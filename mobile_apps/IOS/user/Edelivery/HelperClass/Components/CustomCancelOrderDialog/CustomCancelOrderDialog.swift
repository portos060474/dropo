//
//  CustomPhotoDialog.swift
//  edelivery
//
//  Created by Elluminati on 22/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//



import Foundation
import UIKit
import IQKeyboardManagerSwift



public class CustomCancelOrderDialog:CustomDialog,UITextFieldDelegate {
    //MARK:- OUTLETS
    
    @IBOutlet weak var lblCancellationCharge: UILabel!
    @IBOutlet weak var rbCancelReasonOther: UIButton!
    @IBOutlet weak var rbCancelReasonTwo: UIButton!
    @IBOutlet weak var rbCancelReasonOne: UIButton!
    @IBOutlet weak var rbCancelReasonThree: UIButton!
    @IBOutlet weak var scrDialog: UIScrollView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtCancellationReason: UITextField!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet var alertView: UIView!
    @IBOutlet weak var lblCancellationChargeMessage: UILabel!
    @IBOutlet weak var bottomAnchorView: NSLayoutConstraint!
    
    @IBOutlet weak var tblReason: UITableView!
    @IBOutlet weak var heightTable: NSLayoutConstraint!
    @IBOutlet weak var viewCancelReason: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var activeField: UITextField?
    var selectedIndex = -2
    
    var footerView = UIView()
    
    //MARK:Variables
    var onClickRightButton : ((_ cancelReason:String) -> Void)? = nil
    var onClickLeftButton : (() -> Void)? = nil
    
    static let  cancelDialog = "dialogForCancelOrder"
    var strCancelationReason:String = ""
    var arrReason: [String] = []
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        tblReason.dataSource = self
        tblReason.delegate = self
        tblReason.register(UINib(nibName: "CancelReasonCell", bundle: nil), forCellReuseIdentifier: "CancelReasonCell")
        tblReason.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        IQKeyboardManager.shared.enable = true
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        heightTable.constant = tblReason.contentSize.height
    }
    
    public static func showCustomCancelOrderDialog(title:String, message:String, cancelationCharge:String, titleLeftButton:String, titleRightButton:String, list: [String]) -> CustomCancelOrderDialog {
        let view = UINib(nibName: cancelDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomCancelOrderDialog
        view.alertView.setShadow()
        view.setLocalization()
        let frame = (APPDELEGATE.window?.frame)!
        view.frame = frame
        view.lblTitle.text = title
        view.arrReason = list
        view.setReason()
        view.btnRight.setTitle(titleRightButton/*.uppercased()*/, for: UIControl.State.normal)
        if cancelationCharge.isEmpty {
            view.lblCancellationChargeMessage.isHidden = true
            view.lblCancellationCharge.isHidden = true
        }else {
            view.lblCancellationChargeMessage.isHidden = false
            view.lblCancellationCharge.isHidden = false
            view.lblCancellationCharge.text = cancelationCharge
        }
        
        DispatchQueue.main.async {
            APPDELEGATE.window?.addSubview(view)
            APPDELEGATE.window?.bringSubviewToFront(view)
            view.animationBottomTOTop(view.alertView)
        }
        return view
    }

    //MARK:- Set Localization
    func setLocalization() {
        self.backgroundColor = UIColor.themeOverlayColor
        self.alertView.backgroundColor = UIColor.themeViewBackgroundColor
        lblTitle.textColor = UIColor.themeTextColor
        lblCancellationChargeMessage.text = "TXT_CANCELLATION_CHARGE_APPLY".localized
        txtCancellationReason.placeholder = "TXT_CANCEL_ORDER_REASON".localizedCapitalized
        txtCancellationReason.delegate = self
        rbCancelReasonOne.isSelected = true
        strCancelationReason = rbCancelReasonOne.title(for: UIControl.State.normal)!
        txtCancellationReason.textColor = UIColor.themeTextColor
        
        lblCancellationCharge.textColor = UIColor.themeTextColor
        lblCancellationChargeMessage.textColor = UIColor.themeTextColor
        
        rbCancelReasonOne.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
        rbCancelReasonTwo.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
        rbCancelReasonOther.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
        rbCancelReasonThree.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
        
        rbCancelReasonOne.setTitleColor(UIColor.themeTextColor, for: .selected)
        rbCancelReasonTwo.setTitleColor(UIColor.themeTextColor, for: .selected)
        rbCancelReasonThree.setTitleColor(UIColor.themeTextColor, for: .selected)
        rbCancelReasonOther.setTitleColor(UIColor.themeTextColor, for: .selected)
        
        
        rbCancelReasonOne.setImage(UIImage(named:"radio_btn_unchecked_icon"), for: .normal)
        rbCancelReasonTwo.setImage(UIImage(named:"radio_btn_unchecked_icon"), for: .normal)
        rbCancelReasonOther.setImage(UIImage(named:"radio_btn_unchecked_icon"), for: .normal)
        rbCancelReasonThree.setImage(UIImage(named:"radio_btn_unchecked_icon"), for: .normal)
        
        rbCancelReasonOne.setImage(UIImage(named:"radio_btn_checked_icon")?.imageWithColor(color: UIColor.themeColor), for: .selected)
        rbCancelReasonTwo.setImage(UIImage(named:"radio_btn_checked_icon")?.imageWithColor(color: UIColor.themeColor), for: .selected)
        rbCancelReasonOther.setImage(UIImage(named:"radio_btn_checked_icon")?.imageWithColor(color: UIColor.themeColor), for: .selected)
        
        rbCancelReasonThree.setImage(UIImage(named:"radio_btn_checked_icon")?.imageWithColor(color: UIColor.themeColor), for: .selected)
        
        if UIApplication.isRTL() {
            rbCancelReasonOne.setTitle("\("TXT_CANCEL_ORDER_REASON1".localized)", for: UIControl.State.normal)
            rbCancelReasonTwo.setTitle("\("TXT_CANCEL_ORDER_REASON2".localized )", for: UIControl.State.normal)
            rbCancelReasonOther.setTitle("\("TXT_OTHER".localized)", for: UIControl.State.normal)
            rbCancelReasonThree.setTitle("\("TXT_CANCEL_ORDER_REASON3".localized )", for: UIControl.State.normal)
            rbCancelReasonTwo.contentHorizontalAlignment = .right
            rbCancelReasonOne.contentHorizontalAlignment = .right
            rbCancelReasonOther.contentHorizontalAlignment = .right
            rbCancelReasonThree.contentHorizontalAlignment = .right
        }else{
            rbCancelReasonOne.setTitle("\("TXT_CANCEL_ORDER_REASON1".localized)", for: UIControl.State.normal)
            rbCancelReasonTwo.setTitle("\("TXT_CANCEL_ORDER_REASON2".localized )", for: UIControl.State.normal)
            rbCancelReasonOther.setTitle("\("TXT_OTHER".localized)", for: UIControl.State.normal)
            rbCancelReasonThree.setTitle("\("TXT_CANCEL_ORDER_REASON3".localized )", for: UIControl.State.normal)
        }
        
        /* Set Font */
        rbCancelReasonOne.titleLabel?.font = FontHelper.textRegular(size:FontHelper.labelRegular)
        rbCancelReasonTwo.titleLabel?.font = FontHelper.textRegular(size:FontHelper.labelRegular)
        rbCancelReasonOther.titleLabel?.font = FontHelper.textRegular(size:FontHelper.labelRegular)
        rbCancelReasonThree.titleLabel?.font = FontHelper.textRegular(size:FontHelper.labelRegular)
        rbCancelReasonThree.titleLabel?.numberOfLines = 0
        
        txtCancellationReason.font = FontHelper.textSmall()
        lblTitle.font = FontHelper.textLarge()
        lblCancellationChargeMessage.font = FontHelper.textRegular()
        lblCancellationCharge.font = FontHelper.textMedium()
        
        self.alertView.applyTopCornerRadius()
        
        btnLeft.setImage(UIImage(named:"cancelIcon")?.imageWithColor(color: UIColor.themeColor), for: .normal)
        deregisterFromKeyboardNotifications()
        registerForKeyboardNotifications()
    }
    
    func setReason() {
        if arrReason.count == 0 {
            arrReason.append("TXT_CANCEL_ORDER_REASON1".localized)
            arrReason.append("TXT_CANCEL_ORDER_REASON2".localized)
            arrReason.append("TXT_CANCEL_ORDER_REASON3".localized)
        }
        arrReason.append("TXT_OTHER".localized)
        tblReason.reloadData()
    }
    
    override func updateUIAccordingToTheme() {
        btnLeft.setImage(UIImage(named:"cancelIcon")?.imageWithColor(color: UIColor.themeColor), for: .normal)
    }
    
    //MARK:- TextField Delegate Methods
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        if textField == txtCancellationReason {
            
            textField.resignFirstResponder()
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
    
    //MARK:- ActionMethods
    @IBAction func onClickBtnLeft(_ sender: Any) {
        /* if self.onClickLeftButton != nil {
         self.onClickLeftButton!()
         }*/
        self.animationForHideView(alertView) {
            
            self.removeFromSuperview()
        }
    }
    
    @IBAction func onClickBtnRight(_ sender: Any) {
        if selectedIndex < 0 {
            Utility.showToast(message: "MSG_PLZ_GIVE_VALID_REASON".localized)
        } else if selectedIndex == arrReason.count - 1 && txtCancellationReason.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            Utility.showToast(message: "MSG_PLZ_GIVE_VALID_REASON".localized)
        } else {
            if selectedIndex == arrReason.count - 1 {
                self.onClickRightButton!(txtCancellationReason.text!)
            } else {
                self.onClickRightButton!(strCancelationReason)
            }
        }
    }
    
    @IBAction func onClickRadioButton(_ sender: UIButton) {
        rbCancelReasonOne.isSelected = false
        rbCancelReasonTwo.isSelected = false
        rbCancelReasonOther.isSelected = false
        rbCancelReasonThree.isSelected = false
        sender.isSelected = true
        if  (sender.tag == rbCancelReasonOne.tag) {
            txtCancellationReason.isHidden = true
            strCancelationReason = rbCancelReasonOne.title(for: UIControl.State.normal)!
        }
        else if (sender.tag == rbCancelReasonTwo.tag) {
            txtCancellationReason.isHidden = true
            strCancelationReason = rbCancelReasonTwo.title(for: UIControl.State.normal)!
        }else if (sender.tag == rbCancelReasonThree.tag) {
            txtCancellationReason.isHidden = true
            strCancelationReason = rbCancelReasonThree.title(for: UIControl.State.normal)!
        }
        else {
            txtCancellationReason.isHidden = false
            strCancelationReason = txtCancellationReason.text ?? ""
        }
    }
    
    deinit {
        deregisterFromKeyboardNotifications()
    }
    
    @objc override func keyboardWasShown(notification: NSNotification)
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
                self.bottomAnchorView.constant = 0.0
                UIView.animate(withDuration: 0.5) {
                    DispatchQueue.main.async {
                        self.bottomAnchorView.constant = keyboardSize!.height
                    }
                }
            }
        }
    }
    
    
    @objc override func keyboardWillBeHidden(notification: NSNotification)
    {
        UIView.animate(withDuration: 0.5) {
            self.bottomAnchorView.constant = 0.0
        }
        self.endEditing(true)
    }
}

extension CustomCancelOrderDialog: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrReason.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CancelReasonCell", for: indexPath) as! CancelReasonCell
        if selectedIndex == indexPath.row {
            cell.btnRadio.isSelected = true
        } else {
            cell.btnRadio.isSelected = false
        }
        let obj = arrReason[indexPath.row]
        cell.lblReason.text = obj
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        if indexPath.row == arrReason.count - 1 {
            viewCancelReason.isHidden = false
            tableView.reloadData()
            DispatchQueue.main.async { [unowned self] in
                let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom)
                scrollView.setContentOffset(bottomOffset, animated: true)
            }
        } else {
            strCancelationReason = arrReason[indexPath.row]
            viewCancelReason.isHidden = true
            tableView.reloadData()
        }
    }
}
