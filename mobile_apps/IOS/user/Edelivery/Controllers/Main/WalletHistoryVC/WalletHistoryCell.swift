//
//  HistoryCell.swift
//  Edelivery Provider
//
//  Created by Elluminati iMac on 25/04/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit

class WalletHistoryCell: CustomTableCell {
    
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
        lblTime.font = FontHelper.textSmall()
        lblRequestId.font = FontHelper.textMedium(size: FontHelper.labelRegular)
        
        /*Set Color*/
        
        lblRequestId.textColor = UIColor.themeTextColor
        lblAmount.textColor = UIColor.themeTextColor
        lblStatus.textColor = UIColor.themeLightTextColor
        lblTime.textColor = UIColor.themeTextColor
        self.walleBackView.backgroundColor = UIColor.themeViewBackgroundColor
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
    }
    
    func setWalletHistoryData(walletRequestData: WalletHistoryItem) {
        lblRequestId.text = "TXT_ID".localized + String(walletRequestData.uniqueId)
        
        let date = Utility.stringToString(strDate: walletRequestData.createdAt, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_TIME_FORMAT_HISTORY)
        lblTime.text = "\(date)"
        let walletHistoryStatus:WalletHistoryStatus = WalletHistoryStatus(rawValue: walletRequestData.walletCommentId) ?? .Unknown
        lblStatus.text = walletHistoryStatus.text()
        switch (walletRequestData.walletStatus) {
        case WalletStatus.ADD_WALLET_AMOUNT: fallthrough
        case WalletStatus.ORDER_REFUND_AMOUNT: fallthrough
        case WalletStatus.ORDER_PROFIT_AMOUNT:
            lblAmount.textColor = UIColor.themeWalletAddedColor
            lblAmount.text = "+"  +  String(walletRequestData.addedWallet) + " " + walletRequestData.toCurrencyCode
            lblDivider.backgroundColor = UIColor.themeWalletAddedColor
            break
        case WalletStatus.REMOVE_WALLET_AMOUNT:fallthrough
        case WalletStatus.ORDER_CHARGE_AMOUNT:fallthrough
        case WalletStatus.ORDER_CANCELLATION_CHARGE_AMOUNT:fallthrough
        case WalletStatus.REQUEST_CHARGE_AMOUNT:
            lblAmount.textColor = UIColor.themeWalletDeductedColor
            lblAmount.text = "-"  +  String(walletRequestData.addedWallet) + " " + walletRequestData.fromCurrencyCode
            lblDivider.backgroundColor = UIColor.themeWalletDeductedColor
            break
        default:
            break
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

final class PaddedLabel: UILabel {
    var padding: UIEdgeInsets?
    
    override func draw(_ rect: CGRect) {
        if let insets = padding {
            self.drawText(in: rect.inset(by: insets))
        } else {
            self.drawText(in: rect)
        }
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            if let insets = padding {
                contentSize.height += insets.top + insets.bottom
                contentSize.width += insets.left + insets.right
            }
            return contentSize
        }
    }
}

@IBDesignable class PaddingLabel: UILabel {

    @IBInspectable var topInset: CGFloat = 0.0
    @IBInspectable var bottomInset: CGFloat = 0.0
    @IBInspectable var leftInset: CGFloat = 10.0
    @IBInspectable var rightInset: CGFloat = 10.0

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }

    override var bounds: CGRect {
        didSet {
            preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
        }
    }
}
