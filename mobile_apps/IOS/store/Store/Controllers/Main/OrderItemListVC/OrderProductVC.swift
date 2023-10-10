//
//  ProductVC.swift
// Edelivery Store
//
//  Created by Jaydeep Vyas on 09/03/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//


import UIKit


class OrderItemListVC: BaseVC,RightDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var heightBtnCart: NSLayoutConstraint!
    @IBOutlet weak var tblForItemsList: UITableView!
    @IBOutlet weak var heightForSearchView: NSLayoutConstraint!
    @IBOutlet weak var imgEmpty: UIImageView!
    @IBOutlet weak var btnCart: UIButton!
    @IBOutlet weak var viewForSearchOverlay: UIView!
    @IBOutlet weak var viewForSearchItem: UIView!
    @IBOutlet weak var searchBarItem: UISearchBar!
    @IBOutlet weak var tblForSearchItem: UITableView!
    @IBOutlet weak var btnApplySearch: UIButton!

    
    var filteredArrProductItemList:[ProductItem] = [];
    var productName : String = ""
    var arrProductList = [ProductListItem]() /// Only used to pass the array of productlist to the next screen
    var selectedItemIndexPath:IndexPath? = nil
    var selectedItem:Item? = nil
    var isFromUpdateOrder:Bool = false
    var arrItemsList = [ProductItem]() //List of Items Added by Store

    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        delegateRight = self
        self.setLocalization()
        
        self.hideBackButtonTitle()
        for s in searchBarItem.subviews[0].subviews {
            if s is UITextField {
                s.backgroundColor = UIColor.themeSearchBackgroundColor
                (s as! UITextField).textColor = UIColor.themeTextColor
            }
        }
        tblForItemsList.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if StoreSingleton.shared.cart.count > 0 {
            btnCart.isHidden = false
            heightBtnCart.constant = 40
        }else {
            btnCart.isHidden = true
            heightBtnCart.constant = 0
        }
        self.wsGetItemList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if self.arrItemsList.count > 0 {
            self.updateUi(isUpdate:true)
        }else {
            self.updateUi(isUpdate:false)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - custom set up
    
    func setLocalization() -> Void {
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        super.setNavigationTitle(title: "TXT_PRODUCTS".localized)
        self.setRightBarItem(isNative: false)
        self.tblForItemsList.backgroundColor = UIColor.themeViewBackgroundColor
        /*search view*/
        viewForSearchOverlay.backgroundColor = UIColor.clear
        viewForSearchItem.backgroundColor = UIColor.themeViewBackgroundColor
        btnApplySearch.backgroundColor = UIColor.themeColor
        btnApplySearch.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnApplySearch.setTitle("TXT_APPLY".localizedUppercase, for: .normal)
        btnApplySearch.titleLabel?.font = FontHelper.textRegular()
        searchBarItem.placeholder = "TXT_ENTER_ITEM_NAME".localized
        searchBarItem.barTintColor = UIColor.themeViewBackgroundColor
        searchBarItem.backgroundImage = UIImage()
        tblForSearchItem.backgroundColor = UIColor.themeViewBackgroundColor
        viewForSearchOverlay.isHidden = true
//        btnCart.setRound(withBorderColor: .clear, andCornerRadious: btnCart.frame.size.height/2, borderWidth: 1.0)
        
        self.btnCart.setTitle("TXT_GO_TO_CART".localizedUppercase, for: .normal)
//        self.btnCart.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
//        self.btnCart.backgroundColor = UIColor.themeColor
        // Tableview properties.
        self.tblForItemsList.rowHeight = UITableView.automaticDimension
        self.tblForItemsList.estimatedRowHeight = 150.0
        self.tblForItemsList.sectionHeaderHeight = UITableView.automaticDimension
        self.tblForItemsList.estimatedSectionHeaderHeight = 25
        viewForSearchItem.setShadow(shadowColor: UIColor.black.cgColor, shadowOffset: CGSize.init(width: 2.0, height: 2.0), shadowOpacity: 5.0, shadowRadius: 2.0)
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    func updateUi(isUpdate:Bool = false) {
        imgEmpty.isHidden = isUpdate
        tblForItemsList.isHidden = !isUpdate
        if isUpdate {
            self.setRightBarItemImage(image: UIImage.init(named: "filterIcon")!.imageWithColor(color: .themeColor)!)
        }else {
            self.setRightBarItemImage(image: UIImage.init())
        }
    }
    
    @IBAction func onClickBtnGoToCart(_ sender: Any) {
        self.performSegue(withIdentifier: SEGUE.PRODUCT_TO_CART, sender: self)
    }
    
    //MARK: -
    //MARK: - Custom web service methods
    func wsGetItemList() -> Void {
        var dictParam = [String:Any]()
        dictParam[PARAMS.STORE_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.SERVER_TOKEN] = preferenceHelper.getSessionToken()
        
        Utility.showLoading()
        let alamofire = AlamofireHelper.init()
        alamofire.getResponseFromURL(url: WebService.WS_GET_ITEM_LIST, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            Utility.hideLoading()
            
            if Parser.isSuccess(response: response) {
                
                print(Utility.conteverDictToJson(dict: dictParam))
                
                self.arrItemsList.removeAll()
                self.arrProductList.removeAll()
                self.filteredArrProductItemList.removeAll()
                
                let itemListResponse:ItemListResponse = ItemListResponse.init(fromDictionary: response)
                
                var arrProduct:Array<ProductItem> = itemListResponse.products
                /*-----*/
                var sortedArray = [Item]()
                var array = [ProductItem]()
                var arrayfiltered = [ProductItem]()
                
                array.append(contentsOf: arrProduct)
                
                let SS = array.sorted{ $0.sequence_number < $1.sequence_number }
                arrProduct.removeAll()
                arrProduct.append(contentsOf: SS)
                arrayfiltered.append(contentsOf: SS)
                for i in 0...arrayfiltered.count-1 {
                    if arrayfiltered[i].isProductFiltered {
                        sortedArray = arrayfiltered[i].items.sorted{ $0.sequence_number < $1.sequence_number }
                        arrProduct[i].items.removeAll()
                        arrProduct[i].items.append(contentsOf: sortedArray)
                    }
                }
                /*-----*/
                
                for product in arrProduct {
                    if product.isVisibleInStore
                    {
                        var itemList:[Item] = []
                        
                        for item in product.items
                        {
                            if item.isVisibleInStore && item.isItemInStock
                            {
                                itemList.append(item)
                            }
                        }
                        product.items = itemList
                        if !itemList.isEmpty
                        {
                            self.arrItemsList.append(product)
                            self.filteredArrProductItemList.append(product)
                        }
                    }
                }
                
                if (self.tblForItemsList != nil) {
                    self.reloadTableWithArray(array:self.filteredArrProductItemList)
                    self.tblForSearchItem.reloadData()
                }
                
                if self.arrItemsList.count > 0 {
                    self.updateUi(isUpdate:true)
                }
                else {
                    self.updateUi(isUpdate:false)
                }
            }
        }
    }
    
    /*func reloadTableWithArray(array:[ProductItem]) {
     filteredArrProductItemList.removeAll()
     for productItem in array {
     if productItem.isProductFiltered {
     filteredArrProductItemList.append(productItem)
     }
     }
     tblForItemsList.reloadData()
     }*/
    
    
    //Storeapp //Sorting Sequence no wise
    func reloadTableWithArray(array:[ProductItem]) {
        var sortedArray = [Item]()
        
        filteredArrProductItemList.removeAll()
        if array.count > 0{
            for i in 0...array.count-1 {
                if array[i].isProductFiltered {
                    sortedArray = array[i].items.sorted{ $0.sequence_number < $1.sequence_number }
                    array[i].items.removeAll()
                    array[i].items.append(contentsOf: sortedArray)
                    
                    filteredArrProductItemList.append(array[i])
                }
            }
        }

        if self.filteredArrProductItemList.count > 0 {
            imgEmpty.isHidden = true
            tblForItemsList.isHidden = false
        }else {
            imgEmpty.isHidden = false
            tblForItemsList.isHidden = true
        }
        tblForItemsList.reloadData()
    }
    
    func onClickRightButton() {
        searchBarItem.text = ""
        if !arrItemsList.isEmpty {
            
            self.openProductFilterDialog()
//            if viewForSearchOverlay.isHidden {
//                viewVisible()
//            }else {
//                viewGone()
//            }
        }
    }
    
    func openProductFilterDialog()  {
        let dialogProductFilter = CustomProductFilter.showProductFilter(title: "TXT_FILTERS".localized, message: "", arrProductList: arrItemsList)
        dialogProductFilter.onClickLeftButton = {
            dialogProductFilter.removeFromSuperview()
        }
        dialogProductFilter.onClickApplySearch = {
            (searchText, arrSearchList) in
            dialogProductFilter.removeFromSuperview()
            self.arrItemsList = arrSearchList!
            var isFound: Bool = false
            var product_array:Array<ProductItem> = [];
            
            if searchText.isEmpty() {
                self.reloadTableWithArray(array: self.arrItemsList)
            }else {
                self.arrItemsList.forEach({ (product) in
                    
                    if product.isProductFiltered {
                        let producttemp = ProductItem.init(fromDictionary: product.toDictionary())
                        
                        let itemArray = producttemp.items?.filter({ (itemData) -> Bool in
                            let a = itemData.name?.lowercased().contains(searchText.lowercased())
                            return a!;
                        })
                        if((itemArray?.count) ?? 0 > 0) {
                            producttemp.items = itemArray
                            product_array.append(producttemp)
                        }
                    }
                })
                
                if product_array.isEmpty {
                    isFound = false
                }else {
                    isFound = true
                }
                self.reloadTableWithArray(array: product_array)
                if !isFound{
                    Utility.showToast(message: "TXT_NO_SEARCH_ITEM_NOT_AVAILABLE".localized);
                }
            }
            
            
        }
    }
    
    
    //MARK: - USER DEFINED FUNCTION
    func viewGone(showMessage: Bool = false) {
        let height = self.heightForSearchView.constant
        
        UIView.animate(withDuration: 0.5, animations: {
            self.heightForSearchView.constant = 0.0
            self.viewForSearchItem.superview?.layoutIfNeeded()
            
        }) { (completion) in
            self.viewForSearchOverlay.isHidden = true
            self.heightForSearchView.constant = height
            self.viewForSearchItem.superview?.layoutIfNeeded()
            self.setRightBarItemImage(image: UIImage.init(named: "filterIcon")!.imageWithColor(color: .themeIconTintColor)!)
            if showMessage {
                Utility.showToast(message: "TXT_NO_SEARCH_ITEM_NOT_AVAILABLE".localized);
            }
        }
    }
    func viewVisible() {
        viewForSearchOverlay.isHidden = false
        let height = self.heightForSearchView.constant
        self.heightForSearchView.constant = 0.0
        self.viewForSearchItem.superview?.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, animations: {
            self.heightForSearchView.constant = height
            self.viewForSearchItem.superview?.layoutIfNeeded()
        })
        self.setRightBarItemImage(image: UIImage.init(named: "cancelBlackIcon")!)
        
    }
    
    @IBAction func onClickBtnApplySearch(_ sender: Any) {
        self.view.endEditing(true)
        
        var isFound: Bool = false
        var product_array:Array<ProductItem> = [];
        let searchText = searchBarItem.text ?? ""
        if searchText.isEmpty() {
            self.reloadTableWithArray(array: arrItemsList)
        }else {
            self.arrItemsList.forEach({ (product) in
                
                if product.isProductFiltered {
                    let producttemp = ProductItem.init(fromDictionary: product.toDictionary())
                    
                    let itemArray = producttemp.items?.filter({ (itemData) -> Bool in
                        let a = itemData.name?.lowercased().contains(searchText.lowercased())
                        return a!;
                    })
                    if((itemArray?.count) ?? 0 > 0) {
                        producttemp.items = itemArray
                        product_array.append(producttemp)
                    }
                }
            })
            
            if product_array.isEmpty {
                isFound = false
            }else {
                isFound = true
            }
            self.reloadTableWithArray(array: product_array)
        }
        
        viewGone(showMessage: !isFound)
    }
    
}
extension OrderItemListVC:UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate {
    //MARK: -
    //MARK: - UITableview delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if tableView == tblForItemsList {
            if filteredArrProductItemList.count>0 {
                return self.filteredArrProductItemList[section].items!.count
            }else {
                return 0
            }
        }else {
            return arrItemsList.count
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tblForItemsList {return self.filteredArrProductItemList.count}
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblForItemsList {
            let reuseIdentifire = "OrderItemCell"
            var cell:OrderItemCell?
            
            cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifire, for: indexPath) as? OrderItemCell
            
            
            if (cell == nil) {
                cell = UITableViewCell(style: .default, reuseIdentifier: reuseIdentifire) as? OrderItemCell
            }
            cell?.selectionStyle = .none
            let item:Item = (self.filteredArrProductItemList[indexPath.section].items?[indexPath.row])!
            cell?.setCellData(item: item, parent: self)
            return cell!
        }else {
            
            var cell:ProductSearchCell? = tableView.dequeueReusableCell(withIdentifier: "cellForProductName", for: indexPath) as? ProductSearchCell
            if cell == nil {
                
                cell = ProductSearchCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cellForProductName")
            }
            cell?.selectionStyle = .none
            cell?.setCellData(cellItem:arrItemsList[indexPath.row])
            return cell!
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblForItemsList {
            selectedItemIndexPath = indexPath;
            selectedItem = (self.filteredArrProductItemList[indexPath.section].items?[indexPath.row])!
            productName = (self.filteredArrProductItemList[indexPath.section].name)!
            
            if isFromUpdateOrder {
                self.performSegue(withIdentifier: SEGUE.UPDATE_ORDER_ITEM_SPECIFICATION, sender: self)
            }else {
                self.performSegue(withIdentifier: SEGUE.PRODUCT_SPECIFICATION_LIST, sender: self)
            }
        }else {
            arrItemsList[indexPath.row].isProductFiltered = !(arrItemsList[indexPath.row].isProductFiltered)
            tblForSearchItem.reloadData()
            
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == tblForItemsList {
            let  sectionHeaderCell = tableView.dequeueReusableCell(withIdentifier: "OrderUserItemSection") as! OrderUserItemSection
            sectionHeaderCell.setData(title: self.filteredArrProductItemList[section].name)
            
            return sectionHeaderCell
        }
        return UIView.init()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == SEGUE.PRODUCT_SPECIFICATION_LIST {
            let productSpecificationVC = segue.destination as! OrderProductSpecificationVC
            
            let selectedProductItem:Item = Item.init(fromDictionary: selectedItem!.toDictionary())
            
            productSpecificationVC.selectedProductItem = selectedProductItem
            productSpecificationVC.productName = self.selectedItem?.name
            productSpecificationVC.productUniqueId = self.selectedItem?.uniqueId
            
        }else if segue.identifier == SEGUE.PRODUCT_TO_CART {
            
        }else {
            
            let selectedProductItem:OrderItem = OrderItem.init(fromDictionary: selectedItem!.toDictionary())
            selectedProductItem.itemPrice = selectedItem?.price
            
            
            let productSpecificationVC = segue.destination as! UpdateOrderProductSpecificationVC
            
            
            productSpecificationVC.selectedOrderItem = selectedProductItem
            productSpecificationVC.productName = productName
            productSpecificationVC.productUniqueId = self.selectedItem?.uniqueId
        }
    }
}

//Mark: Class For Item Section
class OrderUserItemSection: CustomCell {
    
    @IBOutlet weak var lblSection: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        lblSection.backgroundColor = UIColor.themeViewBackgroundColor
        lblSection.textColor = UIColor.themeTextColor
        lblSection.font = FontHelper.labelRegular(size: 15.0)
        
    }
    
    func setData(title: String)
    {
        lblSection.text = title.appending("     ").uppercased()
        lblSection.sectionRound(lblSection)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
}

//Mark: Class For Item Cell
class OrderItemCell: CustomCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgCell: UIImageView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblTaxInfo: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        
        
        self.lblName.textColor = UIColor.themeTextColor
        self.lblPrice.textColor = UIColor.themeTextColor
        
        self.lblDescription.textColor = UIColor.themeLightTextColor
        self.lblTaxInfo.textColor = UIColor.themeGreenColor

        
        self.lblName.font = FontHelper.textMedium(size: FontHelper.medium)
        self.lblPrice.font = FontHelper.textMedium(size: FontHelper.medium)
        self.lblDescription.font = FontHelper.textSmall(size: 12.0)
        self.lblTaxInfo.font = FontHelper.textSmall(size: 11.0)

        self.imgCell.setRound(withBorderColor: .clear, andCornerRadious: 8.0, borderWidth: 1.0)
        
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCellData(item:Item,parent:OrderItemListVC) {
        self.lblName.text = item.name
        self.lblPrice.text =  (item.price).toCurrencyString()
        self.lblDescription.text = item.details
        
       /* var taxItem : Int = 0
        var taxStore : Int = 0

        for obj in item.taxDetails{
            if obj.isTaxVisible{
                taxItem = taxItem + obj.tax
            }
        }

        for obj in StoreSingleton.shared.store.taxesDetails{
            if obj.isTaxVisible{
                taxStore = taxStore + obj.tax
            }
        }

        print(item.taxDetails)
        print(taxItem)

        if StoreSingleton.shared.store.isTaxInlcuded{
            if StoreSingleton.shared.store.isUseItemTax{
//                "OF_INCLUSIVE_TAX" = "of inclusive tax";
//                "OF_EXCLUSIVE_TAX" = "of exclusive tax";

                
                self.lblTaxInfo.text = "\(taxItem)% of inclusive tax"
            }else{
                self.lblTaxInfo.text = "\(taxStore)% of inclusive store tax"
            }
        }else{
            self.lblTaxInfo.text = "Exclusive of all taxes"
        }*/
        
        self.lblTaxInfo.text = ""

        if item.price! > 0.0 {
            lblPrice.text =  (item.price!).toCurrencyString()
        }else {
            var price:Double = 0.0
            for specification in item.specifications {
                for listItem in specification.list {
                    if listItem.isDefaultSelected
                    {
                        price = price + ((listItem.price) ?? 0.0)
                    }
                }
            }
            lblPrice.text =  price.toCurrencyString()
        }
        
        if item.imageUrl.isEmpty {
            self.imgCell.isHidden = true
        }else {
            self.imgCell.isHidden = false
//            self.imgCell.downloadedFrom(link: item.imageUrl[0])
            self.imgCell.downloadedFrom(link: Utility.getDynamicImageURL(width: self.imgCell.frame.width, height: self.imgCell.frame.height, imgUrl: item.imageUrl[0]), placeHolder: "placeholder", isFromCache: true, isIndicator: false, mode: .scaleAspectFit, isAppendBaseUrl: true, isFromResize: true)

        }
        
    }
    
    
}



