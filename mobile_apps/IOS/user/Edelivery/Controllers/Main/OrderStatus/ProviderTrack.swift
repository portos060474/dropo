//
//  DeliveryLocationVC.swift
//  edelivery
//
//  Created by Elluminati on 14/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
import GoogleMaps

class ProviderTrack: BaseVC,GMSMapViewDelegate,UITextFieldDelegate {
    
    // MARK: - OUTLETS
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var lblProviderRate: UILabel!
    @IBOutlet weak var lblEstTime: UILabel!
    @IBOutlet weak var lblProviderName: UILabel!
    @IBOutlet weak var imgProvider: UIImageView!
    @IBOutlet weak var viewForProviderDetail: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var lblOrderNumber: UILabel!
    @IBOutlet weak var lblOrderStatus: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var lblDeliveredBy: UILabel!
    @IBOutlet weak var lblEstDistance: UILabel!
    @IBOutlet weak var lblDeliveryAt: UILabel!
    @IBOutlet weak var lblDeliveryAddress: UILabel!
    @IBOutlet weak var heightForStackViewForDMOTW: NSLayoutConstraint!
    
    //MARK: - variable
    var myCoordinate:CLLocationCoordinate2D? = nil
    var selectedOrderStatus:OrderStatusResponse = OrderStatusResponse.init()
    var historyOrderResposnse:HistoryOrderDetailResponse? = nil
    var providerId:String = ""
    var providerNumber:String = ""
    weak var timerForOrderStatus: Timer? = nil
    var providerMarker:GMSMarker = GMSMarker.init()
    var deliveryMarker:GMSMarker = GMSMarker.init()
    var isDoAnimation:Bool = false
    var isFromHistory:Bool = false
    var destinationAddress: String = ""
    var requestDetail: HistoryRequestDetail?
   
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalization()
        self.mapView.delegate = self
        if isFromHistory {
            heightForStackViewForDMOTW.constant = 100
            lblDeliveryAddress.text = self.destinationAddress
            lblEstTime.text = "TXT_TIME_HH_MM".localized + "  " + String(Utility.minutToHoursMinutes(minut: historyOrderResposnse!.orderPayment!.total_time!))
            self.lblEstTime.attributedText = Utility.makeParticularStringColored(to: self.lblEstTime.text ?? "", colorString: "TXT_TIME_HH_MM".localized, textColor: UIColor.themeLightGrayColor, fontSize: FontHelper.labelRegular)
            if historyOrderResposnse!.orderPayment!.is_distance_unit_mile {
                lblEstDistance.text = "TXT_DISTANCE".localized + "  " + String(historyOrderResposnse!.orderPayment!.total_distance!) + "UNIT_MILE".localized
            }else {
                lblEstDistance.text = "TXT_DISTANCE".localized + "  " + String(historyOrderResposnse!.orderPayment!.total_distance!) + "UNIT_KM".localized
            }
            self.lblEstDistance.attributedText = Utility.makeParticularStringColored(to: self.lblEstDistance.text ?? "", colorString: "TXT_DISTANCE".localized, textColor: UIColor.themeLightGrayColor, fontSize: FontHelper.labelRegular)
        }
        else {
            heightForStackViewForDMOTW.constant = 50
            currentBooking.deliveryLatLng = selectedOrderStatus.destinationAddresses[0].location
            if !self.selectedOrderStatus.destinationAddresses.isEmpty {
                lblDeliveryAddress.text = (selectedOrderStatus.destinationAddresses.first)?.address
            }
            self.lblEstTime.isHidden = true
            self.lblEstDistance.isHidden = true
        }
        
        self.setProviderData(selectedOrderStatus)
        self.mapView.translatesAutoresizingMaskIntoConstraints = false
        self.mapView.settings.allowScrollGesturesDuringRotateOrZoom = false
        self.mapView.settings.rotateGestures = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.animationBottomTOTop(self.alertView)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        timerForOrderStatus = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(wsGetProviderLocation), userInfo: nil, repeats: true)
        if !isFromHistory {
            
            btnCall.isHidden = false
        }
        else {
            btnCall.isHidden = true
            if self.requestDetail != nil{
                self.setDataFromHistory(self.requestDetail!)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
        self.timerForOrderStatus?.invalidate()
        self.timerForOrderStatus = nil
    }
    
    override func viewDidDisappear(_ animated: Bool){
        super.viewDidDisappear(animated)
    }
    
    func setLocalization() {
        self.view.backgroundColor = UIColor.themeOverlayColor
        self.alertView.backgroundColor = UIColor.themeViewBackgroundColor
        
        /* Set Colors */
        self.lblOrderNumber.textColor = UIColor.themeTextColor
        self.lblOrderStatus.textColor = UIColor.themeTextColor
        self.lblProviderName.textColor = UIColor.themeTextColor
        
        /* Set Localization */
        self.title = "TXT_DELIVERY_LOCATION".localized
        
        /* Set Font */
        self.lblOrderNumber.font = FontHelper.textRegular()
        self.lblOrderStatus.font = FontHelper.textRegular()
        self.lblProviderName.font = FontHelper.textRegular()
        self.lblEstTime.font = FontHelper.labelRegular()
        self.lblEstDistance.font = FontHelper.labelRegular()
        self.lblEstTime.textColor = .themeTextColor
        self.lblEstDistance.textColor = .themeTextColor
        lblTitle.textColor = UIColor.themeTitleColor
        lblTitle.font = FontHelper.textLarge()
        lblTitle.text =  "TXT_DELIVERY_DETAILS".localized
        btnClose.setImage(UIImage(named:"cancelIcon")?.imageWithColor(color: UIColor.themeColor), for: .normal)
        btnClose.tintColor = .themeColor
       
        //Set View hide show
        lblDeliveredBy.textColor = UIColor.themeLightGrayColor
        lblDeliveredBy.font = FontHelper.textSmall()
        lblDeliveredBy.text = "TXT_DELIVERED_BY".localized
        lblDeliveryAt.textColor = UIColor.themeLightGrayColor
        lblDeliveryAt.font = FontHelper.textSmall()
        lblDeliveryAt.text = "TXT_DELIVERED_AT".localized
        lblDeliveryAddress.textColor = UIColor.themeTextColor
        lblDeliveryAddress.font = FontHelper.textRegular()
        btnCall.setImage(UIImage(named:"callIcon")?.imageWithColor(color: .themeTitleColor), for: .normal)
    }
    
    func setupLayout() {
        imgProvider.setRound()
        alertView.roundCorner(corners: [.topLeft, .topRight], withRadius: 20.0)
    }
    override func updateUIAccordingToTheme() {
        btnClose.setImage(UIImage(named:"cancelIcon")?.imageWithColor(color: UIColor.themeColor), for: .normal)
        btnCall.setImage(UIImage(named:"callIcon")?.imageWithColor(color: .themeColor), for: .normal)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    // MARK: - ACTION METHODS
    @IBAction func onClickBtnCall(_ sender: Any) {
        if preferenceHelper.getIsTwillowMaskEnable() {
            TwilioCallMasking.shared.wsTwilloCallMasking(id: currentBooking.selectedOrderId ?? "", type: "\(CONSTANT.TYPE_PROVIDER)")
        } else {
            providerNumber.toCall()
        }
    }
    
    @IBAction func onClickBtnClose(_ sender: Any) {
        
        self.view.animationForHideView(alertView) {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @objc func wsGetProviderLocation() {
        
        let dictParam: Dictionary<String,Any> =
            [PARAMS.USER_ID:preferenceHelper.getUserId(),
             PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken(),
             PARAMS.ORDER_ID:currentBooking.selectedOrderId!,
             PARAMS.PROVIDER_ID:providerId
            ]
        
        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_GET_PROVIDER_LOCATION, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            if (Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: false)) {
                DispatchQueue.main.async
                {
                    let providerLocationResponse:ProviderLocationResponse = ProviderLocationResponse.init(fromDictionary: response as! [String:Any])
                    let location = providerLocationResponse.providerLocation
                    self.setProviderMarker( CLLocationCoordinate2D.init(latitude: (location?[0])!, longitude: (location?[1])!),url: providerLocationResponse.mapPinImageUrl)
                    var mylocationArray:[CLLocationCoordinate2D] = []
                    let providerCoordinate:CLLocationCoordinate2D = self.providerMarker.position
                    mylocationArray.append(CLLocationCoordinate2D.init(latitude: location![0], longitude: location![1]))
                    mylocationArray.append(self.deliveryMarker.position)
                    self.focusMapToShowAllMarkers(loctions: mylocationArray)
                }
            } else {
                if self.timerForOrderStatus != nil {
                    self.timerForOrderStatus?.invalidate()
                    self.timerForOrderStatus = nil
                }
            }
        }
    }
    
    //MARK:- User Define Methods
    func setProviderData(_ orderStatusReponse:OrderStatusResponse) {
        self.lblOrderNumber.text = "TXT_ORDER_NO".localized + String(orderStatusReponse.uniqueId ?? 0)
        self.lblProviderName.text =  orderStatusReponse.provider_detail?.name
        self.imgProvider.downloadedFrom(link: orderStatusReponse.provider_detail?.image_url ?? "", placeHolder: "profile_placeholder")
        providerNumber = orderStatusReponse.provider_detail?.phone as? String ?? ""
        self.lblProviderRate.text = String(orderStatusReponse.userRate)
        if !isFromHistory {
            providerId = orderStatusReponse.providerId
        }
        wsGetProviderLocation()
    }
    func setDataFromHistory(_ requestDetail:HistoryRequestDetail) {
        self.lblProviderName.text =  requestDetail.provider_detail?.name
        self.imgProvider.downloadedFrom(link: requestDetail.provider_detail?.image_url ?? "", placeHolder: "profile_placeholder")
    }
    
    func focusMapToShowAllMarkers(loctions: [CLLocationCoordinate2D]) {
        
        if mapView != nil{
            var bounds = GMSCoordinateBounds()
            for location:CLLocationCoordinate2D in loctions {
                bounds = bounds.includingCoordinate(location)
            }
            if isDoAnimation {
                CATransaction.begin()
                CATransaction.setValue(3.0, forKey: kCATransactionAnimationDuration)
                CATransaction.setCompletionBlock {
                }
                mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 80.0))
                CATransaction.commit()
            }else {
                isDoAnimation = true
                mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 80.0))
            }
        }
    }
    
    func setProviderMarker(_ latLong:CLLocationCoordinate2D, url:String = "") {
        if self.providerMarker.map == nil {
            self.providerMarker.map = mapView
            self.providerMarker.icon = UIImage.init(named: "driver_pin_icon")
            Utility.downloadImageFrom(link: url, completion: { (image) in
                self.providerMarker.icon = image
            })
            
        }
        self.providerMarker.position = latLong
    }
    
    func setUserMarker(_ latLong:CLLocationCoordinate2D) {
        if self.deliveryMarker.map == nil {
            self.deliveryMarker.map = mapView
            self.deliveryMarker.icon = UIImage.init(named: "user_pin_icon")
        }
        self.deliveryMarker.position = latLong
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
