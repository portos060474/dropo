//
//  BaseVC.swift
//  Edelivery Use
//
//  Created by Elluminati iMac on 10/05/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseMessaging

protocol RightDelegate: NSObjectProtocol {
    func onClickRightButton()
}

protocol LeftDelegate: NSObjectProtocol {
    func onClickLeftButton()
}

public class LeftBarButton: UIButton {
    
    override public var alignmentRectInsets: UIEdgeInsets {
        return UIEdgeInsets(top:0, left: 8, bottom: 0, right: -8)
    }
}

class BaseVC: UIViewController{
    var animPop: Bool?
    weak var delegateRight: RightDelegate?
    weak var delegateLeft: LeftDelegate?
    
    let button = UIButton.init(type: .custom)
    var timeInterval: TimeInterval = 0.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
         printE("\(self) \(#function)")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
         printE("\(self) \(#function)")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        printE("\(self) \(#function)")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var yourBackImage = UIImage()
        yourBackImage = UIImage(named: "back_black")!

        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.backItem?.title = ""
        self.hideKeyboardWhenTappedAround()
        self.hideBackButtonTitle()
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .systemBackground
            self.navigationController?.navigationBar.standardAppearance = appearance;
            self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setupNetworkReachability()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: APPDELEGATE.reachability)
    }
    
    func changed(_ language: Int) {
        
        isChangedLanguageFromSettings = true
        var transition: UIView.AnimationOptions = .transitionFlipFromLeft
        var languageSelectedCode : String = "en"
        var languageSelectedInt : Int = 0
        
     for obj in arrLanguages {
        if (obj.code == arrForLanguages[language].code){
              languageSelectedCode = obj.code!
              languageSelectedInt = arrLanguages.index(where: { $0.code == obj.code })!
              break
          }
        }
        
        print("languageSelectedInt \(languageSelectedInt)")
        print("languageSelectedCode \(languageSelectedCode)")

        Constants.selectedLanguageCode = languageSelectedCode
        Constants.selectedLanguageIndex = "\(languageSelectedInt)"
               
        preferenceHelper.setSelectedLanguage(languageSelectedInt)
        preferenceHelper.setSelectedLanguageCode(str: languageSelectedCode)

        for i in 0...arrForLanguages.count-1{
            if arrForLanguages[i].code == preferenceHelper.getSelectedLanguageCode(){
                preferenceHelper.setLanguage(i)
            }
        }
        
        LocalizeLanguage.setAppleLanguageTo(lang: language)

        if Constants.selectedLanguageCode == "ar" {
          UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }else {
            transition = .transitionFlipFromRight
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }

       Alamofire.Session.default.session.cancelTasks { [] in
            let appWindow: UIWindow? = APPDELEGATE.window
            let storyBoard: UIStoryboard = UIStoryboard.init(name: "MainStoryboard", bundle: nil)
            let vC: UIViewController? = storyBoard.instantiateInitialViewController()
            
            appWindow?.removeFromSuperviewAndNCObserver()
            appWindow?.rootViewController?.removeFromParentAndNCObserver()
            appWindow?.rootViewController = vC
            appWindow?.makeKeyAndVisible()
            appWindow?.backgroundColor = UIColor(hue: 0.6477, saturation: 0.6314, brightness: 0.6077, alpha: 0.8)
            
            UIView.transition(with: appWindow ?? UIWindow(),
                              duration: 0.5,
                              options: transition,
                              animations: { () -> Void in
            }) { (finished) -> Void in
                appWindow?.backgroundColor = UIColor.clear
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
  

    //MARK: Hide Back Button Title
    func hideBackButtonTitle() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
    }
    

    //MARK: Set Back Button Item
    func setBackBarItem(isNative: Bool) {
        
        self.navigationItem.hidesBackButton = true
        let  myBackButton:UIBarButtonItem!
        let customButton = LeftBarButton.init(frame: CGRect.zero)
        customButton.setImage(UIImage.init(named: "back_black")?.imageWithColor(color: UIColor.themeTitleColor), for: .normal)
        
        if LocalizeLanguage.isRTL {
            customButton.setImage( customButton.image(for: .normal)?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)
        }
        customButton.translatesAutoresizingMaskIntoConstraints = false

        let positiveSeparator = UIBarButtonItem(barButtonSystemItem:.fixedSpace, target: nil, action: nil)
        positiveSeparator.width = -8
        
        if isNative {
            customButton.addTarget(self, action: #selector(onClickBackBarItem), for: .touchUpInside)
        }
        else{
            customButton.addTarget(self, action: #selector(onClickLeftBarItem), for: .touchUpInside)
            
        }
        myBackButton = UIBarButtonItem.init(customView: customButton)
        self.navigationItem.leftBarButtonItems = [positiveSeparator, myBackButton]
    }
    

    //MARK: Set Right Button Item
    func setRightBarItem(isNative: Bool){
        button.setImage(UIImage.init(named: "back_icon")?.imageWithColor(color: UIColor.themeTitleColor), for: UIControl.State.normal)
        if LocalizeLanguage.isRTL {
            button.setImage( button.image(for: .normal)?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)
        }
        if isNative {
            button.addTarget(self, action:#selector(BaseVC.onClickRightBarItem), for: UIControl.Event.touchUpInside)
        }else {
            button.addTarget(self, action:#selector(BaseVC.onClickRightButtonItem), for: UIControl.Event.touchUpInside)
        }
        button.frame = CGRect.init(x: 0, y: 0, width: 45, height: 25)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    func setrightBarItemBG(color:UIColor = .themeRedColor){
         button.backgroundColor = color
         button.layer.cornerRadius = 2.0
         button.titleLabel?.font = FontHelper.labelRegular()
     }
    
    func setRightBarItemImage(image:UIImage, title:String = "", mode:UIView.ContentMode = .scaleAspectFit){
        button.setImage(image.imageWithColor(color: UIColor.themeColor), for: UIControl.State.normal)
        button.setTitle(title, for: UIControl.State.normal)
        button.imageView?.contentMode = mode
        
    }
    
    func setRightBarButton(button:UIButton){
        
        button.addTarget(self, action:#selector(BaseVC.onClickRightButtonItem), for: UIControl.Event.touchUpInside)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
    }
    

    //MARK: On Click Left Button
    @objc func onClickBackBarItem() {
        _ = self.navigationController?.popViewController(animated: animPop ?? true)
    }
    
    @objc func onClickLeftBarItem() {
        self.delegateLeft?.onClickLeftButton()
    }
    

    //MARK: On Click Right Button
    @objc func onClickRightBarItem() {
    }
    
    @objc func onClickRightButtonItem() {
        self.delegateRight?.onClickRightButton()
    }
   
    func setNavigationTitle(title:String) -> Void {
        let lbl:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        lbl.textAlignment = .center
        lbl.backgroundColor = UIColor.clear
        lbl.font = FontHelper.textMedium()
        lbl.textColor = UIColor.themeTitleColor
        lbl.text = title
        self.navigationItem.titleView = lbl
    }
    
    //MARK: - NEtwork reachability
    func setupNetworkReachability() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: APPDELEGATE.reachability)
    }
    
    @objc func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        
        if reachability.isReachable {
            self.networkEstablishAgain()
        }else {
            self.networklost()
            
        }
    }
    
    func networkEstablishAgain() {
        printE("\(self.description) Network reachable")
    }
    
    func networklost() {
        printE("\(self.description) Network not reachable")
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            updateUIAccordingToTheme()
        }
    func updateUIAccordingToTheme(){
        
    }
}

//MARK : View Controller Extension

extension UIViewController {
    public func removeFromParentAndNCObserver() {
        for childVC in self.children {
            childVC.removeFromParentAndNCObserver()
        }
        
        if self.isKind(of: UINavigationController.classForCoder()) {
            (self as! UINavigationController).viewControllers = []
        }
        
        self.dismiss(animated: false, completion: nil)
        self.view.removeFromSuperviewAndNCObserver()
        NotificationCenter.default.removeObserver(self)
        self.removeFromParent()
    }
}

extension UIView {
    public func removeFromSuperviewAndNCObserver() {
        for subvw in self.subviews {
            subvw.removeFromSuperviewAndNCObserver()
        }
        
        NotificationCenter.default.removeObserver(self)
        self.removeFromSuperview()
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

public class Model {
    deinit {
        printE("\(self) \(#function)")
    }
}

public class ModelNSObj: NSObject {
    deinit {
        printE("\(self) \(#function)")
    }
}
protocol keyboardWasShownDelegate: class{
    func keyboardWasShown(notification: NSNotification)
}

protocol keyboardWillBeHiddenDelegate: class{
    func keyboardWillBeHidden(notification: NSNotification)
}
public class CustomDialog: UIView {
    
    weak var delegatekeyboardWasShown:keyboardWasShownDelegate?
    weak var delegatekeyboardWillBeHidden:keyboardWillBeHiddenDelegate?
     
    deinit {
        printE("\(self) \(#function)")
        deregisterFromKeyboardNotifications()
    }
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        updateUIAccordingToTheme()
    }
    func updateUIAccordingToTheme() {
    
    }
    // MARK: - Keyboard methods
       func registerForKeyboardNotifications()
       {
           //Adding notifies on keyboard appearing
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
       }
       
       
       func deregisterFromKeyboardNotifications()
       {
           //Removing notifies on keyboard appearing
           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
       }
       
       @objc func keyboardWasShown(notification: NSNotification){
           delegatekeyboardWasShown?.keyboardWasShown(notification: notification)
       }
       
       @objc func keyboardWillBeHidden(notification: NSNotification)
       {
           delegatekeyboardWillBeHidden?.keyboardWillBeHidden(notification: notification)
       }
}


public class CustomTableCell: UITableViewCell {
    deinit {
        printE("\(self) \(#function)")
    }
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
    }
    func updateUIAccordingToTheme()  {
        
    }
}

public class CustomCollectionCell: UICollectionViewCell {
    deinit {
        printE("\(self) \(#function)")
    }
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
    }
    func updateUIAccordingToTheme()  {
        
    }
}
extension UINavigationController {
    
    override open var shouldAutorotate: Bool {
        get {
            if visibleViewController != nil {
                return false
            }
            return false
        }
    }
    
    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        get {
            if visibleViewController != nil {
                return .portrait
            }
            return .portrait
        }
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get {
            if visibleViewController != nil {
                return .portrait
            }
            return .portrait
        }
    }
}

