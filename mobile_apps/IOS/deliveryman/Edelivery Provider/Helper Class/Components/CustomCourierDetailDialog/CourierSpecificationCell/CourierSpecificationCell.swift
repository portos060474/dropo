//
//  CourierSpecificationCell.swift
//  Edelivery
//
//  Created by Mayur on 07/11/22.
//  Copyright © 2022 Elluminati. All rights reserved.
//

import UIKit

class CourierSpecificationCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblName.font = FontHelper.textSmall()
        lblQty.font = FontHelper.textSmall()
        lblPrice.font = FontHelper.textSmall()
        
        lblName.textColor = .themeTextColor
        lblQty.textColor = .themeTextColor
        lblPrice.textColor = .themeTextColor
    }
    
    
    func setData(data: OrderListItem) {
        lblName.text = data.name ?? ""
        
        if data.quantity > 1 {
            lblQty.text = "x \(data.quantity)"
        } else{
            lblQty.text = ""
        }
        
        if (data.price ?? 0) > 0 {
            lblPrice.text = (data.price ?? 0).toCurrencyString()
        } else {
            lblPrice.text = ""
        }
    }
    
}
