//
//  Home.swift
//  edelivery
//
//  Created by Elluati on 30/01/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class HistoryDetailVC: BaseVC,UIScrollViewDelegate,UITabBarDelegate {
    //MARK:- Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerForOtherDetail: UIView!
    @IBOutlet weak var containerForCart: UIView!
    @IBOutlet weak var containerForInvoice: UIView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var viewForTab: UIView!

    //MARK:- Variables
    var otherDetailVC:OtherDetailVC? = nil
    var invoiceDetailVC:HistoryInvoiceVC? = nil
    var cartDetailVC:CartDetailVC? = nil
    var strOrderID:String = ""

    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad();
        view.bringSubviewToFront(containerForInvoice)
        wsGetHistoryDetail()
        setLocalization()
        self.hideBackButtonTitle()
        self.setBackBarItem(isNative: false)
    }

    override func onClickLeftBarItem() {
        self.navigationController?.popViewController(animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
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
        self.view.backgroundColor = UIColor.themeViewBackgroundColor;
        scrollView.isDirectionalLockEnabled = true
    }

    func setupLayout(historyOrderResposnse:HistoryOrderDetailResponse) {
        let firstItem = self.tabBar.addTabBarItem(title: "TXT_OTHER_DETAILS".localized, imageName: "", selectedImageName: "", tagIndex: 1)
        let secondItem = self.tabBar.addTabBarItem(title: "TXT_INVOICE".localized.localized, imageName: "", selectedImageName: "", tagIndex: 2)
        if historyOrderResposnse.orderList.cartDetail.orderDetails.count > 0 {
            let thirdItem = self.tabBar.addTabBarItem(title: "TXT_CART".localized, imageName: "", selectedImageName: "", tagIndex: 3)
            self.tabBar.setItems([firstItem,secondItem,thirdItem], animated: false)
            self.tabBar.selectionIndicatorImage = APPDELEGATE.getImageWithColorPosition(color: UIColor.themeColor, size: CGSize.init(width: self.tabBar.bounds.width/3, height: self.tabBar.bounds.height - 2), lineSize: CGSize.init(width: self.tabBar.bounds.width/3, height: 2.0))
        } else {
            self.tabBar.setItems([firstItem,secondItem], animated: false)
            self.tabBar.selectionIndicatorImage = APPDELEGATE.getImageWithColorPosition(color: UIColor.themeColor, size: CGSize.init(width: self.tabBar.bounds.width/2, height: self.tabBar.bounds.height - 2), lineSize: CGSize.init(width: self.tabBar.bounds.width/2, height: 2.0))
        }
        self.tabBar.selectedItem = self.tabBar.items![0]
        self.viewForTab.backgroundColor = UIColor.themeViewBackgroundColor

        self.viewForTab.setShadow(shadowColor: UIColor.gray.cgColor, shadowOffset:CGSize.init(width: 0.0, height: 3.0), shadowOpacity: 0.8, shadowRadius: 3.0)
        self.tabBar.tintColor = UIColor.themeTitleColor
        self.scrollView.contentSize = CGSize.init(width: CGFloat(self.scrollView.frame.width * CGFloat((self.tabBar.items?.count ?? 2))), height: self.scrollView.frame.height)
        APPDELEGATE.setupTabbar(tabBar: self.tabBar)
    }

    //MARK:- Button action methods
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 1 {
            tabBar.selectedItem = tabBar.items![0]
            UIView.animate(withDuration: 0.1,
                           delay: 0.1,
                           options: UIView.AnimationOptions.curveEaseIn,
                           animations: { () -> Void in
                            self.scrollView.setContentOffset(self.containerForOtherDetail.frame.origin, animated: true)
            }, completion: { (finished) -> Void in
            })
        }
        if item.tag == 2 {
             tabBar.selectedItem = tabBar.items![1]
             UIView.animate(withDuration: 0.1,
                           delay: 0.1,
                           options: UIView.AnimationOptions.curveEaseIn,
                           animations: { () -> Void in
                            self.scrollView.setContentOffset(self.containerForInvoice.frame.origin, animated: true)
            }, completion: { (finished) -> Void in
            })
        }
        if item.tag == 3 {
            tabBar.selectedItem = tabBar.items![2]
            UIView.animate(withDuration: 0.1,
                           delay: 0.1,
                           options: UIView.AnimationOptions.curveEaseIn,
                           animations: { () -> Void in
                            self.scrollView.setContentOffset(self.containerForCart.frame.origin, animated: true)
            }, completion: { (finished) -> Void in
            })
        }
    }

    //MARK:- Scroll View methods
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        /*let pageWidth:CGFloat = scrollView.frame.size.width
        let fractionalPage:CGFloat = scrollView.contentOffset.x / pageWidth
        let page:Int = lroundf(Float(fractionalPage))
        
        switch (page) {
        case 0:
            tabBar(tabBar, didSelect: tabBar.items![0])
            break;
        case 1:
            tabBar(tabBar, didSelect: tabBar.items![1])
            break;
        case 2:
            tabBar(tabBar, didSelect: tabBar.items![2])
            break;
        default:
            break;
        }*/
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
        case 2:
            if self.tabBar.items?.count ?? 2 > 2 {
                tabBar(tabBar, didSelect: tabBar.items![2])
            }
            break;
        default:
            break;
        }
    }

    //MARK:- Navigation Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SEGUE.OTHER_DETAIL {
            otherDetailVC = (segue.destination as! OtherDetailVC)
        } else if segue.identifier == SEGUE.HISTORY_DETAIL_TO_INVOICE {
            invoiceDetailVC = (segue.destination as! HistoryInvoiceVC)
        }
        if segue.identifier ==  SEGUE.CART_DETAIL {
            cartDetailVC = (segue.destination as! CartDetailVC)
        }
    }

    //MARK:- Get Histroy Detail
    func wsGetHistoryDetail() {
        Utility.showLoading()
        let dictParam:[String:String] =
            [PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken(),
             PARAMS.STORE_ID : preferenceHelper.getUserId(),
             PARAMS.ORDER_ID : strOrderID]
        print("dicPraram : \(dictParam)")

        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_GET_HISTORY_DETAIL, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            print(Utility.conteverDictToJson(dict: response))
            if (Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: false)) {
                let historyOrderResposnse:HistoryOrderDetailResponse = HistoryOrderDetailResponse.init(fromDictionary: response)
                self.title = "TXT_ORDER_NO".localized + String(historyOrderResposnse.orderList.uniqueId)

                self.otherDetailVC?.userDetail = historyOrderResposnse.userDetail
                self.otherDetailVC?.providerDetail = historyOrderResposnse.providerDetail
                self.otherDetailVC?.orderDetail = historyOrderResposnse.orderList

                self.otherDetailVC?.setuserDetail(data:  historyOrderResposnse.userDetail)
                self.otherDetailVC?.setProviderDetail(data: historyOrderResposnse.providerDetail)
                self.otherDetailVC?.setOrderListDetail(data:historyOrderResposnse.orderList)

                self.cartDetailVC?.arrForProducts = historyOrderResposnse.orderList.cartDetail.orderDetails
                self.cartDetailVC?.mainOrderTable.reloadData()

                self.invoiceDetailVC?.isTaxIncluded = historyOrderResposnse.orderList.cartDetail.isTaxIncluded
                self.invoiceDetailVC?.isTableBooking = historyOrderResposnse.orderList.cartDetail.delivery_type == DeliveryType.tableBooking ? true:false
                self.invoiceDetailVC?.orderCartDetail = historyOrderResposnse.orderList.cartDetail
                self.invoiceDetailVC?.orderPayment = historyOrderResposnse.orderList.orderPaymentDetail
                self.invoiceDetailVC?.paymentType = historyOrderResposnse.paymentGatewayName
                self.invoiceDetailVC?.strCurrency = historyOrderResposnse.currency
                self.invoiceDetailVC?.getInvoiceData()

                self.setupLayout(historyOrderResposnse: historyOrderResposnse)
            } else {}
            Utility.hideLoading()
        }
    }
}
