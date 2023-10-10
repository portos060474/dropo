//
//  BankDetailVC.swift
//  edelivery
//
//  Created by Elluminati on 28/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class BankDetailVC: BaseVC,RightDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate {

    //MARK:- Outlets Declaration
    @IBOutlet weak var scrBankDetail: UIScrollView!
    @IBOutlet weak var stkvwImages: UIStackView!
    @IBOutlet weak var txtAccountNumber: UITextField!
    @IBOutlet weak var txtAccountHolderName: UITextField!
    @IBOutlet weak var txtRoutingNumber: UITextField!
    @IBOutlet weak var txtPersonalIdNumber: UITextField!
    @IBOutlet weak var txtDob: UITextField!
    @IBOutlet weak var vwGender: UIView!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtPostalCode: UITextField!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var lblFrontImg: UILabel!
    @IBOutlet weak var lblBackImg: UILabel!
    @IBOutlet weak var lblAdditionalImg: UILabel!

    @IBOutlet weak var txtStateCode: UITextField!
    var isPicAddedBack:Bool = false
    var isPicAddedFront:Bool = false
    var isPicAddedAdditional:Bool = false

    var password:String = ""
    var bankDetail:BankDetail? = nil
    var dialogForImage:CustomPhotoDialog?;

    var setData:presentDataSet?
    var paymentID:String = ""

    @IBOutlet weak var btnAddImage: UIButton!
    @IBOutlet weak var imgFront: UIImageView!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var imgAdditional: UIImageView!

    @IBOutlet weak var btnSave :UIButton!
    @IBOutlet weak var height : NSLayoutConstraint!

    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var lblTitle: UILabel!

    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        delegateRight = self
        setLocalization()
        self.alertView.isHidden = true

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gestureRecognizer:)))
        gestureRecognizer.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)

        print("height => ",(UIScreen.main.bounds.height - (70 + UIApplication.shared.statusBarFrame.height)))
        enableTextFields(enable: true)
        super.button.tag = 0
        self.btnAddImage.isHidden = false
        if (bankDetail != nil) {
            setBankData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.paymentID == Payment.PAYSTACK {
            height.constant = 500
        } else {
            if (UIScreen.main.bounds.height - (70 + UIApplication.shared.statusBarFrame.height)) < 850 {
                height.constant = (UIScreen.main.bounds.height - (70 + UIApplication.shared.statusBarFrame.height))
            } else {
                height.constant = 850
            }
        }
        self.alertView.updateConstraints()
        self.view.animationBottomTOTop(self.alertView)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews();
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        //imgFront.setRound()
        //imgBack.setRound()
        //imgAdditional.setRound()
        imgBack.layer.borderWidth = 0.5
        imgBack.layer.borderColor = UIColor.themeLightTextColor.cgColor
        imgBack.clipsToBounds = true;
        imgFront.layer.borderWidth = 0.5
        imgFront.layer.borderColor = UIColor.themeLightTextColor.cgColor
        imgFront.clipsToBounds = true;
        imgAdditional.layer.borderWidth = 0.5
        imgAdditional.layer.borderColor = UIColor.themeLightTextColor.cgColor
        imgAdditional.clipsToBounds = true;
        self.alertView.updateConstraintsIfNeeded()
        self.alertView.applyTopCornerRadius()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    func setLocalization() {
        self.setRightBarItem(isNative: false)

        /*set colors*/
        self.view.backgroundColor = UIColor.themeViewBackgroundColor;
        self.scrBankDetail.backgroundColor = UIColor.themeViewBackgroundColor;
        txtAccountNumber.textColor = UIColor.themeTextColor
        txtAccountHolderName.textColor = UIColor.themeTextColor
        txtRoutingNumber.textColor = UIColor.themeTextColor
        txtPersonalIdNumber.textColor = UIColor.themeTextColor
        txtDob.textColor = UIColor.themeTextColor
        txtGender.textColor = UIColor.themeTextColor
        txtAddress.textColor = UIColor.themeTextColor
        txtPostalCode.textColor = UIColor.themeTextColor
        txtStateCode.textColor = UIColor.themeTextColor
        btnFemale.tintColor = UIColor.themeTextColor
        btnMale.titleLabel?.textColor = UIColor.themeTextColor
        btnMale.isSelected = true
        btnFemale.isSelected = !btnMale.isSelected
        txtGender.text = "TXT_GENDER".localized
        lblFrontImg.text = "TXT_PHOTO_ID_FRONT".localized
        lblBackImg.text = "TXT_PHOTO_ID_BACK".localized
        lblAdditionalImg.text = "TXT_PHOTO_ID_ADDITIONAL".localized

        btnFemale.setTitle(" \("TXT_FEMALE".localized)", for: .normal)
        btnMale.setTitle(" \("TXT_MALE".localized)", for: .normal)
//        self.setRightBarItemImage(image: UIImage.init(named: "doneBlackIcon")!)
//        self.setRightBarItemImage(image: UIImage(), title: "TXT_SAVE".localized, mode: .center)
//        self.setrightBarItemBG()
        self.setRightBarItemImage(image: UIImage(named: "correct")!.imageWithColor(color: .themeColor)!, title: "", mode: .center)

        /*Set Text*/
        title  = "TXT_BANK_DETAILS".localized

        txtAccountNumber.placeholder = "TXT_ACCOUNT_NUMBER".localized
        txtAccountHolderName.placeholder =  "TXT_ACCOUNT_HOLDER_NAME".localized
        txtRoutingNumber.placeholder = "TXT_ROUTING_NUMBER".localized
        txtGender.placeholder = "TXT_GENDER".localized
        txtAddress.placeholder = "TXT_ADDRESS".localized
        txtPostalCode.placeholder = "TXT_POSTALCODE".localized
        txtStateCode.placeholder = "STATE".localized
        txtPersonalIdNumber.placeholder = "TXT_PERSONAL_ID_NUMBER".localized
        txtDob.placeholder = "TXT_DOB".localizedCapitalized
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

        lblTitle.text = "TXT_BANK_DETAILS".localizedCapitalized
        lblTitle.font = FontHelper.textLarge()
        lblTitle.textColor = UIColor.themeTitleColor

        self.view.backgroundColor = UIColor.themeOverlayColor
        alertView.backgroundColor = UIColor.themeViewBackgroundColor;
        self.alertView.updateConstraintsIfNeeded()
        self.alertView.applyTopCornerRadius()

        btnClose.setTitle("", for: .normal)
        btnClose.tintColor = UIColor.themeColor
        btnClose.setTitle("", for: .normal)
        btnClose.setImage(UIImage.init(named: "cross")?.imageWithColor(color: .themeColor), for: .normal)

        btnSave.setTitle("TXT_SAVE".localized, for: .normal)
        btnSave.tag = 0
        btnSave.addTarget(self, action: #selector(self.onClickSaveBtn), for: .touchUpInside)
        imgBack.contentMode = .center
        imgFront.contentMode = .center
        imgAdditional.contentMode = .center
        btnFemale.tintColor = UIColor.themeTextColor
        btnMale.tintColor = UIColor.themeTextColor
        btnMale.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnMale.setTitleColor(UIColor.themeTextColor, for: .selected)
        btnFemale.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnFemale.setTitleColor(UIColor.themeTextColor, for: .selected)

        btnMale.setImage(UIImage.init(named: "radio_btn_unchecked_icon")?.imageWithColor(color: .themeLightTextColor), for: .normal)
        btnMale.setImage(UIImage.init(named: "radio_btn_checked_icon")?.imageWithColor(color: .themeColor), for: .selected)
        btnFemale.setImage(UIImage.init(named: "radio_btn_unchecked_icon")?.imageWithColor(color: .themeLightTextColor), for: .normal)
        btnFemale.setImage(UIImage.init(named: "radio_btn_checked_icon")?.imageWithColor(color: .themeColor), for: .selected)

        txtDob.borderStyle = .roundedRect
        txtGender.borderStyle = .roundedRect
        txtAddress.borderStyle = .roundedRect
        txtPostalCode.borderStyle = .roundedRect
        txtStateCode.borderStyle = .roundedRect
        txtAccountNumber.borderStyle = .roundedRect
        txtRoutingNumber.borderStyle = .roundedRect
        txtPersonalIdNumber.borderStyle = .roundedRect
        txtAccountHolderName.borderStyle = .roundedRect

        lblBackImg.textColor = .themeTextColor
        lblFrontImg.textColor = .themeTextColor
        lblAdditionalImg.textColor = .themeTextColor

        /*let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.txtAccountHolderName.frame.height))
        txtAccountHolderName.leftView = paddingView
        txtAccountHolderName.leftViewMode = UITextField.ViewMode.always*/

        txtAccountHolderName.tintColor = .themeTextColor
        txtAccountNumber.tintColor = .themeTextColor
        txtDob.tintColor = .themeTextColor
        txtAddress.tintColor = .themeTextColor
        txtPostalCode.tintColor = .themeTextColor
        txtStateCode.tintColor = .themeTextColor
        txtRoutingNumber.tintColor = .themeTextColor
        txtGender.tintColor = .themeTextColor
        txtPersonalIdNumber.tintColor = .themeTextColor

        txtAccountHolderName.setBorder()
        txtAccountNumber.setBorder()
        txtDob.setBorder()
        txtAddress.setBorder()
        txtPostalCode.setBorder()
        txtStateCode.setBorder()
        txtRoutingNumber.setBorder()
        txtGender.setBorder()
        txtPersonalIdNumber.setBorder()

        if self.paymentID == Payment.PAYSTACK {
            self.stkvwImages.isHidden = true
            self.txtPersonalIdNumber.isHidden = true
            self.txtDob.isHidden = true
            self.vwGender.isHidden = true
            self.txtAddress.isHidden = true
            self.txtPostalCode.isHidden = true
            self.txtStateCode.isHidden = true
            self.txtRoutingNumber.placeholder = "TXT_BANK_CODE".localized
        }
    }

    @objc func handleTap(gestureRecognizer: UIGestureRecognizer) {
        self.view.endEditing(true)
    }

    @IBAction func onClickBtnClose(_ sender: Any) {
        self.view.backgroundColor = .clear
        self.dismiss(animated: true) {}
    }

    @objc func onClickSaveBtn() {
        if self.btnSave.tag == 0 {
            if (checkValidation()) {
                if preferenceHelper.getSocialId().isEmpty {
                    openVerifyAccountDialog()
                }else {
                    self.wsAddBankDetail()
                }
            }
        } else {
            if preferenceHelper.getSocialId().isEmpty {
                openVerifyAccountDialog()
            }else {
                self.wsDeleteBankDetail()
            }
        }
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
                textField.resignFirstResponder()
                return true
            }
        }
        return true
    }

    //MARK:- Action Methods
    func onClickRightButton() {
        self.view.endEditing(true)
        if super.button.tag == 0 {
            if (checkValidation()) {
                if preferenceHelper.getSocialId().isEmpty() {
                    openVerifyAccountDialog()
                } else {
                    self.wsAddBankDetail()
                }
            }
        } else {
            if preferenceHelper.getSocialId().isEmpty() {
                openVerifyAccountDialog()
            } else {
                self.wsDeleteBankDetail()
            }
        }
    }

    func enableTextFields(enable:Bool) -> Void {
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
                        Utility.showToast(message: "MSG_PLEASE_ENTER_ACCOUNT_NUMBER".localized)})
                    
                } else if (txtRoutingNumber.text?.isEmpty())! {
                    txtRoutingNumber.becomeFirstResponder();
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 , execute: {
                        Utility.showToast(message: "MSG_PLEASE_ENTER_BANK_CODE".localized)})
                    
                }
                return false;
            } else {
                return true
            }
        } else {
            if ((txtAccountNumber.text?.isEmpty())! || (txtAccountHolderName.text?.isEmpty())! || (txtRoutingNumber.text?.isEmpty())! || (txtPersonalIdNumber.text?.isEmpty())!   || (txtDob.text?.count)! < 1) || (txtAddress.text?.isEmpty())! || (txtStateCode.text?.isEmpty())! || (txtPostalCode.text?.isEmpty())!{
                if (txtAccountHolderName.text?.isEmpty())! {
                    txtAccountHolderName.becomeFirstResponder();
                    Utility.showToast(message:"MSG_PLEASE_ENTER_ACCOUNT_HOLDER_NAME".localized)
                } else if (txtAccountNumber.text?.isEmpty())! {
                    Utility.showToast(message: "MSG_PLEASE_ENTER_ACCOUNT_NUMBER".localized)
                    txtAccountNumber.becomeFirstResponder()
                } else if (txtRoutingNumber.text?.isEmpty())! {
                    Utility.showToast(message: "MSG_PLEASE_ENTER_ROUTING_NUMBER".localized)
                    txtRoutingNumber.becomeFirstResponder();
                } else if ((txtPersonalIdNumber.text?.isEmpty())!) {
                    Utility.showToast(message: "MSG_PLEASE_ENTER_PERSONAL_ID_NUMBER".localized)
                    txtPersonalIdNumber.becomeFirstResponder();
                } else if (txtDob.text?.isEmpty())! {
                    Utility.showToast(message: "MSG_PLEASE_ENTER_DOB".localized)
                    txtDob.becomeFirstResponder();
                } else if (txtAddress.text?.isEmpty())! {
                    Utility.showToast(message: "MSG_PLEASE_ENTER_ADDRESS".localized)
                    txtAddress.becomeFirstResponder();
                } else if (txtPostalCode.text?.isEmpty())! {
                    Utility.showToast(message: "MSG_PLEASE_ENTER_POSTALCODE".localized)
                    txtPostalCode.becomeFirstResponder();
                }else if (txtStateCode.text?.isEmpty())!{
                    Utility.showToast(message: "MSG_ENTER_STATE".localized)
                    txtStateCode.becomeFirstResponder();
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
        dialogForVerification.onClickLeftButton = {
                [unowned dialogForVerification] in
                dialogForVerification.removeFromSuperview();
        }
        dialogForVerification.onClickRightButton = { [unowned dialogForVerification, unowned self]  (text1:String,text2:String) in
            let validPassword = text1.checkPasswordValidation()
            if validPassword.0 == false{
               
                Utility.showToast(message: validPassword.1)
            } else {
                self.password = text1
                if (self.button.tag == 1) {
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
        dialogForNote.onClickLeftButton = {
            [unowned dialogForNote] in
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
        print("DOB = \(txtDob.text!)")
        var dictParam : [String : Any] = [:]
        if self.paymentID == Payment.STRIPE {
            var strGender : String = ""
            if btnMale.isSelected {
                strGender = "TXT_MALE".localized
            } else {
                strGender = "TXT_FEMALE".localized
            }

            dictParam =
            [ PARAMS.BANK_ACCOUNT_HOLDER_NAME : txtAccountHolderName.text!,
              PARAMS.ACCOUNT_HOLDER_NAME : txtAccountHolderName.text!,
              PARAMS.BANK_ACCOUNT_NUMBER : txtAccountNumber.text!,
              PARAMS.BANK_ROUTING_NUMBER : txtRoutingNumber.text!,
              PARAMS.BANK_PERSONAL_ID_NUMBER   : txtPersonalIdNumber.text!,
              PARAMS.BANK_DOB : txtDob.text!,
              PARAMS.PASS_WORD: password,
              PARAMS.BANK_HOLDER_TYPE: String(CONSTANT.TYPE_STORE),
              PARAMS.BANK_HOLDER_ID: preferenceHelper.getUserId(),
              PARAMS.SOCIAL_ID : preferenceHelper.getSocialId(),
              PARAMS.GENDER: strGender.lowercased(),
              PARAMS.ADDRESS: txtAddress.text!,
              PARAMS.POSTAL_CODE: txtPostalCode.text!,//"EC1A 1BB",
              PARAMS.STATE:txtStateCode.text!,
              PARAMS.ACCOUNT_HOLDER_TYPE : "individual",
              PARAMS.PAYMENT_ID : Payment.STRIPE
              //             PARAMS.BANK_DOCUMENT: strimage
            ]
        } else {
            dictParam  =
            [
                PARAMS.BANK_ACCOUNT_HOLDER_NAME : txtAccountHolderName.text ?? "",
                PARAMS.ACCOUNT_HOLDER_NAME : txtAccountHolderName.text ?? "",
                PARAMS.BANK_ACCOUNT_NUMBER : self.txtAccountNumber.text ?? "",
                PARAMS.BANK_ROUTING_NUMBER : self.txtRoutingNumber.text ?? "",
                PARAMS.BANK_PERSONAL_ID_NUMBER : txtPersonalIdNumber.text ?? "",
                PARAMS.BANK_DOB : "",
                PARAMS.PAYMENT_ID : Payment.PAYSTACK,
                PARAMS.STORE_ID: preferenceHelper.getUserId(),
                PARAMS.SERVER_TOKEN: preferenceHelper.getSessionToken(),
                PARAMS.PASS_WORD: password,
                PARAMS.BANK_HOLDER_TYPE: String(CONSTANT.TYPE_STORE),
                PARAMS.BANK_HOLDER_ID: preferenceHelper.getUserId(),
                PARAMS.SOCIAL_ID : preferenceHelper.getSocialId(),
                PARAMS.ACCOUNT_HOLDER_TYPE: "individual"
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
                //_ = self.navigationController?.popViewController(animated: true)
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
            [PARAMS.PASS_WORD: password  ,
             PARAMS.BANK_HOLDER_TYPE: String(CONSTANT.TYPE_STORE),
             PARAMS.PROVIDER_ID: preferenceHelper.getUserId(),
             PARAMS.BANK_DETAIL_ID: bankDetail?.id ?? "",
             PARAMS.SOCIAL_ID: preferenceHelper.getSocialId()
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
        self.txtPersonalIdNumber.isHidden = true
        self.btnAddImage.isHidden = true
        self.setRightBarItemImage(image: UIImage.init(named: "delete")!)
        super.button.tag = 1
    }

    func resetBankData() {
        self.txtAccountNumber.text = ""
        self.txtAccountHolderName.text = ""
        self.txtPersonalIdNumber.text = ""
        self.txtRoutingNumber.text = ""
        self.txtDob.text = ""
        self.txtAddress.text = ""
        self.txtPostalCode.text = ""
        self.txtStateCode.text = ""
        self.txtPersonalIdNumber.text = ""
        self.btnAddImage.isHidden = false
        self.txtDob.isHidden = false
        self.txtPersonalIdNumber.isHidden = false

        self.setRightBarItemImage(image: UIImage(named: "correct")!.imageWithColor(color: .themeColor)!, title: "", mode: .center)

        super.button.tag = 1
    }

    @IBAction func onClickBtnMale(_ sender: Any) {
        self.btnMale.isSelected = !self.btnMale.isSelected
        self.btnFemale.isSelected = !self.btnMale.isSelected
        self.txtGender.text = "TXT_GENDER".localized
    }

    @IBAction func onClickBtnFemale(_ sender: Any) {
        self.btnFemale.isSelected = !self.btnFemale.isSelected
        self.btnMale.isSelected = !self.btnFemale.isSelected
        self.txtGender.text = "TXT_GENDER".localized
    }

    @IBAction func onClickBtnAddImage(_ sender: Any) {
        self.view.endEditing(true)
        dialogForImage = CustomPhotoDialog.showPhotoDialog("TXT_SELECT_IMAGE".localized, andParent: self, isCropRequired: false)
        self.dialogForImage?.onImageSelected = {[unowned self] (image:UIImage) in
            self.isPicAddedBack = true;
            self.imgBack.image = image
            self.imgBack.contentMode = .scaleAspectFit
        }
    }

    @IBAction func onClickBtnFront(_ sender: Any) {
        //           openImageDialog()
        self.view.endEditing(true)
        dialogForImage = CustomPhotoDialog.showPhotoDialog("TXT_SELECT_IMAGE".localized, andParent: self, isCropRequired: false)
        self.dialogForImage?.onImageSelected = {[unowned self] (image:UIImage) in
            self.isPicAddedFront = true;
            self.imgFront.image = image
            self.imgFront.contentMode = .scaleAspectFit
        }
    }

    @IBAction func onClickBtnAdditional(_ sender: Any) {
        //   openImageDialog()
        self.view.endEditing(true)
        dialogForImage = CustomPhotoDialog.showPhotoDialog("TXT_SELECT_IMAGE".localized, andParent: self, isCropRequired: false)
        self.dialogForImage?.onImageSelected = {[unowned self] (image:UIImage) in
              self.isPicAddedAdditional = true;
              self.imgAdditional.image = image
            self.imgAdditional.contentMode = .scaleAspectFit
        }
    }

    func openDatePicker() {
        self.view.endEditing(true)
        let gregorian: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let currentDate: Date = Date()
        var components: DateComponents = DateComponents()
        components.year = -13
        let maxDate: Date = gregorian.date(byAdding: components as DateComponents, to: currentDate, options: NSCalendar.Options(rawValue: 0))!
        
        let datePickerDialog:CustomDatePickerDialog = CustomDatePickerDialog.showCustomDatePickerDialog(title: "TXT_SELECT_DOB_DATE".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_SELECT".localized)
        datePickerDialog.setMaxDate(maxdate: maxDate)
        datePickerDialog.onClickLeftButton = { [unowned datePickerDialog] in
            datePickerDialog.removeFromSuperview()
        }
        datePickerDialog.onClickRightButton = { [unowned datePickerDialog, unowned self]  (selectedDate:Date) in
            self.txtDob.text = Utility.dateToString(date: selectedDate, withFormat: DATE_CONSTANT.DD_MM_YYYY)
            datePickerDialog.removeFromSuperview()
        }
    }
}

protocol presentDataSet {
    func setData()
}
