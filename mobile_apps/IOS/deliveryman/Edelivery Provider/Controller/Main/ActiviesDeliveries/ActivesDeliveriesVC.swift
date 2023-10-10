//
//  ActivesDeliveriesVC.swift
//  Edelivery Provider
//
//  Created by Elluminati iMac on 21/04/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit

class ActivesDeliveriesVC: BaseVC, UITableViewDelegate, UITableViewDataSource {
    
//MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgEmptyBox: UIImageView!
    @IBOutlet weak var lblEmptyMsg: UILabel!
    public var parentVC: Any? = nil
    var arrForActiveOrder : NSMutableArray = NSMutableArray.init()
    var refreshControl: UIRefreshControl!
   
//MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
             lblEmptyMsg.isHidden = true
        self.setLocalization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        wsGetActiveOrder()
        
    }
    
    override func updateUIAccordingToTheme() {
        self.setLocalization()
        self.tableView.reloadData()
    }
    
    //MARK: Web Services
    @objc func wsGetActiveOrder() {
        Utility.showLoading()
        let dictParam:[String:String] =
            [PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken(),
             PARAMS.PROVIDER_ID : preferenceHelper.getUserId()]
        
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_GET_ACTIVE_ORDER, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            print("WS_GET_ACTIVE_ORDER \(response)")
            
            self.arrForActiveOrder.removeAllObjects()
            Parser.parseAvailableOrders(response, toArray: self.arrForActiveOrder, isNewOrder: false, completion: { [unowned self] result in
                if result {
                    self.updateUi(isUpdate: true)
                    if let parentVC = self.parent, parentVC is AvailableDeliveriesVC {
                        (self.parent as? AvailableDeliveriesVC)?.tabBar.items![1].badgeValue = String(self.arrForActiveOrder.count)
                    }
                    self.tableView.reloadData()
                }else {
                    if let parentVC = self.parent, parentVC is AvailableDeliveriesVC {
                        (self.parent as? AvailableDeliveriesVC)? .tabBar.items![1].badgeValue = nil
                    }
                }
                if self.arrForActiveOrder.count <= 0{
                    self.updateUi(isUpdate: false)
                }
                Utility.hideLoading()
                self.refreshControl.endRefreshing()
            })
        }
    }
    
    func gotoInvoice(order:ActiveOrder) {
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "History", bundle: nil)
        if let invoiceVC : InvoiceVC = mainView.instantiateViewController(withIdentifier: "InvoiceVC") as? InvoiceVC {
            invoiceVC.isHistoryDetail = false;
            invoiceVC.activeOrder = order
            invoiceVC.modalPresentationStyle = .overCurrentContext
            self.present(invoiceVC, animated: false, completion: nil)
        }
    }
    
    func updateUi(isUpdate:Bool = false) {
        if imgEmptyBox != nil {
            imgEmptyBox.isHidden = isUpdate
        }
        if tableView != nil {
            tableView.isHidden = !isUpdate
        }
    }
    
    //MARK: Tableview Delegate Methods
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrForActiveOrder.count
    }
    
    func  tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell  = tableView.dequeueReusableCell(withIdentifier: "Cell") as? ActiveDelileriesCell
        
        if !(cell != nil) {
            cell = ActiveDelileriesCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "Cell")
        }
        
        cell!.tblAddress.isHidden = true
        
        if self.arrForActiveOrder.count > indexPath.row {
            let dict: ActiveOrder = self.arrForActiveOrder[indexPath.row] as! ActiveOrder
            
            let cellData:AvailableOrderCellData = AvailableOrderCellData.init()
            cellData.isAllowContactlessDelivery = dict.isAllowContactlessDelivery
            cellData.orderNumber = String(dict.orderUniqueId!)
            cellData.deliveryType = dict.delivery_type
            cellData.requestNumber = String(dict.unique_id!)
            cellData.userImage = ""
            
            var destinationObj = dict.destinationAddresses[0]
            
            if dict.destinationAddresses.count > 1 {
                if dict.arrived_at_stop_no >= dict.destinationAddresses.count {
                    destinationObj = dict.destinationAddresses.last ?? dict.destinationAddresses[0]
                } else if dict.arrived_at_stop_no < dict.destinationAddresses.count {
                    destinationObj = dict.destinationAddresses[dict.arrived_at_stop_no]
                }
            }
            
            if dict.delivery_type == DeliveryType.courier {
                cellData.userImage = ""
                cellData.userName = destinationObj.userDetails.name
                cellData.storeName = "TXT_COURIER".localized
                cellData.storeImage = ""
            }
            else {
                cellData.storeName = dict.store_name
                cellData.storeImage = dict.store_image!
                cellData.userName = destinationObj.userDetails.name
                cellData.userImage = dict.user_detail?.image_url
            }
            
            cellData.status =    OrderStatus(rawValue: dict.order_status ?? 0)
            cellData.date = dict.created_at
            cellData.sourceAddress = dict.pickupAddresses[0].address
            cellData.destinationAddress = destinationObj.address
            
            cellData.estimated_time_for_ready_order = dict.estimated_time_for_ready_order
            cell?.setData(dictData: cellData)
        }
        
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if self.arrForActiveOrder.count > 0{
            let dict: ActiveOrder = self.arrForActiveOrder[indexPath.row] as! ActiveOrder
            if OrderStatus.init(rawValue: dict.order_status!) == OrderStatus.DELIVERY_MAN_COMPLETE_DELIVERY {
                self.gotoInvoice(order: dict)
            }else {
            self.performSegue(withIdentifier: SEGUE.ACTIVEDELIVERIES_TO_DETAIL, sender: dict)
            }
        }
    }
   
    //MARK: Set localized layout
    func setLocalization() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 105
        tableView.tableFooterView = UIView()
        lblEmptyMsg.textColor = UIColor.themeTextColor
        lblEmptyMsg.text = "TXT_ACTIVE_ORDER_LIST_EMPTY".localized
        lblEmptyMsg.font = FontHelper.textRegular()
        // COLORS
        view.backgroundColor = UIColor.themeViewBackgroundColor
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "MSG_REFRESH".localized)
        refreshControl.addTarget(self, action: #selector(wsGetActiveOrder), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        tableView.separatorStyle = .none
    }

    //MARK: Memory Mngmnt
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SEGUE.ACTIVEDELIVERIES_TO_DETAIL {
            let objVC = segue.destination as! CurrentDeliveryVC
            objVC.isActiveDelivery = 1
            objVC.activeOrderData = sender as? ActiveOrder
        }
    }
}

