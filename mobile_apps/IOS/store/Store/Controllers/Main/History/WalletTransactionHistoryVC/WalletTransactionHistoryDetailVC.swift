//
//  WalletTransactionHistoryDetailVC.swift
//  // Edelivery Store
//
//  Created by Elluminati iMac on 03/05/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit

class WalletTransactionHistoryDetailVC: BaseVC {

    
    var walletDetail:WalletRequestDetail? = nil
    
    
    @IBOutlet weak var imgTransactionType: UIImageView!
    @IBOutlet weak var lblWalletRequestId: UILabel!
    @IBOutlet weak var lblWalletREquestDate: UILabel!
    
    @IBOutlet weak var lblAmountTag: UILabel!
    @IBOutlet weak var lblRequestedAmountValue: UILabel!
    
    
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblTotalAamountValue: UILabel!
    
    @IBOutlet weak var lblAdminApprovedAmount: UILabel!
    @IBOutlet weak var lblAdminApprovedAmountValue: UILabel!
    
    @IBOutlet weak var lblModeOfTransaction: UILabel!
    @IBOutlet weak var lblModeOfTransactionValue: UILabel!
    
    //MARK: View life cycle
    override func viewDidLoad(){
        super.viewDidLoad()
        
        setLocalization()
        setWalletData()
        
    }
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews();
    }
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews();
        setupLayout()
    }
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(_ animated: Bool){
        super.viewDidDisappear(animated)
        
    }
    
    //MARK: Set localized layout
    func setLocalization() {
        //Set Color
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        lblWalletRequestId.textColor = UIColor.themeTextColor
        lblWalletREquestDate.textColor = UIColor.themeLightTextColor
        lblAmountTag.textColor = UIColor.themeLightTextColor
//        lblRequestedAmountValue.textColor = UIColor.themeSectionBackgroundColor
        
        lblRequestedAmountValue.textColor = .themeTextColor
        
        lblTotalAmount.textColor = UIColor.themeTextColor
        lblTotalAamountValue.textColor = UIColor.themeTextColor
        
        lblAdminApprovedAmount.textColor = UIColor.themeTextColor
        lblAdminApprovedAmountValue.textColor = UIColor.themeTextColor
        
        lblModeOfTransaction.textColor = UIColor.themeTextColor
        lblModeOfTransactionValue.textColor = UIColor.themeTextColor
        
        lblAmountTag.text = "TXT_AMOUNT_DEDUCTED".localizedUppercase
        lblAdminApprovedAmount.text = "TXT_ADMIN_APPROVED_AMOUNT".localized + " : "
        lblTotalAmount.text = "TXT_TOTAL_WALLET_AMOUNT".localized + " : "
        lblModeOfTransaction.text = "TXT_MODE_OF_TRANSACTION".localized + " : "
        
        lblWalletRequestId.font = FontHelper.textMedium(size: FontHelper.medium)
        lblWalletREquestDate.font = FontHelper.textRegular()
        lblAmountTag.font = FontHelper.textRegular(size: FontHelper.medium)
        lblTotalAmount.font = FontHelper.textRegular()
        lblAdminApprovedAmount.font = FontHelper.textRegular()
        lblAdminApprovedAmountValue.font = FontHelper.textMedium()

        lblTotalAamountValue.font = FontHelper.textMedium()
        lblModeOfTransaction.font = FontHelper.textRegular()
        lblModeOfTransactionValue.font = FontHelper.textMedium()
        lblRequestedAmountValue.font = FontHelper.textRegular(size: 17.0)
        
    }
    func setupLayout() {
        
        
        
    }
    func setWalletData() {
        if let walletRequestData = walletDetail {
            lblWalletRequestId.text = "TXT_ID".localized + String(walletRequestData.uniqueId)
              let walletRequestStatus:WalletRequestStatus = WalletRequestStatus(rawValue: walletRequestData.walletStatus) ?? .Unknown;
            
            if  walletRequestStatus == WalletRequestStatus.TRANSFERED || walletRequestStatus == WalletRequestStatus.COMPLETED {
                
                lblRequestedAmountValue.text =  (walletRequestData.approvedRequstedWalletAmount).toString() + " " + walletRequestData.walletCurrencyCode
            }else {
                lblRequestedAmountValue.text =  (walletRequestData.requstedWalletAmount).toString() + " " + walletRequestData.walletCurrencyCode
            }
            
//            switch (walletRequestData.walletStatus) {
//            case WalletStatus.ADD_WALLET_AMOUNT:
//                lblRequestedAmountValue.textColor = UIColor.themeWalletAddedColor
//                break;
//            case WalletStatus.REMOVE_WALLET_AMOUNT:
//                lblRequestedAmountValue.textColor = UIColor.themeWalletDeductedColor
//                break;
//             default:
//                break;
//            }
            
            lblTotalAamountValue.text = (walletRequestData.totalWalletAmount).toString() + " " + walletRequestData.walletCurrencyCode
            
            lblWalletREquestDate.text = Utility.stringToString(strDate: walletRequestData.createdAt, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_TIME_FORMAT)
            
          
            self.setNavigationTitle(title: walletRequestStatus.text())
            
            if walletRequestData.isPaymentModeCash {
//                imgTransactionType.image = UIImage.init(named: "wallet_cash")
                lblModeOfTransactionValue.text = "TXT_CASH_PAYMENT".localized
            }else {
                
//                imgTransactionType.image = UIImage.init(named: "wallet_bank")
                lblModeOfTransactionValue.text = "TXT_BANK_ACCOUNT".localized
            }
            
            
            lblTotalAamountValue.text = (walletRequestData.totalWalletAmount).toString() + " " + walletRequestData.walletCurrencyCode
            lblAdminApprovedAmountValue.text = (walletRequestData.approvedRequstedWalletAmount).toString() + " " + walletRequestData.walletCurrencyCode
            
        }
    }
}
