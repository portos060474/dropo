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
       @IBOutlet weak var viewForTab: Vw!
       

       //MARK: Variables
       var OrderNotificationsVC:OrderNotificationsVC? = nil
        var MassNotificationsVC:MassNotificationsVC? = nil
      
    
    //MARK: View life cycle
       override func viewDidLoad(){
           super.viewDidLoad()
           view.bringSubviewToFront(containerForOrderNoti)
            //setupLayout()
           setLocalization()
            APPDELEGATE.setupTabbar(tabBar: tabBar)
            self.tabBar.isHidden = false
            self.hideBackButtonTitle()
        }
       
       override func viewWillAppear(_ animated: Bool){
           super.viewWillAppear(animated)
//              wsGetHistoryDetail()
       }
       
       override func viewDidAppear(_ animated: Bool){
           super.viewDidAppear(animated)
           if LocalizeLanguage.isRTL {
               let index : Int = self.tabBar.items?.index(of: self.tabBar.selectedItem!) ?? 0
               self.tabBar(self.tabBar, didSelect: self.tabBar.items![index])
           }
       }
       
       override func viewDidLayoutSubviews(){
           super.viewDidLayoutSubviews()
          setupLayout()
       }
    
    func setupLayout() {
         viewForTab.setShadow()
         tabBar.layoutIfNeeded()
         tabBar.tintColor = UIColor.themeTitleColor
         tabBar.selectionIndicatorImage = APPDELEGATE.getImageWithColorPosition(color: UIColor.themeColor, size: CGSize.init(width: tabBar.bounds.width/2, height: tabBar.bounds.height ), lineSize: CGSize.init(width: tabBar.bounds.width/2, height: 1.5))
         
         tabBar.frame.size.width = self.view.frame.width + 4
         tabBar.frame.origin.x = -2
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
       
       func setLocalization() {
           //COLORS
            self.setNavigationTitle(title: "TXT_NOTIFICATION".localized)

           self.view.backgroundColor = UIColor.themeViewBackgroundColor;
         
           scrollView.delegate = self
           viewForTab.backgroundColor = UIColor.gray
           let  firstItem =
               tabBar.addTabBarItem(title: "TXT_ORDER_NOTI".localized, imageName: "", selectedImageName: "", tagIndex: 1)
           
           let secondItem = tabBar.addTabBarItem(title: "TXT_MASS_NOTI".localized, imageName: "", selectedImageName: "", tagIndex: 2)
           
           tabBar.setItems([firstItem,secondItem], animated: false)
           tabBar.selectedItem = tabBar.items![0]
           // Set Font
           tabBar.barTintColor = UIColor.themeNavigationBackgroundColor
           tabBar.backgroundColor = UIColor.themeNavigationBackgroundColor
//           self.viewForTab.setCustomShadow()
           
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
           /*let pageWidth:CGFloat = scrollView.frame.size.width
           let page:Int = Int(floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1)
    
           
           switch (page) {
           case 0:
               tabBar(tabBar, didSelect: tabBar.items![0])
               break
           case 1:
               tabBar(tabBar, didSelect: tabBar.items![1])
               break
           case 2:
               tabBar(tabBar, didSelect: tabBar.items![2])
               break
           default:
               break
           }*/
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
