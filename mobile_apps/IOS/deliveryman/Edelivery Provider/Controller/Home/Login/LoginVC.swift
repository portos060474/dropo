//
//  LoginVC.swift
//  edelivery
//
//  Created by Elluminati on 17/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import FirebaseMessaging

class LoginVC: BaseVC, UITextFieldDelegate {

    //MARK: - Outlets
    @IBOutlet weak var lblOr: UILabel!
    @IBOutlet weak var stkForSocialLogin: UIStackView!
    @IBOutlet weak var viewForSocialLogin: UIView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var scrLogin: UIScrollView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: CustomTextfield!
    @IBOutlet weak var viewForPassword: UIView!
    @IBOutlet weak var btnShowHidePassword: UIButton!
    @IBOutlet weak var btnForgetPasssword: UIButton!
    @IBOutlet weak var viewForLanguage: UIView!
    
    /*View For Language Notification*/
    @IBOutlet weak var lblLanguageTitle: UILabel!
    @IBOutlet weak var lblLanguageMessage: UILabel!
    @IBOutlet weak var btnFacebook: FBLoginButton!
    @IBOutlet weak var btnGoogle: GIDSignInButton!
    @IBOutlet weak var lblRegisterMessage: UILabel!
    @IBOutlet weak var lblLanguageMessages: UILabel!
    @IBOutlet weak var lblLogin: UILabel!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnLanguage: UIButton!
    @IBOutlet weak var imageForLanguage: UIImageView!

    var socialId:String = ""

    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalization()
        let tap = UITapGestureRecognizer(target: self, action:#selector(openLanguageDialog))
        viewForLanguage.addGestureRecognizer(tap)
        viewForLanguage.isHidden = true
        btnGoogle.style = .standard
        btnGoogle.colorScheme = .light
        btnFacebook.delegate = self
        btnFacebook.permissions = ["public_profile", "email"]
        btnFacebook.isHidden = true
        if preferenceHelper.getIsSocialLoginEnable() {
            viewForSocialLogin.isHidden = false
            lblOr.isHidden = false
        } else {
            viewForSocialLogin.isHidden = true
            lblOr.isHidden = true
        }
        lblLanguageMessage.text =
        LocalizeLanguage.currentAppleLanguageFull()
        self.navigationController?.navigationBar.isHidden = true
        
        if Bundle.main.bundleIdentifier == "com.elluminati.edelivery.provider" {
            addTapOnVersion()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LoginManager.init().logOut()
        GIDSignIn.sharedInstance.signOut()
    }

    override func updateUIAccordingToTheme() {
        self.setLocalization()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
    
    func addTapOnVersion() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onClickVersionTap(_:)))
        tap.numberOfTapsRequired = 3
        self.lblLogin.addGestureRecognizer(tap)
        self.lblLogin.isUserInteractionEnabled = true
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

    func setLocalization() {
        /*set colors*/
        self.view.backgroundColor = UIColor.themeViewBackgroundColor;
        txtEmail.textColor = UIColor.themeTextColor;
        txtPassword.textColor = UIColor.themeTextColor;
        btnForgetPasssword.setTitleColor(UIColor.themeColor, for: UIControl.State.normal)
        lblLanguageTitle.textColor = UIColor.themeTextColor
        lblLanguageMessage.textColor = UIColor.themeLightTextColor
        lblOr.textColor = UIColor.themeTextColor

        /* Set localization */
        btnForgetPasssword.setTitle("TXT_FORGOT_PASSWORD".localizedCapitalized, for: UIControl.State.normal)
        btnLogin.setTitle( "TXT_LOGIN".localizedUppercase, for: UIControl.State.normal)
        btnLogin.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        btnLogin.backgroundColor = UIColor.themeButtonBackgroundColor
       // btnLogin.setRound()
        txtPassword.placeholder = "TXT_PASSWORD".localized
        lblLanguageTitle.text = "TXT_LANGUAGE".localized
        lblOr.text = "TXT_OR".localizedUppercase
        lblLanguageMessage.text = LocalizeLanguage.currentAppleLanguageFull()

        /*Set Font*/
        txtEmail.font = FontHelper.textRegular()
        txtPassword.font = FontHelper.textRegular()
        btnForgetPasssword.titleLabel?.font = FontHelper.textRegular() //FontHelper.textMedium(size: 15)
        btnLogin.titleLabel?.font = FontHelper.buttonText()
        lblOr.font = FontHelper.textMedium()
        lblLanguageTitle.font = FontHelper.textSmall()
        lblLanguageMessage.font = FontHelper.textRegular()
        enabledLoginBy()
        lblRegisterMessage.textColor = UIColor.themeTextColor;
        lblRegisterMessage.font = FontHelper.textRegular()
        lblRegisterMessage.text = "TXT_DONT_HAVE_ACCOUNT".localized
        btnRegister.setTitleColor(UIColor.themeColor, for: .normal)
        btnRegister.titleLabel?.font = FontHelper.textMedium(size: 15)
        btnRegister.setTitle("TXT_REGISTER_NOW".localized, for: .normal)
        lblLogin.textColor = .themeTextColor
        lblLogin.text = "TXT_LOGIN".localizedCapitalized
        lblLogin.font = FontHelper.textLargest()
        lblLanguageMessages.font = FontHelper.textRegular()
        lblLanguageMessages.textColor = .themeLightTextColor
        lblLanguageMessages.text = "TXT_USE_APP_IN".localized
        btnLanguage.setTitle(LocalizeLanguage.currentAppleLanguageFull(), for: .normal)
        btnLanguage.titleLabel?.font = FontHelper.textMedium(size: 14)
        btnLanguage.setTitleColor(.themeTextColor, for: .normal)
        btnLanguage.addTarget(self, action: #selector(openLanguageDialog), for: .touchUpInside)
        imageForLanguage.image = UIImage.init(named: "dropdown")?.imageWithColor(color: .themeIconTintColor)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openLanguageDialog))
        imageForLanguage.isUserInteractionEnabled = true
        imageForLanguage.addGestureRecognizer(tapGestureRecognizer)
    }

    @IBAction func btnRegisterClick(_ sender: Any) {
        if #available(iOS 13.0, *) {
            let register = (self.storyboard?.instantiateViewController(identifier: "RegisterVC"))!
            self.navigationController?.pushViewController(register, animated: true)
        } else {
            let register = (self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC"))!
            self.navigationController?.pushViewController(register, animated: true)
        }
    }

    func setupLayout() {}

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

        if (txtEmail.text?.isEmpty())! {
            if txtEmail.placeholder == "TXT_USER_NAME".localized {
                Utility.showToast(message: "MSG_PLEASE_ENTER_VALID_EMAIL_OR_PHONE_NUMBER".localized);
                txtEmail.becomeFirstResponder()
                return false
            } else if txtEmail.placeholder == "TXT_PHONE".localized {
                Utility.showToast(message: "MSG_PLEASE_ENTER_MOBILE_NUMBER".localized);
                txtEmail.becomeFirstResponder()
                return false
            } else {
                Utility.showToast(message: "MSG_PLEASE_ENTER_VALID_EMAIL".localized);
                txtEmail.becomeFirstResponder()
                return false
            }
        } else if validPassword.0 == false {
            Utility.showToast(message: validPassword.1)
            txtPassword.becomeFirstResponder()
            return false
        } else {
            let validEmail = txtEmail.text!.checkEmailValidation()

            if txtEmail.placeholder == "TXT_USER_NAME".localized {
                if validEmail.0 == true {
                    return true
                } else if (txtEmail.text!.isNumber()) {
                    if txtEmail.text!.isValidMobileNumber().0 {
                        return true
                    } else {
                        Utility.showToast(message: "MSG_PLEASE_ENTER_VALID_EMAIL_OR_PHONE_NUMBER".localized)
                        txtEmail.becomeFirstResponder()
                        return false
                    }
                } else {
                    Utility.showToast(message: "MSG_PLEASE_ENTER_VALID_EMAIL_OR_PHONE_NUMBER".localized)
                    txtEmail.becomeFirstResponder()
                    return false
                }
            } else if txtEmail.placeholder == "TXT_PHONE".localized {
                if (txtEmail.text!.isNumber()) {
                    if txtEmail.text!.isValidMobileNumber().0 {
                        return true
                    } else {
                        Utility.showToast(message: "MSG_PLEASE_ENTER_VALID_PHONE_NUMBER".localized)
                        txtEmail.becomeFirstResponder()
                        return false
                    }
                } else {
                    Utility.showToast(message: "MSG_PLEASE_ENTER_VALID_PHONE_NUMBER".localized)
                    txtEmail.becomeFirstResponder()
                    return false
                }
            } else {
                if validEmail.0 == true {
                    return true
                } else {
                    Utility.showToast(message: validEmail.1)
                    txtEmail.becomeFirstResponder()
                    return false
                }
            }
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
    
    //MARK: - Button action methods
    @IBAction func onClickBtnLogin(_ sender: Any?) {
        if(self.checkValidation()) {
            wsLogin()
        }
    }

    @IBAction func onClickBtnForgetPassword(_ sender: Any) {
        openForgetPasswordDialog()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func onClickBtnTwitter(_ sender: Any) {}

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
    func openForgetPasswordDialog() {
        self.view.endEditing(true)
        let dialogForForgetPassword = CustomVerificationDialog.showCustomVerificationDialog(title: "TXT_FORGOT_PASSWORD".localized, message: "MSG_FORGOT_PASSWORD".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_OK".localizedUppercase, editTextOneHint: "TXT_MOBILE_NUMBER".localized, editTextTwoHint: "", isEdiTextTwoIsHidden: true)
        dialogForForgetPassword.onClickLeftButton = { [unowned dialogForForgetPassword] in
            dialogForForgetPassword.removeFromSuperview();
        }
        dialogForForgetPassword.onClickRightButton = { [unowned dialogForForgetPassword, unowned self] (text1:String,text2:String) in
            let validMobileNumber = text1.isValidMobileNumber()
            if validMobileNumber.0 == false {
                Utility.showToast(message: validMobileNumber.1)
            } else {
                self.wsForgetPassword(email: text1, phone: text1, dialogForForgetPassword: dialogForForgetPassword)
            }
        }
    }

    //MARK: - WEB SERVICE CALLS
    func wsLogin() {
        Utility.showLoading()
        var dictParam:[String:Any];
        LoginManager.init().logOut()
        GIDSignIn.sharedInstance.signOut()

        if socialId.isEmpty {
            dictParam = [PARAMS.EMAIL      : txtEmail.text!  ,
                           PARAMS.PASSWORD  : txtPassword.text! ,
                           PARAMS.LOGIN_BY   : CONSTANT.MANUAL ,
                           PARAMS.DEVICE_TYPE: CONSTANT.IOS,
                           PARAMS.DEVICE_TOKEN:preferenceHelper.getDeviceToken(),
                           PARAMS.SOCIAL_ID  : ""
            ]
        } else {
            dictParam = [PARAMS.EMAIL      : txtEmail.text!,
                           PARAMS.PASSWORD  : "",
                           PARAMS.SOCIAL_ID  : socialId,
                           PARAMS.LOGIN_BY   : CONSTANT.SOCIAL ,
                           PARAMS.DEVICE_TYPE: CONSTANT.IOS,
                           PARAMS.DEVICE_TOKEN:preferenceHelper.getDeviceToken()
            ]
        }

        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_PROVIDER_LOGIN, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Utility.hideLoading()
            Parser.parseUserStorageData(response: response, completion: { result in
                if result {
                    APPDELEGATE.clearMassNotificationEntity()
                    APPDELEGATE.clearOrderNotificationEntity()
                    APPDELEGATE.goToMain();
                    return
                }
            })
        }
    }

    func wsForgetPassword(email:String, phone:String, dialogForForgetPassword:CustomVerificationDialog) {
        Utility.showLoading()
        let dictParam : [String : Any] =
        [
            PARAMS.TYPE  : CONSTANT.TYPE_PROVIDER,
            PARAMS.PHONE  : phone
        ]

        let alamoFire:AlamofireHelper = AlamofireHelper()
        alamoFire.getResponseFromURL(url: WebService.WS_FORGET_PASSWORD, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true) {
                dialogForForgetPassword.removeFromSuperview()
                let dialogForForgetPassword = CustomVerificationDialog.showCustomVerificationDialog(title: "TXT_FORGOT_PASSWORD".localized, message: "TITLE_MSG_ENTER_MOBILE_EMAIL_FOR_VERIFICATION".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_VERIFY".localizedUppercase, editTextOneHint: "TXT_MOBILE_NUMBER".localized, editTextTwoHint: "", isEdiTextTwoIsHidden: true, isEdiTextOneIsHidden: false, isForVerifyOtp: true, isForgotPasswordOtp: true, param: dictParam)
                dialogForForgetPassword.startTimer()
                dialogForForgetPassword.onClickLeftButton = { [unowned dialogForForgetPassword] in
                    dialogForForgetPassword.removeFromSuperview()
                }
                dialogForForgetPassword.onClickRightButton = { [unowned self] (text1:String, text2:String) in
                    if text1.count > 0 {
                        self.wsForgetPasswordVerify(email:email, phone:phone, otp:text1, dialogForForgetPassword:dialogForForgetPassword)
                    } else {
                        self.wsForgetPassword(email:email, phone:phone, dialogForForgetPassword:dialogForForgetPassword)
                    }
                }
            }
        }
    }

    func wsForgetPasswordVerify(email:String, phone:String, otp:String, dialogForForgetPassword:CustomVerificationDialog) {
        Utility.showLoading()
        let dictParam : [String : Any] =
        [
            PARAMS.TYPE  : CONSTANT.TYPE_PROVIDER,
            PARAMS.PHONE  : phone,
            PARAMS.OTP  : otp,
        ]
        print(dictParam)

        let alamoFire:AlamofireHelper = AlamofireHelper()
        alamoFire.getResponseFromURL(url: WebService.WS_FORGET_PASSWORD_VERIFY, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response, withSuccessToast: true, andErrorToast: true) {
                self.dialogResetPwd(dialogForForgetPassword: dialogForForgetPassword)
            }
        }
    }

    func dialogResetPwd(dialogForForgetPassword:CustomVerificationDialog){
        dialogForForgetPassword.removeFromSuperview()
        let dialogForForgetPassword = CustomVerificationDialog.showCustomVerificationDialog(title: "TXT_RESET_PWD".localized, message: "TITLE_ENTER_NEW_PWD".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_RESET".localizedUppercase, editTextOneHint: "MSG_ENTER_NEW_PWD".localized, editTextTwoHint: "TXT_CONFIRM_NEW_PWD".localized, isEdiTextTwoIsHidden: false, isEdiTextOneIsHidden: false, editTextOneInputType : true, editTextTwoInputType: true)
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
            PARAMS.TYPE  : CONSTANT.TYPE_PROVIDER,
            PARAMS.ID  : preferenceHelper.getUserId(),
            PARAMS.SERVER_TOKEN  : preferenceHelper.getSessionToken(),
            PARAMS.PASS_WORD  : "",
        ]
        print(dictParam)

        let alamoFire:AlamofireHelper = AlamofireHelper()
        alamoFire.getResponseFromURL(url: WebService.WS_NEW_PASSWORD, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response, withSuccessToast: true, andErrorToast: true) {}
        }
    }

    //MARK: - FACEBOOK AND GOOGLE LOGIN
    @IBAction func onClickBtnGoogleLogin(_ sender: Any) {
        self.socialId = ""
        GIDSignIn.sharedInstance.signOut()
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self){ user, error in
            if (error == nil) {
                self.socialId = (user?.userID)!
                self.txtEmail.text = user?.profile?.email
                self.wsLogin()
            } else {
                print("\(error?.localizedDescription ?? "")")
            }
        }
    }
    
    @IBAction func onClickBtnFacebook(_ sender: Any){
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
                            self.socialId = (profile?.userID)!
                            self.txtEmail.text = email
                            self.wsLogin()
                        } else {
                            Utility.showToast(message: (error?.localizedDescription)!)
                        }
                    })
                }
            }
        }
    }

    @objc func openLanguageDialog() {
        self.openLanguageActionSheet()
    }
}

extension LoginVC:LoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {}

    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if error != nil {} else {
            if result?.isCancelled ?? true {
                print(error ?? "")
            } else {
                Utility.showLoading()
                self.getFBUserData()
            }
        }
    }
}
