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
    
    @IBOutlet weak var viewTextLocation: UIView!
    @IBOutlet weak var switchLocation: UISwitch!
    @IBOutlet weak var txtLat: UITextField!
    @IBOutlet weak var txtLong: UITextField!

    var onClickRightButton : (() -> Void)? = nil
    var onClickLeftButton : (() -> Void)? = nil
    
    var appMode: AppMode = .live
    
    static let  verificationDialog = "DialogForApplicationMode"

    public override func awakeFromNib() {
        super.awakeFromNib()
        btnCancel.setTitleColor(UIColor.themeLightGrayTextColor, for: .normal)
        btnCancel.titleLabel?.textColor = UIColor.themeLightGrayTextColor
        
        self.btnLive.setImage(UIImage.init(named: "radio_btn_unchecked_icon")!.imageWithColor(color: .themeLightTextColor), for: .normal)
        self.btnLive.setImage(UIImage.init(named: "radio_btn_checked_icon")!.imageWithColor(), for: .selected)
        
        self.btnDeveloper.setImage(UIImage.init(named: "radio_btn_unchecked_icon")!.imageWithColor(color: .themeLightTextColor), for: .normal)
        self.btnDeveloper.setImage(UIImage.init(named: "radio_btn_checked_icon")!.imageWithColor(), for: .selected)
        
        self.btnStaging.setImage(UIImage.init(named: "radio_btn_unchecked_icon")!.imageWithColor(color: .themeLightTextColor), for: .normal)
        self.btnStaging.setImage(UIImage.init(named: "radio_btn_checked_icon")!.imageWithColor(), for: .selected)
        
        txtLat.delegate = self
        txtLong.delegate = self
        
        if preferenceHelper.getIsCustomLocation() {
            switchLocation.isOn = true
            viewTextLocation.isHidden = !switchLocation.isOn
            let arrLocation = preferenceHelper.getCustomLocation()
            if arrLocation.count > 1 {
                txtLat.text = "\(arrLocation[0])"
                txtLong.text = "\(arrLocation[1])"
            }
        }
        
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
        if let tagView = APPDELEGATE.window?.viewWithTag(15975) as? DialogForApplicationMode {
            APPDELEGATE.window?.addSubview(tagView)
            APPDELEGATE.window?.bringSubviewToFront(tagView)
            return tagView
        } else {
            let view = UINib(nibName: verificationDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DialogForApplicationMode
            view.tag = 15975
            view.viewCard.applyShadowToView(12)
            let frame = (APPDELEGATE.window?.frame)!
            view.frame = frame
            
            APPDELEGATE.window?.addSubview(view)
            APPDELEGATE.window?.bringSubviewToFront(view)
            
            return view
        }
        
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
        if switchLocation.isOn && txtLat.text!.count == 0 {
            Utility.showToast(message: "Please Enter Latitude")
        } else if switchLocation.isOn && txtLong.text!.count == 0 {
            Utility.showToast(message: "Please Enter Longitude")
        } else {
            if AppMode.currentMode != self.appMode {
                if preferenceHelper.getUserId() == "" {
                    LocationManager().autoUpdate = false
                    preferenceHelper.setSessionToken("")
                    preferenceHelper.setUserId("")
                    preferenceHelper.setAuthToken("")
                    AppMode.currentMode = self.appMode
                    APPDELEGATE.goToSplash()
                } else {
                    wsLogout()
                }
            }
            if switchLocation.isOn {
                CurrentOrder.shared.currentLatitude = Double(txtLat.text!)!
                CurrentOrder.shared.currentLongitude = Double(txtLong.text!)!
                preferenceHelper.setCustomLocation([Double(txtLat.text!)!,Double(txtLong.text!)!])
                NotificationCenter.default.post(name: .didChangeCustomLocation, object: nil)
                preferenceHelper.setIsCustomLocation(true)
            } else {
                preferenceHelper.setCustomLocation([])
                preferenceHelper.setIsCustomLocation(false)
            }
            self.onClickRightButton!();
        }
        
    }
    
    @IBAction func switchLocationChange(_ sender: UISwitch) {
        viewTextLocation.isHidden = !sender.isOn
    }
    
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
                AppMode.currentMode = self.appMode
                APPDELEGATE.goToSplash()
            }
            Utility.hideLoading()
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
}

extension DialogForApplicationMode: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let isNumber = CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) || (textField.text!.isEmpty() && string == "-")
            let withDecimal = (
                string == NumberFormatter().decimalSeparator &&
                textField.text?.contains(string) == false
            )
        return isNumber || withDecimal
    }
}
