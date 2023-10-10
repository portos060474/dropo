//
//  HomeVC.swift
//  edelivery
//
//  Created by Elluminati on 14/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class HistoryVC: BaseVC,UITabBarDelegate {

    //MARK: - OutLets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerForWalletTransactionHistory: UIView!
    @IBOutlet weak var containerForWalletHistory: UIView!
    @IBOutlet weak var viewForTab: UIView!
    @IBOutlet weak var tabBar: UITabBar!

    //MARK: - Variables
    var walletTransationHistoryVC:WalletTransactionHistoryVC? = nil
    var walletHistoryVC:WalletHistoryVC? = nil

    //MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        Utility.showLoading()
        setLocalization()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false;
        self.setNavigationTitle(title:"Payment History".localized)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        setupLayout()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if LocalizeLanguage.isRTL {
            let index : Int = self.tabBar.items?.firstIndex(of: self.tabBar.selectedItem!) ?? 0
            self.tabBar(self.tabBar, didSelect: self.tabBar.items![index])
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    //MARK: - USER DEFINE FUNCTION
    func setLocalization() {
        self.hideBackButtonTitle()
        self.setNavigationTitle(title:"TXT_EARN".localized)
        self.view.backgroundColor = UIColor.themeViewBackgroundColor;
        scrollView.isDirectionalLockEnabled = true
        viewForTab.backgroundColor = UIColor.gray
        let firstItem = tabBar.addTabBarItem(title: "TXT_WALLET_HISTORY".localized.localized, imageName: "", selectedImageName: "", tagIndex: 1)
        let secondItem = tabBar.addTabBarItem(title: "TXT_WALLET_TRANSACTION_HISTORY".localized, imageName: "", selectedImageName: "", tagIndex: 2)
        tabBar.setItems([firstItem,secondItem], animated: false)
        tabBar.selectedItem = tabBar.items![0]
        // Set Font
        tabBar.barTintColor = UIColor.themeNavigationBackgroundColor
        tabBar.backgroundColor = UIColor.themeNavigationBackgroundColor
    }

    func setupLayout() {
        viewForTab.setShadow(shadowColor: UIColor.lightGray.cgColor, shadowOffset:CGSize.init(width: 0.0, height: 0.5), shadowOpacity: 0.17, shadowRadius: 2.0)
        tabBar.selectionIndicatorImage = APPDELEGATE.getImageWithColorPosition(color: UIColor.themeColor, size: CGSize(width:(APPDELEGATE.window?.frame.size.width)!/2,height: 49.5), lineSize: CGSize(width:(APPDELEGATE.window?.frame.size.width)!/2, height:1.5))
    }

    //MARK: - Button action methods
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 1 {
            tabBar.selectedItem = tabBar.items![0]
            UIView.animate(withDuration: 0.1,
                           delay: 0.1,
                           options: UIView.AnimationOptions.curveEaseIn,
                           animations: { () -> Void in
                self.scrollView.setContentOffset(self.containerForWalletHistory.frame.origin, animated: true)
            }, completion: { (finished) -> Void in
            })
        } else {
            tabBar.selectedItem = tabBar.items![1]
            UIView.animate(withDuration: 0.1,
                           delay: 0.1,
                           options: UIView.AnimationOptions.curveEaseIn,
                           animations: { () -> Void in
                self.scrollView.setContentOffset(self.containerForWalletTransactionHistory.frame.origin, animated: true)
            }, completion: { (finished) -> Void in
            })
        }
    }

    //MARK: - Scroll View methods
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

    func goToPoint(point:CGFloat) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
                self.scrollView.contentOffset.x = point
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }

    @IBAction func onClickBtnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    //MARK: - Navigation Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier?.compare(SEGUE.WALLET_HISTORY_TO_WALLET_HISTORY_DETAIL) == ComparisonResult.orderedSame {
            walletTransationHistoryVC = (segue.destination as! WalletTransactionHistoryVC)
        } else if segue.identifier?.compare(SEGUE.HISTORY_TO_WALLET_HISTORY) == ComparisonResult.orderedSame {
            walletHistoryVC = (segue.destination as! WalletHistoryVC)
        } else {}
    }
}
