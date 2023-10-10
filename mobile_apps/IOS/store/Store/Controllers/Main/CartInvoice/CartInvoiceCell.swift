//
//  HomeCell.swift
// Edelivery Store
//
//  Created by Jaydeep Vyas on 15/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class CartInvoiceCell: CustomCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var viewForInvoiceItem: UIView!
    
    //MARK:- LIFECYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        setLocalization()
    }
    
    //MARK:- SET CELL DATA
    func setCellData(cellItem:Invoice) {
        lblTitle.text = cellItem.title!
        lblSubTitle.text = cellItem.subTitle!
        lblPrice.text = cellItem.price!
        if cellItem.title! == "TXT_TOTAL_SERVICE_PRICE".localized || cellItem.title! == "TXT_TOTAL_ITEM_PRICE".localized {
            lblTitle.textColor = UIColor.themeTextColor
            lblPrice.textColor = UIColor.themeTextColor
            lblTitle.text = cellItem.title!.localizedUppercase
            lblSubTitle.text = cellItem.subTitle!.localizedUppercase
            lblTitle.font =  FontHelper.textMedium()
            lblPrice.font =  FontHelper.textMedium()
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
        viewForInvoiceItem.backgroundColor = UIColor.themeViewBackgroundColor
        
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
    }
}
