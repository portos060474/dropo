//
//  CustomTableBookingDialog.swift
//  Edelivery
//
//  Created by Elluminati on 18/10/21.
//  Copyright © 2021 Elluminati. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class AddAddressDialog: CustomDialog, UITextFieldDelegate {

    //MARK:- OUTLETS
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    
    @IBOutlet weak var txtAddress: CustomTextfield!
    @IBOutlet weak var txtName: CustomTextfield!
    @IBOutlet weak var txtCode: CustomTextfield!
    @IBOutlet weak var txtPhone: CustomTextfield!
    @IBOutlet weak var txtNote: CustomTextfield!
    
    @IBOutlet weak var viewAlert: UIView!
    @IBOutlet weak var bottomAnchorView: NSLayoutConstraint!
    
    var activeField: UITextField?
    
    //MARK:- Variables
    var onClickRightButton : ((_ dialog: AddAddressDialog) -> Void)? = nil
    var onClickAddress : ((_ dialog: AddAddressDialog) -> Void)? = nil
    var onClickLeftButton : (() -> Void)? = nil
    var address: Address? {
        didSet {
            txtAddress.text = address?.address ?? ""
            btnRight.enable(checkValidation())
        }
    }
    var inVC: UIViewController?
    var indexPath: IndexPath?
    
    static let dialog = "AddAddressDialog"

    public static func showCustomAddressDialog(title:String, titleRightButton:String, address: Address?, addInVC: UIViewController? = nil) -> AddAddressDialog {
        let view = UINib(nibName: dialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! AddAddressDialog
        
        if let vc = addInVC {
            vc.view.addSubview(view)
            vc.view.bringSubviewToFront(view)
            view.isHidden = true
            view.inVC = vc
        } else {
            APPDELEGATE.window?.addSubview(view)
            APPDELEGATE.window?.bringSubviewToFront(view)
        }
        
        //let frame = (APPDELEGATE.window?.frame)!
        //view.frame = frame
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: view.superview!.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: view.superview!.bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: view.superview!.leadingAnchor, constant: 0).isActive = true
        view.trailingAnchor.constraint(equalTo: view.superview!.trailingAnchor, constant: 0).isActive = true
        
        view.btnRight.setTitle(titleRightButton, for: .normal)
        view.lblTitle.text = title
        //view.deregisterFromKeyboardNotifications()
        //view.registerForKeyboardNotifications()
        view.address = address
        view.btnRight.enable(view.checkValidation())
        //view.animationBottomTOTop(view.viewAlert)
        view.setLocalization()
        return view
    }

    func setLocalization() {
        btnRight.backgroundColor = UIColor.themeButtonBackgroundColor
        btnRight.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnRight.titleLabel?.font = FontHelper.textMedium()
        lblTitle.textColor = UIColor.themeTextColor
        lblTitle.font = FontHelper.textMedium(size: FontHelper.large)
        btnClose.setImage(UIImage(named: "cancelIcon")?.imageWithColor(color: .themeColor), for: .normal)
        
        txtAddress.placeholder = "TXT_ADDRESS".localized
        txtName.placeholder = "TXT_NAME".localized
        txtCode.placeholder = "txt_code".localized
        txtPhone.placeholder = "TXT_PHONE".localized
        txtNote.placeholder = "TXT_NOTE_TEXT".localized
        
        if indexPath != nil {
            btnRight.setTitle("TXT_UPDATE".localized, for: .normal)
        }
        
        txtAddress.textColor = UIColor.themeTextColor
        txtName.textColor = UIColor.themeTextColor
        txtCode.textColor = UIColor.themeTextColor
        txtPhone.textColor = UIColor.themeTextColor
        txtNote.textColor = UIColor.themeTextColor
        
        txtAddress.font = FontHelper.textRegular()
        txtName.font = FontHelper.textRegular()
        txtCode.font = FontHelper.textRegular()
        txtPhone.font = FontHelper.textRegular()
        txtNote.font = FontHelper.textRegular()
        
        txtPhone.keyboardType = .phonePad
        txtCode.keyboardType = .phonePad
        
        txtAddress.delegate = self
        txtName.delegate = self
        txtCode.delegate = self
        txtPhone.delegate = self
        
        if indexPath == nil {
            txtName.text = preferenceHelper.getFirstName() + " " + preferenceHelper.getLastName()
            txtPhone.text = preferenceHelper.getPhoneNumber()
            txtAddress.text = preferenceHelper.getAddress()
        }
        txtCode.text = preferenceHelper.getPhoneCountryCode()
        txtCode.isUserInteractionEnabled = false
        
        
    }
    
    func checkValidation(isShowToast: Bool = false) -> Bool {
        
        let validMobileNumber = txtPhone.text!.isValidMobileNumber()
        
        if txtAddress.text!.isEmpty {
            Utility.showToast(message: !isShowToast ? "" : "MSG_PLEASE_SELECT_VALID_ADDRESS".localized)
            return false
        } else if address == nil {
            Utility.showToast(message: !isShowToast ? "" : "MSG_PLEASE_SELECT_VALID_ADDRESS".localized)
            return false
        } else if txtName.text!.isEmpty() {
            Utility.showToast(message: !isShowToast ? "" : "MSG_PLEASE_ENTER_VALID_NAME".localized)
            return false
        } else if txtCode.text!.isEmpty() {
            Utility.showToast(message: !isShowToast ? "" : "msg_enter_valid_phone_number".localized)
            return false
        } else if txtPhone.text!.isEmpty() {
            Utility.showToast(message: !isShowToast ? "" : "msg_enter_valid_phone_number".localized)
            return false
        } else if !validMobileNumber.0 {
            Utility.showToast(message: !isShowToast ? "" : "msg_enter_valid_phone_number".localized)
            return false
        } else  {
            if let address = address {
                let userDetail = CartUserDetail(name: txtName.text!, code: txtCode.text!, phone: txtPhone.text!)
                address.userDetails = userDetail
                address.note = txtNote.text!
            }
            return true
        }
    }
    
    func reset() {
        txtAddress.text = ""
        txtName.text = ""
        txtPhone.text = ""
        txtCode.text = ""
        txtNote.text = ""
        address = nil
    }
    
    func show(withAnimation: Bool = true) {
        self.isHidden = false
        self.indexPath = nil
        self.setLocalization()
        self.animationBottomTOTop(self.viewAlert, ignoreNavigation: false, withAnimation: withAnimation)
    }
    
    func showUpdateDialog(withAnimation: Bool = true, indexPath: IndexPath) {
        self.isHidden = false
        self.indexPath = indexPath
        self.setLocalization()
        self.animationBottomTOTop(self.viewAlert, ignoreNavigation: false, withAnimation: withAnimation)
    }
    
    func hide() {
        self.animationForHideView(self.viewAlert) {
            self.isHidden = true
        }
    }

    //MARK: Keyboard Delegates
    @objc override func keyboardWasShown(notification: NSNotification)
    {
        //Need to calculate keyboard exact size due to Apple suggestions
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        UIView.animate(withDuration: 0.5) {
            DispatchQueue.main.async {
                self.bottomAnchorView.constant = keyboardSize!.height
            }
        }
    }
    
    @objc override func keyboardWillBeHidden(notification: NSNotification)
    {
        self.endEditing(true)
        UIView.animate(withDuration: 0.5) {
            DispatchQueue.main.async {
                self.bottomAnchorView.constant = 0.0
            }
        }
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtAddress {
            if onClickAddress != nil {
                onClickAddress!(self)
            }
            return false
        }
        activeField = textField
        return true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }

    //MARK:- Action Methods
    @IBAction func onClickBtnRight(_ sender: Any) {
        if checkValidation() {
            if onClickRightButton != nil {
                onClickRightButton!(self)
            }
        }
    }

    @IBAction func onClickBtnClose(_ sender: Any) {
        if self.onClickLeftButton != nil{
            self.onClickLeftButton!()
        }
        self.animationForHideView(viewAlert) {
            if self.inVC == nil {
                self.removeFromSuperview();
            } else {
                self.hide()
            }
        }
    }

    deinit {
        //deregisterFromKeyboardNotifications()
    }

    func setUpRoundedBordersToContainer(viewContainer: UIView) {
        viewContainer.layer.borderWidth = 1.0
        viewContainer.layer.borderColor = UIColor.themeLightTextColor.cgColor
        viewContainer.applyRoundedCornersWithHeight()
    }

    //MARK:- UITextField Delegate
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
        
    @IBAction func textfieldDidChange(_ sender: UITextField) {
        btnRight.enable(checkValidation())
    }
}
