//
//  CustomDialogueForOverview.swift
//  Edelivery
//
//  Created by Elluminati on 3/8/21.
//  Copyright © 2021 Elluminati. All rights reserved.
//

import UIKit

class CustomOverviewDialogue: CustomDialog {
 
    @IBOutlet weak var scrOVerview: UIScrollView!
    @IBOutlet weak var lblStoreAddress: UILabel!
    @IBOutlet weak var lblSlogan: UILabel!
    @IBOutlet weak var lblStoreTime: UILabel!
    @IBOutlet weak var viewForStoreTime: UIView!
    @IBOutlet weak var tblForStoreTime: UITableView!
    @IBOutlet weak var lblStoreWebsite: UILabel!
    @IBOutlet weak var lblStorePhone: UILabel!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnGetDirection: UIButton!
    @IBOutlet weak var viewforShare: UIView!
    @IBOutlet weak var viewForSlogan: UIView!
    @IBOutlet weak var viewForStoreWebsite: UIView!
    @IBOutlet weak var viewForPhone: UIView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
    @IBOutlet weak var mapImage: UIImageView!
    @IBOutlet weak var sloganImage: UIImageView!
    @IBOutlet weak var timeImage: UIImageView!
    @IBOutlet weak var websiteImage: UIImageView!
    @IBOutlet weak var phoneImage: UIImageView!
    @IBOutlet weak var imageDropDown: UIImageView!
    @IBOutlet weak var btnShowTime: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnMapImageIcon: UIButton!
    @IBOutlet weak var btnSloganImageIcon: UIButton!
    @IBOutlet weak var btnTimeImageIcon: UIButton!
    @IBOutlet weak var btnWebsiteImageIcon: UIButton!
    @IBOutlet weak var btnPhoneImageIcon: UIButton!
    
    let upArraow:String = "\u{25B2}"
    let downArrow:String = "\u{25BC}"
    
    var onClickRightButton : (() -> Void)? = nil
    var onClickLeftButton : (() -> Void)? = nil
    var onClickShareButton : (() -> Void)? = nil
    let store:StoreItem = currentBooking.selectedStore!
   
    //MARK: View life cycle

    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    public static func showCustomReviewRatingDialog
        (title:String,
         message:String,
         titleLeftButton:String,
         titleRightButton:String,
         editTextOneHint:String,
         editTextTwoHint:String,
         isEdiTextTwoIsHidden:Bool,
         isEdiTextOneIsHidden:Bool = false,
         editTextOneInputType:Bool = false,
         editTextTwoInputType:Bool = false
         ) ->
        CustomOverviewDialogue
     {
        let view = UINib(nibName: "CustomOverviewDialogue", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomOverviewDialogue
        
        let frame = (APPDELEGATE.window?.frame)!
        view.frame = frame
        view.setLocalization()
        view.tableHeight.constant = 1
        view.tblForStoreTime.estimatedRowHeight = 25
        view.tblForStoreTime.rowHeight = UITableView.automaticDimension
        view.lblTitle.text = title
        view.tblForStoreTime.register(UINib.init(nibName: "StoreTimeCell", bundle: nil), forCellReuseIdentifier: "cell")
        DispatchQueue.main.async {
            view.setStoreData()
            APPDELEGATE.window?.addSubview(view)
            APPDELEGATE.window?.bringSubviewToFront(view)
            view.animationBottomTOTop(view.viewContainer)
        }
        view.setLocalization()
        return view
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }
    func setupLayout() {
       
        if (lblStoreWebsite.text?.isEmpty())! {
            viewForStoreWebsite.isHidden = true
        }
        if (lblSlogan.text?.isEmpty())! {
            viewForSlogan.isHidden = true
        }
        if (lblStorePhone.text?.isEmpty())! {
            viewForPhone.isHidden = true
        }
        viewContainer.applyTopCornerRadius()
        btnShare.applyRoundedCornersWithHeight()
        btnGetDirection.applyRoundedCornersWithHeight()
    }
    
    func setLocalization() {
        self.backgroundColor = UIColor.themeOverlayColor
        self.viewContainer.backgroundColor = UIColor.themeViewBackgroundColor
        btnClose.setImage(UIImage(named: "cancelIcon")?.imageWithColor(color: .themeColor), for: .normal)
        btnShare.setBackgroundColor(color: UIColor.themeColor, forState: .normal)
        btnGetDirection.setBackgroundColor(color: UIColor.themeColor, forState: .normal)
        btnShare.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnGetDirection.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnGetDirection.setTitle("Get Direction".localized, for: .normal)
        btnShare.setTitle("TXT_SHARE".localized, for: .normal)
        btnShare.titleLabel?.font = FontHelper.textMedium(size: FontHelper.medium)
        btnGetDirection.titleLabel?.font = FontHelper.textMedium(size: FontHelper.medium)
        lblTitle.textColor = UIColor.themeTextColor
        lblTitle.font = FontHelper.textMedium(size: FontHelper.large)
        sloganImage.tintColor = UIColor.themeViewBackgroundColor
        lblStoreAddress.font = FontHelper.textRegular()
        lblSlogan.font = FontHelper.textRegular()
        lblStoreTime.font = FontHelper.textRegular()
        lblStorePhone.font = FontHelper.textRegular()
        lblStoreWebsite.font = FontHelper.textRegular()
        btnMapImageIcon.setImage(UIImage(named:"address_icon")?.imageWithColor(color: UIColor.themeTitleColor), for: .normal)
        btnSloganImageIcon.setImage(UIImage(named:"sloganIcon")?.imageWithColor(color: UIColor.themeTitleColor), for: .normal)
        btnTimeImageIcon.setImage(UIImage(named:"store_timing")?.imageWithColor(color: UIColor.themeTitleColor), for: .normal)
        btnWebsiteImageIcon.setImage(UIImage(named:"earthIcon")?.imageWithColor(color: UIColor.themeTitleColor), for: .normal)
        btnPhoneImageIcon.setImage(UIImage(named:"phone_icon")?.imageWithColor(color: UIColor.themeTitleColor), for: .normal)
        imageDropDown.image = UIImage(named:"dropdown")?.imageWithColor(color: .themeTitleColor)
    }
    
    override func updateUIAccordingToTheme() {
        btnMapImageIcon.setImage(UIImage(named:"address_icon")?.imageWithColor(color: UIColor.themeTitleColor), for: .normal)
        btnSloganImageIcon.setImage(UIImage(named:"sloganIcon")?.imageWithColor(color: UIColor.themeTitleColor), for: .normal)
        btnTimeImageIcon.setImage(UIImage(named:"store_timing")?.imageWithColor(color: UIColor.themeTitleColor), for: .normal)
        btnWebsiteImageIcon.setImage(UIImage(named:"earthIcon")?.imageWithColor(color: UIColor.themeTitleColor), for: .normal)
        btnPhoneImageIcon.setImage(UIImage(named:"phone_icon")?.imageWithColor(color: UIColor.themeTitleColor), for: .normal)
        setLocalization()
    }
    
    func setStoreData() {
        self.lblSlogan.text = store.slogan ?? ""
        self.lblStorePhone.text = (store.country_phone_code ?? "") + (store.phone ?? "")
        self.lblStoreAddress.text = store.address ?? ""
        self.lblStoreWebsite.text = store.website_url ?? ""
        self.lblStoreTime.text = "TXT_STORE_TIME".localizedCapitalized
        tblForStoreTime.reloadData()
    }
    
    @IBAction func onClickShowHideTime(_ sender: UIButton) {
        self.tblForStoreTime.superview?.layoutIfNeeded()
        if sender.tag == 0
        {
            sender.tag = 1
            self.lblStoreTime.text = "TXT_STORE_TIME".localizedCapitalized
            tableHeight.constant = tblForStoreTime.contentSize.height
            scrOVerview.isScrollEnabled = true
            imageDropDown.image = UIImage(named: "up_arrow")?.imageWithColor(color: .themeTitleColor)
        }
        else
        {
            scrOVerview.isScrollEnabled = false
            sender.tag = 0
            tableHeight.constant = 0
            self.lblStoreTime.text = "TXT_STORE_TIME".localizedCapitalized
            imageDropDown.image = UIImage(named: "up_arrow")?.imageWithColor(color: .themeTitleColor)
        }
        
    }
    
    @IBAction func onClickBtnShare(_ sender: Any) {
        if self.onClickShareButton != nil {
            self.onClickShareButton!()
        }
        var myString = ""
        if store.branch_io_url.isEmpty
        {
            myString = String(format: "TXT_SHARE_STORE_DETAIL".localized.replacingOccurrences(of: "****", with: "APP_NAME".localized),(store.name ?? "") , (store.website_url ?? ""))
        }
        else
        {
            myString = store.branch_io_url
        }
        let textToShare = [ myString ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
       
    }
    
    @IBAction func onClickBtnMap(_ sender: Any) {
        let url = "http://maps.apple.com/maps?saddr=\(currentBooking.currentLatLng[0]),\(currentBooking.currentLatLng[1])&daddr=\(store.location?[0] ?? 0.0),\(store.location?[1] ?? 0.0)"
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string:url)!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        } else {
            UIApplication.shared.openURL(URL(string:url)!)
        }
        if self.onClickLeftButton != nil {
            self.onClickLeftButton!()
        }
    }
    
    @IBAction func onClickBtnWebsite(_ sender: Any) {
        guard let url = URL(string: store.website_url ?? "") else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func onClickBtnCall(_ sender: Any) {
        let storeContactNumber:String = store.country_phone_code! + store.phone!
        if storeContactNumber.isEmpty {
            Utility.showToast(message: "MSG_UNABLE_TO_CALL".localized)
        }else {
            if let url = URL(string: "tel://\(storeContactNumber)"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    
    //ActionMethods
    @IBAction func onClickBtnLeft(_ sender: Any) {
        if self.onClickLeftButton != nil {
            self.onClickLeftButton!()
        }
        self.animationForHideView(viewContainer) {
            
            self.removeFromSuperview()
        }
    }
    
    @IBAction func onClickBtnRight(_ sender: Any) {
        
    }
}

extension CustomOverviewDialogue: UITableViewDelegate,UITableViewDataSource {
    //MARK: TABLEVIEW DELEGATE METHODS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let storeTimeItem = store.store_time[section]
        if (storeTimeItem.isStoreOpenFullTime) {
            return 1
        }
        else if (!storeTimeItem.isStoreOpenFullTime && !storeTimeItem.isStoreOpen) {
            return 1
        }
        else if (storeTimeItem.dayTime.count == 0) {
            return 1
        }else {
            return storeTimeItem.dayTime.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return store.store_time.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:StoreTimeCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! StoreTimeCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.setCellData(storeTimeItem: store.store_time[indexPath.section], indexPath:indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return UITableView.automaticDimension
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}

class StoreTimeCell: CustomTableCell {
    
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    //MARK:- LIFECYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        setLocalization()
    }
    
    //MARK:- setLocationzation
    func setLocalization() {
        lblDay.textColor = UIColor.themeLightTextColor
        lblTime.textColor = UIColor.themeLightTextColor
        lblDay.font = FontHelper.textMedium()
        /*Set Color*/
    }
    
    //MARK:- SET CELL DATA
    func setCellData(storeTimeItem:StoreTime,indexPath:IndexPath) {

        let currentDay:DateComponents = Calendar.current.dateComponents(in:TimeZone.init(identifier: currentBooking.selectedCityTimezone) ?? TimeZone.current, from: Date())
        if (currentDay.weekday!-1 == indexPath.section) {
            lblDay.textColor = UIColor.themeTextColor
            lblTime.textColor = UIColor.themeTextColor
        }
        let day:Day = Day(rawValue: indexPath.section)!
        lblDay.text = day.text()
        if (storeTimeItem.isStoreOpenFullTime) {
           lblDay.isHidden = false
           lblTime.text = "TXT_OPEN_24_HOURS".localizedCapitalized
        }
        else if (!storeTimeItem.isStoreOpenFullTime && !storeTimeItem.isStoreOpen) {
            lblDay.isHidden = false
            lblDay.textColor = UIColor.themeRedBGColor
            lblTime.textColor = UIColor.themeRedBGColor
            lblTime.text = "TXT_STORE_CLOSED".localizedCapitalized
        }
        else if (storeTimeItem.dayTime.count == 0) {
            lblDay.isHidden = false
            lblDay.textColor = UIColor.themeRedBGColor
            lblTime.textColor = UIColor.themeRedBGColor
            lblTime.text = "TXT_STORE_CLOSED".localizedCapitalized
        }else {
            if (indexPath.row == 0) {
                lblDay.isHidden = false
            }else {
                lblDay.isHidden = true
            }
            if storeTimeItem.dayTime[indexPath.row].storeOpenTime != nil && storeTimeItem.dayTime[indexPath.row].storeOpenTime != nil {
                lblTime.text = storeTimeItem.dayTime[indexPath.row].storeOpenTime + " - " + storeTimeItem.dayTime[indexPath.row].storeCloseTime
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
