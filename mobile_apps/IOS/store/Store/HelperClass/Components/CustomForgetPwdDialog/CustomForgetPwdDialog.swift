//
//  CustomPhotoDialog.swift
// Edelivery Store
//
//  Created by Jaydeep Vyas on 22/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import UIKit

public class CustomForgetPwdDialog: CustomDialog,UITextFieldDelegate,keyboardWasShownDelegate,keyboardWillBeHiddenDelegate {
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

    @IBOutlet weak var ResendTitleView: UIView!
    @IBOutlet weak var lblResendTitile: UILabel!
    @IBOutlet weak var btnResendCodeOtpMsg: UIButton!
    
    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var btnPhone: UIButton!

    @IBOutlet weak var heightResendTitleView: NSLayoutConstraint!
    @IBOutlet weak var bottomAnchorView: NSLayoutConstraint!

    //MARK: - Variables
    var onClickRightButton : ((_ text1:String , _ text2:String ) -> Void)? = nil
    var onClickLeftButton : (() -> Void)? = nil
    //    var onClickResendButton : ((_ isCallResndAPI:Bool) -> Void)? = nil
    var activeField: UITextField?

    weak var timer: Timer? = nil
    var isFromResndCode:Bool = false
    var params:[String:Any] = [:]

    static let verificationDialog = "dialogForForgetPwd"
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
     params:[String:Any] = [:],
     isFromResndCode:Bool = false) -> CustomForgetPwdDialog {

        let view = UINib(nibName: verificationDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomForgetPwdDialog
        view.alertView.setShadow()
        let frame = (APPDELEGATE.window?.frame)!
        view.frame = frame
        view.lblTitle.text = title
        view.lblMessage.text = message
        view.setLocalization()
        view.btnRight.setTitle(titleRightButton, for: UIControl.State.normal)
        view.editTextOne.isSecureTextEntry = editTextOneInputType
        view.editTextTwo.isSecureTextEntry = editTextTwoInputType
        view.btnEmail.isSelected = false
        view.btnPhone.isSelected = true
        view.btnResendCodeOtpMsg.isHidden = true
        view.setUIAccordingToSelection()
        view.params = params

        if UIApplication.isRTL() {
            view.btnEmail.setTitle("     "+"TXT_EMAIL".localized, for: .normal)
            view.btnPhone.setTitle("     "+"TXT_MOBILE_NO".localized, for: .normal)
        } else {
            view.btnEmail.setTitle("TXT_EMAIL".localized, for: .normal)
            view.btnPhone.setTitle("TXT_MOBILE_NO".localized, for: .normal)
        }

        if editTextOneHint == "TXT_PHONE".localized {
            view.editTextOne.keyboardType = .phonePad
        } else {
            view.editTextOne.keyboardType = .default
        }

        view.isFromResndCode = isFromResndCode
        if isFromResndCode {
            view.ResendTitleView.isHidden = false
            view.heightResendTitleView.constant = 34
            view.btnEmail.isHidden = true
            view.btnPhone.isHidden = true
        } else {
            view.ResendTitleView.isHidden = true
            view.heightResendTitleView.constant = 0
            if title != "TXT_RESET_PWD".localized {
                view.btnEmail.isHidden = false
                view.btnPhone.isHidden = false
            } else {
                view.btnEmail.isHidden = true
                view.btnPhone.isHidden = true
            }
        }

        if !isFromResndCode && title == "TXT_RESET_PWD".localized {
            view.editTextOne.isSecureTextEntry = true
            view.editTextTwo.isSecureTextEntry = true
        } else {
            view.editTextOne.isSecureTextEntry = false
            view.editTextTwo.isSecureTextEntry = false
        }

        if !isFromResndCode {
            if title != "TXT_RESET_PWD".localized {
                if preferenceHelper.getIsLoginByEmail() && preferenceHelper.getIsLoginByPhone() {
                    view.editTextOne.placeholder = editTextOneHint
                    view.editTextOne.isHidden = isEdiTextOneIsHidden
                    
                    view.editTextTwo.placeholder = editTextTwoHint
                    view.editTextTwo.isHidden = true
                    
                    view.btnEmail.isHidden = false
                    view.btnPhone.isHidden = false
                    
                    view.btnEmail.isSelected = true
                    view.btnPhone.isSelected = false
                    
                } else if preferenceHelper.getIsLoginByEmail() {
                    view.editTextOne.placeholder = editTextOneHint
                    view.editTextOne.isHidden = isEdiTextOneIsHidden
                    
                    view.editTextTwo.placeholder = ""
                    view.editTextTwo.isHidden = true

                    view.btnEmail.isHidden = false
                    view.btnPhone.isHidden = true
                    view.btnEmail.isSelected = true
                    view.btnPhone.isSelected = false
                } else if preferenceHelper.getIsLoginByPhone() {
                    view.editTextOne.placeholder = ""
                    view.editTextOne.isHidden = true
                    view.editTextTwo.placeholder = editTextTwoHint
                    view.editTextTwo.isHidden = isEdiTextTwoIsHidden
                    
                    view.btnEmail.isHidden = true
                    view.btnPhone.isHidden = false
                    
                    view.btnEmail.isSelected = false
                    view.btnPhone.isSelected = true
                }
            } else {
                view.editTextOne.placeholder = editTextOneHint
                view.editTextOne.isHidden = isEdiTextOneIsHidden
        
                view.editTextTwo.placeholder = editTextTwoHint
                view.editTextTwo.isHidden = isEdiTextTwoIsHidden
            }
        } else {
            view.editTextOne.placeholder = editTextOneHint
            view.editTextOne.isHidden = isEdiTextOneIsHidden

            view.editTextTwo.placeholder = editTextTwoHint
            view.editTextTwo.isHidden = isEdiTextTwoIsHidden
        }

        APPDELEGATE.window?.addSubview(view)
        APPDELEGATE.window?.bringSubviewToFront(view)
        view.animationBottomTOTop(view.alertView)
        view.endEditing(true)

        view.registerForKeyboardObserver()
        view.delegatekeyboardWasShown = view
        view.delegatekeyboardWillBeHidden = view

        if editTextOneHint == "\("TXT_EMAIL".localized)" {
            view.editTextOne.keyboardType = .emailAddress
        } else if editTextOneHint == "\("TXT_MOBILE_NO".localized)" {
            view.editTextOne.keyboardType = .phonePad
        } else if editTextOneHint == "\("TXT_EMAIL_OTP".localized)" || editTextOneHint == "\("TXT_PHONE_OTP".localized)" {
            view.editTextOne.keyboardType = .numberPad
        } else {
            view.editTextOne.keyboardType = .default
        }

        if editTextTwoHint == "\("TXT_MOBILE_NO".localized)" {
            view.editTextTwo.keyboardType = .phonePad
        } else if editTextTwoHint == "\("TXT_EMAIL_OTP".localized)" || editTextTwoHint == "\("TXT_PHONE_OTP".localized)" {
            view.editTextTwo.keyboardType = .numberPad
        } else {
            view.editTextTwo.keyboardType = .default
        }

        return view
    }

    func setLocalization() {
        /* Set Color */
        lblTitle.textColor = UIColor.themeTextColor
        lblMessage.textColor = UIColor.themeLightTextColor
        editTextOne.textColor = UIColor.themeTextColor
        editTextTwo.textColor = UIColor.themeTextColor
        lblResendTitile.textColor = UIColor.themeTextColor
        btnEmail.setTitleColor(.themeTextColor, for: .normal)
        btnPhone.setTitleColor(.themeTextColor, for: .normal)
        btnResendCodeOtpMsg.setTitleColor(UIColor.themeColor, for: .normal)

        /* Set Font */
        btnResendCodeOtpMsg.titleLabel?.font = FontHelper.textRegular()
        btnEmail.titleLabel?.font =  FontHelper.textRegular()
        btnPhone.titleLabel?.font =  FontHelper.textRegular()
        lblTitle.font = FontHelper.textLarge(size: 23.0)
        lblMessage.font =  FontHelper.textRegular()
        editTextOne.font =  FontHelper.textRegular()
        editTextTwo.font =  FontHelper.textRegular()
        lblResendTitile.font =  FontHelper.textRegular()
        editTextOne.autocorrectionType = .no
        editTextTwo.autocorrectionType = .no

        updateUIAccordingToTheme()

        self.backgroundColor = UIColor.themeOverlayColor
        self.alertView.backgroundColor = UIColor.themeViewBackgroundColor
        self.alertView.setRound(withBorderColor: .clear, andCornerRadious: 3.0, borderWidth: 1.0)
    }

    public override func layoutSubviews() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.alertView.applyTopCornerRadius()
        }
    }

    override func updateUIAccordingToTheme() {
        btnLeft.setImage(UIImage(named: "cross")?.imageWithColor(color: .themeColor), for: .normal)
        btnEmail.setImage(UIImage(named: "radio_btn_unchecked_icon"), for: .normal)
        btnPhone.setImage(UIImage(named: "radio_btn_unchecked_icon"), for: .normal)
        
        btnEmail.setImage(UIImage(named: "radio_btn_checked_icon")?.imageWithColor(color: .themeColor), for: .selected)
        btnPhone.setImage(UIImage(named: "radio_btn_checked_icon")?.imageWithColor(color: .themeColor), for: .selected)
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
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

    //MARK: - TIMERS
    var timerLeft:Int = RESEND_TIME

    func startTimer() {
        self.lblResendTitile.text = "\("TXT_RESEND_CODE_IN".localized) " + String.secondsToMinutesSeconds(seconds: self.timerLeft)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timrt) in
            self.timer = timrt
            self.timerLeft -= 1
            if self.timerLeft <= 0 {
                timrt.invalidate()
                self.lblResendTitile.isHidden = true
                self.btnResendCodeOtpMsg.isHidden = false
            } else {
                self.lblResendTitile.text = "\("TXT_RESEND_CODE_IN".localized) " + String.secondsToMinutesSeconds(seconds: self.timerLeft)
            }
        }
    }

    func setUIAccordingToSelection() {
        if btnEmail.isSelected {
            self.editTextOne.isHidden = false
            self.editTextTwo.isHidden = true
            self.editTextTwo.text = ""
        }
        if btnPhone.isSelected {
            self.editTextOne.isHidden = true
            self.editTextTwo.isHidden = false
            self.editTextOne.text = ""
        }
    }

    //MARK: - Action Methods
    @IBAction func btnResendCodeOtpMsgTapped(_ sender: Any) {
        lblResendTitile.text = "\("TXT_RESEND_CODE_IN".localized) 00:00"
        self.wsForgetPassword()
    }

    @IBAction func onClickBtnEmail(_ sender: UIButton) {
        self.btnEmail.isSelected = !self.btnEmail.isSelected
        self.btnPhone.isSelected = !self.btnEmail.isSelected
        setUIAccordingToSelection()
    }

    @IBAction func onClickBtnPhone(_ sender: UIButton) {
        self.btnPhone.isSelected = !self.btnPhone.isSelected
        self.btnEmail.isSelected = !self.btnPhone.isSelected
        setUIAccordingToSelection()
    }

    @IBAction func onClickBtnLeft(_ sender: Any) {
        if self.onClickLeftButton != nil {
            timer?.invalidate()
            self.onClickLeftButton!()
        }
    }

    @IBAction func onClickBtnRight(_ sender: Any) {
        if self.onClickRightButton != nil {
            if !isFromResndCode && btnRight.titleLabel?.text != "TXT_RESEND".localizedUppercase && self.lblTitle.text != "TXT_RESET_PWD".localized {
                self.onClickRightButton!(editTextOne.text ?? "", editTextTwo.text ?? "")
            } else if isFromResndCode && btnRight.titleLabel?.text == "TXT_RESEND".localizedUppercase {
                self.onClickRightButton!(editTextOne.text ?? "", editTextTwo.text ?? "")
            } else if !isFromResndCode && self.lblTitle.text == "TXT_RESET_PWD".localized {
                if editTextOne.text != editTextTwo.text {
                    Utility.showToast(message:"MSG_NEW_CONFIRM_PWD_NOT_MATCHED".localized)
                } else {
                    self.onClickRightButton!(editTextOne.text ?? "",editTextTwo.text ?? "")
                }
            } else {
                if editTextOne.text!.count < 6 {
                    Utility.showToast(message:"MSG_ENTER_VALID_OTP".localized)
                } else {
                    self.onClickRightButton!(editTextOne.text ?? "", "")
                }
            }
        }
    }

    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        return true
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }

    //MARK: - Keyboard methods
    override func keyboardWasShown(notification: NSNotification) {
        //Need to calculate keyboard exact size due to Apple suggestions
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        var aRect : CGRect = self.frame
        aRect.size.height -= keyboardSize!.height
        if let activeFieldPresent = activeField {
            _ = (activeFieldPresent.superview as? UIStackView)?.convert((activeFieldPresent.superview as? UIStackView)?.frame.origin ?? CGPoint.zero, to: nil) ?? CGPoint.zero
            if (aRect.contains(activeField!.frame.origin)) {
                bottomAnchorView.constant = 0.0
                UIView.animate(withDuration: 1.0) {
                    self.bottomAnchorView.constant = keyboardSize!.height
                }
            }
        }
    }

    override func keyboardWillBeHidden(notification: NSNotification) {
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        var _ : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: -keyboardSize!.height, right: 0.0)
        UIView.animate(withDuration: 1.0) {
            self.bottomAnchorView.constant = 0.0
        }
        self.endEditing(true)
    }

    //MARK: - WS Method
    func wsForgetPassword() {
        Utility.showLoading()
        let alamoFire:AlamofireHelper = AlamofireHelper()
        alamoFire.getResponseFromURL(url: WebService.WS_FORGET_PASSWORD, methodName: AlamofireHelper.POST_METHOD, paramData: params) {(response, error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true) {
                self.timerLeft = RESEND_TIME
                self.lblResendTitile.isHidden = false
                self.btnResendCodeOtpMsg.isHidden = true
                self.startTimer()
            }
        }
    }
}

