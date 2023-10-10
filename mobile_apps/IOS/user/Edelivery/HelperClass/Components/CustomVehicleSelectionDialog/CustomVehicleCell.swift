//
//  HomeCell.swift
// SRC Store
//
//  Created by Jaydeep Vyas on 15/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class CustomVehicleCell: CustomCollectionCell {
   
    @IBOutlet var imgCar: UIImageView!
    @IBOutlet var lblVehicleName: UILabel!
    @IBOutlet var selectorView: UIView!
   
    //MARK:- LIFECYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        setLocalization()
    }
    
    //MARK:- setLocationzation
    func setLocalization() {
        lblVehicleName.textColor = UIColor.themeTextColor
        lblVehicleName.font
       = FontHelper.labelRegular()
        selectorView.backgroundColor = UIColor.themeSectionBackgroundColor
    }

    //MARK:- SET CELL DATA
    func setCellData(cellItem:VehicleDetail) {
        imgCar.downloadedFrom(link: Utility.getDynamicResizeImageURL(width: imgCar.frame.width, height: imgCar.frame.height, imgUrl: cellItem.imageUrl),isFromResize: true)
        lblVehicleName.text = cellItem.vehicleName
        selectorView.isHidden = !cellItem.isSelected
    }
}
