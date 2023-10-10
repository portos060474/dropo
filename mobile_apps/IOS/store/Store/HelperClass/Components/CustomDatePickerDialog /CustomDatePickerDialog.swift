//
//  CustomPhotoDialog.swift
// Edelivery Store
//
//  Created by Jaydeep Vyas on 22/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import UIKit


public class CustomDatePickerDialog: CustomDialog {
   //MARK:- OUTLETS
    @IBOutlet weak var stkDialog: UIStackView!
    @IBOutlet weak var stkBtns: UIStackView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var topView: UIView!

    //MARK:Variables
    var onClickRightButton : ((_ selectedDate:Date) -> Void)? = nil
    var onClickLeftButton : (() -> Void)? = nil
    static let  datePickerDialog = "dialogForDatePicker"
    
    
    
    public static func showCustomDatePickerDialog
        (title:String,
         titleLeftButton:String,
         titleRightButton:String,
         mode:UIDatePicker.Mode = .date) ->
        CustomDatePickerDialog {
        let view = UINib(nibName: datePickerDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomDatePickerDialog
        view.alertView.setShadow()
        view.setLocalization()
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame;
        view.lblTitle.textColor = UIColor.themeTextColor
        view.lblTitle.text = title;
        view.btnLeft.setTitle(titleLeftButton.uppercased(), for: UIControl.State.normal)
        view.btnRight.setTitle(titleRightButton.uppercased(), for: UIControl.State.normal)
        
        view.btnLeft.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
        view.btnRight.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
        view.datePicker.setValue(UIColor.themeTextColor, forKey: "textColor")
        view.datePicker.datePickerMode = mode
        
        if #available(iOS 13.4, *) {
            view.datePicker.preferredDatePickerStyle = .wheels
        }
        
        if #available(iOS 13.0, *){
        }else{
            view.datePicker.setValue(false, forKey: "highlightsToday")
        }
    
        DispatchQueue.main.async {
            APPDELEGATE.window?.addSubview(view)
            APPDELEGATE.window?.bringSubviewToFront(view);
            view.animationBottomTOTop(view.alertView)
        }
        return view;
    }
    public override func layoutSubviews() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.topView.applyTopCornerRadius()
        }
    }
    
    func setLocalization(){
        lblTitle.textColor = UIColor.themeTextColor
        
        lblTitle.font = FontHelper.textLarge()
        btnLeft.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
        btnRight.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
        
        btnLeft.titleLabel?.font =  FontHelper.textRegular(size:14)
        btnRight.titleLabel?.font =  FontHelper.textRegular(size:14)
        
        self.backgroundColor = UIColor.themeOverlayColor
        self.alertView.backgroundColor = UIColor.themeViewBackgroundColor
//        self.alertView.setRound(withBorderColor: .clear, andCornerRadious: 3.0, borderWidth: 1.0)
    }
    
    func setMinDate(mindate:Date) {
        datePicker.minimumDate = mindate
        datePicker.date = mindate
    }
    func setMaxDate(maxdate:Date) {
        datePicker.maximumDate = maxdate
    }
    
    //ActionMethods
    
    @IBAction func onClickBtnLeft(_ sender: Any) {
        if self.onClickLeftButton != nil {
            self.onClickLeftButton!();
        }
        
    }
    @IBAction func onClickBtnRight(_ sender: Any) {
        if self.onClickRightButton != nil {
            self.onClickRightButton!(datePicker.date)
        }
        
}
}
