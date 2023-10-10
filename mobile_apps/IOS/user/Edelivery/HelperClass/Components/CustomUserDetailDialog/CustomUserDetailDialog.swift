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
import IQKeyboardManagerSwift

public class CustomUserDetailDialog: CustomDialog,UITextFieldDelegate {
   //MARK:- OUTLETS
 
    @IBOutlet weak var scrDialog: UIScrollView!
    @IBOutlet weak var stkBtns: UIStackView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtCode: UITextField!
    @IBOutlet weak var txtMobileNo: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtLastname: UITextField!
    @IBOutlet weak var constraintForBottom: NSLayoutConstraint!
      
    //MARK:Variables
    var onClickRightButton : ((_ dailog:CustomUserDetailDialog) -> Void)? = nil
    var onClickLeftButton : (() -> Void)? = nil
    static let addressTitleDailog = "CustomUserDetailDialog"
    var keyboardHeight : CGFloat = 0
    var cartUserDetail: Address? {
        didSet {
            setUserDetail()
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        if currentBooking.isQrCodeScanBooking {
            txtEmail.isHidden = false
            txtLastname.isHidden = false
        } else if Utility.isTableBooking() {
            txtLastname.isHidden = true
        } else {
            txtEmail.isHidden = true
            txtLastname.isHidden = true
        }
    }
    
    public static func showCustomDialog (title:String, titleLeftButton:String, titleRightButton:String) -> CustomUserDetailDialog {
        let view = UINib(nibName: addressTitleDailog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomUserDetailDialog
        view.setLocalization()
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame;
        view.lblTitle.text = title;
        view.btnRight.setTitle(titleRightButton, for: UIControl.State.normal)
        APPDELEGATE.window?.addSubview(view)
        APPDELEGATE.window?.bringSubviewToFront(view);
        view.animationBottomTOTop(view.alertView)
        view.deregisterFromKeyboardNotifications()
        view.registerForKeyboardNotifications()
        return view;
    }
    
    func setLocalization() {
        lblTitle.textColor = UIColor.themeTextColor
        lblTitle.font = FontHelper.textMedium(size: FontHelper.large)

        btnLeft.setTitle("", for: .normal)
        btnLeft.tintColor = .themeColor
        btnLeft.setImage(UIImage.init(named: "cancelIcon")?.imageWithColor(color: UIColor.themeColor), for: .normal)
        self.backgroundColor = UIColor.themeOverlayColor
        self.alertView.backgroundColor = UIColor.themeAlertViewBackgroundColor
        self.alertView.setRound(withBorderColor: .clear, andCornerRadious: 3.0, borderWidth: 1.0)
        self.alertView.updateConstraintsIfNeeded()
        IQKeyboardManager.shared.enable = false
        
        txtName.delegate = self
        txtName.font = FontHelper.textRegular()
        
        txtCode.delegate = self
        txtCode.font = FontHelper.textRegular()
        
        txtMobileNo.delegate = self
        txtMobileNo.font = FontHelper.textRegular()
        
        txtEmail.delegate = self
        txtEmail.font = FontHelper.textRegular()
        
        txtLastname.delegate = self
        txtLastname.font = FontHelper.textRegular()
        
        if currentBooking.isQrCodeScanBooking {
            lblTitle.text = "TXT_USER_DETAILS".localizedUppercase
            txtName.placeholder = "TXT_FIRST_NAME".localizedCapitalized
        } else {
            txtName.placeholder = "TXT_NAME".localizedCapitalized
        }
        txtLastname.placeholder = "TXT_LAST_NAME".localizedCapitalized
        txtCode.placeholder = "txt_code".localizedCapitalized
        txtMobileNo.placeholder = "TXT_MOBILE_NO".localizedCapitalized
        
        txtEmail.placeholder = "TXT_EMAIL".localizedCapitalized
        if Utility.isTableBooking() {
            txtEmail.placeholder = "hint_special_request_note".localizedCapitalized
        }
        
        txtMobileNo.keyboardType = .numberPad
        txtEmail.keyboardType = .emailAddress
    }
    
    func setUserDetail() {
        if let detail = cartUserDetail {
            txtName.text = detail.userDetails?.name
            txtCode.text = detail.userDetails?.countryPhoneCode
            txtMobileNo.text = detail.userDetails?.phone
            txtLastname.text = detail.userDetails?.lastName
            if Utility.isTableBooking() {
                txtEmail.text = detail.note
            } else {
                txtEmail.text = detail.userDetails?.email
            }
            
        }
    }
    
    public override func layoutSubviews() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.alertView.applyTopCornerRadius()
        }
    }
    
    override func updateUIAccordingToTheme() {
        btnLeft.setImage(UIImage.init(named: "cancelIcon")?.imageWithColor(color: UIColor.themeTitleColor), for: .normal)
    }
    
    override func keyboardWasShown(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
            self.constraintForBottom.constant = CGFloat(+keyboardHeight)
            print(self.constraintForBottom.constant)
        }
    }
    
    @objc override func keyboardWillBeHidden(notification: NSNotification)
    {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
            self.constraintForBottom.constant = 0
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
    
    @IBAction func onClickBtnLeft(_ sender: Any) {
        IQKeyboardManager.shared.enable = true
        if self.onClickLeftButton != nil {
            self.onClickLeftButton!();
        }
        self.animationForHideView(alertView) {
            self.removeFromSuperview();
        }
    }
    
    @IBAction func onClickBtnRight(_ sender: Any) {
        if checkValidation() {
            self.onClickRightButton!(self)
        }
    }
    
    func checkValidation() -> Bool {
        if currentBooking.isQrCodeScanBooking {
            return checkQRValidation()
        }
        let validMobileNumber = txtMobileNo.text!.isValidMobileNumber()
        if (txtName.text?.isEmpty())! {
            Utility.showToast(message:"MSG_PLEASE_ENTER_VALID_NAME".localized)
            return false
        } else if validMobileNumber.0 == false && !currentBooking.isQrCodeScanBooking {
            Utility.showToast(message:validMobileNumber.1)
            return false
        } else if (txtCode.text?.isEmpty())! && !currentBooking.isQrCodeScanBooking  {
            Utility.showToast(message:"MSG_TXT_PLEASE_ENTER_VALID_MOBILE_NUMBER".localized)
            return false
        } else {
            return true
        }
    }
    
    func checkQRValidation() -> Bool {
        let validMobileNumber = txtMobileNo.text!.isValidMobileNumber()
        let validEmail = txtEmail.text!.checkEmailValidation()
        
        if (txtName.text?.isEmpty())! {
            Utility.showToast(message: "MSG_PLEASE_ENTER_VALID_NAME".localized)
            return false
        } else if (txtLastname.text?.isEmpty() ?? true) {
            Utility.showToast(message: "MSG_PLEASE_ENTER_VALID_NAME".localized)
            return false
        } else if validMobileNumber.0 == false && txtMobileNo.text!.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 {
            Utility.showToast(message:validMobileNumber.1)
            return false
        } else if validEmail.0 == false && txtEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 {
            Utility.showToast(message: validEmail.1)
            return false
        } else if (txtCode.text?.isEmpty())! && !currentBooking.isQrCodeScanBooking  {
            Utility.showToast(message:"MSG_TXT_PLEASE_ENTER_VALID_MOBILE_NUMBER".localized)
            return false
        } else {
            return true
        }
    }
    
    func dismiss() {
        self.animationForHideView(alertView) {
            self.removeFromSuperview();
        }
    }
    
    deinit {
        deregisterFromKeyboardNotifications()
    }
}
