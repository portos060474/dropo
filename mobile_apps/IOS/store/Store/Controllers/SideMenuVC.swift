//
//  MenuVC.swift
//  Edelivery Provider
//
//  Created by Elluminati on 10/03/21.
//  Copyright © 2021 Elluminati iMac. All rights reserved.
//

import UIKit

class SideMenuVC: BaseVC {

    var arrForMenu:[(String,String)] = [("TXT_ORDER","orders_menu_icon"),("TXT_DELIVERIES".localizedCapitalized,"delivery_menu_icon"),("TXT_MENU".localizedCapitalized,"menu_menu_icon"),("TXT_ACCOUNT".localizedCapitalized,"account_menu_icon")]
    @IBOutlet weak var lblTheme: UILabel!
    @IBOutlet weak var switchForTheme: UISwitch!
    var selectedRow = 0
    @IBOutlet weak var tblForMenu : UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //switchForTheme.isOn = !preferenceHelper.getIsDarkModeOn()
        //lblTheme.text = !preferenceHelper.getIsDarkModeOn() ? "TXT_LIGHT_MODE".localizedCapitalized : "TXT_DARK_MODE".localizedCapitalized/
        self.setLocalization()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        selectedRow = 0
    arrForMenu = [("TXT_ORDER","orders_menu_icon"),("TXT_DELIVERIES".localizedCapitalized,"delivery_menu_icon"),("TXT_MENU".localizedCapitalized,"menu_menu_icon"),("TXT_ACCOUNT".localizedCapitalized,"account_menu_icon")]

        if preferenceHelper.getIsSubStoreLogin(){
            if !ScreenVisibilityPermission.Deliveries && !ScreenVisibilityPermission.Order && !ScreenVisibilityPermission.Product{
                arrForMenu = [("TXT_ACCOUNT".localizedCapitalized,"account_menu_icon")]
            }else if !ScreenVisibilityPermission.Deliveries && !ScreenVisibilityPermission.Product{
                arrForMenu = [("TXT_ORDER","orders_menu_icon"),("TXT_ACCOUNT".localizedCapitalized,"account_menu_icon")]
            }else if !ScreenVisibilityPermission.Order && !ScreenVisibilityPermission.Product{
                arrForMenu = [("TXT_DELIVERIES".localizedCapitalized,"delivery_menu_icon"),("TXT_ACCOUNT".localizedCapitalized,"account_menu_icon")]

            }
            else if !ScreenVisibilityPermission.Deliveries && !ScreenVisibilityPermission.Order{
                arrForMenu = [("TXT_MENU".localizedCapitalized,"menu_menu_icon"),("TXT_ACCOUNT".localizedCapitalized,"account_menu_icon")]

            }else{
                if !ScreenVisibilityPermission.Order{
                     arrForMenu = [("TXT_DELIVERIES".localizedCapitalized,"delivery_menu_icon"),("TXT_MENU".localizedCapitalized,"menu_menu_icon"),("TXT_ACCOUNT".localizedCapitalized,"account_menu_icon")]

                }
                if !ScreenVisibilityPermission.Deliveries{
                    arrForMenu = [("TXT_ORDER","orders_menu_icon"),("TXT_MENU".localizedCapitalized,"menu_menu_icon"),("TXT_ACCOUNT".localizedCapitalized,"account_menu_icon")]
                }
            }
        }
        
        
        setLocalization()
    }
    func setLocalization() {
       
        tblForMenu.backgroundColor = UIColor.themeViewBackgroundColor
        tblForMenu.tableFooterView = UIView()
//        tblForMenu.separatorStyle = .none
       self.view.backgroundColor = UIColor.themeViewBackgroundColor
        tblForMenu.reloadData()
        //lblTheme.textColor = .themeTextColor
        //lblTheme.font = FontHelper.textMedium()
    }
    
    override func updateUIAccordingToTheme() {
        tblForMenu.reloadData()
    }
    
    @IBAction func onChangeTheme(_ sender: Any) {
        /*preferenceHelper.setIsDarkModeOn(!switchForTheme.isOn)
        if #available(iOS 11.0, *) {
            UIColor.setColors()
        }
        setLocalization()*/
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension SideMenuVC :UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrForMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuCell
        cell.setData(arrForMenu[indexPath.row].0, arrForMenu[indexPath.row].1,indexPath.row , selectedRow)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        selectedRow = indexPath.row
        tblForMenu.reloadData()
        self.revealViewController()?.hidesideView()
        if let navigationVC: UINavigationController = self.revealViewController()?.mainViewController as? UINavigationController
        {
            var selectedTab = ""
            selectedTab = arrForMenu[indexPath.row].0
            switch selectedTab
            {
                case "TXT_ORDER":
                    print("TXT_ORDER".localizedCapitalized)
                    navigationVC.setNavigationBarHidden(false, animated: true)
                    navigationVC.navigationBar.isHidden = false
                    let storyboard = UIStoryboard.init(name: "Orders", bundle: nil)
                    let vc = storyboard.instantiateInitialViewController()
                    navigationVC.pushViewController(vc!, animated: true)
                    
                case "TXT_DELIVERIES".localizedCapitalized:
                    navigationVC.setNavigationBarHidden(false, animated: true)
                    navigationVC.navigationBar.isHidden = false
                    let storyboard = UIStoryboard.init(name: "Deliveries", bundle: nil)
                    let vc = storyboard.instantiateInitialViewController()
                    navigationVC.pushViewController(vc!, animated: true)
                    
                    print("TXT_EARN".localizedCapitalized)
                case "TXT_MENU".localizedCapitalized:
                    ItemListVC.isCallGetItemAPI = true
                    navigationVC.setNavigationBarHidden(false, animated: true)
                    navigationVC.navigationBar.isHidden = false
                    let storyboard = UIStoryboard.init(name: "ItemDetail", bundle: nil)
                    let vc = storyboard.instantiateInitialViewController()
                    navigationVC.pushViewController(vc!, animated: true)
                    print("TXT_HISTORY".localizedCapitalized)
                case "TXT_ACCOUNT".localizedCapitalized:
                    navigationVC.setNavigationBarHidden(false, animated: true)
                    navigationVC.navigationBar.isHidden = false
                    self.setNavigationTitle(title: "TXT_ACCOUNT".localized)
                    let storyboard = UIStoryboard(name: "Account", bundle: nil)
                    let vc = storyboard.instantiateInitialViewController()
                    navigationVC.pushViewController(vc!, animated: true)
                    print("TXT_ACCOUNT".localizedCapitalized)
            
                default:
                    print("")
            }
        }
    }
}

class MenuCell: CustomTableCell {
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var ImageForMenu : UIImageView!
    var selectedRow = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        lblName.font = FontHelper.textMedium()
        lblName.textColor = UIColor.themeTextColor
        ImageForMenu.contentMode = .scaleAspectFit
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        self.backgroundColor = UIColor.themeViewBackgroundColor
    }
    func setData(_ name : String , _ imageName : String ,_ current : Int,_ selected : Int) {
        lblName.text = name.localizedCapitalized
        if current == selected {
            ImageForMenu?.image = UIImage.init(named: imageName)?.imageWithColor(color:  .themeColor)
            lblName.textColor = UIColor.themeColor
        }
        else {
            ImageForMenu?.image = UIImage.init(named: imageName)?.imageWithColor(color: .themeTextColor)
            lblName.textColor = UIColor.themeTextColor
        }
    }

}
