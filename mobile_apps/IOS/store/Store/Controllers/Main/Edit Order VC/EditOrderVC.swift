//
//  HomeVC.swift
// Edelivery Store
//
//  Created by Jaydeep Vyas on 14/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit


class EditOrderVC: BaseVC,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,RightDelegate,LeftDelegate {
    //MARK: OutLets
    @IBOutlet weak var lblUpdateOrder: UILabel!
    @IBOutlet weak var imgEmpty: UIImageView!
    @IBOutlet weak var viewForTotal: UIView!
    @IBOutlet weak var lblTotalValue: UILabel!
    @IBOutlet weak var tableForEditOrderItems: UITableView!
    //MARK: Variables
    
    var currentOrder = StoreSingleton.shared.updateOrder!;
    var selectedItemId:[String] = [];
    
    var selectedItem:OrderItem? = nil;
    let btnAddItem = UIButton.init(type: .custom)
    
    //MARK:
    //MARK: View life cycle
    override func viewDidLoad(){
        super.viewDidLoad()
        
        tableForEditOrderItems.rowHeight = UITableView.automaticDimension
        tableForEditOrderItems.estimatedRowHeight = 105
        self.setNavigationTitle(title: "TXT_UPDATE_ORDER".localizedCapitalized)
        
        btnAddItem.sizeToFit()
        btnAddItem.setImage(UIImage(named: "add")?.imageWithColor(color: .themeColor), for: .normal)
        self.setRightBarButton(button: btnAddItem);
        self.setBackBarItem(isNative: false)
        delegateRight = self
        delegateLeft = self
        
        if currentOrder.orderDetails.count > 0{
            setLocalization()
            wsGetItemDetails()
            
        }
    }
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        if currentOrder.orderDetails.count == 0{
            wsGetOrderDetail()
        }
        if currentOrder.orderDetails.count == 0 {
            updateUI(isUpdate: false)
        }else {
            tableForEditOrderItems?.reloadData();
            calculateTotalAmount()
        }
    }
    func onClickLeftButton() {
        if !viewForTotal.isHidden{
            self.navigationController?.popViewController(animated: true)
        }else{
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
    }
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews();
        setupLayout()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(_ animated: Bool){
        super.viewDidDisappear(animated)
    }
    func setLocalization(){
        //Colors
        
        lblTotalValue.textColor = UIColor.themeButtonTitleColor
        lblUpdateOrder.textColor = UIColor.themeButtonTitleColor
        lblUpdateOrder.backgroundColor = UIColor.themeColor
        viewForTotal.backgroundColor = UIColor.themeColor
        viewForTotal.layer.cornerRadius = viewForTotal.layer.frame.size.height/2
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        self.tableForEditOrderItems.backgroundColor = UIColor.themeViewBackgroundColor
        //Localizing
        //        title = "TXT_BASKET".localized
        title = "TXT_UPDATE_ORDER".localized
        
        lblTotalValue.text = "TXT_DEFAULT".localized
        lblUpdateOrder.text = "TXT_UPDATE_ORDER".localizedUppercase
        
        /*Set Font*/
        
        lblTotalValue.font = FontHelper.textRegular()
        lblUpdateOrder.font = FontHelper.textRegular()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.onClickCheckOut(_:)))
        gestureRecognizer.delegate = self
        viewForTotal.addGestureRecognizer(gestureRecognizer)
        
        for product in currentOrder.orderDetails {
            for item in product.items {
                selectedItemId.append(item.itemId)
            }
        }
        self.hideBackButtonTitle()
    }
    
    override func updateUIAccordingToTheme() {
        setBackBarItem(isNative: false)
        self.tableForEditOrderItems.reloadData()
    }
    
    func setupLayout(){
        if tableForEditOrderItems != nil{
            tableForEditOrderItems.tableFooterView = UIView()
            btnAddItem.setRound(withBorderColor: UIColor.clear, andCornerRadious: 7.0, borderWidth: 1.0)
        }
        
    }
    func onClickRightButton() {
        self.performSegue(withIdentifier:SEGUE.ITEM_LIST, sender: nil)
        
    }
    //MARK: TABLEVIEW DELEGATE METHODS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return currentOrder.orderDetails[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:EditOrderCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! EditOrderCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let currentProduct:OrderDetail = currentOrder.orderDetails[indexPath.section]
        
        
        let currentItem:OrderItem =    currentProduct.items[indexPath.row]
        cell.setCellData(cellItem: currentItem, section: indexPath.section, row: indexPath.row, parent: self)
        return cell;
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {   return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let mySelectedItem:OrderItem = currentOrder.orderDetails[indexPath.section].items[indexPath.row]
        
        if let index:Int = currentOrder.serverItems.index(where: { (item) -> Bool in
                                                            item.uniqueId == mySelectedItem.uniqueId }) {
            let serverItem:OrderItem =  currentOrder.serverItems[index]
            
            
            selectedItem  = OrderItem.init(fromDictionary: mySelectedItem.toDictionary(isPassArray: false))
            
            selectedItem?.specifications.removeAll()
            
            for specification in serverItem.specifications {
                
                if let mySelectedSpecification:OrderSpecification = mySelectedItem.specifications.first(where: { (localSpecification) -> Bool in
                    localSpecification.user_can_add_specification_quantity = specification.user_can_add_specification_quantity
                    localSpecification.id = specification.id
                    localSpecification.modifierName = specification.modifierName
                    localSpecification.modifierGroupName = specification.modifierGroupName
                    localSpecification.modifierId = specification.modifierId
                    localSpecification.modifierGroupId = specification.modifierGroupId
                    localSpecification.isParentAssociate = specification.isParentAssociate
                    localSpecification.isAssociated = specification.isAssociated
                    return localSpecification.uniqueId == specification.uniqueId
                }) {
                    let newMySelectedSpecification:OrderSpecification = OrderSpecification.init(fromDictionary: mySelectedSpecification.toDictionary(isPassArray: false))
                    
                    newMySelectedSpecification.range = mySelectedSpecification.range
                    newMySelectedSpecification.rangeMax = mySelectedSpecification.rangeMax
                    newMySelectedSpecification.isRequired = mySelectedSpecification.isRequired
                    newMySelectedSpecification.specificationName = mySelectedSpecification.specificationName
                    newMySelectedSpecification.specificationPrice = mySelectedSpecification.specificationPrice
                    newMySelectedSpecification.selectionMessage = mySelectedSpecification.selectionMessage
                    newMySelectedSpecification.id = mySelectedSpecification.id
                    newMySelectedSpecification.modifierName = mySelectedSpecification.modifierName
                    newMySelectedSpecification.modifierGroupName = mySelectedSpecification.modifierGroupName
                    newMySelectedSpecification.modifierId = mySelectedSpecification.modifierId
                    newMySelectedSpecification.modifierGroupId = mySelectedSpecification.modifierGroupId
                    newMySelectedSpecification.isParentAssociate = mySelectedSpecification.isParentAssociate
                    newMySelectedSpecification.isAssociated = mySelectedSpecification.isAssociated
                    

                    newMySelectedSpecification.list.removeAll()
                    for listItem in specification.list
                    {
                        var quntity = 1
                        if mySelectedSpecification.list.first(where: { (localListItem) -> Bool in
                            quntity = localListItem.quantity
                            return localListItem.uniqueId == listItem.uniqueId
                        }) != nil
                        {
                            listItem.isDefaultSelected = true
                            listItem.quantity = quntity
                            newMySelectedSpecification.list.append(listItem)
                        }
                        else
                        {
                            listItem.isDefaultSelected = false
                            newMySelectedSpecification.list.append(listItem)
                        }
                    }
                    selectedItem?.specifications.append(newMySelectedSpecification)
                }
                else {
                    selectedItem?.specifications.append(specification)
                }
            }
            
            self.performSegue(withIdentifier: SEGUE.UPDATE_ORDER_PRODUCT_SPECIFICATION, sender: indexPath)
        }
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return currentOrder.orderDetails.count
    }
    //MARK: USER DEFINE FUNCTION
    
    func updateUI(isUpdate:Bool = false) {
        tableForEditOrderItems.isHidden = !isUpdate
        viewForTotal.isHidden = !isUpdate
        imgEmpty.isHidden = isUpdate
        lblUpdateOrder.isHidden = !isUpdate
    }
    
    public func increaseQuantity(currentProductItem:OrderItem){
        var quantitiy = currentProductItem.quantity!;
        quantitiy = quantitiy + 1
        let total = (currentProductItem.totalSpecificationPrice + currentProductItem.itemPrice) * Double(quantitiy)
        currentProductItem.totalItemTax =  currentProductItem.totalTax * Double(quantitiy)
        currentProductItem.totalItemPrice = total
        
        currentProductItem.quantity = quantitiy
        self.tableForEditOrderItems?.reloadData()
        
        calculateTotalAmount()
        
    }
    
    public func decreaseQuantity(currentProductItem:OrderItem){
        var quantitiy = currentProductItem.quantity!;
        if (quantitiy > 1 ) {
            quantitiy = quantitiy - 1
            let total = (currentProductItem.totalSpecificationPrice + currentProductItem.itemPrice) * Double(quantitiy)
            currentProductItem.totalItemTax =  currentProductItem.totalTax * Double(quantitiy)
            currentProductItem.totalItemPrice = total
            
            currentProductItem.quantity = quantitiy
            self.tableForEditOrderItems?.reloadData()
            calculateTotalAmount()
        }
        
    }
    
    public func removeItemFromCart(currentProductItem:OrderItem, section:Int, row:Int){
        let currentProduct:OrderDetail = currentOrder.orderDetails[section]
        currentProduct.items.remove(at: row)
        if currentProduct.items.count == 0 {
            currentOrder.orderDetails.remove(at: section)
        }
        
        self.tableForEditOrderItems?.reloadData()
        calculateTotalAmount()
    }
    
    func calculateTotalAmount(){
        var total = 0.0
        var totalCartAmountWithoutTax = 0.0
        
        for currentProduct in currentOrder.orderDetails {
            for currentProductItem in currentProduct.items! {
                total = total + Double(currentProductItem.totalItemPrice!)
                
                var eachItemTax = 0
                
                if !currentOrder.isUseItemTaxOld{
                    for obj in currentOrder.storeTaxDetailsOld{
                        eachItemTax = eachItemTax + obj.tax
                    }
                }else{
                    for obj in currentProductItem.taxDetails{
                        eachItemTax = eachItemTax + obj.tax
                    }
                }
                print(eachItemTax)
                
                let specificationPriceTotal = currentProductItem.totalSpecificationPrice!
                
                let itemTax = getTax(itemAmount: currentProductItem.itemPrice!, taxValue: Double(eachItemTax)) * Double(currentProductItem.quantity)
                let specificationTax = getTax(itemAmount: specificationPriceTotal, taxValue: Double(eachItemTax)) * Double(currentProductItem.quantity)
                let totalTax = itemTax + specificationTax
                print(totalTax)
                
                if currentOrder.isTaxIncludedOld{
                    total = total - totalTax
                }
                totalCartAmountWithoutTax = totalCartAmountWithoutTax + Double(currentProductItem.totalItemPrice!)
            }
        }
        setTotalAmount(total,totalCartAmountWithoutTax: totalCartAmountWithoutTax)
    }
    
    func getTax(itemAmount:Double, taxValue:Double) -> Double {
        //        return itemAmount * taxValue * 0.01
        if !currentOrder.isTaxIncludedOld{
            return itemAmount * taxValue * 0.01
        }else{
            return (itemAmount - (100*itemAmount)/(100+taxValue))
        }
    }
    
    func setTotalAmount(_ total:Double = 0.0,totalCartAmountWithoutTax:Double = 0.0) {
        currentOrder.totalOrderPrice = total;
        currentOrder.totalCartAmountWithoutTax = totalCartAmountWithoutTax
        
        let strTotal =  (totalCartAmountWithoutTax.roundTo()).toCurrencyString()
        lblTotalValue.text = strTotal
        
        var isModifyCart = false;
        for cartProduct in currentOrder.orderDetails {
            if (cartProduct.items.count) > 0 {
                isModifyCart = true
            }
        }
        if  isModifyCart {
            updateUI(isUpdate: true)
        }else {
            updateUI(isUpdate: false)
            
        }
    }
    
    //MARK:- NAVIGATION METHODS
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ==  SEGUE.UPDATE_ORDER_PRODUCT_SPECIFICATION {
            let destinationVC: UpdateOrderProductSpecificationVC = segue.destination as! UpdateOrderProductSpecificationVC
            destinationVC.selectedIndexPath = sender as! IndexPath
            destinationVC.selectedOrderItem = selectedItem
            destinationVC.productName = selectedItem?.itemName
            
        }else {
            let destinationVC: OrderItemListVC = segue.destination as! OrderItemListVC
            destinationVC.isFromUpdateOrder = true
        }
    }
    
    @IBAction func onClickCheckOut(_ sender: Any) {
        
        if currentOrder.orderDetails.count > 0 {
            wsupdateOrder()
        }
        
    }
    
    func wsGetOrderDetail() {
        let dictParam : [String : Any] =
            [PARAMS.STORE_ID      : preferenceHelper.getUserId(),
             PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken(),
             PARAMS.ORDER_ID: currentOrder.orderId]
        
        print("dictParam WS_GET_ORDER_DETAIL --> \(dictParam)")
        
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_GET_ORDER_DETAIL, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {   (response, error) -> (Void) in
            
            print("response WS_GET_ORDER_DETAIL --> \(Utility.conteverDictToJson(dict: response))")
            Utility.showLoading()
            
            if  Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: false) {
                let orderListReponse:OrderDetailsNew = OrderDetailsNew.init(fromDictionary: response)
                
                StoreSingleton.shared.updateOrder!.orderDetails = orderListReponse.order.cartDetail.orderDetails
                StoreSingleton.shared.updateOrder?.isUseItemTaxNew = orderListReponse.order.isUseItemTax
                StoreSingleton.shared.updateOrder?.isTaxIncludedNew = orderListReponse.order.isTaxIncluded
                
                StoreSingleton.shared.updateOrder?.isUseItemTaxOld = orderListReponse.order.cartDetail.isUseItemTax
                StoreSingleton.shared.updateOrder?.isTaxIncludedOld = orderListReponse.order.cartDetail.isTaxInlcuded
                StoreSingleton.shared.updateOrder.storeTaxDetailsOld = orderListReponse.order.cartDetail.storeTaxDetails
                StoreSingleton.shared.updateOrder.storeTaxDetailsNew = orderListReponse.order.storeTaxDetails
                
                self.setLocalization()
                self.wsGetItemDetails()
                
            }
        }
    }
    
    func wsGetItemDetails() {
        Utility.showLoading()
        
        let dictParam :[String:Any] =
            [PARAMS.TYPE:CONSTANT.TYPE_STORE,
             PARAMS.ITEM_ARRAY:selectedItemId,
             PARAMS.ID:preferenceHelper.getUserId(),
             PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken()] as [String : Any];
        
        print(dictParam)
        let alamofire = AlamofireHelper.init()
        alamofire.getResponseFromURL(url: WebService.GET_ITEM_DETAIL, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            
            print("---- \(Utility.conteverDictToJson(dict: response))")
            Utility.hideLoading()
            self.currentOrder.serverItems.removeAll()
            if Parser.isSuccess(response: response) {
                
                let itemlistResponse:ItemListDetailResponse = ItemListDetailResponse.init(fromDictionary: response)
                self.currentOrder.serverItems.append(contentsOf: itemlistResponse.items)
                
                if self.currentOrder.orderDetails.count == 0 {
                    self.updateUI(isUpdate: false)
                }else {
                    self.tableForEditOrderItems.reloadData()
                    self.calculateTotalAmount()
                }
                self.compareTaxSettings()
            }else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func compareTaxSettings(){
        print(self.currentOrder.isTaxIncludedNew)
        print(self.currentOrder.isTaxIncludedOld)
        
        print(self.currentOrder.isUseItemTaxNew)
        print(self.currentOrder.isUseItemTaxOld)
        
        var isMismatched : Bool = false
        
        if self.currentOrder.isTaxIncludedOld == self.currentOrder.isTaxIncludedNew {
            if self.currentOrder.isUseItemTaxOld != self.currentOrder.isUseItemTaxNew{
                isMismatched = true
            }else{
                for objOrderDetail in self.currentOrder.orderDetails{
                    for orderDetailItem in objOrderDetail.items{
                        for objServerItems in self.currentOrder.serverItems{
                            if objServerItems.itemId == orderDetailItem.itemId{
                                
                                if self.currentOrder.isUseItemTaxOld{
                                    for serverItemTax in objServerItems.taxDetails{
                                        let x = orderDetailItem.taxDetails.contains(where: { (a) -> Bool in
                                            a.id == serverItemTax.id
                                        })
                                        if !x{
                                            isMismatched = true
                                            break
                                        }
                                    }
                                }
                                if objServerItems.itemPrice != orderDetailItem.itemPrice{
                                    isMismatched = true
                                    break
                                }else{
                                    for serverItemSpec in objServerItems.specifications{
                                        for orderItemSpec in orderDetailItem.specifications{
                                            if serverItemSpec.uniqueId == orderItemSpec.uniqueId{
                                                for serverItemSpecList in serverItemSpec.list{
                                                    for orderItemSpecList in orderItemSpec.list{
                                                        if serverItemSpecList.uniqueId == orderItemSpecList.uniqueId{
                                                            if serverItemSpecList.price != orderItemSpecList.price{
                                                                isMismatched = true
                                                                break
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                if !isMismatched{
                    if !self.currentOrder.isUseItemTaxOld{
                        //Compare store taxes
                        if StoreSingleton.shared.updateOrder.storeTaxDetailsNew.count != StoreSingleton.shared.updateOrder.storeTaxDetailsOld.count{
                            isMismatched = true
                        }else{
                            
                            for storeTaxNew in StoreSingleton.shared.updateOrder.storeTaxDetailsNew{
                                let x = StoreSingleton.shared.updateOrder.storeTaxDetailsOld.contains(where: { (a) -> Bool in
                                    a.id == storeTaxNew.id
                                })
                                if !x{
                                    isMismatched = true
                                    break
                                }
                            }
                        }
                    }
                    
                }
            }
        }else{
            isMismatched = true
        }
        
        
        if isMismatched{
            openTaxSettingWaringDialog()
        }
    }
    
    func openTaxSettingWaringDialog(){
        
        let dialogForLogout = CustomAlertDialog.showCustomAlertDialog(title: "TXT_WARNING".localized, message: "TXT_EDIT_ORDER_WARNING_MSG".localized, titleLeftButton: "TXT_CANCEL".localizedUppercase, titleRightButton: "TXT_CONTINUE".localizedUppercase)
        dialogForLogout.onClickLeftButton = {
            [unowned dialogForLogout] in
            dialogForLogout.removeFromSuperview();
            self.navigationController?.popViewController(animated: true)
        }
        dialogForLogout.onClickRightButton = {
            [unowned dialogForLogout, unowned self] in
            dialogForLogout.removeFromSuperview();
            
            var total = 0.0
            var totalSpecificationPrice = 0.0
            var totalTax = 0.0
            var totalSpecificationTax = 0.0
            var itemTax = 0.0
            var totalItemTax = 0.0
            var totalItemPrice = 0.0
            
            self.currentOrder.isTaxIncludedOld = self.currentOrder.isTaxIncludedNew
            self.currentOrder.isUseItemTaxOld = self.currentOrder.isUseItemTaxNew



            StoreSingleton.shared.updateOrder.storeTaxDetailsOld.removeAll()
            StoreSingleton.shared.updateOrder.storeTaxDetailsOld.append(contentsOf: StoreSingleton.shared.updateOrder.storeTaxDetailsNew)
            
            var storeTax : Int = 0
            for obj in currentOrder.storeTaxDetailsNew{
                storeTax = storeTax + obj.tax
            }
            
            
            for objOrderDetail in self.currentOrder.orderDetails{
                for orderDetailItems in objOrderDetail.items{
                    totalSpecificationPrice = 0.0
                    totalSpecificationTax = 0.0
                    
                    for serverItems in self.currentOrder.serverItems{
                        
                        if orderDetailItems.itemId == serverItems.itemId{
                            
                            orderDetailItems.itemPrice = serverItems.itemPrice
                            orderDetailItems.tax = serverItems.tax
                            orderDetailItems.totalSpecificationPrice = serverItems.totalSpecificationPrice
                            orderDetailItems.taxDetails = serverItems.taxDetails
                            
                            for orderItemSpec in orderDetailItems.specifications{
                                for serverItemSpec in serverItems.specifications{
                                    if orderItemSpec.uniqueId == serverItemSpec.uniqueId{
                                        orderItemSpec.specificationPrice = serverItemSpec.specificationPrice
                                        
                                        for orderItemSpecList in orderItemSpec.list{
                                            for serverItemSpecList in serverItemSpec.list{
                                                if orderItemSpecList.uniqueId == serverItemSpecList.uniqueId{
                                                    orderItemSpecList.price = serverItemSpecList.price
                                                    totalSpecificationPrice = totalSpecificationPrice + serverItemSpecList.price
                                                }
                                                
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
                    
                    
                    var totalTaxAmount : Int = 0
                    for orderDetailItemTax in orderDetailItems.taxDetails{
                        totalTaxAmount = totalTaxAmount + orderDetailItemTax.tax
                    }
                    
                    let tax =  currentOrder.isUseItemTaxNew ? Double(totalTaxAmount) : Double(storeTax)
                    
                    itemTax = getTax(itemAmount: (orderDetailItems.itemPrice)!, taxValue: (tax))
                    totalSpecificationTax = getTax(itemAmount: (totalSpecificationPrice), taxValue: (tax))
                    totalTax = itemTax + totalSpecificationTax
                    print(totalTax)
                    
                    total = (totalSpecificationPrice + orderDetailItems.itemPrice) * Double(orderDetailItems.quantity)
                    orderDetailItems.totalItemPrice = total
                    orderDetailItems.totalSpecificationPrice = totalSpecificationPrice
                    
                    orderDetailItems.totalSpecificationTax = totalSpecificationTax
                    orderDetailItems.totalTax =  totalTax
                    orderDetailItems.totalItemTax = totalTax * Double((orderDetailItems.quantity)!)
                    totalItemTax = totalItemTax + orderDetailItems.totalItemTax
                    if currentOrder.isTaxIncludedNew{
                        totalItemPrice = totalItemPrice + orderDetailItems.totalItemPrice - totalItemTax
                    }else{
                        totalItemPrice = totalItemPrice + orderDetailItems.totalItemPrice
                    }
                    
                }
                print(total)
                print(totalTax)
                objOrderDetail.totalItemTax =  totalItemTax
                objOrderDetail.totalItemPrice =  totalItemPrice
            }
            
            
            self.tableForEditOrderItems?.reloadData()
            self.calculateTotalAmount()
            
        }
    }
    
    func wsupdateOrder() {
        
        var totalSpecificationPriceWithQuantity = 0.0;
        var totalItemsPriceWithQuantity = 0.0;
        var totalSpecificationCount = 0;
        var totalItemsCount = 0;
        var totalPrice:Double = 0.0
        var totalTax:Double = 0.0
        var totalSpecificationTax:Double = 0.0
        var taxDetails = [TaxesDetail]()
        var taxDetailArr = [[String:Any]]()
        
        for orderProduct in  currentOrder.orderDetails {
            var productTotalItemPrice:Double = 0.0
            var productTotalTax:Double = 0.0
            
            for (index, orderProductItem) in orderProduct.items!.enumerated() {
                var eachItemTax = 0
                
                print(index)
                totalItemsPriceWithQuantity += (orderProductItem.itemPrice * Double(orderProductItem.quantity))
                
                productTotalItemPrice = productTotalItemPrice + orderProductItem.totalItemPrice!
                productTotalTax = productTotalTax + orderProductItem.totalTax
                
                totalSpecificationTax = totalSpecificationTax + orderProductItem.totalSpecificationTax
                print(totalSpecificationTax)
                
                totalSpecificationPriceWithQuantity += (orderProductItem.totalSpecificationPrice! * Double(orderProductItem.quantity!))
                totalItemsCount += orderProductItem.quantity!
                
                for specificationItem  in orderProductItem.specifications! {
                    totalSpecificationCount +=  (specificationItem.list?.count)!
                }
                
                totalTax = totalTax + orderProductItem.totalItemTax;
                totalPrice = totalPrice + orderProductItem.totalItemPrice
                
                if currentOrder.isUseItemTaxNew{
                    for obj in orderProductItem.taxDetails{
                        eachItemTax = eachItemTax + obj.tax
                        let x = taxDetails.contains(where: { (a) -> Bool in
                            a.id == obj.id
                        })
                        if !x{
                            taxDetails.append(obj)
                        }
                        for i in taxDetails{
                            if i.id == obj.id{
                                i.tax_amount = i.tax_amount + obj.tax
                            }
                        }
                    }
                }else{
                    for obj in currentOrder.storeTaxDetailsNew{
                        eachItemTax = eachItemTax + obj.tax
                        let x = taxDetails.contains(where: { (a) -> Bool in
                            a.id == obj.id
                        })
                        if !x{
                            taxDetails.append(obj)
                        }
                        for i in taxDetails{
                            if i.id == obj.id{
                                i.tax_amount = i.tax_amount + obj.tax
                            }
                        }
                    }
                }
            }
        }
        
        if currentOrder.isTaxIncludedOld{
            currentOrder.totalCartPrice =  totalPrice - totalTax
        }else{
            currentOrder.totalCartPrice =  totalPrice
        }
        
        currentOrder.totalItemTax = totalTax
        
        StoreSingleton.shared.updateOrder.totalItemCount = totalItemsCount
        if currentOrder.isTaxIncludedOld{
            StoreSingleton.shared.updateOrder.totalOrderPrice = currentOrder.totalOrderPrice - totalTax
        }else{
            StoreSingleton.shared.updateOrder.totalOrderPrice = currentOrder.totalOrderPrice
        }
        StoreSingleton.shared.updateOrder.totalCartPrice = currentOrder.totalCartPrice
        StoreSingleton.shared.updateOrder.totalItemTax = currentOrder.totalItemTax
        StoreSingleton.shared.updateOrder.storeTaxDetailsNew = currentOrder.storeTaxDetailsNew
        
        for obj in taxDetails{
            taxDetailArr.append(obj.toDictionary())
        }
        
        var dictParam = StoreSingleton.shared.updateOrder.toDictionary()
        dictParam[PARAMS.TOTAL_CART_AMOUNT_WITHOUT_TAX] = currentOrder.totalCartAmountWithoutTax!
        dictParam[PARAMS.TAX_DETAILS] = taxDetailArr
        dictParam[PARAMS.IS_USE_ITEM_TAX] = currentOrder.isUseItemTaxNew
        dictParam[PARAMS.IS_TAX_INCLUDED] = currentOrder.isTaxIncludedNew
        
        print("UPDATE_ORDER \(Utility.conteverDictToJson(dict: dictParam))")
        Utility.showLoading()
        let alamofire = AlamofireHelper.init()
        alamofire.getResponseFromURL(url: WebService.UPDATE_ORDER, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            
            Utility.hideLoading()
            if Parser.isSuccess(response: response) {
                self.navigationController?.popToRootViewController(animated: true)
            }else {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        
    }
}
