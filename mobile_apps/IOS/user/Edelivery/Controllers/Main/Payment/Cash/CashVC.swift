//
//  StripeVCViewController.swift
//  edelivery
//
//  Created by Elluminati on 17/04/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class CashVC: BaseVC {
   
    //MARK:- Outlets
    @IBOutlet weak var lblCashMessage: UILabel!
    @IBOutlet weak var lblKeepBringChange: UILabel!
    @IBOutlet weak var switchBringChange: UISwitch!
    @IBOutlet weak var viewBringChange: UIView!
    
    //MARK:- Variables
    //MARK:- View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        setLocalization()
        if preferenceHelper.getIsAllowBringChange() {
            if currentBooking.isUserPickUpOrder || currentBooking.isQrCodeScanBooking || Utility.isTableBooking() {
                viewBringChange.isHidden = true
            } else {
                viewBringChange.isHidden = false
            }
        } else {
            viewBringChange.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setLocalization() {
        lblCashMessage.textColor = UIColor.themeTextColor
        lblCashMessage.font = FontHelper.textRegular()
        lblCashMessage.text = "TXT_CASH_MESSAGE".localized
        lblCashMessage.textAlignment = .center
        
        lblKeepBringChange.text = "txt_keep_bring_change".localized
        lblKeepBringChange.font = FontHelper.textMedium(size: FontHelper.mediumLarge)
    }
}
