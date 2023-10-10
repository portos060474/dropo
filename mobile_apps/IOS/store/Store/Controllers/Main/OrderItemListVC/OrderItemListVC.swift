//
//  ProductVC.swift
//  edelivery
//
//  Created by Jaydeep Vyas on 09/03/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

//
//  ItemsVC.swift
//  Store
//
//  Created by Jaydeep Vyas on 24/03/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit


class OrderItemListVC: BaseVC,RightDelegate
{
    
    //MARK: -
    //MARK: - Outlets
    @IBOutlet weak var tblForItemsList: UITableView!
    var arrItemsList = [ProductItem]() //List of Items Added by Store
    
    @IBOutlet weak var heightForSearchView: NSLayoutConstraint!
    var arrProductList = [ProductListItem]() /// Only used to pass the array of productlist to the next screen
    @IBOutlet weak var btnAddItem: UIButton!
    
    var selectedItemIndexPath:IndexPath? = nil
    
    @IBOutlet weak var imgEmpty: UIImageView!
    
    @IBOutlet weak var viewForSearchOverlay: UIView!
    @IBOutlet weak var viewForSearchItem: UIView!
    @IBOutlet weak var searchBarItem: UISearchBar!
    @IBOutlet weak var tblForSearchItem: UITableView!
    @IBOutlet weak var btnApplySearch: UIButton!
    var filteredArrProductItemList:[ProductItem] = [];
    //MARK: -
    //MARK: - View Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        delegateRight = self
        self.setLocalization()
        self.setRightBarItem(isNative: false)
        self.setRightBarItemImage(image: UIImage.init(named: "searchFilter")!)
        self.hideBackButtonTitle()
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.wsGetItemList()
    }
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - custom set up
    
    func setLocalization() -> Void
    {
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        super.setNavigationTitle(title: "TXT_ITEMS".localized)
        self.tblForItemsList.backgroundColor = UIColor.themeViewBackgroundColor
        /*search view*/
        viewForSearchOverlay.backgroundColor = UIColor.clear
        viewForSearchItem.backgroundColor = UIColor.white
        btnApplySearch.backgroundColor = UIColor.themeButtonBackgroundColor
        btnApplySearch.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnApplySearch.setTitle("TXT_APPLY".localizedUppercase, for: .normal)
        btnApplySearch.titleLabel?.font = FontHelper.regular()
        searchBarItem.barTintColor = UIColor.white
        searchBarItem.backgroundImage = UIImage()
        tblForSearchItem.backgroundColor = UIColor.white
        viewForSearchOverlay.isHidden = true
        
        
        // Tableview properties.
        self.tblForItemsList.rowHeight = UITableViewAutomaticDimension
        self.tblForItemsList.estimatedRowHeight = 120.0
        self.tblForItemsList.sectionHeaderHeight = UITableViewAutomaticDimension
        self.tblForItemsList.estimatedSectionHeaderHeight = 100
        
    }
    func updateUi(isUpdate:Bool = false)
    {
        imgEmpty.isHidden = isUpdate
        tblForItemsList.isHidden = !isUpdate
        btnAddItem.isHidden = false
    }
    //MARK: -
    //MARK: - Custom web service methods
    func wsGetItemList() -> Void
    {
        var dictParam = [String:Any]()
        dictParam[PARAMS.STORE_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.SERVER_TOKEN] = preferenceHelper.getSessionToken()
        
        Utility.showLoading()
        let alamofire = AlamofireHelper.init()
        alamofire.getResponseFromURL(url: WebService.WS_GET_ITEM_LIST, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            
            Utility.hideLoading()
            if Parser.isSuccess(response: response)
            {
                
                
                self.arrItemsList.removeAll()
                self.arrProductList.removeAll()
                self.filteredArrProductItemList.removeAll()
                
                let itemListResponse:ItemListResponse = ItemListResponse.init(fromDictionary: response)
                StoreSingleton.shared.store.currency = itemListResponse.currency
                
                let arrProduct:Array<ProductItem> = itemListResponse.products
               
                for product in arrProduct
                {
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
                    self.arrItemsList.append(product)
                    self.filteredArrProductItemList.append(product)
                    }
                }
                
                
                if (self.tblForItemsList != nil)
                {
                    self.reloadTableWithArray(array:self.filteredArrProductItemList)
                    self.tblForSearchItem.reloadData()
                    
                }
                if self.arrItemsList.count > 0
                {
                    self.updateUi(isUpdate:true)
                    
                }
                else
                {
                    self.updateUi(isUpdate:false)
                }
                
                
                
            }
            
        }
    }
    func reloadTableWithArray(array:[ProductItem])
    {
        filteredArrProductItemList.removeAll()
        for productItem in array
        {
            if productItem.isProductFiltered
            {
                filteredArrProductItemList.append(productItem)
            }
        }
        tblForItemsList.reloadData()
    }
    func onClickRightButton()
    {
        if viewForSearchOverlay.isHidden
        {
            viewVisible()
            
        }
        else
        {
            viewGone()
        }
    }
    
    //MARK: -
    //MARK: - button click methods
    @IBAction func onClickAddItem (_ sender: Any)
    {
        gotoAddItem()
    }
    
    func gotoAddItem()
    {
        let addItemObj = storyboard!.instantiateViewController(withIdentifier: "addItem") as! AddItemVC
        addItemObj.arrProductList = arrProductList
        addItemObj.isForEditItem = false
        DispatchQueue.main.async(execute: { () -> Void in
            self.present(addItemObj, animated: true, completion: nil)
        })
        
    }
   
    func gotoItemSpecifications(item:Item)
    {
        
        
        let itemSpecificationVc = storyboard!.instantiateViewController(withIdentifier: "itemSpecification") as! ItemSpecificationVC
        
        
        
        
        
        itemSpecificationVc.selectedItem = item
        DispatchQueue.main.async(execute: { () -> Void in
            self.present(itemSpecificationVc, animated: true, completion: nil)
        })
    }
    
    
    
    
    func viewGone()
    {
        let height = self.heightForSearchView.constant
        
        UIView.animate(withDuration: 0.5, animations: {
            self.heightForSearchView.constant = 0.0
            self.viewForSearchItem.superview?.layoutIfNeeded()
            
        }) { (completion) in
            self.viewForSearchOverlay.isHidden = true
            self.heightForSearchView.constant = height
            self.viewForSearchItem.superview?.layoutIfNeeded()
            self.setRightBarItemImage(image: UIImage.init(named: "searchFilter")!)
        }
    }
    func viewVisible()
    {
        viewForSearchOverlay.isHidden = false
        let height = self.heightForSearchView.constant
        self.heightForSearchView.constant = 0.0
        self.viewForSearchItem.superview?.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, animations:
            {
                self.heightForSearchView.constant = height
                self.viewForSearchItem.superview?.layoutIfNeeded()
        })
        self.setRightBarItemImage(image: UIImage.init(named: "cancel_white")!)
        
    }
    @IBAction func onClickBtnApplySearch(_ sender: Any) {
        let searchText = searchBarItem.text ?? ""
        if searchText.isEmpty
        {
            self.reloadTableWithArray(array: arrItemsList)
        }
        else
            
        {
            
            var product_array:Array<ProductItem> = [];
            self.arrItemsList.forEach({ (product) in
                
                
                if product.isProductFiltered
                {
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
            self.reloadTableWithArray(array: product_array)
        }
        viewGone()
    }
    
    
    
}
extension OrderItemListVC:UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate
{
    //MARK: -
    //MARK: - UITableview delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if tableView == tblForItemsList
        {
            if filteredArrProductItemList.count>0
            {
                return self.filteredArrProductItemList[section].items!.count
            }
            else
            {
                return 0
            }
        }
        else
        {
            return arrItemsList.count
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tblForItemsList
        {return self.filteredArrProductItemList.count}
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblForItemsList
        {
            let reuseIdentifire = "OrderItemCell"
            var cell:OrderItemCell?
            
            cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifire, for: indexPath) as? OrderItemCell
            
            
            if (cell == nil) {
                cell = UITableViewCell(style: .default, reuseIdentifier: reuseIdentifire) as? OrderItemCell
            }
            
            let item:Item = (self.filteredArrProductItemList[indexPath.section].items?[indexPath.row])!
            cell?.setCellData(item: item, parent: self)
            return cell!
        }
        else
        {
            
            var cell:ProductSearchCell? = tableView.dequeueReusableCell(withIdentifier: "cellForProductName", for: indexPath) as? ProductSearchCell
            if cell == nil
            {
                
                cell = ProductSearchCell(style: UITableViewCellStyle.default, reuseIdentifier: "cellForProductName")
            }
            
            cell?.setCellData(cellItem:arrItemsList[indexPath.row])
            return cell!
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblForItemsList
        {
            selectedItemIndexPath = indexPath;
           
        }
        else
        {
            arrItemsList[indexPath.row].isProductFiltered = !(arrItemsList[indexPath.row].isProductFiltered)
            tblForSearchItem.reloadData()
            
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == tblForItemsList
        {
            let  sectionHeaderCell = tableView.dequeueReusableCell(withIdentifier: "OrderUserItemSection") as! OrderUserItemSection
            sectionHeaderCell.setData(title: self.filteredArrProductItemList[section].name)
            
            return sectionHeaderCell
        }
        return UIView.init()
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        
    }
}
//Mark: Class For Item Section
class OrderUserItemSection: UITableViewCell
{
    
    @IBOutlet weak var lblSection: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        lblSection.backgroundColor = UIColor.themeSectionBackgroundColor
        lblSection.textColor = UIColor.themeTitleColor
        lblSection.font = FontHelper.regular()
        
    }
    
    func setData(title: String)
        
    {
        lblSection.text = title.appending("     ")
        lblSection.sectionRound(lblSection)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
}

//Mark: Class For Item Cell
class OrderItemCell: UITableViewCell
{
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgCell: UIImageView!
    @IBOutlet weak var lblPrice: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        
        self.lblName.textColor = UIColor.themeTextColor
        self.lblPrice.textColor = UIColor.themeTextColor
        
        self.lblDescription.textColor = UIColor.themeLightTextColor
        
        self.lblName.font = FontHelper.medium()
        self.lblPrice.font = FontHelper.medium()
        
        self.lblDescription.font = FontHelper.small()
        self.imgCell.setRound(withBorderColor: .clear, andCornerRadious: 8.0, borderWidth: 1.0)
       
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCellData(item:Item,parent:OrderItemListVC)
    {
        self.lblName.text = item.name
        self.lblPrice.text =  StoreSingleton.shared.store.currency + " " + String(item.price)
        self.lblDescription.text = item.details
        if item.imageUrl.isEmpty
        {
        }
        else
        {
            self.imgCell.downloadedFrom(link: item.imageUrl[0])
        }
       
    }
   
    
}



