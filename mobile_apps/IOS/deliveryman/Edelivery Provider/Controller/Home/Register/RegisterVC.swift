//
//  RegisterVC.swift
//  edelivery
//
//  Created by Elluminati on 17/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
import Foundation
import FBSDKLoginKit
import GoogleSignIn

class RegisterVC: BaseVC,UITextFieldDelegate {
    // MARK: - Dialogs
    var dialogForImage:CustomPhotoDialog? = nil
    // MARK: - OUTLETS
    @IBOutlet weak var scrRegister: UIScrollView!
    @IBOutlet weak var viewForProfile: UIView!
    @IBOutlet weak var cbAccept: UIButton!
    @IBOutlet weak var lblRegister: UILabel!
    @IBOutlet weak var txtvwTermsConditions: UITextView!
    @IBOutlet weak var stkSocialLogin: UIStackView!
    @IBOutlet weak var lblOr: UILabel!
    @IBOutlet weak var viewForSocialLogin: UIView!
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtSelectCity: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var viewForPassword: UIView!
    @IBOutlet weak var btnShowHidePassword: UIButton!
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var txtSelectCountry: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var lblDivider: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var btnUploadImage: UIButton!
    @IBOutlet weak var lblTransparent: UILabel!
    @IBOutlet weak var btnReferral: UIButton!
    @IBOutlet weak var txtReferralCode:UITextField!
    @IBOutlet weak var stkReferralView: UIStackView!
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var btnFacebook: FBLoginButton!
    @IBOutlet weak var btnGoogle: GIDSignInButton!
    @IBOutlet weak var viewForReferral : UIView!
    @IBOutlet weak var lblLogin: UILabel!
    @IBOutlet weak var btnLogin: UIButton!

    //MARK: - VARIABLES
    var arrForCountryList : NSMutableArray = NSMutableArray.init()
    var arrForCityList : NSMutableArray = NSMutableArray.init()
    var strCountryId:String? = ""
    var strCityId:String? = ""
    var isPicAdded:Bool = false
    var strReferralCode:String? = ""
    var socialId:String = ""
    var strCountryCode:String = ""

    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalization()
        btnGoogle.style = .standard
        btnGoogle.colorScheme = .light
        btnFacebook.delegate = self
        btnFacebook.permissions = ["public_profile", "email"]
        btnFacebook.isHidden = true
        self.wsGetCountries()

        if preferenceHelper.getIsSocialLoginEnable() {
            viewForSocialLogin.isHidden = false
            lblOr.isHidden = false
            if UIApplication.isRTL() {
                btnFacebook.contentHorizontalAlignment = .left
                btnGoogle.contentHorizontalAlignment = .right
            }
        } else {
            viewForSocialLogin.isHidden = true
            lblOr.isHidden = true
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.setLocalization()
        LoginManager.init().logOut()
        GIDSignIn.sharedInstance.signOut()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews();
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        setupLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    func setLocalization() {
        self.btnApply.setImage(UIImage.init(), for: UIControl.State.normal)
        self.btnApply.setTitle("TXT_APPLY".localized, for: UIControl.State.normal)
        
        /*set colors*/
        self.view.backgroundColor = UIColor.themeViewBackgroundColor;
        self.scrRegister.backgroundColor = UIColor.themeViewBackgroundColor;
        txtFirstName.textColor = UIColor.themeTextColor
        txtLastName.textColor = UIColor.themeTextColor
        txtEmail.textColor = UIColor.themeTextColor
        txtPassword.textColor = UIColor.themeTextColor
        txtConfirmPassword.textColor = UIColor.themeTextColor
        txtSelectCity.textColor = UIColor.themeTextColor
        txtSelectCountry.textColor = UIColor.themeTextColor
        txtMobileNumber.textColor = UIColor.themeTextColor
        txtAddress.textColor = UIColor.themeTextColor
        lblCountryCode.textColor = UIColor.themeTextColor
        lblDivider.backgroundColor = UIColor.themeLightTextColor
        lblMobileNumber.textColor = UIColor.themeLightTextColor
        lblTransparent.backgroundColor = UIColor.themeViewLightBackgroundColor
        btnRegister.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        btnRegister.backgroundColor = UIColor.themeButtonBackgroundColor
        btnReferral.setTitleColor(UIColor.themeLightGrayTextColor, for: .normal)
        btnReferral.backgroundColor = .themeViewLightBackgroundColor
        lblOr.textColor = UIColor.themeTextColor
        /*set titles*/
        lblOr.text = "TXT_OR".localizedUppercase
        txtFirstName.placeholder = "TXT_FIRST_NAME".localizedCapitalized
        txtLastName.placeholder = "TXT_LAST_NAME".localizedCapitalized
        txtEmail.placeholder = "TXT_EMAIL".localizedCapitalized
        txtPassword.placeholder = "TXT_PASSWORD".localizedCapitalized
        txtSelectCity.placeholder = "TXT_SELECT_CITY".localizedCapitalized
        txtSelectCountry.placeholder = "TXT_SELECT_COUNTRY".localizedCapitalized
        txtMobileNumber.placeholder = "TXT_MOBILE_NO".localizedCapitalized
        lblMobileNumber.text = "TXT_MOBILE_NO".localizedCapitalized
        txtConfirmPassword.placeholder = "TXT_CONFIRM_PASSWORD".localizedCapitalized
        txtAddress.placeholder = "TXT_ADDRESS".localizedCapitalized
        lblCountryCode.text = "TXT_DEFAULT".localizedCapitalized
        btnRegister.setTitle("TXT_REGISTER".localizedUppercase, for: UIControl.State.normal);
        btnReferral.setTitle("  \("TXT_REFERRAL".localizedUppercase)  ", for: .normal)
        
        btnReferral.setRound(withBorderColor: .clear, andCornerRadious: 4, borderWidth: 0)
        txtReferralCode.placeholder = "TXT_ENTER_REFERRAL_CODE".localizedCapitalized

        /*Set Fonts*/
        lblOr.font = FontHelper.textRegular()
        txtFirstName.font = FontHelper.textRegular()
        txtLastName.font = FontHelper.textRegular()
        txtEmail.font = FontHelper.textRegular()
        txtPassword.font = FontHelper.textRegular()
        txtConfirmPassword.font = FontHelper.textRegular()
        txtSelectCity.font = FontHelper.textRegular()
        txtSelectCountry.font = FontHelper.textRegular()
        txtMobileNumber.font = FontHelper.textRegular()
        txtAddress.font = FontHelper.textRegular()
        lblCountryCode.font = FontHelper.textRegular()
        btnRegister.titleLabel?.font = FontHelper.buttonText()
        btnReferral.titleLabel?.font = FontHelper.textRegular()
        txtReferralCode.font = FontHelper.textRegular()

        cbAccept.setImage(UIImage.init(named: "unchecked")?.imageWithColor(color: .themeLightTextColor), for: .normal)
        cbAccept.setImage(UIImage.init(named: "checked")?.imageWithColor(), for: .selected)

        self.txtvwTermsConditions.font = FontHelper.labelRegular()
        self.txtvwTermsConditions.text = "TXT_SIGN_UP_PRIVACY".localized + " " + "TXT_TERMS_AND_CONDITIONS".localizedCapitalized + " " + "text_and".localized + " " + "TXT_PRIVACY_POLICIES".localizedCapitalized
        self.configureLinks()
        lblLogin.text = "TXT_ALREADY_HAVE_AN_ACCOUNT".localizedCapitalized
        lblLogin.font = FontHelper.textRegular()
        lblLogin.textColor = UIColor.themeTextColor;
        btnLogin.setTitle("TXT_LOGIN".localizedCapitalized, for: .normal)
        btnLogin.setTitleColor(UIColor.themeColor, for: .normal)
        btnLogin.titleLabel?.font = FontHelper.textMedium(size: 15)
        lblRegister.textColor = .themeTextColor
        lblRegister.text = "TXT_REGISTER".localizedCapitalized
        lblRegister.font = FontHelper.textLargest()
        lblTransparent.backgroundColor = UIColor.themeViewLightBackgroundColor
        btnUploadImage.tintColor = .themeColor
        btnUploadImage.setImage(UIImage.init(named: "edit_icon")?.imageWithColor(), for: .normal)
        lblTransparent.setRound(withBorderColor: .clear, andCornerRadious: 5, borderWidth: 0.0)
    }

    func configureLinks() {
        let attributedString:NSMutableAttributedString = NSMutableAttributedString.init(string: self.txtvwTermsConditions.text)
        attributedString.setAttributes([.link:WebService.USER_PANEL_URL + "legal/provider-terms-conditions"], range:attributedString.mutableString.range(of:"TXT_TERMS_AND_CONDITIONS".localizedCapitalized, options: .caseInsensitive))
        attributedString.setAttributes([.link:WebService.USER_PANEL_URL + "legal/provider-privacy-policy"], range:attributedString.mutableString.range(of:"TXT_PRIVACY_POLICIES".localizedCapitalized, options: .caseInsensitive))
        attributedString.addAttribute(.font, value: FontHelper.labelRegular(), range: attributedString.mutableString.range(of: self.txtvwTermsConditions.text))
        self.txtvwTermsConditions.attributedText = attributedString
        self.txtvwTermsConditions.linkTextAttributes = [
            .foregroundColor: UIColor.themeTextColor,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        self.txtvwTermsConditions.textColor = UIColor.themeTextColor
    }

    func setupLayout() {
        viewForProfile.setRound()
    }

    @IBAction func btnLoginClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    func updateUI() {
        if preferenceHelper.getIsShowOptionalFieldInRegister() {
            self.txtAddress.isHidden = false
        } else {
            self.txtAddress.isHidden = true
        }

        if preferenceHelper.getIsReferralOn() && preferenceHelper.getIsReferralInCountry() {
            self.stkReferralView.isHidden = false
            self.btnReferral.isHidden = false
            self.viewForReferral.isHidden = false
            self.strReferralCode = ""
            self.txtReferralCode.isUserInteractionEnabled = true;
            self.btnApply.isUserInteractionEnabled = true
            self.txtReferralCode.text = "";
            self.btnApply.setImage(UIImage.init(named: ""), for: UIControl.State.normal)
            self.btnApply.setTitle("TXT_APPLY".localized, for: UIControl.State.normal)
        } else {
            self.stkReferralView.isHidden = true
            self.btnReferral.isHidden = true
            self.viewForReferral.isHidden = true
        }
    }

    //MARK: - TEXTFIELD DELEGATE METHODS
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        if textField == txtSelectCountry {
            self.view.endEditing(true)
            let dialogForCountry = CustomCountryDialog.showCustomCountryDialog(withDataSource:arrForCountryList)
            dialogForCountry.onCountrySelected = { [unowned self, unowned dialogForCountry] (country:Countries) in
                if self.strCountryId?.compare(country._id!) == ComparisonResult.orderedSame {} else {
                    self.txtSelectCity.text = ""
                    self.txtSelectCountry.text = country.country_name!
                    self.lblCountryCode.text = country.country_phone_code!
                    self.strCountryId = country._id!
                    self.txtMobileNumber.text = ""
                    self.strCountryCode = country.country_code!
                    preferenceHelper.setIsReferralInCountry(country.is_referral_to_user!)
                    self.updateUI()
                    self.wsGetCities()
                }
                dialogForCountry.removeFromSuperview()
            }
            return false
        }
        if textField == txtSelectCity {
            self.view.endEditing(true)
            if self.arrForCityList.count > 0 {
                let dialogForCity = CustomCityDialog.showCustomCityDialog(withDataSource: self.arrForCityList)
                dialogForCity.onCitySelected = { [unowned self, unowned dialogForCity] (cityID:String, cityName:String) in
                    self.strCityId = cityID
                    self.txtSelectCity.text = cityName
                    dialogForCity.removeFromSuperview();
                }
            } else {
                Utility.showToast(message: "MSG_NO_CITY_FOUND_IN_SELECTED_COUNTRY".localized)
            }
            return false
        }
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtMobileNumber {
            self.createToolbar(textfield: txtMobileNumber)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        if textField == txtFirstName {
            txtLastName.becomeFirstResponder()
        } else if textField == txtLastName {
            txtEmail.becomeFirstResponder()
        } else if textField == txtEmail {
            txtPassword.becomeFirstResponder()
        } else if textField == txtPassword {
            txtMobileNumber.becomeFirstResponder()
        } else if textField == txtMobileNumber {
            if txtAddress.isHidden {
                textField.resignFirstResponder()
            } else {
                txtAddress.becomeFirstResponder()
            }
        } else if textField == txtAddress {
            textField.resignFirstResponder()
        } else {
            return true
        }
        return true
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

    @objc func doneTextField(sender : UIBarButtonItem){
        view.endEditing(true)
    }

    //MARK: - ACTION METHODS
    @IBAction func onClickBtnTwitterLogin(_ sender: Any) {
        self.socialId = ""
    }

    @IBAction func onClickBtnCheckbox(_ sender: Any) {
        if cbAccept.isSelected {
            cbAccept.isSelected = false
        } else {
            cbAccept.isSelected = true
        }
    }

    @IBAction func onClickBtnApplyPromo(_ sender: Any) {
        self.view.endEditing(true)
        if ((txtReferralCode.text?.count)! <  1) {
            Utility.showToast(message: "MSG_PLEASE_ENTER_REFERRAL_CODE".localized)
        } else {
            wsCheckIsReferralValid()
        }
    }

    @IBAction func editImageButtonClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        dialogForImage = CustomPhotoDialog.showPhotoDialog("TXT_SELECT_IMAGE".localized, andParent: self, isCrop: true)
        dialogForImage?.onImageSelected = { (image:UIImage) in
            self.imgProfilePic.image = image
            self.isPicAdded = true
        }
    }

    @IBAction func onClickBtnRegister(_ sender: Any){
        checkValidation()
    }

    @IBAction func onClickBtnTermsAndConditions(_ sender: Any) {
        guard let url = URL(string: WebService.USER_PANEL_URL + "legal/provider-terms-conditions") else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }

    @IBAction func onClickBtnShowHidePassword(_ sender: Any) {
        if self.txtPassword.isSecureTextEntry {
            self.txtPassword.isSecureTextEntry = false
            self.btnShowHidePassword.setBackgroundImage(UIImage.init(named: "passwordShow"), for: .normal)
        } else {
            self.txtPassword.isSecureTextEntry = true
            self.btnShowHidePassword.setBackgroundImage(UIImage.init(named: "passwordHide"), for: .normal)
        }
    }

    //MARK: - WEB SERVICE CALLS
    func wsCheckIsReferralValid() {
        Utility.showLoading()
        let dictParam : [String : Any] = [PARAMS.REFERRAL_CODE:txtReferralCode.text!,
                                          PARAMS.TYPE : CONSTANT.TYPE_PROVIDER,
                                          PARAMS.COUNTRY_ID:strCountryId ?? ""]

        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_CHECK_REFERRAL, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true) {
                self.strReferralCode = self.txtReferralCode.text;
                DispatchQueue.main.async {
                    self.txtReferralCode.isUserInteractionEnabled = false
                    self.btnApply.isUserInteractionEnabled = false
                    self.btnApply.setImage(UIImage.init(named: "selected_icon"), for: UIControl.State.normal)
                    self.btnApply.setTitle("", for: UIControl.State.normal)
                    self.btnApply.backgroundColor = .clear
                }
            } else {
                DispatchQueue.main.async {
                    self.strReferralCode = ""
                    self.txtReferralCode.isUserInteractionEnabled = true
                    self.btnApply.isUserInteractionEnabled = true
                    self.txtReferralCode.text = ""
                    self.btnApply.setImage(UIImage.init(named: ""), for: UIControl.State.normal)
                    self.btnApply.setTitle("TXT_APPLY".localized, for: UIControl.State.normal)
                    self.btnApply.backgroundColor = .themeColor
                }
            }
        }
    }

    func wsGetCountries() {
        Utility.showLoading()
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_GET_COUNTRY_LIST, methodName: AlamofireHelper.GET_METHOD, paramData: Dictionary.init()) { (response, error) -> (Void) in
            Parser.parseCountries(response, toArray: self.arrForCountryList, completion: { result in
                if result {
                    let locationManager = LocationManager();
                    locationManager.currentAddressLocation(blockCompletion: { [weak self] (myAddress, error) in
                        let item = myAddress?.last?.country ?? ""

                        guard let strongSelf = self else {return}
                        let country:Countries = strongSelf.arrForCountryList[0] as! Countries
                        var isCountryMatch:Bool = false
                        for country in strongSelf.arrForCountryList {
                            let country = country as! Countries
                            if country.country_name?.compare(item) == ComparisonResult.orderedSame {
                                strongSelf.strCountryId = country._id

                                if strongSelf.txtSelectCountry != nil {
                                    strongSelf.txtSelectCountry.text = country.country_name
                                }

                                if strongSelf.lblCountryCode != nil {
                                    strongSelf.lblCountryCode.text = country.country_phone_code
                                }

                                strongSelf.strCountryCode = country.country_code ?? "IN"

                                preferenceHelper.setIsReferralInCountry(country.is_referral_to_user!)
                                strongSelf.updateUI()
                                strongSelf.wsGetCities()
                                isCountryMatch = true
                                break;
                            }
                        }
                        if !isCountryMatch {
                            strongSelf.strCountryId = country._id
                            strongSelf.txtSelectCountry.text = country.country_name
                            strongSelf.lblCountryCode.text = country.country_phone_code
                            strongSelf.strCountryCode = country.country_code ?? "IN"

                            preferenceHelper.setIsReferralInCountry(country.is_referral_to_user ?? false)
                            strongSelf.updateUI()
                            strongSelf.wsGetCities()
                        }
                    })
                }
                Utility.hideLoading()
            })
        }
    }

    func wsGetCities() {
        Utility.showLoading()
        let dictParam:[String:String] = [PARAMS.COUNTRY_ID : strCountryId!]

        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_GET_CITY_LIST, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            Parser.parseCities(response, toArray: self.arrForCityList, completion: { result in
                Utility.hideLoading()
                if result {}
            })
        }
    }

    func wsRegister() {
        Utility.showLoading();
        var dictParam : [String : Any] =
            [PARAMS.FIRST_NAME : txtFirstName.text! ,
             PARAMS.LAST_NAME  : txtLastName.text!  ,
             PARAMS.EMAIL      : txtEmail.text!  ,
             PARAMS.PASSWORD  : txtPassword.text!  ,
             PARAMS.IS_EMAIL_VERIFIED:String(preferenceHelper.getIsEmailVerified()),
             PARAMS.IS_PHONE_NUMBER_VERIFIED:String(preferenceHelper.getIsPhoneNumberVerified()),
             PARAMS.COUNTRY_PHONE_CODE  :lblCountryCode.text ?? ""  ,
             PARAMS.PHONE : txtMobileNumber.text! ,
             PARAMS.ADDRESS  : txtAddress.text ?? "",
             PARAMS.COUNTRY_ID  : strCountryId!,
             PARAMS.CITY_ID  : strCityId!,
             PARAMS.SOCIAL_ID: "",
             PARAMS.DEVICE_TYPE: CONSTANT.IOS,
             PARAMS.DEVICE_TOKEN:preferenceHelper.getDeviceToken(),
             PARAMS.REFERRAL_CODE:strReferralCode ??  "",
             PARAMS.LOGIN_BY: CONSTANT.MANUAL,
        ]
        if !socialId.isEmpty {
            dictParam.updateValue(socialId, forKey: PARAMS.SOCIAL_ID)
            dictParam.updateValue("", forKey: PARAMS.PASSWORD)
            dictParam.updateValue(CONSTANT.SOCIAL, forKey: PARAMS.LOGIN_BY)
        }

        let alamoFire:AlamofireHelper = AlamofireHelper();
        if isPicAdded {
            alamoFire.getResponseFromURL(url: WebService.WS_PROVIDER_REGISTER, paramData: dictParam, image: imgProfilePic.image!, block: { (response, error) -> (Void) in
                Parser.parseUserStorageData(response: response, completion: { result in
                    if result {
                        APPDELEGATE.clearMassNotificationEntity()
                        APPDELEGATE.clearOrderNotificationEntity()
                        APPDELEGATE.goToMain()
                        Utility.hideLoading();
                    }
                })
            })
        } else {
            alamoFire.getResponseFromURL(url: WebService.WS_PROVIDER_REGISTER, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
                Parser.parseUserStorageData(response: response, completion: { result in
                    if result {
                        APPDELEGATE.clearMassNotificationEntity()
                        APPDELEGATE.clearOrderNotificationEntity()
                        APPDELEGATE.goToMain()
                        Utility.hideLoading();
                    }
                })
            }
        }
    }

    func wsGetOtpVerify() {
        let dictParam : [String : Any] =
            [PARAMS.EMAIL      : txtEmail.text!  ,
             PARAMS.COUNTRY_PHONE_CODE : lblCountryCode.text!,
             PARAMS.PHONE : txtMobileNumber.text! ,
             PARAMS.TYPE : CONSTANT.TYPE_PROVIDER
        ]

        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_OTP_VERIFICATION, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            if Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true) {
                let otpResponse:OtpResponse = OtpResponse.init(dictionary: response)!
                switch (self.checkWhichOtpValidationON())
                {
                case CONSTANT.SMS_AND_EMAIL_VERIFICATION_ON:
                    self.openOTPVerifyDialog(otpEmailVerification: otpResponse.otp_for_email!, otpSmsVerification: otpResponse.otp_for_sms!, editTextOneHint:"TXT_EMAIL_OTP".localized, ediTextTwoHint: "TXT_PHONE_OTP".localized, isEditTextTwoIsHidden: false, param: dictParam)
                    break;
                case CONSTANT.SMS_VERIFICATION_ON:
                    self.openOTPVerifyDialog(otpEmailVerification: "", otpSmsVerification: otpResponse.otp_for_sms!, editTextOneHint:"TXT_PHONE_OTP".localized, ediTextTwoHint: "TXT_PHONE_OTP".localized, isEditTextTwoIsHidden: true, param: dictParam)
                    break;
                case CONSTANT.EMAIL_VERIFICATION_ON:
                    self.openOTPVerifyDialog(otpEmailVerification: otpResponse.otp_for_email!, otpSmsVerification: "", editTextOneHint:"TXT_EMAIL_OTP".localized, ediTextTwoHint: "TXT_PHONE_OTP".localized, isEditTextTwoIsHidden: true, param: dictParam)
                    break;
                default:
                    break;
                }
            }
        }
    }

    //MARK: - USER DEIFNE METHODS
    func checkValidation() -> Void {
        let validPassword = txtPassword.text!.checkPasswordValidation()
        let validEmail = txtEmail.text!.checkEmailValidation()
        let validMobileNumber = txtMobileNumber.text!.isValidMobileNumber()

        if (txtFirstName.text?.isEmpty())! {
            txtFirstName.becomeFirstResponder()
            Utility.showToast(message:"MSG_PLEASE_ENTER_VALID_NAME".localized)
        } else if (txtLastName.text?.isEmpty())! {
            txtLastName.becomeFirstResponder()
            Utility.showToast(message:"MSG_PLEASE_ENTER_VALID_NAME".localized)
        } else if validEmail.0 == false {
            txtEmail.becomeFirstResponder()
            Utility.showToast(message:validEmail.1)
        } else if (validPassword.0 == false && socialId.isEmpty) {
            txtPassword.becomeFirstResponder()
            Utility.showToast(message:validPassword.1)
        } else if (txtSelectCountry.text?.isEmpty())! {
            txtSelectCountry.becomeFirstResponder()
            Utility.showToast(message:"MSG_PLEASE_SELECT_COUNTRY".localized)
        } else if lblCountryCode.text == "TXT_DEFAULT".localized || (lblCountryCode.text?.count == 0) {
            txtSelectCountry.becomeFirstResponder()
            Utility.showToast(message:"MSG_PLEASE_SELECT_COUNTRY".localized)
        } else if (txtSelectCity.text?.isEmpty())! {
            txtSelectCity.becomeFirstResponder()
            Utility.showToast(message:"MSG_PLEASE_SELECT_CITY".localized)
        } else if validMobileNumber.0 == false {
            txtMobileNumber.becomeFirstResponder()
            Utility.showToast(message:validMobileNumber.1)
        } else if !cbAccept.isSelected {
            Utility.showToast(message:"MSG_PLEASE_ACCEPT_TERMS_AND_CONDITION_FIRST".localized)
        } else if (preferenceHelper.getIsProfilePicRequired() && !isPicAdded) {
            Utility.showToast(message:"MSG_PLEASE_UPLOAD_PROFILE_PICTURE".localized)
        } else {
            if (preferenceHelper.getIsEmailVerification() || preferenceHelper.getIsPhoneNumberVerification()) {
                wsGetOtpVerify()
            } else {
                wsRegister()
            }
        }
    }

    //MARK: - Dialogs
    func openOTPVerifyDialog(otpEmailVerification:String, otpSmsVerification:String, editTextOneHint:String, ediTextTwoHint:String, isEditTextTwoIsHidden:Bool, param:[String:Any]) {
        self.view.endEditing(true)
        let dialogForVerification = CustomVerificationDialog.showCustomVerificationDialog(title: "TXT_VERIFY_ACCOUNT".localizedCapitalized, message: "MSG_VERIFY_DETAIL".localizedCapitalized, titleLeftButton: "TXT_CANCEL".localizedUppercase, titleRightButton: "TXT_OK".localizedUppercase, editTextOneHint: editTextOneHint, editTextTwoHint:ediTextTwoHint, isEdiTextTwoIsHidden: isEditTextTwoIsHidden, isForVerifyOtp: true, param: param)
        dialogForVerification.startTimer()
        dialogForVerification.onClickRightButton = { [unowned dialogForVerification, unowned self] (text1:String, text2:String) in
            switch (self.checkWhichOtpValidationON()) {
            case CONSTANT.SMS_AND_EMAIL_VERIFICATION_ON:
                if (text1.compare(otpEmailVerification) == ComparisonResult.orderedSame && text2.compare(otpSmsVerification) == ComparisonResult.orderedSame) {
                    dialogForVerification.removeFromSuperview()
                    self.wsRegister()
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
                    self.wsRegister()
                } else {
                    Utility.showToast(message: "MSG_SMS_OTP_WRONG".localized)
                }
                break;
            case CONSTANT.EMAIL_VERIFICATION_ON:
                if (text1.compare(otpEmailVerification) == ComparisonResult.orderedSame) {
                    dialogForVerification.removeFromSuperview()
                    self.wsRegister()
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
        }
    }

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

    //MARK: - GOOGLE AND FACE BOOK SIGN METHOD
    @IBAction func onClickBtnGoogleLogin(_ sender: Any) {
        print("google sign in click")
        self.socialId = ""
        GIDSignIn.sharedInstance.signOut()
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self){ user, error in
            if (error == nil) {
                let url =  user?.profile?.imageURL(withDimension: 0)?.absoluteString
                let userId = user?.userID
                let fullName = user?.profile?.name
                let name = fullName?.components(separatedBy: " ")
                let email = user?.profile?.email
                self.updateUiForSocialLogin(email: email!, socialId: userId!, firstName: (name?[0])!, lastName: (name?[1])!, profileUri: url!)
            } else {
                print("\(error?.localizedDescription ?? "")")
            }
        }
    }

    @IBAction func onClickBtnFacebook(_ sender: Any) {
        self.socialId = ""
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(permissions: [.publicProfile], viewController: self) { (loginResult) in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success( _, _, _):
                Utility.showLoading()
                self.getFBUserData()
            }
        }
    }

    //function is fetching the user data
    func getFBUserData() {
        if((AccessToken.current) != nil) {
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start { (connection, result, error) in
                Utility.hideLoading()
                if (error == nil) {
                    let dict = result as! [String : AnyObject]
                    let email:String = (dict["email"] as? String) ?? ""
                    Profile.loadCurrentProfile(completion: { (profile, error) in
                        if (error == nil) {
                            self.updateUiForSocialLogin(email: email , socialId: (profile?.userID)!, firstName: (profile?.firstName)!, lastName: (profile?.lastName)!, profileUri: (profile?.imageURL(forMode: .normal, size: self.imgProfilePic.frame.size)?.absoluteString)!)
                        } else {
                            Utility.showToast(message: (error?.localizedDescription)!)
                        }
                    })
                }
            }
        }
    }

    func updateUiForSocialLogin(email:String = "",
                                socialId:String = "",
                                firstName:String = "",
                                lastName:String = "",
                                profileUri:String = "") {
        if (!email.isEmpty) {
            txtEmail.text = email
            txtEmail.isEnabled = false
            preferenceHelper.setIsEmailVerified(true)
        }
        self.socialId = socialId;
        txtFirstName.text = firstName
        txtLastName.text = lastName
        txtPassword.isHidden = true;
        btnShowHidePassword.isHidden = true;
        viewForPassword.isHidden = true;
        LoginManager.init().logOut()
        GIDSignIn.sharedInstance.signOut()
        if (!profileUri.isEmpty) {
            imgProfilePic.downloadedFrom(link: profileUri,isAppendBaseUrl: false)
            isPicAdded = true
        }
    }
}

extension RegisterVC:LoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {}

    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if error != nil {}else {
            if result?.isCancelled ?? true {
                print(error ?? "")
            } else {
                Utility.showLoading()
                self.getFBUserData()
            }
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
    return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
    guard let input = input else { return nil }
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
