//
//  EarningVC.swift
// Edelivery Store
//
//  Created by Elluminati on 30/01/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit


class EarningVC: BaseVC,UINavigationControllerDelegate,UIScrollViewDelegate,UITabBarDelegate {
    //MARK: Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerForDailyEarning: UIView!
    @IBOutlet weak var containerForWeeklyEarning: UIView!
    
    @IBOutlet weak var viewForTab: Vw!
    @IBOutlet weak var tabBar: UITabBar!
    
    //MARK: Variables
    var dailyVC:DailyEarningVC? = nil
    var weeklyVC:WeeklyEarningVC? = nil
    
    //MARK: View life cycle
    override func viewDidLoad(){
        super.viewDidLoad();
        view.bringSubviewToFront(containerForDailyEarning)
        setLocalization()
        APPDELEGATE.setupTabbar(tabBar: tabBar)
        self.tabBar.isHidden = false

       
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
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
    }
    override func viewDidDisappear(_ animated: Bool){
        super.viewDidDisappear(animated)
    }
    func setLocalization(){
        //COLORS
        self.hideBackButtonTitle()
        self.setNavigationTitle(title:"TXT_EARNING".localized)
        
        self.view.backgroundColor = UIColor.themeViewBackgroundColor;
        scrollView.isDirectionalLockEnabled = true
        
        viewForTab.backgroundColor = UIColor.gray
        
        let firstItem = tabBar.addTabBarItem(title: "TXT_DAY".localized.localized, imageName: "", selectedImageName: "", tagIndex: 1)
        let secondItem =
            tabBar.addTabBarItem(title: "TXT_WEEK".localized, imageName: "", selectedImageName: "", tagIndex: 2)
        
        tabBar.setItems([firstItem,secondItem], animated: false)
        tabBar.selectedItem = tabBar.items![0]
        // Set Font
        tabBar.barTintColor = UIColor.themeNavigationBackgroundColor
        tabBar.backgroundColor = UIColor.themeNavigationBackgroundColor
        
        if preferenceHelper.getIsSubStoreLogin(){
            if !ScreenVisibilityPermission.Earning && !ScreenVisibilityPermission.WeeklyEarning{
                self.tabBar.isHidden = true
            }else if !ScreenVisibilityPermission.Earning{
               self.tabBar.items?.remove(at: 0)
               tabBar.selectedItem = tabBar.items![0]
                tabBar.items![0].tag = 1
            }else if !ScreenVisibilityPermission.WeeklyEarning{
                self.tabBar.items?.remove(at: 1)
                tabBar.selectedItem = tabBar.items![0]
                tabBar.items![0].tag = 1
            }
        }
        
    }
    func setupLayout() {
        viewForTab.setShadow()
        
        tabBar.layoutIfNeeded()
        tabBar.tintColor = UIColor.themeTitleColor
        tabBar.selectionIndicatorImage = APPDELEGATE.getImageWithColorPosition(color: UIColor.themeColor, size: CGSize.init(width: tabBar.bounds.width/2, height: tabBar.bounds.height ), lineSize: CGSize.init(width: tabBar.bounds.width/2, height: 1.5))
        
        tabBar.frame.size.width = self.view.frame.width + 4
        tabBar.frame.origin.x = -2
        
        
        DispatchQueue.main.async {
              //Issue resolved : Stucking in the middle after going to background and back.
              if self.tabBar.items?.count ?? 0 > 0{
                if self.tabBar.selectedItem == self.tabBar.items![0]{
                    UIView.animate(withDuration: 0.1,
                                   delay: 0.1,
                                   options: UIView.AnimationOptions.curveEaseIn,
                                   animations: { () -> Void in
                                    self.scrollView.setContentOffset(self.containerForDailyEarning.frame.origin, animated: true)
                                    
                    }, completion: { (finished) -> Void in
                    })
                }else{
                    UIView.animate(withDuration: 0.1,
                                   delay: 0.1,
                                   options: UIView.AnimationOptions.curveEaseIn,
                                   animations: { () -> Void in
                                    self.scrollView.setContentOffset(self.containerForWeeklyEarning.frame.origin, animated: true)
                                    
                    }, completion: { (finished) -> Void in
                    })
                }

              }
          }
    }
    
    
    //MARK: Button action methods
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 1 {
            tabBar.selectedItem = tabBar.items![0]
            
            UIView.animate(withDuration: 0.1,
                           delay: 0.1,
                           options: UIView.AnimationOptions.curveEaseIn,
                           animations: { () -> Void in
                            
                            self.scrollView.setContentOffset(self.containerForDailyEarning.frame.origin, animated: true)
                            
            }, completion: { (finished) -> Void in
            })
            
            
        }else {
            tabBar.selectedItem = tabBar.items![1]
            
            
            UIView.animate(withDuration: 0.1,
                           delay: 0.1,
                           options: UIView.AnimationOptions.curveEaseIn,
                           animations: { () -> Void in
                            self.scrollView.setContentOffset(self.containerForWeeklyEarning.frame.origin, animated: true)
                            
                            
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
    
    //MARK:- Navigation Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier?.compare(SEGUE.EARNING_TO_DAILY) == ComparisonResult.orderedSame {
            dailyVC = (segue.destination as! DailyEarningVC)
        }else if segue.identifier?.compare(SEGUE.EARNING_TO_WEEKLY) == ComparisonResult.orderedSame {
            weeklyVC = (segue.destination as! WeeklyEarningVC)
        }
        
    }
}

