//
//  OrderProductVC.swift
//  Edelivery
//
//  Created by Trusha on 26/05/20.
//  Copyright © 2020 Elluminati. All rights reserved.
//

import UIKit

class OrderProductVC: BaseVC,RightDelegate {
    
    
    //MARK: - Outlets
    @IBOutlet weak var tblForItemsList: UITableView!
    @IBOutlet weak var heightBtnCart: NSLayoutConstraint!
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
    var arrItemsList = [ProductItem]()
    var selectedItemIndexPath:IndexPath? = nil
    var selectedItem:ProductItemsItem? = nil
    var isFromUpdateOrder:Bool = false
    
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
        self.filteredArrProductItemList.removeAll()
        self.filteredArrProductItemList.append(contentsOf: self.arrItemsList)
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: - custom set up
    
    func setLocalization() -> Void {
        
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        super.setNavigationTitle(title: "TXT_PRODUCTS".localized)
        self.setRightBarItem(isNative: false)
        self.tblForItemsList.backgroundColor = UIColor.themeViewBackgroundColor
        viewForSearchOverlay.backgroundColor = UIColor.clear
        viewForSearchItem.backgroundColor = UIColor.white
        btnApplySearch.backgroundColor = UIColor.themeButtonBackgroundColor
        btnApplySearch.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnApplySearch.setTitle("TXT_APPLY".localizedCapitalized, for: .normal)
        btnApplySearch.titleLabel?.font = FontHelper.textRegular()
        searchBarItem.placeholder = "TXT_ENTER_ITEM_NAME".localized
        searchBarItem.barTintColor = UIColor.white
        searchBarItem.backgroundImage = UIImage()
        tblForSearchItem.backgroundColor = UIColor.white
        viewForSearchOverlay.isHidden = true
        self.btnCart.setTitle("TXT_GO_TO_CART".localizedCapitalized, for: .normal)
        self.btnCart.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        self.btnCart.backgroundColor = UIColor.themeButtonBackgroundColor
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
            
          self.setRightBarItemImage(image: UIImage.init(named: "filterIcon")!)
        }else {
            self.setRightBarItemImage(image: UIImage.init())
        }
    }
    
    @IBAction func onClickBtnGoToCart(_ sender: Any) {
    }
    
    //MARK: -
    func reloadTableWithArray(array:[ProductItem]) {
        filteredArrProductItemList.removeAll()
        for productItem in array {
            if productItem.isProductFiltered {
                filteredArrProductItemList.append(productItem)
            }
        }
        tblForItemsList.reloadData()
    }
     
    func onClickRightButton() {
        searchBarItem.text = ""
        if !arrItemsList.isEmpty {
            if viewForSearchOverlay.isHidden {
                viewVisible()
            }else {
                viewGone()
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
            self.setRightBarItemImage(image: UIImage.init(named: "filterIcon")!)
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
                self.viewForSearchItem.superview!.layoutIfNeeded()
        })
        self.setRightBarItemImage(image: UIImage.init(named: "cancelBlackIcon")!)
        
    }
    
    @IBAction func onClickBtnApplySearch(_ sender: Any) {
        let searchText = searchBarItem.text ?? ""
        var isFound: Bool = false

        self.view.endEditing(true)
        if searchText.isEmpty() {
            self.reloadTableWithArray(array: arrItemsList)
        }
        else
        {
            var product_array:Array<ProductItem> = []
            self.arrItemsList.forEach({ (product) in
                if product.isProductFiltered {
                    let producttemp = ProductItem.init(dictionary: product.dictionaryRepresentation())
                    let itemArray = producttemp?.items?.filter({ (itemData) -> Bool in
                        let a = itemData.name?.lowercased().contains(searchText.lowercased())
                        return a!
                        
                    })
                    if((itemArray?.count) ?? 0 > 0)
                    {
                        producttemp?.items = itemArray
                        product_array.append(producttemp!)
                    }
                }
            })
            if product_array.isEmpty {
                Utility.showToast(message:"TXT_NO_SEARCH_ITEM_NOT_AVAILABLE".localized)
            }
            
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


extension OrderProductVC:UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate {
    
    //MARK: - UITableview delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchBar.text!)
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
            let item:ProductItemsItem = (self.filteredArrProductItemList[indexPath.section].items?[indexPath.row])!
            cell?.setCellData(item: item, parent: self)
            return cell!
        }else {
            var cell:ProductSearchCell? = tableView.dequeueReusableCell(withIdentifier: "cellForProductName", for: indexPath) as? ProductSearchCell
            if cell == nil {
                cell = ProductSearchCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cellForProductName")
            }
            cell?.setCellData(cellItem:arrItemsList[indexPath.row])
            return cell!
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblForItemsList {
            selectedItemIndexPath = indexPath;
            selectedItem = (self.filteredArrProductItemList[indexPath.section].items?[indexPath.row])!
            productName = (self.filteredArrProductItemList[indexPath.section].productDetail?.name)!
            self.isFromUpdateOrder = false
            goToProductSpecification()

            if isFromUpdateOrder {
                
            }else {
                
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
            sectionHeaderCell.setData(title: self.filteredArrProductItemList[section].productDetail!.name!)
            
            return sectionHeaderCell
        }
        return UIView.init()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    //MARK: USER DEFINE FUNCTION
        
    func goToProductSpecification() {
        
        let productSpecificationVC = EditOrderProductSpecificationVC.init(nibName: "EditOrderProductSpecification", bundle: nil)
        let selectedProductItem:ProductItemsItem = selectedItem!
        selectedProductItem.total_item_price = selectedItem?.price
        productSpecificationVC.selectedProductItem = selectedProductItem
        productSpecificationVC.productName = productName
        productSpecificationVC.productUniqueId = selectedItem?.unique_id
        productSpecificationVC.isFromUpdateOrder = self.isFromUpdateOrder
        self.navigationController?.pushViewController(productSpecificationVC, animated: true)
  
    }
}

//Mark: Class For Item Section
class OrderUserItemSection: UITableViewCell {
    
    @IBOutlet weak var lblSection: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        lblSection.backgroundColor = UIColor.themeSectionBackgroundColor
        lblSection.textColor = UIColor.themeButtonTitleColor
        lblSection.font = FontHelper.textRegular()
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

//Mark: Class For Item Cell
class OrderItemCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgCell: UIImageView!
    @IBOutlet weak var lblPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        self.lblName.textColor = UIColor.themeTextColor
        self.lblPrice.textColor = UIColor.themeTextColor
        self.lblDescription.textColor = UIColor.themeLightTextColor
        self.lblName.font = FontHelper.textMedium(size: FontHelper.labelRegular)
        self.lblPrice.font = FontHelper.textMedium(size: FontHelper.labelRegular)
        self.lblDescription.font = FontHelper.textSmall()
        self.imgCell.setRound(withBorderColor: .clear, andCornerRadious: 8.0, borderWidth: 1.0)
        self.imgCell.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCellData(item:ProductItemsItem,parent:OrderProductVC) {
        self.lblName.text = item.name
        self.lblPrice.text =  (item.price).toCurrencyString()
        self.lblDescription.text = item.details
        
        if item.price! > 0.0 {
            lblPrice.text =  (item.price!).toCurrencyString()
        }else {
            var price:Double = 0.0
            for specification in item.specifications! {
                for listItem in specification.list! {
                    if listItem.is_default_selected
                    {
                        price = price + ((listItem.price) ?? 0.0)
                    }
                }
            }
            lblPrice.text =  price.toCurrencyString()
        }
        
        if item.image_url!.isEmpty {
            self.imgCell.isHidden = true
        }else {
    
        }
    }
}



