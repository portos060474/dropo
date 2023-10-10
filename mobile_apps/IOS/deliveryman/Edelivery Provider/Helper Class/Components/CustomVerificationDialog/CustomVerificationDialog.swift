//
//  CustomPhotoDialog.swift
//  edelivery
//
//  Created by Elluminati on 22/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import UIKit

public class CustomVerificationDialog: CustomDialog,UITextFieldDelegate ,keyboardWasShownDelegate,keyboardWillBeHiddenDelegate{
    //MARK: - OUTLETS
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

    @IBOutlet weak var resendOtpView: UIView!
    @IBOutlet weak var heightResendOtpView: NSLayoutConstraint!
    @IBOutlet weak var lblResendOtpMsg: UILabel!
    @IBOutlet weak var btnResendCodeOtpMsg: UIButton!

    var enteredOtp: String = ""
    var activeField: UITextField?
    var strImage:String = ""

    @IBOutlet weak var bottomAnchorView: NSLayoutConstraint!

    //MARK: - Variables
    var onClickRightButton : ((_ text1:String , _ text2:String) -> Void)? = nil
    var onClickLeftButton : (() -> Void)? = nil
    var isForVerifyOtp:Bool = false
    var isForgotPasswordOtp:Bool = false
    var param:[String:Any] = [:]
    weak var timer: Timer? = nil
    static let dialogNibName = "dialogForVerification"

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
         strImage:String = "",
         param:[String:Any] = [:]) -> CustomVerificationDialog {

        let view = UINib(nibName: dialogNibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomVerificationDialog
        view.alertView.setShadow()
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame;
        view.lblTitle.text = title
        view.lblMessage.text = message
        view.strImage = strImage
        view.setLocalization()
        view.btnRight.setTitle(titleRightButton.uppercased(), for: UIControl.State.normal)
        view.editTextOne.isSecureTextEntry = editTextOneInputType
        view.editTextTwo.isSecureTextEntry = editTextTwoInputType
        view.isForgotPasswordOtp = isForgotPasswordOtp
        view.isForVerifyOtp = isForVerifyOtp
        view.param = param
        view.btnResendCodeOtpMsg.isHidden = true
        
        if editTextOneHint == "TXT_MOBILE_NUMBER".localized || editTextOneHint == "TXT_ENTER_CODE".localizedCapitalized || editTextOneHint == "TXT_PHONE_OTP".localized || editTextOneHint == "TXT_EMAIL_OTP".localized {
            view.editTextOne.keyboardType = .phonePad
        } else {
            view.editTextOne.keyboardType = .default
        }

        if editTextTwoHint == "TXT_PHONE_OTP".localized || editTextTwoHint == "TXT_EMAIL_OTP".localized {
            view.editTextTwo.keyboardType = .phonePad
        }

        if isForVerifyOtp {
            view.resendOtpView.isHidden = false
            view.heightResendOtpView.constant = 34
            view.lblResendOtpMsg.isHidden = false
        } else {
            view.resendOtpView.isHidden = true
            view.heightResendOtpView.constant = 0
        }

        view.editTextOne.isSecureTextEntry = editTextOneInputType
        view.editTextOne.placeholder = editTextOneHint
        view.editTextTwo.placeholder = editTextTwoHint
        view.editTextTwo.isHidden = isEdiTextTwoIsHidden
        view.editTextOne.isHidden = isEdiTextOneIsHidden

        if editTextOneInputType {
            view.editTextOne.isSecureTextEntry = true
            view.editTextTwo.isSecureTextEntry = true
            view.btnShowHideEditTextOne.isHidden = view.editTextOne.isHidden
            view.btnShowHideEditTextTwo.isHidden = view.editTextTwo.isHidden
        } else {
            view.editTextOne.isSecureTextEntry = false
            view.editTextTwo.isSecureTextEntry = false
            view.btnShowHideEditTextOne.isHidden = true
            view.btnShowHideEditTextTwo.isHidden = true
        }

        APPDELEGATE.window?.addSubview(view)
        APPDELEGATE.window?.bringSubviewToFront(view)

        view.alertView.layoutIfNeeded()
        view.animationBottomTOTop(view.alertView)
        view.registerForKeyboardObserver()
        view.delegatekeyboardWasShown = view
        view.delegatekeyboardWillBeHidden = view
        view.endEditing(true)
        return view;
    }

    func setLocalization() {
        /* Set Color */
        btnLeft.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)

        lblTitle.textColor = UIColor.themeTextColor
        lblMessage.textColor = UIColor.themeLightTextColor
        editTextOne.textColor = UIColor.themeTextColor
        editTextTwo.textColor = UIColor.themeTextColor
        lblResendOtpMsg.textColor = UIColor.themeTextColor

        btnLeft.setTitleColor(UIColor.themeIconTintColor, for: .normal)
        btnLeft.tintColor = UIColor.themeColor
        btnLeft.setTitle("", for: .normal)
        btnLeft.setImage(UIImage.init(named: strImage.isEmpty() ? "close" : strImage)?.imageWithColor(), for: .normal)
        btnLeft.imageView?.contentMode = .scaleAspectFill

        /* Set Font */
        lblTitle.font = FontHelper.textLarge()
        lblMessage.font =  FontHelper.textRegular()
        editTextOne.font =  FontHelper.textRegular()
        editTextTwo.font =  FontHelper.textRegular()
        lblResendOtpMsg.font =  FontHelper.textRegular()

        editTextOne.delegate = self
        editTextTwo.delegate = self

        self.backgroundColor = UIColor.themeOverlayColor
        self.alertView.backgroundColor = UIColor.themeAlertViewBackgroundColor
        self.alertView.updateConstraintsIfNeeded()
        self.alertView.roundCorner(corners: [.topRight , .topLeft], withRadius: 20)
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.editTextOne {
            if editTextTwo.isHidden {
                textField.resignFirstResponder()
            } else {
                editTextTwo.becomeFirstResponder()
            }
        }
        return true
    }

    //MARK: - TIMERS
    var timerLeft:Int = RESEND_TIME

    func startTimer() {
        self.lblResendOtpMsg.text = "\("TXT_RESEND_CODE_IN".localized) " + String.secondsToMinutesSeconds(seconds: timerLeft)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timrt) in
            self.timer = timrt
            self.timerLeft -= 1
            if self.timerLeft <= 0 {
                timrt.invalidate()
                self.lblResendOtpMsg.isHidden = true
                self.btnResendCodeOtpMsg.isHidden = false
            } else {
                self.lblResendOtpMsg.text = "\("TXT_RESEND_CODE_IN".localized) " + String.secondsToMinutesSeconds(seconds: self.timerLeft)
            }
        }
    }

    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        return true
    }

    override func keyboardWasShown(notification: NSNotification) {
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        var aRect : CGRect = self.frame
        aRect.size.height -= keyboardSize!.height
        if let activeFieldPresent = activeField {
            _ = (activeFieldPresent.superview as? UIStackView)?.convert((activeFieldPresent.superview as? UIStackView)?.frame.origin ?? CGPoint.zero, to: nil) ?? CGPoint.zero
            if (aRect.contains(activeField!.frame.origin)) {
                bottomAnchorView.constant = 10.0
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
            self.bottomAnchorView.constant = 10.0
        }
        self.endEditing(true)
    }

    // MARK: - Action Methods
    @IBAction func onClickBtnLeft(_ sender: Any) {
        if self.onClickLeftButton != nil {
            self.animationForHideAView(alertView) {
                self.onClickLeftButton!();
            }
        }
    }

    @IBAction func btnResendCodeOtpMsgTapped(_ sender: Any) {
        self.lblResendOtpMsg.text = "\("TXT_RESEND_CODE_IN".localized) 00:00"
        if !self.isForgotPasswordOtp {
            self.wsGetOtpVerify()
        } else {
            self.wsForgetPassword()
        }
    }

    @IBAction func onClickBtnRight(_ sender: Any) {
        if self.onClickRightButton != nil {
            if !isForVerifyOtp && btnRight.titleLabel?.text != "TXT_RESEND".localizedUppercase && self.lblTitle.text != "TXT_RESET_PWD".localized {
                self.onClickRightButton!(editTextOne.text ?? "",editTextTwo.text ?? "")
            } else if isForVerifyOtp && btnRight.titleLabel?.text == "TXT_RESEND".localizedUppercase {
                self.onClickRightButton!(editTextOne.text ?? "",editTextTwo.text ?? "")
            } else if !isForVerifyOtp && self.lblTitle.text == "TXT_RESET_PWD".localized {
                if editTextOne.text != editTextTwo.text{
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

    public override func removeFromSuperview() {
        super.removeFromSuperview()
    }

    //MARK: - WS Methods
    func wsGetOtpVerify() {
        Utility.showLoading()
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_OTP_VERIFICATION, methodName: AlamofireHelper.POST_METHOD, paramData: param) {(response, error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true) {
                self.timerLeft = RESEND_TIME
                self.lblResendOtpMsg.isHidden = false
                self.btnResendCodeOtpMsg.isHidden = true
                self.startTimer()
            }
        }
    }

    func wsForgetPassword() {
        Utility.showLoading()
        let alamoFire:AlamofireHelper = AlamofireHelper()
        alamoFire.getResponseFromURL(url: WebService.WS_FORGET_PASSWORD, methodName: AlamofireHelper.POST_METHOD, paramData: param) {(response, error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true) {
                self.timerLeft = RESEND_TIME
                self.lblResendOtpMsg.isHidden = false
                self.btnResendCodeOtpMsg.isHidden = true
                self.startTimer()
            }
        }
    }
}
