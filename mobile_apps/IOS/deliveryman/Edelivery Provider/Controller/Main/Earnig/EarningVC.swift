//
//  EarningVC.swift
//  edelivery
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
    @IBOutlet weak var viewForTab: UIView!
    @IBOutlet weak var tabBar: UITabBar!

//MARK: Variables
    var dailyVC:DailyEarningVC? = nil
    var weeklyVC:WeeklyEarningVC? = nil

//MARK: View life cycle
    override func viewDidLoad(){
        super.viewDidLoad();
        view.bringSubviewToFront(containerForDailyEarning)
        setLocalization()
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
    
    func  setLocalization(){
        //COLORS
        self.hideBackButtonTitle()
        self.setNavigationTitle(title:"TXT_EARN".localized)
        self.view.backgroundColor = UIColor.themeViewBackgroundColor;
        scrollView.isDirectionalLockEnabled = true
        viewForTab.backgroundColor = UIColor.gray
        let firstItem = tabBar.addTabBarItem(title: "TXT_DAY".localizedCapitalized, imageName: "", selectedImageName: "", tagIndex: 1)
        let secondItem =
            tabBar.addTabBarItem(title: "TXT_WEEK".localizedCapitalized, imageName: "", selectedImageName: "", tagIndex: 2)
        tabBar.setItems([firstItem,secondItem], animated: false)
        tabBar.selectedItem = tabBar.items![0]
        tabBar.barTintColor = UIColor.themeNavigationBackgroundColor
        tabBar.backgroundColor = UIColor.themeNavigationBackgroundColor
        super.hideBackButtonTitle()
        setMenuButton()
    }
    override func updateUIAccordingToTheme() {
        setMenuButton()
    }
    func  setupLayout() {
        viewForTab.setShadow(shadowColor: UIColor.lightGray.cgColor, shadowOffset:CGSize.init(width: 0.0, height: 0.5), shadowOpacity: 0.17, shadowRadius: 2.0)
        tabBar.selectionIndicatorImage
            = APPDELEGATE.getImageWithColorPosition(color: UIColor.themeColor, size: CGSize(width:(APPDELEGATE.window?.frame.size.width)!/2,height: 49.5), lineSize: CGSize(width:(APPDELEGATE.window?.frame.size.width)!/2, height:1.5))
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
    //MARK:
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
