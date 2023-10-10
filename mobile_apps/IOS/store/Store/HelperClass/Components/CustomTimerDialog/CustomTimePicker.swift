//
//  CustomPhotoDialog.swift
// Edelivery Store
//
//  Created by Jaydeep Vyas on 22/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import UIKit


public class CustomTimePicker:CustomDialog {
   //MARK:- OUTLETS
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var lblOpeningTime: UILabel!
    @IBOutlet weak var customTimePicker: UIDatePicker!
    @IBOutlet weak var topView: UIView!

    //MARK:Variables
    
    var onClickRightButton : ((_ selectedTime:Date) -> Void)? = nil
    var onClickLeftButton : (() -> Void)? = nil
    static let  timePickerDialog = "customDialogForTimePicker"
     public static func showCustomTimePickerDialog
        (title:String,
         titleLeftButton:String = "CANCEL",
         titleRightButton:String = "OK",
         openingTime:String = "00:00",
         isOpenTime:Bool = false
         ) ->
        CustomTimePicker
     {
        let view = UINib(nibName: timePickerDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomTimePicker
        view.alertView.setShadow()
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame;
        view.lblTitle.textColor = UIColor.themeTextColor
        view.lblTitle.text = title;
        view.btnLeft.setTitle(titleLeftButton.uppercased(), for: UIControl.State.normal)
        view.btnRight.setTitle(titleRightButton.uppercased(), for: UIControl.State.normal)
        
        view.btnLeft.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
        view.btnRight.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
        view.customTimePicker.datePickerMode = .time
        if #available(iOS 13.4, *) {
            view.customTimePicker.preferredDatePickerStyle = .wheels
        }
        if #available(iOS 13.0, *){
        }else{
            view.customTimePicker.setValue(false, forKey: "highlightsToday")
        }
        if isOpenTime {
            view.lblOpeningTime.isHidden = true;
            
        }else {
            view.lblOpeningTime.text = "TXT_SELECTED_OPEN_TIME".localized + openingTime
            view.lblOpeningTime.isHidden = false;
        }
        view.customTimePicker.setValue(UIColor.themeTextColor, forKey: "textColor")
        view.setLocalization()
        
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
    func setLocalization() {
        lblTitle.textColor = UIColor.themeTextColor
        lblTitle.font = FontHelper.textMedium()
        self.lblOpeningTime.font = FontHelper.textMedium()
        btnLeft.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
        btnRight.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
        btnLeft.titleLabel?.font =  FontHelper.textRegular()
        btnRight.titleLabel?.font =  FontHelper.textRegular()
        
        self.backgroundColor = UIColor.themeOverlayColor
        self.alertView.backgroundColor = UIColor.themeViewBackgroundColor

//        alertView.setRound(withBorderColor: .clear, andCornerRadious: 3.0, borderWidth: 1.0)
    }
    
    //ActionMethods
    func setMinTime(time:Date) {
        customTimePicker.minimumDate = time
    }
    func setMaxTime(time:Date) {
        customTimePicker.maximumDate = time
    }
    @IBAction func onClickBtnLeft(_ sender: Any) {
        if self.onClickLeftButton != nil {
            self.onClickLeftButton!();
        }
        
    }
    @IBAction func onClickBtnRight(_ sender: Any) {

            if self.onClickRightButton != nil {
                
                self.onClickRightButton!(customTimePicker.date);
            }
    }
   
    
}


