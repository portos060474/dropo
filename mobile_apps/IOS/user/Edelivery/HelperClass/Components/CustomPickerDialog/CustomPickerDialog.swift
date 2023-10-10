//
//  CustomPhotoDialog.swift
//  edelivery
//
//  Created by Elluminati on 22/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import UIKit


public class CustomPickerDialog:CustomDialog {
   //MARK:- OUTLETS
    @IBOutlet weak var stkDialog: UIStackView!
    @IBOutlet weak var stkBtns: UIStackView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!

    //MARK:Variables
    var onClickRightButton : ((_ selectedPeoples:Int) -> Void)? = nil
    var onClickLeftButton : (() -> Void)? = nil
    static let datePickerDialog = "dialogForPicker"
    var arrTimeSlots = [String]()
    var numberOfPeoples = [Int]()
    var selectedPeoples:Int = 0
    var isPeople:Bool = false
    var dataSource:[Any] = []

    static func showCustomPickerDialog (title:String, titleLeftButton:String, titleRightButton:String, dataSource:[Any] = [], isPeople:Bool = false) -> CustomPickerDialog {
        let view = UINib(nibName: datePickerDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomPickerDialog
        view.alertView.setShadow()
        view.dataSource = dataSource
        view.isPeople = isPeople
        view.setLocalization()
        let frame = (APPDELEGATE.window?.frame)!
        view.frame = frame
        view.lblTitle.textColor = UIColor.themeTextColor
        view.lblTitle.text = title
        view.btnRight.setTitle(titleRightButton/*.uppercased()*/, for: UIControl.State.normal)
        view.alertView.roundCorner(corners: [.topLeft,.topRight], withRadius: 20.0)
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
        btnRight.titleLabel?.font =  FontHelper.textRegular()
        self.backgroundColor = UIColor.themeOverlayColor
        self.alertView.backgroundColor = UIColor.themeViewBackgroundColor
        self.alertView.setRound(withBorderColor: .clear, andCornerRadious: 3.0, borderWidth: 1.0)

        if self.isPeople {
            for number in 1...10 {
                dataSource.append(number)
            }
            selectedPeoples = dataSource[0] as! Int
        }

        btnLeft.setImage(UIImage(named: "cancelIcon")?.imageWithColor(color: .themeColor), for: .normal)
        btnLeft.tintColor = UIColor.themeColor
        pickerView.dataSource = self
        pickerView.delegate = self
    }

    public override func layoutSubviews() {}

    @objc func closeDialog() {
        self.removeFromSuperview()
    }

    //MARK:- Action Methods
    @IBAction func onClickBtnLeft(_ sender: Any) {
        if self.onClickLeftButton != nil {
            self.onClickLeftButton!()
        }
    }

    @IBAction func onClickBtnRight(_ sender: Any) {
        if self.onClickRightButton != nil {
            self.onClickRightButton!(selectedPeoples)
        }
    }
}

extension CustomPickerDialog : UIPickerViewDelegate, UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if dataSource is [Table_list] {
            return String((dataSource[row] as! Table_list).table_no ?? 0)
        } else {
            return String(dataSource[row] as! Int)
        }
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if dataSource is [Table_list] {
            selectedPeoples = row
        } else {
            selectedPeoples = dataSource[row] as! Int
        }
    }
}
