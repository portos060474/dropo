//
//  DialogForApplicationModw.swift
//  Edelivery Provider
//
//  Created by MacPro3 on 14/02/22.
//  Copyright © 2022 Elluminati iMac. All rights reserved.
//

import UIKit
import SwiftUI

public class DialogForApplicationMode:CustomDialog {
    
    @IBOutlet weak var viewCard: UIView!
    
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnLive: UIButton!
    @IBOutlet weak var btnDeveloper: UIButton!
    @IBOutlet weak var btnStaging: UIButton!
    
    @IBOutlet weak var lblServer: UILabel!
    @IBOutlet weak var lblLive: UILabel!
    @IBOutlet weak var lblStaging: UILabel!
    @IBOutlet weak var lblDeveloper: UILabel!
    
    var onClickRightButton : (() -> Void)? = nil
    var onClickLeftButton : (() -> Void)? = nil
    
    var appMode: AppMode = .live
    
    static let  verificationDialog = "DialogForApplicationMode"
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        btnCancel.setTitleColor(UIColor.themeLightGrayTextColor, for: .normal)
        btnCancel.titleLabel?.textColor = UIColor.themeLightGrayTextColor
        
        self.btnLive.setImage(UIImage(named: "radio_btn_unchecked_icon"), for: .normal)
        self.btnLive.setImage(UIImage.init(named: "radio_btn_checked_icon")!.imageWithColor(color: .themeColor), for: .selected)
        
        self.btnDeveloper.setImage(UIImage(named: "radio_btn_unchecked_icon"), for: .normal)
        self.btnDeveloper.setImage(UIImage.init(named: "radio_btn_checked_icon")!.imageWithColor(color: .themeColor), for: .selected)
        
        self.btnStaging.setImage(UIImage(named: "radio_btn_unchecked_icon"), for: .normal)
        self.btnStaging.setImage(UIImage.init(named: "radio_btn_checked_icon")!.imageWithColor(color: .themeColor), for: .selected)
        
        switch AppMode.currentMode {
        case .live:
            self.onClickRadio(btnLive)
        case .developer:
            self.onClickRadio(btnDeveloper)
        case .staging:
            self.onClickRadio(btnStaging)
        }
    }
    
    public static func showCustomAppModeDialog() -> DialogForApplicationMode {
        let view = UINib(nibName: verificationDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DialogForApplicationMode
        view.viewCard.applyShadowToView(12)
        let frame = (APPDELEGATE.window?.frame)!
        view.frame = frame
        
        DispatchQueue.main.async {
            APPDELEGATE.window?.addSubview(view)
            APPDELEGATE.window?.bringSubviewToFront(view)
        }
        return view
    }
    
    @IBAction func onClickRadio(_ sender: UIButton) {
        
        btnLive.isSelected = false
        btnDeveloper.isSelected = false
        btnStaging.isSelected = false
        
        sender.isSelected = true
        
        if sender == btnLive {
            appMode = .live
        } else if sender == btnDeveloper {
            appMode = .developer
        } else {
            appMode = .staging
        }
    }
    
    @IBAction func onClickBtnLeft(_ sender: Any) {
        self.onClickLeftButton!();
    }
    
    @IBAction func onClickBtnRight(_ sender: Any) {
        self.onClickRightButton!();
        if AppMode.currentMode != self.appMode {
            if preferenceHelper.getUserId() == "" {
                APPDELEGATE.removeFirebaseTokenAndTopic()
                preferenceHelper.setSessionToken("")
                preferenceHelper.setSubStoreId("")
                clearScreenVisibilityPermission()
                AppMode.currentMode = self.appMode
                APPDELEGATE.goToSplash()
                StoreSingleton.shared.cart.removeAll()
            } else {
                wsLogout()
            }
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
                AppMode.currentMode = self.appMode
                APPDELEGATE.goToSplash()
                StoreSingleton.shared.cart.removeAll()
                return
                
            }else {
                
            }
        }
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
}
