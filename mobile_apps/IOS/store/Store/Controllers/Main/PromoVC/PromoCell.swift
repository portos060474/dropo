//
//  ProductCell.swift
//  Store
//
//  Created by Jaydeep Vyas on 20/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class PromoCodeCell: CustomCell {
    
    @IBOutlet weak var lblPromoCodeName: UILabel!
    @IBOutlet weak var lblPromoPrice: UILabel!
    @IBOutlet weak var lblPromoDetails: UILabel!
    @IBOutlet weak var imgPromo: UIImageView!
    @IBOutlet weak var lblIsPromoActive: UILabel!
    @IBOutlet weak var swIsPromoActive: UISwitch!
    @IBOutlet weak var txtStartDate: UITextField!
    @IBOutlet weak var txtExpireDate: UITextField!
    @IBOutlet weak var viewForDate: UIView!
    @IBOutlet weak var viewForDateHeight: NSLayoutConstraint!

    @IBOutlet weak var stkDate: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.lblPromoCodeName.textColor = UIColor.themeTextColor
        self.lblPromoPrice.textColor = UIColor.themeTextColor
        self.lblIsPromoActive.textColor = UIColor.themeTextColor
        self.txtExpireDate.textColor = UIColor.themeTextColor
        self.txtStartDate.textColor = UIColor.themeTextColor
        self.lblPromoDetails.textColor = UIColor.themeTextColor
        
        
        self.lblPromoCodeName.font = FontHelper.textMedium()
        self.lblPromoPrice.font = FontHelper.textMedium()
        self.lblIsPromoActive.font = FontHelper.textSmall()
        self.txtExpireDate.font = FontHelper.textSmall()
        self.txtStartDate.font = FontHelper.textSmall()
        self.lblPromoDetails.font = FontHelper.tiny()
        
        self.txtStartDate.placeholder = "TXT_START_DATE".localizedCapitalized
        self.txtExpireDate.placeholder = "TXT_EXPIRE_DATE".localizedCapitalized



        self.imgPromo.setRound(withBorderColor: .clear, andCornerRadious: 8.0, borderWidth: 1.0)
        
        self.swIsPromoActive.onTintColor = .themeColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellData(promoCode:PromoCodeItem) {
       lblPromoCodeName.text =  promoCode.promoCodeName
       lblPromoDetails.text = promoCode.promoDetails
       swIsPromoActive.isOn = promoCode.isActive
        if swIsPromoActive.isOn {
            lblIsPromoActive.text = "TXT_ACTIVE".localizedCapitalized
        }else {
            lblIsPromoActive.text = "TXT_EXPIRED".localizedCapitalized
        }
        
       if promoCode.promoCodeType == PromoCodeType.PERCENTAGE
       {
        lblPromoPrice.text = String(promoCode.promoCodeValue) + " " + "%"
       }
       else
       {
        lblPromoPrice.text = promoCode.promoCodeValue.toCurrencyString()
       }
        
        if promoCode.isPromoHaveDate{
             txtExpireDate.text = Utility.stringToString(strDate: promoCode.promoExpireDate, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_FORMAT)
             txtStartDate.text = Utility.stringToString(strDate: promoCode.promoStartDate, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_FORMAT)
            stkDate.isHidden = false
            viewForDate.isHidden = false
            viewForDateHeight.constant = 35
           
        }else {
            stkDate.isHidden = true
            viewForDate.isHidden = true
            viewForDateHeight.constant = 0
        }
        
         
    }
  
}

