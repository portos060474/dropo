//
//  ShareVC.swift
//  edelivery
//
//  Created by Elluminati on 14/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class OtherDetailVC: BaseVC {
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var stkForDeliveryUser: UIStackView!
    @IBOutlet weak var stkForOnTheWayDate: UIStackView!
    /*View For Store Detial*/
    @IBOutlet weak var viewForOrderDetail: UIView!
    @IBOutlet weak var viewForStoreDetail: UIView!
    @IBOutlet weak var lblStoreDetail: UILabel!
    @IBOutlet weak var lblStatusDetail: UILabel!
    @IBOutlet weak var lblStoreName: UILabel!
    @IBOutlet weak var imgStorePic: UIImageView!
    @IBOutlet weak var viewForStoreRate: UIView!
    @IBOutlet weak var lblReceiveUser: UILabel!
    @IBOutlet weak var lblReceiveUserName: UILabel!
    /*View For Provider Detail*/
    @IBOutlet weak var viewForProviderRate: UIView!
    @IBOutlet weak var btnRateProvider: UIButton!
    @IBOutlet weak var viewForDeliveryDetail: UIView!
    @IBOutlet weak var lblProviderDetail: UILabel!
    @IBOutlet weak var lblProviderName: UILabel!
    @IBOutlet weak var imgProviderPic: UIImageView!
    @IBOutlet weak var lblSourceAddress: UILabel!
    @IBOutlet weak var lblDestinationAddress: UILabel!
    @IBOutlet weak var lblEstTime: UILabel!
    @IBOutlet weak var lblEstTimeValue: UILabel!
    @IBOutlet weak var lblEstDistance: UILabel!
    @IBOutlet weak var lblEstDistanceValue: UILabel!
    @IBOutlet weak var btnRateStore: UIButton!
    @IBOutlet weak var viewForOrderStatus: UIView!
    @IBOutlet weak var btnOrderAccepted: UIButton!
    @IBOutlet weak var btnOrderPrepared: UIButton!
    @IBOutlet weak var btnOrderOnTheWay: UIButton!
    @IBOutlet weak var btnOrderOnDoorStep: UIButton!
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
    @IBOutlet weak var btnCompleteImage: UIButton!
    @IBOutlet weak var btnPickupImage: UIButton!
    @IBOutlet weak var lblDeliveryCompleteDate: UILabel!
    @IBOutlet weak var lblDeliveryCompleteTime: UILabel!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var imgContactLess: UIImageView!
    @IBOutlet weak var btnToPrepareOrder: UIButton!
    @IBOutlet weak var btnTrackOrder: UIButton!
    @IBOutlet weak var btnViewInvoice: UIButton!
    @IBOutlet weak var btnCloseImage: UIButton!
    @IBOutlet weak var stkVWTableBooking: UIStackView!
    @IBOutlet weak var imgTableBooking: UIImageView!
    @IBOutlet weak var lblTableBooking: UILabel!
    @IBOutlet weak var heightForStoreView: NSLayoutConstraint!
    @IBOutlet weak var btnDeliveryDetails: UIButton!
    
    public var strOrderID: String = ""
    public var isRateToProvider:Bool = false
    var pickupImgUrl = ""
    var completeImgUrl = ""
    public var paymentType:String = ""
    var storeDetail:HistoryStoreDetail?
    var providerDetail:HistoryUserDetails?
    var orderDetail:HistoryOrderList?
    var selectedOrder:Order = Order.init()
    var orderPaymentDetail:OrderPayment = OrderPayment.init(dictionary: [:])!
    var orderStatusReponse:OrderStatusResponse = OrderStatusResponse.init(fromDictionary: [:])
    var arrForDeliveryDetails:[OrderDateWiseStatusDetails] = []
    var requestDetail: HistoryRequestDetail? = HistoryRequestDetail.init(dictionary: [:])
    var cartDetail: CartDetail? = CartDetail.init(fromDictionary: [:])
    var historyOrderResposnse:HistoryOrderDetailResponse? = nil
    var dialogForFeedback: DailogForFeedback? = nil
    var currency = ""
    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("OtherDetailVC Load")
        viewForDeliveryDetail.isHidden = true
        viewForOrderDetail.isHidden = true
        btnPickupImage.isHidden = true
        btnCompleteImage.isHidden = true
        btnDeliveryDetails.isHidden = true
        self.viewImage.isHidden = true
        self.heightForStoreView.constant = 70
        setLocalzation()
        setupLayout()
        
    }
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews(){
        btnPickupImage.setRound(withBorderColor: .clear, andCornerRadious: 3.0, borderWidth: 1.0)
        btnCompleteImage.setRound(withBorderColor: .clear, andCornerRadious: 3.0, borderWidth: 1.0)
        imgContactLess.setRound(withBorderColor: .clear, andCornerRadious: 3.0, borderWidth: 1.0)
        super.viewDidLayoutSubviews()
        
    }
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(_ animated: Bool){
        super.viewDidDisappear(animated)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: Set localize d layout
    func setLocalzation() {
        
        //COLORS
        view.backgroundColor = UIColor.themeViewBackgroundColor
        lblReceiveUser.textColor = UIColor.themeTextColor
        lblReceiveUserName.textColor = UIColor.themeTextColor
        viewImage.backgroundColor = UIColor.themeOverlayColor
        lblStoreDetail.backgroundColor = UIColor.themeSectionBackgroundColor
        lblStatusDetail.backgroundColor = UIColor.themeSectionBackgroundColor
        lblProviderDetail.backgroundColor = UIColor.themeSectionBackgroundColor
        lblStoreDetail.textColor = UIColor.themeButtonTitleColor
        lblStatusDetail.textColor = UIColor.themeButtonTitleColor
        lblProviderDetail.textColor = UIColor.themeButtonTitleColor
        lblStoreName.textColor = UIColor.themeTextColor
        lblProviderName.textColor = UIColor.themeTextColor
        lblSourceAddress.textColor = UIColor.themeTextColor
        lblDestinationAddress.textColor = UIColor.themeTextColor
        lblEstTime.textColor = UIColor.themeLightTextColor
        lblEstDistance.textColor = UIColor.themeLightTextColor
        lblEstTimeValue.textColor = UIColor.themeTextColor
        lblEstDistanceValue.textColor = UIColor.themeTextColor
        lblDate.textColor = UIColor.themeTextColor
        lblEstTime.text = "TXT_TIME".localized
        lblEstDistance.text = "TXT_DISTANCE".localized
        lblStoreDetail.text = "TXT_ORDER_DETAILS".localized.appending("     ")
        lblProviderDetail.text = "TXT_DELIVERY_DETAILS".localized.appending("     ")
        lblStatusDetail.text = "TXT_STATUS_DETAILS".localized.appending("     ")
        lblStoreDetail.sizeToFit()
        lblProviderDetail.sizeToFit()
        lblStatusDetail.sizeToFit()
        self.hideBackButtonTitle()
        /* Set Font */
        lblStoreDetail.font = FontHelper.labelRegular()
        lblStatusDetail.font = FontHelper.labelRegular()
        lblStoreName.font = FontHelper.textMedium()
        lblProviderName.font = FontHelper.textMedium()
        lblProviderDetail.font = FontHelper.labelRegular()
        lblDestinationAddress.font = FontHelper.labelRegular()
        lblEstTime.font = FontHelper.labelRegular()
        lblEstDistance.font = FontHelper.labelRegular()
        lblEstTimeValue.font = FontHelper.textRegular()
        lblEstDistanceValue.font = FontHelper.textRegular()
        lblDate.font = FontHelper.textMedium(size: FontHelper.large)
        lblReceiveUserName.font = FontHelper.textRegular()
        lblReceiveUser.font = FontHelper.textSmall()
        lblOrderAccepted.text = "TXT_ORDER_ACCEPTED".localized
        lblOrderPrepared.text = "TXT_ORDER_PREPARED".localized
        lblOrderTheWay.text = "TXT_ORDER_ON_THE_WAY".localized
        lblOrderOnDoorStep.text = "TXT_ORDER_ON_DOORSTEP".localized
        btnCompleteImage.setTitle("  "+"TXT_DELIVERY_IMAGE".localizedCapitalized + "  ", for: .normal)
        btnPickupImage.setTitle("  "+"TXT_PICKUP_IMAGE".localizedCapitalized + "  ", for: .normal)
        lblAcceptedDate.text = ""
        lblAcceptedTime.text = ""
        lblPreparedDate.text = ""
        lblPreparedTime.text = ""
        lblStartDeliveryDate.text = ""
        lblStartDeliveryTime.text = ""
        lblDeliveryCompleteDate.text = ""
        lblDeliveryCompleteTime.text = ""
        lblAcceptedDate.textColor = UIColor.themeTextColor
        lblAcceptedTime.textColor = UIColor.themeLightTextColor
        lblPreparedDate.textColor = UIColor.themeTextColor
        lblPreparedTime.textColor = UIColor.themeLightTextColor
        lblStartDeliveryDate.textColor = UIColor.themeTextColor
        lblStartDeliveryTime.textColor = UIColor.themeLightTextColor
        lblDeliveryCompleteDate.textColor = UIColor.themeTextColor
        lblDeliveryCompleteTime.textColor = UIColor.themeLightTextColor
        lblAcceptedDate.font = FontHelper.textRegular()
        lblAcceptedTime.font = FontHelper.textSmall(size: FontHelper.labelRegular)
        lblPreparedDate.font = FontHelper.textRegular()
        lblPreparedTime.font = FontHelper.textSmall(size: FontHelper.labelRegular)
        lblStartDeliveryDate.font = FontHelper.textRegular()
        lblStartDeliveryTime.font = FontHelper.textSmall(size: FontHelper.labelRegular)
        lblDeliveryCompleteDate.font = FontHelper.textRegular()
        lblDeliveryCompleteTime.font = FontHelper.textSmall(size: FontHelper.labelRegular)
        btnOrderAccepted.titleLabel?.font = FontHelper.textRegular()
        btnOrderPrepared.titleLabel?.font = FontHelper.textRegular()
        btnOrderOnTheWay.titleLabel?.font = FontHelper.textRegular()
        btnOrderOnDoorStep.titleLabel?.font = FontHelper.textRegular()
        btnPickupImage.titleLabel?.font = FontHelper.textRegular()
        btnCompleteImage.titleLabel?.font = FontHelper.textRegular()
        lblOrderAccepted.font = FontHelper.textRegular()
        lblOrderPrepared.font = FontHelper.textRegular()
        lblOrderTheWay.font = FontHelper.textRegular()
        lblOrderOnDoorStep.font = FontHelper.textRegular()
        
        /*Set color */
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        lblOrderAccepted.textColor = UIColor.themeTextColor
        lblOrderPrepared.textColor = UIColor.themeTextColor
        lblOrderTheWay.textColor = UIColor.themeTextColor
        lblOrderOnDoorStep.textColor = UIColor.themeTextColor
        btnCompleteImage.setTitleColor(UIColor.themeColor, for: .normal)
        btnPickupImage.setTitleColor(UIColor.themeColor, for: .normal)
        btnOrderAccepted.setBackgroundColor(color: UIColor.themeStatusTickColor, forState: .normal)
        btnOrderPrepared.setBackgroundColor(color: UIColor.themeStatusTickColor, forState: .normal)
        btnOrderOnTheWay.setBackgroundColor(color: UIColor.themeStatusTickColor, forState: .normal)
        btnOrderOnDoorStep.setBackgroundColor(color: UIColor.themeStatusTickColor, forState: .normal)
        btnOrderAccepted.setBackgroundColor(color: UIColor.themeTextColor, forState: .selected)
        btnOrderPrepared.setBackgroundColor(color: UIColor.themeTextColor, forState: .selected)
        btnOrderOnTheWay.setBackgroundColor(color: UIColor.themeTextColor, forState: .selected)
        btnOrderOnDoorStep.setBackgroundColor(color: UIColor.themeTextColor, forState: .selected)
        btnOrderAccepted.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnOrderPrepared.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnOrderOnTheWay.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnOrderOnDoorStep.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnOrderAccepted.setTitleColor(UIColor.themeViewBackgroundColor, for: .selected)
        btnOrderPrepared.setTitleColor(UIColor.themeViewBackgroundColor, for: .selected)
        btnOrderOnTheWay.setTitleColor(UIColor.themeViewBackgroundColor, for: .selected)
        btnOrderOnDoorStep.setTitleColor(UIColor.themeViewBackgroundColor, for: .selected)
        btnOrderAccepted.isSelected = false
        btnOrderPrepared.isSelected = false
        btnOrderOnTheWay.isSelected = false
        btnOrderOnDoorStep.isSelected = false
        btnOrderAccepted.setTitle("TXT_1".localized, for: .normal)
        btnOrderPrepared.setTitle("TXT_2".localized, for: .normal)
        btnOrderOnTheWay.setTitle("TXT_3".localized, for: .normal)
        btnOrderOnDoorStep.setTitle("TXT_4".localized, for: .normal)
        btnToPrepareOrder.setTitle("  " + "TXT_VIEW_ORDER_DETAIL".localizedCapitalized + "  ", for: .normal)
        btnTrackOrder.setTitle("  " + "TXT_VIEW_DELIVERYMAN".localizedCapitalized + "  ", for: .normal)
        btnViewInvoice.setTitle( "  " + "TXT_VIEW_INVOICE".localizedCapitalized + "  ", for: .normal)
        btnDeliveryDetails.setTitle( "  " + "TXT_DELIVERY_DETAILS".localizedCapitalized + "  ", for: .normal)
        btnToPrepareOrder.backgroundColor = UIColor.themeViewBackgroundColor
        btnViewInvoice.backgroundColor = UIColor.themeViewBackgroundColor
        btnDeliveryDetails.backgroundColor = UIColor.themeViewBackgroundColor
        btnTrackOrder.backgroundColor = UIColor.themeViewBackgroundColor
        btnViewInvoice.setTitleColor(UIColor.themeColor, for: .normal)
        btnDeliveryDetails.setTitleColor(UIColor.themeColor, for: .normal)
        btnToPrepareOrder.setTitleColor(UIColor.themeColor, for: .normal)
        btnTrackOrder.setTitleColor(UIColor.themeColor, for: .normal)
        btnToPrepareOrder.addTarget(self, action: #selector(self.tapOnPrepareOrder(sender:)), for: .touchUpInside)
        btnTrackOrder.addTarget(self, action: #selector(self.tapOnOrderOnTheWay(sender:)), for: .touchUpInside)
        btnViewInvoice.addTarget(self, action: #selector(self.tapOnViewInvoice(sender:)), for: .touchUpInside)
        btnDeliveryDetails.addTarget(self, action: #selector(self.tapOnDeliveryDetails(sender:)), for: .touchUpInside)
        btnRateProvider.setTitle("TXT_RATE_US".localized, for: .normal)
        btnRateProvider.setTitleColor(UIColor.themeColor, for: .normal)
        btnRateProvider.titleLabel?.font = FontHelper.textRegular(size: FontHelper.regular)
        btnRateStore.setTitle("TXT_RATE_US".localized, for: .normal)
        btnRateStore.setTitleColor(UIColor.themeColor, for: .normal)
        btnRateStore.titleLabel?.font = FontHelper.textRegular(size: FontHelper.regular)
        btnRateStore.isHidden = true
        btnCloseImage.setTitle("TXT_CLOSE".localized, for: .normal)
        btnCloseImage.setTitleColor(.themeViewBackgroundColor, for: .normal)
        btnCloseImage.setBackgroundColor(color: .themeTitleColor, forState: .normal)
        
    }
    func setupLayout() {
        lblProviderDetail.sectionRound(lblProviderDetail)
        lblStoreDetail.sectionRound(lblStoreDetail)
        lblStatusDetail.sectionRound(lblStatusDetail)
        imgProviderPic.setRound()
        imgStorePic.setRound(withBorderColor: UIColor.clear, andCornerRadious: 8.0, borderWidth: 0.5)
        btnOrderAccepted.setRound()
        btnOrderPrepared.setRound()
        btnOrderOnTheWay.setRound()
        btnOrderOnDoorStep.setRound()
        btnCloseImage.setRound(withBorderColor: .clear, andCornerRadious: 8.0, borderWidth: 0.5)
    }
    override func updateUIAccordingToTheme() {
        self.setBackBarItem(isNative: false)
        
        btnOrderAccepted.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnOrderPrepared.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnOrderOnTheWay.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnOrderOnDoorStep.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnOrderAccepted.setTitleColor(UIColor.themeViewBackgroundColor, for: .selected)
        btnOrderPrepared.setTitleColor(UIColor.themeViewBackgroundColor, for: .selected)
        btnOrderOnTheWay.setTitleColor(UIColor.themeViewBackgroundColor, for: .selected)
        btnOrderOnDoorStep.setTitleColor(UIColor.themeViewBackgroundColor, for: .selected)
        btnToPrepareOrder.backgroundColor = UIColor.themeViewBackgroundColor
        btnViewInvoice.backgroundColor = UIColor.themeViewBackgroundColor
        btnDeliveryDetails.backgroundColor = UIColor.themeViewBackgroundColor
        btnTrackOrder.backgroundColor = UIColor.themeViewBackgroundColor
        btnCompleteImage.backgroundColor = UIColor.themeViewBackgroundColor
        btnPickupImage.backgroundColor = UIColor.themeViewBackgroundColor
        btnViewInvoice.setTitleColor(UIColor.themeColor, for: .normal)
        btnDeliveryDetails.setTitleColor(UIColor.themeColor, for: .normal)
        btnToPrepareOrder.setTitleColor(UIColor.themeColor, for: .normal)
        btnTrackOrder.setTitleColor(UIColor.themeColor, for: .normal)
        btnCompleteImage.setTitleColor(UIColor.themeColor, for: .normal)
        btnPickupImage.setTitleColor(UIColor.themeColor, for: .normal)
        btnOrderAccepted.setBackgroundColor(color: UIColor.themeStatusTickColor, forState: .normal)
        btnOrderPrepared.setBackgroundColor(color: UIColor.themeStatusTickColor, forState: .normal)
        btnOrderOnTheWay.setBackgroundColor(color: UIColor.themeStatusTickColor, forState: .normal)
        btnOrderOnDoorStep.setBackgroundColor(color: UIColor.themeStatusTickColor, forState: .normal)
        btnOrderAccepted.setBackgroundColor(color: UIColor.themeTextColor, forState: .selected)
        btnOrderPrepared.setBackgroundColor(color: UIColor.themeTextColor, forState: .selected)
        btnOrderOnTheWay.setBackgroundColor(color: UIColor.themeTextColor, forState: .selected)
        btnOrderOnDoorStep.setBackgroundColor(color: UIColor.themeTextColor, forState: .selected)
    }
    
    @IBAction func onClickRate(_ sender: UIButton) {
        if sender.tag == 0 {
            isRateToProvider = false
        }else {
            isRateToProvider = true
        }
        self.performSegue(withIdentifier: SEGUE.HISTORY_DETAIL_TO_FEEDBACK, sender: self)
        
    }
    
    @IBAction func closePressed(_ sender: UIButton) {
        viewImage.isHidden = true
    }
    @IBAction func pickupPressed(_ sender: UIButton) {
        openViewImageDialogue(link: pickupImgUrl, isPickupImage: true)
    }
    @IBAction func completeImagePressed(_ sender: UIButton) {
        openViewImageDialogue(link: completeImgUrl, isPickupImage: false)
    }
    func openViewImageDialogue(link:String, isPickupImage:Bool) {
        let strTitle = isPickupImage ? "TXT_PICKUP_IMAGE".localized : "TXT_DELIVERY_IMAGE".localized
        let  dialogForViewImage = CustomDialogViewImage.showCustomDialogViewImage(title: strTitle, message: "", imgUrlToView:  link)
    }
    @objc func rateToProvider() {
        
        isRateToProvider = true
        openFeedbackDialogue(isRateProvider: isRateToProvider)
        
    }
    @objc func rateToStore() {
        isRateToProvider = false
        openFeedbackDialogue(isRateProvider: isRateToProvider)
        
    }
    
    func setStatuDetail() {
        
        var isShowDetails :Bool = false
        let orderStatus = ((self.orderStatusReponse.orderStatus > self.orderStatusReponse.deliveryStatus) ? self.orderStatusReponse.orderStatus: self.orderStatusReponse.deliveryStatus) ?? 0
        self.checkForOrderStatus(orderStatusValue: orderStatus)
        self.arrForDeliveryDetails.removeAll()
        for details in self.orderStatusReponse.orderStatusDetails {
            
            let orderStatusDetail:OrderDateWiseStatusDetails = OrderDateWiseStatusDetails.init(fromDictionary: [:])
            orderStatusDetail.date = Utility.relativeDateStringForDate(strDate: Utility.stringToString(strDate: details.date, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_FORMAT, locale: "en_GB")) as String
            orderStatusDetail.time = Utility.stringToString(strDate:details.date, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.TIME_FORMAT_AM_PM)
            orderStatusDetail.status = details.status
            orderStatusDetail.imageUrl = details.imageUrl
            self.arrForDeliveryDetails.append(orderStatusDetail)
            
            
        }
        
        for details in self.orderStatusReponse.deliveryStatusDetails {
            let orderStatusDetail:OrderDateWiseStatusDetails = OrderDateWiseStatusDetails.init(fromDictionary: [:])
            orderStatusDetail.date = Utility.relativeDateStringForDate(strDate: Utility.stringToString(strDate: details.date, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_FORMAT, locale: "en_GB")) as String
            orderStatusDetail.time = Utility.stringToString(strDate:details.date, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.TIME_FORMAT_AM_PM)
            orderStatusDetail.status = details.status
            orderStatusDetail.imageUrl = details.imageUrl
            self.arrForDeliveryDetails.append(orderStatusDetail)
        }
        
        
        for details1 in self.orderStatusReponse.deliveryStatusDetails {
            if details1.status == 3{
                isShowDetails = true
                break
            }else{
                isShowDetails = false
            }
        }
        
        for orderStatusDetails in self.arrForDeliveryDetails {
            let orderStatus =  OrderStatus.init(rawValue: orderStatusDetails.status) ?? OrderStatus.Unknown
            switch (orderStatus)
            {
            case OrderStatus.STORE_ACCEPTED:
                self.lblAcceptedTime.text = orderStatusDetails.date
                break
            case OrderStatus.ORDER_READY:
                self.lblPreparedTime.text = orderStatusDetails.date
                break
            case OrderStatus.CUSTOMER_ARRIVED:
                self.lblPreparedTime.text = orderStatusDetails.date
                break
            case OrderStatus.DELIVERY_MAN_PICKED_ORDER:
                self.pickupImgUrl = orderStatusDetails.imageUrl
                self.btnPickupImage.isHidden = self.pickupImgUrl.isEmpty
                break
            case OrderStatus.DELIVERY_MAN_STARTED_DELIVERY:
                self.lblStartDeliveryTime.text = orderStatusDetails.date
                break
            case OrderStatus.DELIVERY_MAN_ARRIVED_AT_DESTINATION:
                self.lblDeliveryCompleteTime.text = orderStatusDetails.date
                self.completeImgUrl = orderStatusDetails.imageUrl
                self.btnCompleteImage.isHidden = self.completeImgUrl.isEmpty
                break
            case OrderStatus.DELIVERY_MAN_COMPLETE_DELIVERY:
                self.lblDeliveryCompleteTime.text = orderStatusDetails.date
                break
            default :
                break
            }
        }
      
        if isShowDetails{
            viewForOrderStatus.isHidden = false
        }else{
            viewForOrderStatus.isHidden = true
        }
        viewForOrderStatus.isHidden = false
        let onTheWayTitle = orderPaymentDetail.isUserPickupOrder ? ("TXT_3".localized) : ("TXT_4".localized)
        btnOrderOnDoorStep.setTitle(onTheWayTitle, for: .normal)

        if self.orderDetail?.deliveryType == DeliveryType.tableBooking {
            self.updateTableBookingStatusUI()
        }
        
        if self.orderDetail?.is_schedule_order == true {
            self.updateScheduleStatusUI()
        }

    }

    func updateTableBookingStatusUI() {
        
        if self.stkVWTableBooking.isHidden{
            self.imgTableBooking.image = self.imgTableBooking.image?.imageWithColor(color: .themeTextColor)
            self.stkVWTableBooking.isHidden = false
            self.heightForStoreView.constant = 120
            self.lblTableBooking.text = String(format: "MSG_TABLE_BOOK".localized, self.cartDetail!.table_no,self.cartDetail!.no_of_persons)
        }
        viewForOnTheWay.isHidden = true
        btnOrderOnDoorStep.setTitle("TXT_3".localized, for: .normal)
        self.lblOrderOnDoorStep.text = "txt_order_completed".localized
        self.lblOrderPrepared.text = "txt_customer_arrived".localized
    }

    func updateScheduleStatusUI() {
        if self.stkVWTableBooking.isHidden {
            self.imgTableBooking.image = UIImage(named:"schedule_gray_icon")?.imageWithColor(color: UIColor.themeTextColor)
            self.stkVWTableBooking.isHidden = false
            self.heightForStoreView.constant = 120
            self.lblTableBooking.text = "TXT_SCHEDULED_ORDER".localized
        }
    }

    func checkForOrderStatus(orderStatusValue:Int) {
        let orderStatus:OrderStatus = OrderStatus(rawValue: orderStatusValue) ?? .Unknown
        if orderPaymentDetail.isUserPickupOrder{
            self.lblOrderTheWay.isHidden = true
            self.btnOrderOnTheWay.isHidden = true
            self.viewForOnTheWay.isHidden = true
            self.stkForOnTheWayDate.isHidden = true
        } else {
            self.lblOrderTheWay.isHidden = false
            self.btnOrderOnTheWay.isHidden = false
            self.viewForOnTheWay.isHidden = false
            self.stkForOnTheWayDate.isHidden = false
        }
        switch (orderStatus) {
        case OrderStatus.WAITING_FOR_ACCEPT_STORE:
            btnOrderAccepted.isSelected  = false
            btnViewInvoice.isHidden = true
            
        case OrderStatus.STORE_PREPARING_ORDER:
            btnOrderAccepted.isSelected = true
            btnOrderPrepared.isSelected = false
            btnViewInvoice.isHidden = true
            break
            
        case OrderStatus.STORE_ACCEPTED:
            btnOrderAccepted.isSelected = true
            btnOrderPrepared.isSelected = false
            btnViewInvoice.isHidden = true
            break
            
        case OrderStatus.ORDER_READY,
             OrderStatus.DELIVERY_MAN_ACCEPTED,
             OrderStatus.DELIVERY_MAN_COMING,
             OrderStatus.DELIVERY_MAN_REJECTED,
             OrderStatus.DELIVERY_MAN_ARRIVED,
             OrderStatus.DELIVERY_MAN_PICKED_ORDER,
             OrderStatus.WAITING_FOR_DELIVERY_MAN,
             OrderStatus.STORE_CANCELLED_REQUEST,
             OrderStatus.NO_DELIVERY_MAN_FOUND:
            
            btnOrderAccepted.isSelected = true
            btnOrderPrepared.isSelected = true
            btnOrderOnTheWay.isSelected = false
            btnViewInvoice.isHidden = true
            
            btnToPrepareOrder.setTitleColor(UIColor.themeColor, for: .normal)
            btnTrackOrder.setTitleColor(UIColor.themeTextColor, for: .normal)
            btnViewInvoice.setTitleColor(UIColor.themeTextColor, for: .normal)
            
            break
        case OrderStatus.DELIVERY_MAN_STARTED_DELIVERY:
            
            btnOrderAccepted.isSelected = true
            btnOrderPrepared.isSelected = true
            btnOrderOnTheWay.isSelected = true
            btnOrderOnDoorStep.isSelected = false
            btnViewInvoice.isHidden = true
            btnToPrepareOrder.setTitleColor(UIColor.themeColor, for: .normal)
            btnTrackOrder.setTitleColor(UIColor.themeColor, for: .normal)
            btnViewInvoice.setTitleColor(UIColor.themeTextColor, for: .normal)
            
            break
        case OrderStatus.DELIVERY_MAN_ARRIVED_AT_DESTINATION,OrderStatus.DELIVERY_MAN_COMPLETE_DELIVERY:
            
            btnOrderAccepted.isSelected = true
            btnOrderPrepared.isSelected = true
            btnOrderOnTheWay.isSelected = true
            btnOrderOnDoorStep.isSelected = true
            btnViewInvoice.isHidden = false
            btnToPrepareOrder.setTitleColor(UIColor.themeColor, for: .normal)
            btnTrackOrder.setTitleColor(UIColor.themeColor, for: .normal)
            btnViewInvoice.setTitleColor(UIColor.themeColor, for: .normal)
            
            break
        case OrderStatus.STORE_REJECTED:
            btnViewInvoice.isHidden = true
            break
        case OrderStatus.STORE_CANCELLED:
            btnViewInvoice.isHidden = true
            break
        case OrderStatus.CANCELED_BY_USER:
            btnViewInvoice.isHidden = true
            break
        default:
            break
        }
    }
    func openImage(link:String) {
        viewImage.isHidden = false
        imgContactLess.downloadedFrom(link: link,mode: .scaleAspectFit)
    }
    func openViewDetailDialogue(isBtnCofirmPressed: Bool)  {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CartDetailVC") as! CartDetailVC
            vc.strCurrency = self.currency
            let nav = UINavigationController.init(rootViewController: vc)
            nav.setNavigationBarHidden(true, animated: false)
            nav.modalPresentationStyle = .overCurrentContext
            vc.historyDetailResponse = self.historyOrderResposnse
            self.present(nav, animated: false, completion: nil)
        }
    func openProviderTrackDialogue()  {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProviderTrack") as! ProviderTrack
            let nav = UINavigationController.init(rootViewController: vc)
            nav.setNavigationBarHidden(true, animated: false)
            nav.modalPresentationStyle = .overCurrentContext
            vc.providerId = self.requestDetail?.provider_detail?._id ?? ""
            vc.destinationAddress = (self.requestDetail?.destination_addresses.first as? Address)?.address ?? ""
            vc.isFromHistory = true
            vc.requestDetail = self.requestDetail
            vc.selectedOrderStatus = self.orderStatusReponse
            vc.historyOrderResposnse = self.historyOrderResposnse
            self.present(nav, animated: false, completion: nil)
        }
    func openOrderInvoiceDialogue()  {
        
        let invoiceVC = self.storyboard?.instantiateViewController(withIdentifier: "HistoryInvoiceVC") as! HistoryInvoiceVC
        invoiceVC.modalPresentationStyle = .overCurrentContext
        invoiceVC.orderPayment = self.orderPaymentDetail
        invoiceVC.paymentType = self.paymentType
        invoiceVC.isFromHistory = true
        invoiceVC.isTaxIncluded = self.cartDetail?.isTaxIncluded ?? false
        invoiceVC.strCurrency = self.currency
        if let providerFirstName:String = selectedOrder.provider_first_name {
            invoiceVC.name = providerFirstName + " " + (selectedOrder.provider_last_name ?? "")
            invoiceVC.imgurl = selectedOrder.provider_image ?? ""
        }
        self.present(invoiceVC, animated: false, completion: nil)
    }
    func openFeedbackDialogue(isRateProvider:Bool)  {
        var name = ""
        let providerName = (self.providerDetail?.first_name)! + " " +   (self.providerDetail?.last_name)!
        let storeName = (self.storeDetail?.name) ?? ""
        name =  ((isRateProvider) ? providerName : storeName)
        strOrderID = orderDetail?._id ?? ""
        dialogForFeedback = DailogForFeedback.showCustomFeedbackDialog(isRateProvider, false, strOrderID, name: name)
        dialogForFeedback?.onClickApplyButton = {
            (rating) in
            if isRateProvider {
                self.btnRateProvider.setTitle(rating, for: .normal)
                self.btnRateProvider.setImage(UIImage(named: "star_feedback")?.imageWithColor(color: UIColor.themeColor), for: .normal)
                self.btnRateProvider.isUserInteractionEnabled = false
                let buttonIndent =  (LocalizeLanguage.isRTL) ? UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 8.0) : UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 0.0)
                self.btnRateProvider.titleEdgeInsets = buttonIndent
            }
            else {
                self.btnRateStore.setTitle(rating, for: .normal)
                self.btnRateStore.setImage(UIImage(named: "star_feedback")?.imageWithColor(color: UIColor.themeColor), for: .normal)
                self.btnRateStore.isUserInteractionEnabled = false
                let buttonIndent =  (LocalizeLanguage.isRTL) ? UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 8.0) : UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 0.0)
                self.btnRateStore.titleEdgeInsets = buttonIndent
            }
            self.dialogForFeedback?.removeFromSuperview()
        }
    }
    
    //MARK: Get Histroy Detail
    func setOrderListDetail(data: HistoryOrderList, cartDetail: CartDetail) {
        lblSourceAddress.text = cartDetail.pickupAddresses[0].address
        lblDestinationAddress.text = cartDetail.destinationAddresses[0].address
        
        if (cartDetail.destinationAddresses[0].userDetails?.name?.isEmpty ?? false) {
            stkForDeliveryUser.isHidden = true
        }else {
            lblReceiveUserName.text = cartDetail.pickupAddresses[0].address
            stkForDeliveryUser.isHidden = false
        }
        let orderStatus:OrderStatus = OrderStatus(rawValue: data.order_status!) ?? .Unknown
        if !(orderStatus == OrderStatus.DELIVERY_MAN_COMPLETE_DELIVERY) {
            btnRateProvider.isHidden = true
        }
        else if data.is_user_rated_to_provider {
            let providerRate = String(format:"%.1f",data.user_rating_to_provider ?? 0)
            self.btnRateProvider.setTitle(providerRate, for: .normal)
            self.btnRateProvider.tintColor = .themeColor
            self.btnRateProvider.setImage(UIImage(named: "star_feedback")?.imageWithColor(color: UIColor.themeColor), for: .normal)
            self.btnRateProvider.isUserInteractionEnabled = false
            let buttonIndent =  (LocalizeLanguage.isRTL) ? UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 8.0) : UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 0.0)
            self.btnRateProvider.titleEdgeInsets = buttonIndent
            
        }else {
            self.btnRateProvider.titleEdgeInsets = UIEdgeInsets.zero
            
            self.btnRateProvider.imageEdgeInsets = UIEdgeInsets.zero
            self.btnRateProvider.setTitle("TXT_RATE_US".localized, for: .normal)
            if self.requestDetail?.provider_detail == nil{
                self.btnRateProvider.isHidden = true
            }else{
                self.btnRateProvider.isHidden = false
            }

            btnRateProvider.addTarget(self, action: #selector(rateToProvider), for: .touchUpInside)
            btnRateProvider.isUserInteractionEnabled = true
            
        }
        
        if cartDetail.deliveryType == DeliveryType.courier {
            lblReceiveUser.text = "TXT_RECEIVED_BY".localized
            btnDeliveryDetails.isHidden = false
        }else{
            btnDeliveryDetails.isHidden = true
            lblReceiveUser.text = "TXT_ORDER_RECEIVED_BY".localized
        }

        if (!(orderStatus == OrderStatus.DELIVERY_MAN_COMPLETE_DELIVERY) || cartDetail.deliveryType == DeliveryType.courier) {
            btnRateStore.isHidden = true
        }else {
            viewForStoreRate.isHidden = true
            btnRateStore.isHidden = false
            btnRateStore.addTarget(self, action: #selector(rateToStore), for: .touchUpInside)
            if  data.is_user_rated_to_store {
                let storeRate = String(format:"%.1f",data.user_rating_to_store ?? 0)
                
                self.btnRateStore.setTitle("\(storeRate)", for: .normal)
                self.btnRateStore.tintColor = .themeColor
                self.btnRateStore.setImage(UIImage(named: "star_feedback")?.imageWithColor(color: UIColor.themeColor), for: .normal)
                self.btnRateStore.isUserInteractionEnabled = false
                let buttonIndent =  (LocalizeLanguage.isRTL) ? UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 8.0) : UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 0.0)
                self.btnRateStore.titleEdgeInsets = buttonIndent
            }
            else {
                btnRateStore.setTitle("TXT_RATE_US".localized, for: .normal)
                btnRateStore.setTitleColor(UIColor.themeColor, for: .normal)
                self.btnRateStore.isUserInteractionEnabled = true
                self.btnRateStore.titleEdgeInsets = UIEdgeInsets.zero
                self.btnRateStore.imageEdgeInsets = UIEdgeInsets.zero
            }
        }
        
        lblDate.text = Utility.relativeDateStringForDate(strDate: Utility.stringToString(strDate: (data.created_at)!, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_FORMAT, locale: "en_GB")) as String
    
        viewForOrderDetail.isHidden = false
        
        if data.deliveryType == DeliveryType.courier {
            lblOrderAccepted.text = "TXT_ORDER_ACCEPTED".localized
            lblOrderPrepared.text = "TXT_PICKED_UP".localized
            lblOrderTheWay.text = "TXT_IN_TRANSIT".localized
            lblOrderOnDoorStep.text = "TXT_DELIVERED".localized
            btnTrackOrder.setTitle("  " + "TXT_TRACK_ORDER".localizedCapitalized + "  ", for: .normal)
            if data.image_url.count > 0 || !((self.cartDetail?.orderDetails ?? []).isEmpty) {
                btnToPrepareOrder.isHidden = false
            } else {
                btnToPrepareOrder.isHidden = true
            }
        } else {
            lblOrderAccepted.text = "TXT_ORDER_ACCEPTED".localized
            lblOrderPrepared.text = "TXT_ORDER_PREPARED".localized
            lblOrderTheWay.text = "TXT_ORDER_ON_THE_WAY".localized
            lblOrderOnDoorStep.text = "TXT_ORDER_ON_DOORSTEP".localized
        }
        
    }
    
    @objc func tapOnPrepareOrder(sender:UIButton) {
        if cartDetail?.deliveryType == DeliveryType.courier {
            openCourierDetail()
        } else {
            if (self.cartDetail?.orderDetails.isEmpty) ??  true {
                Utility.showToast(message: "MSG_ORDER_DETAIL_NOT_AVAILABLE".localized)
            }else {
                openViewDetailDialogue(isBtnCofirmPressed: self.orderStatusReponse.orderChange)
            }
        }
    }
    
    func openDeliveryDetail()  {
        let _ = CustomDialogViewDeliveryDetails.showCustomDialogDeliveryDetail(title: "TXT_DELIVERY_DETAILS".localizedCapitalized, message: "", selectedOrder: nil, order: historyOrderResposnse, responce: self.orderStatusReponse, isFromHistory: true)
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
    @objc func tapOnViewInvoice(sender:Any) {
        openOrderInvoiceDialogue()
    }
    @objc func tapOnDeliveryDetails(sender:Any) {
        openDeliveryDetail()
    }
    func openCourierDetail() {
        let vc = UIStoryboard(name: "Courier", bundle: nil).instantiateViewController(withIdentifier: "CourierDetailVC") as! CourierDetailVC
        let nav = UINavigationController.init(rootViewController: vc)
        vc.isFromHistory = true
        vc.orderList = historyOrderResposnse?.order_list ?? HistoryOrderList()
        vc.historyResponse = historyOrderResposnse
        nav.setNavigationBarHidden(true, animated: false)
        nav.modalPresentationStyle = .overCurrentContext
        self.present(nav, animated: false, completion: nil)
    }
    func setOrderPaymentDetail(data:OrderPayment) {
        lblEstTimeValue.text = "\(data.total_time ?? 0.00)" + "UNIT_MIN".localized
        if (data.is_distance_unit_mile) {
            lblEstDistanceValue.text = "\(data.total_distance ?? 0.00)" + "UNIT_MILE".localized
        }else {
            lblEstDistanceValue.text = "\(data.total_distance ?? 0.00)" + "UNIT_KM".localized
        }
    }
    
    func setStoreDetail(data:HistoryStoreDetail, cartDetail: CartDetail) {
        
        if cartDetail.deliveryType == DeliveryType.courier {
            lblStoreName.text = cartDetail.pickupAddresses[0].userDetails?.name ?? ""
        }else
        {
            lblStoreName.text = data.name ?? ""
            imgStorePic.downloadedFrom(link: (data.image_url) ?? "")
        }
    }
    
    func setProviderDetail(data:HistoryUserDetails) {
        
        if !data.first_name.isEmpty {
            lblProviderName.text = data.first_name + " " + data.last_name
            imgProviderPic.downloadedFrom(link: data.image_url)
        }
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier?.compare(SEGUE.HISTORY_DETAIL_TO_FEEDBACK) == ComparisonResult.orderedSame) {
            let feedbackVC = segue.destination as! FeedbackVC
            feedbackVC.isRateToProvider = self.isRateToProvider
            feedbackVC.isFromHistory = true
            if self.isRateToProvider {
                feedbackVC.name = (self.providerDetail?.first_name)! + " " +   (self.providerDetail?.last_name)!
                feedbackVC.imgurl = (self.providerDetail?.image_url) ?? ""
            }else {
                feedbackVC.name = (self.storeDetail?.name) ?? ""
                feedbackVC.imgurl = (self.storeDetail?.image_url) ?? ""
            }
        }
    }
}

