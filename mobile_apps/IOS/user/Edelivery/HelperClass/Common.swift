//
//  Common.swift
//  HyrydeDriver
//
//  Created by Mac Pro5 on 04/09/19.
//  Copyright © 2019 KetanMR_Elluminati. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class Common: NSObject {
    
    static let screenRect = UIScreen.main.bounds
    static let screenScale = UIScreen.main.scale
    static let screenH568 = Common.screenRect.height <= 568.0  
    static let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    static let bundleId = Bundle.main.bundleIdentifier ?? ""
    static let bundleVersion: String = (Bundle.main.infoDictionary?["CFBundleVersion"] ?? "") as! String
    static let safeAreaInsets = Common.appDelegate.window?.safeAreaInsets ?? UIEdgeInsets.zero
    static let nCd = NotificationCenter.default
    static let defaultNtf = Notification(name: Notification.Name("defaultNtf"))
    static let localizeNtfNm = Notification.Name(rawValue: "localizeNtfNm")
    static let locationKey = "location"
    static let locationErrorKey = "locationError"
    static let locationUpdateNtfNm = Notification.Name(rawValue: "locationUpdateNtfNm")
    static let locationFailNtfNm = Notification.Name(rawValue: "locationFailNtfNm")
    static let animationDuration = 0.250
    static let alphaVwBg: CGFloat = 0.55
    static let locale = Locale.current
    static let calendar = Calendar.current
  
    // MARK: -
    class func err(dscpt d: String) -> NSError? {
        if d.isEmpty {
            return nil
        }
        return NSError(domain: "NSError domain", 
                       code: -1, 
                       userInfo: [NSLocalizedDescriptionKey: d])
    }
    
    class func openSettingsApp() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("SettingsApp opened: \(success)")
            })
        }
    }
    
    class func IQNext() {
        if IQKeyboardManager.shared.canGoNext {
            IQKeyboardManager.shared.goNext()
        }
        else {
            print("\(#function) failed")
        }
    }
    
    class func IQPrevious() {
        if IQKeyboardManager.shared.canGoPrevious {
            IQKeyboardManager.shared.goPrevious()
        }
        else {
            print("\(#function) failed")
        }
    }
    
    class func alert(_ title: String = "", _ message: String = "") {
        OperationQueue.main.addOperation { 
            let aC = UIAlertController(title: title, 
                                       message: message, 
                                       preferredStyle: UIAlertController.Style.alert)
            
            let act = UIAlertAction(title: "Dismiss", 
                                    style: UIAlertAction.Style.default) {
                                        [weak aC] (act: UIAlertAction) in
                                        print("\(aC?.actions.first?.title ?? "") tapped")
            }
            
            aC.addAction(act)
            
            let vC = Common.appDelegate.window?.rootViewController
            vC?.present(aC, animated: true, completion: { [weak aC] in
                print("\(aC?.message ?? "") presented")
            })
        }
    }
    
}
