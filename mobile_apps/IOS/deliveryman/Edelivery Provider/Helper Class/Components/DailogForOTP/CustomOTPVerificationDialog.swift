//
//  CustomOTPVerificationDialog.swift
//  Provider OOS
//
//  Created by Mac Pro 2 on 10/03/21.
//  Copyright © 2021 Elluminati iMac. All rights reserved.
//

import Foundation

class CustomOTPVerificationDialog:CustomDialog,UITextFieldDelegate,keyboardWasShownDelegate,keyboardWillBeHiddenDelegate{
 
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnCancle: UIButton!
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var otpView: VPMOTPView!
    @IBOutlet weak var bottomAnchorView: NSLayoutConstraint!
    
    @IBOutlet weak var editTextResendOne: UITextField!
    @IBOutlet weak var editTextResendTwo: UITextField!
    @IBOutlet weak var editTextResendThree: UITextField!
    @IBOutlet weak var editTextResendFour: UITextField!
    @IBOutlet weak var editTextResendFive: UITextField!
    @IBOutlet weak var editTextResendSix: UITextField!

    var onClickOkButton : ((_ text:String) -> Void)? = nil
    var onClickCancleButton : (() -> Void)? = nil
    var enteredOtp: String = ""
    var activeField: UITextField?
    
    static let  dialogNibName = "dialogForOTPVerification"
    public override func awakeFromNib() {
        super.awakeFromNib()}
    
    //MARK: ACTION METHODS
    
    @IBAction func onClickBtnCancel(_ sender: Any) {
        
        if self.onClickCancleButton != nil{
            self.onClickCancleButton!()
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut],
                       animations: {
                        self.alertView.frame = CGRect.init(x: self.alertView.frame.origin.x, y: self.frame.height, width: self.alertView.frame.size.width, height: self.alertView.frame.size.height)
                        
                       }, completion: { test in
                        
                        self.removeFromSuperview()
                       })
    }
    
    
    @IBAction func onCliclBtnOk(_ sender: CustomBottomButton) {
        if self.onClickOkButton != nil {
            enteredOtp = "\(editTextResendOne.text!)\(editTextResendTwo.text!)\(editTextResendThree.text!)\(editTextResendFour.text!)\(editTextResendFive.text!)\(editTextResendSix.text!)"
            self.onClickOkButton!(enteredOtp)
            
        }
    }
    
    //MARK: FUNCTION TO SHOW OTP DIALOG
    
    public static func showCustomOTPVerificationDialog
    (title:String,
     message:String,
     titleLeftButton:String,
     titleRightButton:String
    ) ->
    CustomOTPVerificationDialog
    {
        let view = UINib(nibName: dialogNibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomOTPVerificationDialog
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame;
        view.lblTitle.text = title;
        view.lblMessage.text = message;
        view.setLocalization()
        
        APPDELEGATE.window?.addSubview(view)
        APPDELEGATE.window?.bringSubviewToFront(view)
        
        view.btnOk.setTitle(titleRightButton.uppercased(), for: UIControl.State.normal)
        view.otpView.otpFieldsCount = 6
        view.otpView.otpFieldBorderWidth = 0.5
        view.otpView.otpFieldDefaultBorderColor = UIColor.themeTextColor
        view.otpView.delegate = view
        view.otpView.otpFieldDisplayType = .square
        view.otpView.otpFieldSeparatorSpace = 10
        view.otpView.otpFieldSize = 35
        view.otpView.cursorColor = UIColor.themeTextColor
        view.otpView.otpFieldEnteredBorderColor = UIColor.themeTextColor
        
        
        // Create the UI
        
        view.otpView.initializeUI()
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
    
    //MARK: SET LOCALIZED FOR UI
    
    func setLocalization(){
        
        /* Set Color */
        
        lblTitle.textColor = UIColor.themeTextColor
        lblMessage.textColor = UIColor.themeLightTextColor
        
        /* Set Font */
        
        lblTitle.font = FontHelper.textLarge()
        lblMessage.font =  FontHelper.textRegular()
        btnCancle.setImage(UIImage.init(named: "close")?.imageWithColor(), for: .normal)
        self.backgroundColor = UIColor.themeOverlayColor
        self.alertView.backgroundColor = UIColor.themeAlertViewBackgroundColor
        self.alertView.updateConstraintsIfNeeded()
        self.alertView.roundCorner(corners: [.topRight , .topLeft], withRadius: 20)
        
        editTextResendOne.delegate = self
        editTextResendTwo.delegate = self
        editTextResendThree.delegate = self
        editTextResendFour.delegate = self
        editTextResendFive.delegate = self
        editTextResendSix.delegate = self
        
        editTextResendOne.textAlignment = .center
        editTextResendTwo.textAlignment = .center
        editTextResendThree.textAlignment = .center
        editTextResendFour.textAlignment = .center
        editTextResendFive.textAlignment = .center
        editTextResendSix.textAlignment = .center
        
        editTextResendOne.layer.borderWidth = 0.5
        editTextResendTwo.layer.borderWidth = 0.5
        editTextResendThree.layer.borderWidth = 0.5
        editTextResendFour.layer.borderWidth = 0.5
        editTextResendFive.layer.borderWidth = 0.5
        editTextResendSix.layer.borderWidth = 0.5
               
        editTextResendOne.layer.borderColor = UIColor.themeTextColor.cgColor
        editTextResendTwo.layer.borderColor = UIColor.themeTextColor.cgColor
        editTextResendThree.layer.borderColor = UIColor.themeTextColor.cgColor
        editTextResendFour.layer.borderColor = UIColor.themeTextColor.cgColor
        editTextResendFive.layer.borderColor = UIColor.themeTextColor.cgColor
        editTextResendSix.layer.borderColor = UIColor.themeTextColor.cgColor
         
        editTextResendOne.font = FontHelper.textRegular(size: 20.0)
        editTextResendTwo.font = FontHelper.textRegular(size: 20.0)
        editTextResendThree.font = FontHelper.textRegular(size: 20.0)
        editTextResendFour.font = FontHelper.textRegular(size: 20.0)
        editTextResendFive.font = FontHelper.textRegular(size: 20.0)
        editTextResendSix.font = FontHelper.textRegular(size: 20.0)
         
        editTextResendOne.tintColor = UIColor.themeTextColor
        editTextResendTwo.tintColor = UIColor.themeTextColor
        editTextResendThree.tintColor = UIColor.themeTextColor
        editTextResendFour.tintColor = UIColor.themeTextColor
        editTextResendFive.tintColor = UIColor.themeTextColor
        editTextResendSix.tintColor = UIColor.themeTextColor
         
    
    }
    
    public override func removeFromSuperview() {
        super.removeFromSuperview()
        
    }
    
    //MARK: TEXTFIELDS DELEGATE METHODS
   public func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        if textField == editTextResendOne {
            textField.resignFirstResponder()
            editTextResendTwo.becomeFirstResponder()
        }else if textField == editTextResendTwo {
            textField.resignFirstResponder()
            editTextResendThree.becomeFirstResponder()
        }else if textField == editTextResendThree {
            textField.resignFirstResponder()
            editTextResendFour.becomeFirstResponder()
        }else if textField == editTextResendFour {
            textField.resignFirstResponder()
            editTextResendFour.becomeFirstResponder()
        }else if textField == editTextResendFive {
            textField.resignFirstResponder()
            editTextResendFour.becomeFirstResponder()
        }
        else if textField == editTextResendSix {
                textField.resignFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if textField == self.editTextResendOne || textField == self.editTextResendTwo || textField == self.editTextResendThree || textField == self.editTextResendFour || textField == self.editTextResendFive || textField == self.editTextResendSix {
    
        if (string.count == 1){
            if textField == editTextResendOne {
                editTextResendTwo?.becomeFirstResponder()
            }
            if textField == editTextResendTwo {
                editTextResendThree?.becomeFirstResponder()
            }
            if textField == editTextResendThree {
                editTextResendFour?.becomeFirstResponder()
            }
            if textField == editTextResendFour {
                editTextResendFive?.becomeFirstResponder()
                textField.text? = string
                 
            }
            if textField == editTextResendFive {
                editTextResendSix?.becomeFirstResponder()
                textField.text? = string
                 
            }
            if textField == editTextResendSix {
                editTextResendSix?.resignFirstResponder()
                textField.text? = string
                 
            }
            textField.text? = string
            return false
        }else{
            if textField == editTextResendOne {
                editTextResendOne?.becomeFirstResponder()
            }
            if textField == editTextResendTwo {
                editTextResendOne?.becomeFirstResponder()
            }
            if textField == editTextResendThree {
                editTextResendTwo?.becomeFirstResponder()
            }
            if textField == editTextResendFour {
                editTextResendThree?.becomeFirstResponder()
            }
            if textField == editTextResendFive {
                editTextResendFour?.becomeFirstResponder()
            }
            if textField == editTextResendSix {
                editTextResendFive?.becomeFirstResponder()
            }
            textField.text? = string
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
                bottomAnchorView.constant = 0.0
                UIView.animate(withDuration: 1.0) {
                    self.bottomAnchorView.constant = keyboardSize!.height
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
            self.bottomAnchorView.constant = 0.0
        }
        self.endEditing(true)
    }
    
    
}

extension CustomOTPVerificationDialog: VPMOTPViewDelegate {
    
    //MARK: VPMOTPVIEW DELEGATE METHODS
    
    func hasEnteredAllOTP(hasEntered: Bool) -> Bool {
        print("Has entered all OTP? \(hasEntered)")
        
        return enteredOtp == "12345"
    }
    
    func shouldBecomeFirstResponderForOTP(otpFieldIndex index: Int, textfield:UITextField) -> Bool {
        self.activeField = textfield
        return true
    }
    
    func enteredOTP(otpString: String) {
        enteredOtp = otpString
        print("OTPString: \(otpString)")
    }
}







