//
//  ProductCollectionCell.swift
//  Edelivery
//
//  Created by Soft Eaven on 3/26/20.
//  Copyright © 2020 Elluminati. All rights reserved.
//

import UIKit
import MarqueeLabel

class ProductCollectionCell: UICollectionViewCell {

//MARK:- OUTLET
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var viewForImage: UIView!

    //MARK:- LIFECYCLE
    override func awakeFromNib() {
        
        viewForImage.setRound(withBorderColor: UIColor.clear, andCornerRadious: 3.0, borderWidth: 0.5)

    }
}


class ProductHeaderCollectionCell: UICollectionViewCell {

//MARK:- OUTLET
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductName: MarqueeLabel!
    @IBOutlet weak var viewForImage: UIView!

    //MARK:- LIFECYCLE
    override func awakeFromNib() {
        
        viewForImage.setRound(withBorderColor: UIColor.themeLightLineColor, andCornerRadious: 3.0, borderWidth: 0.5)

    }
}
