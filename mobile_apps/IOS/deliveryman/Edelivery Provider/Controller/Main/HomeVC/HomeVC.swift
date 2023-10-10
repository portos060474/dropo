//
//  HomeVC.swift
//  Edelivery Provider
//
//  Created by Elluminati iMac on 19/04/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class HomeVC: BaseVC, CLLocationManagerDelegate, GMSMapViewDelegate {
    @IBOutlet weak var imageForAvailableDeliveies: UIImageView!
    @IBOutlet weak var viewForDecline: UIView!
    @IBOutlet weak var lblDeclineMsg: UILabel!
    @IBOutlet weak var lblGoOnlineMsg: UILabel!
    @IBOutlet weak var btnMyCurrentLocation: UIButton!
    @IBOutlet weak var lblAvailableDeliveries: UILabel!
    @IBOutlet weak var lblAvailDeliveriesCount: UILabel!
    @IBOutlet weak var lblAcceptJobs: UILabel!
    @IBOutlet weak var lblGoOffline: UILabel!
    @IBOutlet weak var swicthAcceptJobs: UISwitch!
    @IBOutlet weak var switchGoOnlieOffline: UISwitch!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var viewForDetail: UIView!
    @IBOutlet weak var lblAppName: UILabel!
    @IBOutlet weak var imageForMenu : UIImageView!
    
    public var str = ""
    var animMapDuration:Double = 0.5
    var currentMarker = GMSMarker()
    var locationManager = LocationManager()
    weak var timerUpdateLocation : Timer?
    var isDoAnimation:Bool = false
    
    //MARK:
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setMap()
        
        currentMarker.icon = UIImage(named: "driver_pin_icon")
        currentMarker.map = mapView
        locationManager.autoUpdate = true
        self.setLocalization()
        self.gettingCurrentLocation()
        
        setupRevealViewController()
        self.hideBackButtonTitle()
        self.mapView.addSubview(self.btnMyCurrentLocation);
        
        self.viewForDecline.isHidden = true
    
        self.setLocalization()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        
        self.wsGetRequestCount()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            print("done")
            self.wsGetProviderInfo()
        })
       
        if !preferenceHelper.getProfilePicUrl().isEmpty {
            print("preferenceHelper.getProfilePicUrl() => ",preferenceHelper.getProfilePicUrl())
            self.imageForMenu.downloadedFrom(link: preferenceHelper.getProfilePicUrl())
            self.imageForMenu.contentMode = .scaleAspectFit
            
        }
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setupLayout()
    }
    //MARK:
    //MARK: Set localized
    override func updateUIAccordingToTheme() {
        imageForAvailableDeliveies.image = UIImage.init(named: "AvailableDelivery")!.imageWithColor(color: UIColor.themeIconTintColor)
    }
    
    func firebaseAuthentication(){
        firebaseAuth.signIn(withCustomToken:  preferenceHelper.getAuthToken()) { user, error in
            if error == nil{
                print("Firebase authentication successfull...")
            }
            else{
                print(error ?? "Error in firebase authentication")
            }
        }
    }
    
    func setLocalization() {
        Utility.hideLoading()
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        // IS ONLINE/OFFLINE
        lblGoOnlineMsg.isHidden = true
        
        // COLORS
        viewForDetail.backgroundColor = UIColor.themeViewLightBackgroundColor
        lblDeclineMsg.textColor = UIColor.themeTextColor
        lblDeclineMsg.font = FontHelper.textRegular()
        lblDeclineMsg.text =  "MSG_APPROVE_ERROR".localized
       
        lblAcceptJobs.textColor = UIColor.themeTextColor
        lblAvailableDeliveries.textColor = UIColor.themeTextColor
        lblAvailDeliveriesCount.textColor = UIColor.themeButtonBackgroundColor
        lblAvailDeliveriesCount.textAlignment = .left
        //themeButtonTitleColor
        //lblAvailDeliveriesCount.backgroundColor = UIColor.themeViewLightBackgroundColor
        lblAvailDeliveriesCount.backgroundColor = .clear
        lblGoOffline.textColor = UIColor.themeTextColor
        
        viewForDetail.backgroundColor = UIColor.themeViewBackgroundColor
        lblGoOnlineMsg.textColor = UIColor.black
        // LOCALIZED
        /*set Titles*/
        
        self.title = "APP_NAME".localized
        lblAcceptJobs.text = "TXT_ACCEPT_JOBS".localized
        lblAvailableDeliveries.text = "TXT_AVAILABLE_DELIVERIES".localized
        lblGoOffline.text = "TXT_GO_ONLINE".localized
        lblGoOnlineMsg.text = "TXT_GO_ONLINE_MSG".localized
        
        


        //Set Fonts
        lblAcceptJobs.font = FontHelper.textRegular(size: 15)
        lblGoOffline.font = FontHelper.textRegular(size: 15)
        lblAvailDeliveriesCount.font = FontHelper.textLargest()
        lblAvailableDeliveries.font = FontHelper.textRegular(size: 16)
        lblGoOnlineMsg.font = FontHelper.textMedium(size: 18)
        
        
        
        self.navigationController?.navigationBar.isHidden = true
        
        lblAppName.textColor = .black
        lblAppName.font =  FontHelper.textMedium()
        lblAppName.text = "APP_NAME".localized
        viewForDetail.applyShadowToView(10.0)
        imageForMenu.backgroundColor = .themeLightTextColor
        imageForMenu.setRound(withBorderColor: .themeLightTextColor, andCornerRadious: imageForMenu.frame.height/2, borderWidth: 0.5)
        lblDeclineMsg.textColor = .themeTextColor
        viewForDecline.backgroundColor = .themeViewBackgroundColor
        
        updateUIAccordingToTheme()
        
    }
    //MARK:
    //MARK: Set layouts
    func setupLayout() {
       
    }
    
    func isProviderOnlineOffline() {
        if preferenceHelper.getIsOnlineOffline() == true {
            switchGoOnlieOffline.isOn = true
            lblGoOffline.text = "TXT_GO_OFFLINE".localized
            swicthAcceptJobs.isEnabled = true
            swicthAcceptJobs.isOn =  preferenceHelper.getIsActiveJob()
            self.wsUpdateLocation()
            if timerUpdateLocation == nil {
                timerUpdateLocation = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(HomeVC.wsUpdateLocation), userInfo: nil, repeats: true)
            }
            lblGoOnlineMsg.isHidden = true
            mapView.layer.opacity = 1.0
        }else{
            switchGoOnlieOffline.isOn = false
            preferenceHelper.setIsActiveJob(false)
            lblGoOffline.text = "TXT_GO_ONLINE".localized
            swicthAcceptJobs.isEnabled = false
            swicthAcceptJobs.isOn = false
            lblGoOnlineMsg.isHidden = false
            mapView.layer.opacity = 0.5
            self.stopTimer()
        }
    }
    
    func stopTimer() {
        if timerUpdateLocation != nil {
            timerUpdateLocation?.invalidate()
            timerUpdateLocation = nil
        }
    }
   
    //MARK: Get Current Location
    func gettingCurrentLocation() {
        
        locationManager.currentUpdatingLocation {  [unowned self]  (location,
            error)  in
            
            if ((location?.coordinate.latitude) != nil) && ((location?.coordinate.longitude) != nil) {

                CurrentOrder.shared.bearing = (location?.course) ?? 0.0
                CurrentOrder.shared.currentLatitude = (location?.coordinate.latitude) ?? 0.0
                CurrentOrder.shared.currentLongitude = (location?.coordinate.longitude) ?? 0.0
                self.animateToCurrentLocation()
                let _:[String:Any] =
                    [PARAMS.PROVIDER_ID : preferenceHelper.getUserId(),
                     PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken(),
                     PARAMS.LATITUDE : CurrentOrder.shared.currentLatitude,
                     PARAMS.LONGITUDE : CurrentOrder.shared.currentLongitude,
                     PARAMS.BEARING :CurrentOrder.shared.bearing,
                     "room":preferenceHelper.getUserId()]
            }
        }
    }
    
    
    func setMap() {
        mapView.clear()
        mapView.delegate = self
    }
    
    func animateToCurrentLocation()
    {
        let position:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: CurrentOrder.shared.currentLatitude, longitude: CurrentOrder.shared.currentLongitude)
       
        CATransaction.begin()
        CATransaction.setValue(animMapDuration, forKey: kCATransactionAnimationDuration)
        CATransaction.setCompletionBlock { 
        }
        let camera = GMSCameraPosition.camera(withTarget: position, zoom: 17.0, bearing: CurrentOrder.shared.bearing, viewingAngle: 0.0)
        self.mapView?.animate(to: camera)
        self.currentMarker.position = position
        CATransaction.commit()
        self.animMapDuration = 3.0
     }
    
    //MARK: WS Update Location
    @objc func wsUpdateLocation() {
       
        if preferenceHelper.getSessionToken().isEmpty {
            self.stopTimer()
            return;
        }else {
            if CurrentOrder.shared.currentLatitude != 0.0 && CurrentOrder.shared.currentLongitude != 0.0 {
                let dictParam:[String:Any] =
                    [PARAMS.PROVIDER_ID : preferenceHelper.getUserId(),
                     PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken(),
                     PARAMS.LATITUDE : CurrentOrder.shared.currentLatitude,
                     PARAMS.LONGITUDE : CurrentOrder.shared.currentLongitude,
                     PARAMS.BEARING :CurrentOrder.shared.bearing]

                let afh:AlamofireHelper = AlamofireHelper.init()
                afh.getResponseFromURL(url: WebService.WS_UPDATE_LOCATION, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
                
                    if Parser.isSuccess(response: response,withSuccessToast: false,andErrorToast: false) {
                
                    }
                }
            }
        }
    }
    
    //MARK: Button action methods
    
    @IBAction func onClickAvailDeliveries(_ sender: UIButton) {
        self.navigationController?.navigationBar.isHidden = false
        performSegue(withIdentifier: SEGUE.HOME_TO_AVAIL_DELIVERIES, sender: nil)
        
    }
    @IBAction func onClickBtnCurrentLocation(_ sender: Any) {
        if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() != CLAuthorizationStatus.denied {
            animMapDuration = 0.5;
            self.animateToCurrentLocation()
        }else {
            
            openLocationDialog()
        }
    }

    //MARK: Switch changed value
    @IBAction func changedValue(_ sender: UISwitch) {
        if !switchGoOnlieOffline.isOn {
            swicthAcceptJobs.isOn = false
            
        }
        preferenceHelper.setIsActiveJob(swicthAcceptJobs.isOn)
        wsChangeStatus()
    }
   
    //MARK: Web Service Calls
    func wsChangeStatus() {
        
       
        Utility.showLoading()
        
        let dictParam:[String:Any] =
            [PARAMS.PROVIDER_ID : preferenceHelper.getUserId(),
             PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken(),
             PARAMS.IS_ONLINE : switchGoOnlieOffline.isOn,
             PARAMS.IS_ACTIVE_FOR_JOB: swicthAcceptJobs.isOn]
        
        let afh:AlamofireHelper = AlamofireHelper.init()
        afh.getResponseFromURL(url: WebService.WS_CHANGE_STATUS, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {
            (response, error) -> (Void) in
            if Parser.isSuccess(response: response, withSuccessToast: true, andErrorToast: true) {
                preferenceHelper.setIsOnlineOffline(self.switchGoOnlieOffline.isOn)
                self.isProviderOnlineOffline()
            }else {
                preferenceHelper.setIsOnlineOffline(!self.switchGoOnlieOffline.isOn)
                self.isProviderOnlineOffline()
            }
            Utility.hideLoading()
        }
    }
    
    func wsGetProviderInfo() {
        
        let currentAppVersion: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)
        let afh:AlamofireHelper = AlamofireHelper.init()
        let dictParam : [String : Any] =
            [ PARAMS.PROVIDER_ID: preferenceHelper.getUserId(),
              PARAMS.SERVER_TOKEN: preferenceHelper.getSessionToken(),
              PARAMS.APP_VERSION: currentAppVersion,
              PARAMS.DEVICE_TOKEN: preferenceHelper.getDeviceToken()
        ]

        afh.getResponseFromURL(url: WebService.WS_GET_PROVIDER_INFO, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            Parser.parseUserStorageData(response: response, isShowToast:false,completion: { result in
                if result {
                    DispatchQueue.main.async {
                        let userData:UserDataResponse = UserDataResponse.init(dictionary: response)!
                        let provider:User = userData.user!;
                        CurrentOrder.shared.providerType = provider.provider_type
                        Utility.downloadImageFrom(link: CurrentOrder.shared.mapPinUrl, completion: { (image) in
                            self.currentMarker.icon = image
                        })
                        
                        self.lblAvailDeliveriesCount.text = String(format: "%02d", CurrentOrder.shared.availableOrders)
                        self.isProviderOnlineOffline()
                        if(preferenceHelper.getIsProviderApprove())
                        {
                            if(preferenceHelper.getIsAdminDocumentMandatory() && !preferenceHelper.getIsProviderDocumentUploaded())
                            {
                                self.gotoDocument()
                            }
                            else if (provider.vehicle_ids.isEmpty && !preferenceHelper.getIsAllVehicleDocumentUploaded())
                            {
                                self.gotoManageVehicle()
                            }
                            else
                            {
                                if CurrentOrder.shared.availableOrders == 0
                                {
                                    self.openConfirmationDialog()
                                }
                            }
                        }
                        else
                        {
                            if(preferenceHelper.getIsAdminDocumentMandatory() && !preferenceHelper.getIsProviderDocumentUploaded())
                            {
                                self.gotoDocument()
                            }
                            else if (provider.vehicle_ids.isEmpty && !preferenceHelper.getIsAllVehicleDocumentUploaded())
                            {
                                self.gotoManageVehicle()
                            }
                            else
                            {
                                self.viewForDecline.isHidden = false
                                self.lblAppName.textColor = .themeTextColor
                            }
                        }
                        self.firebaseAuthentication()
                    }
                } else {
                    Utility.hideLoading()
                }});
        }
    }

    func gotoDocument() {
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "Menu", bundle: nil)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isHidden = true
        if let documentVC : DocumentVC = mainView.instantiateViewController(withIdentifier: "DocumentVC") as? DocumentVC {
            self.navigationController?.pushViewController(documentVC, animated: true)
        }
    }
    
    func gotoManageVehicle() {
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "Menu", bundle: nil)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isHidden = true
        if let manageVehicleVC : ManageVehicleListVC = mainView.instantiateViewController(withIdentifier: "ManageVehicleListVC") as? ManageVehicleListVC {
            manageVehicleVC.isComeFirstTime = true;
            self.navigationController?.pushViewController(manageVehicleVC, animated: true)
        }
    }

    func wsGetOtpVerify(_ dictParam:[String:Any]) {
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_OTP_VERIFICATION, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            if Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true) {
                let otpResponse:OtpResponse = OtpResponse.init(dictionary: response)!
                switch (self.checkWhichOtpValidationON()) {
                case CONSTANT.SMS_AND_EMAIL_VERIFICATION_ON:
                    self.openOTPVerifyDialog(otpEmailVerification: otpResponse.otp_for_email ?? "", otpSmsVerification: otpResponse.otp_for_sms ?? "", editTextOneHint:"TXT_EMAIL_OTP".localized, ediTextTwoHint: "TXT_PHONE_OTP".localized, isEditTextTwoIsHidden: false, param: dictParam)
                    break;
                case CONSTANT.SMS_VERIFICATION_ON:
                    self.openOTPVerifyDialog(otpEmailVerification: otpResponse.otp_for_email ?? "", otpSmsVerification: otpResponse.otp_for_sms ?? "", editTextOneHint:"TXT_PHONE_OTP".localized, ediTextTwoHint: "TXT_PHONE_OTP".localized, isEditTextTwoIsHidden: true, param: dictParam)
                    break;
                case CONSTANT.EMAIL_VERIFICATION_ON:
                    self.openOTPVerifyDialog(otpEmailVerification: otpResponse.otp_for_email ?? "", otpSmsVerification: otpResponse.otp_for_sms ?? "", editTextOneHint:"TXT_EMAIL_OTP".localized, ediTextTwoHint: "TXT_PHONE_OTP".localized, isEditTextTwoIsHidden: true, param: dictParam)
                    break;
                default:
                    break;
                }
            }
        }
    }

    //MARK: - Memory Mngmnt
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: - Navigation
    func wsLogout() {
        Utility.showLoading()
        let dictParam : [String : Any] =
            [PARAMS.PROVIDER_ID      : preferenceHelper.getUserId(),
             PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken()
        ]

        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_PROVIDER_LOGOUT, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            if Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true) {
                preferenceHelper.setSessionToken("")
                preferenceHelper.setUserId("")
                APPDELEGATE.goToHome()
                Utility.hideLoading()
            }
        }
    }

    func wsGetRequestCount() {
        let dictParam : [String : Any] =
            [PARAMS.PROVIDER_ID      : preferenceHelper.getUserId(),
             PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken()
        ]

        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_GET_REQUEST_COUNT, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            if Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true) {
                CurrentOrder.shared.availableOrders = (response["request_count"] as? Int) ?? 00
                self.lblAvailDeliveriesCount.text = String(format: "%02d", CurrentOrder.shared.availableOrders)
            }
        }
    }

    //MARK: - User Define Function
    func checkWhichOtpValidationON() -> Int {
        if (checkEmailVerification() && checkPhoneNumberVerification()) {
            return CONSTANT.SMS_AND_EMAIL_VERIFICATION_ON;
        } else if (checkPhoneNumberVerification()) {
            return CONSTANT.SMS_VERIFICATION_ON;
        } else if (checkEmailVerification()) {
            return CONSTANT.EMAIL_VERIFICATION_ON;
        }
        return 0;
    }

    func checkEmailVerification() -> Bool {
        return preferenceHelper.getIsEmailVerification() && !preferenceHelper.getIsEmailVerified()
    }

    func checkPhoneNumberVerification() -> Bool {
        return preferenceHelper.getIsPhoneNumberVerification() && !preferenceHelper.getIsPhoneNumberVerified();
    }

    //MARK: - Dialogs
    func openApprovelDialog() {
        self.stopTimer()
        let dialogForAdminApprove = CustomAlertDialog.showCustomAlertDialog(title: "TXT_ATTENTION".localized, message: "MSG_APPROVE_ERROR".localized, titleLeftButton: "TXT_EXIT".localizedUppercase, titleRightButton: "TXT_LOGOUT".localizedUppercase,tag: 502)
        dialogForAdminApprove.onClickLeftButton = { [unowned dialogForAdminApprove] in
            dialogForAdminApprove.removeFromSuperview();
            exit(0)
        }
        dialogForAdminApprove.onClickRightButton = { [unowned dialogForAdminApprove, unowned self] in
            dialogForAdminApprove.removeFromSuperview();
            self.wsLogout()
        }
    }

    func openLocationDialog() {
        self.stopTimer()
        let dialogForLocation = CustomAlertDialog.showCustomAlertDialog(title: "TXT_ATTENTION".localized, message: "MSG_LOCATION_ENABLE".localized, titleLeftButton: "".localizedUppercase, titleRightButton: "TXT_OK".localizedUppercase,tag: 502)
        dialogForLocation.onClickLeftButton = { [unowned dialogForLocation] in
            dialogForLocation.removeFromSuperview();
        }
        dialogForLocation.onClickRightButton = { [unowned dialogForLocation] in
            dialogForLocation.removeFromSuperview();
        }
    }

    func openConfirmationDialog() {
        var dictParam : [String : Any] =
            [PARAMS.TYPE : CONSTANT.TYPE_PROVIDER,
             PARAMS.ID :preferenceHelper.getUserId()
        ]

        switch (self.checkWhichOtpValidationON()) {
        case CONSTANT.SMS_AND_EMAIL_VERIFICATION_ON:
            let dialogForConfirmation = CustomConfirmationDialog.showCustomConfirmationDialog(title: "TXT_CONFIRMATION_DIALOG".localized, message: "MSG_CONFIRMATION_EMAIL_PHONE".localized, strImage: "menuLogout", titleRightButton: "TXT_SEND".localized, editTextOneText: preferenceHelper.getEmail(), editTextTwoText: preferenceHelper.getPhoneNumber(), isEdiTextTwoIsHidden: false, isEdiTextOneIsHidden: false)
            dialogForConfirmation.onClickRightButton = { (text1:String, text2:String) in
                preferenceHelper.setTempEmail(text1)
                preferenceHelper.setTempPhoneNumber(text2)
                dictParam.updateValue(text1, forKey: PARAMS.EMAIL)
                dictParam.updateValue(text2, forKey: PARAMS.PHONE)
                dictParam.updateValue(preferenceHelper.getPhoneCountryCode(), forKey: PARAMS.COUNTRY_PHONE_CODE)
                dialogForConfirmation.removeFromSuperview();
                self.wsGetOtpVerify(dictParam)
            }
            dialogForConfirmation.onClickLeftButton = { [unowned dialogForConfirmation] in
                dialogForConfirmation.removeFromSuperview();
                self.wsLogout()
            }
            break;
        case CONSTANT.SMS_VERIFICATION_ON:
            let dialogForConfirmation = CustomConfirmationDialog.showCustomConfirmationDialog(title: "TXT_CONFIRMATION_DIALOG".localized, message: "MSG_CONFIRMATION_EMAIL".localized, strImage: "menuLogout", titleRightButton: "TXT_SEND".localized, editTextOneText: "", editTextTwoText: preferenceHelper.getPhoneNumber(), isEdiTextTwoIsHidden: false, isEdiTextOneIsHidden: true)
            dialogForConfirmation.onClickRightButton = { [unowned dialogForConfirmation] (text1:String, text2:String) in
                if text2.isNumber() {
                    dictParam.updateValue(text2, forKey: PARAMS.PHONE)
                    dictParam.updateValue(preferenceHelper.getPhoneCountryCode(), forKey: PARAMS.COUNTRY_PHONE_CODE)
                    preferenceHelper.setTempPhoneNumber(text2)
                    self.wsGetOtpVerify(dictParam)
                    dialogForConfirmation.removeFromSuperview();
                } else {
                    Utility.showToast(message: "MSG_PLEASE_ENTER_VALID_MOBILE_NUMBER".localized);
                }
            }
            dialogForConfirmation.onClickLeftButton = {
                dialogForConfirmation.removeFromSuperview();
                self.wsLogout()
            }
            break;
        case CONSTANT.EMAIL_VERIFICATION_ON:
            let dialogForConfirmation = CustomConfirmationDialog.showCustomConfirmationDialog(title: "TXT_CONFIRMATION_DIALOG".localized, message: "MSG_CONFIRMATION_PHONE".localized, strImage: "menuLogout", titleRightButton: "TXT_SEND".localized, editTextOneText: preferenceHelper.getEmail(), editTextTwoText: "", isEdiTextTwoIsHidden: true, isEdiTextOneIsHidden: false)
            dialogForConfirmation.onClickRightButton = {   [unowned dialogForConfirmation] (text1:String, text2:String) in
                if text1.isValidEmail() {
                    preferenceHelper.setTempEmail(text1)
                    dictParam.updateValue(text1, forKey: PARAMS.EMAIL)
                    dialogForConfirmation.removeFromSuperview();
                    self.wsGetOtpVerify(dictParam)
                } else {
                    Utility.showToast(message: "MSG_PLEASE_ENTER_VALID_EMAIL".localized);
                }
            }
            dialogForConfirmation.onClickLeftButton = {
                dialogForConfirmation.removeFromSuperview();
                self.wsLogout()
            }
            break;
        default:
            self.lblAvailDeliveriesCount.text = String(CurrentOrder.shared.availableOrders)
            break;
        }
    }

    func openOTPVerifyDialog(otpEmailVerification:String, otpSmsVerification:String,editTextOneHint:String, ediTextTwoHint:String, isEditTextTwoIsHidden:Bool, param:[String:Any]) {
        let dialogForVerification = CustomVerificationDialog.showCustomVerificationDialog(title: "TXT_VERIFY_ACCOUNT".localizedCapitalized, message: "MSG_VERIFY_DETAIL".localizedCapitalized, titleLeftButton: "TXT_CANCEL".localizedUppercase, titleRightButton: "TXT_OK".localizedUppercase, editTextOneHint: editTextOneHint, editTextTwoHint:ediTextTwoHint, isEdiTextTwoIsHidden: isEditTextTwoIsHidden, isForVerifyOtp: true, param: param)
        dialogForVerification.startTimer()
        dialogForVerification.onClickRightButton = { [unowned dialogForVerification, unowned self] (text1:String, text2:String) in
            switch (self.checkWhichOtpValidationON()) {
            case CONSTANT.SMS_AND_EMAIL_VERIFICATION_ON:
                if (text1.compare(otpEmailVerification) == ComparisonResult.orderedSame && text2.compare(otpSmsVerification) == ComparisonResult.orderedSame ) {
                    dialogForVerification.removeFromSuperview()
                    self.wsUpdateOtpVerification()
                } else {
                    if !(text1.compare(otpEmailVerification) == ComparisonResult.orderedSame) {
                        Utility.showToast(message: "MSG_EMAIL_OTP_WRONG".localized)
                    } else if !(text2.compare(otpSmsVerification) == ComparisonResult.orderedSame) {
                        Utility.showToast(message: "MSG_SMS_OTP_WRONG".localized)
                    }
                }
                break;
            case CONSTANT.SMS_VERIFICATION_ON:
                if (text1.compare(otpSmsVerification) == ComparisonResult.orderedSame) {
                    dialogForVerification.removeFromSuperview()
                    self.wsUpdateOtpVerification()
                } else {
                    Utility.showToast(message: "MSG_SMS_OTP_WRONG".localized)
                }
                break;
            case CONSTANT.EMAIL_VERIFICATION_ON:
                if (text1.compare(otpEmailVerification) == ComparisonResult.orderedSame) {
                    dialogForVerification.removeFromSuperview()
                    self.wsUpdateOtpVerification()
                } else {
                    Utility.showToast(message: "MSG_EMAIL_OTP_WRONG".localized)
                }
                break;
            default:
                break;
            }
        }
        dialogForVerification.onClickLeftButton = { [unowned dialogForVerification] in
            dialogForVerification.removeFromSuperview();
            self.openConfirmationDialog()
        }
    }

    func wsUpdateOtpVerification() {
        var dictParam : [String : Any] =
            [PARAMS.PROVIDER_ID: preferenceHelper.getUserId(),
             PARAMS.SERVER_TOKEN: preferenceHelper.getSessionToken(),
             ]
        switch (self.checkWhichOtpValidationON()) {
        case CONSTANT.SMS_AND_EMAIL_VERIFICATION_ON:
            dictParam.updateValue(true, forKey: PARAMS.IS_EMAIL_VERIFIED);
            dictParam.updateValue(preferenceHelper.getTempEmail(), forKey: PARAMS.EMAIL)
            dictParam.updateValue(true, forKey: PARAMS.IS_PHONE_NUMBER_VERIFIED);
            dictParam.updateValue(preferenceHelper.getPhoneCountryCode(), forKey: PARAMS.COUNTRY_PHONE_CODE)
            dictParam.updateValue(preferenceHelper.getTempPhoneNumber(), forKey: PARAMS.PHONE)
            break;
        case CONSTANT.EMAIL_VERIFICATION_ON:
            dictParam.updateValue(true, forKey: PARAMS.IS_EMAIL_VERIFIED);
            dictParam.updateValue(preferenceHelper.getTempEmail(), forKey: PARAMS.EMAIL)
            break;
        case CONSTANT.SMS_VERIFICATION_ON:
            dictParam.updateValue(true, forKey: PARAMS.IS_PHONE_NUMBER_VERIFIED);
            dictParam.updateValue(preferenceHelper.getPhoneCountryCode(), forKey: PARAMS.COUNTRY_PHONE_CODE)
            dictParam.updateValue(preferenceHelper.getTempPhoneNumber(), forKey: PARAMS.PHONE)
            break;
        default:
            break;
        }

        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_UPDATE_OTP_VERFICATION, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            if Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true) {
                if preferenceHelper.getIsEmailVerification() {
                    preferenceHelper.setIsEmailVerified(true)
                    preferenceHelper.setEmail(preferenceHelper.getTempEmail())
                }
                if preferenceHelper.getIsPhoneNumberVerification() {
                    preferenceHelper.setIsPhoneNumberVerified(true)
                    preferenceHelper.setPhoneNumber(preferenceHelper.getTempPhoneNumber())
                }
            }
        }
    }
}

extension HomeVC:PBRevealViewControllerDelegate
{
    func setupRevealViewController()
    {
        self.revealViewController()?.delegate = self
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.openSideView))
        imageForMenu.isUserInteractionEnabled = true
        imageForMenu.addGestureRecognizer(tapGestureRecognizer)
    }
    @objc func openSideView() {
        self.revealViewController()?.revealSideView()
    }
    func revealController(_ revealController: PBRevealViewController, willShowLeft viewController: UIViewController) {
        revealController.mainViewController?.view.isUserInteractionEnabled = false;
    }
    func revealController(_ revealController: PBRevealViewController, willHideLeft viewController: UIViewController) {
        revealController.mainViewController?.view.isUserInteractionEnabled = true;
    }
   
   
    
}
