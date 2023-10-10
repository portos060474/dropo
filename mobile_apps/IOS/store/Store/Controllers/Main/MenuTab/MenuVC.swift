//
//  UserVC.swift
// Edelivery Store
//
//  Created by Jaydeep Vyas on 28/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
import FirebaseMessaging


class MenuVC: BaseVC,UITableViewDelegate,UITableViewDataSource {
    //MARK:- OutLets
    @IBOutlet weak var tblForMenu: UITableView!
    @IBOutlet weak var lblAppVersion: UILabel!
    @IBOutlet weak var imgDownarrowLang: UIImageView!

    //MARK:- Variables
    var arrForItems:Array<String> = [];
    var arrForImages:Array<String> = [];
    var arrForSEGUE:Array<String> = [];
    
    
    @IBOutlet weak var viewForLanguage: UIView!
    @IBOutlet weak var lblLanguageTitle: UILabel!
    @IBOutlet weak var lblLanguageMessage: UILabel!
    
    
    //MARK:- ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideBackButtonTitle()
        self.setMenuButton()
        tblForMenu.showsVerticalScrollIndicator = false
        // preferenceHelper.setStoreCanCreateGroup(true)
        
        if !preferenceHelper.getIsSubStoreLogin(){
            arrForItems.append("TXT_PROFILE".localizedCapitalized)}
        if ScreenVisibilityPermission.History{
            arrForItems.append("TXT_HISTORY".localizedCapitalized)}
        arrForItems.append("TXT_PRODUCT_SPECIFICATION_GROUP".localizedCapitalized)
        if preferenceHelper.getStoreCanCreateGroup(){
            if !preferenceHelper.getIsSubStoreLogin()
            {
                arrForItems.append("TXT_PRODUCT_CATEGORY_GROUP".localizedCapitalized)
            }else if preferenceHelper.getIsSubStoreLogin() && ScreenVisibilityPermission.Group{
                arrForItems.append("TXT_PRODUCT_CATEGORY_GROUP".localizedCapitalized)
            }
        }
        if !preferenceHelper.getIsSubStoreLogin(){
            arrForItems.append("TXT_DOCUMENT".localizedCapitalized)
            arrForItems.append("TXT_BANK_DETAILS".localizedCapitalized)
            arrForItems.append("TXT_PAYMENT".localizedCapitalized)
        }
        if !preferenceHelper.getIsSubStoreLogin(){
            arrForItems.append("TXT_EARNING".localizedCapitalized)
        }else{
            if ScreenVisibilityPermission.Earning{
                arrForItems.append("TXT_EARNING".localizedCapitalized)
            }
        }
        if ScreenVisibilityPermission.Setting{
            arrForItems.append("TXT_SETTING".localizedCapitalized)}
//        arrForItems.append("TXT_SHARE".localizedCapitalized)
        if ScreenVisibilityPermission.CreateOrder{
            arrForItems.append("TXT_CREATE_ORDER".localizedCapitalized)
            arrForItems.append("TXT_INSTANT_ORDER".localizedCapitalized)
        }
        if !preferenceHelper.getIsSubStoreLogin(){
            arrForItems.append("TXT_SUB_STORE".localizedCapitalized)}
        arrForItems.append("TXT_REVIEW".localizedCapitalized)
        if ScreenVisibilityPermission.Promocode{
            arrForItems.append("TXT_PROMO".localizedCapitalized)}
        arrForItems.append("TXT_NOTIFICATION".localizedCapitalized)
        
        arrForItems.append("TXT_HELP".localizedCapitalized)
        arrForItems.append("TXT_LOGOUT".localizedCapitalized)
        
        
        
        if !preferenceHelper.getIsSubStoreLogin(){
            arrForImages.append("menuProfile")}
        if ScreenVisibilityPermission.History{
            arrForImages.append("menuHistory")}
        arrForImages.append("specification_group")
        
        if preferenceHelper.getStoreCanCreateGroup(){
            if !preferenceHelper.getIsSubStoreLogin()
            {
                arrForImages.append("catrgory")
            }else if preferenceHelper.getIsSubStoreLogin() && ScreenVisibilityPermission.Group{
                arrForImages.append("catrgory")
            }
        }
        
//        if preferenceHelper.getStoreCanCreateGroup(){
//            if ScreenVisibilityPermission.Group{
//                arrForImages.append("catrgory")}}
        if !preferenceHelper.getIsSubStoreLogin(){
            arrForImages.append("menuDocument")
            arrForImages.append("menuBank")
            arrForImages.append("menuWallet")
        }
        if !preferenceHelper.getIsSubStoreLogin(){
            arrForImages.append("menuEarning")
        }else{
            if ScreenVisibilityPermission.Earning{
                arrForImages.append("menuEarning")
            }
        }
        if ScreenVisibilityPermission.Setting{
            arrForImages.append("menuSettings")}
//        arrForImages.append("menuShare")
        if ScreenVisibilityPermission.CreateOrder{
            arrForImages.append("menuCreateOrder")
            arrForImages.append("menuInstanceOrder")
        }
        if !preferenceHelper.getIsSubStoreLogin(){
            arrForImages.append("sub_store")}
        arrForImages.append("menuReview")
        if ScreenVisibilityPermission.Promocode{
            arrForImages.append("menuPromo")}
        arrForImages.append("notofication")
        arrForImages.append("menuHelp")
        arrForImages.append("menuLogout")
        
        
        lblAppVersion.font = FontHelper.textSmall()
        
        let currentAppVersion : String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)
        lblAppVersion.text = String(format: "TXT_APP_VERSION".localized + ": %@", currentAppVersion)
        
        imgDownarrowLang.image = UIImage.init(named: "dropdown")!.imageWithColor(color: .themeIconTintColor)!

        
        lblAppVersion.textColor = UIColor.themeLightTextColor
        super.setNavigationTitle(title: "TXT_ACCOUNT".localizedCapitalized)
        
        lblLanguageTitle.textColor = UIColor.themeLightTextColor
        lblLanguageMessage.textColor = UIColor.themeTextColor
        lblLanguageTitle.font = FontHelper.textSmall()
        lblLanguageMessage.font = FontHelper.textMedium(size: 11.0)
        
        lblLanguageTitle.text = "TXT_LANGUAGE".localized
        lblLanguageMessage.text = LocalizeLanguage.currentAppleLanguageFull()
        
        let tap = UITapGestureRecognizer(target: self, action:#selector(openLanguageDialog))
        
        viewForLanguage.addGestureRecognizer(tap)
        viewForLanguage.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
        
        let bundleID = Bundle.main.bundleIdentifier
        if bundleID == "com.elluminati.edelivery.store" {
            addTapOnVersion()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.tintColor = UIColor.black
        self.tabBarController?.tabBar.barTintColor = UIColor.themeViewBackgroundColor
        
        if #available(iOS 10.0, *) {
            self.tabBarController?.tabBar.unselectedItemTintColor = UIColor.black
        } else {
            
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
   
    override func updateUIAccordingToTheme() {
        setMenuButton()
        self.tblForMenu.reloadData()
        imgDownarrowLang.image = UIImage.init(named: "dropdown")!.imageWithColor(color: .themeIconTintColor)!
    }
    func setupLayout(){
        tblForMenu.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- TableView Delegate Method
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch arrForItems[indexPath.row]
        {
        case "TXT_PROFILE".localizedCapitalized:
            self.performSegue(withIdentifier: SEGUE.SEGUE_PROFILE, sender: self)
            break
        case "TXT_HISTORY".localizedCapitalized:
            self.performSegue(withIdentifier: SEGUE.HISTORY, sender: self)
            break
        case "TXT_PRODUCT_SPECIFICATION_GROUP".localizedCapitalized:
            self.performSegue(withIdentifier: SEGUE.MENU_TO_SPECIFICATION_GROUP, sender: self)
            break
        case "TXT_PRODUCT_CATEGORY_GROUP".localizedCapitalized:
            self.performSegue(withIdentifier: SEGUE.MENU_TO_CATEGORY_GROUP, sender: self)
            break
            
        case "TXT_DOCUMENT".localizedCapitalized:
            self.performSegue(withIdentifier: SEGUE.SEGUE_DOCUMENT, sender: self)
            break
        case "TXT_BANK_DETAILS".localizedCapitalized:
            self.performSegue(withIdentifier: SEGUE.USER_TO_BANK_DETAIL, sender: nil)
            break
        case "TXT_PAYMENT".localizedCapitalized:
            self.performSegue(withIdentifier: SEGUE.USER_TO_WALLET_PAYMENT, sender: nil)
            break;
            
        case "TXT_EARNING".localizedCapitalized:
            self.performSegue(withIdentifier: SEGUE.EARNING, sender: self)
            
            break;
        case "TXT_SETTING".localizedCapitalized:
            self.performSegue(withIdentifier: SEGUE.SETTING, sender: self)
            break;
        case "TXT_SHARE".localizedCapitalized:
            self.performSegue(withIdentifier: SEGUE.SHARE, sender: self)
            break;
            
        case "TXT_CREATE_ORDER".localizedCapitalized:
            self.goToCreateOrder()
            break;
            
        case "TXT_INSTANT_ORDER".localizedCapitalized:
            self.performSegue(withIdentifier: SEGUE.INSTANCE_ORDER, sender: self)
            break
            
        case "TXT_SUB_STORE".localizedCapitalized:
            self.performSegue(withIdentifier: SEGUE.SUB_STORE, sender: self)
            break
            
        case "TXT_REVIEW".localizedCapitalized:
            self.performSegue(withIdentifier: SEGUE.REVIEW, sender: nil)
            break;
            
        case "TXT_PROMO".localizedCapitalized:
            self.performSegue(withIdentifier: SEGUE.PROMOLIST, sender: self)
            break
        case "TXT_NOTIFICATION".localizedCapitalized:
            var mainView: UIStoryboard!
            mainView = UIStoryboard(name: "Notification", bundle: nil)
            if let VC : NotificationsVC = mainView.instantiateViewController(withIdentifier: "NotificationsVC") as? NotificationsVC{
                self.navigationController?.pushViewController(VC, animated: true)
            }
            break;
        case "TXT_HELP".localizedCapitalized:
            self.performSegue(withIdentifier: SEGUE.HELP, sender: self)
            break
        case "TXT_LOGOUT".localizedCapitalized:
            openLogoutDialog();
            break;
        default:
            print("wrong Item Selected")
            break
        }
    }
    
    func addTapOnVersion() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onClickVersionTap(_:)))
        tap.numberOfTapsRequired = 3
        self.lblAppVersion.addGestureRecognizer(tap)
        self.lblAppVersion.isUserInteractionEnabled = true
    }
    
    @objc func onClickVersionTap(_ sender: UITapGestureRecognizer) {
        let dialog = DialogForApplicationMode.showCustomAppModeDialog()
        
        dialog.onClickLeftButton = { [unowned dialog] in
            dialog.removeFromSuperview()
        }
        
        dialog.onClickRightButton = { [unowned dialog] in
            dialog.removeFromSuperview()
        }
    }
    
    func goToCreateOrder() {
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "Orders", bundle: nil)
        if let orderItemVC : OrderItemListVC = mainView.instantiateViewController(withIdentifier: "OrderItemListVC") as? OrderItemListVC {
            self.navigationController?.pushViewController(orderItemVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrForItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CellForMenu = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CellForMenu
        
        cell.imgIcon.image = UIImage.init(named: arrForImages[indexPath.row])?.imageWithColor(color: .themeIconTintColor)
        cell.lblItemName.text = arrForItems[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if !StoreSingleton.shared.store.isStoreCreateOrder && (indexPath.row == 9 || indexPath.row == 10) {
            return 0;
        }
        return 50;
        
    }
    //MARK:- Logout dialog
    func openLogoutDialog() {
        
        let dialogForLogout = CustomAlertDialog.showCustomAlertDialog(title: "TXT_LOGOUT".localized, message: "MSG_LOGOUT".localized, titleLeftButton: "TXT_CANCEL".localizedUppercase, titleRightButton: "TXT_OK".localizedUppercase)
        
        dialogForLogout.onClickLeftButton = {
            [unowned dialogForLogout, unowned self] in
            dialogForLogout.removeFromSuperview();
        }
        dialogForLogout.onClickRightButton = {
            [unowned dialogForLogout, unowned self] in
            dialogForLogout.removeFromSuperview();
            self.wsLogout()
        }
    }
    func wsLogout() {
        Utility.showLoading()
        let dictParam : [String : Any] =
            [PARAMS.STORE_ID      : preferenceHelper.getUserId(),
             PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken() ,
            ]
        
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_STORE_LOGOUT, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            
            Utility.hideLoading()
            if  Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true) {
                APPDELEGATE.removeFirebaseTokenAndTopic()
                self.logOutFirebaseAuth()
                preferenceHelper.setSessionToken("")
                
                preferenceHelper.setSubStoreId("");
//                preferenceHelper.setSubStoreSessionToken("")
                clearScreenVisibilityPermission()
                StoreSingleton.shared.cart.removeAll()
                
                APPDELEGATE.goToHome()
                return
                
                
            }else {
                
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    func logOutFirebaseAuth()
    {
            do{
                try firebaseAuth.signOut()
                print("Logout successfully from firebase authentication")
                preferenceHelper.setAuthToken("")
            }catch let signOutError as NSError {
                print("Error signing out in: %@", signOutError)
            }
    }
    
    @objc func openLanguageDialog() {
//
//        let dialogForLanguage:CustomLanguageDialog = CustomLanguageDialog.showCustomLanguageDialog()
//        dialogForLanguage.onItemSelected = {
//            (selectedItem:Int) in
//            super.changed(selectedItem)
//        }
        self.view.endEditing(true)
        super.openLanguageActionSheet()

    }
}

class CellForMenu: CustomCell {
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblItemName: UILabel!
    override func awakeFromNib() {
        lblItemName.textColor = UIColor.themeTextColor
        lblItemName.font = FontHelper.textRegular()
    }
}
