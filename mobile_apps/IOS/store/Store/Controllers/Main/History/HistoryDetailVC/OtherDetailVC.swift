//
//  ShareVC.swift
//  edelivery
//
//  Created by Elluminati on 14/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class OtherDetailVC: BaseVC {
    
    
    @IBOutlet weak var lblCreated: UILabel!
    @IBOutlet weak var lblCreatedDate: UILabel!
    
    @IBOutlet weak var lblDelivered: UILabel!
    @IBOutlet weak var lblDeliveredDate: UILabel!
    
    
    /*View for userDetail*/
    @IBOutlet weak var viewForOrderDetail: UIView!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var viewForUserRate: UIView!
    @IBOutlet weak var btnRateUser: UIButton!
    @IBOutlet weak var imgUserProfilePic: UIImageView!
    @IBOutlet weak var stkForDeliveryUser: UIStackView!
    @IBOutlet weak var lblReceiveUser: UILabel!
    @IBOutlet weak var lblReceiveUserName: UILabel!
    
    
    
    /*View for Provider*/
    @IBOutlet weak var viewForDeliveryDetail: UIView!
    @IBOutlet weak var lblDeliveryDetail: UILabel!
    @IBOutlet weak var imgProviderPic: UIImageView!
    @IBOutlet weak var viewForProviderRate: UIView!
    @IBOutlet weak var lblProviderName: UILabel!
    @IBOutlet weak var btnRateProvider: UIButton!
    
    
    
    
    
    
    
    
    
    @IBOutlet weak var lblDestinationAddress: UILabel!
    @IBOutlet weak var lblEstTime: UILabel!
    @IBOutlet weak var lblEstTimeValue: UILabel!
    @IBOutlet weak var lblEstDistance: UILabel!
    @IBOutlet weak var lblEstDistanceValue: UILabel!
    
    
    @IBOutlet weak var imgTime: UIImageView!
    @IBOutlet weak var imgDistance: UIImageView!
    @IBOutlet weak var tblV: UITableView!
    
    @IBOutlet weak var lblUserrate: UILabel!
    @IBOutlet weak var imgUserrate: UIImageView!
    
    @IBOutlet weak var lblProviderrate: UILabel!
    @IBOutlet weak var imgProviderrate: UIImageView!

    
    
    
    public var isRateToUser:Bool = false
    
    
    var providerDetail:HistoryProviderDetail?
    var userDetail:HistoryUserDetail?
    var orderDetail:HistoryOrderList?
    var dialogForFeedbcak:CustomFeedbackDialog? = nil
    
    //MARK: View life cycle
    override func viewDidLoad(){
        super.viewDidLoad()
        viewForOrderDetail.isHidden = true
        viewForDeliveryDetail.isHidden = true
        setLocalization()
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //MARK: Set localized layout
    func setLocalization() {
        
        lblDetail.text = "TXT_ORDER_DETAILS".localized.appending("     ").uppercased()
        lblDeliveryDetail.text = "TXT_DELIVERY_DETAILS".localized.appending("     ").uppercased()
        lblReceiveUser.text = "TXT_ORDER_RECEIVED_BY".localizedCapitalized
        lblCreated.text = "TXT_CREATED".localized
        lblDelivered.text = "TXT_DELIVERED".localized
        
        //COLORS
        view.backgroundColor = UIColor.themeViewBackgroundColor
        lblDetail.backgroundColor = UIColor.themeColor
        lblDeliveryDetail.backgroundColor = UIColor.themeColor
        lblDetail.textColor = UIColor.themeButtonTitleColor
        lblDeliveryDetail.textColor = UIColor.themeButtonTitleColor
        lblProviderName.textColor = UIColor.themeTextColor
        lblProviderName.textColor = UIColor.themeTextColor
        lblReceiveUser.textColor = UIColor.themeTextColor
        lblReceiveUserName.textColor = UIColor.themeTextColor
        lblDestinationAddress.textColor = UIColor.themeTextColor
        lblEstTime.textColor = UIColor.themeLightTextColor
        lblEstDistance.textColor = UIColor.themeLightTextColor
        lblEstTimeValue.textColor = UIColor.themeTextColor
        lblEstDistanceValue.textColor = UIColor.themeTextColor
        lblCreatedDate.textColor = UIColor.themeTextColor
        lblUserName.textColor = UIColor.themeTextColor
        
        
        btnRateProvider.setTitleColor(UIColor.themeLightTextColor, for: .normal)
        btnRateUser.setTitleColor(UIColor.themeLightTextColor, for: .normal)
        
        
        lblCreated.textColor = UIColor.themeLightTextColor
        lblCreatedDate.textColor = UIColor.themeTextColor
        
        lblDelivered.textColor = UIColor.themeLightTextColor
        lblDeliveredDate.textColor = UIColor.themeTextColor
        
        //LOCALIZED
        title = "TITLE_HISTORY_DETAIL".localized
        lblEstTime.text = "TXT_TIME".localized
        lblEstDistance.text = "TXT_DISTANCE".localized
        btnRateProvider.setTitle("TXT_GIVE_RATE".localizedCapitalized, for: .normal)
        btnRateUser.setTitle("TXT_GIVE_RATE".localizedCapitalized, for: .normal)
        
        
        lblDetail.sizeToFit();
        lblDeliveryDetail.sizeToFit();
        self.hideBackButtonTitle()
        /* Set Font */
        lblDetail.font = FontHelper.labelRegular()
        
        lblUserName.font = FontHelper.textMedium()
        lblProviderName.font = FontHelper.textMedium()
        
        lblDeliveryDetail.font = FontHelper.labelRegular()
        
        lblDestinationAddress.font = FontHelper.labelRegular()
        
        lblEstTime.font = FontHelper.labelRegular()
        lblEstDistance.font = FontHelper.labelRegular()
        lblEstTimeValue.font = FontHelper.textRegular()
        lblEstDistanceValue.font = FontHelper.textRegular()
        
        
        lblCreatedDate.font = FontHelper.textRegular(size: 13.0)
        lblCreated.font = FontHelper.textSmall(size: 12.0)
        lblDelivered.font = FontHelper.textSmall(size: 12.0)
        lblDeliveredDate.font = FontHelper.textRegular(size: 13.0)
        
        btnRateUser.titleLabel?.font = FontHelper.textSmall()
        btnRateProvider.titleLabel?.font = FontHelper.textSmall()
        
        lblReceiveUserName.font = FontHelper.textRegular()
        lblReceiveUser.font = FontHelper.textSmall()
        tblV.tableFooterView = UIView()
        updateUIAccordingToTheme()
    }

    func setupLayout() {
        lblDeliveryDetail.applyTopRightBottomRightCornerRadius()
        lblDetail.applyTopRightBottomRightCornerRadius()
        imgUserProfilePic.setRound()
        imgProviderPic.setRound()
    }

    override func updateUIAccordingToTheme() {
        imgTime.image = UIImage.init(named: "time")!.imageWithColor(color: .themeIconTintColor)!
        imgDistance.image = UIImage.init(named: "distance")!.imageWithColor(color: .themeIconTintColor)!
    }

    @IBAction func onClickRate(_ sender: UIButton) {
        if sender.tag == 0 {
            isRateToUser = true
        } else {
            isRateToUser = false
        }

//        dialogForFeedbcak?.onClickApplyButton = {
//
//        }
      //  self.performSegue(withIdentifier: SEGUE.FEEDBACK, sender: self)
        
    }

    @objc func rateToUser() {
        isRateToUser = true
        var name = ""
        let userName = (self.userDetail?.firstName)! + " " + (self.userDetail?.lastName)!
        let providerName = (self.providerDetail?.firstName)! + " " + (self.providerDetail?.lastName)!
        name = isRateToUser ? userName : providerName
        dialogForFeedbcak = CustomFeedbackDialog.showCustomFeedbackDialog(true, true, (self.orderDetail?.id)!, name: name)
     //   self.performSegue(withIdentifier: SEGUE.FEEDBACK, sender: self)
    }

    @objc func rateToProvider() {
        isRateToUser = false
        var name = ""
        let userName = (self.userDetail?.firstName)! + " " + (self.userDetail?.lastName)!
        let providerName = (self.providerDetail?.firstName)! + " " + (self.providerDetail?.lastName)!
        name = isRateToUser ? userName : providerName
        dialogForFeedbcak = CustomFeedbackDialog.showCustomFeedbackDialog(false, true, (self.orderDetail?.id)!, name: name)
      //  self.performSegue(withIdentifier: SEGUE.FEEDBACK, sender: self)
    }

    //MARK: Get User/Store/Order Details
    func setProviderDetail(data:HistoryProviderDetail) {
        if !data.firstName.isEmpty() {
            lblProviderName.text = data.firstName + " " + data.lastName
            imgProviderPic.downloadedFrom(link: data.imageUrl)
            viewForDeliveryDetail.isHidden = false
        } else {
            viewForDeliveryDetail.isHidden = true
        }
    }

    func setuserDetail(data:HistoryUserDetail) {
        lblUserName.text = data.firstName + " " + data.lastName
        imgUserProfilePic.downloadedFrom(link: data.imageUrl)
    }

    func setOrderListDetail(data: HistoryOrderList) {
        lblDestinationAddress.text = data.cartDetail.destinationAddresses[0].address

        if data.cartDetail.destinationAddresses[0].userDetails.name.isEmpty() {
            stkForDeliveryUser.isHidden = true
        }else {
            lblReceiveUserName.text = data.cartDetail.destinationAddresses[0].userDetails.name
            stkForDeliveryUser.isHidden = false
        }
        
        self.imgUserrate.image = UIImage(named: "ff")?.imageWithColor(color: .themeColor)
        self.imgProviderrate.image = UIImage(named: "ff")?.imageWithColor(color: .themeColor)
        self.lblProviderrate.textColor = .themeColor
        self.lblUserrate.textColor = .themeColor
        
        let orderStatus:OrderStatus = OrderStatus(rawValue: data.orderStatus) ?? .Unknown;
        if data.isStoreRatedToProvider  || !(orderStatus == OrderStatus.DELIVERY_MAN_COMPLETE_DELIVERY) {
            viewForProviderRate.isHidden = true
            self.lblProviderrate.isHidden = false
            self.imgProviderrate.isHidden = false
            if data.reviewDetail != nil{
                self.lblProviderrate.text = Double(data.reviewDetail.storeRatingToProvider).toString() //"\(data.reviewDetail.storeRatingToProvider ?? 0)"
            }else{
                viewForProviderRate.isHidden = true
                self.lblProviderrate.isHidden = true
                            }

            
        }else {
            viewForProviderRate.isHidden = false
            let tap = UITapGestureRecognizer(target: self, action:#selector(rateToProvider))
            viewForProviderRate.addGestureRecognizer(tap)
            viewForProviderRate.isUserInteractionEnabled = true
            self.lblProviderrate.isHidden = true
            self.imgProviderrate.isHidden = true

        }
        
        
        if data.isStoreRatedToUser  || !(orderStatus == OrderStatus.DELIVERY_MAN_COMPLETE_DELIVERY) {
            viewForUserRate.isHidden = true
            self.lblUserrate.isHidden = false
            self.imgUserrate.isHidden = false
            if data.reviewDetail != nil{
                self.lblUserrate.text = Double(data.reviewDetail.storeRatingToUser).toString()
            }else{
                viewForUserRate.isHidden = true
                self.lblUserrate.isHidden = true
                self.imgUserrate.isHidden = true

            }

        }else {
            viewForUserRate.isHidden = false
            self.lblUserrate.isHidden = true
            self.imgUserrate.isHidden = true

            let tap = UITapGestureRecognizer(target: self, action:#selector(rateToUser))
            viewForUserRate.addGestureRecognizer(tap)
            viewForUserRate.isUserInteractionEnabled = true
        }
        
        
        
        
        
        lblCreatedDate.text = Utility.relativeDateStringForDate(strDate: Utility.stringToString(strDate: data.createdAt, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_FORMAT)) as String
        
        lblDeliveredDate.text = Utility.relativeDateStringForDate(strDate: Utility.stringToString(strDate: data.completedAt, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_FORMAT)) as String
        
        lblEstTimeValue.text = String(data.orderPaymentDetail.totalTime) + "UNIT_MIN".localized
        
        var unit = "UNIT_KM".localized
        if data.orderPaymentDetail.isDistanceUnitMile {
            unit = "UNIT_MILE".localized
        }
        lblEstDistanceValue.text = String(data.orderPaymentDetail.totalDistance) + unit
        viewForOrderDetail.isHidden = false
        
    }
    
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier?.compare(SEGUE.FEEDBACK) == ComparisonResult.orderedSame) {
            let feedbackVC = segue.destination as! FeedbackVC;
            feedbackVC.isRateToUser = self.isRateToUser
            feedbackVC.selectedOrderID = (self.orderDetail?.id!)!
            if self.isRateToUser {
                feedbackVC.name = (self.userDetail?.firstName)! + " " + (self.userDetail?.lastName)!
                feedbackVC.imgurl = (self.userDetail?.imageUrl)!
            }
            else {
                feedbackVC.name = (self.providerDetail?.firstName)! + " " + (self.providerDetail?.lastName)!
                feedbackVC.imgurl = (self.providerDetail?.imageUrl)!
                
            }
        }
    }
    
    
}


