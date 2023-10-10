//
//  CustomDialogViewImage.swift
//  Edelivery
//
//  Created by Elluminati on 4/16/21.
//  Copyright © 2021 Elluminati. All rights reserved.
//

import UIKit
import Stripe

class CustomDialogViewDeliveryDetails: CustomDialog {
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblDeliveryTo: UILabel!
    @IBOutlet weak var lblDeliveryAddress: UILabel!
    @IBOutlet weak var tblAddress: UITableView!
    @IBOutlet weak var heightTableAddress: NSLayoutConstraint!
    
    @IBOutlet weak var viewAddress: UIView!
    
    var selectedOrder: Order?
    var orderList: HistoryOrderList?
    var isFromHistory = false
    
    var arrAddress = [Address]()
    var arrTime = [DateTime]()
    
    static let  dialogNibName = "CustomDialogViewDeliveryDetails"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public static func  showCustomDialogDeliveryDetail(title : String ,message: String, selectedOrder: Order?, order: HistoryOrderDetailResponse?, responce: OrderStatusResponse?, isFromHistory: Bool,tag:Int = 4565) -> CustomDialogViewDeliveryDetails
    {
        let view = UINib(nibName: dialogNibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomDialogViewDeliveryDetails
        view.tag = tag
        view.lblTitle.text = title
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame;
        DispatchQueue.main.async{
            UIApplication.shared.keyWindow?.addSubview(view)
            APPDELEGATE.window?.bringSubviewToFront(view);
            view.animationBottomTOTop(view.alertView)
        }
        let arr = isFromHistory ? (order?.order_list?.destination_addresses ?? []) : (responce?.destinationAddresses ?? [])
        view.arrTime = order?.date_time ?? []
        if arr.count > 0 {
            view.tblAddress.isHidden = false
            view.viewAddress.isHidden = true
        } else {
            view.tblAddress.isHidden = true
            view.viewAddress.isHidden = false
        }
        view.arrAddress = arr
        view.selectedOrder = selectedOrder
        view.orderList = order?.order_list
        view.setLocalization()
        return view;
    }
    
    func setLocalization() {
        self.alertView.backgroundColor = UIColor.themeViewBackgroundColor
        self.alertView.updateConstraintsIfNeeded()
        self.alertView.roundCorner(corners: [.topRight , .topLeft], withRadius: 20)
        self.backgroundColor = UIColor.themeOverlayColor
        btnClose.setImage(UIImage(named: "cancelIcon")?.imageWithColor(color: .themeColor), for: .normal)
        
        lblTitle.textColor = UIColor.themeTextColor
        lblTitle.font = FontHelper.textMedium()
        
        lblDeliveryTo.textColor = UIColor.themeTextColor
        lblDeliveryTo.font = FontHelper.textMedium()
        
        lblDeliveryAddress.textColor = UIColor.themeTextColor
        lblDeliveryAddress.font = FontHelper.textRegular()
        
        
        tblAddress.delegate = self
        tblAddress.dataSource = self
        tblAddress.separatorColor = .clear
        tblAddress.register(cellTypes: [AddressListDeliveryDetailCell.self])
        tblAddress.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        tblAddress.reloadData()
        
        if let selectedOrder = selectedOrder {
            self.lblDeliveryTo.text = selectedOrder.destination_addresses?[0].userDetails?.name ?? ""
            self.lblDeliveryAddress.text = selectedOrder.destination_addresses?[0].address ?? ""
        }
        if let orderList = orderList {
            self.lblDeliveryTo.text = orderList.destination_addresses?[0].userDetails?.name ?? ""
            self.lblDeliveryAddress.text = orderList.destination_addresses?[0].address ?? ""
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        heightTableAddress.constant = tblAddress.contentSize.height
    }
    
    override func updateUIAccordingToTheme() {
        setLocalization()
    }
    
    //ActionMethods
    @IBAction func onClickBtnClose(_ sender: Any) {
        self.animationForHideView(alertView) {
            self.removeFromSuperview()
        }
    }
}

extension CustomDialogViewDeliveryDetails: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAddress.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressListDeliveryDetailCell", for: indexPath) as! AddressListDeliveryDetailCell
        cell.lblAddresNo.text = "\(indexPath.row + 1)"
        cell.selectionStyle = .none
        let obj = arrAddress[indexPath.row]
        cell.lblUserName.text = obj.userDetails?.name
        cell.lblAddress.text = obj.address
        cell.lblUserPhone.text = "\(obj.userDetails?.countryPhoneCode ?? "")" + "\(obj.userDetails?.phone ?? "")"
        cell.lblDateTime.text = ""
        if arrTime.count > 0 && arrTime.count > indexPath.row {
            for obj in arrTime {
                if indexPath.row + 1 == obj.stop_no {
                    cell.lblDateTime.text = Utility.stringToString(strDate: obj.date, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_TIME_FORMAT_HISTORY)
                }
            }
        }
        return cell
    }
}
