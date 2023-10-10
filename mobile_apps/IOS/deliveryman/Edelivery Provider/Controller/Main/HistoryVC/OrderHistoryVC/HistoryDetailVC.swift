//
//  HistoryDetailVC.swift
//  Edelivery Provider
//
//  Created by Elluminati iMac on 03/05/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit

class HistoryDetailVC: BaseVC, UITableViewDelegate, UITableViewDataSource,RightDelegate {
    
//MARK: Outlets
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var viewForHeader: UIView!
    @IBOutlet weak var viewForStoreRate: UIView!
    @IBOutlet weak var btnRateStore: UIButton!
    @IBOutlet weak var lblStoreDetail: UILabel!
    @IBOutlet weak var lblStoreName: UILabel!
    @IBOutlet weak var imgStorePic: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewForFooter: UIView!
    @IBOutlet weak var viewForUserRate: UIView!
    @IBOutlet weak var btnRateProvider: UIButton!
    @IBOutlet weak var lblUserDetail: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgUserProfilePic: UIImageView!
    @IBOutlet weak var lblEstTime: UILabel!
    @IBOutlet weak var lblEstTimeValue: UILabel!
    @IBOutlet weak var lblEstDistance: UILabel!
    @IBOutlet weak var lblEstDistanceValue: UILabel!
    @IBOutlet weak var lblOrderNumber: UILabel!
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
    @IBOutlet weak var lblStatusDetail: UILabel!
    @IBOutlet weak var imgForStoreRate : UIImageView!
    @IBOutlet weak var imgForUserRate : UIImageView!
    @IBOutlet weak var imgForTime: UIImageView!
    @IBOutlet weak var imgForDistance: UIImageView!
    @IBOutlet weak var btnClose : UIButton!
    
    @IBOutlet weak var tblAddress : UITableView!
    @IBOutlet weak var heightAddress : NSLayoutConstraint!
    @IBOutlet weak var heightItemList : NSLayoutConstraint!
    
    let btnInvoice = UIButton.init(type: .custom)
    var arrForItems = NSMutableArray()
    var arrOrderDetails : [CartProduct] = []
    var currency: String = ""
    var payment: String = ""
    public var strOrderID: String = ""
    public var isRateToUser:Bool = false
    var storeDetail:HistoryStoreDetail?
    var userDetail:HistoryUserDetails?
    var cartDetail:CartDetail?
    var orderDetailNew:OrderDetail?
    var orderPayment:OrderPayment?

    var OrderStatusValue:Int = 0
    var orderDetail:Request?
    var pickupImgUrl = ""
    var completeImgUrl = ""
    
    var arrStatusDetails = [OrderDateWiseStatusDetails]()
    var arrAddress = [Address]()
    
    //MARK:
    //MARK: View life cycle
    override func viewDidLoad(){
        super.viewDidLoad()
        self.viewImage.isHidden = true
        setLocalization()
        setTableView()
    }
    override func updateUIAccordingToTheme() {
        imgForTime.image = UIImage.init(named: "time_icon")?.imageWithColor(color: .themeIconTintColor)
        imgForDistance.image = UIImage.init(named: "distance_icon")?.imageWithColor(color: .themeIconTintColor)
        btnRateProvider.setImage(UIImage.init(named: "star_rate")?.imageWithColor(), for: .normal)
        btnRateStore.setImage(UIImage.init(named: "star_rate")?.imageWithColor(), for: .normal)
        if self.storeDetail != nil {
            self.setStoreDetail(data: self.storeDetail!)
        }
        if self.orderDetail != nil {
            self.setOrderListDetail(data: self.orderDetail!)
        }
        self.checkForOrderStatus(orderStatusValue: OrderStatusValue)
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tblAddress.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        wsGetHistoryDetail()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tblAddress.removeObserver(self, forKeyPath: "contentSize")
        tableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        heightAddress.constant = tblAddress.contentSize.height
        heightItemList.constant = tableView.contentSize.height
    }
    
    //MARK:
    //MARK: Set localized layout
    func setLocalization() {
        delegateRight = self
        lblStatusDetail.sizeToFit()
        lblStatusDetail.text = "TXT_STATUS_DETAILS".localizedUppercase
        
        //Status Chnages
        lblOrderAccepted.text = "TXT_ORDER_ACCEPTED".localized
        lblOrderPrepared.text = "TXT_STATUS_PICKEDUP_FROM_STORE".localized
        lblOrderTheWay.text = "TXT_STATUS_ARRIVED_AT_DESTINATION".localized
        lblOrderOnDoorStep.text = "TXT_STATUS_DELIVERED_TO_USER".localized
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
        lblAcceptedDate.textColor = UIColor.themeLightTextColor
        lblAcceptedTime.textColor = UIColor.themeLightTextColor
        lblPreparedDate.textColor = UIColor.themeLightTextColor
        lblPreparedTime.textColor = UIColor.themeLightTextColor
        lblStartDeliveryDate.textColor = UIColor.themeLightTextColor
        lblStartDeliveryTime.textColor = UIColor.themeLightTextColor
        lblDeliveryCompleteDate.textColor = UIColor.themeLightTextColor
        lblDeliveryCompleteTime.textColor = UIColor.themeLightTextColor
        lblAcceptedDate.font = FontHelper.textSmall()
        lblAcceptedTime.font = FontHelper.textSmall()
        lblPreparedDate.font = FontHelper.textSmall()
        lblPreparedTime.font = FontHelper.textSmall()
        lblStartDeliveryDate.font = FontHelper.textSmall()
        lblStartDeliveryTime.font = FontHelper.textSmall()
        lblDeliveryCompleteDate.font = FontHelper.textSmall()
        lblDeliveryCompleteTime.font = FontHelper.textSmall()
        lblOrderAccepted.textColor = UIColor.themeTextColor
        lblOrderPrepared.textColor = UIColor.themeTextColor
        lblOrderTheWay.textColor = UIColor.themeTextColor
        lblOrderOnDoorStep.textColor = UIColor.themeTextColor
        btnOrderAccepted.backgroundColor = UIColor.themeViewBackgroundColor
        btnOrderPrepared.backgroundColor = UIColor.themeViewBackgroundColor
        btnOrderOnTheWay.backgroundColor = UIColor.themeViewBackgroundColor
        btnOrderOnDoorStep.backgroundColor = UIColor.themeViewBackgroundColor
        btnCompleteImage.backgroundColor = UIColor.lightGray
        btnPickupImage.backgroundColor = UIColor.lightGray
        btnCompleteImage.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnPickupImage.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnPickupImage.setRound(withBorderColor: .clear, andCornerRadious: 5, borderWidth: 0)
        btnCompleteImage.setRound(withBorderColor: .clear, andCornerRadious: 5, borderWidth: 0)
        
        /*Set Font*/
        btnOrderAccepted.titleLabel?.font = FontHelper.textRegular()
        btnOrderPrepared.titleLabel?.font = FontHelper.textRegular()
        btnOrderOnTheWay.titleLabel?.font = FontHelper.textRegular()
        btnOrderOnDoorStep.titleLabel?.font = FontHelper.textRegular()
        btnPickupImage.titleLabel?.font = FontHelper.tiny()
        btnCompleteImage.titleLabel?.font = FontHelper.tiny()
        lblOrderAccepted.font = FontHelper.textRegular()
        lblOrderPrepared.font = FontHelper.textRegular()
        lblOrderTheWay.font = FontHelper.textRegular()
        lblOrderOnDoorStep.font = FontHelper.textRegular()
        tableView.tableHeaderView = viewForHeader
        tableView.estimatedRowHeight = 30
        tableView.rowHeight = UITableView.automaticDimension
        lblStoreDetail.text = "TXT_ORDER_DETAILS".localizedUppercase
        lblUserDetail.text = "TXT_DELIVERY_DETAILS".localizedUppercase
        btnInvoice.setTitle("" , for: UIControl.State.normal)
        btnInvoice.backgroundColor = UIColor.themeViewBackgroundColor
        btnInvoice.tintColor = .themeColor
        btnInvoice.setImage(UIImage.init(named: "icon_history")?.imageWithColor(), for: .normal)
        btnInvoice.setTitleColor(UIColor.themeColor, for: .normal)
        
        self.setRightBarButton(button: btnInvoice);
       
        //COLORS
        view.backgroundColor = UIColor.themeViewBackgroundColor
    
        lblStoreName.textColor = UIColor.themeTextColor
        lblUserName.textColor = UIColor.themeTextColor
        lblEstTime.textColor = UIColor.themeLightTextColor
        lblEstDistance.textColor = UIColor.themeLightTextColor
        lblEstTimeValue.textColor = UIColor.themeTextColor
        lblEstDistanceValue.textColor = UIColor.themeTextColor
        lblDate.textColor = UIColor.themeTextColor
        lblOrderNumber.font = FontHelper.textRegular()
        btnRateStore.setTitleColor(UIColor.themeColor, for: .normal)
        btnRateProvider.setTitleColor(UIColor.themeColor, for: .normal)
        lblOrderNumber.textColor = UIColor.themeLightTextColor
        imgForTime.image = UIImage.init(named: "time_icon")?.imageWithColor(color: .themeIconTintColor)
        imgForDistance.image = UIImage.init(named: "distance_icon")?.imageWithColor(color: .themeIconTintColor)
        btnClose.tintColor = .themeColor
        btnClose.setImage(UIImage.init(named: "cancel_icon")?.imageWithColor(), for: .normal)
        imgContactLess.setRound(withBorderColor: .clear, andCornerRadious: 5, borderWidth: 0)
        viewImage.backgroundColor = .themeOverlayColor
        title = "TITLE_HISTORY_DETAIL".localized
        lblEstTime.text = "TXT_TIME_HH_MM".localized
        lblEstDistance.text = "TXT_DISTANCE".localized
        btnRateStore.setTitle("", for: .normal)
        btnRateProvider.setTitle("", for: .normal)
        lblStoreDetail.sizeToFit();
        lblUserDetail.sizeToFit();
        self.hideBackButtonTitle()
        
        /* Set Font */
        lblStoreName.font = FontHelper.textMedium()
        lblUserName.font = FontHelper.textMedium()
        lblEstTime.font = FontHelper.labelRegular()
        lblEstDistance.font = FontHelper.labelRegular()
        lblEstTimeValue.font = FontHelper.textRegular()
        lblEstDistanceValue.font = FontHelper.textRegular()
        lblDate.font = FontHelper.textRegular()
        btnRateStore.titleLabel?.font = FontHelper.textRegular()
        btnRateProvider.titleLabel?.font = FontHelper.textRegular()
        btnRateProvider.isHidden = false
        btnInvoice.titleLabel?.font = FontHelper.textSmall()
        btnRateProvider.setImage(UIImage.init(named: "star_rate")?.imageWithColor(), for: .normal)
        btnRateStore.setImage(UIImage.init(named: "star_rate")?.imageWithColor(), for: .normal)
        btnRateProvider.tintColor =  UIColor.themeColor
        btnRateStore.tintColor = UIColor.themeColor
    }
    
    func setupLayout() {
        btnInvoice.setRound(withBorderColor: UIColor.clear, andCornerRadious: 7.0, borderWidth: 1.0)
        imgUserProfilePic.setRound()
        imgStorePic.setRound()
        //tableView.updateConstraints()
    }
    
    func setTableView() {
        tblAddress.delegate = self
        tblAddress.dataSource = self
        tblAddress.separatorColor = .clear
        tblAddress.rowHeight = UITableView.automaticDimension
        tblAddress.estimatedRowHeight = 40
        tblAddress.register(cellTypes: [AddressCell.self])
    }
    
    func onClickRightButton() {
        let objVC = self.storyboard?.instantiateViewController(withIdentifier: "InvoiceVC") as! InvoiceVC
        objVC.orderPayment = self.orderPayment
        objVC.activeOrder = ActiveOrder(dictionary: ["_id" : self.orderDetail?.id ?? "", "user_first_name":self.userDetail?.firstName ?? "","user_last_name":self.userDetail?.lastName ?? "","user_image" : self.userDetail?.imageUrl ?? ""])
        objVC.strCurrency = self.currency
        objVC.paymentType = self.payment
        objVC.isHistoryDetail = true
        objVC.modalPresentationStyle = .overCurrentContext
        self.present(objVC, animated: false, completion: nil)
    }
    
    func openImage(link:String) {
        viewImage.isHidden = false
        imgContactLess.downloadedFrom(link: link)
    }
    
    func openViewImageDialogue(link:String, isPickupImage:Bool) {
        let strTitle = isPickupImage ? "TXT_PICKUP_IMAGE".localized : "TXT_DELIVERY_IMAGE".localized
        let  _ = CustomDialogViewImage.showCustomDialogViewImage(title: strTitle, message: "", imgUrlToView:  link)
        
    }
    
    @IBAction func closePressed(_ sender: UIButton) {
        viewImage.isHidden = true
    }
    
    @IBAction func pickupPressed(_ sender: UIButton) {
        self.openViewImageDialogue(link: pickupImgUrl, isPickupImage: true)
    }
    
    @IBAction func completeImagePressed(_ sender: UIButton) {
        self.openViewImageDialogue(link: completeImgUrl, isPickupImage: false)
    }
    
    @IBAction func onClickRate(_ sender: UIButton) {
        var feedbacktitle = ""
        if sender.tag == 0 {
            isRateToUser = false
            feedbacktitle = (self.storeDetail?.name)!
        }else {
            isRateToUser = true
            feedbacktitle = (self.userDetail?.firstName)! + " " +   (self.userDetail?.lastName)!
        }
        let feebackDailog = DailogForFeedback.showCustomFeedbackDialog(feedbacktitle,isRateToUser , true ,(self.orderDetail?.id) ?? "")
        feebackDailog.onClickApplyButton = {
            self.wsGetHistoryDetail()
            feebackDailog.removeFromSuperview()
        }
    }
    
    @objc func rateToUser() {
        isRateToUser = true
        let feedbacktitle = (self.userDetail?.firstName)! + " " +   (self.userDetail?.lastName)!
        let feebackDailog = DailogForFeedback.showCustomFeedbackDialog(feedbacktitle,isRateToUser , true ,(self.orderDetail?.id) ?? "")
        feebackDailog.onClickApplyButton = {
            self.wsGetHistoryDetail()
            feebackDailog.removeFromSuperview()
        }
    }
    
    @objc func rateToStore() {
        isRateToUser = false
        let   feedbacktitle = (self.storeDetail?.name)!
        let feebackDailog = DailogForFeedback.showCustomFeedbackDialog(feedbacktitle,isRateToUser , true ,(self.orderDetail?.id) ?? "")
        feebackDailog.onClickApplyButton = { 
            self.wsGetHistoryDetail()
            feebackDailog.removeFromSuperview()
        }
    }
    
    func checkForOrderStatus(orderStatusValue:Int) {
       
        let orderStatus:OrderStatus = OrderStatus(rawValue: orderStatusValue) ?? .Unknown
        //Status changes
        switch (orderStatus) {
            
        case  OrderStatus.NO_DELIVERY_MAN_FOUND,
              OrderStatus.ORDER_READY,
              OrderStatus.DELIVERY_MAN_REJECTED,
              OrderStatus.DELIVERY_MAN_CANCELLED,
              OrderStatus.STORE_ACCEPTED:

            btnOrderAccepted.setImage(UIImage.init(named: "red_dot_icon")?.imageWithColor(color: .themeIconTintColor), for: UIControl.State.normal)
             break
            
         case OrderStatus.DELIVERY_MAN_ACCEPTED,
              OrderStatus.DELIVERY_MAN_COMING,
              OrderStatus.DELIVERY_MAN_ARRIVED:
            btnOrderAccepted.setImage(UIImage.init(named: "red_checked_icon")?.imageWithColor(color: .themeIconTintColor), for: UIControl.State.normal)
            btnOrderPrepared.setImage(UIImage.init(named: "red_dot_icon")?.imageWithColor(color: .themeIconTintColor), for: UIControl.State.normal)
            
             break
            
        case
             OrderStatus.DELIVERY_MAN_PICKED_ORDER,
             OrderStatus.DELIVERY_MAN_STARTED_DELIVERY:
            
            btnOrderAccepted.setImage(UIImage.init(named: "red_checked_icon")?.imageWithColor(color: .themeIconTintColor), for: UIControl.State.normal)
            btnOrderPrepared.setImage(UIImage.init(named: "red_checked_icon")?.imageWithColor(color: .themeIconTintColor), for: UIControl.State.normal)
            btnOrderOnTheWay.setImage(UIImage.init(named: "red_dot_icon")?.imageWithColor(color: .themeIconTintColor), for: UIControl.State.normal)
            
            break
        case OrderStatus.DELIVERY_MAN_ARRIVED_AT_DESTINATION:
            
            btnOrderAccepted.setImage(UIImage.init(named: "red_checked_icon")?.imageWithColor(color: .themeIconTintColor), for: UIControl.State.normal)
            
            btnOrderPrepared.setImage(UIImage.init(named: "red_checked_icon")?.imageWithColor(color: .themeIconTintColor), for: UIControl.State.normal)
            
            btnOrderOnTheWay.setImage(UIImage.init(named: "red_checked_icon")?.imageWithColor(color: .themeIconTintColor), for: UIControl.State.normal)
            
            btnOrderOnDoorStep.setImage(UIImage.init(named: "red_dot_icon")?.imageWithColor(color: .themeIconTintColor), for: UIControl.State.normal)
            
            break
        case OrderStatus.DELIVERY_MAN_COMPLETE_DELIVERY,OrderStatus.DELIVERY_MAN_COMPLETE_DELIVERY_2:
            
            btnOrderAccepted.setImage(UIImage.init(named: "red_checked_icon")?.imageWithColor(color: .themeIconTintColor), for: UIControl.State.normal)
            
            btnOrderPrepared.setImage(UIImage.init(named: "red_checked_icon")?.imageWithColor(color: .themeIconTintColor), for: UIControl.State.normal)
            
            btnOrderOnTheWay.setImage(UIImage.init(named: "red_checked_icon")?.imageWithColor(color: .themeIconTintColor), for: UIControl.State.normal)
            
            btnOrderOnDoorStep.setImage(UIImage.init(named: "red_checked_icon")?.imageWithColor(color: .themeIconTintColor), for: UIControl.State.normal)
            
            break
        case OrderStatus.STORE_CANCELLED:
            break
        default:
            break
        }
        
      
    }
    func setStatuDetail(historyOrderResposnse:HistoryOrderDetailResponse) {

        let os = historyOrderResposnse.orderDetail.orderStatus
        let ds = historyOrderResposnse.request.deliveryStatus
        OrderStatusValue = (os > ds) ? os : ds
        self.checkForOrderStatus(orderStatusValue: OrderStatusValue)
        self.arrStatusDetails.removeAll()
        
        for details in historyOrderResposnse.request.arrStatusDetails {
            let orderStatusDetail:OrderDateWiseStatusDetails = OrderDateWiseStatusDetails.init(fromDictionary: [:])
            orderStatusDetail.date = Utility.stringToString(strDate:details.date, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DAY_MMM_YYYY_MONTH) + ","
            orderStatusDetail.time = Utility.stringToString(strDate:details.date, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.TIME_FORMAT_AM_PM)
            orderStatusDetail.status = details.status
            orderStatusDetail.imageUrl = details.imageUrl
            self.arrStatusDetails.append(orderStatusDetail)
        }
        
        for orderStatusDetails in self.arrStatusDetails {
            let orderStatus =  OrderStatus.init(rawValue: orderStatusDetails.status) ?? OrderStatus.Unknown
            switch (orderStatus)
            {
                case OrderStatus.STORE_ACCEPTED:
                    break
                
                case OrderStatus.DELIVERY_MAN_ACCEPTED:
                   self.lblAcceptedDate.text = orderStatusDetails.date
                   self.lblAcceptedTime.text = orderStatusDetails.time
                   break
            
                case OrderStatus.DELIVERY_MAN_PICKED_ORDER:
                    self.lblPreparedDate.text = orderStatusDetails.date
                    self.lblPreparedTime.text = orderStatusDetails.time
                    self.pickupImgUrl = orderStatusDetails.imageUrl
                    self.btnPickupImage.isHidden = self.pickupImgUrl.isEmpty
                    break
               
                case OrderStatus.DELIVERY_MAN_ARRIVED_AT_DESTINATION:
                    self.lblStartDeliveryDate.text = orderStatusDetails.date
                   self.lblStartDeliveryTime.text = orderStatusDetails.time
                   self.completeImgUrl = orderStatusDetails.imageUrl
                   self.btnCompleteImage.isHidden = self.completeImgUrl.isEmpty
                    break
                
                case OrderStatus.DELIVERY_MAN_COMPLETE_DELIVERY:
                    self.lblDeliveryCompleteDate.text = orderStatusDetails.date
                    self.lblDeliveryCompleteTime.text = orderStatusDetails.time
                    break
                
                default :
                    break
            }
        }
        viewForOrderStatus.isHidden = false
    }
    
    //MARK: Get Histroy Detail
    func wsGetHistoryDetail() {
        self.tableView.isHidden = true
        Utility.showLoading()
        let dictParam:[String:String] =
            [PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken(),
             PARAMS.PROVIDER_ID : preferenceHelper.getUserId(),
             PARAMS.REQUEST_ID : strOrderID]
        print(dictParam)
        print(WebService.BASE_URL + WebService.WS_GET_HISTORY_DETAIL)
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_GET_HISTORY_DETAIL, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            
            if (Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: false)) {

                print(response)
                let historyOrderResposnse:HistoryOrderDetailResponse = HistoryOrderDetailResponse.init(fromDictionary: response)
                self.fillAddress(response: historyOrderResposnse)
                self.setStatuDetail(historyOrderResposnse: historyOrderResposnse)
                self.payment = historyOrderResposnse.paymentGatewayName
                self.userDetail = historyOrderResposnse.userDetail
                self.cartDetail = historyOrderResposnse.cartDetail

                //APi change again
                self.orderDetailNew = historyOrderResposnse.orderDetail
                self.orderPayment = historyOrderResposnse.orderPaymentDetail
                self.orderDetail = historyOrderResposnse.request
                self.storeDetail = historyOrderResposnse.storeDetail
                
                //API changes
                self.setStoreDetail(data: self.storeDetail!)
                self.setuserDetail(name: historyOrderResposnse.request.destinationAddresses.first?.userDetails.name ?? "User", imageStringUrl: historyOrderResposnse.request.destinationAddresses.first?.userDetails.image_url ?? "")
                self.btnRateProvider.setTitle(historyOrderResposnse.provider_rating_to_user.toString(), for: .normal)
                self.btnRateStore.setTitle(historyOrderResposnse.provider_rating_to_store.toString(), for: .normal)
                self.setOrderListDetail(data: self.orderDetail!)
                let title = "TXT_REQUEST_NO".localized + " " + String(historyOrderResposnse.request.uniqueID)
                self.setNavigationTitle(title: title)
                self.tableView.isHidden = false
                Utility.hideLoading()
                
            }else {
                self.tableView.isHidden = false
                Utility.hideLoading()
            }                        
        }
    }
    
    func fillAddress(response: HistoryOrderDetailResponse) {
        arrAddress.removeAll()
        arrAddress = response.request.destinationAddresses ?? []
        arrAddress.insert(response.request?.pickupAddresses.first ?? Address(fromDictionary: [:]), at: 0)
        tblAddress.reloadData()
    }
    
    //MARK: Get User/Store/Order Details
    func setStoreDetail(data:HistoryStoreDetail) {
        
        //API Changes
        if self.cartDetail?.deliveryType == DeliveryType.courier {
            lblStoreName.text = "TXT_COURIER".localized
            
        }else {
            lblStoreName.text = data.name
            imgStorePic.downloadedFrom(link: data.imageUrl)
        }
    }
    
    func setuserDetail(name: String, imageStringUrl: String) {
        lblUserName.text = name
        imgUserProfilePic.downloadedFrom(link: imageStringUrl)
    }
    
    func setOrderListDetail(data: Request) {
       
        lblOrderNumber.text = "TXT_ORDER_NO".localized +  "\(self.orderDetailNew?.uniqueID ?? 0)"
        let leftInset = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 0.0)
        let rightInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 8.0)
        btnRateProvider.titleEdgeInsets = (LocalizeLanguage.isRTL) ? rightInset : leftInset
        btnRateStore.titleEdgeInsets = (LocalizeLanguage.isRTL) ? rightInset : leftInset
        if self.orderDetailNew?.isProviderRatedToUser ?? false {
            viewForUserRate.isHidden = false
            viewForUserRate.isUserInteractionEnabled = false
            btnRateProvider.isUserInteractionEnabled = false
            btnRateProvider.isHidden = false
        }else {
            viewForUserRate.isHidden = false
            let tap = UITapGestureRecognizer(target: self, action:#selector(rateToUser))
            viewForUserRate.addGestureRecognizer(tap)
            viewForUserRate.isUserInteractionEnabled = true
            btnRateProvider.setTitle("".localized, for: .normal)
        }
        
        if self.orderDetailNew?.isProviderRatedToStore ?? false || self.cartDetail?.deliveryType == DeliveryType.courier
        {
            viewForStoreRate.isHidden = false
            viewForStoreRate.isUserInteractionEnabled = false
            btnRateStore.isHidden = false
            btnRateStore.isUserInteractionEnabled = false
        }else {
            viewForStoreRate.isHidden = false
            let tap = UITapGestureRecognizer(target: self, action:#selector(rateToStore))
            viewForStoreRate.addGestureRecognizer(tap)
            viewForStoreRate.isUserInteractionEnabled = true
            btnRateStore.setTitle("".localized, for: .normal)
        }
        
        if self.cartDetail?.deliveryType == DeliveryType.courier {
            viewForStoreRate.isHidden = true
            btnRateStore.isHidden = true
        }
        
        lblDate.text = Utility.relativeDateStringForDate(strDate: Utility.stringToString(strDate: (data.completedAt)!, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_FORMAT)) as String
        lblEstTimeValue.text = "\(self.orderPayment?.total_time ?? 0.00)" + "UNIT_MIN".localized

        if(self.orderPayment?.is_distance_unit_mile ?? false) {
            lblEstDistanceValue.text = "\(self.orderPayment?.total_distance ?? 0.00)" +  "UNIT_MILE".localized
        }else{
            lblEstDistanceValue.text = "\(self.orderPayment?.total_distance ?? 0.00)" +  "UNIT_KM".localized
        }

        arrOrderDetails = (self.cartDetail?.orderDetails) ?? []

        arrForItems.removeAllObjects()
        if arrOrderDetails.isEmpty {
        } else {
            for i in 0 ..< arrOrderDetails.count {
                let itemsData = arrOrderDetails[i]
                let arr = (itemsData.items)! as [OrderItem]
                for i in 0 ..< arr.count {
                    arrForItems.add(arr[i])
                }
            }
            tableView.reloadData()
        }
    }

    //MARK: Tableview Delegate
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        if tableView == tblAddress {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblAddress {
            return arrAddress.count
        }
        return arrForItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblAddress {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as! AddressCell
            let obj = arrAddress[indexPath.row]
            cell.lblAddress.text = obj.address
            cell.selectionStyle = .none
            cell.imgPin.image = indexPath.row == 0 ? UIImage(named: "store_pin")!.imageWithColor(color: .themeTextColor) : UIImage(named: "user_pin")!
            cell.imgRight.isHidden = true
            if obj.isArrived {
                cell.imgRight.isHidden = false
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomOrderDetailCell
        let items = arrForItems[indexPath.row] as! OrderItem
        cell.setCellData(itemDetail: items,currency: self.currency)
        if self.orderDetail?.deliveryType == DeliveryType.courier {
            cell.heightItem?.constant = 0
            cell.viewForItem.isHidden = true
        }
        return cell
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}


public class OrderDateWiseStatusDetails {
    var date : String!
    var time : String!
    var status:Int!
    var imageUrl:String=""
    init(fromDictionary dictionary: [String:Any]) {
        date = (dictionary["date"] as? String) ?? ""
        status = (dictionary["status"] as? Int) ?? 0
        imageUrl = dictionary["image_url"] as? String ?? ""
    }
    
    func toDictionary() -> [String:Any] {
        var dictionary = [String:Any]()
        if date != nil{
            dictionary["date"] = date
        }
        if status != nil{
            dictionary["status"] = status
        }
        dictionary["image_url"] = imageUrl
        return dictionary
    }
}
