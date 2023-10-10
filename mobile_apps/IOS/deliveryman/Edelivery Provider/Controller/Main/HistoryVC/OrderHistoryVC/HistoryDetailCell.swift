//
//  HistoryDetailCell.swift
//  Edelivery Provider
//
//  Created by Elluminati iMac on 04/05/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit

class HistoryDetailCell: CustomTableCell {
   
//MARK: Outlets
    @IBOutlet weak var lblOrderName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblOrderQty: UILabel!

    override func awakeFromNib() {
       
        super.awakeFromNib()
        //Colors
        lblOrderName.textColor = UIColor.themeTextColor
        lblOrderQty.textColor = UIColor.themeViewLightBackgroundColor
        lblPrice.textColor = UIColor.themeTextColor
        /*Font*/
        lblOrderName.font = FontHelper.textRegular()
        lblOrderQty.font = FontHelper.textRegular()
        lblPrice.font = FontHelper.textRegular()
    }

    func setData(itemsData: OrderItem) {
        lblOrderName.text = itemsData.itemName
        lblOrderQty.text = String(itemsData.quantity)
        lblPrice.text = (itemsData.totalItemPrice).toCurrencyString()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}


