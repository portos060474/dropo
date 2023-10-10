//
//  SpecificationGroupCell.swift
//  Store
//
//  Created by Jaydeep Vyas on 06/03/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class SpecificationCell: CustomCell {

    @IBOutlet weak var lblSpecificationName: UILabel!
    @IBOutlet weak var lblSpecificationPrice: UILabel!
    @IBOutlet weak var btnRemoveSpecification: UIButton!
    
    var isCellSelected:Bool = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        self.lblSpecificationName.textColor = UIColor.themeTextColor
        self.lblSpecificationName.font = FontHelper.labelRegular()
        
        self.lblSpecificationPrice.textColor = UIColor.themeTextColor
        self.lblSpecificationPrice.font = FontHelper.labelRegular()
    }
    
    func setCellData(data:ProductDisplaySpecification) {
        //Storeapp
        
        if data.modifierName != "" && data.modifierGroupName != "" {
            lblSpecificationName.text = "\(data.sequence_number)   \(StoreSingleton.shared.returnStringAccordingtoLanguage(arrStr: data.nameLanguages)) (\(data.modifierGroupName) - \(data.modifierName))"
        } else {
            lblSpecificationName.text = "\(data.sequence_number)   \(StoreSingleton.shared.returnStringAccordingtoLanguage(arrStr: data.nameLanguages))"
        }
        
        if lblSpecificationPrice != nil {
            print(data.name!)
            print(data.price?.toCurrencyString())
            lblSpecificationPrice.text = data.price?.toCurrencyString()
        }
        btnRemoveSpecification.setImage(UIImage(named: "cross")?.imageWithColor(color: .themeColor), for: .selected)
        btnRemoveSpecification.setImage(UIImage(named: "cross")?.imageWithColor(color: .themeColor), for: .normal)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }


}
