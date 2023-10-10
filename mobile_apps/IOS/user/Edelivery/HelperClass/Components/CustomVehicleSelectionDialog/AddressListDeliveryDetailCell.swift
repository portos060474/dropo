//
//  TableViewCell.swift
//  Edelivery
//
//  Created by MacPro3 on 13/10/22.
//  Copyright © 2022 Elluminati. All rights reserved.
//

import UIKit

class AddressListDeliveryDetailCell: UITableViewCell {
    
    @IBOutlet weak var viewAddressNo: UIView!
    @IBOutlet weak var lblAddresNo: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUserPhone: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblAddress: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        viewAddressNo.setRound()
        viewAddressNo.backgroundColor = .themeColor
        lblAddresNo.textColor = .white
        
        lblUserName.textColor = .themeTextColor
        lblUserPhone.textColor = .themeTextColor
        lblAddress.textColor = .themeTextColor
        lblDateTime.textColor = .themeLightGrayColor
        
        lblUserName.font = FontHelper.textMedium(size: FontHelper.regular)
        lblUserPhone.font = FontHelper.textRegular(size: FontHelper.regular)
        lblAddress.font = FontHelper.textRegular(size: FontHelper.regular)
        lblDateTime.font = FontHelper.textRegular(size: FontHelper.labelRegular)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
