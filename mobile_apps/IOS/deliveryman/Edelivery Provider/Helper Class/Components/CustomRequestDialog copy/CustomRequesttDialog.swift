//
//  CustomPhotoDialog.swift
//  edelivery
//
//  Created by Elluminati on 22/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Stripe

public class CustomRequestDialog: CustomDialog {
   //MARK:- OUTLETS
   @IBOutlet weak var stkBtns: UIStackView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblRemainingSecond: UILabel!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var alertView: UIView!
    /*OrderDetailView*/
    @IBOutlet weak var viewForOrderDetail: UIView!
    @IBOutlet weak var imgStore: UIImageView!
    @IBOutlet weak var lblStoreName: UILabel!
    @IBOutlet weak var lblOrderNumber: UILabel!
    @IBOutlet weak var lbldate: UILabel!
    @IBOutlet weak var btnViewMore: UIButton!
    
    @IBOutlet weak var tblAddress: UITableView!
    @IBOutlet weak var heightAddress: NSLayoutConstraint!
    
    var isPlaySound:Bool = true;
    //MARK:Variables
    var timerLeft : Int = 0
    var strOrderID:String = "101"
    var newOrderData:PushNewOrder = PushNewOrder();
    static let  dialogNibName = "dialogForRequest"
    var orderCounts:Int = 0;
    var player: AVAudioPlayer?// <-- notice here
    /* order detail */
    
    var arrAddress = [Address]()
    
    @IBOutlet weak var lblOrderPrice: UILabel!
    @IBOutlet weak var lblOrderPriceValue: UILabel!
    @IBOutlet weak var lblProfit: UILabel!
    @IBOutlet weak var lblProfitValue: UILabel!
    @IBOutlet weak var lblRequestNumber: UILabel!

    public static func showCustomRequestDialog(newOrder:[String:Any],tag:Int = 503) -> CustomRequestDialog {
        let view = UINib(nibName: dialogNibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomRequestDialog
        view.setLocalization()
        view.tag = tag
        view.alertView.setShadow()
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame;
        view.lblTitle.text = "TXT_REQUEST_ORDER".localized;
        view.lblProfit.text = "TXT_DELIVERYMAN_PROFIT".localized
        view.lblOrderPrice.text = "TXT_ORDER_PRICE".localized

        let newOrder = PushNewOrder.init(fromDictionary:newOrder)
        view.newOrderData = newOrder
        view.arrAddress = newOrder.orderDetail.destinationAddresses
        if let first = newOrder.orderDetail.pickupAddresses.first {
            view.arrAddress.insert(first, at: 0)
        }
        view.tblAddress.reloadData()
        
        view.timerLeft = view.newOrderData.remainingSecond
        view.strOrderID = view.newOrderData.orderDetail.orderId

        //NEW_ORDER_DATE_FORMAT
        let format = view.newOrderData.orderDetail.is_schedule_order ? DATE_CONSTANT.DATE_TIME_AM_PM_FORMAT : DATE_CONSTANT.NEW_ORDER_DATE_FORMAT
        if view.newOrderData.orderDetail.estimateTime.isEmpty {
            let date:String = Utility.stringToString(strDate: view.newOrderData.orderDetail.createdAt!, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat:format)
            view.lbldate.text = date
        } else {
            let date:String = Utility.stringToString(strDate: view.newOrderData.orderDetail.estimateTime!, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat:format)
            view.lbldate.text = "TXT_PICKUP_ORDER_AT".localized + "\n" + date
        }

        if view.newOrderData.orderDetail.deliveryType == DeliveryType.courier {
            view.lblStoreName.text = "TXT_COURIER".localized
            view.lblOrderPriceValue.text = view.newOrderData.orderDetail.total.toCurrencyString()
            view.lblProfitValue.text = ""
        } else {
            view.lblStoreName.text = view.newOrderData.orderDetail.storeName
            view.imgStore.downloadedFrom(link: view.newOrderData.orderDetail.storeImage)
            view.lblOrderPriceValue.text = (view.newOrderData.orderDetail.orderPrice).toCurrencyString()
            view.lblProfitValue.text = view.newOrderData.orderDetail.providerIncome.toCurrencyString()
        }

        view.orderCounts = view.newOrderData.orderDetail.orderCount
        view.lbldate.textColor = UIColor.themeLightGrayTextColor

        view.lblRequestNumber.text = "TXT_REQUEST_NO".localized + String(view.newOrderData.orderDetail.unique_id)
        view.lblOrderNumber.text = "TXT_ORDER_NO".localized + String(view.newOrderData.orderDetail.orderUniqueId)

        view.btnLeft.setTitle("TXT_REJECT".localized, for: UIControl.State.normal)
        view.btnRight.setTitle("TXT_ACCEPT".localized, for: UIControl.State.normal)
        view.btnViewMore.setTitle("TXT_VIEW_MORE".localizedCapitalized, for: .normal)

        view.alertView.layoutIfNeeded()
        view.animationBottomTOTop(view.alertView)

        return view;
    }

    func setLocalization() {
        alertView.backgroundColor = UIColor.white
        backgroundColor = UIColor.themeOverlayColor
        lblTitle.textColor = UIColor.themeTextColor;
        lblRemainingSecond.textColor = UIColor.themeRedColor;

        lblOrderPrice.textColor = UIColor.themeLightTextColor;
        lblProfit.textColor = UIColor.themeLightTextColor;
        lblOrderPriceValue.textColor = UIColor.themeTextColor;
        lblProfitValue.textColor = UIColor.themeTextColor;

        lblRemainingSecond.font = FontHelper.textLargest()
        lblOrderPrice.font = FontHelper.textSmall()
        lblProfit.font = FontHelper.textSmall()
        lblOrderPriceValue.font = FontHelper.textRegular(size: 16)
        lblProfitValue.font = FontHelper.textSmall()

        lblOrderNumber.textColor = UIColor.themeLightTextColor
        lblRequestNumber.textColor = UIColor.themeTextColor

        lblOrderNumber.font = FontHelper.textRegular()
        lblRequestNumber.font = FontHelper.textRegular()

        imgStore.setRound()
        //userpin.image = UIImage.init(named: "user_pin")?.imageWithColor()
        lblStoreName.textColor = .themeTextColor
        btnViewMore.setTitleColor(UIColor.themeColor, for: .normal)

        isPlaySound = true;
        lblStoreName.isHidden = true
        lblOrderPrice.isHidden = true
        btnViewMore.isHidden = self.isViewMoreButtonShow()
        //alertView.setRound(withBorderColor: UIColor.clear, andCornerRadious: 3.0, borderWidth: 1.0)
        btnViewMore.titleLabel?.font = FontHelper.textMedium()
        alertView.backgroundColor = .themeAlertViewBackgroundColor
        lblTitle.font = FontHelper.textLargest()
        self.alertView.updateConstraintsIfNeeded()
        self.alertView.roundCorner(corners: [.topRight , .topLeft], withRadius: 20)
        
        setTableView()
    }
    
    func setTableView() {
        tblAddress.delegate = self
        tblAddress.dataSource = self
        tblAddress.separatorColor = .clear
        tblAddress.rowHeight = UITableView.automaticDimension
        tblAddress.estimatedRowHeight = 40
        tblAddress.register(cellTypes: [AddressCell.self])
        tblAddress.addObserver(self, forKeyPath: "contentSize", options: .new
                               , context: nil)
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        heightAddress.constant = tblAddress.contentSize.height
    }

    func setUpSound() {
        if preferenceHelper.getIsRequesetAlert() {
            let sound = Bundle.main.url(forResource: "beep", withExtension: "mp3")
            do {
                player = try AVAudioPlayer(contentsOf: sound!)
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

    //MARK: - Action Methods
    @IBAction func onClickBtnLeft(_ sender: Any) {
        Utility.showLoading()
        self.stopTimer()
        wsCancelRejectOrder(status:OrderStatus.DELIVERY_MAN_REJECTED)
    }

    @IBAction func onClickBtnRight(_ sender: Any) {
        Utility.showLoading()
        self.stopTimer()
        wsChangeOrderStatus(status: OrderStatus.DELIVERY_MAN_ACCEPTED)
    }

    @IBAction func onClickBtnViewMore(_ sender: Any) {
        self.stopTimer()
        //self.removeFromSuperview()
        APPDELEGATE.closeRequestDialog()
        if let mainview = APPDELEGATE.window?.rootViewController as? PBRevealViewController {
            if let nav1 = mainview.mainViewController as? UINavigationController {
                if nav1.topViewController is AvailableDeliveriesVC {
                    let vc = nav1.topViewController as! AvailableDeliveriesVC
                    vc.tabBar(vc.tabBar, didSelect: vc.tabBar.items![0])
                } else {
                    let mainVC = nav1.viewControllers.first as! HomeVC
                    mainVC.performSegue(withIdentifier: SEGUE.HOME_TO_AVAIL_DELIVERIES, sender: mainVC)
                }
            }
        }
    }

    func isViewMoreButtonShow() -> Bool {
        var show = false
        if let mainview = APPDELEGATE.window?.rootViewController as? PBRevealViewController {
            if let nav1 = mainview.mainViewController as? UINavigationController {
                if nav1.topViewController is AvailableDeliveriesVC {
                    let vc = nav1.topViewController as! AvailableDeliveriesVC
                    //vc.tabBar(vc.tabBar, didSelect: vc.tabBar.items![0])
                    if vc.tabBar.selectedItem ==  vc.tabBar.items?[0] {
                        show = true
                    }
                }
            }
        }
        return show
    }

    //MARK: - ACCEPT REQUEST/CHANGE ORDER STATUS
    func wsChangeOrderStatus(status: OrderStatus) {
        Utility.showLoading()
        let dictParam:[String:Any] =
            [PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken(),
             PARAMS.PROVIDER_ID : preferenceHelper.getUserId(),
             PARAMS.REQUEST_ID : strOrderID,
             PARAMS.DELIVERY_STATUS : status.rawValue]

        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_CHANGE_ORDER_STATUS, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response) {
                if let mainview = APPDELEGATE.window?.rootViewController as? PBRevealViewController {
                    if let nav1 = mainview.mainViewController as? UINavigationController {
                        if nav1.topViewController is HomeVC {
                            let vc = nav1.topViewController as! HomeVC
//                            vc.wsGetProviderInfo()
                            vc.wsGetRequestCount()
                        }
                        if nav1.topViewController is AvailableDeliveriesVC {
                            let vc = nav1.topViewController as! AvailableDeliveriesVC
                            if vc.tabBar.selectedItem == vc.tabBar.items![0] {
                                if vc.vcPendingDelivery != nil {
                                    vc.vcPendingDelivery?.wsGetNewOrder()
                                }
                            }
                        }
                        //self.removeFromSuperview()
                        APPDELEGATE.closeRequestDialog()
                    }
                }
            } else {
                //self.removeFromSuperview()
                APPDELEGATE.closeRequestDialog()
            }
        }
    }

    override public func willRemoveSubview(_ subview: UIView) {
        super.willRemoveSubview(subview)
        self.stopTimer()
    }

    override public func removeFromSuperview() {
        print("animation")
        if alertView != nil {
            self.animationForHideAView(alertView) {
                super.removeFromSuperview()
            }
        }
    }

    //MARK: - TIMERS
    func startTimer() {
        self.watchTimer()
        DispatchQueue.main.async {
            CurrentOrder.shared.timerAcceptReject?.invalidate()
            CurrentOrder.shared.timerAcceptReject = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.watchTimer), userInfo: nil, repeats: true)
        }
    }

    @objc func watchTimer() {
        timerLeft -= 1
        if timerLeft <= 0 {
            self.stopTimer()
            wsCancelRejectOrder(status: OrderStatus.DELIVERY_MAN_REJECTED)
        } else {
            if isPlaySound {
                self.playSound()
            }
            DispatchQueue.main.async {
                self.lblRemainingSecond.text = String(format: "%ds",self.timerLeft)
            }
        }
    }

    func stopTimer() {
        self.player?.stop()
        DispatchQueue.main.async {
            CurrentOrder.shared.timerAcceptReject?.invalidate()
            CurrentOrder.shared.timerAcceptReject = nil
        }
    }

    func updateView(count:Int) {
        isPlaySound = false;
        self.orderCounts = count
        stkBtns.isHidden = true
        btnViewMore.isHidden = false
        btnViewMore.setTitle("TXT_VIEW_MORE".localizedCapitalized + "  " + String(count), for: .normal)
    }

    //MARK: - WEB SERVICE CALLS
    func wsCancelRejectOrder(status: OrderStatus) {
        Utility.showLoading()
        let dictParam:[String:Any] =
            [PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken(),
             PARAMS.PROVIDER_ID : preferenceHelper.getUserId(),
             PARAMS.REQUEST_ID : strOrderID,
             PARAMS.DELIVERY_STATUS : status.rawValue,
         ]

        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_CANCEL_OR_REJECT_ORDER, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response) {
                if let mainview = APPDELEGATE.window?.rootViewController as? PBRevealViewController {
                    if let nav1 = mainview.mainViewController as? UINavigationController {
                        if nav1.topViewController is HomeVC {
                            let vc = nav1.topViewController as! HomeVC
                            vc.wsGetProviderInfo()
                        }
                        if nav1.topViewController is AvailableDeliveriesVC {
                            let vc = nav1.topViewController as! AvailableDeliveriesVC
                            if vc.tabBar.selectedItem == vc.tabBar.items![0] {
                                if vc.vcPendingDelivery != nil {
                                    vc.vcPendingDelivery?.wsGetNewOrder()
                                }
                            }
                        }
                        //self.removeFromSuperview()
                        APPDELEGATE.closeRequestDialog()
                    }
                }
            } else {
                // self.removeFromSuperview()
                APPDELEGATE.closeRequestDialog()
            }
        }
    }
}

extension CustomRequestDialog: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAddress.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
}
