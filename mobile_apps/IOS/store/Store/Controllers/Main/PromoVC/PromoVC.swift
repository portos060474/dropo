//
//  PromoVC.swift
// Edelivery Store
//
//  Created by Jaydeep Vyas on 28/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class PromoVC: BaseVC,RightDelegate {
    
    let downArrow:String = "\u{25BC}"
    var selectedPromoItem:PromoCodeItem? = nil
    var dialogForImage:CustomPhotoDialog?;
    @IBOutlet weak var txtPromoCode: UITextField!
    @IBOutlet weak var txtPromoAmount: UITextField!
    @IBOutlet weak var txtPromoDetail: UITextField!
    @IBOutlet weak var txtPromoStartDate: UITextField!
    @IBOutlet weak var tagViewForDays: HTagView!
    @IBOutlet weak var tagViewForWeeks: HTagView!
    @IBOutlet weak var tagViewForMonths: HTagView!
    
    @IBOutlet weak var viewForShowPromo: UIView!
    @IBOutlet weak var lblPromoCodeType: UILabel!
    @IBOutlet weak var lblPromoCodeTypeValue: UILabel!
    @IBOutlet weak var btnShowPromoCodeType: UIButton!
    
    @IBOutlet weak var overViewOfDialog: UIView!
    /*View for activate promo */
    @IBOutlet weak var viewForActivatePromo: UIView!
    @IBOutlet weak var lblActivatePromo: UILabel!
    @IBOutlet weak var swForActivatePromo: UISwitch!
    /*View for promo expire*/
    @IBOutlet weak var lblSelect: UILabel!
    @IBOutlet weak var tblTags: UITableView!
    
    @IBOutlet weak var btnAddTag: UIButton!
    @IBOutlet weak var lblPromoPromoHaveDate: UILabel!
    @IBOutlet weak var txtPromoExpireDate: UITextField!
    @IBOutlet weak var swForPromoHaveDate: UISwitch!
    /*View For Promo Recurresion*/
    @IBOutlet weak var viewForPromoRecurrsion: UIView!
    @IBOutlet weak var lblRecursionType: UILabel!
    @IBOutlet weak var lblRecursionTypeValue: UILabel!
    @IBOutlet weak var btnSelectRecursionType: UIButton!
    @IBOutlet weak var stkForPromoHaveDate: UIStackView!
    @IBOutlet weak var viewstkForPromoHaveDate: UIView!
    
    @IBOutlet weak var viewForMonth: UIView!
    @IBOutlet weak var lblPromoMonths: UILabel!
    
    @IBOutlet weak var viewForWeek: UIView!
    @IBOutlet weak var lblPromoWeeks: UILabel!
    
    @IBOutlet weak var viewForDay: UIView!
    @IBOutlet weak var lblPromoDays: UILabel!
    
    @IBOutlet weak var txtStartTime: UITextField!
    @IBOutlet weak var txtEndTime: UITextField!
    
    @IBOutlet weak var lblTitleStartTime: UILabel!
    @IBOutlet weak var lblTitleEndTime: UILabel!
    @IBOutlet weak var lblTitleStartDate: UILabel!
    @IBOutlet weak var lblTitleExpiryDate: UILabel!
    
    
    @IBOutlet weak var stkForDate: UIStackView!
    @IBOutlet weak var stkForTime: UIStackView!
    
    /*View for promo min amount*/
    @IBOutlet weak var lblPromoMinAmount: UILabel!
    @IBOutlet weak var swForPromoMinAmount: UISwitch!
    @IBOutlet weak var txtMinPromoAmount: UITextField!
    
    /*View for promo max discount*/
    @IBOutlet weak var txtMaxPromoAmount: UITextField!
    @IBOutlet weak var lblPromoMaxAmount: UILabel!
    @IBOutlet weak var swForMaxPromoDiscount: UISwitch!
    /*View for promo use*/
    @IBOutlet weak var txtPromoUsage: UITextField!
    @IBOutlet weak var lblPromoRequiredUsage: UILabel!
    
    @IBOutlet weak var swForPromoRequiredUsage: UISwitch!
    /*View for promo for*/
    @IBOutlet weak var viewForPromoFor: UIView!
    @IBOutlet weak var lblPromoFor: UILabel!
    // @IBOutlet weak var lblPromoFor: UILabel!
    @IBOutlet weak var btnShowPromoFor: UIButton!
    
    @IBOutlet weak var tblPromoFor: UITableView!
    @IBOutlet weak var heightForPromoTable: NSLayoutConstraint!
    
    @IBOutlet weak var btnShowDays: UIButton!
    @IBOutlet weak var btnShowWeeks: UIButton!
    @IBOutlet weak var btnShowMonths: UIButton!
    
    /*Complete Order View*/
    @IBOutlet weak var viewForPromoCompleteOrder: UIView!
    @IBOutlet weak var lblPromoCompleteOrder: UILabel!
    @IBOutlet weak var swForCompleteOrder: UISwitch!
    @IBOutlet weak var txtCompleteOrderCount: UITextField!
    /*Item Count View*/
    @IBOutlet weak var viewForPromoItemCount: UIView!
    @IBOutlet weak var lblPromoItemCount: UILabel!
    @IBOutlet weak var swForItemCount: UISwitch!
    
    @IBOutlet weak var txtItemCount: UITextField!
    @IBOutlet weak var lblPromoCodeTypePromoFor: UILabel!
    @IBOutlet weak var imgCodeTypeArrow: UIImageView!
    @IBOutlet weak var imgTypeValueArrow: UIImageView!
    @IBOutlet weak var imgDaysArrow: UIImageView!
    @IBOutlet weak var imgWeeksArrow: UIImageView!
    @IBOutlet weak var imgMonthsArrow: UIImageView!
    @IBOutlet weak var imgPromoForArrow: UIImageView!
    @IBOutlet weak var imgStartDt: UIImageView!
    @IBOutlet weak var imgExpiryDt: UIImageView!
    @IBOutlet weak var imgStartTime: UIImageView!
    @IBOutlet weak var imgExpiryTime: UIImageView!
    @IBOutlet weak var btnPromoImage: UIButton!
    
    
    var  newPromoCode:PromoCodeItem = PromoCodeItem.init(fromDictionary: [:])
    
    
    var promoImage = UIImageView()
    var arrForItemList:[(id:String,name:String)] = []
    var arrForProductList:[(id:String,name:String)] = []
    
    var arrForPromoList:[(id:String,name:String)] = []
    var arrForFinalPromoList:[String] = []
    
    let arrForPromoType = ["TXT_PERCENTAGE".localizedCapitalized,"TXT_ABSOLUTE".localizedCapitalized]
    
    
    let arrForPromoRecursionType = ["TXT_NONE".localizedCapitalized,"TXT_DAILY".localizedCapitalized,"TXT_WEEKLY".localizedCapitalized,"TXT_MONTHLY".localizedCapitalized,"TXT_ANNUALLY".localizedCapitalized]
    
    
    let arrForDays:[String] = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
    let arrForWeeks:[String] = ["1st","2nd","3rd","4th","5th"]
    let arrForMonths:[String] = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    
    
    var arrForSelectedDays:[String] = []
    var arrForSelectedWeeks:[String] = []
    var arrForSelectedMonths:[String] = []
    var mainArrayForRecursionTags:[TagList] = []
    
    var openDialogType:Int = 0
    var selectedPromoType: Int = PromoCodeType.PERCENTAGE
    var selectedPromoRecursionType = 0
    
    var selectedPromoFor = 2
    var currentEditingPromoRecursionType = 1
    var startDate = Date(), endDate = Date(), startTime = Date(), endTime = Date();
    
    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        delegateRight = self
        
        
        setLocalization()
        wsGetItemList()
        setUpTagView(tagViewForDays)
        setUpTagView(tagViewForWeeks)
        setUpTagView(tagViewForMonths)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews();
        
    }
    
    fileprivate func setupLayout() {
        
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews();
        setupLayout()
        
    }
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    override func viewDidDisappear(_ animated: Bool){
        super.viewDidDisappear(animated)
    }
    func setLocalization() {
        if StoreSingleton.shared.store.isStoreAddPromoCode {
            self.setRightBarItem(isNative: false)
            //            self.setRightBarItemImage(image: UIImage.init(named: "doneBlackIcon")!)
            //            self.setRightBarItemImage(image: UIImage(), title: "TXT_SAVE".localized, mode: .center)
            //            self.setrightBarItemBG()
            self.setRightBarItemImage(image: UIImage(named: "correct")!.imageWithColor(color: .themeColor)!, title: "", mode: .center)
            
            self.enableTextFields(enable: true)
            /*set Localized*/
            
        }else {
            self.enableTextFields(enable: false)
        }
        self.lblPromoDays.text = "TXT_DAYS".localizedCapitalized
        self.lblPromoMonths.text = "TXT_MONTHS".localizedCapitalized
        self.lblPromoWeeks.text = "TXT_WEEKS".localizedCapitalized
        
        self.overViewOfDialog.backgroundColor = UIColor.themeOverlayColor
        self.lblRecursionType.text = "TXT_PROMO_RECURSION_TYPE".localizedCapitalized
        self.lblRecursionTypeValue.text = "TXT_NONE".localizedCapitalized
        self.btnAddTag.backgroundColor = UIColor.themeColor
        self.btnAddTag.setTitle("TXT_ADD".localizedUppercase, for: .normal)
        self.btnAddTag.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        self.setNavigationTitle(title: "TXT_PROMO".localizedCapitalized)
        self.txtPromoCode.placeholder = "TXT_PROMO_CODE".localizedCapitalized
        self.txtPromoAmount.placeholder = "TXT_DISCOUNT".localizedCapitalized
        self.txtPromoDetail.placeholder = "TXT_PROMO_DETAIL".localizedCapitalized
        self.txtPromoStartDate.placeholder = "TXT_PROMO_START_DATE".localizedCapitalized
        self.txtPromoExpireDate.placeholder = "TXT_PROMO_EXP_DATE".localizedCapitalized
        self.txtMaxPromoAmount.placeholder = "TXT_DISCOUNT".localizedCapitalized
        self.txtMinPromoAmount.placeholder = "TXT_DISCOUNT".localizedCapitalized
        self.txtPromoExpireDate.placeholder = "TXT_EXP_DATE".localizedCapitalized
        self.txtPromoUsage.placeholder = "TXT_USAGE".localizedCapitalized
        self.lblPromoFor.text = "TXT_PROMO_FOR".localizedCapitalized
        self.lblPromoCodeType.text = "TXT_PROMO_CODE_TYPE".localizedCapitalized
        self.lblPromoCodeTypeValue.text = arrForPromoType[0]
        //        self.btnShowPromoFor.setTitle(downArrow, for: .normal)
        self.lblActivatePromo.text = "TXT_PROMO_ACTIVE".localized;
        self.lblPromoPromoHaveDate.text = "TXT_PROMO_HAVE_DATE".localizedCapitalized
        self.lblPromoMinAmount.text = "TXT_PROMO_MINIMUM_AMOUNT".localizedCapitalized
        self.lblPromoMaxAmount.text = "TXT_PROMO_MAX_DISCOUNT".localizedCapitalized
        self.lblPromoRequiredUsage.text = "TXT_PROMO_REQUIRED_USAGE".localizedCapitalized
        self.lblPromoFor.text = "TXT_STORE".localizedCapitalized
        self.lblPromoCompleteOrder.text = "TXT_PROMO_APPLY_ON_COMPLETED_ORDER".localizedCapitalized
        self.lblPromoItemCount.text = "TXT_PROMO_APPLY_ON_ITEM_COUNT".localizedCapitalized
        self.txtStartTime.placeholder = "TXT_START_TIME".localizedCapitalized
        self.txtEndTime.placeholder = "TXT_END_TIME".localizedCapitalized
        
        self.txtCompleteOrderCount.placeholder = "TXT_COUNT".localizedCapitalized
        self.txtItemCount.placeholder = "TXT_COUNT".localizedCapitalized
        self.lblPromoCodeTypePromoFor.text = "TXT_PROMO_CODE_TYPE".localizedCapitalized
        /*Set colors*/
        self.txtPromoCode.textColor = UIColor.themeTextColor
        self.txtPromoAmount.textColor = UIColor.themeTextColor
        self.txtPromoDetail.textColor = UIColor.themeTextColor
        self.txtPromoStartDate.textColor = UIColor.themeTextColor
        self.txtPromoExpireDate.textColor = UIColor.themeTextColor
        self.txtMaxPromoAmount.textColor = UIColor.themeTextColor
        self.txtMinPromoAmount.textColor = UIColor.themeTextColor
        self.txtPromoExpireDate.textColor = UIColor.themeTextColor
        self.txtPromoUsage.textColor = UIColor.themeTextColor
        self.lblPromoFor.textColor = UIColor.themeTextColor
        self.lblPromoCodeType.textColor = UIColor.themeTextColor
        self.lblPromoCodeTypeValue.textColor = UIColor.themeTextColor
        self.lblActivatePromo.textColor = UIColor.themeTextColor
        self.lblPromoPromoHaveDate.textColor = UIColor.themeTextColor
        self.lblPromoMinAmount.textColor = UIColor.themeTextColor
        self.lblPromoMaxAmount.textColor = UIColor.themeTextColor
        self.lblPromoRequiredUsage.textColor = UIColor.themeTextColor
        self.lblRecursionType.textColor = UIColor.themeLightTextColor
        self.lblRecursionTypeValue.textColor = UIColor.themeTextColor
        self.txtStartTime.textColor = UIColor.themeTextColor
        self.txtEndTime.textColor = UIColor.themeTextColor
        viewForActivatePromo.backgroundColor = UIColor.themeViewBackgroundColor
        self.lblTitleStartTime.textColor = UIColor.themeLightTextColor
        self.lblTitleEndTime.textColor = UIColor.themeLightTextColor
        self.lblTitleStartDate.textColor = UIColor.themeLightTextColor
        self.lblTitleExpiryDate.textColor = UIColor.themeLightTextColor
        self.lblPromoCompleteOrder.textColor = UIColor.themeTextColor
        self.lblPromoItemCount.textColor = UIColor.themeTextColor
        self.lblPromoCodeTypePromoFor.textColor = UIColor.themeLightTextColor
        
        
        
        /*set Font*/
        self.txtPromoCode.font = FontHelper.textRegular()
        self.txtPromoAmount.font = FontHelper.textRegular()
        self.txtPromoDetail.font = FontHelper.textRegular()
        self.txtPromoStartDate.font = FontHelper.textRegular()
        self.txtPromoExpireDate.font = FontHelper.textRegular()
        self.txtMaxPromoAmount.font = FontHelper.textRegular()
        self.txtMinPromoAmount.font = FontHelper.textRegular()
        self.txtPromoExpireDate.font = FontHelper.textRegular()
        self.txtPromoUsage.font = FontHelper.textRegular()
        self.txtStartTime.font = FontHelper.textRegular()
        self.txtEndTime.font = FontHelper.textRegular()
        
        self.lblPromoFor.font = FontHelper.textRegular()
        self.lblPromoCodeType.font = FontHelper.textRegular()
        self.lblPromoCodeTypePromoFor.font = FontHelper.textRegular()
        
        self.lblPromoCodeTypeValue.font = FontHelper.textRegular()
        self.lblActivatePromo.font = FontHelper.textRegular()
        self.lblPromoPromoHaveDate.font = FontHelper.textRegular()
        self.lblPromoMinAmount.font = FontHelper.textRegular()
        self.lblPromoMaxAmount.font = FontHelper.textRegular()
        self.lblPromoRequiredUsage.font = FontHelper.textRegular()
        self.lblRecursionType.font = FontHelper.textRegular()
        self.lblRecursionTypeValue.font = FontHelper.textRegular()
        self.lblPromoCompleteOrder.font = FontHelper.textRegular()
        self.lblPromoItemCount.font = FontHelper.textRegular()
        
        self.lblTitleStartTime.font = FontHelper.textSmall()
        self.lblTitleEndTime.font = FontHelper.textSmall()
        self.lblTitleStartDate.font = FontHelper.textSmall()
        self.lblTitleExpiryDate.font = FontHelper.textSmall()
        
        self.lblTitleStartDate.text = "TXT_START_DATE".localizedCapitalized
        self.lblTitleExpiryDate.text = "TXT_EXPIRE_DATE".localizedCapitalized
        
        tblPromoFor.isHidden = true;
        heightForPromoTable.constant = 0
        
        self.lblRecursionTypeValue.text = "TXT_NONE".localizedCapitalized
        self.stkForDate.isHidden = false
        self.stkForTime.isHidden = true
        self.viewForDay.isHidden = true
        self.viewForWeek.isHidden = true
        self.viewForMonth.isHidden = true
        self.selectedPromoRecursionType = 0
        
        txtStartTime.layer.borderColor = UIColor.themeTextColor.cgColor
        txtStartTime.layer.borderWidth = 0.1
        txtStartTime.borderStyle = .roundedRect
        txtStartTime.tintColor = .themeTextColor
        
        txtEndTime.layer.borderColor = UIColor.themeTextColor.cgColor
        txtEndTime.layer.borderWidth = 0.1
        txtEndTime.borderStyle = .roundedRect
        txtEndTime.tintColor = .themeTextColor
        
        txtPromoStartDate.layer.borderColor = UIColor.themeTextColor.cgColor
        txtPromoStartDate.layer.borderWidth = 0.1
        txtPromoStartDate.borderStyle = .roundedRect
        txtPromoStartDate.tintColor = .themeTextColor
        
        txtPromoExpireDate.layer.borderColor = UIColor.themeTextColor.cgColor
        txtPromoExpireDate.layer.borderWidth = 0.1
        txtPromoExpireDate.borderStyle = .roundedRect
        txtPromoExpireDate.tintColor = .themeTextColor
        
        self.swForActivatePromo.onTintColor = .themeColor
        self.swForPromoHaveDate.onTintColor = .themeColor
        self.swForPromoMinAmount.onTintColor = .themeColor
        self.swForMaxPromoDiscount.onTintColor = .themeColor
        self.swForPromoRequiredUsage.onTintColor = .themeColor
        self.swForCompleteOrder.onTintColor = .themeColor
        self.swForItemCount.onTintColor = .themeColor
        self.btnPromoImage.clipsToBounds = true
        self.btnPromoImage.layer.cornerRadius = 10
        updateUIAccordingToTheme()
    }
    
    override func updateUIAccordingToTheme() {
        
        imgCodeTypeArrow.image = UIImage(named: "arrow_down")?.imageWithColor(color: .themeIconTintColor)
        imgTypeValueArrow.image = UIImage(named: "arrow_down")?.imageWithColor(color: .themeIconTintColor)
        imgDaysArrow.image = UIImage(named: "arrow_down")?.imageWithColor(color: .themeIconTintColor)
        imgWeeksArrow.image = UIImage(named: "arrow_down")?.imageWithColor(color: .themeIconTintColor)
        imgMonthsArrow.image = UIImage(named: "arrow_down")?.imageWithColor(color: .themeIconTintColor)
        imgPromoForArrow.image = UIImage(named: "arrow_down")?.imageWithColor(color: .themeIconTintColor)
        
        
        imgStartDt.image = UIImage(named: "calender")?.imageWithColor(color: .themeIconTintColor)
        imgExpiryDt.image = UIImage(named: "calender")?.imageWithColor(color: .themeIconTintColor)
        imgStartTime.image = UIImage(named: "time")?.imageWithColor(color: .themeIconTintColor)
        imgExpiryTime.image = UIImage(named: "time")?.imageWithColor(color: .themeIconTintColor)
        
    }
    
    //MARK:- Action Methods
    func enableFileds(enable:Bool) {
        self.txtPromoCode.isEnabled = enable
        self.txtPromoAmount.isEnabled = enable
        self.txtPromoDetail.isEnabled = enable
        self.txtPromoStartDate.isEnabled = enable
        self.txtPromoExpireDate.isEnabled = enable
        self.txtMaxPromoAmount.isEnabled = enable
        self.txtMinPromoAmount.isEnabled = enable
        self.txtPromoExpireDate.isEnabled = enable
        self.txtPromoUsage.isEnabled = enable
        self.txtStartTime.isEnabled = enable
        self.txtEndTime.isEnabled = enable
        self.btnAddTag.isEnabled = enable
        
        self.swForActivatePromo.isEnabled = enable
        self.swForPromoHaveDate.isEnabled = enable
        self.swForPromoMinAmount.isEnabled = enable
        self.swForMaxPromoDiscount.isEnabled = enable
        self.swForPromoRequiredUsage.isEnabled = enable
        self.swForCompleteOrder.isEnabled = enable
        self.swForItemCount.isEnabled = enable
    }
    @IBAction func onSwitchValueChanged(_ sender: UISwitch) {
        if sender == swForPromoHaveDate {
            isHidePromoHaveDate(isHide: !sender.isOn)
        }else if sender == swForPromoRequiredUsage {
            isHidePromoUsage(isHide:!sender.isOn)
        }else if sender == swForMaxPromoDiscount {
            isHidePromoMaxAmount(isHide: !sender.isOn)
        }else if sender == swForPromoMinAmount {
            isHidePromoMinAmount(isHide: !sender.isOn)
        }else if sender == swForCompleteOrder {
            isHidePromoCompleteORder(isHide:!sender.isOn)
        }else if sender == swForItemCount {
            isHidePromoItemCount(isHide:!sender.isOn)
        }
    }
    func onClickRightButton() {
        editPromo()
        //self.setRightBarItemImage(image: UIImage.init(named: "doneBlackIcon")!)
    }
    
    
    @IBAction func onClickBtnPromoImage(_ sender: UIButton) {
        dialogForImage =  CustomPhotoDialog.showPhotoDialog("TXT_SELECT_IMAGE".localized, andParent: self, leftTitle: "TXT_GALLERY".localized, rightTitle: "TXT_CAMERA".localized, isCropRequired: false)
        
        self.dialogForImage?.onImageSelected = {
            [unowned self] (image:UIImage) in
            self.promoImage.image = image
            self.btnPromoImage.setImage(self.promoImage.image, for: UIControl.State.normal)
            
        }
    }
    
    
    //MARK:- User Define Methods
    
    func isInvalidNumber(_ view:UITextField, isRequired: Bool) -> Bool {
        if (isRequired) {
            
            if let doubleValue = (view.text ?? "").doubleValue
            {
                return !(doubleValue > 0.0)
                
            }
            else
            {
                return true
            }
            
        }else {
            view.text = ""
            return false;
        }
    }
    
    func checkValidation() -> Bool {
        var msg:String = "";
        
        if (txtPromoCode.text!.removingWhitespaces().isEmpty){
            msg = "MSG_ENTER_VALID_DATA".localized
            txtPromoCode.becomeFirstResponder()
        }
        /*
         else if promoImage.image == nil  {
         msg = "MSG_SELECT_PROMO_IMAGE".localized
         }*/
        else if (isInvalidNumber(txtPromoAmount, isRequired: true)) {
            msg = "MSG_ENTER_VALID_DATA".localized
            txtPromoAmount.becomeFirstResponder()
            
        }else if (selectedPromoType == PromoCodeType.PERCENTAGE && (txtPromoAmount.text?.doubleValue ?? 0.0) > 100) {
            msg = "MSG_ENTER_VALID_DATA".localized
            txtPromoAmount.becomeFirstResponder()
        }else if (isInvalidNumber(txtMaxPromoAmount, isRequired: swForMaxPromoDiscount.isOn)) {
            msg = "MSG_ENTER_VALID_DATA".localized
            txtMaxPromoAmount.becomeFirstResponder()
        }else if (isInvalidNumber(txtMinPromoAmount, isRequired: swForPromoMinAmount.isOn)) {
            msg = "MSG_ENTER_VALID_DATA".localized
            txtMinPromoAmount.becomeFirstResponder()
        }else if (isInvalidNumber(txtPromoUsage, isRequired: swForPromoRequiredUsage.isOn)) {
            msg = "MSG_ENTER_VALID_DATA".localized
            txtPromoUsage.becomeFirstResponder()
        }else if (isInvalidNumber(txtItemCount, isRequired: swForItemCount.isOn)) {
            msg = "MSG_ENTER_VALID_DATA".localized
            txtItemCount.becomeFirstResponder()
        }else if (isInvalidNumber(txtCompleteOrderCount, isRequired: swForCompleteOrder.isOn)) {
            msg = "MSG_ENTER_VALID_DATA".localized
            txtCompleteOrderCount.becomeFirstResponder()
        }else if (startTime > endTime) {
            msg = "MSG_ENTER_VALID_DATA".localized
            txtEndTime.becomeFirstResponder()
        }else if (startDate > endDate) {
            msg = "MSG_ENTER_VALID_DATA".localized
            txtPromoExpireDate.becomeFirstResponder()
        }else if (swForPromoHaveDate.isOn) {
            switch (selectedPromoRecursionType) {
            case PROMO_RECURSION_TYPE.ANNUAL:
                if arrForMonths.isEmpty
                {
                    msg = "MSG_ENTER_VALID_DATA".localized
                    
                }
                fallthrough
            case PROMO_RECURSION_TYPE.MONTH:
                if arrForMonths.isEmpty {
                    msg = "MSG_ENTER_VALID_DATA".localized
                }
                fallthrough
            case PROMO_RECURSION_TYPE.WEEK:
                if arrForWeeks.isEmpty {
                    msg = "MSG_ENTER_VALID_DATA".localized
                }
                fallthrough
            case PROMO_RECURSION_TYPE.DAY:
                if arrForDays.isEmpty {
                    msg = "MSG_ENTER_VALID_DATA".localized
                }
                fallthrough
            case PROMO_RECURSION_TYPE.NONE:
                if txtPromoStartDate.text?.isEmpty() ?? true {
                    msg = "MSG_ENTER_VALID_DATA".localized
                }
                else if txtPromoExpireDate.text?.isEmpty() ?? true {
                    msg = "MSG_ENTER_VALID_DATA".localized
                }
                
            default:
                print("done")
            }
        }
        
        if !msg.isEmpty() {
            Utility.showToast(message: msg)
        }
        return msg.isEmpty();
    }
    
    func enableTextFields(enable:Bool) -> Void {
        
        self.btnSelectRecursionType.isEnabled = enable
        self.btnShowDays.isEnabled = enable
        self.btnShowWeeks.isEnabled = enable
        self.btnShowMonths.isEnabled = enable
        
        
        
        self.txtPromoAmount.isEnabled = enable
        self.txtPromoDetail.isEnabled = enable
        self.txtPromoStartDate.isEnabled = enable
        self.txtPromoExpireDate.isEnabled = enable
        self.txtMaxPromoAmount.isEnabled = enable
        self.txtMinPromoAmount.isEnabled = enable
        self.txtPromoUsage.isEnabled = enable
        self.lblPromoCodeTypeValue.isEnabled = enable
        self.txtItemCount.isEnabled = enable
        self.txtCompleteOrderCount.isEnabled = enable
        self.txtStartTime.isEnabled = enable
        self.txtEndTime.isEnabled = enable
        
        
        
        
        self.btnShowPromoCodeType.isEnabled = enable
        self.swForPromoHaveDate.isEnabled = enable
        self.swForActivatePromo.isEnabled = enable
        self.swForPromoMinAmount.isEnabled = enable
        self.swForMaxPromoDiscount.isEnabled = enable
        self.swForPromoRequiredUsage.isEnabled = enable
        self.swForCompleteOrder.isEnabled = enable
        self.swForItemCount.isEnabled = enable
        if selectedPromoItem != nil {
            self.txtPromoCode.isEnabled = false
            self.btnShowPromoFor.isEnabled = false
            self.viewForPromoFor.isUserInteractionEnabled = false
        }else {
            self.txtPromoCode.isEnabled = enable
            self.btnShowPromoFor.isEnabled = enable
            self.viewForPromoFor.isUserInteractionEnabled = enable
        }
    }
    fileprivate func isHidePromoHaveDate(isHide:Bool) {
        stkForPromoHaveDate.isHidden = isHide
        viewstkForPromoHaveDate.isHidden = isHide
        view.layoutIfNeeded()
    }
    fileprivate func isHidePromoUsage(isHide:Bool) {
        txtPromoUsage.isHidden = isHide
        view.layoutIfNeeded()
        
        
    }
    fileprivate func isHidePromoMinAmount(isHide:Bool) {
        txtMinPromoAmount.isHidden = isHide
        view.layoutIfNeeded()
        
    }
    fileprivate func isHidePromoCompleteORder(isHide:Bool) {
        txtCompleteOrderCount.isHidden = isHide
        view.layoutIfNeeded()
        
    }
    fileprivate func isHidePromoItemCount(isHide:Bool) {
        txtItemCount.isHidden = isHide
        view.layoutIfNeeded()
        
    }
    fileprivate func isHidePromoMaxAmount(isHide:Bool) {
        txtMaxPromoAmount.isHidden = isHide
        view.layoutIfNeeded()
        
    }
    func setPromoData() {
        //        print(Utility.getDynamicImageURL(width: imgPromoV.frame.width, height: imgPromoV.frame.height, imgUrl: self.selectedPromoItem!.image_url))
        //        self.imgPromoV.downloadedFrom(link: Utility.getDynamicImageURL(width: imgPromoV.frame.width, height: imgPromoV.frame.height, imgUrl: self.selectedPromoItem!.image_url), placeHolder: "addPlaceholder", isFromCache: true, isIndicator: false, mode: .scaleAspectFit, isAppendBaseUrl: true, isFromResize: true)
        
        
        
        self.promoImage.downloadedFrom(link: self.selectedPromoItem?.promoCodeImageUrl ?? "", placeHolder: "add_image") { success in
            self.btnPromoImage.setImage(self.promoImage.image, for: UIControl.State.normal)
        }
        
        self.txtPromoCode.text = self.selectedPromoItem?.promoCodeName
        self.txtPromoAmount.text =  String(self.selectedPromoItem?.promoCodeValue ?? 0.0)
        self.arrForSelectedDays = self.selectedPromoItem?.days  ?? []
        self.arrForSelectedWeeks = self.selectedPromoItem?.weeks ?? []
        self.arrForSelectedMonths = self.selectedPromoItem?.months ?? []
        self.selectedPromoRecursionType = self.selectedPromoItem?.promoRecursionType ?? 0
        self.updateRecursionView(selectedType: self.selectedPromoRecursionType)
        
        for itemId in (self.selectedPromoItem?.promoApplyOn) ?? [] {
            self.arrForFinalPromoList.append(itemId)
        }
        self.arrForFinalPromoList.append(preferenceHelper.getUserId())
        self.txtPromoDetail.text =  self.selectedPromoItem?.promoDetails
        self.txtMaxPromoAmount.text = String(self.selectedPromoItem?.promoCodeMaxDiscountAmount ?? 0.0)
        self.txtMinPromoAmount.text = String(self.selectedPromoItem?.promoCodeApplyOnMinimumAmount ?? 0.0)
        self.txtPromoUsage.text = String(self.selectedPromoItem?.promoCodeUses ?? 0)
        self.lblPromoCodeTypeValue.text =  String(self.selectedPromoItem?.promoCodeType ?? 0)
        
        self.swForPromoHaveDate.isOn = self.selectedPromoItem?.isPromoHaveDate ?? false
        self.swForActivatePromo.isOn = self.selectedPromoItem?.isActive ?? false
        self.swForPromoMinAmount.isOn = self.selectedPromoItem?.isPromoHaveMinimumAmountLimit ?? false
        self.swForMaxPromoDiscount.isOn = self.selectedPromoItem?.isPromoHaveMaxDiscountLimit ?? false
        self.swForPromoRequiredUsage.isOn = self.selectedPromoItem?.isPromoRequiredUses ?? false
        self.swForItemCount.isOn = self.selectedPromoItem?.isPromoHaveItemCountLimit ?? false
        self.swForCompleteOrder.isOn = self.selectedPromoItem?.isPromoApplyOnCompletedOrder ?? false
        self.txtCompleteOrderCount.text = String(self.selectedPromoItem?.promoApplyAfterCompletedOrder ?? 0 )
        self.txtItemCount.text = String(self.selectedPromoItem?.promoCodeApplyOnMinimumItemCount ?? 0 )
        
        
        
        if (selectedPromoItem?.isPromoHaveDate) ?? false {
            txtPromoExpireDate.text = Utility.stringToString(strDate: (selectedPromoItem?.promoExpireDate)!, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_FORMAT)
            txtPromoStartDate.text = Utility.stringToString(strDate: (selectedPromoItem?.promoStartDate)!, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_FORMAT)
            
            startDate = Utility.stringToDate(strDate: (selectedPromoItem?.promoStartDate)!, withFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB)
            endDate = Utility.stringToDate(strDate: (selectedPromoItem?.promoExpireDate)!, withFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB)
            
            stkForPromoHaveDate.isHidden = false
            viewstkForPromoHaveDate.isHidden = false
            
        }else {
            stkForPromoHaveDate.isHidden = true
            viewstkForPromoHaveDate.isHidden = true
            
        }
        self.txtStartTime.text = selectedPromoItem?.promoStartTime ?? ""
        self.txtEndTime.text = selectedPromoItem?.promoEndTime ?? ""
        
        
        let gregorian = Calendar(identifier: .gregorian)
        let now = Date()
        var components = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
        
        // Change the time to 9:30:00 in your locale
        
        
        
        if !(self.txtStartTime.text?.isEmpty() ?? true) {
            
            
            if let array = txtStartTime.text?.components(separatedBy: ":") {
                components.hour = array[0].integerValue ?? 0
                components.minute = array[1].integerValue ?? 0
                components.second = 0
                startTime = gregorian.date(from: components)!
            }
        }
        if !(self.txtEndTime.text?.isEmpty() ?? true) {
            if let array = txtStartTime.text?.components(separatedBy: ":") {
                components.hour = array[0].integerValue ?? 0
                components.minute = array[1].integerValue ?? 0
                components.second = 0
                endTime = gregorian.date(from: components)!
            }
        }
        
        isHidePromoMinAmount(isHide:!swForPromoMinAmount.isOn)
        isHidePromoMaxAmount(isHide: !swForMaxPromoDiscount.isOn)
        isHidePromoUsage(isHide: !swForPromoRequiredUsage.isOn)
        isHidePromoHaveDate(isHide: !swForPromoHaveDate.isOn)
        isHidePromoCompleteORder(isHide: !swForCompleteOrder.isOn)
        isHidePromoItemCount(isHide: !swForItemCount.isOn)
        selectedPromoType = (selectedPromoItem?.promoCodeType) ?? PromoCodeType.PERCENTAGE
        
        if selectedPromoType == PromoCodeType.PERCENTAGE {
            self.lblPromoCodeTypeValue.text =
            arrForPromoType[0]
            
        }else {
            self.lblPromoCodeTypeValue.text =
            arrForPromoType[1]
        }
        selectedPromoFor = selectedPromoItem?.promoFor ?? 1
        if selectedPromoFor == PROMOFOR.PRODUCT {
            self.lblPromoFor.text = "TXT_PRODUCT".localizedCapitalized
            self.reloadTableWithArray(arrForPromo: arrForProductList)
        }else if selectedPromoFor == PROMOFOR.ITEM {
            self.lblPromoFor.text = "TXT_ITEM".localizedCapitalized
            self.reloadTableWithArray(arrForPromo: arrForItemList)
        }else {
            self.lblPromoFor.text = "TXT_STORE".localizedCapitalized
            tblPromoFor.isHidden = true;
            heightForPromoTable.constant = 0
        }
        reloadTagView(tagViewForDays)
        reloadTagView(tagViewForWeeks)
        reloadTagView(tagViewForMonths)
        
        print(startTime)
        print(endTime)
        print(startDate)
        print(endDate)
        
        
        
    }
    func reloadTagView(_ tagView:HTagView) {
        if tagView == tagViewForDays{
            if arrForSelectedDays.isEmpty {
                tagViewForDays.isHidden = true
            }else {
                tagViewForDays.isHidden = false
                
            }
        }
        if tagView == tagViewForWeeks {
            if arrForSelectedWeeks.isEmpty {
                tagView.isHidden = true
            }else {
                tagView.isHidden = false
                
            }
        }
        if tagView == tagViewForMonths {
            if arrForSelectedMonths.isEmpty {
                tagView.isHidden = true
            }else {
                tagView.isHidden = false
                
            }
        }
        tagView.reloadData()
    }
    func editPromo() -> Void{
        
        if (checkValidation()) {
            if selectedPromoItem != nil {
                wsUpdatePromo()
            }
            else {
                //Storeapp //change
                //                    wsAddPromo()
                
                wsCheckPromo()
            }
        }
        
    }
    
    @IBAction func onClickBtnShowRecursionMenu(_ sender: Any) {
        
        let actionSheetController = UIAlertController(title: "TXT_PROMO_RECURSION_TYPE".localizedCapitalized, message: "OPTION_TO_SELECT".localized, preferredStyle: .actionSheet)
        actionSheetController.view.tintColor = UIColor.themeTitleColor
        let cancelActionButton = UIAlertAction(title: "TXT_NONE".localizedCapitalized, style: .default) { action -> Void in
            self.updateRecursionView(selectedType: PROMO_RECURSION_TYPE.NONE)
        }
        
        actionSheetController.addAction(cancelActionButton)
        
        let dailyActionButton = UIAlertAction(title:"TXT_DAILY".localizedCapitalized, style: .default) { action -> Void in
            self.updateRecursionView(selectedType: PROMO_RECURSION_TYPE.DAY)
            
        }
        actionSheetController.addAction(dailyActionButton)
        
        let weeklyActionButton = UIAlertAction(title: "TXT_WEEKLY".localizedCapitalized, style: .default) { action -> Void in
            
            self.updateRecursionView(selectedType: PROMO_RECURSION_TYPE.WEEK)
            
            
        }
        actionSheetController.addAction(weeklyActionButton)
        
        let monthlyActionButton = UIAlertAction(title: "TXT_MONTHLY".localizedCapitalized, style: .default) { action -> Void in
            self.updateRecursionView(selectedType: PROMO_RECURSION_TYPE.MONTH)
        }
        actionSheetController.addAction(monthlyActionButton)
        let annuallyActionButton = UIAlertAction(title: "TXT_ANNUALLY".localizedCapitalized, style: .default) { action -> Void in
            self.updateRecursionView(selectedType: PROMO_RECURSION_TYPE.ANNUAL)
        }
        actionSheetController.addAction(annuallyActionButton)
        if UIDevice().model == "iPad" {
            
            if let presenter = actionSheetController.popoverPresentationController {
                presenter.sourceView = self.view
                presenter.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                presenter.permittedArrowDirections = []
                
            }
            present(actionSheetController, animated: true, completion: nil)
        }else {
            self.present(actionSheetController, animated: true, completion: nil)
        }
    }
    func updateRecursionView(selectedType:Int) {
        selectedPromoRecursionType = selectedType
        switch selectedType {
        case 0:
            self.lblRecursionTypeValue.text = arrForPromoRecursionType[selectedType]
            self.stkForDate.isHidden = false
            self.stkForTime.isHidden = true
            self.viewForDay.isHidden = true
            self.viewForWeek.isHidden = true
            self.viewForMonth.isHidden = true
        case 1:
            self.lblRecursionTypeValue.text = arrForPromoRecursionType[selectedType]
            self.stkForDate.isHidden = false
            self.stkForTime.isHidden = false
            self.viewForDay.isHidden = true
            self.viewForWeek.isHidden = true
            self.viewForMonth.isHidden = true
            break
        case 2:
            self.lblRecursionTypeValue.text = arrForPromoRecursionType[selectedType]
            self.stkForDate.isHidden = false
            self.stkForTime.isHidden = false
            self.viewForDay.isHidden = false
            self.viewForWeek.isHidden = true
            self.viewForMonth.isHidden = true
            break
        case 3:
            self.lblRecursionTypeValue.text = arrForPromoRecursionType[selectedType]
            self.stkForDate.isHidden = false
            self.stkForTime.isHidden = false
            self.viewForDay.isHidden = false
            self.viewForWeek.isHidden = false
            self.viewForMonth.isHidden = true
            break
        case 4:
            self.lblRecursionTypeValue.text = arrForPromoRecursionType[selectedType]
            self.stkForDate.isHidden = false
            self.stkForTime.isHidden = false
            self.viewForDay.isHidden = false
            self.viewForWeek.isHidden = false
            self.viewForMonth.isHidden = false
            break
        default:
            print("none")
        }
    }
    @IBAction func onClickBtnShowPromoForMenu(_ sender: Any) {
        let actionSheetController = UIAlertController(title: "TXT_SELECT_PROMO_FOR".localized, message: "OPTION_TO_SELECT".localized, preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "TXT_STORE".localizedCapitalized, style: .default) { action -> Void in
            self.heightForPromoTable.constant = 0
            self.lblPromoFor.text = "TXT_STORE".localizedCapitalized
            self.selectedPromoFor = PROMOFOR.STORE
        }
        actionSheetController.addAction(cancelActionButton)
        
        let saveActionButton = UIAlertAction(title: "TXT_PRODUCT".localizedCapitalized, style: .default) { action -> Void in
            self.lblPromoFor.text = "TXT_PRODUCT".localizedCapitalized
            self.selectedPromoFor = PROMOFOR.PRODUCT
            self.reloadTableWithArray(arrForPromo: self.arrForProductList)
        }
        actionSheetController.addAction(saveActionButton)
        
        let deleteActionButton = UIAlertAction(title: "TXT_ITEM".localizedCapitalized, style: .default) { action -> Void in
            self.lblPromoFor.text = "TXT_ITEM".localizedCapitalized
            self.selectedPromoFor = PROMOFOR.ITEM
            
            self.reloadTableWithArray(arrForPromo: self.arrForItemList)
        }
        actionSheetController.addAction(deleteActionButton)
        if UIDevice().model == "iPad" {
            
            if let presenter = actionSheetController.popoverPresentationController {
                presenter.sourceView = self.view
                presenter.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                presenter.permittedArrowDirections = []
                
            }
            present(actionSheetController, animated: true, completion: nil)
        }else {
            self.present(actionSheetController, animated: true, completion: nil)
        }
    }
    @IBAction func onClickBtnShowPromoType(_ sender: Any) {
        let actionSheetController = UIAlertController(title: "TITLE_PLEASE_SELECT_PROMO_TYPE".localized, message: "OPTION_TO_SELECT".localized, preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: arrForPromoType[0], style: .default) { action -> Void in
            self.lblPromoCodeTypeValue.text = self.arrForPromoType[0]
            self.selectedPromoType = PromoCodeType.PERCENTAGE
        }
        actionSheetController.addAction(cancelActionButton)
        
        let saveActionButton = UIAlertAction(title: arrForPromoType[1], style: .default) { action -> Void in
            self.lblPromoCodeTypeValue.text = self.arrForPromoType[1]
            self.selectedPromoType = PromoCodeType.ABSOLUTE
        }
        actionSheetController.addAction(saveActionButton)
        if UIDevice().model == "iPad" {
            
            if let presenter = actionSheetController.popoverPresentationController {
                presenter.sourceView = self.view
                presenter.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                presenter.permittedArrowDirections = []
                
            }
            present(actionSheetController, animated: true, completion: nil)
        }else {
            self.present(actionSheetController, animated: true, completion: nil)
        }
    }
    @IBAction func onClickBtnShowDayDialog(_ sender: Any) {
        showTableView(type: 0)
    }
    @IBAction func onClickBtnShowMonthDialog(_ sender: Any) {
        showTableView(type: 2)
        
    }
    @IBAction func onClickBtnShowWeekDialog(_ sender: Any) {
        showTableView(type: 1)
        
    }
    func showTableView(type:Int) {
        
        var titleStr = ""
        if type == 0{
            titleStr = "TXT_DAYS".localizedCapitalized
        }else if type == 1{
            titleStr = "TXT_WEEKS".localizedCapitalized
        }else{
            titleStr = "TXT_MONTHS".localizedCapitalized
        }
        
        let dialog = DialogForMonthDays.showDialogForMonthDays(title: titleStr, message: "", type: type,arrForSelectedDays: arrForSelectedDays,arrForSelectedWeeks: arrForSelectedWeeks,arrForSelectedMonths: arrForSelectedMonths)
        dialog.onClickApplyRecursion = {
            (type, arrForSelectedDays,  arrForSelectedWeeks,  arrForSelectedMonths, mainArrayForRecursionTags) in
            self.currentEditingPromoRecursionType = type
            
            dialog.removeFromSuperview()
            self.mainArrayForRecursionTags.removeAll()
            self.mainArrayForRecursionTags.append(contentsOf: mainArrayForRecursionTags)
            if self.currentEditingPromoRecursionType == 0 {
                self.arrForSelectedDays.removeAll()
                for element in mainArrayForRecursionTags {
                    if element.isSelected {
                        self.arrForSelectedDays.append(element.itemName)
                    }
                }
                
                self.reloadTagView(self.tagViewForDays)
                
            }else if self.currentEditingPromoRecursionType == 1 {
                self.arrForSelectedWeeks.removeAll()
                for element in mainArrayForRecursionTags {
                    if element.isSelected {
                        self.arrForSelectedWeeks.append(element.itemName)
                    }
                }
                
                self.reloadTagView(self.tagViewForWeeks)
            }
            else {
                self.arrForSelectedMonths.removeAll()
                for element in mainArrayForRecursionTags {
                    if element.isSelected {
                        self.arrForSelectedMonths.append(element.itemName)
                    }
                }
            }
            
            self.reloadTagView(self.tagViewForMonths)
            
            //            if type == 0 {
            //                for  currentElement in self.arrForDays {
            //                    let tag:TagList = TagList.init(itemName: currentElement, isSelected: arrForSelectedDays.contains(currentElement))
            //                    self.mainArrayForRecursionTags.append(tag)
            //                }
            //            }else if type == 1 {
            //                for  currentElement in self.arrForWeeks {
            //                    let tag:TagList = TagList.init(itemName: currentElement, isSelected: arrForSelectedWeeks.contains(currentElement))
            //                    self.mainArrayForRecursionTags.append(tag)
            //                }
            //            }else if type == 2 {
            //                for  currentElement in self.arrForMonths {
            //                    let tag:TagList = TagList.init(itemName: currentElement, isSelected: arrForSelectedMonths.contains(currentElement))
            //                    self.mainArrayForRecursionTags.append(tag)
            //                }
            //            }
            self.tblTags.reloadData()
            //            self.overViewOfDialog.isHidden = false
        }
        
        dialog.onClickLeftButton = {
            dialog.removeFromSuperview()
        }
        
        /*
         if type == 0 {
         for  currentElement in arrForDays {
         let tag:TagList = TagList.init(itemName: currentElement, isSelected: arrForSelectedDays.contains(currentElement))
         mainArrayForRecursionTags.append(tag)
         }
         }else if type == 1 {
         for  currentElement in arrForWeeks {
         let tag:TagList = TagList.init(itemName: currentElement, isSelected: arrForSelectedWeeks.contains(currentElement))
         mainArrayForRecursionTags.append(tag)
         }
         }else if type == 2 {
         for  currentElement in arrForMonths {
         let tag:TagList = TagList.init(itemName: currentElement, isSelected: arrForSelectedMonths.contains(currentElement))
         mainArrayForRecursionTags.append(tag)
         }
         }
         tblTags.reloadData()
         overViewOfDialog.isHidden = false*/
    }
    @IBAction func onClickBtnApplyRecursion(_ sender: Any) {
        if currentEditingPromoRecursionType == 0 {
            arrForSelectedDays.removeAll()
            for element in mainArrayForRecursionTags {
                if element.isSelected {
                    arrForSelectedDays.append(element.itemName)
                }
            }
            
            reloadTagView(tagViewForDays)
            
        }else if currentEditingPromoRecursionType == 1 {
            arrForSelectedWeeks.removeAll()
            for element in mainArrayForRecursionTags {
                if element.isSelected {
                    arrForSelectedWeeks.append(element.itemName)
                }
            }
            
            reloadTagView(tagViewForWeeks)
        }
        else {
            arrForSelectedMonths.removeAll()
            for element in mainArrayForRecursionTags {
                if element.isSelected {
                    arrForSelectedMonths.append(element.itemName)
                }
            }
        }
        
        reloadTagView(tagViewForMonths)
        overViewOfDialog.isHidden = true
    }
    func openDatePicker(isStartDate:Bool) {
        
        self.view.endEditing(true)
        
        let strTitle  = isStartDate ? "TXT_SELECT_PROMO_START_DATE".localized : "TXT_SELECT_EXPIRY_DATE".localized
        let datePickerDialog:CustomDatePickerDialog = CustomDatePickerDialog.showCustomDatePickerDialog(title: strTitle.localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_SELECT".localized)
        
        if isStartDate {
            datePickerDialog.setMinDate(mindate: Date())
            if txtPromoExpireDate.text?.isEmpty() ?? true {
                
            }else {
                datePickerDialog.setMaxDate(maxdate: endDate)
            }
        }else {
            if txtPromoStartDate.text?.isEmpty() ?? true {
                
            }else {
                if selectedPromoItem != nil {
                    datePickerDialog.setMinDate(mindate: Utility.stringToDate(strDate: (selectedPromoItem?.promoStartDate)!, withFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB))
                }
                else {
                    datePickerDialog.setMinDate(mindate: startDate)
                }
            }
        }
        datePickerDialog.onClickLeftButton = { [unowned datePickerDialog] in
            datePickerDialog.removeFromSuperview()
        }
        
        datePickerDialog.onClickRightButton = { [unowned datePickerDialog, unowned self] (selectedDate:Date) in
            let currentDate = Utility.dateToString(date: selectedDate, withFormat: DATE_CONSTANT.DATE_FORMAT)
            if isStartDate {
                if self.selectedPromoItem != nil
                {
                    self.selectedPromoItem?.promoStartDate = Utility.dateToString(date: selectedDate, withFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB)
                    
                }
                else
                {
                    self.newPromoCode.promoStartDate = Utility.dateToString(date: selectedDate, withFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB)
                    
                }
                self.txtPromoStartDate.text = currentDate
                self.startDate = selectedDate;
            }
            else {
                if self.selectedPromoItem != nil
                {
                    self.selectedPromoItem?.promoExpireDate = Utility.dateToString(date: selectedDate, withFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB)
                    
                }
                else
                {
                    
                    self.newPromoCode.promoExpireDate = Utility.dateToString(date: selectedDate, withFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB)
                    
                }
                self.txtPromoExpireDate.text = currentDate
                self.endDate = selectedDate;
            }
            datePickerDialog.removeFromSuperview()
        }
    }
    
    func openTimePicker(isStartTime:Bool
                        = false) {
        if !isStartTime && txtStartTime.text?.isEmpty() ?? true {
            Utility.showToast(message: "TXT_PLEASE_SELECT_START_TIME_FIRST".localized)
        }else {
            let title = isStartTime ? "TXT_SELECT_PROMO_START_TIME".localized : "TXT_SELECT_PROMO_END_TIME".localized
            let dialogForTimePicker:CustomTimePicker = CustomTimePicker.showCustomTimePickerDialog(title:title, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_OK".localized, openingTime: txtStartTime.text!,isOpenTime:isStartTime)
            
            
            dialogForTimePicker.onClickLeftButton = { [unowned dialogForTimePicker] in
                
                dialogForTimePicker.removeFromSuperview();
            }
            dialogForTimePicker.onClickRightButton = {[unowned dialogForTimePicker, unowned self]
                (selectedTime:Date) in
                
                let strSelectedTime:String = Utility.dateToString(date: selectedTime, withFormat: DATE_CONSTANT.TIME_FORMAT_HH_MM)
                
                
                let gregorian = Calendar(identifier: .gregorian)
                let now = Date()
                var components = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
                
                // Change the time to 9:30:00 in your locale
                let array = strSelectedTime.components(separatedBy: ":")
                components.hour = array[0].integerValue ?? 0
                components.minute = array[1].integerValue ?? 0
                components.second = 0
                
                let selectedTimeWithHourMin = gregorian.date(from: components)!
                
                
                if isStartTime {
                    self.txtStartTime.text = strSelectedTime
                    self.startTime = selectedTimeWithHourMin
                }
                else {
                    self.txtEndTime.text = strSelectedTime
                    self.endTime = selectedTimeWithHourMin
                }
                
                dialogForTimePicker.removeFromSuperview();
                
            }
        }
        
    }
    func wsUpdatePromo() {
        
        
        selectedPromoItem?.isPromoHaveDate = swForPromoHaveDate.isOn
        selectedPromoItem?.months = arrForSelectedMonths
        selectedPromoItem?.days = arrForSelectedDays
        selectedPromoItem?.weeks = arrForSelectedWeeks
        selectedPromoItem?.promoRecursionType = self.selectedPromoRecursionType
        
        selectedPromoItem?.isPromoApplyOnCompletedOrder = swForCompleteOrder.isOn
        selectedPromoItem?.isPromoHaveItemCountLimit = swForItemCount.isOn
        
        selectedPromoItem?.promoCodeApplyOnMinimumItemCount = txtItemCount.text?.integerValue ?? 0
        selectedPromoItem?.promoApplyAfterCompletedOrder = txtCompleteOrderCount.text?.integerValue ?? 0
        selectedPromoItem?.promoStartTime = txtStartTime.text
        selectedPromoItem?.promoEndTime = txtEndTime.text
        
        selectedPromoItem?.isPromoRequiredUses = swForPromoRequiredUsage.isOn
        selectedPromoItem?.isActive = swForActivatePromo.isOn
        selectedPromoItem?.isPromoHaveMaxDiscountLimit = swForMaxPromoDiscount.isOn
        selectedPromoItem?.isPromoHaveMinimumAmountLimit = swForPromoMinAmount.isOn
        
        selectedPromoItem?.promoCodeName = txtPromoCode.text
        selectedPromoItem?.promoDetails = txtPromoDetail.text
        selectedPromoItem?.promoCodeValue = (txtPromoAmount.text?.doubleValue)?.roundTo()
        selectedPromoItem?.promoCodeApplyOnMinimumAmount = (txtMinPromoAmount.text?.doubleValue)?.roundTo()
        selectedPromoItem?.promoCodeMaxDiscountAmount = (txtMaxPromoAmount.text?.doubleValue)?.roundTo()
        selectedPromoItem?.promoCodeUses = txtPromoUsage.text?.integerValue
        selectedPromoItem?.promoCodeType = selectedPromoType
        selectedPromoItem?.promoFor = selectedPromoFor
        selectedPromoItem?.promoApplyOn = self.arrForFinalPromoList
        
        
        let dictParam:[String:Any] = (selectedPromoItem?.toDictionary())!
        // print(Utility.conteverDictToJson(dict: dictParam))
        Utility.showLoading()
        
        let alamofire = AlamofireHelper.init()
        
        if promoImage.image == UIImage(named: "add_image"){
            promoImage.image = nil
        }
        
        alamofire.getResponseFromURL(url: WebService.UPDATE_PROMO_CODE, paramData: dictParam, image: promoImage.image) { response, error   in
            Utility.hideLoading()
            
            if Parser.isSuccess(response: response) {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        /*
         alamofire.getResponseFromURL(url: WebService.UPDATE_PROMO_CODE , methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
         
         Utility.hideLoading()
         
         if Parser.isSuccess(response: response) {
         
         self.navigationController?.popViewController(animated: true)
         }
         
         } */
        
        
        
    }
    
    func wsCheckPromo() {
        
        var dictParam = [String:Any]()
        dictParam[PARAMS.STORE_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.SERVER_TOKEN] = preferenceHelper.getSessionToken()
        dictParam[PARAMS.PROMO_CODE] = txtPromoCode.text
        
        Utility.showLoading()
        
        let alamofire = AlamofireHelper.init()
        
        alamofire.getResponseFromURL(url: WebService.CHECK_PROMO_CODE , methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            
            Utility.hideLoading()
            
            if Parser.isSuccess(response: response) {
                self.wsAddPromo()
            }else{
                Utility.showToast(message: "Promo code already added try other one")
            }
            
        }
    }
    
    func wsAddPromo() {
        
        
        newPromoCode.isPromoHaveDate = swForPromoHaveDate.isOn
        newPromoCode.months = arrForSelectedMonths
        newPromoCode.days = arrForSelectedDays
        newPromoCode.weeks = arrForSelectedWeeks
        newPromoCode.promoRecursionType = self.selectedPromoRecursionType
        newPromoCode.isPromoApplyOnCompletedOrder = swForCompleteOrder.isOn
        newPromoCode.isPromoHaveItemCountLimit = swForItemCount.isOn
        newPromoCode.promoCodeApplyOnMinimumItemCount = txtItemCount.text?.integerValue ?? 0
        newPromoCode.promoCodeApplyOnMinimumItemCount = txtCompleteOrderCount.text?.integerValue ?? 0
        newPromoCode.promoStartTime = txtStartTime.text
        newPromoCode.promoEndTime = txtEndTime.text
        
        
        newPromoCode.isPromoRequiredUses = swForPromoRequiredUsage.isOn
        newPromoCode.isActive = swForActivatePromo.isOn
        newPromoCode.isPromoHaveMaxDiscountLimit = swForMaxPromoDiscount.isOn
        newPromoCode.isPromoHaveMinimumAmountLimit = swForPromoMinAmount.isOn
        newPromoCode.promoCodeName = txtPromoCode.text
        newPromoCode.promoDetails = txtPromoDetail.text
        newPromoCode.promoCodeValue = (txtPromoAmount.text?.doubleValue)?.roundTo()
        newPromoCode.promoCodeApplyOnMinimumAmount = (txtMinPromoAmount.text?.doubleValue)?.roundTo()
        newPromoCode.promoCodeMaxDiscountAmount = (txtMaxPromoAmount.text?.doubleValue)?.roundTo()
        newPromoCode.promoCodeUses = txtPromoUsage.text?.integerValue
        newPromoCode.promoCodeType = selectedPromoType
        newPromoCode.promoFor = selectedPromoFor
        
        
        let dictParam:[String:Any] = (newPromoCode.toDictionary())
        
        Utility.showLoading()
        
        let alamofire = AlamofireHelper.init()
        
        
        alamofire.getResponseFromURL(url: WebService.ADD_PROMO_CODE, paramData: dictParam, image: promoImage.image) { response, error in
            Utility.hideLoading()
            
            if Parser.isSuccess(response: response) {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        /*
         alamofire.getResponseFromURL(url: WebService.ADD_PROMO_CODE , methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
         
         Utility.hideLoading()
         
         if Parser.isSuccess(response: response) {
         self.navigationController?.popViewController(animated: true)
         }
         
         } */
        
        
        
        
        
    }
    func wsGetItemList() -> Void {
        var dictParam = [String:Any]()
        dictParam[PARAMS.STORE_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.SERVER_TOKEN] = preferenceHelper.getSessionToken()
        
        Utility.showLoading()
        let alamofire = AlamofireHelper.init()
        alamofire.getResponseFromURL(url: WebService.WS_GET_ITEM_LIST, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            
            
            if Parser.isSuccess(response: response,withSuccessToast: false,andErrorToast: false) {
                
                
                self.arrForProductList.removeAll()
                self.arrForItemList.removeAll()
                
                let itemListResponse:ItemListResponse = ItemListResponse.init(fromDictionary: response)
                let arrProduct:Array<ProductItem> = itemListResponse.products
                
                for product in arrProduct {
                    self.arrForProductList.append((id:product.id, name: product.name))
                    for item in product.items
                    {
                        self.arrForItemList.append((id:item.id, name: item.name))
                    }
                    
                }
                if self.selectedPromoItem != nil {
                    self.setPromoData()
                    
                    
                }
                
                Utility.hideLoading()
            }else {
                Utility.hideLoading()
            }
        }
    }
    
    
    func reloadTableWithArray(arrForPromo:[(String,String)]) {
        self.arrForPromoList.removeAll()
        for item in arrForPromo {
            self.arrForPromoList.append(item)
        }
        tblPromoFor.reloadData()
        self.heightForPromoTable.constant = tblPromoFor.contentSize.height
        tblPromoFor.isHidden = false
    }
}
extension PromoVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tblPromoFor == tableView {
            return arrForPromoList.count
        }else {
            return mainArrayForRecursionTags.count
            
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tblPromoFor {
            let cell:PromoItemCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PromoItemCell
            
            cell.btnAvail.tag = indexPath.row
            cell.btnAvail.isSelected = self.arrForFinalPromoList.contains(arrForPromoList[indexPath.row].id)
            cell.btnAvail.addTarget(self, action: #selector(self.onClickBtnSelectPromo(_:)), for: .touchUpInside)
            cell.lblPromoItemName.text = self.arrForPromoList[indexPath.row].name
            return cell
        }else {
            let cell:CheckListCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CheckListCell
            cell.lblItemName.text = mainArrayForRecursionTags[indexPath.row].itemName.localized
            cell.imgButtonType.isSelected = mainArrayForRecursionTags[indexPath.row].isSelected
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if mainArrayForRecursionTags.count > 0 && mainArrayForRecursionTags.count >= indexPath.row{
            mainArrayForRecursionTags[indexPath.row].isSelected = !mainArrayForRecursionTags[indexPath.row].isSelected
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    @objc func onClickBtnSelectPromo(_ btn:UIButton) {
        
        let id:String = arrForPromoList[btn.tag].id
        if btn.isSelected
        {
            if let index = arrForFinalPromoList.index(of: id) {
                self.arrForFinalPromoList.remove(at: index)
            }
        }else {
            self.arrForFinalPromoList.append(id)
        }
        btn.isSelected = !btn.isSelected
        tblPromoFor.reloadData()
    }
}
extension PromoVC:UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtPromoStartDate {
            
            openDatePicker(isStartDate: true)
            return false
        }else if textField == txtPromoExpireDate {
            openDatePicker(isStartDate: false)
            return false
        }else if textField == txtStartTime {
            self.openTimePicker(isStartTime: true)
            return false
        }else if textField == txtEndTime {
            self.openTimePicker(isStartTime: false)
            return false
        }else {
            return true
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtPromoAmount || textField == txtMinPromoAmount || textField == txtMaxPromoAmount {
            
            let textFieldString = textField.text! as NSString;
            
            let newString = textFieldString.replacingCharacters(in: range, with:string)
            
            let floatRegEx = "^([0-9]+)?(\\.([0-9]+)?)?$"
            
            let floatExPredicate = NSPredicate(format:"SELF MATCHES %@", floatRegEx)
            
            return floatExPredicate.evaluate(with: newString)
        }
        return true
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtPromoCode {
            txtPromoDetail.becomeFirstResponder()
        }else if textField == txtPromoAmount {
            txtPromoStartDate.becomeFirstResponder()
        }else {
            textField.resignFirstResponder()
        }
        return true;
    }
}


class CheckListCell: CustomCell {
    
    //MARK:- OUTLET
    
    
    @IBOutlet weak var imgButtonType: UIButton!
    @IBOutlet weak var lblItemName: UILabel!
    
    //MARK:- LIFECYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor =  UIColor.themeViewBackgroundColor;
        self.backgroundColor = UIColor.themeViewBackgroundColor
        
        lblItemName.font = FontHelper.textRegular()
        lblItemName.textColor = UIColor.themeTextColor
        imgButtonType.setImage( UIImage.init(named: "checked")?.imageWithColor(color: .themeColor)
                                , for: UIControl.State.selected)
        
        imgButtonType.setImage( UIImage.init(named: "unchecked")
                                , for: UIControl.State.normal)
    }
    //MARK:- SET CELL DATA
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
struct TagList {
    var itemName:String = ""
    var isSelected:Bool = false
}
extension PromoVC:HTagViewDelegate,HTagViewDataSource {
    func numberOfTags(_ tagView: HTagView) -> Int {
        if tagView == tagViewForDays {
            return arrForSelectedDays.count
        }else if tagView == tagViewForWeeks {
            return arrForSelectedWeeks.count
        }else {
            return arrForSelectedMonths.count
        }
        
    }
    
    func tagView(_ tagView: HTagView, titleOfTagAtIndex index: Int) -> String {
        
        
        if tagView == tagViewForDays {
            return arrForSelectedDays[index]
        }else if tagView == tagViewForWeeks {
            return arrForSelectedWeeks[index]
        }else {
            return arrForSelectedMonths[index]
        }
    }
    
    func tagView(_ tagView: HTagView, tagTypeAtIndex index: Int) -> HTagType {
        return .cancel
    }
    
    func tagView(_ tagView: HTagView, tagWidthAtIndex index: Int) -> CGFloat {
        return .HTagAutoWidth
    }
    
    // MARK: - HTagViewDelegate
    
    func tagView(_ tagView: HTagView, tagSelectionDidChange selectedIndices: [Int]) {
        print("tag with indices \(selectedIndices) are selected")
        
    }
    func tagView(_ tagView: HTagView, didCancelTagAtIndex index: Int) {
        if tagView == tagViewForDays {
            arrForSelectedDays.remove(at: index)
        }
        if tagView == tagViewForWeeks {
            arrForSelectedWeeks.remove(at: index)
        }
        if tagView == tagViewForMonths {
            arrForSelectedMonths.remove(at: index)
        }
        reloadTagView(tagView)
    }
    
    func setUpTagView(_ tagView:HTagView) {
        tagView.delegate = self
        tagView.dataSource = self
        tagView.multiselect = false
        tagView.marg = 0
        tagView.btwTags = 2
        tagView.btwLines = 2
        tagView.tagFont = FontHelper.textRegular()
        tagView.tagBorderWidth = 1.0
        tagView.tagBorderColor = UIColor.black.cgColor
        
        tagView.tagMainBackColor = UIColor.themeColor
        tagView.tagMainTextColor = UIColor.themeButtonTitleColor
        
        tagView.tagSecondBackColor = UIColor.themeColor
        tagView.tagSecondTextColor = UIColor.themeButtonTitleColor
        
        
        
    }
}
class PromoItemCell: CustomCell {
    @IBOutlet weak var lblPromoItemName: UILabel!
    @IBOutlet weak var btnAvail: UIButton!
    
    //MARK:- LIFECYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        lblPromoItemName.font = FontHelper.textRegular()
        lblPromoItemName.textColor = UIColor.themeTextColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        self.backgroundColor = UIColor.themeViewBackgroundColor
    }
    //MARK:- SET CELL DATA
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
}

