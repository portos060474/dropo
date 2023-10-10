//
//  OrderPlacedVC.swift
//  edelivery
//
//  Created by Elluminati on 14/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

protocol didTapOnTrackOrder {
    func didTapOnTrackOrder()
}

protocol didTapOnCancel {
    func didTapOnCancel()
}

class OrderPlacedVC: BaseVC, LeftDelegate {
    @IBOutlet weak var lblThankYou: UILabel!
    @IBOutlet weak var lblOrderPlaced: UILabel!

    //MARK:- Outlets
    @IBOutlet weak var btnTrackOrder: UIButton!
    @IBOutlet weak var scrView: UIScrollView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var imgThankYou: UIImageView!

    var delegateOnTrackOrder : didTapOnTrackOrder? = nil
    var delegateOnCancel: didTapOnCancel? = nil

    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalization()
        delegateLeft = self
        self.setBackBarItem(isNative: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.animationBottomTOTop(self.alertView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        alertView.applyTopCornerRadius()
    }

    func onClickLeftButton() {
        APPDELEGATE.goToMain()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    func setLocalization() {
        //Colors
        self.view.backgroundColor = UIColor.themeOverlayColor
        btnTrackOrder.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        btnTrackOrder.backgroundColor = UIColor.themeButtonBackgroundColor
        lblOrderPlaced.textColor = UIColor.themeTextColor
        lblThankYou.textColor = UIColor.themeTextColor

        //Localizing
        self.setNavigationTitle(title: "TXT_ORDER_PLACED".localizedCapitalized)
        self.lblTitle.text = "TXT_THANK_YOU".localized
        lblThankYou.text = "TXT_THANK_YOU".localized

        if currentBooking.isQrCodeScanBooking {
            btnTrackOrder.setTitle("TXT_OK".localizedCapitalized, for: UIControl.State.normal)
            lblOrderPlaced.text = "TXT_YOUR_ORDER_PLACED".localized
            imgThankYou.image = UIImage.init(named: "thankyou")
        }
        else if Utility.isTableBooking() {
            btnTrackOrder.setTitle("btn_book_another".localizedCapitalized, for: UIControl.State.normal)
            lblOrderPlaced.text = "msg_success_table_booking".localized
            imgThankYou.image = UIImage.init(named: "table_book_thankyou")
        } else {
            btnTrackOrder.setTitle("TXT_TRACK_YOUR_ORDER".localizedCapitalized, for: UIControl.State.normal)
            lblOrderPlaced.text = "TXT_YOUR_ORDER_PLACED".localized
            imgThankYou.image = UIImage.init(named: "thankyou")
        }

        /*Set Font*/
        lblOrderPlaced.font = FontHelper.textRegular()
        lblThankYou.font = FontHelper.textMedium()
        btnTrackOrder.titleLabel?.font = FontHelper.textMedium()
        self.hideBackButtonTitle()
        self.btnLeft.setImage(UIImage(named:"cancelIcon")?.imageWithColor(color: UIColor.themeColor), for: .normal)
        lblTitle.font = FontHelper.textMedium(size: FontHelper.large)
        lblTitle.textColor = UIColor.themeTitleColor
    }

    override func updateUIAccordingToTheme() {
        self.btnLeft.setImage(UIImage(named:"cancelIcon")?.imageWithColor(color: UIColor.themeColor), for: .normal)
    }

    //MARK: - NAVIGATION METHODS
    @IBAction func onClickTrackOrder(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
        delegateOnTrackOrder?.didTapOnTrackOrder()
    }

    @IBAction func onClickBtnClose(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
        delegateOnCancel?.didTapOnCancel()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let ordersVC:OrderVC = segue.destination as! OrderVC
        ordersVC.isComeFromCompleteOrder = true
    }
}
