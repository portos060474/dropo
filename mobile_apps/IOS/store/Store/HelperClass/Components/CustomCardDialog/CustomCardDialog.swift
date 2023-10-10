//
//  CustomPhotoDialog.swift
//  edelivery
//
//  Created by Elluminati on 22/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//



import Foundation
import UIKit
import Stripe


enum CardBrand: String
     {
    case CardBrandVisa = "Visa"
    case CardBrandAmex = "amex"
    case CardBrandMasterCard = "MasterCard"
    case CardBrandDiscover = "discover"
    case CardBrandJCB = "JCB"
    case CardBrandDinersClub = "Diners Club"
    case CardBrandUnknown = "Unknown"
    var description: String {
        return self.rawValue
    }
}
public class CustomCardDialog: CustomDialog,UITextFieldDelegate,keyboardWasShownDelegate,keyboardWillBeHiddenDelegate {
   //MARK:- OUTLETS
 
    @IBOutlet weak var scrDialog: UIScrollView!
    @IBOutlet weak var stkBtns: UIStackView!
    @IBOutlet weak var lblTitle: UILabel!
  
    @IBOutlet weak var txtCardHolderName: UITextField!
    @IBOutlet weak var lblCardHolderName: UILabel!
    @IBOutlet weak var viewForCardHolderName: UIView!
    
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var viewMonth: UIView!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var viewYear: UIView!
    @IBOutlet weak var lblCvv: UILabel!
    @IBOutlet weak var viewCvv: UIView!
    
    @IBOutlet weak var lblCreditCardNumber: UILabel!
    @IBOutlet weak var viewForCreditCardNumber: UIView!
    
    @IBOutlet weak var txtCreditCardNumber: UITextField!
    @IBOutlet weak var txtMonth: UITextField!
    @IBOutlet weak var txtYear: UITextField!
    @IBOutlet weak var txtCvv: UITextField!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var constraintForBottom: NSLayoutConstraint!
    @IBOutlet weak var constraintForHeight: NSLayoutConstraint!
    
  //MARK:Variables
    var onClickRightButton : ((_ paymentMethod:String,_ lastFour:String) -> Void)? = nil
    var onClickLeftButton : (() -> Void)? = nil
    static let  cardDialog = "dialogForCard"
    var card_length = 19
    var mongth_length = 2
    let numberSet = NSCharacterSet(charactersIn:"0123456789").inverted
    var paymentSetupIntentClientSecret: String?
    var activeField: UITextField?

    
    public static func  showCustomCardDialog
        (title:String,
         titleLeftButton:String,
         titleRightButton:String) ->
        CustomCardDialog
     {
        let view = UINib(nibName: cardDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomCardDialog
        Stripe.setDefaultPublishableKey(CONSTANT.STRIPE_KEY)
        //view.alertView.setShadow()
        view.setLocalization()
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame;
        view.lblTitle.text = title;
        //view.btnLeft.setTitle(titleLeftButton.uppercased(), for: UIControl.State.normal)
        view.btnRight.setTitle(titleRightButton.uppercased(), for: UIControl.State.normal)

        
        APPDELEGATE.window?.addSubview(view)
        APPDELEGATE.window?.bringSubviewToFront(view);
        view.animationBottomTOTop(view.alertView)        
        
        view.registerForKeyboardObserver()
        view.delegatekeyboardWasShown = view
        view.delegatekeyboardWillBeHidden = view
        
        return view;
    }
    //MARK:- Set Localization
    func setLocalization() {
        txtCvv.placeholder = ""
        txtMonth.placeholder = ""
        txtYear.placeholder = ""
        
        txtCreditCardNumber.placeholder = ""
       txtCardHolderName.placeholder = ""
        //"TXT_CARD_HOLDER_NAME".localizedCapitalized
        
//        lblCardHolderName.text = "TXT_CARD_HOLDER_NAME".localizedCapitalized
//        lblCardHolderName.font = FontHelper.textRegular()
//        lblCardHolderName.textColor = .themeLightTextColor
        txtCardHolderName.placeholder = "TXT_CARD_HOLDER_NAME".localizedCapitalized
        
//        lblCreditCardNumber.text = "TXT_CREDIT_CARD_NUMBER".localizedCapitalized
//        lblCreditCardNumber.font = FontHelper.textRegular()
//        lblCreditCardNumber.textColor = .themeLightTextColor
        txtCreditCardNumber.placeholder = "TXT_CREDIT_CARD_NUMBER".localizedCapitalized
        
//        lblYear.text = "TXT_YY".localizedUppercase
//        lblYear.font = FontHelper.textRegular()
//        lblYear.textColor = .themeLightTextColor
        txtYear.placeholder = "TXT_YY".localizedUppercase
        
//        lblMonth.text = "TXT_MM".localizedUppercase
//        lblMonth.font = FontHelper.textRegular()
//        lblMonth.textColor = .themeLightTextColor
        txtMonth.placeholder = "TXT_MM".localizedUppercase
        
        
//        lblCvv.text = "TXT_CVV".localizedUppercase
//        lblCvv.font = FontHelper.textRegular()
//        lblCvv.textColor = .themeLightTextColor
        txtCvv.placeholder = "TXT_CVV".localizedUppercase
        
        txtMonth.delegate = self
        txtCreditCardNumber.delegate = self
        txtYear.delegate = self
        txtCvv.delegate = self
        txtCardHolderName.delegate = self
        
        //Colors
        txtCvv.textColor = UIColor.themeTextColor
        txtMonth.textColor = UIColor.themeTextColor
        txtYear.textColor = UIColor.themeTextColor
        txtCreditCardNumber.textColor = UIColor.themeTextColor
        txtCardHolderName.textColor = UIColor.themeTextColor
        
        lblTitle.textColor = UIColor.themeTextColor
        //btnLeft.setTitleColor(UIColor.themeTextColor, for: .normal)
        //btnRight.setTitleColor(UIColor.themeTextColor, for: .normal)
        /*Set Font*/
        lblTitle.font = FontHelper.textMedium(size: FontHelper.large)
        txtCvv.font = FontHelper.textRegular()
        txtMonth.font = FontHelper.textRegular()
        txtYear.font = FontHelper.textRegular()
        txtCardHolderName.font = FontHelper.textRegular()
        
        txtCreditCardNumber.font = FontHelper.textRegular()
        //btnLeft.titleLabel?.font =  FontHelper.textSmall()
       // btnRight.titleLabel?.font =  FontHelper.textSmall()
        
        btnLeft.setTitle("", for: .normal)
        btnLeft.tintColor = .themeColor
        btnLeft.setImage(UIImage.init(named: "cross")?.imageWithColor(color: UIColor.themeColor), for: .normal)
        
    /*    self.viewForCreditCardNumber.setRound(withBorderColor: .themeSectionBackgroundColor, andCornerRadious: 0.01, borderWidth: 2.0)
        self.viewCvv.setRound(withBorderColor: .themeSectionBackgroundColor, andCornerRadious: 0.01, borderWidth: 2.0)
        self.viewYear.setRound(withBorderColor: .themeSectionBackgroundColor, andCornerRadious: 0.01, borderWidth: 2.0)
        self.viewMonth.setRound(withBorderColor: .themeSectionBackgroundColor, andCornerRadious: 0.01, borderWidth: 2.0)
        self.viewForCardHolderName.setRound(withBorderColor: .themeSectionBackgroundColor, andCornerRadious: 0.01, borderWidth: 2.0) */
        self.backgroundColor = UIColor.themeOverlayColor
        self.alertView.backgroundColor = UIColor.themeViewBackgroundColor
//        self.alertView.setRound(withBorderColor: .clear, andCornerRadious: 3.0, borderWidth: 1.0)
//        self.alertView.updateConstraintsIfNeeded()
        
//        IQKeyboardManager.shared.enable = false
        
        updateUIAccordingToTheme()
    }
    public override func layoutSubviews() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.alertView.applyTopCornerRadius()
        }
    }
    override func updateUIAccordingToTheme() {
        btnLeft.setImage(UIImage.init(named: "cross")?.imageWithColor(color: UIColor.themeColor), for: .normal)
    }
    
    // MARK: - Keyboard methods
    
    override func keyboardWasShown(notification: NSNotification)
    {
        //Need to calculate keyboard exact size due to Apple suggestions
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        var aRect : CGRect = self.frame
        aRect.size.height -= keyboardSize!.height
        if let activeFieldPresent = activeField
        {
            _ = (activeFieldPresent.superview as? UIStackView)?.convert((activeFieldPresent.superview as? UIStackView)?.frame.origin ?? CGPoint.zero, to: nil) ?? CGPoint.zero
            
            if (aRect.contains(activeField!.frame.origin))
            {
                constraintForBottom.constant = 0.0
                UIView.animate(withDuration: 1.0) {
                    self.constraintForBottom.constant = keyboardSize!.height
                }
            }
        }
    }
    
    override func keyboardWillBeHidden(notification: NSNotification)
    {
        //Once keyboard disappears, restore original positions
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        var _ : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: -keyboardSize!.height, right: 0.0)
        
        UIView.animate(withDuration: 1.0) {
            self.constraintForBottom.constant = 0.0
        }
        self.endEditing(true)
    }
    
    //MARK:- TextField Delegate Methods
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        return true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        if textField == txtCardHolderName {
            
            txtCreditCardNumber.becomeFirstResponder()
        }
        if textField == txtCreditCardNumber {
            txtMonth.becomeFirstResponder()
        }else if textField == txtMonth {
            txtYear.becomeFirstResponder()
        }else if textField == txtYear {
            txtCvv.becomeFirstResponder()
        }else {
            textField.resignFirstResponder()
            return true
        }
        return true
    }
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtCardHolderName {
            return true
        }
        
        if  (string == "") || string.count < 1 {
            return true
        }else {
            let compSepByCharInSet = string.components(separatedBy: numberSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            
            if string == numberFiltered {
                if textField == txtCreditCardNumber {
                    if txtCreditCardNumber.text?.count == card_length && range.length == 0 {
                        txtMonth.becomeFirstResponder()
                        return false
                    }else {
                        if txtCreditCardNumber.text?.count == 2 && range.length == 0
                        {
                            let strCardType = self.cardBrand(number: txtCreditCardNumber.text!)
                            card_length = length(forCardType: strCardType)
                            
                        }
                        else if (txtCreditCardNumber.text?.count)! >= card_length && range.length == 0
                        {
                            txtMonth.becomeFirstResponder()
                            return false
                        }
                        else if txtCreditCardNumber.text?.count == 4 || txtCreditCardNumber.text?.count == 9 || txtCreditCardNumber.text?.count == 14
                        {
                            let str: String = txtCreditCardNumber.text!
                            txtCreditCardNumber.text = str + "-"
                        }
                        return true;
                    }
                }else if textField == txtMonth {
                    if (txtMonth.text?.count)! >= 2 {
                        txtYear.becomeFirstResponder()
                        return false
                    }
                    return true
                }else if textField == txtYear {if (txtYear.text?.count)! >= 2{
                    txtCvv.becomeFirstResponder()
                    return false}
                    return true
                }else if textField == txtCvv {
                    if (txtCvv.text?.count)! >= 4 {
                        textField.resignFirstResponder()
                        return false
                    }
                    return true
                }else {
                    textField.resignFirstResponder()
                    return false
                }
            }else {
            return false
            }
        
        }
    }
    public func textFieldDidBeginEditing(_ textField: UITextField) {
            self.createToolbar(textfield: textField)
    }
    
    func createToolbar(textfield : UITextField){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.black
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.white
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(
            title: "TXT_DONE".localized,
            style: .plain,
            target: self,
            action: #selector(doneTextField(sender:))
        )
        doneButton.tag = textfield.tag
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textfield.inputAccessoryView = toolBar
    }
    @objc func doneTextField(sender : UIBarButtonItem){
        self.endEditing(true)
    }
    
    //MARK:- Card Methods
    func cardBrand(number: String) -> String {
            if number.hasPrefix("34") || number.hasPrefix("37") {
                return CardBrand.CardBrandAmex.rawValue
            }else if number.hasPrefix("60") || number.hasPrefix("62") || number.hasPrefix("64") || number.hasPrefix("65") {
                return CardBrand.CardBrandDiscover.rawValue
            }else if number.hasPrefix("35") {
                return CardBrand.CardBrandJCB.rawValue
            }else if number.hasPrefix("30") || number.hasPrefix("36") || number.hasPrefix("38") || number.hasPrefix("39") {
                return CardBrand.CardBrandDinersClub.rawValue
            }else if number.hasPrefix("4") {
                return CardBrand.CardBrandVisa.rawValue
            }else if number.hasPrefix("5") {
                return CardBrand.CardBrandMasterCard.rawValue
            }else {
                return CardBrand.CardBrandUnknown.rawValue
            }
    }
    
    func length(forCardType type: String) -> Int {
        switch type {
        case CardBrand.CardBrandAmex.rawValue:
            return 18
        case CardBrand.CardBrandDinersClub.rawValue:
            return 17
        case CardBrand.CardBrandJCB.rawValue,CardBrand.CardBrandMasterCard.rawValue,CardBrand.CardBrandVisa.rawValue,CardBrand.CardBrandDiscover.rawValue:
            return 19
        default:
            return 19
        }
    }
    
    
    //MARK:- ActionMethods
    @IBAction func onClickBtnLeft(_ sender: Any) {
//        IQKeyboardManager.shared.enable = true
        if self.onClickLeftButton != nil {
            self.onClickLeftButton!();
        }
    }
    @IBAction func onClickBtnRight(_ sender: Any) {
        if (txtCardHolderName.text?.count)! < 1 {
            Utility.showToast(message: "MSG_ENTER_CARD_HOLDER_NAME_FIRST".localized)
            txtCardHolderName.becomeFirstResponder()
        }else if (txtCreditCardNumber.text?.count)! < card_length {
            Utility.showToast(message: "MSG_ENTER_VALID_CREDIT_CARD_NUMBER".localized)
            txtCreditCardNumber.becomeFirstResponder()
        }
      else if (txtMonth.text?.count)! < 1 {
                    Utility.showToast(message: "MSG_ENTER_VALID_MONTH".localized)
            txtMonth.becomeFirstResponder()
        }else if (txtYear.text?.count)! < 1 {
            Utility.showToast(message: "MSG_ENTER_VALID_YEAR".localized)
            txtYear.becomeFirstResponder()
        }else if (txtCvv.text?.count)! < 3 {
            Utility.showToast(message: "MSG_ENTER_VALID_CVV_NUMBER".localized)
            txtCvv.becomeFirstResponder()
        }
        else {
            Utility.showLoading()
             wsGetStripeIntent()
            //generateToken()
        }
    }
}

extension CustomCardDialog: STPAuthenticationContext {
    public func authenticationPresentingViewController() -> UIViewController {
        self.isHidden = true
        Utility.hideLoading()
        return APPDELEGATE.window!.rootViewController!
    }
    func wsGetStripeIntent()
    {
        Utility.showLoading()
        let dictParam : [String : Any] = [PARAMS.PAYMENT_ID:Payment.STRIPE]
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.GET_STRIPE_ADD_CARD_INTENT, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam)
        {
            (response, error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response)
            {
                self.paymentSetupIntentClientSecret = response["client_secret"] as? String
                if self.paymentSetupIntentClientSecret!.isEmpty {
                    return
                }
                Utility.showLoading()
                let cardParams = STPPaymentMethodCardParams.init()
                cardParams.cvc = self.txtCvv.text
                cardParams.expYear = (Int(self.txtYear.text ?? "") ?? 0) as NSNumber
                cardParams.expMonth = (Int(self.txtMonth.text ?? "") ?? 0) as NSNumber
                cardParams.number =  (self.txtCreditCardNumber.text ?? "").replacingOccurrences(of: "-", with: "")
                let billingParams = STPPaymentMethodBillingDetails.init()
                billingParams.email = preferenceHelper.getEmail()
                billingParams.phone = preferenceHelper.getPhoneNumber()
                billingParams.name  = self.txtCardHolderName.text ?? ""
                let paymentMethodParams = STPPaymentMethodParams(card: cardParams, billingDetails: billingParams, metadata: nil)
                let paymentSetupParams = STPSetupIntentConfirmParams(clientSecret: self.paymentSetupIntentClientSecret!)
                paymentSetupParams.paymentMethodParams = paymentMethodParams
                let paymentHandler = STPPaymentHandler.shared()
                paymentHandler.confirmSetupIntent(paymentSetupParams, with: self) { [weak self] status, setupIntent, error in
                    self?.isHidden = false
                    Utility.showLoading()
                    guard let self = self else { return }
                    switch (status) {
                        case .failed:
                            Common.alert("", error!.localizedDescription)
                            Utility.hideLoading()
                            break
                        case .canceled:
                            Utility.hideLoading()
                            print("Setup Payment canceled \(error?.localizedDescription ?? "")")
                            break
                        case .succeeded:
                            if self.onClickRightButton != nil {
                                let lastFour = String((self.txtCreditCardNumber.text ?? "").replacingOccurrences(of: "-", with: "").suffix(4))
                                self.onClickRightButton!((setupIntent?.paymentMethodID)!, lastFour)
                            }
                            break
                        default:
                            break
                    }
                }
            }
        }
    }
}
