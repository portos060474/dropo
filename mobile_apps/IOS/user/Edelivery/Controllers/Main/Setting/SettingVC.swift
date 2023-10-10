//
//  SettingVC.swift
//  edelivery
//
//  Created by Elluminati on 14/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class SettingVC: BaseVC {
   
    /*View For Language Notification*/
    @IBOutlet weak var lblLanguageMessage: UILabel!
    @IBOutlet weak var viewForLanguage: UIView!
    
    /*View For Store Image Loading*/
    @IBOutlet weak var viewForStoreImage: UIView!
    @IBOutlet weak var lblStoreImageTitle: UILabel!
    @IBOutlet weak var lblStoreImageMsg: UILabel!
    @IBOutlet weak var switchForStoreImage: UISwitch!
    
    /*View For Item Image Loading*/
    @IBOutlet weak var viewForItemImage: UIView!
    @IBOutlet weak var lblItemImageTiltle: UILabel!
    @IBOutlet weak var lblItemImageMsg: UILabel!
    @IBOutlet weak var switchForItemImage: UISwitch!
    @IBOutlet weak var imgForDropDown: UIImageView!
    @IBOutlet weak var imgForLanguage: UIImageView!
    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action:#selector(openLanguageDialog))
        viewForLanguage.addGestureRecognizer(tap)
        viewForLanguage.isUserInteractionEnabled = true
        setLocalization()
        switchForItemImage.isOn = preferenceHelper.getIsLoadItemImage()
        switchForStoreImage.isOn = preferenceHelper.getIsLoadStoreImage()
        lblLanguageMessage.text = LocalizeLanguage.currentAppleLanguageFull()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.setBackBarItem(isNative: true)
    }
    
    @IBAction func valueChangeForStoreImage(_ sender: Any) {
        preferenceHelper.setIsLoadStoreImage(switchForStoreImage.isOn)
    }
    
    @IBAction func valueChangeForItemImage(_ sender: Any) {
        preferenceHelper.setIsLoadItemImage(switchForItemImage.isOn)
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
    
    func setLocalization() {
      
        view.backgroundColor = UIColor.themeViewBackgroundColor
        self.hideBackButtonTitle()
        self.setNavigationTitle(title: "TXT_SETTING".localizedCapitalized)
       
        /*set Color*/
        lblStoreImageTitle.textColor = UIColor.themeTextColor
        lblItemImageTiltle.textColor = UIColor.themeTextColor
        lblStoreImageMsg.textColor = UIColor.themeLightTextColor
        lblItemImageMsg.textColor = UIColor.themeLightTextColor
        lblLanguageMessage.textColor = UIColor.themeTextColor
       
        /*set font*/
        lblStoreImageTitle.font = FontHelper.textRegular()
        lblItemImageTiltle.font = FontHelper.textRegular()
        lblItemImageMsg.font = FontHelper.tiny()
        lblStoreImageMsg.font = FontHelper.tiny()
        lblLanguageMessage.font = FontHelper.textMedium()
        
        /*set Localized Text*/
        lblStoreImageTitle.text = "TXT_STORE_IMAGE_TITLE".localized
        lblStoreImageMsg.text = "MSG_STORE_IMAGE".localized
        lblItemImageTiltle.text = "TXT_ITEM_IMAGE_TITLE".localized
        lblItemImageMsg.text = "MSG_ITEM_IMAGE".localized
        lblLanguageMessage.text = "MSG_LANGUAGE".localized
        self.view.layoutIfNeeded()
        
        /*View For Language Overlay*/
        updateUIAccordingToTheme()
        imgForLanguage.image = UIImage(named: "language")?.imageWithColor(color: .themeTitleColor)
        
    }
    override func updateUIAccordingToTheme() {
        imgForDropDown.image = UIImage.init(named: "dropdown")?.imageWithColor(color: .themeIconTintColor)!
         self.setBackBarItem(isNative: true)
        imgForLanguage.image = UIImage(named: "language")?.imageWithColor(color: .themeTitleColor)
    }
    

    //MARK: Button action methods
    
    @objc func openLanguageDialog() {
        openLanguageActionSheet()
    }
    
    func openLanguageActionSheet(){
            
        let alertController = UIAlertController(title: nil, message: "TXT_CHANGE_LANGUAGE".localized, preferredStyle: .actionSheet)
                
            for i in arrForLanguages{
                let action = UIAlertAction(title: i.language , style: .default, handler: { (alert: UIAlertAction!) -> Void in
                    print(alert.title!)

                    print(arrForLanguages.firstIndex(where: {$0.language == alert.title!})!)
                    if arrForLanguages.firstIndex(where: {$0.language == alert.title!})! == preferenceHelper.getLanguage(){
                        self.dismiss(animated: true, completion: nil)
                    }else{
                        super.changed(arrForLanguages.firstIndex(where: {$0.language == alert.title!})!)
                    }
                })
                alertController.addAction(action)
            }

            if let popoverController = alertController.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            
            self.present(alertController, animated: true, completion: nil)
        }
    
}
