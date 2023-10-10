//
//  CustomPhotoDialog.swift
//  edelivery
//
//  Created by Elluminati on 22/02/17.
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
    //MARK:Variables
    var onClickRightButton : ((_ selectedDate:Date) -> Void)? = nil
    var onClickLeftButton : (() -> Void)? = nil
    static let  datePickerDialog = "dialogForDatePicker"
    public static func  showCustomDatePickerDialog
        (title:String,
         titleLeftButton:String,
         titleRightButton:String
         ) ->
        CustomDatePickerDialog
     {
        let view = UINib(nibName: datePickerDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomDatePickerDialog
        view.alertView.setShadow()
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame;
        view.setLocalization()
        view.lblTitle.textColor = UIColor.themeTextColor
        view.lblTitle.text = title;
        view.btnLeft.setTitle(titleLeftButton.uppercased(), for: UIControl.State.normal)
        view.btnRight.setTitle(titleRightButton.uppercased(), for: UIControl.State.normal)
        
        view.btnLeft.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
        view.btnRight.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
        view.datePicker.setValue(UIColor.themeTextColor, forKey: "textColor")
        view.datePicker.datePickerMode = .date
//        view.datePicker.setValue(false, forKey: "highlightsToday")
        if #available(iOS 13.4, *) {
            view.datePicker.preferredDatePickerStyle = .wheels
        }
        
        if #available(iOS 13.0, *){
        }else{
            view.datePicker.setValue(false, forKey: "highlightsToday")
        }
         
        APPDELEGATE.window?.addSubview(view)
        APPDELEGATE.window?.bringSubviewToFront(view);
        
        view.alertView.layoutIfNeeded()
        view.animationBottomTOTop(view.alertView)
        return view;
    }
    
    func setLocalization(){
        lblTitle.textColor = UIColor.themeTextColor
        
        lblTitle.font = FontHelper.textLarge()
        btnLeft.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
        btnRight.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
        
        btnLeft.titleLabel?.font =  FontHelper.textRegular(size:14)
        btnRight.titleLabel?.font =  FontHelper.textRegular(size:14)
        self.backgroundColor = UIColor.themeOverlayColor
        alertView.backgroundColor = .themeAlertViewBackgroundColor
        self.alertView.updateConstraintsIfNeeded()
        self.alertView.roundCorner(corners: [.topRight , .topLeft], withRadius: 20)
        
    }
    
    func setMinDate(mindate:Date) {
    datePicker.minimumDate = mindate
    }
    
    func setMaxDate(maxdate:Date) {
    datePicker.maximumDate = maxdate
    }
    //ActionMethods
    @IBAction func onClickBtnLeft(_ sender: Any) {
        if self.onClickLeftButton != nil {
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut],
                           animations: {
                            self.alertView.frame = CGRect.init(x: self.alertView.frame.origin.x, y: self.frame.height, width: self.alertView.frame.size.width, height: self.alertView.frame.size.height)
                            
            }, completion: { test in
                
                
                self.onClickLeftButton!();
                
            })
            
        }
    }
    @IBAction func onClickBtnRight(_ sender: Any) {
        if self.onClickRightButton != nil {
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut],
                           animations: {
                            self.alertView.frame = CGRect.init(x: self.alertView.frame.origin.x, y: self.frame.height, width: self.alertView.frame.size.width, height: self.alertView.frame.size.height)
                            
            }, completion: { test in
                self.onClickRightButton!(self.datePicker.date)
            })
        }
    }
}


