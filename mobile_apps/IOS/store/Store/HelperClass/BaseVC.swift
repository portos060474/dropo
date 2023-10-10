//
//  BaseVC.swift
// Edelivery Store Use
//
//  Created by Elluminati iMac on 10/05/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit

protocol RightDelegate: AnyObject{
    func onClickRightButton()
}
protocol LeftDelegate: AnyObject{
    func onClickLeftButton()
}

public class LeftBarButton: UIButton {
    override public var alignmentRectInsets: UIEdgeInsets {
        return UIEdgeInsets(top:0, left: 8, bottom: 0, right: -8)
    }
}

class BaseVC: UIViewController{
    var animPop: Bool?
    weak var delegateRight:RightDelegate?
    weak var delegateLeft:LeftDelegate?
    let button = UIButton.init(type: .custom)
    
    //MARK: View life cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Log.d("\(self) \(#function)")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        Log.d("\(self) \(#function)")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        Log.d("\(self) \(#function)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let yourBackImage = UIImage(named: "back")?.imageWithColor(color: .themeIconTintColor)
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.backItem?.title = ""
        if #available(iOS 14.0, *) {
            self.navigationItem.backButtonDisplayMode = .minimal
            self.navigationController?.navigationItem.backButtonDisplayMode = .minimal
        }
        self.hideBackButtonTitle()

        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .systemBackground
            self.navigationController?.navigationBar.standardAppearance = appearance;
            self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
        }

    }
    
    func setMenuButton(){
        let  btnMenu:UIBarButtonItem!;
        let customButton = LeftBarButton.init(frame: CGRect.zero)
        customButton.setImage(UIImage.init(named: "menu_icon")?.imageWithColor(color: .themeIconTintColor), for: .normal)
        customButton.translatesAutoresizingMaskIntoConstraints = false;
        if LocalizeLanguage.isRTL {
            customButton.setImage( customButton.image(for: .normal)?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)
        }
        let positiveSeparator = UIBarButtonItem(barButtonSystemItem:.fixedSpace, target: nil, action: nil)
        positiveSeparator.width = -8
        customButton.addTarget(self.revealViewController(), action: #selector(PBRevealViewController.revealSideView), for: .touchUpInside)
        btnMenu = UIBarButtonItem.init(customView: customButton)
        self.navigationItem.leftBarButtonItems = [positiveSeparator, btnMenu]
    }
    
    func openLanguageActionSheet(){
        let alertController = UIAlertController(title: nil, message: "TXT_SELECT_LANGUAGE".localizedCapitalized, preferredStyle: .actionSheet)
            
        for i in arrForLanguages{
            let action = UIAlertAction(title: i.language , style: .default, handler: { (alert: UIAlertAction!) -> Void in
                print(alert.title!)

                print(arrForLanguages.firstIndex(where: {$0.language == alert.title!})!)
                if arrForLanguages.firstIndex(where: {$0.language == alert.title!})! == preferenceHelper.getLanguage(){
                    self.dismiss(animated: true, completion: nil)
                }else{
                    self.changed(arrForLanguages.firstIndex(where: {$0.language == alert.title!})!)
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
    
    @IBAction func changed(_ language: Int) {
        var transition: UIView.AnimationOptions = .transitionFlipFromLeft
        LocalizeLanguage.setAppleLanguageTo(lang: language)
        
        transition = .transitionFlipFromRight
        if arrForLanguages[language].code == "ar" {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }else {
            transition = .transitionFlipFromRight
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
        
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "Main", bundle: nil)

//        let storyBoard: UIStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let mainVC = mainView.instantiateViewController(withIdentifier: "orderStoryboard")
        let navigation = UINavigationController(rootViewController: mainVC)
        let leftViewController = mainView.instantiateViewController(withIdentifier: "SideMenuVC")
        
        let revealViewController:PBRevealViewController = PBRevealViewController.init(sideViewController: leftViewController, mainViewController: navigation)

        
//        let vC: UIViewController? = storyBoard.instantiateInitialViewController()
        selectedLanguage = arrForLanguages[language].code
        
        for i in 0...ConstantsLang.adminLanguages.count-1{
            if ConstantsLang.adminLanguages[i].languageCode == arrForLanguages[language].code{
                ConstantsLang.AdminLanguageCodeSelected = ConstantsLang.adminLanguages[i].languageCode
                ConstantsLang.AdminLanguageIndexSelected = i
                break
            }else{
                ConstantsLang.AdminLanguageCodeSelected = "en"
                ConstantsLang.AdminLanguageIndexSelected = 0
            }
        }
        
        if ConstantsLang.storeLanguages.count > 0{
            for i in 0...ConstantsLang.storeLanguages.count-1{
                if ConstantsLang.storeLanguages[i].code == arrForLanguages[language].code && ConstantsLang.storeLanguages[i].is_visible == true {
                    ConstantsLang.StoreLanguageCodeSelected = ConstantsLang.storeLanguages[i].code
                    ConstantsLang.StoreLanguageIndexSelected = i
                    break
                }else{
                    ConstantsLang.StoreLanguageCodeSelected = "en"
                    ConstantsLang.StoreLanguageIndexSelected = 0
                }
            }
        }
        
        preferenceHelper.setLanguageAdminInd(ConstantsLang.AdminLanguageIndexSelected)
        preferenceHelper.setLanguageAdminLang(ConstantsLang.AdminLanguageCodeSelected)
        preferenceHelper.setLanguageStoreInd(ConstantsLang.StoreLanguageIndexSelected)
        preferenceHelper.setLanguageStoreLang(ConstantsLang.StoreLanguageCodeSelected)
        
        print("ConstantsLang.AdminLanguageCodeSelected \(ConstantsLang.AdminLanguageCodeSelected)")
        print("ConstantsLang.AdminLanguageIndexSelected \(ConstantsLang.AdminLanguageIndexSelected)")
        print("ConstantsLang.StoreLanguageCodeSelected \(ConstantsLang.StoreLanguageCodeSelected)")
        print("ConstantsLang.StoreLanguageIndexSelected \(ConstantsLang.StoreLanguageIndexSelected)")

        //to call getItem api as we change language
        ItemListVC.isCallGetItemAPI = true
        
//        rootviewcontroller.rootViewController = vC
        rootviewcontroller.rootViewController = revealViewController
        
        let mainwindow = (UIApplication.shared.delegate?.window!)!
        mainwindow.backgroundColor = UIColor(hue: 0.6477, saturation: 0.6314, brightness: 0.6077, alpha: 0.8)
        UIView.transition(with: mainwindow, duration: 0.55001, options: transition, animations: { () -> Void in
        }) { (finished) -> Void in
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateUIAccordingToTheme()
    }
    
    func updateUIAccordingToTheme(){
    }
    
    //MARK: Hide Back Button Title
    @objc func onClickBackBarItem() {
        _ = self.navigationController?.popViewController(animated: animPop!)
    }
    @objc func onClickLeftBarItem() {
        delegateLeft?.onClickLeftButton()
    }
    //MARK: Set Back Button Item
    func setBackBarItem(isNative: Bool) {
        
        self.navigationItem.hidesBackButton = true
        let  myBackButton:UIBarButtonItem!;
        let customButton = LeftBarButton.init(frame: CGRect.zero)
        customButton.setImage(UIImage.init(named: "back")?.imageWithColor(color: .themeIconTintColor), for: .normal)
        customButton.translatesAutoresizingMaskIntoConstraints = false;
        
        if LocalizeLanguage.isRTL {
            customButton.setImage( customButton.image(for: .normal)?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)
        }
        let positiveSeparator = UIBarButtonItem(barButtonSystemItem:.fixedSpace, target: nil, action: nil)
        positiveSeparator.width = -8
        
        if isNative {
            customButton.addTarget(self, action: #selector(onClickBackBarItem), for: .touchUpInside)
        }else{
            customButton.addTarget(self, action: #selector(onClickLeftBarItem), for: .touchUpInside)
        }
        myBackButton = UIBarButtonItem.init(customView: customButton)
        self.navigationItem.leftBarButtonItems = [positiveSeparator, myBackButton]
    }
    
    func hideBackButtonTitle() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
    }
    //MARK: Set Right Button Item
    func setRightBarItem(isNative: Bool){
        //button.setImage(UIImage.init(named: "backBlackIcon"), for: UIControlState.normal)
        if isNative {
            button.addTarget(self, action:#selector(BaseVC.onClickRightBarItem), for: UIControl.Event.touchUpInside)
        }else {
            button.addTarget(self, action:#selector(BaseVC.onClickRightButtonItem), for: UIControl.Event.touchUpInside)
        }
        button.frame = CGRect.init(x: 0, y: 0, width: 45, height: 25)
        button.titleLabel?.textAlignment = NSTextAlignment.center

        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    func setrightBarItemBG(color:UIColor = .themeColor){
        button.backgroundColor = color
        button.layer.cornerRadius = 2.0
        button.titleLabel?.font = FontHelper.labelRegular()
    }
    func setRightBarItemImage(image:UIImage, title:String = "", mode:UIView.ContentMode = .scaleAspectFit){
        button.setImage(image, for: UIControl.State.normal)
        button.setTitle(title, for: UIControl.State.normal)
        button.imageView?.contentMode = mode;
    }
    
    func setRightBarButton(button:UIButton){
        
        button.addTarget(self, action:#selector(BaseVC.onClickRightButtonItem), for: UIControl.Event.touchUpInside)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
    }
    func removerRightButton(){
        self.navigationItem.rightBarButtonItem = nil
    }
    
    
    //MARK: On Click Right Button
    @objc func onClickRightBarItem() {
        print("Native Right Button Call")
    }
    @objc func onClickRightButtonItem() {
        delegateRight?.onClickRightButton()
    }
    func setNavigationTitle(title:String) -> Void {
        let lbl:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        lbl.textAlignment = .center
        lbl.backgroundColor = UIColor.clear
        lbl.font = FontHelper.textRegular()
        lbl.textColor = UIColor.themeTitleColor
        lbl.text = title
        self.navigationItem.titleView = lbl
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
}


public class Model {
    deinit {
        Log.d("\(self) \(#function)")
    }
}

public class ModelNSObj: NSObject {
    deinit {
        Log.d("\(self) \(#function)")
    }
}

protocol keyboardWasShownDelegate: class {
    func keyboardWasShown(notification: NSNotification)
}

protocol keyboardWillBeHiddenDelegate: class{
    func keyboardWillBeHidden(notification: NSNotification)
}

public class CustomDialog: UIView {
    weak var delegatekeyboardWasShown:keyboardWasShownDelegate?
    weak var delegatekeyboardWillBeHidden:keyboardWillBeHiddenDelegate?
    
    
    deinit {
        Log.d("\(self) \(#function)")
        deregisterFromKeyboardNotifications()
    }
    
//    func animationBottomTOTop(_ viewToAnimate : UIView ) {
//        let viewframe = viewToAnimate.frame
//        viewToAnimate.isHidden = true
//
//        viewToAnimate.frame = CGRect.init(x: viewframe.origin.x, y: viewToAnimate.frame.height, width: viewframe.size.width , height: viewframe.size.height)
//
//
//        viewToAnimate.isHidden = false
//        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut],
//                       animations: {
//
//
//
//                        viewToAnimate.frame = CGRect.init(x: viewframe.origin.x, y: (viewToAnimate.frame.size.height - viewframe.size.height), width: (viewframe.size.width), height: viewframe.size.height)
//
//
//                       }, completion: { test in
//
//                       }
//        )
//    }
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        updateUIAccordingToTheme()
    }
    func updateUIAccordingToTheme() {
        
    }
    
    func registerForKeyboardObserver(){
        deregisterFromKeyboardNotifications()
        registerForKeyboardNotifications()
    }
    
    public override class func transition(from fromView: UIView, to toView: UIView, duration: TimeInterval, options: UIView.AnimationOptions = [], completion: ((Bool) -> Void)? = nil) {
        
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

class CustomCell: UITableViewCell {
    @IBOutlet weak var vBG: UIView!

    deinit {
        Log.d("\(self) \(#function)")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .themeViewBackgroundColor
        if vBG != nil{
            vBG.backgroundColor = .themeViewBackgroundColor
//            vBG.setRound(withBorderColor: .themeLightTextColor, andCornerRadious: 5.0, borderWidth: 0.3)
            vBG.applyShadowToView()
        }
    }
}



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

