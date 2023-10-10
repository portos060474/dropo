//
//  CustomPhotoDialog.swift
//  edelivery
//
//  Created by Elluminati on 22/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import UIKit

public class CustomTimeSlotPickerDialog:CustomDialog {
    //MARK:- OUTLETS
    @IBOutlet weak var stkDialog: UIStackView!
    @IBOutlet weak var stkBtns: UIStackView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!

    //MARK:- Variables
    var onClickRightButton : ((_ selectedTimeSlot:String, _ _isStoreClosed:Bool) -> Void)? = nil
    var onClickLeftButton : (() -> Void)? = nil
    static let datePickerDialog = "dialogForTimeSlotPicker"
    var arrTimeSlots = [String]()
    var selectedStoreSlot:StoreTime? = nil
    var selectedTimeStr:String = ""
    var selectedDayInd:Int = 0
    var selectedDateDay:String = ""
    var scheduleTimeInterval:Double = 0
    var isStoreClosed:Bool = false
    var isTableBooking:Bool = false
    var timeZone:TimeZone = TimeZone.init(identifier:"Asia/Kolkata")!
    var isStoreOpen:Bool = false

    static func showCustomTimePickerSlotDialog (title:String,
                                                titleLeftButton:String,
                                                titleRightButton:String,
                                                selectedStoreSlot: StoreTime,
                                                selectedDayInd:Int,
                                                selectedDateDay:String,
                                                scheduleTimeInterval : Double,
                                                timeZone:TimeZone,
                                                isTableBooking:Bool = false) -> CustomTimeSlotPickerDialog {
        let view = UINib(nibName: datePickerDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomTimeSlotPickerDialog
        view.alertView.setShadow()
        view.timeZone = timeZone
        view.isTableBooking = isTableBooking
        view.selectedStoreSlot = selectedStoreSlot
        
        if isTableBooking {
            view.isStoreOpen = view.selectedStoreSlot!.is_booking_open
            view.scheduleTimeInterval = 0
        } else {
            view.isStoreOpen = view.selectedStoreSlot!.isStoreOpen
            view.scheduleTimeInterval = scheduleTimeInterval
        }
        view.selectedDateDay = selectedDateDay
        view.selectedDayInd = selectedDayInd
       
        view.setLocalization()
        let frame = (APPDELEGATE.window?.frame)!
        view.frame = frame
        view.lblTitle.textColor = UIColor.themeTextColor
        view.lblTitle.text = title
//        view.btnLeft.setTitle(titleLeftButton.uppercased(), for: UIControl.State.normal)
        view.btnRight.setTitle(titleRightButton/*.uppercased()*/, for: UIControl.State.normal)
        
//        view.btnLeft.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
//        view.btnRight.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
        view.alertView.roundCorner(corners: [.topLeft,.topRight], withRadius: 20.0)

        DispatchQueue.main.async {
            APPDELEGATE.window?.addSubview(view)
            APPDELEGATE.window?.bringSubviewToFront(view)
        }

        if view.arrTimeSlots.count > 0 {
            view.selectedTimeStr = view.arrTimeSlots[0]
            view.isStoreClosed = false
        } else {
            //view.closeDialog()
            view.isStoreClosed = true
            Utility.showToast(message: "Store is closed")
            if view.onClickRightButton != nil {
                view.onClickRightButton!(view.selectedTimeStr, view.isStoreClosed)
            }
        }
        return view
    }

    func setLocalization() {
        self.backgroundColor = UIColor.themeOverlayColor
        lblTitle.textColor = UIColor.themeTextColor
        lblTitle.font = FontHelper.textLarge()
//        btnLeft.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
//        btnRight.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
        
//        btnLeft.titleLabel?.font =  FontHelper.textSmall()
        btnRight.titleLabel?.font =  FontHelper.textRegular()

        self.backgroundColor = UIColor.themeOverlayColor
        self.alertView.backgroundColor = UIColor.themeViewBackgroundColor
        self.alertView.setRound(withBorderColor: .clear, andCornerRadious: 3.0, borderWidth: 1.0)

        pickerView.dataSource = self
        pickerView.delegate = self

        self.arrTimeSlots.removeAll()

        if isStoreOpen {
            if (selectedStoreSlot?.dayTime.count)! > 0 {
                for obj in selectedStoreSlot!.dayTime {
                    var storeOpenTime:String = ""
                    var storeCloseTime:String = ""
                    if isTableBooking {
                        storeOpenTime = obj.booking_open_time
                        storeCloseTime = obj.booking_close_time
                    } else {
                        storeOpenTime = obj.storeOpenTime
                        storeCloseTime = obj.storeCloseTime
                    }
                    //if selectedDayInd == getSelectedDayInd(day: Utility.dateToString(date: Date(), withFormat: "EEE")) {
                    if selectedDayInd == Utility.getWeekDayInd(day: Utility.dateToString(date: Date(), withFormat: DATE_CONSTANT.DATE_FORMATE_DAY)) &&
                        selectedDateDay == Utility.getDayFromDate(date: Utility.dateToString(date: Date(), withFormat: DATE_CONSTANT.DATE_FORMATE_WITHOUT_TIME)) {
                        if addingTimIntervalAccordingToFlag(openingSlot: storeOpenTime) {
                            self.arrTimeSlots.append("\(storeOpenTime) - \(storeCloseTime)")
                        }
                    } else {
                        self.arrTimeSlots.append("\(storeOpenTime) - \(storeCloseTime)")
                    }
                }
            } else {
                self.arrTimeSlots.removeAll()
                self.arrTimeSlots.append(contentsOf: getFulldayTimeSlots())
                self.pickerView.reloadAllComponents()
            }
        }
        btnLeft.setImage(UIImage(named: "cancelIcon")?.imageWithColor(color: .themeColor), for: .normal)
        btnLeft.tintColor = UIColor.themeColor
    }

    public override func layoutSubviews() {}

    func addingTimIntervalAccordingToFlag(openingSlot: String) -> Bool {
        let dt = Date().addingTimeInterval(scheduleTimeInterval*60)
        return (Utility.stringToDate(strDate: openingSlot, withFormat: DATE_CONSTANT.DATE_FORMATE_TIME).isGreaterThanDate(dateToCompare: Utility.stringToDate(strDate: Utility.dateToString(date: dt, withFormat: DATE_CONSTANT.DATE_FORMATE_TIME, withTimezone: timeZone), withFormat: DATE_CONSTANT.DATE_FORMATE_TIME)))
    }

    @objc func closeDialog() {
        self.removeFromSuperview()
    }

    //MARK:- Fuctions
    func getFulldayTimeSlots() -> [String] {
        var array = [String]()
        let nextHour = 0
        var forLoop = 0
        forLoop = (24 - nextHour-1)
        for index in 0 ... forLoop {
            if selectedDayInd == Utility.getWeekDayInd(day: Utility.dateToString(date: Date(), withFormat: DATE_CONSTANT.DATE_FORMATE_DAY)) &&
                selectedDateDay == Utility.getDayFromDate(date: Utility.dateToString(date: Date(), withFormat: DATE_CONSTANT.DATE_FORMATE_WITHOUT_TIME)) {
                if addingTimIntervalAccordingToFlag(openingSlot: "\(nextHour+index):00") {
                    if nextHour+index+1 == 24{
                        array.append("\(nextHour+index):00 - 00:00")
                    }else{
                        array.append("\(nextHour+index):00 - \(nextHour+index+1):00")
                    }
                }
            } else {
                if nextHour+index+1 == 24{
                    array.append("\(nextHour+index):00 - 00:00")
                }else{
                    array.append("\(nextHour+index):00 - \(nextHour+index+1):00")
                }
            }
        }
        return array
    }

    //MARK:- Action Methods
    @IBAction func onClickBtnLeft(_ sender: Any) {
        if self.onClickLeftButton != nil {
            self.onClickLeftButton!()
        }
    }

    @IBAction func onClickBtnRight(_ sender: Any) {
        if self.onClickRightButton != nil {
            self.onClickRightButton!(selectedTimeStr, isStoreClosed)
        }
    }
}

extension CustomTimeSlotPickerDialog : UIPickerViewDelegate, UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrTimeSlots.count
    }

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrTimeSlots[row]
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if arrTimeSlots.count > 0 {
            selectedTimeStr = arrTimeSlots[row]
        }
    }
}
