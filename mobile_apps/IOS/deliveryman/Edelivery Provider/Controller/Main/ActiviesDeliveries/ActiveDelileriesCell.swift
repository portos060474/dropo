//
//  ActiveDelileriesCell.swift
//  Edelivery Provider
//
//  Created by Elluminati iMac on 21/04/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit


class ActiveDelileriesCell: CustomTableCell {

    @IBOutlet weak var viewForShadow: CustomCardView!
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblOrderNo: UILabel!
    @IBOutlet weak var lblRequestNumber: UILabel!
    @IBOutlet weak var imgContactLess: UIImageView!
    
    @IBOutlet weak var tblAddress: UITableView!
    @IBOutlet weak var heightAddress: NSLayoutConstraint!
    var arrAddress = [Address]()
    
    @IBOutlet weak var stkSourceAddress: UIStackView!
    @IBOutlet weak var stkDestiantionAddress: UIStackView!
    @IBOutlet weak var imageForStorePin : UIImageView!
    @IBOutlet weak var imageForUserPin : UIImageView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblDestinatinAddress: UILabel!
    
    deinit {
        tblAddress.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblName.isHidden = false
        imgProfilePic.applyRoundedCornersWithOutBorder()
        lblName.textColor = UIColor.themeTextColor
        lblStatus.textColor = UIColor.themeViewLightBackgroundColor
        lblOrderNo.textColor = UIColor.themeLightTextColor
        lblRequestNumber.textColor = UIColor.themeTextColor
        //Set Font
        lblStatus.font = FontHelper.textSmall()
        lblDate.font = FontHelper.textRegular()
        lblName.font = FontHelper.textMedium()
        lblOrderNo.font = FontHelper.textSmall(size: 12)
        lblRequestNumber.font = FontHelper.textSmall()
        imgProfilePic.setRound(withBorderColor: .lightGray, andCornerRadious: imgProfilePic.frame.height/2, borderWidth: 0.0)
        lblStatus.textAlignment = .left
        lblDate.textColor = .themeTextColor
        
        tblAddress.isScrollEnabled = false
        tblAddress.isUserInteractionEnabled = false
        
        lblAddress.textColor = UIColor.themeLightGrayTextColor
        lblAddress.font = FontHelper.textSmall()
        
        lblDestinatinAddress.textColor = UIColor.themeLightGrayTextColor
        lblDestinatinAddress.font = FontHelper.textSmall()
    }
    
    func setData(dictData: AvailableOrderCellData) {
        self.imgContactLess.isHidden = !dictData.isAllowContactlessDelivery
        self.imgContactLess.image = UIImage.init(named: "cl_icon_red")?.imageWithColor()
        if isOrderPick(status: dictData.status) {
            lblStatus.textColor = .themeGreenColor
        }
        else {
            lblStatus.textColor = .themeYellowColor
        }
        if  isOrderPicked(status:dictData.status) {
            lblName.text = dictData.userName
            imgProfilePic.downloadedFrom(link: dictData.userImage)
            lblDate.isHidden = true
            lblDestinatinAddress.text = dictData.destinationAddress
            stkSourceAddress.isHidden = true
        }else {
            if dictData.deliveryType == DeliveryType.courier {
                lblName.text = "TXT_COURIER".localized
                imgProfilePic.image = UIImage.init(named: "placeholder")
            }else {
                lblName.text = dictData.storeName
                imgProfilePic.downloadedFrom(link: dictData.storeImage)
            }
            if dictData.estimated_time_for_ready_order.isEmpty() {
                lblDate.isHidden = true
            }else {
                let date:String =  Utility.stringToString(strDate: dictData.estimated_time_for_ready_order, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_TIME_FORMAT)
                lblDate.text = "TXT_PICKUP_ORDER_AT".localized + " - " + date
                lblDate.isHidden = false
            }
            stkSourceAddress.isHidden = false
            lblAddress.text = dictData.sourceAddress
            lblDestinatinAddress.text = dictData.destinationAddress
        }
        lblRequestNumber.text = "TXT_REQUEST_NO".localized + dictData.requestNumber
        lblRequestNumber.isHidden = true
        lblOrderNo.text = "TXT_ORDER_NO".localized + dictData.orderNumber
        lblStatus.text = dictData.status.text()
        lblName.numberOfLines = 2
        
        setTableView(withArr: dictData.arrAddress)
        
        if arrAddress.count > 0 {
            stkSourceAddress.isHidden = true
            stkDestiantionAddress.isHidden = true
            tblAddress.isHidden = false
        } else {
            stkDestiantionAddress.isHidden = false
            tblAddress.isHidden = true
        }
    }
    
    func setTableView(withArr: [Address]) {
        self.arrAddress = withArr
        tblAddress.delegate = self
        tblAddress.dataSource = self
        tblAddress.separatorColor = .clear
        tblAddress.register(cellTypes: [AddressCell.self])
        tblAddress.reloadData()
        
        tblAddress.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        heightAddress.constant = tblAddress.contentSize.height
        tblAddress.layoutIfNeeded()
        self.layoutIfNeeded()
    }
    
    func isOrderPicked(status:OrderStatus) -> Bool {
        switch (status) {

        case OrderStatus.NEW_DELIVERY:fallthrough
        case OrderStatus.DELIVERY_MAN_ACCEPTED:fallthrough
        case OrderStatus.DELIVERY_MAN_REJECTED:fallthrough
        case OrderStatus.DELIVERY_MAN_CANCELLED:fallthrough
        case OrderStatus.DELIVERY_MAN_COMING:fallthrough
        case OrderStatus.DELIVERY_MAN_ARRIVED:return false
        case OrderStatus.DELIVERY_MAN_PICKED_ORDER:fallthrough
        case OrderStatus.DELIVERY_MAN_STARTED_DELIVERY:fallthrough
        case OrderStatus.DELIVERY_MAN_ARRIVED_AT_DESTINATION:
            return true;
        default:
            return false
        }
    }
    func isOrderPick(status:OrderStatus) -> Bool {
        switch (status) {

        case OrderStatus.NEW_DELIVERY:fallthrough
        case OrderStatus.DELIVERY_MAN_ACCEPTED:fallthrough
        case OrderStatus.DELIVERY_MAN_REJECTED:fallthrough
        case OrderStatus.DELIVERY_MAN_CANCELLED:fallthrough
        case OrderStatus.DELIVERY_MAN_COMING:fallthrough
        case OrderStatus.DELIVERY_MAN_ARRIVED:return false
        case OrderStatus.DELIVERY_MAN_PICKED_ORDER:fallthrough
        case OrderStatus.DELIVERY_MAN_STARTED_DELIVERY:fallthrough
        case OrderStatus.DELIVERY_MAN_ARRIVED_AT_DESTINATION:fallthrough
        case OrderStatus.DELIVERY_MAN_COMPLETE_DELIVERY_2:fallthrough
        case OrderStatus.DELIVERY_MAN_COMPLETE_DELIVERY:
            return true;
        default:
            return false
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension ActiveDelileriesCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAddress.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as! AddressCell
        let obj = arrAddress[indexPath.row]
        cell.lblAddress.text = obj.address
        cell.selectionStyle = .none
        cell.imgPin.image = indexPath.row == 0 ? UIImage(named: "store_pin")!.imageWithColor(color: .themeTextColor) : UIImage(named: "user_pin")!
        return cell
    }
}
