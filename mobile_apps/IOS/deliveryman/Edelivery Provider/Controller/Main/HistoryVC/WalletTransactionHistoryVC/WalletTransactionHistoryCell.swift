//
//  HistoryCell.swift
//  Edelivery Provider
//
//  Created by Elluminati iMac on 25/04/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit

class WalletTransactionHistoryCell: CustomTableCell {
   
//MARK: Outlets
    @IBOutlet weak var btnCancelWalletRequest: UIButton!
    @IBOutlet weak var lblRequestId: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var imgRequestType: UIImageView!
    @IBOutlet weak var viewForCanceledOrder: UIView!
    @IBOutlet weak var lblTransparent: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        viewForCanceledOrder.isHidden = true
        
        /*Set Font*/
        lblAmount.font = FontHelper.textMedium()
        lblStatus.font = FontHelper.textRegular()
        lblTime.font = FontHelper.textRegular()
        lblRequestId.font = FontHelper.textMedium(size: FontHelper.medium)
        
        /*Set Color*/
        lblTransparent.backgroundColor = UIColor.themeViewLightBackgroundColor
        lblRequestId.textColor = UIColor.themeTextColor
        lblAmount.textColor = UIColor.themeTextColor
        lblStatus.textColor = UIColor.themeLightTextColor
        lblTime.textColor = UIColor.themeLightTextColor
        viewForCanceledOrder.isHidden = true
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        lblTransparent.setRound()
        imgRequestType.setRound()
        btnCancelWalletRequest.setTitle("TXT_CANCEL_WALLET_REQUEST".localizedUppercase, for: .normal)
        btnCancelWalletRequest.setTitleColor(UIColor.themeRedColor, for: .normal)
        btnCancelWalletRequest.titleLabel?.font = FontHelper.textRegular(size:  12)
    }
    
    func setWalletHistoryData(walletRequestData: WalletRequestDetail) {
        lblRequestId.text = "TXT_ID".localized + String(walletRequestData.uniqueId)
        lblTime.text = Utility.stringToString(strDate: walletRequestData.createdAt, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_TIME_FORMAT_AM_PM)
        let walletRequestStatus:WalletRequestStatus = WalletRequestStatus(rawValue: walletRequestData.walletStatus) ?? .Unknown;
        if  walletRequestStatus == WalletRequestStatus.TRANSFERED || walletRequestStatus == WalletRequestStatus.COMPLETED {
            lblAmount.text =  (walletRequestData.approvedRequstedWalletAmount).toString() + " " + walletRequestData.walletCurrencyCode
        }else {
            lblAmount.text =  (walletRequestData.requstedWalletAmount).toString() + " " + walletRequestData.walletCurrencyCode
        }
        if walletRequestData.isPaymentModeCash {
            imgRequestType.image = UIImage.init(named: "wallet_cash")
        }else {
            imgRequestType.image = UIImage.init(named: "wallet_bank")
        }
        if walletRequestStatus == WalletRequestStatus.CANCELLED || walletRequestStatus == WalletRequestStatus.TRANSFERED || walletRequestStatus == WalletRequestStatus.COMPLETED {
            if walletRequestStatus == WalletRequestStatus.CANCELLED {
                viewForCanceledOrder.isHidden = false
            }else {
                viewForCanceledOrder.isHidden = true
            }
            btnCancelWalletRequest.isHidden = true
        }else {
            viewForCanceledOrder.isHidden = true
            btnCancelWalletRequest.isHidden = false
        }
        lblStatus.text = walletRequestStatus.text()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        lblTransparent.backgroundColor = UIColor.themeViewLightBackgroundColor
        // Configure the view for the selected state
    }
}
