//
//  CustomPhotoDialog.swift
//  edelivery
//
//  Created by Elluminati on 22/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import UIKit


public class CustomVerificationDialog:CustomDialog,UITextFieldDelegate,keyboardWasShownDelegate,keyboardWillBeHiddenDelegate {

    //MARK:- OUTLETS
    @IBOutlet weak var stkDialog: UIStackView!
    @IBOutlet weak var stkBtns: UIStackView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var editTextOne: UITextField!
    @IBOutlet weak var editTextTwo: UITextField!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var viewForEditTextOne: UIView!
    @IBOutlet weak var btnShowHideEditTextOne: UIButton!
    @IBOutlet weak var viewForEditTextTwo: UIView!
    @IBOutlet weak var btnShowHideEditTextTwo: UIButton!
    @IBOutlet weak var heightEditTextOne: NSLayoutConstraint!
    @IBOutlet weak var heightEditTextTwo: NSLayoutConstraint!
    @IBOutlet weak var ResendTitleView: UIView!
    @IBOutlet weak var lblResendOtpMsg: UILabel!
    @IBOutlet weak var btnResendCodeOtpMsg: UIButton!
    @IBOutlet weak var heightResendTitleView: NSLayoutConstraint!
    @IBOutlet var bottomAnchorView: NSLayoutConstraint!
    var activeField: UITextField?

    //MARK: - Variables
    var onClickRightButton : ((_ text1:String , _ text2:String ) -> Void)? = nil
    var onClickLeftButton : (() -> Void)? = nil
    
    weak var timer: Timer? = nil
    var isForVerifyOtp:Bool = false
    var isFromMainVC:Bool = false
    var isForgotPasswordOtp:Bool = false
    var param:[String:Any] = [:]
    static let verificationDialog = "dialogForVerification"

    public override func awakeFromNib() {
        super.awakeFromNib()
    }

    public static func showCustomVerificationDialog
        (title:String,
         message:String,
         titleLeftButton:String,
         titleRightButton:String,
         editTextOneHint:String,
         editTextTwoHint:String,
         isEdiTextTwoIsHidden:Bool,
         isEdiTextOneIsHidden:Bool = false,
         editTextOneInputType:Bool = false,
         editTextTwoInputType:Bool = false,
         isForVerifyOtp:Bool = false,
         isForgotPasswordOtp:Bool = false,
         param:[String:Any] = [:], isFromMainVC:Bool = false
         ) -> CustomVerificationDialog {

        let view = UINib(nibName: verificationDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomVerificationDialog
        view.alertView.setShadow()
        let frame = (APPDELEGATE.window?.frame)!
        view.frame = frame
        view.lblTitle.text = title
        view.lblMessage.text = message
        view.lblMessage.isHidden = message.isEmpty()
        view.isFromMainVC = isFromMainVC
        view.setLocalization()
        view.btnRight.setTitle(titleRightButton, for: UIControl.State.normal)
        view.editTextOne.isSecureTextEntry = editTextOneInputType
        view.editTextTwo.isSecureTextEntry = editTextTwoInputType

        if editTextOneHint == "\("TXT_EMAIL".localized)" {
            view.editTextOne.keyboardType = .emailAddress
        } else if editTextOneHint == "\("TXT_PHONE".localized)" {
            view.editTextOne.keyboardType = .phonePad
        } else if editTextOneHint == "\("TXT_MOBILE_NO".localized)" {
            view.editTextOne.keyboardType = .phonePad
        } else if editTextOneHint == "\("TXT_EMAIL_OTP".localized)" || editTextOneHint == "\("TXT_PHONE_OTP".localized)" {
            view.editTextOne.keyboardType = .numberPad
        } else if editTextOneHint == "\("TXT_WALLET_HINT".localized)" {
            view.editTextOne.keyboardType = .decimalPad
        } else {
            view.editTextOne.keyboardType = .default
        }

        if editTextTwoHint == "\("TXT_EMAIL".localized)" {
            view.editTextTwo.keyboardType = .emailAddress
        } else if editTextTwoHint == "\("TXT_PHONE".localized)" {
            view.editTextTwo.keyboardType = .phonePad
        } else if editTextTwoHint == "\("TXT_MOBILE_NO".localized)" {
            view.editTextTwo.keyboardType = .phonePad
        } else if editTextTwoHint == "\("TXT_EMAIL_OTP".localized)" || editTextTwoHint == "\("TXT_PHONE_OTP".localized)" {
            view.editTextTwo.keyboardType = .numberPad
        } else if editTextTwoHint == "\("TXT_WALLET_HINT".localized)" {
            view.editTextTwo.keyboardType = .decimalPad
        } else {
            view.editTextTwo.keyboardType = .default
        }

        
        view.isForgotPasswordOtp = isForgotPasswordOtp
        view.isForVerifyOtp = isForVerifyOtp
        view.param = param
        view.btnResendCodeOtpMsg.isHidden = true

        if isForVerifyOtp {
            view.ResendTitleView.isHidden = false
            view.heightResendTitleView.constant = 34
            view.lblResendOtpMsg.isHidden = false
        } else {
            view.ResendTitleView.isHidden = true
            view.heightResendTitleView.constant = 0
        }

        view.editTextOne.placeholder = editTextOneHint
        view.editTextTwo.placeholder = editTextTwoHint
        view.viewForEditTextTwo.isHidden = isEdiTextTwoIsHidden
        view.viewForEditTextOne.isHidden = isEdiTextOneIsHidden
        view.heightEditTextOne.constant = view.editTextOne.isHidden ? 0:34
        view.heightEditTextTwo.constant = view.editTextTwo.isHidden ? 0:34

        if !isForVerifyOtp && (title == "TXT_RESET_PWD".localized || title == "TXT_VERIFY_ACCOUNT".localized) {
            view.editTextOne.isSecureTextEntry = true
            view.editTextTwo.isSecureTextEntry = true
            view.btnShowHideEditTextOne.isHidden = view.viewForEditTextOne.isHidden
            view.btnShowHideEditTextTwo.isHidden = view.viewForEditTextTwo.isHidden
        } else {
            view.editTextOne.isSecureTextEntry = false
            view.editTextTwo.isSecureTextEntry = false
            view.btnShowHideEditTextOne.isHidden = true
            view.btnShowHideEditTextTwo.isHidden = true
        }

        DispatchQueue.main.async {
            APPDELEGATE.window?.addSubview(view)
            APPDELEGATE.window?.bringSubviewToFront(view)
            view.animationBottomTOTop(view.alertView)
        }
        return view
    }

    public override func layoutSubviews() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.alertView.applyTopCornerRadius()
        }
        self.btnRight.applyRoundedCornersWithHeight()
    }

    func setLocalization() {
        /* Set Color */
        self.backgroundColor = UIColor.themeOverlayColor
        btnRight.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        btnRight.setBackgroundColor(color: UIColor.themeColor, forState: .normal)
        lblTitle.textColor = UIColor.themeTitleColor
        lblMessage.textColor = UIColor.themeLightTextColor
        editTextOne.textColor = UIColor.themeTextColor
        editTextTwo.textColor = UIColor.themeTextColor
        lblResendOtpMsg.textColor = UIColor.themeTextColor
        btnResendCodeOtpMsg.setTitleColor(UIColor.themeColor, for: .normal)
        lblTitle.font = FontHelper.textLarge()
        lblMessage.font = FontHelper.textRegular()
        editTextOne.font = FontHelper.textRegular()
        editTextTwo.font = FontHelper.textRegular()
        lblResendOtpMsg.font = FontHelper.textRegular()
        btnResendCodeOtpMsg.titleLabel?.font = FontHelper.textRegular()
        editTextOne.delegate = self
        editTextTwo.delegate = self
        self.backgroundColor = UIColor.themeOverlayColor
        self.alertView.backgroundColor = UIColor.themeViewBackgroundColor
        self.alertView.setRound(withBorderColor: .clear, andCornerRadious: 3.0, borderWidth: 1.0)
        deregisterFromKeyboardNotifications()
        registerForKeyboardNotifications()
        self.delegatekeyboardWasShown = self
        self.delegatekeyboardWillBeHidden = self
       
        if isFromMainVC{
            btnLeft.setImage(UIImage(named:"menuLogout")?.imageWithColor(color: .themeColor), for: .normal)
        }else{
            btnLeft.setImage(UIImage(named:"cancelIcon")?.imageWithColor(color: UIColor.themeColor), for: .normal)
        }
    }

    override func updateUIAccordingToTheme() {
        if isFromMainVC{
            btnLeft.setImage(UIImage(named:"menuLogout")?.imageWithColor(color: .themeColor), for: .normal)
        }else{
            btnLeft.setImage(UIImage(named:"cancelIcon")?.imageWithColor(color: UIColor.themeColor), for: .normal)
        }
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        if textField == self.editTextOne {
            if viewForEditTextTwo.isHidden {
                textField.resignFirstResponder()
            } else {
                editTextTwo.becomeFirstResponder()
            }
        } else if textField == editTextTwo {
            textField.resignFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.editTextOne && self.editTextOne!.placeholder == "TXT_PHONE".localized {
            if (string == "") || string.count < 1 {
                return true
            } else if (textField.text?.count)! >= 10 {
                return false
            }
        }
        return true
    }

    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        return true
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }

    //MARK: - TIMERS
    var timerLeft:Int = RESEND_TIME

    func startTimer() {
        self.lblResendOtpMsg.text =  "\("TXT_RESEND_CODE_IN".localized) " +  String.secondsToMinutesSeconds(seconds: self.timerLeft)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timrt) in
            self.timer = timrt
            self.timerLeft -= 1
            if self.timerLeft <= 0 {
                timrt.invalidate()
                self.lblResendOtpMsg.isHidden = true
                self.btnResendCodeOtpMsg.isHidden = false
            } else {
                self.lblResendOtpMsg.text = "\("TXT_RESEND_CODE_IN".localized) " +  String.secondsToMinutesSeconds(seconds: self.timerLeft)
            }
        }
    }

    //MARK: - Action Methods
    @IBAction func onClickBtnLeft(_ sender: Any) {
        if self.onClickLeftButton != nil {
            timer?.invalidate()
            self.animationForHideView(alertView) {
                self.onClickLeftButton!()
            }
        }
    }

    @IBAction func btnResendCodeOtpMsgTapped(_ sender: Any) {
        lblResendOtpMsg.text = "\("TXT_RESEND_CODE_IN".localized) 00:00"
        if !self.isForgotPasswordOtp {
            self.wsGetOtpVerify()
        } else {
            self.wsForgetPassword()
        }
    }

    @IBAction func onClickBtnRight(_ sender: Any) {
        if self.onClickRightButton != nil {
            if !isForVerifyOtp && btnRight.titleLabel?.text != "TXT_RESEND".localizedCapitalized && self.lblTitle.text != "TXT_RESET_PWD".localized {
                self.onClickRightButton!(editTextOne.text ?? "",editTextTwo.text ?? "")
            } else if isForVerifyOtp && btnRight.titleLabel?.text == "TXT_RESEND".localizedCapitalized {
                self.onClickRightButton!(editTextOne.text ?? "",editTextTwo.text ?? "")
            } else if !isForVerifyOtp && self.lblTitle.text == "TXT_RESET_PWD".localized {
                if editTextOne.text != editTextTwo.text {
                    Utility.showToast(message:"MSG_NEW_CONFIRM_PWD_NOT_MATCHED".localized)
                } else if editTextOne.text!.trimmingCharacters(in: .whitespaces).count < passwordMinLength {
                    let myString = String(format: NSLocalizedString("MSG_PLEASE_ENTER_VALID_PASSWORD", comment: ""), String(passwordMinLength))
                    Utility.showToast(message: myString)
                } else {
                    self.onClickRightButton!(editTextOne.text ?? "",editTextTwo.text ?? "")
                }
            } else if isForVerifyOtp && isForgotPasswordOtp {
                if editTextOne.text!.count > 0 {
                    self.onClickRightButton!("\(editTextOne.text ?? "")", "\(editTextTwo.text ?? "")")
                } else {
                    Utility.showToast(message:"MSG_ENTER_VALID_OTP".localized)
                }
            } else if isForVerifyOtp && !isForgotPasswordOtp {
                self.onClickRightButton!("\(editTextOne.text ?? "")", "\(editTextTwo.text ?? "")")
            }
        }
    }

    @IBAction func onClickBtnShowHideEditTextOne(_ sender: Any) {
        if self.editTextOne.isSecureTextEntry {
            self.editTextOne.isSecureTextEntry = false
            self.btnShowHideEditTextOne.setBackgroundImage(UIImage.init(named: "passwordShow"), for: .normal)
        } else {
            self.editTextOne.isSecureTextEntry = true
            self.btnShowHideEditTextOne.setBackgroundImage(UIImage.init(named: "passwordHide"), for: .normal)
        }
    }

    @IBAction func onClickBtnShowHideEditTextTwo(_ sender: Any) {
        if self.editTextTwo.isSecureTextEntry {
            self.editTextTwo.isSecureTextEntry = false
            self.btnShowHideEditTextTwo.setBackgroundImage(UIImage.init(named: "passwordShow"), for: .normal)
        } else {
            self.editTextTwo.isSecureTextEntry = true
            self.btnShowHideEditTextTwo.setBackgroundImage(UIImage.init(named: "passwordHide"), for: .normal)
        }
    }

    deinit {
        deregisterFromKeyboardNotifications()
    }

    //MARK: - Webservice
    func wsForgetPassword() {
        Utility.showLoading()
        let alamoFire:AlamofireHelper = AlamofireHelper()
        alamoFire.getResponseFromURL(url: WebService.WS_FORGET_PASSWORD, methodName: AlamofireHelper.POST_METHOD, paramData: param) {(response, error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response, withSuccessToast: true, andErrorToast: true) {
                self.timerLeft = RESEND_TIME
                self.lblResendOtpMsg.isHidden = false
                self.btnResendCodeOtpMsg.isHidden = true
                self.startTimer()
            }
        }
    }

    func wsGetOtpVerify() {
        Utility.showLoading()
        let alamoFire:AlamofireHelper = AlamofireHelper()
        alamoFire.getResponseFromURL(url: WebService.WS_OTP_VERIFICATION, methodName: AlamofireHelper.POST_METHOD, paramData: self.param) {(response, error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true) {
                self.timerLeft = RESEND_TIME
                self.lblResendOtpMsg.isHidden = false
                self.btnResendCodeOtpMsg.isHidden = true
                self.startTimer()
            }
        }
    }

    @objc override func keyboardWasShown(notification: NSNotification) {
        //Need to calculate keyboard exact size due to Apple suggestions
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        var aRect : CGRect = self.frame
        aRect.size.height -= keyboardSize!.height
        if let activeFieldPresent = activeField {
            _ = (activeFieldPresent.superview as? UIStackView)?.convert((activeFieldPresent.superview as? UIStackView)?.frame.origin ?? CGPoint.zero, to: nil) ?? CGPoint.zero
            self.bottomAnchorView.constant = 0.0
            UIView.animate(withDuration: 0.5) {
                DispatchQueue.main.async {
                    self.bottomAnchorView.constant = keyboardSize!.height
                }
            }
        }
    }

    @objc override func keyboardWillBeHidden(notification: NSNotification) {
        //Once keyboard disappears, restore original positions
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        var _ : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: -keyboardSize!.height, right: 0.0)
        UIView.animate(withDuration: 0.5) {
            DispatchQueue.main.async {
                self.bottomAnchorView.constant = 0.0
            }
        }
        self.endEditing(true)
    }
}
