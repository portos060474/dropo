//
//  CurrentOrderVC.swift
// Edelivery Store
//
//  Created by Jaydeep Vyas on 28/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
import GoogleMaps
class CurrentOrderVC: BaseVC,RightDelegate {
    
    @IBOutlet weak var viewForOrderDetail: UIView!
    @IBOutlet weak var btnCart: UIButton!
    @IBOutlet weak var viewCart: UIView!

    //    @IBOutlet weak var btnCancelOrder: UIButton!

    @IBOutlet weak var heightForProviderView: NSLayoutConstraint!
    @IBOutlet weak var topConstraintMapView: NSLayoutConstraint!

    @IBOutlet weak var btnReassign: UIButton!
    @IBOutlet weak var btnTargetLocation: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblOrderStatus: UILabel!
    @IBOutlet weak var lblOrderNumber: UILabel!
    @IBOutlet weak var lblDeliveryAddress: UILabel!
    @IBOutlet weak var lblTotalOrderPriceValue: UILabel!
    @IBOutlet weak var imgPayment: UIImageView!
    
    @IBOutlet weak var viewForProviderDetail: UIView!
    @IBOutlet weak var imgProvider: UIImageView!
    @IBOutlet weak var lblProviderName: UILabel!
    @IBOutlet weak var imgRate: UIImageView!
    
    @IBOutlet weak var lblPickUpCode: UILabel!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var lblCallProvider: UILabel!

    @IBOutlet weak var btnCallProvider: UIButton!
    
    //    @IBOutlet weak var btnCancelRequest: UIButton!
    @IBOutlet weak var lblCancelRequest: UILabel!
    @IBOutlet weak var viewCancelRequest: UIView!
    @IBOutlet weak var imgCancelRequest: UIImageView!

    @IBOutlet var btnChat: MyBadgeButton!

    
    @IBOutlet weak var viewForSearchOverlay: UIView!
    @IBOutlet weak var viewForSearchItem: UIView!
    @IBOutlet weak var heightForSearchView: NSLayoutConstraint!
    
    @IBOutlet weak var lblChatAdmin: UILabel!
    @IBOutlet weak var lblChatUser: UILabel!
    @IBOutlet weak var lblChatProvider: UILabel!
    @IBOutlet weak var lblSepViewCart: UILabel!

    @IBOutlet weak var viewRessign: UIView!
    @IBOutlet weak var lblRessign: UILabel!
    @IBOutlet weak var lblViewCart: UILabel!
    @IBOutlet weak var lblCallDeliveryman: UILabel!
    @IBOutlet weak var btnGetCode: UIButton!
    @IBOutlet weak var lblPaymentType: UILabel!

    //    var selectedOrder:Order!
    var selectedOrder:OrderOutsideNew!
    var selectedOrderID:String = ""

    var currentOrder:OrderStatusResponse!
    var isOrderPaymentStatusSetByStore:Bool = false
    var timerForOrderStatus = Timer()
    var userMarker:GMSMarker = GMSMarker.init()
    var storeMarker:GMSMarker = GMSMarker.init()
    var providerMarker:GMSMarker = GMSMarker.init()
    var providerNumber:String = ""
    var isDoAnimation:Bool = false
    var isOrderPicked:Bool = false
    var storeLatLong:CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: 0.0, longitude: 0.0);
    var userLatLong:CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: 0.0, longitude: 0.0);
    var providerLatLong:CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: 0.0, longitude: 0.0);
    var orderStatus:OrderStatus = .Unknown
    let btnCancelOrder1 = UIButton.init(type: .custom)
    var isDeliverymanChatVisible:Bool = true
    
    var arrForCart:[OrderDetail] = []
    var selectedVehicleId:String = ""
    //MARK:  View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        viewForProviderDetail.isHidden = true
        topConstraintMapView.constant = 0
        heightForProviderView.constant = 0
        viewRessign.isHidden = true
        
        delegateRight = self
        setLocalization()
        
        btnChat = MyBadgeButton.init(frame: CGRect.init(x: 0, y: 0, width: 32, height: 32))
        btnChat?.setImage(UIImage.init(named: "chat")?.imageWithColor(color: .themeColor), for: .normal)
        btnChat?.addTarget(self, action: #selector(self.onClickBtnChat(_:)), for: .touchUpInside)
        let rightButton:UIBarButtonItem = UIBarButtonItem.init(customView: btnChat!)
        self.setRightBarButton(button: btnCancelOrder1)
        btnChat.isHidden = true
        
        viewForSearchOverlay.backgroundColor = UIColor.clear
        viewForSearchOverlay.isHidden = true
        viewForSearchItem.backgroundColor = UIColor.themeTextColor
        viewForSearchItem.setShadow(shadowColor: UIColor.themeTextColor.cgColor, shadowOffset: CGSize.init(width: 2.0, height: 2.0), shadowOpacity: 5.0, shadowRadius: 2.0)

    }
    
    func setDataLatLong(){
        if selectedOrder.providerDetail != nil {
            setProviderDetail(providerDetail: selectedOrder.providerDetail)
            isOrderPaymentStatusSetByStore = selectedOrder.orderPaymentDetail.isOrderPaymentStatusSetByStore
        }
        orderStatus = OrderStatus(rawValue: selectedOrder.requestDetail.deliveryStatus) ?? .Unknown;
        
        providerLatLong = CLLocationCoordinate2D.init(latitude: selectedOrder.requestDetail.providerLocation[0], longitude: selectedOrder.requestDetail.providerLocation[1])
        
        storeLatLong = CLLocationCoordinate2D.init(latitude: selectedOrder.requestDetail.pickupAddresses[0].location[0], longitude: selectedOrder.requestDetail.pickupAddresses[0].location[1])
        
        userLatLong = CLLocationCoordinate2D.init(latitude: selectedOrder.requestDetail.destinationAddresses[0].location[0], longitude: selectedOrder.requestDetail.destinationAddresses[0].location[1])
    }
    
    @IBAction func onClickBtnCart(_ sender: Any) {
        if arrForCart.isEmpty {
            Utility.showToast(message: "NO_ITEM_TO_DISPLAY".localized)
        }else
        {
            let modalController:CartDetailDialogVC = self.storyboard?.instantiateViewController(withIdentifier: "cartDialogVC") as! CartDetailDialogVC
            modalController.modalPresentationStyle = .overCurrentContext
            modalController.arrForProducts = arrForCart
            modalController.strOrderNumber = lblOrderNumber.text ?? ""
            self.present(modalController, animated: false, completion: nil)
        }
    }
    
    @objc func onClickRightButton() {
        if btnChat.isHidden == true{
            wsGetCancelReasonList(status: OrderStatus.STORE_CANCELLED)
        }
    }
    
    @objc func onclickbtnCancelOrder(){
        wsGetCancelReasonList(status: OrderStatus.STORE_CANCELLED)
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        //Store app
        //        resetTimer()
        self.wsGetOrderDetail()
    }
    
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews();
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews();
        setupLayout()
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopTimer()
    }
    override func viewDidDisappear(_ animated: Bool){
        super.viewDidDisappear(animated)
    }
    func openCancelOrderDialog(status:OrderStatus, list:[String]) {
        let dialogForCancelOrder = CustomCancelOrderDialog.showCustomCancelOrderDialog(title: "TXT_CANCEL_ORDER".localized, message: "", list: list, titleLeftButton: "TXT_CANCEL".localizedUppercase, titleRightButton: "TXT_OK".localizedUppercase)
        
        dialogForCancelOrder.onClickLeftButton =
            { [unowned dialogForCancelOrder] in
                dialogForCancelOrder.removeFromSuperview();
            }
        dialogForCancelOrder.onClickRightButton = { [unowned dialogForCancelOrder, unowned self] (cancelReason:String) in
            dialogForCancelOrder.removeFromSuperview();
            self.wsCancelOrder(orderStatus:status, cancelationReason: cancelReason)
        }
    }
    
    func wsCancelOrder(orderStatus:OrderStatus, cancelationReason:String = "") {
        Utility.showLoading()
        let dictParam : [String : Any] =
            [PARAMS.ORDER_ID:selectedOrder.orderPaymentDetail.orderId,
             PARAMS.STORE_ID: preferenceHelper.getUserId(),
             PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken(),
             PARAMS.ORDER_STATUS: orderStatus.rawValue,
             PARAMS.CANCELATION_REASON:cancelationReason]
        
        let alamoFire:AlamofireHelper = AlamofireHelper.init()
        
        alamoFire.getResponseFromURL(url: WebService.WS_CANCEL_REJECT_ORDER, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            
            Utility.hideLoading()
            if Parser.isSuccess(response: response) {
                self.navigationController?.popViewController(animated: true);
            }else {
                self.navigationController?.popViewController(animated: true);
            }
        }
    }
    func setLocalization() {
        //SEt Font
        lblPickUpCode.isHidden = true
        btnGetCode.isHidden = true
        
        
        lblUserName.font = FontHelper.textMedium()
        lblTotalOrderPriceValue.font = FontHelper.textMedium()
        lblOrderNumber.font = FontHelper.textSmall()
        lblOrderStatus.font = FontHelper.textSmall()
        lblDeliveryAddress.font = FontHelper.textSmall()
        
        //Set Text Color
        lblUserName.textColor = UIColor.themeTextColor
        lblDeliveryAddress.textColor = UIColor.themeLightTextColor
        lblTotalOrderPriceValue.textColor = UIColor.themeTextColor
        lblOrderNumber.textColor = UIColor.themeTextColor
        //        lblOrderStatus.textColor = UIColor.themeColor
        
        lblProviderName.font = FontHelper.textMedium()
        lblPickUpCode.font = FontHelper.textSmall()
        lblRate.font = FontHelper.textRegular()
        btnGetCode.titleLabel?.font = FontHelper.textSmall()
        btnGetCode.setTitleColor(.themeColor, for: .normal)
        
        self.lblRessign.textColor = .themeColor
        self.lblRessign.font = FontHelper.textRegular()
        self.lblViewCart.textColor = .themeColor
        self.lblViewCart.font = FontHelper.textRegular()
        self.lblCallDeliveryman.textColor = .themeColor
        self.lblCallDeliveryman.font = FontHelper.textRegular()
        self.lblPaymentType.font = FontHelper.textRegular(size: 15.0)
        self.lblPaymentType.textColor = .themeTextColor
        
        //Set Color
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        viewForOrderDetail.backgroundColor = UIColor.themeViewBackgroundColor
        viewForProviderDetail.backgroundColor = UIColor.themeViewBackgroundColor
     
        lblCancelRequest.font = FontHelper.textSmall()
        lblProviderName.textColor = UIColor.themeTextColor
        lblPickUpCode.textColor = UIColor.themeTextColor
        lblRate.textColor = UIColor.themeColor
        lblCancelRequest.textColor = UIColor.themeColor

        lblCallDeliveryman.text = "TXT_CALL".localizedCapitalized
        lblRessign.text = "TXT_REASSIGN".localizedCapitalized
        lblViewCart.text =  "TXT_VIEW_CART".localizedCapitalized
        
        lblUserName.text = "TXT_DEFAULT".localized
        lblOrderStatus.text = "TXT_DEFAULT".localized
        lblOrderNumber.text = "TXT_DEFAULT".localized
        lblTotalOrderPriceValue.text = "TXT_DEFAULT".localized
        lblProviderName.text = "TXT_DEFAULT".localized
        lblPickUpCode.text = "TXT_DEFAULT".localized
        lblRate.text = "TXT_DEFAULT".localized
        
        lblChatAdmin.text = "TXT_CHAT_WITH".localized + "TXT_ADMIN".localized
        lblChatUser.text = "TXT_CHAT_WITH".localized + "TXT_USER".localized
        lblChatProvider.text = "TXT_CHAT_WITH".localized + "TXT_PROVIDER".localized

        lblCancelRequest.text = "TITLE_CANCEL_REQUEST".localized

        self.setNavigationTitle(title: "TXT_ORDER".localizedCapitalized)
        
        lblCallProvider.font = FontHelper.textSmall()
        lblCallProvider.textColor = UIColor.themeColor

        lblCallProvider.text = "TXT_CALL_DELIVERYMAN".localizedCapitalized
        updateUIAccordingToTheme()
    }
    
    func setupLayout() {
        imgUser.setRound()
        imgProvider.setRound()
        if selectedOrder != nil{
            if selectedOrder.orderPaymentDetail.isPaymentModeCash {
                imgPayment.image = UIImage.init(named: "cash_icon")?.imageWithColor(color: .themeIconTintColor)
            }else {
                imgPayment.image = UIImage.init(named: "card_icon")?.imageWithColor(color: .themeIconTintColor)
            }
        }
    }

    override func updateUIAccordingToTheme() {
        imgCancelRequest.image = UIImage(named: "crossBig")?.imageWithColor(color: .themeColor)
        btnCancelOrder1.setImage(UIImage.init(named: "cancelIcon")?.imageWithColor(color: .themeColor), for: .normal)
        imgRate.image = UIImage(named: "star_icon")?.imageWithColor(color: .themeColor)

        
    }
    
    func setUserDetail() {
        //        lblUserName.text = selectedOrder.cartDetail.destinationAddresses[0].userDetails.name
        lblUserName.text = selectedOrder.requestDetail.userDetail.name

        lblDeliveryAddress.text = selectedOrder.cartDetail.destinationAddresses[0].address
        //JAnki check //API changes // Not getting image url
        imgUser.downloadedFrom(link: selectedOrder.userImageUrl)
        
        self.arrForCart.removeAll()
        if let orderDetail = selectedOrder.cartDetail.orderDetails {
            self.arrForCart = orderDetail
        }
        btnCart.isHidden = arrForCart.isEmpty
        viewCart.isHidden = arrForCart.isEmpty
        lblSepViewCart.isHidden = arrForCart.isEmpty
        
        if selectedOrder.orderPaymentDetail.isPaymentModeCash {
            imgPayment.image = UIImage.init(named: "cash_icon")?.imageWithColor(color: .themeIconTintColor)
        }else {
            imgPayment.image = UIImage.init(named: "card_icon")?.imageWithColor(color: .themeIconTintColor)
        }
        
        if selectedOrder.order.isPaymentModeCash{
            self.lblPaymentType.text = "\("TXT_PAYMENT_IN".localizedCapitalized) \("TXT_CASH".localizedLowercase)"
        }else{
            self.lblPaymentType.text = "\("TXT_PAYMENT_BY".localizedCapitalized) \("TXT_CARD".localizedLowercase)"
        }
        
        lblOrderNumber.text = "TXT_ORDER_NO".localized + String(selectedOrder.orderPaymentDetail.orderUniqueId)
        
        let orderStatus:OrderStatus = OrderStatus(rawValue: selectedOrder.requestDetail.deliveryStatus) ?? .Unknown;
        lblOrderStatus.text = orderStatus.text()
        lblOrderStatus.textColor = orderStatus.textColor()

        lblTotalOrderPriceValue.text = Double(selectedOrder.orderPaymentDetail.total).toCurrencyString()
    }
    
    func setProviderDetail(providerDetail:OrderProviderDetail ) {
        lblRate.text = String(providerDetail.rate)
        lblProviderName.text = providerDetail.firstName + " " + providerDetail.lastName
        imgProvider.downloadedFrom(link: providerDetail.imageUrl)
        viewForProviderDetail.isHidden = false
        topConstraintMapView.constant = 10
        heightForProviderView.constant = 80
        providerNumber = providerDetail.countryPhoneCode + providerDetail.phone
    }
    
    func resetTimer() {
        timerForOrderStatus.invalidate()
        wsOrderStatus()
        timerForOrderStatus = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(wsOrderStatus), userInfo: nil, repeats: true)
        print("Timer Reseted")
        
    }
    
    func stopTimer() {
        timerForOrderStatus.invalidate()
    }
    
    //MARK:  Button Click Events
    
    @IBAction func onClickBtnReassign(_ sender: Any) {
        self.openVehicleDialog()
    }
    
    @IBAction func onClickBtnCancelRequest(_ sender: Any){
        openCancelRequestDialog()
    }
    @IBAction func onClickBtnCall(_ sender: Any) {
        if preferenceHelper.getIsEnableTwilioCallMask() {
            TwilioCallMasking.shared.wsTwilloCallMasking(id: selectedOrder.requestDetail.id, type: "\(CONSTANT.TYPE_PROVIDER)")
        } else {
            if providerNumber.isEmpty() {
                Utility.showToast(message: "MSG_UNABLE_TO_CALL".localized)
            }else {
                if let url = URL(string: "tel://\(providerNumber)"), UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url)
                    }
                    else {
                        UIApplication.shared.openURL(url)
                    }
                }else {
                    Utility.showToast(message: "MSG_UNABLE_TO_CALL".localized)
                }
            }
        }
    }
    @IBAction func onClickBtnUserCall(_ sender: UIButton) {
        if preferenceHelper.getIsEnableTwilioCallMask() {
            var type = CONSTANT.TYPE_USER
            if sender.tag == 1 {
                type = CONSTANT.TYPE_PROVIDER
            }
            TwilioCallMasking.shared.wsTwilloCallMasking(id: selectedOrder.requestDetail.id, type: "\(type)")
        } else {
            var userPhoneNumber = (selectedOrder.cartDetail.destinationAddresses[0].userDetails.countryPhoneCode) + (selectedOrder.cartDetail.destinationAddresses[0].userDetails.phone)
            
            if sender.tag == 1 {
                userPhoneNumber = (selectedOrder.providerDetail.phone)
            }
            
            if let url = URL(string: "tel://\(userPhoneNumber)"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }else {
                Utility.showToast(message: "MSG_UNABLE_TO_CALL".localized)
            }
        }
    }
    @IBAction func onClickBtnGetCode(_ sender: Any) {
        self.openPaymentDialog()
    }
    @IBAction func onClickBtnTargetLocation(_ sender: Any) {
        focusMapToShowAllMarkers()
    }
    
    @IBAction func onClickBtnChat(_ sender: AnyObject) {
        
        let dialogForChat  = DialogForChatVC.showCustomChatDialog(DeliverymanChatVisible: isDeliverymanChatVisible)
        dialogForChat.onClickUserButton = { [unowned dialogForChat] in
            dialogForChat.removeFromSuperview();
            MessageHandler.ReceiverID = self.selectedOrder.userId
            print(MessageHandler.ReceiverID)
            self.chatNavTitle = "\(self.selectedOrder.order.userDetail.name ?? "User")"
            self.pushChatVC(ind: CONSTANT.CHATTYPES.USER_AND_STORE)
        }
        dialogForChat.onClickDeliverymanButton = { [unowned dialogForChat] in
            dialogForChat.removeFromSuperview();
            MessageHandler.ReceiverID = self.currentOrder.orderRequest.currentProvider
            print(MessageHandler.ReceiverID)
            self.chatNavTitle = "\(self.currentOrder.providerDetail.firstName ?? "Deliveryman") \(self.currentOrder.providerDetail.lastName ?? "")"
            self.pushChatVC(ind: CONSTANT.CHATTYPES.PROVIDER_AND_STORE)

        }
        dialogForChat.onClickAdminButton = { [unowned dialogForChat] in
            dialogForChat.removeFromSuperview();
            MessageHandler.ReceiverID = "000000000000000000000000"
            print(MessageHandler.ReceiverID)
            self.chatNavTitle = "Admin"
            self.pushChatVC(ind: CONSTANT.CHATTYPES.ADMIN_AND_STORE)
        }
        
    }
    
    var chatNavTitle : String = ""

    @IBAction func onClickAdminChat(_ sender: UIButton) {
        MessageHandler.ReceiverID = "000000000000000000000000"
        print(MessageHandler.ReceiverID)
        chatNavTitle = "Admin"
        pushChatVC(ind: CONSTANT.CHATTYPES.ADMIN_AND_STORE)
    }

    @IBAction func onClickUserChat(_ sender: UIButton) {
        MessageHandler.ReceiverID = self.selectedOrder.userId
        print(MessageHandler.ReceiverID)
        chatNavTitle = "\(self.selectedOrder.order.userDetail.name ?? "User")"
        pushChatVC(ind: CONSTANT.CHATTYPES.USER_AND_STORE)
    }

    @IBAction func onClickDeliverymanChat(_ sender: UIButton) {
        MessageHandler.ReceiverID = currentOrder.orderRequest.currentProvider
        print(MessageHandler.ReceiverID)
        chatNavTitle = "\(currentOrder.providerDetail.firstName ?? "Deliveryman") \(currentOrder.providerDetail.lastName ?? "")"
        pushChatVC(ind: CONSTANT.CHATTYPES.PROVIDER_AND_STORE)
    }
    
    func pushChatVC(ind:Int){
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "Orders", bundle: nil)
        if let vc : MyCustomChatVC = mainView.instantiateViewController(withIdentifier: "chatVC") as? MyCustomChatVC
        {
            self.viewGone()
            MessageHandler.orderID = selectedOrder.orderPaymentDetail.orderId
            print(self.selectedOrder.cartDetail!.storeId!)
            MessageHandler.chatType = ind
            vc.navTitle = chatNavTitle
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func onClickCancelOrder(_ sender: UIButton) {
        wsGetCancelReasonList(status: OrderStatus.STORE_CANCELLED)
    }
    
    //MARK: - USER DEFINED FUNCTION
    func viewGone(showMessage: Bool = false) {
        let height = self.heightForSearchView.constant
        
        UIView.animate(withDuration: 0.5, animations: {
            self.heightForSearchView.constant = 0.0
            self.viewForSearchItem.superview?.layoutIfNeeded()
            
        }) { (completion) in
            self.viewForSearchOverlay.isHidden = true
            self.heightForSearchView.constant = height
            self.viewForSearchItem.superview?.layoutIfNeeded()
        }
    }
    func viewVisible() {
        viewForSearchOverlay.isHidden = false
        let height = self.heightForSearchView.constant
        self.heightForSearchView.constant = 0.0
        self.viewForSearchItem.superview?.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, animations: {
            self.heightForSearchView.constant = height
            self.viewForSearchItem.superview!.layoutIfNeeded()
        })
    }
    
    //MARK:  Web Service Methods
    fileprivate func updateUiForReasign(_ orderStatus: OrderStatus) {
        if (orderStatus.rawValue  == OrderStatus.ORDER_READY.rawValue ||
                orderStatus.rawValue  == OrderStatus.NO_DELIVERY_MAN_FOUND.rawValue ||
                orderStatus.rawValue  == OrderStatus.DELIVERY_MAN_REJECTED.rawValue ||
                orderStatus.rawValue  == OrderStatus.DELIVERY_MAN_CANCELLED.rawValue ||
                orderStatus.rawValue  == OrderStatus.STORE_CANCELLED_REQUEST.rawValue)
        {
            //            btnReassign.isHidden = false
            viewRessign.isHidden = false

            self.providerMarker.map = nil
            self.setRightBarButton(button: btnCancelOrder1)

            //            btnCancelRequest.isHidden = true
            viewCancelRequest.isHidden = true

            viewForProviderDetail.isHidden = true
            topConstraintMapView.constant = 0
            heightForProviderView.constant = 0

            self.view.layoutIfNeeded()
            btnGetCode.isHidden = true
            lblPickUpCode.isHidden = true
            mapView.isHidden = true
            isDeliverymanChatVisible = false
        } else {
            //            btnReassign.isHidden = true
            viewRessign.isHidden = true
            mapView.isHidden = false
            isDeliverymanChatVisible = true
            lblPickUpCode.text = "TXT_PICKUP_CODE".localized +  String(currentOrder.orderRequest.confirmationCodeForPickUpDelivery)
            heightForProviderView.constant = 120

            let providerDetail:OrderProviderDetail = currentOrder.providerDetail

            self.setProviderDetail(providerDetail: providerDetail)
            self.view.layoutIfNeeded()
            if (selectedOrder.orderPaymentDetail.isPaymentModeCash) {
                if (orderStatus.rawValue == OrderStatus.DELIVERY_MAN_ARRIVED.rawValue ||
                        orderStatus.rawValue == OrderStatus.DELIVERY_MAN_PICKED_ORDER.rawValue ||
                        orderStatus.rawValue == OrderStatus.DELIVERY_MAN_STARTED_DELIVERY.rawValue ||
                        orderStatus.rawValue == OrderStatus.DELIVERY_MAN_ARRIVED_AT_DESTINATION.rawValue ||
                        orderStatus.rawValue == OrderStatus.DELIVERY_MAN_COMPLETE_DELIVERY.rawValue) {
                    if (!isOrderPaymentStatusSetByStore) {
                        if currentOrder.orderRequest.isConfirmationCodeRequiredAtPickupDelivery {
                            btnGetCode.setTitle("TXT_GET_CODE".localizedUppercase, for: .normal)
                        } else {
                            btnGetCode.setTitle("TXT_WHO_PAY".localizedUppercase, for: .normal)
                        }
                        btnGetCode.isHidden = false
                        lblPickUpCode.isHidden = true
                    } else {
                        if currentOrder.orderRequest.isConfirmationCodeRequiredAtPickupDelivery {
                            lblPickUpCode.isHidden = false
                        } else {
                            lblPickUpCode.isHidden = true
                        }
                        btnGetCode.isHidden = true
                    }
                } else {
                    btnGetCode.isHidden = true
                    lblPickUpCode.isHidden = true
                }
            } else {
                btnGetCode.isHidden = true
                if currentOrder.orderRequest.isConfirmationCodeRequiredAtPickupDelivery {
                    lblPickUpCode.isHidden = false
                } else {
                    lblPickUpCode.isHidden = true
                }
            }
        }
    }

    func updateUI(orderStatus:OrderStatus) {
        switch (orderStatus) {
            case OrderStatus.ORDER_READY:
                lblOrderStatus.text = orderStatus.text()
                //                btnCancelRequest.isHidden = true
                viewCancelRequest.isHidden = true

                isOrderPicked = false
                break;
            case OrderStatus.WAITING_FOR_DELIVERY_MAN:
                lblOrderStatus.text = orderStatus.text()
                viewCancelRequest.isHidden = false
                self.setRightBarButton(button: btnChat)

                btnChat.isHidden = false
                isOrderPicked = false
                break;
            case OrderStatus.DELIVERY_MAN_ACCEPTED:
                lblOrderStatus.text = orderStatus.text()
                viewCancelRequest.isHidden = false
                self.setRightBarButton(button: btnChat)
                btnChat.isHidden = false
                isOrderPicked = false
                break;
            case OrderStatus.DELIVERY_MAN_COMING:
                lblOrderStatus.text = orderStatus.text()
                btnCancelOrder1.isHidden = false
                viewCancelRequest.isHidden = false
                btnCancelOrder1.addTarget(self, action: #selector(onclickbtnCancelOrder), for: .touchUpInside)
                self.navigationItem.setRightBarButtonItems([UIBarButtonItem.init(customView: btnCancelOrder1),UIBarButtonItem.init(customView: btnChat)], animated: true)
                btnChat.isHidden = false
                isOrderPicked = false
                break;
            case OrderStatus.DELIVERY_MAN_ARRIVED:
                lblOrderStatus.text = orderStatus.text()
                viewCancelRequest.isHidden = true

                self.removerRightButton()
                self.setRightBarButton(button: btnChat)
                btnChat.isHidden = false
                isOrderPicked = false
                
                btnCancelOrder1.isHidden = false
                btnCancelOrder1.addTarget(self, action: #selector(onclickbtnCancelOrder), for: .touchUpInside)
                self.navigationItem.setRightBarButtonItems([UIBarButtonItem.init(customView: btnCancelOrder1),UIBarButtonItem.init(customView: btnChat)], animated: true)

                break;
            case OrderStatus.DELIVERY_MAN_PICKED_ORDER:
                lblOrderStatus.text = orderStatus.text()
                viewCancelRequest.isHidden = true
                self.removerRightButton()
                self.setRightBarButton(button: btnChat)
                btnChat.isHidden = false
                isOrderPicked = true
                break;
            case OrderStatus.DELIVERY_MAN_STARTED_DELIVERY:
                lblOrderStatus.text = orderStatus.text()
                viewCancelRequest.isHidden = true
                self.removerRightButton()
                self.setRightBarButton(button: btnChat)
                btnChat.isHidden = false
                isOrderPicked = true
                break;
            case OrderStatus.DELIVERY_MAN_ARRIVED_AT_DESTINATION:
                lblOrderStatus.text = orderStatus.text()
                viewCancelRequest.isHidden = true
                self.removerRightButton()
                self.setRightBarButton(button: btnChat)
                btnChat.isHidden = false
                isOrderPicked = true
                break;
            case OrderStatus.DELIVERY_MAN_COMPLETE_DELIVERY:
                lblOrderStatus.text = orderStatus.text()
                viewCancelRequest.isHidden = true
                self.removerRightButton()
                self.setRightBarButton(button: btnChat)
                btnChat.isHidden = false
                isOrderPicked = true
                self.navigationController?.popViewController(animated: true)
                break;
            case OrderStatus.NO_DELIVERY_MAN_FOUND:
                lblOrderStatus.text = orderStatus.text()
                
                self.setRightBarButton(button: btnCancelOrder1)
                
                viewForProviderDetail.isHidden = true
                topConstraintMapView.constant = 0
                heightForProviderView.constant = 0
                btnChat.isHidden = true

                self.view.layoutIfNeeded()
                viewRessign.isHidden = false

                viewCancelRequest.isHidden = true

                self.stopTimer()
                isOrderPicked = false
            default:
                isOrderPicked = false
                break;
        }
        btnCancelOrder1.isHidden = false
        btnCancelOrder1.addTarget(self, action: #selector(onclickbtnCancelOrder), for: .touchUpInside)
        self.navigationItem.setRightBarButtonItems([UIBarButtonItem.init(customView: btnCancelOrder1),UIBarButtonItem.init(customView: btnChat)], animated: true)
        btnChat.isHidden = false
        Utility.hideLoading()
    }

    @objc func wsOrderStatus() {
        Utility.showLoading()
        let dictParam : [String : String] =
            [PARAMS.ORDER_ID:selectedOrder.orderPaymentDetail.orderId,
             PARAMS.STORE_ID: preferenceHelper.getUserId(),
             PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken(),
             PARAMS.REQUEST_ID:selectedOrder.requestDetail.id]

        let alamoFire:AlamofireHelper = AlamofireHelper.init()
        alamoFire.getResponseFromURL(url: WebService.WS_CHECK_REQUEST_STATUS, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in

            if Parser.isSuccess(response: response) {
                self.currentOrder = OrderStatusResponse.init(fromDictionary:response)

                if self.currentOrder.orderRequest.pickupAddresses[0].location.count > 0 {
                    self.storeLatLong.latitude = self.currentOrder.orderRequest.pickupAddresses[0].location[0]
                    self.storeLatLong.longitude = self.currentOrder.orderRequest.pickupAddresses[0].location[1]
                }
                
                if self.currentOrder.orderRequest.destinationAddresses[0].location.count > 0 {
                    self.userLatLong.latitude = self.currentOrder.orderRequest.destinationAddresses[0].location[0]
                    self.userLatLong.longitude = self.currentOrder.orderRequest.destinationAddresses[0].location[1]
                }
                if self.currentOrder.providerDetail.providerLocation[0] != 0.0 && !self.currentOrder.providerDetail.firstName.isEmpty() {
                    
                    self.providerLatLong.latitude = self.currentOrder.providerDetail.providerLocation[0]
                    self.providerLatLong.longitude = self.currentOrder.providerDetail.providerLocation[1]
                    self.focusProviderPin(bearing:  self.currentOrder.providerDetail.bearing)
                } else {
                    self.providerMarker.map = nil
                    self.focusMapToShowAllMarkers()
                }

                self.orderStatus = OrderStatus(rawValue: self.currentOrder.orderRequest.deliveryStatus) ?? .Unknown;
                
                self.updateUI(orderStatus: self.orderStatus)
                self.updateUiForReasign(self.orderStatus)
                
                Utility.hideLoading()
            }
        }
    }

    func wsSetPaymentStatus(isPayStore:Bool = false) {
        let dictParam : [String : Any] =
            [PARAMS.ORDER_PAYMENT_ID:selectedOrder.orderPaymentDetail.id,
             PARAMS.STORE_ID: preferenceHelper.getUserId(),
             PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken(),
             PARAMS.IS_PAY_BY_STORE: isPayStore
            ]

        Utility.showLoading()
        let alamoFire:AlamofireHelper = AlamofireHelper.init()
        alamoFire.getResponseFromURL(url: WebService.WS_SET_PAYMENT_STATUS, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            if Parser.isSuccess(response: response) {
                self.isOrderPaymentStatusSetByStore = true
                self.orderStatus = OrderStatus(rawValue: self.currentOrder.orderRequest.deliveryStatus) ?? .Unknown;
                DispatchQueue.main.async {
                    self.updateUI(orderStatus: self.orderStatus)
                }
                //                Utility.hideLoading()
            } else {
                Utility.hideLoading()
            }
        }
    }

    func wsCreateRequest(isManuallyAssignProvider:Bool,selectedId:String) {
        Utility.showLoading()
        var dictParam = [String : String]()
        
        if isManuallyAssignProvider{
            dictParam  =
                [
                    PARAMS.ORDER_ID:selectedOrder.orderPaymentDetail.orderId,
                    PARAMS.STORE_ID: preferenceHelper.getUserId(),
                    PARAMS.VEHICLE_ID : selectedVehicleId,
                    PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken(),
                    PARAMS.PROVIDER_ID:selectedId]
        } else {
            dictParam  =
                [PARAMS.ORDER_ID:selectedOrder.orderPaymentDetail.orderId,
                 PARAMS.STORE_ID: preferenceHelper.getUserId(),
                 PARAMS.VEHICLE_ID : selectedVehicleId,
                 PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken()]
        }
        
        let alamoFire:AlamofireHelper = AlamofireHelper.init()
        alamoFire.getResponseFromURL(url: WebService.WS_CREATE_REQUEST, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response) {
                let providerDetail:OrderProviderDetail = OrderProviderDetail.init(fromDictionary:response["provider_detail"] as! [String : Any])
                self.setProviderDetail(providerDetail:providerDetail)
                self.resetTimer()
            }
        }
    }
    
    func wsGetCancelReasonList(status: OrderStatus) {
        
        let dictParam: Dictionary<String,Any> =
        [PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken(),
         PARAMS.STORE_ID : preferenceHelper.getUserId(),
        ]
        
        Utility.showLoading()
        
        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_GET_CANCEL_REASON_LIST, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { [weak self] (response, error) -> (Void) in
            Utility.hideLoading()
            var arrList = [String]()
            if Parser.isSuccess(response: response) {
                print(response)
                if let list = response["reasons"] as? [String] {
                    arrList.append(contentsOf: list)
                }
            }
            self?.openCancelOrderDialog(status: status, list: arrList)
        }
    }

    func wsCancelRequest() {
        Utility.showLoading()
        if currentOrder.orderRequest.currentProvider != nil {
            let dictParam : [String : String] =
                [PARAMS.REQUEST_ID:selectedOrder.requestDetail.id,
                 PARAMS.STORE_ID: preferenceHelper.getUserId(),
                 PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken(),
                 PARAMS.PROVIDER_ID:currentOrder.orderRequest.currentProvider]

            let alamoFire:AlamofireHelper = AlamofireHelper.init()
            print(Utility.conteverDictToJson(dict: dictParam))
            alamoFire.getResponseFromURL(url: WebService.WS_CANCEL_REQUEST, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
                print("WS_CANCEL_REQUEST response \(response)")
                if Parser.isSuccess(response: response) {
                    self.stopTimer()
                    self.providerMarker.map = nil
                    self.focusMapToShowAllMarkers()
                    self.btnChat.isHidden = true
                    let orderStatus:OrderStatus = OrderStatus(rawValue: self.selectedOrder.requestDetail.deliveryStatus) ?? .Unknown;
                    self.lblOrderStatus.text = orderStatus.text()
                    self.lblOrderStatus.textColor = orderStatus.textColor()
                    self.updateUiForReasign(OrderStatus.STORE_CANCELLED_REQUEST)
                    Utility.hideLoading()
                } else {
                    Utility.hideLoading()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }

    func wsGetNearestProviderList() {
        Utility.showLoading()
        let dictParam:[String:String] =
            [PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken(),
             PARAMS.STORE_ID : preferenceHelper.getUserId(),
             PARAMS.ORDER_ID: selectedOrder.orderPaymentDetail.orderId,
             PARAMS.VEHICLE_ID : selectedVehicleId
            ]
        
        print("WS_FIND_NEAREST_PROVIDER_LIST \(dictParam)")
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_FIND_NEAREST_PROVIDER_LIST, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            
            print("WS_FIND_NEAREST_PROVIDER_LIST \(response)")
            Utility.hideLoading()
            if Parser.isSuccess(response: response) {
                
                let response:ModelManualProvider = ModelManualProvider.init(fromDictionary:response)
                var itemListArray = [ModelProvider]()
                for obj in response.providers {
                    itemListArray.append(obj)
                }
                if itemListArray.isEmpty {
                    Utility.showToast(message: "ERROR_CODE_426".localized)
                }else {
                    let dialog = ManualProviderSelectionDialog.showDialog(languages: [:], title: "",options: itemListArray, isAllowMultiselect: false)
                    dialog.onItemSelected = { [unowned self] (selectedId) in
                        self.wsCreateRequest(isManuallyAssignProvider: true,selectedId: selectedId)
                        dialog.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    
    func wsGetOrderDetail() {
        let dictParam : [String : Any] =
            [PARAMS.STORE_ID      : preferenceHelper.getUserId(),
             PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken(),
             //             PARAMS.ORDER_ID: selectedOrder.id]
             PARAMS.ORDER_ID: selectedOrderID]

        print("dictParam WS_GET_ORDER_DETAIL --> \(dictParam)")

        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_GET_ORDER_DETAIL, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {   (response, error) -> (Void) in
            
            print("response WS_GET_ORDER_DETAIL --> \(Utility.conteverDictToJson(dict: response))")
            // Utility.showLoading()

            if  Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: false) {
                let orderListReponse:OrderDetailsNew = OrderDetailsNew.init(fromDictionary: response)
                self.selectedOrder = orderListReponse.order

                self.setUserDetail()
                self.setDataLatLong()
                
                self.updateUI(orderStatus: self.orderStatus)
                self.focusMapToShowAllMarkers()
                self.resetTimer()
                // Utility.hideLoading()
            }
            //self.reloadTableWithArray()
        }
    }
    
    //MARK: Show all markers
    fileprivate func focusProviderPin(bearing:Double) {
        if providerLatLong.latitude != 0 && providerLatLong.longitude != 0 {
            if providerMarker.map == nil {
                providerMarker.icon = Utility.resize(image:UIImage(named: "provider_pin")!)
                
                Utility.downloadImageFrom(link: self.currentOrder.vehicleDetail.mapPinImageUrl, completion: { (image) in
                    self.providerMarker.icon = image
                    
                })
                providerMarker.map = mapView;
            }
            mapView.bringSubviewToFront(btnTargetLocation)
            if isDoAnimation {

                CATransaction.begin()
                CATransaction.setValue(3.0, forKey: kCATransactionAnimationDuration)
                CATransaction.setCompletionBlock {}
                mapView.animate(toLocation: providerLatLong)
                providerMarker.position = providerLatLong
                providerMarker.rotation = bearing
                CATransaction.commit()
                
            }else {
                isDoAnimation = true
                
                providerMarker.position = providerLatLong
                providerMarker.rotation = bearing
                
               Utility.downloadImageFrom(link: self.currentOrder.vehicleDetail.mapPinImageUrl, completion: { (image) in
                    self.providerMarker.icon = image
                })
            }
        }
    }
    
    func focusMapToShowAllMarkers(isAnimation:Bool = false) {
        
        if userMarker.map == nil {
            userMarker.icon = UIImage(named: "user_pin")
            userMarker.map = mapView
        }
        if storeMarker.map == nil {
            storeMarker.icon = UIImage(named: "store_pin")
            storeMarker.map = mapView;
        }
        storeMarker.position =  storeLatLong
        userMarker.position = userLatLong
        
        if providerLatLong.latitude != 0 && providerLatLong.longitude != 0 {
            if providerMarker.map == nil {
                providerMarker.icon = Utility.resize(image:UIImage(named: "provider_pin")!)
                
                providerMarker.map = mapView;
            }
        }
        
        mapView.bringSubviewToFront(btnTargetLocation)
        var bounds = GMSCoordinateBounds()

        if providerLatLong.latitude != 0.0  && providerLatLong.longitude != 0.0 {
            bounds = bounds.includingCoordinate(providerLatLong)
        }
        if (self.orderStatus.rawValue) ==  OrderStatus.WAITING_FOR_DELIVERY_MAN.rawValue {
            bounds = bounds.includingCoordinate(userLatLong)
            bounds = bounds.includingCoordinate(storeLatLong)
        }else if (self.orderStatus.rawValue) >= OrderStatus.DELIVERY_MAN_ARRIVED.rawValue {
            bounds = bounds.includingCoordinate(userLatLong)
        }else {
            bounds = bounds.includingCoordinate(storeLatLong)
        }
        if isAnimation {
            CATransaction.begin()
            CATransaction.setValue(3.0, forKey: kCATransactionAnimationDuration)
            CATransaction.setCompletionBlock {
            }
            mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 80.0))
            CATransaction.commit()

        }else {
            mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 80.0))
        }
        if isOrderPicked {
            mapView.animate(toBearing: getHeadingForDirection(fromCoordinate: providerLatLong, toCoordinate: userLatLong))
        }else {
            mapView.animate(toBearing: getHeadingForDirection(fromCoordinate: providerLatLong, toCoordinate: storeLatLong))
            
        }

    }
    func getHeadingForDirection(fromCoordinate fromLoc: CLLocationCoordinate2D, toCoordinate toLoc: CLLocationCoordinate2D) -> Double {
        
        
        let fLat: Double = fromLoc.latitude.degreesToRadians
        let fLng: Double = fromLoc.longitude.degreesToRadians
        let tLat: Double = toLoc.latitude.degreesToRadians
        let tLng: Double = toLoc.latitude.degreesToRadians
        let degree: Double = atan2(sin(tLng - fLng) * cos(tLat), cos(fLat) * sin(tLat) - sin(fLat) * cos(tLat) * cos(tLng - fLng)).radiansToDegrees
        if degree >= 0 {
            return degree
        }else {
            return 360 + degree
        }
    }
    
    //MARK:- DIALOGS
    
    func openPaymentDialog () {
        let dialogForPayment  = CustomAlertDialog.showCustomAlertDialog(title: "TITLE_ORDER_PAYMENT".localized, message: "MSG_ADVANCE_PAY_FOR_ORDER".localized, titleLeftButton: "TXT_NO".localizedUppercase, titleRightButton: "TXT_YES".localizedUppercase)
        dialogForPayment.onClickLeftButton = {
            [unowned dialogForPayment, unowned self] in
            dialogForPayment.removeFromSuperview();
            self.wsSetPaymentStatus(isPayStore:false )
        }
        dialogForPayment.onClickRightButton =
            {
                [unowned dialogForPayment, unowned self] in
                dialogForPayment.removeFromSuperview();
                self.wsSetPaymentStatus(isPayStore:true )
            }
        
    }
    
    func openVehicleDialog() {
        if selectedOrder.orderPaymentDetail.deliveryPriceUsedType == vehicleType {
            var itemListArray:[(String,Bool)] = []
            
            for i in StoreSingleton.shared.vehicalList {
                itemListArray.append((i.vehicleName,false))
            }
            if itemListArray.isEmpty {
                Utility.showToast(message: "TXT_NO_VEHICLE_AVAILABLE".localized)
            }else {
                
                let dialogForLocalizedLanguage = TableviewDialogVehicle.showDialog(languages: [:], title: "",options: itemListArray, isAllowMultiselect: false)
                dialogForLocalizedLanguage.onItemSelected = { [unowned self] (selectedIndex) in

                    if StoreSingleton.shared.adminVehicalList.count >= selectedIndex[0]{
                        self.selectedVehicleId =  StoreSingleton.shared.adminVehicalList[selectedIndex[0]].vehicleId
                    }else{
                        Utility.showToast(message: "TXT_NO_VEHICLE_AVAILABLE".localized)
                    }
                    //self.wsCreateRequest(orderId: self.selectedOrderId)
                    dialogForLocalizedLanguage.removeFromSuperview()
                }
                
                dialogForLocalizedLanguage.onClickAssignAutoSelected = {
                    self.wsCreateRequest(isManuallyAssignProvider: false,selectedId: "")
                }
                
                dialogForLocalizedLanguage.onClickAssignManuallySelected = {
                    self.wsGetNearestProviderList()
                }
            }
            
        }else {
            var itemListArray:[(String,Bool)] = []
            
            for i in StoreSingleton.shared.adminVehicalList {
                itemListArray.append((i.vehicleName,false))
            }
            
            if itemListArray.isEmpty {
                Utility.showToast(message: "TXT_NO_VEHICLE_AVAILABLE".localized)
            }else {
                
                let dialogForLocalizedLanguage = TableviewDialogVehicle.showDialog(languages: [:], title: "",options: itemListArray, isAllowMultiselect: false)
                dialogForLocalizedLanguage.onItemSelected = { [unowned self] (selectedIndex) in

                    self.selectedVehicleId =  StoreSingleton.shared.adminVehicalList[selectedIndex[0]].vehicleId
                    //self.wsCreateRequest(orderId: self.selectedOrderId)
                    dialogForLocalizedLanguage.removeFromSuperview()
                }
                
                dialogForLocalizedLanguage.onClickAssignAutoSelected = {
                    self.wsCreateRequest(isManuallyAssignProvider: false,selectedId: "")
                }
                
                dialogForLocalizedLanguage.onClickAssignManuallySelected = {
                    self.wsGetNearestProviderList()
                }
            }
        }
    }

    func openCancelRequestDialog() {
        let dialogForCancelRequest  = CustomAlertDialog.showCustomAlertDialog(title: "TITLE_CANCEL_REQUEST".localized, message: "MSG_CANCEL_REQUEST".localized, titleLeftButton: "TXT_NO".localizedUppercase, titleRightButton: "TXT_YES".localizedUppercase)
        dialogForCancelRequest.onClickLeftButton = {
            [unowned dialogForCancelRequest] in
            dialogForCancelRequest.removeFromSuperview();
        }
        dialogForCancelRequest.onClickRightButton = { [unowned dialogForCancelRequest,unowned self] in
            dialogForCancelRequest.removeFromSuperview();
            self.wsCancelRequest()
        }
    }
}

