//
//  ProductVC.swift
// Edelivery Store
//
//  Created by Jaydeep Vyas on 09/03/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class OrderProductSpecificationVC: BaseVC,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate,LeftDelegate,UIScrollViewDelegate {
    
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var topImageConstraints: NSLayoutConstraint!
    @IBOutlet weak var pgControlforDialog: UIPageControl!
    @IBOutlet weak var lblDialogGradient: UILabel!
    @IBOutlet weak var collectionForItems: UICollectionView!
    @IBOutlet var dialogForProductItemImages: UIView!
    //    @IBOutlet weak var lblGradient: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    //    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblCartQuantity: UILabel!
    
    @IBOutlet weak var pgControl: UIPageControl!
    @IBOutlet weak var collectionForItemImages: UICollectionView!
    @IBOutlet var lblProductName: UILabel!
    //    @IBOutlet var viewForProduct: UIView!
    @IBOutlet var lblProductDetail: UILabel!
    @IBOutlet weak var tblForProductSpecification: UITableView!
    @IBOutlet weak var viewForHeader: UIView!
    @IBOutlet weak var viewForNavigation: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewForAddToCart: UIView!
    @IBOutlet weak var btnAddcart: UIButton!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var viewForFooter: UIView!
    @IBOutlet weak var btnCart: UIButton!
    @IBOutlet weak var viewForQuantity: UIView!
    @IBOutlet weak var lblQuantitySep1: UILabel!
    @IBOutlet weak var lblQuantitySep2: UILabel!
    @IBOutlet weak var btnQuantityAdd: UIButton!
    @IBOutlet weak var btnQuantityMinus: UIButton!

    
    var quantity = 1;
    var total = 0.0;
    var arrSpecificationList = [ItemSpecification]()
    var arrSpecificationListMain = [ItemSpecification]()
    var specificationItemListLength:Int? = 0;
    var specificationListLength:Int? = 0;
    var selectedProductItem:Item? = nil;
    var productName:String? = nil;
    var productUniqueId:Int? = 0;
    var cartButton:MyBadgeButton? = nil
    
    //MARK:- Variables
    var newImage: UIImage!
    var requiredCount:Int = 0;
    //MARK:- View Life Cycle
    override func viewDidLoad(){
        super.viewDidLoad()
        lblQuantity.text = String(quantity)
        
        arrSpecificationListMain = selectedProductItem?.specifications ?? []
        specificationListLength = arrSpecificationList.count
        viewForNavigation.backgroundColor = UIColor.themeTransparentNavigationBackgroundColor
        self.title = ""
        setLocalization()
        reArrageArrayWithAssociateSP(arr: arrSpecificationListMain)
        //        topImageConstraints.constant = -UIApplication.shared.statusBarFrame.height
        
        self.setNavigationTitle(title: selectedProductItem?.name ?? "")
        delegateLeft = self
        self.setBackBarItem(isNative:false)
        cartButton = MyBadgeButton.init(frame: CGRect.init(x: 0, y: 0, width: 64, height: 64))
        cartButton?.setImage(UIImage.init(named: "cartIcon"), for: .normal)
        cartButton?.badgeString = "0"
        cartButton?.badgeTextColor = UIColor.themeButtonTitleColor
        cartButton?.badgeBackgroundColor = UIColor.themeColor
        cartButton?.badgeEdgeInsets = UIEdgeInsets.init(top: 10, left: 0, bottom: 0, right: 15)
        
        cartButton?.addTarget(self, action: #selector(OrderProductSpecificationVC.onClickCart(_:)), for: .touchUpInside)
        let rightButton:UIBarButtonItem = UIBarButtonItem.init(customView: cartButton!)
        self.navigationItem.setRightBarButton(rightButton, animated: false)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapOnAddToCart(gestureRecognizer:)))
        gestureRecognizer.delegate = self
        viewForAddToCart.addGestureRecognizer(gestureRecognizer)
        setProductData(productdata: selectedProductItem!)
        
    }
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        setupLayout()
        if tblForProductSpecification != nil{
            tblForProductSpecification.layoutTableHeaderView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        setItemCountInBasket()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewForFooter.frame.size.height = 60
        tblForProductSpecification.tableFooterView = viewForFooter
        
        //       sizeHeaderToFit()
        
    }
    func sizeHeaderToFit() {
        if let headerView = tblForProductSpecification.tableHeaderView {
            headerView.setNeedsLayout()
            headerView.layoutIfNeeded()
            viewForFooter.layoutIfNeeded()
            viewForFooter.frame.size.height = 60
            let height = lblProductDetail.frame.origin.y + lblProductDetail.frame.height + 10
            var frame = headerView.frame
            frame.size.height = height
            headerView.frame = frame
            
            tblForProductSpecification.tableHeaderView = headerView
            tblForProductSpecification.tableFooterView = viewForFooter
            tblForProductSpecification.reloadData()
        }
        
    }
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    
    func setLocalization(){
        
        //        lblGradient.text = ""
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        viewForQuantity.backgroundColor = UIColor.themeViewBackgroundColor
        lblCartQuantity.backgroundColor = UIColor.themeColor
        lblCartQuantity.textColor = UIColor.themeButtonTitleColor
        viewForHeader.backgroundColor = UIColor.themeViewBackgroundColor
        //       viewForProduct.backgroundColor = UIColor.themeAlertViewBackgroundColor
        tblForProductSpecification.backgroundColor = UIColor.themeViewBackgroundColor
        viewForFooter.backgroundColor = UIColor.themeViewBackgroundColor
        viewForQuantity.backgroundColor = UIColor.themeViewBackgroundColor
        tblForProductSpecification.tableFooterView?.backgroundColor = UIColor.themeViewBackgroundColor
        lblProductDetail.textColor = UIColor.themeLightTextColor
        lblProductName.textColor = UIColor.themeTextColor
        
        //        lblDescription.textColor = UIColor.themeTextColor
        
        
        lblTotal.textColor = UIColor.themeButtonTitleColor
        viewForAddToCart.backgroundColor = UIColor.themeColor
        btnAddcart.setTitleColor(UIColor.themeButtonTitleColor, for:UIControl.State.normal);
        lblTitle.textColor = UIColor.themeTitleColor
        pgControl.currentPageIndicatorTintColor = UIColor.themeTextColor
        pgControl.pageIndicatorTintColor = UIColor.themeLightTextColor
        pgControlforDialog.currentPageIndicatorTintColor = UIColor.themeTextColor
        pgControlforDialog.pageIndicatorTintColor = UIColor.themeLightTextColor
        
        
        pgControl.isUserInteractionEnabled = false
        pgControlforDialog.isUserInteractionEnabled = false
        /* Set Font */
        
        lblCartQuantity.font  = FontHelper.cartText()
        lblProductDetail.font = FontHelper.labelRegular()
        //        lblDescription.font = FontHelper.textMedium()
        lblProductName.font = FontHelper.textLarge()
        lblTotal.font = FontHelper.buttonText()
        btnAddcart.titleLabel?.font = FontHelper.buttonText()
        lblTitle.font = FontHelper.textRegular()
        btnQuantityAdd.setTitleColor(.themeColor, for: .normal)
        btnQuantityMinus.setTitleColor(.themeColor, for: .normal)
        lblQuantity.textColor = .themeColor
        
        viewForAddToCart.setRound(withBorderColor: .clear, andCornerRadious: viewForAddToCart.frame.height/2, borderWidth: 1.0)
        self.tblForProductSpecification.sectionHeaderHeight = UITableView.automaticDimension;
        self.tblForProductSpecification.estimatedSectionHeaderHeight = 25;
        
    }
    
    func setupLayout(){
        if viewForQuantity != nil{
            //        lblGradient.setGradient(startColor:UIColor.themeEndGradientColor,endColor:UIColor.themeStartGradientColor)
            lblDialogGradient.setGradient(startColor:UIColor.themeEndGradientColor,endColor:UIColor.themeStartGradientColor)
            //        viewForProduct.layer.cornerRadius = 3;
            //        viewForProduct.setShadow(shadowColor: UIColor.black.cgColor, shadowOffset: CGSize(width: -1, height: 1), shadowOpacity: 0.5, shadowRadius: 5)
            
            viewForQuantity.layer.cornerRadius = viewForQuantity.frame.size.height/2;
            viewForQuantity.layer.borderWidth = 1
            viewForQuantity.layer.borderColor = UIColor.themeColor.cgColor
            lblQuantitySep1.backgroundColor = .themeColor
            lblQuantitySep2.backgroundColor = .themeColor
            
            lblCartQuantity.setRound()
            //        lblProductDetail.sizeToFit()
        }
    }
    
    func reArrageArrayWithAssociateSP(arr: [ItemSpecification]) {
        arrSpecificationList.removeAll()
        
        var arrReArrage = [ItemSpecification]()
        arrReArrage = arr.filter({!$0.isAssociated})
        
        for obj in arrReArrage {
            self.arrSpecificationList.append(obj)
        }
        
        let arrId = arrSpecificationList.map({$0.id})
        var arrSelected = [List]()
        
        for obj in arrSpecificationList {
            for objList in (obj.list ?? []) {
                if objList.isDefaultSelected {
                    arrSelected.append(objList)
                }
            }
        }
        
        for objMain in arrSpecificationListMain {
            for obj in arrSelected {
                if objMain.modifierId == obj.id && !arrId.contains(objMain.id) {
                    arrSpecificationList.append(objMain)
                } else if objMain.modifierId == obj.id && arrId.contains(objMain.id){
                    if let index = arrSpecificationList.firstIndex(where: {$0.id == objMain.id}) {
                        arrSpecificationList.remove(at: index)
                        arrSpecificationList.insert(objMain, at: index)
                    }
                }
            }
        }
        
        setIsRequired()
        calculateTotalAmount()
        setTotalAmount(total)
    }
    
    override func updateUIAccordingToTheme() {
        setBackBarItem(isNative: false)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    //MARK: TABLEVIEW DELEGATE METHODS
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension;
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrSpecificationList.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return arrSpecificationList[section].name
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = tableView.dequeueReusableCell(withIdentifier: "cellForSection")! as! OrderProductSpecificationSection
        
        sectionHeader.setData(title: arrSpecificationList[section].name!, isAllowMultipleSelect: Bool((arrSpecificationList[section].type! as NSNumber)), isRequired: arrSpecificationList[section].isRequired!,message: arrSpecificationList[section].selectionMessage)
        return sectionHeader
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        specificationItemListLength = arrSpecificationList[section].list?.count ?? 0;
        return specificationItemListLength!;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionType = arrSpecificationList[indexPath.section].type!
        let productSpecificationCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OrderProductSpecificationCell
        let currentProduct:ItemSpecification = arrSpecificationList[indexPath.section]
        let currentProductItem:List = currentProduct.list![indexPath.row]
        productSpecificationCell.delegate = self
        productSpecificationCell.setCellData(cellItem: currentProductItem, isAllowMultipleSelect: sectionType)
        if !arrSpecificationList[indexPath.section].user_can_add_specification_quantity {
            productSpecificationCell.viewQty.isHidden = true
        }
        return productSpecificationCell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let currentSpecificationGroup = (arrSpecificationList[indexPath.section])
        if let specificationSubItem:List = currentSpecificationGroup.list?[indexPath.row] {
            let sectionType = currentSpecificationGroup.type
            if sectionType == 2 {
                let checked  = isValidSelection(range: currentSpecificationGroup.range, maxRange: currentSpecificationGroup.rangeMax, selectedCount: currentSpecificationGroup.selectedCount, isDefaultSelected: specificationSubItem.isDefaultSelected)
                if checked &&  !specificationSubItem.isDefaultSelected {
                    currentSpecificationGroup.selectedCount += 1
                }
                else if !checked  && specificationSubItem.isDefaultSelected {
                    currentSpecificationGroup.selectedCount -= 1
                }
                specificationSubItem.isDefaultSelected = checked
            }else {
                for objMain in self.arrSpecificationListMain {
                    if objMain.id == currentSpecificationGroup.id {
                        objMain.selectedCount = 1
                        for objList in (objMain.list ?? []) {
                            if objList.id == specificationSubItem.id {
                                objList.isDefaultSelected = true
                            } else {
                                objList.isDefaultSelected = false
                            }
                        }
                    }
                }
                self.reArrageArrayWithAssociateSP(arr: self.arrSpecificationListMain)
            }
        }
        calculateTotalAmount()
        tableView.reloadData()
        setTotalAmount(total)
    }
    
    func calculateTotalAmount() {
        total = Double((selectedProductItem?.price)!)
        var requiredCountTemp = 0
        for currentProduct in arrSpecificationList {
            for currentProductItem in currentProduct.list! {
                if currentProductItem.isDefaultSelected {
                    total = total + Double(currentProductItem.price!) * Double(currentProductItem.quantity)
                }
                
            }
            if ( (currentProduct.isRequired)
                    && (currentProduct.selectedCount >= currentProduct.range)
                    && (currentProduct.rangeMax == 0  || currentProduct.selectedCount <= currentProduct
                            .rangeMax)
                    && currentProduct.selectedCount != 0) {
                requiredCountTemp += 1;
            }
        }
        total = total * Double(quantity)
        
        if (requiredCountTemp == requiredCount) {
            viewForAddToCart.isUserInteractionEnabled  = true
            viewForAddToCart.backgroundColor = UIColor.themeColor
        } else {
            viewForAddToCart.isUserInteractionEnabled  = false
            viewForAddToCart.backgroundColor = UIColor.lightGray
        }
    }
    
    func isValidSelection(range:Int,maxRange:Int,selectedCount: Int,isDefaultSelected:Bool) -> Bool {
        
        if (range == 0 && maxRange ==
                0)
        {
            return  !isDefaultSelected
        }else if (selectedCount <= range
                    && maxRange == 0) {
            return selectedCount != range &&  !isDefaultSelected
        }else if (selectedCount <= maxRange
                    && range >= 0) {
            return  (selectedCount != maxRange &&  !isDefaultSelected)
        }else {
            return isDefaultSelected
        }
        
    }

    @IBAction func onClickCart(_ sender: Any) {
        self.performSegue(withIdentifier: SEGUE.SPECIFICATION_TO_CART, sender: self)
    }
    //Action Method
    @IBAction func onClickBtnBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func onClickLeftButton() {
        self.onClickBtnBack(btnBack)
    }
    
    @IBAction func onClickBtnIncrement(_ sender: Any){
        quantity+=1;
        lblQuantity.text = String(quantity)
        calculateTotalAmount()
        setTotalAmount(total)
    }
    
    @IBAction func onClickBtnDecrement(_ sender: Any){
        quantity-=1;
        if quantity == 0 {
            quantity = 1
        }
        lblQuantity.text = String(quantity)
        calculateTotalAmount()
        setTotalAmount(total)
    }
    //User Define Functions
    
    @objc func handleTapOnAddToCart(gestureRecognizer: UIGestureRecognizer) {
        addToCart()
    }

    func setProductData(productdata:Item) {
        lblProductName.text = productdata.name
        lblProductDetail.text = productdata.details
        pgControl.numberOfPages = (productdata.imageUrl.count)
        pgControlforDialog.numberOfPages = (productdata.imageUrl.count)
        if pgControl.numberOfPages <= 1 {
            pgControl.isHidden = true
            pgControlforDialog.isHidden = true
        }
    }
    
    func setIsRequired() {
        requiredCount = 0
        for specificationsItem:ItemSpecification in arrSpecificationList {
            if specificationsItem.isRequired {
                requiredCount += 1;
            }
            if specificationsItem.rangeMax == 0 && specificationsItem.range == 0 {
                specificationsItem.selectionMessage = ""
            }else if specificationsItem.rangeMax == 0 && specificationsItem.range > 0 {
                specificationsItem.selectionMessage = "TXT_CHOOSE".localized + " " + String(specificationsItem.range)
            }else if specificationsItem.rangeMax > 0 && specificationsItem.range > 0 {
                specificationsItem.selectionMessage = "TXT_CHOOSE".localized + " " + String(specificationsItem.range) + " - " + String(specificationsItem.rangeMax)
            }else if specificationsItem.rangeMax > 0 && specificationsItem.range == 0 {
                if specificationsItem.rangeMax == 0 {
                    specificationsItem.selectionMessage = "TXT_CHOOSE".localized + " " + String(specificationsItem.range)
                }
                else {
                    specificationsItem.selectionMessage = "TXT_CHOOSE_UP_TO".localized + " " + String(specificationsItem.rangeMax)
                }
            }else {
                specificationsItem.selectionMessage = ""
            }
            specificationsItem.selectedCount = 0
            for itemList in specificationsItem.list {
                if itemList.isDefaultSelected {
                    specificationsItem.selectedCount = specificationsItem.selectedCount +  1
                }
            }
        }
    }
 
    func setTotalAmount(_ total:Double) {
        let strTotal = total.toCurrencyString()
        lblTotal.text = strTotal;
        btnAddcart.setTitle("TXT_ADD_TO_CART".localizedUppercase, for: UIControl.State.normal)
    }
    
    //Add item in Local cart
    
    func addToCart() {
        
        var arrCurrentAdded = [CartProductItems]()
        if StoreSingleton.shared.cart.count > 0 {
            for obj in StoreSingleton.shared.cart {
                for item in (obj.items) {
                    arrCurrentAdded.append(item)
                }
            }
        }
        print(arrCurrentAdded)
        
        var specificationPriceTotal = 0.0;
        var specificationPrice = 0.0;
        var specificationList:[ItemSpecification] = [ItemSpecification].init();
        
        Utility.showLoading();
        for specificationListItem in arrSpecificationList {
            
            var specificationItemCartList:[List] = [List].init();
            
            for listItem in specificationListItem.list! {
                if (listItem.isDefaultSelected)! {
                    specificationPrice = specificationPrice + (listItem.price! * Double(listItem.quantity))
                    specificationPriceTotal = specificationPriceTotal + (listItem.price! * Double(listItem.quantity))
                    specificationItemCartList.append(listItem)
                }
            }
            
            if !specificationItemCartList.isEmpty {
                let specificationsItem:ItemSpecification = ItemSpecification(fromDictionary: [:])
                specificationsItem.list = specificationItemCartList;
                specificationsItem.uniqueId = specificationListItem.uniqueId;
                specificationsItem.name = specificationListItem.name;
                //Storeapp / Specification issue changes
                specificationsItem.nameLanguages = specificationListItem.nameLanguages;
                specificationsItem.price = specificationPrice;
                specificationsItem.type = specificationListItem.type;
                //Changed
                specificationsItem.isRequired = specificationListItem.isRequired;
                specificationsItem.range = specificationListItem.range;
                specificationsItem.rangeMax = specificationListItem.rangeMax;

                specificationList.append(specificationsItem);
            }
            specificationPrice = 0;
        }
        
        let cartProductItems:CartProductItems = CartProductItems.init()
        guard let currentSelectedProductItem = selectedProductItem else {
            return
        }
        
        cartProductItems.itemId = currentSelectedProductItem.id;
        cartProductItems.uniqueId = currentSelectedProductItem.uniqueId
        cartProductItems.itemName = currentSelectedProductItem.name;
        cartProductItems.quantity = quantity;
        cartProductItems.imageURL = currentSelectedProductItem.imageUrl;
        cartProductItems.details = currentSelectedProductItem.details;
        cartProductItems.specifications = specificationList;
        cartProductItems.itemPrice = currentSelectedProductItem.price
        cartProductItems.totalSpecificationPrice = specificationPriceTotal;
        cartProductItems.totalItemPrice = total;
        cartProductItems.noteForItem =  ""
        cartProductItems.taxDetails = currentSelectedProductItem.taxDetails;

        var eachItemTax = 0
        
        if StoreSingleton.shared.store.isUseItemTax{
            for obj in currentSelectedProductItem.taxDetails{
                eachItemTax = eachItemTax + obj.tax
            }
        }else{
            for obj in StoreSingleton.shared.store.taxesDetails{
                eachItemTax = eachItemTax + obj.tax
            }
        }
        
        let itemTax = getTax(itemAmount: currentSelectedProductItem.price, taxValue: Double(eachItemTax))
        let specificationTax = getTax(itemAmount: specificationPriceTotal, taxValue: Double(eachItemTax))
        let totalTax = itemTax + specificationTax
        
        cartProductItems.tax = Double(eachItemTax)
        cartProductItems.itemTax = itemTax
        cartProductItems.totalSpecificationTax = specificationTax
        cartProductItems.totalTax = totalTax
        cartProductItems.totalItemTax = totalTax * Double(quantity)
        
        let isAdded = arrCurrentAdded.filter { obj in
            if obj.getProductJson().isEqual(to: cartProductItems.getProductJson() as! [AnyHashable : Any]) {
                return true
            }
            return false
        }
        
        if isAdded.count > 0 {
            var section = 0
            var row = 0
            
            for obj in StoreSingleton.shared.cart {
                for item in (obj.items) {
                    if isAdded[0].getProductJson().isEqual(to: item.getProductJson() as! [AnyHashable : Any]) {
                        section = StoreSingleton.shared.cart.firstIndex(where: {$0.uniqueId == obj.uniqueId}) ?? 0
                        row = (obj.items).firstIndex(where: {$0.uniqueId == item.uniqueId}) ?? 0
                        break
                    }
                }
            }
            
            print("section \(section) row \(row)")
            
            StoreSingleton.shared.cart[section].items[row] = cartProductItems
            StoreSingleton.shared.cart[section].items[row].totalItemTax = cartProductItems.totalItemTax
            StoreSingleton.shared.cart[section].items[row].quantity = isAdded[0].quantity + self.quantity
        }else {
            var cartProductItemsList:[CartProductItems] = [CartProductItems].init() ;
            cartProductItemsList.append(cartProductItems)
            let cartProducts:CartProduct = CartProduct.init() ;
            cartProducts.items = cartProductItemsList;
            cartProducts.productId = selectedProductItem?.productId;
            cartProducts.productName = productName
            cartProducts.uniqueId = productUniqueId
            cartProducts.totalItemPrice = total
            cartProducts.totalItemTax =  cartProductItems.totalItemTax
            
            StoreSingleton.shared.cart.append(cartProducts)
        }
        setItemCountInBasket()
        Utility.hideLoading()
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    func getTax(itemAmount:Double, taxValue:Double) -> Double {
        if !StoreSingleton.shared.store.isTaxInlcuded{
            return itemAmount * taxValue * 0.01
        }else{
            return (itemAmount - (100*itemAmount)/(100+taxValue))
        }
    }
    
    func setItemCountInBasket() {
        var numberOfItems = 0;
        for cartProduct in StoreSingleton.shared.cart {
            numberOfItems = numberOfItems + cartProduct.items.count
        }
        StoreSingleton.shared.totalItemInCart = numberOfItems
        lblCartQuantity.text = String(StoreSingleton.shared.totalItemInCart)
        cartButton?.badgeString = String(StoreSingleton.shared.totalItemInCart)
    }
    
    func isProductExistInLocalCart(cartProductItems:CartProductItems) -> Bool {
        for cartProduct in StoreSingleton.shared.cart {
            if ((cartProduct.productId.compare((selectedProductItem?.productId)!)) == .orderedSame) {
                cartProduct.items.append(cartProductItems)
                total = total + cartProduct.totalItemPrice!
                cartProduct.totalItemPrice = total
                    //- cartProduct.totalItemTax;
                cartProduct.totalItemTax = cartProduct.totalItemTax +  cartProductItems.totalItemTax
                return true;
                
            }
        }
        return false;
    }
    
    
    // MARK:- ScrollView Deligate Methods
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        if scrollView != self.tblForProductSpecification {
            return
        }
        /*
         if(self.tblForProductSpecification.isTableHeadeViewVisible(headerHeight: collectionForItemImages.frame.height)) {
         viewForNavigation.backgroundColor = UIColor.themeTransparentNavigationBackgroundColor
         lblTitle.text = ""
         
         self.viewForNavigation.isHidden = false
         self.navigationController?.setNavigationBarHidden(true, animated: true)
         
         }else {
         viewForNavigation.backgroundColor = UIColor.themeNavigationBackgroundColor
         lblTitle.text = selectedProductItem?.name!
         self.viewForNavigation.isHidden = true
         self.navigationController?.setNavigationBarHidden(false, animated: true)
         
         }*/
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let center = CGPoint(x: scrollView.contentOffset.x + (scrollView.frame.width / 2), y: (scrollView.frame.height / 2))
        
        let pageWidth:CGFloat = scrollView.frame.size.width
        let fractionalPage:CGFloat = scrollView.contentOffset.x / pageWidth
        let page:Int = lroundf(Float(fractionalPage))
        print(page)
        
        if dialogForProductItemImages.isHidden {
            self.pgControl.currentPage = page

//            if let ip = collectionForItemImages.indexPathForItem(at: center) {
//                self.pgControl.currentPage = ip.row
//                collectionForItemImages.scrollToItem(at: ip, at: .centeredHorizontally, animated: false)
//            }
        }else {
            self.pgControlforDialog.currentPage = page

//            if let ip = collectionForItems.indexPathForItem(at: center) {
//                self.pgControlforDialog.currentPage = ip.row
//                collectionForItems.scrollToItem(at: ip, at: .centeredHorizontally, animated: false)
//            }
            
        }
        
    }
    
    
    
}
class OrderProductSpecificationSection: CustomCell {
    
    //MARK:- OUTLET
    @IBOutlet weak var lblSpecificationName: UILabel!
    @IBOutlet weak var lblSpecificationRequired: UILabel!
    @IBOutlet weak var lblSelectionMessage: UILabel!
    @IBOutlet weak var viewBG: UIView!

    var isMultipleSelect:Bool = false
    
    //MARK:- LIFECYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        lblSpecificationRequired.textColor = UIColor.themeRedColor
        lblSpecificationRequired.font = FontHelper.textMedium()
        
        lblSelectionMessage.textColor = UIColor.themeLightTextColor
        lblSelectionMessage.font = FontHelper.textRegular(size: 11.0)
        
        lblSpecificationName.textColor = UIColor.themeTextColor
        lblSpecificationName.font = FontHelper.textRegular(size: 12.0)
        viewBG.backgroundColor = UIColor(named: "themeSectionBGColor")
        viewBG.layer.cornerRadius = 3.0
        
    }
    
    //MARK:- SET CELL DATA
    func setData(title:String, isAllowMultipleSelect:Bool, isRequired:Bool,message:String)
    {
        if message.isEmpty() {
            lblSelectionMessage.text = ""
            lblSelectionMessage.isHidden = true
        }else {
            lblSelectionMessage.text = message
            lblSelectionMessage.isHidden = false
        }
        lblSpecificationRequired.text = "*"
        lblSpecificationRequired.isHidden = !isRequired
        
        //"TXT_REQUIRED".localized
        
        //        lblSpecificationName.text = title.appending("     ")
        lblSpecificationName.text = title.uppercased()
        
        lblSpecificationName.sizeToFit()
        lblSpecificationName.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        isMultipleSelect = isAllowMultipleSelect
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
extension OrderProductSpecificationVC: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    //MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedProductItem?.imageUrl.count == 0{
            collectionForItems.isHidden = true
            collectionForItemImages.isHidden = true
            return 0
        }
        collectionForItems.isHidden = false
        collectionForItemImages.isHidden = false
        return selectedProductItem?.imageUrl.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionImage
        
        
        if collectionForItems == collectionView {
            cell.imgProductItem.downloadedFrom(link: (selectedProductItem?.imageUrl[indexPath.row])!)
        }else {
            cell.imgProductItem.downloadedFrom(link: (selectedProductItem?.imageUrl[indexPath.row])!,mode: .scaleAspectFit)
        }
        return cell
        
    }
    
    
    
    //MARK: UICollectionViewDelegateFlowLayout
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionForItemImages.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: false)
        collectionForItems.reloadData()
        dialogForProductItemImages.isHidden = false
        collectionForItems.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        pgControlforDialog.currentPage = pgControl.currentPage

        self.view.bringSubviewToFront(dialogForProductItemImages)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    @IBAction func onClickBtnCloseDialog(_ sender: Any) {
        dialogForProductItemImages.isHidden = true
    }
}

class CustomCollectionImage:UICollectionViewCell {
    @IBOutlet weak var imgProductItem: UIImageView!
}

extension OrderProductSpecificationVC: OrderProductSpecificationCellDelegae {
    
    func specificationButtonAction(cell: OrderProductSpecificationCell, sender: UIButton) {
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
