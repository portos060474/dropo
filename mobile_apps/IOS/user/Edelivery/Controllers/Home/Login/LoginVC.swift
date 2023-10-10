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
import AuthenticationServices

class LoginVC: BaseVC, UITextFieldDelegate, UITextViewDelegate {

    //MARK: - Outlets
    @IBOutlet weak var viewForLanguage: UIView!
    @IBOutlet weak var lblLanguageMessage: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var scrLogin: UIScrollView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var viewForPassword: UIView!
    @IBOutlet weak var btnShowHidePassword: UIButton!
    @IBOutlet weak var btnForgetPasssword: UIButton!
    @IBOutlet weak var lblOr: UILabel!
    @IBOutlet weak var stkForSocialLogin: UIStackView!
    @IBOutlet weak var viewForSocialLogin: UIView!
    @IBOutlet weak var btnFacebook: FBLoginButton!
    @IBOutlet weak var btnGoogle: GIDSignInButton!
    @IBOutlet weak var btnSkipLogin: UIButton!
    @IBOutlet weak var lblSignInMsg: UILabel!
    @IBOutlet weak var lblUseAppLang: UILabel!
    @IBOutlet weak var lblSignUp: UILabel!
    @IBOutlet weak var viewImgBG: UIView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblSignInWith: UILabel!
    @IBOutlet weak var txtViewHaveAccount: UITextView!
    @IBOutlet weak var imgDropDown: UIImageView!

    let downArrow:String = "\u{25BC}"
    var socialId:String = ""

    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalization()
        let tap = UITapGestureRecognizer(target: self, action:#selector(openLanguageDialog))
        viewForLanguage.addGestureRecognizer(tap)
        currentBooking.clearBooking()
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
                let btnAppleID = ASAuthorizationAppleIDButton()
                btnAppleID.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
                stkForSocialLogin.addArrangedSubview(btnAppleID)
            }
        } else {
            viewForSocialLogin.isHidden = true
            lblOr.isHidden = true
        }
        lblLanguageMessage.text = LocalizeLanguage.currentAppleLanguageFull() //+  downArrow
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
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

    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    func setLocalization() {
        /*set colors*/
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        btnForgetPasssword.setTitleColor(UIColor.themeColor, for: UIControl.State.normal)
        lblLanguageMessage.textColor = UIColor.themeTextColor
        lblUseAppLang.textColor = UIColor.themeLightTextColor
        lblSignUp.textColor = UIColor.themeLightLineColor
        lblSignInMsg.textColor = UIColor.themeTextColor
        lblSignInWith.textColor = UIColor.themeColor
        txtViewHaveAccount.textColor = UIColor.themeTextColor
      
        /* Set localization */
        btnSkipLogin.setTitleColor(UIColor.themeColor, for: UIControl.State.normal)
        btnSkipLogin.setTitle("TXT_SKIP_LOGIN".localizedCapitalized, for: UIControl.State.normal)
        btnLogin.setTitle( "TXT_SIGN_IN".localizedCapitalized, for: UIControl.State.normal)
        txtPassword.placeholder = "TXT_PASSWORD".localized
        lblLanguageMessage.text = "MSG_LANGUAGE".localized
        btnForgetPasssword.setTitle("TXT_FORGOT_PASSWORD".localized, for: .normal)
        lblSignInMsg.text = "TXT_SIGN_IN".localized
        lblUseAppLang.text = "TXT_USE_APP_LANG".localized
        lblSignInWith.text = String(format: "%@ %@", "TXT_SIGN_IN_WITH".localized,"TXT_PASSWORD".localized)
        
        /*Set Font*/
        txtEmail.font = FontHelper.textRegular()
        txtPassword.font = FontHelper.textRegular()
        btnForgetPasssword.titleLabel?.font = FontHelper.textRegular()
        lblOr.font = FontHelper.textMedium()
        lblLanguageMessage.font = FontHelper.textMedium(size: FontHelper.regular)
        lblSignUp.font = FontHelper.textMedium(size: FontHelper.large)
        lblUseAppLang.font = FontHelper.textRegular()
        lblSignInMsg.font = FontHelper.textMedium(size: FontHelper.largest)
        lblSignInWith.font = FontHelper.textRegular()
        txtViewHaveAccount.font = FontHelper.textRegular()
        lblOr.textColor = UIColor.themeTextColor
        lblOr.text = "TXT_OR".localizedUppercase
        txtViewHaveAccount.isEditable = false
        txtViewHaveAccount.isSelectable = true
        txtViewHaveAccount.delegate = self
        txtViewHaveAccount.hyperLink(originalText: "TXT_HAVE_ACCOUNT_SIGNUP".localized, hyperLink: "TXT_SIGN_UP_NOW".localized, urlString: "http://signup.com/")
        enabledLoginBy()
        imgLogo.image = UIImage(named:"loginlogo")?.imageWithColor(color: UIColor.themeColor)
        imgDropDown.image = UIImage(named:"dropdown")?.imageWithColor(color: .themeTitleColor)
        
        if Bundle.main.bundleIdentifier == "com.elluminati.edelivery" {
            addTapOnVersion()
        }
    }

    func setupLayout() {
        btnLogin.applyShadowToButton()
        viewImgBG.setRound(withBorderColor: UIColor.themeLightLineColor, andCornerRadious: viewImgBG.frame.size.width/2.0, borderWidth: 2.0)
        imgLogo.setRound()
        btnLogin.applyRoundedCornersWithHeight()
    }
    
    func addTapOnVersion() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onClickVersionTap(_:)))
        tap.numberOfTapsRequired = 3
        self.imgLogo.addGestureRecognizer(tap)
        self.imgLogo.isUserInteractionEnabled = true
    }
    
    @objc func onClickVersionTap(_ sender: UITapGestureRecognizer) {
        let dialog = DialogForApplicationMode.showCustomAppModeDialog()
        
        dialog.onClickLeftButton = { [unowned dialog] in
            dialog.removeFromSuperview()
        }
        
        dialog.onClickRightButton = { [unowned dialog] in
            dialog.removeFromSuperview()
            if AppMode.currentMode != dialog.appMode {
                preferenceHelper.setSessionToken("")
                preferenceHelper.setUserId("")
                preferenceHelper.setRandomCartID(String.random(length: 20))
                APPDELEGATE.clearFavoriteAddressEntity()
                APPDELEGATE.clearDeliveryLocationEntity()
                preferenceHelper.setAuthToken("")
                AppMode.currentMode = dialog.appMode
                self.dismiss(animated: false, completion: nil)
                APPDELEGATE.goToHome(isSplash: true)
            }
        }
    }

    override func updateUIAccordingToTheme() {
        imgLogo.image = UIImage(named:"loginlogo")?.imageWithColor(color: UIColor.themeColor)
        imgDropDown.image = UIImage(named:"dropdown")?.imageWithColor(color: .themeTitleColor)
    }

    //MARK: - UITexView Delegate
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.absoluteString == "http://signup.com/" {
            (self.parent as! Home).goToSignUp()
        }
        return false
    }

    //MARK: - TextField Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        if textField == txtEmail {
            txtPassword.becomeFirstResponder()
        } else if textField == txtPassword {
            txtPassword.resignFirstResponder()
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

        if txtEmail.text!.isEmpty() {
            if preferenceHelper.getIsLoginByEmail() && preferenceHelper.getIsLoginByPhone() {
                Utility.showToast(message: "MSG_PLEASE_ENTER_VALID_EMAIL_OR_PHONE_NUMBER".localized)
                txtEmail.becomeFirstResponder()
                return false
            } else if preferenceHelper.getIsLoginByPhone() {
                Utility.showToast(message: "MSG_PLEASE_ENTER_VALID_PHONE_NUMBER".localized)
                txtEmail.becomeFirstResponder()
                return false
            } else {
                Utility.showToast(message: "MSG_ENTER_EMAIL".localized)
                txtEmail.becomeFirstResponder()
                return false
            }
        } else if validPassword.0 == false {
            Utility.showToast(message: validPassword.1)
            txtPassword.becomeFirstResponder()
            return false
        } else {
            let validEmail = txtEmail.text!.checkEmailValidation()
            let validMobileNumber = txtEmail.text!.isValidMobileNumber()

            if txtEmail.placeholder == "TXT_USER_NAME".localized {
                if validEmail.0 == true {
                    return true
                } else if (txtEmail.text!.isNumber() && validMobileNumber.0 == true) {
                    return true
                } else {
                    Utility.showToast(message: "MSG_PLEASE_ENTER_VALID_EMAIL_OR_PHONE_NUMBER".localized)
                    txtEmail.becomeFirstResponder()
                    return false
                }
            } else if txtEmail.placeholder == "TXT_PHONE".localized {
                if validMobileNumber.0 == true {
                    return true
                } else {
                    Utility.showToast(message: validMobileNumber.1)
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
    @IBAction func onClickBtnSkipLogin(_ sender: Any) {
        btnSkipLogin.isUserInteractionEnabled = false
        APPDELEGATE.goToMain()
    }

    @IBAction func onClickBtnLogin(_ sender: Any?) {
        self.view.endEditing(true)
        self.socialId = ""
        if(self.checkValidation()) {
            wsLogin()
        }
    }

    @IBAction func onClickBtnForgetPassword(_ sender: Any) {
        self.view.endEditing(true)
        openForgetPasswordDialog()
    }

    @IBAction func onClickBtnTwitter(_ sender: Any) {
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
    func openForgetPasswordDialog() {
        let dialogForForgetPassword = CustomVerificationDialog.showCustomVerificationDialog(title: "TXT_FORGOT_PASSWORD".localized, message: "MSG_FORGOT_PASSWORD".localized, titleLeftButton: "".localized, titleRightButton: "TXT_RESET_PWD".localizedCapitalized, editTextOneHint: "TXT_PHONE".localized, editTextTwoHint: "", isEdiTextTwoIsHidden: true)
        dialogForForgetPassword.onClickLeftButton = { [unowned dialogForForgetPassword] in
            dialogForForgetPassword.removeFromSuperview()
        }
        dialogForForgetPassword.onClickRightButton = { [unowned self, unowned dialogForForgetPassword] (text1:String,text2:String) in
            let validMobileNumber = text1.isValidMobileNumber()
            if validMobileNumber.0 == false {
                Utility.showToast(message: validMobileNumber.1)
            } else {
                self.wsForgetPassword(email: text1, phone: text1, dialogForForgetPassword: dialogForForgetPassword)
            }
        }
    }

    @objc func openLanguageDialog() {
        openLanguageActionSheet()
    }

    func openLanguageActionSheet() {
        let alertController = UIAlertController(title: nil, message: "TXT_CHANGE_LANGUAGE".localized, preferredStyle: .actionSheet)
        for i in arrForLanguages{
            let action = UIAlertAction(title: i.language , style: .default, handler: { (alert: UIAlertAction!) -> Void in
                print(alert.title!)
                print(arrForLanguages.firstIndex(where: {$0.language == alert.title!})!)
                if arrForLanguages.firstIndex(where: {$0.language == alert.title!})! == preferenceHelper.getLanguage(){
                    self.dismiss(animated: true, completion: nil)
                } else {
                    super.changed(arrForLanguages.firstIndex(where: {$0.language == alert.title!})!)
                }
            })
            alertController.addAction(action)
        }

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

        LoginManager.init().logOut()
        GIDSignIn.sharedInstance.signOut()

        var dictParam:[String:Any]
        if socialId.isEmpty() {
            dictParam =   [PARAMS.EMAIL      : txtEmail.text!  ,
                           PARAMS.PASS_WORD  : txtPassword.text! ,
                           PARAMS.LOGIN_BY   : CONSTANT.MANUAL ,
                           PARAMS.DEVICE_TYPE: CONSTANT.IOS,
                           PARAMS.SOCIAL_ID: "",
                           PARAMS.IPHONE_ID:preferenceHelper.getRandomCartID(),
                           PARAMS.DEVICE_TOKEN:preferenceHelper.getDeviceToken(),
            ]
        } else {
            dictParam =   [PARAMS.EMAIL      : txtEmail.text!,
                           PARAMS.PASS_WORD  : "",
                           PARAMS.SOCIAL_ID  : socialId,
                           PARAMS.LOGIN_BY   : CONSTANT.SOCIAL ,
                           PARAMS.DEVICE_TYPE: CONSTANT.IOS,
                           PARAMS.IPHONE_ID:preferenceHelper.getRandomCartID(),
                           PARAMS.DEVICE_TOKEN:preferenceHelper.getDeviceToken(),
            ]
        }
        print(dictParam)

        let alamoFire:AlamofireHelper = AlamofireHelper()
        alamoFire.getResponseFromURL(url: WebService.WS_USER_LOGIN, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
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

    func wsForgetPassword(email:String,phone:String,dialogForForgetPassword:CustomVerificationDialog) {
        Utility.showLoading()
        let dictParam : [String : Any] = [
            PARAMS.EMAIL : "",
            PARAMS.TYPE  : CONSTANT.TYPE_USER,
            PARAMS.PHONE  : phone
        ]

        let alamoFire:AlamofireHelper = AlamofireHelper()
        alamoFire.getResponseFromURL(url: WebService.WS_FORGET_PASSWORD, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true) {
                dialogForForgetPassword.removeFromSuperview()
                let dialogForForgetPassword = CustomVerificationDialog.showCustomVerificationDialog(title: "TXT_FORGOT_PASSWORD".localized, message: "TXT_TITLE_MSG_VERIFICATION_CODE".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_VERIFY".localizedCapitalized, editTextOneHint: "TXT_PHONE_OTP".localized, editTextTwoHint: "", isEdiTextTwoIsHidden: true, isEdiTextOneIsHidden: false, isForVerifyOtp: true, isForgotPasswordOtp: true, param: dictParam)
                dialogForForgetPassword.startTimer()
                dialogForForgetPassword.onClickLeftButton = { [unowned dialogForForgetPassword] in
                    dialogForForgetPassword.removeFromSuperview()
                }
                dialogForForgetPassword.onClickRightButton = { [unowned self] (text1:String,text2:String) in
                    if text1.count > 0 {
                        self.wsForgetPasswordVerify(email: email, phone: phone,otp: text1, dialogForForgetPassword: dialogForForgetPassword)
                    } else {
                        self.wsForgetPassword(email: email, phone: phone, dialogForForgetPassword: dialogForForgetPassword)
                    }
                }
            }
        }
    }

    func wsForgetPasswordVerify(email:String,phone:String,otp:String,dialogForForgetPassword:CustomVerificationDialog) {
        Utility.showLoading()
        let dictParam : [String : Any] = [
            PARAMS.TYPE  : CONSTANT.TYPE_USER,
            PARAMS.PHONE  : phone,
            PARAMS.OTP  : otp,
        ]
        print(dictParam)

        let alamoFire:AlamofireHelper = AlamofireHelper()
        alamoFire.getResponseFromURL(url: WebService.WS_FORGET_PASSWORD_VERIFY, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Utility.hideLoading()
            if  Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true) {
                dialogForForgetPassword.timer?.invalidate()
                let idFromResponse = response["id"] as? String
                let serverTokenFromResponse = response["server_token"] as? String
                self.dialogResetPwd(dialogForForgetPassword: dialogForForgetPassword, id: idFromResponse ?? "", serverToken:  serverTokenFromResponse ?? "")
            }
        }
    }

    func dialogResetPwd(dialogForForgetPassword:CustomVerificationDialog, id: String, serverToken: String){
        dialogForForgetPassword.removeFromSuperview()
        
        let dialogForForgetPassword = CustomVerificationDialog.showCustomVerificationDialog(title: "TXT_RESET_PWD".localized, message: "TITLE_ENTER_NEW_PWD".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_RESET".localizedCapitalized, editTextOneHint: "MSG_ENTER_NEW_PWD".localized, editTextTwoHint: "TXT_CONFIRM_NEW_PWD".localized, isEdiTextTwoIsHidden: false, isEdiTextOneIsHidden: false)
        
        dialogForForgetPassword.onClickLeftButton = { [unowned dialogForForgetPassword] in
            dialogForForgetPassword.removeFromSuperview()
        }
        
        dialogForForgetPassword.onClickRightButton = { [unowned self]  (text1:String,text2:String) in
            dialogForForgetPassword.removeFromSuperview()
            self.wsUpdateNewPwd(pwd: text1, id: id, serverToken:  serverToken)
        }
    }

    func wsUpdateNewPwd(pwd:String, id: String, serverToken: String){
        Utility.showLoading()
        let dictParam : [String : Any] = [
            PARAMS.TYPE  : CONSTANT.TYPE_USER,
            PARAMS.ID  : id,
            PARAMS.SERVER_TOKEN  : serverToken,
            PARAMS.PASS_WORD  : pwd,
        ]
        print(dictParam)

        let alamoFire:AlamofireHelper = AlamofireHelper()
        alamoFire.getResponseFromURL(url: WebService.WS_NEW_PASSWORD, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response, withSuccessToast: true, andErrorToast: true) {} else {}
        }
    }

    //MARK: - FACEBOOK AND GOOGLE LOGIN
    @IBAction func onClickBtnGoogleLogin(_ sender: Any){
        self.socialId = ""
        GIDSignIn.sharedInstance.signOut()
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self){ user, error in
            guard error == nil else { return }
            self.socialId = user?.userID ?? ""
            self.txtEmail.text = user?.profile?.email
            self.wsLogin()
        }
    }

    @IBAction func onClickBtnFacebook(_ sender: Any){
        self.socialId = ""
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(permissions: [.publicProfile], viewController: self) { (loginResult) in
            switch loginResult {
            case .failed( _):
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

    func getFBUserData() {
        if((AccessToken.current) != nil) {
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start { (connection, result, error) in
                Utility.hideLoading()
                if (error == nil) {
                    let dict = result as! [String : AnyObject]
                    let email:String = (dict["email"] as? String) ?? ""
                    Profile.loadCurrentProfile(completion:  { [unowned self] (profile, error) in
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

@available(iOS 13.0, *)
extension LoginVC: ASAuthorizationControllerDelegate {

    @objc func handleAppleIdRequest() {
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

                    if !(appleIDCredential.email ?? "").isEmpty{
                        preferenceHelper.setSigninWithAppleEmail(appleIDCredential.email ?? "")
                        self.txtEmail.text = preferenceHelper.getSigninWithAppleEmail()
                    } else {
                        if preferenceHelper.getSigninWithAppleEmail().count > 0{
                            DispatchQueue.main.async {
                                self.txtEmail.text = preferenceHelper.getSigninWithAppleEmail()
                            }
                        }
                    }

                    if !(appleIDCredential.fullName?.givenName ?? "").isEmpty{
                        preferenceHelper.setSigninWithAppleUserName((appleIDCredential.fullName?.givenName ?? "") + " " + (appleIDCredential.fullName?.familyName ?? ""))
                    }
                    self.socialId = appleIDCredential.user

                    DispatchQueue.main.async {
                        if appleIDCredential.email?.contains("privaterelay.appleid.com") ?? false {
                            self.wsLogin()
                        } else {
                            self.wsLogin()
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
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("apple signin error = \(error.localizedDescription)")
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
