//
//  CustomPhotoDialog.swift
// Edelivery Store
//
//  Created by Jaydeep Vyas on 22/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import UIKit

public class CustomVerificationDialog: CustomDialog,UITextFieldDelegate,keyboardWasShownDelegate,keyboardWillBeHiddenDelegate {

    // MARK:- OUTLETS
    @IBOutlet weak var stkDialog: UIStackView!
    @IBOutlet weak var stkBtns: UIStackView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var editTextOne: UITextField!
    @IBOutlet weak var editTextTwo: UITextField!

    @IBOutlet weak var viewForEditTextOne: UIView!
    @IBOutlet weak var btnShowHideEditTextOne: UIButton!
    @IBOutlet weak var viewForEditTextTwo: UIView!
    @IBOutlet weak var btnShowHideEditTextTwo: UIButton!

    @IBOutlet weak var ResendOtpView: UIView!
    @IBOutlet weak var lblResendOtpMsg: UILabel!
    @IBOutlet weak var btnResendCodeOtpMsg: UIButton!
    @IBOutlet weak var heightResendOtpView: NSLayoutConstraint!

    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var bottomAnchorView: NSLayoutConstraint!

    // MARK:- Variables
    var onClickRightButton : ((_ text1:String , _ text2:String ) -> Void)? = nil
    var onClickLeftButton : (() -> Void)? = nil
    static let verificationDialog = "dialogForVerification"
    var activeField: UITextField?
    var isForVerifyOtp:Bool = false
    var params:[String:Any] = [:]
    weak var timer: Timer? = nil

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
     editTextOneInputType:Bool = false,
     editTextTwoInputType:Bool = false,
     isForVerifyOtp:Bool = false,
     params:[String:Any] = [:],
     isLogoutLeftBtn : Bool = false) -> CustomVerificationDialog {

        let view = UINib(nibName: verificationDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomVerificationDialog
        view.alertView.setShadow()
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame;
        view.lblTitle.text = title;
        view.lblMessage.text = message;
        view.setLocalization()
//        view.btnLeft.setTitle(titleLeftButton.uppercased(), for: UIControl.State.normal)
        view.btnRight.setTitle(titleRightButton.uppercased(), for: UIControl.State.normal)
        view.editTextOne.isSecureTextEntry = editTextOneInputType
        view.editTextTwo.isSecureTextEntry = editTextTwoInputType
        view.editTextOne.placeholder = editTextOneHint;
        view.editTextTwo.placeholder = editTextTwoHint;
        view.editTextTwo.isHidden = isEdiTextTwoIsHidden;

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
        APPDELEGATE.window?.bringSubviewToFront(view);
        view.animationBottomTOTop(view.alertView)
        view.endEditing(true)

        view.registerForKeyboardObserver()
        view.delegatekeyboardWasShown = view
        view.delegatekeyboardWillBeHidden = view
        view.isForVerifyOtp = isForVerifyOtp
        view.params = params

        if editTextOneHint == "\("TXT_EMAIL".localized)" {
            view.editTextOne.keyboardType = .emailAddress
        } else if editTextOneHint == "\("TXT_MOBILE_NO".localized)" {
            view.editTextOne.keyboardType = .phonePad
        } else if editTextOneHint == "\("TXT_EMAIL_OTP".localized)" || editTextOneHint == "\("TXT_PHONE_OTP".localized)" {
            view.editTextOne.keyboardType = .numberPad
        } else if editTextOneHint == "TXT_ENTER_CODE".localizedCapitalized {
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

        if isLogoutLeftBtn {
            view.btnLeft.setImage(UIImage(named: "logoutIcon")?.imageWithColor(color: .themeColor), for: .normal)
        } else {
            view.btnLeft.setImage(UIImage(named: "cross")?.imageWithColor(color: .themeColor), for: .normal)
        }

        if isForVerifyOtp {
            view.ResendOtpView.isHidden = false
            view.heightResendOtpView.constant = 34
            view.lblResendOtpMsg.isHidden = false
        } else {
            view.ResendOtpView.isHidden = true
            view.heightResendOtpView.constant = 0
        }
        return view;
    }

    func setLocalization() {
        //        btnLeft.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
        //        btnRight.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
        lblTitle.textColor = UIColor.themeTextColor
        lblMessage.textColor = UIColor.themeLightTextColor
        editTextOne.textColor = UIColor.themeTextColor
        editTextTwo.textColor = UIColor.themeTextColor
        //        btnLeft.titleLabel?.font =  FontHelper.textRegular(size:14)
        //        btnRight.titleLabel?.font =  FontHelper.textRegular(size:14)

        lblTitle.font = FontHelper.textLarge()
        lblMessage.font =  FontHelper.textRegular()
        editTextOne.font =  FontHelper.textRegular()
        editTextTwo.font =  FontHelper.textRegular()

        self.alertView.backgroundColor = UIColor.themeViewBackgroundColor
        self.backgroundColor = UIColor.themeOverlayColor

        lblResendOtpMsg.textColor = UIColor.themeTextColor
        btnResendCodeOtpMsg.setTitleColor(UIColor.themeColor, for: .normal)
        lblResendOtpMsg.font = FontHelper.textRegular()
        btnResendCodeOtpMsg.titleLabel?.font = FontHelper.textRegular()

        updateUIAccordingToTheme()
    }

    public override func layoutSubviews() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.alertView.applyTopCornerRadius()
            //            self.btnRight.applyRoundedCornersWithHeight()
        }
    }

    override func updateUIAccordingToTheme() {
        btnLeft.setImage(UIImage(named: "cross")?.imageWithColor(color: .themeColor), for: .normal)
    }

    // MARK: - UITextField methods
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        return true
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.editTextOne {
            if editTextTwo.isHidden {
                textField.resignFirstResponder()
            } else {
                editTextTwo.becomeFirstResponder()
            }
        } else {
            textField.resignFirstResponder();
        }
        return true
    }

    // MARK: - Action Methods
    @IBAction func onClickBtnLeft(_ sender: Any) {
        if self.onClickLeftButton != nil {
            self.onClickLeftButton!();
        }
    }

    @IBAction func onClickBtnRight(_ sender: Any) {
        if self.onClickRightButton != nil {
            self.onClickRightButton!(editTextOne.text ?? "",editTextTwo.text ?? "")
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

    @IBAction func btnResendCodeOtpMsgTapped(_ sender: Any) {
        lblResendOtpMsg.text = "\("TXT_RESEND_CODE_IN".localized) 00:00"
        self.wsGenerateOtp()
    }

    public override func removeFromSuperview() {
        super.removeFromSuperview()
    }

    // MARK: - Keyboard methods
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
        //Once keyboard disappears, restore original positions
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        var _ : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: -keyboardSize!.height, right: 0.0)
        UIView.animate(withDuration: 1.0) {
            self.bottomAnchorView.constant = 0.0
        }
        self.endEditing(true)
    }

    //MARK: - TIMERS
    var timerLeft:Int = RESEND_TIME

    func startTimer() {
        self.lblResendOtpMsg.text = "\("TXT_RESEND_CODE_IN".localized) " + String.secondsToMinutesSeconds(seconds: self.timerLeft)
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

    //MARK: - WS Method
    func wsGenerateOtp() {
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_GENERATE_OTP, methodName: AlamofireHelper.POST_METHOD, paramData: params) {(response, error) -> (Void) in
            if Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true) {
                self.timerLeft = RESEND_TIME
                self.lblResendOtpMsg.isHidden = false
                self.btnResendCodeOtpMsg.isHidden = true
                self.startTimer()
            }
        }
    }
}
