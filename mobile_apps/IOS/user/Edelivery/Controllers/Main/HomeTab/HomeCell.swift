//
//  HomeCell.swift
//  edelivery
//
//  Created by Elluminati on 15/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
import MarqueeLabel

class DeliveryCell: CustomCollectionCell {

    @IBOutlet weak var lblGradient: UILabel!
    @IBOutlet weak var imgMainDelivery: UIImageView!
    @IBOutlet weak var lblName: MarqueeLabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var viewImgContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Color
        lblGradient.backgroundColor = UIColor.themeGradientColor
        lblName.textColor = UIColor.themeTextColor
        lblName.font = FontHelper.textMedium(size: FontHelper.labelRegular)
        //lblName.adjustsFontSizeToFitWidth = true
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        
    }
    
    //MARK:- SET CELL DATA
    func setCellData(cellItem:DeliveriesItem) {
        lblName.text = cellItem.delivery_name
        imgMainDelivery.contentMode = .scaleAspectFit
        imgMainDelivery.downloadedFrom(link: Utility.getDynamicResizeImageURL(width: imgMainDelivery.frame.width, height: imgMainDelivery.frame.height, imgUrl: cellItem.image_url!),mode: .scaleAspectFit, isFromResize: true)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layoutIfNeeded()
        viewImgContainer.setRound(withBorderColor: UIColor.clear, andCornerRadious: 8.0, borderWidth: 0.5)
    }
}
