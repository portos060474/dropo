//
//  NotificationsVC.swift
//  Edelivery
//
//  Created by Trusha on 20/07/20.
//  Copyright © 2020 Elluminati. All rights reserved.
//

import UIKit

class NotificationsVC: BaseVC,UIScrollViewDelegate,UITabBarDelegate  {

    //MARK: Outlets
       @IBOutlet weak var scrollView: UIScrollView!
       @IBOutlet weak var containerForMassNoti: UIView!
       @IBOutlet weak var containerForOrderNoti: UIView!
       @IBOutlet weak var tabBar: UITabBar!
       @IBOutlet weak var viewForTab: UIView!
       

    //MARK: Variables
    var OrderNotificationsVC:OrderNotificationsVC? = nil
    var MassNotificationsVC:MassNotificationsVC? = nil
      
    //MARK: View life cycle
       override func viewDidLoad(){
           super.viewDidLoad()
           view.bringSubviewToFront(containerForOrderNoti)
           setLocalization()
           self.hideBackButtonTitle()
        }
       
       override func viewWillAppear(_ animated: Bool){
           super.viewWillAppear(animated)
       }
       
       override func viewDidAppear(_ animated: Bool){
           super.viewDidAppear(animated)
           if LocalizeLanguage.isRTL {
            let index : Int = self.tabBar.items?.firstIndex(of: self.tabBar.selectedItem!) ?? 0
               self.tabBar(self.tabBar, didSelect: self.tabBar.items![index])
           }
       }
       
       override func viewDidLayoutSubviews(){
           super.viewDidLayoutSubviews()
            setupLayout()
       }
    
       func setupLayout() {
            viewForTab.setShadow(shadowColor: UIColor.gray.cgColor, shadowOffset:CGSize.init(width: 0.0, height: 3.0), shadowOpacity: 0.8, shadowRadius: 3.0)
            tabBar.selectionIndicatorImage =  APPDELEGATE.getImageWithColorPosition(color: UIColor.themeColor, size: CGSize.init(width: viewForTab.frame.width/2, height: viewForTab.frame.height ), lineSize: CGSize.init(width: viewForTab.frame.width/2, height: 1.5))
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
       
       override var prefersStatusBarHidden : Bool {
           return false
       }
       

    func  setLocalization() {
        //COLORS
        self.setNavigationTitle(title: "TXT_NOTIFICATION".localized)
        self.view.backgroundColor = UIColor.themeViewBackgroundColor;
        scrollView.isDirectionalLockEnabled = true
        viewForTab.backgroundColor = UIColor.gray
        let firstItem = tabBar.addTabBarItem(title: "TXT_ORDER_NOTI".localized, imageName: "", selectedImageName: "", tagIndex: 1)
        let secondItem =
            tabBar.addTabBarItem(title: "TXT_MASS_NOTI".localized, imageName: "", selectedImageName: "", tagIndex: 2)
        tabBar.setItems([firstItem,secondItem], animated: false)
        tabBar.selectedItem = tabBar.items![0]
        tabBar.barTintColor = UIColor.themeNavigationBackgroundColor
        tabBar.backgroundColor = UIColor.themeNavigationBackgroundColor
    }
    
       //MARK: Button action methods
       func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
           if item.tag == 1 {
                tabBar.selectedItem = tabBar.items![0]
          
                UIView.animate(withDuration: 0.1,
                              delay: 0.1,
                              options: UIView.AnimationOptions.curveEaseIn,
                              animations: { () -> Void in
                               
                               self.scrollView.setContentOffset(self.containerForOrderNoti.frame.origin, animated: true)
               }, completion: { (finished) -> Void in
               })
           }
           if item.tag == 2 {

                tabBar.selectedItem = tabBar.items![1]
               
                UIView.animate(withDuration: 0.1,
                              delay: 0.1,
                              options: UIView.AnimationOptions.curveEaseIn,
                              animations: { () -> Void in
                               self.scrollView.setContentOffset(self.containerForMassNoti.frame.origin, animated: true)
                               
               }, completion: { (finished) -> Void in
               })
           }
       }
       
       //MARK: Scroll View methods
       func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
       }
       
       func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
           let pageWidth:CGFloat = scrollView.frame.size.width
           let page:Int = Int(floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1)
           
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
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         
           if segue.identifier ==  SEGUE.SEGUE_TO_MASS_NOTIFICATIONS {
               MassNotificationsVC = (segue.destination as! MassNotificationsVC)
           }
           if segue.identifier ==  SEGUE.SEGUE_TO_ORDER_NOTIFICATIONS {
               OrderNotificationsVC = (segue.destination as! OrderNotificationsVC)
           }
        }

}
