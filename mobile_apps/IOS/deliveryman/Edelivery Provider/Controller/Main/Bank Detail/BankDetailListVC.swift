//
//  BankDetailListVC.swift
//  edelivery
//
//  Created by Elluminati on 28/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class BankDetailListVC: BaseVC ,presentDataSet {

//MARK: Outlets
    @IBOutlet weak var lblEmptyMsg: UILabel!
    @IBOutlet weak var imgEmpty: UIImageView!
    @IBOutlet weak var tblForBankDetail: UITableView!
    @IBOutlet weak var btnAdd: UIButton!

    var arrForBankDetail:[BankDetail] = []
    var selectedBankDetail:BankDetail? = nil
    var password:String = ""
    var paymentConfig:PaymentConfig = PaymentConfig.shared

    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        lblEmptyMsg.isHidden = true
        tblForBankDetail.estimatedRowHeight = 180
        tblForBankDetail.rowHeight = UITableView.automaticDimension
        self.hideBackButtonTitle()
        self.setNavigationTitle(title: "TXT_BANK_DETAILS".localizedCapitalized)
        self.wsGetPaymentGateways()
    }

    @IBAction func onClickBtnAdd(_ sender: Any) {
        self.gotoBankDetail()
    }

    override func updateUIAccordingToTheme() {
        self.setLocalization()
        tblForBankDetail.reloadData()
    }

    func gotoBankDetail() {
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "Payment", bundle: nil)
        if let bankDetailVC : BankDetailVC = mainView.instantiateViewController(withIdentifier: "BankDetailVC") as? BankDetailVC {
            bankDetailVC.setData = self
            bankDetailVC.paymentID = self.paymentConfig.paymentId ?? Payment.STRIPE
            bankDetailVC.modalPresentationStyle = .overCurrentContext
            self.present(bankDetailVC, animated: false)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.wsGetBankDetail()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews();
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    func updateUI(isUpdate:Bool = false) {
        imgEmpty.isHidden = isUpdate
        tblForBankDetail.isHidden = !isUpdate
    }

    func setLocalization() {
        /*set colors*/
        self.view.backgroundColor = UIColor.themeViewBackgroundColor;
    }

    //MARK:- TextField Delegate
    func setData() {
        wsGetBankDetail()
    }

    func wsGetBankDetail() {
        let dictParam : [String : Any] =
        [PARAMS.BANK_HOLDER_TYPE: CONSTANT.TYPE_PROVIDER,
         PARAMS.BANK_HOLDER_ID: preferenceHelper.getUserId(),
         PARAMS.SERVER_TOKEN: preferenceHelper.getSessionToken()]

        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_GET_BANK_DETAIL, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            if Parser.isSuccess(response: response, andErrorToast: false) {
                self.arrForBankDetail.removeAll()
                let bankDetailResponse:BankDetailResponse = BankDetailResponse.init(fromDictionary: response)
                let bankList:[BankDetail] = bankDetailResponse.bankDetail
                if bankList.count > 0 {
                    for bank in bankList {
                        self.arrForBankDetail.append(bank)
                    }
                }
                if self.arrForBankDetail.count > 0 {
                    self.updateUI(isUpdate:true)
                } else {
                    self.updateUI(isUpdate:false)
                }
                self.tblForBankDetail.reloadData()
            }
        }
    }

    func wsRemoveBankDetail() {
        let dictParam : [String : Any] =
            [PARAMS.BANK_HOLDER_TYPE: CONSTANT.TYPE_PROVIDER,
             PARAMS.BANK_HOLDER_ID: preferenceHelper.getUserId(),
             PARAMS.PASSWORD: password,
             PARAMS.BANK_DETAIL_ID: (selectedBankDetail?.id) ?? "",
             PARAMS.PROVIDER_ID: preferenceHelper.getUserId(),
             PARAMS.SOCIAL_ID : preferenceHelper.getSocialId()
        ]

        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_DELETE_BANK_DETAIL, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            if Parser.isSuccess(response: response) {
                self.arrForBankDetail.removeAll()
                let bankDetailResponse:BankDetailResponse = BankDetailResponse.init(fromDictionary: response)
                let bankList:[BankDetail] = bankDetailResponse.bankDetail
                if bankList.count > 0 {
                    for bank in bankList {
                        self.arrForBankDetail.append(bank)
                    }
                }
                if self.arrForBankDetail.count > 0 {
                    self.updateUI(isUpdate:true)
                } else {
                    self.updateUI(isUpdate:false)
                }
                self.tblForBankDetail.reloadData()
            }
        }
    }

    func wsGetPaymentGateways() {
        Utility.showLoading()
        var dictParam: [String:Any] = [:]
        dictParam[PARAMS.CITY_ID] = preferenceHelper.getCityId()
        dictParam[PARAMS.USER_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.SERVER_TOKEN] = preferenceHelper.getSessionToken()
        dictParam[PARAMS.TYPE] = CONSTANT.TYPE_PROVIDER
        print(dictParam)

        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_GET_PAYMENT_GATEWAYS, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Utility.hideLoading()
            print(response)
            Parser.parsePaymentGateways(response, completion: { (result) in
                if !self.paymentConfig.paymentGateways.isEmpty {
                    for paymentGateway in self.paymentConfig.paymentGateways {
                        if paymentGateway.id.compare(Payment.STRIPE) == ComparisonResult.orderedSame {
                            self.paymentConfig.paymentId = Payment.STRIPE
                            break;
                        }
                        if paymentGateway.id.compare(Payment.PAYSTACK) == ComparisonResult.orderedSame {
                            self.paymentConfig.paymentId = Payment.PAYSTACK
                            break;
                        }
                    }
                }
            })
        }
    }

    func onClickEditBankDetail(button:UIButton) {
        self.selectedBankDetail = arrForBankDetail[button.tag]
        self.wsSelectBankDetail()
    }

    func onClickRemoveBankDetail(button:UIButton) {
        self.selectedBankDetail = arrForBankDetail[button.tag]
        openVerifyAccountDialog()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let bankDetailVC:BankDetailVC = segue.destination as! BankDetailVC
        if sender != nil {
            bankDetailVC.bankDetail = sender as? BankDetail
        }
    }

    func openVerifyAccountDialog() {
        self.view.endEditing(true)
        let dialogForVerification = CustomVerificationDialog.showCustomVerificationDialog(title: "TXT_VERIFY_ACCOUNT".localized, message: "MSG_PLEASE_ENTER_CURRENT_PASSWORD".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_OK".localized, editTextOneHint: "TXT_PASSWORD".localized, editTextTwoHint: "", isEdiTextTwoIsHidden: true, editTextOneInputType: true)
        dialogForVerification.onClickLeftButton = { [unowned dialogForVerification] in
            dialogForVerification.removeFromSuperview();
        }
        dialogForVerification.onClickRightButton = { [unowned dialogForVerification, unowned self] (text1:String, text2:String) in
            let validPassword = text1.checkPasswordValidation()
            if validPassword.0 == false {
                Utility.showToast(message: validPassword.1)
            } else {
                self.password = text1
                if (self.selectedBankDetail != nil) {
                    self.wsRemoveBankDetail()
                }
                dialogForVerification.removeFromSuperview();
            }
        }
    }
}

extension BankDetailListVC: UITableViewDelegate,UITableViewDataSource {

    //MARK: - Tableview Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrForBankDetail.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! BankDetailCell
        let dict = arrForBankDetail[indexPath.section]
        cell.setData(data: dict, parent: self)
        cell.btnEdit.tag = indexPath.section
        cell.btnDelete.tag = indexPath.section
        cell.btnEdit.isHidden = !dict.isSelected
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = tableView.dequeueReusableCell(withIdentifier: "section")! as! BankDetailSection
        let dict = arrForBankDetail[section]
        sectionHeader.setSectionTitle(title: dict.bankAccountHolderName)
        return sectionHeader
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedBankDetail = arrForBankDetail[indexPath.section]
        wsSelectBankDetail()
    }

    func wsSelectBankDetail() {
        Utility.showLoading()
        let dictParam : [String : Any] =
            [PARAMS.PASSWORD: password,
             PARAMS.SERVER_TOKEN: preferenceHelper.getSessionToken(),
             PARAMS.BANK_HOLDER_TYPE: CONSTANT.TYPE_PROVIDER,
             PARAMS.BANK_HOLDER_ID: preferenceHelper.getUserId(),
             PARAMS.BANK_DETAIL_ID : selectedBankDetail?.id ?? "",
             PARAMS.SOCIAL_ID : preferenceHelper.getSocialId()
        ]

        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_SELECT_BANK_DETAIL, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response) {
                for bankDetail in self.arrForBankDetail {
                    bankDetail.isSelected = false
                    if bankDetail.id == self.selectedBankDetail?.id {
                        bankDetail.isSelected = true
                    }
                }
                self.tblForBankDetail.reloadData()
            }
        }
    }
}

class BankDetailCell: CustomTableCell {

    @IBOutlet weak var lblRoutingNumber: UILabel!
    @IBOutlet weak var lblRoutingNumberValue: UILabel!
    @IBOutlet weak var lblAccount: UILabel!
    @IBOutlet weak var lblAccountNo: UILabel!

    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnEdit: UIButton!

    weak var parent: BankDetailListVC? = nil;

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor

        lblAccount.textColor = UIColor.themeLightTextColor
        lblAccountNo.textColor = UIColor.themeTextColor
        lblRoutingNumber.textColor = UIColor.themeLightTextColor
        lblRoutingNumberValue.textColor = UIColor.themeTextColor

        lblAccount.text = "TXT_ACCOUNT_NUMBER".localizedCapitalized + ": "
        lblAccountNo.text = ""
        lblRoutingNumber.text = "TXT_ROUTING_NUMBER".localizedCapitalized + ": "
        lblRoutingNumberValue.text = ""

        lblAccount.font = FontHelper.textRegular()
        lblAccountNo.font = FontHelper.textMedium()
        lblRoutingNumber.font = FontHelper.textRegular()
        lblRoutingNumberValue.font = FontHelper.textMedium()

        btnDelete.setImage(UIImage.init(named: "close")?.imageWithColor(color: .themeIconTintColor), for: .normal)
    }

    func setData(data: BankDetail,parent:BankDetailListVC) {
        lblAccountNo.text = data.accountNumber
        lblRoutingNumberValue.text = data.routingNumber
        btnDelete.setImage(UIImage.init(named: "close")?.imageWithColor(color: .themeIconTintColor), for: .normal)
        self.parent = parent
    }

    @IBAction func onClickBtnEditBankDetail(_ sender: Any) {
        //self.parent?.onClickEditBankDetail(button: btnEdit)
    }

    @IBAction func onClickRemoveBankDetail(_ sender: Any) {
        self.parent?.onClickRemoveBankDetail(button: btnDelete)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

class BankDetailSection: CustomTableCell {

    @IBOutlet weak var lblSection: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
       // lblSection.backgroundColor = UIColor.themeViewLightBackgroundColor
       // lblSection.textColor = UIColor.themeButtonTitleColor
        //lblSection.font = FontHelper.textRegular()
    }

    func setSectionTitle(title: String) {
        lblSection.text = title
        //lblSection.sectionRound(lblSection)
    }
}
