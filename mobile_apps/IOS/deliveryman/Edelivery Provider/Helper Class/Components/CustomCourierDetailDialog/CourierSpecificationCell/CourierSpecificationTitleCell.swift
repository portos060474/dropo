//
//  CourierSpecificationTitleCell.swift
//  Edelivery
//
//  Created by Mayur on 07/11/22.
//  Copyright © 2022 Elluminati. All rights reserved.
//

import UIKit

class CourierSpecificationTitleCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        lblTitle.font = FontHelper.textMedium()
        lblTitle.textColor = .themeTextColor
    }
    
    func setData(data: OrderSpecification) {
        lblTitle.text = data.specificationName ?? ""
    }
}
