//
//  HistoryVC.swift
//  Edelivery
//
//   Created by Elluminati on 25/04/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit

class HistoryVC: BaseVC, UITableViewDelegate, UITableViewDataSource {
  
    //MARK: OutLets
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var imgEmpty: UIImageView!
    @IBOutlet weak var stackForDate: UIStackView!
    @IBOutlet weak var viewForFrom: UIView!
    @IBOutlet weak var viewForTo: UIView!
    @IBOutlet weak var btnFrom: UIButton!
    @IBOutlet weak var btnTo: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewForFilter: UIView!
    @IBOutlet weak var viewForHeader: UIView?
    @IBOutlet weak var viewForFooter: UIView!
    @IBOutlet weak var lblSeperator: UILabel!
    @IBOutlet weak var viewCurrentOrderHeader: UIView?
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var tableForCurrentOrders: UITableView!
    @IBOutlet weak var imgCurrentOrderEmpty: UIImageView!
    @IBOutlet weak var viewFooter: UIView!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var lblCurrentOrders: UILabel!
    
    override  var preferredContentSize: CGSize {
        get {
            self.tableView.layoutIfNeeded()
            return self.tableView.contentSize
        }
        set {}
    }
    
    var arrForSection = NSMutableArray()
    var arrForHistory = NSMutableArray()
    var arrForFilterHistory = NSMutableArray()
    var arrForCreateAt = NSMutableArray()
    var sectionDate = Array<Any>()
    var strFromDate = ""
    var strToDate = ""
    var hasCurrentOrderData: Bool = false
    var hasHistoryOrderData: Bool = false
    
    //MARK: Variables
    var arrForCurrentOrders:NSMutableArray =  NSMutableArray.init()
    var arrFilterCurrentOrder:NSMutableArray =  NSMutableArray.init()
    var selectedOrder:Order = Order.init()
    var filterType = OrderFilter.all
    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 114
        tableView.rowHeight = UITableView.automaticDimension
        tableForCurrentOrders.estimatedRowHeight = 100.0
        tableForCurrentOrders.rowHeight = UITableView.automaticDimension
        self.hideBackButtonTitle()
        self.setLocalization()
        self.setBackBarItem(isNative: true)
        self.tableView.tableFooterView = UIView()
        viewCurrentOrderHeader?.clipsToBounds = true
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        wsGetOrders()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        self.viewForFooter.frame.size.height = tableView.contentSize.height + (tableView.tableHeaderView?.frame.size.height ?? 0)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayout()
    }
    override func updateUIAccordingToTheme() {
        self.setBackBarItem(isNative: true)
    }

    //MARK: Set localized layout
    func setLocalization() {
       
        view.backgroundColor = UIColor.themeViewBackgroundColor
        self.tableForCurrentOrders.backgroundColor = UIColor.themeViewBackgroundColor
        updateUI(isUpdate: false)
        
        //LOCALIZED
        self.title = "TXT_HISTORY".localized
        btnFrom.setTitle("TXT_FROM".localized, for: UIControl.State.normal)
        btnTo.setTitle("TXT_TO".localized, for: UIControl.State.normal)
        btnApply.setTitle("TXT_APPLY".localizedCapitalized, for: UIControl.State.normal)
        btnReset.setTitle("TXT_RESET".localizedCapitalized, for: UIControl.State.normal)

        //COLORS
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        viewForFilter.backgroundColor = UIColor.themeAlertViewBackgroundColor
        viewForTo.backgroundColor = UIColor.themeAlertViewBackgroundColor
        viewForFrom.backgroundColor = UIColor.themeAlertViewBackgroundColor
        btnFrom.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        btnTo.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        btnFrom.backgroundColor = UIColor.themeLightTextColor
        btnTo.backgroundColor = UIColor.themeLightTextColor
        btnApply.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
        btnReset.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
        
        /*Set Font*/
        btnFrom.titleLabel?.font = FontHelper.textRegular()
        btnTo.titleLabel?.font = FontHelper.textRegular()
        btnApply.titleLabel?.font = FontHelper.textRegular()
        btnReset.titleLabel?.font = FontHelper.textRegular()
        lblHeaderTitle.font = FontHelper.textMedium(size: FontHelper.mediumLarge)
        lblHeaderTitle.textColor = UIColor.themeTitleColor
        lblHeaderTitle.text = "TXT_ORDER_HISTORY".localized
        lblCurrentOrders.font = FontHelper.textMedium(size: FontHelper.mediumLarge)
        lblCurrentOrders.textColor = UIColor.themeTitleColor
        lblCurrentOrders.text = "TXT_CURRENT_ORDER".localized
        btnFilter.tintColor = .themeColor
        btnFilter.setImage(UIImage.init(named: "filter_blue")?.imageWithColor(color: .themeColor), for: .normal)
    }
    
    func setupLayout() {
        btnFrom.applyRoundedCornersWithHeight(4)
        btnTo.applyRoundedCornersWithHeight(4)
    }
    

    //MARK: Tableview Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tableForCurrentOrders {
            return 1
        }
        else {
            return self.arrForSection.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableForCurrentOrders {
            if filterType != .all {
                return arrFilterCurrentOrder.count
            }
            return arrForCurrentOrders.count
        }
        else {
            return (((arrForSection.object(at: section)) as! NSMutableArray).count)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableForCurrentOrders {
            let cell:CurrentOrderCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CurrentOrderCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            let arr: NSMutableArray = {
                if filterType != .all {
                    return arrFilterCurrentOrder
                }
                return arrForCurrentOrders
            }()
            let currentData:Order = arr[indexPath.row] as! Order
            cell.setCellData(cellItem: currentData)
            if currentData.order_change ?? false {
                cell.mainView.backgroundColor = .clear
                cell.backgroundColor = UIColor.themeRedAlphaBackground
                cell.contentView.backgroundColor = UIColor.themeRedAlphaBackground
            } else {
                cell.mainView.backgroundColor = UIColor.themeViewBackgroundColor
                cell.backgroundColor = UIColor.themeViewBackgroundColor
                cell.contentView.backgroundColor = UIColor.themeViewBackgroundColor
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HistoryCell
            
            let dict = ((arrForSection .object(at: indexPath.section)) as! NSMutableArray).object(at: indexPath.row) as! Order_list
            cell.setHistoryData(dictData: dict )
        
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView == tableForCurrentOrders {
            let arr: NSMutableArray = {
                if filterType != .all {
                    return arrFilterCurrentOrder
                }
                return arrForCurrentOrders
            }()
            if let  currentSelectedOrder = arr[indexPath.row] as? Order
            {
                selectedOrder = currentSelectedOrder
                currentBooking.selectedOrderId = selectedOrder._id
                if selectedOrder.delivery_type == DeliveryType.courier {
                    gotoCourierStatus()
                }else {
                    self.performSegue(withIdentifier: SEGUE.SEGUE_ORDER_STATUS, sender: self)
                }
            }
        }
        else {
            let dict = ((arrForSection .object(at: indexPath.section)) as! NSMutableArray).object(at: indexPath.row) as! Order_list
            currentBooking.selectedOrderId = dict._id
            selectedOrder = Order(dictionary: dict.dictionaryRepresentation()) ?? Order()
            if dict.delivery_type == DeliveryType.courier {
                let deliverType: Int = dict.delivery_type ?? 0
                self.performSegue(withIdentifier:SEGUE.HISTORY_TO_DETAIL, sender: deliverType)
                //gotoCourierStatus(isFromHistory: true)
            } else {
                let deliverType: Int = dict.delivery_type ?? 0
                self.performSegue(withIdentifier:SEGUE.HISTORY_TO_DETAIL, sender: deliverType)
            }
        }
    }
    
    func gotoCourierStatus(isFromHistory: Bool = false) {
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "Courier", bundle: nil)
        if let courierStatusVC : CourierStatusVC = mainView.instantiateViewController(withIdentifier: "courierStatusVC") as? CourierStatusVC {
            courierStatusVC.selectedOrder = selectedOrder
            self.navigationController?.pushViewController(courierStatusVC, animated: true)
        }
    }

    //MARK: Create for section
    func createSection() {
        let arrSection: NSMutableArray = {
            if filterType != .all {
                return arrForFilterHistory
            }
            return arrForHistory
        }()
        arrForCreateAt.removeAllObjects()
        arrForSection.removeAllObjects()
        let arrtemp = NSMutableArray()
        arrtemp.addObjects(from: (arrSection as NSArray) as! [Any])
        for i in 0 ..< arrtemp.count {
            let dict:Order_list = arrtemp .object(at: i) as! Order_list
            let strDate:String = dict.created_at!
            let arr = strDate .components(separatedBy:"T")
            let str:String = (arr as NSArray) .object(at: 0) as! String
            if(!arrForCreateAt .contains(str)) {
                arrForCreateAt.add(str)
            }
        }
        for j in 0 ..< arrForCreateAt.count {
            let strTempDate:String = arrForCreateAt .object(at: j) as! String
            let arr1 = NSMutableArray()
            
            for i in 0 ..< arrtemp.count {
                let dict:Order_list = arrtemp .object(at: i) as! Order_list
                let strDate:String = dict.created_at!
                let arr = strDate .components(separatedBy:"T")
                let str:String = (arr as NSArray) .object(at: 0) as! String
                if(str == strTempDate) {
                    arr1.add(dict)
                }
            }
            arrForSection.add(arr1)
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            //self.viewForFooter.frame.size.height = self.preferredContentSize.height
            self?.tableForCurrentOrders.reloadData()
            self?.view.layoutSubviews()
            if arrSection.count > 0 {
                self?.hasHistoryOrderData = true
                self?.updateUI(isUpdate: true)
                self?.viewForHeader?.isHidden = false
                if self?.getCurrentOrderArray().count == 0 {
                    self?.viewCurrentOrderHeader?.frame.size.height = 0
                } else {
                    self?.viewCurrentOrderHeader?.frame.size.height = 50
                }
            } else {
                self?.hasHistoryOrderData = false
                self?.updateUI(isUpdate: false)
                self?.viewForHeader?.isHidden = true
                if self?.getCurrentOrderArray().count == 0 {
                    self?.tableForCurrentOrders.isHidden = true
                } else {
                    self?.tableForCurrentOrders.isHidden = false
                }
            }
            self?.tableForCurrentOrders.reloadData()
        }
    }
    
    func getCurrentOrderArray() -> NSMutableArray {
        if filterType != .all {
            return arrFilterCurrentOrder
        }
        return arrForCurrentOrders
    }

    //MARK: Button action method

    @IBAction func onClickFromTo(_ sender: UIButton) {
        if sender.tag == 10 {
            let datePickerDialog:CustomDatePickerDialog = CustomDatePickerDialog.showCustomDatePickerDialog(title: "TXT_SELECT_FROM_DATE".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_OK".localized)
            datePickerDialog.setMaxDate(maxdate: Date())
            if !strToDate.isEmpty() {
                let maxDate = Utility.stringToDate(strDate: strToDate, withFormat: DATE_CONSTANT.DATE_MM_DD_YYYY)
                datePickerDialog.setMaxDate(maxdate: maxDate)
                
            }
            datePickerDialog.onClickLeftButton = {
                [unowned datePickerDialog] in
                datePickerDialog.removeFromSuperview()
            }
            
            datePickerDialog.onClickRightButton = { [unowned self,unowned datePickerDialog] (selectedDate:Date) in
                self.strFromDate = Utility.dateToString(date: selectedDate, withFormat: DATE_CONSTANT.DATE_MM_DD_YYYY)
                self.btnFrom.setTitle(String(format: "%@",self.strFromDate), for: UIControl.State.normal)
                self.strToDate = self.strFromDate
                datePickerDialog.removeFromSuperview()
            }
        }else {
            if btnFrom.titleLabel?.text == "TXT_FROM".localized
            {
                let alertController = UIAlertController(title: "TXT_WARNING".localized, message: "MSG_INVALID_DATE_WARNING".localized, preferredStyle: .alert)
                
                let yesAction = UIAlertAction(title: "TXT_OK".localized, style: .default, handler: { _ in
                })
                alertController.addAction(yesAction)
                present(alertController, animated: true, completion: nil)
            }else {
                let datePickerDialog:CustomDatePickerDialog = CustomDatePickerDialog.showCustomDatePickerDialog(title: "TXT_SELECT_TO_DATE".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_OK".localized)
                let minidate = Utility.stringToDate(strDate: strFromDate, withFormat: DATE_CONSTANT.DATE_MM_DD_YYYY)
                
                datePickerDialog.setMaxDate(maxdate: Date())
                datePickerDialog.setMinDate(mindate: minidate)
                datePickerDialog.onClickLeftButton =
                { [unowned datePickerDialog] in
                    datePickerDialog.removeFromSuperview()
                }
                
                datePickerDialog.onClickRightButton =
                { [unowned self,unowned datePickerDialog] (selectedDate:Date) in
                        
                        self.strToDate = Utility.dateToString(date: selectedDate, withFormat: DATE_CONSTANT.DATE_MM_DD_YYYY)
                        self.btnTo.setTitle(String(format: "%@",self.strToDate), for: UIControl.State.normal)
                        datePickerDialog.removeFromSuperview()
                }
            }
        }
    }
    
    @IBAction func onClickBtnResetFilter(_ sender: UIButton) {
        strToDate = ""
        strFromDate = ""
        //(self.parent as! OrderVC).onClickRightButton()
        self.wsGetHistory(startDate: strFromDate, endDate: strToDate)
    }
    @IBAction func onClickBtnApplyFilter(_ sender: UIButton) {
        if (strFromDate.isEmpty() || strToDate.isEmpty()) {
            Utility.showToast(message: "MSG_PLEASE_SELECT_DATE_FIRST".localized)
        }else {
            //(self.parent as! OrderVC).onClickRightButton()
            self.wsGetHistory(startDate: strFromDate, endDate: strToDate)
        }
    }
    
    @IBAction func onClickBtnFilterIcon(_ sender: UIButton) {
        let dialogueFilterHistory = DailogForFilter.showCustomFilterDialog()
        dialogueFilterHistory.onClickApplyButton = {
            (strFromDate,strToDate) in
            dialogueFilterHistory.removeFromSuperview()
            if (strFromDate.isEmpty() || strToDate.isEmpty()) {
                Utility.showToast(message: "MSG_PLEASE_SELECT_DATE_FIRST".localized)
            }else {
                //(self.parent as! OrderVC).onClickRightButton()
                self.strFromDate = strFromDate
                self.strToDate = strToDate
                self.wsGetHistory(startDate: strFromDate, endDate: strToDate)
            }
        }
        
        dialogueFilterHistory.onClickResetButton = {
            dialogueFilterHistory.removeFromSuperview()
            self.strToDate = ""
            self.strFromDate = ""
            //(self.parent as! OrderVC).onClickRightButton()
            self.wsGetHistory(startDate: self.strFromDate, endDate: self.strToDate)
        }
        
    }

    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier?.compare(SEGUE.SEGUE_ORDER_STATUS) == ComparisonResult.orderedSame) {
            let orderStatusvc = segue.destination as! OrderStatusVC
            orderStatusvc.selectedOrder = selectedOrder
            
        }
        else if(segue.identifier?.compare(SEGUE.ORDER_TO_INVOICE) == ComparisonResult.orderedSame) {
            let invoiceVC = segue.destination as! HistoryInvoiceVC
            invoiceVC.isFromHistory = false
            invoiceVC.strOrderID = selectedOrder._id!
            invoiceVC.strCurrency = selectedOrder.currency!
            if let providerFirstName:String = selectedOrder.provider_first_name {
                invoiceVC.name = providerFirstName + " " + (selectedOrder.provider_last_name ?? "")
                invoiceVC.imgurl = selectedOrder.provider_image ?? ""
            }
        }
        else {
            let obj = segue.destination as! HistoryDetailVC
            obj.strOrderID = currentBooking.selectedOrderId ?? ""
            obj.deliveryType = sender as! Int
        }
    }
    
    //MARK: Memory Mngmnt
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: User Define Function
    func updateUI(isUpdate:Bool = false) {
        if imgEmpty != nil{
            imgEmpty.isHidden = isUpdate
            viewForFilter.isHidden = true
            hasHistoryOrderData = isUpdate
            tableForCurrentOrders.isHidden = false
            if(hasHistoryOrderData == false && hasCurrentOrderData == false) {
                tableForCurrentOrders.isHidden = true
            }
            lblSeperator.isHidden = !hasCurrentOrderData
            strToDate = ""
            strFromDate = ""
            btnFrom.setTitle("TXT_FROM".localized, for: UIControl.State.normal)
            btnTo.setTitle("TXT_TO".localized, for: UIControl.State.normal)
            self.setRightBarItemImage(image: UIImage.init(named: "filter")!)
            Utility.showToast(message: "")
        }
    }
    
    func updateUiOrders(isUpdate:Bool = false) {
        self.lblCurrentOrders?.isHidden = !isUpdate
        self.imgEmpty?.isHidden = isUpdate
    }
    
    func reloadData(filter: OrderFilter = OrderFilter.all) {
        filterType = filter
        arrFilterCurrentOrder.removeAllObjects()
        arrForFilterHistory.removeAllObjects()
        if filter == .all {
            wsGetOrders()
            return
        }
        if let arrMain = arrForCurrentOrders as? [Order] {
            if filter == OrderFilter.store {
                for obj in arrMain {
                    if obj.delivery_type == DeliveryType.store {
                        arrFilterCurrentOrder.add(obj)
                    }
                }
            } else if filter == OrderFilter.courier {
                for obj in arrMain {
                    if obj.delivery_type == DeliveryType.courier {
                        arrFilterCurrentOrder.add(obj)
                    }
                }
            } else if filter == OrderFilter.tableBook {
                for obj in arrMain {
                    if obj.delivery_type == DeliveryType.tableBooking {
                        arrFilterCurrentOrder.add(obj)
                    }
                }
            }
        }
        if let arrHistory = arrForHistory as? [Order_list] {
            if filter == OrderFilter.store {
                for obj in arrHistory {
                    if obj.delivery_type == DeliveryType.store {
                        arrForFilterHistory.add(obj)
                    }
                }
            } else if filter == OrderFilter.courier {
                for obj in arrHistory {
                    if obj.delivery_type == DeliveryType.courier {
                        arrForFilterHistory.add(obj)
                    }
                }
            } else if filter == OrderFilter.tableBook {
                for obj in arrHistory {
                    if obj.delivery_type == DeliveryType.tableBooking {
                        arrForFilterHistory.add(obj)
                    }
                }
            }
        }
        tableForCurrentOrders.reloadData()
        createSection()
    }

    //MARK: wsGetHistory
    func wsGetHistory(startDate: String,endDate: String) {
        Utility.showLoading()
        let dictParam:[String:String] =
            [PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken(),
             PARAMS.USER_ID : preferenceHelper.getUserId(),
             PARAMS.START_DATE : startDate,
             PARAMS.END_DATE : endDate]
        
        let alamoFire:AlamofireHelper = AlamofireHelper()
        alamoFire.getResponseFromURL(url: WebService.WS_GET_HISTORY, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            self.arrForCreateAt .removeAllObjects()
            self.arrForHistory .removeAllObjects()
            Parser.parseOrderHistory(response, toArray: self.arrForHistory, completion: {
                [weak self] result in
                
                Utility.hideLoading()
                
                guard let self = self else { return }
                
                self.createSection()

                if self.arrForHistory.count == 0 {
                    self.viewForHeader?.isHidden = true
                }else{
                    self.viewForHeader?.isHidden = false
                }
                if self.filterType != .all {
                    self.reloadData(filter: self.filterType)
                }
            })
        }
    }
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
                        self.updateUiOrders(isUpdate: true)
                        self.hasCurrentOrderData = true
                        self.viewCurrentOrderHeader?.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 50.0)
                    }
                    else
                    {
                        self.updateUiOrders()
                        self.hasCurrentOrderData = false
                        self.viewCurrentOrderHeader?.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 0.0)
                    }
                    self.tableForCurrentOrders?.reloadData()
                    Utility.hideLoading()
                    if self.filterType != .all {
                        self.reloadData(filter: self.filterType)
                    }
                    self.wsGetHistory(startDate: self.strFromDate, endDate: self.strToDate)
                }
            })
        }
    }
}
