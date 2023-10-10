//
//  CancelReasonCell.swift
//  Edelivery
//
//  Created by MacPro3 on 10/03/22.
//  Copyright © 2022 Elluminati. All rights reserved.
//

import UIKit

class CancelReasonCell: UITableViewCell {
    
    @IBOutlet weak var btnRadio: UIButton!
    @IBOutlet weak var lblReason: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        btnRadio.isUserInteractionEnabled  = false
        btnRadio.setImage(UIImage(named:"radio_btn_unchecked_icon"), for: .normal)
        btnRadio.setImage(UIImage(named:"radio_btn_checked_icon"), for: .selected)
        
        lblReason.font = FontHelper.textRegular(size:FontHelper.labelRegular)
        lblReason.textColor = UIColor.themeTextColor
        
        self.selectionStyle = .none
        self.backgroundColor = UIColor.themeViewBackgroundColor
    }

}
