//
//  CustomPhotoDialog.swift
//  edelivery
//
//  Created by Elluminati on 22/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import UIKit


public class CustomConfirmationDialog: CustomDialog, UITextFieldDelegate,keyboardWasShownDelegate,keyboardWillBeHiddenDelegate {
   //MARK:- OUTLETS
    @IBOutlet weak var stkDialog: UIStackView!
    @IBOutlet weak var stkBtns: UIStackView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var editTextOne: UITextField!
    @IBOutlet weak var editTextTwo: UITextField!
    @IBOutlet weak var txtCountryPhoneCode: UITextField!
    @IBOutlet weak var bottomAnchorView: NSLayoutConstraint!

    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var alertView: UIView!
    
    @IBOutlet weak var btnLogout: UIButton!
    //    @IBOutlet weak var lblCountryPhoneCode: UILabel!
    @IBOutlet weak var stkPhoneView: UIStackView!
    //MARK:Variables
    var onClickRightButton : ((_ text1:String , _ text2:String ) -> Void)? = nil
    var onClickLeftButton : (() -> Void)? = nil
    static let  verificationDialog = "dialogForConfirmation"
    var activeField: UITextField?

    public override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    public static func showCustomConfirmationDialog
        (title:String,
         message:String,
         titleLeftButton:String,
         titleRightButton:String,
         editTextOneText:String,
         editTextTwoText:String,
         isEdiTextTwoIsHidden:Bool,
         isEdiTextOneIsHidden:Bool
         ) ->
        CustomConfirmationDialog
     {
        let view = UINib(nibName: verificationDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomConfirmationDialog
        view.alertView.setShadow()
        view.setLocalization()
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame;
        view.lblTitle.text = title;
        view.lblMessage.text = message;
        view.btnLeft.setTitle(titleLeftButton.uppercased(), for: UIControl.State.normal)
         view.btnLogout.setTitle("", for: .normal)
        view.btnRight.setTitle(titleRightButton.uppercased(), for: UIControl.State.normal)
        
        if isEdiTextOneIsHidden {
            view.editTextOne.isHidden = true;
        }else {
            view.editTextOne.isHidden = false;
            view.editTextOne.text = editTextOneText;
            
        }
        if isEdiTextTwoIsHidden {
            view.editTextTwo.text = "";
            view.stkPhoneView.isHidden = true;
//            view.lblCountryPhoneCode.text = "";
            view.txtCountryPhoneCode.text = ""
            
        }else {
            view.editTextTwo.text = editTextTwoText;
            view.stkPhoneView.isHidden = false;
//            view.lblCountryPhoneCode.text = preferenceHelper.getPhoneCountryCode()
            view.txtCountryPhoneCode.text = preferenceHelper.getPhoneCountryCode()
            
            
        }
         
        
        APPDELEGATE.window?.addSubview(view)
        APPDELEGATE.window?.bringSubviewToFront(view);
        view.animationBottomTOTop(view.alertView)
        view.registerForKeyboardObserver()
        view.delegatekeyboardWasShown = view
        view.delegatekeyboardWillBeHidden = view

        return view;
    }
    
    
    func setLocalization() {
//        btnLeft.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
//        btnRight.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
        lblTitle.textColor = UIColor.themeTextColor
        lblMessage.textColor = UIColor.themeTextColor
        editTextOne.textColor = UIColor.themeTextColor
        editTextTwo.textColor = UIColor.themeTextColor
//        btnLeft.titleLabel?.font =  FontHelper.textSmall()
//        btnRight.titleLabel?.font =  FontHelper.textSmall()
        lblTitle.font = FontHelper.textLarge()
        lblMessage.font =  FontHelper.textRegular()
        editTextOne.font =  FontHelper.textRegular()
        editTextTwo.font =  FontHelper.textRegular()
//        lblCountryPhoneCode.font =  FontHelper.textRegular()
        txtCountryPhoneCode.font =  FontHelper.textRegular()

        self.backgroundColor = UIColor.themeOverlayColor
        self.alertView.backgroundColor = UIColor.themeViewBackgroundColor
        self.alertView.setRound(withBorderColor: .clear, andCornerRadious: 3.0, borderWidth: 1.0)
        
    }
    public override func layoutSubviews() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.alertView.applyTopCornerRadius()
        }
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            activeField = textField
            return true
        }
    public func textFieldDidEndEditing(_ textField: UITextField) {
          
            activeField = nil
        }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        if textField == self.editTextOne {
            if editTextTwo.isHidden {
                textField.resignFirstResponder()
            }else {
                editTextTwo.becomeFirstResponder()
            }
        
        }else {
            textField.resignFirstResponder();
        }
        return true
    }
    
    //ActionMethods
    
    
    @IBAction func onClickLogout(_ sender: Any) {
        if self.onClickLeftButton != nil {
            self.onClickLeftButton!();
        }
    }
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
    
    public override func removeFromSuperview() {
        super.removeFromSuperview()
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


