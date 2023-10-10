//
//  StoreVC.swift
//  edelivery
//
//  Created by Elluminati on 07/03/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//
/*
import UIKit

class StoreReviewVC: BaseVC
{
  
    //MARK: OutLets
    
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var containerForReview: UIView!
    @IBOutlet weak var containerForOverView: UIView!
    
    
    @IBOutlet weak var viewForTab: UIView!
    
    
    //MARK: Variables
    var reviewVC:ReviewVC? = nil
    var overViewVC:OverViewVC? = nil
    
    //MARK: LIFE CYCLE
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setLocalization()
        self.setNavigationTitle(title:"TXT_STORE_NAME".localized)
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        //reviewVC?.wsGetHistory(startDate: "", endDate: "")
        //overViewVC?.wsGetOrders()
    }
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        viewForTab.setShadow(shadowColor: UIColor.lightGray.cgColor, shadowOffset: CGSize.init(width: 0.0, height: 3.0), shadowOpacity: 0.2, shadowRadius: 3.0)
        tabBar.selectionIndicatorImage
            = APPDELEGATE.getImageWithColorPosition(color: UIColor.themeSectionBackgroundColor, size: CGSize(width:(APPDELEGATE.window?.frame.size.width)!/2,height: 49), lineSize: CGSize(width:(APPDELEGATE.window?.frame.size.width)!/2, height:2))
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
   }
    
    //MARK: USER DEFINE FUNCTION
    func  setLocalization() {
        /*set colors*/
        self.view.backgroundColor = UIColor.themeViewBackgroundColor;
        
        
        /*set titles*/
        
        viewForTab.backgroundColor =
            UIColor.clear;
        
        let firstItem = tabBar.addTabBarItem(title: "TXT_OVERVIEW".localized, imageName: "", selectedImageName: "", tagIndex: 1)
        let secondItem =
            tabBar.addTabBarItem(title: "TXT_REVIEWS".localized, imageName: "", selectedImageName: "", tagIndex: 2)
        
        tabBar.setItems([firstItem,secondItem], animated: false)
        /* Set Font */
        tabBar.selectedItem = tabBar.items![0]
        
        
        self.hideBackButtonTitle()
        
    }
    //MARK:- Action Method
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if(item.tag == 1) {
            tabBar.selectedItem = tabBar.items![0]
            UIView.animate(withDuration: 0.1,
                           delay: 0.1,
                           options: UIViewAnimationOptions.curveEaseIn,
                           animations: { () -> Void in
                            self.scrollView.setContentOffset(self.containerForOverView.frame.origin, animated: true)
            }, completion: { (finished) -> Void in
                
               
            })
        }
        else if(item.tag == 2) {
            tabBar.selectedItem = tabBar.items![1]
            UIView.animate(withDuration: 0.1,
                           delay: 0.1,
                           options: UIViewAnimationOptions.curveEaseIn,
                           animations: { () -> Void in
                            
                            self.scrollView.setContentOffset(self.containerForReview.frame.origin, animated: true)
                            
            }, completion: { (finished) -> Void in
                
                
            })
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)    {
        
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth:CGFloat = scrollView.frame.size.width
        let fractionalPage:CGFloat = scrollView.contentOffset.x / pageWidth
        let page:Int = lroundf(Float(fractionalPage))
        
        switch (page)
        {
        case 0:
            self.tabBar(tabBar, didSelect: tabBar.items![0])
            
            break;
        case 1:
            self.tabBar(tabBar, didSelect: tabBar.items![1])
            
            break;
        default:
            break;
        }
        
    }
    func goToPoint(point:CGFloat){
        DispatchQueue.main.async
            {
                UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveLinear, animations:
                    {
                        self.scrollView.contentOffset.x = point
                        self.view.layoutIfNeeded()
                }, completion: nil)
                
        }
    }
   
    //MARK:- Navigation Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier?.compare(SEGUE.SEGUE_TO_HISTORY) == ComparisonResult.orderedSame
        {
            reviewVC = (segue.destination as! ReviewVC)
        }
        else if segue.identifier?.compare(SEGUE.SEGUE_TO_CURRENT_ORDER) == ComparisonResult.orderedSame
        {
            overViewVC = (segue.destination as! OverViewVC)
        }
        else
        {
            print("No Segue performed");
        }
    }
}


*/


