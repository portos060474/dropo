//
//  ItemsVC.swift
//  Store
//
//  Created by Jaydeep Vyas on 24/03/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class ItemListVC: BaseVC {

    //MARK: -
    //MARK: - Outlets
    
    @IBOutlet weak var tblForItemsList: UITableView!
    var arrItemsList = [ProductItem]() //List of Items Added by Store
    
    @IBOutlet weak var heightForSearchView: NSLayoutConstraint!
    var arrProductList = [ProductListItem]() /// Only used to pass the array of productlist to the next screen
    
    var selectedItemIndexPath:IndexPath? = nil
    
    @IBOutlet weak var imgEmpty: UIImageView!
    @IBOutlet weak var viewForSearchOverlay: UIView!
    @IBOutlet weak var viewForSearchItem: UIView!
    @IBOutlet weak var searchBarItem: UISearchBar!
    @IBOutlet weak var tblForSearchItem: UITableView!
    @IBOutlet weak var btnApplySearch: UIButton!
    
    var filteredArrProductItemList:[ProductItem] = [];
    static var isCallGetItemAPI : Bool = true
    let btnFilter = UIButton.init(type: .custom)
    var arrTax:[TaxesDetail] = [];

    
    //MARK: -
    //MARK: - View Life Cycl

    @IBOutlet weak var viewForAddMenuOverLay: UIVisualEffectView!
    @IBOutlet weak var viewForAddProduct: UIView!
    @IBOutlet weak var lblAddProduct: UILabel!
    @IBOutlet weak var viewForFloating: UIView!
    @IBOutlet weak var btnFloatingButton: UIButton!
    @IBOutlet weak var viewForAddItem: UIView!
    @IBOutlet weak var lblAddItem: UILabel!
    var sectionIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUIAccordingToTheme()
        self.setLocalization()
//        self.btnRight?.setImage(UIImage.init(named: "filterIcon")!.imageWithColor(color: .themeColor), for: .normal)

        btnFilter.setImage(UIImage.init(named: "filterIcon")?.imageWithColor(color: .themeColor), for: .normal)
        btnFilter.addTarget(self, action: #selector(onClickRightButton), for: .touchUpInside)
        self.setRightBarButton(button: btnFilter);
//
//        self.setRightBarButton(button: btnRight)
//        self.btnLeft?.isHidden = true
        
        tblForItemsList.tableFooterView = UIView.init(frame: CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: UIScreen.main.bounds.width, height: 0)))
        tblForItemsList.showsVerticalScrollIndicator = false
        for s in searchBarItem.subviews[0].subviews {
            if s is UITextField {
                s.backgroundColor = UIColor.themeSearchBackgroundColor
                (s as! UITextField).textColor = UIColor.themeTextColor
            }
        }
        
    }
    
    override func updateUIAccordingToTheme() {
        setMenuButton()
    }
    
    @IBAction func onClickBtnFloatButton(_ sender: Any) {
         if viewForAddProduct.isHidden
         { viewAddMenu()}
         else{hideAddMenu()}
    }
    
    @objc func onClickRightButton() {
        openProductFilterDialog()
    }
//    override func btnRightTapped(_ btn: UIButton = UIButton()) {
//        searchBarItem.text = ""
//        self.openProductFilterDialog()
////        if viewForSearchOverlay.isHidden {
////            viewVisible()
////
////        }else {
////            viewGone()
////        }
//    }
    
    func viewAddMenu() {
//        self.btnRight?.isEnabled = false
        viewForAddMenuOverLay.isHidden = false
        viewForAddProduct.isHidden = false
        if StoreSingleton.shared.store.isStoreEditItem {
            viewForAddItem.isHidden = false
        }else {
            viewForAddItem.isHidden = true
        }
        
        self.viewForAddProduct.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
        self.viewForAddProduct.alpha = 0.0
        self.viewForAddItem.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
        self.viewForAddItem.alpha = 0.0
        UIView.animate(withDuration: 0.4,
                       animations: {
                
                self.btnFloatingButton.transform = CGAffineTransform.init(rotationAngle: 45);
                self.viewForAddProduct.alpha = 1.0
                self.viewForAddProduct.transform = CGAffineTransform.identity
                self.viewForAddItem.transform = CGAffineTransform.identity
                self.viewForAddItem.alpha = 1.0
        }, completion: { _ in
       
        })
    }
    func hideAddMenu() {
        viewForAddMenuOverLay.isHidden = true
//        self.btnRight?.isEnabled =  true
        
        self.viewForAddProduct.transform =  CGAffineTransform.identity
        self.viewForAddProduct.alpha = 1.0
        self.viewForAddItem.transform = CGAffineTransform.identity
        self.viewForAddItem.alpha = 1.0
        UIView.animate(withDuration: 0.4,
                       animations: {
                self.viewForAddProduct.alpha = 0.0
                self.viewForAddProduct.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                self.btnFloatingButton.transform = CGAffineTransform.init(rotationAngle: 0);
                self.viewForAddItem.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                self.viewForAddItem.alpha = 0.0
                
            },completion: { _ in
                if self.viewForAddProduct != nil{
                    self.viewForAddProduct.isHidden = true
                    self.viewForAddItem.isHidden = true
                }
        })
        
    }
   
    @IBAction func onClickBtnAddProduct(_ sender: Any) {
        self.performSegue(withIdentifier: SEGUE.ITEM_TO_ADD_PRODUCT, sender: self)
    }
    @IBAction func onClickBtnAddItem(_ sender: Any) {
        self.gotoAddItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        if ItemListVC.isCallGetItemAPI{
            self.wsGetItemList()
        }
        self.tabBarController?.tabBar.tintColor = UIColor.black
                self.tabBarController?.tabBar.barTintColor = UIColor.themeViewBackgroundColor
        if #available(iOS 10.0, *) {
            self.tabBarController?.tabBar.unselectedItemTintColor = UIColor.black
        } else {
            
        }
        viewForAddItem.isHidden = true
        viewForAddProduct.isHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.isHidden = true
        if !viewForAddMenuOverLay.isHidden {
        self.hideAddMenu()
        }
        
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewForSearchItem.setShadow(shadowColor: UIColor.gray.cgColor, shadowOffset: CGSize.zero, shadowOpacity: 0.8, shadowRadius: 0.5)
        viewForAddProduct.setShadow(shadowColor: UIColor.gray.cgColor, shadowOffset: CGSize.zero, shadowOpacity: 0.8, shadowRadius: 0.5)
        viewForAddItem.setShadow(shadowColor: UIColor.gray.cgColor, shadowOffset: CGSize.zero, shadowOpacity: 0.8, shadowRadius: 0.5)
        viewForAddProduct.setRound(withBorderColor: .clear, andCornerRadious: 25, borderWidth: 1.0)
        viewForAddItem.setRound(withBorderColor: .clear, andCornerRadious: 25, borderWidth: 1.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: - custom set up
    
    func setLocalization() -> Void {
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        self.viewForAddMenuOverLay.backgroundColor = UIColor.themeViewBackgroundColor.withAlphaComponent(0.5)
        
        
        self.tblForItemsList.backgroundColor = UIColor.themeViewBackgroundColor
        /*search view*/
        viewForSearchOverlay.backgroundColor = UIColor.clear
        viewForSearchItem.backgroundColor = UIColor.themeViewBackgroundColor
        btnApplySearch.backgroundColor = UIColor.themeColor
        btnApplySearch.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnApplySearch.setTitle("TXT_APPLY".localizedUppercase, for: .normal)
        btnApplySearch.titleLabel?.font = FontHelper.buttonText()
        searchBarItem.placeholder = "TXT_ENTER_ITEM_NAME".localized
        searchBarItem.barTintColor = UIColor.themeViewBackgroundColor
        searchBarItem.backgroundImage = UIImage()
        tblForSearchItem.backgroundColor = UIColor.themeViewBackgroundColor
        viewForSearchOverlay.isHidden = true
        self.setNavigationTitle(title: "TXT_ITEMS".localized)
        btnFloatingButton.backgroundColor = .themeColor
        btnFloatingButton.layer.cornerRadius = btnFloatingButton.frame.height/2.0
        
        viewForAddProduct.backgroundColor = UIColor.themeColor
        lblAddProduct.textColor  = UIColor.themeButtonTitleColor
        lblAddProduct.text = "TXT_ADD_PRODUCT".localizedCapitalized
        lblAddProduct.font = FontHelper.textRegular(size: 16.0)
        viewForAddProduct.isHidden = true
        
        viewForAddItem.backgroundColor = UIColor.themeColor
        lblAddItem.textColor  = UIColor.themeButtonTitleColor
        lblAddItem.text = "TXT_ADD_ITEM".localizedCapitalized
        lblAddItem.font = FontHelper.textRegular(size: 16.0)
        viewForAddItem.isHidden = true
        
        viewForFloating.backgroundColor = UIColor.clear
        // Tableview properties.
        self.tblForItemsList.rowHeight = UITableView.automaticDimension
        self.tblForItemsList.estimatedRowHeight = 130.0
        
        self.updateUi(isUpdate:false)

        
    }
    func updateUi(isUpdate:Bool = false) {
        imgEmpty.isHidden = isUpdate
        tblForItemsList.isHidden = !isUpdate
        btnFloatingButton.isHidden = false
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
    //MARK: -
    //MARK: - Custom web service methods
    
    func wsGetItemList() -> Void {
        var dictParam = [String:Any]()
        dictParam[PARAMS.STORE_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.SERVER_TOKEN] = preferenceHelper.getSessionToken()
        print("\(WebService.WS_GET_ITEM_LIST) parameters : \(dictParam)")

        Utility.showLoading()
        let alamofire = AlamofireHelper.init()
        alamofire.getResponseFromURL(url: WebService.WS_GET_ITEM_LIST, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
        
            print(Utility.conteverDictToJson(dict: response))
            Utility.hideLoading()
            if Parser.isSuccess(response: response) {
                self.arrItemsList.removeAll()
                self.arrProductList.removeAll()
                self.filteredArrProductItemList.removeAll()
                let itemList:ItemListResponse = ItemListResponse.init(fromDictionary: response)
                var arrProduct:Array<ProductItem> = itemList.products
                
                self.arrTax = itemList.taxesDetails

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
                    self.arrItemsList.append(product)
                    self.filteredArrProductItemList.append(product)
                     self.arrProductList.append(ProductListItem.init(fromDictionary: product.toDictionary()))
                }
                
                DispatchQueue.main.async {
                    
                    if (self.tblForItemsList != nil) {
                        self.reloadTableWithArray(array:self.filteredArrProductItemList)
                        self.tblForSearchItem.reloadData()
                        
                    }
                    if self.arrItemsList.count > 0 {
    //                    self.btnRight?.isHidden = false
                        self.updateUi(isUpdate:true)
                        
                    }
                    else {
    //                     self.btnRight?.isHidden = true
                        self.updateUi(isUpdate:false)
                    }
                }

            }
        }
    }
    
    func reloadTableWithArray(array:[ProductItem]) {
        filteredArrProductItemList.removeAll()
            for productItem in array {
                if productItem.isProductFiltered {
                    filteredArrProductItemList.append(productItem)
                }
            }
        tblForItemsList.reloadData()
        if filteredArrProductItemList.count > 0{
            self.updateUi(isUpdate:true)
        }else{
            self.updateUi(isUpdate:false)
        }
    }

    
    //Storeapp //Sorting Sequence no wise

   /* func reloadTableWithArray(array:[ProductItem]) {
        var sortedArray = [Item]()
        var arrayfiltered = [ProductItem]()

        filteredArrProductItemList.removeAll()
        
        let SS = array.sorted{ $0.sequence_number < $1.sequence_number }
        filteredArrProductItemList.append(contentsOf: SS)
        arrayfiltered.append(contentsOf: SS)

        
        for i in 0...arrayfiltered.count-1 {
            if arrayfiltered[i].isProductFiltered {
                sortedArray = arrayfiltered[i].items.sorted{ $0.sequence_number < $1.sequence_number }
                filteredArrProductItemList[i].items.removeAll()
                filteredArrProductItemList[i].items.append(contentsOf: sortedArray)
            }
        }

        tblForItemsList.reloadData()
    }*/
  
    //MARK: -
    //MARK: - button click methods
 
    
    func gotoAddItem() {
        let addItemObj = storyboard!.instantiateViewController(withIdentifier: "addItem") as! AddItemVC
        addItemObj.arrProductList = arrProductList
        addItemObj.arrTax = self.arrTax
        addItemObj.isForEditItem = false
        DispatchQueue.main.async(execute: { () -> Void in
            self.navigationController?.pushViewController(addItemObj, animated: true)
        })
    }
    
    func gotoEditItem() {
        let addItemObj = storyboard!.instantiateViewController(withIdentifier: "addItem") as! AddItemVC
       
        if self.arrItemsList[selectedItemIndexPath!.section].items.count > 0{
            addItemObj.isForEditItem = true

            addItemObj.productCategory = self.arrItemsList[selectedItemIndexPath!.section].name!;
            addItemObj.selectedProductItem = self.arrProductList[(selectedItemIndexPath?.section)!]
            addItemObj.itemDetail = self.arrItemsList[selectedItemIndexPath!.section].items[selectedItemIndexPath!.row]
            
            for obj in self.arrTax{
                obj.isTaxSelected = false
            }
            for obj in self.arrTax{
                for i in self.arrItemsList[selectedItemIndexPath!.section].items[selectedItemIndexPath!.row].taxDetails{
//                for i in self.arrItemsList[selectedItemIndexPath!.section].items[selectedItemIndexPath!.row].itemTaxes{
                    if i.id == obj.id{
                        obj.isTaxSelected = true
                    }
                }
            }
            addItemObj.arrTax = self.arrTax

        }
        
        if addItemObj.itemDetail != nil{
        DispatchQueue.main.async(execute: { () -> Void in
            self.navigationController?.pushViewController(addItemObj, animated: true)
        })}
    }
    
    func gotoItemSpecifications(item:Item) {
        let itemSpecificationVc = self.storyboard!.instantiateViewController(withIdentifier: "itemSpecification") as! ItemSpecificationVC
        itemSpecificationVc.selectedItem = item
        DispatchQueue.main.async(execute: { () -> Void in
            self.navigationController?.pushViewController(itemSpecificationVc, animated: true)
        })
    }
    
    func viewGone(showMessage: Bool = false) {
        //Storeapp
        let height = self.heightForSearchView.constant
  
        UIView.animate(withDuration: 0.5, animations: {
            self.heightForSearchView.constant = 0.0
            self.viewForSearchItem.superview?.layoutIfNeeded()
            
        }) { (completion) in
            self.viewForSearchOverlay.isHidden = true
            self.heightForSearchView.constant = height
            self.viewForSearchItem.superview?.layoutIfNeeded()
//            self.btnRight?.setImage(UIImage.init(named: "filterIcon")!.imageWithColor(color: .themeColor), for: .normal)
            
            if showMessage {
                Utility.showToast(message: "TXT_NO_SEARCH_ITEM_NOT_AVAILABLE".localized);
            }
         }
    }
    
    func viewVisible() {

        viewForSearchOverlay.isHidden = false
        var height = self.heightForSearchView.constant
        self.heightForSearchView.constant = 0.0
        self.viewForSearchItem.superview?.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, animations: {
                let landscape = UIDevice.current.orientation
//                if landscape.isLandscape {
//                    height = height+40
//                }
                self.heightForSearchView.constant = height
                self.viewForSearchItem.superview?.layoutIfNeeded()
        })
//        self.btnRight?.setImage(UIImage.init(named: "cancelBlackIcon")?.imageWithColor(color: .themeColor), for: .normal)
        
        
    }
    @IBAction func onClickBtnApplySearch(_ sender: Any) {
        self.view.endEditing(true)
        var isFound: Bool = false
        let searchText = searchBarItem.text ?? ""
        if searchText.isEmpty() {
            self.reloadTableWithArray(array: arrItemsList)
        }else
             {
            
            var product_array:Array<ProductItem> = [];
            self.arrItemsList.forEach({ (product) in
                
                
                if product.isProductFiltered {
                    let producttemp = ProductItem.init(fromDictionary: product.toDictionary())
                    
                    
                    let itemArray = producttemp.items?.filter({ (itemData) -> Bool in
                        let a = itemData.name?.lowercased().contains(searchText.lowercased())
                        return a!;
                        
                    })
                    if((itemArray?.count) ?? 0 > 0)
                    {
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
extension ItemListVC:UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate {
    //MARK: -
    //MARK: - UITableview delegate

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if tableView == tblForItemsList {
                if filteredArrProductItemList.count>0
                    {
                        if self.filteredArrProductItemList[section].items!.count == 0{
                            return 1
                        }else{
                            return self.filteredArrProductItemList[section].items!.count
                        }
                }
                else {
                    return 0
                }
        }else {
            if arrItemsList.count == 0{
                return 0
            }
            return arrItemsList.count
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tblForItemsList {return self.filteredArrProductItemList.count}
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblForItemsList {
        let reuseIdentifire = "ItemCell"
        var cell:ItemCell?
        
        cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifire, for: indexPath) as? ItemCell
        
        
        if (cell == nil) {
            cell = UITableViewCell(style: .default, reuseIdentifier: reuseIdentifire) as? ItemCell
        }
            cell?.selectionStyle = .none
        if self.filteredArrProductItemList[indexPath.section].items!.count > 0{
            let item:Item = (self.filteredArrProductItemList[indexPath.section].items?[indexPath.row])!
            cell?.customViewForNotFound.isHidden = true
            cell?.cardView.isHidden = false
            
            cell?.btnSpecifications.isHidden = false
            cell?.swInStock.isHidden = false
            cell?.setCellData(item: item, parent: self)
        }else{
            cell?.cardView.isHidden = true
            cell?.customViewForNotFound.isHidden = false
            cell?.lblNoItemsFound.text = "TXT_NO_ITEMS_FOUND".localizedCapitalized
            cell?.lblName.text = "TXT_NO_ITEMS_FOUND".localizedCapitalized
            cell?.lblPrice.text = ""
            cell?.btnSpecifications.isHidden = true
            cell?.lblDescription.text = ""
            cell?.lblInStock.text = ""
            cell?.swInStock.isHidden = true
        
        }
            
        return cell!
        }else {
            
            var cell:ProductSearchCell? = tableView.dequeueReusableCell(withIdentifier: "cellForProductName", for: indexPath) as? ProductSearchCell
            if cell == nil {
                
                cell = ProductSearchCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cellForProductName")
            }
            cell?.selectionStyle = .none

            if arrItemsList.count > 0{
                
                cell?.setCellData(cellItem:arrItemsList[indexPath.row])
                
            }else{
               
                cell?.lblProductName.text = "TXT_NO_ITEMS_FOUND".localizedCapitalized
                
                
            }
            return cell!
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblForItemsList {
            //Store selectedItemIndexPath Bug
            selectedItemIndexPath = indexPath;
            gotoEditItem()
        }else {
            arrItemsList[indexPath.row].isProductFiltered = !(arrItemsList[indexPath.row].isProductFiltered)
            tblForSearchItem.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == tblForItemsList {
            sectionIndex = section
            let  sectionHeaderCell = tableView.dequeueReusableCell(withIdentifier: "itemSection") as! ItemSection
            sectionHeaderCell.setData(title:self.filteredArrProductItemList[section].name)
            let tap = UITapGestureRecognizer(target: self, action:#selector(editProductEvent(gesture:)))
            tap.view?.tag = section
            sectionHeaderCell.addGestureRecognizer(tap)
            sectionHeaderCell.tag = section
            sectionHeaderCell.layoutIfNeeded()
            return sectionHeaderCell
        }
        return UIView.init()
    }
    
    
    @objc func editProductEvent(gesture:UITapGestureRecognizer) {
//        let product = self.filteredArrProductItemList[0] as! Product
        
        let addProductObj = storyboard!.instantiateViewController(withIdentifier: "addProduct") as! AddProductVC
        addProductObj.productDetail =  self.filteredArrProductItemList[gesture.view!.tag]
        addProductObj.isForEditProduct = true
        self.navigationController?.pushViewController(addProductObj, animated: true)
//        DispatchQueue.main.async(execute: { () -> Void in
//            self.present(addProductObj, animated: true, completion: nil)
//        })
    }

}
//Mark: Class For Item Section
class ItemSection: CustomCell {
    
    @IBOutlet weak var lblSection: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        lblSection.backgroundColor = UIColor.themeViewBackgroundColor
        lblSection.textColor = UIColor.themeColor
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
class ItemCell: CustomCell {
    
    @IBOutlet weak var cardView: CustomCardView!
    
    @IBOutlet weak var lblNoItemsFound: UILabel!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnSpecifications: UIButton!
    @IBOutlet weak var lblDescription: UILabel!

    @IBOutlet weak var lblInStock: UILabel!
    @IBOutlet weak var swInStock: UISwitch!
    @IBOutlet weak var btnSwitch: UIButton!

    
    @IBOutlet weak var lblSaprator: CustomLabelSeprator!
    
    @IBOutlet weak var customViewForNotFound: CustomCardView!
    @IBOutlet weak var stkForItems: UIStackView!
    @IBOutlet weak var lblPrice: UILabel!
    var product:Item? = nil
    var parent:ItemListVC? = nil
    var attrs = [
        convertFromNSAttributedStringKey(NSAttributedString.Key.font) : FontHelper.textSmall(),
        convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor.themeColor,
        convertFromNSAttributedStringKey(NSAttributedString.Key.underlineStyle) : 1] as [String : Any]
    
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lblNoItemsFound.textColor = UIColor.themeTextColor
        self.lblName.textColor = UIColor.themeTextColor
        self.lblPrice.textColor = UIColor.themeTextColor
        swInStock.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        self.lblDescription.textColor = UIColor.themeLightTextColor
        
        self.btnSpecifications.setTitleColor(UIColor.themeTextColor, for: .normal)
        
        self.lblNoItemsFound.font = FontHelper.textMedium(size:FontHelper.labelRegular)
        self.lblName.font = FontHelper.textMedium(size:FontHelper.labelRegular)
        self.lblPrice.font = FontHelper.textMedium(size:FontHelper.labelRegular)
        
        self.lblDescription.font = FontHelper.labelSmall()
        self.btnSpecifications.titleLabel?.font = FontHelper.textSmall()
        
        
        self.lblInStock.textColor = UIColor.themeTextColor
        self.lblInStock.font = FontHelper.textSmall()
        self.lblInStock.text = "TXT_IN_STOCK".localized
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func updateStock(_ sender: UISwitch) {
        wsUpdateStockItem()
    }
    func setCellData(item:Item,parent:ItemListVC) {
        self.parent = parent
        self.product = item
        self.lblName.text = item.name
        self.lblPrice.text = (item.price).toCurrencyString()
        
       
        
//        let buttonTitleStr = NSMutableAttributedString(string:"TXT_SPECIFICATIONS".localized, attributes:convertToOptionalNSAttributedStringKeyDictionary(attrs))
//    self.btnSpecifications.setAttributedTitle(buttonTitleStr, for: .normal)
        self.btnSpecifications.setTitle("  " + "TXT_SPECIFICATIONS".localized + "  ", for: .normal)
        self.btnSpecifications.setImage(UIImage(named: "specificationIcon")?.imageWithColor(color: .themeColor), for: .normal)
        self.btnSwitch.addTarget(self, action: #selector(onClickSwitch(_sender:)), for: .touchUpInside)
        
        self.lblDescription.text = item.details
        self.swInStock.onTintColor = .themeColor
        if (item.isItemInStock)! {
            self.lblInStock.text = "TXT_IN_STOCK".localized
//            self.swInStock.setOn(true, animated: true)
            self.swInStock.isOn = true
        }else {
            self.lblInStock.text = "TXT_OUT_OF_STOCK".localized
//            self.swInStock.setOn(false, animated: true)
            self.swInStock.isOn = false
        }
    }
    
    @objc func onClickSwitch(_sender:UIButton){
//        _sender.isSelected = !_sender.isSelected
        self.swInStock.isOn = !self.swInStock.isOn
        DispatchQueue.main.async {
            self.wsUpdateStockItem()
        }
    }
    
    @IBAction func onClickSpecifications(sender:Any) {
        parent?.gotoItemSpecifications(item: product!)
    }
    
    func wsUpdateStockItem() {
        Utility.showLoading();
        let dictParam : [String : Any] = [PARAMS.ITEM_ID : product!.id, PARAMS.IS_ITEM_IN_STOCK: swInStock.isOn]
        
        let alamoFire:AlamofireHelper = AlamofireHelper.init()
        alamoFire.getResponseFromURL(url: WebService.WS_IS_ITEM_IN_STOCK, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response) {
                self.product?.isItemInStock = self.swInStock.isOn
            }else {
                self.product?.isItemInStock = !self.swInStock.isOn
            }
            self.parent?.tblForItemsList.reloadData()
            
        }
        
    }
}


class ProductSearchCell: CustomCell {
    
    //MARK:- OUTLET
    
    
    @IBOutlet weak var imgButtonType: UIButton!
    @IBOutlet weak var lblProductName: UILabel!
    
    //MARK:- LIFECYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor =  UIColor.themeViewBackgroundColor;
        self.backgroundColor = UIColor.themeViewBackgroundColor
        
        lblProductName.font = FontHelper.textSmall()
        lblProductName.textColor = UIColor.themeTextColor
        imgButtonType.setImage( UIImage.init(named: "checked")?.imageWithColor(color: .themeColor)
            , for: UIControl.State.selected)
        
        imgButtonType.setImage( UIImage.init(named: "unchecked")
            , for: UIControl.State.normal)
    }
    //MARK:- SET CELL DATA
    func setCellData(cellItem:ProductItem) {
        
        lblProductName.text = cellItem.name
        imgButtonType.isSelected = cellItem.isProductFiltered
        
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
