//
//  EditOrderVC.swift
//  Edelivery
//
//  Created by Trusha on 22/05/20.
//  Copyright © 2020 Elluminati. All rights reserved.
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
    static var selectedOrder:Order = Order.init()
    var arrProductList:Array<ProductItem>? = nil
    var selectedItemId:[String] = [];
    var arrForProducts:[CartProduct] = []
    var selectedStore:StoreItem?
    let btnAddItem = UIButton.init(type: .custom)
    
    //MARK: View life cycle
    override func viewDidLoad(){
        
        super.viewDidLoad()
        setLocalization()
        tableForEditOrderItems.rowHeight = UITableView.automaticDimension
        tableForEditOrderItems.estimatedRowHeight = 105
        self.setNavigationTitle(title: "TXT_BASKET".localizedCapitalized)
        btnAddItem.setTitle(" " + "TXT_ADD_ITEM".localized + " ", for: UIControl.State.normal)
        btnAddItem.titleLabel?.font = FontHelper.textSmall()
        btnAddItem.sizeToFit()
        btnAddItem.backgroundColor = UIColor.themeSectionBackgroundColor
        btnAddItem.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        self.setRightBarButton(button: btnAddItem);
        self.setBackBarItem(isNative: false)
        delegateRight = self
        delegateLeft = self
        wsGetProductList(storeId: (EditOrderVC.selectedOrder.cartDetail?.storeId!)!)
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        if EditOrderVC.selectedOrder.cartDetail?.orderDetails.count == 0 {
            updateUI(isUpdate: false)
        }else {
            tableForEditOrderItems?.reloadData();
            calculateTotalAmount()
        }
    }
    
    func onClickLeftButton() {
        self.navigationController?.popViewController(animated: true)
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
        lblUpdateOrder.backgroundColor = UIColor.themeButtonBackgroundColor
        viewForTotal.backgroundColor = UIColor.themeButtonBackgroundColor
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        self.tableForEditOrderItems.backgroundColor = UIColor.themeViewBackgroundColor
        
        //Localizing
        title = "TXT_BASKET".localized
        lblTotalValue.text = "TXT_DEFAULT".localized
        lblUpdateOrder.text = "CONFIRM"
        
        /*Set Font*/
        lblTotalValue.font = FontHelper.textRegular()
        lblUpdateOrder.font = FontHelper.textRegular()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.onClickUpdateOrder(_:)))
        gestureRecognizer.delegate = self
        viewForTotal.addGestureRecognizer(gestureRecognizer)
        for product in EditOrderVC.selectedOrder.cartDetail!.orderDetails {
            for item in product.items! {
                selectedItemId.append(item.item_id!)
            }
        }
        self.hideBackButtonTitle()
    }
  
    func setupLayout(){
        tableForEditOrderItems.tableFooterView = UIView()
        btnAddItem.setRound(withBorderColor: UIColor.clear, andCornerRadious: 7.0, borderWidth: 1.0)
    }
    
    func onClickRightButton() {
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "Order", bundle: nil)
        if let OrderProductVC : OrderProductVC = mainView.instantiateViewController(withIdentifier: "OrderProductVC") as? OrderProductVC
        {
            OrderProductVC.arrItemsList = self.arrProductList!
            OrderProductVC.isFromUpdateOrder = false
            self.navigationController?.pushViewController(OrderProductVC, animated: true)
        }
        
    }
    
    //MARK: TABLEVIEW DELEGATE METHODS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return EditOrderVC.selectedOrder.cartDetail!.orderDetails[section].items!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:EditOrderCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! EditOrderCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let currentProduct:CartProduct = (EditOrderVC.selectedOrder.cartDetail?.orderDetails[indexPath.section])!
        let currentItem:CartProductItems =    currentProduct.items![indexPath.row]
        cell.setCellData(cellItem: currentItem, section: indexPath.section, row: indexPath.row, parent: self)
        return cell;
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {   return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        self.goToProductSpecification(currentProduct: EditOrderVC.selectedOrder.cartDetail!.orderDetails[indexPath.section].items![indexPath.row],indSection: indexPath.section,indRow: indexPath.row)

    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return EditOrderVC.selectedOrder.cartDetail!.orderDetails.count
    }
    
    //MARK: USER DEFINE FUNCTION
    
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
        
        productSpecificationVC.selectedProductItem = myFinalProduct
        productSpecificationVC.selectedProductItem?.name = currentProduct.item_name
        productSpecificationVC.selectedProductItem?.details = currentProduct.details
        productSpecificationVC.quantity =  myFinalProduct.quantity
        productSpecificationVC.productName = currentProduct.item_name
        productSpecificationVC.productUniqueId = currentProduct.unique_id
        productSpecificationVC.isFromUpdateOrder = true
        productSpecificationVC.selectInd = indRow
        productSpecificationVC.selectSection = indSection
        productSpecificationVC.selectedStore = self.selectedStore

        self.navigationController?.pushViewController(productSpecificationVC, animated: true)
    }
    
    func updateUI(isUpdate:Bool = false) {
        tableForEditOrderItems.isHidden = !isUpdate
        viewForTotal.isHidden = !isUpdate
        imgEmpty.isHidden = isUpdate
        lblUpdateOrder.isHidden = !isUpdate
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
            self.tableForEditOrderItems?.reloadData()
        }

    }
    
    
    public func removeItemFromCart(currentProductItem:CartProductItems, section:Int, row:Int){
        printE("Remove Method Called")
        
        let currentProduct:CartProduct = EditOrderVC.selectedOrder.cartDetail!.orderDetails[section]
       
        currentProduct.items?.remove(at: row)
        let itemCount = (currentProduct.items?.count) ?? 0
        if itemCount == 0 {
            
            EditOrderVC.selectedOrder.cartDetail!.orderDetails.remove(at: section)
        }
        self.tableForEditOrderItems?.reloadData()
        
        self.tableForEditOrderItems.reloadData()
        calculateTotalAmount()
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
            self.tableForEditOrderItems?.reloadData()
            calculateTotalAmount()
        }
    }
   
    func getTax(itemAmount:Double, taxValue:Double) -> Double {
        if !selectedStore!.isTaxInlcuded{
            return itemAmount * taxValue * 0.01
        }else{
            return (itemAmount - (100*itemAmount)/(100+taxValue))
        }
    }
    
    func calculateTotalAmount(){
        var total = 0.0
        var totalCartAmountWithoutTax = 0.0

        for currentProduct in EditOrderVC.selectedOrder.cartDetail!.orderDetails {
            for currentProductItem in currentProduct.items! {
                total = total + Double(currentProductItem.totalItemPrice!)
                
                var eachItemTax = 0

                if !selectedStore!.isUseItemTax{
                    for obj in selectedStore!.storeTaxDetails{
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
                
                if selectedStore!.isTaxInlcuded{
                    total = total - totalTax
                }
                
                totalCartAmountWithoutTax = totalCartAmountWithoutTax + Double(currentProductItem.totalItemPrice!)
            }
        }
        setTotalAmount(total,totalCartAmountWithoutTax:totalCartAmountWithoutTax)
        
        if EditOrderVC.selectedOrder.cartDetail!.orderDetails.count > 0{
            EditOrderVC.selectedOrder.cartDetail!.orderDetails[0].total_item_price = total
            EditOrderVC.selectedOrder.cartDetail!.orderDetails[0].totalCartAmountWithoutTax = totalCartAmountWithoutTax
        }
    }
    
    func setTotalAmount(_ total:Double = 0.0,totalCartAmountWithoutTax:Double = 0.0){

        let strTotal =  (totalCartAmountWithoutTax.roundTo()).toCurrencyString()
        lblTotalValue.text = strTotal
        
        var isModifyCart = false;
        for cartProduct in EditOrderVC.selectedOrder.cartDetail!.orderDetails {
            if (cartProduct.items!.count) > 0 {
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
    @IBAction func onClickUpdateOrder(_ sender: Any) {
        wsUpdateOrder()
    }
    
    //MARK:- WEB SERVICE CALLS
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
            
            self.arrProductList = Parser.parseStoreProductList(response)
            print("wsGetProductList response\(response)")
            
            DispatchQueue.main.async {
                if (response["store"] != nil) {
                    self.selectedStore = StoreItem.init(dictionary: response["store"] as! NSDictionary)
                    self.selectedStore?.currency = (response["currency"] as? String) ?? ""
                }
                Utility.hideLoading()
            }
        }
    }
    
    func wsUpdateOrder() {
        
        let cartOrder:CartOrder = CartOrder.init()        
        cartOrder.order_details = (EditOrderVC.selectedOrder.cartDetail?.orderDetails)
       
        var totalPrice:Double = 0.0
        var totalTax:Double = 0.0
        var taxDetails = [TaxesDetail]()
        var taxDetailArr = [[String:Any]]()
        for cartProduct in (EditOrderVC.selectedOrder.cartDetail!.orderDetails[0].items!) {
            
            var eachItemTax = 0

            totalTax = totalTax + cartProduct.totalItemTax
            totalPrice = totalPrice + (cartProduct.totalItemPrice ?? 0.0)
            
            if ((EditOrderVC.selectedOrder.store_detail?.isUseItemTax) != nil){
                for obj in EditOrderVC.selectedOrder.store_detail!.storeTaxDetails{
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
                            i.tax_amount = i.tax_amount + obj.tax
                        }
                    }
                }
         }
            
        }

        if selectedStore!.isTaxInlcuded{
            cartOrder.totalCartPrice =  totalPrice - totalTax
        }else{
            cartOrder.totalCartPrice =  totalPrice
        }
        cartOrder.totalItemTax = totalTax
        
        var totalItemsCount = 0
        
        for cartProductItem in (EditOrderVC.selectedOrder.cartDetail!.orderDetails[0].items!) {
            totalItemsCount += cartProductItem.quantity!
        }
        
        for obj in taxDetails{
            taxDetailArr.append(obj.toDictionary())
        }

        print(taxDetailArr)
        
        let afn:AlamofireHelper = AlamofireHelper.init()
        let dictParam:NSMutableDictionary = (cartOrder.dictionaryRepresentationOrder_details() as! NSMutableDictionary)
        
        dictParam[PARAMS.ORDER_ID]  = EditOrderVC.selectedOrder._id
        dictParam[PARAMS.SERVER_TOKEN]  = preferenceHelper.getSessionToken()
        dictParam[PARAMS.STORE_ID]  = (EditOrderVC.selectedOrder.cartDetail?.storeId!)!
        dictParam[PARAMS.USER_ID]  = preferenceHelper.getUserId()
        dictParam[PARAMS.TOTAL_CART_PRICE]  = cartOrder.totalCartPrice
        dictParam[PARAMS.TOTAL_ITEM_COUNT]  = totalItemsCount
        dictParam[PARAMS.TOTAL_ITEM_TAX]  = cartOrder.totalItemTax
        dictParam["tax_details"] = taxDetailArr

        print(Utility.convertDictToJson(dict: dictParam as! Dictionary<String, Any>))
        
        afn.getResponseFromURL(url: WebService.WS_USER_UPDATE_ORDER, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam as? Dictionary<String, Any>) { (response,error) -> (Void) in
            
            if (Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true)) {
                var isFindController : Bool = false
                if let navigationVC = self.navigationController {
                    print("navigationVC.viewControllers --- \(navigationVC.viewControllers)")
                    for controller in navigationVC.viewControllers {
                        if controller.isKind(of: OrderVC.self) {
                            self.navigationController?.popToViewController(controller, animated: true)
                            isFindController = true
                            return
                        }
                    }
                    if !isFindController{
                        if navigationVC.viewControllers.count > 0 {
                            self.navigationController?.popToViewController(navigationVC.viewControllers[0], animated: true)
                            return
                        }
                    }
                }
            }
            Utility.hideLoading()
        }
    }
}
