//
//  OrderDetailVC.swift
// Edelivery Store
//
//  Created by Jaydeep Vyas on 28/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
import CoreBluetooth
import Printer

class OrderDetailVC: BaseVC {
    
    @IBOutlet weak var heightForStatus: NSLayoutConstraint!
    
    @IBOutlet weak var btnEditOrder: UIButton!
    @IBOutlet weak var btnDeliveryMan: UIButton!
    
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var btnReject: UIButton!
    @IBOutlet weak var btnSetStatus: UIButton!
    @IBOutlet weak var btnCancelOrder: UIButton!
    
    @IBOutlet weak var viewForOrderStatus: UIView!
    @IBOutlet weak var viewForSetStaus: UIStackView!
    
    @IBOutlet weak var viewForAcceptReject: UIStackView!
    /*Order Detail View */
    @IBOutlet weak var viewForOrderDetail: UIView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblOrderNumber: UILabel!
    @IBOutlet weak var lblDeliveryAddress: UILabel!
    @IBOutlet weak var lblTotalOrderPriceValue: UILabel!
    @IBOutlet weak var lblOrderStatus: UILabel!
    @IBOutlet weak var imgPayment: UIImageView!
    @IBOutlet weak var imgPickup: UIImageView!
    
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var lblSchedualOrderDate: UILabel!
    
    @IBOutlet weak var stackViewForOrderStatus: UIStackView!
    @IBOutlet weak var btnAssignProvider: UIButton!
    @IBOutlet weak var btnCompleteOrder: UIButton!
    
    @IBOutlet weak var mainOrderTable: UITableView!
    @IBOutlet weak var viewForSearchOverlay: UIView!
    @IBOutlet weak var viewForSearchItem: UIView!
    @IBOutlet weak var heightForSearchView: NSLayoutConstraint!
    @IBOutlet var btnChat: MyBadgeButton!
    
    @IBOutlet weak var lblChatAdmin: UILabel!
    @IBOutlet weak var lblChatUser: UILabel!
    @IBOutlet weak var lblPayment: UILabel!
    @IBOutlet weak var lblCall: UILabel!
    @IBOutlet weak var lblEdit: UILabel!

    @IBOutlet weak var lblViewInvoice: UILabel!
    @IBOutlet weak var viewEditOrder: UIView!
    @IBOutlet weak var imgSepCancelOrder: UIImageView!
    @IBOutlet weak var viewCancelOrder: UIView!
    @IBOutlet weak var viewSepCancelOrder: UIView!
    @IBOutlet weak var viewForPaymentDeliveryStatus: CustomCardView!
    @IBOutlet weak var lblDeliveryStatus: UILabel!
    @IBOutlet weak var lblTopSeprator: CustomLabelSeprator!
    @IBOutlet weak var viewForInvoice: UIView!
    //    @IBOutlet weak var viewForCancelOrder2: UIView!
    @IBOutlet weak var viewForCartItems: CustomCardView!
    @IBOutlet weak var viewForPickupDelivery: UIView!
    @IBOutlet weak var viewForPaymentMode: UIView!
    @IBOutlet weak var viewForTableNumber: UIView!
    @IBOutlet weak var imgTableNumber: UIImageView!
    @IBOutlet weak var lblTableBookForPeople: UILabel!

    @IBOutlet weak var viewForNote: UIView!
    @IBOutlet weak var btnNote: UIButton!
    @IBOutlet weak var lblNote: UILabel!
    @IBOutlet weak var imgNote: UIImageView!

    let btnPrintInvoice = UIButton.init(type: .custom)

    var orderDetail:OrderOutsideNew! = nil
    var selectedOrder:Order!
    var estimateTimeForPrepareOrder:String = "0"
    var currentOrder:CurrentOrder!
    var myNextOrderStatus:OrderStatus! = .Unknown;
    //Storeapp
    var arrForProducts:[OrderDetail] = []
    //    var arrForProducts:[OrderDetailNew] = []
    
    var selectedVehicleId:String = ""
    var strPrintData : String = ""
    var bluetoothManager = CBCentralManager()

    //--code Printer 2
    private let dummyPrinter = DummyPrinter()
    var printManager:BluetoothPrinterManager?
    var ticket:Ticket?

    //MARK:  View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalization()
        // setUserDetail()
        viewForOrderStatus.isHidden = true
        // wsGetOrderStatus()
        
        arrForProducts.removeAll()
        //Storeapp //API changes
        //        arrForProducts = selectedOrder.cartDetail.orderDetails
        
        //        arrForProducts = orderDetail.cartDetail.orderDetails
        let options = [CBCentralManagerOptionShowPowerAlertKey: NSNumber(value: false)]
        bluetoothManager = CBCentralManager(delegate: self, queue: nil, options: options)
        NotificationCenter.default.addObserver(self, selector: #selector(handlePrinterConnectedNotification(_:)), name: NSNotification.Name.PrinterConnected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handlePrinterDisconnectedNotification(_:)), name: NSNotification.Name.PrinterDisconnected, object: nil)
        
        if Printers.IS_PRINTER_1_CONNECTED{
            //--code Printer 1
            PrinterSDK.default()
        }else{
            //--code Printer 2
            printManager = BluetoothPrinterManager.init()
        }
        
        btnPrintInvoice.setImage(UIImage.init(named: "printerIcon")!.imageWithColor(color: .themeColor), for: .normal)
        btnPrintInvoice.addTarget(self, action: #selector(onClickPrintInvoice), for: .touchUpInside)
        
        mainOrderTable.estimatedRowHeight = 100
        mainOrderTable.rowHeight = UITableView.automaticDimension
        mainOrderTable.reloadData()
        stackViewForOrderStatus.isHidden = true
        
        btnChat = MyBadgeButton.init(frame: CGRect.init(x: 0, y: 0, width: 32, height: 32))
        btnChat?.setImage(UIImage.init(named: "chat"), for: .normal)
        btnChat?.addTarget(self, action: #selector(self.onClickBtnChat(_:)), for: .touchUpInside)
        let rightButton:UIBarButtonItem = UIBarButtonItem.init(customView: btnChat!)
        self.navigationItem.setRightBarButtonItems([UIBarButtonItem.init(customView: btnPrintInvoice),rightButton], animated: false)

        viewForSearchOverlay.backgroundColor = UIColor.clear
        viewForSearchOverlay.isHidden = true
        viewForSearchItem.backgroundColor = UIColor.themeViewBackgroundColor
        viewForSearchItem.setShadow(shadowColor: UIColor.black.cgColor, shadowOffset: CGSize.init(width: 2.0, height: 2.0), shadowOpacity: 5.0, shadowRadius: 2.0)
    }

    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        wsGetOrderDetail()
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
    }

    override func viewDidDisappear(_ animated: Bool){
        super.viewDidDisappear(animated)
    }

    override func updateUIAccordingToTheme() {
        if orderDetail != nil{
            self.setUserDetail()
        }
    }

    func setLocalization() {
        //SEt Font
        lblUserName.font = FontHelper.textMedium()
        lblTotalOrderPriceValue.font = FontHelper.textMedium()
        lblOrderNumber.font = FontHelper.textSmall()
        //        lblOrderStatus.font = FontHelper.textSmall()
        lblDeliveryAddress.font = FontHelper.textSmall()
        lblSchedualOrderDate.font = FontHelper.textSmall()
        //        btnAccept.titleLabel?.font = FontHelper.buttonText()
        //        btnReject.titleLabel?.font = FontHelper.buttonText()
        //        btnSetStatus.titleLabel?.font = FontHelper.buttonText()
        btnAssignProvider.titleLabel?.font = FontHelper.buttonText()
        btnCompleteOrder.titleLabel?.font = FontHelper.buttonText()
        //Set Text Color
        lblUserName.textColor = UIColor.themeTextColor
        lblDeliveryAddress.textColor = UIColor.themeLightTextColor
        lblTotalOrderPriceValue.textColor = UIColor.themeTextColor
        lblOrderNumber.textColor = UIColor.themeLightTextColor
        //        lblOrderStatus.textColor = UIColor.themeSectionBackgroundColor
        lblSchedualOrderDate.textColor = UIColor.themeColor
        //        btnAccept.backgroundColor = UIColor.themeButtonBackgroundColor
        //        btnReject.backgroundColor = UIColor.themeButtonBackgroundColor
        //        btnAccept.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        //        btnReject.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnCompleteOrder.backgroundColor = UIColor.themeColor
        btnAssignProvider.backgroundColor = UIColor.themeColor
        //        btnReject.titleLabel?.font = FontHelper.buttonText()
        //        btnAccept.titleLabel?.font = FontHelper.buttonText()
        //Set Color
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        viewForOrderDetail.backgroundColor = UIColor.themeViewBackgroundColor
        viewForOrderStatus.backgroundColor = UIColor.themeViewBackgroundColor
        //        mainOrderTable.backgroundColor = UIColor.themeViewBackgroundColor
        //        mainOrderTable.setRound(withBorderColor: .themeLightTextColor, andCornerRadious: 5.0, borderWidth: 0.3)
        mainOrderTable.tableFooterView = UIView()
        lblPayment.font = FontHelper.textRegular()
        lblPayment.textColor = UIColor.themeTextColor
        
        lblViewInvoice.font = FontHelper.textSmall(size: 12.0)
        lblViewInvoice.textColor = UIColor.themeColor
        lblEdit.font = FontHelper.textSmall(size: 12.0)
        lblEdit.textColor = UIColor.themeColor
        lblEdit.text = "TXT_EDIT".localizedCapitalized
        lblNote.font = FontHelper.textSmall(size: 12.0)
        lblNote.textColor = UIColor.themeColor

        lblCall.font = FontHelper.textSmall(size: 12.0)
        lblCall.textColor = UIColor.themeColor
        lblCall.text = "TXT_CALL_USER".localized
        lblViewInvoice.text = "TXT_VIEW_INVOICE".localized
        lblNote.text = "text_note".localized

        lblDeliveryStatus.textColor = UIColor.themeTextColor
        lblDeliveryStatus.font = FontHelper.textRegular()

        lblTableBookForPeople.textColor = UIColor.themeTextColor
        lblTableBookForPeople.font = FontHelper.textRegular()

        //Set Localization
        lblUserName.text = "TXT_DEFAULT".localized
        lblOrderNumber.text = "TXT_DEFAULT".localized
        self.setNavigationTitle(title: "TXT_ORDER".localizedCapitalized)
        lblDeliveryAddress.text = "TXT_DEFAULT".localized
        lblTotalOrderPriceValue.text = "TXT_DEFAULT".localized
        //        lblOrderStatus.text = "TXT_DEFAULT".localized
        lblChatAdmin.text = "TXT_CHAT_WITH".localized + "TXT_ADMIN".localized
        lblChatUser.text = "TXT_CHAT_WITH".localized + "TXT_USER".localized
        btnAccept.setTitle("TXT_ACCEPT".localizedUppercase, for: .normal)
        btnReject.setTitle("TXT_REJECT".localizedUppercase, for: .normal)
        btnCancelOrder.setTitle("TXT_CANCEL".localized, for: .normal)
        btnCancelOrder.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        viewEditOrder.isHidden = true
        //        self.btnEditOrder.layer.cornerRadius = 5.0
        //        self.btnEditOrder.layer.masksToBounds = true
        //        self.btnEditOrder.backgroundColor = UIColor.themeSectionBackgroundColor
        //        btnEditOrder.setTitle(" "+"TXT_EDIT".localizedCapitalized+" ", for: .normal)
        btnCompleteOrder.setTitle("TXT_COMPLETE_ORDER".localized, for: .normal)
        btnAssignProvider.setTitle("TXT_ASSIGN_PROVIDER".localized, for: .normal)

        btnCompleteOrder.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnAssignProvider.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
    }

    func setupLayout() {
        if imgUser != nil{
            imgUser.setRound()
        }
    }

    func setUserDetail() {
        //Storeapp //API changes
        /*lblUserName.text = selectedOrder.cartDetail.destinationAddresses[0].userDetails.name
         imgUser.downloadedFrom(link: selectedOrder.userDetail.imageUrl)
         lblDeliveryAddress.text = selectedOrder.cartDetail.destinationAddresses[0].address
         btnDeliveryMan.isHidden = selectedOrder.orderPaymentDetail.isUserPickupOrder
         
         
         if selectedOrder.orderPaymentDetail.isPaymentModeCash {
         imgPayment.image = UIImage.init(named: "cash_icon")
         }else {
         imgPayment.image = UIImage.init(named: "card_icon")
         }
         
         if selectedOrder.isScheduleOrder {
         lblSchedualOrderDate.isHidden = false
         //Storeapp
         if selectedOrder.scheduleOrderStartAt2.count > 0{
         let str2 : String = Utility.stringToString(strDate: selectedOrder.scheduleOrderStartAt2, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.TIME_FORMAT_24Hours,timezone:selectedOrder.timeZone)
         if str2.count > 0{
         lblSchedualOrderDate.text = "\(Utility.stringToString(strDate: selectedOrder.scheduleOrderStartAt, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_TIME_FORMAT,timezone:selectedOrder.timeZone)) - \(str2)"
         }
         }else{
         lblSchedualOrderDate.text =
         Utility.stringToString(strDate: selectedOrder.scheduleOrderStartAt, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_TIME_FORMAT,timezone : selectedOrder.timeZone)
         }
         
         }else {
         lblSchedualOrderDate.isHidden = true
         }
         
         lblOrderNumber.text = "TXT_ORDER_NO".localized + String(selectedOrder.uniqueId)
         lblTotalOrderPriceValue.text = (selectedOrder.orderPaymentDetail.totalOrderPrice).toCurrencyString()
         
         
         let orderStatus:OrderStatus = OrderStatus(rawValue: selectedOrder.orderStatus) ?? .Unknown;
         lblOrderStatus.text = orderStatus.text()*/
        
        lblUserName.text = orderDetail.order.userDetail.name
        imgUser.downloadedFrom(link: orderDetail.userImageUrl)
        setDestinationAddress(address: orderDetail.cartDetail.destinationAddresses[0])
        //        btnDeliveryMan.isHidden = orderDetail.orderPaymentDetail.isUserPickUpOrder

        if orderDetail.orderPaymentDetail.isPaymentModeCash != nil {
            if orderDetail.orderPaymentDetail.isPaymentModeCash {
                imgPayment.image = UIImage.init(named: "cashPayment")?.imageWithColor(color: .themeIconTintColor)
                lblPayment.text = "\("TXT_PAYMENT_IN".localizedCapitalized) \("TXT_CASH".localized)"
            } else {
                imgPayment.image = UIImage.init(named: "card_icon")?.imageWithColor(color: .themeIconTintColor)
                lblPayment.text = "\("TXT_PAYMENT_BY".localizedCapitalized) \("TXT_CARD".localized)"
            }
        } else {
            imgPayment.image = UIImage.init(named: "card_icon")?.imageWithColor(color: .themeIconTintColor)
            lblPayment.text = "\("TXT_PAYMENT_BY".localizedCapitalized) \("TXT_CARD".localized)"
        }

        if self.arrForProducts.count > 0 {
            self.viewForCartItems.isHidden = false
        } else {
            self.viewForCartItems.isHidden = true
        }

        if self.orderDetail.cartDetail.deliveryType == DeliveryType.tableBooking {
            self.viewForPickupDelivery.isHidden = true
            self.viewForTableNumber.isHidden = false
            self.imgTableNumber.image = UIImage.init(named: "table_booking")//?.imageWithColor(color: .themeIconTintColor)
            self.lblTableBookForPeople.text = String(format:"text_table_no_booked_for_people".localized, self.orderDetail.cartDetail.table_no, self.orderDetail.cartDetail.no_of_persons)
        } else {
            self.viewForPickupDelivery.isHidden = false
            self.viewForTableNumber.isHidden = true
        }

        if orderDetail.orderPaymentDetail.isUserPickupOrder {
            lblDeliveryStatus.text = "TXT_PICKUP_DELIVERY".localizedCapitalized
            imgPickup.image = UIImage.init(named: "takeway")?.imageWithColor(color: .themeIconTintColor)
        } else {
            lblDeliveryStatus.text = "TX_PROVIDER_DELIVERY".localizedCapitalized
            imgPickup.image = UIImage.init(named: "deliveryMan")?.imageWithColor(color: .themeIconTintColor)
        }

        if orderDetail.order.isScheduleOrder {
            lblSchedualOrderDate.isHidden = false
            lblTopSeprator.isHidden = false

            //Storeapp
            if orderDetail.order.scheduleOrderStartAt2.count > 0 {
                let str2 : String = Utility.stringToString(strDate: orderDetail.order.scheduleOrderStartAt2, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.TIME_FORMAT_24Hours,timezone:orderDetail.order.timezone)
                if str2.count > 0 {
                    lblSchedualOrderDate.text = "\(Utility.stringToString(strDate: orderDetail.order.scheduleOrderStartAt, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_TIME_FORMAT,timezone:orderDetail.order.timezone)) - \(str2)"
                }
            } else {
                lblSchedualOrderDate.text = Utility.stringToString(strDate: orderDetail.order.scheduleOrderStartAt!, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_TIME_FORMAT,timezone : orderDetail.order.timezone)
            }
        } else {
            lblSchedualOrderDate.isHidden = true
            lblTopSeprator.isHidden = true
        }

        lblOrderNumber.text = "TXT_ORDER_NO".localized + String(orderDetail.order.uniqueId)
        lblTotalOrderPriceValue.text = Double(orderDetail.orderPaymentDetail.total).toCurrencyString()

        let orderStatus:OrderStatus = OrderStatus(rawValue: orderDetail.order.orderStatus) ?? .Unknown;
        //        lblOrderStatus.text = orderStatus.text()
    }

    //MARK:- Button Click Events
    @IBAction func onClickBtnRejectOrder(_ sender: UIButton) {
        wsGetCancelReasonList(status: OrderStatus.STORE_REJECTED)
    }

    @IBAction func onClickBtnEditOrder(_ sender: Any) {
        StoreSingleton.shared.updateOrder?.orderId  = orderDetail.order.id
        //check this
        StoreSingleton.shared.updateOrder?.orderDetails = orderDetail.cartDetail!.orderDetails
        StoreSingleton.shared.updateOrder?.isUseItemTaxNew = orderDetail.isUseItemTax
        StoreSingleton.shared.updateOrder?.isTaxIncludedNew = orderDetail.isTaxIncluded

        StoreSingleton.shared.updateOrder?.isUseItemTaxOld = orderDetail.cartDetail!.isUseItemTax
        StoreSingleton.shared.updateOrder?.isTaxIncludedOld = orderDetail.cartDetail!.isTaxInlcuded
        StoreSingleton.shared.updateOrder.storeTaxDetailsOld = orderDetail.cartDetail.storeTaxDetails
        StoreSingleton.shared.updateOrder.storeTaxDetailsNew = orderDetail.storeTaxDetails

        self.performSegue(withIdentifier: SEGUE.EDIT_ORDER, sender: nil)
    }

    @IBAction func onClickBtnAcceptOrder(_ sender: UIButton) {
        Utility.showLoading()
        self.wsSetOrderStatus(orderStatus:OrderStatus.STORE_ACCEPTED)
    }

    @IBAction func onClickBtnCancelOrder(_ sender: Any){
        wsGetCancelReasonList(status: OrderStatus.STORE_CANCELLED)
    }

    @IBAction func onClickBtnAssignProvider(_ sender: Any) {
        openVehicleDialog()
    }

    @IBAction func onClickBtnCompleteOrder(_ sender: Any) {
        //        if currentOrder.isConfirmationCodeRequiredAtCompleteDelivery {
        if orderDetail.isConfirmationCodeRequiredAtCompleteDelivery {
            openVerifyDialog()
        } else {
            wsCompleteOrder()
        }
    }
    
    @IBAction func onClickBtnSetOrderStatus(_ sender: Any) {
        /*        if  currentOrder.orderStatus  == OrderStatus.ORDER_READY.rawValue && currentOrder.isUserPickupOrder {
         if currentOrder.isConfirmationCodeRequiredAtCompleteDelivery {
         openVerifyDialog()
         }else {
         wsCompleteOrder()
         }
         }else {
         if currentOrder.orderStatus  == OrderStatus.ORDER_READY.rawValue && StoreSingleton.shared.store.isStoreCanCompleteOrder {
         if currentOrder.isConfirmationCodeRequiredAtCompleteDelivery {
         openVerifyDialog()
         }
         else {
         wsCompleteOrder()
         }
         }else if  myNextOrderStatus.rawValue  == OrderStatus.WAITING_FOR_DELIVERY_MAN.rawValue {
         openVehicleDialog()
         }else {
         if self.checkForEstimateTime() {
         self.openEstimateTimeDialog()
         }
         else {
         self.wsSetOrderStatus(orderStatus:myNextOrderStatus)
         }
         }
         }*/

        if orderDetail.order.orderStatus == OrderStatus.TABLE_BOOKING_ARRIVED.rawValue && orderDetail.cartDetail.deliveryType == DeliveryType.tableBooking {
            wsCompleteOrder()
        } else if orderDetail.order.orderStatus == OrderStatus.ORDER_READY.rawValue && orderDetail.order.isUserPickUpOrder {
            if orderDetail.isConfirmationCodeRequiredAtCompleteDelivery {
                openVerifyDialog()
            } else {
                wsCompleteOrder()
            }
        } else {
            if orderDetail.order.orderStatus == OrderStatus.ORDER_READY.rawValue && StoreSingleton.shared.store.isStoreCanCompleteOrder {
                if orderDetail.isConfirmationCodeRequiredAtCompleteDelivery {
                    openVerifyDialog()
                } else {
                    wsCompleteOrder()
                }
            } else if myNextOrderStatus.rawValue == OrderStatus.WAITING_FOR_DELIVERY_MAN.rawValue {
                openVehicleDialog()
            } else {
                if self.checkForEstimateTime() {
                    self.openEstimateTimeDialog()
                } else {
                    self.wsSetOrderStatus(orderStatus:myNextOrderStatus)
                }
            }
        }
    }

    @IBAction func onClickBtnCall(_ sender: Any) {

        if preferenceHelper.getIsEnableTwilioCallMask() {
            TwilioCallMasking.shared.wsTwilloCallMasking(id: orderDetail.order.id, type: "\(CONSTANT.TYPE_USER)")
        } else {
            let mobileNumber:String = (orderDetail.cartDetail.destinationAddresses[0].userDetails.countryPhoneCode) + (orderDetail.cartDetail.destinationAddresses[0].userDetails.phone)
            if mobileNumber.isEmpty() {
                Utility.showToast(message: "MSG_UNABLE_TO_CALL".localized)
            } else {
                if let phoneNumberUrl:URL = URL(string: "tel://\(mobileNumber)") {
                    if UIApplication.shared.canOpenURL(phoneNumberUrl) {
                        if #available(iOS 10, *) {
                            UIApplication.shared.open(phoneNumberUrl, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(phoneNumberUrl as URL)
                        }
                    }
                } else {
                    Utility.showToast(message: "MSG_UNABLE_TO_CALL".localized)
                }
            }
        }
    }

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
    
    @IBAction func onClickPrintInvoice(_ sender: AnyObject) {
        if Printers.IS_PRINTER_1_CONNECTED{
            //--code Printer 1
            if bluetoothManager.state  != .poweredOn {
                Utility.showToast(message: "MSG_TURN_ON_BLUETOOTH".localized)
            }else{
                if Printers.IS_PRINTER_CONNECTED == true {
                    PrinterSDK.default()?.setFontSizeMultiple(0)
                    PrinterSDK.default()?.printText(strPrintData)
                }else{
                    PrinterSDK.default().disconnect()
                    var mainView: UIStoryboard!
                    mainView = UIStoryboard(name: "Orders", bundle: nil)
                    if let vc : PrinterListViewController = mainView.instantiateViewController(withIdentifier: "PrinterListViewController") as? PrinterListViewController
                    {
                        //                vc.delegate = self
                        self.present(vc, animated: false, completion: nil)
                    }
                }
            }
        }else{
            
            if bluetoothManager.state != .poweredOn {
                Utility.showToast(message: "MSG_TURN_ON_BLUETOOTH".localized)
                return
            }

            //--code Printer 2
            if self.printManager?.canPrint ?? false
            {
                if self.ticket != nil {
                    self.printManager?.print(self.ticket! )
                }
            }else{
                if self.printManager?.nearbyPrinters.count ?? 0 > 0{
                    self.performSegue(withIdentifier: "segueToBluetoothPrinterList", sender: self)
                }else{
                    Utility.showToast(message: "MSG_NO_PRINTERS".localized)
                }
            }
        }
    }
    
    @IBAction func onClickBtnChat(_ sender: AnyObject) {
        //        if viewForSearchOverlay.isHidden {
        //            viewVisible()
        //        }else {
        //            viewGone()
        //        }
        
        let dialogForChat  = DialogForChatVC.showCustomChatDialog(DeliverymanChatVisible: false)
        dialogForChat.onClickUserButton = { [unowned dialogForChat] in
            dialogForChat.removeFromSuperview();
            //Storeapp //API changes
            
            
            //        MessageHandler.ReceiverID = self.selectedOrder.userId
            
            MessageHandler.ReceiverID = self.orderDetail.userId
            print(MessageHandler.ReceiverID)
            //        chatNavTitle = "\(self.orderDetail.userDetail.name ?? "User") \(self.selectedOrder.userDetail.lastName ?? "")"
            self.chatNavTitle = "\(self.orderDetail.order.userDetail.name ?? "User")"
            
            self.pushChatVC(ind: CONSTANT.CHATTYPES.USER_AND_STORE)
        }
        
        dialogForChat.onClickDeliverymanButton = { [unowned dialogForChat] in
            dialogForChat.removeFromSuperview();
            //            MessageHandler.ReceiverID = self.currentOrder.orderRequest.currentProvider
            //            print(MessageHandler.ReceiverID)
            //            self.chatNavTitle = "\(self.currentOrder.providerDetail.firstName ?? "Deliveryman") \(self.currentOrder.providerDetail.lastName ?? "")"
            //            self.pushChatVC(ind: CONSTANT.CHATTYPES.PROVIDER_AND_STORE)
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
        //Storeapp //API changes
        
        
        //        MessageHandler.ReceiverID = self.selectedOrder.userId
        
        MessageHandler.ReceiverID = self.orderDetail.userId
        print(MessageHandler.ReceiverID)
        //        chatNavTitle = "\(self.orderDetail.userDetail.name ?? "User") \(self.selectedOrder.userDetail.lastName ?? "")"
        chatNavTitle = "\(self.orderDetail.order.userDetail.name ?? "User")"
        
        pushChatVC(ind: CONSTANT.CHATTYPES.USER_AND_STORE)
    }

    @IBAction func onClickBtnViewInvoice(_ sender: AnyObject) {
        if self.orderDetail != nil {
            let dialog = CustomInvoiceDialog.showDialog(languages: [:], title: "",options: self.orderDetail.orderPaymentDetail, isAllowMultiselect: false, isTaxIncluded: self.orderDetail.cartDetail.isTaxInlcuded, isTableBooking: self.orderDetail.cartDetail.deliveryType == DeliveryType.tableBooking ? true:false)
            dialog.onItemSelected = { [unowned self] (selectedId) in
                dialog.removeFromSuperview()
            }
        } else {
            Utility.showToast(message: "No Order detail found.")
        }
    }

    @IBAction func onClickBtnNote(_ sender: AnyObject) {
        let dialogForNote = CustomAlertDialog.showCustomAlertDialog(title: "text_note".localized, message: self.orderDetail.order.destinationAddresses[0].note, titleLeftButton: "TXT_CANCEL".localizedUppercase, titleRightButton: "TXT_OK".localizedUppercase, isHideCloseButton: true)
        dialogForNote.onClickLeftButton = {
            dialogForNote.removeFromSuperview();
        }
        dialogForNote.onClickRightButton = {
            dialogForNote.removeFromSuperview();
        }
    }

    func pushChatVC(ind:Int) {
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "Orders", bundle: nil)
        if let vc : MyCustomChatVC = mainView.instantiateViewController(withIdentifier: "chatVC") as? MyCustomChatVC {
            self.viewGone()
            //            MessageHandler.orderID = selectedOrder.id
            MessageHandler.orderID = self.orderDetail.order.id
            
            //            print(self.selectedOrder.cartDetail!.storeId!)
            MessageHandler.chatType = ind
            vc.navTitle = chatNavTitle
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    //MARK:- Web Service Methods
    func updateUI() {
        //        let orderStatus:OrderStatus = OrderStatus(rawValue: currentOrder.orderStatus) ?? .Unknown;
        if orderDetail != nil {
            let orderStatus:OrderStatus = OrderStatus(rawValue: self.orderDetail.order.orderStatus) ?? .Unknown;
            //            lblOrderStatus.text = orderStatus.text()

            if (self.orderDetail.order.orderType == CONSTANT.TYPE_STORE && orderStatus.rawValue == OrderStatus.STORE_ACCEPTED.rawValue) && preferenceHelper.getStoreCanEditOrder() {
                viewEditOrder.isHidden = false
            } else if orderStatus.rawValue < OrderStatus.STORE_ACCEPTED.rawValue && preferenceHelper.getStoreCanEditOrder() {
                viewEditOrder.isHidden = false
            } else {
                viewEditOrder.isHidden = true
            }

            if self.orderDetail.cartDetail.delivery_type == DeliveryType.tableBooking {
                viewEditOrder.isHidden = true
                if self.orderDetail.order.destinationAddresses[0].note.isEmpty {
                    viewForNote.isHidden = true
                } else {
                    viewForNote.isHidden = false
                    self.imgNote.image = UIImage.init(named: "note")?.imageWithColor(color: .themeColor)
                }
            } else {
                viewForNote.isHidden = true
            }

            if orderStatus.rawValue < OrderStatus.STORE_ACCEPTED.rawValue {
                viewForSetStaus.isHidden = true
                viewForAcceptReject.isHidden = false
            } else {
                viewForSetStaus.isHidden = false
                viewForAcceptReject.isHidden = true
            }

            switch (orderStatus) {
                case .WAITING_FOR_ACCEPT_STORE:
                    self.viewCancelOrder.isHidden = false
                    myNextOrderStatus = .STORE_ACCEPTED
                    break
                case .STORE_ACCEPTED:
                    self.viewCancelOrder.isHidden = false
                    if self.orderDetail.cartDetail.delivery_type != DeliveryType.tableBooking {
                        myNextOrderStatus = .STORE_PREPARING_ORDER
                        btnSetStatus.setTitle("TXT_START_PREPARING_ORDER".localizedUppercase, for: UIControl.State.normal);
                    } else {
                        myNextOrderStatus = .TABLE_BOOKING_ARRIVED
                        btnSetStatus.setTitle("btn_arrived".localizedUppercase, for: UIControl.State.normal);
                    }
                    break
                case .TABLE_BOOKING_ARRIVED:
                    self.viewCancelOrder.isHidden = true
                    myNextOrderStatus = .ORDER_READY
                    btnSetStatus.setTitle("text_complete_order".localizedUppercase, for: .normal);
                    break
                case .STORE_PREPARING_ORDER:
                    self.viewCancelOrder.isHidden = false
                    myNextOrderStatus = .ORDER_READY
                    btnSetStatus.setTitle("TXT_ORDER_READY".localizedUppercase, for: UIControl.State.normal);
                    break
                case .ORDER_READY:
                    self.viewCancelOrder.isHidden = false
                    myNextOrderStatus = .WAITING_FOR_DELIVERY_MAN

                    if self.orderDetail.order.isUserPickUpOrder {
                        myNextOrderStatus = .ORDER_READY
                        btnSetStatus.setTitle("TXT_COMPLETE_ORDER".localizedUppercase, for: .normal);
                    } else if self.orderDetail.requestDetail != nil {
                        if self.orderDetail.requestDetail.id.count > 0 {
                            self.navigationController?.popViewController(animated: true)
                        }
                    } else {
                        //                    viewForCancelOrder2.isHidden = false
                        if StoreSingleton.shared.store.isStoreCanAddProvider && StoreSingleton.shared.store.isStoreCanCompleteOrder {
                            stackViewForOrderStatus.isHidden = false
                            viewForSetStaus.isHidden = true
                        } else if StoreSingleton.shared.store.isStoreCanAddProvider {
                            btnSetStatus.setTitle("TXT_ASSIGN_PROVIDER".localizedUppercase, for: .normal);
                        } else if StoreSingleton.shared.store.isStoreCanCompleteOrder {
                            btnSetStatus.setTitle("TXT_COMPLETE_ORDER".localizedUppercase, for: .normal);
                        } else {
                            btnSetStatus.setTitle("TXT_ASSIGN_PROVIDER".localizedUppercase, for: .normal);
                        }
                    }
                    break
                case .WAITING_FOR_DELIVERY_MAN:
                    self.viewCancelOrder.isHidden = false
                    myNextOrderStatus = .NO_DELIVERY_MAN_FOUND
                    break
                case .CANCELED_BY_USER:
                    self.viewCancelOrder.isHidden = false
                    self.openCancelByUserDialog()
                    break
                default:
                    self.viewCancelOrder.isHidden = false
                    myNextOrderStatus = .NO_DELIVERY_MAN_FOUND
                    break
            }
            viewForOrderStatus.isHidden = false
        }
    }

    func openCancelByUserDialog() {
        let dialogForCancelOrder = CustomAlertDialog.showCustomAlertDialog(title: "TXT_ORDER_CANCELLED".localized, message: "", titleLeftButton: "", titleRightButton: "TXT_OK".localized)
        dialogForCancelOrder.onClickLeftButton = {  [unowned dialogForCancelOrder, unowned self] in
            dialogForCancelOrder.removeFromSuperview();
            self.navigationController?.popViewController(animated: true)
        }
        dialogForCancelOrder.onClickRightButton = { [unowned dialogForCancelOrder, unowned self] in
            dialogForCancelOrder.removeFromSuperview();
            self.navigationController?.popViewController(animated: true)
        }
    }

    func wsGetOrderStatus() {
        Utility.showLoading()
        let dictParam : [String : Any] =
            [
                //                PARAMS.ORDER_ID:selectedOrder.id,
                PARAMS.ORDER_ID:selectedOrder.id,
                PARAMS.STORE_ID: preferenceHelper.getUserId(),
                PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken()]
        print(dictParam)
        
        let alamoFire:AlamofireHelper = AlamofireHelper.init()
        alamoFire.getResponseFromURL(url: WebService.WS_CHECK_ORDER_STATUS, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            Utility.hideLoading()
            print(response)
            if Parser.isSuccess(response: response) {
                let orderStatusResponse:OrderStatusResponse = OrderStatusResponse.init(fromDictionary:response)
                self.currentOrder =  orderStatusResponse.order
                //                var currentOrder : CurrentOrder!
                //                currentOrder.confirmationCodeForCompleteDelivery = self.orderDetail.order.confirmationCodeForCompleteDelivery
                //                currentOrder.confirmationCodeForPickUpDelivery = self.orderDetail.order.confirmationCodeForPickUpDelivery
                //                currentOrder.createdAt = self.orderDetail.order.createdAt
                self.updateUI()
            }
        }
    }

    func wsSetOrderStatus(orderStatus:OrderStatus) {
        //        if currentOrder != nil {
        if orderDetail.order != nil {
            let dictParam : [String : Any] =
                [
                    //                    PARAMS.ORDER_ID:selectedOrder.id,
                    PARAMS.ORDER_ID:orderDetail.order.id,
                    PARAMS.STORE_ID: preferenceHelper.getUserId(),
                    PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken(),
                    PARAMS.ORDER_STATUS: orderStatus.rawValue]
            print("WS_SET_ORDER_STATUS dictParam \(dictParam)")

            Utility.showLoading()
            let alamoFire:AlamofireHelper = AlamofireHelper.init()
            alamoFire.getResponseFromURL(url: WebService.WS_SET_ORDER_STATUS, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
                Utility.hideLoading()
                if Parser.isSuccess(response: response) {
                    //                    self.currentOrder.orderStatus = orderStatus.rawValue;
                    self.orderDetail.order.orderStatus = orderStatus.rawValue;
                    self.checkForEstimateTime()
                    self.updateUI()
                }else{
                    
                    let isSuccess:IsSuccessResponse = IsSuccessResponse.init(dictionary: response)!
                    let errorCode:String = "ERROR_CODE_" + String(isSuccess.errorCode ?? 0)
                    
                    if errorCode == "ERROR_CODE_662"{
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                
            }
        }
    }

    func checkForEstimateTime() -> Bool {
        //        return self.currentOrder.orderStatus == OrderStatus.STORE_ACCEPTED.rawValue && StoreSingleton.shared.store.isAskEstimatedTimeForReadyOrder && !self.self.currentOrder.isUserPickupOrder
        return self.orderDetail.order.orderStatus == OrderStatus.STORE_ACCEPTED.rawValue && StoreSingleton.shared.store.isAskEstimatedTimeForReadyOrder && !self.orderDetail.order.isUserPickUpOrder && (self.orderDetail.requestDetail == nil) && orderDetail.cartDetail.deliveryType != DeliveryType.tableBooking
    }

    func wsCreateRequest(isManuallyAssignProvider:Bool,selectedId:String) {
        Utility.showLoading()
        var dictParam = [String : String]()
        if isManuallyAssignProvider {
            dictParam  =
                [
                    //PARAMS.ORDER_ID:selectedOrder.id,
                    PARAMS.ORDER_ID:orderDetail.order.id,
                    PARAMS.STORE_ID: preferenceHelper.getUserId(),
                    PARAMS.VEHICLE_ID : selectedVehicleId,
                    PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken(),
                    PARAMS.PROVIDER_ID:selectedId]
        } else {
            dictParam  =
                [
                    //PARAMS.ORDER_ID:selectedOrder.id,
                    PARAMS.ORDER_ID:orderDetail.order.id,
                    PARAMS.STORE_ID: preferenceHelper.getUserId(),
                    PARAMS.VEHICLE_ID : selectedVehicleId,
                    PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken()]
        }

        if StoreSingleton.shared.store.isAskEstimatedTimeForReadyOrder {
            dictParam[PARAMS.ESTIMATED_TIME_FOR_READY_ORDER] = estimateTimeForPrepareOrder
        }

        let alamoFire:AlamofireHelper = AlamofireHelper.init()
        print("WS_CREATE_REQUEST \(dictParam)")

        alamoFire.getResponseFromURL(url: WebService.WS_CREATE_REQUEST, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            Utility.hideLoading()
            print("WS_CREATE_REQUEST \(response)")
            
            if Parser.isSuccess(response: response) {
                self.navigationController?.popViewController(animated: true)
            } else {
                //Removed wsGetOrderStatus like Android //Storeapp
                //                self.wsGetOrderStatus()
                self.wsGetOrderDetail()
            }
        }
    }

    func wsRejectOrder(orderStatus:OrderStatus, cancelationReason:String = "") {
        Utility.showLoading()
        let dictParam : [String : Any] =
            [
                //PARAMS.ORDER_ID:selectedOrder.id,
                PARAMS.ORDER_ID:orderDetail.order.id,
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
    
    func wsCompleteOrder() {
        Utility.showLoading()
        let dictParam:[String:String] =
            [PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken(),
             PARAMS.STORE_ID : preferenceHelper.getUserId(),
             //           PARAMS.ORDER_ID : currentOrder.id,
             PARAMS.ORDER_ID : orderDetail.order.id
            ]
        print("WS_COMPLETE_ORDER \(dictParam)")
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_COMPLETE_ORDER, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            
            print("WS_COMPLETE_ORDER \(response)")
            Utility.hideLoading()
            if Parser.isSuccess(response: response) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func wsGetNearestProviderList() {
        Utility.showLoading()
        let dictParam:[String:String] =
            [PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken(),
             PARAMS.STORE_ID : preferenceHelper.getUserId(),
             //             PARAMS.ORDER_ID : currentOrder.id,
             PARAMS.ORDER_ID : orderDetail.order.id,
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
                        
                        //self.selectedVehicleId =  StoreSingleton.shared.adminVehicalList[selectedIndex[0]].vehicleId
                        self.wsCreateRequest(isManuallyAssignProvider: true,selectedId: selectedId)
                        dialog.removeFromSuperview()
                    }
                }
            }
        }
    }

    func wsGetOrderDetail() {
        Utility.showLoading()
        let dictParam : [String : Any] =
            [PARAMS.STORE_ID      : preferenceHelper.getUserId(),
             PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken(),
             PARAMS.ORDER_ID: selectedOrder.id ?? ""]
        print("dictParam WS_GET_ORDER_DETAIL --> \(dictParam)")

        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_GET_ORDER_DETAIL, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            print("response WS_GET_ORDER_DETAIL --> \(Utility.conteverDictToJson(dict: response))")
            //            self.arrOrders.removeAll()
            //            self.arrScheduleOrders.removeAll()
            //            self.arrCurrentOrders.removeAll()
            if Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true) {
                let orderListReponse:OrderDetailsNew = OrderDetailsNew.init(fromDictionary: response)
                self.orderDetail = orderListReponse.order
                self.arrForProducts = self.orderDetail.cartDetail.orderDetails
                self.setUserDetail()
                self.setPrintData()
            }
            //            self.reloadTableWithArray()
            self.updateUI()
            if self.mainOrderTable != nil {
                self.mainOrderTable.reloadData()
            }
            Utility.hideLoading()
        }
    }

    //MARK:- DIALOGS
    func openCancelOrderDialog(status:OrderStatus, list:[String]) {
        let dialogForCancelOrder = CustomCancelOrderDialog.showCustomCancelOrderDialog(title: "TXT_CANCEL_ORDER".localized, message: "", list: list, titleLeftButton: "TXT_CANCEL".localizedUppercase, titleRightButton: "TXT_OK".localizedUppercase)
        
        dialogForCancelOrder.onClickLeftButton =
            { [unowned dialogForCancelOrder] in
                
                dialogForCancelOrder.removeFromSuperview();
            }
        dialogForCancelOrder.onClickRightButton = { [unowned dialogForCancelOrder, unowned self] (cancelReason:String) in
            
            self.wsRejectOrder(orderStatus:status, cancelationReason: cancelReason)
            dialogForCancelOrder.removeFromSuperview();
            
        }
    }
    
    
    func openEstimateTimeDialog() {
        
        let dialogForVerification = CustomVerificationDialog.showCustomVerificationDialog(title: "TXT_TITLE_ESTIMATE_TIME".localized, message: "MSG_DIALOG_ENTER_ESTIMATE_TIME_MESSAGE".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_OK".localized, editTextOneHint: "TXT_HINT_ENTER_ESTIMATE_TIME".localizedCapitalized, editTextTwoHint: "", isEdiTextTwoIsHidden: true, editTextOneInputType: false)
        dialogForVerification.onClickLeftButton = {
            [unowned dialogForVerification, unowned self] in
            
            dialogForVerification.removeFromSuperview();
        }
        dialogForVerification.onClickRightButton = { [unowned dialogForVerification, unowned self]
            (text1:String,text2:String) in
            
            if text1.count > 0
            {
                if text1.isNumber() {
                    dialogForVerification.removeFromSuperview();
                    self.estimateTimeForPrepareOrder = text1
                    self.openVehicleDialog()
                }
                else {
                    Utility.showToast(message:"MSG_ENTER_VALID_ESTIMATE_TIME".localized)
                    
                }
            }else
            {
                Utility.showToast(message: "MSG_ENTER_ESTIMATE_TIME".localized)
            }
        }
    }
    
    func openVerifyDialog() {
        let dialogForVerification = CustomVerificationDialog.showCustomVerificationDialog(title: "TXT_CONFIRMATION_CODE".localized, message: "TXT_ENTER_CODE_MESSAGE".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_OK".localized, editTextOneHint: "TXT_ENTER_CODE".localizedCapitalized, editTextTwoHint: "", isEdiTextTwoIsHidden: true, editTextOneInputType: false)
        dialogForVerification.onClickLeftButton = {
            [unowned dialogForVerification] in
            dialogForVerification.removeFromSuperview();
        }
        dialogForVerification.onClickRightButton = { [unowned dialogForVerification, unowned self]
            
            (text1:String,text2:String) in
            
            if text1.count > 0
            {
                //                if String(self.currentOrder.confirmationCodeForCompleteDelivery!) == text1 {
                if String(self.orderDetail.order.confirmationCodeForCompleteDelivery!) == text1 {
                    dialogForVerification.removeFromSuperview();
                    self.wsCompleteOrder()
                }
                else {
                    Utility.showToast(message:"MSG_ENTER_CONFIRMATION_CODE".localized)

                }
            }else
            {
                Utility.showToast(message: "MSG_ENTER_CODE".localized)
            }
            
        }
    }
    func openVehicleDialog() {
        //        if selectedOrder.orderPaymentDetail.deliveryPriceUsedType == vehicleType {
        if orderDetail.orderPaymentDetail.deliveryPriceUsedType == vehicleType {
            var itemListArray:[(String,Bool)] = []
            
            for i in StoreSingleton.shared.vehicalList {
                itemListArray.append((i.vehicleName,false))
            }
            if itemListArray.isEmpty {
                Utility.showToast(message: "TXT_NO_VEHICLE_AVAILABLE".localized)
            }else {
                //STOREDEV
                //                TableDialog().show(title: "TXT_SELECT_VEHICLE".localized, doneButtonTitle: "TXT_DONE".localized, cancelButtonTitle: "TXT_CANCEL".localized, options: itemListArray, isAllowMultiselect: false) { [unowned self] (selectedIndex) in
                //                    self.selectedVehicleId =  StoreSingleton.shared.vehicalList[selectedIndex[0]].vehicleId
                //                    self.wsCreateRequest(isManuallyAssignProvider: false,selectedId: "")
                //                }
                
                let dialogForLocalizedLanguage = TableviewDialogVehicle.showDialog(languages: [:], title: "",options: itemListArray, isAllowMultiselect: false)
                dialogForLocalizedLanguage.onItemSelected = { [unowned self] (selectedIndex) in
                    if StoreSingleton.shared.adminVehicalList.count > selectedIndex[0]{
                        self.selectedVehicleId =  StoreSingleton.shared.adminVehicalList[selectedIndex[0]].vehicleId
                    }
                    //self.wsCreateRequest()
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
                //STOREDEV
                //                TableDialog().show(title: "TXT_SELECT_VEHICLE".localized, doneButtonTitle: "TXT_DONE".localized, cancelButtonTitle: "TXT_CANCEL".localized, options: itemListArray, isAllowMultiselect: false) { [unowned self] (selectedIndex) in
                //
                //                    self.selectedVehicleId =  StoreSingleton.shared.adminVehicalList[selectedIndex[0]].vehicleId
                //                    self.wsCreateRequest(isManuallyAssignProvider: false,selectedId: "")
                //                }
                
                let dialogForLocalizedLanguage = TableviewDialogVehicle.showDialog(languages: [:], title: "",options: itemListArray, isAllowMultiselect: false)
                dialogForLocalizedLanguage.onItemSelected = { [unowned self] (selectedIndex) in
                    if StoreSingleton.shared.adminVehicalList.count > selectedIndex[0]{
                        self.selectedVehicleId =  StoreSingleton.shared.adminVehicalList[selectedIndex[0]].vehicleId
                    }
                    //self.wsCreateRequest()
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
    
    func setDestinationAddress(address: Address) {
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
        
        lblDeliveryAddress.text = finalAddress
    }
}

extension OrderDetailVC:UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrForProducts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrForProducts[section].items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomOrderDetailCell
        cell.setCellData(itemDetail: arrForProducts[indexPath.section].items![indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //
    //        let sectionHeader = tableView.dequeueReusableCell(withIdentifier: "section")! as! OrderItemSection
    //
    //        sectionHeader.setData(title: (arrForProducts[section].productName))
    //        return sectionHeader
    //
    //    }
    //    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        return (arrForProducts[section].productName)
    //    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    //    func tableView(tableView: UITableView,
    //                   heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
    //
    //        return UITableView.automaticDimension
    //    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
        //        return 25
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
class OrderItemSection: CustomCell {
    @IBOutlet weak var lblSection: CustomPaddingLabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        self.backgroundColor = UIColor.themeViewBackgroundColor
        //        lblSection.backgroundColor = UIColor.themeColor
        //        lblSection.textColor = UIColor.themeButtonTitleColor
        lblSection.font = FontHelper.labelRegular()
    }
    
    func setData(title: String) {
        //        lblSection.text = title.appending("     ")
        lblSection.text = title.localizedUppercase
        //        lblSection.sectionRound(lblSection)
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}


extension OrderDetailVC{
    @objc func handlePrinterConnectedNotification(_ notification: Notification?) {
        print("\n\nconnected\n\n")
        Printers.IS_PRINTER_CONNECTED = true
        //        self.setPrintData()
    }

    @objc func handlePrinterDisconnectedNotification(_ notification: Notification?) {
        print("\n\nDisconnected\n\n")
        Printers.IS_PRINTER_CONNECTED = false
    }
    
    func setPrintData() {

        if Printers.IS_PRINTER_1_CONNECTED{
            strPrintData = ""
            strPrintData = strPrintData + "INVOICE\n"
            strPrintData = strPrintData + "--------------------------------\n"
            strPrintData = strPrintData + "\(self.orderDetail.cartDetail.pickupAddresses[0].userDetails.name!)\n"
            strPrintData = strPrintData + "\(self.orderDetail.cartDetail.pickupAddresses[0].address!)\n"
            strPrintData = strPrintData + "-----------------------------\n"
            strPrintData = strPrintData + "Order No.: #\(self.orderDetail.order.uniqueId!)\n"

            if self.orderDetail.order.createdAt.count > 0{
                strPrintData = strPrintData + "Created: \(Utility.stringToString(strDate: self.orderDetail.order.createdAt!, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_TIME_FORMAT))\n"
            }
            
            if self.orderDetail.order.isScheduleOrder{
                if (self.orderDetail.order.scheduleOrderStartAt).count > 0{
                    strPrintData = strPrintData + "Scheduled: \(Utility.stringToString(strDate: self.orderDetail.order.scheduleOrderStartAt!, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_TIME_FORMAT))\n"
                }
            }

            strPrintData = strPrintData + "-----------------------------\n"

            strPrintData = strPrintData + "\(self.orderDetail.order.userDetail.name!)\n"

            if self.orderDetail.order.userDetail.phone.count > 0{
                strPrintData = strPrintData + "\(self.orderDetail.order.userDetail.phone!)\n"
            }
            strPrintData = strPrintData + "-----------------------------\n"
            
            if self.orderDetail.cartDetail.orderDetails.count > 0 {
                for item in self.orderDetail.cartDetail.orderDetails[0].items {
                    //                strPrintData = strPrintData + "\(String(item.quantity) + " " + item.itemName)" + " " + "\(String((item.totalSpecificationPrice +  item.itemPrice) * Double(item.quantity)))\n"
                    strPrintData = strPrintData + "\(String(item.quantity) + "  " + item.itemName)" + " \(((item.totalSpecificationPrice +  item.itemPrice) * Double(item.quantity)))\n"
                    for spec in item.specifications{

                        //                    self.ticket?.add(block:.kvWithSpaceCalculator(k: "  " + spec.specificationName , v:  "  " + (spec.specificationPrice).toCurrencyString()))
                        strPrintData = strPrintData + "  " + "\(spec.specificationName) \((spec.specificationPrice).toCurrencyString())\n"
                    }

                }
            }
            
            strPrintData = strPrintData + "-----------------------------\n"
            strPrintData = strPrintData + "Sub Total: "+"\((self.orderDetail.orderPaymentDetail.totalCartPrice!))\n"

            if self.orderDetail.cartDetail.totalItemTax > 0{
                strPrintData = strPrintData + "Tax: "+"\(Double(self.orderDetail.cartDetail.totalItemTax!))\n"

            }
            if self.orderDetail.orderPaymentDetail.totalDeliveryPrice > 0.0{
                strPrintData = strPrintData + "Fees: "+"\((self.orderDetail.orderPaymentDetail.totalDeliveryPrice!))\n"
            }
            
            if self.orderDetail.orderPaymentDetail.promoPayment > 0{
                strPrintData = strPrintData + "Discount: "+"\((self.orderDetail.orderPaymentDetail.promoPayment!))\n"
            }
            
            strPrintData = strPrintData + "-----------------------------\n"

            if self.orderDetail.order.total > 0.0{
                strPrintData = strPrintData + "Total: "+"\((self.orderDetail.order.total!))\n"
            }
            
            strPrintData = strPrintData + "-----------------------------\n"

            if self.orderDetail.order.isPaymentModeCash{
                strPrintData = strPrintData + "Paid By Cash"
            } else {
                strPrintData = strPrintData + "Paid By Card"
            }
            print(strPrintData)
        } else {
            //--code Printer 2
            strPrintData = ""

            self.ticket = Ticket()
            //            self.ticket?.add(block:.blank)
            self.ticket?.add(block:.text(.init(content: "INVOICE" , predefined: .bold,.alignment(.center),.scale(.l1))))
            strPrintData = strPrintData + "INVOICE\n"

            self.ticket?.add(block:.text(.init(content: "---------------------------------" ,predefined: .small, .alignment(.center))))
            strPrintData = strPrintData + "-----------------------------\n"

            self.ticket?.add(block:.text(.init(content: "\(self.orderDetail.cartDetail.pickupAddresses[0].userDetails.name!)" , predefined: .small,.alignment(.center))))
            strPrintData = strPrintData + "\(self.orderDetail.cartDetail.pickupAddresses[0].userDetails.name!)\n"

            self.ticket?.add(block:.text(.init(content: "*PAID*" , predefined: .bold,.alignment(.center),.scale(.l1))))
            strPrintData = strPrintData + "*PAID*\n"

            self.ticket?.add(block:.text(.init(content: "\(self.orderDetail.cartDetail.pickupAddresses[0].address!)" , predefined: .small,.alignment(.center))))
            strPrintData = strPrintData + "\(self.orderDetail.cartDetail.pickupAddresses[0].address!)\n"
            
            self.ticket?.add(block:.text(.init(content: "---------------------------------" ,predefined: .small, .alignment(.center))))
            strPrintData = strPrintData + "-----------------------------\n"

            self.ticket?.add(block:.text(.init(content: "Order No." + ": " + "#\((self.orderDetail.order.uniqueId!))", predefined: .bold,.alignment(.center),.scale(.l0))))
            strPrintData = strPrintData + "Order No. : #\(self.orderDetail.order.uniqueId!)\n"

            if self.orderDetail.order.createdAt.count > 0{
                self.ticket?.add(block:.text(.init(content: "Created" + ": " + "\(Utility.stringToString(strDate: self.orderDetail.order.createdAt!, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_TIME_FORMAT))", predefined: .small,.alignment(.left))))
                strPrintData = strPrintData + "Created. : \(Utility.stringToString(strDate: self.orderDetail.order.createdAt!, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_TIME_FORMAT))\n"
            }

            if self.orderDetail.order.isScheduleOrder{
                if (self.orderDetail.order.scheduleOrderStartAt).count > 0{
                    self.ticket?.add(block:.text(.init(content: "Scheduled" + ": " + "\(Utility.stringToString(strDate: self.orderDetail.order.scheduleOrderStartAt!, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_TIME_FORMAT))", predefined: .small,.alignment(.left))))
                    strPrintData = strPrintData + "Scheduled. : \(Utility.stringToString(strDate: self.orderDetail.order.scheduleOrderStartAt!, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_TIME_FORMAT))\n"
                }
            }

            self.ticket?.add(block:.text(.init(content: "---------------------------------" ,predefined: .small, .alignment(.center))))
            strPrintData = strPrintData + "-----------------------------\n"

            self.ticket?.add(block:.text(.init(content: "\(self.orderDetail.order.userDetail.name!)" , predefined: .small,.alignment(.center))))
            strPrintData = strPrintData + "\(self.orderDetail.order.userDetail.name!)\n"

            if self.orderDetail.order.userDetail.phone.count > 0{
                self.ticket?.add(block:.text(.init(content: "\(self.orderDetail.order.userDetail.phone!)" , predefined: .small,.alignment(.center))))
            }
            strPrintData = strPrintData + "\(self.orderDetail.order.userDetail.phone!)\n"

            self.ticket?.add(block:.text(.init(content: "---------------------------------" ,predefined: .small, .alignment(.center))))
            strPrintData = strPrintData + "-----------------------------\n"

            for obj in self.orderDetail.cartDetail.orderDetails {
                for item in obj.items {
                    self.ticket?.add(block:.kvWithSpaceCalculator(k: String(item.quantity) + "  " + item.itemName , v:  "  " + ((item.totalSpecificationPrice +  item.itemPrice) * Double(item.quantity)).toCurrencyString()))
                    strPrintData = strPrintData + "\(String(item.quantity) + "  " + item.itemName)" + " \(((item.totalSpecificationPrice +  item.itemPrice) * Double(item.quantity)).toCurrencyString())\n"
                    for spec in item.specifications{
                        
                        self.ticket?.add(block:.kvWithSpaceCalculator(k: "  " + spec.specificationName , v:  "  " + (spec.specificationPrice).toCurrencyString()))
                        strPrintData = strPrintData + "  " + "\(spec.specificationName) \((spec.specificationPrice).toCurrencyString())\n"
                    }

                }
            }
            
            self.ticket?.add(block:.text(.init(content: "---------------------------------" ,predefined: .small, .alignment(.center))))
            strPrintData = strPrintData + "-----------------------------\n"

            self.ticket?.add(block: .kvWithAttr(k: "Sub Total" + ": ", v: "\((self.orderDetail.orderPaymentDetail.totalCartPrice!).toCurrencyString())", predefined: .bold, .scale(.l0)))
            
            strPrintData = strPrintData + "Sub Total"+"\((self.orderDetail.orderPaymentDetail.totalCartPrice!).toCurrencyString())\n"

            if self.orderDetail.cartDetail.totalItemTax > 0{
                self.ticket?.add(block: .kvWithAttr(k: "Tax" + ": ", v: "\((Double(self.orderDetail.cartDetail.totalItemTax!).toCurrencyString()))", predefined: .bold))
                strPrintData = strPrintData + "Tax"+"\((Double(self.orderDetail.cartDetail.totalItemTax!)).toCurrencyString())\n"

            }
            if self.orderDetail.orderPaymentDetail.totalDeliveryPrice > 0.0{
                self.ticket?.add(block: .kvWithAttr(k: "Fees" + ": ", v: "\((self.orderDetail.orderPaymentDetail.totalDeliveryPrice!).toCurrencyString())", predefined: .bold))
                strPrintData = strPrintData + "Fees"+"\((self.orderDetail.orderPaymentDetail.totalDeliveryPrice!).toCurrencyString())\n"
            }
            
            if self.orderDetail.orderPaymentDetail.promoPayment > 0{
                self.ticket?.add(block: .kvWithAttr(k: "Discount" + ": ", v: "\((self.orderDetail.orderPaymentDetail.promoPayment!).toCurrencyString())", predefined: .bold))
                strPrintData = strPrintData + "Discount"+"\(self.orderDetail.orderPaymentDetail.promoPayment!)\n"
            }
            
            self.ticket?.add(block:.text(.init(content: "---------------------------------" ,predefined: .small, .alignment(.center))))
            strPrintData = strPrintData + "-----------------------------\n"

            if self.orderDetail.order.total > 0.0{
                self.ticket?.add(block: .kvWithAttr(k: "Total" + ": ", v: "\((self.orderDetail.order.total!).toCurrencyString())", predefined: .bold, .scale(.l0)))
                strPrintData = strPrintData + "Total"+"\(self.orderDetail.order.total!)\n"
            }

            self.ticket?.add(block:.text(.init(content: "---------------------------------" ,predefined: .small, .alignment(.center))))
            strPrintData = strPrintData + "-----------------------------\n"

            if self.orderDetail.order.isPaymentModeCash{
                self.ticket?.add(block:.text(.init(content: "Paid By Cash" )))
                strPrintData = strPrintData + "Paid By Cash"
            } else {
                self.ticket?.add(block:.text(.init(content: "Paid By Card" )))
                strPrintData = strPrintData + "Paid By Card"
            }

            print(strPrintData)

            self.ticket?.feedLinesOnHead = 1
            self.ticket?.feedLinesOnTail = 1
        }
    }

    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? BluetoothPrinterSelectTableViewController {
            vc.sectionTitle = "TXT_CHOOSE_BLUETOOTH_PRINTER".localized
            vc.printerManager = printManager
            vc.tableView.tableFooterView = UIView.init()
        }
    }
}

extension OrderDetailVC : CBCentralManagerDelegate{
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        var stateString = "";
        switch(self.bluetoothManager.state)
        {
            case .resetting:
                stateString = "The connection with the system service was momentarily lost, update imminent.";
                //            Utility.showToast(message: stateString)
                break;
            case .unsupported:
                stateString = "The platform doesn't support Bluetooth Low Energy.";
                //            Utility.showToast(message: stateString)

                break;
            case .unauthorized:
                stateString = "The app is not authorized to use Bluetooth Low Energy.";
                //            Utility.showToast(message: stateString)

                break;
            case .poweredOff:
                stateString = "Bluetooth is currently powered off.";
                //            Utility.showToast(message: stateString)

                break;
            case .poweredOn:
                stateString = "Bluetooth is currently powered on and available to use.";
                //            Utility.showToast(message: stateString)

                break;
            default:
                stateString = "State unknown, update imminent.";
                //            Utility.showToast(message: stateString)

                break;
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
