//
//  DeliveriesVC.swift
//  Store
//
//  Created by Jaydeep Vyas on 24/03/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class DeliveriesVC: BaseVC,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var tblForDeliveries: UITableView!
//    var arrForDeliveries = [Order]()
    var arrForDeliveries = [Requests]()

    //var selectedOrder:Order? = nil
    var selectedVehicleId:String = ""
    var selectedOrderId :String = ""
    @IBOutlet weak var imgEmpty: UIImageView!
    
    //MARK: -
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUi(isUpdate: false)
        tblForDeliveries.showsVerticalScrollIndicator = false
        tblForDeliveries.tableFooterView = UIView.init(frame: CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: UIScreen.main.bounds.width, height: 0)))
        super.hideBackButtonTitle()
        updateUIAccordingToTheme()
        super.setNavigationTitle(title: "TXT_DELIVERIES".localized)
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.wsGetDeliveries()
        
        self.tabBarController?.tabBar.tintColor = UIColor.black
        if #available(iOS 10.0, *) {
            self.tabBarController?.tabBar.unselectedItemTintColor = UIColor.black
        } else {
         
        }
        
        self.tabBarController?.tabBar.barTintColor = UIColor.themeViewBackgroundColor
        tblForDeliveries.estimatedRowHeight = 130
        tblForDeliveries.rowHeight = UITableView.automaticDimension

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.isHidden = true
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func updateUIAccordingToTheme() {
        setMenuButton()
    }
    
    func updateUi(isUpdate:Bool = false) {
        imgEmpty.isHidden = isUpdate
        tblForDeliveries.isHidden = !isUpdate
    }
    /* Table Delegate */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrForDeliveries.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:OrderDeliveryCell?
        
        cell = tableView.dequeueReusableCell(withIdentifier: "orderDeliveryCell") as? OrderDeliveryCell
        
        if (cell == nil) {
            cell = UITableViewCell(style: .default, reuseIdentifier: "orderDeliveryCell") as? OrderDeliveryCell
        }
        cell?.btnReassign.tag = indexPath.row
        cell?.btnReassign.addTarget(self, action: #selector(DeliveriesVC.reassignOrder(sender:)), for: .touchUpInside)
        cell?.selectionStyle = .none
        cell?.setCellData(orderItem: arrForDeliveries[indexPath.row])
        
        return cell!
    }
    var SelectedInd : Int = -1
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        SelectedInd = indexPath.row
        //Storeapp //API changes
        //selectedOrder = arrForDeliveries[indexPath.row]
       self.performSegue(withIdentifier: SEGUE.ORDERSTATUS, sender: self)
    }
    
    func wsGetDeliveries() {
        
        Utility.showLoading()
        let dictParam : [String : Any] =
            [PARAMS.STORE_ID      : preferenceHelper.getUserId(),
             PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken() ,
             ]
        print(dictParam)
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_GET_ORDER_DELIVERY_LIST, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            
            Utility.hideLoading()
            self.arrForDeliveries.removeAll()
            if  Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: false) {
                
                let orderListReponse:OrderListResponse = OrderListResponse.init(fromDictionary: response)
                //Storeapp //API changes
//                self.arrForDeliveries = orderListReponse.orders
               self.arrForDeliveries = orderListReponse.requests

                self.arrForDeliveries.sort { (obj1, obj2) -> Bool in
                    obj1.orderUniqueId > obj2.orderUniqueId
                }
                StoreSingleton.shared.vehicalList.removeAll()
                StoreSingleton.shared.adminVehicalList.removeAll()
                
                for vehicle in orderListReponse.vehicles {
                    StoreSingleton.shared.vehicalList.append(vehicle)
                }
                
                for vehicle in orderListReponse.adminVehicles {
                    StoreSingleton.shared.adminVehicalList.append(vehicle)
                }
                
                if self.tblForDeliveries != nil{
                    self.tblForDeliveries.reloadData()
                }
            }
                
            if self.arrForDeliveries.count > 0 {
                self.updateUi(isUpdate:true)
            }else {
                self.updateUi(isUpdate:false)
            }
        }
    }
    
    func wsGetNearestProviderList(orderId:String) {
        Utility.showLoading()
        let dictParam:[String:String] =
            [PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken(),
             PARAMS.STORE_ID : preferenceHelper.getUserId(),
             PARAMS.ORDER_ID : orderId,
             PARAMS.VEHICLE_ID : selectedVehicleId
        ]
        
        print("WS_FIND_NEAREST_PROVIDER_LIST \(dictParam)")
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_FIND_NEAREST_PROVIDER_LIST, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            
            print("WS_FIND_NEAREST_PROVIDER_LIST \(response)")
            Utility.hideLoading()
            if Parser.isSuccess(response: response) {
                
                let response:ModelManualProvider = ModelManualProvider.init(fromDictionary:response)
                var itemListArray = [ModelProvider]()
                for obj in response.providers {
                    itemListArray.append(obj)
                }
                if itemListArray.isEmpty {
                    Utility.showToast(message: "ERROR_CODE_426".localized)
                }else {
                    let dialog = ManualProviderSelectionDialog.showDialog(languages: [:], title: "",options: itemListArray, isAllowMultiselect: false)
                                dialog.onItemSelected = { [unowned self] (selectedId) in
                                    self.wsCreateRequest(orderId: self.selectedOrderId,isManuallyAssignProvider: true,selectedId: selectedId)
                                    dialog.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    func openVehicleDialog(ind:Int) {
//        if selectedOrder!.orderPaymentDetail.deliveryPriceUsedType == vehicleType {
        
        if self.arrForDeliveries[ind].providerTypeId == vehicleType {
            var itemListArray:[(String,Bool)] = []
            
            for i in StoreSingleton.shared.vehicalList {
                itemListArray.append((i.vehicleName,false))
            }
            if itemListArray.isEmpty {
                Utility.showToast(message: "TXT_NO_VEHICLE_AVAILABLE".localized)
            }else {
                //STOREDEV
//                TableDialog().show(title: "TXT_SELECT_VEHICLE".localized, doneButtonTitle: "TXT_DONE".localized, cancelButtonTitle: "TXT_CANCEL".localized, options: itemListArray, isAllowMultiselect: false) { [unowned self] (selectedIndex) in
//
//                    self.selectedVehicleId =  StoreSingleton.shared.vehicalList[selectedIndex[0]].vehicleId
//                    self.wsCreateRequest(orderId: self.selectedOrderId,isManuallyAssignProvider: false,selectedId: "")
//
//                }
                
                let dialogForLocalizedLanguage = TableviewDialogVehicle.showDialog(languages: [:], title: "",options: itemListArray, isAllowMultiselect: false)
                            dialogForLocalizedLanguage.onItemSelected = { [unowned self] (selectedIndex) in
                                
                                self.selectedVehicleId =  StoreSingleton.shared.adminVehicalList[selectedIndex[0]].vehicleId
                                //self.wsCreateRequest(orderId: self.selectedOrderId)
                                dialogForLocalizedLanguage.removeFromSuperview()
                }
                
                dialogForLocalizedLanguage.onClickAssignAutoSelected = {
                    self.wsCreateRequest(orderId: self.selectedOrderId,isManuallyAssignProvider: false,selectedId: "")
                }
                
                dialogForLocalizedLanguage.onClickAssignManuallySelected = {
                    self.wsGetNearestProviderList(orderId: self.selectedOrderId)
                }
            }
            
        }else {
            var itemListArray:[(String,Bool)] = []
            
            for i in StoreSingleton.shared.adminVehicalList {
                itemListArray.append((i.vehicleName,false))
            }
            if itemListArray.isEmpty {
                Utility.showToast(message: "TXT_NO_VEHICLE_AVAILABLE".localized)
            }else {
//                //STOREDEV
//                TableDialog().show(title: "TXT_SELECT_VEHICLE".localized, doneButtonTitle: "TXT_DONE".localized, cancelButtonTitle: "TXT_CANCEL".localized, options: itemListArray, isAllowMultiselect: false) { [unowned self] (selectedIndex) in
//
//                    self.selectedVehicleId =  StoreSingleton.shared.adminVehicalList[selectedIndex[0]].vehicleId
//                    self.wsCreateRequest(orderId: self.selectedOrderId, isManuallyAssignProvider: false,selectedId: "")
//                }
                
                let dialogForLocalizedLanguage = TableviewDialogVehicle.showDialog(languages: [:], title: "",options: itemListArray, isAllowMultiselect: false)
                            dialogForLocalizedLanguage.onItemSelected = { [unowned self] (selectedIndex) in
                                
                                self.selectedVehicleId =  StoreSingleton.shared.adminVehicalList[selectedIndex[0]].vehicleId
                                //self.wsCreateRequest(orderId: self.selectedOrderId)
                                dialogForLocalizedLanguage.removeFromSuperview()
                }
                
                dialogForLocalizedLanguage.onClickAssignAutoSelected = {
                    self.wsCreateRequest(orderId: self.selectedOrderId,isManuallyAssignProvider: false,selectedId: "")
                }
                
                dialogForLocalizedLanguage.onClickAssignManuallySelected = {
                    self.wsGetNearestProviderList(orderId: self.selectedOrderId)
                }
            
            }
        }
        
    }
    func wsCreateRequest(orderId:String,isManuallyAssignProvider:Bool,selectedId:String) {
        Utility.showLoading()
        let dictParam : [String : String] =
            [PARAMS.ORDER_ID:orderId,
             PARAMS.VEHICLE_ID : selectedVehicleId,
             PARAMS.STORE_ID: preferenceHelper.getUserId(),
             PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken()]
        
        let alamoFire:AlamofireHelper = AlamofireHelper.init()
        
        alamoFire.getResponseFromURL(url: WebService.WS_CREATE_REQUEST, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            if Parser.isSuccess(response: response) {
                self.wsGetDeliveries()
            }else {
                Utility.hideLoading()
            }
            
        }
    }
    @objc func reassignOrder(sender: UIButton) {
//        selectedOrder = arrForDeliveries[sender.tag]
//        selectedOrderId = arrForDeliveries[sender.tag].orderPaymentDetail.orderId
        
        //Janki Check this
        //selectedOrder = arrForDeliveries[sender.tag]
        
        selectedOrderId = arrForDeliveries[sender.tag].orderId
        
        openVehicleDialog(ind: sender.tag)
    }
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let currentOrder = segue.destination as! CurrentOrderVC
        //Janki Check this
        currentOrder.selectedOrderID = arrForDeliveries[SelectedInd].orderId
//        currentOrder.selectedOrder = selectedOrder!
    }
}
class OrderDeliveryCell: CustomCell {
    
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblDeliveryAddress: UILabel!
    @IBOutlet weak var lblTotalOrderPriceValue: UILabel!
    @IBOutlet weak var imgPayment: UIImageView!
    @IBOutlet weak var lblOrderNo: UILabel!
    @IBOutlet weak var btnReassign: UIButton!
    var strUserPhone:String = ""
    var orderId:String = ""
    @IBOutlet weak var lblOrderStatus: UILabel!
    
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var lblSep: CustomLabelSeprator!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Set Font
         btnReassign.titleLabel?.font = FontHelper.textSmall()
        
        
        
        lblUserName.font = FontHelper.textMedium()
        lblTotalOrderPriceValue.font = FontHelper.textMedium()
        lblOrderNo.font = FontHelper.textSmall()
        lblOrderStatus.font = FontHelper.textSmall()
        lblDeliveryAddress.font = FontHelper.textSmall()
        btnReassign.titleLabel?.font = FontHelper.textSmall()
        
        //Set Text Color
        lblUserName.textColor = UIColor.themeTextColor
        lblDeliveryAddress.textColor = UIColor.themeLightTextColor
        lblTotalOrderPriceValue.textColor = UIColor.themeTextColor
        lblOrderNo.textColor = UIColor.themeTextColor
//        lblOrderStatus.textColor = UIColor.themeColor
//        btnReassign.backgroundColor = UIColor.themeSectionBackgroundColor
//        btnReassign.setRound(withBorderColor: .clear, andCornerRadious: 3.0, borderWidth: 1.0)
        btnReassign.setTitle(" " + "TXT_REASSIGN".localizedCapitalized + " ", for: .normal)
        btnReassign.setTitleColor(UIColor.themeTextColor, for: .normal)
        imgUser.setRound()
        btnCall.setTitleColor(.themeColor, for: .normal)
        btnCall.setTitle("  " + "TXT_CALL_USER".localized + "  ", for: .normal)
        btnReassign.setTitle("  " + "TXT_REASSIGN".localizedCapitalized + "  ", for: .normal)

        
    }
    @IBAction func onClickBtnCall(_ sender: Any) {
        if preferenceHelper.getIsEnableTwilioCallMask() {
            TwilioCallMasking.shared.wsTwilloCallMasking(id: orderId, type: "\(CONSTANT.TYPE_USER)")
        } else {
            if strUserPhone.isEmpty() {
                Utility.showToast(message: "MSG_UNABLE_TO_CALL".localized)
            }else{
                if let url = URL(string: "tel://\(strUserPhone)"), UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }else{
                    Utility.showToast(message: "MSG_UNABLE_TO_CALL".localized)
                }
            }
        }
    }
    
    func setCellData(orderItem:Requests) {
        orderId = orderItem.id
        strUserPhone =  orderItem.destinationAddresses[0].userDetails.countryPhoneCode + orderItem.destinationAddresses[0].userDetails.phone
//        imgUser.downloadedFrom(link: orderItem.userDetail.imageUrl)
        
        imgUser.downloadedFrom(link: orderItem.destinationAddresses[0].userDetails.imageUrl)

        lblUserName.text = orderItem.destinationAddresses[0].userDetails.name
//        lblTotalOrderPriceValue.text =  (orderItem.orderPaymentDetail.totalOrderPrice).toCurrencyString()
        lblTotalOrderPriceValue.text =  (orderItem.total).toCurrencyString()

        lblDeliveryAddress.text = orderItem.destinationAddresses[0].address
        
        let orderStatus:OrderStatus = OrderStatus(rawValue: orderItem.deliveryStatus) ?? .Unknown;
        
        if orderStatus.rawValue  == OrderStatus.ORDER_READY.rawValue ||
            orderStatus.rawValue  == OrderStatus.NO_DELIVERY_MAN_FOUND.rawValue ||
            orderStatus.rawValue  == OrderStatus.DELIVERY_MAN_REJECTED.rawValue ||
            orderStatus.rawValue  == OrderStatus.DELIVERY_MAN_CANCELLED.rawValue ||
            orderStatus.rawValue  == OrderStatus.STORE_CANCELLED_REQUEST.rawValue {
            btnReassign.isHidden = false
            lblSep.isHidden = false
        }else {
//            btnCall.setTitle("  " + "TXT_CALL_DELIVERYMAN".localized + "  ", for: .normal)
            btnReassign.isHidden = true
            lblSep.isHidden = true
        }
        
        //Design Change
        /* if orderItem.isPaymentModeCash {
             imgPayment.image = UIImage.init(named: "cash_icon")
         }else {
             imgPayment.image = UIImage.init(named: "card_icon")
         }*/
        lblOrderNo.text = "TXT_ORDER_NO".localized + String(orderItem.orderUniqueId)
        lblOrderStatus.text = orderStatus.text()
        lblOrderStatus.textColor = orderStatus.textColor()
        
        lblDeliveryAddress.text = orderItem.destinationAddresses[0].address
        
        //remove assigning of deliveryman from delivery list
        btnReassign.isHidden = true
        lblSep.isHidden = true

   }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
   

    
    
}
