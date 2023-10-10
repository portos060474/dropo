//
//  BankDetailVC.swift
//  edelivery
//
//  Created by Elluminati on 28/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class BankDetailVC: BaseVC,UITextFieldDelegate {

    //MARK:- Outlets Declaration
    @IBOutlet weak var scrBankDetail: UIScrollView!
    @IBOutlet weak var stkvwImages: UIStackView!
    @IBOutlet weak var vwAccountNumber: UIView!
    @IBOutlet weak var txtAccountNumber: UITextField!
    @IBOutlet weak var vwAccountHolderName: UIView!
    @IBOutlet weak var txtAccountHolderName: UITextField!
    @IBOutlet weak var vwRoutingNumber: UIView!
    @IBOutlet weak var txtRoutingNumber: UITextField!
    @IBOutlet weak var vwPersonalIdNumber: UIView!
    @IBOutlet weak var txtPersonalIdNumber: UITextField!
    @IBOutlet weak var vwDob: UIView!
    @IBOutlet weak var txtDob: UITextField!
    @IBOutlet weak var vwGender: UIView!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var vwAddress: UIView!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var vwPostalCode: UIView!
    @IBOutlet weak var txtPostalCode: UITextField!
    @IBOutlet weak var txtStateCode: CustomTextView!
    @IBOutlet weak var lblStateCode: TextLabel!
    @IBOutlet weak var vwStateCode: UIView!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var lblFrontImg: UILabel!
    @IBOutlet weak var lblBackImg: UILabel!
    @IBOutlet weak var lblAdditionalImg: UILabel!
    @IBOutlet weak var lblAccountHolderName: UILabel!
    @IBOutlet weak var lblAccountNumber: UILabel!
    @IBOutlet weak var lblRoutingNumber: UILabel!
    @IBOutlet weak var lblPersonalIdNumber: UILabel!
    @IBOutlet weak var lblDob: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblPostalCode: UILabel!
    @IBOutlet weak var stkForGender: UIStackView!
    @IBOutlet weak var viewForSave: UIView!
    @IBOutlet weak var btnSave :UIButton!
    @IBOutlet weak var height : NSLayoutConstraint!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewForDOB : UIView!
    @IBOutlet weak var viewForPersonalID : UIView!
    @IBOutlet weak var imageForCalendar : UIImageView!
    @IBOutlet weak var btnAddImage: UIButton!
    @IBOutlet weak var imgFront: UIImageView!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var imgAdditional: UIImageView!
    
    var setData:presentDataSet?
    var isPicAddedBack:Bool = false
    var isPicAddedFront:Bool = false
    var isPicAddedAdditional:Bool = false
    var password:String = ""
    var bankDetail:BankDetail? = nil
    var dialogForImage:CustomPhotoDialog?;
    var paymentID:String = ""

    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalization()
        self.alertView.isHidden = true
        if self.paymentID == Payment.PAYSTACK {
            height.constant = 500
        } else {
            height.constant = (UIScreen.main.bounds.height - (50 + UIApplication.shared.statusBarFrame.height))
        }
        enableTextFields(enable: true)
        if (bankDetail != nil) {
            setBankData()
        }
    }

    override func updateUIAccordingToTheme() {
        self.setLocalization()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.alertView.updateConstraints()
        self.view.animationBottomTOTop(self.alertView)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews();
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        self.alertView.updateConstraintsIfNeeded()
        self.alertView.roundCorner(corners: [.topRight , .topLeft], withRadius: 20)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    func setLocalization() {
        /*set colors*/
        self.view.backgroundColor = UIColor.themeOverlayColor
        self.scrBankDetail.backgroundColor = UIColor.themeViewBackgroundColor;
        txtAccountNumber.textColor = UIColor.themeTextColor
        txtAccountHolderName.textColor = UIColor.themeTextColor
        txtRoutingNumber.textColor = UIColor.themeTextColor
        txtPersonalIdNumber.textColor = UIColor.themeTextColor
        txtDob.textColor = UIColor.themeTextColor
        txtGender.textColor = UIColor.themeTextColor
        txtAddress.textColor = UIColor.themeTextColor
        txtStateCode.textColor = UIColor.themeTextColor
        txtPostalCode.textColor = UIColor.themeTextColor
        btnFemale.tintColor = UIColor.themeTextColor
        btnMale.titleLabel?.textColor = UIColor.themeTextColor
        btnMale.isSelected = true
        btnFemale.isSelected = !btnMale.isSelected
        lblFrontImg.textColor = .themeTextColor
        lblBackImg.textColor = .themeTextColor
        lblAdditionalImg.textColor = .themeTextColor
        btnMale.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnMale.setTitleColor(UIColor.themeTextColor, for: .selected)
        btnFemale.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnFemale.setTitleColor(UIColor.themeTextColor, for: .selected)
        btnMale.setImage(UIImage.init(named: "radio_btn_unchecked_icon")?.imageWithColor(color: .themeLightTextColor), for: .normal)
        btnMale.setImage(UIImage.init(named: "radio_btn_checked_icon")?.imageWithColor(), for: .selected)
        btnFemale.setImage(UIImage.init(named: "radio_btn_unchecked_icon")?.imageWithColor(color: .themeLightTextColor), for: .normal)
        btnFemale.setImage(UIImage.init(named: "radio_btn_checked_icon")?.imageWithColor(), for: .selected)
        imageForCalendar.image = UIImage.init(named: "calender_white")?.imageWithColor(color: .themeIconTintColor)
        stkForGender.backgroundColor = .themeViewBackgroundColor
        imgBack.image = UIImage.init(named: "add_image")
        imgFront.image = UIImage.init(named: "add_image")
        imgAdditional.image = UIImage.init(named: "add_image")//?.imageWithColor(color: .themeIconTintColor)
        imgBack.setRound(withBorderColor: .themeLightTextColor, andCornerRadious: 0.01, borderWidth: 0.5)
        imgFront.setRound(withBorderColor: .themeLightTextColor, andCornerRadious: 0.01, borderWidth: 0.5)
        imgAdditional.setRound(withBorderColor: .themeLightTextColor, andCornerRadious: 0.01, borderWidth: 0.5)
        btnClose.setImage(UIImage.init(named: "cancel_icon")?.imageWithColor(), for: .normal)

        /*Set Text*/
        title  = ""
        txtAccountNumber.placeholder = ""
        txtAccountHolderName.placeholder =  ""
        txtRoutingNumber.placeholder = ""
        txtPersonalIdNumber.placeholder = ""
        txtDob.placeholder = ""
        txtGender.placeholder = ""
        txtAddress.placeholder = ""
        txtPostalCode.placeholder = ""
        txtStateCode.placeholder = ""
        txtGender.text = "TXT_MALE".localized
        lblFrontImg.text = "TXT_PHOTO_ID_FRONT".localized
        lblAccountNumber.text = "TXT_ACCOUNT_NUMBER".localized
        lblAccountHolderName.text =  "TXT_ACCOUNT_HOLDER_NAME".localized
        lblRoutingNumber.text = "TXT_ROUTING_NUMBER".localized
        lblPersonalIdNumber.text = "TXT_PERSONAL_ID_NUMBER".localized
        lblDob.text = "TXT_DOB".localizedCapitalized
        lblGender.text = "TXT_GENDER".localized
        lblAddress.text = "TXT_ADDRESS".localized
        lblPostalCode.text = "TXT_POSTALCODE".localized
        lblStateCode.text = "STATE".localized
        lblBackImg.text = "TXT_PHOTO_ID_BACK".localized
        lblAdditionalImg.text = "TXT_PHOTO_ID_ADDITIONAL".localized
        btnFemale.setTitle(" \("TXT_FEMALE".localized)", for: .normal)
        btnMale.setTitle(" \("TXT_MALE".localized)", for: .normal)
        lblTitle.text = "TXT_BANK_DETAILS".localizedCapitalized
        btnSave.setTitle("TXT_SAVE".localized, for: .normal)

        /*Set Font*/
        txtAccountNumber.font = FontHelper.textRegular()
        txtAccountHolderName.font = FontHelper.textRegular()
        txtRoutingNumber.font = FontHelper.textRegular()
        txtPersonalIdNumber.font = FontHelper.textRegular()
        txtDob.font = FontHelper.textRegular()
        txtGender.font = FontHelper.textRegular()
        txtAddress.font = FontHelper.textRegular()
        txtPostalCode.font = FontHelper.textRegular()
        txtStateCode.font = FontHelper.textRegular()
        btnFemale.titleLabel?.font = FontHelper.labelRegular()
        btnMale.titleLabel?.font = FontHelper.labelRegular()
        lblFrontImg.font = FontHelper.textMedium(size: FontHelper.labelSmall)
        lblBackImg.font = FontHelper.textMedium(size: FontHelper.labelSmall)
        lblAdditionalImg.font = FontHelper.textMedium(size: FontHelper.labelSmall)
        viewForSave.backgroundColor = .themeViewBackgroundColor
        btnSave.tag = 0
        btnSave.addTarget(self, action: #selector(self.onClickSaveBtn), for: .touchUpInside)
        lblTitle.font = FontHelper.textLarge()
        lblTitle.textColor = UIColor.themeTitleColor
        self.view.backgroundColor = UIColor.themeOverlayColor
        alertView.backgroundColor = .themeAlertViewBackgroundColor
        btnClose.setTitleColor(UIColor.themeIconTintColor, for: .normal)
        btnClose.tintColor = UIColor.themeColor
        btnClose.setTitle("", for: .normal)
        btnMale.backgroundColor = .themeViewBackgroundColor
        btnFemale.backgroundColor = .themeViewBackgroundColor

        if self.paymentID == Payment.PAYSTACK {
            self.stkvwImages.isHidden = true
            self.vwPersonalIdNumber.isHidden = true
            self.vwDob.isHidden = true
            self.vwGender.isHidden = true
            self.vwAddress.isHidden = true
            self.vwPostalCode.isHidden = true
            self.vwStateCode.isHidden = true
            self.lblRoutingNumber.text = "TXT_BANK_CODE".localized
        }
    }

    @IBAction func onClickBtnClose(_ sender: Any) {
        self.view.backgroundColor = .clear
        self.dismiss(animated: true) {}
    }

    //MARK:- TextField Delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtDob {
            openDatePicker()
            return false
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.paymentID == Payment.PAYSTACK {
            if textField == txtAccountHolderName {
                txtAccountNumber.becomeFirstResponder()
            } else if textField == txtAccountNumber {
                txtRoutingNumber.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
                return true
            }
        } else {
            if textField == txtAccountHolderName {
                txtAccountNumber.becomeFirstResponder()
            } else if textField == txtAccountNumber {
                txtRoutingNumber.becomeFirstResponder()
            } else if textField == txtRoutingNumber {
                txtPersonalIdNumber.becomeFirstResponder();
            } else if textField == txtPersonalIdNumber {
                txtDob.becomeFirstResponder()
            } else if textField == txtDob {
                txtAddress.becomeFirstResponder()
            } else if textField == txtAddress {
                txtStateCode.becomeFirstResponder()
            }else if textField == txtStateCode{
                txtPostalCode.becomeFirstResponder()
            }
            else {
                textField.resignFirstResponder();
                return true
            }
        }
        return true
    }

    //MARK:- Action Methods
    @objc func onClickSaveBtn() {
        if self.btnSave.tag == 0 {
            if (checkValidation()) {
                if preferenceHelper.getSocialId().isEmpty {
                    openVerifyAccountDialog()
                } else {
                    self.wsAddBankDetail()
                }
            }
        } else {
            if preferenceHelper.getSocialId().isEmpty {
                openVerifyAccountDialog()
            } else {
                self.wsDeleteBankDetail()
            }
        }
    }

    func enableTextFields(enable:Bool) -> Void{
        self.view.isUserInteractionEnabled = enable
        txtAccountNumber.isEnabled = enable
        txtRoutingNumber.isEnabled = enable
        txtAccountHolderName.isEnabled = enable
        txtPersonalIdNumber.isEnabled = enable
        txtDob.isEnabled = enable
        txtAddress.isEnabled = enable
        txtPostalCode.isEnabled = enable
        txtStateCode.isEnabled = enable
    }

    @IBAction func onClickBtnMale(_ sender: Any) {
        self.btnMale.isSelected = !self.btnMale.isSelected
        self.btnFemale.isSelected = !self.btnMale.isSelected
        if btnMale.isSelected {
            txtGender.text = "TXT_MALE".localized
        } else {
            txtGender.text = "TXT_FEMALE".localized
        }
    }

    @IBAction func onClickBtnFemale(_ sender: Any) {
        self.btnFemale.isSelected = !self.btnFemale.isSelected
        self.btnMale.isSelected = !self.btnFemale.isSelected
        if !btnFemale.isSelected {
            txtGender.text = "TXT_MALE".localized
        } else {
            txtGender.text = "TXT_FEMALE".localized
        }
    }

    @IBAction func onClickBtnAddImage(_ sender: Any) {
        self.view.endEditing(true)
        dialogForImage = CustomPhotoDialog.showPhotoDialog("TXT_SELECT_IMAGE".localized, andParent: self)
        self.dialogForImage?.onImageSelected = {[unowned self] (image:UIImage) in
            self.isPicAddedBack = true;
            self.imgBack.image = image
            self.imgBack.contentMode = .scaleAspectFit
        }
    }

    @IBAction func onClickBtnFront(_ sender: Any) {
        self.view.endEditing(true)
        dialogForImage = CustomPhotoDialog.showPhotoDialog("TXT_SELECT_IMAGE".localized, andParent: self)
        self.dialogForImage?.onImageSelected = {[unowned self] (image:UIImage) in
            self.isPicAddedFront = true;
            self.imgFront.image = image
            self.imgFront.contentMode = .scaleAspectFit
        }
    }

    @IBAction func onClickBtnAdditional(_ sender: Any) {
        self.view.endEditing(true)
        dialogForImage = CustomPhotoDialog.showPhotoDialog("TXT_SELECT_IMAGE".localized, andParent: self)
        self.dialogForImage?.onImageSelected = {[unowned self] (image:UIImage) in
            self.isPicAddedAdditional = true;
            self.imgAdditional.image = image
            self.imgAdditional.contentMode = .scaleAspectFit
        }
    }

    //MARK:- User Define Methods
    func checkValidation() -> Bool {
        if self.paymentID == Payment.PAYSTACK {
            if ((txtAccountNumber.text?.isEmpty())! || (txtAccountHolderName.text?.isEmpty())! || (txtRoutingNumber.text?.isEmpty())!) {
                if (txtAccountHolderName.text?.isEmpty())! {
                    txtAccountHolderName.becomeFirstResponder();
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 , execute: {
                        Utility.showToast(message:"MSG_PLEASE_ENTER_ACCOUNT_HOLDER_NAME".localized)
                    })
                } else if (txtAccountNumber.text?.isEmpty())! {
                    txtAccountNumber.becomeFirstResponder()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 , execute: {
                        Utility.showToast(message: "MSG_PLEASE_ENTER_ACCOUNT_NUMBER".localized)
                    })
                } else if (txtRoutingNumber.text?.isEmpty())! {
                    txtRoutingNumber.becomeFirstResponder();
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 , execute: {
                        Utility.showToast(message: "MSG_PLEASE_ENTER_BANK_CODE".localized)
                    })
                }
                return false;
            } else {
                return true
            }
        } else {
            if ((txtAccountNumber.text?.isEmpty())! || (txtAccountHolderName.text?.isEmpty())! || (txtRoutingNumber.text?.isEmpty())! || (txtPersonalIdNumber.text?.isEmpty())!  || (txtDob.text?.isEmpty())!) {
                if ((txtAccountHolderName.text?.count)! < 1) {
                    txtAccountHolderName.becomeFirstResponder();
                    Utility.showToast(message:"MSG_PLEASE_ENTER_ACCOUNT_HOLDER_NAME".localized)
                } else if ((txtAccountNumber.text?.count)! < 1) {
                    txtAccountNumber.becomeFirstResponder()
                    Utility.showToast(message: "MSG_PLEASE_ENTER_ACCOUNT_NUMBER".localized)
                } else if ((txtRoutingNumber.text?.count)! < 1) {
                    txtRoutingNumber.becomeFirstResponder();
                    Utility.showToast(message: "MSG_PLEASE_ENTER_ROUTING_NUMBER".localized)
                } else if ((txtPersonalIdNumber.text?.count)! < 1) {
                    txtPersonalIdNumber.becomeFirstResponder();
                    Utility.showToast(message: "MSG_PLEASE_ENTER_PERSONAL_ID_NUMBER".localized)
                } else if ((txtDob.text?.count)! < 1) {
                    txtDob.becomeFirstResponder();
                    Utility.showToast(message: "MSG_PLEASE_ENTER_DOB".localized)
                } else if (txtAddress.text?.isEmpty())! {
                    txtAddress.becomeFirstResponder();
                    Utility.showToast(message: "MSG_PLEASE_ENTER_ADDRESS".localized)
                }else if (txtStateCode.text?.isEmpty())!{
                    txtStateCode.becomeFirstResponder()
                    Utility.showToast(message: "MSG_ENTER_STATE".localized)
                }
                else if (txtPostalCode.text?.isEmpty())! {
                    txtPostalCode.becomeFirstResponder();
                    Utility.showToast(message: "MSG_PLEASE_ENTER_POSTALCODE".localized)
                }
                return false;
            } else {
                if (isPicAddedAdditional && isPicAddedBack && isPicAddedFront) {
                    return true
                } else {
                    Utility.showToast(message: "MSG_PLEASE_UPLOAD_PICTURE".localized)
                    return false;
                }
            }
        }
    }

    func openVerifyAccountDialog() {
        self.view.endEditing(true)
        let dialogForVerification = CustomVerificationDialog.showCustomVerificationDialog(title: "TXT_VERIFY_ACCOUNT".localized, message: "MSG_PLEASE_ENTER_CURRENT_PASSWORD".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_OK".localized, editTextOneHint: "TXT_PASSWORD".localized, editTextTwoHint: "", isEdiTextTwoIsHidden: true, editTextOneInputType: true)
        dialogForVerification.onClickLeftButton = { [unowned dialogForVerification] in
            dialogForVerification.removeFromSuperview();
        }
        dialogForVerification.onClickRightButton = { [unowned dialogForVerification, unowned self] (text1:String,text2:String) in
            let validPassword = text1.checkPasswordValidation()
            if validPassword.0 == false {
                Utility.showToast(message: validPassword.1)
            } else {
                self.password = text1
                if (self.btnSave.tag == 1) {
                    self.wsDeleteBankDetail()
                } else {
                    self.wsAddBankDetail();
                }
                dialogForVerification.removeFromSuperview();
            }
        }
    }

    func openErrorDialog(strMessage:String) {
        let dialogForNote = CustomAlertDialog.showCustomAlertDialog(title: "TXT_ERROR".localized, message: strMessage, titleLeftButton: "", titleRightButton: "TXT_OK".localizedUppercase)
        dialogForNote.onClickLeftButton =
        { [unowned dialogForNote] in
            dialogForNote.removeFromSuperview();
        }
        dialogForNote.onClickRightButton = {
            [unowned dialogForNote] in
            dialogForNote.removeFromSuperview();
        }
    }

    //MARK:- Web Service Call
    func wsAddBankDetail() {
        Utility.showLoading()
        var dictParam : [String : Any] = [:]
        if self.paymentID == Payment.STRIPE {
            var strGender : String = ""
            if btnMale.isSelected {
                strGender = "TXT_MALE".localized
            } else {
                strGender = "TXT_FEMALE".localized
            }

            dictParam = [
                PARAMS.BANK_ACCOUNT_HOLDER_NAME : txtAccountHolderName.text!,
                PARAMS.ACCOUNT_HOLDER_NAME : txtAccountHolderName.text!,
                PARAMS.BANK_ACCOUNT_NUMBER : txtAccountNumber.text!,
                PARAMS.BANK_ROUTING_NUMBER : txtRoutingNumber.text!,
                PARAMS.BANK_PERSONAL_ID_NUMBER   : txtPersonalIdNumber.text!,
                PARAMS.BANK_DOB : txtDob.text!,
                PARAMS.PASS_WORD: password,
                PARAMS.BANK_HOLDER_TYPE: String(CONSTANT.TYPE_PROVIDER),
                PARAMS.BANK_HOLDER_ID: preferenceHelper.getUserId(),
                PARAMS.SOCIAL_ID : preferenceHelper.getSocialId(),
                PARAMS.PROVIDER_ID: preferenceHelper.getUserId(),
                PARAMS.GENDER: strGender.lowercased(),
                PARAMS.ADDRESS: txtAddress.text!,
                PARAMS.POSTAL_CODE: txtPostalCode.text!,//"EC1A 1BB",
                PARAMS.ACCOUNT_HOLDER_TYPE : "individual",
                PARAMS.PAYMENT_ID : Payment.STRIPE,
                PARAMS.STATE:txtStateCode.text!
            ]
        } else {
            dictParam = [
                PARAMS.BANK_ACCOUNT_HOLDER_NAME : txtAccountHolderName.text ?? "",
                PARAMS.ACCOUNT_HOLDER_NAME : txtAccountHolderName.text ?? "",
                PARAMS.BANK_ACCOUNT_NUMBER : self.txtAccountNumber.text ?? "",
                PARAMS.BANK_ROUTING_NUMBER : self.txtRoutingNumber.text ?? "",
                PARAMS.BANK_PERSONAL_ID_NUMBER : txtPersonalIdNumber.text ?? "",
                PARAMS.BANK_DOB : "",
                PARAMS.PAYMENT_ID : Payment.PAYSTACK,
                PARAMS.SERVER_TOKEN: preferenceHelper.getSessionToken(),
                PARAMS.PASS_WORD: password,
                PARAMS.PROVIDER_ID: preferenceHelper.getUserId(),
                PARAMS.BANK_HOLDER_TYPE: String(CONSTANT.TYPE_PROVIDER),
                PARAMS.BANK_HOLDER_ID: preferenceHelper.getUserId(),
                PARAMS.SOCIAL_ID : preferenceHelper.getSocialId(),
                PARAMS.ACCOUNT_HOLDER_TYPE : "individual"
            ]
        }
        print("dictParam ----- > WS_ADD_BANK_DETAIL - > \(Utility.conteverDictToJson(dict: dictParam))")

        let alamoFire:AlamofireHelper = AlamofireHelper.init()
        alamoFire.getResponseFromURLWithImages(url: WebService.WS_ADD_BANK_DETAIL, paramData: dictParam,imgParamData:["front","back","additional"],images: [imgFront.image,imgBack.image,imgAdditional.image], block: { (response, error) -> (Void) in
            print("response ----- > WS_ADD_BANK_DETAIL---> \(response)")
            if Parser.isSuccess(response: response, andErrorToast: false) {
                if let messageCode = response["message"] as? Int {
                    let messageCode:String = "MSG_CODE_" + String(messageCode)
                    Utility.showToast(message:messageCode.localized);
                }
                Utility.hideLoading()
                self.view.backgroundColor = .clear
                self.dismiss(animated: true) {
                    self.setData?.setData()
                }
            } else {
                Utility.hideLoading()
                self.openErrorDialog(strMessage: (response["stripe_error"] as? String) ?? "Error")
            }
        })
    }

    func wsDeleteBankDetail() {
        let dictParam : [String : Any] =
        [PARAMS.PASSWORD: password  ,
         PARAMS.BANK_HOLDER_TYPE: CONSTANT.TYPE_PROVIDER,
         PARAMS.PROVIDER_ID: preferenceHelper.getUserId(),
         PARAMS.BANK_DETAIL_ID : bankDetail?.id ?? "",
         PARAMS.SOCIAL_ID : preferenceHelper.getSocialId()
        ]

        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_DELETE_BANK_DETAIL, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            if Parser.isSuccess(response: response) {
                self.resetBankData()
            }
        }
    }

    func setBankData() {
        self.txtAccountNumber.text = "*******" + (bankDetail?.accountNumber)!
        self.txtAccountHolderName.text = bankDetail?.bankAccountHolderName
        self.txtPersonalIdNumber.text = ""
        self.txtRoutingNumber.text = bankDetail?.routingNumber
        self.txtDob.isHidden = true
        self.viewForDOB.isHidden = true
        self.txtPersonalIdNumber.isHidden = true
        self.viewForPersonalID.isHidden = true
        self.btnAddImage.isHidden = true
        btnSave.tag = 1
    }

    func resetBankData() {
        self.txtAccountNumber.text = ""
        self.txtAccountHolderName.text = ""
        self.txtPersonalIdNumber.text = ""
        self.txtRoutingNumber.text = ""
        self.txtDob.text = ""
        self.txtPersonalIdNumber.text = ""
        self.txtDob.text = ""
        self.txtAddress.text = ""
        self.txtPostalCode.text = ""
        
        self.btnAddImage.isHidden = false
        self.txtDob.isHidden = false
        self.txtPersonalIdNumber.isHidden = false
        self.txtPersonalIdNumber.isHidden = false
        self.viewForPersonalID.isHidden = false
        self.btnAddImage.isHidden = false
        btnSave.tag = 1
    }

    func openDatePicker() {
        self.view.endEditing(true)
        let gregorian: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let currentDate: Date = Date()
        var components: DateComponents = DateComponents()
        components.year = -13
        let maxDate: Date = gregorian.date(byAdding: components as DateComponents, to: currentDate, options: NSCalendar.Options(rawValue: 0))!

        let datePickerDialog: CustomDatePickerDialog = CustomDatePickerDialog.showCustomDatePickerDialog(title: "TXT_SELECT_DOB_DATE".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_SELECT".localized)

        datePickerDialog.setMaxDate(maxdate: maxDate)
        datePickerDialog.onClickLeftButton = { [unowned datePickerDialog] in
            datePickerDialog.removeFromSuperview()
        }

        datePickerDialog.onClickRightButton = { [unowned datePickerDialog, unowned self] (selectedDate:Date) in
            self.txtDob.text = Utility.dateToString(date: selectedDate, withFormat: DATE_CONSTANT.DD_MM_YYYY)
            datePickerDialog.removeFromSuperview()
        }
    }
}

protocol presentDataSet {
    func setData()
}
