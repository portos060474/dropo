//
//  ProfileVC.swift
// Edelivery Store
//
//  Created by Jaydeep Vyas on 28/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class ProfileVC: BaseVC,RightDelegate,UITextFieldDelegate {
    
    //MARK:- Outlets Declaration
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var btnSelectPhoto: UIButton!
    
    @IBOutlet weak var lblDivider: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var viewForProfile: UIView!
    @IBOutlet weak var btnChangePassword: UIButton!
    @IBOutlet weak var imgForRefral: UIImageView!
    @IBOutlet weak var lblForRefral: UILabel!
    @IBOutlet weak var viewForReferral: CustomCardView!
    @IBOutlet weak var btnShowHidePassword: UIButton!
    @IBOutlet weak var btnShowHideConfirmPassword: UIButton!
    @IBOutlet weak var viewForConfirmPassword: UIView!
    @IBOutlet weak var viewForPassword: UIView!
    @IBOutlet weak var btnDeleteAccount: UIButton!
    
    //MARK:- Variable Declaration
    var isPicAdded:Bool = false
    var phoneNumberLength = 10
    var dialogForImage:CustomPhotoDialog?;
    var password:String = "";

    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        delegateRight = self
        setLocalization()
        setProfileData();
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews();
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        viewForProfile.setRound(withBorderColor: UIColor.themeLightTextColor)
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


    func setLocalization() {
        /*set colors*/
        self.view.backgroundColor = UIColor.themeViewBackgroundColor;
        btnChangePassword.setTitleColor(UIColor.themeColor, for: .normal)
        btnSelectPhoto.backgroundColor = UIColor.clear
        
        txtName.textColor = UIColor.themeTextColor
        txtEmail.textColor = UIColor.themeTextColor
        txtNewPassword.textColor = UIColor.themeTextColor
        txtConfirmPassword.textColor = UIColor.themeTextColor
        txtMobileNumber.textColor = UIColor.themeTextColor
        lblCountryCode.textColor = UIColor.themeTextColor
        lblDivider.backgroundColor = UIColor.themeLightTextColor
        lblMobileNumber.textColor = UIColor.themeLightTextColor
        /*Set Place Holder*/
        txtName.placeholder = "TXT_NAME".localizedCapitalized
        txtEmail.placeholder = "TXT_EMAIL".localizedCapitalized
        txtNewPassword.placeholder = "TXT_NEW_PASSWORD".localizedCapitalized
        txtConfirmPassword.placeholder = "TXT_CONFIRM_PASSWORD".localizedCapitalized
        txtMobileNumber.placeholder = "TXT_MOBILE_NO".localizedCapitalized
        lblCountryCode.text = "TXT_DEFAULT".localizedCapitalized
        lblMobileNumber.text = "TXT_MOBILE_NO".localizedCapitalized
        
        txtMobileNumber.tintColor = .themeTextColor
        self.setRightBarItem(isNative: false)
        
        btnDeleteAccount.setTitle("txt_delete_account".localized, for: .normal)
        btnDeleteAccount.setTitleColor(UIColor.themeRedColor, for: .normal)
        
        /*Set Text*/
        title  = "TXT_PROFILE".localized
        
        lblCountryCode.text = "TXT_DEFAULT".localized;
        txtName.text = "".localizedCapitalized
        txtEmail.text = "".localizedCapitalized
        txtMobileNumber.text = "".localizedCapitalized
        txtNewPassword.text = "".localizedCapitalized
        txtConfirmPassword.text = "".localizedCapitalized
        btnChangePassword.setTitle("TXT_CHANGE_PASSWORD".localized, for: .normal)
        
        /*Set Fonts*/
        txtName.font = FontHelper.textRegular()
        txtEmail.font = FontHelper.textRegular()
        txtNewPassword.font = FontHelper.textRegular()
        txtConfirmPassword.font = FontHelper.textRegular()
        txtMobileNumber.font = FontHelper.textRegular()
        lblCountryCode.font = FontHelper.textRegular()
        btnSelectPhoto.titleLabel?.font = FontHelper.labelSmall()
        
//        btnSelectPhoto.setImage(UIImage(named: "edit_cameta_icon")?.imageWithColor(color: .themeColor), for: .normal)
        
        if preferenceHelper.getSocialId().isEmpty() {
            
        }else {
            btnChangePassword.isHidden = true
            txtNewPassword.isHidden = true
            txtConfirmPassword.isHidden = true
            txtNewPassword.isHidden = true
            btnShowHidePassword.isHidden = true
            btnShowHideConfirmPassword.isHidden = true
            viewForPassword.isHidden = true
            viewForConfirmPassword.isHidden = true
        }
        
        imgForRefral.image = UIImage.init(named: "share_icon")?.imageWithColor(color: UIColor.themeColor)
        lblForRefral.text =  "TXT_REFERRAL_CODE".localized + " " +  String(StoreSingleton.shared.store.referralCode) + "    "
        lblForRefral.font = FontHelper.textRegular()
        lblForRefral.textColor = UIColor.themeColor
        
        let tapReferral = UITapGestureRecognizer(target: self, action:#selector(tapReferral(gesture:)))
        viewForReferral.addGestureRecognizer(tapReferral)
        
    }
    
    @objc func tapReferral(gesture: UIGestureRecognizer){
        let myString = String(format: NSLocalizedString("SHARE_REFERRAL", comment: ""),String(StoreSingleton.shared.store.referralCode))
        
        let textToShare = [ myString ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    //MARK:- TextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        if textField == txtName {
            txtEmail.becomeFirstResponder()
        }else if textField == txtEmail {
            txtMobileNumber.becomeFirstResponder()
        }else if textField == txtMobileNumber {
            txtNewPassword.becomeFirstResponder()
        }else if textField == txtNewPassword {
            txtConfirmPassword.becomeFirstResponder()
        }else {
            textField.resignFirstResponder();
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtMobileNumber {
            if  (string == "") || string.count < 1 {
                return true
            }
            else if  (textField.text?.count)! >= preferenceHelper.getMaxMobileLength() {
                return false
            }
            
        }
        return true;
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtName {
            self.openLocalizedLanguagDialog()
            return false
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func openLocalizedLanguagDialog()
    {
        self.view.endEditing(true)
        let storeData:Store = StoreSingleton.shared.store;
        
        //Janki
        let dialogForLocalizedLanguage = CustomActiveLanguageDialog.showCustomLanguageDialog(languages: [:], title: txtName.placeholder ?? "",nameLang: storeData.nameLanguages, isFromProfile: true)
        dialogForLocalizedLanguage.onItemSelected = { (selectedArray) in
            
            print(selectedArray)
            var namelang = [String]()
            var count : Int = 0
            
            //According to Admin lang
            for i in 0...ConstantsLang.adminLanguages.count-1
            {
                count = 0
                for j in 0...selectedArray.count-1
                {
                    if Array(selectedArray.keys)[j] == ConstantsLang.adminLanguages[i].languageCode{
                        namelang.append(selectedArray[ConstantsLang.adminLanguages[i].languageCode]!)
                        count = 1
                    }
                }
                if count == 0{
                    namelang.append("")
                }
            }
            
            print(namelang)
            storeData.nameLanguages = namelang
            self.txtName.text = storeData.nameLanguages[ConstantsLang.AdminLanguageIndexSelected]
            
            dialogForLocalizedLanguage.removeFromSuperview()
        }
    }
    
    //MARK:- Action Methods
    
    @IBAction func onClickBtnChangePassword(_ sender: Any) {
        self.view.endEditing(true)
        if txtConfirmPassword.isHidden {
            txtNewPassword.isHidden = false
            txtConfirmPassword.isHidden = false
            btnShowHidePassword.isHidden = false
            btnShowHideConfirmPassword.isHidden = false
            viewForPassword.isHidden = false
            viewForConfirmPassword.isHidden = false
        }else {
            viewForConfirmPassword.isHidden = true
            viewForConfirmPassword.isHidden = true
            txtNewPassword.isHidden = true
            txtConfirmPassword.isHidden = true
            btnShowHidePassword.isHidden = true
            btnShowHideConfirmPassword.isHidden = true
            
        }
    }
    func onClickRightButton() {
        self.view.endEditing(true)
        editProfile()
        //        self.setRightBarItemImage(image: UIImage.init(named: "doneBlackIcon")!)
        //"TXT_SAVE".localized
        self.setRightBarItemImage(image: UIImage(named: "correct")!.imageWithColor(color: .themeColor)!, title: "", mode: .center)
//        self.setrightBarItemBG()
    }
    
    @IBAction func onClickDeleteAccount(_ sender: Any) {
        self.view.endEditing(true)
        
        let dialog = CustomAlertDialog.showCustomAlertDialog(title: "txt_delete_account".localized, message: "txt_are_you_sure_account_delete".localized, titleLeftButton: "", titleRightButton: "TXT_YES".localized)
        
        dialog.onClickLeftButton = {
            dialog.removeFromSuperview()
        }
        
        dialog.onClickRightButton = { [weak self] in
            guard let self = self else { return }
            dialog.removeFromSuperview()
            self.openVerifyAccountDialog(isDelete: true)
        }
    }

    @IBAction func editImageButtonClicked(_ sender: UIButton){
        openImageDialog()
    }

    //MARK: - User Define Methods
    func checkValidation() -> Bool{
        let validPassword = txtNewPassword.text!.checkPasswordValidation()
        let validPhoneNo = txtMobileNumber.text!.isValidMobileNumber()
        let validEmail = txtEmail.text!.checkEmailValidation()

        if ((txtName.text?.count)! < 1 || (txtEmail.text?.count)! < 1 || (txtMobileNumber.text?.count)! < 1) {
            if ((txtName.text?.count)! < 1) {
                Utility.showToast(message: "MSG_PLEASE_ENTER_VALID_NAME".localized)
                txtName.becomeFirstResponder();
            } else if ((txtEmail.text?.count)! < 1) {
                Utility.showToast(message: "MSG_PLEASE_ENTER_EMAIL".localized)
                txtEmail.becomeFirstResponder()
            } else if ((txtMobileNumber.text?.count)! < 1) {
                Utility.showToast(message: "MSG_PLEASE_ENTER_MOBILE_NUMBER".localized)
                txtMobileNumber.becomeFirstResponder();
            } else {}
            return false;
        } else {
            if(validEmail.0 == false) {
                Utility.showToast(message: validEmail.1)
                txtEmail.becomeFirstResponder()
                return false
            } else if (validPhoneNo.0 == false) {
                Utility.showToast(message:validPhoneNo.1)
                txtMobileNumber.becomeFirstResponder()
                return false
            } else {
                if ((txtNewPassword.text?.count)! < 1 && (txtConfirmPassword.text?.count)! < 1) {
                    return true
                } else if validPassword.0 == false {
                    Utility.showToast(message:validPassword.1)
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
    }

    var isUserinteractionEnable : Bool = false

    func enableTextFields(enable:Bool) -> Void {
        txtName.isEnabled = enable
        if preferenceHelper.getSocialId().isEmpty() {
            txtEmail.isEnabled = enable
        } else {
            txtEmail.isEnabled = false
        }
        
        txtMobileNumber.isEnabled = enable
        txtNewPassword.isEnabled = enable
        txtConfirmPassword.isEnabled = enable
        btnChangePassword.isEnabled = enable
        btnSelectPhoto.isEnabled = enable
//        self.view.isUserInteractionEnabled = enable
        isUserinteractionEnable = enable
    }
    
    func setProfileData() {
        let storeData:Store = StoreSingleton.shared.store;
        txtName.text = storeData.name
        txtMobileNumber.text = storeData.phone
        lblCountryCode.text = storeData.countryPhoneCode
        txtEmail.text = storeData.email
        imgProfilePic.downloadedFrom(link: storeData.imageUrl, placeHolder: "profile_placeholder")
        txtNewPassword.isHidden = true
        txtConfirmPassword.isHidden = true
        btnShowHidePassword.isHidden = true
        btnShowHideConfirmPassword.isHidden = true
        viewForPassword.isHidden = true
        viewForConfirmPassword.isHidden = true
        enableTextFields(enable: false)
        
        let image = UIImage.init(named: "edit")!.imageWithColor(color: .themeColor)!
        self.setRightBarItemImage(image: image)
//        self.setRightBarItemImage(image: UIImage.init(named: "editBlackIcon")!, title: "TXT_EDIT".localized, mode: .center)
//        self.setrightBarItemBG()
    }

    func editProfile() -> Void {
        if (!isUserinteractionEnable) {
            enableTextFields(enable: true)
            //Janki
            //txtName.becomeFirstResponder()
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

    // MARK:- Dialog Methods
    func checkWhichOtpValidationON() -> Int{
        if (checkEmailVerification() && checkPhoneNumberVerification()) {
            return CONSTANT.SMS_AND_EMAIL_VERIFICATION_ON;
        }else if (checkPhoneNumberVerification()) {
            return CONSTANT.SMS_VERIFICATION_ON;
        }else if (checkEmailVerification()) {
            return CONSTANT.EMAIL_VERIFICATION_ON;
        }
        return 0;
    }
    
    func checkEmailVerification() -> Bool{
        return preferenceHelper.getIsEmailVerification() && !(txtEmail.text!.compare(preferenceHelper.getEmail()) == ComparisonResult.orderedSame)
    }
    
    func checkPhoneNumberVerification() -> Bool{
        return preferenceHelper.getIsPhoneNumberVerification() && !(txtMobileNumber.text!.compare(preferenceHelper.getPhoneNumber()) == ComparisonResult.orderedSame)
    }
    
    func openVerifyAccountDialog(isDelete: Bool = false) {
        if !preferenceHelper.getSocialId().isEmpty() {
            self.password = ""
            if isDelete {
                self.wsDeleteAccount()
            } else {
                self.wsUpdateProfile()
            }
        } else {
            let dialogForVerification = CustomVerificationDialog.showCustomVerificationDialog(title: "TXT_VERIFY_ACCOUNT".localized, message: "MSG_PLEASE_ENTER_CURRENT_PASSWORD".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_OK".localized, editTextOneHint: "TXT_PASSWORD".localized, editTextTwoHint: "", isEdiTextTwoIsHidden: true, editTextOneInputType: true)
            dialogForVerification.onClickLeftButton = {
                [unowned dialogForVerification, unowned self] in
                dialogForVerification.removeFromSuperview();
            }
            dialogForVerification.onClickRightButton = { [unowned dialogForVerification, unowned self] (text1:String,text2:String) in
                let validPassword = text1.checkPasswordValidation()
                if validPassword.0 == false{
                    Utility.showToast(message: validPassword.1)
                }
                else {
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

    func openImageDialog() {
        dialogForImage = CustomPhotoDialog.showPhotoDialog("TXT_SELECT_IMAGE".localized, andParent: self)
        self.dialogForImage?.onImageSelected = {
            [unowned self] (image:UIImage) in
            self.imgProfilePic.image = image
            self.isPicAdded = true
        }
    }

    func wsUpdateProfile() {
        Utility.showLoading()
        
        let storeData:Store = StoreSingleton.shared.store;
        print(storeData.nameLanguages)
        
        let dictParam : [String : Any] =
            [
                //PARAMS.NAME : txtName.text! ,
                PARAMS.NAME : storeData.nameLanguages ,
                PARAMS.EMAIL      : txtEmail.text!  ,
                PARAMS.OLD_PASSWORD: password  ,
                PARAMS.NEW_PASSWORD: txtNewPassword.text ?? "",
                PARAMS.COUNTRY_PHONE_CODE  :lblCountryCode.text ?? "" ,
                PARAMS.PHONE : txtMobileNumber.text! ,
                PARAMS.DEVICE_TYPE: CONSTANT.IOS,
                PARAMS.DEVICE_TOKEN:preferenceHelper.getDeviceToken(),
                PARAMS.SERVER_TOKEN: preferenceHelper.getSessionToken(),
                PARAMS.STORE_ID: preferenceHelper.getUserId(),
                PARAMS.SOCIAL_ID: preferenceHelper.getSocialId(),
                PARAMS.IS_PHONE_NUMBER_VERIFIED:String(preferenceHelper.getIsPhoneNumberVerified()),
                PARAMS.IS_EMAIL_VERIFIED:String(preferenceHelper.getIsEmailVerified()),
        ]
        
        print(Utility.conteverDictToJson(dict: dictParam))
        let alamoFire:AlamofireHelper = AlamofireHelper();
        
        if isPicAdded {
            alamoFire.getResponseFromURL(url: WebService.WS_UPDATE_STORE, paramData: dictParam, image: imgProfilePic.image!, block: { (response, error) -> (Void) in
                
                print(response)
                
                Utility.hideLoading()
                Parser.parseUserStorageData(response: response, completion: { result in
                    if result{
                        if let messageCode = response["message"] as? Int {
                            let messageCode:String = "MSG_CODE_" + String(messageCode)
                            Utility.showToast(message:messageCode.localized);
                        }
                        
                        self.navigationController?.popViewController(animated: true)
                        
                    }
                }
                )
            })
        }else {
            alamoFire.getResponseFromURL(url: WebService.WS_UPDATE_STORE, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
                Utility.hideLoading()
                
                print(response)
                
                Parser.parseUserStorageData(response: response, completion: { result in
                    if result{
                        if let messageCode = response["message"] as? Int {
                            let messageCode:String = "MSG_CODE_" + String(messageCode)
                            Utility.showToast(message:messageCode.localized);
                        }
                        
                        self.navigationController?.popViewController(animated: true)
                    }
                })
            }
        }
    }

    func openOTPVerifyDialog(otpEmailVerification:String, otpSmsVerification:String,editTextOneHint:String, ediTextTwoHint:String, isEditTextTwoIsHidden:Bool, otp_id:String, params:[String:Any]) {
        let dialogForVerification = CustomVerificationDialog.showCustomVerificationDialog(title: "TXT_VERIFY_ACCOUNT".localizedCapitalized, message: "MSG_VERIFY_DETAIL".localizedCapitalized, titleLeftButton: "TXT_CANCEL".localizedUppercase, titleRightButton: "TXT_OK".localizedUppercase, editTextOneHint: editTextOneHint, editTextTwoHint:ediTextTwoHint, isEdiTextTwoIsHidden: isEditTextTwoIsHidden, isForVerifyOtp: true, params: params)
        dialogForVerification.startTimer()
        dialogForVerification.onClickRightButton = {  [unowned dialogForVerification, unowned self] (text1:String, text2:String) in
            switch (self.checkWhichOtpValidationON()) {
                
            case CONSTANT.SMS_AND_EMAIL_VERIFICATION_ON:
                self.wsGetOtpVerify(otpID: otp_id, emailOTP: text1, smsOtp: text2, dialogForVerification: dialogForVerification)
                /*
                 if (text1.compare(otpEmailVerification) == ComparisonResult.orderedSame && text2.compare(otpSmsVerification) == ComparisonResult.orderedSame ) {
                 dialogForVerification.removeFromSuperview()
                 preferenceHelper.setIsEmailVerified(true);
                 preferenceHelper.setIsPhoneNumberVerified(true);
                 self.openVerifyAccountDialog();
                 }
                 else {
                 if !(text1.compare(otpEmailVerification) == ComparisonResult.orderedSame)
                 {
                 Utility.showToast(message: "MSG_EMAIL_OTP_WRONG".localized)
                 }
                 else if !(text2.compare(otpSmsVerification) == ComparisonResult.orderedSame)
                 {Utility.showToast(message: "MSG_SMS_OTP_WRONG".localized)
                 }
                 
                 }*/
                break;
            case CONSTANT.SMS_VERIFICATION_ON:
                self.wsGetOtpVerify(otpID: otp_id, emailOTP: "", smsOtp: text1, dialogForVerification: dialogForVerification)
                /* if (text1.compare(otpSmsVerification) == ComparisonResult.orderedSame) {
                 dialogForVerification.removeFromSuperview()
                 
                 preferenceHelper.setIsPhoneNumberVerified(true);
                 self.openVerifyAccountDialog();
                 }
                 else {
                 Utility.showToast(message: "MSG_SMS_OTP_WRONG".localized)
                 }
                 */
                break;
            case CONSTANT.EMAIL_VERIFICATION_ON:
                self.wsGetOtpVerify(otpID: otp_id, emailOTP: text1, smsOtp: "", dialogForVerification: dialogForVerification)
                /*
                 if (text1.compare(otpEmailVerification) == ComparisonResult.orderedSame) {
                 preferenceHelper.setIsEmailVerified(true);
                 dialogForVerification.removeFromSuperview()
                 self.openVerifyAccountDialog();
                 }
                 else {
                 Utility.showToast(message: "MSG_EMAIL_OTP_WRONG".localized)
                 }*/
                break;
                
            default:
                self.openVerifyAccountDialog();
                break;
            }
        }
        dialogForVerification.onClickLeftButton = {
            [unowned dialogForVerification, unowned self] in
            dialogForVerification.removeFromSuperview();
        }
    }

    func wsGenerateOtp(_ dictParam:[String:Any]) {
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_GENERATE_OTP, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            if Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true) {
                let otpResponse:OtpResponse = OtpResponse.init(fromDictionary: response)
                print(otpResponse)
                switch (self.checkWhichOtpValidationON()) {
                case CONSTANT.SMS_AND_EMAIL_VERIFICATION_ON:
                    self.openOTPVerifyDialog(otpEmailVerification: otpResponse.otpForEmail ?? "", otpSmsVerification: otpResponse.otpForSms ?? "", editTextOneHint:"TXT_EMAIL_OTP".localized, ediTextTwoHint: "TXT_PHONE_OTP".localized, isEditTextTwoIsHidden: false,otp_id: otpResponse.otpID, params: dictParam)
                    break;
                case CONSTANT.SMS_VERIFICATION_ON:
                    self.openOTPVerifyDialog(otpEmailVerification: otpResponse.otpForEmail ?? "", otpSmsVerification: otpResponse.otpForSms ?? "", editTextOneHint:"TXT_PHONE_OTP".localized, ediTextTwoHint: "TXT_PHONE_OTP".localized, isEditTextTwoIsHidden: true,otp_id: otpResponse.otpID, params: dictParam)
                    break;
                case CONSTANT.EMAIL_VERIFICATION_ON:
                    self.openOTPVerifyDialog(otpEmailVerification: otpResponse.otpForEmail ?? "", otpSmsVerification: otpResponse.otpForSms ?? "", editTextOneHint:"TXT_EMAIL_OTP".localized, ediTextTwoHint: "TXT_PHONE_OTP".localized, isEditTextTwoIsHidden: true,otp_id: otpResponse.otpID, params: dictParam)
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
                PARAMS.STORE_ID : preferenceHelper.getUserId(),
                PARAMS.SERVER_TOKEN: preferenceHelper.getSessionToken(),
                PARAMS.PASS_WORD: self.password,
                PARAMS.SOCIAL_ID : preferenceHelper.getSocialId()
        ]
        
        let alamoFire:AlamofireHelper = AlamofireHelper();
        
        alamoFire.getResponseFromURL(url: WebService.WS_DELETE_ACCOUNT, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Utility.hideLoading()
            
            if Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: false) {
                APPDELEGATE.removeFirebaseTokenAndTopic()
                preferenceHelper.setSessionToken("")
                preferenceHelper.setUserId("")
                APPDELEGATE.goToHome()
                StoreSingleton.shared.cart.removeAll()
            }
        }
    }

    func openConfirmationDialog() {
        let validEmail = txtEmail.text!.checkEmailValidation()
        var dictParam : [String : Any] =
            [PARAMS.TYPE : CONSTANT.TYPE_STORE,
             PARAMS.ID :preferenceHelper.getUserId()
        ]
        switch (self.checkWhichOtpValidationON()) {
            
        case CONSTANT.SMS_AND_EMAIL_VERIFICATION_ON:
            preferenceHelper.setTempEmail(self.txtEmail.text!)
            preferenceHelper.setTempPhoneNumber(txtMobileNumber.text!)
            dictParam.updateValue(txtEmail.text!, forKey: PARAMS.EMAIL)
            dictParam.updateValue(txtMobileNumber.text!, forKey: PARAMS.PHONE)
            dictParam.updateValue(preferenceHelper.getPhoneCountryCode(), forKey: PARAMS.COUNTRY_PHONE_CODE)
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
            }
            else {
                Utility.showToast(message: validEmail.1);
            }
            
            break;
        default:
            self.openVerifyAccountDialog()
        }
    }
    
    func wsGetOtpVerify(otpID:String,emailOTP:String,smsOtp:String,dialogForVerification:CustomVerificationDialog){
        Utility.showLoading()
        let dictParam : [String : Any] =
            [PARAMS.OTP_ID:otpID,
             PARAMS.EMAIL_OTP : emailOTP,
             PARAMS.SMS_OTP:smsOtp]
        
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_OTP_VERFICATION, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Utility.hideLoading()
            if  Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true) {
                
                switch (self.checkWhichOtpValidationON()) {
                case CONSTANT.SMS_AND_EMAIL_VERIFICATION_ON:
                    preferenceHelper.setIsEmailVerified(true)
                    preferenceHelper.setIsPhoneNumberVerified(true)
                    dialogForVerification.removeFromSuperview()
                    self.openVerifyAccountDialog()
                    break;
                    
                case CONSTANT.SMS_VERIFICATION_ON:
                    dialogForVerification.removeFromSuperview()
                    preferenceHelper.setIsPhoneNumberVerified(true);
                    self.openVerifyAccountDialog();
                    break;
                    
                case CONSTANT.EMAIL_VERIFICATION_ON:
                    preferenceHelper.setIsEmailVerified(true);
                    dialogForVerification.removeFromSuperview()
                    self.openVerifyAccountDialog();
                    
                    break;
                default:
                    self.openVerifyAccountDialog()
                }
            }
        }
    }
}
