//
//  historySectionCell.swift
//  Edelivery Provider
//
//  Created by Elluminati iMac on 25/04/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit

class historySectionCell: UITableViewCell
{
    
    
    
    @IBOutlet weak var lblSection: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        lblSection.backgroundColor = UIColor.themeSectionBackgroundColor
        lblSection.textColor = UIColor.themeTitleColor
        lblSection.font = FontHelper.regular()
        
        
        
    }
    
    func setData(title: String)
        
    {
        lblSection.text = title.appending("     ")
        lblSection.sectionRound(lblSection)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
