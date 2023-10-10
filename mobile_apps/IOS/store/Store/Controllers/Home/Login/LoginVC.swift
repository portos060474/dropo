//
//  LoginVC.swift
// Edelivery Store
//
//  Created by Jaydeep Vyas on 17/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import DeviceCheck
import GoogleSignIn
import FirebaseAnalytics
import FirebaseMessaging

class LoginVC: BaseVC,UITextFieldDelegate {

    //MARK: - Outlets
    @IBOutlet weak var lblOr: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var scrLogin: UIScrollView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var viewForPassword: UIView!
    @IBOutlet weak var btnShowHidePassword: UIButton!
    @IBOutlet weak var btnForgetPasssword: UIButton!
    @IBOutlet weak var socialStackView: UIStackView!
    @IBOutlet weak var btnFacebook: FBLoginButton!

    @IBOutlet weak var lblStoreTitle: UILabel!
    @IBOutlet weak var lblSubStoreTitle: UILabel!
    
    @IBOutlet weak var viewForLanguage: UIView!
    /*View For Language Notification*/
    //    @IBOutlet weak var lblLanguageTitle: UILabel!
    @IBOutlet weak var lblLanguageMessage: UILabel!
    @IBOutlet weak var lblLanguageTitle: UILabel!

    @IBOutlet weak var btnGoogle: GIDSignInButton!
    @IBOutlet weak var lblSelectedStorNamee: UILabel!
    
    @IBOutlet weak var btnDropdown: UIButton!
    @IBOutlet weak var viewForDropDownTitle: UIView!
    
    @IBOutlet weak var viewForSocialLogin: UIView!
    @IBOutlet weak var viewForDropDown: UIView!
    @IBOutlet weak var heightForDropDown: NSLayoutConstraint!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var lblDonthaveyourStore: UILabel!
    @IBOutlet weak var lblRegisterNow: UILabel!
    @IBOutlet weak var lblLoginTitle: UILabel!
    @IBOutlet weak var txtStoreType: CustomTextfield!
    @IBOutlet weak var imgDownarrowLang: UIImageView!
    @IBOutlet weak var imgDownarrowStoretype: UIImageView!

    var deviceCheckToken:String = ""
    var socialId:String = ""
    var signInConfig: GIDConfiguration!

    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalization()
        
        btnGoogle.style = .standard
        btnGoogle.addTarget(self, action: #selector(onClickGoogle), for: .touchUpInside)
        btnGoogle.colorScheme = .light

        btnFacebook.delegate = self
        btnFacebook.permissions = ["public_profile", "email"]
        //        self.setupTwitterButton()
        if preferenceHelper.getIsSocialLoginEnable() {
            viewForSocialLogin.isHidden = false
            lblOr.isHidden = false
            btnFacebook.isHidden = true
            if UIApplication.isRTL() {
                //btnFacebook.contentHorizontalAlignment = .left
                //btnGoogle.contentHorizontalAlignment = .right
            }
        } else {
            viewForSocialLogin.isHidden = true
            lblOr.isHidden = true
        }
        
       // viewForSocialLogin.isHidden = true
        
        //        lblLanguageMessage.text = "\("TXT_LANGUAGE".localized) \(LocalizeLanguage.currentAppleLanguageFull())"
        
        lblLanguageTitle.text = "TXT_LANGUAGE".localized
        lblLanguageMessage.text = LocalizeLanguage.currentAppleLanguageFull()

        viewForDropDown.isHidden = true
        lblSubStoreTitle.text = "TXT_SUB_STORE".localized
        lblStoreTitle.text = "TXT_STORE".localizedCapitalized
        self.txtStoreType.placeholder = "TXT_LOGIN_AS".localized
        if preferenceHelper.getIsSubStoreLogin() {
            lblSelectedStorNamee.text = "TXT_SUB_STORE".localized
            self.txtStoreType.text = "TXT_SUB_STORE".localized
        } else {
            lblSelectedStorNamee.text = "TXT_STORE".localizedCapitalized
            self.txtStoreType.text = "TXT_STORE".localizedCapitalized
        }
        viewForDropDown.backgroundColor = UIColor.white
        viewForDropDown.setShadow(shadowColor: UIColor.black.cgColor, shadowOffset: CGSize.init(width: 2.0, height: 2.0), shadowOpacity: 5.0, shadowRadius: 2.0)
        self.heightForDropDown.constant = 70
        
        if Bundle.main.bundleIdentifier == "com.elluminati.edelivery.store" {
            addTapOnVersion()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        signInConfig = GIDConfiguration.init(clientID:Google.CLIENT_ID)
    }

    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
    }

    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        setupLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
    }

    override func viewDidDisappear(_ animated: Bool){
        super.viewDidDisappear(animated)
    }

    func setLocalization() {
        /*set colors*/
        self.view.backgroundColor = UIColor.themeViewBackgroundColor;
        txtEmail.textColor = UIColor.themeTextColor;
        txtPassword.textColor = UIColor.themeTextColor;
        btnForgetPasssword.setTitleColor(UIColor.themeColor, for: UIControl.State.normal)
        lblOr.textColor = UIColor.themeTextColor
        
        
        /* Set localization */
        lblOr.text = "TXT_OR".localizedUppercase
        btnForgetPasssword.setTitle("TXT_FORGOT_PASSWORD".localizedCapitalized, for: UIControl.State.normal)
        btnLogin.setTitle( "TXT_LOGIN".localizedUppercase, for: UIControl.State.normal)
        //        btnLogin.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        //        btnLogin.backgroundColor = UIColor.themeButtonBackgroundColor
        txtPassword.placeholder = "TXT_PASSWORD".localized
        
        /*Set Font*/
        txtEmail.font = FontHelper.textRegular()
        txtPassword.font = FontHelper.textRegular()
        txtStoreType.font = FontHelper.textRegular()
        
        btnForgetPasssword.titleLabel?.font = FontHelper.textSmall()
        //        btnLogin.titleLabel?.font = FontHelper.buttonText()
        lblOr.font = FontHelper.textMedium()
        
        lblLanguageTitle.textColor = UIColor.themeLightTextColor
        lblLanguageMessage.textColor = UIColor.themeTextColor
        lblLanguageTitle.font = FontHelper.textSmall(size: FontHelper.regular)
        lblLanguageMessage.font = FontHelper.textMedium(size: FontHelper.regular)
        
        //        lblLanguageTitle.textColor = UIColor.themeTextColor
        //        lblLanguageTitle.text = "TXT_LANGUAGE".localized
        //        lblLanguageTitle.font = FontHelper.textSmall()
        
        lblLoginTitle.textColor = UIColor.themeTextColor
        lblLoginTitle.text = "TXT_LOGIN".localized
        lblLoginTitle.font = FontHelper.textLarge()
        
        lblDonthaveyourStore.textColor = UIColor.themeTextColor
        lblDonthaveyourStore.text = "TXT_DONT_HAVE_YOUR_STORE".localizedCapitalized
        lblDonthaveyourStore.font = FontHelper.textSmall()
        
        lblRegisterNow.textColor = UIColor.themeColor
        lblRegisterNow.text = "TXT_REGISTER_NOW".localizedCapitalized
        lblRegisterNow.font = FontHelper.textSmall()
        updateUIAccordingToTheme()
        enabledLoginBy()
    }

    override func updateUIAccordingToTheme() {
        imgDownarrowLang.image = UIImage.init(named: "dropdown")?.imageWithColor(color: .themeIconTintColor)!
        imgDownarrowStoretype.image = UIImage.init(named: "dropdown")?.imageWithColor(color: .themeIconTintColor)!
    }

    func setupLayout() {}
    
    func addTapOnVersion() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onClickVersionTap(_:)))
        tap.numberOfTapsRequired = 3
        self.lblLoginTitle.addGestureRecognizer(tap)
        self.lblLoginTitle.isUserInteractionEnabled = true
    }
    
    @objc func onClickVersionTap(_ sender: UITapGestureRecognizer) {
        let dialog = DialogForApplicationMode.showCustomAppModeDialog()
        
        dialog.onClickLeftButton = { [unowned dialog] in
            dialog.removeFromSuperview()
        }
        
        dialog.onClickRightButton = { [unowned dialog] in
            dialog.removeFromSuperview()
        }
    }

    //MARK: - TextField Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtEmail {
            txtPassword.becomeFirstResponder();
        } else if textField == txtPassword {
            txtPassword.resignFirstResponder();
            onClickBtnLogin(nil)
        } else {
            self.view.endEditing(true)
            return true
        }
        return true
    }

    //MARK: - USER DEFINE METHODS
    func checkValidation() -> Bool {
        let validPassword = txtPassword.text!.checkPasswordValidation()
        let validEmail = txtEmail.text!.checkEmailValidation()
        let validPhoneNo = txtEmail.text!.isValidMobileNumber()

        if txtEmail.placeholder == "TXT_USER_NAME".localized {
            if txtEmail.text!.isEmpty {
                Utility.showToast(message: "MSG_PLEASE_ENTER_VALID_EMAIL_OR_PHONE_NUMBER".localized)
                txtEmail.becomeFirstResponder()
                return false
            }
            if txtEmail.text!.isNumber() {
                if validPhoneNo.0 == false {
                    Utility.showToast(message: validPhoneNo.1)
                    txtEmail.becomeFirstResponder()
                    return false
                }
            } else {
                if validEmail.0 == false {
                    Utility.showToast(message: validEmail.1)
                    txtEmail.becomeFirstResponder()
                    return false
                }
            }
        } else if txtEmail.placeholder == "TXT_PHONE".localized {
            if validPhoneNo.0 == false {
                Utility.showToast(message: validPhoneNo.1)
                txtEmail.becomeFirstResponder()
                return false
            }
        } else if txtEmail.placeholder == "TXT_EMAIL".localized {
            if validEmail.0 == false {
                Utility.showToast(message: validEmail.1);
                txtEmail.becomeFirstResponder();
                return false
            }
        }

        if validPassword.0 == false {
            Utility.showToast(message:validPassword.1);
            txtPassword.becomeFirstResponder();
            return false
        } else {
            return true
        }
    }

    func enabledLoginBy() {
        if preferenceHelper.getIsLoginByEmail() && preferenceHelper.getIsLoginByPhone() {
            txtEmail.placeholder = "TXT_USER_NAME".localized
        } else if preferenceHelper.getIsLoginByPhone() {
            txtEmail.placeholder = "TXT_PHONE".localized
        } else {
            txtEmail.placeholder = "TXT_EMAIL".localized
        }
    }

    func getDeviceCheckTokenData(completeCapatcha:@escaping((_ token:String) -> Void)) {
        if UIDevice.modelName.contains("Simulator") {
            completeCapatcha(self.deviceCheckToken)
        } else {
            let currentDevice = DCDevice.current
            if currentDevice.isSupported {
                currentDevice.generateToken(completionHandler: { (data, error) in
                    if let tokenData = data {
                        print("Token: \(tokenData.base64EncodedString())")
                        DispatchQueue.main.async {
                            completeCapatcha(self.deviceCheckToken)
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

    //MARK: - Button action methods
    @IBAction func onClickBtnRegisterVC(_ sender: UIButton) {
        for i in 0...(self.navigationController?.viewControllers.count)!-1{
            if self.navigationController!.viewControllers[i].isKind(of: RegisterVC.self){
                self.navigationController?.popToViewController(self.navigationController!.viewControllers[i], animated: true)
                return
            }
        }
        let mainView : UIStoryboard = UIStoryboard(name: "Prelogin", bundle: nil)
        let vc : RegisterVC = mainView.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func onClickBtnTwitter(_ sender: Any) {
        getTwitterData()
    }

    @objc func onClickGoogle() {
        print("GOOGLE LOGIN....")
        self.socialId = ""
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            if (error == nil) {
                self.socialId = user?.userID ?? ""
                self.txtEmail.text = user?.profile?.email
                self.getDeviceCheckTokenData { token in
                    self.deviceCheckToken = token
                    self.wsLogin()
                }
            } else {
                print("\(error?.localizedDescription)")
            }
        }
    }

    @IBAction func onClickBtnLogin(_ sender: Any?)    {
        self.socialId = ""
        if(self.checkValidation()) {
            if preferenceHelper.getIsSubStoreLogin() {
                self.getDeviceCheckTokenData { token in
                    self.deviceCheckToken = token
                    self.wsSubStoreLogin()
                }
            } else {
                self.getDeviceCheckTokenData { token in
                    self.deviceCheckToken = token
                    self.wsLogin()
                }
            }
        }
    }

    @IBAction func onClickBtnForgetPassword(_ sender: Any) {
        openForgetPasswordDialog()
    }
    
    @IBAction func onClickOpenLangueges(_ sender: UIButton) {
        openLanguageDialog()
    }

    @IBAction func onClickBtnDropdown(_ sender: UIButton) {
        self.openStoreSectionActionSheet()
    }

    @IBAction func onClickBtnStore(_ sender: UIButton) {
        viewGone()
        preferenceHelper.setIsSubStoreLogin(false)
        lblSelectedStorNamee.text = "TXT_STORE".localizedCapitalized
    }

    @IBAction func onClickBtnSubStore(_ sender: UIButton) {
        viewGone()
        preferenceHelper.setIsSubStoreLogin(true)
        lblSelectedStorNamee.text = "TXT_SUB_STORE".localized
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

    func viewGone(showMessage: Bool = false) {
        let height = 70
        UIView.animate(withDuration: 0.5, animations: {
            self.heightForDropDown.constant = CGFloat(height)
            self.viewForDropDown.superview?.layoutIfNeeded()
        }) { (completion) in
            self.viewForDropDown.isHidden = true
            self.heightForDropDown.constant = CGFloat(height)
            self.viewForDropDown.superview?.layoutIfNeeded()
        }
    }

    func viewVisible() {
        self.viewForDropDown.isHidden = false
        let height = 130
        self.heightForDropDown.constant = 70
        self.viewForDropDown.superview?.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, animations: {
            self.heightForDropDown.constant = CGFloat(height)
            self.viewForDropDown.superview!.layoutIfNeeded()
        })
    }

    //MARK: - Dialogs
    func openForgetPasswordDialog() {
        let dialogForForgetPassword = CustomForgetPwdDialog.showCustomVerificationDialog(title: "TXT_FORGOT_PASSWORD".localized, message: "TITLE_MSG_ENTER_MOBILE_EMAIL_FOR_VERIFICATION".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_RESET_PWD".localized, editTextOneHint: "TXT_EMAIL".localized, editTextTwoHint: "TXT_MOBILE_NO".localized, isEdiTextTwoIsHidden: false, isEdiTextOneIsHidden: false)
        dialogForForgetPassword.onClickLeftButton = { [unowned dialogForForgetPassword] in
            dialogForForgetPassword.removeFromSuperview();
        }
        dialogForForgetPassword.onClickRightButton = { [unowned dialogForForgetPassword, unowned self] (text1:String, text2:String) in
            let validEmail = text1.checkEmailValidation()
            let validPhoneNo = text2.isValidMobileNumber()

            if (text1.isEmpty() && text2.isEmpty()) {
                Utility.showToast(message: "MSG_PLEASE_ENTER_VALID_EMAIL_OR_PHONE_NUMBER".localized);
            } else if !text1.isEmpty() && validEmail.0 == false {
                Utility.showToast(message: validEmail.1)
            } else if !text2.isEmpty() && validPhoneNo.0 == false {
                Utility.showToast(message: validPhoneNo.1)
            } else {
                self.getDeviceCheckTokenData { token in
                    self.deviceCheckToken = token
                    self.wsForgetPassword(email: text1, phone: text2, dialogForForgetPassword: dialogForForgetPassword)
                }
            }
        }
    }

    @objc func openLanguageDialog() {
        super.openLanguageActionSheet()
    }

    func openStoreSectionActionSheet() {
        let alertController = UIAlertController(title: nil, message: "TXT_LOGIN_AS".localizedCapitalized, preferredStyle: .actionSheet)
        lblSubStoreTitle.text = "TXT_SUB_STORE".localized
        lblStoreTitle.text = "TXT_STORE".localizedCapitalized

        let action = UIAlertAction(title: "TXT_SUB_STORE".localized, style: .default, handler: { (alert: UIAlertAction!) -> Void in
            print(alert.title!)
            preferenceHelper.setIsSubStoreLogin(true)
            
            self.txtStoreType.text = "TXT_SUB_STORE".localized
        })
        
        let action1 = UIAlertAction(title: "TXT_STORE".localized, style: .default, handler: { (alert: UIAlertAction!) -> Void in
            print(alert.title!)
            preferenceHelper.setIsSubStoreLogin(false)
            
            self.txtStoreType.text = "TXT_STORE".localizedCapitalized
        })
        
        alertController.addAction(action1)
        alertController.addAction(action)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }

        self.present(alertController, animated: true, completion: nil)
    }

    //MARK: - WEB SERVICE CALLS
    func wsLogin() {
        Utility.showLoading()
        var dictParam:[String:Any];

        let currentAppVersion: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)
        LoginManager.init().logOut()
        GIDSignIn.sharedInstance.signOut()

        if socialId.isEmpty() {
            dictParam =   [PARAMS.EMAIL      : txtEmail.text!  ,
                           PARAMS.PASS_WORD  : txtPassword.text! ,
                           PARAMS.LOGIN_BY   : CONSTANT.MANUAL ,
                           PARAMS.DEVICE_TYPE: CONSTANT.IOS,
                           PARAMS.DEVICE_TOKEN:preferenceHelper.getDeviceToken(),
                           PARAMS.CAPTCHA_TOKEN : self.deviceCheckToken,
                           PARAMS.APP_VERSION : currentAppVersion]
        } else {
            dictParam =   [PARAMS.EMAIL      : txtEmail.text!,
                           PARAMS.PASS_WORD  : "",
                           PARAMS.SOCIAL_ID  : socialId,
                           PARAMS.LOGIN_BY   : CONSTANT.SOCIAL ,
                           PARAMS.DEVICE_TYPE: CONSTANT.IOS,
                           PARAMS.DEVICE_TOKEN:preferenceHelper.getDeviceToken(),
                           PARAMS.CAPTCHA_TOKEN : self.deviceCheckToken,
                           PARAMS.APP_VERSION : currentAppVersion
            ]
        }
        print("LOGIN=\(dictParam)")

        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_STORE_LOGIN, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Utility.hideLoading()
            Parser.parseUserStorageData(response: response, completion: { [unowned self] result in
                if result {
                    preferenceHelper.setRandomCartID(String.random(length: 20))
                    preferenceHelper.setCartID("")
                    self.btnFacebook.delegate = nil
                    APPDELEGATE.clearOrderNotificationEntity()
                    APPDELEGATE.clearMassNotificationEntity()
                    APPDELEGATE.goToMain();
                    /*
                    if preferenceHelper.getIsUserApprove() {
                        
                    } else {
                        APPDELEGATE.removeFirebaseTokenAndTopic()
                        preferenceHelper.setSessionToken("")
                        preferenceHelper.setUserId("")
                        StoreSingleton.shared.cart.removeAll()
                        Utility.showToast(message: "txt_unapprove_user".localized)
                    }*/
                    return
                }
            })
        }
    }

    func wsSubStoreLogin() {
        Utility.showLoading()
        var dictParam:[String:Any];
    
        let currentAppVersion: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)
        LoginManager.init().logOut()

        dictParam =   [PARAMS.EMAIL      : txtEmail.text!  ,
                       PARAMS.PASS_WORD  : txtPassword.text! ,
                       PARAMS.DEVICE_TYPE: CONSTANT.IOS,
                       PARAMS.DEVICE_TOKEN:preferenceHelper.getDeviceToken(),
                       PARAMS.CAPTCHA_TOKEN : self.deviceCheckToken,
                       PARAMS.APP_VERSION : currentAppVersion]

        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_SUB_STORE_LOGIN, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Utility.hideLoading()
            Parser.parseUserStorageData(response: response, completion: { [weak self] result in
                guard let self = self else { return }
                if result {
                    preferenceHelper.setRandomCartID(String.random(length: 20))
                    preferenceHelper.setCartID("")
                    self.btnFacebook.delegate = nil
                    APPDELEGATE.goToMain();
                    return
                }
            })
            
        }
    }

    func wsForgetPassword(email:String, phone:String, dialogForForgetPassword:CustomForgetPwdDialog) {
        Utility.showLoading()
        var dictParam : [String : Any] =
            [
                PARAMS.TYPE  : CONSTANT.TYPE_STORE
            ]
        if email.count > 0 && phone.count <= 0{
            dictParam[PARAMS.EMAIL] = email
        } else {
            dictParam[PARAMS.PHONE] = phone
            dictParam[PARAMS.COUNTRY_CODE] = preferenceHelper.getPhoneCountryCode()
        }
        dictParam[PARAMS.CAPTCHA_TOKEN] = self.deviceCheckToken
        print(dictParam)

        let alamoFire:AlamofireHelper = AlamofireHelper()
        alamoFire.getResponseFromURL(url: WebService.WS_FORGET_PASSWORD, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true) {
                Utility.showToast(message: "Verification code sent successfully".localized)
                dialogForForgetPassword.removeFromSuperview()
                let dialogForForgetPassword = CustomForgetPwdDialog.showCustomVerificationDialog(title: "TXT_FORGOT_PASSWORD".localized, message: email.count > 0 ? "Enter verification code received on email".localized : "Enter verification code received on phone number".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_VERIFY".localizedUppercase, editTextOneHint: email.count > 0 ? "TXT_EMAIL_OTP".localized:"TXT_PHONE_OTP".localized, editTextTwoHint: "", isEdiTextTwoIsHidden: true, isEdiTextOneIsHidden: false, params:dictParam, isFromResndCode: true)
                dialogForForgetPassword.startTimer()
                dialogForForgetPassword.onClickLeftButton = { [unowned dialogForForgetPassword] in
                    dialogForForgetPassword.removeFromSuperview()
                }
                dialogForForgetPassword.onClickRightButton = { [unowned self] (text1:String, text2:String) in
                    if text1.count > 0 {
                        self.getDeviceCheckTokenData { token in
                            self.deviceCheckToken = token
                            self.wsForgetPasswordVerify(email: email, phone: phone,otp: text1, dialogForForgetPassword: dialogForForgetPassword)
                        }
                    } else {
                        self.getDeviceCheckTokenData { token in
                            self.deviceCheckToken = token
                            self.wsForgetPassword(email: email, phone: phone, dialogForForgetPassword: dialogForForgetPassword)
                        }
                    }
                }
            }
        }
    }

    func wsForgetPasswordVerify(email:String,phone:String,otp:String,dialogForForgetPassword:CustomForgetPwdDialog) {
        Utility.showLoading()
        var dictParam : [String : Any] =
            [
                //                 PARAMS.EMAIL : email,
                PARAMS.TYPE  : CONSTANT.TYPE_STORE,
                //                 PARAMS.PHONE  : phone,
                PARAMS.OTP  : otp,
            ]
        if email.count > 0 && phone.count <= 0 {
            dictParam[PARAMS.EMAIL] = email
        } else {
            dictParam[PARAMS.PHONE] = phone
            dictParam[PARAMS.COUNTRY_CODE] = preferenceHelper.getPhoneCountryCode()
        }
        dictParam[PARAMS.CAPTCHA_TOKEN] = self.deviceCheckToken
        print(dictParam)

        let alamoFire:AlamofireHelper = AlamofireHelper()
        alamoFire.getResponseFromURL(url: WebService.WS_FORGET_PASSWORD_VERIFY, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response, withSuccessToast: true, andErrorToast: true) {
                preferenceHelper.setUserId(response["id"] as! String)
                self.dialogResetPwd(dialogForForgetPassword: dialogForForgetPassword)
            }
        }
    }

    func dialogResetPwd(dialogForForgetPassword:CustomForgetPwdDialog) {
        dialogForForgetPassword.removeFromSuperview()
        let dialogForForgetPassword = CustomForgetPwdDialog.showCustomVerificationDialog(title: "TXT_RESET_PWD".localized, message: "TITLE_ENTER_NEW_PWD".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_RESET_PWD".localizedUppercase, editTextOneHint: "MSG_ENTER_NEW_PWD".localized, editTextTwoHint: "TXT_CONFIRM_NEW_PWD".localized, isEdiTextTwoIsHidden: false,isEdiTextOneIsHidden: false,isFromResndCode: false)
        dialogForForgetPassword.onClickLeftButton = { [unowned dialogForForgetPassword] in
            dialogForForgetPassword.removeFromSuperview()
        }
        dialogForForgetPassword.onClickRightButton = { [unowned self]  (text1:String,text2:String) in
            self.wsUpdateNewPwd(pwd: text1)
        }
    }

    func wsUpdateNewPwd(pwd:String) {
        Utility.showLoading()
        let dictParam : [String : Any] =
            [
                PARAMS.TYPE  : CONSTANT.TYPE_STORE,
                PARAMS.ID  : preferenceHelper.getUserId(),
                PARAMS.SERVER_TOKEN  : preferenceHelper.getSessionToken(),
                PARAMS.PASS_WORD  : "",
            ]
        print(dictParam)

        let alamoFire:AlamofireHelper = AlamofireHelper()
        alamoFire.getResponseFromURL(url: WebService.WS_NEW_PASSWORD, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Utility.hideLoading()
            if  Parser.isSuccess(response: response, withSuccessToast: true, andErrorToast: true) {} else {}
        }
    }

    //MARK: - FACEBOOK AND GOOGLE LOGIN
    @IBAction func onClickBtnGoogleLogin(_ sender: Any){
        print("GOOGLE")
        self.socialId = ""
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            if (error == nil) {
                self.socialId = user?.userID ?? ""
                self.txtEmail.text = user?.profile?.email
                self.getDeviceCheckTokenData { token in
                    self.deviceCheckToken = token
                    self.wsLogin()
                }
            } else {
                print("\(error?.localizedDescription)")
            }
        }
    }

    @IBAction func onClickBtnFacebook(_ sender: Any) {
        self.socialId = ""
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(permissions: [.publicProfile], viewController: self) { (loginResult) in
            switch loginResult {
                case .failed( _):
                    break;
                case .cancelled:
                    Log.i("User Cancelled Login")
                    break;
                case .success( _, _, _):
                    Utility.showLoading()
                    self.getFBUserData()
            }
        }
    }

    func getTwitterData() {}

    func getFBUserData() {
        if AccessToken.current != nil {
            _ = GraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start {connection,result,error in
                Utility.hideLoading()
                if (error == nil) {
                    let dict = result as! [String : AnyObject]
                    let email:String = (dict["email"] as? String) ?? ""
                    Profile.loadCurrentProfile(completion: { [unowned self] (profile, error) in
                        if (error == nil) {
                            self.socialId = (profile?.userID)!
                            self.txtEmail.text = email
                            self.getDeviceCheckTokenData { token in
                                self.deviceCheckToken = token
                                self.wsLogin()
                            }
                        } else {
                            Utility.showToast(message: (error?.localizedDescription)!)
                        }
                    })
                }
            }
        }
    }

    //MARK: - GOOGLE SIGN METHOD
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }

    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {} else {
            print("\(error.localizedDescription)")
        }
    }
}

extension LoginVC:LoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {}

    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if error != nil {} else {
            if result?.isCancelled ?? true {
                print(error)
            } else {
                Utility.showLoading()
                self.getFBUserData()
            }
        }
    }
    
    func setupTwitterButton() {}
}
