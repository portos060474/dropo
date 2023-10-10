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

public class CustomAddressTitleDialog: CustomDialog,UITextFieldDelegate {
   //MARK:- OUTLETS
 
    @IBOutlet weak var scrDialog: UIScrollView!
    @IBOutlet weak var stkBtns: UIStackView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var constraintForBottom: NSLayoutConstraint!
  
    //MARK:Variables
    var onClickRightButton : ((_ paymentMethod:String) -> Void)? = nil
    var onClickLeftButton : (() -> Void)? = nil
    static let addressTitleDailog = "CustomAddressTitleDialog"
    var keyboardHeight : CGFloat = 30.0
    
    public static func showCustomAddressTitleDialog (title:String, titleLeftButton:String, titleRightButton:String) -> CustomAddressTitleDialog {
        let view = UINib(nibName: addressTitleDailog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomAddressTitleDialog
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
        
        txtTitle.placeholder = "txt_address_title_placeholder".localized
        
        btnLeft.setTitle("", for: .normal)
        btnLeft.tintColor = .themeColor
        btnLeft.setImage(UIImage.init(named: "cancelIcon")?.imageWithColor(color: UIColor.themeColor), for: .normal)
        self.backgroundColor = UIColor.themeOverlayColor
        self.alertView.backgroundColor = UIColor.themeAlertViewBackgroundColor
        self.alertView.setRound(withBorderColor: .clear, andCornerRadious: 3.0, borderWidth: 1.0)
        self.alertView.updateConstraintsIfNeeded()
        IQKeyboardManager.shared.enable = false
        
        txtTitle.delegate = self
        txtTitle.text = "Other" //Default Value
        txtTitle.font = FontHelper.textRegular()
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
        if (txtTitle.text?.count)! < 1 {
            Utility.showToast(message: "MSG_PLEASE_ENTER_ADDRESSTITLE".localized)
            txtTitle.becomeFirstResponder()
        }
        else {
            self.animationForHideView(alertView) {
                self.removeFromSuperview();
            }
            self.onClickRightButton!(txtTitle.text!)
        }
    }
    
    deinit {
        deregisterFromKeyboardNotifications()
    }
}
