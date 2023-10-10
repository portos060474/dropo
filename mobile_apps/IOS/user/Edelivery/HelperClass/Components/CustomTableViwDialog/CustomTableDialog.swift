//
//  CustomTableDialog.swift
//  edelivery
//
//  Created by Jaydeep Vyas on 24/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
enum CustomCellIdentifiers
{
    static let dialogForCustomTable = "dialogForCustomTable"
    static let cellForCountry = "cellForCountry"
    static let cellForCity = "cellForCity"
    static let cellForStoreType = "cellForStoreType"
    static let cellForProductList = "cellForProductList"
    static let cellForSpecificationGroup = "cellForSpecificationGroup"
    
}
class CustomTableDialog: UIView, UITableViewDelegate, UITableViewDataSource
{
    
    //MARK:- Outlets
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableForItems: UITableView!
    //MARK:- Variables
    var arrForItemList:NSMutableArray = [];
    var cellIdentifier = CustomCellIdentifiers.cellForCity;
    var onItemSelected : ((_ selectedItem:Any) -> Void)? = nil
    
    override func awakeFromNib()
    {
        lblTitle.font = FontHelper.regular()
        lblTitle.textColor = UIColor.themeTextColor
        btnClose.titleLabel?.font = FontHelper.regular()
        btnClose.setTitleColor(UIColor.themeTextColor, for: .normal)
        self.backgroundColor = UIColor.themeOverlayColor
    }
    public static func  showCustomTableDialog(withDataSource:NSMutableArray = [],cellIdentifier:String, title:String ) -> CustomTableDialog
    {
        let view = UINib(nibName: CustomCellIdentifiers.dialogForCustomTable, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomTableDialog
        view.setShadow()
        view.tableForItems.delegate = view;
        view.tableForItems.dataSource = view;
        view.arrForItemList = withDataSource
        view.cellIdentifier = cellIdentifier
        view.lblTitle.text = title
        switch view.cellIdentifier
        {
        case CustomCellIdentifiers.cellForCountry:
            view.tableForItems.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier:cellIdentifier)
            break;
        case CustomCellIdentifiers.cellForCity:
            view.tableForItems.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
            break;
        case CustomCellIdentifiers.cellForStoreType:
            view.tableForItems.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
            break;
        case CustomCellIdentifiers.cellForSpecificationGroup :
             view.tableForItems.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        case CustomCellIdentifiers.cellForProductList :
            view.tableForItems.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
            
        default:
            print("Invalid Cell")
        }
    
        
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame
        APPDELEGATE.window?.addSubview(view)
        APPDELEGATE.window?.bringSubview(toFront: view);
        
        return view;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
       let item =  arrForItemList.object(at: indexPath.row)
        if self.onItemSelected != nil
        {
            self.onItemSelected!(item)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if arrForItemList.count > 0
        {
            return arrForItemList.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        
        var cell:CustomTableCell? = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as? CustomTableCell
        if cell == nil {
            
            cell = CustomTableCell(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifier)
        }
        switch cellIdentifier
        {
        case CustomCellIdentifiers.cellForCountry:
            cell?.setCountryCell(countryData: arrForItemList[indexPath.row] as! Country)
            break;
        case CustomCellIdentifiers.cellForCity:
            cell?.setCityCell(cityData:arrForItemList[indexPath.row] as! City)
            break;
        case CustomCellIdentifiers.cellForStoreType:
            cell?.setStoreTypeCell(storeTypeData:arrForItemList[indexPath.row] as! Delivery)
            break;
        case CustomCellIdentifiers.cellForSpecificationGroup:
            cell?.setGroupCell(groupData:arrForItemList[indexPath.row] as! ItemSpecification)
            break;
        case CustomCellIdentifiers.cellForProductList:
            cell?.setProductCell(productData:arrForItemList[indexPath.row] as! ProductListItem)
            break;
        default: break
            
        }
        return cell!
        
    }
    
    @IBAction func onClickBtnClose(_ sender: Any)
    {
        self.removeFromSuperview();
    }
    
}
class CustomTableCell: UITableViewCell
{
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
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        switch self.reuseIdentifier!
        {
        case CustomCellIdentifiers.cellForCountry:
            self.lblCountryName.font = FontHelper.regular()
            self.lblCountryCode.font = FontHelper.regular()
            
            self.lblCountryName.textColor = UIColor.themeTextColor
            self.lblCountryCode.textColor = UIColor.themeTextColor
            break;
        case CustomCellIdentifiers.cellForCity:
            self.lblCityName.font = FontHelper.regular()
            self.lblCityName.textColor = UIColor.themeTextColor
            break;
        case CustomCellIdentifiers.cellForStoreType:
            self.lblStoreType.font = FontHelper.regular()
            self.lblStoreType.textColor = UIColor.themeTextColor
            break;
        case CustomCellIdentifiers.cellForSpecificationGroup:
            self.lblGroupName.font = FontHelper.regular()
            self.lblGroupName.textColor = UIColor.themeTextColor
            break;
        case CustomCellIdentifiers.cellForProductList:
            self.lblProductName.font = FontHelper.regular()
            self.lblProductName.textColor = UIColor.themeTextColor
            break;
        default: break
            
        }
    }
    
    
    func setCountryCell(countryData:Country)
    {
        lblCountryCode.text = countryData.countryPhoneCode
        lblCountryName.text = countryData.countryName
    }
    
    func setCityCell(cityData:City)
    {
        lblCityName.text = cityData.cityName
    }
    
    func setStoreTypeCell(storeTypeData:Delivery)
    {
        lblStoreType.text = storeTypeData.deliveryName
        imgCategory.downloadedFrom(link: storeTypeData.imageUrl)
    }
    
    func setGroupCell(groupData:ItemSpecification)
    {
        lblGroupName.text = groupData.name
        
    }
    func setProductCell(productData:ProductListItem)
    {
        lblProductName.text = productData.name
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
