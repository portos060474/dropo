//
//  Home.swift
//  edelivery
//
//  Created by Elluminati on 30/01/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
import GoogleSignIn
import FirebaseCrashlytics

class Home: BaseVC,UITextFieldDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,UITabBarDelegate {

    //MARK: Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerForRegister: UIView!
    @IBOutlet weak var containerForLogin: UIView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var viewForTab: UIView!

    //MARK: Variables
    var registerVC:RegisterVC? = nil
    var loginVC:LoginVC? = nil

    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        preferenceHelper.setIsEmailVerified(false)
        preferenceHelper.setIsPhoneNumberVerified(false)
        view.bringSubviewToFront(containerForLogin)
        setLocalization()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
          self.setNeedsStatusBarAppearanceUpdate()
      }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        setupLayout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
        if isBeingDismissed {
             APPDELEGATE.goToMain()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool){
        super.viewDidDisappear(animated)
    }
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    func setLocalization() {
        //COLORS
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        scrollView.isDirectionalLockEnabled = true
        viewForTab.backgroundColor = UIColor.themeButtonBackgroundColor
        let firstItem = tabBar.addTabBarItem(title: "TXT_LOGIN".localized.localized, imageName: "", selectedImageName: "", tagIndex: 1)
        let secondItem =
            tabBar.addTabBarItem(title: "TXT_REGISTER".localized, imageName: "", selectedImageName: "", tagIndex: 2)
        tabBar.setItems([firstItem,secondItem], animated: false)
        tabBar.selectedItem = tabBar.items![0]
        viewForTab.backgroundColor = UIColor.gray
    }
    
    func setupLayout() {
        viewForTab.setShadow(shadowColor: UIColor.gray.cgColor, shadowOffset:CGSize.init(width: 0.0, height: 3.0), shadowOpacity: 0.8, shadowRadius: 3.0)
        
        tabBar.layoutIfNeeded()
        tabBar.tintColor = UIColor.themeTitleColor
        tabBar.frame.size.width = self.view.frame.width + 4
        tabBar.frame.origin.x = -2
        DispatchQueue.main.async {
            
            //Issue resolved : Stucking in the middle after visiting terms and condtions.
            if self.tabBar.items?.count ?? 0 > 0{
                
                if self.tabBar.selectedItem == self.tabBar.items![0]{
                    /*Register Button Clicked*/
                    self.tabBar.selectedItem = self.tabBar.items![0]
                    self.registerVC?.view.endEditing(true)
                    UIView.animate(withDuration: 0.1,
                                   delay: 0.1,
                                   options: UIView.AnimationOptions.curveEaseIn,
                                   animations: { () -> Void in
                                    self.scrollView.setContentOffset(self.containerForLogin.frame.origin, animated: true)
                                    
                    }, completion: { (finished) -> Void in
                    })
                    
                  //  GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self.registerVC!)
                }else{
                    /*Register Button Clicked*/
                    self.tabBar.selectedItem = self.tabBar.items![1]
                    self.loginVC?.view.endEditing(true)
                    UIView.animate(withDuration: 0.1,
                                   delay: 0.1,
                                   options: UIView.AnimationOptions.curveEaseIn,
                                   animations: { () -> Void in
                                    self.scrollView.setContentOffset(self.containerForRegister.frame.origin, animated: true)
                                    
                    }, completion: { (finished) -> Void in
                    })
                  
                    //GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self.loginVC!)
                }
            }
        }
    }

    func goToSignUp()  {
        tabBar(tabBar, didSelect: tabBar.items![1])
    }
    func goToSignIn()  {
        tabBar(tabBar, didSelect: tabBar.items![0])
    }
    //MARK: Button action methods
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 1 {
            tabBar.selectedItem = tabBar.items![0]
            registerVC?.view.endEditing(true)
            UIView.animate(withDuration: 0.1,
                           delay: 0.1,
                           options: UIView.AnimationOptions.curveEaseIn,
                           animations: { () -> Void in
                            self.scrollView.setContentOffset(self.containerForLogin.frame.origin, animated: true)
                           }, completion: { (finished) -> Void in
                           })
            //GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self.registerVC!)
        }else {
            /*Register Button Clicked*/
            tabBar.selectedItem = tabBar.items![1]
            loginVC?.view.endEditing(true)
            UIView.animate(withDuration: 0.1,
                           delay: 0.1,
                           options: UIView.AnimationOptions.curveEaseIn,
                           animations: { () -> Void in
                            self.scrollView.setContentOffset(self.containerForRegister.frame.origin, animated: true)
                           }, completion: { (finished) -> Void in
                           })
           // GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self.loginVC!)
        }
    }
    
    //MARK: Scroll View methods
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth:CGFloat = scrollView.frame.size.width
        let fractionalPage:CGFloat = scrollView.contentOffset.x / pageWidth
        let page:Int = lroundf(Float(fractionalPage))
        
        switch (page) {
        case 0:
            tabBar(tabBar, didSelect: tabBar.items![0])
            break
        case 1:
            tabBar(tabBar, didSelect: tabBar.items![1])
            break
        default:
            break
        }
    }
    
    //MARK:- Navigation Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier?.compare(SEGUE.SEGUE_LOGIN) == ComparisonResult.orderedSame {
            loginVC = (segue.destination as! LoginVC)
        } else if segue.identifier?.compare(SEGUE.SEGUE_REGISTER) == ComparisonResult.orderedSame {
            registerVC = (segue.destination as! RegisterVC)
        } else {
            printE("No Segue performed")
        }
    }
}
