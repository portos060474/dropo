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

public class CustomCancelOrderDialog: CustomDialog,UITextFieldDelegate ,keyboardWasShownDelegate,keyboardWillBeHiddenDelegate{
    //MARK:- OUTLETS
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtCancellationReason: UITextField!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var constraintForBottom: NSLayoutConstraint!
    
    @IBOutlet weak var tblReason: UITableView!
    @IBOutlet weak var heightTable: NSLayoutConstraint!
    @IBOutlet weak var viewCancelReason: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var keyboardHeight : CGFloat = 30.0
    
    //MARK:Variables
    var onClickRightButton : ((_ cancelReason:String) -> Void)? = nil
    var onClickLeftButton : (() -> Void)? = nil
    static let  cancelDialog = "dialogForCancelOrder"
    var strCancelationReason:String = "";
    
    var activeField: UITextField?
    var arrReason: [String] = []
    var selectedIndex = -2
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        tblReason.dataSource = self
        tblReason.delegate = self
        tblReason.register(UINib(nibName: "CancelReasonCell", bundle: nil), forCellReuseIdentifier: "CancelReasonCell")
        tblReason.separatorColor = .clear
        tblReason.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        heightTable.constant = tblReason.contentSize.height
    }
    
    public static func  showCustomCancelOrderDialog(title:String, message:String, list: [String],  titleRightButton:String) -> CustomCancelOrderDialog {
        let view = UINib(nibName: cancelDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomCancelOrderDialog
        view.alertView.setShadow()
        view.setLocalization()
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame;
        view.lblTitle.text = title;
        //view.btnLeft.setTitle(titleLeftButton.uppercased(), for: UIControl.State.normal)
        view.btnRight.setTitle(titleRightButton.uppercased(), for: UIControl.State.normal)

        APPDELEGATE.window?.addSubview(view)
        APPDELEGATE.window?.bringSubviewToFront(view);
        
        view.arrReason = list
        view.setReason()
        
        view.alertView.layoutIfNeeded()
        view.animationBottomTOTop(view.alertView)
        
        view.registerForKeyboardObserver()
        view.delegatekeyboardWasShown = view
        view.delegatekeyboardWillBeHidden = view
        
        return view;
    }
    //MARK:- Set Localization
    
    override func updateUIAccordingToTheme() {
        self.setLocalization()
    }
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
                constraintForBottom.constant = 0.0
                UIView.animate(withDuration: 1.0) {
                    self.constraintForBottom.constant = keyboardSize?.height ?? 0.0
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
            self.constraintForBottom.constant = 0.0
        }
        self.endEditing(true)
    }
    func setLocalization() {
        lblTitle.textColor = UIColor.themeTextColor
        txtCancellationReason.placeholder = "TXT_CANCEL_ORDER_REASON".localizedCapitalized
        txtCancellationReason.delegate = self
        
        //title(for: UIControl.State.normal)!
        txtCancellationReason.textColor  = UIColor.themeTextColor
        
        btnLeft.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
        
        /*
         if UIApplication.isRTL(){
         rbCancelReasonOne.setTitle("    "+"TXT_CANCEL_ORDER_REASON1".localized, for: UIControl.State.normal)
         rbCancelReasonTwo.setTitle("    "+"TXT_CANCEL_ORDER_REASON2".localized, for: UIControl.State.normal)
         rbCancelReasonOther.setTitle("    "+"TXT_OTHER".localized, for: UIControl.State.normal)
         }else{
         rbCancelReasonOne.setTitle("TXT_CANCEL_ORDER_REASON1".localized, for: UIControl.State.normal)
         rbCancelReasonTwo.setTitle("TXT_CANCEL_ORDER_REASON2".localized, for: UIControl.State.normal)
         rbCancelReasonOther.setTitle("TXT_OTHER".localized, for: UIControl.State.normal)
         }*/
        
        btnLeft.titleLabel?.font =  FontHelper.textSmall(size: 14)
        
        txtCancellationReason.font = FontHelper.textSmall(size: 14)
        lblTitle.font = FontHelper.textLarge()
        
        btnLeft.setTitleColor(UIColor.themeIconTintColor, for: .normal)
        btnLeft.tintColor = UIColor.themeIconTintColor
        //btnCancel.setTitle("TXT_DONE".localizedUppercase, for: .normal)
        btnLeft.tintColor = .themeColor
        btnLeft.setTitle("", for: .normal)
        btnLeft.setImage(UIImage.init(named: "close")?.imageWithColor(), for: .normal)
        
        self.backgroundColor = UIColor.themeOverlayColor
        alertView.backgroundColor = .themeAlertViewBackgroundColor
        self.alertView.updateConstraintsIfNeeded()
        self.alertView.roundCorner(corners: [.topRight , .topLeft], withRadius: 20)
    }
    
    func setReason() {
        if arrReason.count == 0 {
            arrReason.append("TXT_CANCEL_ORDER_REASON1".localized)
            arrReason.append("TXT_CANCEL_ORDER_REASON2".localized)
        }
        arrReason.append("TXT_OTHER".localized)
        tblReason.reloadData()
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
    
    //MARK:- ActionMethods
    @IBAction func onClickBtnLeft(_ sender: Any) {
        if self.onClickLeftButton != nil {
            self.animationForHideAView(alertView) {
                self.onClickLeftButton!();
            }
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

