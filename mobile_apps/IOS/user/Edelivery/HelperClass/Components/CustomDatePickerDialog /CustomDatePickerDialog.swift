//
//  CustomPhotoDialog.swift
//  edelivery
//
//  Created by Elluminati on 22/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import UIKit


public class CustomDatePickerDialog:CustomDialog {
   
    //MARK:- OUTLETS
    @IBOutlet weak var stkDialog: UIStackView!
    @IBOutlet weak var stkBtns: UIStackView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
   
    //MARK:Variables
    var onClickRightButton : ((_ selectedDate:Date) -> Void)? = nil
    var onClickLeftButton : (() -> Void)? = nil
    static let  datePickerDialog = "dialogForDatePicker"
    
    public static func showCustomDatePickerDialog (title:String, titleLeftButton:String, titleRightButton:String, mode:UIDatePicker.Mode = .date) -> CustomDatePickerDialog {
        let view = UINib(nibName: datePickerDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomDatePickerDialog
        view.alertView.setShadow()
        view.setLocalization()
        let frame = (APPDELEGATE.window?.frame)!
        view.frame = frame
        view.lblTitle.textColor = UIColor.themeTextColor
        view.lblTitle.text = title
        view.btnRight.setTitle(titleRightButton.uppercased(), for: UIControl.State.normal)
        view.datePicker.setValue(UIColor.themeTitleColor, forKey: "textColor")
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
            APPDELEGATE.window?.bringSubviewToFront(view)
        }
        return view
    }
    
    func setLocalization(){
        self.backgroundColor = UIColor.themeOverlayColor
        lblTitle.textColor = UIColor.themeTextColor
        lblTitle.font = FontHelper.textLarge()
        btnRight.titleLabel?.font =  FontHelper.textRegular()
        self.backgroundColor = UIColor.themeOverlayColor
        self.alertView.backgroundColor = UIColor.themeViewBackgroundColor
        self.alertView.roundCorner(corners: [.topLeft,.topRight], withRadius: 20.0)
        btnLeft.setImage(UIImage(named: "cancelIcon")?.imageWithColor(color: .themeColor), for: .normal)
        btnLeft.tintColor = UIColor.themeColor
    }
    
    public override func layoutSubviews() {

    }
    
    override func updateUIAccordingToTheme() {
        self.setLocalization()
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
            self.onClickLeftButton!()
        }
    }
    
    @IBAction func onClickBtnRight(_ sender: Any) {
        if self.onClickRightButton != nil {
            self.onClickRightButton!(datePicker.date)
        }
    }
}


