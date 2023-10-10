//
//  HomeVC.swift
//  edelivery
//
//  Created by Elluminati on 14/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
import Stripe

class PaymentVC: BaseVC,UITabBarDelegate,UIScrollViewDelegate,RightDelegate,LeftDelegate,didTapOnCancel,didTapOnTrackOrder {

    //MARK:- OutLets
    @IBOutlet weak var lblCurrentBalance: UILabel!
    @IBOutlet weak var lblCurrentWalletAmount: UILabel!
    @IBOutlet weak var btnAddToWallet: UIButton!
    @IBOutlet weak var txtWalletAmount: UITextField!
    @IBOutlet weak var lblWalletTitle: UILabel!
    @IBOutlet weak var lblWalletMessage: UILabel!
    @IBOutlet weak var lblUseWallet: UILabel!

    @IBOutlet weak var viewForAddWallet: UIView!
    @IBOutlet weak var viewForWallet: UIView!
    @IBOutlet weak var paymentTab: UITabBar!
    @IBOutlet weak var btnPayNow: UIButton!
    @IBOutlet weak var switchWalletStatus: UISwitch!
    @IBOutlet weak var lblSelectPaymentMethod: UILabel!

    /*containerView*/
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerForStripe: UIView!
    @IBOutlet weak var containerForCash: UIView!
    @IBOutlet weak var containerForPaystack: UIView!

    @IBOutlet weak var lblPayMessage: UILabel!
    @IBOutlet weak var btnAddCard: UIButton!
    
    @IBOutlet weak var constraintHeightWalletView: NSLayoutConstraint!

    //MARK:- Variables
    var finalTabItems:[UITabBarItem] = []
    var viewControllers:[UIViewController]? = []
    var containerViews:[UIView]? = []
    var paymentConfig:PaymentConfig = PaymentConfig.shared
    var stripePublishableKey:String = ""
    var isFullPaymentWallet = false
    var cashVC:CashVC!
    var stripeVC:StripeVC!
    var paystackVC:PayStackVC!

    //MARK:- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalization()
        delegateRight = self
        finalTabItems = paymentTab.items!
        paymentTab.items?.removeAll()
        paymentConfig.paymentId = Payment.CASH
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        viewForWallet.backgroundColor = UIColor.themeViewBackgroundColor
        viewForAddWallet.isHidden = true
        self.setNavigationTitle(title: "TXT_PAYMENTS".localizedCapitalized)
        wsGetPaymentGateways()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        btnPayNow.isHidden = currentBooking.isHidePayNow
        lblWalletMessage.isHidden = currentBooking.isHidePayNow
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    func setUpLayout() {
        let title = "TXT_SELECT_PAYMENT_METHOD".localized
        let walletTitle = "TXT_WALLET".localized

        lblSelectPaymentMethod.text = title.appending("    ")
        lblWalletTitle.text = walletTitle.appending("    ")

        if (viewControllers?.count ?? 0) > 0 {
            let frame = containerForCash.frame
            scrollView.contentSize = CGSize(width: CGFloat(viewControllers!.count) * frame.size.width, height: frame.size.height)
        }
        btnAddToWallet.applyRoundedCornersWithHeight()
        btnAddCard.applyRoundedCornersWithHeight()
    }

    func adjustPaymentTabbar() {
        paymentTab.barTintColor = UIColor.themeViewBackgroundColor
        paymentTab.backgroundColor = UIColor.themeViewBackgroundColor
        let newItems:NSArray = NSArray.init(array: finalTabItems)

        let frame = containerForCash.frame
        paymentTab.setItems(newItems as? [UITabBarItem], animated: true)

        for i in 0..<containerViews!.count {
            containerViews?[i].frame =  CGRect.init(x: (frame.size.width * CGFloat(i)), y: frame.origin.y, width: frame.size.width, height: frame.size.height)
            scrollView.addSubview(containerViews![i])
        }
        scrollView.contentSize = CGSize(width: CGFloat(viewControllers!.count) * frame.size.width, height: frame.size.height)
        if finalTabItems.count > 0 {
            paymentTab.selectedItem = paymentTab.items?[0]
        }
    }

    func setLocalization() {
        //Colors
        btnAddToWallet.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        btnAddToWallet.backgroundColor = UIColor.themeColor
        
        btnPayNow.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        btnPayNow.backgroundColor = UIColor.themeButtonBackgroundColor
        
        txtWalletAmount.textColor = UIColor.themeTextColor
        lblWalletTitle.textColor = UIColor.themeTitleColor
        lblWalletMessage.textColor = UIColor.themeTextColor
        lblWalletTitle.backgroundColor = UIColor.themeViewBackgroundColor
        lblSelectPaymentMethod.backgroundColor = UIColor.themeViewBackgroundColor
        lblSelectPaymentMethod.textColor = UIColor.themeTitleColor
        lblCurrentBalance.textColor = UIColor.themeLightTextColor
        lblCurrentWalletAmount.textColor = UIColor.themeTextColor
        //localizing text
        title = "TXT_PAYMENTS".localized
        lblCurrentBalance.text = "TXT_CURRENT_BALANCE".localizedCapitalized
        lblWalletMessage.text = "TXT_HOW_WOULD_YOU_LIKE_TO_PAY".localized + " " + CurrentBooking.shared.currency + " " + paymentConfig.total.toString()

        txtWalletAmount.placeholder = "TXT_WALLET_HINT".localized
        lblUseWallet.text = "TXT_USE_WALLET".localizedCapitalized
        btnPayNow.setTitle("TXT_PAY_NOW".localizedCapitalized, for: .normal)

        /* Set Font */
        lblCurrentWalletAmount.isHidden = false
        lblCurrentWalletAmount.textColor = UIColor.themeTextColor

        txtWalletAmount.font = FontHelper.textRegular()
        lblWalletTitle.font = FontHelper.textMedium(size: FontHelper.mediumLarge)
        lblSelectPaymentMethod.font = FontHelper.textMedium(size: FontHelper.mediumLarge)
        lblCurrentBalance.font = FontHelper.textRegular()
        lblCurrentWalletAmount.font = FontHelper.textLarge()
        btnAddToWallet.titleLabel?.font = FontHelper.labelRegular()

        lblPayMessage.font = FontHelper.textRegular()
        lblPayMessage.textColor = UIColor.themeSectionBackgroundColor

        btnAddCard.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        btnAddCard.backgroundColor = UIColor.themeColor
        btnAddCard.titleLabel?.font = FontHelper.labelRegular()
        btnAddCard.setTitle("TXT_ADD_TEXT".localized, for: .normal)
        APPDELEGATE.setupNavigationbar()
        
        super.setBackBarItem(isNative: false)
        if preferenceHelper.getIsQRUser() {
            constraintHeightWalletView.constant = 0
        } else {
            super.setRightBarItem(isNative: false)
            super.setRightBarItemImage(image: UIImage.init(named: "walletHistory")!)
        }

        self.delegateLeft = self
        self.hideBackButtonTitle()
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font:FontHelper.textRegular(), NSAttributedString.Key.foregroundColor: UIColor.themeTextColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font:FontHelper.textLarge(), NSAttributedString.Key.foregroundColor: UIColor.themeColor], for: .selected)
    }

    override func updateUIAccordingToTheme() {
        super.setBackBarItem(isNative: false)
        super.setRightBarItem(isNative: false)
        super.setRightBarItemImage(image: UIImage.init(named: "walletHistory")!)
    }

    //MARK:- USER DEFINE FUNCTION
    func updateWalletView(isUpdate:Bool) {
        if  isUpdate {
            btnAddToWallet.tag = 1
            txtWalletAmount.text = ""
            txtWalletAmount.becomeFirstResponder()
            btnAddToWallet.setTitle("TXT_SUBMIT".localized, for: .normal)
            viewForAddWallet.isHidden = false
            lblCurrentWalletAmount.isHidden = true
        } else {
            btnAddToWallet.tag = 0
            lblCurrentWalletAmount.text = paymentConfig.wallet.toString(decimalPlaced: 2) +  " " + paymentConfig.walletCurrencyCode
            txtWalletAmount.resignFirstResponder()
            btnAddToWallet.setTitle("TXT_ADD_TEXT".localized, for: .normal)
            viewForAddWallet.isHidden = true
            lblCurrentWalletAmount.isHidden = false
        }
        switchWalletStatus.isEnabled = paymentConfig.wallet > 0
    }

    func onClickRightButton() {
        self.performSegue(withIdentifier: SEGUE.WALLET_HISTORY, sender: self)
    }

    func onClickLeftButton() {
        self.navigationController?.popViewController(animated: true)
    }

    func initiateTabbarWith(vc:UIViewController, container:UIView) {
        self.addChild(vc)
        vc.view.frame = CGRect(x: container.frame.origin.x, y: container.frame.origin.y, width: container.frame.size.width, height: container.frame.size.height)
        container.addSubview(vc.view)
        vc.didMove(toParent: self)
    }

    func openWalletDialog() {
        let dialogForWallet = CustomVerificationDialog.showCustomVerificationDialog(title: "TXT_ADD_WALLET_AMOUNT".localized, message: "".localized, titleLeftButton: "".localized, titleRightButton: "TXT_SUBMIT".localized, editTextOneHint: "TXT_WALLET_HINT".localized, editTextTwoHint: "", isEdiTextTwoIsHidden: true)
        dialogForWallet.onClickLeftButton = { [unowned dialogForWallet] in
            dialogForWallet.removeFromSuperview()
        }
        dialogForWallet.onClickRightButton = { [unowned self, unowned dialogForWallet]  (text1:String,text2:String) in
            if (text1.trimmingCharacters(in: .whitespaces).count < 1) {
                Utility.showToast(message: "MSG_ENTER_VALID_AMOUNT".localized)
            } else if ((text1.trimmingCharacters(in: .whitespaces).doubleValue) == nil)  {
                Utility.showToast(message: "MSG_ENTER_VALID_AMOUNT".localized)
            } else if (text1.trimmingCharacters(in: .whitespaces).doubleValue!) <= 0 {
                Utility.showToast(message: "MSG_ENTER_VALID_AMOUNT".localized)
            } else {
                dialogForWallet.removeFromSuperview()
                self.handleWalletDialog(amount: text1)
            }
        }
    }

    func openPaystackPinVerificationDialog(requiredParam:String, reference:String, isWallet:Bool) {
        self.view.endEditing(true)
        switch requiredParam {
            case VerificationParameter.SEND_PIN:
                let dialogForPromo = DialogForCardPinVerification.showCustomVerificationDialog(title: "ENTER_PIN".localized, message: "EG_1234".localized, titleLeftButton: "", titleRightButton: "TXT_APPLY".localized, txtFPlaceholder: "ENTER_PIN".localized, isHideBackButton: false, isShowBirthdayTextfield: false)

                dialogForPromo.onClickLeftButton =
                    { [unowned dialogForPromo] in
                        dialogForPromo.removeFromSuperview();
                    }

                dialogForPromo.onClickRightButton =
                    { [unowned self, unowned dialogForPromo] (text:String) in

                        if (text.count <  1)
                        {
                            Utility.showToast(message: "PLEASE_ENTER_PIN".localized)
                        }
                        else
                        {
                            wsSendPaystackRequiredDetail(requiredParam: requiredParam, reference: reference,pin: text,otp : "", phone: "", dialog: dialogForPromo, isWallet: isWallet)
                        }
                    }
            case VerificationParameter.SEND_OTP:
                let dialogForPromo = DialogForCardPinVerification.showCustomVerificationDialog(title: "ENTER_OTP".localized, message: "EG_123456".localized, titleLeftButton: "", titleRightButton: "TXT_APPLY".localized, txtFPlaceholder: "ENTER_OTP".localized,isHideBackButton: false, isShowBirthdayTextfield: false)

                dialogForPromo.onClickLeftButton =
                    { [unowned dialogForPromo] in
                        dialogForPromo.removeFromSuperview();
                    }

                dialogForPromo.onClickRightButton =
                    { [unowned self, unowned dialogForPromo] (text:String) in
                        if (text.count <  1)
                        {
                            Utility.showToast(message: "PLEASE_ENTER_OTP".localized)
                        }
                        else
                        {
                            wsSendPaystackRequiredDetail(requiredParam: requiredParam, reference: reference,pin: "",otp : text, phone: "", dialog: dialogForPromo, isWallet: isWallet)
                        }
                    }
            case VerificationParameter.SEND_PHONE:
                let dialogForPromo = DialogForCardPinVerification.showCustomVerificationDialog(title: "ENTER_PHONE_NUMBER".localized, message: "MINIMUM_10_DIGITS".localized, titleLeftButton: "", titleRightButton: "TXT_APPLY".localized, txtFPlaceholder: "ENTER_PHONE_NUMBER".localized,isHideBackButton: false, isShowBirthdayTextfield: false)

                dialogForPromo.onClickLeftButton =
                    { [unowned dialogForPromo] in
                        dialogForPromo.removeFromSuperview();
                    }

                dialogForPromo.onClickRightButton =
                    { [unowned self, unowned dialogForPromo] (text:String) in
                        if (text.count <  1)
                        {
                            Utility.showToast(message: "PLEASE_ENTER_PHONE_NO".localized)
                        }
                        else
                        {
                            wsSendPaystackRequiredDetail(requiredParam: requiredParam, reference: reference,pin: "",otp : "",phone:text, dialog: dialogForPromo, isWallet: isWallet)
                        }
                    }

            case VerificationParameter.SEND_BIRTHDAY:
                let dialogForPromo = DialogForCardPinVerification.showCustomVerificationDialog(title: "ENTER_BIRTHDATE".localized, message: "EG_DD-MM-YYYY".localized, titleLeftButton: "", titleRightButton: "TXT_APPLY".localized, txtFPlaceholder: "ENTER_BIRTHDATE".localized,isHideBackButton: false, isShowBirthdayTextfield: true)

                dialogForPromo.onClickLeftButton =
                    { [unowned dialogForPromo] in
                        dialogForPromo.removeFromSuperview();
                    }

                dialogForPromo.onClickRightButton =
                    { [unowned self, unowned dialogForPromo] (text:String) in
                        if (text.count <  1)
                        {
                            Utility.showToast(message: "PLEASE_ENTER_BIRTHDATE".localized)
                        }
                        else
                        {
                            wsSendPaystackRequiredDetail(requiredParam: requiredParam, reference: reference,pin: "",otp : "",phone:text, dialog: dialogForPromo, isWallet: isWallet)
                        }
                    }
            case VerificationParameter.SEND_ADDRESS:
                print(VerificationParameter.SEND_ADDRESS)
            //Didnt tested address flow
            /*  let dialogForPromo = CustomAddressVerificationDialog.showCustomAlertDialog(title: "Enter Address", message: "Eg. Xyz Building, St. road, Maharashtra, India 400001", titleLeftButton: "", titleRightButton: "TXT_APPLY".localized, txtFPlaceholder: "Enter Address",isHideBackButton: false)

             dialogForPromo.onClickLeftButton =
             { [unowned dialogForPromo] in
             dialogForPromo.removeFromSuperview();
             }

             dialogForPromo.onClickRightButton =
             { [unowned self, unowned dialogForPromo] (text:String) in
             if (text.count <  1)
             {
             Utility.showToast(message: "PLEASE_ENTER_BIRTHDATE".localized)
             }
             else
             {
             wsSendPaystackRequiredDetail(requiredParam: requiredParam, reference: reference,pin: "",otp : "",phone:text, dialog: dialogForPromo)
             }
             }*/
            default:
                break
        }
    }

    func wsSendPaystackRequiredDetail(requiredParam:String, reference:String, pin:String, otp:String, phone:String, dialog:DialogForCardPinVerification, isWallet:Bool) {
        Utility.showLoading()
        var dictParam : [String : Any] =
            [PARAMS.USER_ID      : preferenceHelper.getUserId(),
             PARAMS.SERVER_TOKEN  : preferenceHelper.getSessionToken(),
             PARAMS.TYPE : CONSTANT.TYPE_USER,
             PARAMS.PAYMENT_ID : Payment.PAYSTACK,
             PARAMS.REFERENCE : reference,
             PARAMS.REQUIRED_PARAM : requiredParam,
             PARAMS.PIN : pin,
             PARAMS.OTP : otp,
             PARAMS.BIRTHDAY : "",
             PARAMS.ADDRESS : "",
             PARAMS.PHONE : ""]
        if !isWallet {
            dictParam[PARAMS.ORDER_PAYMENT_ID] = currentBooking.orderPaymentId!
        }

        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.SEND_PAYSTACK_REQUIRED_DETAIL, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam)
        { (response, error) -> (Void) in
            Utility.hideLoading()
            print(response)
            if Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: false) {
                if let walletResponse:Wallet = Wallet.init(dictionary: response) {
                    dialog.removeFromSuperview()
                    if isWallet {
                        self.paymentConfig.wallet = walletResponse.wallet ?? 0.0
                        self.paymentConfig.walletCurrencyCode = walletResponse.walletCurrencyCode
                        self.updateWalletView(isUpdate: false)
                    } else {
                        self.wsCreateOrder(paymentID: Payment.PAYSTACK)
                    }
                }
            } else {
                dialog.removeFromSuperview()
                if (response[PARAMS.REQUIRED_PARAM] as? String)?.count ?? "".count > 0{
                    self.openPaystackPinVerificationDialog(requiredParam: response[PARAMS.REQUIRED_PARAM] as? String ?? "", reference: response["reference"] as? String ?? "", isWallet: isWallet)
                } else {
                    if (response["error_code"] as? String)?.count ?? "".count > 0{
                        if (response["error_message"] as? String ?? "").count > 0{
                            Utility.showToast(message: (response["error_message"] as? String ?? "").localized)
                        } else {
                            Utility.showToast(message: "ERROR_CODE_\(response["error_code"] as? String ?? "")".localized)
                        }
                    } else {
                        Utility.showToast(message: (response["error_message"] as? String ?? "").localized)
                    }
                }
            }
        }
    }

    func handleWalletDialog(amount: String)  {
        if ((amount.doubleValue) != nil) {
            let selectedTab = paymentTab.selectedItem
            switch(selectedTab?.tag ?? 0) {
            case 0:
                Utility.showToast(message: "MSG_SELECT_OTHER_PAYMENT_MODE".localized)
                break
            case 1:
                if stripeVC.selectedCard != nil {
                    wsGetStripeIntent(amount: Double(amount)!, payment_id: Payment.STRIPE)
                } else {
                    Utility.showToast(message: "MSG_PLEASE_ADD_CARD_FIRST".localized)
                }
                break
            case 2:
                if paystackVC.selectedCard != nil {
                    wsGetStripeIntent(amount: Double(amount)!, payment_id: Payment.PAYSTACK)
                } else {
                    Utility.showToast(message: "MSG_PLEASE_ADD_CARD_FIRST".localized)
                }
                break
            default:
                Utility.showToast(message: "MSG_SELECT_OTHER_PAYMENT_MODE".localized)
            }
        } else {
            Utility.showToast(message: "MSG_ENTER_VALID_AMOUNT".localized)
        }
    }

    //MARK:- ACTION METHODS
    @IBAction func onClickBtnBack(_ sender: AnyObject) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func onClickBtnAddToWallet(_ sender: Any) {
        openWalletDialog()
       /* if btnAddToWallet.tag == 0 {
            updateWalletView(isUpdate:true)
        }else {
            
            if ((txtWalletAmount.text?.doubleValue) != nil) {
                
                let selectedTab = paymentTab.selectedItem
                switch(selectedTab?.tag ?? 0) {
                case 0:
                    Utility.showToast(message: "MSG_SELECT_OTHER_PAYMENT_MODE".localized)
                    break
                case 1:
                    if stripeVC.selectedCard != nil
                    {
                        wsGetStripeIntent(amount: Double(txtWalletAmount.text!)!)
                    }
                    else
                    {
                        Utility.showToast(message: "MSG_PLEASE_ADD_CARD_FIRST".localized)
                    }
                    break
                case 2:
                    break
                default:
                    Utility.showToast(message: "MSG_SELECT_OTHER_PAYMENT_MODE".localized)
                }
            }else {
                Utility.showToast(message: "MSG_ENTER_VALID_AMOUNT".localized)
            }
        } */
    }

    @IBAction func onClickSwitchWallet(_ sender: Any) {
        self.view.endEditing(true)
        wsChangeWalletStatus(status:switchWalletStatus.isOn)
    }

    @IBAction func onClickBtnPayNow(_ sender: Any) {
        Utility.showLoading()
        self.view.endEditing(true)
        let selectedTab = paymentTab.selectedItem
        
        switch(selectedTab?.tag ?? 0) {
        case 0:
            wsPayOrderPayment()
            break
        case 1:
            if stripeVC.selectedCard != nil {
                wsPayOrderPayment()
            } else {
                Utility.hideLoading()
                Utility.showToast(message: "MSG_PLEASE_ADD_CARD_FIRST".localized)
            }
            break
        case 2:
            if paystackVC.selectedCard != nil {
                wsPayOrderPayment()
            } else {
                Utility.hideLoading()
                Utility.showToast(message: "MSG_PLEASE_ADD_CARD_FIRST".localized)
            }
            break
        default:
            Utility.hideLoading()
            Utility.showToast(message: "MSG_SELECT_OTHER_PAYMENT_MODE".localized)
        }
    }

    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.view.endEditing(true)
        switch item.tag {
        case 0:
            paymentConfig.paymentId = Payment.CASH
            goToPoint(point: containerForCash.frame.origin.x)
            btnAddCard.isHidden = true
            break
        case 1:
            paymentConfig.paymentId = Payment.STRIPE
            goToPoint(point: containerForStripe.frame.origin.x)
            btnAddCard.isHidden = false
            break
        case 2:
            paymentConfig.paymentId = Payment.PAYSTACK
            goToPoint(point: containerForPaystack.frame.origin.x)
            btnAddCard.isHidden = false
            break
        default:
            break
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            let currentPage = scrollView.currentPage
            if currentPage <= ((viewControllers?.count) ?? 0 - 1) && currentPage >= 0 {
                self.tabBar(paymentTab, didSelect: paymentTab.items![currentPage])
                paymentTab.selectedItem = paymentTab.items?[currentPage]
                
            }
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = scrollView.currentPage
        if currentPage <= (((viewControllers?.count) ?? 0) - 1) && currentPage >= 0 {
            self.tabBar(paymentTab, didSelect: paymentTab.items![currentPage])
            paymentTab.selectedItem = paymentTab.items?[currentPage]
        }
    }

    func goToPoint(point:CGFloat) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
                self.scrollView.contentOffset.x = point
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }

    @IBAction func onBtnClickAddCard(_ sender: UIButton) {
        if paymentConfig.paymentId == Payment.STRIPE {
            stripeVC.onClickBtnAddNewCard(btnAddToWallet)
        } else if paymentConfig.paymentId == Payment.PAYSTACK {
            self.performSegue(withIdentifier: SEGUE.PAYMENT_TO_PAYSTACK_WEBVIEW, sender: self)
        }
    }

    func didTapOnCancel() {
        currentBooking.clearBooking()
        APPDELEGATE.goToMain()
    }

    func didTapOnTrackOrder() {
        if currentBooking.isQrCodeScanBooking {
            APPDELEGATE.clearQRUser()
            currentBooking.clearBooking()
            APPDELEGATE.goToMain()
        } else if Utility.isTableBooking() {
            currentBooking.clearBooking()
            APPDELEGATE.goToMain()
        } else {
            currentBooking.clearBooking()
            goToOrderList()
        }
    }

    //MARK: - NAVIGATION METHODS
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier?.compare(SEGUE.SEGUE_STORE_LIST) == ComparisonResult.orderedSame) {
            //let myStoreVC:StoreVC = segue.destination as! StoreVC
        }
    }

    //MARK: - WEB SERVICE
    func wsAddAmountToWallet(paymentID: String) {
        Utility.showLoading()
        let dictParam : [String : Any] =
            [PARAMS.USER_ID      : preferenceHelper.getUserId()  ,
             PARAMS.SERVER_TOKEN  : preferenceHelper.getSessionToken(),
             PARAMS.TYPE : CONSTANT.TYPE_USER,
             PARAMS.PAYMENT_INTENT_ID : paymentID,
             PARAMS.PAYMENT_ID : Payment.STRIPE,
             PARAMS.WALLET : Double(txtWalletAmount.text ?? "") ?? 0.0,
             PARAMS.LAST_FOUR : stripeVC.selectedCard?.lastFour ?? ""
        ]

        let alamoFire:AlamofireHelper = AlamofireHelper()
        alamoFire.getResponseFromURL(url: WebService.WS_ADD_WALLET_AMOUNT, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            if Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true) {
                let walletResponse:Wallet = Wallet.init(dictionary: response)!
                self.paymentConfig.wallet = walletResponse.wallet ?? 0.0
                self.paymentConfig.walletCurrencyCode = walletResponse.walletCurrencyCode
                self.updateWalletView(isUpdate: false)
                Utility.hideLoading()
            }
        }
    }

    func wsChangeWalletStatus(status:Bool) {
        Utility.showLoading()
        let dictParam : [String : Any] =
            [PARAMS.USER_ID      : preferenceHelper.getUserId(),
             PARAMS.SERVER_TOKEN  : preferenceHelper.getSessionToken() ,
             PARAMS.IS_WALLET   :  status,
             PARAMS.TYPE : CONSTANT.TYPE_USER]

        let alamoFire:AlamofireHelper = AlamofireHelper()
        alamoFire.getResponseFromURL(url: WebService.WS_CHANGE_WALLET_STATUS, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            if Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true) {
                Utility.hideLoading()
                let walletStatus:WalletStatusResponse = WalletStatusResponse.init(dictionary: response)!
                self.switchWalletStatus.setOn(walletStatus.isUseWallet, animated: true)
                self.setMessageAsParPayment(isWalletUsed: walletStatus.isUseWallet, walletAmount: self.paymentConfig.wallet, totalOrderInvoiceAmount: PaymentConfig.shared.total)
            }
        }
    }

    func wsPayOrderPayment() {
        let isPaymentCash = (Payment.CASH.compare(paymentConfig.paymentId) == ComparisonResult.orderedSame) ? true :false
        var dictParam : [String : Any] = [:]
        dictParam[PARAMS.USER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.SERVER_TOKEN] = preferenceHelper.getSessionToken()
        dictParam[PARAMS.ORDER_PAYMENT_ID] = currentBooking.orderPaymentId!
        dictParam[PARAMS.PAYMENT_ID] = paymentConfig.paymentId
        dictParam[PARAMS.ORDER_TYPE] = CONSTANT.TYPE_USER
        dictParam[PARAMS.IS_PAYMENT_MODE_CASH] = isPaymentCash
        dictParam[PARAMS.ORDER_ID] = currentBooking.selectedOrderId

        if currentBooking.isCourier {
            dictParam[PARAMS.STORE_DELIVERY_ID] = currentBooking.courierDeliveryId
        }
        print(dictParam)

        let alamoFire:AlamofireHelper = AlamofireHelper()
        alamoFire.getResponseFromURL(url: WebService.WS_PAY_ORDER_PAYMENT, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            if Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: self.paymentConfig.paymentId != Payment.PAYSTACK) {
                let isPaymentPaid:Bool = (response.value(forKey: "is_payment_paid") as? Bool) ?? false
                if isPaymentPaid {
                    self.wsCreateOrder()
                } else {
                    if isPaymentCash {
                        Utility.showToast(message: "MSG_PAYMENT_FAILED".localized)
                    } else {
                        if PaymentConfig.shared.paymentId == Payment.STRIPE{//stripe
                            if let paymentMethod =  response["payment_method"] as? String, let clientSecret: String = response["client_secret"] as? String {
                                self.openStripePaymentMethod(paymentMethod: paymentMethod, clientSecret: clientSecret, isWallet: false)
                            } else {
                                Utility.showToast(message: "MSG_PAYMENT_FAILED".localized)
                            }
                        }
                    }
                }
            } else {
                if PaymentConfig.shared.paymentId == Payment.PAYSTACK {//paystack
                    if (response[PARAMS.REQUIRED_PARAM] as? String)?.count ?? "".count > 0{
                        self.openPaystackPinVerificationDialog(requiredParam: response[PARAMS.REQUIRED_PARAM] as? String ?? "", reference: response["reference"] as? String ?? "", isWallet:false)
                    } else {
                        Utility.showToast(message: response["error_message"] as? String ?? "")
                    }
                }
            }
        }
    }

    func wsCreateOrder(paymentID:String = "") {
        let isPaymentCash = (Payment.CASH.compare(paymentConfig.paymentId) == ComparisonResult.orderedSame) ? true :false
        if currentBooking.isCourier {
            var dictParam:[String:Any] = [ PARAMS.VEHICLE_ID : currentBooking.selectedVehicleId,
                                           PARAMS.CART_ID:currentBooking.cartId, PARAMS.USER_ID:preferenceHelper.getUserId(), PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken(),
                                           PARAMS.STORE_DELIVERY_ID : currentBooking.courierDeliveryId,
                                           PARAMS.IS_BRING_CHANGE : cashVC.switchBringChange.isOn,
                                           PARAMS.ORDER_TYPE : CONSTANT.TYPE_USER.description,
                                           PARAMS.DELIVERY_TYPE : DeliveryType.courier.description]
            dictParam[PARAMS.PAYMENT_INTENT_ID] = paymentID
            dictParam[PARAMS.ORDER_PAYMENT_ID] = currentBooking.orderPaymentId!
            let status = isPaymentCash ? false : currentBooking.isContactLessDelivery
            dictParam[PARAMS.IS_ALLOW_CONTACTLESS_DELIVERY] = String(isFullPaymentWallet ? currentBooking.isContactLessDelivery : status)

            print("Parameter WS_CREATE_ORDER: \(dictParam)")
            let alamoFire:AlamofireHelper = AlamofireHelper()
            alamoFire.getResponseFromURL(url: WebService.WS_CREATE_ORDER, paramData: dictParam, images: currentBooking.courierImage) { (response, error) -> (Void) in
                Utility.hideLoading()
                if Parser.isSuccess(response: response, withSuccessToast: true, andErrorToast: true) {
                    preferenceHelper.setRandomCartID(String.random(length: 20))
                    self.goToOrderPlaced()
                }
            }
        } else {
            var dictParam:[String:Any] = [PARAMS.CART_ID:currentBooking.cartId, PARAMS.USER_ID:preferenceHelper.getUserId(), PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken(),
                                          PARAMS.IS_SCHEDULE_ORDER: currentBooking.isFutureOrder,
                                          PARAMS.ORDER_START_AT :currentBooking.futureUTCMilliSecond,
                                          PARAMS.IS_USER_PICK_UP_ORDER : currentBooking.isUserPickUpOrder,
                                          PARAMS.DELIVERY_USER_NAME : currentBooking.deliveryName,
                                          PARAMS.DELIVERY_USER_PHONE : currentBooking.deliveryContact,
                                          PARAMS.ORDER_TYPE : CONSTANT.TYPE_USER,
                                          PARAMS.IS_BRING_CHANGE : cashVC.switchBringChange.isOn,
                                          PARAMS.DELIVERY_TYPE:currentBooking.deliveryType]
            
            let status = isPaymentCash ? false : currentBooking.isContactLessDelivery
            
            dictParam[PARAMS.IS_ALLOW_CONTACTLESS_DELIVERY] = isFullPaymentWallet ? currentBooking.isContactLessDelivery : status
            dictParam[PARAMS.PAYMENT_INTENT_ID] = paymentID
            dictParam[PARAMS.ORDER_PAYMENT_ID] = currentBooking.orderPaymentId!
            let addressDict:[[String:Any]] = [currentBooking.destinationAddress[0].toDictionary()]
            dictParam[Google.DESTINATION_ADDRESSES] = addressDict
            
            if currentBooking.futureUTCMilliSecond2 > 0{
                dictParam[PARAMS.ORDER_START_AT2] = currentBooking.futureUTCMilliSecond2
            }
            
            print("Parameter WS_CREATE_ORDER: \(dictParam)")
            print(Utility.convertDictToJson(dict: dictParam as! Dictionary<String, Any>))

            let alamoFire:AlamofireHelper = AlamofireHelper()
            alamoFire.getResponseFromURL(url: WebService.WS_CREATE_ORDER, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
                Utility.hideLoading()
                if Parser.isSuccess(response: response, withSuccessToast: true, andErrorToast: true) {
                    preferenceHelper.setRandomCartID(String.random(length: 20))
                    self.goToOrderPlaced()
                }
            }
        }
    }

    func openStripePaymentMethod(paymentMethod:String, clientSecret: String, isWallet:Bool=false) {
        StripeAPI.defaultPublishableKey = stripePublishableKey
        let paymentIntentParams = STPPaymentIntentParams(clientSecret: clientSecret)
        paymentIntentParams.paymentMethodId = paymentMethod
        
        //Submit the payment
        let paymentHandler = STPPaymentHandler.shared()
        Utility.showLoading()
        paymentHandler.confirmPayment(paymentIntentParams, with: self) { [weak self] (status, paymentIntent, error) in
            Utility.showLoading()
            guard let self = self else { return }
            switch (status) {
            case .failed:
                if isWallet  {
                    self.updateWalletView(isUpdate: false)
                }
                Common.alert("", error!.localizedDescription)
                Utility.hideLoading()
                break
            case .canceled:
                if isWallet {
                    self.updateWalletView(isUpdate: false)
                }
                Utility.hideLoading()
                break
            case .succeeded:
                let id = paymentIntent?.stripeId ?? ""
                if isWallet {
                    self.wsAddAmountToWallet(paymentID: id)
                } else {
                    self.wsCreateOrder(paymentID: id)
                }
                break
            @unknown default:
                fatalError()
                break
            }
        }
    }
    
    func wsGetPaymentGateways(){
        Utility.showLoading()
        
        var dictParam: [String:Any] = currentBooking.currentPlaceData.toDictionary()
        dictParam[PARAMS.TYPE] = CONSTANT.TYPE_USER
        
        if btnPayNow.isHidden {
            dictParam[PARAMS.CITY_ID] = ""
        }else {
            dictParam[PARAMS.CITY_ID] = currentBooking.cartCityId
        }
        
        let alamoFire:AlamofireHelper = AlamofireHelper()
        alamoFire.getResponseFromURL(url: WebService.WS_GET_PAYMENT_GATEWAYS, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Utility.hideLoading()
            Parser.parsePaymentGateways(response, isShowCash: !self.btnPayNow.isHidden, completion: { (result) in
                self.updatePaymentGateWays()
            })
        }
    }

    func wsGetStripeIntent(amount:Double, payment_id: String) {
        Utility.showLoading()
        let dictParam : [String : Any] = [PARAMS.USER_ID : preferenceHelper.getUserId(),
                                          //                                          PARAMS.PAYMENT_ID : Payment.STRIPE,
                                          PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken(),
                                          PARAMS.AMOUNT: amount,
                                          PARAMS.TYPE : CONSTANT.TYPE_USER,
                                          PARAMS.PAYMENT_ID : payment_id]
        
        let alamoFire:AlamofireHelper = AlamofireHelper()
        alamoFire.getResponseFromURL(url: WebService.GET_STRIPE_PAYMENT_INTENT_WALLET, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in

            if PaymentConfig.shared.paymentId == Payment.STRIPE{//stripe
                if Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true) {
                    if let paymentMethod =  response["payment_method"] as? String, let clientSecret: String = response["client_secret"] as? String {
                        self.openStripePaymentMethod(paymentMethod: paymentMethod, clientSecret: clientSecret,isWallet: true)
                    } else {
                        Utility.hideLoading()
                    }
                } else {
                    Utility.hideLoading()
                    Utility.showToast(message: response["error"] as? String ?? "")
                }
            } else if PaymentConfig.shared.paymentId == Payment.PAYSTACK {
                if Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: false) {
                    if let walletResponse:Wallet = Wallet.init(dictionary: response) {
                        self.paymentConfig.wallet = walletResponse.wallet ?? 0.0
                        self.paymentConfig.walletCurrencyCode = walletResponse.walletCurrencyCode
                        self.updateWalletView(isUpdate: false)
                        Utility.hideLoading()
                    }
                } else {
                    Utility.hideLoading()
                    if (response[PARAMS.REQUIRED_PARAM] as? String)?.count ?? "".count > 0 {
                        self.openPaystackPinVerificationDialog(requiredParam: response[PARAMS.REQUIRED_PARAM] as? String ?? "", reference: response["reference"] as? String ?? "", isWallet: true)
                    } else {
                        Utility.showToast(message: response["error_message"] as? String ?? "")
                    }
                }
            }
        }
    }

    func updatePaymentGateWays() {
        finalTabItems.removeAll()
        viewControllers?.removeAll()
        containerViews?.removeAll()

        if !self.paymentConfig.paymentGateways.isEmpty {
            for paymentGateway in self.paymentConfig.paymentGateways {
                if paymentGateway.id.compare(Payment.CASH) == ComparisonResult.orderedSame {
                    cashVC = (storyboard?.instantiateViewController(withIdentifier: "cashVC"))! as? CashVC
                    viewControllers?.append(cashVC)
                    containerViews?.append(containerForCash)
                    initiateTabbarWith(vc: cashVC, container: containerForCash)
                    paymentConfig.paymentId = Payment.CASH
                    self.finalTabItems.append(UITabBarItem.init(title: paymentGateway.name?.capitalized ?? "CASH", image: nil, tag: 0))
                    cashVC.switchBringChange.addTarget(self, action: #selector(self.switchBringChange(_:)), for: .valueChanged)
                }
                if paymentGateway.id.compare(Payment.STRIPE) == ComparisonResult.orderedSame {
                    stripeVC = (storyboard?.instantiateViewController(withIdentifier: "stripeVC"))! as? StripeVC
                    stripePublishableKey = paymentGateway.paymentKeyId
                    self.viewControllers?.append(stripeVC)
                    self.containerViews?.append(containerForStripe)
                    self.initiateTabbarWith(vc: stripeVC, container: containerForStripe)
                    self.finalTabItems.append(UITabBarItem.init(title: paymentGateway.name?.capitalized ?? "STRIPE", image: nil, tag: 1))
                    paymentConfig.paymentId = Payment.STRIPE
                }
                if paymentGateway.id.compare(Payment.PAYSTACK) == ComparisonResult.orderedSame {
                    paystackVC = (storyboard?.instantiateViewController(withIdentifier: "payStackVC"))! as? PayStackVC
                    self.viewControllers?.append(paystackVC)
                    self.containerViews?.append(containerForPaystack)
                    self.initiateTabbarWith(vc: paystackVC, container: containerForPaystack)
                    self.finalTabItems.append(UITabBarItem.init(title: paymentGateway.name?.capitalized ?? "PAYSTACK", image: nil, tag: 2))
                    paymentConfig.paymentId = Payment.PAYSTACK
                }
            }
            if finalTabItems.count > 0 {
                tabBar(paymentTab, didSelect: finalTabItems[0])
            }
        } else {
            paymentTab.isHidden = true
            btnPayNow.isHidden = true
            scrollView.isHidden = true
            btnAddCard.isHidden = true
        }
        switchWalletStatus.isOn = paymentConfig.isUseWallet
        updateWalletView(isUpdate:false)
        adjustPaymentTabbar()
        self.setMessageAsParPayment(isWalletUsed: paymentConfig.isUseWallet, walletAmount: paymentConfig.wallet, totalOrderInvoiceAmount: paymentConfig.total)
    }

    func goToOrderPlaced() {
        let storyboard = UIStoryboard(name: "Cart", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "OrderPlacedVC") as! OrderPlacedVC
        vc.delegateOnCancel = self
        vc.delegateOnTrackOrder = self
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false, completion: nil)
    }

    func goToOrderList() {
        let storyboard = UIStoryboard(name: "Order", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "OrderVC") as! OrderVC
        vc.isComeFromCompleteOrder = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func switchBringChange(_ sender: UISwitch) {
        print(sender.isOn)
    }
}

extension PaymentVC:UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtWalletAmount {
            let textFieldString = textField.text! as NSString
            let newString = textFieldString.replacingCharacters(in: range, with:string)
            let floatRegEx = "^([0-9]+)?(\\.([0-9]+)?)?$"
            let floatExPredicate = NSPredicate(format:"SELF MATCHES %@", floatRegEx)
            return floatExPredicate.evaluate(with: newString)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func setMessageAsParPayment(isWalletUsed:Bool, walletAmount:Double = PaymentConfig.shared.wallet, totalOrderInvoiceAmount:Double = PaymentConfig.shared.total) {
        var payMessage = "", payAmount = ""
        let youPaid = totalOrderInvoiceAmount - walletAmount
        var remainPay = 0.0
        
        if (isWalletUsed && paymentConfig.wallet > 0) {
            payMessage = String(format: NSLocalizedString("TXT_PAY_AMOUNT_FROM_WALLET", comment: ""),CurrentBooking.shared.currency,((youPaid > 0 ? totalOrderInvoiceAmount - youPaid : totalOrderInvoiceAmount)).toString())
            remainPay = youPaid > 0 ? youPaid : 0
            payAmount = String(format: NSLocalizedString("TXT_PAY", comment: ""),CurrentBooking.shared.currency,remainPay.toString())
        }else {
            remainPay = totalOrderInvoiceAmount
            payAmount = String(format: NSLocalizedString("TXT_PAY", comment: ""),CurrentBooking.shared.currency,remainPay.toString())
        }
        isFullPaymentWallet = (remainPay == 0 && isWalletUsed)
        if (!payMessage.isEmpty() && !currentBooking.isHidePayNow) {
            lblPayMessage.text = payMessage
            lblPayMessage.isHidden = false
        }else {
            lblPayMessage.isHidden = true
        }
        btnPayNow.setTitle(payAmount, for: .normal)
        if cashVC != nil {
            if currentBooking.isQrCodeScanBooking {
                cashVC.lblCashMessage.text = String(format: NSLocalizedString("TXT_PAY_WITH_CASH", comment: ""),CurrentBooking.shared.currency,remainPay.toString())
            } else {
                cashVC.lblCashMessage.text = String(format: NSLocalizedString("TXT_PAY_CASH_AMOUNT", comment: ""),CurrentBooking.shared.currency,remainPay.toString())
            }
        }
    }
}

extension PaymentVC: STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        Utility.hideLoading()
        return self
    }
}
