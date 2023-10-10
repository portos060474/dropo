//
//  UserVC.swift
//  Edelivery Provider
//
//  Created by Elluminati iMac on 26/04/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit

class UserVC: BaseVC, UITableViewDelegate, UITableViewDataSource {

//MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblAppVersion: UILabel!
    @IBOutlet weak var viewForLanguage: UIView!
    @IBOutlet weak var lblLanguageTitle: UILabel!
    @IBOutlet weak var lblLanguageMessage: UILabel!
    @IBOutlet weak var imgDownarrowLang: UIImageView!
    
    var arrItems = [String]()
    var arrItemsImages = [String]()
  
//MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalization()
        let bundleID = Bundle.main.bundleIdentifier
        if bundleID == "com.elluminati.edelivery.provider" {
            addTapOnVersion()
        }
    }
   
//MARK: Set localized layout
    
    override func updateUIAccordingToTheme() {
        self.setLocalization()
        tableView.reloadData()
        setMenuButton()
    }
    
    func setLocalization() {
        self.hideBackButtonTitle()
        self.setNavigationTitle(title: "TXT_ACCOUNT".localized)
        tableView.tableFooterView = UIView()
        super.hideBackButtonTitle()
        setMenuButton()
        arrItems = ["TXT_PROFILE".localized,"TXT_BANK_DETAILS".localized/*,"TXT_SETTING".localized,"TXT_SHARE".localized*/,"TXT_DOCUMENT".localized,"TXT_PAYMENT".localized,"TXT_VEHICLE".localized,"TXT_NOTIFICATION".localized,"TXT_HELP".localized,"TXT_LOGOUT".localized ]
        arrItemsImages = ["menuProfile","menuBank","menuDocument","menuWallet","menuVehicle","noti","menuHelp","menuLogout"]
        
        view.backgroundColor = UIColor.themeViewBackgroundColor
        lblAppVersion.textColor = UIColor.themeTextColor
        let currentAppVersion : String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)
        lblAppVersion.text = String(format: "TXT_APP_VERSION".localized + ": %@", currentAppVersion)
        lblLanguageTitle.textColor = UIColor.themeLightTextColor
        lblLanguageMessage.textColor = UIColor.themeTextColor
        lblLanguageTitle.font = FontHelper.textSmall()
        lblLanguageMessage.font = FontHelper.textMedium(size: 11)
        lblLanguageTitle.text = "TXT_USE_APP_IN".localized
        lblLanguageMessage.text = LocalizeLanguage.currentAppleLanguageFull()
        let tap = UITapGestureRecognizer(target: self, action:#selector(openLanguageDialog))
        viewForLanguage.addGestureRecognizer(tap)
        viewForLanguage.isUserInteractionEnabled = true
        title = "User".localized
        imgDownarrowLang.image = UIImage.init(named: "dropdown")?.imageWithColor(color: .themeIconTintColor)!
    }
    
    @objc func openLanguageDialog() {
        self.openLanguageActionSheet()
    }

    func signOutFirebaseAuth() {
            do{
                try firebaseAuth.signOut()
                print("Logout successfully from firebase authentication")
                preferenceHelper.setAuthToken("")
            }catch let signOutError as NSError {
                print("Error signing out in: %@", signOutError)
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
    
//MARK: Tableview Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CellForUserMenu
        cell.imgIcon?.image = UIImage.init(named: arrItemsImages[indexPath.row])?.imageWithColor(color: UIColor.themeIconTintColor)
        cell.lblItemName.text = arrItems[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if arrItems[indexPath.row] == "TXT_PROFILE".localized {
            self.performSegue(withIdentifier: SEGUE.USER_TO_PROFILE, sender: nil)
        }else if arrItems[indexPath.row] == "TXT_DOCUMENT".localized {
            self.performSegue(withIdentifier: SEGUE.USER_TO_DOCUMENT, sender: nil)
        }else if arrItems[indexPath.row] == "TXT_LOGOUT".localized {
           openLogoutDialog()
        }else if arrItems[indexPath.row] == "TXT_BANK_DETAILS".localized {
            self.performSegue(withIdentifier: SEGUE.USER_TO_BANK_DETAIL, sender: nil)
        }else if arrItems[indexPath.row].localizedLowercase == "TXT_PAYMENT".localizedLowercase {
            self.performSegue(withIdentifier: SEGUE.USER_TO_WALLET_PAYMENT, sender: nil)
        }else if arrItems[indexPath.row] == "TXT_HELP".localized {
            self.performSegue(withIdentifier: SEGUE.HELP, sender: nil)
        }else if arrItems[indexPath.row] == "TXT_VEHICLE".localized {
            self.performSegue(withIdentifier: SEGUE.USER_TO_MANAGE_VEHICLE, sender: nil)
        }else if arrItems[indexPath.row] == "TXT_NOTIFICATION".localized {
            var mainView: UIStoryboard!
            mainView = UIStoryboard(name: "Notification", bundle: nil)
            if let VC : NotificationsVC = mainView.instantiateViewController(withIdentifier: "NotificationsVC") as? NotificationsVC{
                self.navigationController?.pushViewController(VC, animated: true)
            }
        }
        else if arrItems[indexPath.row] == "TXT_HISTORY".localized {
            let history = UIStoryboard.init(name: "History", bundle: nil)
            if let vc = history.instantiateInitialViewController() {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
  
//MARK: Log out
    func wsLogout() {
        Utility.showLoading()
        let dictParam:[String:String] =
            [PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken(),
             PARAMS.PROVIDER_ID : preferenceHelper.getUserId()]
        
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_PROVIDER_LOGOUT, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            
           if (Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true))
           {
                LocationManager().autoUpdate = false
                preferenceHelper.setSessionToken("")
                preferenceHelper.setUserId("")
                self.signOutFirebaseAuth()
                APPDELEGATE.goToHome()
           }
            Utility.hideLoading()
        }
    }
    
    func openLogoutDialog() {
        let dialogForLogout = CustomAlertDialog.showCustomAlertDialog(title: "TXT_LOGOUT".localized, message: "MSG_ARE_YOU_SURE".localized, titleLeftButton: "TXT_CANCEL".localizedUppercase, titleRightButton: "TXT_OK".localizedUppercase)
        dialogForLogout.onClickLeftButton = { [unowned dialogForLogout] in
            dialogForLogout.removeFromSuperview();
        }
        dialogForLogout.onClickRightButton = { [unowned dialogForLogout, unowned self] in
            dialogForLogout.removeFromSuperview();
            self.wsLogout()
        }
    }

//MARK: Memory mngmnt
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

class CellForUserMenu: CustomCell {
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblItemName: UILabel!
    override func awakeFromNib() {
        lblItemName.textColor = UIColor.themeTextColor
        lblItemName.font = FontHelper.textRegular()
    }
}

