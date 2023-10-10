//
//  SplashVC.swift
//  Store
//
//  Created by Jaydeep Vyas on 18/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class SplashVC: BaseVC {
    
    @IBOutlet weak var splashImage: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      wsGetAppSetting()
      if preferenceHelper.getRandomCartID().isEmpty {
        preferenceHelper.setRandomCartID(String.random(length: 20))
      }
    }
    
    override func viewDidLoad() {
      super.viewDidLoad();
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews();
    }
    
    override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}


//MARK:- Web Serivice Calls
extension SplashVC {
    
    func wsGetAppSetting() {
        UIColor.setColors()

        let afh:AlamofireHelper = AlamofireHelper.init()
        let dictParam : [String : Any] = [PARAMS.DEVICE_TYPE: CONSTANT.IOS,
                                          PARAMS.TYPE:CONSTANT.TYPE_STORE]
        print(dictParam)
        afh.getResponseFromURL(url: WebService.WS_GET_SETTING_DETAIL, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            
            print("response---> \(response)")
            if (error != nil) {
                
                self.openServerErrorDialog()
                
            }
                else{
                
                if(Parser.parseAppSettingDetail(response: response)) {
                    
                    let setting:AppSettingResponse = AppSettingResponse.init(fromDictionary: response)
                    if (setting.isOpenUpdateDialog! &&  self.isUpdateAvailable(preferenceHelper.getLatestAppVersion())) {
                        self.openUpdateAppDialog(isForceUpdate: preferenceHelper.getIsRequiredForceUpdate())
                    }else {
                        self.checkLogin()
                    }
                }
                
            }
        }
    }
    
    //MARK:- User Define Methods
    func checkLogin() {
        Utility.hideLoading()
        //Storeapp
//        if preferenceHelper.getSessionToken().isEmpty() {
        if (preferenceHelper.getSessionToken().isEmpty() && !preferenceHelper.getIsSubStoreLogin()) || (preferenceHelper.getSessionToken().isEmpty() && preferenceHelper.getIsSubStoreLogin()){
            APPDELEGATE.goToHome()
            return
        } else {
            APPDELEGATE.goToMain()
            return
        }
    }
    func isUpdateAvailable(_ latestVersion: String) -> Bool {
        
        let currentAppVersion: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)
        let myCurrentVersion: [String] = currentAppVersion.components(separatedBy: ".")
        let myLatestVersion: [String] = latestVersion.components(separatedBy: ".")
        let legthOfLatestVersion: Int = myLatestVersion.count
        let legthOfCurrentVersion: Int = myCurrentVersion.count
        
        if legthOfLatestVersion == legthOfCurrentVersion {
            
            for i in 0..<myLatestVersion.count {
                
                if CInt(myCurrentVersion[i])! < CInt(myLatestVersion[i])! {
                    return true
                } else if CInt(myCurrentVersion[i]) == CInt(myLatestVersion[i]) {
                    continue
                } else {
                    return false
                }
                
            }
            
            return false
        } else {
            
            let count: Int = legthOfCurrentVersion > legthOfLatestVersion ? legthOfLatestVersion : legthOfCurrentVersion
            
            for i in 0..<count {
                if CInt(myCurrentVersion[i])! < CInt(myLatestVersion[i])! {
                    return true
                } else if CInt(myCurrentVersion[i])! > CInt(myLatestVersion[i])! {
                    return false
                } else if CInt(myCurrentVersion[i]) == CInt(myLatestVersion[i]) {
                    continue
                }
            }
            if legthOfCurrentVersion < legthOfLatestVersion {
                
                for i in legthOfCurrentVersion..<legthOfLatestVersion {
                
                    if CInt(myLatestVersion[i]) != 0 {
                        return true
                    }
                }
                
                return false
            } else {
                return false
            }
            
        }
    }
    //MARK:- Dialogs
    func openUpdateAppDialog(isForceUpdate:Bool) {
        
        if isForceUpdate {
            
            let dialogForUpdateApp = CustomAlertDialog.showCustomAlertDialog(title: "TXT_ATTENTION".localized, message: "MSG_UPDATE_APP".localized, titleLeftButton: "TXT_EXIT".localizedUppercase, titleRightButton: "TXT_UPDATE".localizedUppercase)
            dialogForUpdateApp.onClickLeftButton = { [unowned dialogForUpdateApp] in
                    dialogForUpdateApp.removeFromSuperview();
                    exit(0)
            }
            
            dialogForUpdateApp.onClickRightButton = { [unowned dialogForUpdateApp] in
                    if let url = URL(string: CONSTANT.UPDATE_URL),
                        UIApplication.shared.canOpenURL(url)
                    {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
             }
        } else {
            
            let dialogForUpdateApp = CustomAlertDialog.showCustomAlertDialog(title: "TXT_ATTENTION".localized, message: "MSG_UPDATE_APP".localized, titleLeftButton: "TXT_CANCEL".localizedUppercase, titleRightButton: "TXT_UPDATE".localizedUppercase)
            dialogForUpdateApp.onClickLeftButton = {
                [unowned dialogForUpdateApp] in
                dialogForUpdateApp.removeFromSuperview();
                self.checkLogin()
            }
            dialogForUpdateApp.onClickRightButton = {
                [unowned dialogForUpdateApp] in
                    if let url = URL(string: CONSTANT.UPDATE_URL),
                        UIApplication.shared.canOpenURL(url) { 
                        
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
            }
            
            
        }
        
        
    }
    func openServerErrorDialog() {
        let dialogForServerError = CustomAlertDialog.showCustomAlertDialog(title: "TXT_ATTENTION".localized, message: "MSG_SERVER_ERROR".localized, titleLeftButton: "TXT_EXIT".localizedUppercase, titleRightButton: "TXT_RETRY".localizedUppercase)
        dialogForServerError.onClickLeftButton = {
            [unowned dialogForServerError] in
                dialogForServerError.removeFromSuperview();
                exit(0)
                
        }
        dialogForServerError.onClickRightButton = {
            [unowned dialogForServerError] in
                dialogForServerError.removeFromSuperview();
                self.wsGetAppSetting()
        }
    }
}
