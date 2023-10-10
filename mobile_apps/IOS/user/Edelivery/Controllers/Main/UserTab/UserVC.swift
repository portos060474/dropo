//
//  UserVC.swift
//  edelivery
//
//  Created by Elluminati on 28/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
import FirebaseMessaging
import Firebase

class UserVC: BaseVC,UITableViewDelegate,UITableViewDataSource,LeftDelegate {

    //MARK:- OutLets
    @IBOutlet weak var tblForUser: UITableView!
    @IBOutlet weak var lblAppVersion: UILabel!

    //MARK:- Variables
    var arrForItems:Array<String> = []
    var arrForImages:Array<String> = []
    var arrForSEGUE:Array<String> = []
    
    //MARK:- ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideBackButtonTitle()
        delegateLeft = self
        arrForItems = ["TXT_PROFILE".localized,
                       "TXT_PAYMENTS".localized,
                       "TXT_DOCUMENT".localized,
                       "TXT_ORDERS".localized,
                       "TXT_SETTING".localized,
                       "TXT_FAVOURITE_STORE".localized,
                       "TXT_FAVOURITE_ADDRESS".localized,
                       "TXT_NOTIFICATION".localized,
                       "TXT_HELP".localized,
                       "TXT_LOGOUT".localized]
        
        arrForImages = ["menuProfile",
                        "menuPayment",
                        "menuDocument",
                        "menuOrders",
                        "menuSettings",
                        "menuFavStore",
                        "menuFavourite",
                        "noti",
                        "menuHelp",
                        "menuLogout"
                        ]
        
        let currentAppVersion : String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)
        lblAppVersion.text = String(format: "TXT_APP_VERSION".localized + ": %@", currentAppVersion)
        lblAppVersion.font = FontHelper.textSmall()
        lblAppVersion.textColor = UIColor.themeLightTextColor
        self.title = "TXT_ACCOUNT".localizedCapitalized
        
        let bundleID = Bundle.main.bundleIdentifier
        if bundleID == "com.elluminati.edelivery" {
            addTapOnVersion()
        }
    }

    override func updateUIAccordingToTheme() {
        self.setBackBarItem(isNative: true)
        tblForUser.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "TXT_ACCOUNT".localizedCapitalized
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        self.setBackBarItem(isNative: true)
        self.setNavigationTitle(title: "TXT_ACCOUNT".localizedCapitalized)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.title = "TXT_ACCOUNT".localizedCapitalized
        }
    }
    
    func setupLayout(){
        tblForUser.tableFooterView = UIView()
    }

    func onClickLeftButton() {
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK:- TableView Delegate Method
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            self.performSegue(withIdentifier: SEGUE.SEGUE_PROFILE, sender: self)
            break
        case 1:
            currentBooking.isHidePayNow = true
            self.gotoPayment()
            break
        case 2:
            self.performSegue(withIdentifier: SEGUE.SEGUE_DOCUMENTS, sender: self)
            break
        case 3:
            self.performSegue(withIdentifier: SEGUE.SEGUE_TO_HISTORY, sender: self)
            break
        case 4:
            self.performSegue(withIdentifier: SEGUE.SETTING, sender: self)
            break
            
        case 5:
            self.performSegue(withIdentifier: SEGUE.FAVOURITE_STORE, sender: self)
            break
        case 6:
            var mainView: UIStoryboard!
            mainView = UIStoryboard(name: "MainStoryboard", bundle: nil)
            if let VC : FavAddressListVC = mainView.instantiateViewController(withIdentifier: "FavAddressListVC") as? FavAddressListVC {
                VC.isFromDeliveryLocationScreen = false
                self.navigationController?.pushViewController(VC, animated: true)
            }
            break
        case 7:
            var mainView: UIStoryboard!
            mainView = UIStoryboard(name: "Notification", bundle: nil)
            if let VC : NotificationsVC = mainView.instantiateViewController(withIdentifier: "NotificationsVC") as? NotificationsVC{
                self.navigationController?.pushViewController(VC, animated: true)
            }
            break
        case 8:
            self.performSegue(withIdentifier: SEGUE.HELP, sender: self)
            break
        case 9:
            //openApp()
            openLogoutDialog()
            break
        default:
            Utility.showToast(message: "Wrong item selected")
            break
        }
        
    }
    
    func gotoPayment() {
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "Cart", bundle: nil)
        if let paymentVC : PaymentVC = mainView.instantiateViewController(withIdentifier: "paymentVC") as? PaymentVC {
            self.navigationController?.pushViewController(paymentVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrForItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CellForUser = tableView.dequeueReusableCell(withIdentifier: "cellForUser", for: indexPath) as! CellForUser
      
        cell.imgIcon.image = UIImage.init(named: arrForImages[indexPath.row])?.imageWithColor(color: UIColor.themeIconTintColor)
        cell.lblItemName.text = arrForItems[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    //MARK:- Logout dialog
    func openLogoutDialog() {
      
            let dialogForLogout = CustomAlertDialog.showCustomAlertDialog(title: "TXT_LOGOUT".localized, message: "MSG_ARE_YOU_SURE".localized, titleLeftButton: "".localizedCapitalized, titleRightButton: "TXT_OK".localizedCapitalized)
            dialogForLogout.onClickLeftButton = {
                    [unowned self,unowned dialogForLogout] in
                    dialogForLogout.removeFromSuperview()
            }
            dialogForLogout.onClickRightButton = {
                    [unowned self,unowned dialogForLogout] in
                        dialogForLogout.removeFromSuperview()
                        self.wsLogout()
                }
    }

    func wsLogout(appMode: AppMode? = nil) {
        APPDELEGATE.removeFirebaseTokenAndTopic()
        Utility.showLoading()
        let dictParam : [String : Any] =
            [PARAMS.USER_ID      : preferenceHelper.getUserId(),
             PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken() ,
            ]

        let alamoFire:AlamofireHelper = AlamofireHelper()
        alamoFire.getResponseFromURL(url: WebService.WS_USER_LOGOUT, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true) {
             // APPDELEGATE.clearEntity()
                preferenceHelper.setSessionToken("")
                preferenceHelper.setUserId("")
                preferenceHelper.setRandomCartID(String.random(length: 20))
                if appMode != nil {
                    AppMode.currentMode = appMode!
                    APPDELEGATE.goToHome(isSplash: true)
                } else {
                    APPDELEGATE.goToHome()
                }
                APPDELEGATE.clearFavoriteAddressEntity()
                APPDELEGATE.clearDeliveryLocationEntity()
                self.signOutFirebaseAuth()
                return
            } else {}
        }
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

    func openAppStore() {
        if let url = URL(string: "https://itunes.apple.com/app/id1184832545"),
            UIApplication.shared.canOpenURL(url){
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:]) { (opened) in
                    if(opened){
                        
                    }
                }
            } else {
                // Fallback on earlier versions
            }
        } else {
            printE("Can't Open URL on Simulator")
        }
    }
    
    func openApp() {
        let appScheme = "eber://"
        let appUrl = URL(string: appScheme)
        if UIApplication.shared.canOpenURL(appUrl! as URL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appUrl!)
            } else {
                // Fallback on earlier versions
            }
        } else {
            openAppStore()
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
            if AppMode.currentMode != dialog.appMode {
                self.wsLogout(appMode: dialog.appMode)
            } 
        }
    }
}

class CellForUser: CustomTableCell {
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblItemName: UILabel!
    override func awakeFromNib() {
        lblItemName.textColor = UIColor.themeTextColor
        lblItemName.font = FontHelper.textRegular()
    }
}
