//
//  HomeVC.swift
//  edelivery
//
//  Created by Elluminati on 14/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class CurrentOrderVC: BaseVC,UITableViewDelegate,UITableViewDataSource {

    //MARK: OutLets
    @IBOutlet weak var tableForCurrentOrders: UITableView!
    @IBOutlet weak var imgEmpty: UIImageView!
    @IBOutlet weak var viewFooter: UIView!
    
    
    
    //MARK: Variables
    var arrForCurrentOrders:NSMutableArray =  NSMutableArray.init()
    var arrFilterOrder:NSMutableArray =  NSMutableArray.init()
    var selectedOrder:Order = Order.init()
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalization()
        tableForCurrentOrders.estimatedRowHeight = 100.0
        tableForCurrentOrders.rowHeight = UITableView.automaticDimension
        self.hideBackButtonTitle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        wsGetOrders()
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        tableForCurrentOrders.tableFooterView = viewFooter
    }
    
    override func viewDidLayoutSubviews(){
    super.viewDidLayoutSubviews()
        setupLayout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func reloadData(filter: OrderFilter = OrderFilter.all) {
        arrFilterOrder.removeAllObjects()
        if let arrMain = arrForCurrentOrders as? [Order] {
            if filter == OrderFilter.store {
                arrFilterOrder = arrMain.filter({$0.delivery_type == DeliveryType.store}) as! NSMutableArray
            } else if filter == OrderFilter.courier {
                arrFilterOrder = arrMain.filter({$0.delivery_type == DeliveryType.courier}) as! NSMutableArray
            }
        }
        tableForCurrentOrders.reloadData()
    }
    
    func setupLayout() {
    }
    
    func setLocalization() {
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        self.tableForCurrentOrders.backgroundColor = UIColor.themeViewBackgroundColor
   }
    
    func updateUi(isUpdate:Bool = false) {
        self.tableForCurrentOrders?.isHidden = !isUpdate
        self.imgEmpty?.isHidden = isUpdate
    }
    
    // MARK:TABLEVIEW DELEGATE METHODS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if arrFilterOrder.count > 0 {
            return arrFilterOrder.count
        }
        return arrForCurrentOrders.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:CurrentOrderCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CurrentOrderCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let currentData:Order = {
            if arrFilterOrder.count > 0 {
                return arrFilterOrder[indexPath.row] as! Order
            }
          return arrForCurrentOrders[indexPath.row] as! Order
        }()
        cell.setCellData(cellItem: currentData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let arrOrder:NSMutableArray = {
            if arrFilterOrder.count > 0 {
                return arrFilterOrder
            }
          return arrForCurrentOrders
        }()
        if let  currentSelectedOrder = arrOrder[indexPath.row] as? Order
        {
            selectedOrder = currentSelectedOrder
            currentBooking.selectedOrderId = selectedOrder._id
            currentBooking.selectedStoreId = selectedOrder.cartDetail?.storeId
            
            if selectedOrder.delivery_type == DeliveryType.courier {
                var mainView: UIStoryboard!
                mainView = UIStoryboard(name: "Courier", bundle: nil)
                if let courierStatusVC : CourierStatusVC = mainView.instantiateViewController(withIdentifier: "courierStatusVC") as? CourierStatusVC {
                    
                    courierStatusVC.selectedOrder = selectedOrder
                    self.navigationController?.pushViewController(courierStatusVC, animated: true)
                }
            }else {
                self.performSegue(withIdentifier: SEGUE.SEGUE_ORDER_STATUS, sender: self)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
    
    }

    //MARK: WEB SERVICE CALLS
    func wsGetOrders() {
        Utility.showLoading()
        let dictParam: Dictionary<String,Any> =
            [PARAMS.USER_ID:preferenceHelper.getUserId(),
             PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken()]
        
        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_GET_ORDER, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
                Parser.parseOrders(response, toArray: self.arrForCurrentOrders, completion: { (result) in
                    
                    print("WS_GET_ORDER response \(response)")

                    DispatchQueue.main.async {
                        if result
                        {
                            self.updateUi(isUpdate: true)
                        }
                        else
                        {
                            self.updateUi()
                        }
                        self.tableForCurrentOrders?.reloadData()
                        Utility.hideLoading()
                    }
                })
        }
    }

  //MARK: USER DEFINE FUNCTION
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier?.compare(SEGUE.SEGUE_ORDER_STATUS) == ComparisonResult.orderedSame) {
            let orderStatusvc = segue.destination as! OrderStatusVC
            orderStatusvc.selectedOrder = selectedOrder
            
        }
        if(segue.identifier?.compare(SEGUE.ORDER_TO_INVOICE) == ComparisonResult.orderedSame) {
            let invoiceVC = segue.destination as! HistoryInvoiceVC
            invoiceVC.isFromHistory = false
            invoiceVC.strOrderID = selectedOrder._id!
            invoiceVC.strCurrency = selectedOrder.currency!
            if let providerFirstName:String = selectedOrder.provider_first_name {
                invoiceVC.name = providerFirstName + " " + (selectedOrder.provider_last_name ?? "")
            invoiceVC.imgurl = selectedOrder.provider_image ?? ""
            }
        }
    }
}
