//
//  tableBookCell.swift
//  Edelivery
//
//  Created by Elluminati on 13/10/21.
//  Copyright © 2021 Elluminati. All rights reserved.
//

import UIKit

class TableBookCell: CustomCollectionCell {

    @IBOutlet weak var vwBackground: UIView!
    @IBOutlet weak var newLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        newLabel.textColor = UIColor.themeTextColor
        newLabel.text = "store_filter_book_a_table".localized
        newLabel.font = FontHelper.textRegular()
    }

    override func layoutSubviews() {
        vwBackground.layer.cornerRadius = vwBackground.frame.height/2
        vwBackground.layer.borderWidth = 1.0
        vwBackground.clipsToBounds = true
    }

    func setData(labelTitle: [Any]) {
        newLabel.text = (labelTitle.first as! String)
        if labelTitle[1] as! Bool == true {
            self.vwBackground.layer.backgroundColor = UIColor.themeLightButtonBackgroundColor.cgColor
            self.vwBackground.layer.borderColor = UIColor.themeColor.cgColor
            self.newLabel.textColor = UIColor.themeColor
        } else {
            self.vwBackground.layer.backgroundColor = UIColor.themeViewBackgroundColor.cgColor
            self.vwBackground.layer.borderColor = UIColor.themeLightTextColor.cgColor
            self.newLabel.textColor = UIColor.themeTextColor
        }
    }
}
