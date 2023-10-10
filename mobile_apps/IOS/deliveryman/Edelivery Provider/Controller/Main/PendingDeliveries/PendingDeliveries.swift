//
//  PendingDeliveries.swift
//  Edelivery Provider
//
//  Created by Elluminati iMac on 21/04/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit

class PendingDeliveries: BaseVC, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgEmptyBox: UIImageView!
    @IBOutlet weak var lblEmptyMsg: UILabel!
    
    public var parentVC: Any? = nil
    var arrForNewOrder : NSMutableArray = NSMutableArray.init()
    var refreshControl: UIRefreshControl!
    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblEmptyMsg.isHidden = true
        self.setLocalization()
    }
    
    override func updateUIAccordingToTheme() {
        self.setLocalization()
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.wsGetNewOrder()
    }

    //MARK: wsGetNewOrder
    @objc func wsGetNewOrder() {
        Utility.showLoading()
        let dictParam:[String:String] =
            [PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken(),
             PARAMS.PROVIDER_ID : preferenceHelper.getUserId()]
        
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_GET_ORDER, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            print(response)
            self.arrForNewOrder.removeAllObjects()
            Parser.parseAvailableOrders(response, toArray: self.arrForNewOrder, isNewOrder: true, completion: { result in
                if result {
                    DispatchQueue.main.async {
                        if let parentVC = self.parent, parentVC is AvailableDeliveriesVC
                        {
                            (self.parent as? AvailableDeliveriesVC)? .tabBar.items![0].badgeValue = String(self.arrForNewOrder.count)
                        }
                        self.imgEmptyBox.isHidden = true
                        self.tableView.reloadData()
                        self.tableView.isHidden = false
                    }
                }else {
                    DispatchQueue.main.async
                        {
                            if let parentVC = self.parent, parentVC is AvailableDeliveriesVC
                            {
                                (self.parent as? AvailableDeliveriesVC)? .tabBar.items![0].badgeValue = nil
                            }
                        self.imgEmptyBox.isHidden = false
                        self.tableView.reloadData()
                        self.tableView.isHidden = true
                    }
                }
                self.refreshControl.endRefreshing()
                Utility.hideLoading()
            })
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrForNewOrder.count
    }
    
    func  tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell  = tableView.dequeueReusableCell(withIdentifier: "Cell") as? ActiveDelileriesCell
        
        if !(cell != nil) {
            cell = ActiveDelileriesCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "Cell")
        }
        
        if let dict: NewOrder = self.arrForNewOrder[indexPath.row] as? NewOrder {
            let cellData:AvailableOrderCellData = AvailableOrderCellData.init()
            cellData.isAllowContactlessDelivery = dict.isAllowContactlessDelivery
            cellData.orderNumber = String(dict.orderUniqueId!)
            cellData.requestNumber = String(dict.unique_id!)
            cellData.userImage = ""
            cellData.userName = ""
            if dict.delivery_type == DeliveryType.courier {
                cellData.storeName = "TXT_COURIER".localized
                cellData.storeImage = ""
            }else {
                cellData.userImage = ""
                cellData.userName = dict.destinationAddresses[0].userDetails.name
                cellData.storeName = dict.store_name
                cellData.storeImage = dict.store_image!
            }
            cellData.deliveryType = dict.delivery_type
            cellData.status =    OrderStatus(rawValue: dict.order_status!)
            cellData.date = dict.created_at
            cellData.sourceAddress = dict.pickupAddresses[0].address
            cellData.destinationAddress = dict.destinationAddresses[0].address
            cellData.estimated_time_for_ready_order = dict.estimated_time_for_ready_order
            
            var arrAdddress = dict.destinationAddresses ?? []
            arrAdddress.insert(dict.pickupAddresses[0], at: 0)
            cellData.arrAddress = arrAdddress
            
            cell?.setData(dictData: cellData)
        }
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let dict: NewOrder = self.arrForNewOrder[indexPath.row] as! NewOrder
        self.performSegue(withIdentifier: SEGUE.ACTIVEDELIVERIES_TO_DETAIL, sender: dict)
    }
   
    //MARK: Set localized layout
    func setLocalization() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.tableFooterView = UIView()
        
        // COLORS
        view.backgroundColor = UIColor.themeViewBackgroundColor
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "MSG_REFRESH".localized)
        refreshControl.addTarget(self, action: #selector(wsGetNewOrder), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        lblEmptyMsg.textColor = UIColor.themeTextColor
        lblEmptyMsg.text = "TXT_PENDING_ORDER_LIST_EMPTY".localized
        lblEmptyMsg.font = FontHelper.textRegular()
        tableView.separatorStyle = .none
    }
   
    //MARK: Memory Mngmnt
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let objVC = segue.destination as! CurrentDeliveryVC
        objVC.newOrderData = sender as? NewOrder
        objVC.isActiveDelivery = 0
    }
}
