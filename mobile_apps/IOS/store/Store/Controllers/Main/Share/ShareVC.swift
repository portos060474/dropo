//
//  ShareVC.swift
// Edelivery Store
//
//  Created by Jaydeep Vyas on 14/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class ShareVC: BaseVC {
   
 

    @IBOutlet weak var lblReferralCode: UILabel!
    @IBOutlet weak var btnShare: UIButton!
    
    @IBOutlet weak var lblReferral: UILabel!
    
    @IBOutlet weak var lblReferralMessage: UILabel!
    @IBOutlet weak var lblShare: UILabel!
    @IBOutlet weak var lblWallet: UILabel!
    @IBOutlet weak var lblCurrentBalance: UILabel!
    @IBOutlet weak var lblWalletAmount: UILabel!
//MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalization()
     }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
   
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
    }
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        setupLayout()
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
    func setupLayout(){
        lblReferralCode.sizeToFit()
        self.view.layoutIfNeeded()
        
        
        let labelBorder = CAShapeLayer()
        labelBorder.strokeColor = UIColor.themeLightTextColor.cgColor
        labelBorder.lineWidth = 3.0
        labelBorder.lineDashPattern = [10, 5]
        labelBorder.frame = lblReferralCode.bounds
        labelBorder.path = UIBezierPath(rect: lblReferralCode.bounds).cgPath
        labelBorder.fillColor = UIColor.clear.cgColor
        lblReferralCode.layer.addSublayer(labelBorder)
        
        
        adjustLabel(label:lblShare, title:"TXT_SHARE".localized)
        adjustLabel(label:lblWallet, title:"TXT_WALLET".localized)
        
        
        
        
    }
    func setLocalization() {
        view.backgroundColor = UIColor.themeViewBackgroundColor;
        self.hideBackButtonTitle()
        
        /*set Titles*/
        
        
        lblReferral.text = "TXT_REFERRAL_CODE".localizedCapitalized
        lblReferralMessage.text = "MSG_REFERRAL".localized
        lblCurrentBalance.text = "TXT_CURRENT_BALANCE".localizedCapitalized
        lblWallet.text = "TXT_WALLET".localizedCapitalized + "     "
        lblShare.text = "TXT_SHARE".localizedCapitalized + "     "
        
        btnShare.setTitle("TXT_SHARE".localizedUppercase, for: UIControl.State.normal)
        self.setNavigationTitle(title: "TXT_SHARE".localizedCapitalized)
        
        lblReferralCode.text =  "    " + StoreSingleton.shared.store.referralCode + "    "
        
        
        lblReferralCode.textAlignment = .left
        
        lblWalletAmount.text = String( StoreSingleton.shared.store.wallet) + " " + StoreSingleton.shared.store.walletCurrencyCode
        
        /*Set Color*/
        lblShare.backgroundColor = UIColor.themeColor
        lblWallet.backgroundColor = UIColor.themeColor
        
        
        btnShare.backgroundColor = UIColor.themeColor
        lblShare.textColor = UIColor.themeButtonTitleColor
        lblWallet.textColor = UIColor.themeButtonTitleColor
        lblCurrentBalance.textColor = UIColor.themeLightTextColor
        lblWalletAmount.textColor = UIColor.themeTextColor
        lblReferralMessage.textColor = UIColor.themeTextColor
        lblReferralCode.textColor = UIColor.themeTextColor
        lblReferral.textColor = UIColor.themeLightTextColor
        
        
        /* Set Font */
        
        btnShare.titleLabel?.font = FontHelper.textRegular()
        lblShare.font = FontHelper.textRegular()
        lblWallet.font = FontHelper.textRegular()
        
        lblCurrentBalance.font = FontHelper.textSmall()
        lblWalletAmount.font = FontHelper.textLarge()
        
        
        lblReferralMessage.font = FontHelper.textSmall()
        lblReferralCode.font = FontHelper.textMedium()
        lblReferral.font = FontHelper.textMedium()
    }
//MARK: Button action methods
  
    @IBAction func onClickBtnShare(_ sender: Any) {
        
        let myString = String(format: NSLocalizedString("SHARE_REFERRAL", comment: ""),String(StoreSingleton.shared.store.referralCode))
        
        
        let textToShare = [ myString ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    func adjustLabel(label:UILabel, title:String) {
        label.text = title.appending("    ")
        label.sectionRound(label)
        
    }
}
