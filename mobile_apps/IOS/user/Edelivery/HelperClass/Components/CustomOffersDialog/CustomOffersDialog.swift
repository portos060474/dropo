//
//  CustomProductFilter.swift
//  Edelivery
//
//  Created by Elluminati on 3/10/21.
//  Copyright © 2021 Elluminati. All rights reserved.
//

import Foundation
import  UIKit

class CustomOffersDialog: CustomDialog  {
    
    @IBOutlet weak var viewForSearchItem: UIView!
//    @IBOutlet weak var searchBarItem: UISearchBar!
    @IBOutlet weak var tblV: UITableView!
//    @IBOutlet weak var btnApplySearch: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var viewHeightConstarint: NSLayoutConstraint!
    @IBOutlet weak var imgNoOffers: UIImageView!

    var onClickLeftButton : (() -> Void)? = nil
    var onClickApply : ((_ _id: String) -> Void)? = nil
    static let  dialogForOffers = "dialogForOffers"
    var arrPromoCodes:Array<PromoCodeModal>? = nil
    var maskLayer: CAShapeLayer?
    var isFromHome: Bool = false
    var preferredContentSize: CGSize {
        get {
            // Force the table view to calculate its height
            self.tblV.layoutIfNeeded()
            return self.tblV.contentSize
        }
        set {}
    }

    public static func showOffers
    (title:String,
     message:String,
     arrPromoCodes:Array<PromoCodeModal>?,
     isFromHome:Bool
    ) ->
    CustomOffersDialog
    {
        let view = UINib(nibName: dialogForOffers, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomOffersDialog
        let frame = (APPDELEGATE.window?.frame)!
        view.frame = frame
        view.lblTitle.text = title
        DispatchQueue.main.async {
            APPDELEGATE.window?.addSubview(view)
            APPDELEGATE.window?.bringSubviewToFront(view)
            view.animationBottomTOTop(view.viewForSearchItem)
        }
        view.tblV.register(UINib.init(nibName: "PromoCodeCell", bundle: nil), forCellReuseIdentifier: "PromoCodeCell")
        view.arrPromoCodes = arrPromoCodes
        view.imgNoOffers.isHidden = arrPromoCodes?.count != 0
        view.tblV.isHidden = arrPromoCodes?.count == 0
        view.tblV.reloadData()
        view.setLocalization()
        view.isFromHome = isFromHome
        return view
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        viewForSearchItem.applyTopCornerRadius()
    }
    
    func setLocalization(){
        
//        for s in searchBarItem.subviews[0].subviews {
//            if s is UITextField {
//                s.backgroundColor = UIColor.white
//                (s as! UITextField).font = FontHelper.textRegular(size: 12)
//            }
//        }
//        searchBarItem?.delegate = self
        self.backgroundColor = UIColor.themeOverlayColor
        self.viewForSearchItem.backgroundColor = UIColor.themeViewBackgroundColor
        self.tblV.backgroundColor = UIColor.themeViewBackgroundColor
        
//        searchBarItem.backgroundImage = UIImage()
//        searchBarItem.barTintColor = UIColor.themeTextColor
//        searchBarItem.backgroundColor = UIColor.themeViewBackgroundColor
//        searchBarItem.layer.borderColor = UIColor.themeLightLineColor.cgColor
//        searchBarItem.layer.borderWidth = 1.0
//        searchBarItem.tintColor = UIColor.themeTextColor
//        searchBarItem.setTextColor(color: UIColor.themeTextColor)
//
//        searchBarItem.placeholder = "TXT_ENTER_ITEM_NAME".localized
        
        lblTitle.textColor = UIColor.themeTextColor
        lblTitle.font = FontHelper.textMedium(size: FontHelper.large)

        tblV.reloadData()
        tblV.tableFooterView = UIView()
        if arrPromoCodes?.count ?? 0 > 0 {
            if self.preferredContentSize.height <= UIScreen.main.bounds.height - 100 {
                self.viewHeightConstarint.constant = self.preferredContentSize.height + tblV.frame.origin.y
            } else {
                self.viewHeightConstarint.constant = UIScreen.main.bounds.height - 100
            }
        } else {
            self.viewHeightConstarint.constant = 400
        }
        

        updateUIAccordingToTheme()
        self.layoutSubviews()
    }
    
    override func updateUIAccordingToTheme(){
        btnClose.setImage(UIImage(named: "cancelIcon")?.imageWithColor(color: .themeColor), for: .normal)
        self.tblV.reloadData()
    }
    
    //ActionMethods
    @IBAction func onClickBtnClose(_ sender: Any) {
      /*  if self.onClickLeftButton != nil {
            self.onClickLeftButton!()
        } */
        self.animationForHideView(viewForSearchItem) {
            
            self.removeFromSuperview()
        }
    }
    @IBAction func onClickBtnApplySearch(_ sender: Any) {
//        let searchText = searchBarItem.text ?? ""
        
    }
    func onClickApply(promoName: String) {
        if self.onClickApply != nil {
            self.onClickApply!(promoName)
        }
    }
    
}

extension CustomOffersDialog:UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return UIView.init()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrPromoCodes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:PromoCodeCell? =  tableView.dequeueReusableCell(with: PromoCodeCell.self, for: indexPath)
        if cell == nil {
            cell = PromoCodeCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "PromoCodeCell")
        }
        cell?.setData(promoObj: arrPromoCodes![indexPath.row], isApplyPromo: !isFromHome, parent: self)
//        cell?.setCellData(cellItem:(arrProductList?[indexPath.row])!)
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
//        arrProductList?[indexPath.row].isProductFiltered = !(arrProductList?[indexPath.row].isProductFiltered)!
        tblV.reloadData()
        
    }
}
class PromoCodeCell: CustomTableCell {
    
    //MARK:- OUTLET
    @IBOutlet weak var imgPromo: UIImageView!
    @IBOutlet weak var lblPromoTitle: UILabel!
    @IBOutlet weak var btnApply: CustomBottomButton!
    @IBOutlet weak var lblPromoDesc: UILabel!
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var stkV: UIStackView!
    @IBOutlet weak var lblTCTitle: UILabel!
    @IBOutlet weak var lblSep: UILabel!
    @IBOutlet weak var lblCompleteOrder: UILabel!
    @IBOutlet weak var lblFirstUser: UILabel!
    @IBOutlet weak var lblMinOrderPrice: UILabel!
    @IBOutlet weak var lblUptoDiscount: UILabel!
    @IBOutlet weak var lblMinItem: UILabel!
    @IBOutlet weak var lblPromoDate: UILabel!
    @IBOutlet weak var lblPromoTime: UILabel!
    @IBOutlet weak var lblPromoDay: UILabel!
    @IBOutlet weak var lblPromoWeek: UILabel!
    @IBOutlet weak var lblPromoMonth: UILabel!
    @IBOutlet weak var stkCompleteOrder: UIStackView!
    @IBOutlet weak var stkFirstUser: UIStackView!
    @IBOutlet weak var stkMinOrderPrice: UIStackView!
    @IBOutlet weak var stkUptoDiscount: UIStackView!
    @IBOutlet weak var stkMinItem: UIStackView!
    @IBOutlet weak var stkPromoDate: UIStackView!
    @IBOutlet weak var stkPromoTime: UIStackView!
    @IBOutlet weak var stkPromoDay: UIStackView!
    @IBOutlet weak var stkPromoWeek: UIStackView!
    @IBOutlet weak var stkPromoMonth: UIStackView!
    
    var parent: CustomOffersDialog?
    var currentPromoObj: PromoCodeModal?
    
    //MARK:- LIFECYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        lblPromoTitle.textColor = UIColor.themeTitleColor
        lblPromoTitle.font = FontHelper.textMedium(size: 16.0)
        lblPromoDesc.textColor = UIColor.themeTextColor
        lblPromoDesc.font = FontHelper.labelRegular()
        lblTCTitle.textColor = UIColor.themeTextColor
        lblTCTitle.font = FontHelper.textMedium()
        lblCompleteOrder.textColor = UIColor.themeLightTextColor
        lblCompleteOrder.font = FontHelper.textSmall(size: FontHelper.labelRegular)
        lblFirstUser.textColor = UIColor.themeLightTextColor
        lblFirstUser.font = FontHelper.textSmall(size: FontHelper.labelRegular)
        lblMinOrderPrice.textColor = UIColor.themeLightTextColor
        lblMinOrderPrice.font = FontHelper.textSmall(size: FontHelper.labelRegular)
        lblUptoDiscount.textColor = UIColor.themeLightTextColor
        lblUptoDiscount.font = FontHelper.textSmall(size: FontHelper.labelRegular)
        lblMinItem.textColor = UIColor.themeLightTextColor
        lblMinItem.font = FontHelper.textSmall(size: FontHelper.labelRegular)
        lblPromoDate.textColor = UIColor.themeLightTextColor
        lblPromoDate.font = FontHelper.textSmall(size: FontHelper.labelRegular)
        lblPromoTime.textColor = UIColor.themeLightTextColor
        lblPromoTime.font = FontHelper.textSmall(size: FontHelper.labelRegular)
        lblPromoDay.textColor = UIColor.themeLightTextColor
        lblPromoDay.font = FontHelper.textSmall(size: FontHelper.labelRegular)
        lblPromoWeek.textColor = UIColor.themeLightTextColor
        lblPromoWeek.font = FontHelper.textSmall(size: FontHelper.labelRegular)
        lblPromoMonth.textColor = UIColor.themeLightTextColor
        lblPromoMonth.font = FontHelper.textSmall(size: FontHelper.labelRegular)
        imgPromo.setRound(withBorderColor: UIColor.themeLightLineColor, andCornerRadious: 3.0, borderWidth: 0.5)
        btnApply.setTitle("TXT_APPLY".localized, for: .normal)
        lblTCTitle.text = "TXT_TERMS_AND_CONDITIONS_STAR".localized
    }
    
    func setData(promoObj:PromoCodeModal,isApplyPromo:Bool, parent: CustomOffersDialog) -> Bool{
        self.parent = parent
        self.currentPromoObj = promoObj
        let _ = " • "
        self.lblPromoTitle.text = promoObj.promoCodeName
        self.lblPromoDesc.text = promoObj.promoDetails
        self.imgPromo.downloadedFrom(link: promoObj.imageUrl)
        if preferenceHelper.getUserId().isEmpty() {
            btnApply.disable()
        } else {
            btnApply.enable()
        }
        
        var isHaveData : Bool = false
        
        if promoObj.promoApplyAfterCompletedOrder > 0 && promoObj.isPromoApplyOnCompletedOrder{
            self.lblCompleteOrder.isHidden = false
            self.stkCompleteOrder.isHidden = false
            self.lblCompleteOrder.text = "\(String(format: NSLocalizedString("TXT_APPLIED_AFTER_COMPLETING_ORDER".localized, comment: ""),String("\(promoObj.promoApplyAfterCompletedOrder!)")))"
            isHaveData = true
        }else{
            self.lblCompleteOrder.isHidden = true
            self.stkCompleteOrder.isHidden = true
        }
        
        if promoObj.promoRecursionType > 0{
            self.lblFirstUser.isHidden = false
            self.stkFirstUser.isHidden = false
            self.lblFirstUser.text = "\(String(format: NSLocalizedString("TXT_OFFERS_APPLIES_TO_FIRST_USERS_ONLY".localized, comment: ""),String("\(promoObj.promoRecursionType!)")))"
            isHaveData = true
        }else{
            self.lblFirstUser.isHidden = true
            self.stkFirstUser.isHidden = true
        }
        
        if promoObj.promoCodeApplyOnMinimumAmount > 0 && promoObj.isPromoHaveMinimumAmountLimit{
            self.lblMinOrderPrice.isHidden = false
            self.stkMinOrderPrice.isHidden = false
            let str = "\(currentBooking.currency)\(promoObj.promoCodeApplyOnMinimumAmount!)"
            self.lblMinOrderPrice.text = "\(String(format: NSLocalizedString("TXT_MINIMUM_ORDER_PURCHASE".localized, comment: ""),String("\(str)")))"
            isHaveData = true
        }else{
            self.lblMinOrderPrice.isHidden = true
            self.stkMinOrderPrice.isHidden = true
        }
        
        if promoObj.promoCodeMaxDiscountAmount > 0 && promoObj.isPromoHaveMaxDiscountLimit{
            self.lblUptoDiscount.isHidden = false
            self.stkUptoDiscount.isHidden = false

            let str = "\(promoObj.promoCodeType! == PROMO_CODE_TYPE.ABS ? "\(currentBooking.currency)\(promoObj.promoCodeMaxDiscountAmount!)" : "\(promoObj.promoCodeMaxDiscountAmount!)%")"
            self.lblUptoDiscount.text = "\(String(format: NSLocalizedString("TXT_UPTO_DISCOUNT_ON_TOTAL_PURCHASE_PRICE".localized, comment: ""),String("\(str)")))"
            isHaveData = true
        }else{
            self.lblUptoDiscount.isHidden = true
            self.stkUptoDiscount.isHidden = true

        }
        
        if promoObj.promoCodeApplyOnMinimumItemCount > 0 && promoObj.isPromoHaveItemCountLimit{
            self.lblMinItem.isHidden = false
            self.stkMinItem.isHidden = false

            let str = "\(promoObj.promoCodeApplyOnMinimumItemCount!)"
            self.lblMinItem.text = "\(String(format: NSLocalizedString("MINIMUM_ITEM_PER_ORDER".localized, comment: ""),String("\(str)")))"
            isHaveData = true
        }else{
            self.lblMinItem.isHidden = true
            self.stkMinItem.isHidden = true

        }
        
        if (promoObj.promoStartDate != nil && promoObj.promoStartDate.count > 0) && (promoObj.promoExpireDate != nil  && promoObj.promoExpireDate.count > 0 ) &&  promoObj.isPromoHaveDate{
            self.lblPromoDate.isHidden = false
            self.stkPromoDate.isHidden = false
            let timeZone: TimeZone = TimeZone.init(identifier: currentBooking.selectedCityTimezone) ?? TimeZone.current
            let str1 = "\(Utility.dateToString(date: Utility.stringToDate(strDate: promoObj.promoStartDate!, withFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB), withFormat: DATE_CONSTANT.DATE_FORMATE_DAY_MONTH_YEAR, withTimezone: timeZone))"
            let str2 = "\(Utility.dateToString(date: Utility.stringToDate(strDate: promoObj.promoExpireDate!, withFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB), withFormat: DATE_CONSTANT.DATE_FORMATE_DAY_MONTH_YEAR, withTimezone: timeZone))"
            self.lblPromoDate.text = "\(String(format: "TXT_PROMO_APPLY_DATE".localized,String("\(str1)"),String("\(str2)")))"
            isHaveData = true
        }else{
            self.lblPromoDate.isHidden = true
            self.stkPromoDate.isHidden = true
        }
        
        if promoObj.promoStartTime.count > 0 && promoObj.promoEndTime.count > 0 && promoObj.isPromoHaveDate{
            self.lblPromoTime.isHidden = false
            self.stkPromoTime.isHidden = false

            let str1 = Utility.dateToString(date: Utility.stringToDate(strDate: promoObj.promoStartTime!, withFormat: DATE_CONSTANT.TIME_FORMAT_HH_MM), withFormat: DATE_CONSTANT.TIME_FORMAT_AM_PM)
            
            let str2 = Utility.dateToString(date: Utility.stringToDate(strDate: promoObj.promoEndTime!, withFormat: DATE_CONSTANT.TIME_FORMAT_HH_MM), withFormat: DATE_CONSTANT.TIME_FORMAT_AM_PM)
            
            self.lblPromoTime.text = "\(String(format: "TXT_PROMO_APPLY_TIME".localized,String("\(str1)"),String("\(str2)")))"
            isHaveData = true
            
        }else{
            self.lblPromoTime.isHidden = true
            self.stkPromoTime.isHidden = true
        }
        
        if promoObj.days.count > 0{
            self.lblPromoDay.isHidden = false
            self.stkPromoDay.isHidden = false

            var str = ""
            for obj in promoObj.days{
                if obj.count > 0{
                    str = str + obj + ", "
                }
            }
            if str.count > 0{
                self.lblPromoDay.text = "\(String(format: "TXT_PROMO_APPLY_DAY".localized,String("\(str.dropLast(2))")))"
                isHaveData = true
            }else{
                self.lblPromoDay.isHidden = true
                self.stkPromoDay.isHidden = true
                isHaveData = false
            }
            
        }else{
            self.lblPromoDay.isHidden = true
            self.stkPromoDay.isHidden = true

        }
        
        if promoObj.weeks.count > 0{
            self.lblPromoWeek.isHidden = false
            self.stkPromoWeek.isHidden = false

            var str = ""
            
            for obj in promoObj.weeks{
                if obj.count > 0{
                    str = str + obj + ", "
                }
            }
            
            if str.count > 0{
                self.lblPromoWeek.text = "\(String(format: "TXT_PROMO_APPLY_WEEK".localized,String("\(str.dropLast(2))")))"
                isHaveData = true
            }else{
                self.lblPromoWeek.isHidden = true
                self.stkPromoWeek.isHidden = true
                isHaveData = false
            }
        }else{
            self.lblPromoWeek.isHidden = true
            self.stkPromoWeek.isHidden = true
        }
        
        if promoObj.months.count > 0{
            self.lblPromoMonth.isHidden = false
            self.stkPromoMonth.isHidden = false

            var str = ""
            
            for obj in promoObj.months{
                if obj.count > 0{
                    str = str + obj  + ", "
                }
            }
            
            if str.count > 0{
                self.lblPromoMonth.text = "\(String(format: "TXT_PROMO_APPLY_MONTH".localized,String("\(str.dropLast(2))")))"
                isHaveData = true
            }else{
                self.lblPromoMonth.isHidden = true
                self.stkPromoMonth.isHidden = true
                isHaveData = false
            }
        }else{
            self.lblPromoMonth.isHidden = true
            self.stkPromoMonth.isHidden = true
        }
        
        if isApplyPromo{
            self.btnApply.isHidden = false
        }else{
            self.btnApply.isHidden = true
        }
        if isHaveData{
            self.lblTCTitle.isHidden = false
        }else{
            self.lblTCTitle.isHidden = true
        }
        return isHaveData
    }
    @IBAction func onClickBtnApply(_ sender: UIButton)  {
        parent?.onClickApply(promoName: currentPromoObj!.promoCodeName)
    }
}
