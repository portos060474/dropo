//
//  TableBookingSelectionCVCell.swift
//  Edelivery
//
//  Created by Elluminati MacPro1 on 18/10/21.
//  Copyright © 2021 Elluminati. All rights reserved.
//

import UIKit

class TableBookingSelectionCVCell: CustomCollectionCell {

    @IBOutlet weak var viewForData: UIView!
    @IBOutlet weak var lblData: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblData.font = FontHelper.textMedium()
    }
}
