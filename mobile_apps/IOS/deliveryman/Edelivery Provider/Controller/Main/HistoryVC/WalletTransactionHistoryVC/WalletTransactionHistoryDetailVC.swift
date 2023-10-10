//
//  WalletTransactionHistoryDetailVC.swift
//  Edelivery Provider
//
//  Created by Elluminati iMac on 03/05/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit

class WalletTransactionHistoryDetailVC: BaseVC {

//MARK: OutLets
    
    var walletDetail:WalletRequestDetail? = nil
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
    @IBOutlet weak var lblLine: UILabel!
  
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
        lblRequestedAmountValue.textColor = UIColor.themeTextColor
        lblTotalAmount.textColor = UIColor.themeLightTextColor
        lblTotalAamountValue.textColor = UIColor.themeTextColor
        lblAdminApprovedAmount.textColor = UIColor.themeLightTextColor
        lblAdminApprovedAmountValue.textColor = UIColor.themeTextColor
        lblModeOfTransaction.textColor = UIColor.themeLightTextColor
        lblModeOfTransactionValue.textColor = UIColor.themeTextColor
        lblAmountTag.text = "TXT_AMOUNT_DEDUCTED".localized
        lblAdminApprovedAmount.text = "TXT_ADMIN_APPROVED_AMOUNT".localized + " :"
        lblModeOfTransaction.text = "TXT_MODE_OF_TRANSACTION".localized + " :"
        lblTotalAmount.text = "TXT_TOTAL_WALLET_AMOUNT".localized + " :"
        lblWalletREquestDate.font = FontHelper.textRegular()
        lblAmountTag.textColor = .themeLightTextColor
        lblAmountTag.font = FontHelper.textRegular()
        lblWalletRequestId.font = FontHelper.textMedium(size: 17)
        lblRequestedAmountValue.font = FontHelper.textMedium()
        lblWalletREquestDate.font = FontHelper.textRegular()
        lblTotalAmount.font = FontHelper.textRegular()
        lblTotalAamountValue.font = FontHelper.textMedium()
        lblModeOfTransaction.font = FontHelper.textRegular()
        lblModeOfTransactionValue.font = FontHelper.textMedium()
        lblAdminApprovedAmount.font = FontHelper.textRegular()
        lblAdminApprovedAmountValue.font = FontHelper.textMedium()
        lblLine.backgroundColor = .themeLightTextColor
    }
    
    func setWalletData() {
        if let walletRequestData = walletDetail {
            lblWalletRequestId.text = "TXT_ID".localized + String(walletRequestData.uniqueId)
            lblTotalAamountValue.text = String(walletRequestData.totalWalletAmount) + " " + walletRequestData.walletCurrencyCode
            lblWalletREquestDate.text = Utility.stringToString(strDate: walletRequestData.createdAt, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.MESSAGE_FORMAT)
            let walletRequestStatus:WalletRequestStatus = WalletRequestStatus(rawValue: walletRequestData.walletStatus) ?? .Unknown;
            if  walletRequestStatus == WalletRequestStatus.TRANSFERED || walletRequestStatus == WalletRequestStatus.COMPLETED {
                lblRequestedAmountValue.text =  (walletRequestData.approvedRequstedWalletAmount).toString() + " " + walletRequestData.walletCurrencyCode
            }else {
                lblRequestedAmountValue.text =  (walletRequestData.requstedWalletAmount).toString() + " " + walletRequestData.walletCurrencyCode
            }
            self.setNavigationTitle(title: walletRequestStatus.text())
            if walletRequestData.isPaymentModeCash {
                lblModeOfTransactionValue.text = "TXT_CASH".localized
            }else {
                lblModeOfTransactionValue.text = "TXT_BANK_ACCOUNT".localized
            }
            lblTotalAamountValue.text = String(walletRequestData.totalWalletAmount) + " " + walletRequestData.walletCurrencyCode
            lblAdminApprovedAmountValue.text = String(walletRequestData.approvedRequstedWalletAmount) + " " + walletRequestData.walletCurrencyCode
        }
    }
}
