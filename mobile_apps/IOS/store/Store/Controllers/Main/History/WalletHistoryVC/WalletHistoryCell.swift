//
//  HistoryCell.swift
//  // Edelivery Store
//
//  Created by Elluminati iMac on 25/04/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit

class WalletHistoryCell: CustomCell {

    @IBOutlet weak var lblDivider: UILabel!
    @IBOutlet weak var walleBackView: UIView!
    
    @IBOutlet weak var lblRequestId: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        /*Set Font*/
         lblAmount.font = FontHelper.textMedium()
        lblStatus.font = FontHelper.textRegular()
        lblTime.font = FontHelper.textRegular(size: FontHelper.small)
        lblRequestId.font = FontHelper.textMedium(size: FontHelper.medium)
        
        
        /*Set Color*/
        
        lblRequestId.textColor = UIColor.themeTextColor
        lblAmount.textColor = UIColor.themeTextColor
        lblStatus.textColor = UIColor.themeLightTextColor
        lblTime.textColor = UIColor.themeLightTextColor
        
        self.walleBackView.backgroundColor = UIColor.themeWalletBGColor
        
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
    }

    func setWalletHistoryData(walletRequestData: WalletHistoryItem) {
        lblRequestId.text = "TXT_ID".localized + String(walletRequestData.uniqueId)
        
        
        lblTime.text = Utility.stringToString(strDate: walletRequestData.createdAt, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_TIME_FORMAT_AM_PM)
     
        let walletHistoryStatus:WalletHistoryStatus = WalletHistoryStatus(rawValue: walletRequestData.walletCommentId) ?? .Unknown;
        
        lblStatus.text = walletHistoryStatus.text()
        switch (walletRequestData.walletStatus) {
        case WalletStatus.ADD_WALLET_AMOUNT:
            lblAmount.textColor = UIColor.themeWalletAddedColor
            lblAmount.text = "+"  +  (walletRequestData.addedWallet).toString() + " " + walletRequestData.toCurrencyCode
            lblDivider.backgroundColor = UIColor.themeWalletAddedColor
            break;
        case WalletStatus.REMOVE_WALLET_AMOUNT:
            lblAmount.textColor = UIColor.themeWalletDeductedColor
            lblAmount.text = "-"  +  (walletRequestData.addedWallet).toString() + " " + walletRequestData.fromCurrencyCode
            lblDivider.backgroundColor = UIColor.themeWalletDeductedColor
            break;
         default:
            break;
        }
        
    }
  
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
         
        // Configure the view for the selected state
    }

}
