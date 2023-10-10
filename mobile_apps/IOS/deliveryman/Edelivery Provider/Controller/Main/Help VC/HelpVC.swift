//
//  ShareVC.swift
//  edelivery
//
//  Created by Elluminati on 14/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class HelpVC: BaseVC {

//MARK: OutLets
    @IBOutlet weak var btnMail: UIButton!
    @IBOutlet weak var btnTerms: UIButton!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var btnPrivacy: UIButton!
    
//MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalization()
     }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
    func setLocalization() {
        view.backgroundColor = UIColor.themeViewBackgroundColor;
        self.hideBackButtonTitle()
        btnMail.setTitle("  " + "TXT_MAIL".localizedCapitalized, for: .normal)
        btnCall.setTitle("  " + "TXT_CALL_NOW".localizedCapitalized, for: .normal)
        btnMail.setTitleColor(.themeColor, for: .normal)
        btnCall.setTitleColor(.themeColor, for: .normal)
        btnMail.imageView?.tintColor = .themeColor
        btnCall.imageView?.tintColor = .themeColor
        btnCall.setImage(UIImage.init(named: "callIcon")?.imageWithColor(), for: .normal)
        btnMail.setImage(UIImage.init(named: "mailIcon")?.imageWithColor(), for: .normal)
        let textRange = NSMakeRange(0, "TXT_TERMS_AND_CONDITIONS".localizedCapitalized.count)
        let attributedText = NSMutableAttributedString(string: "TXT_TERMS_AND_CONDITIONS".localizedCapitalized)
        attributedText.setAttributes(convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font) : FontHelper.textRegular()
            , convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor.themeColor]), range: textRange)
        attributedText.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: textRange)
        btnTerms.setAttributedTitle(attributedText, for: .normal)
        let textRange2 = NSMakeRange(0, "TXT_PRIVACY_POLICIES".localizedCapitalized.count)
        let attributedText2 = NSMutableAttributedString(string: "TXT_PRIVACY_POLICIES".localizedCapitalized)
        attributedText2.setAttributes(convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font) : FontHelper.textRegular()
            , convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor.themeColor]), range: textRange2)
        attributedText2.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: textRange2)
         btnPrivacy.setAttributedTitle(attributedText2, for: .normal)
        self.setNavigationTitle(title: "TXT_HELP_CENTER".localizedCapitalized)
    }

    @IBAction func onClickBtnTerms(_ sender: UIButton) {
        
        guard let url = URL(string: WebService.USER_PANEL_URL + "legal/provider-terms-conditions") else {
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }

    @IBAction func onClickBtnPrivacy(_ sender: Any) {
        
        guard let url = URL(string: WebService.USER_PANEL_URL + "legal/provider-privacy-policy") else {
            return 
        }

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }

    @IBAction func onClickbtnCall(_ sender: Any) {
        if let url = URL(string: "tel://\(preferenceHelper.getAdminContact())"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }

    @IBAction func onClickBtnMail(_ sender: Any) {
        let email = preferenceHelper.getAdminEmail()
        let url = URL(string: "mailto:\(email)")

        if #available(iOS 10, *) {
            UIApplication.shared.open(url!)
        } else {
            UIApplication.shared.openURL(url!)
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
