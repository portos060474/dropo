//
//  AddressCell.swift
//  Edelivery Provider
//
//  Created by MacPro3 on 21/10/22.
//  Copyright © 2022 Elluminati iMac. All rights reserved.
//

import UIKit

class AddressCell: UITableViewCell {
    
    @IBOutlet weak var imgPin: UIImageView!
    @IBOutlet weak var imgRight: UIImageView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        lblAddress.font = FontHelper.textRegular()
        lblAddress.textColor = .themeTextColor
        
        lblDate.font = FontHelper.textRegular(size: FontHelper.labelRegular)
        lblDate.textColor = .themeLightGrayTextColor
        lblDate.isHidden = true
        imgRight.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
