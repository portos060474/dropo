//
//  TableBookingDateTimeSelectionCell.swift
//  edelivery
//
//  Created by Elluminati on 20/10/21.
//  Copyright © 2021 Elluminati. All rights reserved.
//

import UIKit

class TableBookingDateTimeSelectionCell: CustomTableCell {

    @IBOutlet weak var viewForDateAndTime: UIView!
    @IBOutlet weak var viewForDate: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var viewTextfieldDate: UIView!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var viewDateIcon: UIView!
    @IBOutlet weak var viewForTime: UIView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var viewTextfieldTime: UIView!
    @IBOutlet weak var txtTime: UITextField!
    @IBOutlet weak var viewTimeIcon: UIView!

    var selectedIndex:Int!
    var onItemSelected:((_ index:Int)->Void)? = nil
    var dataSource:[Any] = []

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    //MARK:- SET CELL DATA
    func setCellData(date:String, time:String) {
        self.lblDate.text = "TXT_DATE".localized
        self.lblDate.textColor = UIColor.themeTextColor
        self.lblDate.font = FontHelper.textRegular()
        self.lblTime.text = "TXT_TIME".localized
        self.lblTime.textColor = UIColor.themeTextColor
        self.lblTime.font = FontHelper.textRegular()
        self.viewTextfieldDate.layer.borderColor = UIColor.themeLightBackgroundColor.cgColor
        self.viewTextfieldDate.layer.borderWidth = 1.0
        self.viewTextfieldTime.layer.borderColor = UIColor.themeLightBackgroundColor.cgColor
        self.viewTextfieldTime.layer.borderWidth = 1.0
        self.txtDate.font = FontHelper.textRegular()
        self.txtDate.text = date
        self.txtDate.setLeftPaddingPoints(5)
        self.txtDate.setRightPaddingPoints(5)
        self.txtTime.font = FontHelper.textRegular()
        self.txtTime.text = time
        self.txtTime.setLeftPaddingPoints(5)
        self.txtTime.setRightPaddingPoints(5)
    }
    override func layoutSubviews() {}
}
