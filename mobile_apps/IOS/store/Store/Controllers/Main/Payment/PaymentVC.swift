//
//  HomeVC.swift
//  edelivery
//
//  Created by Elluminati on 14/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
import Stripe
import AVFoundation

class PaymentVC: BaseVC,UITabBarDelegate,UIScrollViewDelegate,RightDelegate {

    //MARK:- OutLets

    //MARK: WALLET VIEW

    @IBOutlet weak var lblCurrentBalance: UILabel!
    @IBOutlet weak var lblCurrentWalletAmount: UILabel!
    @IBOutlet weak var btnAddToWallet: UIButton!
    @IBOutlet weak var txtWalletAmount: UITextField!
    @IBOutlet weak var lblWalletTitle: UILabel!

    @IBOutlet weak var viewForAddWallet: UIView!
    @IBOutlet weak var viewForWallet: UIView!

    /*View For Payment Gateway*/
    @IBOutlet weak var paymentTab: UITabBar!
    @IBOutlet weak var lblSelectPaymentMethod: UILabel!
    @IBOutlet weak var lblWithdrawalTitle: UILabel!

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerForStripe: UIView!
    @IBOutlet weak var containerForCash: UIView!
    @IBOutlet weak var containerForPaystack: UIView!

    //Select withdrawel method
    @IBOutlet weak var viewForSelectWithdrawalMethod: UIView!
    @IBOutlet weak var lblSelectWithdrawMethod: UILabel!
    @IBOutlet weak var imgWithdraw: UIImageView!

    //MARK:- Variables
    var finalTabItems:[UITabBarItem] = [];
    var viewControllers:[UIViewController]? = []
    var containerViews:[UIView]? = []
    var paymentConfig:PaymentConfig = PaymentConfig.shared
    var cashVC:CashVC!
    var stripeVC:StripeVC!
    var stripePublishableKey:String = ""
    var paystackVC:PayStackVC!

    //MARK:- LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.selectWithdrawMethod(gestureRecognizer:)))
        //gestureRecognizer.delegate = self
        viewForSelectWithdrawalMethod.addGestureRecognizer(gestureRecognizer)

        setLocalization()
        delegateRight = self
        finalTabItems = paymentTab.items!;
        paymentTab.items?.removeAll()

        scrollView.isPagingEnabled = true
        scrollView.alwaysBounceHorizontal = false
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        viewForWallet.backgroundColor = UIColor.themeViewBackgroundColor
        viewForAddWallet.isHidden = true

        self.setNavigationTitle(title: "TXT_PAYMENT".localizedCapitalized)

        wsGetPaymentGateways()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        //wsGetPaymentGateways()
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

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setLocalization()
    }

    func setUpLayout() {
        if (viewControllers?.count ?? 0) > 0 {
            let frame = containerForCash.frame
            scrollView.contentSize = CGSize(width: CGFloat(viewControllers!.count) * frame.size.width, height: frame.size.height)
        }
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
        APPDELEGATE.setupTabbar(tabBar: paymentTab)
    }

    func setLocalization() {
        //Colors
        btnAddToWallet.setTitleColor(UIColor.themeColor, for: UIControl.State.normal);
        btnAddToWallet.backgroundColor = UIColor.clear
        
        
//        txtWalletAmount.textColor = UIColor.themeTextColor
//        lblWalletTitle.textColor = UIColor.themeButtonTitleColor;
//        lblWalletTitle.backgroundColor = UIColor.themeColor
        lblSelectPaymentMethod.backgroundColor = UIColor.themeColor
        lblSelectPaymentMethod.textColor = UIColor.themeButtonTitleColor
        lblSelectWithdrawMethod.textColor = UIColor.themeColor
        
        //localizing text
        lblSelectPaymentMethod.text = "TXT_SELECT_PAYMENT_METHOD".localizedUppercase
        lblWalletTitle.text = "TXT_WALLET".localizedUppercase
        lblWithdrawalTitle.text = "TXT_WITHDRAWAL".localizedUppercase
        title = "TXT_WITHDRAWAL".localized
        lblCurrentBalance.text = "TXT_CURRENT_BALANCE".localizedCapitalized
        lblSelectWithdrawMethod.text = "TXT_SELECT_WITHDRAWAL_METHOD".localized
        txtWalletAmount.placeholder = "TXT_WALLET_HINT".localized
        txtWalletAmount.keyboardType = .numberPad
        /* Set Font */
        
        lblSelectWithdrawMethod.font = FontHelper.labelRegular()
        txtWalletAmount.font = FontHelper.textRegular()
//        lblWalletTitle.font = FontHelper.labelRegular()
        lblWithdrawalTitle.font = FontHelper.labelRegular()
        
        lblSelectPaymentMethod.font = FontHelper.labelRegular()
        lblCurrentBalance.font = FontHelper.textRegular()
        lblCurrentWalletAmount.font = FontHelper.textLarge()
        btnAddToWallet.titleLabel?.font = FontHelper.labelRegular()
        
        super.setRightBarItem(isNative: false)
        super.setRightBarItemImage(image: UIImage.init(named: "walletHistoryIcon")!.imageWithColor(color: .themeColor)!)
        lblCurrentWalletAmount.textColor = UIColor.themeTextColor
        lblCurrentWalletAmount.isHidden = false
        self.hideBackButtonTitle()
        imgWithdraw.image = UIImage(named: "withdrawal")?.imageWithColor(color: .themeColor)
    }

    //MARK:- USER DEFINE FUNCTION
    func updateWalletView(isUpdate:Bool) {
        if isUpdate {
            btnAddToWallet.tag = 1
            txtWalletAmount.text = ""
            txtWalletAmount.becomeFirstResponder()
            btnAddToWallet.setTitle("TXT_SUBMIT".localized, for: .normal)
            viewForAddWallet.isHidden = false
            lblCurrentWalletAmount.isHidden = true
        } else {
            btnAddToWallet.tag = 0
            lblCurrentWalletAmount.text = (paymentConfig.wallet ?? 0.0).toString() +  " " + (paymentConfig.walletCurrencyCode ?? "")
            StoreSingleton.shared.store.wallet = paymentConfig.wallet
            txtWalletAmount.resignFirstResponder()
            btnAddToWallet.setTitle("TXT_ADD".localized, for: .normal)
            viewForAddWallet.isHidden = true
            lblCurrentWalletAmount.isHidden = false
        }
    }

    func onClickRightButton() {
        self.performSegue(withIdentifier: SEGUE.WALLET_TO_HISTORY, sender: self)
    }

    func initiateTabbarWith(vc:UIViewController, container:UIView) {
        self.addChild(vc)
        vc.view.frame =
            CGRect(x: container.frame.origin.x, y: container.frame.origin.y,
                   width: container.frame.size.width, height: container.frame.size.height)
        container.addSubview(vc.view)
        vc.didMove(toParent: self)
    }

    //MARK:- ACTION METHODS
    @IBAction func onClickBtnBack(_ sender: AnyObject) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true);
    }

    @IBAction func onClickBtnAddToWallet(_ sender: Any) {
        if btnAddToWallet.tag == 0 {
            updateWalletView(isUpdate:true)
        } else {
            if ((txtWalletAmount.text?.doubleValue) != nil) {
                let selectedTab = paymentTab.selectedItem
                switch(selectedTab?.tag ?? 0) {
                    case 0:
                        Utility.showToast(message: "MSG_SELECT_OTHER_PAYMENT_MODE".localized)
                        break;
                    case 1:
                        if stripeVC.selectedCard != nil {
                            wsGetStripeIntent(amount: Double(txtWalletAmount.text!)!, payment_id: Payment.STRIPE)
                        } else {
                            Utility.showToast(message: "MSG_PLEASE_ADD_CARD_FIRST".localized)
                        }
                        break;
                    case 2:
                        if paystackVC.selectedCard != nil {
                            wsGetStripeIntent(amount: Double(txtWalletAmount.text!)!, payment_id: Payment.PAYSTACK)
                        } else {
                            Utility.showToast(message: "MSG_PLEASE_ADD_CARD_FIRST".localized)
                        }
                        break;
                    default:
                        Utility.showToast(message: "MSG_SELECT_OTHER_PAYMENT_MODE".localized)
                        break;
                }
            } else {
                Utility.showToast(message: "MSG_ENTER_VALID_AMOUNT".localized)
            }
        }
    }

    @objc func selectWithdrawMethod(gestureRecognizer: UIGestureRecognizer) {
        self.performSegue(withIdentifier: SEGUE.SELECT_WITHDRAW_METHOD, sender: self)
    }

    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.view.endEditing(true)
        switch item.tag {
        case 0:
            paymentConfig.paymentId = Payment.CASH
            goToPoint(point: containerForCash.frame.origin.x)
            break
        case 1:
            paymentConfig.paymentId = Payment.STRIPE
            goToPoint(point: containerForStripe.frame.origin.x)
            break
        case 2:
            paymentConfig.paymentId = Payment.PAYSTACK
            goToPoint(point: containerForPaystack.frame.origin.x)
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
            self.tabBar(paymentTab, didSelect: (paymentTab.items?[currentPage])!)
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

    //MARK:- NAVIGATION METHODS
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {}

    //MARK:- WEB SERVICE
    func wsAddAmountToWallet(paymentID: String) {
        Utility.showLoading()
        let dictParam : [String : Any] =
            [PARAMS.USER_ID      : preferenceHelper.getUserId()  ,
             PARAMS.SERVER_TOKEN  : preferenceHelper.getSessionToken(),
             PARAMS.TYPE : CONSTANT.TYPE_STORE,
             PARAMS.PAYMENT_INTENT_ID : paymentID,
             PARAMS.PAYMENT_ID : Payment.STRIPE,
             PARAMS.WALLET : Double(txtWalletAmount.text ?? "") ?? 0.0,
             PARAMS.LAST_FOUR : stripeVC.selectedCard?.lastFour ?? ""
            ]

        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_ADD_WALLET_AMOUNT, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            if Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true) {
                let walletResponse:Wallet = Wallet.init(fromDictionary: response)
                self.paymentConfig.wallet = walletResponse.wallet ?? 0.0;
                StoreSingleton.shared.store.wallet = walletResponse.wallet ?? 0.0;
                self.paymentConfig.walletCurrencyCode = walletResponse.walletCurrencyCode
                self.updateWalletView(isUpdate: false)
                Utility.hideLoading()
            }
        }
    }

    func wsGetPaymentGateways() {
        Utility.showLoading()
        var dictParam: [String:Any] = [:]
        dictParam[PARAMS.CITY_ID]  = StoreSingleton.shared.store.cityId
        dictParam[PARAMS.USER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.SERVER_TOKEN] = preferenceHelper.getSessionToken()
        dictParam[PARAMS.TYPE] = CONSTANT.TYPE_STORE
        print(dictParam)

        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_GET_PAYMENT_GATEWAYS, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Utility.hideLoading()
            print(response)
            Parser.parsePaymentGateways(response, completion: { (result) in
                self.updatePaymentGateWays()
            })
        }
    }

    func updatePaymentGateWays() {
        finalTabItems.removeAll()
        viewControllers?.removeAll()
        containerViews?.removeAll()
        if !self.paymentConfig.paymentGateways.isEmpty {
            for paymentGateway in self.paymentConfig.paymentGateways {
                if paymentGateway.id.compare(Payment.CASH) == ComparisonResult.orderedSame {
                    if cashVC == nil {
                        cashVC = (storyboard?.instantiateViewController(withIdentifier: "cashVC"))! as? CashVC
                    }
                    viewControllers?.append(cashVC);
                    containerViews?.append(containerForCash)
                    initiateTabbarWith(vc: cashVC, container: containerForCash)
                    paymentConfig.paymentId = Payment.CASH
                    self.finalTabItems.append(UITabBarItem.init(title: paymentGateway.name?.capitalized ?? "TXT_CASH".localizedCapitalized, image: nil, tag: 0))
                }
                if paymentGateway.id.compare(Payment.STRIPE) == ComparisonResult.orderedSame {
                    if stripeVC == nil {
                        stripeVC = (storyboard?.instantiateViewController(withIdentifier: "stripeVC"))! as? StripeVC
                    }
                    stripePublishableKey = paymentGateway.paymentKeyId
                    self.viewControllers?.append(stripeVC);
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
            tabBar(paymentTab, didSelect: finalTabItems[0])
        } else {
            paymentTab.isHidden = true
            scrollView.isHidden = true
        }
        updateWalletView(isUpdate:false)
        adjustPaymentTabbar()
    }
}

extension PaymentVC:UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtWalletAmount {
            let textFieldString = textField.text! as NSString;
            let newString = textFieldString.replacingCharacters(in: range, with:string)
            let floatRegEx = "^([0-9]+)?(\\.([0-9]+)?)?$"
            let floatExPredicate = NSPredicate(format:"SELF MATCHES %@", floatRegEx)
            return floatExPredicate.evaluate(with: newString)
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}

extension PaymentVC: STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        Utility.hideLoading()
        return self
    }

    func openStripePaymentMethod(paymentMethod:String, clientSecret: String) {
        StripeAPI.defaultPublishableKey = stripePublishableKey
        let paymentIntentParams = STPPaymentIntentParams(clientSecret: clientSecret)
        paymentIntentParams.paymentMethodId = paymentMethod

        //Submit the payment
        let paymentHandler = STPPaymentHandler.shared()
        Utility.showLoading()
        paymentHandler.confirmPayment(paymentIntentParams, with:self) { [weak self] status, paymentIntent, error in
            Utility.showLoading()
            guard let self = self else { return }
            switch (status) {
            case .failed:
                self.updateWalletView(isUpdate: false)
                Common.alert("", error!.localizedDescription)
                Utility.hideLoading()
                break
            case .canceled:
                self.updateWalletView(isUpdate: false)
                Utility.hideLoading()
                break
            case .succeeded:
                let id = paymentIntent?.stripeId ?? ""
                self.wsAddAmountToWallet(paymentID: id)
                break
            @unknown default:
                fatalError()
                break
            }
        }
    }

    func wsGetStripeIntent(amount:Double, payment_id: String) {
        Utility.showLoading()
        let dictParam : [String : Any] = [PARAMS.USER_ID : preferenceHelper.getUserId(),
                                          PARAMS.PAYMENT_ID : payment_id,
                                          PARAMS.AMOUNT: amount,
                                          PARAMS.TYPE : CONSTANT.TYPE_STORE,
                                          PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken()]

        let alamoFire:AlamofireHelper = AlamofireHelper()
        alamoFire.getResponseFromURL(url: WebService.GET_STRIPE_PAYMENT_INTENT_WALLET, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            /*if Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true) {
                if let paymentMethod =  response["payment_method"] as? String, let clientSecret: String = response["client_secret"] as? String {
                    self.openStripePaymentMethod(paymentMethod: paymentMethod, clientSecret: clientSecret)
                }
            }*/

            if PaymentConfig.shared.paymentId == Payment.STRIPE { //stripe
                if Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true) {
                    if let paymentMethod =  response["payment_method"] as? String, let clientSecret: String = response["client_secret"] as? String {
                        self.openStripePaymentMethod(paymentMethod: paymentMethod, clientSecret: clientSecret)
                    } else {
                        Utility.hideLoading()
                    }
                } else {
                    Utility.hideLoading()
                    Utility.showToast(message: response["error"] as? String ?? "")
                }
            } else if PaymentConfig.shared.paymentId == Payment.PAYSTACK {
                if Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: false) {
                     let walletResponse:Wallet = Wallet.init(fromDictionary: response)
                    self.paymentConfig.wallet = walletResponse.wallet ?? 0.0
                    self.paymentConfig.walletCurrencyCode = walletResponse.walletCurrencyCode
                    self.updateWalletView(isUpdate: false)
                    Utility.hideLoading()
                } else {
                    Utility.hideLoading()
                    if (response[PARAMS.REQUIRED_PARAM] as? String)?.count ?? "".count > 0{
                        self.openPaystackPinVerificationDialog(requiredParam: response[PARAMS.REQUIRED_PARAM] as? String ?? "", reference: response["reference"] as? String ?? "")
                    } else {
                        Utility.showToast(message: response["error_message"] as? String ?? "")
                    }
                }
            }
        }
    }

    func openPaystackPinVerificationDialog(requiredParam:String,reference:String) {
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
                    wsSendPaystackRequiredDetail(requiredParam: requiredParam, reference: reference,pin: text,otp : "", phone: "", dialog: dialogForPromo)
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
                    wsSendPaystackRequiredDetail(requiredParam: requiredParam, reference: reference,pin: "",otp : text, phone: "", dialog: dialogForPromo)
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
                    wsSendPaystackRequiredDetail(requiredParam: requiredParam, reference: reference,pin: "",otp : "",phone:text, dialog: dialogForPromo)
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
                    wsSendPaystackRequiredDetail(requiredParam: requiredParam, reference: reference,pin: "",otp : "",phone:text, dialog: dialogForPromo)
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

    func wsSendPaystackRequiredDetail(requiredParam:String,reference:String,pin:String,otp:String,phone:String,dialog:DialogForCardPinVerification) {
        Utility.showLoading()
        let dictParam : [String : Any] =
        [PARAMS.USER_ID      : preferenceHelper.getUserId(),
         PARAMS.SERVER_TOKEN  : preferenceHelper.getSessionToken(),
         PARAMS.TYPE : CONSTANT.TYPE_STORE,
         PARAMS.PAYMENT_ID : Payment.PAYSTACK,
         PARAMS.REFERENCE : reference,
         PARAMS.REQUIRED_PARAM : requiredParam,
         PARAMS.PIN : pin,
         PARAMS.OTP : otp,
         PARAMS.BIRTHDAY : "",
         PARAMS.ADDRESS : "",
         PARAMS.PHONE : ""]

        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.SEND_PAYSTACK_REQUIRED_DETAIL, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam)
        { (response, error) -> (Void) in
            Utility.hideLoading()
            print(response)
            if Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: false) {
                let walletResponse:Wallet = Wallet.init(fromDictionary: response)
                dialog.removeFromSuperview()
                self.paymentConfig.wallet = walletResponse.wallet ?? 0.0
                self.paymentConfig.walletCurrencyCode = walletResponse.walletCurrencyCode
                self.updateWalletView(isUpdate: false)
            } else {
                dialog.removeFromSuperview()
                if (response[PARAMS.REQUIRED_PARAM] as? String)?.count ?? "".count > 0{
                    self.openPaystackPinVerificationDialog(requiredParam: response[PARAMS.REQUIRED_PARAM] as? String ?? "", reference: response["reference"] as? String ?? "")
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
}
