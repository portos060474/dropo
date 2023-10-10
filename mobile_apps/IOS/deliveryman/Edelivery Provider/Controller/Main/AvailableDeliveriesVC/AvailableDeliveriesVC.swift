//
//  AvailableDeliveriesVC.swift
//  Edelivery Provider
//
//  Created by Elluminati iMac on 20/04/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit

class AvailableDeliveriesVC: BaseVC,UITabBarDelegate , UIScrollViewDelegate {

//MARK: Outlets
    @IBOutlet weak var containerActiveDeliveries: UIView!
    @IBOutlet weak var containerPendingDeliveries: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewForTab: UIView!
    @IBOutlet weak var tabBar: UITabBar!
    weak var timerForOrders:Timer? = nil
    var vcActiveDelivery : ActivesDeliveriesVC? = nil
    var vcPendingDelivery : PendingDeliveries? = nil
    
//MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
      self.setLocalization()
        scrollView.delegate = self
        if #available(iOS 10.0, *) {
            self.tabBar.items![0].badgeColor = .themeRedColor
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 10.0, *) {
            self.tabBar.items![1].badgeColor = UIColor.themeRedColor
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    timerForOrders = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.timerToUpdateOrders), userInfo: nil, repeats: true)
    }
    
    override func updateUIAccordingToTheme() {
        self.setColor()
    }
    
    @objc func timerToUpdateOrders() {
        if tabBar.selectedItem == tabBar.items![0] {
            if vcPendingDelivery != nil {
                vcPendingDelivery?.wsGetNewOrder()
            }
        }else {
            if vcActiveDelivery != nil {
                vcActiveDelivery?.wsGetActiveOrder()
            }
        }
    }

    //MAKR: Set localized & Loyout
    func setColor() {
        self.view.backgroundColor = UIColor.themeViewBackgroundColor;
        tabBar.barTintColor = UIColor.themeNavigationBackgroundColor
        tabBar.backgroundColor = UIColor.themeNavigationBackgroundColor
    }
    func setLocalization() {
        self.hideBackButtonTitle()
        self.setNavigationTitle(title:"TXT_AVAILABLE_DELIVERIES".localized)
        self.view.backgroundColor = UIColor.themeViewBackgroundColor;
        scrollView.isDirectionalLockEnabled = true
        viewForTab.backgroundColor = UIColor.themeNavigationBackgroundColor
        let firstItem = tabBar.addTabBarItem(title: "TXT_PENDING_DELIVERIES".localized.localized, imageName: "", selectedImageName: "", tagIndex: 1)
        let secondItem =
            tabBar.addTabBarItem(title: "TXT_ACTIVES_DELIVERIES".localized, imageName: "", selectedImageName: "", tagIndex: 2)
        tabBar.setItems([firstItem,secondItem], animated: false)
        tabBar.selectedItem = tabBar.items![0]
        // Set Font
        tabBar.barTintColor = UIColor.themeNavigationBackgroundColor
        tabBar.backgroundColor = UIColor.themeNavigationBackgroundColor
    }
   
    //MARK: Scrollview delgate
   
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        if LocalizeLanguage.isRTL {
            let index : Int = self.tabBar.items?.firstIndex(of: self.tabBar.selectedItem!) ?? 0
            self.tabBar(self.tabBar, didSelect: self.tabBar.items![index])
        }

    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews();
        setupLayout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
        timerForOrders?.invalidate()
    }
    
    override func viewDidDisappear(_ animated: Bool){
        super.viewDidDisappear(animated)
    }
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    func  setupLayout() {
        viewForTab.setShadow(shadowColor: UIColor.lightGray.cgColor, shadowOffset:CGSize.init(width: 0.0, height: 0.5), shadowOpacity: 0.17, shadowRadius: 2.0)
        tabBar.selectionIndicatorImage
            = APPDELEGATE.getImageWithColorPosition(color: UIColor.themeColor, size: CGSize(width:(APPDELEGATE.window?.frame.size.width)!/2,height: 49.5), lineSize: CGSize(width:(APPDELEGATE.window?.frame.size.width)!/2, height:2))
    }
    
    //MARK: Button action methods
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 1 {
            tabBar.selectedItem = tabBar.items![0]
            
            if vcPendingDelivery != nil {
                vcPendingDelivery?.wsGetNewOrder()
            }
            UIView.animate(withDuration: 0.1,
                           delay: 0.1,
                           options: UIView.AnimationOptions.curveEaseIn,
                           animations: { () -> Void in
                            
                            self.scrollView.setContentOffset(self.containerPendingDeliveries.frame.origin, animated: true)
                            
            }, completion: { (finished) -> Void in
            })
        
        }else {
            tabBar.selectedItem = tabBar.items![1]
            
            if vcActiveDelivery != nil {
                vcActiveDelivery?.wsGetActiveOrder()
            }
            
            UIView.animate(withDuration: 0.1,
                           delay: 0.1,
                           options: UIView.AnimationOptions.curveEaseIn,
                           animations: { () -> Void in
                            self.scrollView.setContentOffset(self.containerActiveDeliveries.frame.origin, animated: true)
                            
                            
            }, completion: { (finished) -> Void in
            })
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
            break;
        case 1:
            tabBar(tabBar, didSelect: tabBar.items![1])
            break;
        default:
            break;
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == EMBEDED.ACTIVE_ORDER {
            let vcActive = segue.destination as! ActivesDeliveriesVC
            vcActiveDelivery?.parentVC = self
            vcActiveDelivery = vcActive
        }else {
            let vcPending = segue.destination as! PendingDeliveries
            vcPendingDelivery?.parentVC = self
            vcPendingDelivery = vcPending
        }
    }
}
