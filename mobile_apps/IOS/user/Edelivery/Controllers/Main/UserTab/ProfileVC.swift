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
    @IBOutlet weak var txtSelectCountry: UITextField!
    @IBOutlet weak var btnEditImage: UIButton!
    @IBOutlet weak var lblDivider: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var viewForProfile: UIView!
    @IBOutlet weak var btnChangePassword: UIButton!
    @IBOutlet weak var tableForDropDown: UITableView!
    @IBOutlet weak var viewForDropDown: UIView!
    @IBOutlet weak var subViewForDropDown: UIView!
    @IBOutlet weak var heightForDropDown: NSLayoutConstraint!
    @IBOutlet weak var imgForRefral: UIImageView!
    @IBOutlet weak var lblForRefral: UILabel!
    @IBOutlet weak var viewForReferral: CustomCardView!
    @IBOutlet weak var lblTransparent: UILabel!
    @IBOutlet weak var btnShowHidePassword: UIButton!
    @IBOutlet weak var btnShowHideConfirmPassword: UIButton!
    @IBOutlet weak var viewForNewPassword: UIView!
    @IBOutlet weak var viewForNewConfirmPassword: UIView!
    @IBOutlet weak var btnDeleteAccount: UIButton!

    //MARK: - Variable Declaration
    var isPicAdded:Bool = false
    var phoneNumberLength = 10
    var dialogForImage:CustomPhotoDialog?
    var password:String = ""
    var arrForCountryList = [CountryModal]()
    var selectedCountryObj = CountryModal(fromDictionary: [:])
    var heightDropDown : CGFloat = 0.0
    var strCountryId:String? = ""
    var arrCountryCode = [String]()

    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        delegateRight = self
        RegisterVC.wsGetCountries { (arrForCountryList) in
            self.arrForCountryList.removeAll()
            self.arrForCountryList.append(contentsOf: arrForCountryList)
            self.txtSelectCountry.text = ""
            self.lblCountryCode.text = ""
            Utility.hideLoading()
        }
        setLocalization()

        if preferenceHelper.getIsShowOptionalFieldInRegister() {
            txtAddress.isHidden = false
        } else {
            txtAddress.isHidden = true
        }

        if preferenceHelper.getSocialId().isEmpty() {} else {
            btnChangePassword.isHidden = true
            txtNewPassword.isHidden = true
            txtConfirmPassword.isHidden = true
            viewForNewPassword.isHidden = true
            viewForNewConfirmPassword.isHidden = true
        }
        setProfileData()
        super.setNavigationTitle(title: "TXT_PROFILE".localizedCapitalized)
        
        txtMobileNumber.keyboardType = .numberPad
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.setNavigationTitle(title: "TXT_PROFILE".localizedCapitalized)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        super.setNavigationTitle(title: "TXT_PROFILE".localizedCapitalized)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewForProfile.setRound()
    }

    override func updateUIAccordingToTheme() {
        imgForRefral.image = UIImage.init(named: "referral")?.imageWithColor(color: UIColor.themeColor)
        btnEditImage.setImage(UIImage.init(named: "edit_icon")?.imageWithColor(color: .themeColor), for: UIControl.State.normal)
        self.setBackBarItem(isNative: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.view.endEditing(true)
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
            self.btnShowHideConfirmPassword.setBackgroundImage(UIImage.init(named: "passwordShow"), for: .normal)
        } else {
            self.txtConfirmPassword.isSecureTextEntry = true
            self.btnShowHideConfirmPassword.setBackgroundImage(UIImage.init(named: "passwordHide"), for: .normal)
        }
    }

    //MARK: - Localized String and initial View Setup
    func setLocalization() {
        /*set colors*/
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        self.scrProfile.backgroundColor = UIColor.themeViewBackgroundColor
        btnChangePassword.setTitleColor(UIColor.themeColor, for: .normal)
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
        
        btnDeleteAccount.setTitle("txt_delete_account".localized, for: .normal)
        btnDeleteAccount.setTitleColor(UIColor.red, for: .normal)

        /*Set Place Holder*/
        txtFirstName.placeholder = "TXT_FIRST_NAME".localizedCapitalized
        txtLastName.placeholder = "TXT_LAST_NAME".localizedCapitalized
        txtEmail.placeholder = "TXT_EMAIL".localizedCapitalized
        txtNewPassword.placeholder = "TXT_NEW_PASSWORD".localizedCapitalized
        txtConfirmPassword.placeholder = "TXT_CONFIRM_PASSWORD".localizedCapitalized
        txtSelectCountry.placeholder = "TXT_SELECT_COUNTRY".localizedCapitalized
        txtAddress.placeholder = "TXT_ADDRESS".localizedCapitalized
        lblCountryCode.text = "TXT_DEFAULT".localizedCapitalized
        lblMobileNumber.text = "TXT_MOBILE_NO".localizedCapitalized

        self.setRightBarItem(isNative: false)
        self.setBackBarItem(isNative: true)

        /*Set Text*/
        lblCountryCode.text = "TXT_DEFAULT".localized
        txtFirstName.text = "".localizedCapitalized
        txtLastName.text = "".localizedCapitalized
        txtEmail.text = "".localizedCapitalized
        txtMobileNumber.text = "".localizedCapitalized
        txtAddress.text = "".localizedCapitalized
        txtNewPassword.text = "".localizedCapitalized
        txtConfirmPassword.text = "".localizedCapitalized
        btnChangePassword.setTitle("TXT_CHANGE_PASSWORD".localized, for: .normal)
        /*Set Fonts*/
        txtFirstName.font = FontHelper.textRegular()
        txtLastName.font = FontHelper.textRegular()
        txtEmail.font = FontHelper.textRegular()
        txtNewPassword.font = FontHelper.textRegular()
        txtConfirmPassword.font = FontHelper.textRegular()
        txtSelectCountry.font = FontHelper.textRegular()
        txtMobileNumber.font = FontHelper.textRegular()
        txtAddress.font = FontHelper.textRegular()
        lblCountryCode.font = FontHelper.textRegular()

        if UIApplication.isRTL() {
            btnChangePassword.contentHorizontalAlignment = .right
        } else {
            btnChangePassword.contentHorizontalAlignment = .left
        }

        let tap = UITapGestureRecognizer(target: self, action:#selector(tapLblCountry(gesture:)))
        lblCountryCode.addGestureRecognizer(tap)

        let tapReferral = UITapGestureRecognizer(target: self, action:#selector(tapReferral(gesture:)))
        viewForReferral.addGestureRecognizer(tapReferral)

        viewForDropDown.isHidden = true
        viewForDropDown.backgroundColor = UIColor.themeViewBackgroundColor
        subViewForDropDown.setShadow(shadowColor: UIColor.black.cgColor, shadowOffset: CGSize.init(width: 2.0, height: 2.0), shadowOpacity: 5.0, shadowRadius: 2.0)
        tableForDropDown.delegate = self
        tableForDropDown.dataSource = self

        lblForRefral.text =  "TXT_REFERRAL_CODE".localized + " " +  preferenceHelper.getReferralCode() + "    "
        lblForRefral.font = FontHelper.textRegular()
        lblForRefral.textColor = UIColor.themeColor
        imgForRefral.image = UIImage.init(named: "referral")?.imageWithColor(color: UIColor.themeColor)
        lblTransparent.setRound(withBorderColor:UIColor.clear, andCornerRadious: 4.0, borderWidth: 1.0)
        lblTransparent.backgroundColor = UIColor.themeViewLightBackgroundColor
        btnEditImage.setImage(UIImage.init(named: "edit_icon")?.imageWithColor(color: .themeColor), for: UIControl.State.normal)
    }

    @objc func tapReferral(gesture: UIGestureRecognizer) {
        let myString = String(format: NSLocalizedString("SHARE_REFERRAL", comment: ""),String("\n" + preferenceHelper.getReferralCode()))
        let textToShare = [ myString ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        self.navigationController?.present(activityViewController, animated: true, completion: nil)
    }

    //MARK: - TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFirstName {
            txtLastName.becomeFirstResponder()
        } else if textField == txtLastName {
            txtMobileNumber.becomeFirstResponder()
        } else if textField == txtMobileNumber {
            if txtAddress.isHidden {
                txtNewPassword.becomeFirstResponder()
            } else {
                txtAddress.becomeFirstResponder()
            }
        } else if textField == txtAddress {
            txtNewPassword.becomeFirstResponder()
        } else if textField == txtNewPassword {
            txtConfirmPassword.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            return true
        }
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtMobileNumber {
            if (string == "") || string.count < 1 {
                return true
            } else if (textField.text?.count)! >= preferenceHelper.getMaxMobileLength() {
                return false
            }
            //Prevent "0" characters as the first characters.
            if textField.text?.count == 0 && string == "0" {
                return false
            }
        }
        return true
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtSelectCountry {
            openCountryDialog()
            return false
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        /*
        if textField == txtMobileNumber {
            let result = textField.text?.getPhoneNumberFormat(regionCode: selectedCountryObj.alpha2 ?? "IN")
            if result!.isValid {
                self.txtMobileNumber.text = result!.phoneNumber.nationalNumber.stringValue
            } else {
                self.txtMobileNumber.text = ""
                Utility.showToast(message: "MSG_TXT_PLEASE_ENTER_VALID_MOBILE_NUMBER".localized)
            }
        }*/
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    //MARK: - Action Methods
    @IBAction func onClickBtnChangePassword(_ sender: Any) {
        self.view.endEditing(true)
        if txtConfirmPassword.isHidden {
            txtNewPassword.isHidden = false
            txtConfirmPassword.isHidden = false
            viewForNewPassword.isHidden = false
            viewForNewConfirmPassword.isHidden = false
        } else {
            txtNewPassword.isHidden = true
            txtConfirmPassword.isHidden = true
            viewForNewPassword.isHidden = true
            viewForNewConfirmPassword.isHidden = true
        }
    }

    func onClickRightButton() {
        self.view.endEditing(true)
        editProfile()
        self.setRightBarItemImage(image: UIImage.init(named: "doneIcon")!.imageWithColor(color: .themeColor)!)
    }

    @IBAction func editImageButtonClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        openImageDialog()
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

    //MARK: - Other Functions
    func enableTextFields(enable:Bool) -> Void {
        txtFirstName.isEnabled = enable
        txtMobileNumber.isEnabled = enable
        txtLastName.isEnabled = enable
        txtAddress.isEnabled = enable
        lblCountryCode.isEnabled = enable
        txtEmail.isEnabled = enable
        txtNewPassword.isEnabled = enable
        txtConfirmPassword.isEnabled = enable
        txtSelectCountry.isEnabled = enable
        btnEditImage.isEnabled = enable
        btnChangePassword.isEnabled = enable
    }

    func setProfileData() {
        txtFirstName.text = (preferenceHelper.getFirstName())
        txtMobileNumber.text = (preferenceHelper.getPhoneNumber())
        txtLastName.text = (preferenceHelper.getLastName())
        txtAddress.text = (preferenceHelper.getAddress())
        lblCountryCode.text = (preferenceHelper.getPhoneCountryCode())

        let countryInd : Int = self.arrForCountryList.firstIndex(where: {
            if $0.code == preferenceHelper.getPhoneCountryCode() {
                return true
            }
            return false
        }) ?? 0

        txtSelectCountry.text = self.arrForCountryList[countryInd].name
        self.selectedCountryObj = self.arrForCountryList[countryInd]
        txtEmail.text = (preferenceHelper.getEmail())
        imgProfilePic.downloadedFrom(link: preferenceHelper.getProfilePicUrl(), placeHolder: "profile_placeholder",isFromCache: false,isIndicator: true)
        txtNewPassword.isHidden = true
        txtConfirmPassword.isHidden = true
        viewForNewPassword.isHidden = true
        viewForNewConfirmPassword.isHidden = true
        enableTextFields(enable: false)
        self.setRightBarItemImage(image: UIImage.init(named: "edit")!.imageWithColor(color: .themeColor)!)
    }

    func editProfile() -> Void {
        if (!txtFirstName.isEnabled) {
            enableTextFields(enable: true)
            txtFirstName.becomeFirstResponder()
        } else {
            if (checkValidation()) {
                switch (self.checkWhichOtpValidationON()) {
                case CONSTANT.SMS_AND_EMAIL_VERIFICATION_ON:
                     openConfirmationDialog()
                    break
                case CONSTANT.SMS_VERIFICATION_ON:
                    openConfirmationDialog()
                    break
                case CONSTANT.EMAIL_VERIFICATION_ON:
                    openConfirmationDialog()
                    break
                default:
                    self.openVerifyAccountDialog()
                    break
                }
            }
        }
    }

    @objc func tapLblCountry(gesture: UIGestureRecognizer) {
        openDropDown()
    }

    func openDropDown() {
        if self.viewForDropDown.isHidden {
           viewVisible()
        } else {
           viewGone()
        }
    }

    func viewGone(showMessage: Bool = false) {
        let height = 0
        self.heightForDropDown.constant = CGFloat(height)
        self.viewForDropDown.isHidden = true
    }

    func viewVisible() {
        self.viewForDropDown.isHidden = false
        self.heightForDropDown.constant = CGFloat(heightDropDown)
    }

    //MARK: - Validation  Methods
    func checkValidation() -> Bool {
        let validPassword = txtNewPassword.text!.checkPasswordValidation()
        let validEmail = txtEmail.text!.checkEmailValidation()
        let validMobileNumber = txtMobileNumber.text!.isValidMobileNumber()

        if (txtFirstName.text?.isEmpty() ?? true) {
            Utility.showToast(message: "MSG_PLEASE_ENTER_VALID_NAME".localized)
            txtFirstName.becomeFirstResponder()
            return false
        } else if (txtLastName.text?.isEmpty() ?? true) {
            Utility.showToast(message: "MSG_PLEASE_ENTER_VALID_NAME".localized)
            txtLastName.becomeFirstResponder()
            return false
        } else if validEmail.0 == false {
            Utility.showToast(message: validEmail.1)
            txtEmail.becomeFirstResponder()
            return false
        } else if (txtSelectCountry.text?.isEmpty() ?? true) {
            txtSelectCountry.becomeFirstResponder()
            Utility.showToast(message:"MSG_PLEASE_SELECT_COUNTRY".localized)
            return false
        } else if (txtMobileNumber.text?.isEmpty() ?? true) {
            Utility.showToast(message: "MSG_PLEASE_ENTER_MOBILE_NUMBER".localized)
            txtMobileNumber.becomeFirstResponder()
            return false
        } else if validMobileNumber.0 == false {
            Utility.showToast(message:validMobileNumber.1)
            txtMobileNumber.becomeFirstResponder()
            return false
        } else {
            if ((txtNewPassword.text?.isEmpty())! && (txtConfirmPassword.text?.isEmpty())!) {
                return true
            } else if validPassword.0 == false {
                Utility.showToast(message: validPassword.1)
                txtNewPassword.becomeFirstResponder()
                return false
            } else {
                if ((txtConfirmPassword.text?.compare(txtNewPassword.text!) == ComparisonResult.orderedSame)) {
                    return true
                } else {
                    Utility.showToast(message: "MSG_INCORRECT_CONFIRM_PASSWORD".localized)
                    txtConfirmPassword.becomeFirstResponder()
                    return false
                }
            }
        }
    }

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
        return preferenceHelper.getIsEmailVerification() && !(txtEmail.text!.compare(preferenceHelper.getEmail()) == ComparisonResult.orderedSame)
    }

    func checkPhoneNumberVerification() -> Bool {
        return preferenceHelper.getIsPhoneNumberVerification() && !(txtMobileNumber.text!.compare(preferenceHelper.getPhoneNumber()) == ComparisonResult.orderedSame)
    }
}

//MARK: - Web Service Calls
extension ProfileVC {

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
             PARAMS.DEVICE_TYPE: CONSTANT.IOS,
             PARAMS.DEVICE_TOKEN:preferenceHelper.getDeviceToken(),
             PARAMS.SERVER_TOKEN: preferenceHelper.getSessionToken(),
             PARAMS.USER_ID: preferenceHelper.getUserId(),
             PARAMS.IS_PHONE_NUMBER_VERIFIED:String(preferenceHelper.getIsPhoneNumberVerified()),
             PARAMS.IS_EMAIL_VERIFIED:String(preferenceHelper.getIsEmailVerified()),
             PARAMS.SOCIAL_ID: preferenceHelper.getSocialId(),
             PARAMS.COUNTRY_NAME : self.selectedCountryObj.name ?? "",
             PARAMS.COUNTRY_CODE :self.selectedCountryObj.alpha2 ?? "",
             PARAMS.CURRENCY : self.selectedCountryObj.currency_code ?? ""
        ]

        let alamoFire:AlamofireHelper = AlamofireHelper()
        Utility.showLoading()
        if isPicAdded {
            alamoFire.getResponseFromURL(url: WebService.WS_UPDATE_PROFILE, paramData: dictParam, image: imgProfilePic.image!, block: { (response, error) -> (Void) in
                Utility.hideLoading()
                Parser.parseUserStorageData(response: response, completion: { result in
                    if result{
                        if let messageCode = response.value(forKey: "status_phrase") as? String {
                            //let messageCode:String = "MSG_CODE_" + String(messageCode)
                            Utility.showToast(message:messageCode.localized)
                        }
                        self.navigationController?.popViewController(animated: true)
                    }
                })
            })
        } else {
            alamoFire.getResponseFromURL(url: WebService.WS_UPDATE_PROFILE, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
                Utility.hideLoading()
                Parser.parseUserStorageData(response: response, completion: { result in
                    if result{
                        if let messageCode = response.value(forKey: "status_phrase") as? String {
                            //let messageCode:String = "MSG_CODE_" + String(messageCode)
                            Utility.showToast(message:messageCode.localized)
                        }
                        self.navigationController?.popViewController(animated: true)
                    }
                })
            }
        }
    }
    
    func wsDeleteAccount() {
        Utility.showLoading()
        
        let dictParam : [String : Any] =
            [
                PARAMS.USER_ID : preferenceHelper.getUserId(),
                PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken(),
                PARAMS.PASS_WORD : password,
                PARAMS.SOCIAL_ID : preferenceHelper.getSocialId()
        ]
        
        let alamoFire:AlamofireHelper = AlamofireHelper();
        
        alamoFire.getResponseFromURL(url: WebService.WS_DELETE_ACCOUNT, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response) {
                preferenceHelper.setSessionToken("")
                preferenceHelper.setUserId("")
                preferenceHelper.setRandomCartID(String.random(length: 20))
                APPDELEGATE.goToHome()
                APPDELEGATE.clearFavoriteAddressEntity()
                APPDELEGATE.clearDeliveryLocationEntity()
            }
        }
    }

    func updateFirebaseEmail() {
        if firebaseAuth.currentUser != nil {
            firebaseAuth.currentUser?.updateEmail(to: preferenceHelper.getEmail()) { error in
                if error == nil {
                    print("Firebase imail updated successfull...")
                } else {
                    print(error ?? "Error in update firebase authentication imailID")
                }
            }
        }
    }

    func wsGetOtpVerify(_ dictParam:[String:Any]) {
        let alamoFire:AlamofireHelper = AlamofireHelper()
        alamoFire.getResponseFromURL(url: WebService.WS_OTP_VERIFICATION, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            if Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true) {
                let otpResponse:OtpResponse = OtpResponse.init(dictionary: response)!
                switch (self.checkWhichOtpValidationON()) {
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
}

//MARK: - Dialogs
extension ProfileVC {
    func openVerifyAccountDialog(isDelete: Bool = false) {
        self.view.endEditing(true)
        if !preferenceHelper.getSocialId().isEmpty() {
            self.password = ""
            if isDelete {
                self.wsDeleteAccount()
            } else {
                self.wsUpdateProfile()
            }
        } else {
            let dialogForVerification = CustomVerificationDialog.showCustomVerificationDialog(title: "TXT_VERIFY_ACCOUNT".localized, message: "MSG_PLEASE_ENTER_CURRENT_PASSWORD".localized, titleLeftButton: "".localized, titleRightButton: "TXT_OK".localized, editTextOneHint: "TXT_PASSWORD".localized, editTextTwoHint: "", isEdiTextTwoIsHidden: true, editTextOneInputType: true)
            dialogForVerification.onClickLeftButton = { [unowned dialogForVerification] in
                dialogForVerification.removeFromSuperview()
            }
            dialogForVerification.onClickRightButton = { [unowned self,unowned dialogForVerification] (text1:String,text2:String) in
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
                    dialogForVerification.removeFromSuperview()
                }
            }
        }
    }

    func openImageDialog() {
        dialogForImage = CustomPhotoDialog.showPhotoDialog("TXT_SELECT_IMAGE".localized, andParent: self, isCrop: true)
        self.dialogForImage?.onImageSelected = { [unowned self, weak dialogForImage = self.dialogForImage](image:UIImage) in
            self.imgProfilePic.image = image
            self.isPicAdded = true
            dialogForImage?.removeFromSuperviewAndNCObserver()
            dialogForImage = nil
        }
    }

    func openCountryDialog() {
        self.view.endEditing(true)
        let dialogForCountry = CustomCountryDialog.showCustomCountryDialog(withDataSource:arrForCountryList)
        dialogForCountry.onCountrySelected = { [unowned self] (country:CountryModal) in
            self.txtMobileNumber.text = ""
            self.selectedCountryObj = country
            self.txtSelectCountry.text = country.name!
            self.lblCountryCode.isUserInteractionEnabled = false
            self.lblCountryCode.text = country.code
            self.txtMobileNumber.text = ""
            dialogForCountry.removeFromSuperview()
        }
    }

    func openOTPVerifyDialog(otpEmailVerification:String, otpSmsVerification:String,editTextOneHint:String, ediTextTwoHint:String, isEditTextTwoIsHidden:Bool, param:[String:Any]) {
        self.view.endEditing(true)
        let dialogForVerification = CustomVerificationDialog.showCustomVerificationDialog(title: "TXT_VERIFY_ACCOUNT".localizedCapitalized, message: "MSG_VERIFY_DETAIL".localizedCapitalized, titleLeftButton: "".localizedCapitalized, titleRightButton: "TXT_OK".localizedCapitalized, editTextOneHint: editTextOneHint, editTextTwoHint:ediTextTwoHint, isEdiTextTwoIsHidden: isEditTextTwoIsHidden, isForVerifyOtp: true, param: param)
        dialogForVerification.startTimer()
        dialogForVerification.onClickRightButton = { [unowned self,unowned dialogForVerification] (text1:String, text2:String) in
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
                        Utility.showToast(message: "MSG_SMS_OTP_WRONG".localized)
                    }
                }
                break
            case CONSTANT.SMS_VERIFICATION_ON:
                if (text1.compare(otpSmsVerification) == ComparisonResult.orderedSame) {
                    dialogForVerification.removeFromSuperview()
                    preferenceHelper.setIsPhoneNumberVerified(true)
                    self.openVerifyAccountDialog()
                } else {
                    Utility.showToast(message: "MSG_SMS_OTP_WRONG".localized)
                }
                break
            case CONSTANT.EMAIL_VERIFICATION_ON:
                if (text1.compare(otpEmailVerification) == ComparisonResult.orderedSame) {
                    preferenceHelper.setIsEmailVerified(true)
                    dialogForVerification.removeFromSuperview()
                    self.openVerifyAccountDialog()
                } else {
                    Utility.showToast(message: "MSG_EMAIL_OTP_WRONG")
                }
                break
            default:
                self.openVerifyAccountDialog()
                break
            }
        }
        dialogForVerification.onClickLeftButton = { [unowned dialogForVerification] in
            dialogForVerification.removeFromSuperview()
        }
    }

    func openConfirmationDialog() {
        self.view.endEditing(true)
        var dictParam : [String : Any] =
            [PARAMS.TYPE : CONSTANT.TYPE_USER,
             PARAMS.ID :preferenceHelper.getUserId()]
        switch (self.checkWhichOtpValidationON()) {
            case CONSTANT.SMS_AND_EMAIL_VERIFICATION_ON:
                preferenceHelper.setTempEmail(self.txtEmail.text!)
                preferenceHelper.setTempPhoneNumber(txtMobileNumber.text!)
                dictParam.updateValue(txtEmail.text!, forKey: PARAMS.EMAIL)
                dictParam.updateValue(txtMobileNumber.text!, forKey: PARAMS.PHONE)
                dictParam.updateValue(preferenceHelper.getPhoneCountryCode(), forKey: PARAMS.COUNTRY_PHONE_CODE)
                self.wsGetOtpVerify(dictParam)
                break
            case CONSTANT.SMS_VERIFICATION_ON:
                dictParam.updateValue(self.txtMobileNumber.text!, forKey: PARAMS.PHONE)
                dictParam.updateValue(preferenceHelper.getPhoneCountryCode(), forKey: PARAMS.COUNTRY_PHONE_CODE)
                preferenceHelper.setTempPhoneNumber(self.txtMobileNumber.text!)
                self.wsGetOtpVerify(dictParam)
                break
            case CONSTANT.EMAIL_VERIFICATION_ON:
                if self.txtEmail.text!.isValidEmail() {
                    preferenceHelper.setTempEmail(self.txtEmail.text!)
                    dictParam.updateValue(self.txtEmail.text!, forKey: PARAMS.EMAIL)
                    self.wsGetOtpVerify(dictParam)
                } else {
                    Utility.showToast(message: "MSG_PLEASE_ENTER_VALID_EMAIL".localized)
                }
                break
            default:
                self.openVerifyAccountDialog()
        }
    }
}

extension ProfileVC : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCountryCode.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:DropdownCell = tableView.dequeueReusableCell(withIdentifier: "DropdownCell") as! DropdownCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.lblTitle.text = arrCountryCode[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        30
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.lblCountryCode.text = arrCountryCode[indexPath.row]
        self.viewGone()
    }
}
