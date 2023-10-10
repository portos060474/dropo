//
//  AcceptedDeliveriesVC.swift
//  Edelivery Provider
//
//  Created by Elluminati iMac on 21/04/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces
import AVFoundation
//import StripeUICore


class CurrentDeliveryVC: BaseVC,RightDelegate {
  
    var player: AVAudioPlayer? // <-- notice here
    
    @IBOutlet weak var viewDetail: UIView!
    @IBOutlet weak var btnContactLess: UIButton!
    @IBOutlet weak var btnCart: UIButton!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblRequestNumber: UILabel!
    @IBOutlet weak var lblProviderInvoiceValue: UILabel!
    @IBOutlet weak var lblProviderIncome: UILabel!
    @IBOutlet weak var btnSetStatus: UIButton!
    @IBOutlet weak var btnNavigation: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblOrderNumber: UILabel!
    @IBOutlet weak var lblEstTime: UILabel!
    @IBOutlet weak var lblEstDistance: UILabel!
    @IBOutlet weak var lblEstTimeValue: UILabel!
    @IBOutlet weak var lblDistanceValue: UILabel!
    @IBOutlet weak var lblSecondCount: UILabel!
    @IBOutlet weak var viewForServiceType: UIView!
    @IBOutlet weak var stackViewForAcceptReject: UIStackView!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var btnReject: UIButton!
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var viewForProfit: UIView!
    @IBOutlet weak var btnChat: UIButton!
    @IBOutlet weak var viewForChat: UIView!
    @IBOutlet weak var viewForContactLess: UIView!
    @IBOutlet weak var viewForCall: UIView!
    @IBOutlet weak var viewForCart: UIView!
    @IBOutlet weak var lblChat: UILabel!
    @IBOutlet weak var lblContactLess: UILabel!
    @IBOutlet weak var lblCart: UILabel!
    @IBOutlet weak var lblCall: UILabel!
    @IBOutlet weak var imageForChat: UIImageView!
    @IBOutlet weak var imageForContactLess: UIImageView!
    @IBOutlet weak var imageForCall: UIImageView!
    @IBOutlet weak var imageForCart: UIImageView!
    @IBOutlet weak var imageForTime: UIImageView!
    @IBOutlet weak var imageForDistance: UIImageView!
    @IBOutlet weak var imageForEarning: UIImageView!
    @IBOutlet weak var btnCurrentLocation: UIButton!
    @IBOutlet weak var lblBringChange: UILabel!
    
    public var isActiveDelivery : Int = 0
    public var activeOrderData: ActiveOrder!
    public var newOrderData: NewOrder!
    
    var isStoreChatVisible = false
    var isDoAnimation:Bool = false
    var strMobileNumber:String = ""
    var arrForOrderStatus : NSMutableArray = NSMutableArray.init()
    var arrForUserDetails : NSMutableArray = NSMutableArray.init()
    var arrForInvoice : NSMutableArray = NSMutableArray.init()
    var arrForCart:[CartProduct] = []
    var strRquestID : String = String()
    var requestStatus : OrderStatus = OrderStatus.Unknown
    var dictRequestStatus = NSMutableDictionary();
    var orderStatusResponse: OrderStatusResponse = OrderStatusResponse(dictionary: [:]);
    var locationManager = LocationManager()
    /*Map Animation*/
    var isMapFocus:Bool = false
    var dialogForImage : CustomPhotoDialog?
    /*LatLongs*/
    var storeCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D.init()
    var userCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D.init()
    var providerCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D.init()
    var note = ""
    var pickupMessage = ""
    var deliveryMessage = ""
    var timerLeft : Int = 0
    var invoiceResponse:InvoiceResponse?;
    var btnRight: UIButton? = nil;
    var isAllowContactLessDelivery:Bool = false
    var is_allow_pickup_order_verification:Bool = false
    var isCouirer = false
    var userType = CONSTANT.TYPE_USER
    
    //MARKERS
    let userMarker:GMSMarker = GMSMarker.init()
    let storeMarker:GMSMarker = GMSMarker.init()
    let providerMarker:GMSMarker = GMSMarker.init()
    var cartDataSet:Bool = false
    var tripComplete = false
    var isOrderPick = false
    
    @IBOutlet weak var tblAddress: UITableView!
    @IBOutlet weak var heightAddress: NSLayoutConstraint!
    
    var arrAddress = [Address]()
    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpMarkers()
        self.setLocalization()
        //Set Right Button
        delegateRight = self
        btnRight = UIButton.init(type: .custom)
        btnRight?.setTitle("", for: UIControl.State.normal);
        btnRight?.setImage(UIImage.init(named: "cancelBlackIcon")?.imageWithColor(), for: UIControl.State.normal)
        btnRight?.tag = 0
        btnRight?.sizeToFit()
        //Set Fonts
        lblSecondCount.font = FontHelper.textLarge()
        lblName.font = FontHelper.textMedium()
        lblName.numberOfLines = 2
        lblName.adjustsFontSizeToFitWidth = false
        lblOrderNumber.font = FontHelper.textSmall()
        lblRequestNumber.font = FontHelper.textSmall()
        self.setUpSound()
        locationManager.autoUpdate = true
        Utility.showLoading()
        self.mapView.bringSubviewToFront(self.btnCurrentLocation);
        
        lblSecondCount.text = ""
        
        if let activeData = activeOrderData {
            lblBringChange.isHidden = !activeData.is_bring_change
        }
        lblBringChange.backgroundColor = UIColor.themeViewBackgroundColor
        lblBringChange.textColor = UIColor.themeRedColor
        lblBringChange.font = FontHelper.textRegular()
        lblBringChange.text = "txt_bring_change_with_you".localized
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isDoAnimation = false
        tblAddress.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.wsGetOrderStatus()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopAccetpRejectTimer()
        tblAddress.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        heightAddress.constant = tblAddress.contentSize.height
    }
    
    func setUpSound() {
        if preferenceHelper.getIsRequesetAlert() {
            let sound = Bundle.main.url(forResource: "beep", withExtension: "mp3")
            do {
                player = try AVAudioPlayer(contentsOf: sound!)
                guard player != nil else { return }
            }
            catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func playSound() {
        if preferenceHelper.getIsRequesetAlert() {
            player?.stop()
            player?.play()
        }
    }
    
    func openCancelOrderDialog(list: [String]) {
        let dialogForCancelOrder = CustomCancelOrderDialog.showCustomCancelOrderDialog(title: "TXT_CANCEL_DELIVERY".localized, message: "", list: list, titleRightButton: "TXT_CANCEL_NOW".localizedCapitalized)
        dialogForCancelOrder.onClickLeftButton = { [unowned dialogForCancelOrder] in
            dialogForCancelOrder.removeFromSuperview();
        }
        dialogForCancelOrder.onClickRightButton = {  [unowned dialogForCancelOrder, unowned self] (cancelReason:String) in
            self.wsCancelRejectOrder(status: OrderStatus.DELIVERY_MAN_CANCELLED, cancelReason: cancelReason)
            dialogForCancelOrder.removeFromSuperview();
        }
    }
    
    func openNoteDialog() {
        var dialogForNote:DailogForNote? = nil
        if isCouirer {
            dialogForNote = DailogForNote.showCustomAlertDialog(title: "TXT_COURIER_NOTE".localized, pickupMessage: self.pickupMessage, deliveryMessage: self.deliveryMessage)
        }
        else {
            dialogForNote = DailogForNote.showCustomAlertDialog(title: "TXT_NOTE".localized, pickupMessage: self.pickupMessage, deliveryMessage: self.deliveryMessage)
        }
        dialogForNote?.onClickLeftButton =
        { [unowned dialogForNote] in
            dialogForNote?.removeFromSuperview();
        }
       
    }
    
    func onClickRightButton() {
        if self.btnRight?.tag == 0 {
            wsGetCancelReasonList()
        }else if self.btnRight?.tag == 1{
            openNoteDialog()
        }
    }
 
    var chatNavTitle : String = ""
    func pushChatVC(ind:Int){
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "AvailableOrder", bundle: nil)
        if let vc : MyCustomChatVC = mainView.instantiateViewController(withIdentifier: "chatVC") as? MyCustomChatVC
        {
            MessageHandler.chatType = ind
            vc.navTitle = chatNavTitle
            MessageHandler.Order_ID = (self.orderStatusResponse.order?.order_id!)!
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
        
    @IBAction func onClickBtnChat(_ sender: AnyObject) {
       
        let dialogForChat  = DialogForChatVC.showCustomChatDialog(storeChatVisible: isCouirer ? true : isStoreChatVisible,userChatVisible: isOrderPick)
        dialogForChat.onClickUserButton = { [unowned dialogForChat] in
                dialogForChat.removeFromSuperview();
            MessageHandler.ReceiverID = self.orderStatusResponse.userDetails._id!
            print(MessageHandler.ReceiverID)
            self.chatNavTitle = "\(self.orderStatusResponse.userDetails.first_name ?? "") \(self.orderStatusResponse.userDetails.last_name ?? "")"
            self.pushChatVC(ind: CONSTANT.CHATTYPES.USER_AND_PROVIDER)
        }
        dialogForChat.onClickStoreButton = { [unowned dialogForChat] in
                dialogForChat.removeFromSuperview();
            MessageHandler.ReceiverID = (self.orderStatusResponse.order?.store_id!)!
            print(MessageHandler.ReceiverID)
            self.chatNavTitle = "\(self.orderStatusResponse.order?.store_name ?? "Store")"
            self.pushChatVC(ind: CONSTANT.CHATTYPES.PROVIDER_AND_STORE)
                
        }
        dialogForChat.onClickAdminButton = { [unowned dialogForChat] in
            dialogForChat.removeFromSuperview();
            MessageHandler.ReceiverID = "000000000000000000000000"
            print(MessageHandler.ReceiverID)
            self.chatNavTitle = "Admin"
            self.pushChatVC(ind: CONSTANT.CHATTYPES.ADMIN_AND_PROVIDER)
        }
    }
    
    override func updateUIAccordingToTheme() {
        self.setLocalization()
    }
    
    //MARK: - USER DEFINED FUNCTION
   
    //MARK: Set localized layout
    func setLocalization() {
        if isActiveDelivery == 1 {
            viewForServiceType.isHidden = false
            stackViewForAcceptReject.isHidden = true
            lblSecondCount.isHidden = true
            lblSecondCount.text = ""
            
            self.title = "TXT_ACTIVE_DELIVERY".localized
        }else {
            viewForServiceType.isHidden = true
            stackViewForAcceptReject.isHidden = false
            lblSecondCount.isHidden = false
            self.title = "TXT_ACCEPTED_DELIVERY".localized
        }
        
        imgProfilePic.applyRoundedCornersWithOutBorder()
        viewForProfit.isHidden = true
        
        // COLORS
        viewForServiceType.backgroundColor = UIColor.themeViewBackgroundColor
        lblDate.textColor = UIColor.themeTextColor
        lblSecondCount.backgroundColor = UIColor.themeViewBackgroundColor
        lblSecondCount.textColor = UIColor.themeRedColor
        btnSetStatus.backgroundColor = UIColor.themeButtonBackgroundColor
        lblDate.textAlignment = .left
        lblName.textColor = UIColor.themeTextColor
        lblOrderNumber.textColor = UIColor.themeLightTextColor
        lblRequestNumber.textColor = UIColor.themeTextColor
        lblSecondCount.backgroundColor = .themeViewBackgroundColor
        btnAccept.backgroundColor = UIColor.themeButtonBackgroundColor
        btnAccept.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        btnReject.backgroundColor = UIColor.themeButtonBackgroundColor
        btnReject.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        lblEstDistance.textColor = UIColor.themeLightTextColor
        lblDistanceValue.textColor = UIColor.themeTextColor
        lblEstTime.textColor = UIColor.themeLightTextColor
        lblEstTimeValue.textColor = UIColor.themeTextColor
        lblProviderIncome.textColor = UIColor.themeLightTextColor
        lblProviderInvoiceValue.textColor = UIColor.themeTextColor
        imageForCart.image = UIImage.init(named: "cart_icon")?.imageWithColor()
        imageForCall.image = UIImage.init(named: "callIcon")?.imageWithColor()
        imageForContactLess.image = UIImage.init(named: "cl_icon")?.imageWithColor()
        imageForTime.image = UIImage.init(named: "time_icon")?.imageWithColor(color: .themeIconTintColor)
        imageForDistance.image = UIImage.init(named: "distance_icon")?.imageWithColor(color: .themeIconTintColor)
        imageForEarning.image = UIImage.init(named: "amount_icon")?.imageWithColor(color: .themeIconTintColor)
        imageForChat.image = UIImage.init(named: "chat")?.imageWithColor()
        btnAccept.setTitle("TXT_ACCEPT".localized, for: UIControl.State.normal)
        btnReject.setTitle("TXT_REJECT".localized, for: UIControl.State.normal)
        lblEstTime.text = "TXT_EST_TIME".localized
        lblEstDistance.text = "TXT_EST_DISTANCE".localized
        lblProviderIncome.text = "TXT_PROFIT".localized
        lblProviderInvoiceValue.text = "TXT_DEFAULT".localized
        btnRight?.tintColor = .themeColor
        btnAccept.titleLabel?.font = FontHelper.textSmall()
        btnReject.titleLabel?.font = FontHelper.textSmall()
        lblDate.font = FontHelper.textSmall()
        lblProviderIncome.font = FontHelper.textSmall()
        lblProviderInvoiceValue.font = FontHelper.textSmall()
        lblEstDistance.font = FontHelper.textSmall()
        lblDistanceValue.font = FontHelper.textSmall()
        lblEstTime.font = FontHelper.textSmall()
        lblEstTimeValue.font = FontHelper.textSmall()
        self.view.backgroundColor = .themeViewBackgroundColor
        viewDetail.backgroundColor = .themeViewBackgroundColor
        mapView.setRound(withBorderColor: .clear, andCornerRadious: 10, borderWidth: 0.0)
        lblCart.text = "TXT_VIEW_CART".localized
        lblChat.text = "TXT_CHAT".localized
        lblContactLess.text = "TXT_CONTACT_LESS_DELIVERY".localized
        lblCart.textColor = .themeColor
        lblCall.textColor = .themeColor
        lblChat.textColor = .themeColor
        lblContactLess.textColor = .themeColor
        lblCart.font = FontHelper.textSmall(size: 12)
        lblCall.font = FontHelper.textSmall(size: 12)
        lblChat.font = FontHelper.textSmall(size: 12)
        lblContactLess.font = FontHelper.textSmall(size: 12)
        lblContactLess.numberOfLines = 2
        lblCart.numberOfLines = 1
        lblCall.numberOfLines = 1
        lblChat.numberOfLines = 1
        
        setTableView()
    }
    
    func setTableView() {
        tblAddress.delegate = self
        tblAddress.dataSource = self
        tblAddress.separatorColor = .clear
        tblAddress.rowHeight = UITableView.automaticDimension
        tblAddress.estimatedRowHeight = 40
        tblAddress.register(cellTypes: [AddressCell.self])
    }
   
    //MARK: Get Order Status
    func wsGetOrderStatus() {
        
        var dictParam:[String:String] = ["":""]
        
        if isActiveDelivery == 1 {
            dictParam = [PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken(),
                         PARAMS.PROVIDER_ID : preferenceHelper.getUserId(),
                         PARAMS.REQUEST_ID : activeOrderData._id!]
        }else{
            dictParam = [PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken(),
                         PARAMS.PROVIDER_ID : preferenceHelper.getUserId(),
                         PARAMS.REQUEST_ID : newOrderData._id!]
        }
        
        print(dictParam)
        
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_GET_ORDER_STATUS, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            
            Utility.hideLoading()
            
            Parser.parseOrderStatus(response, toOrdersStatus: self.dictRequestStatus, completion: { result in
                if result {
                    let orderStatus:OrderStatusResponse = OrderStatusResponse.init(dictionary: response)
                    self.isAllowContactLessDelivery = orderStatus.order?.isAllowContactlessDelivery ?? false
                    self.is_allow_pickup_order_verification = orderStatus.order?.is_allow_pickup_order_verification ?? false
                    self.orderStatusResponse = self.dictRequestStatus.value(forKey: CONSTANT.STATUS) as! OrderStatusResponse;
                    self.btnContactLess.isHidden = !self.isAllowContactLessDelivery
                    self.viewForContactLess.isHidden = !self.isAllowContactLessDelivery
                    self.getOrderStatus(orderData: self.orderStatusResponse )
                    if self.orderStatusResponse.order?.store_id == nil{
                        self.isStoreChatVisible = true
                    }else{
                        self.isStoreChatVisible = false
                    }
                }else {
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
    }
    
    func openImageDialog() {
        dialogForImage = CustomPhotoDialog.showPhotoDialog("TXT_SELECT_IMAGE".localized, andParent: self,isCameraOnly: true, isCrop: true)
        dialogForImage?.onImageSelected = { [unowned self, weak dialogForImage = self.dialogForImage] (image:UIImage) in
            self.wsChangeOrderStatus(status: self.requestStatus,image: image)
            dialogForImage?.removeFromSuperview()
        }
    }

    //MARK: Get Order Status
    func isOrderPicked(status:OrderStatus) -> Bool {
        switch (status) {
            
        case OrderStatus.NEW_DELIVERY:fallthrough
        case OrderStatus.DELIVERY_MAN_ACCEPTED:fallthrough
        case OrderStatus.DELIVERY_MAN_REJECTED:fallthrough
        case OrderStatus.DELIVERY_MAN_CANCELLED:fallthrough
        case OrderStatus.DELIVERY_MAN_COMING:fallthrough
        case OrderStatus.DELIVERY_MAN_ARRIVED:return false
        case OrderStatus.DELIVERY_MAN_PICKED_ORDER:fallthrough
        case OrderStatus.DELIVERY_MAN_STARTED_DELIVERY:fallthrough
        case OrderStatus.DELIVERY_MAN_ARRIVED_AT_DESTINATION:
            return true;
        default:
            return false
        }
    }
    
    func getOrderStatus(orderData: OrderStatusResponse) {
        
        fillAddress(orderData: orderData)
        
        let checkOrderStatus = OrderStatus(rawValue: (orderData.order?.order_status)!)

        if !cartDataSet {
            self.arrForCart.removeAll()
            self.arrForCart = (orderData.order?.orderDetails) ?? []
            if (orderData.order?.delivery_type)! == DeliveryType.courier {
                //btnCart.isHidden = ((orderData.order?.image_url) ?? []).isEmpty
                //viewForCart.isHidden = ((orderData.order?.image_url) ?? []).isEmpty
            
                if !((orderData.order?.image_url) ?? []).isEmpty || !arrForCart.isEmpty {
                    btnCart.isHidden = false
                    viewForCart.isHidden = false
                } else {
                    btnCart.isHidden = true
                    viewForCart.isHidden = true
                }
                
                lblCall.text = "TXT_CALL_USER".localized
            }else {
                btnCart.isHidden = arrForCart.isEmpty
                viewForCart.isHidden = arrForCart.isEmpty
            }
            cartDataSet = true
        }
        self.lblProviderInvoiceValue.text =  (orderData.order?.total_provider_income)!.toCurrencyString()
        
        if orderData.order?.delivery_type == DeliveryType.courier {
            lblCall.text = "TXT_CALL_USER".localized
            isCouirer = true
            setNoteForCorier(orderData: orderData)
        }else {
            isCouirer = false
            if (orderData.order?.destinationAddresses[0].note.isEmpty) ?? true {
                note = ""
            }else {
                note = orderData.order?.destinationAddresses[0].note ?? ""
                self.deliveryMessage = orderData.order?.destinationAddresses[0].note ?? ""
            }
        }
        
        if  isOrderPicked(status:checkOrderStatus!) {
            if orderData.order?.delivery_type == DeliveryType.courier {
                var stop = orderData.order?.arrived_at_stop_no ?? 0
                if stop == orderData.order?.destinationAddresses.count ?? 0 {
                    stop -= 1
                }
                if stop < orderData.order?.destinationAddresses.count ?? 0  {
                    lblName.text = orderData.order?.destinationAddresses[stop].userDetails.name
                } else {
                    lblName.text = orderData.order?.destinationAddresses.last?.userDetails.name ?? ""
                }
                
                imgProfilePic.image = UIImage.init(named: "placeholder")
                lblCall.text = "TXT_CALL_USER".localized
                
            }else {
                lblName.text = orderData.order?.destinationAddresses[0].userDetails.name
                imgProfilePic.downloadedFrom(link: (orderData.userDetails?.image_url)!)
            }
            
            //setDestinationAddress(address: orderData.order?.destinationAddresses[0] ?? Address.init(fromDictionary: [:]))
            //lblDestinationAddress.text = orderData.order?.destinationAddresses[0].address
            lblDate.isHidden = true
            userType = CONSTANT.TYPE_USER
            strMobileNumber = (orderData.order?.destinationAddresses[0].userDetails.countryPhoneCode)! + (orderData.order?.destinationAddresses[0].userDetails.phone)!
            lblCall.text = "TXT_CALL_USER".localized
       
        }else {
            if orderData.order!.delivery_type == DeliveryType.courier {
                lblName.text = orderData.order?.pickupAddresses[0].userDetails.name
                imgProfilePic.image = UIImage.init(named: "placeholder")
                lblCall.text = "TXT_CALL_USER".localized
            }else {
                lblName.text = orderData.order?.store_name
                imgProfilePic.downloadedFrom(link: (orderData.order?.store_image)!)
            }
            if (orderData.order?.estimated_time_for_ready_order.isEmpty)! {
                lblDate.isHidden = true
            }else {
                lblDate.isHidden = false
                let date:String =  Utility.stringToString(strDate: (orderData.order?.estimated_time_for_ready_order)!, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_TIME_FORMAT)
                lblDate.text = "TXT_PICKUP_ORDER_AT".localized + " - " + date
            }
            //setDestinationAddress(address: orderData.order?.destinationAddresses[0] ?? Address.init(fromDictionary: [:]))
            userType = CONSTANT.TYPE_STORE
            //lblDestinationAddress.text = orderData.order?.destinationAddresses[0].address
            strMobileNumber = (orderData.order?.pickupAddresses[0].userDetails.countryPhoneCode)! + (orderData.order?.pickupAddresses[0].userDetails.phone)!
            lblCall.text = "TXT_CALL_STORE".localized
        }
        
        lblOrderNumber.text = "TXT_ORDER_NO".localized + String(orderData.order?.orderUniqueId ?? 0)
        lblRequestNumber.text = "TXT_REQUEST_NO".localized + String(orderData.order?.unique_id ?? 0)
        lblEstTimeValue.text = String(format: "%.2f min",(orderData.order?.total_time!)!)
        lblDistanceValue.text = String(format: "%.2f km",(orderData.order?.total_distance!)!)
        
        if (orderData.is_distance_unit_mile ?? false) {
            lblDistanceValue.text = "\(orderData.order?.total_distance ?? 0.00)" +  "UNIT_MILE".localized
        } else {
            lblDistanceValue.text = "\(orderData.order?.total_distance ?? 0.00)" +  "UNIT_KM".localized
        }
        strRquestID = (orderData.order?._id!)!
        let destinationLocation = orderData.order?.destinationAddresses[0].location
        let sourceLocation = orderData.order?.pickupAddresses[0].location
        self.userCoordinate = CLLocationCoordinate2D(latitude: destinationLocation![0] , longitude: destinationLocation![1])
        self.storeCoordinate = CLLocationCoordinate2D(latitude: sourceLocation![0] , longitude: sourceLocation![1] )
        self.providerCoordinate = CLLocationCoordinate2D(latitude: CurrentOrder.shared.currentLatitude, longitude: CurrentOrder.shared.currentLongitude)
        mapView.clear()
        self.isMapFocus = true
        self.focusMapToShowAllMarkers(sourceLatLong: storeCoordinate, destinationLatLong: userCoordinate, currentLatLong: providerCoordinate)
        let status: OrderStatus = OrderStatus(rawValue: (orderData.order?.order_status!)!) ?? .Unknown;
        if (orderStatusResponse.order?.delivery_type)! == DeliveryType.courier {
            lblCall.text = "TXT_CALL_USER".localized
            btnChat.isHidden = false
            viewForChat.isHidden = false
        }
        else {
            btnChat.isHidden = false
            viewForChat.isHidden = false
        }
        
        lblSecondCount.text = ""
        
        switch (status) {
            
        case OrderStatus.NEW_DELIVERY:
            isOrderPick = true
            timerLeft = (orderData.order?.time_left_to_responds_trip!)!
            lblSecondCount.text = String(timerLeft)
            self.stopAccetpRejectTimer()
            self.timerForAcceptReject()
            self.startTimerForAcceptReject()
            if note.isEmpty() {
                self.removerRightButton()
            }else {
                self.btnRight?.tag = 1
                self.btnRight?.setImage(UIImage.init(named: "note")?.imageWithColor(), for: .normal)
                self.setRightBarButton(button: btnRight!)
            }
            break
            
        case OrderStatus.DELIVERY_MAN_COMPLETE_DELIVERY:
            isOrderPick = false
            btnSetStatus.setTitle("".localized, for: UIControl.State.normal)
            self.wsCompleteOrder()
            self.removerRightButton()
            break
            
        case OrderStatus.DELIVERY_MAN_COMING:
            isOrderPick = true
            btnSetStatus.setTitle("TXT_TAP_HERE_TO_ARRIVE".localized, for: UIControl.State.normal)
            requestStatus = OrderStatus.DELIVERY_MAN_ARRIVED
            self.btnRight?.tag = 0
            btnRight?.setImage(UIImage.init(named: "cancelBlackIcon")?.imageWithColor(), for: UIControl.State.normal)
            self.setRightBarButton(button: btnRight!)
            break
            
        case OrderStatus.DELIVERY_MAN_ARRIVED:
            
            isOrderPick = true
            btnSetStatus.setTitle("TXT_TAP_HERE_TO_PICKUP".localized, for: UIControl.State.normal)
            requestStatus = OrderStatus.DELIVERY_MAN_PICKED_ORDER
            self.btnRight?.tag = 0
            btnRight?.setImage(UIImage.init(named: "cancelBlackIcon")?.imageWithColor(), for: UIControl.State.normal)
            self.setRightBarButton(button: btnRight!)
            break
            
        case OrderStatus.DELIVERY_MAN_ACCEPTED:
            isOrderPick = true
            btnSetStatus.setTitle("TXT_TAP_HERE_TO_COMING".localized, for: UIControl.State.normal)
            requestStatus = OrderStatus.DELIVERY_MAN_COMING
            self.setRightBarButton(button: btnRight!)
            break
            
        case OrderStatus.DELIVERY_MAN_REJECTED:
            btnSetStatus.setTitle("".localized, for: UIControl.State.normal)
            self.setRightBarButton(button: btnRight!)
            break
            
        case OrderStatus.DELIVERY_MAN_CANCELLED:
            btnSetStatus.setTitle("".localized, for: UIControl.State.normal)
            break
            
        case OrderStatus.DELIVERY_MAN_PICKED_ORDER:
            isOrderPick = true
            btnSetStatus.setTitle("TXT_TAP_HERE_TO_START".localized, for: UIControl.State.normal)
            requestStatus = OrderStatus.DELIVERY_MAN_STARTED_DELIVERY
            
            if note.isEmpty()
            {
                self.removerRightButton()
            }else {
                self.btnRight?.tag = 1
                self.btnRight?.setImage(UIImage.init(named: "note")?.imageWithColor(), for: .normal)
                self.setRightBarButton(button: btnRight!)
            }
            break
            
        case OrderStatus.DELIVERY_MAN_STARTED_DELIVERY:
            guard let order = orderData.order else { return }
            let arrDestinationAddress = order.destinationAddresses ?? []
            if arrDestinationAddress.count > 1 && order.arrived_at_stop_no != arrDestinationAddress.count - 1 && order.arrived_at_stop_no + 1 < arrDestinationAddress.count {
                btnSetStatus.setTitle("TXT_TAP_HERE_TO_ARRIVE_DESTINATION".localized + " " + "\(order.arrived_at_stop_no + 1)", for: UIControl.State.normal)
            } else {
                btnSetStatus.setTitle("TXT_TAP_HERE_TO_ARRIVE_DESTINATION".localized, for: UIControl.State.normal)
            }
            requestStatus = OrderStatus.DELIVERY_MAN_ARRIVED_AT_DESTINATION
            if note.isEmpty()
            {
                self.removerRightButton()
            }else {
                self.btnRight?.tag = 1
                self.btnRight?.setImage(UIImage.init(named: "note")?.imageWithColor(), for: .normal)
                self.setRightBarButton(button: btnRight!)
            }
            
            isOrderPick = false
                        
            break
            
        case OrderStatus.DELIVERY_MAN_ARRIVED_AT_DESTINATION:
            guard let order = orderData.order else { return }
            let arrDestinationAddress = order.destinationAddresses ?? []
            if order.arrived_at_stop_no >= order.destinationAddresses.count {
                requestStatus = OrderStatus.DELIVERY_MAN_COMPLETE_DELIVERY
                btnSetStatus.setTitle("TXT_TAP_HERE_TO_END".localized, for: UIControl.State.normal)
            } else {
                requestStatus = OrderStatus.DELIVERY_MAN_PICKED_ORDER
                if arrDestinationAddress.count > 1 && order.arrived_at_stop_no != 0 {
                    btnSetStatus.setTitle("txt_start_from_address".localized + " " + "\(order.arrived_at_stop_no)", for: UIControl.State.normal)
                } else {
                    btnSetStatus.setTitle("TXT_TAP_HERE_TO_END".localized, for: UIControl.State.normal)
                }
            }
            
            isOrderPick = false
            
            if note.isEmpty()
            {
                self.removerRightButton()
            }else {
                self.btnRight?.tag = 1
                self.btnRight?.setImage(UIImage.init(named: "note")?.imageWithColor(), for: .normal)
                self.setRightBarButton(button: btnRight!)
            }
            isOrderPick = false
            break
            
        default:
            print("Invalid Case")
        }
    }
    
    func fillAddress(orderData: OrderStatusResponse) {
        let checkOrderStatus = OrderStatus(rawValue: (orderData.order?.order_status)!)
        arrAddress.removeAll()
        arrAddress = orderData.order?.destinationAddresses ?? []
        arrAddress.insert(orderData.order?.pickupAddresses.first ?? Address(fromDictionary: [:]), at: 0)
        for i in 0..<arrAddress.count {
            let obj = arrAddress[i]
            if  isOrderPicked(status:checkOrderStatus!) && i == 0 {
                obj.isArrived = true
            } else {
                if i <= orderData.order?.arrived_at_stop_no ?? 0 && orderData.order?.arrived_at_stop_no ?? 0 > 0 {
                    obj.isArrived = true
                }
            }
            if i == arrAddress.count - 1 {
                obj.address = self.setDestinationAddress(address: obj)
            }
        }
        tblAddress.reloadData()
    }
    
    func setNoteForCorier(orderData: OrderStatusResponse) {
        var isNoteFound = false
        
        for i in 0..<arrAddress.count {
            let obj = arrAddress[i]
            if obj.note != "" && !obj.note.isEmpty && obj.note != nil {
                isNoteFound = true
            }
        }
        
        if !isNoteFound {
            self.note = ""
            return
        }
        
        var stop = 1
        self.deliveryMessage = ""
        for i in 0..<arrAddress.count {
            let obj = arrAddress[i]
            if i == 0 {
                self.deliveryMessage += "TXT_PICKUP_NOTE".localized + " : \n"
                self.deliveryMessage += (obj.note ?? "") + "\n\n"
            } else {
                self.deliveryMessage += "TXT_DESTINATION_NOTE".localized + " "
                if arrAddress.count > 2 {
                    self.deliveryMessage += "\(stop)" + " : \n"
                    stop += 1
                }
                self.deliveryMessage += (obj.note ?? "") + "\n\n"
            }
        }
        
        note = "TXT_PICKUP_NOTE".localized + "\n" + self.pickupMessage  + "\n\n" + "TXT_DESTINATION_NOTE".localized + "\n" + self.deliveryMessage
        
        if (self.pickupMessage.isEmpty && self.deliveryMessage.isEmpty) {
            note = ""
        }
    }
    
    func setDestinationAddress(address: Address) -> String {
        let strAddress = address.address ?? ""
        let flatNo = address.flat_no ?? ""
        let street = address.street ?? ""
        let landmark = address.landmark ?? ""
        
        var finalAddress = strAddress
        var newLine = "\n"
        if !flatNo.isEmpty && !street.isEmpty {
            finalAddress += "\n\n" + "\(flatNo),\(street)"
        } else if !flatNo.isEmpty {
            finalAddress += "\n\n" + "\(flatNo)"
        } else if !street.isEmpty {
            finalAddress += "\n\n" + "\(street)"
        } else {
            newLine = "\n\n"
        }
        if !landmark.isEmpty {
            finalAddress += newLine + "\(landmark)"
        }
        return finalAddress
        //lblDestinationAddress.text = finalAddress
    }
  
    //MARK: Start/Stop Timer
    @objc func timerForAcceptReject() {
        
        timerLeft -= 1
        if timerLeft <= 0 {
            self.stopAccetpRejectTimer()
            wsCancelRejectOrder(status: OrderStatus.DELIVERY_MAN_REJECTED)
        }else {
            self.playSound()
            DispatchQueue.main.async {
                self.lblSecondCount.text = String(format: "%d Secs",self.timerLeft)
            }
            
        }
    }
    
    func stopAccetpRejectTimer() {
        DispatchQueue.main.async {
            CurrentOrder.shared.timerAcceptReject?.invalidate()
            CurrentOrder.shared.timerAcceptReject = nil
        }
        if player != nil {
            if (player?.isPlaying)! {
                player?.stop()
            }
        }
    }
    
    func startTimerForAcceptReject() {
        DispatchQueue.main.async {
            CurrentOrder.shared.timerAcceptReject?.invalidate()
            CurrentOrder.shared.timerAcceptReject =  Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(CurrentDeliveryVC.timerForAcceptReject), userInfo: nil, repeats: true)
        }
    }
    
    //MARK: Show all markers
    func focusMapToShowAllMarkers(sourceLatLong: CLLocationCoordinate2D, destinationLatLong: CLLocationCoordinate2D, currentLatLong: CLLocationCoordinate2D) {
        
        userMarker.position = destinationLatLong
        providerMarker.position = currentLatLong
        storeMarker.position = sourceLatLong
        userMarker.map = mapView
        storeMarker.map = mapView
        providerMarker.map = mapView
        var bearing:Double = 0.0
        
        var bounds = GMSCoordinateBounds()
        bounds = bounds.includingCoordinate(currentLatLong)
        if self.isActiveDelivery == 0 {
            bounds = bounds.includingCoordinate(sourceLatLong)
            bounds = bounds.includingCoordinate(destinationLatLong)
            
        }else {
            if isOrderPicked(status: requestStatus) {
                bounds = bounds.includingCoordinate(destinationLatLong)
                bearing = getBearingBetweenTwoPoints1(point1: providerCoordinate, point2: userCoordinate)
            }else {
                bounds = bounds.includingCoordinate(sourceLatLong)
                bearing = getBearingBetweenTwoPoints1(point1: providerCoordinate, point2: storeCoordinate)
            }
            
        }
        if isDoAnimation {
            isDoAnimation = true
            CATransaction.begin()
            CATransaction.setValue(3.0, forKey: kCATransactionAnimationDuration)
            CATransaction.setCompletionBlock {
            }
            mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 100.0))
            mapView.animate(toBearing: bearing)
            CATransaction.commit()
        }else {
            mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 100.0))
            mapView.animate(toBearing: bearing)
            
        }
        isMapFocus = false
    }
    
    func setUpMarkers() {
        userMarker.icon = UIImage(named: "user_pin")
        storeMarker.icon = UIImage(named: "store_pin")!.imageWithColor(color: .themeTextColor)
        storeMarker.map = mapView;
        providerMarker.icon = UIImage(named: "driver_pin_icon")
        providerMarker.map = mapView;
        Utility.downloadImageFrom(link: CurrentOrder.shared.mapPinUrl, completion: { (image) in
            self.providerMarker.icon = image
        })
        locationManager.currentUpdatingLocation { [unowned self] (location, error) in
            self.providerCoordinate = CLLocationCoordinate2D.init(latitude: CurrentOrder.shared.currentLatitude, longitude: CurrentOrder.shared.currentLongitude)
            self.animateToCurrentLocation()
        }
    }
    
    func animateToCurrentLocation() {
        if mapView != nil {
            let position:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: CurrentOrder.shared.currentLatitude, longitude: CurrentOrder.shared.currentLongitude)
            CATransaction.begin()
            CATransaction.setValue(3.0, forKey: kCATransactionAnimationDuration)
            CATransaction.setCompletionBlock {
            }
            print("position =>",position)
            providerMarker.position = position
            let camera = GMSCameraPosition.camera(withTarget: position, zoom: 17.0, bearing: CurrentOrder.shared.bearing, viewingAngle: 0.0)
            mapView.animate(to: camera)
            if isMapFocus {
                focusMapToShowAllMarkers(sourceLatLong: storeCoordinate, destinationLatLong: userCoordinate, currentLatLong: providerCoordinate)
            }
            CATransaction.commit()
        }
    }
    
    func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / 180.0 }
    func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }
    func getBearingBetweenTwoPoints1(point1 : CLLocationCoordinate2D, point2 : CLLocationCoordinate2D) -> Double {
        let fLat = degreesToRadians(degrees: point1.latitude)
        let fLng = degreesToRadians(degrees: point1.longitude)
        let tLat = degreesToRadians(degrees: point2.latitude)
        let tLng = degreesToRadians(degrees: point2.longitude)
        let degree = radiansToDegrees(radians: atan2(sin(tLng-fLng)*cos(tLat), cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(tLng-fLng)));
        if (degree >= 0) {
            return degree;
        } else {
            return 360+degree;
        }
    }
    
    //MARK: Button action method
    @IBAction func onClickServiceType(_ sender: UIButton) {
        if tripComplete {
            self.gotoInvoice()
        }
        else {
            if self.requestStatus == .DELIVERY_MAN_COMPLETE_DELIVERY {
                self.openCompletedeliveryDialog()
            }
            else if self.requestStatus == .DELIVERY_MAN_PICKED_ORDER {
                self.openConfirmCartDialog()
            }
            else {
                if self.requestStatus == .DELIVERY_MAN_ARRIVED_AT_DESTINATION &&  self.isAllowContactLessDelivery{
                    openImageDialog()
                }
                else {
                    Utility.showLoading()
                    wsChangeOrderStatus(status: requestStatus)
                }
            }
        }
    }
    
    @IBAction func onClickNavigation(_ sender: UIButton) {
        if isOrderPicked(status: requestStatus) {
            
            if CurrentOrder.shared.currentLatitude.isZero || CurrentOrder.shared.currentLongitude.isZero || !(CLLocationCoordinate2DIsValid(userCoordinate)) {
                
            }else {
                let url = "http://maps.apple.com/maps?saddr=\(CurrentOrder.shared.currentLatitude),\(CurrentOrder.shared.currentLongitude)&daddr=\(userCoordinate.latitude),\(userCoordinate.longitude)"
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string:url)!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(URL(string:url)!)
                }
            }
        }
        else {
            if CurrentOrder.shared.currentLatitude.isZero || CurrentOrder.shared.currentLongitude.isZero || !(CLLocationCoordinate2DIsValid(storeCoordinate)) {
            }
            else {
                let url = "http://maps.apple.com/maps?saddr=\(CurrentOrder.shared.currentLatitude),\(CurrentOrder.shared.currentLongitude)&daddr=\(storeCoordinate.latitude),\(storeCoordinate.longitude)"
               
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string:url)!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(URL(string:url)!)
                }
            }
        }
    }
    
    @IBAction func onClickBtnCart(_ sender: Any) {
        if (orderStatusResponse.order?.delivery_type)! == DeliveryType.courier {
            lblCall.text = "TXT_CALL_USER".localized
            presentCourierDetail()
        }else {
            presentCartModal()
        }
    }
    
    @IBAction func onClickAccpetReject(_ sender: UIButton) {
        self.stopAccetpRejectTimer()
        if sender.tag == 10 {
            wsChangeOrderStatus(status: OrderStatus.DELIVERY_MAN_ACCEPTED)
        }
        else {
            wsCancelRejectOrder(status: OrderStatus.DELIVERY_MAN_REJECTED)
        }
    }
    
    @IBAction func onClickBtnTargetLocation(_ sender: Any) {
        isMapFocus = true
        animateToCurrentLocation()
    }
    
    func presentCartModal() {
        if arrForCart.isEmpty {
            Utility.showToast(message: "TXT_NO_ITEM_TO_DISPLAY".localized)
        }else
        {
            let modalController:CartDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "cartVc") as! CartDetailVC
            modalController.modalPresentationStyle = .overCurrentContext
            modalController.arrForProducts = arrForCart
            modalController.strOrderNumber = lblOrderNumber.text ?? ""
            present(modalController, animated: false, completion: nil)
        }
    }
    
    func presentCourierDetail() {
        if (self.orderStatusResponse.order?.image_url.isEmpty) ?? true && !cartDataSet {
            Utility.showToast(message: "TXT_NO_ITEM_TO_DISPLAY".localized)
        }else
        {
            let dialogForCourierDetail: CustomCourierDetailDialog = CustomCourierDetailDialog.showCustomCourierDetailDialog(orderDetail: self.orderStatusResponse.order!, titleDoneButton: "TXT_DONE".localized)
            dialogForCourierDetail.onClickDoneButton = { [unowned dialogForCourierDetail] in
                
                dialogForCourierDetail.removeFromSuperview()
            }
        }
    }
    
    @IBAction func onClickBtnCall(_ sender: Any) {
        if preferenceHelper.getIsEnableTwilioCallMask() {
            TwilioCallMasking.shared.wsTwilloCallMasking(id: strRquestID, type: userType)
        } else {
            if let phoneNumberUrl:URL = URL(string: "tel://\(strMobileNumber)") {
                if  UIApplication.shared.canOpenURL(phoneNumberUrl) {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(phoneNumberUrl, options: Utility.convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                    }else {
                        UIApplication.shared.openURL(phoneNumberUrl as URL)
                    }
                }
            }else {
                Utility.showToast(message: "MSG_UNABLE_TO_CALL".localized)
            }
        }
    }
    
    func openConfirmCartDialog() {
        if btnCart.isHidden {
            self.openPickUpDialog()
        }else {
            let dialogForConfirmation = CustomAlertDialog.showCustomAlertDialog(title: "TXT_CONFIRM_CART_DETAIL".localizedCapitalized, message: "MSG_CONFIRM_CART_DETAIL".localized, titleLeftButton: "TXT_CANCEL".localizedUppercase, titleRightButton: "TXT_CONFIRM".localizedUppercase)
            dialogForConfirmation.onClickLeftButton = {[unowned dialogForConfirmation] in
                dialogForConfirmation.removeFromSuperview();
            }
            dialogForConfirmation.onClickRightButton = {[unowned dialogForConfirmation, unowned self] in
                dialogForConfirmation.removeFromSuperview();
                self.openPickUpDialog()
            }
        }
    }
    
    func openPickUpDialog() {
        
        if (self.orderStatusResponse.order?.isConfirmationCodeRequiredAtPickupDelivery)! && self.orderStatusResponse.order?.arrived_at_stop_no == 0 {
            print(self.orderStatusResponse.order?.confirmation_code_for_pickup as Any)
            let dailogForOTP = CustomOTPVerificationDialog.showCustomOTPVerificationDialog(title: "TXT_CONFIRMATION_CODE".localized, message: "TXT_ENTER_CODE_MESSAGE".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_SUBMIT".localized)
            dailogForOTP.onClickOkButton = { otp in
                if otp.count > 0 {
                    
                    if self.requestStatus == .DELIVERY_MAN_PICKED_ORDER
                    {
                        let code = self.orderStatusResponse.order?.confirmation_code_for_pickup
                        if (otp.compare(code!) == ComparisonResult.orderedSame)
                        {
                            dailogForOTP.removeFromSuperview();
                            if self.is_allow_pickup_order_verification  && self.orderStatusResponse.order?.arrived_at_stop_no == 0 {
                                self.openImageDialog()
                            }
                            else {
                                self.wsChangeOrderStatus(status: self.requestStatus)
                            }
                        }
                        else
                        {
                            Utility.showToast(message:"MSG_ENTER_PICKUP_CODE".localized)
                        }
                    }
                } else {
                    Utility.showToast(message: "MSG_ENTER_CODE".localized)
                }
            }
        }
        else {
            if self.is_allow_pickup_order_verification && self.orderStatusResponse.order?.arrived_at_stop_no == 0 {
                openImageDialog()
            }
            else {
                self.wsChangeOrderStatus(status: self.requestStatus)
            }
        }
    }
    
    func openCompletedeliveryDialog() {
        
        if (self.orderStatusResponse.order?.isConfirmationCodeRequiredAtCompletedelivery)! {
           
            let dialogForVerification = CustomOTPVerificationDialog.showCustomOTPVerificationDialog(title: "TXT_CONFIRMATION_CODE".localized, message: "TXT_ENTER_CODE_MESSAGE".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_SUBMIT".localized)

            dialogForVerification.onClickOkButton = { text1 in
                
                if text1.count > 0 {
                    let code = self.orderStatusResponse.order?.confirmation_code_for_complete_delivery
                    if (text1.compare(code!) == ComparisonResult.orderedSame)
                    {
                        dialogForVerification.removeFromSuperview();
                        self.wsCompleteOrder()
                    }
                    else
                    {
                        Utility.showToast(message:"MSG_ENTER_CONFIRMATION_CODE".localized)
                    }
                }else {
                    Utility.showToast(message: "MSG_ENTER_CODE".localized)
                }
                
            }
        }else {
            self.wsCompleteOrder()
        }
    }
  
//MARK: CompleteOrder
    
    func wsCompleteOrder() {
        Utility.showLoading()
        
        let dictParam:[String:String] =
            [PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken(),
             PARAMS.PROVIDER_ID : preferenceHelper.getUserId(),
             PARAMS.REQUEST_ID : strRquestID,
        ]
        print(dictParam)
        
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_COMPLETE_ORDER, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            self.arrForInvoice.removeAllObjects()
            if Parser.isSuccess(response: response) {
                print(response)
                Utility.hideLoading()
                self.invoiceResponse = InvoiceResponse.init(dictionary: response)
                self.gotoInvoice()
                self.tripComplete = true
                self.btnNavigation.isHidden = true
                self.btnSetStatus.setTitle("TXT_VIEW_INVOICE".localized, for: .normal)
            }
        }
    }
   
    //MARK: ACCEPT REQUEST/CHANGE ORDER STATUS
    func wsChangeOrderStatus(status: OrderStatus,image:UIImage?=nil) {
        Utility.showLoading()
        
        var dictParam:[String:Any] =
            [PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken(),
             PARAMS.PROVIDER_ID : preferenceHelper.getUserId(),
             PARAMS.REQUEST_ID : strRquestID,
             PARAMS.DELIVERY_STATUS : status.rawValue]
        print(dictParam)

        let alamoFire:AlamofireHelper = AlamofireHelper();
        if image != nil && (self.requestStatus == .DELIVERY_MAN_PICKED_ORDER || self.requestStatus == .DELIVERY_MAN_ARRIVED_AT_DESTINATION) {
             dictParam[PARAMS.DELIVERY_STATUS] = String(status.rawValue)
            alamoFire.getResponseFromURL(url:WebService.WS_CHANGE_ORDER_STATUS , paramData: dictParam, image: image, block: { response, error in
                Utility.hideLoading()
                print(response)
                if Parser.isSuccess(response: response) {
                    self.wsGetOrderStatus()
                }
                if self.isActiveDelivery == 0 {
                    _ = self.navigationController?.popViewController(animated: true)
                }
            })
        } else {
            alamoFire.getResponseFromURL(url: WebService.WS_CHANGE_ORDER_STATUS, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
                Utility.hideLoading()
                print(response)
                if Parser.isSuccess(response: response) {
                    self.wsGetOrderStatus()
                }
                if self.isActiveDelivery == 0 {
                    _ = self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func wsGetCancelReasonList() {
        
        let dictParam: Dictionary<String,Any> =
        [PARAMS.PROVIDER_ID:preferenceHelper.getUserId(),
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
   
    //MARK: REJECT/CANCEL ORDER
    func wsCancelRejectOrder(status: OrderStatus, cancelReason:String = "") {
        Utility.showLoading()
        var dictParam:[String:Any];
        if cancelReason.isEmpty {
            dictParam =
                [PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken(),
                 PARAMS.PROVIDER_ID : preferenceHelper.getUserId(),
                 PARAMS.REQUEST_ID : strRquestID,
                 PARAMS.DELIVERY_STATUS : status.rawValue,
                 PARAMS.CANCEL_REASON :cancelReason
            ]
            
        }else {
            let cancelationReason:CancelReason = CancelReason.init(fromDictionary: [:])
            let userDetail:UserDetail = UserDetail(fromDictionary: [:]);
            userDetail.email = preferenceHelper.getEmail()
            userDetail.uniqueId = preferenceHelper.getUniqueId()
            userDetail.countryPhoneCode = preferenceHelper.getPhoneCountryCode()
            userDetail.name = preferenceHelper.getFirstName() + " " + preferenceHelper.getLastName()
            userDetail.phone = preferenceHelper.getPhoneNumber()
            cancelationReason.userDetails = userDetail
            cancelationReason.cancelledAt = Utility.dateToString(date: Date(), withFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB)
            cancelationReason.cancelReason = cancelReason
            cancelationReason.userType = CONSTANT.TYPE_PROVIDER.integerValue
            
            dictParam =
                [PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken(),
                 PARAMS.PROVIDER_ID : preferenceHelper.getUserId(),
                 PARAMS.REQUEST_ID : strRquestID,
                 PARAMS.DELIVERY_STATUS : status.rawValue,
                 PARAMS.CANCEL_REASON :cancelationReason.toDictionary()
            ]
        }
        
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_CANCEL_OR_REJECT_ORDER, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            
            Utility.hideLoading()
            if Parser.isSuccess(response: response) {
                _ = self.navigationController?.popViewController(animated: true)
            }else {
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }
   
    //MARK: Memory Mngmnt
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let objVC = segue.destination as! InvoiceVC
        objVC.orderPayment = invoiceResponse?.order_payment!
        objVC.strCurrency = (invoiceResponse?.currency!)!
        objVC.paymentType = invoiceResponse?.payment_gateway_name ?? ""
        objVC.activeOrder = self.activeOrderData
    }
    
    func gotoInvoice() {
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "History", bundle: nil)
        if let invoiceVC : InvoiceVC = mainView.instantiateViewController(withIdentifier: "InvoiceVC") as? InvoiceVC {
            invoiceVC.orderPayment = invoiceResponse?.order_payment!
            invoiceVC.strCurrency = (invoiceResponse?.currency!)!
            invoiceVC.paymentType = invoiceResponse?.payment_gateway_name ?? ""
            invoiceVC.activeOrder = self.activeOrderData
            invoiceVC.modalPresentationStyle = .overCurrentContext
            self.present(invoiceVC, animated: false, completion: nil)
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}

extension CurrentDeliveryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAddress.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as! AddressCell
        let obj = arrAddress[indexPath.row]
        cell.lblAddress.text = obj.address
        cell.selectionStyle = .none
        cell.imgPin.image = indexPath.row == 0 ? UIImage(named: "user_pin")!.imageWithColor(color: .themeTextColor) : UIImage(named: "user_pin")!
        cell.imgRight.isHidden = true
        if obj.isArrived {
            cell.imgRight.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
