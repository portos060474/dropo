//
//  HistoryCell.swift
//  // Edelivery Store
//
//  Created by Elluminati iMac on 25/04/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit

class OrderHistoryCell: CustomCell {
    
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var viewForCanceledOrder: UIView!
    @IBOutlet weak var lblTransparent: UILabel!
    @IBOutlet weak var lblOrderStatus: UILabel!
    
    //    @IBOutlet weak var lblProviderEarning: UILabel!
    
    @IBOutlet weak var lblOrderNo: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewForCanceledOrder.isHidden = true
        /*Set Font*/
        lblName.font = FontHelper.textMedium()
        lblPrice.font = FontHelper.textMedium()
        lblOrderNo.font = FontHelper.textSmall()
        //        lblProviderEarning.font = FontHelper.textSmall()
        lblTime.font = FontHelper.textSmall()
        lblOrderStatus.font = FontHelper.textSmall()
        
        /*Set Color*/
        lblTransparent.backgroundColor = UIColor.themeWhiteTransparentColor
        
        lblName.textColor = UIColor.themeTextColor
        lblPrice.textColor = UIColor.themeTextColor
        lblTime.textColor = UIColor.themeTextColor
        lblOrderNo.textColor = UIColor.themeLightTextColor
        //        lblProviderEarning.textColor = UIColor.themeTextColor
        
        if UIApplication.isRTL(){
            lblOrderStatus.textAlignment = .left
        }else{
            lblOrderStatus.textAlignment = .justified
        }
        
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        imgProfilePic.setRound()
        lblTransparent.setRound()
        
    }
    
    func setHistoryData(dictData: OrderList) {
        lblName.text = dictData.userDetail.firstName + " " + dictData.userDetail.lastName
        lblPrice.text = (dictData.total ?? 0.0).toCurrencyString()
        lblTime.text = Utility.stringToString(strDate: dictData.completedAt!, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.TIME_FORMAT_AM_PM)
        lblOrderNo.text = ("TXT_ORDER_NO".localized + String(dictData.uniqueId)).uppercased()
        imgProfilePic.downloadedFrom(link:dictData.userDetail.imageUrl)
        
        //API changes : HIde Profit label
        //        lblProviderEarning.isHidden = true
        //        lblProviderEarning.text = "TXT_PROFIT".localized + ": " +  dictData.storeProfit.toCurrencyString()
        
        
        if dictData.orderStatus != 25 {
            viewForCanceledOrder.isHidden = false
            lblOrderStatus.text = "TXT_ORDER_CANCELLED".localizedCapitalized
            self.vBG.backgroundColor = .themeViewBackgroundColor
            //vBG.layer.opacity = 0.4
            lblOrderStatus.textColor = UIColor.themeRedColor
        }else {
            viewForCanceledOrder.isHidden = true
            self.vBG.backgroundColor = .themeViewBackgroundColor
            //vBG.layer.opacity = 1.0
            lblOrderStatus.textColor = UIColor.themeGreenColor
            lblOrderStatus.text = ""
        }
        //        lblOrderStatus.text = (OrderStatus(rawValue: dictData.orderStatus) ?? .Unknown).text()
        //        lblOrderStatus.textColor = (OrderStatus(rawValue: dictData.orderStatus) ?? .Unknown).textColor()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        lblTransparent.backgroundColor = UIColor.themeWhiteTransparentColor
        
        // Configure the view for the selected state
    }
    
}
