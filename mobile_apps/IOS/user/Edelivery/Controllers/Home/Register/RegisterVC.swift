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
import AuthenticationServices
import CoreLocation

class RegisterVC: BaseVC,UITextFieldDelegate,UITextViewDelegate
{
    //MARK: - Dialogs
    var dialogForImage:CustomPhotoDialog? = nil
    var dialogForCountry:CustomCountryDialog? = nil
    
    //MARK: - OUTLETS
    @IBOutlet weak var cbAccept: UIButton!
    @IBOutlet weak var scrRegister: UIScrollView!
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var viewForPassword: UIView!
    @IBOutlet weak var btnShowHidePassword: UIButton!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtSelectCity: UITextField!
    @IBOutlet weak var btnReferral: UIButton!
    @IBOutlet weak var lblDivider: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var viewForProfile: UIView!
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var txtSelectCountry: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var txtReferralCode:UITextField!
    @IBOutlet weak var stkReferralView: UIStackView!
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var stkRegister: UIStackView!
    @IBOutlet weak var lblTransparent: UILabel!
    @IBOutlet weak var stkSocialLogin: UIStackView!
    @IBOutlet weak var viewForSocialLogin: UIView!
    @IBOutlet weak var lblOr: UILabel!
    @IBOutlet weak var tableForDropDown: UITableView!
    @IBOutlet weak var viewForDropDown: UIView!
    @IBOutlet weak var subViewForDropDown: UIView!
    @IBOutlet weak var txtViewSignIn: UITextView!
    @IBOutlet weak var heightForDropDown: NSLayoutConstraint!
    @IBOutlet weak var btnFacebook: FBLoginButton!
    @IBOutlet weak var btnGoogle: GIDSignInButton!
    @IBOutlet weak var txtvwTermsConditions: UITextView!
    @IBOutlet weak var lblSignUp: UILabel!
    @IBOutlet weak var viewForReferral : UIView!
    
    //MARK: - VARIABLES
    var arrForCountryList = [CountryModal]()
    var selectedCountryObj = CountryModal(fromDictionary: [:])
    var arrForCityList : NSMutableArray = NSMutableArray.init()
    var strCountryId:String? = ""
    var strCityId:String? = ""
    var strReferralCode:String? = ""
    var isPicAdded:Bool = false
    var socialId:String = ""
    var arrCountryCode = [String]()
    var heightDropDown : CGFloat = 0.0
    var isSignInWithApple:Bool = false
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalization()
        RegisterVC.wsGetCountries { [weak self] (arrForCountryList) in
            guard let self = self else { return }
            self.arrForCountryList.removeAll()
            self.arrForCountryList.append(contentsOf: arrForCountryList)
            if currentBooking.currentSendPlaceData.latitude != 0 && currentBooking.currentSendPlaceData.longitude != 0 {
                let location = CLLocation.init(latitude: currentBooking.currentSendPlaceData.latitude, longitude: currentBooking.currentSendPlaceData.longitude)
                LocationCenter.default.fetchCityAndCountry(location: location) {[weak self] (city, country, error) in
                    guard let self = self else { return }
                    print(city ?? "")
                    print(country ?? "")
                    for data in self.arrForCountryList {
                        if data.name.lowercased() == country?.lowercased() {
                            self.txtSelectCountry.text = data.name!
                            self.lblCountryCode.isUserInteractionEnabled = false
                            self.lblCountryCode.text = data.code
                            self.txtMobileNumber.text = ""
                            self.selectedCountryObj = data
                            preferenceHelper.setCountryCode(data.alpha2)
                            self.updateUI()
                        }
                    }
                }
            }
            Utility.hideLoading()
        }
        
        btnGoogle.style = .standard
        btnGoogle.colorScheme = .light
        btnFacebook.delegate = self
        btnFacebook.permissions = ["public_profile", "email"]
        btnFacebook.isHidden = true
        LoginManager.init().logOut()
        GIDSignIn.sharedInstance.signOut()
        lblOr.isHidden = true
        if preferenceHelper.getIsSocialLoginEnable() {
            viewForSocialLogin.isHidden = false
            lblOr.isHidden = false
            if UIApplication.isRTL() {
                btnFacebook.contentHorizontalAlignment = .left
                btnGoogle.contentHorizontalAlignment = .right
            }
            //Set up apple sign in Button
            if #available(iOS 13.2, *) {
                let btnAppleID = ASAuthorizationAppleIDButton(type: .signUp, style: .black)
                
                btnAppleID.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
                stkSocialLogin.addArrangedSubview(btnAppleID)
            }
        } else {
            viewForSocialLogin.isHidden = true
            lblOr.isHidden = true
        }
        
        txtMobileNumber.keyboardType = .numberPad
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.txtLastName.isHidden = false
        self.viewForPassword.isHidden = false
        txtEmail.isEnabled = true
        txtFirstName.isEnabled = true
        txtLastName.isEnabled = true
        self.isSignInWithApple = false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
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
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func setLocalization() {
        /*set colors*/
        self.btnApply.setTitle("TXT_APPLY".localized, for: UIControl.State.normal)
        self.btnApply.setImage(UIImage.init(), for: UIControl.State.normal)
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        self.scrRegister.backgroundColor = UIColor.themeViewBackgroundColor
        txtFirstName.textColor = UIColor.themeTextColor
        txtLastName.textColor = UIColor.themeTextColor
        txtEmail.textColor = UIColor.themeTextColor
        txtPassword.textColor = UIColor.themeTextColor
        txtSelectCity.textColor = UIColor.themeTextColor
        txtSelectCountry.textColor = UIColor.themeTextColor
        txtMobileNumber.textColor = UIColor.themeTextColor
        txtAddress.textColor = UIColor.themeTextColor
        lblCountryCode.textColor = UIColor.themeTextColor
        btnRegister.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        btnRegister.backgroundColor = UIColor.themeButtonBackgroundColor
        lblCountryCode.textColor = UIColor.themeTextColor
        lblDivider.backgroundColor = UIColor.themeLightTextColor
        lblTransparent.backgroundColor = UIColor.themeWhiteTransparentColor
        lblMobileNumber.textColor = UIColor.themeLightTextColor
        btnReferral.setTitleColor(UIColor.themeTextColor, for: .normal)
        lblSignUp.textColor = UIColor.themeTextColor
        /*set titles*/
        txtFirstName.placeholder = "TXT_FIRST_NAME".localizedCapitalized
        txtLastName.placeholder = "TXT_LAST_NAME".localizedCapitalized
        txtEmail.placeholder = "TXT_EMAIL".localizedCapitalized
        txtPassword.placeholder = "TXT_PASSWORD".localizedCapitalized
        txtConfirmPassword.placeholder = "TXT_CONFIRM_PASSWORD".localizedCapitalized
        txtSelectCity.placeholder = "TXT_CITY".localizedCapitalized
        txtSelectCountry.placeholder = "TXT_SELECT_COUNTRY".localizedCapitalized
        txtMobileNumber.placeholder = "TXT_MOBILE_NO".localizedCapitalized
        lblMobileNumber.text = "TXT_MOBILE_NO".localizedCapitalized
        txtAddress.placeholder = "TXT_ADDRESS".localizedCapitalized
        lblCountryCode.text = "TXT_DEFAULT".localizedCapitalized
        lblSignUp.text = "TXT_SIGNUP".localized
        btnRegister.setTitle("TXT_SIGNUP".localizedCapitalized, for: UIControl.State.normal)
        btnReferral.setTitle("  \("TXT_REFERRAL".localized)  ", for: .normal)
        self.txtReferralCode.placeholder = "TXT_ENTER_REFEERAL_CODE".localizedCapitalized
        let tap = UITapGestureRecognizer(target: self, action:#selector(tapLblCountry(gesture:)))
        lblCountryCode.addGestureRecognizer(tap)
        self.txtvwTermsConditions.font = FontHelper.labelRegular()
        self.txtvwTermsConditions.text = "TXT_SIGN_UP_PRIVACY".localized + " " + "TXT_TERMS_AND_CONDITIONS".localizedCapitalized + " " + "text_and".localized + " " + "TXT_PRIVACY_POLICIES".localizedCapitalized
        self.configureLinks()
        
        /*Set Fonts*/
        txtFirstName.font = FontHelper.textRegular()
        txtLastName.font = FontHelper.textRegular()
        txtEmail.font = FontHelper.textRegular()
        txtPassword.font = FontHelper.textRegular()
        txtConfirmPassword.font = FontHelper.textRegular()
        txtSelectCity.font = FontHelper.textRegular()
        txtSelectCountry.font = FontHelper.textRegular()
        txtMobileNumber.font = FontHelper.textRegular()
        txtAddress.font = FontHelper.textRegular()
        lblSignUp.font = FontHelper.textMedium(size: FontHelper.largest)
        lblCountryCode.font = FontHelper.textRegular()
        btnReferral.titleLabel?.font = FontHelper.textRegular()
        
        if preferenceHelper.getIsSocialLoginEnable() {
            stkSocialLogin.isHidden = false
            lblOr.isHidden = false
        } else {
            stkSocialLogin.isHidden = true
            lblOr.isHidden = true
        }
        
        lblOr.textColor = UIColor.themeTextColor
        lblOr.text = "TXT_OR".localizedUppercase
        lblOr.font = FontHelper.textRegular()
        
        viewForDropDown.isHidden = true
        viewForDropDown.backgroundColor = UIColor.white
        subViewForDropDown.setShadow(shadowColor: UIColor.black.cgColor, shadowOffset: CGSize.init(width: 2.0, height: 2.0), shadowOpacity: 5.0, shadowRadius: 2.0)
        tableForDropDown.delegate = self
        tableForDropDown.dataSource = self
        txtViewSignIn.isEditable = false
        txtViewSignIn.isSelectable = true
        txtViewSignIn.delegate = self
        txtViewSignIn.hyperLink(originalText: "TXT_HAVE_ACCOUNT_SIGNIN".localized, hyperLink: "TXT_SIGNIN_NOW".localized, urlString: "http://signin.com/")
        btnReferral.backgroundColor = .themeStatusTickColor
        btnReferral.setRound(withBorderColor: .clear, andCornerRadious: 4.0, borderWidth: 0)
    }
    
    func configureLinks() {
        let attributedString:NSMutableAttributedString = NSMutableAttributedString.init(string: self.txtvwTermsConditions.text)
        attributedString.setAttributes([.link:WebService.USER_PANEL_URL + "legal/user-terms-conditions"], range:attributedString.mutableString.range(of:"TXT_TERMS_AND_CONDITIONS".localizedCapitalized, options: .caseInsensitive))
        attributedString.setAttributes([.link:WebService.USER_PANEL_URL + "legal/user-privacy-policy"], range:attributedString.mutableString.range(of:"TXT_PRIVACY_POLICIES".localizedCapitalized, options: .caseInsensitive))
        attributedString.addAttribute(.font, value: FontHelper.labelRegular(), range: attributedString.mutableString.range(of: self.txtvwTermsConditions.text))
        self.txtvwTermsConditions.attributedText = attributedString
        self.txtvwTermsConditions.linkTextAttributes = [
            .foregroundColor: UIColor.themeIconTintColor,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        self.txtvwTermsConditions.textColor = .themeIconTintColor
    }
    
    func setupLayout() {
        viewForProfile.setRound()
        btnRegister.applyShadowToButton()
        btnRegister.applyRoundedCornersWithHeight()
    }
    
    func updateUI() {
        if preferenceHelper.getIsShowOptionalFieldInRegister() {
            self.txtAddress.isHidden = false
        } else {
            self.txtAddress.isHidden = true
        }
        self.txtAddress.isHidden = true
        self.txtSelectCity.isHidden = true
        
        if preferenceHelper.getIsReferralOn() {
            self.stkReferralView.isHidden = false
            self.btnReferral.isHidden = false
            self.viewForReferral.isHidden = false
            self.strReferralCode = ""
            self.txtReferralCode.isUserInteractionEnabled = true
            self.btnApply.isUserInteractionEnabled = true
            self.txtReferralCode.text = ""
            self.btnApply.setImage(UIImage.init(named: ""), for: UIControl.State.normal)
            self.btnApply.setTitle("TXT_APPLY".localized, for: UIControl.State.normal)
            self.txtReferralCode.placeholder = "TXT_ENTER_REFEERAL_CODE".localizedCapitalized
            
            if UIApplication.isRTL() {
                btnReferral.contentHorizontalAlignment = .right
            } else {
                btnReferral.contentHorizontalAlignment = .left
            }
        } else {
            self.stkReferralView.isHidden = true
            self.btnReferral.isHidden = true
            self.viewForReferral.isHidden = true
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
    
    //MARK: - UITexView Delegate
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.absoluteString == "http://signin.com/" {
            (self.parent as! Home).goToSignIn()
        }
        return false
    }
    
    //MARK: - TEXTFIELD DELEGATE METHODS
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtSelectCountry {
            self.view.endEditing(true)
            dialogForCountry = CustomCountryDialog.showCustomCountryDialog(withDataSource:arrForCountryList)
            dialogForCountry?.onCountrySelected = {
                [unowned self] (country:CountryModal) in
                self.txtSelectCountry.text = country.name!
                self.lblCountryCode.isUserInteractionEnabled = false
                self.lblCountryCode.text = country.code
                self.txtMobileNumber.text = ""
                self.selectedCountryObj = country
                self.updateUI()
                self.dialogForCountry?.removeFromSuperview()
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtReferralCode {
            txtReferralCode.resignFirstResponder()
        }
        
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
                txtMobileNumber.resignFirstResponder()
            } else {
                txtAddress.becomeFirstResponder()
            }
        } else {
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        /*
        if textField == txtMobileNumber {
            let result = textField.text?.getPhoneNumberFormat(regionCode: selectedCountryObj.alpha2 ?? "IN")
            if result!.isValid {
                self.txtMobileNumber.text = result!.phoneNumber.nationalNumber.stringValue
            } else {
                Utility.showToast(message: "MSG_TXT_PLEASE_ENTER_VALID_MOBILE_NUMBER".localized)
            }
        }*/
    }
    
    //MARK: - ACTION METHODS
    @IBAction func onClickBtnTwitter(_ sender: Any) {
        self.socialId = ""
    }
    
    @IBAction func onClickBtnCheckbox(_ sender: Any) {
        if cbAccept.isSelected {
            cbAccept.isSelected = false
        } else {
            cbAccept.isSelected = true
        }
    }
    
    @IBAction func onClickBtnTermsAndConditions(_ sender: Any) {
        guard let url = URL(string: WebService.USER_PANEL_URL + "legal/user-terms-conditions") else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func onClickReferral(_ sender: UIButton) {
        self.view.endEditing(true)
    }
    
    @IBAction func editImageButtonClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        self.dialogForImage = CustomPhotoDialog.showPhotoDialog("TXT_SELECT_IMAGE".localized, andParent: self)
        dialogForImage?.onImageSelected = { [unowned self, weak dialogForImage = self.dialogForImage] (image:UIImage) in
            self.imgProfilePic.image = image
            self.isPicAdded = true
            dialogForImage?.removeFromSuperviewAndNCObserver()
            dialogForImage = nil
        }
    }
    
    @IBAction func onClickBtnRegister(_ sender: Any) {
        self.view.endEditing(true)
        checkValidation()
    }
    
    @IBAction func onClickBtnApplyPromo(_ sender: Any) {
        self.view.endEditing(true)
        if ((txtReferralCode.text?.count)! < 1) {
            Utility.showToast(message: "MSG_PLEASE_ENTER_REFERRAL_CODE".localized)
        } else {
            if ((txtSelectCountry.text?.count)! < 1) {
                Utility.showToast(message:"MSG_PLEASE_SELECT_COUNTRY".localized)
            } else {
                wsCheckIsReferralValid()
            }
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
    
    //MARK: - Web service call to register
    func wsRegister() {
        Utility.showLoading()
        var dictParam : [String : String] =
        [PARAMS.FIRST_NAME : txtFirstName.text ?? "" ,
         PARAMS.IPHONE_ID:preferenceHelper.getRandomCartID(),
         PARAMS.LAST_NAME  : txtLastName.text ?? ""  ,
         PARAMS.EMAIL      : txtEmail.text ?? ""  ,
         PARAMS.PASS_WORD  : txtPassword.text ?? ""  ,
         PARAMS.COUNTRY_PHONE_CODE  :lblCountryCode.text ?? "",
         PARAMS.PHONE : txtMobileNumber.text ?? "" ,
         PARAMS.ADDRESS  : txtAddress.text ?? "",
         PARAMS.COUNTRY_ID  : strCountryId ?? "",
         PARAMS.CITY  : txtSelectCity.text ?? "",
         PARAMS.DEVICE_TYPE: CONSTANT.IOS,
         PARAMS.DEVICE_TOKEN:preferenceHelper.getDeviceToken(),
         PARAMS.REFERRAL_CODE:strReferralCode ??  "",
         PARAMS.IS_EMAIL_VERIFIED:String(preferenceHelper.getIsEmailVerified()),
         PARAMS.IS_PHONE_NUMBER_VERIFIED:String(preferenceHelper.getIsPhoneNumberVerified()),
         PARAMS.LOGIN_BY: CONSTANT.MANUAL,
         PARAMS.SOCIAL_ID: "",
         PARAMS.COUNTRY_NAME : self.selectedCountryObj.name,
         PARAMS.COUNTRY_CODE :self.selectedCountryObj.alpha2,
         PARAMS.CURRENCY : self.selectedCountryObj.currency_code
        ]
        if !socialId.isEmpty() {
            dictParam.updateValue(socialId, forKey: PARAMS.SOCIAL_ID)
            dictParam.updateValue("", forKey: PARAMS.PASS_WORD)
            dictParam.updateValue(CONSTANT.SOCIAL, forKey: PARAMS.LOGIN_BY)
        }
        
        print("DicParam WS_USER_REGISTER ------ \(Utility.convertDictToJson(dict: dictParam))")
        let alamoFire:AlamofireHelper = AlamofireHelper()
        
        if isPicAdded {
            alamoFire.getResponseFromURL(url: WebService.WS_USER_REGISTER, paramData: dictParam, image: imgProfilePic.image!, block: { (response, error) -> (Void) in
                print(Utility.convertDictToJson(dict: response as! Dictionary<String, Any>))
                Parser.parseUserStorageData(response: response, completion: { result in
                    if result {
                        APPDELEGATE.clearOrderNotificationEntity()
                        APPDELEGATE.clearMassNotificationEntity()
                        APPDELEGATE.goToMain()
                        Utility.hideLoading()
                    }
                })
            })
        } else {
            alamoFire.getResponseFromURL(url: WebService.WS_USER_REGISTER, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
                Utility.hideLoading()
                Parser.parseUserStorageData(response: response, completion: { result in
                    if result {
                        APPDELEGATE.clearOrderNotificationEntity()
                        APPDELEGATE.clearMassNotificationEntity()
                        APPDELEGATE.goToMain()
                        return
                    }
                })
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
                    // do with default
                    break
                }
            }
        }
    }
    
    func wsCheckIsReferralValid() {
        Utility.showLoading()
        let dictParam : [String : Any] = [PARAMS.REFERRAL_CODE:txtReferralCode.text!,
                                          PARAMS.TYPE : CONSTANT.TYPE_USER,
                                          PARAMS.COUNTRY_ID:strCountryId ?? "",
                                          PARAMS.COUNTRY_CODE : selectedCountryObj.alpha2 ?? ""]
        
        let alamoFire:AlamofireHelper = AlamofireHelper()
        alamoFire.getResponseFromURL(url: WebService.WS_CHECK_REFERRAL, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true) {
                self.strReferralCode = self.txtReferralCode.text
                DispatchQueue.main.async {
                    self.txtReferralCode.isUserInteractionEnabled = false
                    self.btnApply.isUserInteractionEnabled = false
                    self.btnApply.setImage(UIImage.init(named: "selected_icon"), for: UIControl.State.normal)
                    self.btnApply.backgroundColor = .clear
                    self.btnApply.setTitle("", for: UIControl.State.normal)
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
    
    //MARK: - USER DEIFNE METHODS
    func checkValidation() -> Void {
        let validPassword = txtPassword.text!.checkPasswordValidation()
        let validEmail = txtEmail.text!.checkEmailValidation()
        let validMobileNumber = txtMobileNumber.text!.isValidMobileNumber()
        
        if ((txtFirstName.text?.isEmpty())! && (socialId.isEmpty() || self.isSignInWithApple)) {
            txtFirstName.becomeFirstResponder()
            Utility.showToast(message:"MSG_PLEASE_ENTER_VALID_NAME".localized)
        } else if (validEmail.0 == false && (socialId.isEmpty() || self.isSignInWithApple)) {
            txtEmail.becomeFirstResponder()
            Utility.showToast(message:validEmail.1)
        } else if (validPassword.0 == false && socialId.isEmpty()) {
            txtPassword.becomeFirstResponder()
            Utility.showToast(message:validPassword.1)
        } else if ((txtSelectCountry.text?.isEmpty())!) {
            txtSelectCountry.becomeFirstResponder()
            Utility.showToast(message:"MSG_PLEASE_SELECT_COUNTRY".localized)
        } else if validMobileNumber.0 == false {
            txtMobileNumber.becomeFirstResponder()
            Utility.showToast(message:validMobileNumber.1)
        } else if !cbAccept.isSelected {
            Utility.showToast(message:"MSG_PLEASE_ACCEPT_TERMS_AND_CODNITION_FIRST".localized)
        } else {
            var dictParam : [String : Any] = [PARAMS.TYPE : CONSTANT.TYPE_USER]
            switch (self.checkWhichOtpValidationON()) {
            case CONSTANT.SMS_AND_EMAIL_VERIFICATION_ON:
                preferenceHelper.setTempEmail(self.txtEmail.text!)
                preferenceHelper.setTempPhoneNumber(txtMobileNumber.text!)
                dictParam.updateValue(txtEmail.text!, forKey: PARAMS.EMAIL)
                dictParam.updateValue(txtMobileNumber.text!, forKey: PARAMS.PHONE)
                dictParam.updateValue(lblCountryCode.text!, forKey: PARAMS.COUNTRY_PHONE_CODE)
                self.wsGetOtpVerify(dictParam)
                break
            case CONSTANT.SMS_VERIFICATION_ON:
                dictParam.updateValue(self.txtMobileNumber.text!, forKey: PARAMS.PHONE)
                dictParam.updateValue(lblCountryCode.text!, forKey: PARAMS.COUNTRY_PHONE_CODE)
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
                self.wsRegister()
            }
        }
    }
    
    //MARK: - Dialogs
    func openOTPVerifyDialog(otpEmailVerification:String, otpSmsVerification:String,editTextOneHint:String, ediTextTwoHint:String, isEditTextTwoIsHidden:Bool, param:[String:Any]) {
        self.view.endEditing(true)
        let dialogForVerification = CustomVerificationDialog.showCustomVerificationDialog(title: "TXT_VERIFY_ACCOUNT".localizedCapitalized, message: "MSG_VERIFY_DETAIL".localizedCapitalized, titleLeftButton: "TXT_CANCEL".localizedCapitalized, titleRightButton: "TXT_OK".localizedCapitalized, editTextOneHint: editTextOneHint, editTextTwoHint:ediTextTwoHint, isEdiTextTwoIsHidden: isEditTextTwoIsHidden, isForVerifyOtp: true, param: param)
        dialogForVerification.startTimer()
        dialogForVerification.onClickRightButton = { [unowned self, unowned dialogForVerification] (text1:String, text2:String) in
            switch (self.checkWhichOtpValidationON()) {
            case CONSTANT.SMS_AND_EMAIL_VERIFICATION_ON:
                if text1.isEmpty() {
                    Utility.showToast(message: "MSG_EMAIL_OTP_WRONG".localized)
                } else if text2.isEmpty() {
                    Utility.showToast(message: "MSG_SMS_OTP_WRONG".localized)
                } else if (text1.compare(otpEmailVerification) == ComparisonResult.orderedSame && text2.compare(otpSmsVerification) == ComparisonResult.orderedSame) {
                    preferenceHelper.setIsEmailVerified(true)
                    preferenceHelper.setIsPhoneNumberVerified(true)
                    dialogForVerification.removeFromSuperview()
                    self.wsRegister()
                } else {
                    if !(text1.compare(otpEmailVerification) == ComparisonResult.orderedSame) {
                        Utility.showToast(message: "MSG_EMAIL_OTP_WRONG".localized)
                    } else if !(text2.compare(otpSmsVerification) == ComparisonResult.orderedSame) {
                        Utility.showToast(message: "MSG_SMS_OTP_WRONG".localized)
                    }
                }
                break
            case CONSTANT.SMS_VERIFICATION_ON:
                if text1.isEmpty() {
                    Utility.showToast(message: "MSG_SMS_OTP_WRONG".localized)
                } else if (text1.compare(otpSmsVerification) == ComparisonResult.orderedSame) {
                    preferenceHelper.setIsPhoneNumberVerified(true)
                    dialogForVerification.removeFromSuperview()
                    self.wsRegister()
                } else {
                    Utility.showToast(message: "MSG_SMS_OTP_WRONG".localized)
                }
                break
            case CONSTANT.EMAIL_VERIFICATION_ON:
                if text1.isEmpty() {
                    Utility.showToast(message: "MSG_EMAIL_OTP_WRONG".localized)
                } else if (text1.compare(otpEmailVerification) == ComparisonResult.orderedSame) {
                    preferenceHelper.setIsEmailVerified(true)
                    dialogForVerification.removeFromSuperview()
                    self.wsRegister()
                } else {
                    Utility.showToast(message: "MSG_EMAIL_OTP_WRONG".localized)
                }
                break
            default:
                // do with default
                break
            }
        }
        dialogForVerification.onClickLeftButton = { [unowned dialogForVerification] in
            dialogForVerification.removeFromSuperview()
        }
    }
    
    func checkWhichOtpValidationON() -> Int {
        if !self.socialId.isEmpty() && self.isSignInWithApple {
            return 0
        }
        
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
    
    @IBAction func onClickBtnGoogleLogin(_ sender: Any) {
        self.socialId = ""
        txtEmail.text = ""
        txtFirstName.text = ""
        txtLastName.text = ""
        
        GIDSignIn.sharedInstance.signOut()
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self){ user, error in
            guard error == nil else { return }
            let url =  user?.profile?.imageURL(withDimension: 0)?.absoluteString
            let userId = user?.userID                // For client-side use only!
            let fullName = user?.profile?.name
            let name = fullName?.components(separatedBy: " ")
            let email = user?.profile?.email
            self.updateUiForSocialLogin(email: email!, socialId: userId!, firstName: (name?[0])!, lastName: (name?[1])!, profileUri: url!, isSigninWithapple: false)
        }
    }
    
    @IBAction func onClickBtnFacebook(_ sender: Any) {
        self.socialId = ""
        txtEmail.text = ""
        txtFirstName.text = ""
        txtLastName.text = ""
        
        self.txtLastName.isHidden = true
        self.viewForPassword.isHidden = true
        
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(permissions: [.publicProfile], viewController: self) { (loginResult) in
            switch loginResult {
            case .failed(let error):
                printE(error)
                break
            case .cancelled:
                printE("User cancelled login.")
                break
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
                    Profile.loadCurrentProfile(completion: { [unowned self] (profile, error) in
                        if (error == nil) {
                            self.updateUiForSocialLogin(email: email , socialId: (profile?.userID)!, firstName: (profile?.firstName)!, lastName: (profile?.lastName)!, profileUri: (profile?.imageURL(forMode: .normal, size: self.imgProfilePic.frame.size)?.absoluteString)!, isSigninWithapple: false)
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
                                profileUri:String = "",isSigninWithapple:Bool) {
        if (!email.isEmpty()) {
            txtEmail.text = email
            txtEmail.isEnabled = false
            preferenceHelper.setIsEmailVerified(true)
        }
        
        if isSigninWithapple {
            if ((txtFirstName.text!.isEmpty())) {
                txtFirstName.isEnabled = true
                txtLastName.isEnabled = true
            } else {
                txtFirstName.isEnabled = false
                txtLastName.isEnabled = false
            }
            
            if ((txtEmail.text!.isEmpty())) {
                txtEmail.isEnabled = true
            } else {
                txtEmail.isEnabled = false
            }
        }
        self.socialId = socialId
        txtFirstName.text = firstName
        txtLastName.text = lastName
        self.viewForPassword.isHidden = true
        
        LoginManager.init().logOut()
        GIDSignIn.sharedInstance.signOut()
        
        if (!profileUri.isEmpty()) {
            imgProfilePic.downloadedFrom(link: profileUri,isAppendBaseUrl: false)
            isPicAdded = true
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}

extension RegisterVC:LoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if error != nil {}else {
            if result?.isCancelled ?? true {
                printE(error?.localizedDescription ?? "")
            } else {
                Utility.showLoading()
                self.getFBUserData()
            }
        }
    }
}

extension NSArray {
    public func toDictionary<Key: Hashable>(with selectKey: (Element) -> Key) -> [Key:Element] {
        var dict = [Key:Element]()
        for element in self {
            dict[selectKey(element)] = element
        }
        return dict
    }
}

extension RegisterVC {
    //MARK: - WEB SERVICE CALLS
    typealias CompletionHandler = (_ arrForCountryList:[CountryModal]) -> Void
    
    static func wsGetCountries(completionHandler: CompletionHandler) {
        var arrForCountryList = [CountryModal]()
        let url = Bundle.main.url(forResource: "countries", withExtension: ".json")!
        do {
            let jsonData = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: jsonData) as! NSArray
            print("json --------------- \(json)")
            arrForCountryList.removeAll()
            for obj in json {
                let value = obj as! [String : Any]
                arrForCountryList.append(CountryModal(fromDictionary: value))
            }
        } catch {
            print(error)
        }
        completionHandler(arrForCountryList)
    }
}

extension RegisterVC : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCountryCode.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
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

class DropdownCell: CustomTableCell {
    @IBOutlet weak var lblTitle: UILabel!
    
    //MARK: - LIFECYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        lblTitle.textColor = UIColor.themeTextColor
    }
}

@available(iOS 13.0, *)
extension RegisterVC: ASAuthorizationControllerDelegate {
    
    @objc func handleAppleIdRequest() {
        isSignInWithApple = true
        self.txtLastName.isHidden = true
        self.viewForPassword.isHidden = true
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            print("User id = \(userIdentifier)\nFull Name = \(String(describing: fullName)) \nEmail id = \(String(describing: email))")
            
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: userIdentifier) {  (credentialState, error) in
                switch credentialState {
                case .authorized:
                    print("The Apple ID credential is valid.")
                    
                    DispatchQueue.main.async {
                        self.txtFirstName.text = appleIDCredential.fullName?.givenName ?? ""
                        print(appleIDCredential.fullName?.givenName ?? "")
                        self.txtEmail.text = appleIDCredential.email ?? ""
                        self.socialId = appleIDCredential.user
                        
                        if !(appleIDCredential.email ?? "").isEmpty() {
                            preferenceHelper.setSigninWithAppleEmail(appleIDCredential.email ?? "")
                        }
                        
                        if !(appleIDCredential.fullName?.givenName ?? "").isEmpty() {
                            preferenceHelper.setSigninWithAppleUserName((appleIDCredential.fullName?.givenName ?? "") + " " + (appleIDCredential.fullName?.familyName ?? ""))
                        }
                        
                        DispatchQueue.main.async {
                            if !preferenceHelper.getSigninWithAppleEmail().isEmpty() {
                                self.txtEmail.text = preferenceHelper.getSigninWithAppleEmail()
                            }
                            
                            if !preferenceHelper.getSigninWithAppleUserName().isEmpty() {
                                if !preferenceHelper.getSigninWithAppleUserName().components(separatedBy: " ")[0].isEmpty() {
                                    self.txtFirstName.text = preferenceHelper.getSigninWithAppleUserName().components(separatedBy: " ")[0]
                                } else {
                                    self.txtFirstName.text = preferenceHelper.getSigninWithAppleUserName()
                                }
                                
                                if !preferenceHelper.getSigninWithAppleUserName().components(separatedBy: " ")[1].isEmpty() {
                                    self.txtLastName.text = preferenceHelper.getSigninWithAppleUserName().components(separatedBy: " ")[1]
                                }
                            }
                        }
                        
                        self.updateUiForSocialLogin(email: self.txtEmail.text!, socialId: self.socialId, firstName: self.txtFirstName.text!, lastName: appleIDCredential.fullName?.familyName ?? "", profileUri: "", isSigninWithapple: true)
                        
                        if appleIDCredential.email?.contains("privaterelay.appleid.com") ?? false {
                            self.checkValidation()
                        } else {
                            self.checkValidation()
                        }
                    }
                    break
                case .revoked:
                    print("The Apple ID credential is revoked.")
                    break
                case .notFound:
                    print("No credential was found, so show the sign-in UI.")
                    break
                default:
                    break
                }
            }
        } else {
            if let passwordCredential = authorization.credential as? ASPasswordCredential {
                _ = passwordCredential.user
                _ = passwordCredential.password
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("apple signin error = \(error.localizedDescription)")
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
