//
//  HomeVC.swift
//  edelivery
//
//  Created by Elluminati on 14/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
import CoreAudio

class OrderStatusVC: BaseVC, LeftDelegate,DelegateTapOnConfirm {
    
    @IBOutlet weak var viewForOrderStatus: UIView!
    //MARK: OutLets
    
    @IBOutlet weak var orderNumber: UILabel!
    @IBOutlet weak var viewForEstTime: UILabel!
    @IBOutlet weak var lblEstDeliveryTime: UILabel!
    /*Stauses*/
    @IBOutlet weak var btnOrderAccepted: UIButton!
    @IBOutlet weak var btnOrderPrepared: UIButton!
    @IBOutlet weak var btnOrderOnTheWay: UIButton!
    @IBOutlet weak var btnOrderOnDoorStep: UIButton!
    var btnRight: UIButton? = nil
    var isOpenFromPush: Bool = false
    
    @IBOutlet weak var btnToPrepareOrder: UIButton!
    @IBOutlet weak var btnCancelOrder: UIButton!
    @IBOutlet weak var btnTrackOrder: UIButton!
    @IBOutlet weak var btnGetCode: UIButton!
    @IBOutlet weak var btnViewInvoice: UIButton!
    @IBOutlet weak var lblOrderAccepted: UILabel!
    @IBOutlet weak var lblOrderPrepared: UILabel!
    @IBOutlet weak var lblOrderTheWay: UILabel!
    @IBOutlet weak var lblOrderOnDoorStep: UILabel!
    @IBOutlet weak var viewForOnTheWay: UIView!
    @IBOutlet weak var viewForDoorStop: UIView!
    @IBOutlet weak var lblDividerToTrackProvider: UILabel!
    @IBOutlet weak var lblDividerToDoorStep: UILabel!
  
    //MARK: Date View
    
    @IBOutlet weak var lblAcceptedDate: UILabel!
    @IBOutlet weak var lblAcceptedTime: UILabel!
    @IBOutlet weak var viewUserConfirm: UIView!
    @IBOutlet weak var btnUserConfirm: UIButton!
    @IBOutlet weak var lblUserConfirm: UILabel!
    @IBOutlet weak var lblPreparedDate: UILabel!
    @IBOutlet weak var lblPreparedTime: UILabel!
    @IBOutlet weak var lblStartDeliveryDate: UILabel!
    @IBOutlet weak var lblStartDeliveryTime: UILabel!
    @IBOutlet weak var btnCompleteImage: UIButton!
    @IBOutlet weak var btnPickupImage: UIButton!
    @IBOutlet var btnChat: MyBadgeButton!
    @IBOutlet weak var lblDeliveryCompleteDate: UILabel!
    @IBOutlet weak var lblDeliveryCompleteTime: UILabel!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var imgContactLess: UIImageView!
    @IBOutlet weak var viewForSearchOverlay: UIView!
    @IBOutlet weak var viewForSearchItem: UIView!
    @IBOutlet weak var heightForSearchView: NSLayoutConstraint!
    @IBOutlet weak var viewForDeliverymanChat: UIView!
    @IBOutlet weak var viewForStoreChat: UIView!
    @IBOutlet weak var lblChatAdmin: UILabel!
    @IBOutlet weak var lblChatProvider: UILabel!
    @IBOutlet weak var lblChatStore: UILabel!
    @IBOutlet weak var imgStore: UIImageView!
    @IBOutlet weak var lblStoreName: UILabel!
    @IBOutlet weak var lblStoreAddress: UILabel!
    @IBOutlet weak var btnRateProvider: UIButton!
    @IBOutlet weak var btnRateStore: UIButton!
    @IBOutlet var btnGetPickupCode: UIButton!
    @IBOutlet var btnClose: UIButton!
    @IBOutlet weak var stkVWTableBooking: UIStackView!
    @IBOutlet weak var imgTableBooking: UIImageView!
    @IBOutlet weak var lblTableBooking: UILabel!
    @IBOutlet weak var lblTableBookScheduleTime: UILabel!
    
    @IBOutlet weak var heightForView: NSLayoutConstraint!
    var dialogForImage:CustomPhotoDialog?
    var arrForDeliveryDetails:[OrderDateWiseStatusDetails] = []
    var pickupImgUrl = ""
    var completeImgUrl = ""
    
    //MARK: Variables
    var selectedOrder:Order = Order.init()
    var orderStatusReponse:OrderStatusResponse = OrderStatusResponse.init(fromDictionary: [:])
    weak var timerForOrderStatus: Timer? = nil
    var dialogForCancelOrder:CustomCancelOrderDialog? = nil
    var dialogForConfirmCode:CustomAlertDialog? = nil
    var dialogForFeedback: DailogForFeedback? = nil
    var isDeliverymanChatVisible: Bool = false
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        viewForEstTime.isHidden = true //isUserWillPickupDelivery
        lblEstDeliveryTime.isHidden = true //isUserWillPickupDelivery
        heightForView.constant = 100
        setLocalization()
        btnGetCode.isHidden = true
        btnPickupImage.isHidden = true
        btnCompleteImage.isHidden = true
        self.viewImage.isHidden = true
        btnGetCode.addTarget(self, action: #selector(OrderStatusVC.tapOnGetCode), for: .touchUpInside)
        btnCancelOrder.addTarget(self, action: #selector(OrderStatusVC.tapOnOrderCancel(sender:)), for: .touchUpInside)
        btnToPrepareOrder.addTarget(self, action: #selector(OrderStatusVC.tapOnPrepareOrder(sender:)), for: .touchUpInside)
        btnTrackOrder.addTarget(self, action: #selector(OrderStatusVC.tapOnOrderOnTheWay(sender:)), for: .touchUpInside)
        btnViewInvoice.addTarget(self, action: #selector(OrderStatusVC.tapOnViewInvoice(sender:)), for: .touchUpInside)
        viewForSearchOverlay.backgroundColor = UIColor.clear
        viewForSearchOverlay.isHidden = true
        viewForSearchItem.backgroundColor = UIColor.white
        viewForSearchItem.setShadow(shadowColor: UIColor.black.cgColor, shadowOffset: CGSize.init(width: 2.0, height: 2.0), shadowOpacity: 5.0, shadowRadius: 2.0)
        btnChat = MyBadgeButton.init(frame: CGRect.init(x: 0, y: 0, width: 32, height: 32))
        btnChat?.setImage(UIImage.init(named: "chat")?.imageWithColor(color: .themeColor), for: .normal)
        btnChat?.addTarget(self, action: #selector(self.onClickBtnChat(_:)), for: .touchUpInside)
        let rightButton:UIBarButtonItem = UIBarButtonItem.init(customView: btnChat!)
        self.navigationItem.setRightBarButton(rightButton, animated: false)
        self.btnViewInvoice.isHidden = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Userapp
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        wsGetOrderDetail()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //Userapp
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        btnToPrepareOrder.setRound(withBorderColor: .clear, andCornerRadious: 3.0, borderWidth: 1.0)
        //        btnCancelOrder.setRound(withBorderColor: .clear, andCornerRadious: 3.0, borderWidth: 1.0)
        btnTrackOrder.setRound(withBorderColor: .clear, andCornerRadious: 3.0, borderWidth: 1.0)
        btnGetCode.setRound(withBorderColor: .clear, andCornerRadious: 3.0, borderWidth: 1.0)
        btnPickupImage.setRound(withBorderColor: .clear, andCornerRadious: 3.0, borderWidth: 1.0)
        btnCompleteImage.setRound(withBorderColor: .clear, andCornerRadious: 3.0, borderWidth: 1.0)
        imgContactLess.setRound(withBorderColor: .clear, andCornerRadious: 3.0, borderWidth: 1.0)
        btnUserConfirm.setRound(withBorderColor: .clear, andCornerRadious: 3.0, borderWidth: 1.0)
        animateView()
        btnOrderAccepted.setRound()
        btnOrderPrepared.setRound()
        btnOrderOnTheWay.setRound()
        btnOrderOnDoorStep.setRound()
        imgStore.setRound(withBorderColor: UIColor.clear, andCornerRadious: 8.0, borderWidth: 0.1)
        btnClose.setRound(withBorderColor: .clear, andCornerRadious: 8.0, borderWidth: 1.0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timerForOrderStatus?.invalidate()
        //MessageHandler.ReceiverID = ""
        timerForOrderStatus = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        timerForOrderStatus?.invalidate()
        timerForOrderStatus = nil
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
    
    //MARK: - IBAction Event
    
    @IBAction func onClickBtnChat(_ sender: AnyObject) {
        /*  if viewForSearchOverlay.isHidden {
         viewVisible()
         }else {
         viewGone()
         } */
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
    
    
    func pushChatVC(ind:Int){
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "Order", bundle: nil)
        if let vc : MyCustomChatVC = mainView.instantiateViewController(withIdentifier: "chatVC") as? MyCustomChatVC
        {
            self.viewGone()
            
            MessageHandler.chatType = ind
            vc.navTitle = chatNavTitle
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func onClickLeftButton() {
        HistoryInvoiceVC.isInvoiceSubmittedOnce = false
        if isOpenFromPush {
            APPDELEGATE.goToMain()
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }

    
    func setLocalization() {
        APPDELEGATE.setupNavigationbar()
        self.setBackBarItem(isNative: false)
        delegateLeft = self
        self.hideBackButtonTitle()
        /*Set localized Text*/
        lblUserConfirm.text = "MSG_USER_CONFIRM_ORDER".localized
        btnUserConfirm.setTitle("TXT_CHECK_ORDER".localized, for: .normal)
        lblUserConfirm.text = "MSG_USER_CONFIRM_ORDER".localized
        btnUserConfirm.setTitle("TXT_CHECK_ORDER".localized, for: .normal)
        lblOrderAccepted.text = "TXT_ORDER_ACCEPTED".localized
        lblEstDeliveryTime.text = "TXT_ESTIMATE_DELIVERY_TIME".localizedCapitalized
        lblOrderPrepared.text = "TXT_ORDER_PREPARED".localized
        lblOrderTheWay.text = "TXT_ORDER_ON_THE_WAY".localized
        lblOrderOnDoorStep.text = "TXT_ORDER_ON_DOORSTEP".localized
        btnCancelOrder.setTitle( "  " + "TXT_CANCEL_ORDER".localizedCapitalized + "  ", for: .normal)
        btnToPrepareOrder.setTitle("  " + "TXT_PREPARE_ORDER".localizedCapitalized + "  ", for: .normal)
        btnTrackOrder.setTitle("  " + "TXT_TRACK_ORDER".localizedCapitalized + "  ", for: .normal)
        btnGetCode.setTitle("  "+"TXT_GET_CODE".localizedCapitalized + "  ", for: .normal)
        btnCompleteImage.setTitle("  "+"TXT_DELIVERY_IMAGE".localizedCapitalized + "  ", for: .normal)
        btnPickupImage.setTitle("  "+"TXT_PICKUP_IMAGE".localizedCapitalized + "  ", for: .normal)
        btnViewInvoice.setTitle( "  " + "TXT_VIEW_INVOICE".localizedCapitalized + "  ", for: .normal)
        lblChatAdmin.text = "TXT_CHAT_WITH".localized + "TXT_ADMIN".localized
        lblChatProvider.text = "TXT_CHAT_WITH".localized + "TXT_PROVIDER".localized
        lblChatStore.text = "TXT_CHAT_WITH".localized + "TXT_STORE".localized
        
        viewImage.backgroundColor = UIColor.themeOverlayColor
        lblAcceptedDate.text = ""
        lblAcceptedTime.text = ""
        lblPreparedDate.text = ""
        lblPreparedTime.text = ""
        lblStartDeliveryDate.text = ""
        lblStartDeliveryTime.text = ""
        lblDeliveryCompleteDate.text = ""
        lblDeliveryCompleteTime.text = ""
        
        btnUserConfirm.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnUserConfirm.backgroundColor = UIColor.themeButtonBackgroundColor
        btnUserConfirm.titleLabel?.font = FontHelper.buttonText()
        lblUserConfirm.textColor = UIColor.themeTextColor
        lblUserConfirm.font = FontHelper.labelRegular()
        
        lblAcceptedDate.textColor = UIColor.themeTextColor
        lblAcceptedTime.textColor = UIColor.themeLightTextColor
        lblPreparedDate.textColor = UIColor.themeTextColor
        lblPreparedTime.textColor = UIColor.themeLightTextColor
        lblStartDeliveryDate.textColor = UIColor.themeTextColor
        lblStartDeliveryTime.textColor = UIColor.themeLightTextColor
        lblDeliveryCompleteDate.textColor = UIColor.themeTextColor
        lblDeliveryCompleteTime.textColor = UIColor.themeLightTextColor
        
        /*set font*/
        lblAcceptedDate.font = FontHelper.textRegular()
        lblAcceptedTime.font = FontHelper.textSmall(size: FontHelper.labelRegular)
        lblPreparedDate.font = FontHelper.textRegular()
        lblPreparedTime.font = FontHelper.textSmall(size: FontHelper.labelRegular)
        lblStartDeliveryDate.font = FontHelper.textRegular()
        lblStartDeliveryTime.font = FontHelper.textSmall(size: FontHelper.labelRegular)
        lblDeliveryCompleteDate.font = FontHelper.textRegular()
        lblDeliveryCompleteTime.font = FontHelper.textSmall(size: FontHelper.labelRegular)
        
        
        /*Set color */
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        lblOrderAccepted.textColor = UIColor.themeTextColor
        lblEstDeliveryTime.textColor = UIColor.themeTextColor
        lblOrderPrepared.textColor = UIColor.themeTextColor
        lblOrderTheWay.textColor = UIColor.themeTextColor
        lblOrderOnDoorStep.textColor = UIColor.themeTextColor
        viewForEstTime.backgroundColor = UIColor.clear
        viewForEstTime.textColor = UIColor.themeTextColor
        
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
        
        btnToPrepareOrder.backgroundColor = UIColor.themeViewBackgroundColor
        btnCancelOrder.backgroundColor = UIColor.themeViewBackgroundColor
        btnViewInvoice.backgroundColor = UIColor.themeViewBackgroundColor
        btnTrackOrder.backgroundColor = UIColor.themeViewBackgroundColor
        btnGetCode.backgroundColor = UIColor.themeViewBackgroundColor
        btnCompleteImage.backgroundColor = UIColor.themeViewBackgroundColor
        btnPickupImage.backgroundColor = UIColor.themeViewBackgroundColor
        btnCancelOrder.setTitleColor(UIColor.themeColor, for: .normal)
        btnViewInvoice.setTitleColor(UIColor.themeColor, for: .normal)
        btnToPrepareOrder.setTitleColor(UIColor.themeColor, for: .normal)
        btnTrackOrder.setTitleColor(UIColor.themeColor, for: .normal)
        btnGetCode.setTitleColor(UIColor.themeColor, for: .normal)
        btnCompleteImage.setTitleColor(UIColor.themeColor, for: .normal)
        btnPickupImage.setTitleColor(UIColor.themeColor, for: .normal)
        
        /*Set Font*/
        btnOrderAccepted.titleLabel?.font = FontHelper.textRegular()
        btnOrderPrepared.titleLabel?.font = FontHelper.textRegular()
        btnOrderOnTheWay.titleLabel?.font = FontHelper.textRegular()
        btnOrderOnDoorStep.titleLabel?.font = FontHelper.textRegular()
        
        btnCancelOrder.titleLabel?.font = FontHelper.textRegular()
        btnViewInvoice.titleLabel?.font = FontHelper.textRegular()
        btnToPrepareOrder.titleLabel?.font = FontHelper.textRegular()
        btnTrackOrder.titleLabel?.font = FontHelper.textRegular()
        btnGetCode.titleLabel?.font = FontHelper.textRegular()
        btnPickupImage.titleLabel?.font = FontHelper.textRegular()
        btnCompleteImage.titleLabel?.font = FontHelper.textRegular()
        
        
        lblOrderAccepted.font = FontHelper.textRegular(size:FontHelper.medium)
        lblEstDeliveryTime.font = FontHelper.textRegular()
        lblOrderPrepared.font = FontHelper.textRegular(size:FontHelper.medium)
        lblOrderTheWay.font = FontHelper.textRegular(size:FontHelper.medium)
        lblOrderOnDoorStep.font = FontHelper.textRegular(size:FontHelper.medium)
        viewForEstTime.font = FontHelper.textSmall()
        
        lblStoreName.textColor = UIColor.themeTitleColor
        lblStoreAddress.textColor = UIColor.themeTitleColor
        
        lblStoreName.font = FontHelper.textMedium(size: FontHelper.regular)
        lblStoreAddress.font = FontHelper.textRegular()
        lblUserConfirm.isHidden = true
        viewUserConfirm.isHidden = true
        btnRateProvider.setTitle("TXT_RATE_US".localized, for: .normal)
       // btnRateProvider.setImage(UIImage(named:"star_feedback"), for: .normal)
        
        btnRateProvider.setTitleColor(UIColor.themeColor, for: .normal)
        btnRateProvider.titleLabel?.font = FontHelper.textRegular(size: FontHelper.regular)
        btnRateProvider.isHidden = true
        btnRateProvider.tintColor = UIColor.themeColor
        btnRateStore.setTitle("TXT_RATE_US".localized, for: .normal)
        btnRateStore.setTitleColor(UIColor.themeColor, for: .normal)
        btnRateStore.titleLabel?.font = FontHelper.textRegular(size: FontHelper.regular)
        btnRateStore.isHidden = true
       // btnRateStore.setImage(UIImage(named: "star_feedback"), for: .normal)
        btnRateStore.tintColor  = UIColor.themeColor
        btnGetPickupCode.isHidden = true
        btnGetPickupCode.addTarget(self, action: #selector(OrderStatusVC.tapOnGetPickupCode(sender:)), for: .touchUpInside)
        btnGetPickupCode.backgroundColor = UIColor.themeViewBackgroundColor
        btnGetPickupCode.setTitle("  "+"TXT_GET_CODE".localizedCapitalized + "  ", for: .normal)
        btnGetPickupCode.setTitleColor(UIColor.themeColor, for: .normal)
        btnGetPickupCode.titleLabel?.font = FontHelper.textRegular()
        btnGetPickupCode.addTarget(self, action: #selector(OrderStatusVC.tapOnGetPickupCode(sender:)), for: .touchUpInside)
        btnGetPickupCode.isHidden = true
        
        btnOrderAccepted.setTitle("TXT_1".localized, for: .normal)
        btnOrderPrepared.setTitle("TXT_2".localized, for: .normal)
        btnOrderOnTheWay.setTitle("TXT_3".localized, for: .normal)
        btnOrderOnDoorStep.setTitle("TXT_4".localized, for: .normal)
        
        btnClose.setTitle("TXT_CLOSE".localized, for: .normal)
        btnClose.setTitleColor(.themeViewBackgroundColor, for: .normal)
        btnClose.setBackgroundColor(color: .themeTitleColor, forState: .normal)
        lblTableBooking.textColor = .themeTextColor
        lblTableBooking.font = FontHelper.textMedium()
        lblTableBookScheduleTime.textColor = .themeIconTintColor
        lblTableBookScheduleTime.font = FontHelper.textRegular(size: FontHelper.labelRegular)
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
        btnCancelOrder.backgroundColor = UIColor.themeViewBackgroundColor
        btnViewInvoice.backgroundColor = UIColor.themeViewBackgroundColor
        btnTrackOrder.backgroundColor = UIColor.themeViewBackgroundColor
        btnGetCode.backgroundColor = UIColor.themeViewBackgroundColor
        btnCompleteImage.backgroundColor = UIColor.themeViewBackgroundColor
        btnPickupImage.backgroundColor = UIColor.themeViewBackgroundColor
        btnCancelOrder.setTitleColor(UIColor.themeColor, for: .normal)
        btnViewInvoice.setTitleColor(UIColor.themeColor, for: .normal)
        btnToPrepareOrder.setTitleColor(UIColor.themeColor, for: .normal)
        btnTrackOrder.setTitleColor(UIColor.themeColor, for: .normal)
        btnGetCode.setTitleColor(UIColor.themeColor, for: .normal)
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

    //MARK: - WEB SERVICE CALLS
    @objc func wsGetOrderStatus() {
        let dictParam: Dictionary<String,Any> =
            [PARAMS.USER_ID:preferenceHelper.getUserId(),
             PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken(),
             PARAMS.ORDER_ID:selectedOrder._id ?? ""]
        print("WS_ORDER_STATUS dictParam---> \(dictParam)")

        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_ORDER_STATUS, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { [weak self]   (response, error) -> (Void) in
            print("WS_ORDER_STATUS response---> \(response)")
            Utility.hideLoading()
            guard let self = self else { return }
            if (Parser.isSuccess(response: response)) {
                self.orderStatusReponse = OrderStatusResponse.init(fromDictionary: response as! [String : Any])
                
                self.title = "TXT_ORDER_NO".localized + "\((self.orderStatusReponse.uniqueId) ?? 0)"
                
                if !self.orderStatusReponse.destinationAddresses.isEmpty {
                    currentBooking.deliveryLatLng = self.orderStatusReponse.destinationAddresses[0].location
                }
                
                self.viewForEstTime?.text = self.secondsToHoursMinutesSeconds(seconds: Int((self.orderStatusReponse.totalTime * 60) + (self.orderStatusReponse.estimatedTimeForDeliveryInMin * 60)))
                self.updateStatusUI(isConfirmationCodeRequired: self.orderStatusReponse.isConfirmationCodeRequiredAtCompleteDelivery, isUserWillPickupDelivery: self.orderStatusReponse.isUserPickUpOrder,isConfirmationCodeRequiredAtPickup: self.orderStatusReponse.isConfirmationCodeRequiredAtPickupDelivery)
               
                if self.orderStatusReponse.deliveryType == DeliveryType.tableBooking {
                    self.updateTableBookingStatusUI()
                }

                if self.orderStatusReponse.isScheduleOrder {
                    self.updateScheduleStatusUI()
                }

                let orderStatus = ((self.orderStatusReponse.orderStatus > self.orderStatusReponse.deliveryStatus) ? self.orderStatusReponse.orderStatus: self.orderStatusReponse.deliveryStatus) ?? 0
                self.checkForOrderStatus(orderStatusValue: orderStatus)
                self.arrForDeliveryDetails.removeAll()

                if self.orderStatusReponse.provider_detail == nil {
                    self.btnTrackOrder.setTitle("", for: .normal)
                    self.btnTrackOrder.isUserInteractionEnabled = false
                } else {
                    self.btnTrackOrder.setTitle("  " + "TXT_TRACK_ORDER".localizedCapitalized + "  ", for: .normal)
                    self.btnTrackOrder.isUserInteractionEnabled = true
                }

                for details in self.orderStatusReponse.orderStatusDetails {
                    let orderStatusDetail:OrderDateWiseStatusDetails = OrderDateWiseStatusDetails.init(fromDictionary: [:])
                    orderStatusDetail.date =      Utility.relativeDateStringForDate(strDate: Utility.stringToString(strDate: details.date, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_TIME_FORMAT_HISTORY, locale: "en_GB"), dateFormate: DATE_CONSTANT.DATE_TIME_FORMAT_HISTORY) as String
                    orderStatusDetail.time = Utility.stringToString(strDate:details.date, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.TIME_FORMAT_AM_PM)
                    orderStatusDetail.status = details.status
                    self.arrForDeliveryDetails.append(orderStatusDetail)
                }

                for details in self.orderStatusReponse.deliveryStatusDetails {
                    let orderStatusDetail:OrderDateWiseStatusDetails = OrderDateWiseStatusDetails.init(fromDictionary: [:])
                    orderStatusDetail.date =      Utility.relativeDateStringForDate(strDate: Utility.stringToString(strDate: details.date, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_TIME_FORMAT_HISTORY, locale: "en_GB"), dateFormate: DATE_CONSTANT.DATE_TIME_FORMAT_HISTORY) as String
                    orderStatusDetail.time = Utility.stringToString(strDate:details.date, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.TIME_FORMAT_AM_PM)
                    orderStatusDetail.status = details.status
                    orderStatusDetail.imageUrl = details.imageUrl
                    self.arrForDeliveryDetails.append(orderStatusDetail)
                }

                for orderStatusDetails in self.arrForDeliveryDetails {
                    let orderStatus =  OrderStatus.init(rawValue: orderStatusDetails.status) ?? OrderStatus.Unknown

                    if  (orderStatus.toInt() > self.selectedOrder.store_detail!.cancellation_charge_apply_till){
                        self.btnCancelOrder.isHidden = true
                    }else{
                        self.btnCancelOrder.isHidden = false
                    }


                    //                    if (orderStatus.rawValue <= OrderStatus.STORE_ACCEPTED) && (orderStatus.rawValue > OrderStatus.DELIVERY_MAN_ARRIVED) {
                    //                                            self.btnCancelOrder.isHidden = false
                    //                                        }else{
                    //                                            self.btnCancelOrder.isHidden = true
                    //                                        }
                    //                    self.btnCancelOrder.isHidden = true

                    self.viewForDeliverymanChat.isHidden = true
                    self.isDeliverymanChatVisible = false
                    self.heightForSearchView.constant = 80
                    print("orderStatus ----- \(orderStatus)")
                    self.btnViewInvoice.isHidden = true

                    switch (orderStatus)
                    {
                        case OrderStatus.STORE_ACCEPTED:
                            self.lblAcceptedDate.text = orderStatusDetails.date
                            self.lblAcceptedTime.text = orderStatusDetails.date
                            self.btnRateProvider.isHidden = true
                            self.btnRateStore.isHidden = true
                            break
                        case OrderStatus.ORDER_READY:
                            self.lblPreparedDate.text = orderStatusDetails.date
                            self.lblPreparedTime.text = orderStatusDetails.date
                            self.btnRateProvider.isHidden = true
                            self.btnRateStore.isHidden = true
                            break
                        case OrderStatus.CUSTOMER_ARRIVED:
                            self.lblPreparedDate.text = orderStatusDetails.date
                            self.lblPreparedTime.text = orderStatusDetails.date
                            self.btnRateProvider.isHidden = true
                            self.btnRateStore.isHidden = true
                            break
                        case OrderStatus.DELIVERY_MAN_PICKED_ORDER:
                            self.pickupImgUrl = orderStatusDetails.imageUrl
                            self.btnPickupImage.isHidden = self.pickupImgUrl.isEmpty
                            self.viewForDeliverymanChat.isHidden = false
                            self.isDeliverymanChatVisible = true
                            self.heightForSearchView.constant = 110
                            self.btnRateProvider.isHidden = true
                            self.btnRateStore.isHidden = true
                            break

                        case OrderStatus.DELIVERY_MAN_STARTED_DELIVERY:
                            self.lblStartDeliveryDate.text = orderStatusDetails.date
                            self.lblStartDeliveryTime.text = orderStatusDetails.date
                            self.viewForDeliverymanChat.isHidden = false
                            self.isDeliverymanChatVisible = true
                            self.heightForSearchView.constant = 110
                            self.btnRateProvider.isHidden = true
                            self.btnRateStore.isHidden = true
                            break

                        case OrderStatus.DELIVERY_MAN_ARRIVED_AT_DESTINATION:
                            self.lblDeliveryCompleteDate.text = orderStatusDetails.date
                            self.lblDeliveryCompleteTime.text = orderStatusDetails.date
                            self.completeImgUrl = orderStatusDetails.imageUrl
                            self.btnCompleteImage.isHidden = self.completeImgUrl.isEmpty
                            self.viewForDeliverymanChat.isHidden = false
                            self.isDeliverymanChatVisible = true
                            self.heightForSearchView.constant = 110
                            self.btnRateProvider.isHidden = true
                            self.btnRateStore.isHidden = true
                            break

                        case OrderStatus.DELIVERY_MAN_COMPLETE_DELIVERY:
                            self.lblDeliveryCompleteDate.text = orderStatusDetails.date
                            self.lblDeliveryCompleteTime.text = orderStatusDetails.date
                            self.btnCancelOrder.isHidden = true

                            if self.orderStatusReponse.provider_detail == nil{
                                self.btnRateProvider.isHidden = true
                            }else{
                                self.btnRateProvider.isHidden = false
                            }
                            self.btnRateStore.isHidden = false
                            self.btnViewInvoice.isHidden = false
                            break
                        case OrderStatus.WAITING_FOR_ACCEPT_STORE:
                            self.btnRateProvider.isHidden = true
                            self.btnRateStore.isHidden = true
                            break
                        case OrderStatus.STORE_PREPARING_ORDER:
                            self.btnRateProvider.isHidden = true
                            self.btnRateStore.isHidden = true
                            break
                        case OrderStatus.WAITING_FOR_DELIVERY_MAN:
                            self.btnRateProvider.isHidden = true
                            self.btnRateStore.isHidden = true
                            break
                        case OrderStatus.DELIVERY_MAN_ACCEPTED:
                            self.btnRateProvider.isHidden = true
                            self.btnRateStore.isHidden = true
                            break
                        case OrderStatus.DELIVERY_MAN_COMING:
                            self.btnRateProvider.isHidden = true
                            self.btnRateStore.isHidden = true
                            break
                        case OrderStatus.DELIVERY_MAN_ARRIVED:
                            self.btnRateProvider.isHidden = true
                            self.btnRateStore.isHidden = true
                            break

                        default :
                            break
                    }
                }
                
                if self.selectedOrder.cartDetail!.storeId == nil {
                    self.heightForSearchView.constant = self.heightForSearchView.constant - 30
                }
            }
        }
    }

    func updateDateUI(status:OrderStatus,response:OrderStatusResponse) {

        self.btnViewInvoice.isHidden = true

        switch (status) {
            case OrderStatus.WAITING_FOR_ACCEPT_STORE:
                lblAcceptedDate.text = ""
                lblAcceptedTime.text = ""

            case OrderStatus.STORE_ACCEPTED:
                if   let orderDetail = orderStatusReponse.orderStatusDetails.first(where: { (statusDetail) -> Bool in
                    statusDetail.status == status.rawValue
                }) {
                    self.lblAcceptedDate.text = Utility.stringToString(strDate: orderDetail.date, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_FORMAT)
                    self.lblAcceptedTime.text = Utility.stringToString(strDate: orderDetail.date, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.TIME_FORMAT_HH_MM)
                }
                break
            case  OrderStatus.STORE_PREPARING_ORDER:

                if   let orderDetail = orderStatusReponse.orderStatusDetails.first(where: { (statusDetail) -> Bool in
                    statusDetail.status == status.rawValue
                }) {
                    self.lblPreparedDate.text = Utility.stringToString(strDate: orderDetail.date, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_FORMAT)
                    self.lblPreparedTime.text = Utility.stringToString(strDate: orderDetail.date, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.TIME_FORMAT_HH_MM)
                }

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
                btnCancelOrder.setTitleColor(UIColor.themeColor, for: .normal)
                btnToPrepareOrder.setTitleColor(UIColor.themeColor, for: .normal)
                btnTrackOrder.setTitleColor(UIColor.themeColor, for: .normal)
                btnViewInvoice.setTitleColor(UIColor.themeColor, for: .normal)

                break
            case OrderStatus.DELIVERY_MAN_STARTED_DELIVERY:

                btnOrderAccepted.isSelected = true
                btnOrderPrepared.isSelected = true
                btnOrderOnTheWay.isSelected = true
                btnOrderOnDoorStep.isSelected = false
                btnRateProvider.isHidden = true
                btnRateStore.isHidden = true
                btnCancelOrder.setTitleColor(UIColor.themeColor, for: .normal)
                btnToPrepareOrder.setTitleColor(UIColor.themeColor, for: .normal)
                btnTrackOrder.setTitleColor(UIColor.themeColor, for: .normal)
                btnViewInvoice.setTitleColor(UIColor.themeColor, for: .normal)
                break
            
            case OrderStatus.DELIVERY_MAN_ARRIVED_AT_DESTINATION:
                btnOrderAccepted.isSelected = true
                btnOrderPrepared.isSelected = true
                btnOrderOnTheWay.isSelected = false
                btnOrderOnDoorStep.isSelected = false
                btnRateProvider.isHidden = true
                btnRateStore.isHidden = true
                btnCancelOrder.setTitleColor(UIColor.themeColor, for: .normal)
                btnToPrepareOrder.setTitleColor(UIColor.themeColor, for: .normal)
                btnTrackOrder.setTitleColor(UIColor.themeColor, for: .normal)
                btnViewInvoice.setTitleColor(UIColor.themeColor, for: .normal)
                break
            
            case OrderStatus.DELIVERY_MAN_COMPLETE_DELIVERY:
                timerForOrderStatus?.invalidate()
                dialogForConfirmCode?.removeFromSuperview()
                btnOrderAccepted.isSelected = true
                btnOrderPrepared.isSelected = true
                btnOrderOnTheWay.isSelected = true
                btnOrderOnDoorStep.isSelected = true
                btnRateProvider.isHidden = false
                btnRateStore.isHidden = false
                self.btnViewInvoice.isHidden = false
                btnCancelOrder.setTitleColor(UIColor.themeColor, for: .normal)
                btnToPrepareOrder.setTitleColor(UIColor.themeColor, for: .normal)
                btnTrackOrder.setTitleColor(UIColor.themeColor, for: .normal)
                btnViewInvoice.setTitleColor(UIColor.themeColor, for: .normal)
                if self.navigationController?.visibleViewController == self {
                }
                return
            
            case OrderStatus.STORE_REJECTED:
                timerForOrderStatus?.invalidate()
                self.navigationController?.popViewController(animated: true)
                break
            case OrderStatus.STORE_CANCELLED:
                timerForOrderStatus?.invalidate()
                self.navigationController?.popViewController(animated: true)
                break
            default:
                break
        }
    }

    func updateStatusUI(isConfirmationCodeRequired:Bool, isUserWillPickupDelivery:Bool,isConfirmationCodeRequiredAtPickup:Bool) {
        setUpStoreDetail()
        btnGetCode.isHidden = !isConfirmationCodeRequired
        viewForOnTheWay.isHidden = isUserWillPickupDelivery
        let onTheWayTitle = isUserWillPickupDelivery ? ("TXT_3".localized) : ("TXT_4".localized)
        btnOrderOnDoorStep.setTitle(onTheWayTitle, for: .normal)
        viewForEstTime.isHidden = true
        lblEstDeliveryTime.isHidden = true
    }

    func updateTableBookingStatusUI() {
        if self.stkVWTableBooking.isHidden {
            self.imgTableBooking.image = self.imgTableBooking.image?.imageWithColor(color: .themeTextColor)
            self.stkVWTableBooking.isHidden = false
            heightForView.constant = 160
            self.lblTableBooking.text = String(format: "MSG_TABLE_BOOK".localized,            self.selectedOrder.cartDetail!.table_no,self.selectedOrder.cartDetail!.no_of_persons)
            self.lblTableBookScheduleTime.text = "MSG_TABLE_BOOK_SCHEDULE_TIME_DATE".localized + String( Utility.relativeDateStringForDate(strDate: Utility.stringToString(strDate: self.selectedOrder.cartDetail?.createdAt ?? "", fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_TIME_FORMAT_HISTORY,locale: "en_US"),dateFormate: DATE_CONSTANT.DATE_TIME_FORMAT_HISTORY)) //as String
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
            heightForView.constant = 160
            self.lblTableBooking.text = "TXT_SCHEDULED_ORDER".localized
            self.lblTableBookScheduleTime.text = "MSG_TABLE_BOOK_SCHEDULE_TIME_DATE".localized + String( Utility.relativeDateStringForDate(strDate: Utility.stringToString(strDate: self.selectedOrder.cartDetail?.createdAt ?? "", fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_TIME_FORMAT_HISTORY,locale: "en_US"),dateFormate: DATE_CONSTANT.DATE_TIME_FORMAT_HISTORY)) //as String
        }
    }

    func setUpStoreDetail() {
        lblStoreName.text = "\((self.orderStatusReponse.pickupAddresses.first)?.userDetails?.name ?? "")"
        lblStoreAddress.text = "\((self.orderStatusReponse.pickupAddresses.first)?.address ?? "")"
        guard let storeImageUrl = ((self.orderStatusReponse.pickupAddresses.first) as? Address)?.userDetails?.imageUrl else { return  }
        imgStore.downloadedFrom(link: Utility.getDynamicResizeImageURL(width: imgStore.frame.size.width, height: imgStore.frame.size.height, imgUrl: storeImageUrl), isFromResize: true)
    }
    
    func wsGetCancelReasonList(cancellationCharge:Double) {
        
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
            self?.openCancelOrderDialog(cancellationCharge: cancellationCharge, list: arrList)
        }
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

    func wsGetCancellationCharge() {
        Utility.showLoading()
        let dictParam: Dictionary<String,Any> =
            [PARAMS.USER_ID:preferenceHelper.getUserId(),
             PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken(),
             PARAMS.ORDER_ID:selectedOrder._id ?? ""
            ]

        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_GET_CANCELLATION_CHARGES, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response) {
                self.wsGetCancelReasonList(cancellationCharge: response[PARAMS.CANCELLATION_CHARGE] as? Double ?? 0)
            }
        }
    }

    //MARK: - ACTION METHODS
    @objc func tapOnPrepareOrder(sender:UIButton) {
        if (selectedOrder.cartDetail?.orderDetails.isEmpty) ?? true {
            Utility.showToast(message: "MSG_ORDER_DETAIL_NOT_AVAILABLE".localized)
        } else {
            openViewDetailDialogue(isBtnCofirmPressed: self.orderStatusReponse.orderChange)
        }
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

    @IBAction func checkOrderPressed(_ sender: Any) {
        if (selectedOrder.cartDetail?.orderDetails.isEmpty) ?? true {
            Utility.showToast(message: "MSG_ORDER_DETAIL_NOT_AVAILABLE".localized)
        } else {
            self.performSegue(withIdentifier: SEGUE.SEGUE_PREPARE_ORDER, sender: btnUserConfirm)
        }
    }

    @objc func tapOnOrderCancel(sender:Any) {
        self.wsGetCancellationCharge()
    }

    @objc func tapOnGetCode(sender:Any) {
        openConfirmationDialog()
    }
    
    @objc func tapOnGetPickupCode(sender:Any) {
        openConfirmationDialog()
    }

    @objc func tapOnViewInvoice(sender:Any) {
        openOrderInvoiceDialogue()
    }

    @IBAction func onClickBtnRateProvider(_ sender: UIButton)  {
        openFeedbackDialogue(isRateProvider: true)
    }

    @IBAction func onClickBtnRateStore(_ sender: UIButton)  {
        openFeedbackDialogue(isRateProvider: false)
    }

    //MARK: - USER DEFINE FUNCTION
    @IBAction func closePressed(_ sender: UIButton) {
        viewImage.isHidden = true
    }
    
    @IBAction func pickupPressed(_ sender: UIButton) {
        
        self.openViewImageDialogue(link: pickupImgUrl, isPickupImage: true)
    }
    @IBAction func completeImagePressed(_ sender: UIButton) {

        self.openViewImageDialogue(link: completeImgUrl, isPickupImage:  false)
    }
    
    func resetTimer() {
        timerForOrderStatus?.invalidate()
        
        wsGetOrderStatus()
        
        Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self]  (timer) in
            self?.wsGetOrderStatus()
        }
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
            
            print("response WS_GET_ORDER_DETAIL --> \(Utility.convertDictToJson(dict: response as! Dictionary<String, Any>))")

            Parser.parseCurrentOrder(response, completion: { (result,order)   in
                if result {
                    currentBooking.selectedOrderId = order._id
                    self.selectedOrder.cartDetail =  order.cartDetail
                    self.selectedOrder.unique_id = order.unique_id ?? 0
                    self.selectedOrder.order_status = order.order_status ?? 0
                    self.selectedOrder.store_detail = order.store_detail
                    self.selectedOrder.store_detail!.storeTaxDetails = order.store_detail?.storeTaxDetails
                    self.selectedOrder.table_settings_details = order.table_settings_details
                    self.selectedOrder.schedule_order_start_at = order.schedule_order_start_at
                    self.selectedOrder.server_time = (response["server_time"] as? String)
                    self.selectedOrder.timezone = order.timezone
                    self.selectedOrder.total = order.total

                    DispatchQueue.main.async {
                        
                        if self.selectedOrder.cartDetail!.storeId == nil {
                            self.viewForStoreChat.isHidden = true
                        }else{
                            self.viewForStoreChat.isHidden = false
                        }
                    
                    }
                    self.resetTimer()
                }else {
                    Utility.hideLoading()
                    APPDELEGATE.goToMain()
                }
            })
        }
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> String {
        return " \(seconds / 3600) hr : \((seconds % 3600) / 60) min"
    }
    
    func checkForOrderStatus(orderStatusValue:Int) {
        self.btnViewInvoice.isHidden = true

        let orderStatus:OrderStatus = OrderStatus(rawValue: orderStatusValue) ?? .Unknown
        
        switch (orderStatus) {
            case OrderStatus.WAITING_FOR_ACCEPT_STORE:

                btnCancelOrder.setTitleColor(UIColor.themeColor, for: .normal)
                btnRateProvider.isHidden = true
                btnRateStore.isHidden = true

            case OrderStatus.STORE_ACCEPTED,OrderStatus.STORE_PREPARING_ORDER:

                btnOrderAccepted.isSelected = true
                btnOrderPrepared.isSelected = false
                btnRateProvider.isHidden = true
                btnRateStore.isHidden = true

                break

            case OrderStatus.ORDER_READY,
                 OrderStatus.DELIVERY_MAN_ACCEPTED,
                 OrderStatus.DELIVERY_MAN_COMING,
                 OrderStatus.DELIVERY_MAN_REJECTED,
                 OrderStatus.DELIVERY_MAN_ARRIVED,
                 OrderStatus.CUSTOMER_ARRIVED,
                 OrderStatus.DELIVERY_MAN_PICKED_ORDER,
                 OrderStatus.WAITING_FOR_DELIVERY_MAN,
                 OrderStatus.STORE_CANCELLED_REQUEST,
                 OrderStatus.NO_DELIVERY_MAN_FOUND:

                btnOrderAccepted.isSelected = true
                btnOrderPrepared.isSelected = true
                btnOrderOnTheWay.isSelected = false
                btnRateProvider.isHidden = true
                btnRateStore.isHidden = true


                break
            case OrderStatus.DELIVERY_MAN_STARTED_DELIVERY:

                btnOrderAccepted.isSelected = true
                btnOrderPrepared.isSelected = true
                btnOrderOnTheWay.isSelected = true
                btnOrderOnDoorStep.isSelected = false
                btnRateProvider.isHidden = true
                btnRateStore.isHidden = true
                btnCancelOrder.setTitleColor(UIColor.themeColor, for: .normal)
                btnToPrepareOrder.setTitleColor(UIColor.themeColor, for: .normal)
                btnTrackOrder.setTitleColor(UIColor.themeColor, for: .normal)
                btnViewInvoice.setTitleColor(UIColor.themeTextColor, for: .normal)
                break
            
            case OrderStatus.DELIVERY_MAN_ARRIVED_AT_DESTINATION:

                btnOrderAccepted.isSelected = true
                btnOrderPrepared.isSelected = true
                btnOrderOnTheWay.isSelected = true
                btnOrderOnDoorStep.isSelected = true
                btnRateProvider.isHidden = true
                btnRateStore.isHidden = true
                btnCancelOrder.setTitleColor(UIColor.themeColor, for: .normal)
                btnToPrepareOrder.setTitleColor(UIColor.themeColor, for: .normal)
                btnTrackOrder.setTitleColor(UIColor.themeColor, for: .normal)
                btnViewInvoice.setTitleColor(UIColor.themeColor, for: .normal)
                btnRateProvider.isHidden = true
                btnRateStore.isHidden = true
                break
            
            case OrderStatus.DELIVERY_MAN_COMPLETE_DELIVERY:
                btnOrderAccepted.isSelected = true
                btnOrderPrepared.isSelected = true
                btnOrderOnTheWay.isSelected = true
                btnOrderOnDoorStep.isSelected = true
                btnCancelOrder.setTitleColor(UIColor.themeColor, for: .normal)
                btnToPrepareOrder.setTitleColor(UIColor.themeColor, for: .normal)
                btnTrackOrder.setTitleColor(UIColor.themeColor, for: .normal)
                btnViewInvoice.setTitleColor(UIColor.themeColor, for: .normal)
                btnRateProvider.isHidden = false
                btnRateStore.isHidden = false
                btnViewInvoice.isHidden = false
                timerForOrderStatus?.invalidate()
                timerForOrderStatus = nil
                dialogForConfirmCode?.removeFromSuperview()
                return
            case OrderStatus.STORE_REJECTED:
                timerForOrderStatus?.invalidate()
                self.navigationController?.popViewController(animated: true)
                break
            case OrderStatus.STORE_CANCELLED:
                timerForOrderStatus?.invalidate()
                self.navigationController?.popViewController(animated: true)
                break
            default:
                break
        }
    }
    func openImage(link:String) {
        viewImage.isHidden = false
        imgContactLess.downloadedFrom(link: link,mode: .scaleAspectFit)
    }
    func openViewImageDialogue(link:String, isPickupImage:Bool) {
        let strTitle = isPickupImage ? "TXT_PICKUP_IMAGE".localized : "TXT_DELIVERY_IMAGE".localized
        let  dialogForViewImage = CustomDialogViewImage.showCustomDialogViewImage(title: strTitle, message: "", imgUrlToView:  link)
        
    }
    func openViewDetailDialogue(isBtnCofirmPressed: Bool)  {

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderBeingPrepared") as! OrderBeingPrepared
        let currentOrder = self.selectedOrder
        if (currentOrder.store_id ?? "").isEmpty {
            currentOrder.store_id = orderStatusReponse.storeId
        }
        currentOrder.currency = orderStatusReponse.currency
        OrderBeingPrepared.selectedOrder =  currentOrder
        print("OrderBeingPrepared.selectedOrder.store_id => ", OrderBeingPrepared.selectedOrder.store_id ?? "")
        vc.delegateTapOnConfirm = self
        let nav = UINavigationController.init(rootViewController: vc)
        nav.setNavigationBarHidden(true, animated: false)
        nav.modalPresentationStyle = .overCurrentContext

        if isBtnCofirmPressed {
            vc.isfromConfirm = true
        }

        self.present(nav, animated: false, completion: nil)
    }
    func didTapOnConfirm() {
        wsGetOrderDetail()
    }
    func openProviderTrackDialogue()  {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProviderTrack") as! ProviderTrack
        let nav = UINavigationController.init(rootViewController: vc)
        nav.setNavigationBarHidden(true, animated: false)
        nav.modalPresentationStyle = .overCurrentContext
        vc.selectedOrderStatus = self.orderStatusReponse
        self.present(nav, animated: false, completion: nil)
    }
    func openOrderInvoiceDialogue()  {
        
        let invoiceVC = self.storyboard?.instantiateViewController(withIdentifier: "HistoryInvoiceVC") as! HistoryInvoiceVC
        invoiceVC.modalPresentationStyle = .overCurrentContext
        invoiceVC.isFromHistory = false
        invoiceVC.strOrderID = selectedOrder._id ?? ""
        self.present(invoiceVC, animated: false, completion: nil)
    }
    func openFeedbackDialogue(isRateProvider:Bool)  {
        var name = ""
        let providerName = orderStatusReponse.provider_detail?.name ?? ""
        let storeName = selectedOrder.store_name
        name =  ((isRateProvider) ? providerName : storeName) ?? ""
        dialogForFeedback = DailogForFeedback.showCustomFeedbackDialog(isRateProvider, false, selectedOrder._id!, name: name)
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
    func openChatDialog() {
        let dialogForChat  = DialogForChatVC.showCustomChatDialog(DeliverymanChatVisible: isDeliverymanChatVisible)
        dialogForChat.onClickStoreButton = { [unowned dialogForChat] in
            dialogForChat.removeFromSuperview();
            MessageHandler.ReceiverID = self.selectedOrder.cartDetail!.storeId!
            print("store MessageHandler.ReceiverID \(MessageHandler.ReceiverID)")
            self.chatNavTitle = self.selectedOrder.store_name ?? "Store"
            self.pushChatVC(ind: CONSTANT.CHATTYPES.USER_AND_STORE)
        }
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
    
    // MARK:- Dialogs
    func openConfirmationDialog() {
        dialogForConfirmCode = CustomAlertDialog.showCustomAlertDialog(title: "TXT_CONFIRMATION_CODE".localized, message: String(self.orderStatusReponse.confirmationCodeForCompleteDelivery!) , titleLeftButton: "".localizedCapitalized, titleRightButton: "TXT_SHARE".localizedCapitalized)
        dialogForConfirmCode?.onClickLeftButton = { [unowned self, weak dialogForConfirmCode = self.dialogForConfirmCode] in

            self.dialogForConfirmCode?.removeFromSuperview()
        }
        dialogForConfirmCode?.onClickRightButton = { [unowned self, weak dialogForConfirmCode = self.dialogForConfirmCode] in

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
        
        dialogForConfirmCode = CustomAlertDialog.showCustomAlertDialog(title: "TXT_CONFIRMATION_CODE".localized, message: String(self.orderStatusReponse.confirmationCodeForCompleteDelivery!) , titleLeftButton: "".localizedUppercase, titleRightButton: "TXT_SHARE".localizedUppercase)
        dialogForConfirmCode?.onClickLeftButton = { [unowned self, weak dialogForConfirmCode = self.dialogForConfirmCode] in

            self.dialogForConfirmCode?.removeFromSuperview()
        }
        dialogForConfirmCode?.onClickRightButton = { [unowned self, weak dialogForConfirmCode = self.dialogForConfirmCode] in
            let myString = String(format: NSLocalizedString("SHARE_CONFIRM_CODE", comment: ""),String(self.orderStatusReponse.confirmationCodeForCompleteDelivery))
            let textToShare = [ myString ]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
            self.present(activityViewController, animated: true, completion: nil)
            self.dialogForConfirmCode?.removeFromSuperview()
        }
    }

    func openCancelOrderDialog(cancellationCharge:Double, list: [String]) {
        var charge:String = ""
        if cancellationCharge > 0 {
            charge = self.orderStatusReponse.currency + " " + cancellationCharge.toString(decimalPlaced: 2)
        }

        dialogForCancelOrder = CustomCancelOrderDialog.showCustomCancelOrderDialog(title: "TXT_CANCEL_ORDER".localized, message: "", cancelationCharge: charge, titleLeftButton: "".localizedCapitalized, titleRightButton: "TXT_OK".localizedCapitalized, list: list)
        dialogForCancelOrder?.onClickLeftButton = { [unowned self,weak dialogForCancelOrder = self.dialogForCancelOrder] in
        }
        dialogForCancelOrder?.onClickRightButton = { [unowned self,weak dialogForCancelOrder = self.dialogForCancelOrder] (cancelReason:String) in
            self.wsCancelOrder(reason: cancelReason)
            self.dialogForCancelOrder?.removeFromSuperview()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier?.compare(SEGUE.SEGUE_PREPARE_ORDER) == ComparisonResult.orderedSame) {
            let prepareOrder = segue.destination as! OrderBeingPrepared
            if (sender as? UIButton) == btnUserConfirm {
                prepareOrder.isfromConfirm = true
            }
            OrderBeingPrepared.selectedOrder = selectedOrder
        } else if (segue.identifier?.compare(SEGUE.ORDER_STATUS_TO_INVOICE) == ComparisonResult.orderedSame) {
            let invoiceVC = segue.destination as! HistoryInvoiceVC
            invoiceVC.strOrderID = selectedOrder._id ?? ""
            invoiceVC.name = self.orderStatusReponse.provider_detail?.name ?? ""
            invoiceVC.imgurl = self.orderStatusReponse.providerImage
        } else if (segue.identifier?.compare(SEGUE.ORDER_STATUS_TO_TRACK_ORDER) == ComparisonResult.orderedSame) {
            let providerTrack = segue.destination as! ProviderTrack
            providerTrack.selectedOrderStatus = self.orderStatusReponse
        }
    }
}
