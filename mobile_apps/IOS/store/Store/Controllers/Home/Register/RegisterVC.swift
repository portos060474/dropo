//
//  RegisterVC.swift
//  Edelivery Store
//
//  Created by Elluminati on 17/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
import Foundation
import FBSDKLoginKit
import GoogleSignIn
import DeviceCheck

class RegisterVC: BaseVC,UITextFieldDelegate,LocationHandlerDelegate {
    //MARK:- Dialogs
    var dialogForImage:CustomPhotoDialog? = nil

    //MARK:- OUTLETS
    @IBOutlet weak var btnFacebook: FBLoginButton!
    @IBOutlet weak var btnGoogle: GIDSignInButton!

    @IBOutlet weak var stkAddress: UIStackView!

    @IBOutlet weak var viewForSocialLogin: UIView!
    @IBOutlet weak var stkSocialLogin: UIStackView!
    @IBOutlet weak var lblOr: UILabel!
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var viewForProfile: UIView!

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var viewForPassword: UIView!
    @IBOutlet weak var btnShowHidePassword: UIButton!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtSelectCountry: UITextField!

    @IBOutlet weak var txtSelectCity: UITextField!
    @IBOutlet weak var txtSelectStoreType: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var btnSelectAddress: UIButton!
    @IBOutlet weak var txtLatitude: UITextField!
    @IBOutlet weak var txtLongitude: UITextField!
    @IBOutlet weak var lblDivider: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var txtSlogan: UITextField!
    @IBOutlet weak var txtWebSite: UITextField!

    @IBOutlet weak var btnSelectPhoto: UIButton!
    @IBOutlet weak var stkReferralView: UIStackView!
    @IBOutlet weak var btnReferral: UIButton!
    @IBOutlet weak var txtReferralCode:UITextField!
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var lblrefferal: CustomPaddingLabel!

    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var stkRegister: UIStackView!

    @IBOutlet weak var cbAccept: UIButton!

    //@IBOutlet weak var btnTermsAndCondition: UIButton!
    @IBOutlet weak var txtvwTermsConditions: UITextView!
    @IBOutlet weak var lblRegisterTitle: UILabel!
    @IBOutlet weak var lblhaveyourStore: UILabel!
    @IBOutlet weak var lblLoginNow: UILabel!
    @IBOutlet weak var imgArrowCity: UIImageView!
    @IBOutlet weak var imgArrowCountry: UIImageView!
    @IBOutlet weak var imgArrowStoreType: UIImageView!

    // MARK: - VARIABLES
    var arrForCountryList : NSMutableArray = NSMutableArray.init()
    var arrForCityList : NSMutableArray = NSMutableArray.init()
    var arrForStoreTypeList : NSMutableArray = NSMutableArray.init()
    
    var strCountryCode:String? = "IN"

    var strCountryId:String? = ""
    var strCityId:String? = ""
    var strStoreTypeId:String? = ""
    
    var strReferralCode:String? = ""
    var isPicAdded:Bool = false
    var socialId:String = ""
    var arrForNames:[String:String] = [:]

    var deviceCheckToken:String = ""
    var signInConfig: GIDConfiguration!

    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalization()
        txtLongitude.isHidden = true
        txtLatitude.isHidden = true
        stkAddress.isUserInteractionEnabled = true
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(self.onClickBtnSelectAddress(_:)))
        stkAddress.addGestureRecognizer(tapGesture)
        btnFacebook.delegate = self
        btnGoogle.style = .standard
        btnGoogle.colorScheme = .light
        btnGoogle.addTarget(self, action: #selector(onClickGoogle), for: .touchUpInside)
        btnFacebook.permissions = ["public_profile", "email"]
        btnFacebook.isHidden = true
        arrForNames.removeAll()
        
        txtMobileNumber.keyboardType = .numberPad

        for language in ConstantsLang.adminLanguages {
            arrForNames[language.languageCode] = ""
        }

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
        wsGetCountries()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        signInConfig = GIDConfiguration.init(clientID:Google.CLIENT_ID)
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
        /*set colors*/
        imgProfilePic.clipsToBounds = true
        self.btnApply.setTitle("TXT_APPLY".localized, for: UIControl.State.normal)
        self.btnApply.setImage(UIImage.init(), for: UIControl.State.normal)
        self.view.backgroundColor = UIColor.themeViewBackgroundColor;

        txtName.textColor = UIColor.themeTextColor
        txtEmail.textColor = UIColor.themeTextColor
        txtPassword.textColor = UIColor.themeTextColor
        txtConfirmPassword.textColor = UIColor.themeTextColor
        txtSelectCountry.textColor = UIColor.themeTextColor
        txtSelectCity.textColor = UIColor.themeTextColor
        txtSelectStoreType.textColor = UIColor.themeTextColor
        txtAddress.textColor = UIColor.themeTextColor
        txtLatitude.textColor = UIColor.themeTextColor
        txtLongitude.textColor = UIColor.themeTextColor
        txtReferralCode.textColor = UIColor.themeTextColor
        txtMobileNumber.textColor = UIColor.themeTextColor
        lblCountryCode.textColor = UIColor.themeTextColor
        txtSlogan.textColor = UIColor.themeTextColor
        txtWebSite.textColor = UIColor.themeTextColor
        lblOr.textColor = UIColor.themeTextColor
        lblrefferal.textColor = UIColor.themeColor

        lblDivider.backgroundColor = UIColor.themeLightTextColor
        lblMobileNumber.textColor = UIColor.themeLightTextColor
        lblRegisterTitle.textColor = UIColor.themeTextColor
        lblRegisterTitle.text = "TXT_REGISTER".localized
        lblRegisterTitle.font = FontHelper.textLarge()

        /*set placeholders*/
        lblOr.text = "TXT_OR".localizedUppercase
        txtName.placeholder = "TXT_NAME".localizedCapitalized
        txtEmail.placeholder = "TXT_EMAIL".localizedCapitalized
        txtPassword.placeholder = "TXT_PASSWORD".localizedCapitalized
        txtConfirmPassword.placeholder = "TXT_CONFIRM_REGISTER_PASSWORD".localizedCapitalized
        txtSelectCountry.placeholder = "TXT_SELECT_COUNTRY".localizedCapitalized
        txtSelectCity.placeholder = "TXT_SELECT_CITY".localizedCapitalized
        txtSelectStoreType.placeholder = "TXT_SELECT_STORE_TYPE".localizedCapitalized
        txtAddress.placeholder = "TXT_ADDRESS".localizedCapitalized
        txtLatitude.placeholder = "TXT_LATITUDE".localizedCapitalized
        txtLongitude.placeholder = "TXT_LONGITUDE".localizedCapitalized
        txtReferralCode.placeholder = "TXT_REFERRAL_CODE".localizedCapitalized
        txtMobileNumber.placeholder = "TXT_MOBILE_NO".localizedCapitalized
        lblMobileNumber.text = "TXT_MOBILE_NO".localizedCapitalized
        lblCountryCode.text = "TXT_DEFAULT".localizedCapitalized
        txtSlogan.placeholder = "TXT_SLOGAN".localizedCapitalized
        txtWebSite.placeholder = "TXT_WEBSITE".localizedCapitalized
        btnRegister.setTitle("TXT_REGISTER".localizedUppercase, for: UIControl.State.normal);
        btnReferral.setTitle("", for: .normal)
        txtReferralCode.placeholder = "MSG_PLEASE_ENTER_REFERRAL_CODE".localizedCapitalized
        lblrefferal.text = "TXT_REFERRAL".localizedUppercase

        self.txtvwTermsConditions.font = FontHelper.labelRegular()
        self.txtvwTermsConditions.text = "TXT_SIGN_UP_PRIVACY".localized + " " + "TXT_TERMS_AND_CONDITIONS".localizedCapitalized + " " + "text_and".localized + " " + "TXT_PRIVACY_POLICIES".localizedCapitalized
        self.configureLinks()

        /*Set Fonts*/
        txtName.font = FontHelper.textRegular()
        txtName.font = FontHelper.textRegular()
        txtEmail.font = FontHelper.textRegular()
        txtPassword.font = FontHelper.textRegular()
        txtConfirmPassword.font = FontHelper.textRegular()
        txtSelectCountry.font = FontHelper.textRegular()
        txtSelectCity.font = FontHelper.textRegular()
        txtSelectStoreType.font = FontHelper.textRegular()
        txtAddress.font = FontHelper.textRegular()
        txtLatitude.font = FontHelper.textRegular()
        txtLongitude.font = FontHelper.textRegular()
        txtReferralCode.font = FontHelper.textRegular()
        txtMobileNumber.font = FontHelper.textRegular()
        lblCountryCode.font = FontHelper.textRegular()
        txtSlogan.font = FontHelper.textRegular()
        txtWebSite.font = FontHelper.textRegular()

        lblOr.font = FontHelper.textMedium()
        lblCountryCode.font = FontHelper.textRegular()
        btnReferral.titleLabel?.font = FontHelper.buttonText()
        txtAddress.isUserInteractionEnabled = false
        txtLatitude.isUserInteractionEnabled = false
        txtLongitude.isUserInteractionEnabled = false
        lblhaveyourStore.textColor = UIColor.themeTextColor
        lblhaveyourStore.text = "TXT_HAVE_YOUR_OWN_STORE".localizedCapitalized
        lblhaveyourStore.font = FontHelper.textSmall()

        lblLoginNow.textColor = UIColor.themeColor
        lblLoginNow.text = "TXT_LOGIN_NOW".localizedCapitalized
        lblLoginNow.font = FontHelper.textSmall()

        updateUIAccordingToTheme()
    }

    func configureLinks() {
        let attributedString:NSMutableAttributedString = NSMutableAttributedString.init(string: self.txtvwTermsConditions.text)
        attributedString.setAttributes([.link:WebService.USER_PANEL_URL + "legal/store-terms-conditions"], range:attributedString.mutableString.range(of:"TXT_TERMS_AND_CONDITIONS".localizedCapitalized, options: .caseInsensitive))
        attributedString.setAttributes([.link:WebService.USER_PANEL_URL + "legal/store-privacy-policy"], range:attributedString.mutableString.range(of:"TXT_PRIVACY_POLICIES".localizedCapitalized, options: .caseInsensitive))
        attributedString.addAttribute(.font, value: FontHelper.labelRegular(), range: attributedString.mutableString.range(of: self.txtvwTermsConditions.text))
        self.txtvwTermsConditions.attributedText = attributedString
        self.txtvwTermsConditions.linkTextAttributes = [
            .foregroundColor: UIColor.themeIconTintColor,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        self.txtvwTermsConditions.textColor = UIColor.themeIconTintColor
    }

    override func updateUIAccordingToTheme() {
        imgArrowCity.image = UIImage.init(named: "dropdown")?.imageWithColor(color: .themeIconTintColor)
        imgArrowCountry.image = UIImage.init(named: "dropdown")?.imageWithColor(color: .themeIconTintColor)
        imgArrowStoreType.image = UIImage.init(named: "dropdown")?.imageWithColor(color: .themeIconTintColor)
        
        btnSelectAddress.setImage(UIImage(named: "location_arrow"), for: .normal)
        cbAccept.setImage(UIImage.init(named: "unchecked"), for: .normal)
        cbAccept.setImage(UIImage.init(named: "checked")?.imageWithColor(color: .themeColor), for: .selected)
    }

    func setupLayout() {}

    func updateUI() {
        if preferenceHelper.getIsShowOptionalFieldInRegister() {
            if self.txtSlogan != nil {
                self.txtSlogan.isHidden = false
                self.txtWebSite.isHidden = false
            }
        } else {
            if self.txtSlogan != nil {
                self.txtSlogan.isHidden = true
            }
            if self.txtWebSite != nil {
                self.txtWebSite.isHidden = true
            }
        }
        if preferenceHelper.getIsReferralOn() && preferenceHelper.getIsReferralInCountry() {
            if self.stkReferralView != nil {
                self.stkReferralView.isHidden = false
                self.btnReferral.isHidden = false
                self.lblrefferal.isHidden = false
            }
        } else {
            if self.stkReferralView != nil {
                self.stkReferralView.isHidden = true
                self.btnReferral.isHidden = true
                self.lblrefferal.isHidden = true
            }
        }
    }

    //MARK: - TEXTFIELD DELEGATE METHODS
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtSelectCountry {
            self.view.endEditing(true)
            let dialogForCountry = CustomTableDialog.showCustomTableDialog(withDataSource: arrForCountryList, cellIdentifier: CustomCellIdentifiers.cellForCountry, title: "TXT_SELECT_COUNTRY".localized)
            dialogForCountry.onItemSelected = { [unowned self, unowned dialogForCountry] (selectedItem:Any) in
                let country = selectedItem as! Country
                if self.strCountryId?.compare(country.id!) == ComparisonResult.orderedSame
                {} else {
                    self.txtSelectCity.text = ""
                    self.txtSelectStoreType.text = ""
                    
                    self.txtSelectCountry.text = country.countryName!
                    self.lblCountryCode.text = country.countryPhoneCode!
                    self.strCountryId = country.id!
                    self.strCountryCode = country.countryCode
                    self.txtMobileNumber.text = ""
                    preferenceHelper.setIsReferralInCountry(country.isReferralStore!)
                    self.updateUI()
                    self.wsGetCities()
                }
                dialogForCountry.removeFromSuperview()
            }
            return false
        } else if textField == txtSelectCity {
            self.view.endEditing(true)
            if self.arrForCityList.count > 0 {
                let  dialogForCity =  CustomTableDialog.showCustomTableDialog(withDataSource: arrForCityList, cellIdentifier: CustomCellIdentifiers.cellForCity,title: "TXT_SELECT_CITY".localized)
                dialogForCity.onItemSelected = { [unowned self, unowned dialogForCity] (selectedItem:Any) in
                    let city = selectedItem as! City
                    if self.strCityId?.compare(city.id) == ComparisonResult.orderedSame
                    {} else {
                        self.txtSelectStoreType.text = ""
                        self.strCityId = city.id
                        self.txtSelectCity.text = city.cityName
                        dialogForCity.removeFromSuperview();
                        self.wsGetStoreTypeList()
                    }
                }
            } else {
                Utility.showToast(message: "TXT_NO_CITY_FOUND_IN_SELECTED_COUNTRY".localized)
            }
            return false
        } else if textField == txtSelectStoreType {
            self.view.endEditing(true)
            if self.arrForStoreTypeList.count > 0 {
                let dialogForStoreType = CustomTableDialog.showCustomTableDialog(withDataSource: arrForStoreTypeList, cellIdentifier: CustomCellIdentifiers.cellForStoreType,title: "TXT_SELECT_STORE_TYPE".localized)
                dialogForStoreType.onItemSelected = { [unowned self, unowned dialogForStoreType] (selectedItem:Any) in
                    let delivery = selectedItem as! Delivery
                    self.strStoreTypeId = delivery.id
                    self.txtSelectStoreType.text = delivery.deliveryName
                    
                    //janki
                    //self.strStoreTypeId = "5e81b57e5a70781c5b5bc682"
                    //                        self.txtSelectStoreType.text = "Food"
                    
                    dialogForStoreType.removeFromSuperview();
                }
            } else {
                Utility.showToast(message: "TXT_NO_STORE_TYPE_FOUND_IN_SELECTED_CITY".localized)
            }
            return false
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtReferralCode {
            txtReferralCode.resignFirstResponder();
        }
        if textField == txtName {
            txtEmail.becomeFirstResponder()
        }else if textField == txtEmail {
            txtPassword.becomeFirstResponder()
        }else if textField == txtPassword {
            txtAddress.becomeFirstResponder()
        }else if textField == txtAddress {
            txtLatitude.becomeFirstResponder()
        }else if textField == txtLatitude {
            txtLongitude.becomeFirstResponder()
        }else if textField == txtLongitude {
            txtMobileNumber.becomeFirstResponder()
        }else if textField == txtMobileNumber {
            if txtSlogan.isHidden {
                txtReferralCode.becomeFirstResponder()
            }else {
                txtSlogan.becomeFirstResponder()
            }
        }else if textField == txtSlogan {
            txtWebSite.becomeFirstResponder()
        }else if textField == txtWebSite {
            txtReferralCode.becomeFirstResponder()
        }else if textField == txtReferralCode {
            txtReferralCode.resignFirstResponder()
        }else {
            return true
        }
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtMobileNumber {
            //Prevent "0" characters as the first characters.
            if textField.text?.count == 0 && string == "0" {
                   return false
            }

            if (string == "") || string.count < 1 {
                return true
            } else if (textField.text?.count)! >= preferenceHelper.getMaxMobileLength() {
                return false
            }
        } else if textField ==  txtLatitude || textField == txtLongitude {
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let decimalRegex = try! NSRegularExpression(pattern: "^\\d*\\.?\\d{0,7}$", options: [])
            let matches = decimalRegex.matches(in: newString, options: [], range: NSMakeRange(0, newString.count))
            if matches.count == 1 {
                return true
            }
            return false
        }
        return true;
    }

    func textFieldDidEndEditing(_ textField: UITextField) {}

    func openLocalizedLanguagDialog() {
        self.view.endEditing(true)
        let dialogForLocalizedLanguage = CustomActiveLanguageDialog.showCustomLanguageDialog(languages: arrForNames, title: txtName.placeholder ?? "")
        dialogForLocalizedLanguage.onItemSelected = { (selectedArray) in
            self.arrForNames = selectedArray
            self.txtName.text = self.arrForNames[selectedLanguage]
            dialogForLocalizedLanguage.removeFromSuperview()
        }
    }

    //MARK: - ACTION METHODS
    @IBAction func onClickReferral(_ sender: UIButton) {}

    @IBAction func editImageButtonClicked(_ sender: UIButton) {
        dialogForImage = CustomPhotoDialog.showPhotoDialog("TXT_SELECT_IMAGE".localized, andParent: self)
        dialogForImage?.onImageSelected = {[unowned self, weak dialogForImage = self.dialogForImage]
            (image:UIImage) in
            self.imgProfilePic.image = image
            self.isPicAdded = true
        }
    }

    @IBAction func onClickBtnRegister(_ sender: Any) {
        checkValidation()
    }

    @IBAction func onClickBtnCheckbox(_ sender: Any) {
        if cbAccept.isSelected {
            cbAccept.isSelected = false
        } else {
            cbAccept.isSelected = true
        }
    }

    @IBAction func onClickBtnTermsAndConditions(_ sender: Any) {
        /*guard let url = URL(string: preferenceHelper.getTermsAndCondition()) else {
            return //be safe
        }*/

        guard let url = URL(string: WebService.USER_PANEL_URL + "legal/store-terms-conditions") else {
            return //be safe
        }

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }

    @IBAction func onClickBtnApplyPromo(_ sender: Any) {
        if ((txtReferralCode.text?.count)! <  1) {
            Utility.showToast(message: "MSG_PLEASE_ENTER_REFERRAL_CODE".localized)
        } else {
            wsCheckIsReferralValid()
        }
    }

    @IBAction func onClickBtnSelectAddress(_ sender: UIButton) {
        if (txtSelectCity.text?.isEmpty())! {
            Utility.showToast(message:"MSG_PLEASE_SELECT_CITY".localized)
        } else {
            let locationVC : StoreLocationVC = storyboard?.instantiateViewController(withIdentifier: "storeLocationVC") as! StoreLocationVC
            locationVC.delegate = self
            locationVC.comingFrom = SourceVC.REGISTER_VC
            locationVC.strCityID = strCityId!
            self.navigationController?.pushViewController(locationVC, animated: true)
        }
    }

    func finalAddressAndLocation(address: String, latitude: Double, longitude: Double) {
        self.txtAddress.text = address
        self.txtLatitude.text = String(latitude)
        self.txtLongitude.text = String(longitude)
    }

    @IBAction func onClickBtnTwitterLogin(_ sender: Any) {
        self.socialId = ""
        getTwitterData()
    }

    @objc func onClickGoogle() {
        self.socialId = ""
        GIDSignIn.sharedInstance.signOut()
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, err in
            if err == nil{
                let img = user?.profile?.imageURL(withDimension: 0)?.absoluteString
                let userId = user?.userID
                let name = user?.profile?.givenName
                let email = user?.profile?.email
                self.updateUiForSocialLogin(email: email ?? "", socialId: userId ?? "", firstName: name ?? "", lastName: "", profileUri:img ?? "")
            }
        }
    }

    @IBAction func onClickBtnGoogleLogin(_ sender: Any) {}

    @IBAction func onClickBtnFacebook(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(permissions: [.publicProfile], viewController: self) { (loginResult) in
            switch loginResult {
            case .failed(let error):
                Log.e(error)
            case .cancelled:
                Log.i("User cancelled login.")
            case .success( _, _, _):
                Utility.showLoading()
                self.getFBUserData()
            }
        }
    }

    //function is fetching the user data
    func getFBUserData() {
        if AccessToken.current != nil {
            let GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start {connection,result,error in
                Utility.hideLoading()
                if (error == nil) {
                    let dict = result as! [String : AnyObject]
                    let email:String = (dict["email"] as? String) ?? ""
                    Profile.loadCurrentProfile {[unowned self] (profile, err) in
                        if err == nil {
                            self.socialId = (profile?.userID)!
                            self.updateUiForSocialLogin(email: email, socialId: self.socialId, firstName: (profile?.firstName)!, lastName: (profile?.lastName)!, profileUri: (profile?.imageURL(forMode: .normal, size: self.imgProfilePic.frame.size)?.absoluteString)!)
                        } else {
                            Utility.showToast(message: (err?.localizedDescription)!)
                        }
                    }
                }
            }
        }
    }

    func getTwitterData() {}
 
    //MARK: - WEB SERVICE CALLS
    func wsGetCountries() {
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_GET_COUNTRY_LIST, methodName: AlamofireHelper.GET_METHOD, paramData: Dictionary.init()) { (response, error) -> (Void) in
            Parser.parseCountries(response, toArray: self.arrForCountryList, completion: { result in
                if result {
                    let locationManager = LocationManager();
                    locationManager.currentAddressLocation(blockCompletion:
                        {
                            (myAddress, error) in
                            let item = (myAddress?.country) ?? ""
                            let country:Country =  self.arrForCountryList[0] as! Country
                            var isCountryMatch:Bool = false
                            
                            for country in self.arrForCountryList
                            {
                                let country = country as! Country
                                if country.countryName?.compare(item) == ComparisonResult.orderedSame
                                {
                                    self.strCountryId =  country.id
                                    
                                    if self.txtSelectCountry != nil {
                                        self.txtSelectCountry.text = country.countryName!
                                    }

                                    if self.lblCountryCode != nil {
                                        self.lblCountryCode.text = country.countryPhoneCode!
                                    }

                                    preferenceHelper.setIsReferralInCountry(country.isReferralStore!)
                                    self.updateUI()
                                    self.wsGetCities()
                                    isCountryMatch = true
                                    break;
                                }
                            }
                            if !isCountryMatch
                            {
                                self.strCountryId =  country.id
                                if self.txtSelectCountry != nil{
                                    self.txtSelectCountry.text = country.countryName
                                    self.lblCountryCode.text = country.countryPhoneCode!
                                }
                                
                                self.updateUI()
                                self.wsGetCities()
                            }
                    })
                }
                Utility.hideLoading()
            })
        }
    }
    
    func wsGetStoreTypeList() -> Void{
        let almofireObj = AlamofireHelper.init()
        let dictParam : [String : String] =
            [PARAMS.CITY_ID     : strCityId ?? ""]

        txtSelectStoreType.text = ""

        print(dictParam)
        Utility.showLoading()
        almofireObj.getResponseFromURL(url: WebService.WS_GET_NEAREST_DELIVERY_LIST, methodName:AlamofireHelper.POST_METHOD , paramData: dictParam) { (response, error) -> (Void) in
            print("WS_GET_NEAREST_DELIVERY_LIST \(response)")
            Parser.parseStoreTypes(response, toArray: self.arrForStoreTypeList, completion: {
                result in
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
        let currentAppVersion: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)
        var dictParam : [String : String] =
            [
                PARAMS.STORE_DELIVERY_ID:strStoreTypeId!,
                PARAMS.NAME : txtName.text! ,
                PARAMS.EMAIL      : txtEmail.text!  ,
                PARAMS.PASS_WORD  : txtPassword.text!  ,
                PARAMS.COUNTRY_PHONE_CODE  :lblCountryCode.text ?? ""  ,
                PARAMS.PHONE : txtMobileNumber.text! ,
                PARAMS.ADDRESS  : txtAddress.text ?? "",
                PARAMS.COUNTRY_ID  : strCountryId!,
                PARAMS.CITY_ID  : strCityId!,
                PARAMS.DEVICE_TYPE: CONSTANT.IOS,
                PARAMS.DEVICE_TOKEN:preferenceHelper.getDeviceToken(),
                PARAMS.REFERRAL_CODE:strReferralCode ??  "",
                PARAMS.IS_EMAIL_VERIFIED:String(preferenceHelper.getIsEmailVerified()),
                PARAMS.IS_PHONE_NUMBER_VERIFIED:String(preferenceHelper.getIsPhoneNumberVerified()),
                PARAMS.APP_VERSION: currentAppVersion,
                PARAMS.SLOGAN: txtSlogan.text ?? "",
                PARAMS.WEBSITE_URL: txtWebSite.text ?? "",
                PARAMS.LATITUDE: txtLatitude.text!,
                PARAMS.LONGITUDE: txtLongitude.text!,
                PARAMS.LOGIN_BY: CONSTANT.MANUAL,
                PARAMS.SOCIAL_ID: "",
                PARAMS.CAPTCHA_TOKEN: self.deviceCheckToken
        ]
        if !socialId.isEmpty() {
            dictParam.updateValue(socialId, forKey: PARAMS.SOCIAL_ID)
            dictParam.updateValue("", forKey: PARAMS.PASS_WORD)
            dictParam.updateValue(CONSTANT.SOCIAL, forKey: PARAMS.LOGIN_BY)
        }
        print(Utility.conteverDictToJson(dict: dictParam))

        let alamoFire:AlamofireHelper = AlamofireHelper();
        if isPicAdded {
            alamoFire.getResponseFromURL(url: WebService.WS_STORE_REGISTER, paramData: dictParam, image: imgProfilePic.image!, block: { (response, error) -> (Void) in
                print(response)
                Parser.parseUserStorageData(response: response, completion: { result in
                    if result {
                        APPDELEGATE.clearOrderNotificationEntity()
                        APPDELEGATE.clearMassNotificationEntity()
                        APPDELEGATE.goToMain()
                    }
                })
            })
        } else {
            alamoFire.getResponseFromURL(url: WebService.WS_STORE_REGISTER, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
                Utility.hideLoading()
                print(response)
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

    func wsGenerateOtp(_ dictParam:[String:Any]) {
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_GENERATE_OTP, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            if Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true) {
                let otpResponse:OtpResponse = OtpResponse.init(fromDictionary: response)
                Log.i(otpResponse)
                switch (self.checkWhichOtpValidationON()) {
                case CONSTANT.SMS_AND_EMAIL_VERIFICATION_ON:
                    self.openOTPVerifyDialog(otpEmailVerification: otpResponse.otpForEmail ?? "", otpSmsVerification: otpResponse.otpForSms ?? "", editTextOneHint:"TXT_EMAIL_OTP".localized, ediTextTwoHint: "TXT_PHONE_OTP".localized, isEditTextTwoIsHidden: false, otp_id: otpResponse.otpID, params:dictParam)
                    break;
                case CONSTANT.SMS_VERIFICATION_ON:
                    self.openOTPVerifyDialog(otpEmailVerification: otpResponse.otpForEmail ?? "", otpSmsVerification: otpResponse.otpForSms ?? "", editTextOneHint:"TXT_PHONE_OTP".localized, ediTextTwoHint: "TXT_PHONE_OTP".localized, isEditTextTwoIsHidden: true, otp_id: otpResponse.otpID, params:dictParam)
                    break;
                case CONSTANT.EMAIL_VERIFICATION_ON:
                    self.openOTPVerifyDialog(otpEmailVerification: otpResponse.otpForEmail ?? "", otpSmsVerification: otpResponse.otpForSms ?? "", editTextOneHint:"TXT_EMAIL_OTP".localized, ediTextTwoHint: "TXT_PHONE_OTP".localized, isEditTextTwoIsHidden: true, otp_id: otpResponse.otpID, params:dictParam)
                    break;
                default:
                    break;
                }
            }
        }
    }

    func wsGetOtpVerify(otpID:String,emailOTP:String,smsOtp:String,dialogForVerification:CustomVerificationDialog) {
        let dictParam : [String : Any] =
            [PARAMS.OTP_ID:otpID,
             PARAMS.EMAIL_OTP : emailOTP,
             PARAMS.SMS_OTP:smsOtp]

        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_OTP_VERFICATION, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            if Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true) {
                //                    let otpResponse:OtpResponse = OtpResponse.init(fromDictionary: response)
                preferenceHelper.setIsEmailVerified(true)
                preferenceHelper.setIsPhoneNumberVerified(true)
                dialogForVerification.removeFromSuperview()
                self.getDeviceCheckTokenData()
            }
        }
    }

    func wsCheckIsReferralValid() {
        Utility.showLoading()
        let dictParam : [String : Any] =
            [PARAMS.REFERRAL_CODE:txtReferralCode.text!,
             PARAMS.TYPE : CONSTANT.TYPE_STORE,
             PARAMS.COUNTRY_ID:strCountryId ?? ""]

        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_CHECK_REFERRAL, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true) {
                self.strReferralCode = self.txtReferralCode.text;
                DispatchQueue.main.async {
                    self.txtReferralCode.isUserInteractionEnabled = false;
                    self.btnApply.isUserInteractionEnabled = false
                    self.btnApply.setImage(UIImage.init(named: "selected_icon"), for: UIControl.State.normal)
                    self.btnApply.backgroundColor = .clear
                    self.btnApply.setTitle("", for: UIControl.State.normal)
                }
            } else {
                DispatchQueue.main.async {
                    self.strReferralCode = ""
                    self.txtReferralCode.isUserInteractionEnabled = true;
                    self.btnApply.isUserInteractionEnabled = true
                    self.txtReferralCode.text = "";
                    self.btnApply.setImage(UIImage.init(named: ""), for: UIControl.State.normal)
                    self.btnApply.setTitle("TXT_APPLY".localized, for: UIControl.State.normal)
                    self.btnApply.backgroundColor = .themeColor
                  //  self.btnApply.setImage(UIImage.init(named: ""), for: UIControl.State.normal)
                  //  self.btnApply.setTitle("TXT_APPLY".localized, for: UIControl.State.normal)
                }
            }
        }
    }

    //MARK: - USER DEIFNE METHODS
    func checkValidation() -> Void {
        let validPassword = txtPassword.text!.checkPasswordValidation()
        let validPhoneNo = txtMobileNumber.text!.isValidMobileNumber()
        let validEmail = txtEmail.text!.checkEmailValidation()
        if (
            (txtName.text?.isEmpty())! ||
                (txtEmail.text?.isEmpty())! ||
                ((txtPassword.text?.count)!  < 1 && socialId.isEmpty() ) ||
                (txtSelectCountry.text?.isEmpty())! ||
                (txtSelectCity.text?.isEmpty())! ||
                (txtSelectStoreType.text?.isEmpty())! ||
                (txtMobileNumber.text?.isEmpty())! ||
                (txtAddress.text?.isEmpty())! ||
                (txtLatitude.text?.isEmpty())! ||
                (txtLongitude.text?.isEmpty())! ||
                !cbAccept.isSelected
            ) {
            if !cbAccept.isSelected {
                Utility.showToast(message:"MSG_PLEASE_ACCEPT_TERMS_AND_CONDITION_FIRST".localized)
            }else if (txtName.text?.isEmpty())! {
                txtName.becomeFirstResponder();
                Utility.showToast(message:"MSG_PLEASE_ENTER_VALID_NAME".localized)
            }else if (txtEmail.text?.isEmpty())! {
                txtEmail.becomeFirstResponder();
                Utility.showToast(message:"MSG_PLEASE_ENTER_EMAIL".localized)
            }else if  ((txtPassword.text?.count)!  < 1 && socialId.isEmpty() ) {
                txtPassword.becomeFirstResponder();
                Utility.showToast(message:"MSG_PLEASE_ENTER_PASSWORD".localized)
            }else if (txtSelectCountry.text?.isEmpty())! {
                txtSelectCountry.becomeFirstResponder();
                Utility.showToast(message:"MSG_PLEASE_SELECT_COUNTRY".localized)
            }else if (txtSelectCity.text?.isEmpty())! {
                txtSelectCity.becomeFirstResponder();
                Utility.showToast(message:"MSG_PLEASE_SELECT_CITY".localized)
            }else if (txtSelectStoreType.text?.isEmpty())! {
                txtSelectStoreType.becomeFirstResponder();
                Utility.showToast(message:"MSG_PLEASE_SELECT_STORE_TYPE".localized)
            }else if ((txtMobileNumber.text?.trimmingCharacters(in: .whitespaces).count)! <  1) {
                txtMobileNumber.becomeFirstResponder();
                Utility.showToast(message:"MSG_PLEASE_ENTER_MOBILE_NUMBER".localized)
            }else if (txtAddress.text?.isEmpty())! {
                txtAddress.becomeFirstResponder();
                Utility.showToast(message:"MSG_PLEASE_ENTER_ADDRESS".localized)
            }else if (txtLatitude.text?.isEmpty())! {
                txtAddress.becomeFirstResponder();
                Utility.showToast(message:"MSG_PLEASE_ENTER_ADDRESS".localized)
            }else if (txtLongitude.text?.isEmpty())! {
                txtAddress.becomeFirstResponder();
                Utility.showToast(message:"MSG_PLEASE_ENTER_ADDRESS".localized)
            }else {
                Utility.showToast(message:"MSG_SOMETHING_MISSED".localized)
            }
        } else {
            if(validEmail.0 == false) {
                txtEmail.becomeFirstResponder();
                Utility.showToast(message:validEmail.1)
            } else if validPassword.0 == false {
                txtPassword.becomeFirstResponder();
               
                Utility.showToast(message:validPassword.1)
            } else if validPhoneNo.0 == false {
                txtMobileNumber.becomeFirstResponder();
                Utility.showToast(message:validPhoneNo.1)                
            } else {
                var dictParam : [String : Any] =
                    [PARAMS.TYPE : CONSTANT.TYPE_STORE]
                
                switch (self.checkWhichOtpValidationON()) {
                    
                case CONSTANT.SMS_AND_EMAIL_VERIFICATION_ON:
                    preferenceHelper.setTempEmail(self.txtEmail.text!)
                    preferenceHelper.setTempPhoneNumber(txtMobileNumber.text!)
                    
                    dictParam.updateValue(txtEmail.text!, forKey: PARAMS.EMAIL)
                    dictParam.updateValue(txtMobileNumber.text!, forKey: PARAMS.PHONE)
                    dictParam.updateValue(lblCountryCode.text!, forKey: PARAMS.COUNTRY_PHONE_CODE)
                    self.wsGenerateOtp(dictParam)
                    
                    break;
                    
                case CONSTANT.SMS_VERIFICATION_ON:
                    
                    dictParam.updateValue(self.txtMobileNumber.text!, forKey: PARAMS.PHONE)
                    dictParam.updateValue(preferenceHelper.getPhoneCountryCode(), forKey: PARAMS.COUNTRY_PHONE_CODE)
                    preferenceHelper.setTempPhoneNumber(self.txtMobileNumber.text!)
                    self.wsGenerateOtp(dictParam)
                    
                    break;
                    
                case CONSTANT.EMAIL_VERIFICATION_ON:
                    if validEmail.0 == true {
                        preferenceHelper.setTempEmail(self.txtEmail.text!)
                        dictParam.updateValue(self.txtEmail.text!, forKey: PARAMS.EMAIL)
                        self.wsGenerateOtp(dictParam)
                    } else {
                        Utility.showToast(message: "MSG_PLEASE_ENTER_VALID_EMAIL".localized);
                    }
                    break;
                default:
                    self.getDeviceCheckTokenData()
                }
            }
        }
    }

    func updateUiForSocialLogin(email:String = "",
                                socialId:String = "",
                                firstName:String = "",
                                lastName:String = "",
                                profileUri:String = "") {
        if (!email.isEmpty()) {
            txtEmail.text = email
            txtEmail.isEnabled = false
            preferenceHelper.setIsEmailVerified(true)
        }
        self.socialId = socialId;
        txtName.text = firstName + " " + lastName
        txtPassword.isHidden = true;
        btnShowHidePassword.isHidden = true;
        viewForPassword.isHidden = true;
        GIDSignIn.sharedInstance.signOut()
        LoginManager.init().logOut()
        if (!profileUri.isEmpty()) {
            imgProfilePic.downloadedFrom(link: profileUri,isAppendBaseUrl: false)
            isPicAdded = true
        }
    }

    func getDeviceCheckTokenData() {
        if UIDevice.modelName.contains("Simulator") {
            self.wsRegister()
        } else {
            let currentDevice = DCDevice.current
            if currentDevice.isSupported {
                currentDevice.generateToken(completionHandler: { (data, error) in
                    if let tokenData = data {
                        print("Token: \(tokenData.base64EncodedString())")
                        DispatchQueue.main.async {
                            self.deviceCheckToken = "\(tokenData.base64EncodedString())"
                            self.wsRegister()
                        }
                    } else {
                        print("Error: \(error?.localizedDescription ?? "")")
                        Utility.showToast(message: "MSG_DEVICE_AUTHENTICATION_FAILED".localized)
                    }
                })
            } else {
                Utility.showToast(message: "MSG_UNSUPPORTED_DEVICE".localized)
            }
        }
    }

    @IBAction func onClickBtnLogin(_ sender: Any) {
        for i in 0...(self.navigationController?.viewControllers.count)!-1{
            if self.navigationController!.viewControllers[i].isKind(of: LoginVC.self){
                self.navigationController?.popToViewController(self.navigationController!.viewControllers[i], animated: true)
                return
            }
        }

        let mainView : UIStoryboard = UIStoryboard(name: "Prelogin", bundle: nil)
        let vc : LoginVC = mainView.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(vc, animated: true)
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

    //MARK: - Dialogs
    func openOTPVerifyDialog(otpEmailVerification:String, otpSmsVerification:String,editTextOneHint:String, ediTextTwoHint:String, isEditTextTwoIsHidden:Bool, otp_id:String, params:[String:Any]) {
        let dialogForVerification = CustomVerificationDialog.showCustomVerificationDialog(title: "TXT_VERIFY_ACCOUNT".localizedCapitalized, message: "MSG_VERIFY_DETAIL".localizedCapitalized, titleLeftButton: "TXT_CANCEL".localizedUppercase, titleRightButton: "TXT_OK".localizedUppercase, editTextOneHint: editTextOneHint, editTextTwoHint:ediTextTwoHint, isEdiTextTwoIsHidden: isEditTextTwoIsHidden, isForVerifyOtp: true, params: params)
        dialogForVerification.startTimer()
        dialogForVerification.onClickRightButton = { [unowned dialogForVerification, unowned self] (text1:String, text2:String) in
            switch (self.checkWhichOtpValidationON()) {
            case CONSTANT.SMS_AND_EMAIL_VERIFICATION_ON:
                self.wsGetOtpVerify(otpID: otp_id, emailOTP: text1, smsOtp: text2,dialogForVerification: dialogForVerification)
                break;
            case CONSTANT.SMS_VERIFICATION_ON:
                if (text1.compare(otpSmsVerification) == ComparisonResult.orderedSame) && text1.count > 0{
                    preferenceHelper.setIsPhoneNumberVerified(true)
                    dialogForVerification.removeFromSuperview()
                    self.getDeviceCheckTokenData()
                } else {
                    Utility.showToast(message: "MSG_SMS_OTP_WRONG".localized)
                }
                break;
            case CONSTANT.EMAIL_VERIFICATION_ON:
                if (text1.compare(otpEmailVerification) == ComparisonResult.orderedSame) && text1.count > 0 {
                    preferenceHelper.setIsEmailVerified(true)
                    dialogForVerification.removeFromSuperview()
                    self.getDeviceCheckTokenData()
                } else {
                    Utility.showToast(message: "MSG_EMAIL_OTP_WRONG".localized)
                }
                break;
            default:
                break;
            }
        }
        dialogForVerification.onClickLeftButton = {
            [unowned dialogForVerification, unowned self] in
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

    func checkEmailVerification() -> Bool{
        return preferenceHelper.getIsEmailVerification() && !preferenceHelper.getIsEmailVerified()
    }

    func checkPhoneNumberVerification() -> Bool{
        return preferenceHelper.getIsPhoneNumberVerification() && !preferenceHelper.getIsPhoneNumberVerified();
    }

    //MARK: - GOOGLE SIGN METHOD
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }

    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {} else {
            Log.e("\(error.localizedDescription)")
        }
    }
}

extension RegisterVC:LoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {}

    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        self.socialId = ""
        if error != nil {
        } else {
            if result?.isCancelled ?? true {
                Log.e(error)
            } else {
                Utility.showLoading()
                self.getFBUserData()
            }
        }
    }

    func setupTwitterButton() {}
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
