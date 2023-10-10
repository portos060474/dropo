//
//  historySectionCell.swift
//  // Edelivery Store
//
//  Created by Elluminati iMac on 25/04/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit

class OrderHistorySectionCell: CustomCell {
    
    
    
    @IBOutlet weak var lblSection: CustomPaddingLabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        lblSection.backgroundColor = UIColor.themeSectionBackgroundColor
        lblSection.textColor = UIColor.themeTextColor
        lblSection.font = FontHelper.labelRegular()
        lblSection.paddingLeft = 10
        lblSection.paddingRight = 10
        lblSection.paddingTop  = 8
        lblSection.paddingBottom  = 8
        
    }
    
    func setData(title: String)
         {
        lblSection.text = title.uppercased().appending("     ")
        lblSection.sectionRound(lblSection)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
