//
//  CustomPhotoDialog.swift
//  edelivery
//
//  Created by Elluminati on 22/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import UIKit

public class CustomDateSlotPickerDialog:CustomDialog {
    //MARK:- OUTLETS
    @IBOutlet weak var stkDialog: UIStackView!
    @IBOutlet weak var stkBtns: UIStackView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!

    //MARK:- Variables
    var onClickRightButton : ((_ selectedDate:String, _ selectedDayIndex:Int) -> Void)? = nil
    var onClickLeftButton : (() -> Void)? = nil
    static let  datePickerDialog = "dialogForDateSlotPicker"
    var arrDays = [String]()
    var arrDaysNames = [String]()
    var arrDaysNamesWithYear = [String]()
    var selectedDateStr:String = ""
    var selectedDayIndex:Int = 0
    var reservationMaxDays:Int = 0

    public static func showCustomDatePickerSlotDialog (title:String, titleLeftButton:String, titleRightButton:String, mode:UIDatePicker.Mode = .date, reservationMaxDays:Int = 7) -> CustomDateSlotPickerDialog {
        let view = UINib(nibName: datePickerDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomDateSlotPickerDialog
        view.alertView.setShadow()
        view.reservationMaxDays = reservationMaxDays
        view.setLocalization()
        let frame = (APPDELEGATE.window?.frame)!
        view.frame = frame
        view.lblTitle.textColor = UIColor.themeTextColor
        view.lblTitle.text = title
        view.btnRight.setTitle(titleRightButton, for: UIControl.State.normal)
        DispatchQueue.main.async {
            APPDELEGATE.window?.addSubview(view)
            APPDELEGATE.window?.bringSubviewToFront(view)
        }
        return view
    }

    func setLocalization() {
        self.backgroundColor = UIColor.themeOverlayColor
        lblTitle.textColor = UIColor.themeTextColor
        lblTitle.font = FontHelper.textLarge()
        btnLeft.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
        btnLeft.titleLabel?.font = FontHelper.textSmall()
        btnRight.titleLabel?.font = FontHelper.textRegular()
        self.backgroundColor = UIColor.themeOverlayColor
        self.alertView.backgroundColor = UIColor.themeViewBackgroundColor
        self.alertView.updateConstraintsIfNeeded()
        self.alertView.roundCorner(corners: [.topLeft, .topRight], withRadius: 20.0)
        pickerView.dataSource = self
        pickerView.delegate = self
        getNext7Dates()
        btnLeft.setImage(UIImage(named: "cancelIcon")?.imageWithColor(color: .themeColor), for: .normal)
        btnLeft.tintColor = UIColor.themeColor
    }

    override func updateUIAccordingToTheme() {
        self.setLocalization()
    }

    func getNext7Dates() {
        let cal = Calendar.current
        let date = cal.startOfDay(for: Date())
        var days = [String]()
        var daysWithYear = [String]()

        let dateFormatter = DateFormatter()
        let localeId = arrForLanguages[0].code + "_GB"

        dateFormatter.locale = NSLocale(localeIdentifier: localeId) as Locale
        dateFormatter.dateFormat = DATE_CONSTANT.DATE_FORMATE_SLOT_DATE

        let dateFormatterDay = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: localeId) as Locale
        dateFormatterDay.dateFormat = DATE_CONSTANT.DATE_FORMATE_DAY

        let dateFormatterYear = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: localeId) as Locale
        dateFormatterYear.dateFormat = DATE_CONSTANT.DATE_FORMATE_WITHOUT_TIME

        arrDaysNames.removeAll()
        arrDaysNamesWithYear.removeAll()

        for i in 0 ... reservationMaxDays {
            let newdate = cal.date(byAdding: .day, value: +i, to: date)!
            let str = dateFormatter.string(from: newdate)
            days.append(str)
            daysWithYear.append(dateFormatterYear.string(from: newdate))
            arrDaysNames.append(dateFormatterDay.string(from: newdate))
        }

        arrDays.removeAll()
        arrDays.append(contentsOf: days)
        arrDaysNamesWithYear.append(contentsOf: daysWithYear)
        selectedDateStr = arrDaysNamesWithYear[0]
        selectedDayIndex = Utility.getWeekDayInd(day: arrDaysNames[0])
    }

    //MARK:- Action Methods
    @IBAction func onClickBtnLeft(_ sender: Any) {
        if self.onClickLeftButton != nil {
            self.onClickLeftButton!()
        }
    }

    @IBAction func onClickBtnRight(_ sender: Any) {
        if self.onClickRightButton != nil {
            self.onClickRightButton!(selectedDateStr, selectedDayIndex)
        }
    }
}

extension CustomDateSlotPickerDialog : UIPickerViewDelegate, UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrDays.count
    }

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrDays[row]
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDayIndex = Utility.getWeekDayInd(day: arrDaysNames[row])
        selectedDateStr = arrDaysNamesWithYear[row]
    }
}
