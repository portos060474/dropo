//
//  CourierStatusVC.swift
//  edelivery
//
//  Created by Elluminati on 14/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class CourierStatusVC: BaseVC, LeftDelegate {
    //MARK: OutLets
    @IBOutlet weak var viewForOrderStatus: UIView!
    @IBOutlet weak var orderNumber: UILabel!
    @IBOutlet weak var viewForEstTime: UILabel!
    @IBOutlet weak var lblEstDeliveryTime: UILabel!
    @IBOutlet weak var btnOrderAccepted: UIButton!
    @IBOutlet weak var btnOrderPrepared: UIButton!
    @IBOutlet weak var btnOrderOnTheWay: UIButton!
    @IBOutlet weak var btnOrderOnDoorStep: UIButton!
    @IBOutlet weak var btnToPrepareOrder: UIButton!
    @IBOutlet weak var btnCancelOrder: UIButton!
    @IBOutlet weak var btnTrackOrder: UIButton!
    @IBOutlet weak var btnGetCode: UIButton!
    @IBOutlet var btnGetPickupCode: UIButton!
    @IBOutlet weak var lblOrderAccepted: UILabel!
    @IBOutlet weak var lblOrderPrepared: UILabel!
    @IBOutlet weak var lblOrderTheWay: UILabel!
    @IBOutlet weak var lblOrderOnDoorStep: UILabel!
    @IBOutlet weak var viewForOnTheWay: UIView!
    @IBOutlet weak var viewForDoorStop: UIView!
    @IBOutlet weak var lblDividerToTrackProvider: UILabel!
    @IBOutlet weak var lblDividerToDoorStep: UILabel!
    @IBOutlet weak var lblAcceptedDate: UILabel!
    @IBOutlet weak var lblAcceptedTime: UILabel!
    @IBOutlet weak var lblPreparedDate: UILabel!
    @IBOutlet weak var lblPreparedTime: UILabel!
    @IBOutlet weak var lblStartDeliveryDate: UILabel!
    @IBOutlet weak var lblStartDeliveryTime: UILabel!
    @IBOutlet weak var lblDeliveryCompleteDate: UILabel!
    @IBOutlet weak var lblDeliveryCompleteTime: UILabel!
    @IBOutlet weak var pickUpUserImage: UIImageView!
    @IBOutlet weak var lblPickUpUserName: UILabel!
    @IBOutlet weak var lblPickUpUserAddress: UILabel!
    @IBOutlet var btnChat: MyBadgeButton!
    @IBOutlet weak var btnRateProvider: UIButton!
    @IBOutlet weak var btnViewInvoice: UIButton!
    @IBOutlet weak var btnPickUpImage: UIButton!
    @IBOutlet weak var btnDeliveryDetail: UIButton!
    
    //MARK: Variables
    weak var timerForOrderStatus: Timer? = nil
    var selectedOrder:Order = Order.init()
    var orderStatusReponse:OrderStatusResponse = OrderStatusResponse.init(fromDictionary: [:])
    var arrForDeliveryDetails:[OrderDateWiseStatusDetails] = []
    var dialogForCancelOrder:CustomCancelOrderDialog? = nil
    var dialogForConfirmCode:CustomAlertDialog? = nil
    var dialogForPickupConfirmCode:CustomAlertDialog? = nil
    var dialogForFeedback: DailogForFeedback? = nil
    var isDeliverymanChatVisible: Bool = false
    var pickupImageUrl: String = ""
    var btnRight: UIButton? = nil
    var isOpenFromPush: Bool = false
    var isFromHistory = false
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        print("OrderStatusVC Load")
        viewForEstTime.isHidden = true
        lblEstDeliveryTime.isHidden = true
        setLocalization()
        btnGetCode.isHidden = true
        btnGetCode.addTarget(self, action: #selector(OrderStatusVC.tapOnGetCode(sender:)), for: .touchUpInside)
        btnGetPickupCode.isHidden = true
        btnGetPickupCode.addTarget(self, action: #selector(self.tapOnGetPickupCode(sender:)), for: .touchUpInside)
        btnCancelOrder.addTarget(self, action: #selector(self.tapOnOrderCancel(sender:)), for: .touchUpInside)
        btnToPrepareOrder.addTarget(self, action: #selector(self.tapOnPrepareOrder(sender:)), for: .touchUpInside)
        btnTrackOrder.addTarget(self, action: #selector(self.tapOnOrderOnTheWay(sender:)), for: .touchUpInside)
        btnChat = MyBadgeButton.init(frame: CGRect.init(x: 0, y: 0, width: 32, height: 32))
        btnChat?.setImage(UIImage.init(named: "chat")?.imageWithColor(color: .themeColor), for: .normal)
        btnChat?.addTarget(self, action: #selector(self.onClickBtnChat(_:)), for: .touchUpInside)
        btnViewInvoice.addTarget(self, action: #selector(self.tapOnViewInvoice(sender:)), for: .touchUpInside)
        btnPickUpImage.addTarget(self, action: #selector(self.tapOnPickupImage(sender:)), for: .touchUpInside)
        btnDeliveryDetail.addTarget(self, action: #selector(self.tapOnDeliveryDetail(sender:)), for: .touchUpInside)
        let rightButton:UIBarButtonItem = UIBarButtonItem.init(customView: btnChat!)
        self.navigationItem.setRightBarButton(rightButton, animated: false)
        
        btnOrderAccepted.isSelected = false
        btnOrderPrepared.isSelected = false
        btnOrderOnTheWay.isSelected = false
        btnOrderOnDoorStep.isSelected = false
        self.btnPickUpImage.isHidden = true
        self.btnDeliveryDetail.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        wsGetOrderDetail()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        btnOrderAccepted.setRound()
        btnOrderPrepared.setRound()
        btnOrderOnTheWay.setRound()
        btnOrderOnDoorStep.setRound()
        pickUpUserImage.setRound(withBorderColor: UIColor.clear, andCornerRadious: 8.0, borderWidth: 0.5)
        animateView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timerForOrderStatus?.invalidate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func onClickLeftButton() {
        if isOpenFromPush {
            APPDELEGATE.goToMain()
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func setLocalization(isFromModeChange : Bool = false) {
        
        self.setBackBarItem(isNative: false)
        delegateLeft = self
        self.hideBackButtonTitle()
        
        /*Set localized Text*/
        lblOrderAccepted.text = "TXT_ORDER_ACCEPTED".localized
        lblEstDeliveryTime.text = "TXT_ESTIMATE_DELIVERY_TIME".localizedCapitalized
        lblOrderPrepared.text = "TXT_PICKED_UP".localized
        lblOrderTheWay.text = "TXT_IN_TRANSIT".localized
        lblOrderOnDoorStep.text = "TXT_DELIVERED".localized
        btnCancelOrder.setTitle( "" + "TXT_CANCEL_ORDER".localizedCapitalized + "  ", for: .normal)
        btnToPrepareOrder.setTitle("" + "TXT_PREPARE_ORDER".localizedCapitalized + "  ", for: .normal)
        btnTrackOrder.setTitle("" + "TXT_TRACK_ORDER".localizedCapitalized + "  ", for: .normal)
        btnGetCode.setTitle("  "+"TXT_GET_CODE".localizedCapitalized + "  ", for: .normal)
        btnGetPickupCode.setTitle(""+"TXT_GET_CODE".localizedCapitalized + "  ", for: .normal)
        btnViewInvoice.setTitle( "" + "TXT_VIEW_INVOICE".localizedCapitalized + "  ", for: .normal)
        btnPickUpImage.setTitle( "" + "TXT_PICKUP_IMAGE".localizedCapitalized + "  ", for: .normal)
        btnDeliveryDetail.setTitle( "" + "TXT_DELIVERY_DETAILS".localizedCapitalized + "  ", for: .normal)
        
        if !isFromModeChange{
            lblAcceptedDate.text = ""
            lblAcceptedTime.text = ""
            lblPreparedDate.text = ""
            lblPreparedTime.text = ""
            lblStartDeliveryDate.text = ""
            lblStartDeliveryTime.text = ""
            lblDeliveryCompleteDate.text = ""
            lblDeliveryCompleteTime.text = ""
        }
        
        lblAcceptedDate.textColor = UIColor.themeTextColor
        lblAcceptedTime.textColor = UIColor.themeLightTextColor
        lblPreparedDate.textColor = UIColor.themeTextColor
        lblPreparedTime.textColor = UIColor.themeLightTextColor
        lblStartDeliveryDate.textColor = UIColor.themeTextColor
        lblStartDeliveryTime.textColor = UIColor.themeLightTextColor
        lblDeliveryCompleteDate.textColor = UIColor.themeTextColor
        lblDeliveryCompleteTime.textColor = UIColor.themeLightTextColor
        lblAcceptedDate.font = FontHelper.textRegular()
        lblAcceptedTime.font = FontHelper.textRegular()
        lblPreparedDate.font = FontHelper.textRegular()
        lblPreparedTime.font = FontHelper.textRegular()
        lblStartDeliveryDate.font = FontHelper.textRegular()
        lblStartDeliveryTime.font = FontHelper.textRegular()
        lblDeliveryCompleteDate.font = FontHelper.textRegular()
        lblDeliveryCompleteTime.font = FontHelper.textRegular()
        
        
        /*Set color */
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        lblOrderAccepted.textColor = UIColor.themeTextColor
        lblEstDeliveryTime.textColor = UIColor.themeTextColor
        lblOrderPrepared.textColor = UIColor.themeTextColor
        lblOrderTheWay.textColor = UIColor.themeTextColor
        lblOrderOnDoorStep.textColor = UIColor.themeTextColor
        viewForEstTime.backgroundColor = UIColor.clear
        viewForEstTime.textColor = UIColor.themeTextColor
        btnToPrepareOrder.backgroundColor = UIColor.themeViewBackgroundColor
        btnCancelOrder.backgroundColor = UIColor.themeViewBackgroundColor
        btnTrackOrder.backgroundColor = UIColor.themeViewBackgroundColor
        btnGetCode.backgroundColor = UIColor.themeViewBackgroundColor
        btnGetPickupCode.backgroundColor = UIColor.themeViewBackgroundColor
        btnViewInvoice.backgroundColor = UIColor.themeViewBackgroundColor
        btnCancelOrder.setTitleColor(UIColor.themeColor, for: .normal)
        btnPickUpImage.backgroundColor = UIColor.themeViewBackgroundColor
        btnDeliveryDetail.backgroundColor = UIColor.themeViewBackgroundColor
        btnToPrepareOrder.setTitleColor(UIColor.themeColor, for: .normal)
        btnTrackOrder.setTitleColor(UIColor.themeColor, for: .normal)
        btnGetCode.setTitleColor(UIColor.themeColor, for: .normal)
        btnGetPickupCode.setTitleColor(UIColor.themeColor, for: .normal)
        btnViewInvoice.setTitleColor(UIColor.themeColor, for: .normal)
        btnPickUpImage.setTitleColor(UIColor.themeColor, for: .normal)
        btnDeliveryDetail.setTitleColor(UIColor.themeColor, for: .normal)
        
        /*Set Font*/
        btnOrderAccepted.titleLabel?.font = FontHelper.textRegular()
        btnOrderPrepared.titleLabel?.font = FontHelper.textRegular()
        btnOrderOnTheWay.titleLabel?.font = FontHelper.textRegular()
        btnOrderOnDoorStep.titleLabel?.font = FontHelper.textRegular()
        btnCancelOrder.titleLabel?.font = FontHelper.textRegular()
        btnToPrepareOrder.titleLabel?.font = FontHelper.textRegular()
        btnTrackOrder.titleLabel?.font = FontHelper.textRegular()
        btnGetCode.titleLabel?.font = FontHelper.textRegular()
        btnGetPickupCode.titleLabel?.font = FontHelper.textRegular()
        btnViewInvoice.titleLabel?.font = FontHelper.textRegular()
        btnPickUpImage.titleLabel?.font = FontHelper.textRegular()
        btnDeliveryDetail.titleLabel?.font = FontHelper.textRegular()
        lblOrderAccepted.font = FontHelper.textRegular()
        lblEstDeliveryTime.font = FontHelper.textRegular()
        lblOrderPrepared.font = FontHelper.textRegular()
        lblOrderTheWay.font = FontHelper.textRegular()
        lblOrderOnDoorStep.font = FontHelper.textRegular()
        viewForEstTime.font = FontHelper.textSmall()
        btnOrderAccepted.setTitle("TXT_1".localized, for: .normal)
        btnOrderPrepared.setTitle("TXT_2".localized, for: .normal)
        btnOrderOnTheWay.setTitle("TXT_3".localized, for: .normal)
        btnOrderOnDoorStep.setTitle("TXT_4".localized, for: .normal)
        btnOrderAccepted.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnOrderPrepared.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnOrderOnTheWay.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnOrderOnDoorStep.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnViewInvoice.setTitleColor(UIColor.themeColor, for: .normal)
        btnViewInvoice.titleLabel?.font = FontHelper.textRegular()
        btnOrderAccepted.setTitleColor(UIColor.themeViewBackgroundColor, for: .selected)
        btnOrderPrepared.setTitleColor(UIColor.themeViewBackgroundColor, for: .selected)
        btnOrderOnTheWay.setTitleColor(UIColor.themeViewBackgroundColor, for: .selected)
        btnOrderOnDoorStep.setTitleColor(UIColor.themeViewBackgroundColor, for: .selected)
        btnOrderAccepted.setBackgroundColor(color: UIColor.themeStatusTickColor, forState: .normal)
        btnOrderPrepared.setBackgroundColor(color: UIColor.themeStatusTickColor, forState: .normal)
        btnOrderOnTheWay.setBackgroundColor(color: UIColor.themeStatusTickColor, forState: .normal)
        btnOrderOnDoorStep.setBackgroundColor(color: UIColor.themeStatusTickColor, forState: .normal)
        btnOrderAccepted.setBackgroundColor(color: UIColor.themeTextColor, forState: .selected)
        btnOrderPrepared.setBackgroundColor(color: UIColor.themeTextColor, forState: .selected)
        btnOrderOnTheWay.setBackgroundColor(color: UIColor.themeTextColor, forState: .selected)
        btnOrderOnDoorStep.setBackgroundColor(color: UIColor.themeTextColor, forState: .selected)
        self.setBackBarItem(isNative: false)
        lblPickUpUserName.textColor = UIColor.themeTitleColor
        lblPickUpUserAddress.textColor = UIColor.themeTitleColor
        lblPickUpUserName.font = FontHelper.textMedium(size: FontHelper.regular)
        lblPickUpUserAddress.font = FontHelper.textRegular()
        btnRateProvider.setTitle("".localized, for: .normal)
        btnRateProvider.setTitleColor(UIColor.themeColor, for: .normal)
        btnRateProvider.titleLabel?.font = FontHelper.textRegular(size: FontHelper.regular)
        btnRateProvider.isHidden = true
        btnRateProvider.setImage(UIImage(named: "star_give_rate"), for: .normal)
        btnRateProvider.tintColor = UIColor.themeColor
    }
    
    override func updateUIAccordingToTheme() {
        setLocalization(isFromModeChange: true)
    }
    func setPickUpDetail()  {
        lblPickUpUserName.text = (self.orderStatusReponse.pickupAddresses.first)?.userDetails?.name
        lblPickUpUserAddress.text = (self.orderStatusReponse.pickupAddresses.first)?.address
        guard let imageUrl = ((self.orderStatusReponse.pickupAddresses.first) as? Address)?.userDetails?.imageUrl else { return  }
        pickUpUserImage.downloadedFrom(link: Utility.getDynamicResizeImageURL(width: pickUpUserImage.frame.size.width, height: pickUpUserImage.frame.size.height, imgUrl: imageUrl), isFromResize: true)
    }
    // MARK: - IBAction method
    @IBAction func onClickBtnChat(_ sender: AnyObject) {
        self.openChatDialog()
    }
    
    var chatNavTitle : String = ""
    
    @IBAction func onClickAdminChat(_ sender: UIButton) {
        MessageHandler.ReceiverID = "000000000000000000000000"
        print(MessageHandler.ReceiverID)
        chatNavTitle = "Admin"
        pushChatVC(ind: CONSTANT.CHATTYPES.ADMIN_AND_USER)
    }
    
    @IBAction func onClickStoreChat(_ sender: UIButton) {
        MessageHandler.ReceiverID = self.selectedOrder.cartDetail!.storeId!
        print("store MessageHandler.ReceiverID \(MessageHandler.ReceiverID)")
        chatNavTitle = self.selectedOrder.store_name ?? "Store"
        pushChatVC(ind: CONSTANT.CHATTYPES.USER_AND_STORE)
    }
    
    @IBAction func onClickDeliverymanChat(_ sender: UIButton) {
        MessageHandler.ReceiverID = self.orderStatusReponse.providerId
        print(MessageHandler.ReceiverID)
        chatNavTitle = "\(self.orderStatusReponse.provider_detail?.name ?? "")"
        pushChatVC(ind: CONSTANT.CHATTYPES.USER_AND_PROVIDER)
    }
    @IBAction func onClickRateProvider(_ sender: UIButton)  {
        openFeedbackDialogue(isRateProvider: true)
    }
    
    func pushChatVC(ind:Int){
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "Order", bundle: nil)
        if let vc : MyCustomChatVC = mainView.instantiateViewController(withIdentifier: "chatVC") as? MyCustomChatVC
        {
            MessageHandler.chatType = ind
            vc.navTitle = chatNavTitle
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: WEB SERVICE CALLS
    
    @objc func wsGetOrderStatus() {
        let dictParam: Dictionary<String,Any> =
        [PARAMS.USER_ID:preferenceHelper.getUserId(),
         PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken(),
         PARAMS.ORDER_ID:selectedOrder._id ?? ""]
        
        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_ORDER_STATUS, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            
            Utility.hideLoading()
            
            if (Parser.isSuccess(response: response) && self.view.subviews.count > 0) {
                
                self.orderStatusReponse = OrderStatusResponse.init(fromDictionary: response as! [String : Any])
                self.title =
                "TXT_ORDER_NO".localized + String((self.orderStatusReponse.uniqueId) ?? 0)
                if !self.orderStatusReponse.destinationAddresses.isEmpty {
                    currentBooking.deliveryLatLng = self.orderStatusReponse.destinationAddresses[0].location
                    
                }
                if !self.orderStatusReponse.pickupAddresses.isEmpty {
                    self.setPickUpDetail()
                }
                
                self.updateStatusUI(isConfirmationCodeRequired: self.orderStatusReponse.isConfirmationCodeRequiredAtCompleteDelivery, isUserWillPickupDelivery: self.orderStatusReponse.isUserPickUpOrder, isConfirmationCodeRequiredAtPickup: self.orderStatusReponse.isConfirmationCodeRequiredAtPickupDelivery)
                
                let orderStatus =  self.orderStatusReponse.deliveryStatus ?? 0
                self.checkForOrderStatus(orderStatusValue: orderStatus)
                self.arrForDeliveryDetails.removeAll()
                
                
                for details in self.orderStatusReponse.orderStatusDetails {
                    let orderStatusDetail:OrderDateWiseStatusDetails = OrderDateWiseStatusDetails.init(fromDictionary: [:])
                    
                    if details.date.count > 0{
                        orderStatusDetail.date =  Utility.stringToString(strDate: details.date, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.TIME_FORMAT_HH_MM)
                    }
                    orderStatusDetail.time = Utility.stringToString(strDate:details.date, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.TIME_FORMAT_AM_PM)
                    orderStatusDetail.status = details.status
                    
                    self.arrForDeliveryDetails.append(orderStatusDetail)
                    
                }
                for details in self.orderStatusReponse.deliveryStatusDetails {
                    let orderStatusDetail:OrderDateWiseStatusDetails = OrderDateWiseStatusDetails.init(fromDictionary: [:])
                    if details.date.count > 0{
                        orderStatusDetail.date = Utility.relativeDateStringForDate(strDate: Utility.stringToString(strDate: details.date, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_TIME_FORMAT_HISTORY, locale: "en_GB"), dateFormate: DATE_CONSTANT.DATE_TIME_FORMAT_HISTORY) as String
                    }
                    orderStatusDetail.time = Utility.stringToString(strDate:details.date, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.TIME_FORMAT_AM_PM)
                    
                    orderStatusDetail.status = details.status
                    self.arrForDeliveryDetails.append(orderStatusDetail)
                    if OrderStatus.init(rawValue:details.status) == OrderStatus.DELIVERY_MAN_PICKED_ORDER  {
                        if details.imageUrl != "" {
                            self.pickupImageUrl = details.imageUrl
                        }
                    }
                }
                
                for orderStatusDetails in self.arrForDeliveryDetails {
                    
                    let orderStatus =  OrderStatus.init(rawValue: orderStatusDetails.status) ?? OrderStatus.Unknown
                    self.btnCancelOrder.isHidden = false
                    self.btnViewInvoice.isHidden = true
                    
                    switch (orderStatus)
                    {
                        
                    case OrderStatus.CANCELED_BY_USER:
                        self.lblAcceptedDate.text = orderStatusDetails.date
                        self.lblAcceptedTime.text = orderStatusDetails.date
                        self.btnCancelOrder.isHidden = true
                        self.isDeliverymanChatVisible = false
                        self.btnRateProvider.isHidden = true
                        self.btnPickUpImage.isHidden = true
                        break
                        
                    case OrderStatus.DELIVERY_MAN_ACCEPTED:
                        self.lblAcceptedDate.text = orderStatusDetails.date
                        self.lblAcceptedTime.text = orderStatusDetails.date
                        self.btnCancelOrder.isHidden = false
                        self.isDeliverymanChatVisible = false
                        self.btnRateProvider.isHidden = true
                        self.btnPickUpImage.isHidden = true
                        break
                        
                    case OrderStatus.DELIVERY_MAN_PICKED_ORDER:
                        self.lblPreparedDate.text = orderStatusDetails.date
                        self.lblPreparedTime.text = orderStatusDetails.date
                        self.btnCancelOrder.isHidden = true
                        self.isDeliverymanChatVisible = true
                        self.btnRateProvider.isHidden = true
                        self.btnPickUpImage.isHidden = true
                        break
                        
                    case OrderStatus.DELIVERY_MAN_STARTED_DELIVERY:
                        self.lblStartDeliveryDate.text = orderStatusDetails.date
                        self.lblStartDeliveryTime.text = orderStatusDetails.date
                        self.btnCancelOrder.isHidden = true
                        self.isDeliverymanChatVisible = true
                        self.btnRateProvider.isHidden = true
                        self.btnPickUpImage.isHidden = false
                        break
                        
                    case OrderStatus.DELIVERY_MAN_ARRIVED_AT_DESTINATION:
                        self.lblDeliveryCompleteDate.text = orderStatusDetails.date
                        self.lblDeliveryCompleteTime.text = orderStatusDetails.date
                        self.btnCancelOrder.isHidden = true
                        self.isDeliverymanChatVisible = true
                        self.btnRateProvider.isHidden = true
                        self.btnPickUpImage.isHidden = false
                        break
                        
                    case OrderStatus.DELIVERY_MAN_COMPLETE_DELIVERY:
                        self.lblDeliveryCompleteDate.text = orderStatusDetails.date
                        self.lblDeliveryCompleteTime.text = orderStatusDetails.date
                        self.btnCancelOrder.isHidden = true
                        self.isDeliverymanChatVisible = true
                        self.btnRateProvider.isHidden = false
                        self.btnViewInvoice.isHidden = false
                        self.btnPickUpImage.isHidden = false
                        
                    default :
                        break
                    }
                }
                if !self.pickupImageUrl.isEmpty() {
                    self.btnPickUpImage.isHidden = false
                } else {
                    self.btnPickUpImage.isHidden = true
                }
            }
        }
    }
    
    func updateStatusUI(isConfirmationCodeRequired:Bool, isUserWillPickupDelivery:Bool, isConfirmationCodeRequiredAtPickup:Bool) {
        btnGetCode.isHidden = !isConfirmationCodeRequired
        viewForOnTheWay.isHidden = isUserWillPickupDelivery
        viewForEstTime.isHidden = true
        lblEstDeliveryTime.isHidden = true
        btnGetPickupCode.isHidden = !isConfirmationCodeRequiredAtPickup
    }
    
    func wsCancelOrder(reason:String) {
        let dictParam: Dictionary<String,Any> =
        [PARAMS.USER_ID:preferenceHelper.getUserId(),
         PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken(),
         PARAMS.ORDER_ID:selectedOrder._id ?? "",
         PARAMS.ORDER_STATUS:OrderStatus.CANCELED_BY_USER.rawValue,
         PARAMS.CANCEL_REASON:reason
        ]
        
        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_CANCEL_ORDER, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            if (Parser.isSuccess(response: response)) {
                self.timerForOrderStatus?.invalidate()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    //MARK: - BUTOON ACTION METHODS
    @objc func tapOnPrepareOrder(sender:Any) {
        openViewDetailDialogue()
    }
    
    @objc func tapOnOrderOnTheWay(sender:Any) {
        let orderStatus:OrderStatus = OrderStatus(rawValue: ((self.orderStatusReponse.orderStatus > self.orderStatusReponse.deliveryStatus) ? self.orderStatusReponse.orderStatus: self.orderStatusReponse.deliveryStatus) ?? 0) ?? .Unknown
        
        
        switch (orderStatus) {
        case OrderStatus.DELIVERY_MAN_PICKED_ORDER,
            OrderStatus.DELIVERY_MAN_STARTED_DELIVERY,
            OrderStatus.DELIVERY_MAN_ARRIVED_AT_DESTINATION,
            OrderStatus.DELIVERY_MAN_COMPLETE_DELIVERY:
            self.openProviderTrackDialogue()
            break
            
        default:
            Utility.showToast(message: "MSG_ORDER_NOT_PICKUP_YET".localized)
        }
    }
    
    @objc func tapOnOrderCancel(sender:Any) {
        wsGetCancelReasonList()
    }
    
    @objc func tapOnGetCode(sender:Any) {
        openConfirmationDialog()
    }
    
    @objc func tapOnGetPickupCode(sender:Any) {
        openPickupConfirmationDialog()
    }
    @objc func tapOnViewInvoice(sender:Any) {
        openOrderInvoiceDialogue()
    }
    @objc func tapOnPickupImage(sender:Any)  {
        openPickupImageDialogue()
    }
    @objc func tapOnDeliveryDetail(sender:Any)  {
        openDeliveryDetail()
    }
    
    //MARK: USER DEFINE FUNCTION
    
    func resetTimer() {
        timerForOrderStatus?.invalidate()
        wsGetOrderStatus()
        timerForOrderStatus = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(wsGetOrderStatus), userInfo: nil, repeats: true)
    }
    
    func animateView() {
        viewForEstTime.setRound(withBorderColor: .black, andCornerRadious: 0, borderWidth: 1.0)
    }
    
    func wsGetOrderDetail() {
        
        let dictParam: Dictionary<String,Any> =
        [PARAMS.USER_ID:preferenceHelper.getUserId(),
         PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken(),
         PARAMS.ORDER_ID:selectedOrder._id ?? ""]
        Utility.showLoading()
        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_GET_ORDER_DETAIL, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            
            if error == nil {
                Parser.parseCurrentOrder(response, completion: { (result,order)   in
                    if result
                    {
                        currentBooking.selectedOrderId = order._id
                        currentBooking.selectedStoreId = order.store_id
                        self.selectedOrder = order
                        self.selectedOrder.cartDetail =  order.cartDetail
                        self.selectedOrder.unique_id = order.unique_id ?? 0
                        self.selectedOrder.order_status = order.order_status ?? 0
                        self.selectedOrder.image_urls = order.image_urls
                        if (self.selectedOrder.cartDetail?.orderDetails.isEmpty) ??  true && self.selectedOrder.delivery_type! != DeliveryType.courier {
                            self.btnOrderPrepared.isHidden = true
                        } else {
                            self.btnOrderPrepared.isHidden = false
                        }
                        if self.selectedOrder.delivery_type! == DeliveryType.courier {
                            if self.selectedOrder.image_urls.count > 0 || (self.selectedOrder.cartDetail?.orderDetails ?? []).count > 0 {
                                self.btnToPrepareOrder.isHidden = false
                            } else {
                                self.btnToPrepareOrder.isHidden = true
                            }
                            self.btnDeliveryDetail.isHidden = false
                        } else {
                            self.btnDeliveryDetail.isHidden = true
                        }
                        DispatchQueue.main.async {
                            self.title = "TXT_ORDER_NO".localized + String((self.orderStatusReponse.uniqueId) ?? 0)
                        }
                        self.resetTimer()
                    }
                    else {
                        Utility.hideLoading()
                        APPDELEGATE.goToMain()
                    }
                })
            }
            
        }
    }
    
    func wsGetCancelReasonList() {
        
        let dictParam: Dictionary<String,Any> =
        [PARAMS.USER_ID:preferenceHelper.getUserId(),
         PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken()]
        
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
            self?.openCancelOrderDialog(list: arrList)
        }
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> String {
        return " \(seconds / 3600) hr : \((seconds % 3600) / 60) min"
    }
    
    func checkForOrderStatus(orderStatusValue:Int) {
        let orderStatus:OrderStatus = OrderStatus(rawValue: orderStatusValue) ?? .Unknown
        
        switch (orderStatus) {
        case OrderStatus.WAITING_FOR_DELIVERY_MAN,OrderStatus.DELIVERY_MAN_REJECTED,OrderStatus.DELIVERY_MAN_CANCELLED,OrderStatus.NO_DELIVERY_MAN_FOUND:
            
            btnOrderAccepted.isSelected = true
            btnOrderPrepared.isSelected = false
            btnOrderOnTheWay.isSelected = false
            btnOrderOnDoorStep.isSelected = false
            break
            
        case OrderStatus.DELIVERY_MAN_ACCEPTED,OrderStatus.DELIVERY_MAN_COMING,OrderStatus.DELIVERY_MAN_ARRIVED:
            
            btnOrderAccepted.isSelected = true
            btnOrderPrepared.isSelected = false
            btnOrderOnTheWay.isSelected = false
            btnOrderOnDoorStep.isSelected = false
            break
            
        case OrderStatus.DELIVERY_MAN_PICKED_ORDER:
            
            btnOrderAccepted.isSelected = true
            btnOrderPrepared.isSelected = true
            btnOrderOnTheWay.isSelected = false
            btnOrderOnDoorStep.isSelected = false
            break
            
        case OrderStatus.DELIVERY_MAN_STARTED_DELIVERY:
            
            btnOrderAccepted.isSelected = true
            btnOrderPrepared.isSelected = true
            btnOrderOnTheWay.isSelected = true
            btnOrderOnDoorStep.isSelected = false
            break
            
        case OrderStatus.DELIVERY_MAN_ARRIVED_AT_DESTINATION:
            
            btnOrderAccepted.isSelected = true
            btnOrderPrepared.isSelected = true
            btnOrderOnTheWay.isSelected = true
            btnOrderOnDoorStep.isSelected = false
            break
            
        case OrderStatus.DELIVERY_MAN_COMPLETE_DELIVERY:
            btnOrderAccepted.isSelected = true
            btnOrderPrepared.isSelected = true
            btnOrderOnTheWay.isSelected = true
            btnOrderOnDoorStep.isSelected = true
            timerForOrderStatus?.invalidate()
            dialogForConfirmCode?.removeFromSuperview()
            dialogForPickupConfirmCode?.removeFromSuperview()
            if self.navigationController?.visibleViewController == self
            {
                return
                let mainView: UIStoryboard = UIStoryboard(name: "Order", bundle: nil)
                if let invoiceVC : HistoryInvoiceVC = mainView.instantiateViewController(withIdentifier: "HistoryInvoiceVC") as? HistoryInvoiceVC
                {
                    invoiceVC.strOrderID = selectedOrder._id ?? ""
                    invoiceVC.name =  self.orderStatusReponse.provider_detail?.name ?? ""
                    invoiceVC.imgurl = self.orderStatusReponse.providerImage
                    
                    return
                }
            }
            return
        case .WAITING_FOR_ACCEPT_STORE,.STORE_ACCEPTED,.STORE_PREPARING_ORDER,.ORDER_READY,.CANCELED_BY_USER,.STORE_CANCELLED,.STORE_CANCELLED_REQUEST,.STORE_REJECTED,.CUSTOMER_ARRIVED,.Unknown:
            break
            
        }
        
        if (orderStatus == OrderStatus
                .DELIVERY_MAN_PICKED_ORDER || orderStatus == OrderStatus
                .DELIVERY_MAN_STARTED_DELIVERY || orderStatus == OrderStatus
                .DELIVERY_MAN_ARRIVED_AT_DESTINATION || orderStatus == OrderStatus
                .DELIVERY_MAN_COMPLETE_DELIVERY) {
            
            self.viewForEstTime.text = self.secondsToHoursMinutesSeconds(seconds: Int( (self.orderStatusReponse.estimatedTimeForDeliveryInMin * 60)))
        }else {
            self.viewForEstTime.text = self.secondsToHoursMinutesSeconds(seconds: Int((self.orderStatusReponse.totalTime * 60) + (self.orderStatusReponse.estimatedTimeForDeliveryInMin * 60)))
            
        }
    }
    
    func openViewDetailDialogue()  {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CourierDetailVC") as! CourierDetailVC
        let nav = UINavigationController.init(rootViewController: vc)
        vc.selectedOrder = selectedOrder
        nav.setNavigationBarHidden(true, animated: false)
        nav.modalPresentationStyle = .overCurrentContext
        self.present(nav, animated: false, completion: nil)
    }
    
    func openPickupImageDialogue()  {
        let _ = CustomDialogViewImage.showCustomDialogViewImage(title: "TXT_PICKUP_IMAGE".localized, message: "", imgUrlToView:  self.pickupImageUrl)
    }
     
    func openDeliveryDetail()  {
        let _ = CustomDialogViewDeliveryDetails.showCustomDialogDeliveryDetail(title: "TXT_DELIVERY_DETAILS".localizedCapitalized, message: "", selectedOrder: selectedOrder, order: nil, responce: orderStatusReponse, isFromHistory: false)
    }
    
    func openFeedbackDialogue(isRateProvider:Bool)  {
        var name = ""
        let providerName = self.orderStatusReponse.provider_detail?.name ?? ""
        let storeName = selectedOrder.store_name
        name =  ((isRateProvider) ? providerName : storeName) ?? ""
        
        dialogForFeedback = DailogForFeedback.showCustomFeedbackDialog(isRateProvider, false, selectedOrder._id!, name: name)
        
        
        dialogForFeedback?.onClickApplyButton = {
            (rating) in
            if isRateProvider {
                self.btnRateProvider.setTitle(rating, for: .normal)
                self.btnRateProvider.setImage(UIImage(named: "star_give_rate")?.imageWithColor(color: UIColor.themeColor), for: .normal)
                self.btnRateProvider.isUserInteractionEnabled = false
                let buttonIndent =  (LocalizeLanguage.isRTL) ? UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 8.0) : UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 0.0)
                self.btnRateProvider.titleEdgeInsets = buttonIndent
                self.btnRateProvider.tintColor = UIColor.themeColor
            }
            self.dialogForFeedback?.removeFromSuperview()
        }
        
    }
    
    // MARK:- Dialogs
    func openConfirmationDialog() {
        
        
        dialogForConfirmCode = CustomAlertDialog.showCustomAlertDialog(title: "TXT_CONFIRMATION_CODE".localized, message: String(self.orderStatusReponse.confirmationCodeForCompleteDelivery!) , titleLeftButton: "TXT_CANCEL".localizedCapitalized, titleRightButton: "TXT_SHARE".localizedCapitalized)
        dialogForConfirmCode?.onClickLeftButton = { [unowned self] in
            
            self.dialogForConfirmCode?.removeFromSuperview()
        }
        dialogForConfirmCode?.onClickRightButton = { [unowned self] in
            let myString = String(format: NSLocalizedString("SHARE_CONFIRM_CODE", comment: ""),String(self.orderStatusReponse.confirmationCodeForCompleteDelivery))
            let textToShare = [ myString ]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
            self.present(activityViewController, animated: true, completion: nil)
            self.dialogForConfirmCode?.removeFromSuperview()
        }
    }
    
    func openPickupConfirmationDialog() {
        
        
        dialogForPickupConfirmCode = CustomAlertDialog.showCustomAlertDialog(title: "TXT_CONFIRMATION_CODE".localized, message: String(self.orderStatusReponse.confirmationCodeForPickUpDelivery!) , titleLeftButton: "TXT_CANCEL".localizedCapitalized, titleRightButton: "TXT_SHARE".localizedCapitalized)
        dialogForPickupConfirmCode?.onClickLeftButton = { [unowned self] in
            
            self.dialogForPickupConfirmCode?.removeFromSuperview()
        }
        dialogForPickupConfirmCode?.onClickRightButton = { [unowned self] in
            
            
            let myString = String(format: NSLocalizedString("SHARE_CONFIRM_CODE", comment: ""),String(self.orderStatusReponse.confirmationCodeForPickUpDelivery))
            
            
            let textToShare = [ myString ]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
            self.present(activityViewController, animated: true, completion: nil)
            self.dialogForPickupConfirmCode?.removeFromSuperview()
        }
    }
    
    func openCancelOrderDialog(list: [String]) {
        var cancellationCharge:String = ""
        if orderStatusReponse.orderCancellationCharge > 0.0 {
            cancellationCharge = orderStatusReponse.currency + " " + (orderStatusReponse.orderCancellationCharge).toString()
        } else {
            cancellationCharge = ""
        }
        
        dialogForCancelOrder = CustomCancelOrderDialog.showCustomCancelOrderDialog(title: "TXT_CANCEL_ORDER".localized, message: "", cancelationCharge: cancellationCharge, titleLeftButton: "TXT_CANCEL".localizedCapitalized, titleRightButton: "TXT_OK".localizedCapitalized, list: list)
                
        dialogForCancelOrder?.onClickLeftButton =
        {
            [unowned self] in
            
            self.dialogForCancelOrder?.removeFromSuperview()
        }
        dialogForCancelOrder?.onClickRightButton = {
            [unowned self] (cancelReason:String) in
            
            self.wsCancelOrder(reason: cancelReason)
            self.dialogForCancelOrder?.removeFromSuperview()
            
        }
    }
    func openProviderTrackDialogue()  {
        let mainView: UIStoryboard = UIStoryboard(name: "Order", bundle: nil)
        let vc = mainView.instantiateViewController(withIdentifier: "ProviderTrack") as! ProviderTrack
        let nav = UINavigationController.init(rootViewController: vc)
        nav.setNavigationBarHidden(true, animated: false)
        nav.modalPresentationStyle = .overCurrentContext
        vc.selectedOrderStatus = self.orderStatusReponse
        self.present(nav, animated: false, completion: nil)
    }
    func openChatDialog() {
        let dialogForChat  = DialogForChatVC.showCustomChatDialog(DeliverymanChatVisible: isDeliverymanChatVisible, storeChatVisible: true)
        
        dialogForChat.onClickDeliverymanButton = { [unowned dialogForChat] in
            dialogForChat.removeFromSuperview();
            MessageHandler.ReceiverID = self.orderStatusReponse.providerId
            print(MessageHandler.ReceiverID)
            self.chatNavTitle = "\(self.orderStatusReponse.provider_detail?.name ?? "")"
            self.pushChatVC(ind: CONSTANT.CHATTYPES.USER_AND_PROVIDER)
            
        }
        dialogForChat.onClickAdminButton = { [unowned dialogForChat] in
            dialogForChat.removeFromSuperview();
            MessageHandler.ReceiverID = "000000000000000000000000"
            print(MessageHandler.ReceiverID)
            self.chatNavTitle = "Admin"
            self.pushChatVC(ind: CONSTANT.CHATTYPES.ADMIN_AND_USER)
        }
        
    }
    func openOrderInvoiceDialogue()  {
        let storyboard = UIStoryboard(name: "Order", bundle: nil)
        let invoiceVC = storyboard.instantiateViewController(withIdentifier: "HistoryInvoiceVC") as! HistoryInvoiceVC
        invoiceVC.modalPresentationStyle = .overCurrentContext
        invoiceVC.strOrderID = selectedOrder._id ?? ""
        invoiceVC.name =  self.orderStatusReponse.provider_detail?.name ?? ""
        invoiceVC.imgurl = self.orderStatusReponse.providerImage
        invoiceVC.isFromHistory = false
        
        self.present(invoiceVC, animated: false, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier?.compare(SEGUE.ORDER_STATUS_TO_COURIER_DETAIL) == ComparisonResult.orderedSame) {
            let prepareOrder = segue.destination as! CourierDetailVC
            prepareOrder.selectedOrder = selectedOrder
            
        }
    }
    
}
