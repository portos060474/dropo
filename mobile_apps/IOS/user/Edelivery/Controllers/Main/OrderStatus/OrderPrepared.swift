//
//  HomeVC.swift
//  edelivery
//
//  Created by Elluminati on 14/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

protocol DelegateTapOnConfirm {
    func didTapOnConfirm()
}
class OrderBeingPrepared: BaseVC,UIGestureRecognizerDelegate {

//MARK: OutLets
    @IBOutlet weak var mainOrderTable: UITableView!
    @IBOutlet weak var heightBottomView: NSLayoutConstraint!
    @IBOutlet weak var stackViewBottom: UIStackView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var lblUpdateOrder: UILabel!
    @IBOutlet weak var lblTotalValue: UILabel!
    @IBOutlet weak var viewForTotal: UIView!
    @IBOutlet weak var heightForTblList: NSLayoutConstraint!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnEditOrder: UIButton!
    @IBOutlet weak var lblOrderNumber: UILabel!
    @IBOutlet weak var lblOrderStatus: UILabel!
    
    @IBOutlet weak var viewForEditOrder: UIView!
    
    //MARK: Variables
    var arrForProducts:[CartProduct] = []
    var isfromConfirm:Bool = false
    var isEditOrder:Bool = false
    var delegateTapOnConfirm: DelegateTapOnConfirm?
    static var selectedOrder:Order = Order.init()
    var arrProductList:Array<ProductItem>? = nil
   
    override var preferredContentSize: CGSize {
        get {
            self.mainOrderTable.layoutIfNeeded()
            return self.mainOrderTable.contentSize
        }
        set {}
    }
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        btnConfirm.isHidden = !isfromConfirm
        btnEditOrder.isHidden = !isfromConfirm
        viewForEditOrder.isHidden = !isfromConfirm
        manageStackViewVisibility(isHidden: btnEditOrder.isHidden)
        arrForProducts.removeAll()
        arrForProducts =  (OrderBeingPrepared.selectedOrder.cartDetail?.orderDetails)!.map { $0 }
        self.view.animationBottomTOTop(self.alertView)
        mainOrderTable.estimatedRowHeight = 100
        mainOrderTable.rowHeight = UITableView.automaticDimension
        mainOrderTable.reloadData()
        setLocalization()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.onClickUpdateOrder(_:)))
        gestureRecognizer.delegate = self
        
        viewForTotal.isUserInteractionEnabled = true
        viewForTotal.addGestureRecognizer(gestureRecognizer)
       
        wsGetProductList(storeId: OrderBeingPrepared.selectedOrder.store_id ?? "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainOrderTable.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.navigationController?.setNavigationBarHidden(true, animated: false)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mainOrderTable.removeObserver(self, forKeyPath: "contentSize")
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        heightForTblList.constant = mainOrderTable.contentSize.height
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewForTotal.applyRoundedCornersWithHeight()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setLocalization() {
        self.view.backgroundColor = UIColor.themeOverlayColor
        self.hideBackButtonTitle()
        self.lblOrderNumber.textColor = UIColor.themeTextColor
        self.lblOrderStatus.textColor = UIColor.themeTextColor
        self.lblOrderNumber.font = FontHelper.textRegular()
        self.lblOrderStatus.font = FontHelper.textRegular()
        btnConfirm.setTitle("TXT_CONFIRM".localizedCapitalized, for: .normal)
        self.btnEditOrder.setTitle("TXT_EDIT_ORDER".localizedCapitalized, for: .normal)
        self.btnEditOrder.titleLabel?.font = FontHelper.textMedium(size: FontHelper.regular)
        self.lblOrderNumber.text = "TXT_ORDER_NO".localized + "\(OrderBeingPrepared.selectedOrder.unique_id ?? 0)"
        self.lblOrderStatus.text = (OrderStatus(rawValue: OrderBeingPrepared.selectedOrder.order_status ?? 0) ?? .Unknown)!.text(cellItem: Order.init())
        lblTitle.textColor = UIColor.themeTextColor
        lblTitle.font = FontHelper.textLarge()
        lblTitle.text = "TXT_ORDER_DETAILS".localized
        btnCancel.setImage(UIImage(named:"cancelIcon")?.imageWithColor(color: UIColor.themeColor), for: .normal)
        alertView.backgroundColor = UIColor.themeViewBackgroundColor
        alertView.roundCorner(corners: [.topLeft, .topRight], withRadius: 20.0)
        lblUpdateOrder.textColor = UIColor.themeButtonTitleColor
        lblUpdateOrder.text = "TXT_UPDATE".localized
        lblUpdateOrder.font = FontHelper.textRegular()
        lblTotalValue.font = FontHelper.textRegular()
        lblTotalValue.textColor = UIColor.themeButtonTitleColor
        viewForTotal.backgroundColor = UIColor.themeColor
        //setUpTableViewHeight()
    }
    
    func manageStackViewVisibility(isHidden:Bool){
        stackViewBottom.isHidden = isHidden
        if isHidden {
            self.heightBottomView.constant = 0
        }else{
            self.heightBottomView.constant = 45
        }
    }
    
    @IBAction func confirmPressed(_ sender: Any) {
        wsConfirmOrder()
    }
    
    @IBAction func cancelPRessed(_ sender: Any) {
        OrderBeingPrepared.selectedOrder = Order.init()
        delegateTapOnConfirm?.didTapOnConfirm()
        self.view.animationForHideView(alertView) {
            
            self.dismiss(animated: false, completion: nil)
        }
    }

    @IBAction func onClickBtnEditOrder(_ sender: Any) {
    
        compareTaxSettings()
        
        self.btnEditOrder.setTitle("TXT_ADD_ITEM".localizedCapitalized, for: .normal)
        self.isEditOrder = true
        if (self.btnEditOrder.isSelected)  {
            self.goToProductVC(storeID: OrderBeingPrepared.selectedOrder.store_id ?? "")
        }
        self.btnEditOrder.isSelected = true
        self.mainOrderTable.reloadData()
        self.btnConfirm.isHidden = true
        self.viewForTotal.isHidden = false
        
        mainOrderTable.reloadData()
        calculateTotalAmount()
        
    }
    @IBAction func onClickUpdateOrder(_ sender: Any) {
        wsUpdateOrder()
    }
    @objc func wsConfirmOrder()
    {
        Utility.showLoading()
        let dictParam: Dictionary<String,Any> =
            [PARAMS.USER_ID:preferenceHelper.getUserId(),
             PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken(),
             PARAMS.ORDER_ID:OrderBeingPrepared.selectedOrder._id ?? ""];
        let afn:AlamofireHelper = AlamofireHelper.init();
        afn.getResponseFromURL(url: WebService.WS_APPROVE_EDIT_ORDER, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam)
        {(response, error) -> (Void) in
            if Parser.isSuccess(response: response,withSuccessToast: false, andErrorToast: false) {
                Utility.hideLoading()
                self.navigationController?.navigationBar.isHidden = false
                self.view.animationForHideView(self.alertView) {
                    self.dismiss(animated: false, completion: nil)
                    self.delegateTapOnConfirm?.didTapOnConfirm()
                }
            }else{
                Utility.hideLoading()
            }
        }
    }
    func wsUpdateOrder() {
        
        let cartOrder:CartOrder = CartOrder.init()
        cartOrder.order_details = (OrderBeingPrepared.selectedOrder.cartDetail?.orderDetails)
        var totalPrice:Double = 0.0
        var totalTax:Double = 0.0
        var taxDetails = [TaxesDetail]()
        var taxDetailArr = [[String:Any]]()
        var totalCartAmountWithoutTax:Double = 0.0
        for cartProductItem in (OrderBeingPrepared.selectedOrder.cartDetail!.orderDetails!) {
            for cartProduct in cartProductItem.items! {
                var eachItemTax = 0
                totalTax = totalTax + cartProduct.totalItemTax
                totalPrice = totalPrice + (cartProduct.totalItemPrice ?? 0.0)
                
                if ((OrderBeingPrepared.selectedOrder.store_detail?.isUseItemTax) != nil){
                    for obj in OrderBeingPrepared.selectedOrder.store_detail!.storeTaxDetails{
                        
                        eachItemTax = eachItemTax + obj.tax
                        let x = taxDetails.contains(where: { (a) -> Bool in
                            a.id == obj.id
                        })
                        if !x{
                            taxDetails.append(obj)
                        }
                        for i in taxDetails{
                            if i.id == obj.id{
                                i.tax_amount = obj.tax
                            }
                        }
                    }
                    
                }else{
                    for obj in cartProduct.taxDetails{
                        eachItemTax = eachItemTax + obj.tax
                        let x = taxDetails.contains(where: { (a) -> Bool in
                            a.id == obj.id
                        })
                        if !x{
                            taxDetails.append(obj)
                        }
                        for i in taxDetails{
                            if i.id == obj.id{
                                i.tax_amount = obj.tax
                            }
                        }
                    }
                }
            }
            totalCartAmountWithoutTax = totalCartAmountWithoutTax + cartProductItem.totalCartAmountWithoutTax
        }

        if OrderBeingPrepared.selectedOrder.cartDetail!.isTaxIncluded{
            cartOrder.totalCartPrice =  totalPrice - totalTax
        }else{
            cartOrder.totalCartPrice =  totalPrice
        }
        
        cartOrder.totalItemTax = totalTax
        var totalItemsCount = 0
        for cartProductItem in (OrderBeingPrepared.selectedOrder.cartDetail!.orderDetails[0].items!) {
            totalItemsCount += cartProductItem.quantity!
        }
        for obj in taxDetails{
            taxDetailArr.append(obj.toDictionary())
        }
        
        print(taxDetailArr)
        
        let afn:AlamofireHelper = AlamofireHelper.init()
        let dictParam:NSMutableDictionary = (cartOrder.dictionaryRepresentationOrder_details() as! NSMutableDictionary)
        
        dictParam[PARAMS.ORDER_ID]  = OrderBeingPrepared.selectedOrder._id
        dictParam[PARAMS.SERVER_TOKEN]  = preferenceHelper.getSessionToken()
        dictParam[PARAMS.STORE_ID]  = (OrderBeingPrepared.selectedOrder.cartDetail?.storeId!)!
        dictParam[PARAMS.USER_ID]  = preferenceHelper.getUserId()
        dictParam[PARAMS.TOTAL_CART_PRICE]  = cartOrder.totalCartPrice
        dictParam[PARAMS.TOTAL_ITEM_COUNT]  = totalItemsCount
        dictParam[PARAMS.TOTAL_ITEM_TAX]  = cartOrder.totalItemTax
        dictParam[PARAMS.TAX_DETAILS] = taxDetailArr
        dictParam[PARAMS.IS_USE_ITEM_TAX] = OrderBeingPrepared.selectedOrder.cartDetail!.isUseItemTax
        dictParam[PARAMS.IS_TAX_INCLUDED] = OrderBeingPrepared.selectedOrder.cartDetail!.isTaxIncluded
        dictParam[PARAMS.TOTAL_CART_AMOUNT_WITHOUT_TAX] = totalCartAmountWithoutTax

        print(Utility.convertDictToJson(dict: dictParam as! Dictionary<String, Any>))
        
        afn.getResponseFromURL(url: WebService.WS_USER_UPDATE_ORDER, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam as? Dictionary<String, Any>) { (response,error) -> (Void) in
            
            if (Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true)) {
                var _ : Bool = false
                self.view.animationForHideView(self.alertView) {
                    
                    self.dismiss(animated: false, completion: nil)
                    self.delegateTapOnConfirm?.didTapOnConfirm()
                }
            }
            Utility.hideLoading()
        }
    }
    func wsGetProductList(storeId:String) {
        
        let dictParam: Dictionary<String,Any> =
            [PARAMS.USER_ID:preferenceHelper.getUserId(),
             PARAMS.IPHONE_ID:preferenceHelper.getRandomCartID(),
             PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken(),
             PARAMS.STORE_ID:storeId]
        
        print("wsGetProductList dictParam\(dictParam)")
        
        Utility.showLoading()
        let afn:AlamofireHelper = AlamofireHelper.init()
        
        afn.getResponseFromURL(url: WebService.WS_GET_STORE_PRODUCT_ITEM_LIST, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response, andErrorToast: false) {
                self.arrProductList = Parser.parseStoreProductList(response)
                let store : StoreItem = StoreItem(dictionary: response["store"] as! NSDictionary)!
                OrderBeingPrepared.selectedOrder.store_detail!.isTaxInlcuded = store.isTaxInlcuded
                OrderBeingPrepared.selectedOrder.store_detail!.isUseItemTax = store.isUseItemTax
                OrderBeingPrepared.selectedOrder.store_detail!.storeTaxDetails = store.storeTaxDetails
                    
                print("wsGetProductList response\(Utility.convertDictToJson(dict: response as! Dictionary<String,Any>))")
            }
        }
    }
    
    
    func goToProductVC(storeID:String = "") {

        let productVc : ProductVC = ProductVC.init(nibName: "Product", bundle: nil)
        if storeID.isEmpty {

        }else {
            productVc.selectedStoreId = storeID
        }
        productVc.isFromUpdateOrder = true
        productVc.arrEditOrders = arrForProducts
        productVc.editOrderType = OrderBeingPrepared.selectedOrder.delivery_type ?? 1
        productVc.isFromDeliveryList = false
        productVc.arrEditOrders = self.arrForProducts
        var isIndexMatch : Bool = false
        var selectedInd : Int = 0
        if preferenceHelper.getSelectedLanguageCode() != Constants.selectedLanguageCode{
            Constants.selectedLanguageCode = preferenceHelper.getSelectedLanguageCode()
        }
        
        if storeID.isEmpty {
            for obj in currentBooking.selectedStore!.langItems!{
                if (obj.code == Constants.selectedLanguageCode) && (obj.is_visible! == true){
                    isIndexMatch = true
                    selectedInd = currentBooking.selectedStore!.langItems!.firstIndex(where: { $0.code == obj.code })!
                    break
                }else{
                    isIndexMatch = false
                }
            }
        }else{
            
            for obj in OrderBeingPrepared.selectedOrder.store_detail?.langItems! ?? [] {
                if obj.code == Constants.selectedLanguageCode{
                    isIndexMatch = true
                    selectedInd = OrderBeingPrepared.selectedOrder.store_detail?.langItems!.firstIndex(where: { $0.code == obj.code })! ?? 0

                    break
                }else{
                    isIndexMatch = false
                }
            }
        }

        if !isIndexMatch{
            productVc.languageCode = OrderBeingPrepared.selectedOrder.store_detail?.langItems![0].code! ?? "en"
            productVc.languageCodeInd = "0"
        }else{
            productVc.languageCode = Constants.selectedLanguageCode
            productVc.languageCodeInd = "\(selectedInd)"
        }
        self.navigationController?.pushViewController(productVc, animated: true)
        
    }
    
    func goToProductSpecification(currentProduct:CartProductItems,indSection:Int, indRow:Int) {
        
        var myServerSelectedProductItem:ProductItemsItem? = nil
        for obj in self.arrProductList! {
            for tempObj in obj.items! {
                if tempObj._id == currentProduct.item_id!{
                    myServerSelectedProductItem = (obj.items!.first { (item) -> Bool in
                        item.unique_id! == currentProduct.unique_id!
                    })!
                }
            }
        }
        myServerSelectedProductItem!.quantity = currentProduct.quantity
        myServerSelectedProductItem!.instruction = currentProduct.noteForItem
        
        for specification in myServerSelectedProductItem!.specifications! {
            
            for subSpecification in specification.list!{
                subSpecification.is_default_selected = false
            }
            for currentProductspecification in currentProduct.specifications {
                
                if currentProductspecification.unique_id == specification.unique_id {
                    for subSpecification in specification.list!
                    {
                        for currentSubSpecification in currentProductspecification.list!
                        {
                            if subSpecification.unique_id == currentSubSpecification.unique_id
                            {
                                subSpecification.quantity = currentSubSpecification.quantity
                                subSpecification.is_default_selected = true
                            }
                        }
                    }
                }
            }
        }
        let myFinalProduct:ProductItemsItem = ProductItemsItem.init(dictionary: myServerSelectedProductItem!.dictionaryRepresentation())!
        myFinalProduct.quantity = myServerSelectedProductItem!.quantity
        myFinalProduct.currency = currentBooking.cartCurrency
        let productSpecificationVC = EditOrderProductSpecificationVC.init(nibName: "EditOrderProductSpecification", bundle: nil)
        productSpecificationVC.FromOrderPrepare = true
        productSpecificationVC.selectedProductItem = myFinalProduct
        productSpecificationVC.selectedProductItem?.name = currentProduct.item_name
        productSpecificationVC.selectedProductItem?.details = currentProduct.details
        productSpecificationVC.quantity =  myFinalProduct.quantity
        productSpecificationVC.productName = currentProduct.item_name
        productSpecificationVC.productUniqueId = currentProduct.unique_id
        productSpecificationVC.isFromUpdateOrder = true
        productSpecificationVC.selectInd = indRow
        productSpecificationVC.selectSection = indSection
        productSpecificationVC.selectedStore = OrderBeingPrepared.selectedOrder.store_detail!
        productSpecificationVC.selectedStore?.storeTaxDetails = OrderBeingPrepared.selectedOrder.store_detail!.storeTaxDetails

        self.navigationController?.pushViewController(productSpecificationVC, animated: true)
    }
    public func increaseQuantity(currentProductItem:CartProductItems){
        printE("Increment Method Called")
        var quantity = currentProductItem.quantity!
        quantity = quantity + 1
        let total = (currentProductItem.total_specification_price! + currentProductItem.item_price!) * Double(quantity)
        
        currentProductItem.totalItemPrice = total
        currentProductItem.quantity = quantity
        currentProductItem.totalItemTax =  currentProductItem.totalTax * Double(quantity)
        calculateTotalAmount()
        
        DispatchQueue.main.async
        {
            self.mainOrderTable.reloadData()
        }
    
    }
    public func decreaseQuantity(currentProductItem:CartProductItems){
        printE("Decrement Method Called")
        var quantity = currentProductItem.quantity!
        if (quantity > 1 ) {
            quantity = quantity - 1
            let total = (currentProductItem.total_specification_price! + currentProductItem.item_price!) * Double(quantity)
            currentProductItem.totalItemPrice = total
            currentProductItem.quantity = quantity
            
            let tax =  currentProductItem.tax
            let specificationPriceTotal = currentProductItem.total_specification_price!
            let itemTax = getTax(itemAmount: currentProductItem.item_price!, taxValue: tax)
            let specificationTax = getTax(itemAmount: specificationPriceTotal, taxValue: tax)
            let totalTax = itemTax + specificationTax
            currentProductItem.itemTax = itemTax
            currentProductItem.totalSpecificationTax = specificationTax
            currentProductItem.totalTax = totalTax
            currentProductItem.totalItemTax =   totalTax * Double(quantity)
            
            self.mainOrderTable?.reloadData()
           
            calculateTotalAmount()
        }
    }
    
    func getTax(itemAmount:Double, taxValue:Double) -> Double {

        if !OrderBeingPrepared.selectedOrder.store_detail!.isTaxInlcuded{
            return itemAmount * taxValue * 0.01
        }else{
            return (itemAmount - (100*itemAmount)/(100+taxValue))
        }
    }
    
    func compareTaxSettings(){
        print(OrderBeingPrepared.selectedOrder.cartDetail!.isTaxIncluded)
        print(OrderBeingPrepared.selectedOrder.store_detail!.isTaxInlcuded)
        
        print(OrderBeingPrepared.selectedOrder.cartDetail!.isUseItemTax)
        print(OrderBeingPrepared.selectedOrder.store_detail!.isUseItemTax)

        var selectedItems = [ProductItemsItem]()
        for i in arrProductList ?? [] {
            for obj in OrderBeingPrepared.selectedOrder.cartDetail!.orderDetails{
                for j in obj.items!{
                    for k in i.items!{
                        if j.item_id == k._id{
                            selectedItems.append(k)
                        }
                    }
                }
            }
        }
            print(selectedItems)
        
        
        var isMismatched : Bool = false
        
        if OrderBeingPrepared.selectedOrder.cartDetail!.isTaxIncluded == OrderBeingPrepared.selectedOrder.store_detail!.isTaxInlcuded {
            if OrderBeingPrepared.selectedOrder.cartDetail!.isUseItemTax != OrderBeingPrepared.selectedOrder.store_detail!.isUseItemTax{
                isMismatched = true
            }else{
                for objOrderDetail in OrderBeingPrepared.selectedOrder.cartDetail!.orderDetails{
                    for orderDetailItem in objOrderDetail.items!{
                        for objServerItems in selectedItems{
                            if objServerItems._id == orderDetailItem.item_id{
                                
                                if OrderBeingPrepared.selectedOrder.cartDetail!.isUseItemTax{
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
                                if objServerItems.price != orderDetailItem.item_price{
                                    isMismatched = true
                                    break
                                }else{
                                    for serverItemSpec in objServerItems.specifications!{
                                        for orderItemSpec in orderDetailItem.specifications{
                                            if serverItemSpec.unique_id == orderItemSpec.unique_id{
                                                for serverItemSpecList in serverItemSpec.list!{
                                                    for orderItemSpecList in orderItemSpec.list!{
                                                        if serverItemSpecList.unique_id == orderItemSpecList.unique_id{
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
                    if !OrderBeingPrepared.selectedOrder.cartDetail!.isUseItemTax{
                       
                        if OrderBeingPrepared.selectedOrder.store_detail!.storeTaxDetails.count != OrderBeingPrepared.selectedOrder.cartDetail!.storeTaxDetails.count{
                            isMismatched = true
                        }else{
                            
                            for storeTaxNew in OrderBeingPrepared.selectedOrder.store_detail!.storeTaxDetails{
                                let x = OrderBeingPrepared.selectedOrder.cartDetail!.storeTaxDetails.contains(where: { (a) -> Bool in
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
            self.view.animationForHideView(self.alertView) {
                self.dismiss(animated: false, completion: nil)
            }
            
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
            
            var selectedItems = [ProductItemsItem]()
            for i in arrProductList!{
                for obj in OrderBeingPrepared.selectedOrder.cartDetail!.orderDetails{
                    for j in obj.items!{
                        for k in i.items!{
                            if j.item_id == k._id{
                                selectedItems.append(k)
                            }
                        }
                    }
                }
            }
            print(selectedItems)

            OrderBeingPrepared.selectedOrder.cartDetail!.isTaxIncluded = OrderBeingPrepared.selectedOrder.store_detail!.isTaxInlcuded
            OrderBeingPrepared.selectedOrder.cartDetail!.isUseItemTax = OrderBeingPrepared.selectedOrder.store_detail!.isUseItemTax
            
            OrderBeingPrepared.selectedOrder.cartDetail!.storeTaxDetails.removeAll()
            OrderBeingPrepared.selectedOrder.cartDetail!.storeTaxDetails.append(contentsOf: OrderBeingPrepared.selectedOrder.store_detail!.storeTaxDetails)
            
            print(OrderBeingPrepared.selectedOrder.cartDetail!.isTaxIncluded)
            print(OrderBeingPrepared.selectedOrder.store_detail!.isTaxInlcuded)
            
            print(OrderBeingPrepared.selectedOrder.cartDetail!.isUseItemTax)
            print(OrderBeingPrepared.selectedOrder.store_detail!.isUseItemTax)
            
            var storeTax : Int = 0
            for obj in OrderBeingPrepared.selectedOrder.store_detail!.storeTaxDetails{
                storeTax = storeTax + obj.tax
            }
            
            for objOrderDetail in OrderBeingPrepared.selectedOrder.cartDetail!.orderDetails{
                for orderDetailItems in objOrderDetail.items!{
                    totalSpecificationPrice = 0.0
                    totalSpecificationTax = 0.0
                    
                    for serverItems in selectedItems{
                        
                        if orderDetailItems.item_id == serverItems._id{
                            
                            orderDetailItems.item_price = serverItems.price
                            orderDetailItems.tax = serverItems.tax
                            orderDetailItems.total_specification_price = serverItems.totalSpecificationPrice
                            
                            for orderItemSpec in orderDetailItems.specifications{
                                for serverItemSpec in serverItems.specifications!{
                                    if orderItemSpec.unique_id == serverItemSpec.unique_id{
                                        orderItemSpec.price = serverItemSpec.price
                                        
                                        for orderItemSpecList in orderItemSpec.list!{
                                            for serverItemSpecList in serverItemSpec.list!{
                                                if orderItemSpecList.unique_id == serverItemSpecList.unique_id{
                                                    orderItemSpecList.price = serverItemSpecList.price
                                                    totalSpecificationPrice = totalSpecificationPrice + serverItemSpecList.price!
                                                }

                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
                    
                    
                    var totalTaxAmount : Int = 0
                    for i in orderDetailItems.taxDetails{
                        totalTaxAmount = totalTaxAmount + i.tax
                    }
                    

                    let tax =  OrderBeingPrepared.selectedOrder.cartDetail!.isUseItemTax ? Double(totalTaxAmount) : Double(storeTax)

                    itemTax = getTax(itemAmount: (orderDetailItems.item_price)!, taxValue: (tax))
                    totalSpecificationTax = getTax(itemAmount: (totalSpecificationPrice), taxValue: (tax))
                    totalTax = itemTax + totalSpecificationTax
                    print(totalTax)
                    
                    total = (totalSpecificationPrice + orderDetailItems.item_price!) * Double(orderDetailItems.quantity)
                    orderDetailItems.totalItemPrice = total
                    orderDetailItems.total_specification_price = totalSpecificationPrice
                    
                    orderDetailItems.totalSpecificationTax = totalSpecificationTax
                    orderDetailItems.totalTax =  totalTax
                    orderDetailItems.totalItemTax = totalTax * Double((orderDetailItems.quantity)!)
                    totalItemTax = totalItemTax + orderDetailItems.totalItemTax
                    if OrderBeingPrepared.selectedOrder.cartDetail!.isTaxIncluded{
                        totalItemPrice = totalItemPrice + orderDetailItems.totalItemPrice! - totalItemTax
                    }else{
                        totalItemPrice = totalItemPrice + orderDetailItems.totalItemPrice!
                    }
                }
                print(total)
                print(totalTax)
                objOrderDetail.totalItemTax =  totalItemTax
                objOrderDetail.total_item_price =  totalItemPrice
            }
           
            self.mainOrderTable?.reloadData()
            self.calculateTotalAmount()

        }
    }
    
    func OldopenTaxSettingWaringDialog() {
        
        let dialogForLogout = CustomAlertDialog.showCustomAlertDialog(title: "TXT_WARNING".localized, message: "TXT_EDIT_ORDER_WARNING_MSG".localized, titleLeftButton: "TXT_CANCEL".localizedUppercase, titleRightButton: "TXT_CONTINUE".localizedUppercase)
        dialogForLogout.onClickLeftButton = {
            [unowned dialogForLogout] in
            dialogForLogout.removeFromSuperview();
            self.view.animationForHideView(self.alertView) {
                self.dismiss(animated: false, completion: nil)
            }
            
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
            
            var selectedItems = [ProductItemsItem]()
            for i in arrProductList!{
                for obj in OrderBeingPrepared.selectedOrder.cartDetail!.orderDetails{
                    for j in obj.items!{
                        for k in i.items!{
                            if j.item_id == k._id{
                                selectedItems.append(k)
                            }
                        }
                    }
                }
            }
            print(selectedItems)
            
            OrderBeingPrepared.selectedOrder.cartDetail!.isTaxIncluded = OrderBeingPrepared.selectedOrder.store_detail!.isTaxInlcuded
            OrderBeingPrepared.selectedOrder.cartDetail!.isUseItemTax = OrderBeingPrepared.selectedOrder.store_detail!.isUseItemTax
            
            OrderBeingPrepared.selectedOrder.cartDetail!.storeTaxDetails.removeAll()
            OrderBeingPrepared.selectedOrder.cartDetail!.storeTaxDetails.append(contentsOf: OrderBeingPrepared.selectedOrder.store_detail!.storeTaxDetails)
            
            print(OrderBeingPrepared.selectedOrder.cartDetail!.isTaxIncluded)
            print(OrderBeingPrepared.selectedOrder.store_detail!.isTaxInlcuded)
            
            print(OrderBeingPrepared.selectedOrder.cartDetail!.isUseItemTax)
            print(OrderBeingPrepared.selectedOrder.store_detail!.isUseItemTax)
            
            var storeTax : Int = 0
            for obj in OrderBeingPrepared.selectedOrder.store_detail!.storeTaxDetails{
                storeTax = storeTax + obj.tax
            }
            for i in OrderBeingPrepared.selectedOrder.cartDetail!.orderDetails{
                for obj in i.items!{
                    totalSpecificationPrice = 0.0
                    totalSpecificationTax = 0.0
                    
                    for i in selectedItems{
                        if i._id == obj.item_id{
                            obj.item_price = i.price
                            obj.tax = i.tax
                        }
                    }
                    
                    for i in obj.specifications{
                        for j in i.list!{
                            totalSpecificationPrice = totalSpecificationPrice + j.price!
                        }
                    }
                    var totalTaxAmount : Int = 0
                    for i in obj.taxDetails{
                        totalTaxAmount = totalTaxAmount + i.tax
                    }
                
                    let tax =  OrderBeingPrepared.selectedOrder.cartDetail!.isUseItemTax ? Double(totalTaxAmount) : Double(storeTax)

                    itemTax = getTax(itemAmount: (obj.item_price)!, taxValue: (tax))
                    totalSpecificationTax = getTax(itemAmount: (totalSpecificationPrice), taxValue: (tax))
                    totalTax = itemTax + totalSpecificationTax
                    print(totalTax)
                    
                    total = (totalSpecificationPrice + obj.item_price!) * Double(obj.quantity)
                    obj.totalItemPrice = total
                    obj.total_specification_price = totalSpecificationPrice
                    
                    obj.totalSpecificationTax = totalSpecificationTax
                    obj.totalTax =  totalTax
                    obj.totalItemTax = totalTax * Double((obj.quantity)!)
                    totalItemTax = totalItemTax + obj.totalItemTax
                    if OrderBeingPrepared.selectedOrder.cartDetail!.isTaxIncluded{
                        totalItemPrice = totalItemPrice + obj.totalItemPrice! - totalItemTax
                    }else{
                        totalItemPrice = totalItemPrice + obj.totalItemPrice!
                    }
                }
                
                print(total)
                print(totalTax)
                i.totalItemTax =  totalItemTax
                i.total_item_price =  totalItemPrice
            }
            
            self.mainOrderTable?.reloadData()
            self.calculateTotalAmount()
            
        }
    }
    
    
    public func removeItemFromCart(currentProductItem:CartProductItems, section:Int, row:Int){
        printE("Remove Method Called")
        if OrderBeingPrepared.selectedOrder.cartDetail!.orderDetails.count > 0 {
            let currentProduct:CartProduct = OrderBeingPrepared.selectedOrder.cartDetail!.orderDetails[section]
            //currentBooking.cart[section]
            if OrderBeingPrepared.selectedOrder.cartDetail!.orderDetails.count == 1 {
                let itemCount = (currentProduct.items?.count) ?? 0
                if itemCount == 1 {
                    Utility.showToast(message: "MSG_LIMIT_ORDER_ITEM_REMOVE".localized)
                }
                else {
                    currentProduct.items?.remove(at: row)
                }

            }
            else {
                currentProduct.items?.remove(at: row)
            }

            let itemCount = (currentProduct.items?.count) ?? 0
            if itemCount == 0 {
                OrderBeingPrepared.self.selectedOrder.cartDetail!.orderDetails.remove(at: section)
            }
        }
        self.updateData()
        self.mainOrderTable?.reloadData()
        //self.setUpTableViewHeight()
        calculateTotalAmount()
    }
    
    func calculateTotalAmount(){
        var total = 0.0
        var totalCartAmountWithoutTax = 0.0

        for currentProduct in OrderBeingPrepared.self.selectedOrder.cartDetail!.orderDetails {

            for currentProductItem in currentProduct.items! {
                total = total + Double(currentProductItem.totalItemPrice!)
                var eachItemTax = 0

                if !OrderBeingPrepared.selectedOrder.store_detail!.isUseItemTax{
                    for obj in OrderBeingPrepared.selectedOrder.store_detail!.storeTaxDetails{
                        eachItemTax = eachItemTax + obj.tax
                    }
                }else{
                    for obj in currentProductItem.taxDetails{
                        eachItemTax = eachItemTax + obj.tax
                    }
                }
                print(eachItemTax)
                
                let specificationPriceTotal = currentProductItem.total_specification_price!

                let itemTax = getTax(itemAmount: currentProductItem.item_price!, taxValue: Double(eachItemTax)) * Double(currentProductItem.quantity)
                let specificationTax = getTax(itemAmount: specificationPriceTotal, taxValue: Double(eachItemTax)) * Double(currentProductItem.quantity)
                let totalTax = itemTax + specificationTax
                print(totalTax)
                
                if OrderBeingPrepared.selectedOrder.store_detail!.isTaxInlcuded{
                    total = total - totalTax
                }
                totalCartAmountWithoutTax = totalCartAmountWithoutTax + Double(currentProductItem.totalItemPrice!)
            }
            
            currentProduct.total_item_price = total
            currentProduct.totalCartAmountWithoutTax = totalCartAmountWithoutTax
        }
        
        setTotalAmount(total,totalCartAmountWithoutTax: totalCartAmountWithoutTax)

    }
    
    func setTotalAmount(_ total:Double = 0.0,totalCartAmountWithoutTax:Double = 0.0){

        
        let strTotal =  (totalCartAmountWithoutTax.roundTo()).toCurrencyString()
        lblTotalValue.text = strTotal
        
        var isModifyCart = false;
        }
    func updateData()  {
        arrForProducts.removeAll()
        arrForProducts = (OrderBeingPrepared.selectedOrder.cartDetail?.orderDetails)!.map { $0 }
        mainOrderTable.reloadData()
        setUpTableViewHeight()
        calculateTotalAmount()
    }
    func setUpTableViewHeight()  {
        if (preferredContentSize.height + mainOrderTable.frame.origin.y) <= UIScreen.main.bounds.height - 100{
            heightForTblList.constant = preferredContentSize.height + mainOrderTable.frame.origin.y + 50
        }else{
            heightForTblList.constant = UIScreen.main.bounds.height - 100
        }
        self.view.layoutSubviews()
    }
}

extension OrderBeingPrepared:UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return    arrForProducts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  arrForProducts[section].items!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomOrderDetailCell
        
        cell.setCellData(itemDetail: arrForProducts[indexPath.section].items![indexPath.row], currency: OrderBeingPrepared.selectedOrder.currency ?? "", isEdit: self.isEditOrder, section: indexPath.section, row: indexPath.row, parent: self, isEditSelect: btnEditOrder.isSelected)
        cell.layoutIfNeeded()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionHeader = tableView.dequeueReusableCell(withIdentifier: "section")! as! OrderItemSection
        sectionHeader.setData(title: (arrForProducts[section].product_name!))
        return sectionHeader
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (arrForProducts[section].product_name!)
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1 //25
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.isEditOrder {
           goToProductSpecification(currentProduct: OrderBeingPrepared.selectedOrder.cartDetail!.orderDetails[indexPath.section].items![indexPath.row], indSection: indexPath.section, indRow: indexPath.row)
        }
        
    }
}
class OrderItemSection: CustomTableCell {
    @IBOutlet weak var lblSection: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        self.backgroundColor = UIColor.themeViewBackgroundColor
        lblSection.backgroundColor = UIColor.themeViewBackgroundColor
        lblSection.textColor = UIColor.themeButtonTitleColor
        lblSection.font = FontHelper.textMedium(size: FontHelper.medium)
    }
    
    func setData(title: String)
         {
        lblSection.text = title.appending("     ")
        lblSection.sectionRound(lblSection)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}



class CustomCollection: CustomCollectionCell {
    
    @IBOutlet weak var imgProductItem: UIImageView!

}

