//
//  WalletHistoryDetailVC.swift
//  // Edelivery Store
//
//  Created by Elluminati iMac on 03/05/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit

class WalletHistoryDetailVC: BaseVC {
    
    
    var walletDetail:WalletHistoryItem? = nil
    
    @IBOutlet weak var lblWalletRequestId: UILabel!
    @IBOutlet weak var lblWalletREquestDate: UILabel!
    
    @IBOutlet weak var viewForCurrentRate: UIView!
    @IBOutlet weak var lblCurrentRate: UILabel!
    @IBOutlet weak var lblCurrentRateValue: UILabel!
    
    
    @IBOutlet weak var lblAmountTag: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblTotalAamountValue: UILabel!
    
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var heightViewForCurrentRate: NSLayoutConstraint!
    @IBOutlet weak var heightViewBG: NSLayoutConstraint!

    //MARK: View life cycle
    override func viewDidLoad(){
        super.viewDidLoad()
        
        setLocalization()
        heightViewBG.constant = 150
        
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
        lblAmount.textColor = UIColor.themeLightTextColor
        lblTotalAmount.textColor = UIColor.themeTextColor
        lblCurrentRate.textColor = UIColor.themeTextColor
        lblWalletRequestId.textColor = UIColor.themeTextColor
        lblWalletREquestDate.textColor = UIColor.themeTextColor
        lblTotalAamountValue.textColor = UIColor.themeTextColor
        lblCurrentRateValue.textColor = UIColor.themeTextColor
        lblDescription.textColor = UIColor.themeTextColor
        
        //Set Font
//        lblWalletRequestId.font = FontHelper.textSmall()
        lblWalletREquestDate.font = FontHelper.textRegular()
        lblAmountTag.textColor = .themeLightTextColor
        
        lblAmountTag.font = FontHelper.textRegular(size: FontHelper.medium)
        lblWalletRequestId.font = FontHelper.textMedium(size: FontHelper.medium)

        lblAmount.font = FontHelper.textRegular()
        lblTotalAmount.font = FontHelper.textRegular()
        lblCurrentRate.font = FontHelper.textRegular()
        
        lblTotalAamountValue.font = FontHelper.textMedium()
        lblCurrentRateValue.font = FontHelper.textMedium()
        lblDescription.font = FontHelper.textRegular()
        
        
        //Set Text
        lblTotalAmount.text = "TXT_TOTAL_WALLET_AMOUNT".localizedCapitalized + " : "
        lblCurrentRate.text = "TXT_CURRENT_RATE".localized + " : "
        setupLayout()

    }
    
    func setupLayout() {
        self.setWalletData()
    }
    
    func setWalletData() {
        if let walletRequestData = walletDetail {
            lblWalletRequestId.text =  "TXT_ID".localized +  String(walletRequestData.uniqueId) +  "  "
            
            lblWalletREquestDate.text = Utility.stringToString(strDate: walletRequestData.createdAt, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_TIME_FORMAT)

            let walletHistoryStatus:WalletHistoryStatus = WalletHistoryStatus(rawValue: walletRequestData.walletCommentId) ?? .Unknown;
            self.setNavigationTitle(title: walletHistoryStatus.text())
        
            lblDescription.text = walletRequestData.walletDescription
            lblTotalAamountValue.text = (walletRequestData.totalWalletAmount).toString() + " " + walletRequestData.fromCurrencyCode
                        
            switch (walletRequestData.walletStatus) {
            case WalletStatus.ADD_WALLET_AMOUNT:
                lblAmount.textColor = UIColor.themeWalletAddedColor
                lblAmountTag.text = "TXT_AMOUNT_ADDED".localizedUppercase
                lblAmount.text =  "+" +
                    (walletDetail?.addedWallet ?? 0.0).toString() + (walletDetail?.toCurrencyCode)!
                lblTotalAamountValue.text =   (walletDetail?.totalWalletAmount ?? 0.0).toString() + (walletDetail?.toCurrencyCode)!
                break;
            case WalletStatus.REMOVE_WALLET_AMOUNT:
                
                lblAmount.textColor = UIColor.themeWalletDeductedColor
                lblAmountTag.text = "TXT_AMOUNT_DEDUCTED".localizedUppercase
                lblAmount.text =  "-" + (walletDetail?.addedWallet ?? 0.0).toString() + (walletDetail?.fromCurrencyCode)!
                lblTotalAamountValue.text =   (walletDetail?.totalWalletAmount ?? 0.0).toString() + (walletDetail?.fromCurrencyCode)!
                
                break;
            default:
                break;
            }
            
            if (walletRequestData.currentRate == 1.0) {
                viewForCurrentRate.isHidden = true
                heightViewForCurrentRate.constant = 0
                heightViewBG.constant = heightViewBG.constant - 25
            } else {
                viewForCurrentRate.isHidden = false
                heightViewForCurrentRate.constant = 30
                heightViewBG.constant = heightViewBG.constant + 25
                
                lblCurrentRateValue.text =  "1 " + walletRequestData.fromCurrencyCode + " (" + String(format: "%.4f", arguments: [walletRequestData.currentRate]) + walletRequestData.toCurrencyCode + ")"
                
            }
        }
    }
}
