//
//  ShareVC.swift
//  edelivery
//
//  Created by Elluminati on 14/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class ShareVC: BaseVC {
    
    @IBOutlet weak var lblHeight: NSLayoutConstraint!
    @IBOutlet weak var lblReferralCode: UILabel!
    @IBOutlet weak var lblCodeBorder: UILabel!
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
        lblReferralCode.sizeToFit()
        self.lblHeight.constant = 45
       
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
        
        adjustLabel(label:lblShare, title:"TXT_SHARE".localized)
        adjustLabel(label:lblWallet, title:"TXT_WALLET".localized)
        let labelBorder = CAShapeLayer()
        labelBorder.strokeColor = UIColor.themeLightTextColor.cgColor
        labelBorder.lineWidth = 3.0
        labelBorder.lineDashPattern = [10, 5]
        labelBorder.frame = lblCodeBorder.bounds
        labelBorder.path = UIBezierPath(rect: lblCodeBorder.bounds).cgPath
        labelBorder.fillColor = UIColor.clear.cgColor
        labelBorder.name = "border"
        for layer in (lblCodeBorder.layer.sublayers ?? []) {
            if let borderLayer: CAShapeLayer = (layer as? CAShapeLayer), borderLayer.name == "border" {
                return
            }
        }
        lblCodeBorder.layer.addSublayer(labelBorder)
    }
    
    func setLocalization() {
        view.backgroundColor = UIColor.themeViewBackgroundColor
        self.hideBackButtonTitle()
        
        /*set Titles*/
        lblReferral.text = "TXT_REFERRAL_CODE".localizedCapitalized
        lblReferralMessage.text = "MSG_REFERRAL".localized.replacingOccurrences(of: "****", with: "APP_NAME".localized)
        lblCurrentBalance.text = "TXT_CURRENT_BALANCE".localizedCapitalized
        lblWallet.text = "TXT_WALLET".localizedCapitalized + "     "
        lblShare.text = "TXT_SHARE".localizedCapitalized + "     "
        btnShare.setTitle("TXT_SHARE_WITH_FRIEND".localizedCapitalized, for: UIControl.State.normal)
        self.setNavigationTitle(title: "TXT_SHARE".localizedCapitalized)
        lblReferralCode.text =  preferenceHelper.getReferralCode() + "    "
        lblReferralCode.textAlignment = .center
        lblWalletAmount.text = preferenceHelper.getWalletAmount() + " " + preferenceHelper.getWalletCurrencyCode()

        /*Set Color*/
        lblShare.backgroundColor = UIColor.themeSectionBackgroundColor
        lblWallet.backgroundColor = UIColor.themeSectionBackgroundColor
        btnShare.backgroundColor = UIColor.themeButtonBackgroundColor
        lblShare.textColor = UIColor.themeButtonTitleColor
        lblWallet.textColor = UIColor.themeButtonTitleColor
        lblCurrentBalance.textColor = UIColor.themeLightTextColor
        lblWalletAmount.textColor = UIColor.themeTextColor
        lblReferralMessage.textColor = UIColor.themeTextColor
        lblReferralCode.textColor = UIColor.themeTextColor
        lblReferral.textColor = UIColor.themeLightTextColor
        
        /* Set Font */
        btnShare.titleLabel?.font = FontHelper.buttonText()
        lblShare.font = FontHelper.textRegular()
        lblWallet.font = FontHelper.textRegular()
        lblCurrentBalance.font = FontHelper.textSmall()
        lblWalletAmount.font = FontHelper.textLarge()
        lblReferralMessage.font = FontHelper.textSmall()
        lblReferralCode.font = FontHelper.textMedium()
        lblReferral.font = FontHelper.textMedium()
    }
    
//MARK:
//MARK: Button action methods
  
    @IBAction func onClickBtnShare(_ sender: Any) {
        
        let myString = String(format: NSLocalizedString("SHARE_REFERRAL", comment: ""),String(preferenceHelper.getReferralCode()))
        let textToShare = [ myString ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        self.navigationController?.present(activityViewController, animated: true, completion: nil)
    }
    
    func adjustLabel(label:UILabel, title:String) {
        label.text = title.appending("    ")
        label.sectionRound(label)
    }
}
