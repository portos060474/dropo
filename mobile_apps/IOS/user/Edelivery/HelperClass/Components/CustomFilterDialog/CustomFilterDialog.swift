//
//  CustomFilterDialog.swift
//  Edelivery
//
//  Created by Elluminati on 3/3/21.
//  Copyright © 2021 Elluminati. All rights reserved.
//

import UIKit

class CustomFilterDialog: CustomDialog, UITextFieldDelegate, HTagViewDelegate,HTagViewDataSource,keyboardWasShownDelegate,keyboardWillBeHiddenDelegate {
   
    //MARK:- OUTLETS
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var btnResetFilter: UIButton!
    @IBOutlet weak var btnApplyFilter: UIButton!
    
    /*Price Rate*/
    @IBOutlet weak var stkPriceFilter: UIStackView!
    @IBOutlet weak var viewPriceFilter: UIView!
    @IBOutlet weak var lblPriceFilter: UILabel!
    @IBOutlet weak var btnPriceRate1: UIButton!
    @IBOutlet weak var btnPriceRate2: UIButton!
    @IBOutlet weak var btnPriceRate3: UIButton!
    @IBOutlet weak var btnPriceRate4: UIButton!
    
    /*TimeRate*/
    @IBOutlet weak var viewDeliveryTimeFilter: UIView!
    @IBOutlet weak var lblDeliveryTimeFilter: UILabel!
    @IBOutlet weak var btnTimeRate1: UIButton!
    @IBOutlet weak var btnTimeRate2: UIButton!
    @IBOutlet weak var btnTimeRate3: UIButton!
    
    /*Distance Rate */
    @IBOutlet weak var viewDistaceRateFilter: UIView!
    @IBOutlet weak var lblDistanceFilter: UILabel!
    @IBOutlet weak var btnDistanceRate1: UIButton!
    @IBOutlet weak var btnDistanceRate2: UIButton!
    @IBOutlet weak var btnDistanceRate3: UIButton!
    
    /* Delivery radius */
    @IBOutlet weak var viewDeliveryRadiusFilter: UIView!
    @IBOutlet weak var lblDeliveryRadiusFilter: UILabel!
    @IBOutlet weak var btnDeliveryRadiousAll: UIButton!
    @IBOutlet weak var btnDeliveryRadiousAnywhere: UIButton!
    @IBOutlet weak var btnDeliveryRadiousMyLocation: UIButton!
    @IBOutlet weak var lblTags: UILabel!
    @IBOutlet weak var storeTagView: HTagView!
    @IBOutlet weak var scrollForTags: UIScrollView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblSearchBy: UILabel!
    @IBOutlet weak var txtSearchItem: UITextField!
    @IBOutlet weak var viewSearchBy: UIView!
    @IBOutlet weak var bottomAnchorView: NSLayoutConstraint!

    var filteredArrStoreList:Array<StoreItem>? = nil
    var originalArrStoreList:Array<StoreItem>? = nil
    var currentDeliveryItem:DeliveriesItem?
    var arrForSelectedTags:[String] = []
    var activeField: UITextField?
    
    //MARK:Variables
    var onClickRightButton : (() -> Void)? = nil
    var onClickClearButton : (() -> Void)? = nil
    var onClickLeftButton : ((_ filteredArray:Array<StoreItem>?) -> Void)? = nil
    var isFilterApply:Bool = false
    var arrForPriceRate:[Int] = []
    var storeTimeRate = Int.max, storeDistanceRate=Int.max
    var filterSingleton: SelectedFilterOptions = SelectedFilterOptions.shared
    
    static let  filterDialog = "CustomFilterDialog"
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public static func showCustomFilterDialog
        (title:String,
         message:String,
         titleLeftButton:String,
         titleRightButton:String,
         editTextOneHint:String,
         editTextTwoHint:String,
         isEdiTextTwoIsHidden:Bool,
         isEdiTextOneIsHidden:Bool = false,
         editTextOneInputType:Bool = false,
         editTextTwoInputType:Bool = false,
         isFromResndCode:Bool = false,
         selectedDeliveryItem: DeliveriesItem,
         originalStoreList:Array<StoreItem>?
         ) ->
        CustomFilterDialog
     {
        let view = UINib(nibName: filterDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomFilterDialog
        
        let frame = (APPDELEGATE.window?.frame)!
        view.frame = frame
        view.currentDeliveryItem = selectedDeliveryItem
        view.originalArrStoreList = originalStoreList
        view.btnApplyFilter.setTitle(titleLeftButton, for: .normal)
        view.btnResetFilter.setTitle(titleRightButton, for: .normal)
        view.lblTitle.text = title
        view.filteredArrStoreList = []
        view.deregisterFromKeyboardNotifications()
        view.registerForKeyboardNotifications()

        DispatchQueue.main.async {
            APPDELEGATE.window?.addSubview(view)
            APPDELEGATE.window?.bringSubviewToFront(view)
            view.animationBottomTOTop(view.filterView)
        }
        view.setLocalization()
        return view
    }
    
    func setLocalization(){
        self.backgroundColor = UIColor.themeOverlayColor
        btnApplyFilter.setBackgroundColor(color: UIColor.themeButtonBackgroundColor, forState: .normal)
        btnResetFilter.setBackgroundColor(color: UIColor.themeButtonBackgroundColor, forState: .normal)
        btnApplyFilter.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnResetFilter.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        lblTitle.textColor = UIColor.themeTextColor
        lblTitle.font = FontHelper.textMedium(size: FontHelper.large)
        lblSearchBy.textColor = UIColor.themeTitleColor
        lblSearchBy.font = FontHelper.textRegular(size: FontHelper.small)
        lblSearchBy.text = "TXT_SEARCH_BY".localized
        txtSearchItem.textColor = UIColor.themeTitleColor
        txtSearchItem.placeholder = "TXT_SEARCH_BY_ITEM".localized
        txtSearchItem.font = FontHelper.textRegular(size: FontHelper.small)
        lblPriceFilter.textColor = UIColor.themeTitleColor
        lblPriceFilter.font = FontHelper.textRegular(size: FontHelper.small)
        lblPriceFilter.text = "TXT_PRICE".localizedCapitalized
        lblDeliveryTimeFilter.textColor = UIColor.themeTitleColor
        lblDeliveryTimeFilter.font = FontHelper.textRegular(size: FontHelper.small)
        lblDeliveryTimeFilter.text = "TXT_DELIVERY_TIME".localizedCapitalized
        lblDistanceFilter.textColor = UIColor.themeTitleColor
        lblDistanceFilter.font = FontHelper.textRegular(size: FontHelper.small)
        lblDistanceFilter.text = "TXT_DISTANCE".localizedCapitalized
        lblDeliveryRadiusFilter.textColor = UIColor.themeTitleColor
        lblDeliveryRadiusFilter.font = FontHelper.textRegular(size: FontHelper.small)
        lblDeliveryRadiusFilter.text = "TXT_PROVIDE_DELIVEY_IN_CITY".localizedCapitalized
        btnDeliveryRadiousMyLocation.setTitle("TXT_AT_MY_LOCATION".localizedCapitalized, for: .normal)
        btnDeliveryRadiousAll.setTitle("TXT_ALL".localizedCapitalized, for: .normal)
        btnDeliveryRadiousAnywhere.setTitle("TXT_ANYWHERE".localizedCapitalized, for: .normal)
        btnTimeRate1.setTitleColor(UIColor.white, for: .selected)
        btnTimeRate2.setTitleColor(UIColor.white, for: .selected)
        btnTimeRate3.setTitleColor(UIColor.white, for: .selected)
        btnTimeRate1.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnTimeRate2.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnTimeRate3.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnTimeRate1.setBackgroundColor(color: UIColor.themeButtonBackgroundColor, forState: .selected)
        btnTimeRate2.setBackgroundColor(color: UIColor.themeButtonBackgroundColor, forState: .selected)
        btnTimeRate3.setBackgroundColor(color: UIColor.themeButtonBackgroundColor, forState: .selected)
        btnTimeRate1.setBackgroundColor(color: UIColor.themeViewBackgroundColor  , forState: .normal)
        btnTimeRate2.setBackgroundColor(color: UIColor.themeViewBackgroundColor  , forState: .normal)
        btnTimeRate3.setBackgroundColor(color: UIColor.themeViewBackgroundColor  , forState: .normal)
        btnDistanceRate1.setTitleColor(UIColor.white, for: .selected)
        btnDistanceRate2.setTitleColor(UIColor.white, for: .selected)
        btnDistanceRate3.setTitleColor(UIColor.white, for: .selected)
        btnDistanceRate1.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnDistanceRate2.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnDistanceRate3.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnDistanceRate1.setBackgroundColor(color: UIColor.themeButtonBackgroundColor, forState: .selected)
        btnDistanceRate2.setBackgroundColor(color: UIColor.themeButtonBackgroundColor, forState: .selected)
        btnDistanceRate3.setBackgroundColor(color: UIColor.themeButtonBackgroundColor, forState: .selected)
        btnDistanceRate1.setBackgroundColor(color: UIColor.themeViewBackgroundColor  , forState: .normal)
        btnDistanceRate2.setBackgroundColor(color: UIColor.themeViewBackgroundColor  , forState: .normal)
        btnDistanceRate3.setBackgroundColor(color: UIColor.themeViewBackgroundColor, forState: .normal)
        btnDeliveryRadiousAll.setTitleColor(UIColor.white, for: .selected)
        btnDeliveryRadiousMyLocation.setTitleColor(UIColor.white, for: .selected)
        btnDeliveryRadiousAnywhere.setTitleColor(UIColor.white, for: .selected)
        btnDeliveryRadiousAll.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnDeliveryRadiousMyLocation.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnDeliveryRadiousAnywhere.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnDeliveryRadiousAll.setBackgroundColor(color: UIColor.themeButtonBackgroundColor, forState: .selected)
        btnDeliveryRadiousAnywhere.setBackgroundColor(color: UIColor.themeButtonBackgroundColor, forState: .selected)
        btnDeliveryRadiousMyLocation.setBackgroundColor(color: UIColor.themeButtonBackgroundColor, forState: .selected)
        btnDeliveryRadiousAll.setBackgroundColor(color: UIColor.themeViewBackgroundColor, forState: .normal)
        btnDeliveryRadiousAnywhere.setBackgroundColor(color: UIColor.themeViewBackgroundColor  , forState: .normal)
        btnDeliveryRadiousMyLocation.setBackgroundColor(color:UIColor.themeViewBackgroundColor,forState:.normal)
        lblTags.font = FontHelper.textRegular(size: FontHelper.small)
        lblTags.text = "TXT_TAGS".localizedCapitalized
        lblTags.textColor = UIColor.themeTextColor
        btnClose.setImage(UIImage(named: "cancelIcon")?.imageWithColor(color: .themeColor), for: .normal)
        filterView.backgroundColor = UIColor.themeViewBackgroundColor
        setUpTagView()
        setUpOptions()
        txtSearchItem.tintColor = .themeTextColor
        filterView.roundCorner(corners: [.topLeft, .topRight], withRadius: 20.0)
    }
    func setUpTagView() {
        storeTagView.delegate = self
        storeTagView.dataSource = self
        storeTagView.multiselect = true
        storeTagView.marg = 0
        storeTagView.btwTags = 2
        storeTagView.btwLines = 2
        storeTagView.tagFont = FontHelper.textSmall()
        storeTagView.tagBorderWidth = 1.0
        storeTagView.tagBorderColor = UIColor.themeLightTextColor.cgColor
        storeTagView.tagMainBackColor = UIColor.themeButtonBackgroundColor
        storeTagView.tagMainTextColor = UIColor.themeButtonTitleColor
        storeTagView.tagSecondBackColor = UIColor.themeViewBackgroundColor
        storeTagView.tagSecondTextColor = UIColor.themeTextColor
        scrollForTags.contentSize = storeTagView.bounds.size
        storeTagView.tagCornerRadiusToHeightRatio =  0.47
        
    }
    func setUpOptions()  {
        if filterSingleton.deliveryTime != -1 {
            storeTimeRate =  filterSingleton.deliveryTime
              switch storeTimeRate {
                  case TimeRate.TIME_RATE_1:
                      storeTimeRate = TimeRate.TIME_RATE_1
                      btnTimeRate1.isSelected = true
                      break
                  case TimeRate.TIME_RATE_2:
                      storeTimeRate = TimeRate.TIME_RATE_2
                      btnTimeRate2.isSelected = true
                      break
                  case TimeRate.TIME_RATE_3:
                      storeTimeRate = TimeRate.TIME_RATE_3
                      btnTimeRate3.isSelected = true
                      break
                      
              default:
                break
            }
        }
        if filterSingleton.distanceValue != -1 {
            storeDistanceRate = filterSingleton.distanceValue
            switch storeDistanceRate {
            case  5:
                btnDistanceRate1.isSelected = true
                break
            case  15:
                  btnDistanceRate2.isSelected = true
                break
            case  25:
                btnDistanceRate3.isSelected = true
               break
            
            default:
                break
            }
        }
        if filterSingleton.arrForPriceRate.count > 0 {
            for val in filterSingleton.arrForPriceRate {
                arrForPriceRate.append(val)
                switch val {
                case 4:
                    btnPriceRate4.isSelected = true
                    break
                    
                case 3:
                    btnPriceRate3.isSelected = true
                    break
                    
                case 2:
                    btnPriceRate2.isSelected = true
                    break
                    
                case 1:
                    btnPriceRate1.isSelected = true
                    break
                    
                default:
                    break
                }
            }
        }
    }
    func resetFilterButtons() {
        btnDeliveryRadiousAll.isSelected = false
        btnDeliveryRadiousMyLocation.isSelected = false
        btnDeliveryRadiousAnywhere.isSelected = false
        btnDistanceRate1.isSelected = false
        btnDistanceRate2.isSelected = false
        btnDistanceRate3.isSelected = false
        btnTimeRate1.isSelected = false
        btnTimeRate2.isSelected = false
        btnTimeRate3.isSelected = false
        btnPriceRate1.isSelected = false
        btnPriceRate2.isSelected = false
        btnPriceRate3.isSelected = false
        btnPriceRate4.isSelected = false
        arrForPriceRate.removeAll()
        storeTimeRate = Int.max
        storeDistanceRate = Int.max
        storeTagView.resetAllButtons()
        storeTagView.reloadData()
        arrForSelectedTags.removeAll()
        filterSingleton.clear()
    }
    func applyFilter() {
            
            filteredArrStoreList?.removeAll()
            
            if !btnTimeRate1.isSelected && !btnTimeRate2.isSelected && !btnTimeRate3.isSelected {
                storeTimeRate = Int.max
            }
            if !btnDistanceRate1.isSelected && !btnDistanceRate2.isSelected && !btnDistanceRate3.isSelected {
                storeDistanceRate = Int.max
            }
            if !btnDeliveryRadiousAll.isSelected && !btnDeliveryRadiousAnywhere.isSelected && !btnDeliveryRadiousMyLocation.isSelected {
                btnDeliveryRadiousAll.isSelected = true
            }
            
            
            for storesItem:StoreItem in originalArrStoreList ?? [] {
                
                if storesItem.deliveryTime <= storeTimeRate && storesItem.distanceFromMyLocation <= storeDistanceRate {
                    
                    if (arrForPriceRate.count > 0 ) {
                        if arrForPriceRate.contains(storesItem.price_rating ?? 0)
                        {
                            if btnDeliveryRadiousAnywhere.isSelected && storesItem.isProvideDelivryAnywhere
                            {
                                self.filteredArrStoreList?.append(storesItem)
                            }
                            else if btnDeliveryRadiousMyLocation.isSelected
                            {
                                if storesItem.isProvideDelivryAnywhere
                                {
                                    self.filteredArrStoreList?.append(storesItem)
                                }
                                else if storesItem.delivryRadious >= Double(storesItem.distanceFromMyLocation)
                                {
                                    self.filteredArrStoreList?.append(storesItem)
                                }
                            }
                            else
                            {
                                self.filteredArrStoreList?.append(storesItem)
                            }
                        }
                    }else {
                        if btnDeliveryRadiousAnywhere.isSelected && storesItem.isProvideDelivryAnywhere
                        {
                            self.filteredArrStoreList?.append(storesItem)
                        }
                        else if btnDeliveryRadiousMyLocation.isSelected
                        {
                            if storesItem.isProvideDelivryAnywhere
                            {
                                self.filteredArrStoreList?.append(storesItem)
                            }
                            else if storesItem.delivryRadious >= Double(storesItem.distanceFromMyLocation)
                            {
                                self.filteredArrStoreList?.append(storesItem)
                            }
                        }
                        else if btnDeliveryRadiousAll.isSelected
                        {
                            self.filteredArrStoreList?.append(storesItem)
                        }
                    }
                }
            }
            
            if arrForSelectedTags.count > 0 {
                let newList =   filteredArrStoreList?.filter({ (storeItem) -> Bool in
                    for tag in arrForSelectedTags {
                        print("---\(storeItem.famousProductsTags)")
                        for obj in storeItem.famousProductsTags {
                            return  obj.tag == tag
                        }
                    }
                    return false
                })
                searching(txtSearchItem.text ?? "")
            }else {
                searching(txtSearchItem.text ?? "")
            }
            
        txtSearchItem.text = ""
        filterSingleton.clear()
        
        for val in arrForPriceRate {
            filterSingleton.arrForPriceRate.append(val)
        }
        for val in arrForSelectedTags {
            filterSingleton.arrForSelectedTags.append(val)
        }
        filterSingleton.deliveryTime = storeTimeRate
        filterSingleton.distanceValue = storeDistanceRate
        
        }
        override func layoutSubviews() {
            self.btnPriceRate1.applyRoundedCornersWithHeight()
            self.btnPriceRate2.applyRoundedCornersWithHeight()
            self.btnPriceRate3.applyRoundedCornersWithHeight()
            self.btnPriceRate4.applyRoundedCornersWithHeight()
            self.btnTimeRate1.applyRoundedCornersWithHeight()
            self.btnTimeRate2.applyRoundedCornersWithHeight()
            self.btnTimeRate3.applyRoundedCornersWithHeight()
            self.btnDistanceRate1.applyRoundedCornersWithHeight()
            self.btnDistanceRate2.applyRoundedCornersWithHeight()
            self.btnDistanceRate3.applyRoundedCornersWithHeight()
            self.btnDeliveryRadiousAll.applyRoundedCornersWithHeight()
            self.btnDeliveryRadiousAnywhere.applyRoundedCornersWithHeight()
            self.btnDeliveryRadiousMyLocation.applyRoundedCornersWithHeight()
            self.setUpRoundedBordersToContainer(viewContainer: self.viewPriceFilter)
            self.setUpRoundedBordersToContainer(viewContainer: self.viewDeliveryTimeFilter)
            self.setUpRoundedBordersToContainer(viewContainer: self.viewDistaceRateFilter)
            self.setUpRoundedBordersToContainer(viewContainer: self.viewDeliveryRadiusFilter)
            self.viewSearchBy.setRound(withBorderColor: UIColor.themeLightTextColor, andCornerRadious: 5.0, borderWidth: 0.5)

        btnPriceRate4.setTitle(currentBooking.currency + currentBooking.currency + currentBooking.currency + currentBooking.currency  , for: .normal)
        btnPriceRate3.setTitle(currentBooking.currency + currentBooking.currency + currentBooking.currency, for: .normal)
        btnPriceRate2.setTitle(currentBooking.currency + currentBooking.currency , for: .normal)
        btnPriceRate1.setTitle(currentBooking.currency, for: .normal)
        btnPriceRate1.setTitleColor(UIColor.white, for: .selected)
        btnPriceRate2.setTitleColor(UIColor.white, for: .selected)
        btnPriceRate3.setTitleColor(UIColor.white, for: .selected)
        btnPriceRate4.setTitleColor(UIColor.white, for: .selected)
        btnPriceRate1.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnPriceRate2.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnPriceRate3.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnPriceRate4.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnPriceRate1.setBackgroundColor(color: UIColor.themeButtonBackgroundColor, forState: .selected)
        btnPriceRate2.setBackgroundColor(color: UIColor.themeButtonBackgroundColor, forState: .selected)
        btnPriceRate3.setBackgroundColor(color: UIColor.themeButtonBackgroundColor, forState: .selected)
        btnPriceRate4.setBackgroundColor(color: UIColor.themeButtonBackgroundColor, forState: .selected)
        btnPriceRate1.setBackgroundColor(color: UIColor.themeViewBackgroundColor  , forState: .normal)
        btnPriceRate2.setBackgroundColor(color: UIColor.themeViewBackgroundColor  , forState: .normal)
        btnPriceRate3.setBackgroundColor(color: UIColor.themeViewBackgroundColor  , forState: .normal)
        btnPriceRate4.setBackgroundColor(color: UIColor.themeViewBackgroundColor  , forState: .normal)
        storeTagView.tagCornerRadiusToHeightRatio =  0.47
    }
    override func updateUIAccordingToTheme() {
        btnTimeRate1.setBackgroundColor(color: UIColor.themeButtonBackgroundColor, forState: .selected)
        btnTimeRate2.setBackgroundColor(color: UIColor.themeButtonBackgroundColor, forState: .selected)
        btnTimeRate3.setBackgroundColor(color: UIColor.themeButtonBackgroundColor, forState: .selected)
        btnTimeRate1.setBackgroundColor(color: UIColor.themeViewBackgroundColor  , forState: .normal)
        btnTimeRate2.setBackgroundColor(color: UIColor.themeViewBackgroundColor  , forState: .normal)
        btnTimeRate3.setBackgroundColor(color: UIColor.themeViewBackgroundColor  , forState: .normal)
        btnDistanceRate1.setBackgroundColor(color: UIColor.themeButtonBackgroundColor, forState: .selected)
        btnDistanceRate2.setBackgroundColor(color: UIColor.themeButtonBackgroundColor, forState: .selected)
        btnDistanceRate3.setBackgroundColor(color: UIColor.themeButtonBackgroundColor, forState: .selected)
        btnDistanceRate1.setBackgroundColor(color: UIColor.themeViewBackgroundColor  , forState: .normal)
        btnDistanceRate2.setBackgroundColor(color: UIColor.themeViewBackgroundColor  , forState: .normal)
        btnDistanceRate3.setBackgroundColor(color: UIColor.themeViewBackgroundColor, forState: .normal)
        btnDeliveryRadiousAll.setBackgroundColor(color: UIColor.themeButtonBackgroundColor, forState: .selected)
        btnDeliveryRadiousAnywhere.setBackgroundColor(color: UIColor.themeButtonBackgroundColor, forState: .selected)
        btnDeliveryRadiousMyLocation.setBackgroundColor(color: UIColor.themeButtonBackgroundColor, forState: .selected)
        btnDeliveryRadiousAll.setBackgroundColor(color: UIColor.themeViewBackgroundColor, forState: .normal)
        btnDeliveryRadiousAnywhere.setBackgroundColor(color: UIColor.themeViewBackgroundColor  , forState: .normal)
        btnDeliveryRadiousMyLocation.setBackgroundColor(color:UIColor.themeViewBackgroundColor,forState:.normal)
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    //ActionMethods
    @IBAction func onClickBtnLeft(_ sender: Any) {
        applyFilter()
    }
    @IBAction func onClickBtnRight(_ sender: Any) {
        
    }
    @IBAction func onClickBtnClose(_ sender: Any) {
        self.animationForHideView(filterView) {
            self.removeFromSuperview();
        }
    }
    deinit {
        deregisterFromKeyboardNotifications()
    }
    @IBAction func onClickBtnPriceTag(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            sender.backgroundColor = UIColor.themeViewBackgroundColor
            
        }else {
            sender.isSelected = true
            sender.backgroundColor = UIColor.themeButtonBackgroundColor
        }
        
        if let index = arrForPriceRate.index(of: sender.tag) {
            arrForPriceRate.remove(at: index)
        }else {
            arrForPriceRate.append(sender.tag)
        }
    }
    @IBAction func onClickBtnTimeTag(_ sender: UIButton) {
        
        btnTimeRate1.backgroundColor = UIColor.themeViewBackgroundColor
        btnTimeRate2.backgroundColor = UIColor.themeViewBackgroundColor
        btnTimeRate3.backgroundColor = UIColor.themeViewBackgroundColor
        btnTimeRate1.isSelected = false
        btnTimeRate2.isSelected = false
        btnTimeRate3.isSelected = false
        sender.backgroundColor = UIColor.themeButtonBackgroundColor
        sender.isSelected = true
        switch sender.tag {
        case 0:
            storeTimeRate = TimeRate.TIME_RATE_1
            break
        case 1:
            storeTimeRate = TimeRate.TIME_RATE_2
            break
        case 2:
            storeTimeRate = TimeRate.TIME_RATE_3
            break
        default:
            storeTimeRate = TimeRate.TIME_RATE_3
        }
        
    }
    @IBAction func onClickBtnDistanceTag(_ sender: UIButton) {
        btnDistanceRate1.backgroundColor = UIColor.themeViewBackgroundColor
        btnDistanceRate2.backgroundColor = UIColor.themeViewBackgroundColor
        btnDistanceRate3.backgroundColor = UIColor.themeViewBackgroundColor
        btnDistanceRate1.isSelected = false
        btnDistanceRate2.isSelected = false
        btnDistanceRate3.isSelected = false
        
        sender.backgroundColor = UIColor.themeButtonBackgroundColor
        sender.isSelected = true
        
        switch sender.tag {
        case 0:
            storeDistanceRate = 5
            break
        case 1:
            storeDistanceRate = 15
            break
        case 2:
            storeDistanceRate = 25
            break
        default:
            storeDistanceRate = 0
        }
        
    }
    @IBAction func onClickBtnDeliveryTag(_ sender: UIButton) {
        btnDeliveryRadiousAnywhere.backgroundColor = UIColor.themeViewBackgroundColor
        btnDeliveryRadiousAll.backgroundColor = UIColor.themeViewBackgroundColor
        btnDeliveryRadiousMyLocation.backgroundColor = UIColor.themeViewBackgroundColor
        btnDeliveryRadiousAnywhere.isSelected = false
        btnDeliveryRadiousAll.isSelected = false
        btnDeliveryRadiousMyLocation.isSelected = false
        sender.backgroundColor = UIColor.themeButtonBackgroundColor
        sender.isSelected = true
    }
    @IBAction func onClickBtnClear(_ sender: Any) {
        isFilterApply = false
        txtSearchItem.text = ""
        resetFilterButtons()
        
        if self.onClickClearButton != nil {
            self.onClickClearButton!()
            self.animationForHideView(filterView) {
                self.removeFromSuperview();
            }
        }
    }
    func setUpRoundedBordersToContainer(viewContainer: UIView) {
        viewContainer.layer.borderWidth = 1.0
        viewContainer.layer.borderColor = UIColor.themeLightTextColor.cgColor
        viewContainer.applyRoundedCornersWithHeight()
    }
    fileprivate func searching(_ mySearchText: String) {
            if mySearchText.isEmpty() {
                if self.onClickLeftButton != nil {
                    self.onClickLeftButton!(filteredArrStoreList)
                }
            }
            else
            {
        
                let tempArray:Array<StoreItem> = (filteredArrStoreList) ?? []
                var tempFiltereArray:Array<StoreItem> = []
                
                    for storesItem:StoreItem in tempArray {
                        for  itemName:String in storesItem.productItemNameList
                        {
                            if itemName.lowercased().contains(mySearchText.lowercased())
                            {
                                if !tempFiltereArray.contains(where: { (item) -> Bool in
                                    item._id == storesItem._id
                                })
                                {
                                    tempFiltereArray.append(storesItem)
                                }
                            }
                        }
                    }
                
                if self.onClickLeftButton != nil {
                    self.onClickLeftButton!(tempFiltereArray)
                }
            }
        }
    
    // MARK: - UITextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

   // MARK: - Keyboard methode
   @objc override func keyboardWasShown(notification: NSNotification)
   {
       //Need to calculate keyboard exact size due to Apple suggestions
       
       let info : NSDictionary = notification.userInfo! as NSDictionary
       let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
       var aRect : CGRect = self.frame
       aRect.size.height -= keyboardSize!.height
       if let activeFieldPresent = activeField
       {
           let globalPoint = (activeFieldPresent.superview as? UIStackView)?.convert((activeFieldPresent.superview as? UIStackView)?.frame.origin ?? CGPoint.zero, to: nil) ?? CGPoint.zero
           
           if (aRect.contains(activeField!.frame.origin))
           {
               self.bottomAnchorView.constant = 0.0
               UIView.animate(withDuration: 0.5) {
                   DispatchQueue.main.async {
                         self.bottomAnchorView.constant = keyboardSize!.height
                   }
               }
           }
       }
   }

   @objc override func keyboardWillBeHidden(notification: NSNotification)
   {
       //Once keyboard disappears, restore original positions
       var info : NSDictionary = notification.userInfo! as NSDictionary
       var keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
       var contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: -keyboardSize!.height, right: 0.0)
       
       UIView.animate(withDuration: 0.5) {
           self.bottomAnchorView.constant = 0.0
       }
       self.endEditing(true)
   }
    
    func numberOfTags(_ tagView: HTagView) -> Int {
        return (currentDeliveryItem?.famousProductsTags.count)  ?? 0
    }
        
    func tagView(_ tagView: HTagView, titleOfTagAtIndex index: Int) -> String {
        return currentDeliveryItem?.famousProductsTags[index].tag ?? ""
    }
        
    func tagView(_ tagView: HTagView, tagTypeAtIndex index: Int) -> HTagType {
        return .select
    }
        
    func tagView(_ tagView: HTagView, tagWidthAtIndex index: Int) -> CGFloat {
        return .HTagAutoWidth
    }
    
    // MARK: - HTagViewDelegate
        
    func tagView(_ tagView: HTagView, tagSelectionDidChange selectedIndices: [Int]) {
        arrForSelectedTags.removeAll()
            for index in selectedIndices {
                arrForSelectedTags.append((currentDeliveryItem?.famousProductsTags[index].tag)!)
        }
        storeTagView.reloadData()
    }
}

