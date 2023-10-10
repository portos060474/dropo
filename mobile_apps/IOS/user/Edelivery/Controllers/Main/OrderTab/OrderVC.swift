//
//  HomeVC.swift
//  edelivery
//
//  Created by Elluminati on 14/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

enum OrderFilter {
    case all
    case courier
    case store
    case tableBook
}

class OrderVC: BaseVC,RightDelegate, LeftDelegate, UITabBarDelegate, UIScrollViewDelegate {
    
    //MARK: OutLets
    
    @IBOutlet weak var tabForTopBar: UITabBar!
    @IBOutlet weak var scrollViewForTab: UIScrollView!
    @IBOutlet weak var containerForHistory: UIView!
    @IBOutlet weak var containerForCurrentOrder: UIView!
    @IBOutlet weak var viewForShadow: UIView!
    @IBOutlet weak var lblCurrentOrders: UILabel!
    
    //MARK: Variables
    var historyVC:HistoryVC? = nil
    var currentOrderVC:CurrentOrderVC? = nil
    var isComeFromCompleteOrder:Bool = false
    var filterType = OrderFilter.all
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegateRight = self
        if isComeFromCompleteOrder {
            self.delegateLeft = self
            self.setBackBarItem(isNative: false)
        }
        else {
            self.setBackBarItem(isNative: true)
        }
        self.setRightBarItem(isNative: false)
        self.setRightBarItemImage(image: UIImage.init(named: "filter")!.imageWithColor(color: .red)!)
        Utility.showLoading()
        scrollViewForTab.delegate = self
        setLocalization()
        self.setNavigationTitle(title:"TXT_ORDERS".localized)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    self.scrollViewForTab.setContentOffset(self.containerForHistory.frame.origin, animated: true)
        self.containerForCurrentOrder.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabForTopBar.tintColor = UIColor.themeTitleColor
        viewForShadow.setShadow(shadowColor: UIColor.lightGray.cgColor, shadowOffset: CGSize.init(width: 0.0, height: 3.0), shadowOpacity: 0.2, shadowRadius: 3.0)
        tabForTopBar.selectionIndicatorImage = APPDELEGATE.getImageWithColorPosition(color: UIColor.themeSectionBackgroundColor, size: CGSize(width:(APPDELEGATE.window?.frame.size.width)!/2,height: 49), lineSize: CGSize(width:(APPDELEGATE.window?.frame.size.width)!/2, height:2))
    }
    override func updateUIAccordingToTheme() {
        if isComeFromCompleteOrder {
            self.setBackBarItem(isNative: false)
        }
        else {
            self.setBackBarItem(isNative: true)
        }
    }
    func onClickLeftButton()
    {

        if isComeFromCompleteOrder {
            APPDELEGATE.goToMain()
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    //MARK: USER DEFINE FUNCTION
    func setLocalization() {
        /*set colors*/
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        viewForShadow.backgroundColor =
            UIColor.clear
        
        let firstItem = tabForTopBar.addTabBarItem(title: "TXT_CURRENT_ORDER".localized, imageName: "", selectedImageName: "", tagIndex: 1)
        let secondItem = tabForTopBar.addTabBarItem(title: "TXT_ORDER_HISTORY".localized, imageName: "", selectedImageName: "", tagIndex: 2)
        
        tabForTopBar.setItems([firstItem,secondItem], animated: false)
        tabForTopBar.selectedItem = tabForTopBar.items![1]
        lblCurrentOrders.font = FontHelper.textMedium(size: FontHelper.mediumLarge)
        lblCurrentOrders.textColor = UIColor.themeTitleColor
        lblCurrentOrders.text = "TXT_CURRENT_ORDER".localized
        self.hideBackButtonTitle()
        
    }
    
    //MARK:- Action Method
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        self.scrollViewForTab.setContentOffset(self.containerForHistory.frame.origin, animated: true)
        self.containerForCurrentOrder.endEditing(true)
        self.view.layoutIfNeeded()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)    {
        if !decelerate {
            let pageWidth:CGFloat = scrollView.frame.size.width
            let fractionalPage:CGFloat = scrollView.contentOffset.x / pageWidth
            let page:Int = lroundf(Float(fractionalPage))
            switch (page) {
            case 0:
                self.tabBar(tabForTopBar, didSelect: tabForTopBar.items![0])
                break
            case 1:
                self.tabBar(tabForTopBar, didSelect: tabForTopBar.items![1])
                break
            default:
                break
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth:CGFloat = scrollView.frame.size.width
        let fractionalPage:CGFloat = scrollView.contentOffset.x / pageWidth
        let page:Int = lroundf(Float(fractionalPage))
        
        switch (page) {
        case 0:
            self.tabBar(tabForTopBar, didSelect: tabForTopBar.items![0])
            break
       
        case 1:
            self.tabBar(tabForTopBar, didSelect: tabForTopBar.items![1])
            break
       
        default:
            break
        }
    }
    
    func goToPoint(point:CGFloat){
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveLinear, animations:
            {
                    self.scrollViewForTab.contentOffset.x = point
                    self.view.layoutIfNeeded()
            }, completion: nil)
            
        }
    }
    
    func onClickRightButton() {
        
        openFilterList()
        
        self.historyVC?.btnFrom.setTitle("TXT_FROM".localized, for: UIControl.State.normal)
        self.historyVC?.btnTo.setTitle("TXT_TO".localized, for: UIControl.State.normal)
        if (self.historyVC?.viewForFilter.isHidden)! {
            self.historyVC?.viewForFilter.isHidden = false
            //self.setRightBarItemImage(image: UIImage.init(named: "cancel")!)
        }else {
            self.historyVC?.viewForFilter.isHidden = true
            //self.setRightBarItemImage(image: UIImage.init(named: "filter")!)
        }
    }
    
    func openFilterList() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let all = UIAlertAction(title: "TXT_ALL".localized , style: .default, handler: { [unowned self] (alert: UIAlertAction!) -> Void in
            filterType = .all
            reloadFilter()
        })
        alertController.addAction(all)
        
        let courier = UIAlertAction(title: "TXT_COURIER".localized , style: .default, handler: { [unowned self] (alert: UIAlertAction!) -> Void in
            filterType = .courier
            reloadFilter()
        })
        alertController.addAction(courier)
        
        let store = UIAlertAction(title: "TXT_STORE".localized , style: .default, handler: { [unowned self] (alert: UIAlertAction!) -> Void in
            filterType = .store
            reloadFilter()
        })
        alertController.addAction(store)
        
        let tableBook = UIAlertAction(title: "text_table_reservation".localizedCapitalized , style: .default, handler: { [unowned self] (alert: UIAlertAction!) -> Void in
            filterType = .tableBook
            reloadFilter()
        })
        alertController.addAction(tableBook)
        
        let cancel = UIAlertAction(title: "TXT_CANCEL".localized , style: .cancel, handler: { [unowned self] (alert: UIAlertAction!) -> Void in
            
        })
        alertController.addAction(cancel)

        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    func reloadFilter() {
        historyVC?.reloadData(filter: filterType)
    }
    
    @IBAction func onClickBtnBack(_ sender: Any) {
        if isComeFromCompleteOrder {
            APPDELEGATE.goToMain()
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK:- Navigation Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier?.compare(SEGUE.SEGUE_TO_HISTORY) == ComparisonResult.orderedSame {
            historyVC = (segue.destination as! HistoryVC)
        }
        else if segue.identifier?.compare(SEGUE.SEGUE_TO_CURRENT_ORDER) == ComparisonResult.orderedSame {
            currentOrderVC = (segue.destination as! CurrentOrderVC)
        }else {
            printE("No Segue performed")
        }
    }
}
