//
//  ProductVC.swift
// Edelivery Store
//
//  Created by Jaydeep Vyas on 09/03/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class UpdateOrderProductSpecificationVC: BaseVC,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate,LeftDelegate,UIScrollViewDelegate {
        
    //MARK:- OUTLETS
//    @IBOutlet weak var topImageConstraints: NSLayoutConstraint!
    @IBOutlet weak var pgControlforDialog: UIPageControl!
    @IBOutlet weak var lblDialogGradient: UILabel!
    @IBOutlet weak var collectionForItems: UICollectionView!
    @IBOutlet var dialogForProductItemImages: UIView!
//    @IBOutlet weak var lblGradient: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
//    @IBOutlet weak var lblDescription: UILabel!
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
    @IBOutlet weak var viewForQuantity: UIView!
    @IBOutlet weak var lblQuantitySep1: UILabel!
    @IBOutlet weak var lblQuantitySep2: UILabel!
    @IBOutlet weak var btnQuantityAdd: UIButton!
    @IBOutlet weak var btnQuantityMinus: UIButton!
    
    var quantity = 1;
    var total = 0.0;
    var arrSpecificationList = [OrderSpecification]()
    var arrSpecificationListMain = [OrderSpecification]()
    var specificationItemListLength:Int? = 0;
    var specificationListLength:Int? = 0;
    var selectedOrderItem:OrderItem? = nil;
    
    var currentOrder:UpdateOrder = StoreSingleton.shared.updateOrder
    var productName:String? = nil;
    var productUniqueId:Int? = 0;
    
    var selectedIndexPath:IndexPath = IndexPath.init(row: -1, section: -1);
    
    //MARK:- Variables
    var newImage: UIImage!
    var requiredCount:Int = 0;
    //MARK:- View Life Cycle
    override func viewDidLoad(){
        super.viewDidLoad()
        
        setProductData(productdata: selectedOrderItem!)

        viewForNavigation.backgroundColor = UIColor.themeTransparentNavigationBackgroundColor
        setLocalization()
        self.setNavigationTitle(title: selectedOrderItem?.itemName ?? "")
        
        delegateLeft = self
        self.setBackBarItem(isNative:false)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapOnAddToCart(gestureRecognizer:)))
        gestureRecognizer.delegate = self
        viewForAddToCart.addGestureRecognizer(gestureRecognizer)
        viewForAddToCart.layer.cornerRadius = viewForAddToCart.layer.frame.size.height/2
        viewForAddToCart.backgroundColor = .themeColor
        
    }
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        setupLayout()
        
    }
    
    
    func sizeHeaderToFit() {
        let headerView = tblForProductSpecification.tableHeaderView!
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        let height = lblProductDetail.frame.origin.y + lblProductDetail.frame.height + 15
        var frame = headerView.frame
        frame.size.height = height
        headerView.frame = frame
        tblForProductSpecification.tableHeaderView = headerView
        tblForProductSpecification.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewForFooter.frame.size.height = 150
        tblForProductSpecification.tableFooterView = viewForFooter
        
        sizeHeaderToFit()
    }
    
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    func setLocalization(){
        
//        lblGradient.text = ""
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        viewForQuantity.backgroundColor = UIColor.themeViewBackgroundColor
        
        viewForHeader.backgroundColor = UIColor.themeViewBackgroundColor
//        viewForProduct.backgroundColor = UIColor.themeAlertViewBackgroundColor
        tblForProductSpecification.backgroundColor = UIColor.themeViewBackgroundColor
        viewForFooter.backgroundColor = UIColor.themeViewBackgroundColor
        tblForProductSpecification.tableFooterView?.backgroundColor = UIColor.themeViewBackgroundColor
        lblProductDetail.textColor = UIColor.themeLightTextColor
//        lblDescription.textColor = UIColor.themeTextColor
        
        
        lblTotal.textColor = UIColor.themeButtonTitleColor
        viewForAddToCart.backgroundColor = UIColor.themeColor
        btnAddcart.setTitleColor(UIColor.themeButtonTitleColor, for:UIControl.State.normal);
        lblTitle.textColor = UIColor.themeTitleColor
        pgControl.currentPageIndicatorTintColor = UIColor.themeColor
        pgControl.pageIndicatorTintColor = UIColor.themeLightTextColor
        pgControlforDialog.currentPageIndicatorTintColor = UIColor.themeColor
        pgControlforDialog.pageIndicatorTintColor = UIColor.themeLightTextColor
        pgControl.isUserInteractionEnabled = false
        pgControlforDialog.isUserInteractionEnabled = false

        
        lblProductDetail.font = FontHelper.textMedium()
//        lblDescription.font = FontHelper.textMedium()
        lblProductName.font = FontHelper.textLarge()
        lblTotal.font = FontHelper.textRegular()
        btnAddcart.titleLabel?.font = FontHelper.textRegular()
        lblTitle.font = FontHelper.textRegular()
        self.tblForProductSpecification.sectionHeaderHeight = UITableView.automaticDimension;
        self.tblForProductSpecification.estimatedSectionHeaderHeight = 25;
        
        lblQuantitySep1.backgroundColor = .themeColor
        lblQuantitySep2.backgroundColor = .themeColor
        lblProductName.textColor = .themeTextColor
        
    }
    
    override func updateUIAccordingToTheme() {
        setBackBarItem(isNative: false)
        self.tblForProductSpecification.reloadData()
    }
    
    func setupLayout(){
        if viewForQuantity != nil{
//            lblGradient.setGradient(startColor:UIColor.themeEndGradientColor,endColor:UIColor.themeStartGradientColor)
            lblDialogGradient.setGradient(startColor:UIColor.themeEndGradientColor,endColor:UIColor.themeStartGradientColor)
//            viewForProduct.layer.cornerRadius = 3;
            
//            viewForProduct.setShadow(shadowColor: UIColor.black.cgColor, shadowOffset: CGSize(width: -1, height: 1), shadowOpacity: 0.5, shadowRadius: 5)
            viewForQuantity.layer.cornerRadius = viewForQuantity.frame.size.height/2;
            viewForQuantity.layer.borderWidth = 1
            viewForQuantity.layer.borderColor = UIColor.themeColor.cgColor
            
            lblProductDetail.sizeToFit()
            viewForHeader.sizeToFit()
            viewForHeader.autoresizingMask = UIView.AutoresizingMask()
            
            btnQuantityAdd.setTitleColor(.themeColor, for: .normal)
            btnQuantityMinus.setTitleColor(.themeColor, for: .normal)
            lblQuantity.textColor = .themeColor
            
        }
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
        
        return (arrSpecificationList[section].specificationName)
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = tableView.dequeueReusableCell(withIdentifier: "cellForSection")! as! OrderProductSpecificationSection
        
        sectionHeader.setData(title: arrSpecificationList[section].specificationName, isAllowMultipleSelect: Bool(truncating: (arrSpecificationList[section].type as NSNumber)), isRequired: arrSpecificationList[section].isRequired, message: arrSpecificationList[section].selectionMessage)
        
        return sectionHeader
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        specificationItemListLength = arrSpecificationList[section].list?.count ?? 0;
        return specificationItemListLength!;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionType = arrSpecificationList[indexPath.section].type!
        let productSpecificationCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UpdateOrderSpecificationCell
        productSpecificationCell.delegate = self
        let currentProduct:OrderSpecification = arrSpecificationList[indexPath.section]
        let currentProductItem:OrderListItem = currentProduct.list[indexPath.row]
        
        productSpecificationCell.setCellData(cellItem: currentProductItem, isAllowMultipleSelect: sectionType)
        if !arrSpecificationList[indexPath.section].user_can_add_specification_quantity {
            productSpecificationCell.viewQty?.isHidden = true
        }
        return productSpecificationCell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let currentSpecificationGroup = (arrSpecificationList[indexPath.section])
        let specificationSubItem:OrderListItem = currentSpecificationGroup.list[indexPath.row]
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
        
        calculateTotalAmount()
        tableView.reloadData()
        viewForFooter.frame.size.height = 120
        tblForProductSpecification.tableFooterView = viewForFooter
        
        setTotalAmount(total)
    }
    
    func calculateTotalAmount() {
        total = Double((selectedOrderItem?.itemPrice)!)
        var requiredCountTemp = 0
        for currentProduct in arrSpecificationList {
            for currentProductItem in currentProduct.list! {
                if currentProductItem.isDefaultSelected {
                    total = total + Double(currentProductItem.price!) * Double(currentProductItem.quantity)
                }
                
            }
            if (currentProduct.isRequired
                    && currentProduct.selectedCount >= currentProduct.range
                    && (currentProduct.rangeMax == 0  || currentProduct.selectedCount <= currentProduct
                            .rangeMax)
                    && currentProduct.selectedCount != 0) {
                requiredCountTemp += 1;
            }
        }
        total = total * Double(quantity)
        DispatchQueue.main.async {
            if (requiredCountTemp == self.requiredCount) {
                self.viewForAddToCart.isUserInteractionEnabled  = true
                self.viewForAddToCart.backgroundColor = UIColor.themeColor
            } else {
                self.viewForAddToCart.isUserInteractionEnabled  = false
                self.viewForAddToCart.backgroundColor = UIColor.lightGray
            }
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
        addItemInOrder()
    }
    
    
    func setProductData(productdata:OrderItem) {
        lblProductName.text = productName
        //productdata.itemName
        //Storeapp
        lblProductDetail.text = productdata.details
        
        lblQuantity.text = String(productdata.quantity)
        quantity = productdata.quantity
        pgControl.numberOfPages = productdata.imageURL.count
        pgControlforDialog.numberOfPages = productdata.imageURL.count
        if pgControl.numberOfPages <= 1 {
            pgControl.isHidden = true
            pgControlforDialog.isHidden = true
        }
        arrSpecificationListMain = selectedOrderItem?.specifications ?? []
        specificationListLength = arrSpecificationListMain.count
        
        reArrageArrayWithAssociateSP(arr: arrSpecificationListMain)
        
        tblForProductSpecification.reloadData()
    }
    
    func reArrageArrayWithAssociateSP(arr: [OrderSpecification]) {
        arrSpecificationList.removeAll()
        
        var arrReArrage = [OrderSpecification]()
        arrReArrage = arr.filter({!$0.isAssociated})
        
        for obj in arrReArrage {
            self.arrSpecificationList.append(obj)
        }
        
        let arrId = arrSpecificationList.map({$0.id})
        var arrSelected = [OrderListItem]()
        
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
    
    
    func setIsRequired() {
        requiredCount = 0
        for specificationsItem:OrderSpecification in arrSpecificationList {
            if specificationsItem.isRequired! {
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
            for itemList in specificationsItem.list! {
                if itemList.isDefaultSelected! {
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
    
    //Update item in Local cart
    func addItemInOrder() {
        
        var arrCurrentAdded = [OrderItem]()
        if currentOrder.orderDetails.count > 0 {
            for obj in currentOrder.orderDetails {
                for item in (obj.items ?? []) {
                    arrCurrentAdded.append(item)
                }
            }
        }
        print(arrCurrentAdded)
        
        var specificationPriceTotal = 0.0;
        var specificationPrice = 0.0;
        var specificationList:[OrderSpecification] = [OrderSpecification].init();
        
        Utility.showLoading();
        for specificationListItem in arrSpecificationList {
            
            var specificationItemCartList:[OrderListItem]? = [OrderListItem].init();
            
            for listItem in specificationListItem.list! {
                if (listItem.isDefaultSelected)! {
                    specificationPrice = specificationPrice + listItem.price;
                    specificationPriceTotal = specificationPriceTotal + listItem.price;
                    specificationItemCartList?.append(listItem)
                }
            }
            let specificationsItem:OrderSpecification = OrderSpecification(fromDictionary: [:])
            
            specificationsItem.list = specificationItemCartList;
            specificationsItem.uniqueId = specificationListItem.uniqueId;
            specificationsItem.id = specificationListItem.id
            specificationsItem.specificationName = specificationListItem.specificationName;
            specificationsItem.specificationPrice = specificationPrice;
            specificationsItem.type = specificationListItem.type;

            specificationsItem.range = specificationListItem.range;
            specificationsItem.rangeMax = specificationListItem.rangeMax;
            specificationsItem.isRequired = specificationListItem.isRequired;

            specificationList.append(specificationsItem);
            specificationPrice = 0;
        }
        
        
        
        let orderItem:OrderItem = OrderItem.init(fromDictionary: [:]);
        
        
        orderItem.itemId = selectedOrderItem?.itemId
        orderItem.uniqueId = selectedOrderItem?.uniqueId
        orderItem.itemName = selectedOrderItem?.itemName;
        orderItem.quantity = quantity;
        orderItem.imageURL = selectedOrderItem?.imageURL;
        orderItem.details = selectedOrderItem?.details;
        orderItem.specifications = specificationList;
        orderItem.itemPrice = selectedOrderItem?.itemPrice;
        orderItem.totalSpecificationPrice = specificationPriceTotal;
        orderItem.totalItemPrice = total;
        orderItem.taxDetails = selectedOrderItem?.taxDetails;

//        var tax = 0.0
        var eachItemTax = 0
        
        if StoreSingleton.shared.store.isUseItemTax{
            for obj in selectedOrderItem!.taxDetails{
                eachItemTax = eachItemTax + obj.tax
            }
        }else{
            for obj in StoreSingleton.shared.store.taxesDetails{
                eachItemTax = eachItemTax + obj.tax
            }
        }
        
        
        print(selectedOrderItem?.itemName)
        print(eachItemTax)
        
//        tax = (StoreSingleton.shared.store.isUseItemTax ) ?  selectedOrderItem!.tax : StoreSingleton.shared.store.itemTax
        
        
        let itemTax = getTax(itemAmount: selectedOrderItem!.itemPrice, taxValue: Double(eachItemTax))
        let specificationTax = getTax(itemAmount: specificationPriceTotal, taxValue: Double(eachItemTax))
        let totalTax = itemTax + specificationTax
        
        orderItem.tax = Double(eachItemTax)
        orderItem.itemTax = itemTax
        orderItem.totalSpecificationTax = specificationTax
        orderItem.totalTax = totalTax
        orderItem.totalItemTax = totalTax * Double(quantity)
        orderItem.noteForItem = selectedOrderItem!.noteForItem

        if selectedIndexPath.row == -1 {
     
            let isAdded = arrCurrentAdded.filter({$0.getProductJson().isEqual(to: orderItem.getProductJson() as! [AnyHashable : Any])})
            
            if isAdded.count > 0 {
                var section = 0
                var row = 0
                
                for obj in currentOrder.orderDetails {
                    for item in (obj.items ?? []) {
                        if isAdded[0].getProductJson().isEqual(to: item.getProductJson() as! [AnyHashable : Any]) {
                            section = currentOrder.orderDetails.firstIndex(where: {$0.getProductJson() == obj.getProductJson()}) ?? 0
                            row = (obj.items ?? []).firstIndex(where: {$0.getProductJson() == item.getProductJson()}) ?? 0
                            break
                        }
                    }
                }
                
                currentOrder.orderDetails[section].items![row] = orderItem
                currentOrder.orderDetails[section].items![row].quantity = isAdded[0].quantity + self.quantity
                currentOrder.orderDetails[section].items![row].totalItemTax = totalTax * Double((isAdded[0].quantity + self.quantity))
                
            }else {
                
                currentOrder.serverItems.append(selectedOrderItem!)
                
                var orderProductItemsList:[OrderItem] = [OrderItem].init() ;
                orderProductItemsList.append(orderItem)
                let orderProduct:OrderDetail = OrderDetail.init(fromDictionary: [:]) ;
                orderProduct.items = orderProductItemsList;
                orderProduct.productId = selectedOrderItem?.productId;
                orderProduct.productName = productName
                orderProduct.uniqueId = productUniqueId
                orderProduct.totalItemPrice = total;
                
                orderProduct.totalItemTax = orderItem.totalItemTax
                    //selectedOrderItem!.totalItemTax
                
                currentOrder.orderDetails.append(orderProduct)
            }
        }else {
            currentOrder.orderDetails[selectedIndexPath.section].items[selectedIndexPath.row] = orderItem
        }
        
        
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
    
    func isProductExistInOrder(currentOrderItem:OrderItem) -> Bool {
        for orderItem in currentOrder.orderDetails {
            if orderItem.productId == (selectedOrderItem?.productId)! {
                orderItem.items?.append(currentOrderItem)
                total = total + orderItem.totalItemPrice!
                orderItem.totalItemPrice = total;
                
                orderItem.totalItemPrice = total;
                orderItem.totalItemTax = orderItem.totalItemTax +  orderItem.totalItemTax
                return true;
                
            }
        }
        return false;
    }
    
    
    // MARK:- ScrollView Deligate Methods
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        
        viewForNavigation.backgroundColor = UIColor.themeNavigationBackgroundColor
        lblTitle.text = selectedOrderItem?.itemName
        
        self.viewForNavigation.isHidden = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        //Storeapp
        //removed image from header
        /* if(self.tblForProductSpecification.isTableHeadeViewVisible(headerHeight: collectionForItemImages.frame.height)) {
         //            viewForNavigation.backgroundColor = UIColor.themeTransparentNavigationBackgroundColor
         //            lblTitle.text = ""
         //
         //            self.viewForNavigation.isHidden = false
         //            self.navigationController?.setNavigationBarHidden(true, animated: true)
         
         }else {
         viewForNavigation.backgroundColor = UIColor.themeNavigationBackgroundColor
         lblTitle.text = selectedOrderItem?.itemName
         
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

extension UpdateOrderProductSpecificationVC: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    //MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedOrderItem?.imageURL.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionImage
        
        
        if collectionForItems == collectionView {
              cell.imgProductItem.downloadedFrom(link: (selectedOrderItem?.imageURL[indexPath.row])!)
        }else {
                cell.imgProductItem.downloadedFrom(link: (selectedOrderItem?.imageURL[indexPath.row])!)
            
        }
        return cell
        
    }
    @IBAction func onClickBtnCloseDialog(_ sender: Any) {
        dialogForProductItemImages.isHidden = true
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
}

extension UpdateOrderProductSpecificationVC : UpdateOrderSpecificationCellDelegae {
    func updateOrderCellButtonAction(cell: UpdateOrderSpecificationCell, sender: UIButton) {
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
