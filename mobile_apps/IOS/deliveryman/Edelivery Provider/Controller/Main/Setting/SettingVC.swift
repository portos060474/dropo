//
//  SettingVC.swift
//  edelivery
//
//  Created by Elluminati on 14/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
//import Crashlytics
import FirebaseCrashlytics

class SettingVC: BaseVC {
   
    /*View For Request Push Notification*/
    @IBOutlet weak var viewForRequestPushNotification: UIView!
    @IBOutlet weak var lblRequestPushTitle: UILabel!
    @IBOutlet weak var lblRequestPushMessage: UILabel!
    @IBOutlet weak var switchForRequestPushSound: UISwitch!
    
    /*View For Pickup Push Notification*/
    @IBOutlet weak var viewForPickupPushNotification: UIView!
    @IBOutlet weak var lblPickupPushTitle: UILabel!
    @IBOutlet weak var lblpickupPushMessage: UILabel!
    @IBOutlet weak var switchForPickupPushSound: UISwitch!
  
    /*View For Push Notification*/
    @IBOutlet weak var viewForPushNotification: UIView!
    @IBOutlet weak var lblPushTitle: UILabel!
    @IBOutlet weak var lblPushMessage: UILabel!
    @IBOutlet weak var switchForPushSound: UISwitch!
   
    /*View For Language Notification*/
    @IBOutlet weak var viewForLanguage: UIView!
    @IBOutlet weak var lblLanguageTitle: UILabel!
    @IBOutlet weak var lblLanguageMessage: UILabel!
    @IBOutlet weak var imageForLanguage: UIImageView!
   
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalization()
        let tap = UITapGestureRecognizer(target: self, action:#selector(openLanguageDialog))
        viewForLanguage.addGestureRecognizer(tap)
        viewForLanguage.isUserInteractionEnabled = true
        viewForLanguage.isHidden = true
    }
    
    @objc func openLanguageDialog() {
        self.openLanguageActionSheet()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switchForRequestPushSound.isOn = preferenceHelper.getIsRequesetAlert()
        switchForPushSound.isOn = preferenceHelper.getIsPushSoundOn()
    }
   
    override func updateUIAccordingToTheme() {
        self.setLocalization()
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool){
        super.viewDidDisappear(animated)
    }
    
    @IBAction func onChangeRequestSound(_ sender: Any) {
        preferenceHelper.setIsRequesetAlert(switchForRequestPushSound.isOn)
    }
    
    @IBAction func onChangePushSound(_ sender: Any) {
        preferenceHelper.setIsPushSoundOn(switchForPushSound.isOn)
    }
    
    func setLocalization() {
        
        viewForPushNotification.isHidden = true
        view.backgroundColor = UIColor.themeAlertViewBackgroundColor;
        self.hideBackButtonTitle()
        self.setNavigationTitle(title: "TXT_SETTING".localizedCapitalized)
        /*set Color*/
        lblPushTitle.textColor = UIColor.themeTextColor
        lblRequestPushTitle.textColor = UIColor.themeTextColor
        lblLanguageTitle.textColor = UIColor.themeTextColor
        lblPickupPushTitle.textColor = UIColor.themeTextColor
        lblpickupPushMessage.textColor = UIColor.themeLightTextColor
        lblRequestPushMessage.textColor = UIColor.themeLightTextColor
        lblPushMessage.textColor = UIColor.themeLightTextColor
        lblLanguageMessage.textColor = UIColor.themeLightTextColor
        /*set font*/
        lblPushTitle.font = FontHelper.textRegular()
        lblRequestPushTitle.font = FontHelper.textRegular()
        lblLanguageTitle.font = FontHelper.textRegular()
        lblPickupPushTitle.font = FontHelper.textRegular()
        lblpickupPushMessage.font = FontHelper.textSmall(size: 12)
        lblRequestPushMessage.font = FontHelper.textSmall(size: 12)
        lblPushMessage.font = FontHelper.textSmall(size: 12)
        lblLanguageMessage.font = FontHelper.textSmall(size: 12)
        /*set Localized Text*/
        lblPushTitle.text = "TXT_PUSH_NOTIFICATION".localized
        lblRequestPushTitle.text = "TXT_REQUEST_ALERT".localized
        lblLanguageTitle.text = "TXT_LANGUAGE".localized
        lblPickupPushTitle.text = "TXT_PICKUP_ALERT".localized
        lblpickupPushMessage.text = "MSG_PICKUP_ALERT".localized
        lblRequestPushMessage.text = "MSG_REQUEST_ALERT".localized
        lblPushMessage.text = "MSG_PUSH_NOTIFICATION".localized
        lblLanguageMessage.text = "MSG_LANGUAGE".localized
        lblLanguageMessage.text = LocalizeLanguage.currentAppleLanguageFull()
        imageForLanguage.image = UIImage.init(named: "language")?.imageWithColor(color: .themeIconTintColor)
        self.view.layoutIfNeeded()
    }
}
