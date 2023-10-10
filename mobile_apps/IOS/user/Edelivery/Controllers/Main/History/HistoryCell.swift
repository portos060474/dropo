//
//  HistoryCell.swift
//  Edelivery
//
//   Created by Ellumination 25/04/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit

class HistoryCell: CustomTableCell {

    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblService: UILabel!
    @IBOutlet weak var lblOrderNo: UILabel!
    @IBOutlet weak var lblRefundAmount: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblTransparent: UILabel!
    @IBOutlet weak var viewForCanceledOrder: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.setShadow()

        /*Set Font*/
        lblStatus.font = FontHelper.textSmall()
        lblName.font = FontHelper.textMedium()
        lblService.font = FontHelper.textSmall()
        lblOrderNo.font = FontHelper.textMedium(size: FontHelper.medium)
        lblTime.font = FontHelper.textSmall()
        lblRefundAmount.font = FontHelper.textMedium()

        /*Set Color*/
        lblTime.textColor = UIColor.themeLightTextColor
        lblService.textColor = UIColor.themeLightTextColor
        lblStatus.textColor = UIColor.themeLightTextColor
        lblName.textColor = UIColor.themeTitleColor
        lblOrderNo.textColor = UIColor.themeTitleColor
        lblTransparent.backgroundColor = UIColor.themeWhiteTransparentColor
        lblRefundAmount.textColor = UIColor.themeLightTextColor
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        self.mainView.backgroundColor = UIColor.themeViewBackgroundColor
        imgProfilePic.isHidden = true
        lblTransparent.setRound()
    }

    func setHistoryData(dictData: Order_list) {
        if dictData.delivery_type! == DeliveryType.courier {
            lblName.text = dictData.destination_addresses?[0].userDetails?.name ?? "-"
            lblStatus.text = getStringCourierStatus(status: OrderStatus(rawValue: dictData.order_status!) ?? .Unknown)
            lblStatus.textColor = OrderStatus(rawValue: dictData.order_status!)?.textColor(cellItem: dictData)
            lblService.text = "TXT_COURIER".localized
        } else {
            lblName.text = dictData.store_detail?.name ?? ""
            if dictData.store_detail?.image_url != nil {
            }
            let orderStatus:OrderStatus = OrderStatus(rawValue: dictData.order_status!) ?? .Unknown
            lblStatus.text =  orderStatus.textStatus(cellItem: dictData)
            lblStatus.textColor = orderStatus.textColor(cellItem: dictData)
            lblService.text = ""
        }
        lblTime.text = Utility.relativeDateStringForDate(strDate: Utility.stringToString(strDate: dictData.created_at!, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_TIME_FORMAT_HISTORY,locale: "en_US"),dateFormate: DATE_CONSTANT.DATE_TIME_FORMAT_HISTORY) as String
        //lblPrice.text = dictData.currency + " "  + dictData.total!.toString()
        lblOrderNo.text = "TXT_ORDER_NO".localized + "\(dictData.uniqueID!)"

        if dictData.order_status != OrderStatus.DELIVERY_MAN_COMPLETE_DELIVERY.rawValue {
            if dictData.refund_amount != nil {
                if dictData.refund_amount! > 0 {
                    lblRefundAmount.text = "Refund: \(dictData.refund_amount!)"
                } else {
                    lblRefundAmount.text = ""
                }
            } else {
                lblRefundAmount.text = ""
            }
        }
    }

    func getStringCourierStatus(status: OrderStatus) -> String {
        var message: String = ""
        switch (status) {
        case OrderStatus.WAITING_FOR_DELIVERY_MAN,OrderStatus.DELIVERY_MAN_REJECTED,OrderStatus.DELIVERY_MAN_CANCELLED,OrderStatus.NO_DELIVERY_MAN_FOUND:
            message = "MSG_WAIT_FOR_ACCEPT_COURIER".localized
            break
        case OrderStatus.DELIVERY_MAN_ACCEPTED,OrderStatus.DELIVERY_MAN_COMING,OrderStatus.DELIVERY_MAN_ARRIVED:
            message =  "MSG_COURIER_ACCEPTED".localized
            break
        case OrderStatus.DELIVERY_MAN_PICKED_ORDER:
            message = "MSG_DELIVERY_MAN_PICKED_COURIER".localized
            break
        case OrderStatus.DELIVERY_MAN_STARTED_DELIVERY:
            message = "MSG_DELIVERY_MAN_STARTED_DELIVERY_COURIER".localized
            break
        case OrderStatus.DELIVERY_MAN_ARRIVED_AT_DESTINATION:
            message = "MSG_DELIVERY_MAN_ARRIVED_AT_DESTINATION_COURIER".localized
            break
        case OrderStatus.DELIVERY_MAN_COMPLETE_DELIVERY:
            message = "MSG_DELIVERY_MAN_COMPLETE_DELIVERY".localized
            break
        case .CANCELED_BY_USER : return "MSG_CANCELED_BY_USER".localized
        case .STORE_CANCELLED: return "MSG_STORE_CANCELLED".localized
        default:
            message = ""
            break
        }
        return message
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
