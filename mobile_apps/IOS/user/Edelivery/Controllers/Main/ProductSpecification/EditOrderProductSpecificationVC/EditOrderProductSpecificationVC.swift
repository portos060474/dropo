//
//  EditOrderProductSpecificationVC.swift
//  Edelivery
//
//  Created by Trusha on 25/05/20.
//  Copyright © 2020 Elluminati. All rights reserved.
//

import UIKit
                
class EditOrderProductSpecificationVC: BaseVC, UIViewControllerTransitioningDelegate, UINavigationBarDelegate, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate, LeftDelegate {
    
    weak var timerForItem: Timer? = nil
    
    var  statusbarHeight:CGFloat = 20.0
    //MARK:- OUTLETS
    var FromOrderPrepare : Bool = false
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
    @IBOutlet weak var txtNoteForItem: UITextField!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var lblNote: UILabel!
    //MARK:- Variables
    var quantity = 1
    var total = 0.00
    var arrSpecificationList = [Specifications]()
    var arrSpecificationListMain = [Specifications]()
    var arrSpecificationFromProductVC = [Specifications]()
    var arrSpecificationItemList:Array<SpecificationListItem>? = nil
    var specificationItemListLength:Int? = 0
    var specificationListLength:Int? = 0
    var selectedProductItem:ProductItemsItem? = nil
    
    var productName:String? = nil
    var productUniqueId:Int? = 0
    var selectedStore:StoreItem?

    
    //    var productName:String? = nil
    //    var productUniqueId:Int? = 0
    var currentItemIndex:Int = 0
    var newImage: UIImage!
    var requiredCount:Int = 0
    var cartButton:MyBadgeButton? = nil
    //    var selectedIndexPath:IndexPath = IndexPath.init(row: -1, section: -1)
    var languageCode : String = "en"
    var languageCodeInd : String = "1"
    var selectInd : Int = -1
    var selectSection : Int = -1
    var isFromUpdateOrder:Bool = false
    
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
        if selectedProductItem!.specifications!.count > 0{
            self.arrSpecificationFromProductVC.append(contentsOf: selectedProductItem!.specifications!)
        }
        
        self.setNavigationTitle(title: selectedProductItem?.name ?? "")
        delegateLeft = self
        self.setBackBarItem(isNative:false)
        cartButton = MyBadgeButton.init(frame: CGRect.init(x: 0, y: 0, width: 32, height: 32))
        cartButton?.setImage(UIImage.init(named: "cart"), for: .normal)
        cartButton?.badgeString = "0"
        cartButton?.badgeTextColor = UIColor.themeButtonTitleColor
        cartButton?.badgeBackgroundColor = UIColor.themeSectionBackgroundColor
        cartButton?.addTarget(self, action: #selector(ProductVC.onClickBtnCart(_:)), for: .touchUpInside)
        // let rightButton:UIBarButtonItem = UIBarButtonItem.init(customView: cartButton!)
        //  self.navigationItem.setRightBarButton(rightButton, animated: false)
        
        self.tblForProductSpecification.delegate = self
        self.tblForProductSpecification.dataSource = self
        self.tblForProductSpecification.estimatedRowHeight = 40
        self.tblForProductSpecification.estimatedSectionHeaderHeight = 20
        self.tblForProductSpecification.rowHeight = UITableView.automaticDimension
        self.tblForProductSpecification.sectionHeaderHeight = UITableView.automaticDimension
        
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapOnAddToCart(gestureRecognizer:)))
        gestureRecognizer.delegate = self
        viewForAddToCart.addGestureRecognizer(gestureRecognizer)
        //        calculateTotalAmount()
        //        setTotalAmount(total)
        viewForNavigation.backgroundColor = UIColor.clear
        
        self.tblForProductSpecification.register(cellTypes: [ProductSpecificationCell.self,ProductSpecificationSection.self])
        self.collectionForItemImages.register(cellType: CustomCollection.self)
        self.collectionForItems.register(cellType: CustomCollection.self)
        self.tblForProductSpecification.reloadData()
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayout()
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
        wsGetUserSpecificationList()
        //        setItemCountInBasket()
        //setupTimer()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sizeHeaderToFit()
        tblForProductSpecification.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
        timerForItem?.invalidate()
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
        collectionForItems.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        collectionForItemImages.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func setLocalization(){
        
        lblGradient.text = ""
        txtNoteForItem.placeholder = "TXT_NOTE".localizedCapitalized
        
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        viewForQuantity.backgroundColor = UIColor.themeViewBackgroundColor
        lblCartQuantity.backgroundColor = UIColor.themeSectionBackgroundColor
        lblCartQuantity.textColor = UIColor.themeButtonTitleColor
        viewForHeader.backgroundColor = UIColor.themeViewBackgroundColor
        viewForProduct.backgroundColor = UIColor.themeViewBackgroundColor
        tblForProductSpecification.backgroundColor = UIColor.themeViewBackgroundColor
        viewForFooter.backgroundColor = UIColor.themeViewBackgroundColor
        viewForQuantity.backgroundColor = UIColor.themeViewBackgroundColor
        tblForProductSpecification.tableFooterView?.backgroundColor = UIColor.themeViewBackgroundColor
        lblProductDetail.textColor = UIColor.themeLightTextColor
        lblDescription.textColor = UIColor.themeTextColor
        txtNoteForItem.textColor = UIColor.themeTextColor
        
        lblTotal.textColor = UIColor.themeButtonTitleColor
        viewForAddToCart.backgroundColor = UIColor.themeButtonBackgroundColor
        btnAddcart.setTitleColor(UIColor.themeButtonTitleColor, for:UIControl.State.normal)
        pgControl.currentPageIndicatorTintColor = UIColor.black
        pgControl.pageIndicatorTintColor = UIColor.gray
        pgControlforDialog.currentPageIndicatorTintColor = UIColor.black
        pgControlforDialog.pageIndicatorTintColor = UIColor.gray
        
        /* Set Font */
        lblCartQuantity.font = FontHelper.cartText()
        lblProductDetail.font = FontHelper.labelRegular()
        lblDescription.font = FontHelper.textMedium()
        lblProductName.font = FontHelper.textLarge()
        lblTotal.font = FontHelper.buttonText()
        btnAddcart.titleLabel?.font = FontHelper.buttonText()
        if FromOrderPrepare {
            btnAddcart.setTitle("TXT_UPDATE_ORDER".localizedCapitalized, for: UIControl.State.normal)
        }
        else {
            btnAddcart.setTitle("TXT_ADD_TO_CART".localizedCapitalized, for: UIControl.State.normal)
        }
        
        self.hideBackButtonTitle()
        
        btnPlus.setTitleColor(UIColor.themeColor, for: .normal)
        btnMinus.setTitleColor(UIColor.themeColor, for: .normal)
        lblNote.textColor = UIColor.themeLightTextColor
        
        btnPlus.layer.borderColor = UIColor.themeColor.cgColor
        btnMinus.layer.borderColor = UIColor.themeColor.cgColor
        btnPlus.layer.borderWidth = 1
        btnMinus.layer.borderWidth = 1
        viewForQuantity.layer.borderWidth = 1
        viewForQuantity.layer.borderColor = UIColor.themeColor.cgColor
        
        lblNote.text = "TXT_NOTE_TEXT".localized
        lblNote.textColor = UIColor.themeLightTextColor
        lblNote.font = FontHelper.textRegular()
    }
    
    func setupLayout() {
        lblGradient.setGradient(startColor:UIColor.themeEndGradientColor,endColor:UIColor.themeStartGradientColor)
        viewForNavigation.setGradient(startColor: UIColor.themeStartGradientColor, endColor: UIColor.themeEndGradientColor)
        lblDialogGradient.setGradient(startColor:UIColor.themeEndGradientColor,endColor:UIColor.themeStartGradientColor)
        viewForQuantity.applyRoundedCornersWithHeight()
        viewForAddToCart.applyRoundedCornersWithHeight()
        lblCartQuantity.setRound()
        lblProductDetail.sizeToFit()
        viewForHeader.sizeToFit()
        viewForHeader.autoresizingMask = UIView.AutoresizingMask()
        dialogForProductItemImages.frame = UIScreen.main.bounds
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
        
        sectionHeader.setData(title: arrSpecificationList[section].name!, isAllowMultipleSelect: Bool((arrSpecificationList[section].type! as NSNumber)), isRequired: arrSpecificationList[section].is_required!,message: arrSpecificationList[section].selectionMessage)
        return sectionHeader
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
        
        productSpecificationCell.setCellData(cellItem: currentProductItem, isAllowMultipleSelect: sectionType,currency: selectedProductItem?.currency ?? "" ,arrSpecificationFromProductVC: self.arrSpecificationList[indexPath.section].list![indexPath.row],isFromCart: false)
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
        
        DispatchQueue.main.async {
            self.tblForProductSpecification.reloadData()
        }
        
        calculateTotalAmount()
        setTotalAmount(total)
    }
    
    //MARK:- Range Selection Validation
    func isValidSelection(range:Int,maxRange:Int,selectedCount: Int,isDefaultSelected:Bool) -> Bool {
        
        if (range == 0 && maxRange ==
                0)
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
    
    //MARK: Action Method
    func onClickLeftButton() {
        self.onClickBtnBack(btnBack)
    }
    
    @IBAction func onClickBtnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickBtnCart(_ sender: Any) {
        if let navigationVC = self.navigationController {
            for controller in navigationVC.viewControllers {
                if controller.isKind(of: CartVC.self) {
                    self.navigationController?.popToViewController(controller, animated: true)
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
        self.addToCart()
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
    
    //MARK: User Define Functions
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
        txtNoteForItem.text = productdata.instruction
        if productdata.image_url?.count ?? 0 > 0 {
            collectionForItems.isHidden = false
        } else {
            collectionForItems.isHidden = true
        }
    }
    
    func addToCart() {
        
        
        var arrCurrentAdded = [CartProductItems]()
        if OrderBeingPrepared.selectedOrder.cartDetail!.orderDetails.count > 0 {
            for obj in OrderBeingPrepared.selectedOrder.cartDetail!.orderDetails {
                for item in (obj.items ?? []) {
                    arrCurrentAdded.append(item)
                }
            }
        }
        
        var specificationPriceTotal = 0.0
        var specificationPrice = 0.0
        var specificationList:[Specifications] = [Specifications].init()
        
        //Utility.showLoading()
        for specificationListItem in arrSpecificationList {
            var specificationItemCartList:[SpecificationListItem] = [SpecificationListItem].init()
            
            for listItem in specificationListItem.list! {
                if (listItem.is_default_selected) {
                    specificationPrice = specificationPrice + listItem.price!
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
        
        cartProductItems.noteForItem = txtNoteForItem.text ?? ""
        cartProductItems.totalPrice = currentSelectedProductItem.price + specificationPriceTotal
        cartProductItems.taxDetails = currentSelectedProductItem.taxDetails

        var tax = 0.0
        
        if !selectedStore!.isUseItemTax{
            for obj in selectedStore!.storeTaxDetails{
                tax = tax + Double(obj.tax)
            }
        }else{
            for obj in currentSelectedProductItem.taxDetails{
                tax = tax + Double(obj.tax)
            }
        }
        
        let itemTax = getTax(itemAmount: currentSelectedProductItem.price, taxValue: tax)
        let specificationTax = getTax(itemAmount: specificationPriceTotal, taxValue: tax)
        let totalTax = itemTax + specificationTax
        
        cartProductItems.tax = tax
        cartProductItems.itemTax = itemTax
        cartProductItems.totalSpecificationTax = specificationTax
        cartProductItems.totalTax = totalTax
        cartProductItems.totalItemTax =   totalTax * Double(quantity)
                
        let isAdded = arrCurrentAdded.filter({$0.getProductJson().isEqual(to: cartProductItems.getProductJson() as! [AnyHashable : Any])})
                
        if isAdded.count > 0 {
            var section = 0
            var row = 0
            for obj in OrderBeingPrepared.selectedOrder.cartDetail!.orderDetails {
                for item in (obj.items ?? []) {
                    if isAdded[0].getProductJson().isEqual(to: item.getProductJson() as! [AnyHashable : Any]) {
                        section = OrderBeingPrepared.selectedOrder.cartDetail!.orderDetails.firstIndex(where: {$0.getProductJson().isEqual(to: obj.getProductJson() as! [AnyHashable : Any])}) ?? 0
                        row = (obj.items ?? []).firstIndex(where: {$0.getProductJson().isEqual(to: item.getProductJson() as! [AnyHashable : Any])}) ?? 0
                        break
                    }
                }
            }
            
            OrderBeingPrepared.selectedOrder.cartDetail!.orderDetails[section].items![row] = cartProductItems
            OrderBeingPrepared.selectedOrder.cartDetail!.orderDetails[section].items![row].quantity = isAdded[0].quantity + self.quantity
            OrderBeingPrepared.selectedOrder.cartDetail!.orderDetails[section].items![row].totalItemTax = totalTax * Double(quantity) * Double((isAdded[0].quantity + self.quantity))
        }else{
            if OrderBeingPrepared.selectedOrder.cartDetail != nil{
                
                var cartProductItemsList:[CartProductItems] = [CartProductItems].init()
                cartProductItemsList.append(cartProductItems)
                let cartProducts:CartProduct = CartProduct.init()
                cartProducts.items = cartProductItemsList
                cartProducts.product_id = currentSelectedProductItem.product_id
                cartProducts.product_name = productName
                cartProducts.unique_id = productUniqueId
                cartProducts.total_item_price = total

                cartProducts.totalItemTax =  cartProductItems.totalItemTax
                OrderBeingPrepared.selectedOrder.cartDetail!.orderDetails.append(cartProducts)
                
                /*
                if isProductExistInOrder(currentOrderItem: currentSelectedProductItem,cartProductItems: cartProductItems){
                    //                    OrderBeingPrepared.selectedOrder.cartDetail!.orderDetails[0].items?.append(contentsOf: [cartProductItems])
                }else{
                    
                }*/
            }
            
        }
        
        self.navigationController?.popViewController(animated: true)
        for VC in self.navigationController?.viewControllers ?? [] {
            if VC is OrderBeingPrepared {
                (VC as! OrderBeingPrepared).updateData()
            }
        }
    }
    
    func isProductExistInOrder(currentOrderItem:ProductItemsItem,cartProductItems:CartProductItems) -> Bool {
        if (OrderBeingPrepared.selectedOrder.cartDetail?.orderDetails.count)! > 0{
            for i in 0...OrderBeingPrepared.selectedOrder.cartDetail!.orderDetails.count-1 {
                if OrderBeingPrepared.selectedOrder.cartDetail!.orderDetails[i].product_id == (currentOrderItem.product_id)! {
                    OrderBeingPrepared.selectedOrder.cartDetail!.orderDetails[i].items?.append(contentsOf: [cartProductItems])
                    return true;
                }
            }
        }
        return false;
    }
    
    
//    func getTax(itemAmount:Double, taxValue:Double) -> Double {
//        return itemAmount * taxValue * 0.01
//    }
    func getTax(itemAmount:Double, taxValue:Double) -> Double {
//        return itemAmount * taxValue * 0.01
        if !selectedStore!.isTaxInlcuded{
            return itemAmount * taxValue * 0.01
        }else{
            return (itemAmount - (100*itemAmount)/(100+taxValue))
        }
    }
    
    
    func calculateTotalAmount() {
        total = Double((selectedProductItem?.price)!)
        var requiredCountTemp = 0
        for currentProduct in arrSpecificationList {
            for currentProductItem in currentProduct.list! {
                if currentProductItem.is_default_selected {
                    total = total + Double(currentProductItem.price!) * Double(currentProductItem.quantity)
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
            viewForAddToCart.backgroundColor = UIColor.lightGray
        }
    }
    
    func setIsRequired() {
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
                collectionForItems.scrollToItem(at: ip, at: .centeredHorizontally, animated: false)
                self.pgControl.currentPage = ip.row
                collectionForItemImages.scrollToItem(at: ip, at: .centeredHorizontally, animated: false)
                self.pgControlforDialog.currentPage = ip.row
            }
        }else {
            if let ip = collectionForItemImages.indexPathForItem(at: center) {
                collectionForItemImages.scrollToItem(at: ip, at: .centeredHorizontally, animated: false)
                self.pgControlforDialog.currentPage = ip.row
                collectionForItems.scrollToItem(at: ip, at: .centeredHorizontally, animated: false)
                self.pgControl.currentPage = ip.row
            }
        }
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
        
        afn.getResponseFromURL(url: WebService.WS_GET_USER_SPECIFICATION_LIST, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            
            Utility.hideLoading()
            
            print(response)
            let arr: Array<Specifications> = Parser.parseSpecifications(response)
            if arr.count > 0{
                self.arrSpecificationListMain = arr
            }
            print(self.arrSpecificationListMain)
            
            DispatchQueue.main.async {
                
                print(self.isFromUpdateOrder)

                //Changed
                if self.arrSpecificationListMain.count > 0 && self.arrSpecificationFromProductVC.count > 0{
                    for i in 0...self.arrSpecificationFromProductVC.count - 1{
                        if self.arrSpecificationFromProductVC[i].list!.count == self.arrSpecificationListMain[i].list!.count{
                            if self.arrSpecificationFromProductVC[i].list!.count > 0 {
                                for j in 0...self.arrSpecificationFromProductVC[i].list!.count-1{
                                    self.arrSpecificationListMain[i].list![j].is_default_selected = false
                                    if self.arrSpecificationListMain[i].list![j].unique_id == self.arrSpecificationFromProductVC[i].list![j].unique_id{
                                        if self.isFromUpdateOrder{
                                            self.arrSpecificationListMain[i].list![j].is_default_selected
                                                = self.arrSpecificationFromProductVC[i].list![j].is_default_selected
                                            self.arrSpecificationListMain[i].list![j].quantity
                                                = self.arrSpecificationFromProductVC[i].list![j].quantity
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
                self.setIsRequired()
                self.setLocalization()
                
                self.calculateTotalAmount()
                self.setTotalAmount(self.total)
                self.tblForProductSpecification.reloadData()
            }
        }
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
    }
}


extension EditOrderProductSpecificationVC: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    //MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedProductItem?.image_url?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollection", for: indexPath) as! CustomCollection
        
        
        if collectionForItems == collectionView {
//            cell.imgProductItem.downloadedFrom(link: (selectedProductItem?.image_url?[indexPath.row])!,mode:UIView.ContentMode.scaleAspectFill)
            
            cell.imgProductItem.downloadedFrom(link: Utility.getDynamicResizeImageURL(width: cell.imgProductItem.frame.width, height: cell.imgProductItem.frame.height, imgUrl: (selectedProductItem?.image_url?[indexPath.row])!),isFromResize: true)
            
        }else {
//            cell.imgProductItem.downloadedFrom(link: (selectedProductItem?.image_url?[indexPath.row])!,mode:UIView.ContentMode.scaleAspectFit)
            
            cell.imgProductItem.downloadedFrom(link: Utility.getDynamicResizeImageURL(width: cell.imgProductItem.frame.width, height: cell.imgProductItem.frame.height, imgUrl: (selectedProductItem?.image_url?[indexPath.row])!),isFromResize: true)
            
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

extension EditOrderProductSpecificationVC: SpecificationCellDelegae {
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
