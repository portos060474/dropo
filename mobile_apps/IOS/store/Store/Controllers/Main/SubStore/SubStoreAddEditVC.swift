//
//  SubStoreAddEditVC.swift
//  Store
//
//  Created by Trusha on 14/07/20.
//  Copyright © 2020 Elluminati. All rights reserved.
//

import UIKit

class SubStoreAddEditVC: BaseVC,RightDelegate {

    var arrSubStore = SubStore(fromDictionary: [:])
    @IBOutlet weak var tblSubStoreDetail: UITableView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhno: UITextField!
    @IBOutlet weak var viewForPassword: UIView!
    @IBOutlet weak var btnShowHidePassword: UIButton!
    @IBOutlet weak var txtPwd: UITextField!
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var switchforStatus: UISwitch!
    @IBOutlet weak var lblswitchStatus: UILabel!
    @IBOutlet weak var lblPhonoTxt: UILabel!
    @IBOutlet weak var lblScreenaTxt: UILabel!

    var isFromAdd: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalization()
        tblSubStoreDetail.estimatedRowHeight = 60
        tblSubStoreDetail.rowHeight = UITableView.automaticDimension
        
        txtPhno.keyboardType = .numberPad
    }

    func setLocalization() -> Void {
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        super.hideBackButtonTitle()
        self.setNavigationTitle(title: "TXT_SUB_STORE".localized)
        switchforStatus.onTintColor = UIColor.themeGreenColor
        txtName.textColor = UIColor.themeTextColor
        txtEmail.textColor = UIColor.themeTextColor
        txtPhno.textColor = UIColor.themeTextColor
        txtPwd.textColor = UIColor.themeTextColor
        lblCountryCode.textColor = UIColor.themeTextColor
        lblswitchStatus.textColor = .themeTextColor
        txtName.text = ""
        txtEmail.text = ""
        txtPwd.text = ""

        txtName.font = FontHelper.textRegular()
        txtEmail.font = FontHelper.textRegular()
        txtPhno.font = FontHelper.textRegular()
        txtPwd.font = FontHelper.textRegular()
        lblCountryCode.font = FontHelper.textRegular()
        lblswitchStatus.font = FontHelper.textRegular()

        txtName.placeholder = "TXT_NAME".localizedCapitalized
        txtPwd.placeholder = "TXT_PASSWORD".localized
        txtEmail.placeholder = "TXT_EMAIL".localized
        lblPhonoTxt.text = "TXT_PHONE_NO".localized
        lblScreenaTxt.text = "TXT_SCREENS".localizedUppercase
        txtPhno.placeholder = "TXT_MOBILE_NUMBER".localized
        lblswitchStatus.text = "TXT_APPROVED".localized

        switchforStatus.onTintColor = .themeColor

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gestureRecognizer:)))
        self.view.addGestureRecognizer(gestureRecognizer)

        self.delegateRight = self

        if isFromAdd {
            //self.txtName.isEnabled = true
            self.txtEmail.isEnabled = true
            self.txtPhno.isEnabled = true
            btnSave.setTitle("TXT_SAVE".localizedUppercase, for: UIControl.State.normal)
            for obj in self.arrSubStore.urls {
                obj.permission = 0
            }
            lblCountryCode.text = preferenceHelper.getPhoneCountryCode()
        } else {
            if self.arrSubStore.countryPhoneCode.count <= 0 {
                self.arrSubStore.countryPhoneCode = preferenceHelper.getPhoneCountryCode()
            }
            lblCountryCode.text = self.arrSubStore.countryPhoneCode
            if self.arrSubStore.name.count > 0 {
                if self.arrSubStore.name.count-1 >= ConstantsLang.AdminLanguageIndexSelected {
                    self.txtName.text = self.arrSubStore.name[ConstantsLang.AdminLanguageIndexSelected]
                } else {
                    self.txtName.text = self.arrSubStore.name[0]
                }
            } else {
                self.txtName.text = ""
            }
            self.txtEmail.text = self.arrSubStore.email
            self.txtPhno.text = self.arrSubStore.phone
            if self.arrSubStore.password.count > 0 {
                var str = ""
                for _ in 0..<(self.arrSubStore.password.count-1) {
                    str = str + "*"
                }
                self.txtPwd.text = str
            }
            switchforStatus.isOn = self.arrSubStore.isApproved
            onSwitchValueChanged(switchforStatus)
            setlblSwitchStatus()
            // self.txtName.isEnabled = false
            self.txtEmail.isEnabled = false
            self.txtPhno.isEnabled = false
            btnSave.setTitle("TXT_UPDATE".localizedUppercase, for: UIControl.State.normal)
        }
        updateUIAccordingToTheme()
    }

    @objc func handleTap(gestureRecognizer: UIGestureRecognizer) {
        self.view.endEditing(true)
    }

    override func updateUIAccordingToTheme() {
        super.setRightBarItem(isNative: false)
        self.setRightBarItemImage(image: UIImage(named: "correct")!.imageWithColor(color: .themeColor)!, title: "", mode: .center)
        self.tblSubStoreDetail.reloadData()
    }

    func setlblSwitchStatus() {
        lblswitchStatus.text = "TXT_SCREEN_PERMISSION".localizedCapitalized
        if self.arrSubStore.isApproved {
            lblswitchStatus.text = "TXT_APPROVED".localized
        } else {
            lblswitchStatus.text = "TXT_REJECT".localized
        }
    }

    func validation() -> Bool {
        let validPassword = txtPwd.text!.checkPasswordValidation()
        let validEmail = txtEmail.text!.checkEmailValidation()
        let validPhoneNo = txtPhno.text!.isValidMobileNumber()
        self.view.endEditing(true)

        var isPermissionadded : Bool = false
        for obj in self.arrSubStore.urls {
            if obj.permission == 1 {
                isPermissionadded = true
                break
            }
        }

        if (self.txtName.text)!.removingWhitespaces().count <= 0 {
            Utility.showToast(message: "MSG_PLEASE_ENTER_VALID_NAME".localized)
            return false
        } else if validEmail.0 == false{
            Utility.showToast(message:validEmail.1)
            return false
        } else if validPhoneNo.0 == false{
            Utility.showToast(message: validPhoneNo.1);
            return false
        } else if validPassword.0 == false {
//            let str = self.txtPwd.text
//            if (str!.replacingOccurrences(of: " ", with: "")).count <= 0{
            Utility.showToast(message: validPassword.1)
                return false
          //  }
        } else if !isPermissionadded {
            Utility.showToast(message: "Please select any permission.");
            return false
        }
        return true
    }

    func openLocalizedLanguagDialog() {
        self.view.endEditing(true)
        let dialogForLocalizedLanguage = CustomActiveLanguageDialog.showCustomLanguageDialog(languages: [:], title: txtName.placeholder ?? "",nameLang: self.arrSubStore.name, isFromProfile: true)
        dialogForLocalizedLanguage.onItemSelected = { (selectedArray) in
            print(selectedArray)
            var namelang = [String]()
            var count : Int = 0

            //According to Admin lang
            for i in 0...ConstantsLang.adminLanguages.count-1 {
                count = 0
                for j in 0...selectedArray.count-1 {
                    if Array(selectedArray.keys)[j] == ConstantsLang.adminLanguages[i].languageCode{
                        namelang.append(selectedArray[ConstantsLang.adminLanguages[i].languageCode]!)
                        count = 1
                    }
                }
                if count == 0 {
                    namelang.append("")
                }
            }

            print(namelang)
            self.arrSubStore.name = namelang
            self.txtName.text = self.arrSubStore.name[ConstantsLang.AdminLanguageIndexSelected]

            dialogForLocalizedLanguage.removeFromSuperview()
        }
    }

    func openLocalizedLanguagDialog(textFiled: UITextField) {
        if textFiled == txtName {
            self.view.endEditing(true)
            let dialogForLocalizedLanguage = CustomActiveLanguageDialog.showCustomLanguageDialog(languages: [:], title: txtName.placeholder ?? "",nameLang: self.arrSubStore.name)
            dialogForLocalizedLanguage.onItemSelected = { (selectedArray) in
                print(selectedArray)
                var namelang = [String]()
                var count : Int = 0
                if ConstantsLang.storeLanguages.count > 0{
                    for i in 0...ConstantsLang.storeLanguages.count-1 {
                        count = 0
                        for j in 0...selectedArray.count-1 {
                            if Array(selectedArray.keys)[j] == ConstantsLang.storeLanguages[i].code{
                                namelang.append(selectedArray[ConstantsLang.storeLanguages[i].code]!)
                                count = 1
                            }
                        }
                        if count == 0 {
                            namelang.append("")
                        }
                    }
                }
                print(namelang)
                self.arrSubStore.name = namelang
                self.txtName.text = self.arrSubStore.name[ConstantsLang.AdminLanguageIndexSelected]
                dialogForLocalizedLanguage.removeFromSuperview()
            }
        }
    }

    //MARK: - IBAction Method
    func onClickRightButton() {
        if validation() {
            if isFromAdd {
                wsAddProduct()
            } else {
                wsUpdateProduct()
            }
        }
    }

    @IBAction func onClickBtnSave(_ sender: Any) {
        if validation() {
            if isFromAdd {
                wsAddProduct()
            } else {
                wsUpdateProduct()
            }
        }
    }

    @IBAction func onSwitchValueChanged(_ sender: UISwitch) {
        if sender == switchforStatus {
            self.arrSubStore.isApproved = switchforStatus.isOn
            setlblSwitchStatus()
        }
    }

    @IBAction func onClickBtnShowHidePassword(_ sender: Any) {
        if self.txtPwd.isSecureTextEntry {
            self.txtPwd.isSecureTextEntry = false
            self.btnShowHidePassword.setBackgroundImage(UIImage.init(named: "passwordShow"), for: .normal)
        } else {
            self.txtPwd.isSecureTextEntry = true
            self.btnShowHidePassword.setBackgroundImage(UIImage.init(named: "passwordHide"), for: .normal)
        }
    }
}

extension SubStoreAddEditVC : UITableViewDataSource, UITableViewDelegate {

    //MARK: - UITableview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSubStore.urls.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell : ScreenCell = tableView.cellForRow(at: indexPath) as! ScreenCell
        cell.btnCheckBox.isSelected = !cell.btnCheckBox.isSelected
        if cell.btnCheckBox.isSelected {
            self.arrSubStore.urls[cell.btnCheckBox.tag].permission = 1
        } else {
            self.arrSubStore.urls[cell.btnCheckBox.tag].permission = 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScreenCell", for: indexPath) as! ScreenCell
        cell.selectionStyle = .none
        cell.lblName.text = self.getLocalizedScreenName(name: self.arrSubStore.urls[indexPath.row].name)
        cell.btnCheckBox.setImage(UIImage.init(named: "unchecked"), for: .normal)
        cell.btnCheckBox.setImage(UIImage.init(named: "checked")?.imageWithColor(color: .themeColor), for: .selected)
        cell.btnCheckBox.tag = indexPath.row
        cell.btnCheckBox.addTarget(self, action: #selector(onClickCheckBox(_sender:)), for: .touchUpInside)

        if self.arrSubStore.urls[indexPath.row].permission == 1 {
            cell.btnCheckBox.isSelected = true
        } else {
            cell.btnCheckBox.isSelected = false
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    @objc func onClickCheckBox(_sender:UIButton) {
        _sender.isSelected = !_sender.isSelected
        if _sender.isSelected {
            self.arrSubStore.urls[_sender.tag].permission = 1
        } else {
            self.arrSubStore.urls[_sender.tag].permission = 0
        }
    }
}

extension SubStoreAddEditVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtPwd {
            self.txtPwd.text = ""
        }
        if textField == txtEmail {
            self.txtEmail.text = ""
        }
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtName {
            self.openLocalizedLanguagDialog(textFiled: textField)
            return false
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtEmail {
            self.arrSubStore.email = txtEmail.text
        } else if textField == txtPwd {
            self.arrSubStore.password = txtPwd.text
        } else if textField == txtPhno {
            self.arrSubStore.phone = txtPhno.text
        }
    }
}

extension SubStoreAddEditVC {

    func wsAddProduct() {
        var dictParam = [String:Any]()
        dictParam = self.arrSubStore.toDictionaryURLS()
        dictParam[PARAMS.EMAIL] = self.txtEmail.text
        dictParam[PARAMS.PHONE] = self.txtPhno.text
        dictParam[PARAMS.PASS_WORD] = self.txtPwd.text
        dictParam[PARAMS.NAME] = self.arrSubStore.name
        dictParam[PARAMS.COUNTRY_PHONE_CODE] = lblCountryCode.text!

        print("WS_ADD_SUB_STORE \(dictParam)")
        Utility.showLoading()
        let alamofire = AlamofireHelper.init()

        alamofire.getResponseFromURL(url: WebService.WS_ADD_SUB_STORE, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam, block: { (response, error) -> (Void) in
            Utility.hideLoading()
            print("WS_ADD_SUB_STORE \(response)")
            if Parser.isSuccess(response: response) {
                self.navigationController?.popViewController(animated: true)
            }
        })
    }

    func wsUpdateProduct() {
        var dictParam = [String:Any]()
        dictParam = self.arrSubStore.toDictionaryURLS()
        dictParam[PARAMS._ID] = self.arrSubStore.id
        dictParam[PARAMS.PASS_WORD] = self.arrSubStore.password
        dictParam[PARAMS.EMAIL] = self.arrSubStore.email
        dictParam[PARAMS.NAME] = self.arrSubStore.name
        dictParam[PARAMS.IS_APPROVED] = self.arrSubStore.isApproved
        dictParam[PARAMS.COUNTRY_PHONE_CODE] = self.arrSubStore.countryPhoneCode

        print("WS_UPDATE_SUB_STORE \(dictParam)")
        Utility.showLoading()

        let alamofire = AlamofireHelper.init()
        alamofire.getResponseFromURL(url: WebService.WS_UPDATE_SUB_STORE, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam, block: { (response, error) -> (Void) in
            Utility.hideLoading()
            print("WS_UPDATE_SUB_STORE \(response)")

            if Parser.isSuccess(response: response) {
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
}

class ScreenCell: CustomCell,UITextFieldDelegate {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnCheckBox: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension SubStoreAddEditVC {

    func getLocalizedScreenName(name:String) -> String {
        switch name {
        case "Create Order":
            return "TXT_CREATE_ORDER".localized
        case "Provider":
            return "TXT_PROVIDER".localized
        case "Service":
            return "TXT_SERVICE".localized
        case "Order":
            return "TXT_ORDER".localized
        case "Deliveries":
            return "TXT_DELIVERIES".localized
        case "History":
            return "TXT_HISTORY".localized
        case "Group":
            return "TXT_GROUP".localized
        case "Product":
            return "TXT_PRODUCT_".localized
        case "Promo Code":
            return "TXT_PROMO_CODE_ONLY".localized
        case "Setting":
            return "TXT_SETTING_".localized
        case "Settings":
            return "TXT_SETTING_".localized
        case "Earning":
            return "TXT_EARNING".localized
        case "Earnings":
            return "TXT_EARNING".localized
        case "Weekly Earning":
            return "TXT_WEEKLY_EARNING".localized
        default:
            return name
        }
    }
}
