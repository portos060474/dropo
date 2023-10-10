//
//  SelectWalletPaymentVC.swift
//  Store
//
//  Created by Elluminati on 18/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class SelectWalletPaymentVC: BaseVC,presentDataSet {

    //Wallet View
    @IBOutlet weak var lblSelectWithdrawalMethod: UILabel!
    //Select withdrawel method
    
    @IBOutlet weak var viewForBankAccount: UIView!
    @IBOutlet weak var viewForDescription: UIView!
    @IBOutlet weak var viewForAmount: UIView!
    @IBOutlet weak var viewForBank: UIView!
    
    /*View For Select wallet withdraw method*/
    @IBOutlet weak var lblTransferType: UILabel!
    @IBOutlet weak var btnTransferInBank: UIButton!
    @IBOutlet weak var btnRequestCash: UIButton!
    
    /*View For Request wallet withdraw amount*/
    @IBOutlet weak var lblEnterAmount: UILabel!
    @IBOutlet weak var txtAmount: UITextField!
    
    /*View For Request Bank Account*/
    @IBOutlet weak var txtBankAccount: UITextField!
    @IBOutlet weak var lblBankAccount: UILabel!
    
    /*View For Request wallet withdraw description*/
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var btnRequestWithdraw: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    
    var arrForBankDetail : NSMutableArray = NSMutableArray.init()
    var selectedBankDetail:BankDetail? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad();
        setLocalization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        wsGetBankDetail()
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews();
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
    
    func setData() {
        wsGetBankDetail()
    }
    
    func  setLocalization() {
       
        //Colors
        self.view.backgroundColor = .themeViewBackgroundColor
        self.btnRequestCash.setImage(UIImage.init(named: "radio_btn_unchecked_icon")!.imageWithColor(color: .themeLightTextColor), for: .normal)
        self.btnRequestCash.setImage(UIImage.init(named: "radio_btn_checked_icon")!.imageWithColor(), for: .selected)
        self.btnTransferInBank.setImage(UIImage.init(named: "radio_btn_unchecked_icon")!.imageWithColor(color: .themeLightTextColor), for: .normal)
        self.btnTransferInBank.setImage(UIImage.init(named: "radio_btn_checked_icon")!.imageWithColor(), for: .selected)
        lblBankAccount.textColor = UIColor.themeTextColor
        lblTransferType.textColor = UIColor.themeTextColor
        txtAmount.backgroundColor = .themeViewBackgroundColor
        txtDescription.backgroundColor = .themeViewBackgroundColor
        txtBankAccount.backgroundColor = .themeViewBackgroundColor
        lblEnterAmount.textColor = UIColor.themeTextColor
        txtAmount.textColor = UIColor.themeTextColor
        txtBankAccount.textColor = UIColor.themeTextColor
        lblBankAccount.textColor = UIColor.themeTextColor
        lblDescription.textColor = UIColor.themeTextColor
        txtDescription.textColor = UIColor.themeTextColor
        btnRequestWithdraw.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnTransferInBank.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnRequestCash.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnAdd.setTitleColor(UIColor.themeButtonBackgroundColor, for: .normal)
        btnRequestWithdraw.backgroundColor = UIColor.themeButtonBackgroundColor
        viewForAmount.backgroundColor = .themeViewLightBackgroundColor
        viewForDescription.backgroundColor = .themeViewLightBackgroundColor
        viewForBankAccount.backgroundColor = .themeViewLightBackgroundColor
        
        /*Set Font*/
        lblBankAccount.font = FontHelper.textRegular()
        btnAdd.titleLabel?.font = FontHelper.textMedium(size: FontHelper.regular)
        lblTransferType.font = FontHelper.textMedium(size: FontHelper.regular)
        btnTransferInBank.titleLabel?.font = FontHelper.textRegular()
        btnRequestWithdraw.titleLabel?.font = FontHelper.textRegular()
        btnRequestCash.titleLabel?.font = FontHelper.textRegular()
        lblEnterAmount.font = FontHelper.textMedium(size: FontHelper.regular)
        txtAmount.font = FontHelper.textRegular()
        txtBankAccount.font = FontHelper.textRegular()
        lblBankAccount.font = FontHelper.textMedium(size: FontHelper.regular)
        lblDescription.font = FontHelper.textMedium(size: FontHelper.regular)
        txtDescription.font = FontHelper.textRegular()
        
        /*Set Text*/
        lblTransferType.text = "TXT_HOW_WOULD_YOU_LIKE_TO_REQUEST".localized
        btnTransferInBank.setTitle("TXT_TRANSFER_TO_BANK_ACCOUNT".localized, for: .normal)
        btnRequestCash.setTitle("TXT_REQUEST_CASH".localized, for: .normal)
        lblDescription.text = "TXT_DESCRIPTION".localized
        txtDescription.placeholder = "TXT_DESCRIPTION".localized
        lblEnterAmount.text = "TXT_ENTER_AMOUNT_TO_WITHDRAW".localized
        txtAmount.placeholder =  "TXT_AMOUNT".localized
        lblBankAccount.text = "TXT_BANK_ACCOUNT".localized
        txtBankAccount.placeholder =  "TXT_SELECT_BANK_ACCOUNT".localized
        btnRequestWithdraw.setTitle("TXT_REQUEST_WITHDRAWAL".localizedUppercase, for: .normal)
        self.setNavigationTitle(title: "TXT_WITHDRAWAL".localizedCapitalized)
        lblSelectWithdrawalMethod.text = "TXT_SELECT_WITHDRAWAL_METHOD".localized
        btnAdd.setTitle(("+ " + "TXT_ADD".localized), for: .normal)
        let leftInset = UIEdgeInsets.init(top: 0.0, left: 15.0, bottom: 0.0, right: 0.0)
        let rightInset = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 15.0)
        btnRequestCash.titleEdgeInsets = (LocalizeLanguage.isRTL) ?  rightInset : leftInset
        btnTransferInBank.titleEdgeInsets = (LocalizeLanguage.isRTL) ?  rightInset : leftInset
        self.onClickTransferInBankAccount(btnTransferInBank!)
        self.hideBackButtonTitle()
    }
   
    //Mark: Action Methods
    @IBAction func onClickTransferInBankAccount(_ sender: Any) {
        btnRequestCash.isSelected = false
        btnTransferInBank.isSelected = true
        viewForBank.isHidden = false
    }
    
    @IBAction func onClickBtnAdd(_ sender: UIButton) {
        self.openBankAccountDialog()
    }
    
    @IBAction func onClickRequestCash(_ sender: Any) {
        btnRequestCash.isSelected = true
        btnTransferInBank.isSelected = false
        txtBankAccount.text = ""
        viewForBank.isHidden = true
    }
    @IBAction func onClickWithDrawalRequest(_ sender: Any) {
        if checkValidation() {
           wsCreateWalletRequest()
        }
    }
    
    func checkValidation() -> Bool {
        if ((txtAmount.text?.doubleValue) ?? 0.0 == 0.0) {
            Utility.showToast(message: "MSG_ENTER_VALID_AMOUNT".localized)
            return false
        }
        
        if btnTransferInBank.isSelected && txtBankAccount.text!.isEmpty {
            Utility.showToast(message: "MSG_PLEASE_SELECT_BANK_ACCOUNT_FIRST".localized)
            return false
        }
        if txtDescription.text?.isEmpty ?? true {
            Utility.showToast(message: "MSG_PLEASE_ENTER_DESCRIPTION".localized)
            txtDescription.becomeFirstResponder()
            return false
        }
        return true
    }
    //Mark:Open Dialog
    func openBankAccountDialog() {
        if (arrForBankDetail.count > 0) {
        let dialogForBankAccount = CustomTableDialog.showCustomTableDialog(withDataSource: arrForBankDetail, cellIdentifier: CustomCellIdentifiers.cellForBankName, title: "TXT_SELECT_BANK_ACCOUNT".localized)
        dialogForBankAccount.onItemSelected = { [unowned dialogForBankAccount, unowned self] 
                (selectedItem:Any) in
                self.selectedBankDetail = selectedItem as? BankDetail
                self.txtBankAccount.text = (self.selectedBankDetail?.accountNumber)!
                dialogForBankAccount.removeFromSuperview()
        }
        }else {
            if let bankDetailVC : BankDetailVC = self.storyboard!.instantiateViewController(withIdentifier: "BankDetailVC") as? BankDetailVC {
                bankDetailVC.setData = self
                bankDetailVC.modalPresentationStyle = .overCurrentContext
                self.present(bankDetailVC, animated: false)
            }
        }
    }
    //MARK: Web Service Call
    func wsGetBankDetail() {
        let dictParam : [String : Any] =
            [PARAMS.BANK_HOLDER_TYPE: CONSTANT.TYPE_PROVIDER,
             PARAMS.BANK_HOLDER_ID: preferenceHelper.getUserId(),
             PARAMS.SERVER_TOKEN: preferenceHelper.getSessionToken()
        ]
        let alamoFire:AlamofireHelper = AlamofireHelper();
        Utility.showLoading()
        alamoFire.getResponseFromURL(url: WebService.WS_GET_BANK_DETAIL, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response) {
                self.arrForBankDetail.removeAllObjects()
                let bankDetailResponse:BankDetailResponse = BankDetailResponse.init(fromDictionary: response )
                let bankList:[BankDetail] = bankDetailResponse.bankDetail
                if bankList.count > 0 {
                    for bank in bankList {
                        self.arrForBankDetail.add(bank)
                    }
                }
            }
        }
    }
    
    func wsCreateWalletRequest() {
        Utility.showLoading()
        let dictParam : [String : Any] =
            [PARAMS.TYPE: CONSTANT.TYPE_PROVIDER,
             PARAMS.ID: preferenceHelper.getUserId(),
             PARAMS.SERVER_TOKEN: preferenceHelper.getSessionToken(),
             PARAMS.REQUESTED_WALLET_AMOUNT : txtAmount.text!,
             PARAMS.DESCRIPTION_FOR_REQUESTED_WALLET_AMOUNT : txtDescription.text ?? "",
             PARAMS.TRANSACTION_DETAILS : selectedBankDetail?.toDictionary() as Any,
             PARAMS.IS_PAYMENT_MODE_CASH : btnRequestCash.isSelected
             ]
        let alamoFire:AlamofireHelper = AlamofireHelper();
        
        alamoFire.getResponseFromURL(url: WebService.WS_CREATE_WALLET_REQUEST, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            
            if Parser.isSuccess(response: response,withSuccessToast: true,andErrorToast: true) {
                Utility.hideLoading()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension SelectWalletPaymentVC:UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        if textField == txtBankAccount {
            self.openBankAccountDialog()
            return false
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtAmount {
            let textFieldString = textField.text! as NSString;
            let newString = textFieldString.replacingCharacters(in: range, with:string)
            let floatRegEx = "^([0-9]+)?(\\.([0-9]+)?)?$"
            let floatExPredicate = NSPredicate(format:"SELF MATCHES %@", floatRegEx)
            return floatExPredicate.evaluate(with: newString)
        }
        return true
    }
}
