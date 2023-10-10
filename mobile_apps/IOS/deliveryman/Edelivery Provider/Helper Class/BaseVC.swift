//
//  BaseVC.swift
//  Edelivery Use
//
//  Created by Elluminati iMac on 10/05/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit
import Alamofire
import IQKeyboardManagerSwift

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
        print("\(self) \(#function)")
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        print("\(self) \(#function)")
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("\(self) \(#function)")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let yourBackImage = UIImage(named: "back_icon")?.imageWithColor(color: .themeIconTintColor)
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
        
        if Bundle.main.bundleIdentifier == bundleId {
            addEdgePanGesture()
        }

        IQKeyboardManager.shared.keyboardDistanceFromTextField = 10
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
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            updateUIAccordingToTheme()
        }
    func addEdgePanGesture() {
        let edgeGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self.userSwipedFromEdge(sender:)))
        edgeGestureRecognizer.edges = .right
        self.view.addGestureRecognizer(edgeGestureRecognizer)
    }
    @objc func userSwipedFromEdge(sender: UIScreenEdgePanGestureRecognizer) {
        if sender.edges == UIRectEdge.right {
            let dialog = DialogForApplicationMode.showCustomAppModeDialog()
            
            dialog.onClickLeftButton = { [unowned dialog] in
                dialog.removeFromSuperview()
            }
            
            dialog.onClickRightButton = { [unowned dialog] in
                dialog.removeFromSuperview()
            }
        }
    }
    
    func setMenuButton(){
        let  btnMenu:UIBarButtonItem!;
        let customButton = LeftBarButton.init(frame: CGRect.zero)
        customButton.tintColor = UIColor.themeIconTintColor
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
    func updateUIAccordingToTheme(){
        
    }
    func changed(_ language: Int) {
        var transition: UIView.AnimationOptions = .transitionFlipFromLeft
        
        LocalizeLanguage.setAppleLanguageTo(lang: language)
        
        if arrForLanguages[language].code == "ar" {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }else {
            transition = .transitionFlipFromRight
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        
        Alamofire.Session.default.session.cancelTasks { [unowned self] in
            
            
           
            let appWindow: UIWindow? = APPDELEGATE.window
            if self.classForCoder == LoginVC.classForCoder() {
                let storyBoard: UIStoryboard = UIStoryboard.init(name: "Home", bundle: nil)
                let viewcontroller : LoginVC = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                let nav = UINavigationController.init(rootViewController: viewcontroller)
                appWindow?.removeFromSuperviewAndNCObserver()
                appWindow?.rootViewController?.removeFromParentAndNCObserver()
                appWindow?.rootViewController = nav
                appWindow?.makeKeyAndVisible()
                appWindow?.backgroundColor = UIColor(hue: 0.6477, saturation: 0.6314, brightness: 0.6077, alpha: 0.8)
            }
            else {
                var mainView: UIStoryboard!
                mainView = UIStoryboard(name: "Main", bundle: nil)
                let mainVC = mainView.instantiateViewController(withIdentifier: "home")
                let navigation = UINavigationController(rootViewController: mainVC)
                let leftViewController = mainView.instantiateViewController(withIdentifier: "MenuVC")
    let revealViewController:PBRevealViewController = PBRevealViewController.init(sideViewController: leftViewController, mainViewController: navigation)
                appWindow?.removeFromSuperviewAndNCObserver()
                appWindow?.rootViewController?.removeFromParentAndNCObserver()
                appWindow?.rootViewController = revealViewController
                appWindow?.makeKeyAndVisible()
                appWindow?.backgroundColor = UIColor(hue: 0.6477, saturation: 0.6314, brightness: 0.6077, alpha: 0.8)
            }
            
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
    //MARK:
    //MARK: Hide Back Button Title
    func hideBackButtonTitle() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
    }
    
    func removerRightButton() {
        self.navigationItem.rightBarButtonItem = nil
        
    }
    func openLanguageActionSheet(){
        
        let alertController = UIAlertController(title: nil, message: "TXT_SELECT_LANGUAGE".localized, preferredStyle: .actionSheet)
        
        let titleAttributes = [NSAttributedString.Key.font: FontHelper.textLarge(), NSAttributedString.Key.foregroundColor: UIColor.themeTextColor]
          let titleString = NSAttributedString(string: "TXT_SELECT_LANGUAGE".localized, attributes: titleAttributes)
        
        alertController.setValue(titleString, forKey: "attributedMessage")
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
            action.setValue(UIColor.themeTextColor, forKey: "titleTextColor")
            
            alertController.addAction(action)
        }

        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    //MARK:
    //MARK: Set Back Button Item
    func setBackBarItem(isNative: Bool) {
        
        self.navigationItem.hidesBackButton = true
        
        
        let  myBackButton:UIBarButtonItem!;
        let customButton = LeftBarButton.init(frame: CGRect.zero)
        customButton.setImage(UIImage.init(named: "back_icon")?.imageWithColor(color: .themeIconTintColor), for: .normal)
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
    //MARK:
    //MARK: Set Right Button Item
    func setRightBarItem(isNative: Bool){
        button.setImage(UIImage.init(named: "back_icon")?.imageWithColor(color: .themeIconTintColor), for: UIControl.State.normal)
        if LocalizeLanguage.isRTL {
            button.setImage( button.image(for: .normal)?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)
        }
        if isNative {
            button.addTarget(self, action:#selector(BaseVC.onClickRightBarItem), for: UIControl.Event.touchUpInside)
        }else {
            button.addTarget(self, action:#selector(BaseVC.onClickRightButtonItem), for: UIControl.Event.touchUpInside)
        }
        button.frame = CGRect.init(x: 0, y: 0, width: 45, height: 25)
        button.contentHorizontalAlignment = .center
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    func setrightBarItemBG(color:UIColor = .themeColor){
        button.backgroundColor = color
        button.layer.cornerRadius = 2.0
        button.titleLabel?.font = FontHelper.labelRegular()
    }
    
    func setRightBarItemImage(image:UIImage, title:String = "", mode:UIView.ContentMode = .scaleAspectFit){
        button.setImage(image.imageWithColor(color: .themeColor), for: UIControl.State.normal)
        button.setTitle(title, for: UIControl.State.normal)
        button.imageView?.contentMode = mode;
    }
   
    func setRightBarButton(button:UIButton){
        button.addTarget(self, action:#selector(BaseVC.onClickRightButtonItem), for: UIControl.Event.touchUpInside)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    //MARK:
    //MARK: On Click Left Button
    @objc func onClickBackBarItem() {
        _ = self.navigationController?.popViewController(animated: animPop!)
    }
    @objc func onClickLeftBarItem() {
        self.delegateLeft?.onClickLeftButton()
    }
    //MARK:
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
        print("\(self.description) Network reachable")
    }
    
    func networklost() {
        print("\(self.description) Network not reachable")
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
        let tap: UITapGestureRecognizer =     UITapGestureRecognizer(target: self, action:    #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

public class Model {
    deinit {
        print("\(self) \(#function)")
    }
}

public class ModelNSObj: NSObject {
    deinit {
        print("\(self) \(#function)")
    }
}

public class CustomDialog: UIView {
    weak var delegatekeyboardWasShown:keyboardWasShownDelegate?
    weak var delegatekeyboardWillBeHidden:keyboardWillBeHiddenDelegate?
    
    
    deinit {
      //  Log.d("\(self) \(#function)")
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
protocol keyboardWasShownDelegate: class{
    func keyboardWasShown(notification: NSNotification)
}

protocol keyboardWillBeHiddenDelegate: class{
    func keyboardWillBeHidden(notification: NSNotification)
}

public class CustomTableCell: UITableViewCell {
    deinit {
        print("\(self) \(#function)")
    }
}

public class CustomCollectionCell: UICollectionViewCell {
    deinit {
        print("\(self) \(#function)")
    }
}

