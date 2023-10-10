//
//  ProfileVC.swift
//  edelivery
//
//  Created by Elluminati on 28/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class ProfileVC: BaseVC,RightDelegate,UITextFieldDelegate {

    //MARK: - Outlets Declaration
    @IBOutlet weak var viewForProfile: UIView!
    @IBOutlet weak var scrProfile: UIScrollView!
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var btnChangePassword: UIButton!
    @IBOutlet weak var lblTransparent: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var btnUploadImage: UIButton!
    @IBOutlet weak var lblDivider: UILabel!
    @IBOutlet weak var viewForChangePassword: UIView!
    @IBOutlet weak var imgForRefral: UIImageView!
    @IBOutlet weak var lblForRefral: UILabel!
    @IBOutlet weak var viewForReferral: CustomCardView!
    @IBOutlet weak var btnShowHidePassword: UIButton!
    @IBOutlet weak var btnShowHideConfirmPassword: UIButton!
    @IBOutlet weak var viewForNewPassword: UIView!
    @IBOutlet weak var viewForConfirmPassword: UIView!
    @IBOutlet weak var btnDeleteAccount: UIButton!

    //MARK: - Variable Declaration
    var isPicAdded:Bool = false
    var dialogForImage:CustomPhotoDialog?;
    var password:String = "";
    var arrForCountryList:[CountryModal] = []
    var strCountryCode:String = ""

    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        delegateRight = self
        setLocalization()
        setProfileData()
        enableTextFields(enable: false)

        if preferenceHelper.getIsShowOptionalFieldInRegister() {
            self.txtAddress.isHidden = false
        } else {
            self.txtAddress.isHidden = true
        }

        self.getCountriesFromJson()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews();
        viewForProfile.setRound()
    }

    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews();
    }

    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }

    override func viewDidDisappear(_ animated: Bool){
        super.viewDidDisappear(animated)
    }

    @IBAction func onClickBtnShowHidePassword(_ sender: Any) {
        if self.txtNewPassword.isSecureTextEntry {
            self.txtNewPassword.isSecureTextEntry = false
            self.btnShowHidePassword.setBackgroundImage(UIImage.init(named: "passwordShow"), for: .normal)
        } else {
            self.txtNewPassword.isSecureTextEntry = true
            self.btnShowHidePassword.setBackgroundImage(UIImage.init(named: "passwordHide"), for: .normal)
        }
    }

    @IBAction func onClickBtnShowHideConfirmPassword(_ sender: Any) {
        if self.txtConfirmPassword.isSecureTextEntry {
            self.txtConfirmPassword.isSecureTextEntry = false
            self.btnShowHidePassword.setBackgroundImage(UIImage.init(named: "passwordShow"), for: .normal)
        } else {
            self.txtConfirmPassword.isSecureTextEntry = true
            self.btnShowHidePassword.setBackgroundImage(UIImage.init(named: "passwordHide"), for: .normal)
        }
    }

    func setLocalization() {
        /*set colors*/
        self.view.backgroundColor = UIColor.themeViewBackgroundColor;
        self.scrProfile.backgroundColor = UIColor.themeViewBackgroundColor;
        txtFirstName.textColor = UIColor.themeTextColor
        txtLastName.textColor = UIColor.themeTextColor
        txtEmail.textColor = UIColor.themeTextColor
        txtNewPassword.textColor = UIColor.themeTextColor
        txtConfirmPassword.textColor = UIColor.themeTextColor
        txtMobileNumber.textColor = UIColor.themeTextColor
        txtAddress.textColor = UIColor.themeTextColor
        lblCountryCode.textColor = UIColor.themeTextColor
        lblDivider.backgroundColor = UIColor.themeLightTextColor
        lblMobileNumber.textColor = UIColor.themeLightTextColor
        lblTransparent.backgroundColor = UIColor.themeViewLightBackgroundColor
        btnChangePassword.setTitleColor(UIColor.themeColor, for: .normal)

        /*Set Place Holder*/
        txtFirstName.placeholder = "TXT_FIRST_NAME".localizedCapitalized
        txtLastName.placeholder = "TXT_LAST_NAME".localizedCapitalized
        txtEmail.placeholder = "TXT_EMAIL".localizedCapitalized
        txtNewPassword.placeholder = "TXT_NEW_PASSWORD".localizedCapitalized
        txtConfirmPassword.placeholder = "TXT_CONFIRM_PASSWORD".localizedCapitalized
        txtMobileNumber.placeholder = "TXT_MOBILE_NO".localizedCapitalized
        txtAddress.placeholder = "TXT_ADDRESS".localizedCapitalized
        lblCountryCode.text = "TXT_DEFAULT".localizedCapitalized
        self.setRightBarItem(isNative: false)
        self.setRightBarItemImage(image: UIImage.init(named: "editBlackIcon")!)
        btnChangePassword.setTitle("TXT_CHANGE_PASSWORD".localized, for: .normal)
        lblMobileNumber.text = "TXT_MOBILE_NO".localizedCapitalized

        /*Set Text*/
        title  = "TXT_PROFILE".localized
        lblCountryCode.text = "TXT_DEFAULT".localized;
        txtFirstName.text = "".localizedCapitalized
        txtLastName.text = "".localizedCapitalized
        txtEmail.text = "".localizedCapitalized
        txtMobileNumber.text = "".localizedCapitalized
        txtAddress.text = "".localizedCapitalized
        txtNewPassword.text = "".localizedCapitalized
        txtConfirmPassword.text = "".localizedCapitalized
        lblCountryCode.text = "TXT_DEFAULT".localizedCapitalized

        /*Set Font*/
        lblCountryCode.font = FontHelper.textRegular()
        txtFirstName.font = FontHelper.textRegular()
        txtLastName.font = FontHelper.textRegular()
        txtEmail.font = FontHelper.textRegular()
        txtMobileNumber.font = FontHelper.textRegular()
        txtAddress.font = FontHelper.textRegular()
        txtNewPassword.font = FontHelper.textRegular()
        txtConfirmPassword.font = FontHelper.textRegular()
        lblCountryCode.font = FontHelper.textRegular()
        btnChangePassword.titleLabel?.font = FontHelper.textRegular()
        btnUploadImage.setImage(UIImage.init(named: "edit_icon")?.imageWithColor(), for: .normal)
        imgForRefral.image = UIImage.init(named: "share_icon")?.imageWithColor(color: UIColor.themeColor)
        lblForRefral.text =  "TXT_SHARE_REFERRAL_CODE".localized + " " +  preferenceHelper.getReferralCode() + "    "
        lblForRefral.font = FontHelper.textRegular()
        lblForRefral.textColor = UIColor.themeColor
        let tapReferral = UITapGestureRecognizer(target: self, action:#selector(tapReferral(gesture:)))
        viewForReferral.addGestureRecognizer(tapReferral)
        viewForNewPassword.isHidden = true
        viewForConfirmPassword.isHidden = true
        txtNewPassword.isHidden = true
        txtConfirmPassword.isHidden = true
        
        btnDeleteAccount.setTitle("txt_delete_account".localized, for: .normal)
        btnDeleteAccount.setTitleColor(UIColor.themeRedColor, for: .normal)
    }

    @objc func tapReferral(gesture: UIGestureRecognizer) {
        var myString = String(format: NSLocalizedString("SHARE_REFERRAL", comment: ""),String(preferenceHelper.getReferralCode()))
        if LocalizeLanguage.isRTL {
            myString = String(format: NSLocalizedString("SHARE_REFERRAL", comment: ""),String("\n"+preferenceHelper.getReferralCode()))
        }
        let textToShare = [ myString ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        self.navigationController?.present(activityViewController, animated: true, completion: nil)
    }

    //MARK: - TextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtMobileNumber {
            self.createToolbar(textfield: txtMobileNumber)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFirstName {
            txtLastName.becomeFirstResponder()
        } else if textField == txtLastName {
            txtMobileNumber.becomeFirstResponder()
        } else if textField == txtMobileNumber {
            if txtAddress.isHidden {
                txtNewPassword.becomeFirstResponder();
            } else {
                txtAddress.becomeFirstResponder()
            }
        } else if textField == txtNewPassword {
            txtConfirmPassword.becomeFirstResponder()
        } else {
            textField.resignFirstResponder();
            return true
        }
        return true
    }

    //MARK: - Action Methods
    func onClickRightButton() {
        editProfile()
        self.setRightBarItemImage(image: UIImage.init(named: "doneBlackIcon")!)
    }

    @IBAction func editImageButtonClicked(_ sender: UIButton) {
        openImageDialog()
    }

    @IBAction func onClickBtnChangePassword(_ sender: Any) {
        if txtConfirmPassword.isHidden {
            txtNewPassword.isHidden = false
            txtConfirmPassword.isHidden = false
            btnShowHidePassword.isHidden = false
            btnShowHideConfirmPassword.isHidden = false
            viewForNewPassword.isHidden = false
            viewForConfirmPassword.isHidden = false
        } else {
            txtNewPassword.isHidden = true
            txtConfirmPassword.isHidden = true
            btnShowHidePassword.isHidden = true
            btnShowHideConfirmPassword.isHidden = true
            viewForNewPassword.isHidden = true
            viewForConfirmPassword.isHidden = true
        }
    }
    
    @IBAction func onClickDeleteAccount(_ sender: Any) {
        self.view.endEditing(true)
        let dailog = CustomAlertDialog.showCustomAlertDialog(title: "txt_delete_account".localized, message: "txt_are_you_sure_account_delete".localized, titleLeftButton: "".localizedCapitalized, titleRightButton: "TXT_YES".localized)
        dailog.onClickRightButton = { [weak self] in
            dailog.removeFromSuperview()
            guard let self = self else { return }
            self.openVerifyAccountDialog(isDelete: true)
        }
        dailog.onClickLeftButton = {
            dailog.removeFromSuperview()
        }
    }

    //MARK: - User Define Methods
    func checkValidation() -> Bool {
        let validNewPassword = txtNewPassword.text!.checkPasswordValidation()
        let validEmail = txtEmail.text!.checkEmailValidation()
        let validMobileNumber = txtMobileNumber.text!.isValidMobileNumber()

        if ((txtFirstName.text?.isEmpty())!) {
            Utility.showToast(message:"MSG_PLEASE_ENTER_VALID_NAME".localized)
            txtFirstName.becomeFirstResponder()
            return false
        } else if ((txtLastName.text?.isEmpty())!) {
            Utility.showToast(message:"MSG_PLEASE_ENTER_VALID_NAME".localized)
            txtLastName.becomeFirstResponder()
            return false
        } else if validEmail.0 == false {
            Utility.showToast(message:validEmail.1)
            txtEmail.becomeFirstResponder()
            return false
        } else if validMobileNumber.0 == false {
            Utility.showToast(message:validMobileNumber.1)
            txtMobileNumber.becomeFirstResponder()
            return false
        } else {
            if ((txtNewPassword.text?.isEmpty())! && (txtConfirmPassword.text?.isEmpty())!) {
                return true
            } else if validNewPassword.0 == false {
                Utility.showToast(message:validNewPassword.1)
                txtNewPassword.becomeFirstResponder()
                return false
            } else {
                if ((txtConfirmPassword.text?.compare(txtNewPassword.text!) == ComparisonResult.orderedSame)) {
                    return true
                } else {
                    Utility.showToast(message:"MSG_INCORRECT_CONFIRM_PASSWORD".localized)
                    txtConfirmPassword.becomeFirstResponder()
                    return false
                }
            }
        }
    }

    func enableTextFields(enable:Bool) -> Void {
        txtFirstName.isEnabled = enable
        txtLastName.isEnabled = enable
        txtEmail.isEnabled = enable
        txtMobileNumber.isEnabled = enable
        txtAddress.isEnabled = enable
        txtNewPassword.isEnabled = enable
        txtConfirmPassword.isEnabled = enable
        btnUploadImage.isEnabled = enable
        btnChangePassword.isEnabled = enable
    }

    func setProfileData() {
        txtFirstName.text = (preferenceHelper.getFirstName());
        txtMobileNumber.text = (preferenceHelper.getPhoneNumber());
        txtLastName.text = (preferenceHelper.getLastName());
        txtAddress.text = (preferenceHelper.getAddress());
        lblCountryCode.text = (preferenceHelper.getPhoneCountryCode());
        txtEmail.text = (preferenceHelper.getEmail());
        imgProfilePic.downloadedFrom(link: preferenceHelper.getProfilePicUrl(), placeHolder: "profile_placeholder", isFromCache: false)
        btnChangePassword.isHidden = !preferenceHelper.getSocialId().isEmpty()
        viewForChangePassword.isHidden = !preferenceHelper.getSocialId().isEmpty()
    }

    func createToolbar(textfield : UITextField) {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.black
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.white
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(
            title: "TXT_DONE".localized,
            style: .plain,
            target: self,
            action: #selector(doneTextField(sender:))
        )
        doneButton.tag = textfield.tag
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textfield.inputAccessoryView = toolBar
    }

    @objc func doneTextField(sender : UIBarButtonItem) {
        view.endEditing(true)
    }

    func editProfile() -> Void {
        if (!txtFirstName.isEnabled) {
            enableTextFields(enable: true)
        } else {
            if (checkValidation()) {
                switch (self.checkWhichOtpValidationON()) {
                case CONSTANT.SMS_AND_EMAIL_VERIFICATION_ON:
                    openConfirmationDialog()
                    break;
                case CONSTANT.SMS_VERIFICATION_ON:
                    openConfirmationDialog()
                    break;
                case CONSTANT.EMAIL_VERIFICATION_ON:
                    openConfirmationDialog()
                    break;
                default:
                    self.openVerifyAccountDialog();
                    break;
                }
            }
        }
    }

    //MARK: - Dialog Methods
    func openImageDialog() {
        dialogForImage = CustomPhotoDialog.showPhotoDialog("TXT_SELECT_IMAGE".localized, andParent: self, isCrop: true)
        self.dialogForImage?.onImageSelected = { (image:UIImage) in
                self.imgProfilePic.image = image
                self.isPicAdded = true
        }
    }

    //MARK: - Web Service Calls
    func wsUpdateProfile() {
        let dictParam : [String : Any] =
            [PARAMS.FIRST_NAME : txtFirstName.text! ,
             PARAMS.LAST_NAME  : txtLastName.text!  ,
             PARAMS.EMAIL      : txtEmail.text!  ,
             PARAMS.OLD_PASSWORD: password  ,
             PARAMS.NEW_PASSWORD: txtNewPassword.text ?? "",
             PARAMS.LOGIN_BY   : CONSTANT.MANUAL ,
             PARAMS.COUNTRY_PHONE_CODE  :lblCountryCode.text ?? "" ,
             PARAMS.PHONE : txtMobileNumber.text! ,
             PARAMS.ADDRESS  : txtAddress.text ?? "",
             PARAMS.SOCIAL_ID: preferenceHelper.getSocialId(),
             PARAMS.DEVICE_TYPE: CONSTANT.IOS,
             PARAMS.DEVICE_TOKEN:preferenceHelper.getDeviceToken(),
             PARAMS.SERVER_TOKEN: preferenceHelper.getSessionToken(),
             PARAMS.PROVIDER_ID: preferenceHelper.getUserId()
        ]
        let alamoFire:AlamofireHelper = AlamofireHelper();
        self.view.endEditing(true)
        print(Utility.conteverDictToJson(dict: dictParam))

        if isPicAdded {
            alamoFire.getResponseFromURL(url: WebService.WS_PROVIDER_UPDATE, paramData: dictParam, image: imgProfilePic.image!, block: { (response, error) -> (Void) in
                print("response \(response)")
                Parser.parseUserStorageData(response: response,isShowToast: false, completion: { result in
                    if result{
                        if let messageCode = response["message"] as? Int {
                            let messageCode:String = "MSG_CODE_" + String(messageCode)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                Utility.showToast(message:messageCode.localized);
                            }
                        }
                        self.navigationController?.popViewController(animated: true)
                     }
                })
            })
        } else {
            alamoFire.getResponseFromURL(url: WebService.WS_PROVIDER_UPDATE, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
                Parser.parseUserStorageData(response: response,isShowToast: false, completion: { result in
                    if result {
                        if let messageCode = response["message"] as? Int {
                            let messageCode:String = "MSG_CODE_" + String(messageCode)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                Utility.showToast(message:messageCode.localized);
                            }
                        }
                        self.navigationController?.popViewController(animated: true)
                    }
                })
            }
        }
    }

    //MARK: - OTP Operation
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
        return preferenceHelper.getIsEmailVerification() && !(txtEmail.text!.compare(preferenceHelper.getEmail()) == ComparisonResult.orderedSame)
    }
    
    func checkPhoneNumberVerification() -> Bool {
        return preferenceHelper.getIsPhoneNumberVerification() && !(txtMobileNumber.text!.compare(preferenceHelper.getPhoneNumber()) == ComparisonResult.orderedSame)
    }

    func openVerifyAccountDialog(isDelete: Bool = false) {
        self.view.endEditing(true)
        if !preferenceHelper.getSocialId().isEmpty {
            self.password = ""
            if isDelete {
                self.wsDeleteAccount()
            } else {
                self.wsUpdateProfile()
            }
        } else {
            let dialogForVerification = CustomVerificationDialog.showCustomVerificationDialog(title: "TXT_VERIFY_ACCOUNT".localized, message: "MSG_PLEASE_ENTER_CURRENT_PASSWORD".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_OK".localized, editTextOneHint: "TXT_PASSWORD".localized, editTextTwoHint: "", isEdiTextTwoIsHidden: true, editTextOneInputType: true)
            dialogForVerification.onClickLeftButton = { [unowned dialogForVerification] in
                dialogForVerification.removeFromSuperview();
            }
            dialogForVerification.onClickRightButton = { [unowned dialogForVerification, unowned self] (text1:String, text2:String) in
                let validPassword = text1.checkPasswordValidation()
                if validPassword.0 == false {
                    Utility.showToast(message: validPassword.1)
                } else {
                    self.password = text1
                    if isDelete {
                        self.wsDeleteAccount()
                    } else {
                        self.wsUpdateProfile()
                    }
                    dialogForVerification.removeFromSuperview();
                }
            }
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
                    preferenceHelper.setIsEmailVerified(true)
                    preferenceHelper.setIsPhoneNumberVerified(true)
                    self.openVerifyAccountDialog()
                } else {
                    if !(text1.compare(otpEmailVerification) == ComparisonResult.orderedSame) {
                        Utility.showToast(message: "MSG_EMAIL_OTP_WRONG")
                    } else if !(text2.compare(otpSmsVerification) == ComparisonResult.orderedSame) {
                        Utility.showToast(message: "MSG_SMS_OTP_WRONG")
                    }
                }
                break;
            case CONSTANT.SMS_VERIFICATION_ON:
                if (text1.compare(otpSmsVerification) == ComparisonResult.orderedSame) {
                    dialogForVerification.removeFromSuperview()
                    preferenceHelper.setIsPhoneNumberVerified(true);
                    self.openVerifyAccountDialog();
                } else {
                    Utility.showToast(message: "MSG_SMS_OTP_WRONG")
                }
                break;
            case CONSTANT.EMAIL_VERIFICATION_ON:
                if (text1.compare(otpEmailVerification) == ComparisonResult.orderedSame) {
                    preferenceHelper.setIsEmailVerified(true);
                    dialogForVerification.removeFromSuperview()
                    self.openVerifyAccountDialog();
                } else {
                    Utility.showToast(message: "MSG_EMAIL_OTP_WRONG")
                }
                break;
            default:
                self.openVerifyAccountDialog();
                break;
            }
        }
        dialogForVerification.onClickLeftButton = { [unowned dialogForVerification] in
            dialogForVerification.removeFromSuperview();
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
    
    func wsDeleteAccount() {
        Utility.showLoading()
        
        let dictParam : [String : Any] =
            [
                PARAMS.PROVIDER_ID : preferenceHelper.getUserId(),
                PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken(),
                PARAMS.PASSWORD : self.password,
                PARAMS.SOCIAL_ID : preferenceHelper.getSocialId()
        ]
        
        let alamoFire:AlamofireHelper = AlamofireHelper();
        
        alamoFire.getResponseFromURL(url: WebService.WS_DELETE_ACCOUNT, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            if Parser.isSuccess(response: response,withSuccessToast: false, andErrorToast: true) {
                Utility.hideLoading()
                preferenceHelper.setSessionToken("")
                preferenceHelper.setUserId("")
                //SocketHelper.shared.disConnectSocket()
                APPDELEGATE.goToHome()
            }
        }
    }

    func openConfirmationDialog() {
        var dictParam : [String : Any] =
            [PARAMS.TYPE : CONSTANT.TYPE_PROVIDER,
             PARAMS.ID :preferenceHelper.getUserId()
        ]
        switch (self.checkWhichOtpValidationON()) {
        case CONSTANT.SMS_AND_EMAIL_VERIFICATION_ON:
            preferenceHelper.setTempEmail(self.txtEmail.text!)
            preferenceHelper.setTempPhoneNumber(txtMobileNumber.text!)
            dictParam.updateValue(txtEmail.text!, forKey: PARAMS.EMAIL)
            dictParam.updateValue(txtMobileNumber.text!, forKey: PARAMS.PHONE)
            dictParam.updateValue(preferenceHelper.getPhoneCountryCode(), forKey: PARAMS.COUNTRY_PHONE_CODE)
            self.wsGetOtpVerify(dictParam)
            break;
        case CONSTANT.SMS_VERIFICATION_ON:
            dictParam.updateValue(self.txtMobileNumber.text!, forKey: PARAMS.PHONE)
            dictParam.updateValue(preferenceHelper.getPhoneCountryCode(), forKey: PARAMS.COUNTRY_PHONE_CODE)
            preferenceHelper.setTempPhoneNumber(self.txtMobileNumber.text!)
            self.wsGetOtpVerify(dictParam)
            break;
        case CONSTANT.EMAIL_VERIFICATION_ON:
            if self.txtEmail.text!.isValidEmail() {
                preferenceHelper.setTempEmail(self.txtEmail.text!)
                dictParam.updateValue(self.txtEmail.text!, forKey: PARAMS.EMAIL)
                self.wsGetOtpVerify(dictParam)
            } else {
                Utility.showToast(message: "MSG_PLEASE_ENTER_VALID_EMAIL".localized);
            }
            break;
        default:
            self.openVerifyAccountDialog()
        }
    }
}

extension ProfileVC {

    func getCountriesFromJson() {
        let url = Bundle.main.url(forResource: "countries", withExtension: ".json")!
        do {
            let jsonData = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: jsonData) as! NSArray
            print("json --------------- \(json)")
            self.arrForCountryList.removeAll()

            for obj in json {
                let value = obj as! [String : Any]
                self.arrForCountryList.append(CountryModal(fromDictionary: value))
            }

            if self.arrForCountryList.count > 0 {
                for country in self.arrForCountryList {
                    if country.code == preferenceHelper.getPhoneCountryCode() {
                        self.strCountryCode = country.alpha2
                        break;
                    }
                }
            }
        } catch {
            print(error)
        }
    }
}
