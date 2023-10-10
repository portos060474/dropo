//
//  WalletPaymentVC.swift
//  Store
//
//  Created by Elluminati on 18/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class WalletPaymentVC: BaseVC,RightDelegate {

    
    //Wallet View
    @IBOutlet weak var lblWallet: UILabel!
    @IBOutlet weak var lblCurrentBalance: UILabel!
    @IBOutlet weak var viewForAddWallet: UIView!
    @IBOutlet weak var txtWalletAmount: UITextField!
    @IBOutlet weak var lblWalletAmount: UILabel!
    @IBOutlet weak var btnAddToWallet: UIButton!
    //Select withdrawel method
    @IBOutlet weak var viewForSelectWithdrawalMethod: UIView!
    @IBOutlet weak var lblSelectWithdrawMethod: UILabel!
    
    
    override func viewDidLoad(){
        super.viewDidLoad();
        delegateRight = self
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.selectWithdrawMethod(gestureRecognizer:)))
        //gestureRecognizer.delegate = self
        viewForSelectWithdrawalMethod.addGestureRecognizer(gestureRecognizer)
        super.setRightBarItem(isNative: false)
        super.setRightBarItemImage(image: UIImage.init(named: "walletHistoryIcon")!)
        self.hideBackButtonTitle()
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
        adjustLabel(label:lblWallet, title:"TXT_WALLET".localized)
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
    func adjustLabel(label:UILabel, title:String) {
        label.backgroundColor = UIColor.themeColor
        label.textColor = UIColor.themeButtonTitleColor
        
        label.text = title.appending("     ")
        label.sectionRound(label)
        
    }
    func onClickRightButton() {
        self.performSegue(withIdentifier: SEGUE.WALLET_TO_HISTORY, sender: self)
    }
    func setLocalization() {
        //Colors
        btnAddToWallet.setTitleColor(UIColor.themeColor, for: UIControl.State.normal);
        btnAddToWallet.backgroundColor = UIColor.clear
        txtWalletAmount.textColor = UIColor.themeTextColor
        //localizing text
        self.setNavigationTitle(title:"TXT_PAYMENT".localized)
        lblCurrentBalance.text = "TXT_CURRENT_BALANCE".localizedCapitalized
        txtWalletAmount.placeholder = "TXT_WALLET_HINT".localized
        txtWalletAmount.keyboardType = .numberPad
        /* Set Font */
        btnAddToWallet.titleLabel?.font = FontHelper.textRegular()
        txtWalletAmount.font = FontHelper.textRegular()
        
        lblWalletAmount.isHidden = false
        viewForAddWallet.isHidden = true
        lblWalletAmount.font = FontHelper.textLarge()
        lblWalletAmount.textColor = UIColor.themeTextColor
        
        lblSelectWithdrawMethod.text = "TXT_SELECT_WITHDRAWAL_METHOD".localizedCapitalized
        
        lblSelectWithdrawMethod.font = FontHelper.textRegular()
        lblSelectWithdrawMethod.textColor = UIColor.themeTextColor
        lblWalletAmount.text =  String(StoreSingleton.shared.store.wallet) + " " + StoreSingleton.shared.store.walletCurrencyCode
        self.hideBackButtonTitle()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gestureRecognizer:)))
//        gestureRecognizer.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func handleTap(gestureRecognizer: UIGestureRecognizer)
    {
       self.view.endEditing(true)
    }
    
    @objc func selectWithdrawMethod(gestureRecognizer: UIGestureRecognizer) {
        self.performSegue(withIdentifier: SEGUE.SELECT_WITHDRAW_METHOD, sender: self)
    }
    //Mark: Action Methods
    @IBAction func onClickBtnAddWallet(_ sender: Any) {
        if btnAddToWallet.tag == 0 {
            updateWalletView(isUpdate:true)
        }else {
                if ((txtWalletAmount.text?.doubleValue) != nil) {
                }
                else {
                    Utility.showToast(message: "MSG_ENTER_VALID_AMOUNT".localized)
                }
            }
            
        }
    func updateWalletView(isUpdate:Bool) {
        if  isUpdate {
            btnAddToWallet.tag = 1
            txtWalletAmount.text = ""
            txtWalletAmount.becomeFirstResponder()
            btnAddToWallet.setTitle("TXT_SUBMIT".localized, for: .normal)
            viewForAddWallet.isHidden = false
            lblWalletAmount.isHidden = true
        }else {
            btnAddToWallet.tag = 0
           
            
            txtWalletAmount.resignFirstResponder()
            btnAddToWallet.setTitle("TXT_ADD".localized, for: .normal)
            viewForAddWallet.isHidden = true
            lblWalletAmount.isHidden = false
            
        }
    }
    
    //MARK:- Web Serivice Calls
    
}


extension WalletPaymentVC:UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtWalletAmount {
            
            let textFieldString = textField.text! as NSString;
            
            let newString = textFieldString.replacingCharacters(in: range, with:string)
            
            let floatRegEx = "^([0-9]+)?(\\.([0-9]+)?)?$"
            
            let floatExPredicate = NSPredicate(format:"SELF MATCHES %@", floatRegEx)
            
            return floatExPredicate.evaluate(with: newString)
        }
        return true
        
    }
    
}
