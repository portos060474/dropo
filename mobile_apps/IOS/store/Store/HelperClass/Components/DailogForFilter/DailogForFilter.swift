//
//  DailogForFilter.swift
//  Edelivery Provider
//
//  Created by Elluminati on 26/02/21.
//  Copyright © 2021 Elluminati iMac. All rights reserved.
//

import UIKit

class DailogForFilter: CustomDialog,UITextFieldDelegate  {

    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var lblFrom: UILabel!
    @IBOutlet weak var lblTo: UILabel!
    @IBOutlet weak var ImageForFrom: UIImageView!
    @IBOutlet weak var ImageForTo: UIImageView!
    @IBOutlet weak var txtFrom: UITextField!
    @IBOutlet weak var txtTo: UITextField!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var viewForFrom: UIView!
    @IBOutlet weak var stackViewForFrom: UIStackView!
    @IBOutlet weak var stackViewForTo: UIStackView!

    @IBOutlet weak var vStackViewForFrom: UIView!
    @IBOutlet weak var vStackViewForTo: UIView!

    @IBOutlet weak var viewForTo: UIView!
    var onClickApplyButton : ((_ From:String, _ To:String) -> Void)? = nil
    var onClickResetButton : (() -> Void)? = nil
    var strFromDate = ""
    var strToDate = ""
    static let  dialogNibName = "dailogForFilter"
    
    override func updateUIAccordingToTheme() {
        self.setupLocalization()
    }
    
    func setupLocalization() {
        lblFrom.text = "TXT_FROM".localized
        lblTo.text = "TXT_TO".localized
        
        lblFrom.textColor = UIColor.themeLightTextColor
        lblTo.textColor = UIColor.themeLightTextColor
        btnCancel.setTitleColor(UIColor.themeColor, for: .normal)
         btnCancel.tintColor = UIColor.themeColor
        //btnCancel.setTitle("TXT_DONE".localizedUppercase, for: .normal)
         btnCancel.setTitle("", for: .normal)
        btnCancel.setImage(UIImage.init(named: "cross")?.imageWithColor(color: UIColor.themeColor), for: .normal)
        btnCancel.imageView?.contentMode = .scaleToFill
        lblFrom.font = FontHelper.textRegular()
        lblTo.font = FontHelper.textRegular()
        txtTo.delegate = self
        txtFrom.delegate = self
        lblTitle.text = "TXT_FILTER_HISTORY".localizedCapitalized
        lblTitle.font = FontHelper.textLarge()
        lblTitle.textColor = UIColor.themeTitleColor
        txtTo.font = FontHelper.textRegular()
        txtFrom.font = FontHelper.textRegular()
        btnApply.setTitle("TXT_APPLY".localized, for: .normal)
        btnReset.setTitle("TXT_RESET".localized, for: .normal)
        viewForTo.backgroundColor = .themeViewBackgroundColor
        
        vStackViewForFrom.setRound(withBorderColor: .themeLightTextColor, andCornerRadious: 0.1, borderWidth: 0.3)
        vStackViewForTo.setRound(withBorderColor: .themeLightTextColor, andCornerRadious: 0.1, borderWidth: 0.3)
        
        viewForFrom.backgroundColor = .themeViewBackgroundColor
        alertView.backgroundColor = .themeViewBackgroundColor
        
        self.alertView.updateConstraintsIfNeeded()
//        self.alertView.applyTopCornerRadius()
        self.backgroundColor = UIColor.themeOverlayColor
        ImageForFrom.image = UIImage.init(named: "calendarGray")?.imageWithColor(color: .themeIconTintColor)
        ImageForTo.image = UIImage.init(named: "calendarGray")?.imageWithColor(color: .themeIconTintColor)
    }
    public static func  showCustomFilterDialog(tag:Int = 413) -> DailogForFilter
    {
        let view = UINib(nibName: dialogNibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DailogForFilter
        view.tag = tag
        
       
        view.setupLocalization()
            
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame;
           
        DispatchQueue.main.async{
            UIApplication.shared.keyWindow?.addSubview(view)
            APPDELEGATE.window?.bringSubviewToFront(view);
        }
        
        view.alertView.layoutIfNeeded()
        DispatchQueue.main.async {
            view.animationBottomTOTop(view.alertView)
        }
        return view;
    }
    
    public override func layoutSubviews() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.alertView.applyTopCornerRadius()
        }
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        if textField == txtFrom {
            let datePickerDialog: CustomDatePickerDialog = CustomDatePickerDialog.showCustomDatePickerDialog(title: "TXT_SELECT_FROM_DATE".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_OK".localized)
            datePickerDialog.setMaxDate(maxdate: Date())
            if !strToDate.isEmpty {
                let maxDate = Utility.stringToDate(strDate: strToDate, withFormat: DATE_CONSTANT.DATE_MM_DD_YYYY)
                datePickerDialog.setMaxDate(maxdate: maxDate)
                
            }
            datePickerDialog.onClickLeftButton = { [unowned datePickerDialog] in
                    datePickerDialog.removeFromSuperview()
            }
            
            datePickerDialog.onClickRightButton = { [unowned datePickerDialog, unowned self] (selectedDate:Date) in
                    self.strFromDate = Utility.dateToString(date: selectedDate, withFormat: DATE_CONSTANT.DATE_MM_DD_YYYY)
                self.txtFrom.text = String(format: "%@",self.strFromDate)
                    self.strToDate = self.strFromDate
                    datePickerDialog.removeFromSuperview()
            }
            return false
        }
        else if textField == txtTo {
            if txtFrom.text! == "" {
                Utility.showToast(message: "MSG_INVALID_DATE_WARNING".localized);
            }else {
                let datePickerDialog: CustomDatePickerDialog = CustomDatePickerDialog.showCustomDatePickerDialog(title: "TXT_SELECT_TO_DATE".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_OK".localized)
                let minidate = Utility.stringToDate(strDate: strFromDate, withFormat: DATE_CONSTANT.DATE_MM_DD_YYYY)
                
                datePickerDialog.setMaxDate(maxdate: Date())
                datePickerDialog.setMinDate(mindate: minidate)
                datePickerDialog.onClickLeftButton = { [unowned datePickerDialog] in
                        datePickerDialog.removeFromSuperview()
                }
                
                datePickerDialog.onClickRightButton = { [unowned datePickerDialog, unowned self] (selectedDate:Date) in
                        
                        self.strToDate = Utility.dateToString(date: selectedDate, withFormat: DATE_CONSTANT.DATE_MM_DD_YYYY)
                        self.txtTo.text = String(format: "%@",self.strToDate)
                        datePickerDialog.removeFromSuperview()
                        
                }
                
            }
            return false
        }
        
        return true
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBAction func onClickBtnCancel(_ sender: Any) {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut],
                       animations: {
                        self.alertView.frame = CGRect.init(x: self.alertView.frame.origin.x, y: self.frame.height, width: self.alertView.frame.size.width, height: self.alertView.frame.size.height)
                        
        }, completion: { test in
            
            self.removeFromSuperview()
        })
        
    }
    @IBAction func onClickBtnApply(_ sender: Any) {
        strFromDate = txtFrom.text!
        strToDate = txtTo.text!
        if (strFromDate.isEmpty || strToDate.isEmpty) {
            Utility.showToast(message: "MSG_PLEASE_SELECT_DATE_FIRST".localized);
            
        }else {
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut],
                           animations: {
                            self.alertView.frame = CGRect.init(x: self.alertView.frame.origin.x, y: self.frame.height, width: self.alertView.frame.size.width, height: self.alertView.frame.size.height)
                            
            }, completion: { test in
                
                if self.onClickApplyButton != nil {
                    self.onClickApplyButton!(self.strFromDate  , self.strToDate);
                }
            })
        }
       
        
    }
    @IBAction func onClickBtnReset(_ sender: Any) {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut],
                       animations: {
                        self.alertView.frame = CGRect.init(x: self.alertView.frame.origin.x, y: self.frame.height, width: self.alertView.frame.size.width, height: self.alertView.frame.size.height)
                        
        }, completion: { test in
            
            if self.onClickResetButton != nil {
                self.onClickResetButton!();
            }
        })
        
    }
}
