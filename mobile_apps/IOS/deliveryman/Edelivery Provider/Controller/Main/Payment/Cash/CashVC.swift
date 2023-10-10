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
   
    //MARK:- View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        setLocalization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setLocalization() {
        lblCashMessage.textColor = UIColor.themeTextColor
        lblCashMessage.font = FontHelper.textRegular()
        lblCashMessage.text = "TXT_CASH_MESSAGE".localized
        lblCashMessage.textAlignment = .center
        
    }
}
