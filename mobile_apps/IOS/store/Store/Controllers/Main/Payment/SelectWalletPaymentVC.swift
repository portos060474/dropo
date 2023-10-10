//
//  SelectWalletPaymentVC.swift
//  Store
//
//  Created by Elluminati on 18/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class SelectWalletPaymentVC: BaseVC,UIScrollViewDelegate,presentDataSet {

    
    //Wallet View
    @IBOutlet weak var lblSelectWithdrawalMethod: UILabel!
   
    //Select withdrawel method
    @IBOutlet weak var lbl01: UILabel!
    @IBOutlet weak var lbl02: UILabel!
    @IBOutlet weak var lbl03: UILabel!
    @IBOutlet weak var lbl04: UILabel!
    @IBOutlet weak var scrSelectPayment: UIScrollView!
    
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
    
    
    @IBOutlet weak var viewForBank: UIView!
    @IBOutlet weak var lblDownArrow: UILabel!

     var arrForBankDetail : NSMutableArray = NSMutableArray.init()
    var selectedBankDetail:BankDetail? = nil
    let downArrow:String = "\u{25BC}"

    
    override func viewDidLoad() {
        super.viewDidLoad();
        wsGetBankDetail()
       setLocalization()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
    }
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews();
//        adjustLabel(label:lblSelectWithdrawalMethod, title:"TXT_SELECT_WITHDRAWAL_METHOD".localized)
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
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setLocalization()
    }
    
    func adjustLabel(label:UILabel, title:String) {
        label.backgroundColor = UIColor.themeColor
        label.textColor = UIColor.themeButtonTitleColor
        label.text = title.appending("     ")
//        label.sectionRound(label)
    }
    
    func setLocalization() {
        //Colors
        lbl01.textColor = UIColor.themeColor
        lbl02.textColor = UIColor.themeColor
        lbl03.textColor = UIColor.themeColor
        lbl04.textColor = UIColor.themeColor
        lblBankAccount.textColor = UIColor.themeTextColor
        lblTransferType.textColor = UIColor.themeTextColor
        
        txtBankAccount.delegate = self
        txtDescription.delegate = self
        
        lblEnterAmount.textColor = UIColor.themeTextColor
        txtAmount.textColor = UIColor.themeTextColor
        txtBankAccount.textColor = UIColor.themeTextColor
        lblBankAccount.textColor = UIColor.themeTextColor
        lblDescription.textColor = UIColor.themeTextColor
        txtDescription.textColor = UIColor.themeTextColor
        
        txtAmount.keyboardType = .numberPad
        btnTransferInBank.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnRequestCash.setTitleColor(UIColor.themeTextColor, for: .normal)
        
        /*Set Font*/
        lbl01.font = FontHelper.textLarge()
        lbl02.font = FontHelper.textLarge()
        lbl03.font = FontHelper.textLarge()
        lbl04.font = FontHelper.textLarge()
        
        lblTransferType.font = FontHelper.textRegular(size: 13.0)
        btnTransferInBank.titleLabel?.font = FontHelper.textRegular(size: 13.0)
        btnRequestCash.titleLabel?.font = FontHelper.textRegular(size: 13.0)
        
        btnRequestWithdraw.setTitle("TXT_REQUEST_WITHDRAWAL".localizedCapitalized, for: .normal)
        self.btnRequestWithdraw.backgroundColor = UIColor.themeColor
        self.btnRequestWithdraw.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        self.btnRequestWithdraw.titleLabel?.font = FontHelper.buttonText()
        self.btnRequestWithdraw.setRound(withBorderColor: .clear, andCornerRadious: self.btnRequestWithdraw.frame.size.height/2, borderWidth: 1.0)
        
        lblEnterAmount.font = FontHelper.textRegular(size: 13.0)
        txtAmount.font = FontHelper.textRegular()
        txtBankAccount.font = FontHelper.textRegular()
        lblBankAccount.font = FontHelper.textRegular(size: 13.0)
        lblDescription.font = FontHelper.textRegular(size: 13.0)
        txtDescription.font = FontHelper.textRegular()
        
        txtAmount.borderStyle = .roundedRect
        txtDescription.borderStyle = .roundedRect
        txtBankAccount.borderStyle = .roundedRect
        
        txtAmount.tintColor = .themeTextColor
        txtDescription.tintColor = .themeTextColor
        txtBankAccount.tintColor = .themeTextColor
        
        
        lblDownArrow.text = downArrow + "   "
        lblDownArrow.textColor = .themeTextColor
        /*Set Text*/
        lblSelectWithdrawalMethod.text = "TXT_SELECT_WITHDRAWAL_METHOD".localizedUppercase
        lblTransferType.text = "TXT_HOW_WOULD_YOU_LIKE_TO_REQUEST".localized
        if UIApplication.isRTL(){
            btnTransferInBank.contentHorizontalAlignment = .right
            btnRequestCash.contentHorizontalAlignment = .right
            btnTransferInBank.setTitle("    "+"TXT_TRANSFER_TO_BANK_ACCOUNT".localized, for: .normal)
            btnRequestCash.setTitle("    "+"TXT_REQUEST_CASH".localized, for: .normal)
        }else{
            btnRequestCash.contentHorizontalAlignment = .left
            btnTransferInBank.contentHorizontalAlignment = .left
            btnTransferInBank.setTitle("TXT_TRANSFER_TO_BANK_ACCOUNT".localized, for: .normal)
            btnRequestCash.setTitle("TXT_REQUEST_CASH".localized, for: .normal)
        }
        
        lblDescription.text = "TXT_DESCRIPTION".localized
        lblEnterAmount.text = "TXT_ENTER_AMOUNT_TO_WITHDRAW".localized
        txtAmount.placeholder =  "TXT_AMOUNT".localized
        lblBankAccount.text = "TXT_BANK_ACCOUNT".localized
        txtBankAccount.placeholder =  "TXT_SELECT_BANK_ACCOUNT".localized
        txtDescription.placeholder = "TXT_DESCRIPTION".localized
        lbl01.text = "TXT_01".localized
        lbl02.text = "TXT_02".localized
        lbl03.text = "TXT_03".localized
        lbl04.text = "TXT_04".localized
        
        btnTransferInBank.setImage(UIImage(named: "radio_btn_unchecked_icon"), for: .normal)
        btnRequestCash.setImage(UIImage(named: "radio_btn_unchecked_icon"), for: .normal)
        
        btnTransferInBank.setImage(UIImage(named: "radio_btn_checked_icon")?.imageWithColor(color: .themeColor), for: .selected)
        btnRequestCash.setImage(UIImage(named: "radio_btn_checked_icon")?.imageWithColor(color: .themeColor), for: .selected)

        
        self.setNavigationTitle(title: "TXT_WITHDRAWAL".localizedCapitalized)
        
        
        self.onClickTransferInBankAccount(btnTransferInBank)
        self.hideBackButtonTitle()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gestureRecognizer:)))
        self.view.addGestureRecognizer(gestureRecognizer)
    }
   
    @objc func handleTap(gestureRecognizer: UIGestureRecognizer)
    {
       self.view.endEditing(true)
    }
    
    //Mark: Action Methods
    @IBAction func onClickTransferInBankAccount(_ sender: Any) {
        btnRequestCash.isSelected = false
        btnTransferInBank.isSelected = true
        viewForBank.isHidden = false
    }
    
    @IBAction func onClickRequestCash(_ sender: Any) {
        btnRequestCash.isSelected = true
        btnTransferInBank.isSelected = false
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
        if btnTransferInBank.isSelected && txtBankAccount.text!.isEmpty() {
            Utility.showToast(message: "MSG_PLEASE_SELECT_BANK_ACCOUNT_FIRST".localized)
            return false
        }
        return true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.x = 0
    }
    
    //Mark:Open Dialog
    func setData() {
           wsGetBankDetail()
       }
      func openBankAccountDialog() {
           if (arrForBankDetail.count > 0) {
           let dialogForBankAccount = CustomTableDialog.showCustomTableDialog(withDataSource: arrForBankDetail, cellIdentifier: CustomCellIdentifiers.cellForBankName, title: "TXT_SELECT_BANK_ACCOUNT".localized)
           dialogForBankAccount.onItemSelected = { [unowned self, unowned dialogForBankAccount]
                   (selectedItem:Any) in
                   self.selectedBankDetail = selectedItem as? BankDetail
                   self.txtBankAccount.text = (self.selectedBankDetail?.accountNumber)!
                  dialogForBankAccount.removeFromSuperview()
           }
           }else {
               
               if let bankDetailVC = storyboard?.instantiateViewController(withIdentifier: "AddBankDetail") as? BankDetailVC {
                //self.navigationController?.pushViewController(bankDetailVC, animated: true)
                   bankDetailVC.setData = self
                   bankDetailVC.modalPresentationStyle = .overCurrentContext
                   self.present(bankDetailVC, animated: false)
               }
           }
      }
    //Mark: Web Service Call
    func wsGetBankDetail() {
        let dictParam : [String : Any] =
            [PARAMS.BANK_HOLDER_TYPE: String(CONSTANT.TYPE_STORE),
             PARAMS.BANK_HOLDER_ID: preferenceHelper.getUserId(),
             PARAMS.SERVER_TOKEN: preferenceHelper.getSessionToken()]
        
        let alamoFire:AlamofireHelper = AlamofireHelper();
        
        alamoFire.getResponseFromURL(url: WebService.WS_GET_BANK_DETAIL, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            
            if Parser.isSuccess(response: response) {
                self.arrForBankDetail.removeAllObjects()
                let bankDetailResponse:BankDetailResponse = BankDetailResponse.init(fromDictionary: response)
                
                let bankList:[BankDetail] = bankDetailResponse.bankDetail
                if bankList.count > 0 {
                    for bank in bankList
                    {
                        self.arrForBankDetail.add(bank)
                    }
                    
                }
            }
        }
    }
    func wsCreateWalletRequest() {
        Utility.showLoading()
        let dictParam : [String : Any] =
            [PARAMS.TYPE:String(CONSTANT.TYPE_STORE),
             PARAMS.ID: preferenceHelper.getUserId(),
             PARAMS.SERVER_TOKEN: preferenceHelper.getSessionToken(),
             PARAMS.REQUESTED_WALLET_AMOUNT : txtAmount.text!,
             PARAMS.DESCRIPTION_FOR_REQUESTED_WALLET_AMOUNT : txtDescription.text ?? "",
             PARAMS.TRANSACTION_DETAILS : selectedBankDetail?.toDictionary() ?? "",
             PARAMS.IS_PAYMENT_MODE_CASH : btnRequestCash.isSelected
             ]
        let alamoFire:AlamofireHelper = AlamofireHelper();
        
        alamoFire.getResponseFromURL(url: WebService.WS_CREATE_WALLET_REQUEST, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            
            print(response)
            if Parser.isSuccess(response: response,withSuccessToast: true,andErrorToast: true) {
                Utility.hideLoading()
                _ = self.navigationController?.popViewController(animated: true)
            }else{
                Utility.hideLoading()
            }
        }
    }
}

extension SelectWalletPaymentVC:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
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
