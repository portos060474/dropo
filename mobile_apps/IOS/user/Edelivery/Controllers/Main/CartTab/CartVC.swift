//
//  HomeVC.swift
//  edelivery
//
//  Created by Elluminati on 14/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
import GooglePlaces

class CartVC: BaseVC, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, LeftDelegate {

    //MARK:- OutLets
    @IBOutlet weak var btnCheckout: UIButton!
    @IBOutlet weak var imgEmpty: UIImageView!
    @IBOutlet weak var viewForTotal: UIView!
    @IBOutlet weak var lblTotalValue: UILabel!
    @IBOutlet weak var tableForCartItems: UITableView!
    @IBOutlet weak var stkCheckout: UIStackView!
    @IBOutlet weak var viewForEmpty: UIView!

    var selectedIndexPath:IndexPath = IndexPath.init(row: -1, section: -1)

    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalization()
        tableForCartItems.rowHeight = UITableView.automaticDimension
        tableForCartItems.estimatedRowHeight = 250
        self.setNavigationTitle(title: "TXT_CART".localizedCapitalized)
        APPDELEGATE.setupNavigationbar()
        self.setBackBarItem(isNative: false)
        delegateLeft = self
        self.hideBackButtonTitle()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        wsGetCart()
    }

    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
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

    func setLocalization() {
        //Colors
        lblTotalValue.textColor = UIColor.themeButtonTitleColor
        viewForTotal.backgroundColor = UIColor.themeViewBackgroundColor
        btnCheckout.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        btnCheckout.backgroundColor = UIColor.themeButtonBackgroundColor
        viewForTotal.backgroundColor = UIColor.themeButtonBackgroundColor
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        self.tableForCartItems.backgroundColor = UIColor.themeViewBackgroundColor
        lblTotalValue.text = "TXT_DEFAULT".localized
        btnCheckout.setTitle("TXT_CHECKOUT".localizedCapitalized, for: UIControl.State.normal)
        lblTotalValue.font = FontHelper.textRegular()
        btnCheckout.titleLabel?.font = FontHelper.buttonText()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.onClickCheckOut(_:)))
        gestureRecognizer.delegate = self
        viewForTotal.addGestureRecognizer(gestureRecognizer)
        viewForEmpty.backgroundColor = UIColor.themeViewBackgroundColor
        self.hideBackButtonTitle()
    }

    func setupLayout() {
        tableForCartItems.tableFooterView = UIView()
        viewForTotal.applyRoundedCornersWithHeight()
    }

    override func updateUIAccordingToTheme() {
        self.setBackBarItem(isNative: false)
    }

    func onClickLeftButton() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.popViewController(animated: true)
    }

    //MARK:- TABLEVIEW DELEGATE METHODS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return currentBooking.cart[section].items!.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:CartCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CartCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let currentProduct:CartProduct = currentBooking.cart[indexPath .section]
        let currentItem:CartProductItems = currentProduct.items![indexPath.row]
        cell.setCellData(cellItem: currentItem, section: indexPath.section, row: indexPath.row, parent: self)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {   return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        self.goToProductSpecification(currentProduct: currentBooking.cart[indexPath.section].items![indexPath.row])
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {}

    func numberOfSections(in tableView: UITableView) -> Int {
        return currentBooking.cart.count
    }

    //MARK:- USER DEFINE FUNCTION
    func updateUI(isUpdate:Bool = false) {
        tableForCartItems.isHidden = !isUpdate
        viewForTotal.isHidden = !isUpdate
        imgEmpty.isHidden = isUpdate
        btnCheckout.isHidden = !isUpdate
        stkCheckout.isHidden = !isUpdate
    }

    func increaseQuantity(currentProductItem:CartProductItems) {
        printE("Increment Method Called")
        var quantity = currentProductItem.quantity!
        quantity = quantity + 1
        let total = (currentProductItem.total_specification_price! + currentProductItem.item_price!) * Double(quantity)
        currentProductItem.totalItemPrice = total
        currentProductItem.quantity = quantity
        currentProductItem.totalItemTax = ((currentProductItem.totalItemPrice ?? 0.0) * (currentProductItem.tax)) / 100
        calculateTotalAmount()
        wsAddItemInServerCart()
    }

    func getTax(itemAmount:Double, taxValue:Double) -> Double {
        
        if !currentBooking.isTaxIncluded {
            return itemAmount * taxValue * 0.01
        } else {
            return (itemAmount - (100*itemAmount)/(100+taxValue))
        }
    }

    func removeItemFromCart(currentProductItem:CartProductItems, section:Int, row:Int) {
        printE("Remove Method Called")
        if currentBooking.cart.count >= section{
            let currentProduct:CartProduct = currentBooking.cart[section]
            currentProduct.items?.remove(at: row)
            let itemCount = (currentProduct.items?.count) ?? 0
            if itemCount == 0 {
                currentBooking.cart.remove(at: section)
            }
            self.tableForCartItems?.reloadData()
            var isModifyCart = false
            for cartProduct in currentBooking.cart {
                if (cartProduct.items?.count)! > 0 {
                    isModifyCart = true
                }
            }
            if isModifyCart {
                wsAddItemInServerCart()
            } else {
                wsClearCart()
            }
            calculateTotalAmount()
        }
    }

    func decreaseQuantity(currentProductItem:CartProductItems) {
        printE("Decrement Method Called")
        var quantity = currentProductItem.quantity!
        if (quantity > 1 ) {
            quantity = quantity - 1
            let total = (currentProductItem.total_specification_price! + currentProductItem.item_price!) * Double(quantity)
            currentProductItem.totalItemPrice = total
            currentProductItem.quantity = quantity

            var tax = 0.0

            if !currentBooking.isUseItemTax {
                for obj in currentBooking.StoreTaxDetails {
                    tax = tax + Double(obj.tax)
                }
            } else {
                for obj in currentProductItem.taxDetails {
                    tax = tax + Double(obj.tax)
                }
            }
            print(tax)

            let specificationPriceTotal = currentProductItem.total_specification_price!
            let itemTax = getTax(itemAmount: currentProductItem.item_price!, taxValue: tax)
            let specificationTax = getTax(itemAmount: specificationPriceTotal, taxValue: tax)
            let totalTax = itemTax + specificationTax
            currentProductItem.itemTax = itemTax
            currentProductItem.totalSpecificationTax = specificationTax
            currentProductItem.totalTax = totalTax
            currentProductItem.totalItemTax =   totalTax * Double(quantity)

            self.tableForCartItems?.reloadData()
            calculateTotalAmount()
            wsAddItemInServerCart()
        }
    }

    func calculateTotalAmount()
    {
        var total = 0.0
        var totalCartAmountWithoutTax = 0.0

        for currentProduct in currentBooking.cart {
            for currentProductItem in currentProduct.items! {
                
                total = total + Double(currentProductItem.totalItemPrice!)
                var eachItemTax = 0

                if !currentBooking.isUseItemTax{
                    for obj in currentBooking.StoreTaxDetails{
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
                
                if currentBooking.isTaxIncluded{
                    total = total - totalTax
                }
                totalCartAmountWithoutTax = totalCartAmountWithoutTax + Double(currentProductItem.totalItemPrice!)

           }
        }
        setTotalAmount(total,totalCartAmountWithoutTax: totalCartAmountWithoutTax)
        currentBooking.totalCartAmount = total
        currentBooking.totalCartAmountWithoutTax = totalCartAmountWithoutTax

    }
    
    func setTotalAmount(_ total:Double = 0.0,totalCartAmountWithoutTax:Double = 0.0){
        let strTotal =   currentBooking.cartCurrency + " " + totalCartAmountWithoutTax.roundTo().toString()
        lblTotalValue.text = String(format: "%@- %@", "TXT_CHECKOUT".localizedCapitalized, strTotal)
    }
    
//MARK:- Web Service Methods
    func wsGetCart() {
        
        let dictParam: [String:Any] = APPDELEGATE.getCommonDictionary()
        print(dictParam)
        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_GET_CART, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Utility.hideLoading()
            currentBooking.clearCart()
            if Parser.parseCart(response) {
                if (currentBooking.cart).count == 0 {
                    self.updateUI(isUpdate: false)
                } else {
                    self.tableForCartItems?.reloadData()
                    self.calculateTotalAmount()
                }
            }
        }
    }

    func wsAddItemInServerCart(gotoNextActivity:Bool = false) {
        Utility.showLoading()
        let cartOrder:CartOrder = CartOrder.init()
        cartOrder.server_token = preferenceHelper.getSessionToken()
        cartOrder.user_id = preferenceHelper.getUserId()
        cartOrder.store_id = currentBooking.selectedStoreId
        cartOrder.order_details = currentBooking.cart
        cartOrder.orderPaymentId = currentBooking.orderPaymentId
                
        var totalPrice:Double = 0.0
        var totalTax:Double = 0.0
        for cartProduct in currentBooking.cart {
            var productTotalItemPrice:Double = 0.0
            var productTotalTax:Double = 0.0
            for cartItem in cartProduct.items! {
                productTotalItemPrice = productTotalItemPrice + cartItem.totalItemPrice!
                productTotalTax = productTotalTax + cartItem.totalItemTax
            }
            cartProduct.totalItemTax = productTotalTax
            cartProduct.total_item_price = productTotalItemPrice
            totalTax = totalTax + cartProduct.totalItemTax
            totalPrice = totalPrice + (cartProduct.total_item_price ?? 0.0)
        }
        
        cartOrder.totalCartPrice =  totalPrice
        cartOrder.totalItemTax = totalTax

        if (currentBooking.destinationAddress.isEmpty || currentBooking.destinationAddress[0].userDetails?.phone?.isEmpty ?? false) {
            
            let destinationAddress:Address = Address.init()
            destinationAddress.address = currentBooking.deliveryAddress
            destinationAddress.addressType = AddressType.DESTINATION
            destinationAddress.userType = CONSTANT.TYPE_USER
            destinationAddress.note = ""
            destinationAddress.city = currentBooking.currentSendPlaceData.city1
            destinationAddress.location = currentBooking.deliveryLatLng
            destinationAddress.flat_no = currentBooking.currentSendPlaceData.flat_no
            destinationAddress.street = currentBooking.currentSendPlaceData.street
            destinationAddress.landmark = currentBooking.currentSendPlaceData.landmark
        
            let cartUserDetail:CartUserDetail = CartUserDetail()
            cartUserDetail.email = preferenceHelper.getEmail()
            cartUserDetail.countryPhoneCode = preferenceHelper.getPhoneCountryCode()
            cartUserDetail.name = preferenceHelper.getFirstName() + " " + preferenceHelper.getLastName()
            cartUserDetail.phone = preferenceHelper.getPhoneNumber()
            destinationAddress.userDetails = cartUserDetail
            currentBooking.destinationAddress = [destinationAddress]
        }
        
        if currentBooking.pickupAddress.isEmpty {
            let mySelectedStore:StoreItem = currentBooking.selectedStore!
            let pickupAddress:Address = Address.init()
            pickupAddress.address = mySelectedStore.address
            pickupAddress.addressType = AddressType.PICKUP
            pickupAddress.userType = CONSTANT.TYPE_USER
            pickupAddress.note = ""
            pickupAddress.city = ""
            pickupAddress.location = mySelectedStore.location ?? [0.0,0.0]
            
            let cartStoreDetail:CartUserDetail = CartUserDetail()
            cartStoreDetail.email = mySelectedStore.email ?? ""
            cartStoreDetail.countryPhoneCode = mySelectedStore.country_phone_code ?? ""
            cartStoreDetail.name = mySelectedStore.name ?? ""
            cartStoreDetail.phone = mySelectedStore.phone ?? ""
            cartStoreDetail.imageUrl = mySelectedStore.image_url ?? ""
            pickupAddress.userDetails = cartStoreDetail
            currentBooking.pickupAddress = [pickupAddress]
        }
        
        cartOrder.pickupAddress = currentBooking.pickupAddress
        cartOrder.destinationAddress = currentBooking.destinationAddress
        if Utility.isTableBooking() || currentBooking.isQrCodeScanBooking {
            cartOrder.table_no = currentBooking.table_no
            cartOrder.table_id = currentBooking.tableID
            cartOrder.booking_type = currentBooking.bookingType
            cartOrder.delivery_type = DeliveryType.tableBooking
            currentBooking.deliveryType = DeliveryType.tableBooking
            cartOrder.no_of_persons = currentBooking.number_of_pepole
            cartOrder.order_start_at = currentBooking.futureDateMilliSecondTable
            cartOrder.order_start_at2 = currentBooking.futureDateMilliSecondTable2
        }

        let dictData:NSDictionary = (cartOrder.dictionaryRepresentation())
        dictData.setValue(currentBooking.isUseItemTax, forKey: PARAMS.IS_USE_ITEM_TAX)
        dictData.setValue(currentBooking.isTaxIncluded, forKey: PARAMS.IS_TAX_INCLUDED)
        dictData.setValue(currentBooking.totalCartAmountWithoutTax, forKey: PARAMS.TOTAL_CART_AMOUNT_WITHOUT_TAX)

        print("dicdata WS_ADD_ITEM_IN_CART -- \(Utility.convertDictToJson(dict: dictData as! Dictionary<String, Any>))")

        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_ADD_ITEM_IN_CART, methodName: AlamofireHelper.POST_METHOD, paramData: dictData as? Dictionary<String, Any>) { (response,error) -> (Void) in
            if (Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true)) {
                Utility.hideLoading()
                if gotoNextActivity {
                    if currentBooking.cart.count > 0 {
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: SEGUE.SEGUE_CART_TO_INVOICE, sender: self)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.tableForCartItems?.reloadData()
                    }
                }
            } else {
                self.wsGetCart()
            }
            Utility.hideLoading()
        }
    }
    
    func openClearCartDialogForChangeSetting() {
        
        let dialogForClearCart = CustomAlertDialog.showCustomAlertDialog(title: "TXT_ATTENTION".localized, message: "Item Tax Miss Match, Please Clear Cart", titleLeftButton: "".localizedCapitalized, titleRightButton: "TXT_OK".localizedCapitalized)
        dialogForClearCart.onClickLeftButton = {
            [unowned self,unowned dialogForClearCart] in
            
            dialogForClearCart.removeFromSuperview()
        }
        dialogForClearCart.onClickRightButton = {
            [unowned dialogForClearCart] in
            dialogForClearCart.removeFromSuperview()
            self.wsClearCart()
        }
    }
    
    func wsClearCart() {
        Utility.showLoading()
        var dictParam: [String:Any] = APPDELEGATE.getCommonDictionary()
        dictParam[PARAMS.CART_ID] = currentBooking.cartId

        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_CLEAR_CART, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response,error) -> (Void) in
            Utility.hideLoading()
            currentBooking.clearCart()
            currentBooking.clearTableBooking()
            self.updateUI(isUpdate: false)
        }
    }

    //MARK: - NAVIGATION METHODS
    @IBAction func onClickCheckOut(_ sender: Any) {
        if currentBooking.cart.count > 0 {
             self.wsAddItemInServerCart(gotoNextActivity: true)
        }
    }

    func goToProductSpecification(currentProduct:CartProductItems) {
        let myServerSelectedProductItem:ProductItemsItem = currentBooking.cartWithAllSpecification.first { (item) -> Bool in
            item.unique_id! == currentProduct.unique_id!
            }!
        myServerSelectedProductItem.quantity = currentProduct.quantity
        myServerSelectedProductItem.instruction = currentProduct.noteForItem

        for specification in myServerSelectedProductItem.specifications! {
            for subSpecification in specification.list!{
                subSpecification.is_default_selected = false
            }
            
            for currentProductspecification in currentProduct.specifications {
                if currentProductspecification.unique_id == specification.unique_id {
                    for subSpecification in specification.list! {
                        for currentSubSpecification in currentProductspecification.list! {
                            if subSpecification.unique_id == currentSubSpecification.unique_id {
                                subSpecification.is_default_selected = true
                                subSpecification.quantity = currentSubSpecification.quantity
                                print(subSpecification.name ?? "")
                            }
                        }
                    }
                }
            }
        }
        let myFinalProduct:ProductItemsItem = ProductItemsItem.init(dictionary: myServerSelectedProductItem.dictionaryRepresentation())!
        myFinalProduct.quantity = myServerSelectedProductItem.quantity
        myFinalProduct.currency = currentBooking.cartCurrency

        let productSpecificationVC = ProductSpecificationVC.init(nibName: "ProductSpecification", bundle: nil)
        productSpecificationVC.selectedProductItem = myFinalProduct
        productSpecificationVC.selectedProductItem?.name = currentProduct.item_name
        productSpecificationVC.selectedProductItem?.details = currentProduct.details
        productSpecificationVC.productName = currentBooking.cart[selectedIndexPath.section].product_name ?? ""
        productSpecificationVC.productUniqueId = currentBooking.cart[selectedIndexPath.section].unique_id ?? 0
        productSpecificationVC.selectedIndexPath = self.selectedIndexPath
        productSpecificationVC.quantity = myFinalProduct.quantity

        var isIndexMatch:Bool = false
        var selectedInd:Int = 0
        print(currentBooking.CartResponselangItems ?? "")

        if currentBooking.selectedStore != nil {
            for obj in currentBooking.selectedStore!.langItems!{
                if (obj.code == Constants.selectedLanguageCode) && (obj.is_visible! == true){
                    isIndexMatch = true
                    selectedInd = currentBooking.selectedStore!.langItems!.firstIndex(where: { $0.code == obj.code })!
                    break
                } else {
                    isIndexMatch = false
                }
            }
        } else {
            for obj in currentBooking.CartResponselangItems!{
                if (obj.code == Constants.selectedLanguageCode) && (obj.is_visible! == true){
                    isIndexMatch = true
                    selectedInd = currentBooking.CartResponselangItems!.firstIndex(where: { $0.code == obj.code })!
                    break
                } else {
                    isIndexMatch = false
                }
            }
        }

        if !isIndexMatch {
            if currentBooking.selectedStore != nil {
                if currentBooking.selectedStore!.langItems!.count > 0 {
                    productSpecificationVC.languageCode = currentBooking.selectedStore!.langItems![0].code!
                } else {
                    productSpecificationVC.languageCode = "en"
                }
                productSpecificationVC.languageCodeInd = "0"
            } else {
                if currentBooking.CartResponselangItems!.count > 0 {
                    productSpecificationVC.languageCode = currentBooking.CartResponselangItems![0].code!
                } else {
                    productSpecificationVC.languageCode = "en"
                }
                productSpecificationVC.languageCodeInd = "0"
            }
        } else {
            productSpecificationVC.languageCode = Constants.selectedLanguageCode
            productSpecificationVC.languageCodeInd = "\(selectedInd)"
        }
        self.navigationController?.pushViewController(productSpecificationVC, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier?.compare(SEGUE.SEGUE_CART_TO_INVOICE) == ComparisonResult.orderedSame {
            _ = segue.destination as! InvoiceVC
        }
    }
}
