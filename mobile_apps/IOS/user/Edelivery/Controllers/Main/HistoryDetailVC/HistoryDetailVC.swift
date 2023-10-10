//
//  Home.swift
//  edelivery
//
//  Created by Elluminati on 30/01/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit


class HistoryDetailVC: BaseVC,UIScrollViewDelegate,UITabBarDelegate {

    //MARK: Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerForOtherDetail: UIView!
    @IBOutlet weak var containerForCart: UIView!
    @IBOutlet weak var containerForInvoice: UIView!
    @IBOutlet var containerForCourierDetail: UIView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var viewForTab: UIView!

    //MARK: Variables
    var otherDetailVC:OtherDetailVC? = nil
    var invoiceDetailVC:HistoryInvoiceVC? = nil
    var cartDetailVC:CartDetailVC? = nil
    var editOrderVC:EditOrderVC? = nil
    var courierDetailVC: CourierHistoryDetailVC? = nil
    var strOrderID:String = ""
    var deliveryType: Int = 0
    var historyOrderResposnse: HistoryOrderDetailResponse? = nil

    //MARK: View life cycle
    override func viewDidLoad(){
        super.viewDidLoad()
        view.bringSubviewToFront(containerForInvoice)
        setupLayout()
        setLocalization()
        self.hideBackButtonTitle()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.setBackBarItem(isNative: true)
        wsGetHistoryDetail()
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
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        scrollView.isDirectionalLockEnabled = false
        let  firstItem =
            tabBar.addTabBarItem(title: "TXT_OTHER_DETAILS".localized, imageName: "", selectedImageName: "", tagIndex: 1)
        let secondItem = tabBar.addTabBarItem(title: "TXT_INVOICE".localized.localized, imageName: "", selectedImageName: "", tagIndex: 2)
        let thirdItem: UITabBarItem!
        if deliveryType == DeliveryType.courier {
            thirdItem =
                tabBar.addTabBarItem(title: "TXT_COURIER_DETAIL".localized, imageName: "", selectedImageName: "", tagIndex: 3)
            containerForCart.isHidden = true
            containerForCourierDetail.isHidden = false
        }else {
            thirdItem =
                tabBar.addTabBarItem(title: "TXT_CART".localized, imageName: "", selectedImageName: "", tagIndex: 3)
            containerForCart.isHidden = false
            containerForCourierDetail.isHidden = true
        }
        tabBar.setItems([firstItem,secondItem,thirdItem], animated: false)
        tabBar.selectedItem = tabBar.items![0]
    }
    
    func setupLayout() {
        tabBar.tintColor = UIColor.themeTitleColor
        tabBar.selectionIndicatorImage = APPDELEGATE.getImageWithColorPosition(color: UIColor.themeSectionBackgroundColor, size: CGSize(width:(APPDELEGATE.window?.frame.size.width)!/3,height: 49), lineSize: CGSize(width:(APPDELEGATE.window?.frame.size.width)!/3, height:2))
    }
    
    override func updateUIAccordingToTheme() {
        self.setBackBarItem(isNative: true)
    }

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
    }
    

    //MARK: Scroll View methods
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
       
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth:CGFloat = scrollView.frame.size.width
        let _:Int = Int(floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1)
    
    }
    
    //MARK:- Navigation Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SEGUE.OTHER_DETAIL {
            otherDetailVC = (segue.destination as! OtherDetailVC)
            otherDetailVC?.historyOrderResposnse = self.historyOrderResposnse
        }
        else if segue.identifier == SEGUE.HISTORY_DETAIL_TO_INVOICE {
            invoiceDetailVC?.isFromHistory = true
            invoiceDetailVC = (segue.destination as! HistoryInvoiceVC)
            
        }
        if segue.identifier ==  SEGUE.CART_DETAIL {
            cartDetailVC = (segue.destination as! CartDetailVC)
        }
        if segue.identifier ==  SEGUE.COURIER_HISTORY_DETAIL {
            courierDetailVC = (segue.destination as! CourierHistoryDetailVC)
        }
    }
    

    //MARK: Get Histroy Detail
    func wsGetHistoryDetail() {
        Utility.showLoading()
        let dictParam:[String:String] =
            [PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken(),
             PARAMS.USER_ID : preferenceHelper.getUserId(),
             PARAMS.ORDER_ID : strOrderID]
        let alamoFire:AlamofireHelper = AlamofireHelper()
        alamoFire.getResponseFromURL(url: WebService.WS_GET_HISTORY_DETAIL, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            print(Utility.convertDictToJson(dict: response as! Dictionary<String, Any>))
            if (Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: false)) {
                
                self.historyOrderResposnse = HistoryOrderDetailResponse.init(dictionary: response)!
                self.title = "TXT_ORDER_NO".localized + "\(self.historyOrderResposnse?.order_list?.unique_id ?? 0)"
                if (self.historyOrderResposnse?.order_list?.isAllowContactlessDelivery ?? false) {
                    
                }
                self.otherDetailVC?.orderStatusReponse.orderStatusDetails = self.historyOrderResposnse?.arrDateTime
                self.otherDetailVC?.orderStatusReponse.deliveryStatus = self.historyOrderResposnse?.order_list?.order_status ?? 0
                self.otherDetailVC?.orderStatusReponse.deliveryStatusDetails = self.historyOrderResposnse?.order_list?.arrDatetime ?? []
                self.otherDetailVC?.orderPaymentDetail = (self.historyOrderResposnse?.orderPayment!)!
                self.otherDetailVC?.storeDetail = self.historyOrderResposnse?.store_detail
                self.otherDetailVC?.providerDetail = self.historyOrderResposnse?.user_detail
                self.otherDetailVC?.orderDetail = self.historyOrderResposnse?.order_list
                self.otherDetailVC?.historyOrderResposnse = self.historyOrderResposnse
                self.otherDetailVC?.cartDetail = self.historyOrderResposnse?.cartDetail
                self.otherDetailVC?.setStatuDetail()

                if !((self.historyOrderResposnse?.currency?.isEmpty) ?? true ) {
                    self.cartDetailVC?.strCurrency = self.historyOrderResposnse?.currency ?? ""
                    self.invoiceDetailVC?.strCurrency = self.historyOrderResposnse?.currency ?? ""
                }

                self.otherDetailVC?.setStoreDetail(data: (self.historyOrderResposnse?.store_detail!)!, cartDetail: (self.historyOrderResposnse?.cartDetail!)!)
                self.otherDetailVC?.setProviderDetail(data: (self.historyOrderResposnse?.user_detail!)!)
                self.otherDetailVC?.setOrderPaymentDetail(data: (self.historyOrderResposnse?.orderPayment!)!)
                self.otherDetailVC?.currency = response["currency"] as? String ?? ""
                self.otherDetailVC?.paymentType = (self.historyOrderResposnse?.payment!)!
                self.otherDetailVC?.requestDetail = self.historyOrderResposnse?.requestDetail
                if self.otherDetailVC?.requestDetail?.provider_detail == nil{
                    self.otherDetailVC?.btnTrackOrder.setTitle("", for: .normal)
                    self.otherDetailVC?.btnTrackOrder.isEnabled = false
                }else{
                    self.otherDetailVC?.btnTrackOrder.isEnabled = true
                }
                self.otherDetailVC?.setOrderListDetail(data:(self.historyOrderResposnse?.order_list!)!, cartDetail: (self.historyOrderResposnse?.cartDetail!)!)
                self.courierDetailVC?.arrForImageUrls = (self.historyOrderResposnse?.order_list?.image_url) ?? []
                self.courierDetailVC?.orderId = (self.historyOrderResposnse?.order_list?.unique_id) ?? 0
                self.courierDetailVC?.setLocalization()
                self.cartDetailVC?.arrForProducts.removeAll()
                self.cartDetailVC?.historyDetailResponse = self.historyOrderResposnse!
                self.cartDetailVC?.arrForProducts = (self.historyOrderResposnse?.cartDetail?.orderDetails)!
                self.cartDetailVC?.mainOrderTable.reloadData()
                self.editOrderVC?.arrForProducts = (self.historyOrderResposnse?.cartDetail?.orderDetails)!
                self.invoiceDetailVC?.isFromHistory = true
                self.invoiceDetailVC?.orderPayment = self.historyOrderResposnse?.orderPayment
                self.invoiceDetailVC?.paymentType = (self.historyOrderResposnse?.payment!)!
                self.invoiceDetailVC?.getInvoiceData()
            }
            Utility.hideLoading()
            
        }
    }
}
