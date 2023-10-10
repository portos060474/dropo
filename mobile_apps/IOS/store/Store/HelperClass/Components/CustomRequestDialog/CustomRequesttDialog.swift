//
//  CustomPhotoDialog.swift
// Edelivery Store
//
//  Created by Jaydeep Vyas on 22/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import UIKit

public class CustomRequestDialog: CustomDialog {
    //MARK: - OUTLETS
    @IBOutlet weak var lblTotalItemPrice: UILabel!
    @IBOutlet weak var stkBtns: UIStackView!
    @IBOutlet weak var lblTotalItemPriceValue: UILabel!
    @IBOutlet weak var lblTitle: UILabel!

    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var alertView: UIView!
    /*OrderDetailView*/
    @IBOutlet weak var viewForOrderDetail: UIView!

    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblStoreName: UILabel!
    @IBOutlet weak var lblOrderNumber: UILabel!

    @IBOutlet weak var lblDestinationAddress: UILabel!
    @IBOutlet weak var btnViewMore: UIButton!
    var isPlaySound:Bool = true;

    //MARK: - Variables
    var strOrderID:String = "0"
    var newOrderData:PushNewOrder = PushNewOrder();
    static let  verificationDialog = "dialogForRequest"
    var orderCounts:Int = 0;

    public static func showCustomRequestDialog(newOrder:[String:Any],tag:Int = 403) -> CustomRequestDialog {
        let view = UINib(nibName: verificationDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomRequestDialog
        view.setLocalization()
        view.tag = tag
        view.alertView.setShadow()

        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame;
        view.newOrderData = PushNewOrder.init(fromDictionary:newOrder)
        view.strOrderID = view.newOrderData.orderDetail.orderId
        view.lblStoreName.text = view.newOrderData.orderDetail.firstName + " " + view.newOrderData.orderDetail.lastName
        view.imgUser.downloadedFrom(link: view.newOrderData.orderDetail.userImage)
        view.lblDestinationAddress.text = view.newOrderData.orderDetail.destinationAddresses[0].address
        view.lblTotalItemPriceValue.text =  (view.newOrderData.orderDetail.totalOrderPrice).toCurrencyString()
        view.orderCounts = view.newOrderData.orderDetail.orderCount
        view.lblOrderNumber.text = "TXT_ORDER_NO".localized + String(view.newOrderData.orderDetail.uniqueId)

        UIApplication.shared.windows.first?.addSubview(view)
        APPDELEGATE.window?.bringSubviewToFront(view);
        UIApplication.shared.windows.first?.animationBottomTOTop(view)
        return view;
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        alertView.applyTopCornerRadius()
    }

    func setLocalization() {
        alertView.backgroundColor = UIColor.themeViewBackgroundColor
        backgroundColor = UIColor.themeOverlayColor
        lblTitle.textColor = UIColor.themeTextColor;
        lblTitle.font = FontHelper.textRegular()
        imgUser.setRound()
//        btnLeft.titleLabel?.font = FontHelper.textRegular(size: 14)
//        btnRight.titleLabel?.font = FontHelper.textRegular(size: 14)
//        btnLeft.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
//        btnRight.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)

        alertView.setRound(withBorderColor: UIColor.clear, andCornerRadious: 3.0, borderWidth: 1.0)
        lblTotalItemPrice.textColor = UIColor.themeTextColor
        lblTotalItemPriceValue.textColor = UIColor.themeTextColor

        lblTotalItemPrice.font = FontHelper.textSmall()
        lblTotalItemPriceValue.font = FontHelper.textMedium()

        self.lblStoreName.font = FontHelper.textMedium()
        self.lblTitle.text = "TXT_REQUEST_ORDER".localized;
        self.btnLeft.setImage(UIImage(named: "cross")?.imageWithColor(color: .themeColor), for: .normal)

//        self.btnLeft.setTitle("TXT_REJECT".localizedUppercase, for: UIControl.State.normal)
        self.btnRight.setTitle("TXT_ACCEPT".localizedUppercase, for: UIControl.State.normal)
        self.btnViewMore.setTitle("TXT_VIEW_MORE".localizedCapitalized, for: .normal)
        self.btnViewMore.setTitleColor(.themeColor, for: .normal)
        self.lblTotalItemPrice.text = "TXT_TOTAL_ORDER_PRICE".localizedCapitalized
    }

    //MARK: - Action Methods
    @IBAction func onClickBtnLeft(_ sender: Any) {
        wsCancelRejectOrder(status:OrderStatus.STORE_REJECTED)
    }

    @IBAction func onClickBtnRight(_ sender: Any) {
        wsChangeOrderStatus(status: OrderStatus.STORE_ACCEPTED)
    }

    @IBAction func onClickBtnViewMore(_ sender: Any) {
        self.removeFromSuperview()
        APPDELEGATE.goToMain()
    }

    //MARK: - ACCEPT REQUEST/CHANGE ORDER STATUS
    func wsChangeOrderStatus(status: OrderStatus) {
        Utility.showLoading()

        let dictParam:[String:Any] =
            [PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken(),
             PARAMS.STORE_ID : preferenceHelper.getUserId(),
             PARAMS.ORDER_ID : strOrderID,
             PARAMS.ORDER_STATUS : status.rawValue]
        print("WS_SET_ORDER_STATUS dictParam \(dictParam)")

        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_SET_ORDER_STATUS, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Utility.hideLoading()
            print("WS_SET_ORDER_STATUS response \(response)")

            if Parser.isSuccess(response: response) {
                self.removeFromSuperview()
            } else {
                self.removeFromSuperview()
            }
        }
    }

    override public func willRemoveSubview(_ subview: UIView) {
        super.willRemoveSubview(subview)
    }

    override public func removeFromSuperview() {
        super.removeFromSuperview()
    }

    //MARK: - TIMERS
    func updateView(count:Int) {
        self.orderCounts = count
        stkBtns.isHidden = true
        btnViewMore.setTitle("TXT_VIEW_MORE".localizedCapitalized + "  " + String(count), for: .normal)
        APPDELEGATE.window?.bringSubviewToFront(self)
    }

    //MARK: - WEB SERVICE CALLS
    func wsCancelRejectOrder(status: OrderStatus) {
        Utility.showLoading()

        let dictParam:[String:Any] =
            [PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken(),
             PARAMS.STORE_ID : preferenceHelper.getUserId(),
             PARAMS.ORDER_ID : strOrderID,
             PARAMS.ORDER_STATUS : status.rawValue,
         ]

        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_CANCEL_REJECT_ORDER, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response) {
                self.removeFromSuperview()
            } else {
                self.removeFromSuperview()
            }
        }
    }
}
