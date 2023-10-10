//
//  EasyAmountCell.swift
//  Merchant App
//
//  Created by Elluminati MacPro1 on 01/02/21.
//

import UIKit

class EasyAmountCell: UICollectionViewCell {

    @IBOutlet weak var lblAmount: CustomPaddingLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblAmount.font = FontHelper.textRegular(size: 13.0)
        if #available(iOS 13.0, *) {
            self.lblAmount.textColor = .systemBackground
        } else {
            self.lblAmount.textColor = .white
        }
//        self.lblAmount.layer.cornerRadius = self.lblAmount.frame.size.height/2
        self.lblAmount.textAlignment = .center
        self.lblAmount.setRound(withBorderColor: .themeLightTextColor, andCornerRadious: 14, borderWidth: 1.0)

    }
}
