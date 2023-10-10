//
//  ProductVC.swift
//  edelivery
//
//  Created by Elluminati on 09/03/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

@objc protocol refreshCartBadgeDelegate: AnyObject {
    func refreshCartBadge()
}

class ProductSpecificationVC: BaseVC, UIViewControllerTransitioningDelegate, UINavigationBarDelegate, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate, LeftDelegate {
    
    weak var timerForItem: Timer? = nil
    var  statusbarHeight:CGFloat = 20.0
    
    //MARK:- OUTLETS
    @IBOutlet weak var navigationHeight: NSLayoutConstraint!
    @IBOutlet weak var tableViewTopConstriant: NSLayoutConstraint!
    @IBOutlet weak var collectionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var pgControlforDialog: UIPageControl!
    @IBOutlet weak var lblDialogGradient: UILabel!
    @IBOutlet weak var collectionForItems: UICollectionView!
    @IBOutlet var dialogForProductItemImages: UIView!
    @IBOutlet weak var lblGradient: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblCartQuantity: UILabel!
    @IBOutlet weak var viewForRight: UIView!
    @IBOutlet weak var pgControl: UIPageControl!
    @IBOutlet weak var collectionForItemImages: UICollectionView!
    @IBOutlet var lblProductName: UILabel!
    @IBOutlet var viewForProduct: UIView!
    @IBOutlet var lblProductDetail: UILabel!
    @IBOutlet weak var tblForProductSpecification: UITableView!
    @IBOutlet weak var viewForHeader: UIView!
    @IBOutlet weak var viewForNavigation: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var viewForAddToCart: UIView!
    @IBOutlet weak var btnAddcart: UIButton!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var viewForFooter: UIView!
    @IBOutlet weak var btnCart: UIButton!
    @IBOutlet weak var viewForQuantity: UIView!
    @IBOutlet weak var txtNoteForItem: CustomTextfield!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var lblNote: UILabel!
    
    //MARK:- Variables
    var delegateRefreshCartBadge:refreshCartBadgeDelegate?
    var quantity = 1
    var total = 0.00
    var arrSpecificationListMain = [Specifications]()
    var arrSpecificationList = [Specifications]()
    var arrSpecificationFromProductVC = [Specifications]()
    var arrSpecificationItemList:Array<SpecificationListItem>? = nil
    var specificationItemListLength:Int? = 0
    var specificationListLength:Int? = 0
    var selectedProductItem:ProductItemsItem? = nil
    var productName:String? = nil
    var productUniqueId:Int? = 0
    var currentItemIndex:Int = 0
    var newImage: UIImage!
    var requiredCount:Int = 0
    var cartButton:MyBadgeButton? = nil
    var selectedIndexPath:IndexPath = IndexPath.init(row: -1, section: -1)
    var languageCode : String = "en"
    var languageCodeInd : String = "1"

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    //MARK:- View Life Cycle
    override func viewDidLoad(){
        super.viewDidLoad()
        statusbarHeight = UIApplication.shared.statusBarFrame.height
        setProductData(productdata: selectedProductItem!)
        
        if LocalizeLanguage.isRTL {
            btnBack.setImage( btnBack.image(for: .normal)?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)
        }
        
        self.arrSpecificationFromProductVC.removeAll()
        if selectedProductItem!.specifications!.count > 0 {
            self.arrSpecificationFromProductVC.append(contentsOf: selectedProductItem!.specifications!)
        }
    
        self.setNavigationTitle(title: selectedProductItem?.name ?? "")
        delegateLeft = self
        self.setBackBarItem(isNative:false)
        cartButton = MyBadgeButton.init(frame: CGRect.init(x: 0, y: 0, width: 32, height: 32))
        cartButton?.setImage(UIImage.init(named: "cart_colour_outline"), for: .normal)
        cartButton?.badgeString = ""
        cartButton?.badgeTextColor = UIColor.themeButtonTitleColor
        cartButton?.badgeBackgroundColor = UIColor.themeRedBGColor
        cartButton?.addTarget(self, action: #selector(ProductVC.onClickBtnCart(_:)), for: .touchUpInside)
        let rightButton:UIBarButtonItem = UIBarButtonItem.init(customView: cartButton!)
        self.tblForProductSpecification.delegate = self
        self.tblForProductSpecification.dataSource = self
        self.tblForProductSpecification.estimatedRowHeight = 40
        self.tblForProductSpecification.estimatedSectionHeaderHeight = 20
        self.tblForProductSpecification.rowHeight = UITableView.automaticDimension
        self.tblForProductSpecification.sectionHeaderHeight = UITableView.automaticDimension
        
    
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapOnAddToCart(gestureRecognizer:)))
        gestureRecognizer.delegate = self
        viewForAddToCart.addGestureRecognizer(gestureRecognizer)
        viewForNavigation.backgroundColor = UIColor.clear
        self.tblForProductSpecification.register(cellTypes: [ProductSpecificationCell.self,ProductSpecificationSection.self])
        self.collectionForItemImages.register(cellType: CustomCollection.self)
        self.collectionForItems.register(cellType: CustomCollection.self)
        self.tblForProductSpecification.reloadData()
        wsGetUserSpecificationList()
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayout()
        collectionForItems.reloadData()
        collectionForItemImages.reloadData()
    }
    
    func sizeHeaderToFit() {
        navigationHeight.constant = statusbarHeight + 64
        let headerView = tblForProductSpecification.tableHeaderView!
        collectionViewTopConstraint.constant = -statusbarHeight
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        viewForFooter.layoutIfNeeded()
        lblProductDetail.sizeToFit()
        let height = lblProductDetail.frame.maxY + 10
        var frame = headerView.frame
        frame.size.height = height
        headerView.frame = frame
        tblForProductSpecification.tableHeaderView = headerView
        tblForProductSpecification.tableFooterView = viewForFooter
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setItemCountInBasket()
        self.navigationController?.isNavigationBarHidden = true
        setLocalization()
        sizeHeaderToFit()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
        timerForItem?.invalidate()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.navigationController?.view.setNeedsLayout()
    }
    
    func setupTimer() {
        timerForItem?.invalidate()
        timerForItem = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(ProductSpecificationVC.handleAddTimer), userInfo: nil, repeats: true)
    }
    
    @objc func handleAddTimer() {
        currentItemIndex = currentItemIndex +  1
        if (currentItemIndex == selectedProductItem?.image_url?.count ?? 0) {
            currentItemIndex = 0
        }
        let indexPath = IndexPath(row: currentItemIndex, section: 0)
        pgControl.currentPage = currentItemIndex
        pgControlforDialog.currentPage = currentItemIndex
        if #available(iOS 14.0, *) {
            self.collectionForItems.isPagingEnabled = false
            self.collectionForItems.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.collectionForItems.isPagingEnabled = true
            self.collectionForItemImages.isPagingEnabled = false
            self.collectionForItemImages?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.collectionForItemImages.isPagingEnabled = true
        }
        else {
            collectionForItems.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            collectionForItemImages.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    func setLocalization(){
        
        lblGradient.text = ""
        txtNoteForItem.placeholder = "TXT_NOTE".localizedCapitalized
        lblNote.text = "TXT_NOTE_TEXT".localized
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        viewForQuantity.backgroundColor = UIColor.themeViewBackgroundColor
        lblCartQuantity.backgroundColor = UIColor.themeRedBGColor
        lblCartQuantity.textColor = UIColor.themeButtonTitleColor
        viewForHeader.backgroundColor = UIColor.themeViewBackgroundColor
        viewForProduct.backgroundColor = UIColor.themeViewBackgroundColor
        tblForProductSpecification.backgroundColor = UIColor.themeViewBackgroundColor
        viewForFooter.backgroundColor = UIColor.themeViewBackgroundColor
        viewForQuantity.backgroundColor = UIColor.themeViewBackgroundColor
        tblForProductSpecification.tableFooterView?.backgroundColor = UIColor.themeViewBackgroundColor
        lblProductDetail.textColor = UIColor.themeLightTextColor
        lblDescription.textColor = UIColor.themeTextColor
        lblTotal.textColor = UIColor.themeButtonTitleColor
        lblQuantity.textColor = UIColor.themeColor
        btnPlus.setTitleColor(UIColor.themeColor, for: .normal)
        btnMinus.setTitleColor(UIColor.themeColor, for: .normal)
        lblNote.textColor = UIColor.themeLightTextColor
        viewForAddToCart.backgroundColor = UIColor.themeColor
        btnAddcart.setTitleColor(UIColor.themeButtonTitleColor, for:UIControl.State.normal)
        pgControl.currentPageIndicatorTintColor = UIColor.black
        pgControl.pageIndicatorTintColor = UIColor.gray
        pgControlforDialog.currentPageIndicatorTintColor = UIColor.black
        pgControlforDialog.pageIndicatorTintColor = UIColor.gray
       
        /* Set Font */
        lblCartQuantity.font = FontHelper.cartText()
        lblProductDetail.font = FontHelper.labelRegular(size: FontHelper.medium)
        lblDescription.font = FontHelper.textMedium()
        lblProductName.font = FontHelper.textRegular(size: FontHelper.large)
        lblTotal.font = FontHelper.buttonText()
        lblNote.font = FontHelper.textRegular()
        if getIsFromCart() {
            btnAddcart.setTitle("TXT_UPDATE_CART".localizedCapitalized, for: UIControl.State.normal)
        }else {
            btnAddcart.setTitle("TXT_ADD_TO_CART".localizedCapitalized, for: UIControl.State.normal)
        }
        btnPlus.layer.borderColor = UIColor.themeColor.cgColor
        btnMinus.layer.borderColor = UIColor.themeColor.cgColor
        btnPlus.layer.borderWidth = 1
        btnMinus.layer.borderWidth = 1
        viewForQuantity.layer.borderWidth = 1
        viewForQuantity.layer.borderColor = UIColor.themeColor.cgColor
        let leftRect = CGRect(x: 0.0, y: 0.0, width: 20.0, height: txtNoteForItem.frame.size.height)
        self.hideBackButtonTitle()
        tblForProductSpecification.alwaysBounceVertical = false
    }
    
    func getIsFromCart() -> Bool {
        return selectedIndexPath.row > -1
    }
    
    func setupLayout() {
        lblGradient.setGradient(startColor:UIColor.themeEndGradientColor,endColor:UIColor.themeStartGradientColor)
        viewForNavigation.setGradient(startColor: UIColor.themeStartGradientColor, endColor: UIColor.themeEndGradientColor)
        lblDialogGradient.setGradient(startColor:UIColor.themeEndGradientColor,endColor:UIColor.themeStartGradientColor)
        viewForQuantity.applyRoundedCornersWithHeight()
        lblCartQuantity.setRound()
        lblProductDetail.sizeToFit()
        viewForHeader.sizeToFit()
        viewForHeader.autoresizingMask = UIView.AutoresizingMask()
        dialogForProductItemImages.frame = UIScreen.main.bounds
        viewForAddToCart.applyRoundedCornersWithHeight()
    }
    override func updateUIAccordingToTheme() {
        tblForProductSpecification.reloadData()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: TABLEVIEW DELEGATE METHODS
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrSpecificationList.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return (arrSpecificationList[section].name)!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = tableView.dequeueReusableCell(withIdentifier: "ProductSpecificationSection")! as! ProductSpecificationSection
        sectionHeader.setData(title: arrSpecificationList[section].name!, isAllowMultipleSelect: Bool(truncating: (arrSpecificationList[section].type! as NSNumber)), isRequired: arrSpecificationList[section].is_required!,message: arrSpecificationList[section].selectionMessage)
        return sectionHeader
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let viewFrame = CGRect(x: 0.0, y: 0.0, width: tableView.frame.width, height: 20.0)
        let view = UIView(frame: viewFrame)
        view.backgroundColor = UIColor.themeViewBackgroundColor
        return view
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20.0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrSpecificationList.count > 0{
            specificationItemListLength = arrSpecificationList[section].list?.count ?? 0
            return specificationItemListLength!
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionType = arrSpecificationList[indexPath.section].type!
        
        let productSpecificationCell = tableView.dequeueReusableCell(with: ProductSpecificationCell.self, for: indexPath)
        let currentProduct:Specifications = arrSpecificationList[indexPath.section]
        let currentProductItem:SpecificationListItem = currentProduct.list![indexPath.row]
        //productSpecificationCell.setCellData(cellItem: currentProductItem, isAllowMultipleSelect: sectionType,currency: selectedProductItem?.currency ?? "" ,arrSpecificationFromProductVC: self.arrSpecificationFromProductVC[indexPath.section].list![indexPath.row],isFromCart: getIsFromCart())
        
        productSpecificationCell.setCellData(cellItem: currentProductItem, isAllowMultipleSelect: sectionType,currency: selectedProductItem?.currency ?? "" ,arrSpecificationFromProductVC: self.arrSpecificationList[indexPath.section].list![indexPath.row],isFromCart: getIsFromCart())
        
        if !arrSpecificationList[indexPath.section].user_can_add_specification_quantity {
            productSpecificationCell.viewQty.isHidden = true
        }
        productSpecificationCell.delegate = self
        return productSpecificationCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
                
        self.tblForProductSpecification.reloadData()
        
        calculateTotalAmount()
        setTotalAmount(total)
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
    
    func onClickLeftButton() {
        self.onClickBtnBack(btnBack)
    }

    //Action Method
    @IBAction func onClickBtnBack(_ sender: Any) {
        if getIsFromCart() {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func onClickBtnCart(_ sender: Any) {
        if let navigationVC = self.navigationController {
            for controller in navigationVC.viewControllers {
                if controller.isKind(of: CartVC.self) {
                    self.delegateRefreshCartBadge?.refreshCartBadge()
                    if getIsFromCart() {
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        self.dismiss(animated: true, completion: nil)
                    }
                    return
                }
            }
        }
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "Cart", bundle: nil)
        if let cartvc: CartVC = mainView.instantiateInitialViewController() as? CartVC {
            self.navigationController?.pushViewController(cartvc, animated: true)
        }
    }
    
    @objc func handleTapOnAddToCart(gestureRecognizer: UIGestureRecognizer) {
        if currentBooking.currentAddress.isEmpty {
            currentBooking.currentAddress = currentBooking.selectedStore?.address ?? ""
        }
        if !currentBooking.currentAddress.isEmpty() {
            
            if(currentBooking.cart.count == 0) {
                addToCart()
            }else {
                if currentBooking.selectedStoreId != nil{
                    if (currentBooking.selectedStoreId!.compare((selectedProductItem?.store_id!)!) == .orderedSame) {
                        addToCart()
                    }else {
                        openClearCartDialog()
                    }
                }else{
                    openClearCartDialog()
                }
            }
        }else {
            Utility.showToast(message: "MSG_YOUR_DELIVERY_ADDRESS_IS_EMPTY".localized)
        }
    }
    
    @IBAction func onClickBtnIncrement(_ sender: Any){
        quantity+=1
        lblQuantity.text = String(quantity)
        calculateTotalAmount()
        setTotalAmount(total)
        
    }
    
    @IBAction func onClickBtnDecrement(_ sender: Any){
        quantity-=1
        if quantity == 0 {
            quantity = 1
        }
        lblQuantity.text = String(quantity)
        calculateTotalAmount()
        setTotalAmount(total)
    }
    
    //User Define Functions
    func setProductData(productdata:ProductItemsItem) {
        quantity = productdata.quantity
        lblQuantity.text = String(quantity)
        lblProductName.text = productdata.name!
        lblProductDetail.text = productdata.details!
        pgControl.numberOfPages = (productdata.image_url?.count) ?? 0
        pgControlforDialog.numberOfPages = (productdata.image_url?.count) ?? 0
        if pgControl.numberOfPages <= 1 {
            pgControl.isHidden = true
            pgControlforDialog.isHidden = true
        }
        if getIsFromCart() {
            txtNoteForItem.text = productdata.instruction
        }
        if productdata.image_url?.count ?? 0 > 0 {
            collectionForItems.isHidden = false
        } else {
            collectionForItems.isHidden = true
        }
    }
    
    func addToCart() {
        
        var arrCurrentAdded = [CartProductItems]()
        if currentBooking.cart.count > 0 {
            for obj in CurrentBooking.shared.cart {
                for item in (obj.items ?? []) {
                    arrCurrentAdded.append(item)
                }
            }
        }
        print(arrCurrentAdded)
        
        currentBooking.deliveryAddress = currentBooking.currentAddress
        currentBooking.deliveryLatLng = currentBooking.currentLatLng
        var specificationPriceTotal = 0.0
        var specificationPrice = 0.0
        var specificationList:[Specifications] = [Specifications].init()
        
        Utility.showLoading()
        for specificationListItem in arrSpecificationList {
            
            var specificationItemCartList:[SpecificationListItem] = [SpecificationListItem].init()
            
            for listItem in specificationListItem.list! {
                print(listItem.name)
                print(listItem.is_default_selected)
                
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
        guard let currentSelectedProductItem = selectedProductItem else {
            return
        }
        
        cartProductItems.item_id = currentSelectedProductItem._id
        cartProductItems.unique_id = currentSelectedProductItem.unique_id
        cartProductItems.item_name = currentSelectedProductItem.name
        cartProductItems.quantity = quantity
        cartProductItems.image_url = currentSelectedProductItem.image_url
        cartProductItems.details = currentSelectedProductItem.details
        cartProductItems.specifications = specificationList
        cartProductItems.item_price = currentSelectedProductItem.price
        cartProductItems.total_specification_price = specificationPriceTotal
        cartProductItems.totalItemPrice = total
        cartProductItems.taxDetails = currentSelectedProductItem.taxDetails
        cartProductItems.noteForItem = txtNoteForItem.text ?? ""
        cartProductItems.totalPrice = currentSelectedProductItem.price + specificationPriceTotal
        
        var tax = 0.0
        
        if getIsFromCart() {
            if !currentBooking.isUseItemTax {
                for obj in currentBooking.StoreTaxDetails {
                    tax = tax + Double(obj.tax)
                }
            }else{
                for obj in selectedProductItem!.taxDetails{
                    tax = tax + Double(obj.tax)
                }
            }
        }else{
            if !currentBooking.selectedStore!.isUseItemTax{
                for obj in currentBooking.selectedStore!.storeTaxDetails{
                    tax = tax + Double(obj.tax)
                }
            }else{
                for obj in currentSelectedProductItem.taxDetails{
                    tax = tax + Double(obj.tax)
                }
            }
        }
        
        print(tax)
        let itemTax = getTax(itemAmount: currentSelectedProductItem.price, taxValue: tax)
        let specificationTax = getTax(itemAmount: specificationPriceTotal, taxValue: tax)
        let totalTax = itemTax + specificationTax
        cartProductItems.tax = tax
        cartProductItems.itemTax = itemTax
        cartProductItems.totalSpecificationTax = specificationTax
        cartProductItems.totalTax = totalTax
        cartProductItems.totalItemTax = totalTax * Double(quantity)
        
        if getIsFromCart() {
            currentBooking.cart[selectedIndexPath.section].items![selectedIndexPath.row] = cartProductItems
            currentBooking.cart[selectedIndexPath.section].totalItemTax = cartProductItems.totalItemTax
            wsAddItemInServerCart(cartPRoduct:currentBooking.cart[selectedIndexPath.section] )
        } else {
            if !(currentBooking.cartWithAllSpecification.contains(where: { (item) -> Bool in
                item._id == currentSelectedProductItem._id!
            })) {
                currentBooking.cartWithAllSpecification.append(currentSelectedProductItem)
            }
            
            let isAdded = arrCurrentAdded.filter { obj in
                if obj.getProductJson().isEqual(to: cartProductItems.getProductJson() as! [AnyHashable : Any]) {
                    return true
                }
                return false
            }

            if isAdded.count > 0 {
                var section = 0
                var row = 0
                
                for obj in currentBooking.cart {
                    for item in (obj.items ?? []) {
                        if isAdded[0].getProductJson().isEqual(to: item.getProductJson() as! [AnyHashable : Any]) {
                            section = currentBooking.cart.firstIndex(where: {$0.getProductJson() == obj.getProductJson()}) ?? 0
                            row = (obj.items ?? []).firstIndex(where: {$0.getProductJson() == item.getProductJson()}) ?? 0
                            print("break")
                            break
                        }
                    }
                }
                
                print("section \(section) row \(row)")
                
                currentBooking.cart[section].items![row] = cartProductItems
                currentBooking.cart[section].items![row].quantity = isAdded[0].quantity + self.quantity
                currentBooking.cart[section].items![row].totalItemTax = totalTax * Double((isAdded[0].quantity + self.quantity))
                wsAddItemInServerCart(cartPRoduct:currentBooking.cart[section])
                
            }else {
                var cartProductItemsList:[CartProductItems] = [CartProductItems].init() 
                cartProductItemsList.append(cartProductItems)
                let cartProducts:CartProduct = CartProduct.init() 
                cartProducts.items = cartProductItemsList
                cartProducts.product_id = currentSelectedProductItem.product_id
                cartProducts.product_name = productName
                cartProducts.unique_id = productUniqueId
                cartProducts.total_item_price = total
                cartProducts.totalItemTax =  cartProductItems.totalItemTax
                currentBooking.cart.append(cartProducts)
                currentBooking.selectedStoreId = currentSelectedProductItem.store_id
                wsAddItemInServerCart(cartPRoduct: cartProducts)
            }
        }
        
        setItemCountInBasket()
    }
    
    func getTax(itemAmount:Double, taxValue:Double) -> Double {
        if !currentBooking.isTaxIncluded{
            return itemAmount * taxValue * 0.01
        }else{
            return (itemAmount - (100*itemAmount)/(100+taxValue))
        }
    }
    
    func setItemCountInBasket() {
        var numberOfItems = 0
        for cartProduct in currentBooking.cart {
            numberOfItems = numberOfItems + (cartProduct.items?.count)!
        }
        currentBooking.totalItemInCart = numberOfItems
        lblCartQuantity?.text = String(currentBooking.totalItemInCart)
        cartButton?.badgeString = String(currentBooking.totalItemInCart)
    }
    
    func isProductExistInLocalCart(cartProductItems:CartProductItems) -> (Bool,CartProduct?) {
        for cartProduct in currentBooking.cart {
            if ((cartProduct.product_id?.compare((selectedProductItem?.product_id)!)) == .orderedSame) {
                return (true,cartProduct)
            }
        }
        return (false,nil)
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
        self.setTotalAmount(self.total)
    }
    
    func setDefaultSelection() {
        var arrIndex = [IndexPath]()
        
        for obj in arrSpecificationList {
            for objList in obj.list ?? [] {
                if objList.is_default_selected {
                    if let section = arrSpecificationList.firstIndex(where: {$0._id == obj._id}) {
                        if let row = (obj.list ?? []).firstIndex(where: {$0._id == objList._id}) {
                            arrIndex.append(IndexPath(row: row, section: section))
                        }
                    }
                }
            }
        }
        
        for indexPath in arrIndex {
            self.tableView(tblForProductSpecification, didSelectRowAt: indexPath)
        }
    }
    
    func calculateTotalAmount() {
        total = Double((selectedProductItem?.price)!)
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
        total = total * Double(quantity)
        if (requiredCountTemp == requiredCount) {
            viewForAddToCart.isUserInteractionEnabled = true
            viewForAddToCart.backgroundColor = UIColor.themeButtonBackgroundColor
        } else {
            viewForAddToCart.isUserInteractionEnabled = false
            viewForAddToCart.backgroundColor = UIColor.themeDisableButtonBackgroundColor
        }
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
    
    func setTotalAmount(_ total:Double) {
        let strTotal = (selectedProductItem?.currency ?? "")  + total.toString()
        lblTotal.text = strTotal
        var strTitle = ""
        if getIsFromCart() {
            strTitle = "TXT_UPDATE_CART".localizedCapitalized
        }else {
            strTitle = "TXT_ADD_TO_CART".localizedCapitalized
            
        }
        strTitle = String(format:"%@- %@", strTitle, strTotal)
        btnAddcart.setTitle(strTitle, for: UIControl.State.normal)
    }
    
    func openClearCartDialog() {
        
        let dialogForClearCart = CustomAlertDialog.showCustomAlertDialog(title: "TXT_ATTENTION".localized, message: "MSG_OTHER_STORE_ITEM_IN_CART".localized, titleLeftButton: "".localizedCapitalized, titleRightButton: "TXT_OK".localizedCapitalized)
        dialogForClearCart.onClickLeftButton = {
            [unowned self,unowned dialogForClearCart] in
            dialogForClearCart.removeFromSuperview()
        }
        dialogForClearCart.onClickRightButton = {
            [unowned self,unowned dialogForClearCart] in
            dialogForClearCart.removeFromSuperview()
            self.wsClearCart()
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
    
    @IBAction func onClickBtnCloseDialog(_ sender: Any) {
        dialogForProductItemImages.isHidden = true
    }
    
    // MARK:- ScrollView Deligate Methods
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        if(self.tblForProductSpecification.isTableHeaderViewVisible) {
            viewForNavigation.setGradient(startColor: UIColor.themeStartGradientColor, endColor: UIColor.themeEndGradientColor)
            self.viewForNavigation.isHidden = false
            self.tableViewTopConstriant.constant = 0
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }else {
            self.viewForNavigation.setGradient(startColor: UIColor.themeNavigationBackgroundColor, endColor: UIColor.themeNavigationBackgroundColor)
            self.viewForNavigation.isHidden = true
            self.tableViewTopConstriant.constant = -44 - statusbarHeight
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let center = CGPoint(x: scrollView.contentOffset.x + (scrollView.frame.width / 2), y: (scrollView.frame.height / 2))

        if dialogForProductItemImages.isHidden {
            if let ip = collectionForItems.indexPathForItem(at: center) {
                if #available(iOS 14.0, *) {
                    self.collectionForItems.isPagingEnabled = false
                    self.collectionForItems?.scrollToItem(at: ip, at: .centeredHorizontally, animated: true)
                    self.collectionForItems.isPagingEnabled = true

                    self.collectionForItemImages.isPagingEnabled = false
                    self.collectionForItemImages?.scrollToItem(at: ip, at: .centeredHorizontally, animated: true)
                    self.collectionForItemImages.isPagingEnabled = true
                }
                else {
                    self.collectionForItems?.scrollToItem(at: ip, at: .centeredHorizontally, animated: true)
                    self.collectionForItemImages.scrollToItem(at: ip, at: .centeredHorizontally, animated: false)
                }
                self.pgControl.currentPage = ip.row
                self.pgControlforDialog.currentPage = ip.row
            }
        }else {
            if let ip = collectionForItemImages.indexPathForItem(at: center) {
                if #available(iOS 14.0, *) {
                    self.collectionForItems.isPagingEnabled = false
                    self.collectionForItems?.scrollToItem(at: ip, at: .centeredHorizontally, animated: true)
                    self.collectionForItems.isPagingEnabled = true
                    self.collectionForItemImages.isPagingEnabled = false
                    self.collectionForItemImages?.scrollToItem(at: ip, at: .centeredHorizontally, animated: true)
                    self.collectionForItemImages.isPagingEnabled = true
                }
                else {
                    self.collectionForItems?.scrollToItem(at: ip, at: .centeredHorizontally, animated: true)
                    self.collectionForItemImages.scrollToItem(at: ip, at: .centeredHorizontally, animated: false)
                }
                self.pgControlforDialog.currentPage = ip.row
                self.pgControl.currentPage = ip.row
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    //MARK:- WEB SERVICE CALLS
    func wsGetUserSpecificationList() {
        
        let dictParam: Dictionary<String,Any> =
            [PARAMS.USER_ID:preferenceHelper.getUserId(),
             PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken(),
             PARAMS.ITEM_ID:selectedProductItem!._id!
            ]
        
        print(dictParam)
        
        Utility.showLoading()
        let afn:AlamofireHelper = AlamofireHelper.init()
        
        afn.getResponseFromStoreURL(langInd: languageCodeInd, url: WebService.WS_GET_USER_SPECIFICATION_LIST, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            
            Utility.hideLoading()
            
            print(response)
            let arr: Array<Specifications> = Parser.parseSpecifications(response)
            if arr.count > 0{
                self.arrSpecificationListMain = arr
            }
            print(self.arrSpecificationListMain)
            
            DispatchQueue.main.async {
                if self.arrSpecificationListMain.count > 0 && self.arrSpecificationFromProductVC.count > 0{
                    for i in 0...self.arrSpecificationFromProductVC.count - 1{
                        if i < self.arrSpecificationListMain.count {
                            if self.arrSpecificationFromProductVC[i].list!.count == self.arrSpecificationListMain[i].list!.count{
                                if self.arrSpecificationFromProductVC[i].list!.count > 0 {
                                    for j in 0...self.arrSpecificationFromProductVC[i].list!.count-1{
                                        self.arrSpecificationListMain[i].list![j].is_default_selected = false
                                        if self.arrSpecificationListMain[i].list![j].unique_id == self.arrSpecificationFromProductVC[i].list![j].unique_id{
                                            self.arrSpecificationListMain[i].list![j].is_default_selected
                                                = self.arrSpecificationFromProductVC[i].list![j].is_default_selected
                                            self.arrSpecificationListMain[i].list![j].quantity = self.arrSpecificationFromProductVC[i].list![j].quantity
                                            print(self.arrSpecificationListMain[i].list![j].name!)
                                            print(self.arrSpecificationListMain[i].list![j].is_default_selected)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                self.reArrageArrayWithAssociateSP(arr: self.arrSpecificationListMain)
                self.specificationListLength = self.arrSpecificationList.count
                self.lblCartQuantity.text = String(currentBooking.totalItemInCart)
                self.sizeHeaderToFit()
                self.tblForProductSpecification.reloadData()
            }
        }
    }
    
    func wsAddItemInServerCart(cartPRoduct:CartProduct) {
        
        let cartOrder:CartOrder = CartOrder.init()
        cartOrder.server_token = preferenceHelper.getSessionToken()
        cartOrder.user_id = preferenceHelper.getUserId()
        cartOrder.store_id = currentBooking.selectedStoreId ?? ""
        cartOrder.order_details = currentBooking.cart
        
        var totalPrice:Double = 0.0
        var totalTax:Double = 0.0
        for cartProduct in currentBooking.cart {
            totalTax = totalTax + cartProduct.totalItemTax
            totalPrice = totalPrice + (cartProduct.total_item_price ?? 0.0)
            
        }
        cartOrder.totalCartPrice =  totalPrice
        cartOrder.totalItemTax = totalTax
        
        if (currentBooking.destinationAddress.isEmpty || currentBooking.destinationAddress[0].address != currentBooking.deliveryAddress ) {
            
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
        if currentBooking.pickupAddress.isEmpty && (currentBooking.selectedStore != nil) {
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
            cartStoreDetail.imageUrl = mySelectedStore.image_url
            pickupAddress.userDetails = cartStoreDetail
            currentBooking.pickupAddress = [pickupAddress]
        }

        cartOrder.pickupAddress = currentBooking.pickupAddress
        cartOrder.destinationAddress = currentBooking.destinationAddress
        if Utility.isTableBooking() || currentBooking.isQrCodeScanBooking {
            cartOrder.table_no = currentBooking.table_no
            cartOrder.booking_type = currentBooking.bookingType
            cartOrder.delivery_type = DeliveryType.tableBooking
            currentBooking.deliveryType = DeliveryType.tableBooking
            cartOrder.no_of_persons = currentBooking.number_of_pepole
            cartOrder.order_start_at = currentBooking.futureDateMilliSecondTable
            cartOrder.order_start_at2 = currentBooking.futureDateMilliSecondTable2
            cartOrder.table_id = currentBooking.tableID
        }

        let dictData:NSDictionary = (cartOrder.dictionaryRepresentation())
        dictData.setValue(currentBooking.isUseItemTax, forKey: PARAMS.IS_USE_ITEM_TAX)
        dictData.setValue(currentBooking.isTaxIncluded, forKey: PARAMS.IS_TAX_INCLUDED)
        dictData.setValue(currentBooking.totalCartAmountWithoutTax, forKey: PARAMS.TOTAL_CART_AMOUNT_WITHOUT_TAX)

        print(Utility.convertDictToJson(dict: dictData as! Dictionary<String, Any>))

        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_ADD_ITEM_IN_CART, methodName: AlamofireHelper.POST_METHOD, paramData: dictData as? Dictionary<String, Any>) { (response,error) -> (Void) in
            if (Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true)) {
                print(Utility.convertDictToJson(dict: response as! Dictionary<String, Any>))
                currentBooking.cartCurrency = self.selectedProductItem?.currency ?? ""
                currentBooking.cartId = (response.value(forKey: PARAMS.CART_ID) as? String) ?? ""
                currentBooking.cartCityId = (response.value(forKey: PARAMS.CITY_ID)as? String) ?? ""
                currentBooking.storeLatLng = currentBooking.selectedStore?.location ?? [0.0,0.0]
                self.onClickBtnBack(self.btnBack)
                self.delegateRefreshCartBadge?.refreshCartBadge()
                self.wsGetCart()
            } else {
                if response["error_code"] != nil{
                    if response["error_code"] as! Int == 968{
                        self.openClearCartDialogForChangeSetting()
                    }
                } else {
                    self.wsGetCart()
                }
            }
            Utility.hideLoading()
        }
    }

    func wsClearCart() {
        var dictParam: [String:Any] = APPDELEGATE.getCommonDictionary()
        dictParam[PARAMS.CART_ID] = currentBooking.cartId

        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_CLEAR_CART, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response,error) -> (Void) in
            Utility.hideLoading()
            currentBooking.clearCart()
            currentBooking.clearTableBooking()
            self.addToCart()
        }
    }

    func wsGetCart() {
        let dictParam: [String:Any] = APPDELEGATE.getCommonDictionary()

        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_GET_CART, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Utility.hideLoading()
            currentBooking.clearCart()
            if Parser.parseCart(response) {
                self.onClickBtnBack(self.btnBack)
            } else {
                self.setItemCountInBasket()
            }
        }
    }
}

class ProductSpecificationSection: CustomTableCell {
    
    //MARK:- OUTLET
    @IBOutlet weak var lblSpecificationName: UILabel!
    @IBOutlet weak var lblSpecificationRequired: UILabel!
    @IBOutlet weak var lblSelectionMessage: UILabel!
    
    var isMultipleSelect:Bool = false
    //MARK:- LIFECYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        lblSpecificationRequired.font = FontHelper.labelRegular()
        lblSpecificationName.font = FontHelper.textMedium(size: FontHelper.mediumLarge)
        lblSpecificationRequired.textColor = UIColor.themeRedBGColor
        lblSpecificationRequired.font = FontHelper.textMedium(size: FontHelper.large)
        lblSelectionMessage.textColor = UIColor.themeLightTextColor
        lblSelectionMessage.font = FontHelper.textRegular()
        lblSpecificationName.textColor = UIColor.themeTitleColor
        lblSpecificationName.font = FontHelper.textMedium(size: FontHelper.mediumLarge)
        
    }
    
    //MARK:- SET CELL DATA
    func setData(title:String, isAllowMultipleSelect:Bool, isRequired:Bool,message:String)
    {
        lblSpecificationRequired.text = "TXT_REQUIRED".localized
        lblSpecificationRequired.isHidden = !isRequired
        lblSpecificationName.text = title.appending("")
        lblSpecificationName.sizeToFit()
        lblSpecificationName.textColor = UIColor.themeTitleColor
        lblSpecificationName.backgroundColor = UIColor.clear
        lblSpecificationName.font = FontHelper.textMedium(size: FontHelper.mediumLarge)
        self.backgroundColor = UIColor.clear
        isMultipleSelect = isAllowMultipleSelect
        if message.isEmpty() {
            lblSelectionMessage.text = ""
            lblSelectionMessage.isHidden = true
        }else {
            lblSelectionMessage.text = message
            lblSelectionMessage.isHidden = false
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension ProductSpecificationVC: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    //MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedProductItem?.image_url?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollection", for: indexPath) as! CustomCollection
        print(Utility.getDynamicResizeImageURL(width: cell.imgProductItem.frame.width, height: cell.imgProductItem.frame.height, imgUrl: (selectedProductItem?.image_url?[indexPath.row])!))
        if collectionForItems == collectionView {
            cell.imgProductItem.downloadedFrom(link: Utility.getDynamicResizeImageURL(width: cell.imgProductItem.frame.width, height: cell.imgProductItem.frame.height, imgUrl: (selectedProductItem?.image_url?[indexPath.row])!), isFromResize: true) { isLoad in
                if isLoad {
                    print(cell.imgProductItem.image!.getAspectRation())
                }
            }
        }else {
            cell.imgProductItem.downloadedFrom(link: Utility.getDynamicResizeImageURL(width: cell.imgProductItem.frame.width, height: cell.imgProductItem.frame.height, imgUrl: (selectedProductItem?.image_url?[indexPath.row])!), isFromResize: true) { isLoad in
                if isLoad {
                    print(cell.imgProductItem.image!.getAspectRation())
                }
            }
        }
        return cell
    }
    
    //MARK: UICollectionViewDelegateFlowLayout
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionForItemImages.collectionViewLayout.invalidateLayout()
        setupLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: false)
        collectionForItemImages.reloadData()
        dialogForProductItemImages.isHidden = false
        collectionForItemImages.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        collectionForItems.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        pgControlforDialog.currentPage = pgControl.currentPage
        pgControl.currentPage = pgControl.currentPage
        self.view.bringSubviewToFront(dialogForProductItemImages)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionForItemImages {
            return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
}

extension ProductSpecificationVC: SpecificationCellDelegae {
    func specificationButtonAction(cell: ProductSpecificationCell, sender: UIButton) {
        if let indexPath = tblForProductSpecification.indexPath(for: cell) {
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
            setTotalAmount(total)
            tblForProductSpecification.reloadData()
        }
    }
}
