//
//  InvoiceCell.swift
//  Edelivery Provider
//
//  Created by Elluminati iMac on 24/04/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit

class InvoiceCell: CustomTableCell {

//MARK: Outlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        setLocalization()
    }
    
//MARK: Set data
    func setCellData(cellItem:Invoice) {
        lblTitle.text = cellItem.title!
        lblSubTitle.text = cellItem.subTitle!
        lblPrice.text = cellItem.price!
        
        if cellItem.title! == "TXT_TOTAL_SERVICE_PRICE".localized || cellItem.title! == "TXT_TOTAL_ITEM_PRICE".localized || cellItem.title! == "TXT_TIP_AMOUNT".localized{
            lblTitle.textColor = UIColor.themeTextColor
            lblPrice.textColor = UIColor.themeTextColor
            lblTitle.text = cellItem.title!.localizedUppercase
            lblSubTitle.text = cellItem.subTitle!.localizedUppercase
            lblTitle.font = FontHelper.textMedium(size: 14)
            lblPrice.font = FontHelper.textMedium(size: 14)
        }else {
            lblTitle.textColor = UIColor.themeTextColor
            lblPrice.textColor = UIColor.themeTextColor
            lblTitle.text = cellItem.title!.localizedCapitalized
            lblSubTitle.text = cellItem.subTitle!.localized
            lblTitle.font = FontHelper.textRegular()
            lblPrice.font = FontHelper.textRegular()
        }
    }
    
    func setLocalization() {
        //Colors
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        lblTitle.textColor = UIColor.themeTextColor
        lblSubTitle.textColor = UIColor.themeLightTextColor
        lblPrice.textColor = UIColor.themeTextColor
      
        /*Set Font*/
        lblTitle.font =  FontHelper.textRegular()
        lblSubTitle.font =  FontHelper.labelSmall()
        lblPrice.font =  FontHelper.textRegular()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
