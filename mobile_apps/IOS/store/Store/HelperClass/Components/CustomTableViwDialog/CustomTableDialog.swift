//
//  CustomTableDialog.swift
// Edelivery Store
//
//  Created by Jaydeep Vyas on 24/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
enum CustomCellIdentifiers {
    static let dialogForCustomTable = "dialogForCustomTable"
    static let cellForCountry = "cellForCountry"
    static let cellForCity = "cellForCity"
    static let cellForStoreType = "cellForStoreType"
    static let cellForProductList = "cellForProductList"
    static let cellForSpecificationGroup = "cellForSpecificationGroup"
    static let cellForBankName = "cellForBankName"
}
class CustomTableDialog: CustomDialog, UITableViewDelegate, UITableViewDataSource,keyboardWasShownDelegate, keyboardWillBeHiddenDelegate {
    
    deinit {
        tableForItems.removeObserver(self, forKeyPath: "contentSize")
    }
    
    //MARK:- Outlets
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableForItems: UITableView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var heightOfTableView: NSLayoutConstraint!
    @IBOutlet weak var constraintBottomSuperView: NSLayoutConstraint!
    @IBOutlet weak var searchBarItem: UISearchBar!

    //MARK:- Variables
    var isSearch = false
    var arrForItemList:NSMutableArray = [];
    var arrFilterItemList:NSMutableArray = [];
    var cellIdentifier = CustomCellIdentifiers.cellForCity;
    var onItemSelected : ((_ selectedItem:Any) -> Void)? = nil
    var keyBoardHeight: CGFloat = 0
    var isKeyboardShow = false
    
    override func awakeFromNib() {
        lblTitle.font = FontHelper.textMedium(size: 17.0)
        lblTitle.textColor = UIColor.themeTextColor
//        btnClose.titleLabel?.font = FontHelper.textRegular()
//        btnClose.setTitleColor(UIColor.themeTextColor, for: .normal)
        self.backgroundColor = UIColor.themeOverlayColor
        
        searchBarItem.backgroundImage = UIImage()
        searchBarItem.barTintColor = UIColor.themeTextColor
        searchBarItem.backgroundColor = UIColor.themeViewBackgroundColor
        searchBarItem.layer.borderColor = UIColor.themeLightLineColor.cgColor
        searchBarItem.layer.borderWidth = 1.0
        searchBarItem.tintColor = UIColor.themeTextColor
        searchBarItem.setTextColor(color: UIColor.themeTextColor)
        for s in searchBarItem.subviews[0].subviews {
            if s is UITextField {
               s.backgroundColor = UIColor.white
               (s as! UITextField).font = FontHelper.textRegular(size: 12)
            }
        }
        
        tableForItems.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    public static func showCustomTableDialog(withDataSource:NSMutableArray = [],cellIdentifier:String, title:String ) -> CustomTableDialog {
        let view = UINib(nibName: CustomCellIdentifiers.dialogForCustomTable, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomTableDialog
        view.setShadow()
        view.tableForItems.delegate = view;
        view.tableForItems.dataSource = view;
        view.arrForItemList = withDataSource
        view.cellIdentifier = cellIdentifier
        view.lblTitle.text = title.localizedCapitalized
        view.searchBarItem.superview?.isHidden = true
        switch view.cellIdentifier {
        case CustomCellIdentifiers.cellForCountry:
            view.tableForItems.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier:cellIdentifier)
            view.searchBarItem.placeholder = "TXT_SEARCH_COUNTRY".localizedCapitalized
            view.searchBarItem.superview?.isHidden = false
            break;
        case CustomCellIdentifiers.cellForCity:
            view.tableForItems.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
            view.searchBarItem.placeholder = "TXT_SEARCH_CITY".localizedCapitalized
            view.searchBarItem.superview?.isHidden = false
            break;
        case CustomCellIdentifiers.cellForStoreType:
            view.tableForItems.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
            break;
        case CustomCellIdentifiers.cellForSpecificationGroup :
             view.tableForItems.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        case CustomCellIdentifiers.cellForProductList :
            view.tableForItems.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        case CustomCellIdentifiers.cellForBankName :
            view.tableForItems.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        default:
            print("Invalid Cell")
        }

        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame
        APPDELEGATE.window?.addSubview(view)
        APPDELEGATE.window?.bringSubviewToFront(view);
        view.animationBottomTOTop(view.alertView)

        view.registerForKeyboardObserver()
        view.delegatekeyboardWasShown = view
        view.delegatekeyboardWillBeHidden = view
        
        view.updateUIAccordingToTheme()

        return view;
    }
    
    override func keyboardWasShown(notification: NSNotification)
    {
        isKeyboardShow = true
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        var aRect : CGRect = self.frame
        aRect.size.height -= keyboardSize!.height
        
        keyBoardHeight = keyboardSize!.height
        
        constraintBottomSuperView.constant = 0.0

        UIView.animate(withDuration: 1.0) {
            self.constraintBottomSuperView.constant = -keyboardSize!.height
//            let tempHeight = self.frame.size.height - keyboardSize!.height - 250
//            if self.tableForItems.contentSize.height > (tempHeight) {
//                self.heightOfTableView.constant = tempHeight
//            } else {
//                self.heightOfTableView.constant = self.tableForItems.contentSize.height
//            }
        } completion: { _ in
            self.tableForItems.reloadData()
        }
    }

    override func keyboardWillBeHidden(notification: NSNotification)
    {
        isKeyboardShow = false
        //Once keyboard disappears, restore original positions
        UIView.animate(withDuration: 1.0) {
            self.constraintBottomSuperView.constant = 0.0
            DispatchQueue.main.async {
                self.tableForItems.reloadData()
            }
        }
        self.endEditing(true)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if isKeyboardShow {
            let tempHeight = self.frame.size.height - keyBoardHeight - 250

            if tableForItems.contentSize.height + 50 <= tempHeight {
                heightOfTableView.constant = tableForItems.contentSize.height
            }else{
                heightOfTableView.constant = tempHeight
            }
        } else {
            if tableForItems.contentSize.height + 50 <= UIScreen.main.bounds.height - 250 {
                heightOfTableView.constant = tableForItems.contentSize.height
            }else{
                heightOfTableView.constant = UIScreen.main.bounds.height - 250
            }
        }
    }
    
    public override func layoutSubviews() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.alertView.applyTopCornerRadius()
        }
    }
    
    fileprivate func extractedFunc(_ item: Any) {
        self.onItemSelected!(item)
    }
    
    override func updateUIAccordingToTheme() {
        btnClose.setImage(UIImage(named: "cross")?.imageWithColor(color: .themeColor), for: .normal)

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item: Any = {
            if isSearch {
                return arrFilterItemList.object(at: indexPath.row)
            }
           return arrForItemList.object(at: indexPath.row)
        }()
        
        if self.onItemSelected != nil {
            extractedFunc(item)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            return arrFilterItemList.count
        }
        if arrForItemList.count > 0 {
            return arrForItemList.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell:CustomTableCell? = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as? CustomTableCell
        if cell == nil {
            cell = CustomTableCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellIdentifier)
        }
        
        let item: Any = {
            if isSearch {
                return arrFilterItemList.object(at: indexPath.row)
            }
           return arrForItemList.object(at: indexPath.row)
        }()
        
        switch cellIdentifier {
        case CustomCellIdentifiers.cellForCountry:
            cell?.setCountryCell(countryData: item as! Country)
            break;
        case CustomCellIdentifiers.cellForCity:
            cell?.setCityCell(cityData:item as! City)
            break;
        case CustomCellIdentifiers.cellForStoreType:
            cell?.setStoreTypeCell(storeTypeData:item as! Delivery)
            break;
        case CustomCellIdentifiers.cellForSpecificationGroup:
            cell?.setGroupCell(groupData:item as! ItemSpecification)
            break;
        case CustomCellIdentifiers.cellForProductList:
            cell?.setProductCell(productData:item as! ProductListItem)
        case CustomCellIdentifiers.cellForBankName:
            cell?.setBankData(bankData: item as! BankDetail)
            break;
        default: break
            
        }
        cell?.selectionStyle = .none

        return cell!
        
    }
    
    @IBAction func onClickBtnClose(_ sender: Any) {
        self.removeFromSuperview();
    }
    
}

extension CustomTableDialog: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchbarSearchText()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchbarSearchText()
        searchBarItem.endEditing(true)
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBarItem.endEditing(true)
    }

    func searchbarSearchText() {
        arrFilterItemList.removeAllObjects()
        let searchText = searchBarItem.text ?? ""
        if searchText.isEmpty() {
            isSearch = false
            self.tableForItems.reloadData()
        }
        else
        {
            isSearch = true
            switch cellIdentifier {
            case CustomCellIdentifiers.cellForCountry:
                if let arr = arrForItemList as? [Country] {
                    let filterArray = arr.filter({ (itemData) -> Bool in
                        let a = itemData.countryName.lowercased().contains(searchText.lowercased())
                        return a
                    })
                    arrFilterItemList = NSMutableArray.init(array: filterArray)
                }
                break;
            case CustomCellIdentifiers.cellForCity:
                if let arr = arrForItemList as? [City] {
                    let filterArray = arr.filter({ (itemData) -> Bool in
                        let a = itemData.cityName.lowercased().contains(searchText.lowercased())
                        return a
                    })
                    arrFilterItemList = NSMutableArray.init(array: filterArray)
                }
                break;
            default: break
            }
            
            self.tableForItems.reloadData()
        }
    }
}


class CustomTableCell: CustomCell {
    /*Cell For Country*/
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var lblCountryName: UILabel!
    
    
    /*Cell For City*/
    @IBOutlet weak var lblCityName: UILabel!
    
    /*Cell For StoreType*/
    @IBOutlet weak var lblStoreType: UILabel!
    @IBOutlet weak var imgCategory: UIImageView!
    /*Cell For Specification Group*/
    @IBOutlet weak var lblGroupName: UILabel!
    /*Cell For Product List*/
    @IBOutlet weak var lblProductName: UILabel!
    /*Cell For Bank*/
    @IBOutlet weak var lblBankName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        switch self.reuseIdentifier! {
        case CustomCellIdentifiers.cellForCountry:
            self.lblCountryName.font = FontHelper.textRegular()
            self.lblCountryCode.font = FontHelper.textRegular()
            
            self.lblCountryName.textColor = UIColor.themeTextColor
            self.lblCountryCode.textColor = UIColor.themeTextColor
            break;
        case CustomCellIdentifiers.cellForCity:
            self.lblCityName.font = FontHelper.textRegular()
            self.lblCityName.textColor = UIColor.themeTextColor
            break;
        case CustomCellIdentifiers.cellForStoreType:
            self.lblStoreType.font = FontHelper.textRegular()
            self.lblStoreType.textColor = UIColor.themeTextColor
            break;
        case CustomCellIdentifiers.cellForSpecificationGroup:
            self.lblGroupName.font = FontHelper.textRegular()
            self.lblGroupName.textColor = UIColor.themeTextColor
            break;
        case CustomCellIdentifiers.cellForProductList:
            self.lblProductName.font = FontHelper.textRegular()
            self.lblProductName.textColor = UIColor.themeTextColor
            break;
        case CustomCellIdentifiers.cellForBankName:
            self.lblBankName.font = FontHelper.textRegular()
            self.lblBankName.textColor = UIColor.themeTextColor
            break;
        default: break
            
        }
    }
    
    func setBankData(bankData:BankDetail) {
        lblBankName.text = bankData.accountNumber 
    }
    func setCountryCell(countryData:Country) {
        lblCountryCode.text = countryData.countryPhoneCode
        lblCountryName.text = countryData.countryName
    }
    
    func setCityCell(cityData:City) {
        lblCityName.text = cityData.cityName
    }
    
    func setStoreTypeCell(storeTypeData:Delivery) {
        lblStoreType.text = storeTypeData.deliveryName
            
        imgCategory.downloadedFrom(link: storeTypeData.imageUrl)
    }
    
    func setGroupCell(groupData:ItemSpecification) {
        lblGroupName.text = groupData.name
        
    }
    func setProductCell(productData:ProductListItem) {
        lblProductName.text = productData.name
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
