//
//  SettingVC.swift
// Edelivery Store
//
//  Created by Jaydeep Vyas on 28/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class SettingVC: BaseVC,RightDelegate,LocationHandlerDelegate,UIPopoverPresentationControllerDelegate,UIGestureRecognizerDelegate {
    @IBOutlet weak var btnStoreSchedule: UIButton!
    @IBOutlet weak var stkAddress: UIStackView!
    
    @IBOutlet weak var btnSelectAddress: UIButton!
    
    @IBOutlet weak var btnFamousFor: UIButton!
    @IBOutlet weak var lblIsPayDeliveryFees: UILabel!
    @IBOutlet weak var btnLanguage: UIButton!
    @IBOutlet weak var btnstoreDeliveryTime: UIButton!
    
    @IBOutlet weak var scrSetting: UIScrollView!
    
    //MARK:- Outlets Declaration
    
    @IBOutlet weak var viewForPriceRate: UIView!
    @IBOutlet weak var lblPriceRate: UILabel!
    @IBOutlet weak var lblPriceRatePlaceHolder: UILabel!
    @IBOutlet weak var lblIsBussy: UILabel!
    @IBOutlet weak var swForIsBussy: UISwitch!
    
    @IBOutlet weak var lblProvideDelivery: UILabel!
    @IBOutlet weak var swProvideDelivery: UISwitch!
    
    @IBOutlet weak var lblProvidePickupDelivery: UILabel!
    
    @IBOutlet weak var swForProvidePickupDelivery: UISwitch!
    @IBOutlet weak var lblIsAskForEstTime: UILabel!
    
    @IBOutlet weak var btnPriceRate: UIButton!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtLatitude: UITextField!
    @IBOutlet weak var txtLongitude: UITextField!
    @IBOutlet weak var txtTaxOnOrderBill: UITextField!
    @IBOutlet weak var txtSlogan: UITextField!
    @IBOutlet weak var txtWebSite: UITextField!
    
    @IBOutlet weak var txtMaximumItemQuantityAddByUser: UITextField!
    @IBOutlet weak var txtMinimumOrderPrice: UITextField!
    @IBOutlet weak var lblIsBusiness: UILabel!
    
    
    @IBOutlet weak var btnCancellationChargeTypeEdit: UIButton!
    @IBOutlet weak var btnPriceRateEdit: UIButton!
    
    @IBOutlet weak var switchForIsBusiness: UISwitch!
    @IBOutlet weak var viewForDeliveryStoreTime: UIView!
    @IBOutlet weak var switchForDeliveryStoreTime: UISwitch!
    
    
    /*Free Delivery View*/
    @IBOutlet weak var viewForFreeDelivery: UIView!
    @IBOutlet weak var switchForIsStorePayDeliveryFees: UISwitch!
    @IBOutlet weak var txtFreeDeliveryAboveOrderPRice: UITextField!
    @IBOutlet weak var heightForFreeDeliveryView: NSLayoutConstraint!
    @IBOutlet weak var txtFreeDeliveryRadius: UITextField!
    
    /*View For Cancellation Charge*/
    
    @IBOutlet weak var switchForIsTakeCancellationCharge: UISwitch!
    @IBOutlet weak var viewForCancellationCharge: UIView!
    @IBOutlet weak var heightForCancellationChargeView: NSLayoutConstraint!
    @IBOutlet weak var viewCancellationChargeState: UIView!

    
    @IBOutlet weak var lblCancellationChargeType: UILabel!
    @IBOutlet weak var btnCancellationChargeType: UIButton!
    @IBOutlet weak var lblCancellationChargeTypeValue: UILabel!
    @IBOutlet weak var txtCancellationChargeAboveOrderPrice: UITextField!
    @IBOutlet weak var lblCancellationStateTitle: UILabel!
    @IBOutlet weak var lblCancellationStartState: UILabel!
    @IBOutlet weak var lblCancellationEndState: UILabel!

    @IBOutlet weak var viewCancellationStartState: UIView!
    @IBOutlet weak var viewCancellationEndState: UIView!

    @IBOutlet weak var btnCancellationStartState: UIButton!
    @IBOutlet weak var btnCancellationEndState: UIButton!

    @IBOutlet weak var btnDropdownCancellationStartState: UIButton!
    @IBOutlet weak var btnDropdownCancellationEndState: UIButton!

    
    @IBOutlet weak var txtOrderCancellationChargeValue: UITextField!
    @IBOutlet weak var viewCancellationChargeType: UIView!
    @IBOutlet weak var lblIsCancellationCharge: UILabel!
    
    /*Provide Delivery Anywhere*/
    
    @IBOutlet weak var viewForProvideDeliveryAnywhere: UIView!
    @IBOutlet weak var txtDeliveryRadius: UITextField!
    @IBOutlet weak var lblIsProvideDeliveryAnyWhere: UILabel!
    @IBOutlet weak var switchForIsProvideDeliveryAnywhere: UISwitch!
    @IBOutlet weak var heightForProvideDeliveryView: NSLayoutConstraint!
    
    /*Schedule Order*/
    @IBOutlet weak var viewForScheduleOrder: UIView!
    @IBOutlet weak var switchForIsTakeScheduleOrder: UISwitch!
    @IBOutlet weak var lblIsTakeScheduleOrder: UILabel!
    @IBOutlet weak var txtScheduleOrderCreateAfterMinute: UITextField!
    @IBOutlet weak var txtInformScheduleOrderBeforeMinute: UITextField!
    @IBOutlet weak var heightForScheduleOrderView: NSLayoutConstraint!
    @IBOutlet weak var txtDeliveryRate: UITextField!
    @IBOutlet weak var txtMaxDeliveryRata: UITextField!
    
    @IBOutlet weak var swIsAskForEstTime: UISwitch!
    
    @IBOutlet weak var viewForItemTax: UIView!
    @IBOutlet weak var lblItemTax: UILabel!
    @IBOutlet weak var lblStoreDeliveryTime: UILabel!
    
    @IBOutlet weak var switchForIsUseItemtax: UISwitch!
    @IBOutlet var collVTax: UICollectionView!
    @IBOutlet weak var collVHeight: NSLayoutConstraint!
    //   @IBOutlet weak var viewForTaxHeight: NSLayoutConstraint!
    @IBOutlet weak var lblIncludeExcludeTax: UILabel!
    @IBOutlet weak var switchForIncludeExcludeTax: UISwitch!
    @IBOutlet weak var viewFroTaxSetting: UIView!

    /*Variables*/
    var password:String = ""
    var selectedAddress:String = "";
    var latitude:Double = 0.0;
    var longitude:Double = 0.0;
    let arrForPrice = ["1","2","3","4"]
    let arrForCancellationChargeType = ["TXT_PERCENTAGE".localizedCapitalized,"TXT_ABSOLUTE".localizedCapitalized]
    var selectedCancelationChargeType = 1
    var arrSelectedIndex = [IndexPath]()
    var arrSelectedData = [String]()
    var selectedRow : Int = 0
    let arrForapplyCancelChargeState = [3 , 5 , 7 , 17 , 21]
    var selectedStartApplyCancelChargeState : Int = 5
    var selectedEndApplyCancelChargeState : Int = 7


    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        delegateRight = self
        setLocalization()
        
        enableTextFields(enable: false)
        self.setRightBarItem(isNative: false)
        self.hideBackButtonTitle()
        if preferenceHelper.getIsShowOptionalFieldInRegister() {
            self.txtSlogan.isHidden = false
            self.txtWebSite.isHidden = false
            
        }else {
            
            self.txtSlogan.isHidden = true
            self.txtWebSite.isHidden = true
        }
        txtLongitude.isHidden = true
        txtLatitude.isHidden = true
        
        txtScheduleOrderCreateAfterMinute.delegate = self
        txtInformScheduleOrderBeforeMinute.delegate = self
        
        self.collVTax.register(UINib(nibName: "EasyAmountCell", bundle: nil), forCellWithReuseIdentifier: "EasyAmountCell")

        wsGetUserInfo()

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gestureRecognizer:)))
        self.view.addGestureRecognizer(gestureRecognizer)
        gestureRecognizer.delegate = self

        
        //        arrEasyAmount.sort { (i, r) -> Bool in
        //            i.count < r.count
        //        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if btnStoreSchedule.isEnabled {
            //        self.setRightBarItemImage(image: UIImage.init(named: "doneBlackIcon")!)
            //            self.setRightBarItemImage(image: UIImage(), title: "TXT_SAVE".localized, mode: .center)
            //            self.setrightBarItemBG()
            self.setRightBarItemImage(image: UIImage(named: "correct")!.imageWithColor(color: .themeColor)!, title: "", mode: .center)
            
        }else {
            //        self.setRightBarItemImage(image: UIImage.init(named: "editBlackIcon")!)
            //            self.setRightBarItemImage(image: UIImage(), title: "TXT_EDIT".localized, mode: .center)
            //            self.setrightBarItemBG()
            let image = UIImage.init(named: "edit")!.imageWithColor(color: .themeColor)!
            self.setRightBarItemImage(image: image)
            
        }
        
    }
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews();
        
    }
    
    @objc func handleTap(gestureRecognizer: UIGestureRecognizer)
    {
        self.view.endEditing(true)
    }
    
    fileprivate func setupLayout() {
        viewForFreeDelivery.setShadow(shadowColor: UIColor.lightGray.cgColor, shadowOffset: CGSize.init(width: 0.0, height: 0.0), shadowOpacity: 0.5, shadowRadius: 2.0)
        viewForCancellationCharge.setShadow(shadowColor: UIColor.lightGray.cgColor, shadowOffset: CGSize.init(width: 0.0, height: 0.0), shadowOpacity: 0.5, shadowRadius: 2.0)
        viewForProvideDeliveryAnywhere.setShadow(shadowColor: UIColor.lightGray.cgColor, shadowOffset: CGSize.init(width: 0.0, height: 0.0), shadowOpacity: 0.5, shadowRadius: 2.0)
        viewForScheduleOrder.setShadow(shadowColor: UIColor.lightGray.cgColor, shadowOffset: CGSize.init(width: 0.0, height: 0.0), shadowOpacity: 0.5, shadowRadius: 2.0)
        
        self.collVTax.collectionViewLayout = LeftAlignedCollectionViewFlowLayout()
        self.collVTax.reloadData()
        self.collVHeight.constant = self.collVTax.contentSize.height;
        
        self.collVTax.layoutIfNeeded()
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
        dialogForCustomLanguage.arrUpdatedInd.removeAll()
        
    }
    
    func setLocalization() {
        
        
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(self.onClickBtnSelectAddress(_:)));
        stkAddress.addGestureRecognizer(tapGesture)
        /*set colors*/
        
        
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        
        self.viewForFreeDelivery.backgroundColor = UIColor.themeViewBackgroundColor
        self.viewForCancellationCharge.backgroundColor = UIColor.themeViewBackgroundColor
        self.viewForProvideDeliveryAnywhere.backgroundColor = UIColor.themeViewBackgroundColor
        self.viewForScheduleOrder.backgroundColor = UIColor.themeViewBackgroundColor
        
        txtAddress.textColor = UIColor.themeTextColor
        txtLatitude.textColor = UIColor.themeTextColor
        txtLongitude.textColor = UIColor.themeTextColor
        txtTaxOnOrderBill.textColor = UIColor.themeTextColor
        txtTaxOnOrderBill.keyboardType = .numberPad
        txtFreeDeliveryAboveOrderPRice.textColor = UIColor.themeTextColor
        txtFreeDeliveryRadius.textColor = UIColor.themeTextColor
        txtSlogan.textColor = UIColor.themeTextColor
        txtWebSite.textColor = UIColor.themeTextColor
        lblIsBusiness.textColor = UIColor.themeTextColor
        txtDeliveryRate.textColor = UIColor.themeTextColor
        txtMaxDeliveryRata.textColor = UIColor.themeTextColor
        
        txtCancellationChargeAboveOrderPrice.textColor = UIColor.themeTextColor
        
        lblCancellationStateTitle.textColor = UIColor.themeTextColor
        lblCancellationStartState.textColor = UIColor.themeTextColor
        lblCancellationEndState.textColor = UIColor.themeTextColor

        
        
        txtOrderCancellationChargeValue.textColor = UIColor.themeTextColor
        txtMaximumItemQuantityAddByUser.textColor = UIColor.themeTextColor
        txtMinimumOrderPrice.textColor = UIColor.themeTextColor
        txtScheduleOrderCreateAfterMinute.textColor = UIColor.themeTextColor
        txtInformScheduleOrderBeforeMinute.textColor = UIColor.themeTextColor
        txtDeliveryRadius.textColor = UIColor.themeTextColor
        
        lblIsCancellationCharge.textColor = UIColor.themeTextColor
        lblIsProvideDeliveryAnyWhere.textColor = UIColor.themeTextColor
        lblIsTakeScheduleOrder.textColor = UIColor.themeTextColor
        lblIsBusiness.textColor = UIColor.themeTextColor
        lblIsAskForEstTime.textColor = UIColor.themeTextColor
        lblProvidePickupDelivery.textColor = UIColor.themeTextColor
        lblItemTax.textColor = UIColor.themeTextColor
        lblStoreDeliveryTime.textColor = UIColor.themeTextColor
        lblProvideDelivery.textColor = UIColor.themeTextColor

        
        lblCancellationChargeTypeValue.textColor = UIColor.themeTextColor
        lblIsCancellationCharge.textColor = UIColor.themeTextColor
        
        lblPriceRatePlaceHolder.textColor = UIColor.themeLightTextColor
        lblCancellationChargeType.textColor = UIColor.themeLightTextColor
        lblIsBussy.textColor = UIColor.themeTextColor
        lblPriceRatePlaceHolder.text = "TXT_PRICE_RATING".localized + " (\(StoreSingleton.shared.store.currency))"
        
        lblIsPayDeliveryFees.textColor = UIColor.themeTextColor
        lblIncludeExcludeTax.textColor = UIColor.themeTextColor

        /*Set Text*/
        
        // btnstoreDeliveryTime.isEnabled = false
        viewForDeliveryStoreTime.isHidden = false
        
        let downArrow:String = "\u{25BC}"
        //        btnCancellationChargeTypeEdit.setTitle(downArrow, for: .normal)
        //        btnCancellationChargeTypeEdit.tintColor = .themeColor
        //        btnPriceRateEdit.setTitle(downArrow, for: .normal)

        
        txtAddress.placeholder = "TXT_ADDRESS".localizedCapitalized
        txtLatitude.placeholder = "TXT_LATITUDE".localizedCapitalized
        txtLongitude.placeholder = "TXT_LONGITUDE".localizedCapitalized
        txtTaxOnOrderBill.placeholder = "TXT_TAX_ON_ORDER_BILL".localizedCapitalized
        txtFreeDeliveryAboveOrderPRice.placeholder = "TXT_FREE_DELIVERY_ABOVE_ORDER_PRICE".localizedCapitalized
        txtFreeDeliveryRadius.placeholder = "TXT_FREE_DELIVERY_RADIUS".localizedCapitalized
        
        txtSlogan.placeholder = "TXT_SLOGAN".localizedCapitalized
        
        txtWebSite.placeholder = "TXT_WEBSITE".localizedCapitalized
        
        lblIsBusiness.text = "TXT_IS_BUSINESS".localizedCapitalized
        lblIsAskForEstTime.text = "TXT_IS_ESTIMATE_TIME".localizedCapitalized
        lblProvidePickupDelivery.text = "TXT_PROVIDE_PICKUP_DELIVERY".localizedCapitalized
        btnStoreSchedule.setTitle("   " + "TXT_MANAGE_STORE_TIME_SCHEDULE".localized, for: .normal)
        btnStoreSchedule.setTitleColor(UIColor.themeTextColor, for: .normal)
        lblItemTax.text = "TXT_IS_USE_ITEM_TAX".localizedCapitalized
        lblStoreDeliveryTime.text = "TXT_IS_SET_DELIVERY_STORE_TIME".localizedCapitalized
        
        btnFamousFor.setTitle("   " + "TXT_FAMOUS_FOR".localized, for: .normal)
        btnFamousFor.setTitleColor(UIColor.themeTextColor, for: .normal)
        
        btnLanguage.setTitle("   " + "TXT_SELECT_LANG".localized, for: .normal)
        //        ("   Select Language", for: .normal)
        btnLanguage.setTitleColor(UIColor.themeTextColor, for: .normal)
        
        btnstoreDeliveryTime.setTitle("   " + "TXT_IS_SET_DELIVERY_STORE_TIME".localized, for: .normal)
        btnstoreDeliveryTime.setTitleColor(UIColor.themeTextColor, for: .normal)
        
        txtDeliveryRate.placeholder = "TXT_DELIVERY_TIME".localizedCapitalized
        txtMaxDeliveryRata.placeholder = "TXT_MAX_DELIVERY_TIME".localizedCapitalized
        
        lblProvideDelivery.text = "txt_provider_delivery".localizedCapitalized
        
        txtCancellationChargeAboveOrderPrice.placeholder = "TXT_ORDER_CANCELLATION_CHARGE_ABOVE_ORDER_PRICE".localizedCapitalized
        txtOrderCancellationChargeValue.placeholder = "TXT_ORDER_CANCELLATION_CHARGE".localizedCapitalized
        
        txtMaximumItemQuantityAddByUser.placeholder = "TXT_MAX_ITEM_QUANTITY_ADD_BY_USER".localizedCapitalized
        txtMinimumOrderPrice.placeholder = "TXT_MINIMUM_ORDER_PRICE".localizedCapitalized
        txtScheduleOrderCreateAfterMinute.placeholder = "TXT_SCHEDULE_ORDER_CREATE_AFTER_MINUTE".localizedCapitalized
        txtInformScheduleOrderBeforeMinute.placeholder = "TXT_INFORM_SCHEDULE_ORDER_BEFORE_MINUTE".localizedCapitalized
        txtDeliveryRadius.placeholder = "TXT_DELIVERY_RADIUS".localizedCapitalized
        
        lblIsProvideDeliveryAnyWhere.text = "TXT_PROVIDE_DELIVERY_ANYWHERE".localizedCapitalized
        lblIsTakeScheduleOrder.text = "TXT_TAKING_SCHEDULE_ORDER".localizedCapitalized
        lblIsCancellationCharge.text = "TXT_TAKING_ORDER_CANCELLATION_CHARGE".localizedCapitalized
        lblCancellationChargeType.text = "TXT_ORDER_CANCELLATION_CHARGE_TYPE".localizedCapitalized
        lblIsPayDeliveryFees.text = "TXT_PAY_DELIVERY_FEES".localizedCapitalized
        lblIsBussy.text = "TXT_IS_STORE_BUSY".localizedCapitalized
        lblIncludeExcludeTax.text = "TXT_TAX_INC_EXC".localizedCapitalized
        
        /*Set Text*/
        self.setNavigationTitle(title: "TXT_SETTING".localized)
        /*Set Font*/
        txtAddress.font = FontHelper.textRegular()
        txtLatitude.font = FontHelper.textRegular()
        txtLongitude.font = FontHelper.textRegular()
        txtTaxOnOrderBill.font = FontHelper.textRegular()
        txtFreeDeliveryAboveOrderPRice.font = FontHelper.textRegular()
        txtFreeDeliveryRadius.font = FontHelper.textRegular()
        txtSlogan.font = FontHelper.textRegular()
        txtWebSite.font = FontHelper.textRegular()
        lblIsBusiness.font = FontHelper.textRegular()
        btnStoreSchedule.titleLabel?.font =  FontHelper.textRegular()
        btnFamousFor.titleLabel?.font = FontHelper.textRegular()
        btnLanguage.titleLabel?.font = FontHelper.textRegular()
        btnstoreDeliveryTime.titleLabel?.font = FontHelper.textRegular()
        lblIncludeExcludeTax.font = FontHelper.textRegular()

        lblCancellationStateTitle.font =  FontHelper.textRegular()
        lblCancellationStartState.font =  FontHelper.textRegular()
        lblCancellationEndState.font =  FontHelper.textRegular()
        lblProvideDelivery.font =  FontHelper.textRegular()

        txtCancellationChargeAboveOrderPrice.font =  FontHelper.textRegular()
        txtOrderCancellationChargeValue.font =  FontHelper.textRegular()
        txtMaximumItemQuantityAddByUser.font =  FontHelper.textRegular()
        txtMinimumOrderPrice.font =  FontHelper.textRegular()
        txtScheduleOrderCreateAfterMinute.font =  FontHelper.textRegular()
        txtInformScheduleOrderBeforeMinute.font =  FontHelper.textRegular()
        txtDeliveryRate.font =  FontHelper.textRegular()
        txtDeliveryRate.font =  FontHelper.textRegular()
        txtDeliveryRadius.font =  FontHelper.textRegular()
        lblIsCancellationCharge.font = FontHelper.textRegular()
        lblItemTax.font =  FontHelper.textRegular()
        lblStoreDeliveryTime.font =  FontHelper.textRegular()

        
        lblIsProvideDeliveryAnyWhere.font =  FontHelper.textRegular()
        lblIsTakeScheduleOrder.font =  FontHelper.textRegular()
        lblIsBusiness.font =  FontHelper.textRegular()
        lblCancellationChargeTypeValue.font =  FontHelper.textRegular()
        lblCancellationChargeType.font = FontHelper.textSmall()
        
        lblPriceRatePlaceHolder.font = FontHelper.textSmall()
        lblIsBussy.font = FontHelper.textRegular()
        lblIsPayDeliveryFees.font = FontHelper.textRegular()
        lblIsAskForEstTime.font = FontHelper.textRegular()
        lblProvidePickupDelivery.font = FontHelper.textRegular()
        
        txtAddress.isUserInteractionEnabled = false
        txtLongitude.isUserInteractionEnabled = false
        txtLatitude.isUserInteractionEnabled = false
        
        swForIsBussy.onTintColor = .themeColor
        swForProvidePickupDelivery.onTintColor = .themeColor
        swIsAskForEstTime.onTintColor = .themeColor
        switchForIsBusiness.onTintColor = .themeColor
        switchForIsUseItemtax.onTintColor = .themeColor
        switchForDeliveryStoreTime.onTintColor = .themeColor
        switchForIsTakeScheduleOrder.onTintColor = .themeColor
        switchForIsTakeCancellationCharge.onTintColor = .themeColor
        switchForIsProvideDeliveryAnywhere.onTintColor = .themeColor
        switchForIsStorePayDeliveryFees.onTintColor = .themeColor
        switchForIncludeExcludeTax.onTintColor = .themeColor
        swProvideDelivery.onTintColor = .themeColor
        updateUIAccordingToTheme()
    }
    
    override func updateUIAccordingToTheme() {
        btnstoreDeliveryTime.setImage(UIImage(named: "delivery_time")?.imageWithColor(color: .themeColor), for: .normal)
        btnLanguage.setImage(UIImage(named: "language")?.imageWithColor(color: .themeColor), for: .normal)
        btnStoreSchedule.setImage(UIImage(named: "store_time")?.imageWithColor(color: .themeColor), for: .normal)
        btnSelectAddress.setImage(UIImage(named: "location_arrow"), for: .normal)
        btnFamousFor.setImage(UIImage(named: "famousFor")?.imageWithColor(color: .themeColor), for: .normal)
        btnPriceRateEdit.setImage(UIImage(named: "dropdown")?.imageWithColor(color: .themeIconTintColor), for: .normal)
        btnCancellationChargeTypeEdit.setImage(UIImage(named: "dropdown")?.imageWithColor(color: .themeIconTintColor), for: .normal)
        btnDropdownCancellationEndState.setImage(UIImage(named: "dropdown")?.imageWithColor(color: .themeIconTintColor), for: .normal)
        btnDropdownCancellationStartState.setImage(UIImage(named: "dropdown")?.imageWithColor(color: .themeIconTintColor), for: .normal)

    }
    
    //MARK:- Action Methods
    
    func onClickRightButton() {
        editProfile()
        //        self.setRightBarItemImage(image: UIImage.init(named: "doneBlackIcon")!)
        //        self.setRightBarItemImage(image: UIImage(), title: "TXT_SAVE".localized, mode: .center)
        //        self.setrightBarItemBG()
        self.setRightBarItemImage(image: UIImage(named: "correct")!.imageWithColor(color: .themeColor)!, title: "", mode: .center)
    }
    
    //MARK:- User Define Methods
    func checkValidation() -> Bool {
        self.view.endEditing(true)
        if ((txtAddress.text?.count)!     < 1 ||
                (txtLatitude.text?.count)!      < 1 ||
                (txtLongitude.text?.count)!  < 1) {
            if ((txtAddress.text?.count)! <  1) {
                txtAddress.becomeFirstResponder();
                
                Utility.showToast(message:"MSG_PLEASE_ENTER_ADDRESS".localized)
            }
            else if ((txtLatitude.text?.trimmingCharacters(in: .whitespaces).count)! < 1) {
                txtAddress.becomeFirstResponder();
                
                Utility.showToast(message:"MSG_PLEASE_ENTER_ADDRESS".localized)
                
            }
            else if ((txtLongitude.text?.trimmingCharacters(in: .whitespaces).count)! < 1)
            {
                txtAddress.becomeFirstResponder();
                
                Utility.showToast(message:"MSG_PLEASE_ENTER_ADDRESS".localized)
                
            }else {
                Utility.showToast(message:"MSG_SOMETHING_MISSED".localized)
            }
            return false;
            
        }else if (!checkValidNumber(isValidationRequired: !switchForIsProvideDeliveryAnywhere.isOn, textValue: txtDeliveryRadius.text!)) {
            Utility.showToast(message: "TXT_ENTER_VALID_RADIUS".localized)
            return false
        }else if (!switchForIsProvideDeliveryAnywhere.isOn && (txtDeliveryRadius.text?.doubleValue) ?? 0.0  <= 0.0) {
            Utility.showToast(message: "TXT_ENTER_VALID_RADIUS".localized)
            return false
        }else if !switchForIsProvideDeliveryAnywhere.isOn && (txtDeliveryRadius.text?.doubleValue ?? 0.0) > Double(StoreSingleton.shared.store.cityDetails?.city_radius ?? 0) {
            Utility.showToast(message: "TXT_DELIVERY_RADIUS_MORE_THEN_CITY".localized)
            return false
        }else if (switchForIsStorePayDeliveryFees.isOn && (txtFreeDeliveryRadius.text?.doubleValue) ?? 0.0  <= 0.0) {
            Utility.showToast(message: "TXT_ENTER_VALID_FREE_RADIUS".localized)
            return false
        }else if switchForIsStorePayDeliveryFees.isOn && (txtFreeDeliveryRadius.text?.doubleValue ?? 0.0) > Double(StoreSingleton.shared.store.cityDetails?.city_radius ?? 0) {
            Utility.showToast(message: "TXT_DELIVERY_RADIUS_MORE_THEN_CITY".localized)
            return false
        }else if (!checkValidNumber(isValidationRequired: switchForIsTakeScheduleOrder.isOn, textValue: txtScheduleOrderCreateAfterMinute.text!)) {
            Utility.showToast(message: "TXT_ENTER_VALID_TIME".localized)
            return false
        }else if (!checkValidNumber(isValidationRequired: switchForIsTakeScheduleOrder.isOn, textValue: txtInformScheduleOrderBeforeMinute.text!)) {
            Utility.showToast(message: "TXT_ENTER_VALID_TIME".localized)
            return false
        }else if (!checkValidNumber(isValidationRequired: true, textValue: txtDeliveryRate.text!)) {
            Utility.showToast(message: "TXT_ENTER_VALID_DELIVERY_TIME".localized)
            return false
        }else if (!checkValidNumber(isValidationRequired: true, textValue: txtMaxDeliveryRata.text!)) {
            Utility.showToast(message: "TXT_ENTER_VALID_MAX_DELIVERY_TIME".localized)
            return false
        }else if ((txtMaxDeliveryRata.text?.integerValue) ?? 0 <= (txtDeliveryRate.text?.integerValue) ?? 0) {
            Utility.showToast(message: "TXT_ENTER_VALID_MAX_DELIVERY_TIME".localized)
            return false
        }else if ((lblCancellationStartState.text?.count) == 0 || (lblCancellationEndState.text?.count) == 0) {
            Utility.showToast(message: "Please select cancellation charge apply states")
            return false
        }
        else if (!swForProvidePickupDelivery.isOn && !switchForIsProvideDeliveryAnywhere.isOn && (txtDeliveryRadius.text?.doubleValue) ?? 0.0 <= 0.0) {
            Utility.showToast(message: "TOAST_MSG_YOU_ARE_NOT_PROVIDE_ANY_DELIVERY".localized)
            return false
        }
        return true
    }
    func checkValidNumber(isValidationRequired:Bool,textValue:String = "") -> Bool {
        if isValidationRequired {
            if !textValue.isEmpty() && textValue.isValidAmount() {
                return true
            }else if textValue.isEmpty() {
                return false
            }else {
                return false
            }
        }
        
        return true;
    }
    
    func enableTextFields(enable:Bool) -> Void {
        btnSelectAddress.isEnabled = enable
        stkAddress.isUserInteractionEnabled = enable
        txtAddress.isEnabled = enable
        txtLatitude.isEnabled = enable
        txtLongitude.isEnabled = enable
        txtTaxOnOrderBill.isEnabled = enable
        txtFreeDeliveryAboveOrderPRice.isEnabled = enable
        txtFreeDeliveryRadius.isEnabled = enable
        txtSlogan.isEnabled = enable
        txtWebSite.isEnabled = enable
        txtCancellationChargeAboveOrderPrice.isEnabled = enable
        btnCancellationEndState.isEnabled = enable
        btnCancellationStartState.isEnabled = enable
        

        txtOrderCancellationChargeValue.isEnabled = enable
        txtMaximumItemQuantityAddByUser.isEnabled = enable
        txtMinimumOrderPrice.isEnabled = enable
        txtScheduleOrderCreateAfterMinute.isEnabled = enable
        txtInformScheduleOrderBeforeMinute.isEnabled = enable
        txtDeliveryRadius.isEnabled = enable
        
        switchForIsBusiness.isEnabled = enable
        swIsAskForEstTime.isEnabled = enable
        switchForIsUseItemtax.isEnabled = enable
        switchForIsStorePayDeliveryFees.isEnabled = enable
        switchForIsTakeCancellationCharge.isEnabled = enable
        switchForIsProvideDeliveryAnywhere.isEnabled = enable
        switchForIsTakeScheduleOrder.isEnabled = enable
        swForIsBussy.isEnabled = enable
        btnPriceRate.isEnabled = enable
        swForProvidePickupDelivery.isEnabled = enable
        swProvideDelivery.isEnabled = enable
        btnCancellationChargeType.isEnabled = enable
        btnStoreSchedule.isEnabled = enable
        btnFamousFor.isEnabled = enable
        btnLanguage.isEnabled = enable
        switchForDeliveryStoreTime.isEnabled = enable
        //btnstoreDeliveryTime.isEnabled = enable
        txtDeliveryRate.isEnabled = enable
        txtMaxDeliveryRata.isEnabled = enable
        switchForIncludeExcludeTax.isEnabled = enable
        
        btnCancellationChargeTypeEdit.isEnabled = enable
        btnDropdownCancellationStartState.isEnabled = enable
        btnDropdownCancellationEndState.isEnabled = enable

        if switchForIsUseItemtax.isEnabled{
            self.collVTax.isUserInteractionEnabled = !switchForIsUseItemtax.isOn
        }else{
            self.collVTax.isUserInteractionEnabled = false
        }

    }
    func setSettingData() {
        let storeData:Store = StoreSingleton.shared.store;
        
        if selectedAddress.isEmpty() {
            txtAddress.text = (storeData.address);
            txtLatitude.text = String(storeData.location[0]);
            txtLongitude.text = String(storeData.location[1]);
            
        }else {
            self.txtAddress.text = selectedAddress
            self.txtLatitude.text = String(latitude)
            self.txtLongitude.text = String(longitude)
        }
        
        if storeData.isStoreCanSetCancellationCharge {
            viewForCancellationCharge.isHidden = false
            self.heightForCancellationChargeView.constant = 110
            self.lblCancellationStateTitle.text = "TXT_CANCELLATION_CHARGE_APPLY_TILL_STATES".localized
        }else {
            viewForCancellationCharge.isHidden = true
            self.heightForCancellationChargeView.constant = 0
            self.lblCancellationStateTitle.text = "TXT_CANCELLATION_CHARGE_APPLY_TILL_STATES".localized
        }
        
        txtTaxOnOrderBill.text = String(storeData.itemTax)
        txtFreeDeliveryAboveOrderPRice.text = String(storeData.freeDeliveryForAboveOrderPrice)
        txtFreeDeliveryRadius.text = String(storeData.freeDeliveryRadius)
        txtSlogan.text = storeData.slogan
        txtWebSite.text = storeData.websiteUrl
        
        lblPriceRate.text = String(storeData.priceRating)
        txtDeliveryRate.text = String(storeData.deliveryTime)
        txtMaxDeliveryRata.text = String(storeData.deliveryTimeMax)
        
        txtCancellationChargeAboveOrderPrice.text = String(storeData.orderCancellationChargeForAboveOrderPrice)
        txtOrderCancellationChargeValue.text = String(storeData.orderCancellationChargeValue)
        txtMaximumItemQuantityAddByUser.text = String(storeData.maxItemQuantityAddByUser)
        txtMinimumOrderPrice.text = String(storeData.minOrderPrice)
        txtScheduleOrderCreateAfterMinute.text = String(storeData.scheduleOrderCreateAfterMinute)
        txtInformScheduleOrderBeforeMinute.text = String(storeData.informScheduleOrderBeforeMin)
        txtDeliveryRadius.text = String(storeData.deliveryRadius)
        
        switchForIsBusiness.isOn = storeData.isBusiness
        swIsAskForEstTime.isOn = storeData.isAskEstimatedTimeForReadyOrder
        switchForIsStorePayDeliveryFees.isOn = storeData.isStorePayDeliveryFees
        switchForDeliveryStoreTime.isOn = storeData.isStoreSetScheduleDeliveryTime
        
        switchForIsTakeCancellationCharge.isOn = storeData.isOrderCancellationChargeApply
        switchForIsProvideDeliveryAnywhere.isOn = storeData.isProvideDeliveryAnywhere
        switchForIsTakeScheduleOrder.isOn = storeData.isTakingScheduleOrder
        
        switchForIsUseItemtax.isOn = storeData.isUseItemTax
        switchForIncludeExcludeTax.isOn = storeData.isTaxInlcuded

        swForIsBussy.isOn = storeData.isBussy
        swForProvidePickupDelivery.isOn = storeData.isProvidePickupDelivery
        swProvideDelivery.isOn = storeData.is_provide_delivery
        
        selectedCancelationChargeType = storeData.orderCancellationChargeType
        
        if storeData.orderCancellationChargeType == 1 {
            self.lblCancellationChargeTypeValue.text =
                arrForCancellationChargeType[0]
            
        }else {
            self.lblCancellationChargeTypeValue.text = arrForCancellationChargeType[1]
        }
        if storeData.cancellation_charge_apply_from > 0{
            selectedStartApplyCancelChargeState = storeData.cancellation_charge_apply_from
        }
        if storeData.cancellation_charge_apply_till > 0{
            selectedEndApplyCancelChargeState = storeData.cancellation_charge_apply_till
        }
        self.lblCancellationStartState.text = CancellationStates(rawValue: selectedStartApplyCancelChargeState)!.text()
        self.lblCancellationEndState.text = CancellationStates(rawValue: selectedEndApplyCancelChargeState)!.text()

        onSwitchValueChanged(switchForIsProvideDeliveryAnywhere)
        onSwitchValueChanged(switchForIsTakeCancellationCharge)
        onSwitchValueChanged(switchForIsStorePayDeliveryFees)
        onSwitchValueChanged(switchForIsTakeScheduleOrder)
        onSwitchValueChanged(switchForDeliveryStoreTime)
        onSwitchValueChanged(switchForIsUseItemtax)

    }
    func editProfile() -> Void{
        
        if (!txtAddress.isEnabled) {
            enableTextFields(enable: true)
            
        }else {
            if (checkValidation()) {
                if !preferenceHelper.getSocialId().isEmpty()
                {
                    self.password = ""
                    self.wsUpdateProfile();
                }
                else
                {
                    self.openVerifyAccountDialog();
                }
            }
            
        }
        
        self.setDeliveryStoreTimeVisiblity(isSwitchon: switchForDeliveryStoreTime.isOn)
    }
    
    func setDeliveryStoreTimeVisiblity(isSwitchon:Bool){
        if (txtAddress.isEnabled){
            btnstoreDeliveryTime.isEnabled =  isSwitchon
        }else{
            btnstoreDeliveryTime.isEnabled = false
        }
    }
    
    //MARK:_ Dialog Methods
    //MARK:- Web Service Calls
    func wsUpdateProfile() {
        
        Utility.showLoading()

        let store:Store = Store.init(fromDictionary: [:])
        store.address = txtAddress.text ?? ""
        store.location = [txtLatitude.text!.doubleValue ?? 0.0,txtLongitude.text!.doubleValue ?? 0.0]
        //Changed
        //        store.itemTax = txtTaxOnOrderBill.text!.doubleValue ?? 0.0
        store.websiteUrl = txtWebSite.text ?? ""
        store.slogan = txtSlogan.text ?? ""
        store.freeDeliveryForAboveOrderPrice = (txtFreeDeliveryAboveOrderPRice.text ?? "0.0").doubleValue ?? 0.0
        
        store.isBusiness = switchForIsBusiness.isOn
        store.freeDeliveryRadius = txtFreeDeliveryRadius.text!.doubleValue ?? 0.0
        store.isStorePayDeliveryFees = switchForIsStorePayDeliveryFees.isOn
        store.priceRating = (lblPriceRate.text!.integerValue ?? 0)
        store.deliveryTime = (txtDeliveryRate.text!.integerValue ?? 0)
        store.deliveryTimeMax = (txtMaxDeliveryRata.text!.integerValue ?? 0)
        store.deviceType = CONSTANT.IOS
        store.isAskEstimatedTimeForReadyOrder = swIsAskForEstTime.isOn
        store.minOrderPrice = ((self.txtMinimumOrderPrice.text ?? "").doubleValue ??
                                0.0)
        store.informScheduleOrderBeforeMin = (self.txtInformScheduleOrderBeforeMinute.text ?? "0").integerValue ?? 0
        
        store.deviceToken = preferenceHelper.getDeviceToken()
        store.isTakingScheduleOrder = switchForIsTakeScheduleOrder.isOn
        store.deliveryRadius = (txtDeliveryRadius.text ?? "").doubleValue ?? 0.0
        store.isProvideDeliveryAnywhere = switchForIsProvideDeliveryAnywhere.isOn
        store.scheduleOrderCreateAfterMinute = (txtScheduleOrderCreateAfterMinute.text ?? "0").integerValue ?? 0
        //Janki
        //        store.famousProductsTags = StoreSingleton.shared.store.famousProductsTags
        store.famousProductsTagsToUpdate = StoreSingleton.shared.store.famousProductsTags
        store.isStoreSetScheduleDeliveryTime = switchForDeliveryStoreTime.isOn
        
        
        store.maxItemQuantityAddByUser = (txtMaximumItemQuantityAddByUser.text ?? "0").integerValue ?? 0
        store.orderCancellationChargeValue = (txtOrderCancellationChargeValue.text ?? "0").doubleValue ?? 0.0
        store.orderCancellationChargeType = selectedCancelationChargeType
        store.orderCancellationChargeForAboveOrderPrice = (txtCancellationChargeAboveOrderPrice.text ?? "").doubleValue ?? 0.0
        
        store.isUseItemTax = switchForIsUseItemtax.isOn
        store.isBussy = swForIsBussy.isOn
        store.isOrderCancellationChargeApply = switchForIsTakeCancellationCharge.isOn
        
        store.isProvidePickupDelivery = swForProvidePickupDelivery.isOn
        store.is_provide_delivery = swProvideDelivery.isOn
        store.name = StoreSingleton.shared.store.name
        store.nameLanguages = StoreSingleton.shared.store.nameLanguages
        store.countryDetails = StoreSingleton.shared.store.countryDetails
        
        let defaultSelectedArray = StoreSingleton.shared.store.taxesDetails.filter() {($0 as TaxesDetail).isTaxSelected}
        if StoreSingleton.shared.store.taxes != nil{
            StoreSingleton.shared.store.taxes.removeAll()
        }
            for obj in defaultSelectedArray{
                StoreSingleton.shared.store.taxes.append(obj.id)
            }
        
        if StoreSingleton.shared.store.taxes != nil{
            store.taxes = StoreSingleton.shared.store.taxes
        }
        store.isTaxInlcuded = switchForIncludeExcludeTax.isOn
        
        store.cancellation_charge_apply_from = selectedStartApplyCancelChargeState
        store.cancellation_charge_apply_till = selectedEndApplyCancelChargeState

        var dictParam : [String : Any] = store.toDictionary()
        
        dictParam[PARAMS.OLD_PASSWORD] = password
        dictParam[PARAMS.NEW_PASSWORD] = ""
        dictParam[PARAMS.SOCIAL_ID] = preferenceHelper.getSocialId()
        dictParam[PARAMS.SERVER_TOKEN] = preferenceHelper.getSessionToken()
        dictParam[PARAMS.STORE_ID] = preferenceHelper.getUserId()

        
        print(Utility.conteverDictToJson(dict: dictParam))
        var arrStorelang = [[String : Any]]()
        if ConstantsLang.storeLanguages.count > 0{
            for i in 0...ConstantsLang.storeLanguages.count-1{
                let dic : [String : Any] = ["is_visible" :ConstantsLang.storeLanguages[i].is_visible!
                                            ,"name" :ConstantsLang.storeLanguages[i].name!
                                            ,"code" :ConstantsLang.storeLanguages[i].code!
                                            ,"string_file_path" :ConstantsLang.storeLanguages[i].string_file_path!]
                arrStorelang.append(dic)
            }
        }
        dictParam["languages_supported"] = arrStorelang
        
        print("arrStorelang \(arrStorelang)")
        
        let alamoFire:AlamofireHelper = AlamofireHelper();
        
        alamoFire.getResponseFromURL(url: WebService.WS_UPDATE_STORE, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            print("WS_UPDATE_STORE response : \(response)")
            Parser.parseUserStorageData(response: response, completion: { result in
                if result{
                    Utility.hideLoading()
                    StoreSingleton.shared.clearCart()
                    _ = self.navigationController?.popViewController(animated: true);
                }
            })
        }
    }
    
    func openVerifyAccountDialog() {
        let dialogForVerification = CustomVerificationDialog.showCustomVerificationDialog(title: "TXT_VERIFY_ACCOUNT".localized, message: "MSG_PLEASE_ENTER_CURRENT_PASSWORD".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_OK".localized, editTextOneHint: "TXT_PASSWORD".localized, editTextTwoHint: "", isEdiTextTwoIsHidden: true, editTextOneInputType: true)
        dialogForVerification.onClickLeftButton = {
            [unowned dialogForVerification, unowned self] in
            dialogForVerification.removeFromSuperview();
        }
        dialogForVerification.onClickRightButton = {[unowned dialogForVerification, unowned self] (text1:String,text2:String) in
            let validPassword = text1.checkPasswordValidation()
            if validPassword.0 == false {
                Utility.showToast(message: validPassword.1);
            }
            else {
                
                self.password = text1
                self.wsUpdateProfile();
                dialogForVerification.removeFromSuperview();
            }
        }
        
    }
    
    func wsGetUserInfo() {
        Utility.showLoading()
        let currentAppVersion: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)
        
        let afh:AlamofireHelper = AlamofireHelper.init()
        
        let dictParam : [String : Any] =
            [ PARAMS.STORE_ID: preferenceHelper.getUserId(),
              PARAMS.SERVER_TOKEN: preferenceHelper.getSessionToken(),
              PARAMS.APP_VERSION: currentAppVersion,
              PARAMS.DEVICE_TOKEN: preferenceHelper.getDeviceToken()
            ]
        
        print(Utility.conteverDictToJson(dict: dictParam))
        afh.getResponseFromURL(url: WebService.WS_GET_STORE_DATA, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            print(Utility.conteverDictToJson(dict: response))
            Utility.hideLoading()
            if Parser.isSuccess(response: response) {
                if let storeData = response["store_detail"] as? [String:Any]{
                    StoreSingleton.shared.store = Store(fromDictionary: storeData)
                    if StoreSingleton.shared.store.taxes != nil{
                    for i in StoreSingleton.shared.store.taxes{
                        for j in StoreSingleton.shared.store.taxesDetails{
                            if j.id == i{
                                j.isTaxSelected = true
                            }
                        }
                    }
                    }
                }
                
                self.setSettingData()
            }
        }
    }
    
    
    func openCancellationChargeStartStatePicker() {
        let actionSheetController = UIAlertController(title: "TXT_SELECT_APPLY_CANCELLATION_CHARGE_START_STATE".localized, message: "OPTION_TO_SELECT".localized, preferredStyle:.actionSheet)
        
        let cancelAction = UIAlertAction.init(title: "TXT_CANCEL".localized, style: .cancel) { action -> Void in
        }
        actionSheetController.addAction(cancelAction)
        
        for i in 0...arrForapplyCancelChargeState.count-1{
            let state:CancellationStates = CancellationStates(rawValue: arrForapplyCancelChargeState[i])!

            let oneActionButton = UIAlertAction(title: state.text() , style: .default, handler: { (alert: UIAlertAction!) -> Void in
                
                self.lblCancellationStartState.text = alert.title!
                self.selectedStartApplyCancelChargeState = state.toInt(str: alert.title!)
                
                self.lblCancellationEndState.text = ""
            })
            actionSheetController.addAction(oneActionButton)
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popoverController = actionSheetController.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
                self.present(actionSheetController, animated: true, completion: nil)
            }
        }else{
            self.present(actionSheetController, animated: true, completion: nil)
        }
    }
    
    func openCancellationChargeEndStatePicker() {
        
        let actionSheetController = UIAlertController(title: "TXT_SELECT_APPLY_CANCELLATION_CHARGE_END_STATE".localized, message: "OPTION_TO_SELECT".localized, preferredStyle:.actionSheet)
        
        let cancelAction = UIAlertAction.init(title: "TXT_CANCEL".localized, style: .cancel) { action -> Void in
        }
        actionSheetController.addAction(cancelAction)
        var arrTemp = [Int]()
        if self.switchForIsTakeCancellationCharge.isOn{
            for i in 0...arrForapplyCancelChargeState.count-1{
                if i > self.arrForapplyCancelChargeState.index(of: selectedStartApplyCancelChargeState) ?? 0{
                    arrTemp.append(arrForapplyCancelChargeState[i])
                }
            }
        }else{
            for i in 0...arrForapplyCancelChargeState.count-1{
                arrTemp.append(arrForapplyCancelChargeState[i])
            }
        }
        
        for obj in arrTemp{
            let state:CancellationStates = CancellationStates(rawValue: obj)!

            let oneActionButton = UIAlertAction(title: state.text() , style: .default, handler: { (alert: UIAlertAction!) -> Void in

                self.selectedEndApplyCancelChargeState = state.toInt(str: alert.title!)
                self.lblCancellationEndState.text = alert.title!
            })
            actionSheetController.addAction(oneActionButton)
        }
        //Issue resolved : Added Actionsheet support for IPAD
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popoverController = actionSheetController.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
                self.present(actionSheetController, animated: true, completion: nil)
            }
        }else{
            self.present(actionSheetController, animated: true, completion: nil)
        }
    }
    
    func showPricePicker() {
        let actionSheetController = UIAlertController(title: "TITLE_PLEASE_SELECT_PRICE_RATE".localized, message: "OPTION_TO_SELECT".localized, preferredStyle:.actionSheet)
        
        let cancelAction = UIAlertAction.init(title: "TXT_CANCEL".localized, style: .cancel) { action -> Void in
            
        }
        actionSheetController.addAction(cancelAction)
        
        let oneActionButton = UIAlertAction(title: arrForPrice[0], style: .default) { action -> Void in
            self.lblPriceRate.text = self.arrForPrice[0]
        }
        actionSheetController.addAction(oneActionButton)
        
        let twoActionButton = UIAlertAction(title: arrForPrice[1], style: .default) { action -> Void in
            self.lblPriceRate.text = self.arrForPrice[1]
        }
        
        actionSheetController.addAction(twoActionButton)
        
        let threeActionButton = UIAlertAction(title: arrForPrice[2], style: .default) { action -> Void in
            self.lblPriceRate.text = self.arrForPrice[2]
        }
        actionSheetController.addAction(threeActionButton)
        
        let fourActionButton = UIAlertAction(title: arrForPrice[3], style: .default) { action -> Void in
            self.lblPriceRate.text = self.arrForPrice[3]
        }
        
        actionSheetController.addAction(fourActionButton)
        
        //Issue resolved : Added Actionsheet support for IPAD
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popoverController = actionSheetController.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
                self.present(actionSheetController, animated: true, completion: nil)
                
            }
        }else{
            self.present(actionSheetController, animated: true, completion: nil)
        }
        
    }
    
    func showCancellationChargeTypePicker() {
        let actionSheetController = UIAlertController(title: "TITLE_PLEASE_SELECT_CANCELATION_TYPE".localized, message: "OPTION_TO_SELECT".localized, preferredStyle: .actionSheet)
        
        let percentageActionButton = UIAlertAction(title: arrForCancellationChargeType[0], style: .default) { action -> Void in
            self.selectedCancelationChargeType = 1
            self.lblCancellationChargeTypeValue.text = self.arrForCancellationChargeType[0]
        }
        actionSheetController.addAction(percentageActionButton)
        
        let absoluteActionButton = UIAlertAction(title: arrForCancellationChargeType[1], style: .default) { action -> Void in
            self.selectedCancelationChargeType = 2
            self.lblCancellationChargeTypeValue.text = self.arrForCancellationChargeType[1]
        }
        actionSheetController.addAction(absoluteActionButton)
        self.present(actionSheetController, animated: true, completion: nil)
    }

    @IBAction func onClickBtnStoreSchedule(_ sender: Any) {
        //        self.performSegue(withIdentifier: SEGUE.STORE_SCHEDULE, sender: self)
        let storyBoard:UIStoryboard = UIStoryboard.init(name: "Setting", bundle: nil)
        let vc : StoreTimeVC = storyBoard.instantiateViewController(withIdentifier: "StoreTimeVC") as! StoreTimeVC
        vc.isFromStoreDeliveryTime = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onClickBtnStoreDeliveryTime(_ sender: Any) {
        //        self.performSegue(withIdentifier: SEGUE.STORE_SCHEDULE, sender: self)
        let storyBoard:UIStoryboard = UIStoryboard.init(name: "Setting", bundle: nil)
        let vc : StoreTimeVC = storyBoard.instantiateViewController(withIdentifier: "StoreTimeVC") as! StoreTimeVC
        vc.isFromStoreDeliveryTime = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onClickBtnFamousFor(_ sender: Any) {
        self.performSegue(withIdentifier: SEGUE.FAMOUS_FOR, sender: self)
    }
    
    @IBAction func onClickBtnLanguage(_ sender: Any) {
        self.view.endEditing(true)
        let dialogForLanguage:dialogForCustomLanguage = dialogForCustomLanguage.showCustomLanguageDialogSetting()
        dialogForLanguage.onItemSelected = {
            (selectedItem:Int) in
            //                    super.changed(selectedItem)
        }
        dialogForLanguage.onClickLeftButton = {
            dialogForLanguage.removeFromSuperview()
        }
    }
    
    
    fileprivate func isHideFreeDeliveryView(_ sender: UISwitch) {
        txtFreeDeliveryAboveOrderPRice.isHidden = !sender.isOn
        txtFreeDeliveryRadius.isHidden = !sender.isOn
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.0) {
            if self.txtFreeDeliveryAboveOrderPRice.isHidden {
                self.heightForFreeDeliveryView.constant = 40
            }else {
                self.heightForFreeDeliveryView.constant = 140
                
            }
            self.view.layoutIfNeeded()
        }
    }
    fileprivate func idHideCancelView(_ sender: UISwitch) {
        txtCancellationChargeAboveOrderPrice.isHidden = !sender.isOn
        txtOrderCancellationChargeValue.isHidden = !sender.isOn
        viewCancellationChargeType.isHidden = !sender.isOn
        //        lblCancellationStateTitle.isHidden = !sender.isOn
        lblCancellationStartState.isHidden = !sender.isOn
        //        lblCancellationEndState.isHidden = !sender.isOn
        viewCancellationStartState.isHidden = !sender.isOn
        //        viewCancellationEndState.isHidden = !sender.isOn
        btnCancellationStartState.isHidden = !sender.isOn
        //        btnCancellationEndState.isHidden = !sender.isOn
        //        viewCancellationChargeState.isHidden = !sender.isOn
        //        btnDropdownCancellationEndState.isHidden = !sender.isOn
        btnDropdownCancellationStartState.isHidden = !sender.isOn

        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.0) {
            if self.txtCancellationChargeAboveOrderPrice.isHidden {
                self.heightForCancellationChargeView.constant = 110
                if self.viewForCancellationCharge.isHidden {
                    self.heightForCancellationChargeView.constant = 0
                }
            }else {
                self.heightForCancellationChargeView.constant = 250
            }
            
            if self.switchForIsTakeCancellationCharge.isOn{
                self.lblCancellationStateTitle.text = "TXT_CANCELLATION_CHARGE_APPLY_TILL_STATES".localized
                self.selectedStartApplyCancelChargeState = 5
            }else{
                self.lblCancellationStateTitle.text = "Cancellation apply till state :"
                self.selectedStartApplyCancelChargeState = 0
            }

            self.view.layoutIfNeeded()
        }
    }
    
    fileprivate func idHideProvideAnywhereView(_ sender: UISwitch) {
        txtDeliveryRadius.isHidden = sender.isOn
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.0) {
            if self.txtDeliveryRadius.isHidden {
                self.heightForProvideDeliveryView.constant = 40
            }else {
                self.heightForProvideDeliveryView.constant = 90
            }
            self.view.layoutIfNeeded()
        }
    }
    fileprivate func idHideScheduleOrderView(_ sender: UISwitch) {
        txtScheduleOrderCreateAfterMinute.isHidden = !sender.isOn
        txtInformScheduleOrderBeforeMinute.isHidden = true
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.1) {
            if self.txtScheduleOrderCreateAfterMinute.isHidden {
                self.heightForScheduleOrderView.constant = 40
            }else {
                self.heightForScheduleOrderView.constant = 100
            }
            self.view.layoutIfNeeded()
        }
        
    }
    
    fileprivate func idHideDeliveryStoreTimeView(_ sender: UISwitch) {
        self.setDeliveryStoreTimeVisiblity(isSwitchon: sender.isOn)
        
        
        /*view.layoutIfNeeded()
         UIView.animate(withDuration: 0.0) {
         if self.txtScheduleOrderCreateAfterMinute.isHidden {
         self.heightForScheduleOrderView.constant = 60
         }else {
         self.heightForScheduleOrderView.constant = 150
         }
         self.view.layoutIfNeeded()
         }*/
        
    }
    
    @IBAction func onSwitchValueChanged(_ sender: UISwitch) {
        if sender == switchForIsStorePayDeliveryFees {
            isHideFreeDeliveryView(sender)
        }
        if sender == switchForIsTakeCancellationCharge {
            idHideCancelView(sender)
        }
        if sender == switchForIsProvideDeliveryAnywhere {
            idHideProvideAnywhereView(sender)
        }
        if sender == switchForIsTakeScheduleOrder {
            idHideScheduleOrderView(sender)
            
        }
        if sender == switchForDeliveryStoreTime {
            idHideDeliveryStoreTimeView(sender)
        }
        
        if sender == switchForIsUseItemtax {
            if switchForIsUseItemtax.isEnabled{
                self.collVTax.isUserInteractionEnabled = !switchForIsUseItemtax.isOn
            }else{
                self.collVTax.isUserInteractionEnabled = false
            }
        }
        
        if sender == swForProvidePickupDelivery {
            if !swProvideDelivery.isOn {
                swProvideDelivery.isOn = true
            }
        }
        
        if sender == swProvideDelivery {
            if !swForProvidePickupDelivery.isOn {
                swForProvidePickupDelivery.isOn = true
            }
        }
    }
    
    
    @IBAction func onClickShowPricePicker(_ sender: UIButton) {
        if self.btnPriceRate.isEnabled{
            self.showPricePicker()
        }
    }
    
    @IBAction func onClickShowCancellationChargePicker(_ sender: UIButton) {
        self.showCancellationChargeTypePicker()
    }
    
    @IBAction func onClickBtnSelectAddress(_ sender: UIButton) {
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "Prelogin", bundle: nil)
        
        let locationVC : StoreLocationVC = mainView.instantiateViewController(withIdentifier: "storeLocationVC") as! StoreLocationVC
        
        let navigationViewController: UINavigationController = UINavigationController(rootViewController: locationVC)
        locationVC.delegate = self
        locationVC.comingFrom = SourceVC.REGISTER_VC
        self.navigationController?.pushViewController(locationVC, animated: true)
        
    }
    
    func finalAddressAndLocation(address: String, latitude: Double, longitude: Double) {
        self.selectedAddress = address;
        self.latitude = latitude;
        self.longitude = longitude;
        
        self.txtAddress.text = address
        self.txtLatitude.text = String(latitude)
        self.txtLongitude.text = String(longitude)
    }
    
    @IBAction func onClickSelectCancelStartState(_ sender: Any) {
        openCancellationChargeStartStatePicker()
    }
    
    @IBAction func onClickSelectCancelEndState(_ sender: Any) {
        openCancellationChargeEndStatePicker()
    }
    
    @IBAction func onClickTimePicker(_ sender: Any) {
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}

extension SettingVC:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtScheduleOrderCreateAfterMinute || textField == txtInformScheduleOrderBeforeMinute {
            if string == "" {
                return true
            }
            let textstring = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let length = textstring.count
            if length > 4 {
                return false
            }
        }
        return true
    }
}

extension UIScrollView {
    
    // Scroll to a specific view so that it's top is at the top our scrollview
    func scrollToView(view:UIView, animated: Bool) {
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(CGPoint.init(x: 15, y: view.frame.origin.y), to: self)
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            var contentOffset = self.contentOffset
            contentOffset.y = childStartPoint.y
            self.contentOffset = contentOffset
        }
    }
    
    // Bonus: Scroll to top
    func scrollToTop(animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }
    
    // Bonus: Scroll to bottom
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if(bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: true)
        }
    }
    
}
class PopOverViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SettingVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if StoreSingleton.shared.store.countryDetails != nil{
            return StoreSingleton.shared.store.taxesDetails.count
        }else{
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:EasyAmountCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EasyAmountCell", for: indexPath) as! EasyAmountCell
        cell.lblAmount.text =  " \(StoreSingleton.shared.returnStringAccordingtoLanguage(arrStr: StoreSingleton.shared.store.taxesDetails[indexPath.row].taxName)) \(StoreSingleton.shared.store.taxesDetails[indexPath.row].tax!)% "
        //        cell.contentView.transform = CGAffineTransform(scaleX: -1, y: 1)
        DispatchQueue.main.async {
            if StoreSingleton.shared.store.taxesDetails[indexPath.item].isTaxSelected{
                cell.lblAmount.textColor = UIColor.white
                cell.lblAmount.backgroundColor = UIColor.themeColor
            }else{
                cell.lblAmount.textColor = UIColor.themeLightTextColor
                cell.lblAmount.backgroundColor = .clear
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        StoreSingleton.shared.store.taxesDetails[indexPath.item].isTaxSelected = !StoreSingleton.shared.store.taxesDetails[indexPath.item].isTaxSelected
        DispatchQueue.main.async {
            self.collVTax.reloadData()
            self.collVHeight.constant = self.collVTax.contentSize.height;
            self.collVTax.layoutIfNeeded()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        return CGSize.init(width: String(" \(StoreSingleton.shared.returnStringAccordingtoLanguage(arrStr: StoreSingleton.shared.store.taxesDetails[indexPath.row].taxName)) \(StoreSingleton.shared.store.taxesDetails[indexPath.row].tax!)% ").size(withAttributes: nil).width + 20, height: 35)
        return CGSize.init(width: String(" \(StoreSingleton.shared.returnStringAccordingtoLanguage(arrStr: StoreSingleton.shared.store.taxesDetails[indexPath.row].taxName)) \(StoreSingleton.shared.store.taxesDetails[indexPath.row].tax!)% ").width(withConstrainedHeight: 35, font: FontHelper.textRegular(size: 13))+20, height: 35)
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if ((touch.view?.isDescendant(of: self.collVTax)) != nil) {
            self.view.endEditing(true)
            return false
        } else {
            return true
        }
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}


class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width//minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }
        return attributes
    }
}
