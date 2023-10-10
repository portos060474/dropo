//
//  CurrentOrderCell.swift
//  edelivery
//
//  Created by Elluminati on 15/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class CurrentOrderCell: CustomTableCell {
    
    @IBOutlet weak var imgOrder: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblService: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblOrderNo: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.setShadow()
        mainView.backgroundColor = UIColor.themeViewBackgroundColor
        lblStatus.textColor = UIColor.themeSectionBackgroundColor
        lblOrderNo.textColor = UIColor.themeTitleColor
        lblDate.textColor = UIColor.themeLightTextColor
        lblService.textColor = UIColor.themeLightTextColor
        lblName.textColor = UIColor.themeTitleColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        self.backgroundColor = UIColor.themeViewBackgroundColor
        /*Set Font*/
        lblDate.font = FontHelper.textSmall()
        lblName.font = FontHelper.textMedium()
        lblService.font = FontHelper.textSmall()
        lblStatus.font = FontHelper.textSmall()
        lblOrderNo.font = FontHelper.textMedium()
    }

    //MARK:- SET CELL DATA
    func setCellData(cellItem:Order) {
        if cellItem.delivery_type! == DeliveryType.courier {
            lblName.text = cellItem.destination_addresses?[0].userDetails?.name ?? "-"
            lblStatus.text = getStringCourierStatus(status: OrderStatus(rawValue: cellItem.delivery_status!) ?? .Unknown)
            lblStatus.textColor = getStringCourierStatusColor(status: OrderStatus(rawValue: cellItem.delivery_status!) ?? .Unknown)
            lblService.text = "TXT_COURIER".localized
        } else {
            let orderStatus:OrderStatus =
                (cellItem.order_status! > cellItem.delivery_status!) ? OrderStatus(rawValue: cellItem.order_status!) ?? .Unknown : OrderStatus(rawValue: cellItem.delivery_status!) ?? .Unknown
            lblStatus.text = orderStatus.text(cellItem: cellItem)
            lblName.text = cellItem.store_name ?? ""
            lblStatus.textColor = orderStatus.textColor(cellItem: cellItem)
            lblService.text = ""
        }
        lblOrderNo.text = "TXT_ORDER_NO".localized + "\(cellItem.unique_id!)"
        lblDate.text = Utility.relativeDateStringForDate(strDate: Utility.stringToString(strDate: cellItem.created_at!, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_TIME_FORMAT_HISTORY,locale: "en_US"),dateFormate: DATE_CONSTANT.DATE_TIME_FORMAT_HISTORY) as String
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
        default:
            message = ""
        break
    }
    return message
    }
    func getStringCourierStatusColor(status: OrderStatus) -> UIColor {
        
        switch (status) {
            
        case OrderStatus.WAITING_FOR_ACCEPT_STORE,OrderStatus.WAITING_FOR_DELIVERY_MAN,OrderStatus.NO_DELIVERY_MAN_FOUND,OrderStatus.CANCELED_BY_USER,OrderStatus.STORE_REJECTED,OrderStatus.STORE_CANCELLED,OrderStatus.STORE_CANCELLED_REQUEST:
            return .themeStatusString1
            
        case OrderStatus.STORE_ACCEPTED,OrderStatus.DELIVERY_MAN_ACCEPTED,OrderStatus.DELIVERY_MAN_CANCELLED:
            return .themeStatusString2
            
        case OrderStatus.STORE_PREPARING_ORDER,OrderStatus.DELIVERY_MAN_COMING,OrderStatus.DELIVERY_MAN_ARRIVED,OrderStatus.DELIVERY_MAN_PICKED_ORDER,OrderStatus.DELIVERY_MAN_COMPLETE_DELIVERY:
            return .themeStatusString3
            
        case OrderStatus.ORDER_READY,OrderStatus.DELIVERY_MAN_STARTED_DELIVERY:
            return .themeStatusString4
            
        case OrderStatus.DELIVERY_MAN_ARRIVED_AT_DESTINATION:
            return .themeStatusString4
            
        default:
            return .themeStatusString1
            
        }
        
    }
}
