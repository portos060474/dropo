//
//  HistoryCell.swift
//  Edelivery Provider
//
//  Created by Elluminati iMac on 25/04/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit

class HistoryCell: CustomTableCell {

    //MARK: - Outlets
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var viewForCanceledOrder: UIView!
    @IBOutlet weak var lblTransparent: UILabel!
    @IBOutlet weak var lblProviderEarning: UILabel!
    @IBOutlet weak var lblOrderNo: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        viewForCanceledOrder.isHidden = true
        /*Set Font*/
        lblName.font = FontHelper.textMedium()
        lblPrice.font = FontHelper.textMedium()
        lblOrderNo.font = FontHelper.textRegular()
        lblTime.font = FontHelper.textRegular(size: 12)
        lblProviderEarning.font = FontHelper.textSmall()

        /*Set Color*/
        lblTransparent.backgroundColor = UIColor.themeViewLightBackgroundColor
        lblName.textColor = UIColor.themeTextColor
        lblPrice.textColor = UIColor.themeTextColor
        lblTime.textColor = UIColor.themeTextColor
        lblOrderNo.textColor = UIColor.themeLightTextColor
        lblProviderEarning.textColor = UIColor.themeTextColor
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        imgProfilePic.setRound()
        lblTransparent.setRound()
    }

    func setHistoryData(dictData: Order_list) {
        if dictData.delivery_type == DeliveryType.courier {
            lblName.text = "TXT_COURIER".localized
            imgProfilePic.image = UIImage.init(named: "placeholder")
        } else {
            imgProfilePic.downloadedFrom(link:(dictData.user_detail?.image_url)!)
            lblName.text = (dictData.user_detail?.name)!
            print((dictData.user_detail?.name)!)
        }
        lblPrice.text = (dictData.total!).toCurrencyString()
        lblTime.text = Utility.stringToString(strDate: dictData.created_at!, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.TIME_FORMAT_AM_PM)
        lblOrderNo.text = "TXT_REQUEST_NO".localized + "\(dictData.uniqueID!)"
        lblProviderEarning.isHidden = true
        if dictData.order_status != 25 {
            viewForCanceledOrder.isHidden = false
        } else {
            viewForCanceledOrder.isHidden = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        lblTransparent.backgroundColor = UIColor.themeViewLightBackgroundColor
    }
}
