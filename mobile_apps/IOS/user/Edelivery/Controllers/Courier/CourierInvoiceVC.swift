//
//  HomeVC.swift
//  edelivery
//
//  Created by Elluminati on 14/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class CourierInvoiceVC: BaseVC,UITableViewDelegate,UITableViewDataSource,LeftDelegate {
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblTotalValue: UILabel!
    @IBOutlet weak var btnPlaceOrder: UIButton!
    @IBOutlet var viewForTotal: UIView!
    @IBOutlet weak var tableForInvoice: UITableView!
    @IBOutlet weak var viewForInvoice: UIView!
    
    @IBOutlet weak var tblCorierSpecification: UITableView!
    @IBOutlet weak var btnViewInvoice: UIButton!
    
    @IBOutlet weak var lblInvoiceTitle: UILabel!
    
    @IBOutlet var lblMinFareUsed: UILabel!
    
    @IBOutlet var heightTableSpecification: NSLayoutConstraint!
    @IBOutlet var heightTableInvoice: NSLayoutConstraint!
    
    var arrSpecificationListMain = [Specifications]()
    var arrSpecificationList = [Specifications]()
    
    var requiredCount:Int = 0
    var total: Double = 0
    
    var selectedVehicleId: String = ""
    var arrForInvoice: NSMutableArray = NSMutableArray.init()
    var timeZone: TimeZone = TimeZone.init(identifier: currentBooking.selectedCityTimezone) ?? TimeZone.current
    
    var totalTime: Double = 0
    var totalDistance: Double = 0
    var isRoundTrip = false
    var cartOrder: CartOrder?
    var response: InvoiceResponse?
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        super.hideBackButtonTitle()
        
        setLocalization()
        prepareInvoicePARAMS(totalCartPrice: 0, isLoadingSpecification: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.delegateLeft = self
        
        tblCorierSpecification.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        tableForInvoice.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        tblCorierSpecification.removeObserver(self, forKeyPath: "contentSize")
        tableForInvoice.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        heightTableSpecification.constant = tblCorierSpecification.contentSize.height
        heightTableInvoice.constant = tableForInvoice.contentSize.height
    }
    
    func setLocalization() {
        
        /*Set Color*/
        lblTotal.textColor = UIColor.themeLightTextColor
        self.setNavigationTitle(title:"TXT_COURIER_ORDER_INVOICE".localizedCapitalized)
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        tableForInvoice.backgroundColor = UIColor.themeViewBackgroundColor
        viewForTotal.backgroundColor = UIColor.themeViewBackgroundColor
        btnPlaceOrder.backgroundColor = UIColor.themeButtonBackgroundColor
        btnPlaceOrder.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        btnPlaceOrder.setTitle("TXT_PLACEORDER".localizedCapitalized, for: .normal)
        lblTotal.text = "TXT_TOTAL".localizedCapitalized
        lblMinFareUsed.text = "TXT_MIN_FARE_APPLIED".localized
        lblMinFareUsed.font = FontHelper.textRegular()
        lblMinFareUsed.textColor = UIColor.themeSectionBackgroundColor
        tableForInvoice.rowHeight = UITableView.automaticDimension
        tableForInvoice.estimatedRowHeight = 30
        
        /* Set Font */
        btnPlaceOrder.titleLabel?.font = FontHelper.buttonText()
        lblTotalValue.font = FontHelper.textMedium(size: 30)
        lblTotal.font = FontHelper.textRegular()
        
        lblInvoiceTitle.textColor = UIColor.themeTitleColor
        lblInvoiceTitle.font = FontHelper.textMedium(size: FontHelper.mediumLarge)
        lblInvoiceTitle.text = "TXT_INVOICE".localized
        
        self.setBackBarItem(isNative: false)
        
        tblCorierSpecification.delegate = self
        tblCorierSpecification.dataSource = self
        tblCorierSpecification.separatorColor = UIColor.clear
        tblCorierSpecification.register(cellTypes: [ProductSpecificationCell.self,ProductSpecificationSection.self])
        tblCorierSpecification.backgroundColor = UIColor.themeViewBackgroundColor
        tblCorierSpecification.tableFooterView?.backgroundColor = UIColor.themeViewBackgroundColor
        
        btnViewInvoice.backgroundColor = UIColor.themeButtonBackgroundColor
        btnViewInvoice.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        btnViewInvoice.setTitle("TXT_VIEW_INVOICE".localizedCapitalized, for: .normal)
        
        
    }
    
    override func updateUIAccordingToTheme() {
        setLocalization()
    }
    
    func onClickLeftButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func reArrageArrayWithAssociateSP(arr: [Specifications]) {
        
        arrSpecificationList.removeAll()
        
        var arrReArrage = [Specifications]()
        arrReArrage = arr.filter({!$0.isAssociated})
        
        for obj in arrReArrage {
            self.arrSpecificationList.append(obj)
        }
        
        let arrId = arrSpecificationList.map({$0._id})
        var arrSelected = [SpecificationListItem]()
        
        for obj in arrSpecificationList {
            for objList in (obj.list ?? []) {
                if objList.is_default_selected {
                    arrSelected.append(objList)
                }
            }
        }
        
        for objMain in arrSpecificationListMain {
            for obj in arrSelected {
                if objMain.modifierId == obj._id && !arrId.contains(objMain._id) {
                    arrSpecificationList.append(objMain)
                } else if objMain.modifierId == obj._id && arrId.contains(objMain._id){
                    if let index = arrSpecificationList.firstIndex(where: {$0._id == objMain._id}) {
                        arrSpecificationList.remove(at: index)
                        arrSpecificationList.insert(objMain, at: index)
                    }
                }
            }
        }
        
        setIsRequired()
        self.calculateTotalAmount()
    }
    
    func setIsRequired() {
        requiredCount = 0
        if arrSpecificationList.count > 0{
            for specificationsItem:Specifications in arrSpecificationList {
                if specificationsItem.is_required! {
                    requiredCount += 1
                }
                if specificationsItem.rangeMax == 0 && specificationsItem.range == 0 {
                    specificationsItem.selectionMessage = ""
                }else if specificationsItem.rangeMax == 0 && specificationsItem.range > 0 {
                    specificationsItem.selectionMessage = "TXT_CHOOSE".localized + " " + String(specificationsItem.range)
                }else if specificationsItem.rangeMax > 0 && specificationsItem.range > 0 {
                    specificationsItem.selectionMessage = "TXT_CHOOSE".localized + " " + String(specificationsItem.range) + " - " + String(specificationsItem.rangeMax)
                }else if specificationsItem.rangeMax > 0 && specificationsItem.range == 0 {
                    if specificationsItem.rangeMax == 0 {
                        specificationsItem.selectionMessage = "TXT_CHOOSE".localized + " " + String(specificationsItem.rangeMax)
                    }
                    else {
                        specificationsItem.selectionMessage = "TXT_CHOOSE_UP_TO".localized + " " + String(specificationsItem.rangeMax)
                    }
                }else {
                    specificationsItem.selectionMessage = ""
                }
                specificationsItem.selectedCount = 0
                for itemList in specificationsItem.list! {
                    if itemList.is_default_selected {
                        specificationsItem.selectedCount = specificationsItem.selectedCount +  1
                    }
                }
            }
        }
    }
    
    func calculateTotalAmount() {
        total = 0//Double((selectedProductItem?.price)!)
        var requiredCountTemp = 0
        for currentProduct in arrSpecificationList {
            for currentProductItem in currentProduct.list! {
                if currentProductItem.is_default_selected {
                    total = total + (Double(currentProductItem.price!) * Double(currentProductItem.quantity))
                }
            }
            if (currentProduct.is_required! && currentProduct.selectedCount >= currentProduct.range
                && (currentProduct.rangeMax == 0  || currentProduct.selectedCount <= currentProduct
                    .rangeMax)) {
                if currentProduct.selectedCount != 0 {
                    requiredCountTemp += 1
                }
            }
        }
        if (requiredCountTemp == requiredCount) {
            btnViewInvoice.enable(true)
        } else {
            btnViewInvoice.enable(false)
        }
    }
    
    //MARK:- Range Selection Validation
    func isValidSelection(range:Int,maxRange:Int,selectedCount: Int,isDefaultSelected:Bool) -> Bool {
        
        if (range == 0 && maxRange == 0)
        {
            return  !isDefaultSelected
        }
        else if (selectedCount <= range
                 && maxRange == 0) {
            return selectedCount != range &&  !isDefaultSelected
        }
        else if (selectedCount <= maxRange
                 && range >= 0) {
            return  (selectedCount != maxRange &&  !isDefaultSelected)
        }else {
            return  isDefaultSelected
        }
    }
    
    //MARK: TABLEVIEW DELEGATE METHODS
    @IBAction func onClickPlaceOrder(_ sender: Any) {
        currentBooking.isCourier = true
        currentBooking.isHidePayNow = false
        self.gotoPayment()
    }
    
    @IBAction func onClickViewInvoice(_ sender: Any) {
        addToCart()
        wsAddItemInServerCart()
    }
    
    func gotoPayment() {
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "Cart", bundle: nil)
        if let paymentVC : PaymentVC = mainView.instantiateViewController(withIdentifier: "paymentVC") as? PaymentVC {
            self.navigationController?.pushViewController(paymentVC, animated: true)
        }
    }
    
    func showInvoiceList(bool: Bool) {
        viewForInvoice.isHidden = !bool
        btnViewInvoice.isHidden = bool
        btnPlaceOrder.isHidden = !bool
        viewForTotal.isHidden = !bool
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == tblCorierSpecification {
            return UITableView.automaticDimension
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tblCorierSpecification {
            return arrSpecificationList.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblCorierSpecification {
            if arrSpecificationList.count > 0 {
                let count = arrSpecificationList[section].list?.count ?? 0
                return count
            }else{
                return 0
            }
        }
        return arrForInvoice.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == tblCorierSpecification {
            let sectionHeader = tableView.dequeueReusableCell(withIdentifier: "ProductSpecificationSection")! as! ProductSpecificationSection
            sectionHeader.setData(title: arrSpecificationList[section].name!, isAllowMultipleSelect: Bool(truncating: (arrSpecificationList[section].type! as NSNumber)), isRequired: arrSpecificationList[section].is_required!,message: arrSpecificationList[section].selectionMessage)
            return sectionHeader
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if tableView == tblCorierSpecification {
            let sectionType = arrSpecificationList[indexPath.section].type!
            
            let productSpecificationCell = tableView.dequeueReusableCell(with: ProductSpecificationCell.self, for: indexPath)
            let currentProduct:Specifications = arrSpecificationList[indexPath.section]
            let currentProductItem:SpecificationListItem = currentProduct.list![indexPath.row]
            
            productSpecificationCell.setCellData(cellItem: currentProductItem, isAllowMultipleSelect: sectionType,currency: currentBooking.currency ,arrSpecificationFromProductVC: self.arrSpecificationList[indexPath.section].list![indexPath.row],isFromCart: false)
            
            if !arrSpecificationList[indexPath.section].user_can_add_specification_quantity {
                productSpecificationCell.viewQty.isHidden = true
            }
            productSpecificationCell.delegate = self
            return productSpecificationCell
        }
        let cell:InvoiceCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! InvoiceCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let currentInvoiceItem:Invoice = arrForInvoice.object(at: indexPath.row) as! Invoice
        cell.setCellData(cellItem: currentInvoiceItem)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblCorierSpecification {
            tableView.deselectRow(at: indexPath, animated: false)
            let currentSpecificationGroup = (arrSpecificationList[indexPath.section])
            
            if let specificationSubItem:SpecificationListItem = currentSpecificationGroup.list?[indexPath.row] {
                
                let sectionType = currentSpecificationGroup.type
                if sectionType == 2 {
                    let checked = isValidSelection(range: currentSpecificationGroup.range, maxRange: currentSpecificationGroup.rangeMax, selectedCount: currentSpecificationGroup.selectedCount, isDefaultSelected: specificationSubItem.is_default_selected)
                    
                    if checked &&  !specificationSubItem.is_default_selected {
                        currentSpecificationGroup.selectedCount += 1
                    }
                    else if !checked  && specificationSubItem.is_default_selected {
                        currentSpecificationGroup.selectedCount -= 1
                    }
                    specificationSubItem.is_default_selected = checked
                    
                    if !checked {
                        specificationSubItem.quantity = 1
                    }
                    
                }else {
                    let count = arrSpecificationList[indexPath.section].list!.count
                    for row in 0...count-1 {
                        (currentSpecificationGroup.list![row] ).is_default_selected = false
                    }
                    (currentSpecificationGroup.list![indexPath.row] ).is_default_selected = true
                    currentSpecificationGroup.selectedCount = 1
                    
                    for objMain in self.arrSpecificationListMain {
                        if objMain._id == currentSpecificationGroup._id {
                            objMain.selectedCount = 1
                            for objList in (objMain.list ?? []) {
                                if objList._id == specificationSubItem._id {
                                    objList.is_default_selected = true
                                } else {
                                    objList.is_default_selected = false
                                }
                            }
                        }
                    }
                    
                    self.reArrageArrayWithAssociateSP(arr: self.arrSpecificationListMain)
                    
                }
            }
            
            self.tblCorierSpecification.reloadData()
            calculateTotalAmount()
            
            self.showInvoiceList(bool: false)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblCorierSpecification {
            return UITableView.automaticDimension
        }
        return UITableView.automaticDimension
    }
    
    func openMinAmountDialog(amount:String) {
        let minAmountMessage:String = "TXT_MIN_INVOICE_AMOUNT_MSG".localized + amount
        let dialogForMinAmount = CustomAlertDialog.showCustomAlertDialog(title: "TXT_MIN_AMOUNT".localized, message: minAmountMessage, titleLeftButton: "", titleRightButton: "TXT_ADD_MORE_ITEMS".localizedCapitalized)
        dialogForMinAmount.onClickLeftButton = {
            [unowned dialogForMinAmount] in
            dialogForMinAmount.removeFromSuperview()
        }
        dialogForMinAmount.onClickRightButton = {
            [unowned self,unowned dialogForMinAmount] in
            dialogForMinAmount.removeFromSuperview()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK:- NAVIGATION METHODS
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier?.compare(SEGUE.SEGUE_STORE_LIST) == ComparisonResult.orderedSame) {
            
        }
    }
    
    //MARK:- WEB SERVICE
    func getTimeAndDistance(srcLat:Double, srcLong:Double, destLat:Double, destLong:Double)->(String,String) {
        
        var timeAndDistance:(time:String, distance:String)
        timeAndDistance.time = "0"
        timeAndDistance.distance = "0"
        let src_lat: String = String(srcLat)
        let src_long: String = String(srcLong)
        let dest_lat: String = String(destLat)
        let dest_long: String = String(destLong)
        
        let request = URL(string: "https://maps.googleapis.com/maps/api/distancematrix/json?origins=\(src_lat),\(src_long)&destinations=\(dest_lat),\(dest_long)&key=\(Google.API_KEY)")
        let parseData = parseJSON(inputData: getJSON(urlToRequest: request!))
        
        let googleRsponse: GoogleDistanceMatrixResponse = GoogleDistanceMatrixResponse(dictionary:parseData)!
        if ((googleRsponse.status?.compare("OK")) == ComparisonResult.orderedSame) {
            timeAndDistance.time = String((googleRsponse.rows?[0].elements?[0].duration?.value) ?? 0)
            timeAndDistance.distance = String((googleRsponse.rows?[0].elements?[0].distance?.value) ?? 0)
            
        }
        return timeAndDistance
    }
    
    func getJSON(urlToRequest:URL) -> Data {
        var content:Data?
        do {
            content = try Data(contentsOf:urlToRequest)
        }
        catch let error {
            printE(error)
        }
        return content ?? Data.init()
    }
    
    func parseJSON(inputData:Data) -> NSDictionary{
        let dictData = (try! JSONSerialization.jsonObject(with: inputData, options: .mutableContainers)) as! NSDictionary
        return dictData
    }
    
    func wsGetInvoice(dictParam:Dictionary<String,Any>, isLoadingSpecification: Bool){
        Utility.showLoading()
        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_GET_COURIER_INVOICE, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response,error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response) {
                
                let invoiceResponse:InvoiceResponse = InvoiceResponse.init(dictionary: response)!
                self.response = invoiceResponse
                currentBooking.currentServerTime = invoiceResponse.serverTime
                self.timeZone = TimeZone.init(identifier:invoiceResponse.timeZone)!
                
                currentBooking.currentDateMilliSecond = Utility.convertServerDateToMilliSecond(serverDate:currentBooking.currentServerTime , strTimeZone: self.timeZone.identifier)
                
                if isLoadingSpecification {
                    self.arrSpecificationList.removeAll()
                    self.arrSpecificationListMain.removeAll()
                    
                    if let itesm = response["item_detail"] as? [String:Any] {
                        if let sepecifications = itesm["specifications"] as? [[String:Any]] {
                            for obj in sepecifications {
                                let specificationsResponse:Specifications = Specifications.init(dictionary: obj as NSDictionary)!
                                self.arrSpecificationListMain.append(specificationsResponse)
                            }
                        }
                    }
                    self.showInvoiceList(bool: false)
                }
                
                if !isLoadingSpecification || self.arrSpecificationListMain.count == 0 {
                    Parser.parseInvoice(invoiceResponse.order_payment!, toArray: self.arrForInvoice, currency:currentBooking.currency,isTaxIncluded: invoiceResponse.isTaxIncluded, completetion: { (result) in
                        if (result) {
                            self.lblMinFareUsed.isHidden = !(invoiceResponse.order_payment?.isMinFareApplied ?? false)
                            self.tableForInvoice?.reloadData()
                            self.lblTotalValue.text = currentBooking.currency + " " + (PaymentConfig.shared.total).toString()
                        }
                    })
                    
                    self.showInvoiceList(bool: true)
                }
                
            }else {
                let isSuccess:IsSuccessResponse = IsSuccessResponse.init(dictionary: response)!
                if isSuccess.errorCode! == CONSTANT.ERROR_MINMUM_INVOICE_AMOUNT {
                    let minAmount = (response.value(forKey: PARAMS.MIN_ORDER_PRICE) as? Double)?.roundTo() ?? 0.0
                    self.openMinAmountDialog(amount:String(minAmount))
                }
            }
            self.reArrageArrayWithAssociateSP(arr: self.arrSpecificationListMain)
            
            if self.arrSpecificationList.count > 0 {
                self.tblCorierSpecification.isHidden = false
            } else {
                self.tblCorierSpecification.isHidden = true
            }
            self.tblCorierSpecification.reloadData()
        }
    }
    
    func addToCart() {
        
        guard let response = response else {
            return
        }
        
        var specificationPriceTotal = 0.0
        var specificationPrice = 0.0
        var specificationList:[Specifications] = [Specifications].init()
        
        for specificationListItem in arrSpecificationList {
            
            var specificationItemCartList:[SpecificationListItem] = [SpecificationListItem].init()
            
            for listItem in specificationListItem.list! {
                if (listItem.is_default_selected) {
                    specificationPrice = specificationPrice + (listItem.price! * Double(listItem.quantity))
                    specificationPriceTotal = specificationPriceTotal + (listItem.price! * Double(listItem.quantity))
                    specificationItemCartList.append(listItem)
                }
            }
            
            if !specificationItemCartList.isEmpty {
                let specificationsItem:Specifications = Specifications()
                specificationsItem.list = specificationItemCartList
                specificationsItem.unique_id = specificationListItem.unique_id
                specificationsItem.name = specificationListItem.name
                specificationsItem.price = specificationPrice
                specificationsItem.type = specificationListItem.type
                specificationsItem.range = specificationListItem.range
                specificationsItem.rangeMax = specificationListItem.rangeMax
                specificationsItem.is_required = specificationListItem.is_required
                

                specificationList.append(specificationsItem)
            }
            specificationPrice = 0
        }
        
        let cartProductItems:CartProductItems = CartProductItems.init()
        
        guard let itemDetail = response.itemDetail else {
            return
        }
        
        cartProductItems.item_id = itemDetail._id ?? ""
        cartProductItems.unique_id = itemDetail.unique_id ?? 0
        cartProductItems.item_name = itemDetail.name ?? ""
        cartProductItems.quantity = itemDetail.quantity
        cartProductItems.image_url = itemDetail.image_url ?? []
        cartProductItems.details = itemDetail.details ?? ""
        cartProductItems.specifications = specificationList
        cartProductItems.item_price = itemDetail.price ?? 0
        cartProductItems.total_specification_price = specificationPriceTotal
        cartProductItems.totalItemPrice = total
        cartProductItems.taxDetails = itemDetail.taxDetails ?? []
        cartProductItems.noteForItem = ""
        cartProductItems.totalPrice = (itemDetail.price ?? 0) + specificationPriceTotal
        
        var tax = 0.0
        
        for obj in (itemDetail.taxDetails ?? []) {
            tax = tax + Double(obj.tax)
        }
        

        let itemTax = getTax(itemAmount: itemDetail.price, taxValue: tax)
        let specificationTax = getTax(itemAmount: specificationPriceTotal, taxValue: tax)
        let totalTax = itemTax + specificationTax
        cartProductItems.tax = tax
        cartProductItems.itemTax = itemTax
        cartProductItems.totalSpecificationTax = specificationTax
        cartProductItems.totalTax = totalTax
        cartProductItems.totalItemTax = totalTax * Double(1)
        
        var cartProductItemsList:[CartProductItems] = [CartProductItems].init()
        cartProductItemsList.append(cartProductItems)
        let cartProducts:CartProduct = CartProduct.init()
        cartProducts.items = cartProductItemsList
        cartProducts.product_id = itemDetail.product_id
        cartProducts.product_name = itemDetail.name
        cartProducts.unique_id = itemDetail.unique_id
        cartProducts.total_item_price = total
        cartProducts.totalItemTax =  cartProductItems.totalItemTax
        cartOrder?.order_details?.append(cartProducts)
    }
    
    func wsAddItemInServerCart() {
        
        guard let cartOrder = cartOrder else {
            return
        }
        
        Utility.showLoading()
  
        let dictData:NSDictionary = (cartOrder.dictionaryRepresentation())
        dictData.setValue(currentBooking.bookCountryId ?? "", forKey: PARAMS.COUNTRY_ID)
        dictData.setValue(currentBooking.bookCityId ?? "", forKey: PARAMS.CITY_ID)
        dictData.setValue(DeliveryType.courier, forKey: PARAMS.DELIVERY_TYPE)
        print(Utility.convertDictToJson(dict: dictData as! Dictionary<String, Any>))
        print("dicdata \(dictData)")
        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_ADD_ITEM_IN_CART, methodName: AlamofireHelper.POST_METHOD, paramData: dictData as? Dictionary<String, Any>) { (response,error) -> (Void) in
            print("response \(response)")
            Utility.hideLoading()
            if (Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true)) {
                currentBooking.cartId = (response.value(forKey: "cart_id") as? String) ?? ""
                currentBooking.cartCityId = (response.value(forKey: "city_id") as? String) ?? ""
                currentBooking.deliveryType = DeliveryType.courier
                self.prepareInvoicePARAMS(totalCartPrice: self.total, isLoadingSpecification: false)
            }
        }
    }
    
    func prepareInvoicePARAMS(totalCartPrice: Double, isLoadingSpecification: Bool) {
        //let storeLatLong = currentBooking.courierPickupAddress[0].location ?? [0.0,0.0]
        //let deliveryLatLong = currentBooking.courierDestinationAddress[0].location ?? [0.0,0.0]
        
        
        var dictParam:[String:Any] = APPDELEGATE.getCommonDictionary()
        dictParam[PARAMS.TOTAL_TIME] = totalTime
        dictParam[PARAMS.TOTAL_DISTANCE] = totalDistance
        dictParam[PARAMS.COUNTRY_ID] = currentBooking.bookCountryId ?? ""
        dictParam[PARAMS.CITY_ID] = currentBooking.bookCityId ?? ""
        dictParam[PARAMS.VEHICLE_ID] = currentBooking.selectedVehicleId
        dictParam[PARAMS.is_round_trip] = currentBooking.isRoundTrip
        dictParam[PARAMS.no_of_stop] = currentBooking.courierNoOfStop
        dictParam[PARAMS.TOTAL_CART_PRICE] = totalCartPrice
        
        wsGetInvoice(dictParam: dictParam, isLoadingSpecification: isLoadingSpecification)
    }
    
    func getTax(itemAmount:Double, taxValue:Double) -> Double {
        if !currentBooking.isTaxIncluded{
            return itemAmount * taxValue * 0.01
        }else{
            return (itemAmount - (100*itemAmount)/(100+taxValue))
        }
    }
    
}

extension CourierInvoiceVC: SpecificationCellDelegae {
    func specificationButtonAction(cell: ProductSpecificationCell, sender: UIButton) {
        if let indexPath = tblCorierSpecification.indexPath(for: cell) {
            let obj = arrSpecificationList[indexPath.section].list![indexPath.row]
            if sender == cell.btnPluse {
                obj.quantity += 1
            } else if sender == cell.btnMinus {
                let qty = obj.quantity
                if qty > 1 {
                    obj.quantity -= 1
                }
            }
            calculateTotalAmount()
            tblCorierSpecification.reloadData()
        }
    }
}
