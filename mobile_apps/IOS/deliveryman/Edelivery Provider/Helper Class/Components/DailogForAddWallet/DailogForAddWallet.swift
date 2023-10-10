//
//  DailogForAddWallet.swift
//  Edelivery Provider
//
//  Created by Elluminati on 03/03/21.
//  Copyright © 2021 Elluminati iMac. All rights reserved.
//

import UIKit

class DailogForAddWallet: CustomDialog,UITextFieldDelegate,keyboardWasShownDelegate,keyboardWillBeHiddenDelegate{

    @IBOutlet weak var constraintForBottom: NSLayoutConstraint!

    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCurrency: UILabel!
    @IBOutlet weak var lblAddWallet: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var viewForTextField: UIView!
    @IBOutlet weak var txtAddWallet: UITextField!

    static let  dialogNibName = "dailogForAddWallet"
    var activeField: UITextField?
    var onClickSubmitButton : ((_ value : Double) -> Void)? = nil

    public static func  showCustomAddWalletDialog(tag:Int = 415) -> DailogForAddWallet {

        let view = UINib(nibName: dialogNibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DailogForAddWallet
        view.tag = tag
        view.setupLocalization()

        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame;

        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.addSubview(view)
            APPDELEGATE.window?.bringSubviewToFront(view);
        }

        view.alertView.layoutIfNeeded()
        view.animationBottomTOTop(view.alertView)
        view.registerForKeyboardObserver()
        view.delegatekeyboardWasShown = view
        view.delegatekeyboardWillBeHidden = view
        return view;
    }

    override func updateUIAccordingToTheme() {
        self.setupLocalization()
    }

    func setupLocalization() {

        lblTitle.text = "TXT_ADD_WALLET_BALANCE".localizedCapitalized
        lblTitle.font = FontHelper.textLarge()
        lblTitle.textColor = UIColor.themeTitleColor
        lblAddWallet.text = "TXT_ADD_WALLET".localizedCapitalized
        lblAddWallet.font = FontHelper.textRegular()
        lblAddWallet.textColor = .themeLightTextColor
        
        btnSubmit.setTitle("TXT_SUBMIT".localizedCapitalized, for: .normal)
        lblCurrency.backgroundColor = .themeViewBackgroundColor
        lblCurrency.textColor = .themeTextColor
        lblCurrency.font = FontHelper.textRegular(size: 18)
        btnCancel.setImage(UIImage.init(named: "close")?.imageWithColor(), for: .normal)
        
        txtAddWallet.delegate = self
        btnCancel.setTitleColor(UIColor.themeIconTintColor, for: .normal)
        btnCancel.tintColor = UIColor.themeIconTintColor
        //btnCancel.setTitle("TXT_DONE".localizedUppercase, for: .normal)
        btnCancel.setTitle("", for: .normal)
        btnCancel.setImage(UIImage.init(named: "close")?.imageWithColor(), for: .normal)
        btnCancel.imageView?.contentMode = .scaleAspectFill
        
        self.backgroundColor = .themeOverlayColor
        // lblCurrency.text = Double.getCurrencySign()
        
        txtAddWallet.keyboardType = .numberPad
        
        alertView.backgroundColor = .themeAlertViewBackgroundColor
        self.alertView.updateConstraintsIfNeeded()
        self.alertView.roundCorner(corners: [.topRight , .topLeft], withRadius: 20)
        self.backgroundColor = UIColor.themeOverlayColor
        lblCurrency.contentMode = .bottom
        lblCurrency.sizeToFit()
    }

    override func keyboardWasShown(notification: NSNotification) {

        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        var aRect : CGRect = self.frame
        aRect.size.height -= keyboardSize!.height
        if let activeFieldPresent = activeField {
            _ = (activeFieldPresent.superview as? UIStackView)?.convert((activeFieldPresent.superview as? UIStackView)?.frame.origin ?? CGPoint.zero, to: nil) ?? CGPoint.zero
            if (aRect.contains(activeField!.frame.origin)) {
                constraintForBottom.constant = 0.0
                UIView.animate(withDuration: 1.0) {
                    self.constraintForBottom.constant = keyboardSize?.height ?? 0.0
                }
            }
        }
    }

    override func keyboardWillBeHidden(notification: NSNotification) {

        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        var _ : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: -keyboardSize!.height, right: 0.0)
        
        UIView.animate(withDuration: 1.0) {
            self.constraintForBottom.constant = 10.0
        }
        self.endEditing(true)
    }

    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtAddWallet {
            
            let textFieldString = textField.text! as NSString;
            
            let newString = textFieldString.replacingCharacters(in: range, with:string)
            
            let floatRegEx = "^([0-9]+)?(\\.([0-9]+)?)?$"
            
            let floatExPredicate = NSPredicate(format:"SELF MATCHES %@", floatRegEx)
            
            return floatExPredicate.evaluate(with: newString)
        }
        return true
    }

    @IBAction func onClickBtnSubmit(_ sender: Any) {

        if ((txtAddWallet.text?.doubleValue) != nil) && (txtAddWallet.text?.doubleValue ?? 0.0) > 0.0{
            
            if self.onClickSubmitButton != nil {
                //self.animationForHideAView(alertView) {
                    self.onClickSubmitButton!((self.txtAddWallet.text?.doubleValue)!)
               // }
            }
        } else {
            Utility.showToast(message: "MSG_ENTER_VALID_AMOUNT".localized)
        }
    }

    @IBAction func onClickBtnCancel(_ sender: Any) {
        //self.endEditing(true)
        self.animationForHideAView(alertView) {
            self.removeFromSuperview();
        }
    }
}
