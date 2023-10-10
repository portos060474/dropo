//
//  TableBookingOrderNowOptionsCell.swift
//  Edelivery
//
//  Created by Elluminati MacPro1 on 21/10/21.
//  Copyright © 2021 Elluminati. All rights reserved.
//

import UIKit

class TableBookingOrderNowOptionsCell: CustomCollectionCell {

    @IBOutlet weak var viewForData: UIView!
    @IBOutlet weak var imgRadioSelection: UIImageView!
    @IBOutlet weak var lblData: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    //MARK:- SET CELL DATA
    func setCellData(text:String) {
        self.lblData.text = text
        self.lblData.textColor = UIColor.themeTextColor
        self.lblData.font = FontHelper.textRegular()
    }

    override func layoutSubviews() {}
}
