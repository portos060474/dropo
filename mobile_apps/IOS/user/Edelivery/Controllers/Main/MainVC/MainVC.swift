//
//  MainVC.swift
//  edelivery
//
//  Created by Elluminati on 14/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
import FirebaseMessaging
import Firebase
import AVFoundation

class MainVC: BaseVC {

    //MARK: - OUTLET
    @IBOutlet weak var viewForNavigation: UIView!
    @IBOutlet weak var btnNavigation: UIButton!
    @IBOutlet weak var viewQrCodeScan: UIView!
    @IBOutlet weak var btnQrCodeScan: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var stkBottomView: UIStackView!
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnCart: UIButton!
    @IBOutlet weak var btnUser: UIButton!
    @IBOutlet weak var btnHistory: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cvForHome: UIView!
    @IBOutlet weak var cvForUser: UIView!
    @IBOutlet weak var lblStatusbarBg: UILabel!
    @IBOutlet weak var btnProfilePic: UIButton!
    @IBOutlet weak var navigationHeight: NSLayoutConstraint!

    //MARK: - VARIABLE
    var homeVC:HomeVC? = nil
    var userVC:UserVC? = nil
    var isUserScreen:Bool = false
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var isQrUrl: String? = nil
    
    var viewQR = UIView()

    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalization()
        APPDELEGATE.setupNavigationbar()
        if preferenceHelper.getUserId().isEmpty() {
            btnHistory.isHidden = true
        }
        self.btnNavigation.translatesAutoresizingMaskIntoConstraints = false
        self.btnNavigation.imageView?.translatesAutoresizingMaskIntoConstraints = false
        preferenceHelper.setTempEmail(preferenceHelper.getEmail())
        preferenceHelper.setTempPhoneNumber(preferenceHelper.getPhoneNumber())
        showComponents(btnHome)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        if !preferenceHelper.getUserId().isEmpty() {
            self.wsGetUserInfo()
        }
        currentBooking.isQrCodeScanBooking = false
        APPDELEGATE.clearQRUser()
        self.updateTitle()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let url = isQrUrl {
            currentBooking.qrCodeUrl = nil
            isQrUrl = nil
            found(code: url)
        }
        if let url = currentBooking.qrCodeUrl {
            currentBooking.qrCodeUrl = nil
            isQrUrl = nil
            found(code: url)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.cancelQrCodeScan()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    func setupLayout() {
        navigationHeight.constant = 64
        Utility.setupButton(button:btnHome)
        Utility.setupButton(button:btnHistory)
        Utility.setupButton(button:btnUser)
        Utility.setupButton(button:btnCart)
        viewForNavigation.setShadow(shadowColor: UIColor.lightGray.cgColor, shadowOffset: CGSize.init(width: 0.0, height: 1.0), shadowOpacity:0.17, shadowRadius: 2.0)
        bottomView.setShadow(shadowColor: UIColor.lightGray.cgColor, shadowOffset: CGSize(width: 0, height: -1.5), shadowOpacity: 0.3, shadowRadius: 1.0)
        btnProfilePic.applyRoundedCornersWithHeight()
    }

    func setLocalization() {
        view.backgroundColor = UIColor.themeViewBackgroundColor
        self.viewForNavigation.backgroundColor = UIColor.themeViewBackgroundColor
        self.hideBackButtonTitle()

        bottomView.backgroundColor = UIColor.themeViewBackgroundColor
        btnUser.setTitleColor(UIColor.themeLightTextColor, for: .normal)
        btnCart.setTitleColor(UIColor.themeLightTextColor, for: .normal)
        btnHome.setTitleColor(UIColor.themeLightTextColor, for: .normal)
        btnHistory.setTitleColor(UIColor.themeLightTextColor, for: .normal)
        btnUser.setTitleColor(UIColor.themeTextColor, for: .selected)
        btnCart.setTitleColor(UIColor.themeTextColor, for: .selected)
        btnHome.setTitleColor(UIColor.themeTextColor, for: .selected)
        btnHistory.setTitleColor(UIColor.themeTextColor, for: .selected)
        btnHome.setTitle("TXT_HOME".localizedCapitalized, for: UIControl.State.normal)
        btnHistory.setTitle("TXT_ORDERS".localizedCapitalized, for: UIControl.State.normal)
        btnCart.setTitle("TXT_BASKET".localizedCapitalized, for: UIControl.State.normal)

        if preferenceHelper.getUserId().isEmpty() {
            btnUser.setTitle("TXT_LOGIN".localizedCapitalized, for: UIControl.State.normal)
        } else {
            btnUser.setTitle("TXT_ACCOUNT".localizedCapitalized, for: UIControl.State.normal)
        }

        /* Set Font */
        btnUser.titleLabel?.font = FontHelper.textRegular()
        btnHome.titleLabel?.font = FontHelper.textRegular()
        btnHistory.titleLabel?.font = FontHelper.textRegular()
        btnCart.titleLabel?.font = FontHelper.textRegular()
        lblStatusbarBg.backgroundColor = UIColor.themeNavigationBackgroundColor
        viewForNavigation.backgroundColor = UIColor.themeNavigationBackgroundColor
        btnNavigation.setTitleColor(UIColor.themeTitleColor, for: .normal)
        btnNavigation.titleLabel?.font = FontHelper.textMedium()

        self.btnQrCodeScan.tintColor = .themeColor
        self.btnQrCodeScan.setImage(UIImage.init(named: "qrcode")?.imageWithColor(color: .themeColor), for: .normal)
    }

    //MARK: - Button action methods
    @IBAction func onClickBtnQrCodeScan(_ sender: Any) {
        //found(code: "https://webappedeliverynew.appemporio.net/store?store_id=6218923713f863d30f878317&table_id=6218cf50bd7055fe955f7ada&token=QTKXQHUDCHGTUDIH")
        //found(code: "https://webappedelivery.appemporio.net/store?store_id=61b857f880634c722c8ea5eb&table_id=6218cf50bd7055fe955f7ada&token=QTKXQHUDCHGTUDIH")
        //return
        if self.btnQrCodeScan.tag == 0 {
            self.openQrCodeScan()
            self.btnNavigation.isHidden = true
            self.btnProfilePic.isHidden = true
            self.btnQrCodeScan.tag = 1
            self.btnQrCodeScan.setImage(UIImage.init(named: "cancel_icon")?.imageWithColor(color: .themeColor), for: .normal)
        } else {
            self.cancelQrCodeScan()
        }
    }

    @IBAction func onClickBtnNavigation(_ sender: Any) {
        if !isUserScreen {
            if let navigationVC = self.navigationController {
                for controller in navigationVC.viewControllers {
                    if controller.isKind(of: DeliveryLocationVC.self) {
                        self.navigationController?.popToViewController(controller, animated: true)
                        return
                    }
                }
            }
            self.performSegue(withIdentifier: SEGUE.SEGUE_DELIVERY_LOCATION, sender: self)
            return
        }
    }

    @IBAction func showComponents(_ sender: UIButton) {
        btnHome.isSelected = false
        btnCart.isSelected = false
        btnHistory.isSelected = false
        btnUser.isSelected = false
        sender.isSelected = true

        switch sender.tag {
        case 0:
            cvForUser.isHidden = true
            cvForHome.isHidden = false
            isUserScreen = false
            self.updateTitle()
            break
        case 1:
            if let navigationVC = self.navigationController {
                for controller in navigationVC.viewControllers {
                    if controller.isKind(of: CartVC.self) {
                        self.navigationController?.popToViewController(controller, animated: true)
                        return
                    }
                }
            }
            self.performSegue(withIdentifier:SEGUE.SEGUE_CART, sender: self)
            break
        case 2:
            if let navigationVC = self.navigationController {
                for controller in navigationVC.viewControllers {
                    if controller.isKind(of: OrderVC.self) {
                        self.navigationController?.popToViewController(controller, animated: true)
                        return
                    }
                }
            }
            self.performSegue(withIdentifier:SEGUE.SEGUE_ORDER_LIST, sender: self)
            break
        case 3:
            if preferenceHelper.getUserId().isEmpty() {
                APPDELEGATE.goToHome()
                return
            } else {
                cvForUser.isHidden = false
                cvForHome.isHidden = true
                self.btnNavigation.setTitle("TXT_ACCOUNT".localized, for: .normal)
                button.imageView?.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -8.0).isActive = true
                button.imageView?.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: 0.0).isActive = true
                isUserScreen = true
                break
            }
            default: break
        }
    }

    @IBAction func onClickBtnProfile(_ sender: UIButton) {
        if !preferenceHelper.getUserId().isEmpty() {
            self.goToUserTab()
        } else {
            self.goToLogin()
        }
    }

    func goToLogin() {
        let storyboard = UIStoryboard(name: "Prelogin", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HomeStoryBoard") as! Home
        if UIDevice.current.userInterfaceIdiom == .pad {
            vc.modalPresentationStyle = .overCurrentContext
        } else {
            vc.modalPresentationStyle = .popover
        }
        self.present(vc, animated: true, completion: nil)
    }

    func goToUserTab() {
        let storyboard = UIStoryboard(name: "Menu", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UserVC") as! UserVC
        self.navigationController?.pushViewController(vc, animated: true)
    }

    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier?.compare(SEGUE.SEGUE_HOME_TAB) == ComparisonResult.orderedSame {
            homeVC = (segue.destination as! HomeVC)
        } else if segue.identifier?.compare(SEGUE.SEGUE_USER_TAB) == ComparisonResult.orderedSame {
            userVC = (segue.destination as! UserVC)
        } else if segue.identifier?.compare(SEGUE.SEGUE_DELIVERY_LOCATION) == ComparisonResult.orderedSame {
            let destVC = (segue.destination as! DeliveryLocationVC)
            destVC.delegateCheckDeliveryList = self
        }
    }

    //MARK: - Web Service Call
    func wsGetUserInfo() {
        let currentAppVersion: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)
        let afh:AlamofireHelper = AlamofireHelper.init()
        let dictParam : [String : Any] = [
            PARAMS.USER_ID: preferenceHelper.getUserId(),
            PARAMS.SERVER_TOKEN: preferenceHelper.getSessionToken(),
            PARAMS.APP_VERSION: currentAppVersion,
            PARAMS.DEVICE_TOKEN: preferenceHelper.getDeviceToken(),
            PARAMS.IPHONE_ID: preferenceHelper.getRandomCartID()
        ]
        print(dictParam)

        afh.getResponseFromURL(url: WebService.WS_GET_USER_INFO, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            print(response)
            Parser.parseUserStorageData(response: response, completion: { result in
                if preferenceHelper.getProfilePicUrl() != "" {
                    self.btnProfilePic?.sd_setImage(with: URL.init(string: WebService.BASE_URL_ASSETS+preferenceHelper.getProfilePicUrl()), for: .normal, placeholderImage: UIImage(named:"profile_placeholder"))
                } else {
                    self.btnProfilePic?.setImage(UIImage(named:"profile_placeholder"), for: .normal)
                }

                if result {
                    if(preferenceHelper.getIsUserApprove()) {
                        if(preferenceHelper.getIsAdminDocumentMandatory() && !preferenceHelper.getIsUserDocumentUploaded()) {
                            self.gotoDocument()
                            return
                        } else {
                            DispatchQueue.main.async {
                                if currentBooking.currentRunningOrder == 0 {
                                    self.openConfirmationDialog()
                                }
                            }
                        }
                    } else {
                        if(preferenceHelper.getIsAdminDocumentMandatory() && !preferenceHelper.getIsUserDocumentUploaded()) {
                            self.gotoDocument()
                            return
                        } else {
                            self.openApprovelDialog()
                        }
                    }
                } else {
                    return
                }
            })

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                CurrentBooking.shared.PushNotification = false
                print ("CurrentBooking.shared.logout = ",CurrentBooking.shared.PushNotification)
            }
        }
    }

    func gotoDocument() {
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "Menu", bundle: nil)
        if let documentVC : DocumentVC = mainView.instantiateViewController(withIdentifier: "DocumentVC") as? DocumentVC {
            self.navigationController?.pushViewController(documentVC, animated: true)
        }
    }

    func wsLogout() {
       APPDELEGATE.removeFirebaseTokenAndTopic()
        Utility.showLoading()
        let dictParam : [String : Any] =
            [PARAMS.USER_ID      : preferenceHelper.getUserId(),
             PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken() ,
        ]

        let alamoFire:AlamofireHelper = AlamofireHelper()
        alamoFire.getResponseFromURL(url: WebService.WS_USER_LOGOUT, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            if Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true) {
                preferenceHelper.setSessionToken("")
                preferenceHelper.setUserId("")
                preferenceHelper.setRandomCartID(String.random(length: 20))
                APPDELEGATE.goToHome()
                APPDELEGATE.clearFavoriteAddressEntity()
                APPDELEGATE.clearDeliveryLocationEntity()
                return
            }
        }
    }
    
    func wsGetOtpVerify(_ dictParam:[String:Any]){
        let alamoFire:AlamofireHelper = AlamofireHelper()
        alamoFire.getResponseFromURL(url: WebService.WS_OTP_VERIFICATION, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            if Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true) {
                let otpResponse:OtpResponse = OtpResponse.init(dictionary: response)!
                switch (self.checkWhichOtpValidationON())
                {
                case CONSTANT.SMS_AND_EMAIL_VERIFICATION_ON:
                    self.openOTPVerifyDialog(otpEmailVerification: otpResponse.otp_for_email ?? "", otpSmsVerification: otpResponse.otp_for_sms ?? "", editTextOneHint:"TXT_EMAIL_OTP".localized, ediTextTwoHint: "TXT_PHONE_OTP".localized, isEditTextTwoIsHidden: false, param: dictParam)
                    break
                case CONSTANT.SMS_VERIFICATION_ON:
                    self.openOTPVerifyDialog(otpEmailVerification: otpResponse.otp_for_email ?? "", otpSmsVerification: otpResponse.otp_for_sms ?? "", editTextOneHint:"TXT_PHONE_OTP".localized, ediTextTwoHint: "TXT_PHONE_OTP".localized, isEditTextTwoIsHidden: true, param: dictParam)
                    break
                case CONSTANT.EMAIL_VERIFICATION_ON:
                    self.openOTPVerifyDialog(otpEmailVerification: otpResponse.otp_for_email ?? "", otpSmsVerification: otpResponse.otp_for_sms ?? "", editTextOneHint:"TXT_EMAIL_OTP".localized, ediTextTwoHint: "TXT_PHONE_OTP".localized, isEditTextTwoIsHidden: true, param: dictParam)
                    break
                default:
                    break
                }
            }
        }
    }

    func wsUpdateOtpVerification() {
        var dictParam : [String : Any] =
            [PARAMS.USER_ID: preferenceHelper.getUserId(),
             PARAMS.SERVER_TOKEN: preferenceHelper.getSessionToken(),
        ]
        if preferenceHelper.getIsEmailVerification() && !preferenceHelper.getIsEmailVerified() {
            dictParam.updateValue(true, forKey: PARAMS.IS_EMAIL_VERIFIED)
            dictParam.updateValue(preferenceHelper.getTempEmail(), forKey: PARAMS.EMAIL)
        }
        if preferenceHelper.getIsPhoneNumberVerification() && !preferenceHelper.isProxy() {
            dictParam.updateValue(true, forKey: PARAMS.IS_PHONE_NUMBER_VERIFIED)
            dictParam.updateValue(preferenceHelper.getPhoneCountryCode(), forKey: PARAMS.COUNTRY_PHONE_CODE)
            dictParam.updateValue(preferenceHelper.getTempPhoneNumber(), forKey: PARAMS.PHONE)
        }

        let alamoFire:AlamofireHelper = AlamofireHelper()
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
                self.showComponents(self.btnHome)
            }
        }
    }

    //MARK: - User Define Function
    func checkWhichOtpValidationON() -> Int {
        if (checkEmailVerification() && checkPhoneNumberVerification()) {
            return CONSTANT.SMS_AND_EMAIL_VERIFICATION_ON
        } else if (checkPhoneNumberVerification()) {
            return CONSTANT.SMS_VERIFICATION_ON
        } else if (checkEmailVerification()) {
            return CONSTANT.EMAIL_VERIFICATION_ON
        }
        return 0
    }

    func checkEmailVerification() -> Bool {
        return preferenceHelper.getIsEmailVerification() && !preferenceHelper.getIsEmailVerified()
    }

    func checkPhoneNumberVerification() -> Bool {
        return preferenceHelper.getIsPhoneNumberVerification() && !preferenceHelper.getIsPhoneNumberVerified()
    }

    //MARK: - Dialogs
    func openApprovelDialog() {
        let dialogForAdminApprove = CustomAlertDialog.showCustomAlertDialog(title: "TXT_ATTENTION".localized, message: "MSG_APPROVE_ERROR".localized, titleLeftButton: "".localizedCapitalized, titleRightButton: "TXT_LOGOUT".localizedCapitalized)
        dialogForAdminApprove.btnLeft.isHidden = true
        dialogForAdminApprove.onClickLeftButton = { [unowned dialogForAdminApprove] in
            dialogForAdminApprove.removeFromSuperview()
            exit(0)
        }
        dialogForAdminApprove.onClickRightButton = { [unowned dialogForAdminApprove] in
            APPDELEGATE.removeFirebaseTokenAndTopic()
            preferenceHelper.setSessionToken("")
            preferenceHelper.setUserId("")
            APPDELEGATE.goToHome()
            dialogForAdminApprove.removeFromSuperview()
            return
        }
    }

    func openConfirmationDialog() {
        var dictParam : [String : Any] =
            [PARAMS.TYPE : CONSTANT.TYPE_USER,
             PARAMS.ID :preferenceHelper.getUserId(),
             PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken()
        ]
        switch (self.checkWhichOtpValidationON()) {

        case CONSTANT.SMS_AND_EMAIL_VERIFICATION_ON:
            let dialogForConfirmation = CustomConfirmationDialog.showCustomConfirmationDialog(title: "TXT_CONFIRMATION_DIALOG".localized, message: "MSG_CONFIRMATION_EMAIL_PHONE".localized, titleLeftButton: "TXT_LOGOUT".localized, titleRightButton: "TXT_SEND".localized, editTextOneText: preferenceHelper.getEmail(), editTextTwoText: preferenceHelper.getPhoneNumber(), isEdiTextTwoIsHidden: false, isEdiTextOneIsHidden: false)
            dialogForConfirmation.onClickRightButton = { [unowned self, unowned dialogForConfirmation] (text1:String, text2:String) in
                let validMobileNumber = text2.isValidMobileNumber()
                if text1.isValidEmail() && validMobileNumber.0 == true {
                    preferenceHelper.setTempEmail(text1)
                    preferenceHelper.setTempPhoneNumber(text2)
                    dictParam.updateValue(text1, forKey: PARAMS.EMAIL)
                    dictParam.updateValue(text2, forKey: PARAMS.PHONE)
                    dictParam.updateValue(preferenceHelper.getPhoneCountryCode(), forKey: PARAMS.COUNTRY_PHONE_CODE)
                    dialogForConfirmation.removeFromSuperview()
                    self.wsGetOtpVerify(dictParam)
                } else {
                    Utility.showToast(message: "MSG_PLEASE_ENTER_VALID_EMAIL_OR_PHONE_NUMBER".localized)
                }
            }
            dialogForConfirmation.onClickLeftButton = { [unowned dialogForConfirmation] in
                self.wsLogout()
                dialogForConfirmation.removeFromSuperview()
            }
            break

        case CONSTANT.SMS_VERIFICATION_ON:
            let dialogForConfirmation = CustomConfirmationDialog.showCustomConfirmationDialog(title: "TXT_CONFIRMATION_DIALOG".localized, message: "MSG_CONFIRMATION_PHONE".localized, titleLeftButton: "TXT_LOGOUT".localized, titleRightButton: "TXT_SEND".localized, editTextOneText: "", editTextTwoText: preferenceHelper.getPhoneNumber(), isEdiTextTwoIsHidden: false, isEdiTextOneIsHidden: true)
            dialogForConfirmation.onClickRightButton = { [unowned self,unowned dialogForConfirmation] (text1:String, text2:String) in
                let validMobileNumber = text2.isValidMobileNumber()
                if validMobileNumber.0 == true {
                    dictParam.updateValue(text2, forKey: PARAMS.PHONE)
                    dictParam.updateValue(preferenceHelper.getPhoneCountryCode(), forKey: PARAMS.COUNTRY_PHONE_CODE)
                    preferenceHelper.setTempPhoneNumber(text2)
                    dialogForConfirmation.removeFromSuperview()
                    self.wsGetOtpVerify(dictParam)
                } else {
                    Utility.showToast(message: validMobileNumber.1)
                }
            }
            dialogForConfirmation.onClickLeftButton = {[unowned dialogForConfirmation] in
                self.wsLogout()
                dialogForConfirmation.removeFromSuperview()}
            break

        case CONSTANT.EMAIL_VERIFICATION_ON:
            let dialogForConfirmation = CustomConfirmationDialog.showCustomConfirmationDialog(title: "TXT_CONFIRMATION_DIALOG".localized, message: "MSG_CONFIRMATION_EMAIL".localized, titleLeftButton: "TXT_LOGOUT".localized, titleRightButton: "TXT_SEND".localized, editTextOneText: preferenceHelper.getEmail(), editTextTwoText: "", isEdiTextTwoIsHidden: true, isEdiTextOneIsHidden: false)
            dialogForConfirmation.onClickRightButton = { [unowned self,unowned dialogForConfirmation] (text1:String, text2:String) in
                if text1.isValidEmail() {
                    preferenceHelper.setTempEmail(text1)
                    dictParam.updateValue(text1, forKey: PARAMS.EMAIL)
                    dialogForConfirmation.removeFromSuperview()
                    self.wsGetOtpVerify(dictParam)
                } else {
                    Utility.showToast(message: "MSG_PLEASE_ENTER_VALID_EMAIL".localized)
                }
            }
            dialogForConfirmation.onClickLeftButton = { [unowned dialogForConfirmation] in
                dialogForConfirmation.removeFromSuperview()
                self.wsLogout()
            }
            break
        default:
            break
        }
    }

    func openOTPVerifyDialog(otpEmailVerification:String, otpSmsVerification:String,editTextOneHint:String, ediTextTwoHint:String, isEditTextTwoIsHidden:Bool, param:[String:Any]) {
        let dialogForVerification = CustomVerificationDialog.showCustomVerificationDialog(title: "TXT_VERIFY_ACCOUNT".localizedCapitalized, message: "MSG_VERIFY_DETAIL".localizedCapitalized, titleLeftButton: "".localizedCapitalized, titleRightButton: "TXT_OK".localizedCapitalized, editTextOneHint: editTextOneHint, editTextTwoHint:ediTextTwoHint, isEdiTextTwoIsHidden: isEditTextTwoIsHidden, isForVerifyOtp: true, param: param, isFromMainVC: true)
        dialogForVerification.startTimer()
        dialogForVerification.onClickRightButton = { [unowned self, unowned dialogForVerification] (text1:String, text2:String) in
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
                break
            case CONSTANT.SMS_VERIFICATION_ON:
                if (text1.compare(otpSmsVerification) == ComparisonResult.orderedSame) {
                    dialogForVerification.removeFromSuperview()
                    self.wsUpdateOtpVerification()
                } else {
                    Utility.showToast(message: "MSG_SMS_OTP_WRONG".localized)
                }
                break
            case CONSTANT.EMAIL_VERIFICATION_ON:
                if (text1.compare(otpEmailVerification) == ComparisonResult.orderedSame) {
                    dialogForVerification.removeFromSuperview()
                    self.wsUpdateOtpVerification()
                } else {
                    Utility.showToast(message: "MSG_EMAIL_OTP_WRONG".localized)
                }
                break
            default:
                break
            }
        }
        dialogForVerification.onClickLeftButton = {
            dialogForVerification.removeFromSuperview()
            self.wsLogout()
        }
    }

    func updateTitle() {
        var startTitle = ""
        var strTitle = "TXT_ASAP".localizedUppercase
        startTitle = "TXT_ASAP".localizedUppercase

        if currentBooking.isFutureOrder {
            startTitle = "TXT_SCHEDULE".localizedUppercase
            strTitle = "TXT_SCHEDULE".localizedUppercase
        }

        if (((currentBooking.currentAddress != nil)) && !((currentBooking.bookCityId?.isEmpty()) ?? true)) {
            strTitle += (" " + currentBooking.currentAddress)
        } else {
            strTitle = "APP_NAME".localized
            startTitle = "APP_NAME".localized
        }

        let attributedTitle =  Utility.makeParticularStringColored(to: strTitle, colorString: startTitle, textColor: UIColor.themeColor, fontSize: FontHelper.regular)
        self.btnNavigation.setAttributedTitle(attributedTitle, for: .normal)
    }
}

extension MainVC : DelegateDeliveryListChanged {

    func didChangeDeliveryList() {
        homeVC?.lastSelectedDeliveryIndex = 0
        homeVC?.checkForStoreList()
    }
}

extension MainVC: AVCaptureMetadataOutputObjectsDelegate {

    func openQrCodeScan() {
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            failed()
            return
        }

        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            failed()
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        viewQR.frame = CGRect.init(x: 0, y: self.viewForNavigation.frame.origin.y + self.viewForNavigation.frame.height, width: self.view.frame.width, height: self.view.frame.height - self.viewForNavigation.frame.height)
        self.view.addSubview(viewQR)
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = viewQR.bounds
        previewLayer.videoGravity = .resizeAspectFill
        viewQR.layer.addSublayer(previewLayer)
        captureSession.startRunning()
    }

    func cancelQrCodeScan() {
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }

        if previewLayer != nil {
            previewLayer.removeFromSuperlayer()
        }
        self.viewQR.removeFromSuperview()
        self.btnNavigation.isHidden = false
        self.btnProfilePic.isHidden = false
        self.btnQrCodeScan.tag = 0
        self.btnQrCodeScan.setImage(UIImage.init(named: "qrcode")?.imageWithColor(color: .themeColor), for: .normal)
    }

    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { ok in
            self.captureSession = nil
            self.cancelQrCodeScan()
        }))
        present(ac, animated: true)
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        dismiss(animated: true)
    }

    func found(code: String) {
        print(code)
        let dict:[String:String] = URL.init(string: code)?.queryDictionary ?? [:]
        print(dict)
        if dict[PARAMS.STORE_ID] != nil {
            if let storeId = dict[PARAMS.STORE_ID], let tableId = dict[PARAMS.TABLE_ID] {
                currentBooking.isQrCodeScanBooking = true
                currentBooking.deliveryType = DeliveryType.tableBooking
                
                self.cancelQrCodeScan()
                currentBooking.tableID = tableId
                homeVC?.selectedStoreItem = nil
                homeVC?.goToProductVC(storeID: storeId)
            }
        }
    }
}

extension URL {
    var queryDictionary: [String: String]? {
        guard let query = self.query else {
            return nil
        }
        var queryStrings = [String: String]()
        for pair in query.components(separatedBy: "&") {
            if pair.contains("=") {
                let key = pair.components(separatedBy: "=")[0]
                let value = pair
                    .components(separatedBy:"=")[1]
                    .replacingOccurrences(of: "+", with: " ")
                    .removingPercentEncoding ?? ""
                queryStrings[key] = value
            }
        }
        return queryStrings
    }
}
