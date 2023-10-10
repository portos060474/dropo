//
//  StoreVC.swift
//  edelivery
//
//  Created by Elluminati on 07/03/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
import GoogleMaps

enum SelectedFrom {
    case fromTableView
    case fromCollectionView
    case fromMapView
    case none
}

class StoreVC: BaseVC
     {
    // MARK: - OUTLET
    let upArraow:String = "\u{25B2}"
    let downArrow:String = "\u{25BC}"
    
    @IBOutlet weak var heightForFilterType: NSLayoutConstraint!
    @IBOutlet weak var imgEmpty: UIImageView!
    @IBOutlet weak var btnFilterDropDown: UIButton!
    @IBOutlet weak var scrollForTags: UIScrollView!
    @IBOutlet weak var viewForHeader: UIView!
    @IBOutlet weak var collectionView: UICollectionView?
    @IBOutlet weak var tblForStoreList: UITableView!
    @IBOutlet weak var viewForFilter: UIView!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var btnResetFilter: UIButton!
    @IBOutlet weak var btnApplyFilter: UIButton!
    @IBOutlet weak var lblAddDetails: UILabel!
    @IBOutlet weak var pgControl: UIPageControl!
    @IBOutlet weak var lblGradient: UILabel!
    @IBOutlet weak var viewForMap: GMSMapView!
    @IBOutlet weak var lblDeliryRadiousFilter: UILabel!
    
    /*Price Rate*/
    @IBOutlet weak var lblPriceFilter: UILabel!
    @IBOutlet weak var btnPriceRate1: UIButton!
    @IBOutlet weak var btnPriceRate2: UIButton!
    @IBOutlet weak var btnPriceRate3: UIButton!
    @IBOutlet weak var btnPriceRate4: UIButton!
    /*TimeRate*/
    @IBOutlet weak var lblDeliveryTimeFilter: UILabel!
    @IBOutlet weak var btnTimeRate1: UIButton!
    @IBOutlet weak var btnTimeRate2: UIButton!
    @IBOutlet weak var btnTimeRate3: UIButton!
    /*Distance Rate */
    
    @IBOutlet weak var lblDistanceFilter: UILabel!
    @IBOutlet weak var btnDistanceRate1: UIButton!
    @IBOutlet weak var btnDistanceRate2: UIButton!
    @IBOutlet weak var btnDistanceRate3: UIButton!
    
    /*View For Filter Type*/
    @IBOutlet weak var btnByTag: UIButton!
    @IBOutlet weak var btnByItem: UIButton!
    @IBOutlet weak var btnByStoreName: UIButton!
    @IBOutlet weak var storeTagView: HTagView!
    @IBOutlet weak var IBbtnFilter: UIButton!
    @IBOutlet weak var IBbtnMap: UIButton!
    @IBOutlet weak var IBlblTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!

    
//    var btnMap: UIButton = UIButton.init(type: .custom)
//    var btnFilter: UIButton = UIButton.init(type: UIButton.ButtonType.custom)
    var arrForStoreLatLong:[CLLocationCoordinate2D] = []
    var arrForAddList:[AdItem] = []
    var arrForSelectedTags:[String] = []
    let transition = CustomAnimator.init(duration: TimeInterval.init(0.3), isPresenting: true)
    @IBOutlet weak var lblTags: UILabel!
    // MARK: - Variables
    
    @IBOutlet weak var searchStore: UISearchBar!
    
    var currentBooking = CurrentBooking.shared
    var currentDeliveryItem:DeliveriesItem?
    var storeListLength:Int? = 0
    var selectedStoreItem:StoreItem? = nil
    
    @IBOutlet weak var heightForBtnCart: NSLayoutConstraint!
    @IBOutlet weak var btnCart: UIButton!
    
    
    
    private let refreshControl = UIRefreshControl()
    var isFilterApply:Bool = false
    var imageDownloaded:Bool = false
    
    var finalFilteredArray:Array<StoreItem> = []
    var originalArrStoreList:Array<StoreItem>? = nil
    var filteredArrStoreList:Array<StoreItem>? = nil
    
    
    var storeTimeRate = Int.max, storeDistanceRate=Int.max
    var arrForPriceRate:[Int] = []
    
    
    var selectedFrom: SelectedFrom = SelectedFrom.none
    var selectedIndex:Int = 0
    var iconImage:UIImage = UIImage.init(named: "store_pin")!
    var currentAddIndex = 0
    weak var timerForAdd: Timer? = nil
    
    @IBOutlet weak var viewForSearch: UIView!
    
    @IBOutlet weak var btnDeliveryRadiousAll: UIButton!
    @IBOutlet weak var btnDeliveryRadiousAnywhere: UIButton!
    @IBOutlet weak var btnDeliveryRadiousMyLocation: UIButton!
    
    var isShowGroupItems:Bool = false

    // MARK: - LifeCycle
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.tblForStoreList.estimatedRowHeight = 300
        self.tblForStoreList.rowHeight = 300
//        self.tblForStoreList.register(cellType: StoreCell.self)
        
        btnByStoreName.isSelected = true
        collectionView?.backgroundColor = UIColor.themeViewBackgroundColor
        collectionView?.isPagingEnabled = true
        collectionView?.isUserInteractionEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        self.collectionView?.register(cellType: AdvertiseCell.self)
        
//        btnMap.isHidden = true
//        btnFilter.isHidden = true
        IBbtnMap.isHidden = true
        IBbtnFilter.isHidden = true

        
        viewForMap.delegate = self
        collectionView?.delegate = self
        collectionView?.dataSource = self
        Utility.downloadImageFrom(link: (currentDeliveryItem?.map_pin_url) ?? "",placeholder: "store_pin") {
            (image) in
            self.iconImage = image
            self.imageDownloaded = true
            self.setMarkers()
        }
        
        filteredArrStoreList = []
        
        if #available(iOS 10.0, *) {
            tblForStoreList.refreshControl = refreshControl
        } else {
            tblForStoreList.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(refreshControl:)), for: .valueChanged)
        self.automaticallyAdjustsScrollViewInsets = false
        viewForFilter.isHidden = true
        setLocalization()
        self.setNavigationTitle(title:(currentDeliveryItem?.delivery_name) ?? "TXT_APP_NAME".localizedCapitalized)
        IBlblTitle.text = (currentDeliveryItem?.delivery_name) ?? "TXT_APP_NAME".localizedCapitalized
        loadStoreList()
        
        for s in searchStore.subviews[0].subviews {
            if s is UITextField {
                s.backgroundColor = UIColor.white
                (s as! UITextField).font = FontHelper.textRegular(size: 12)
            }
        }
        setUpTagView()
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
        storeTagView.tagBorderColor = UIColor.black.cgColor
        
        storeTagView.tagMainBackColor = UIColor.themeButtonBackgroundColor
        storeTagView.tagMainTextColor = UIColor.themeButtonTitleColor
        
        storeTagView.tagSecondBackColor = UIColor.themeButtonTitleColor
        storeTagView.tagSecondTextColor = UIColor.themeButtonBackgroundColor
        scrollForTags.contentSize = storeTagView.bounds.size
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        if currentBooking.cart.count > 0 {
            btnCart.isHidden = false
            heightForBtnCart.constant = 45
        }else {
            btnCart.isHidden = true
            heightForBtnCart.constant = 0
        }
        if arrForAddList.count > 0 {
            self.timerSetup()
        }
        self.view.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
    }

    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        setupLayout()
    }
    
    func timerSetup() {
        timerForAdd?.invalidate()
        timerForAdd = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(StoreVC.handleAddTimer), userInfo: nil, repeats: true)
    }
    
    @objc func handleAddTimer() {
        currentAddIndex = currentAddIndex +  1
        if(  currentAddIndex == self.arrForAddList.count) {
            currentAddIndex = 0
        }
        let indexPath = IndexPath(row: currentAddIndex, section: 0)
        pgControl.currentPage = currentAddIndex
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
        timerForAdd?.invalidate()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func setupLayout() {
        tblForStoreList.tableFooterView = UIView()
        viewForFilter.setShadow(shadowColor: UIColor.lightGray.cgColor, shadowOffset: CGSize.init(width: 0.0, height: 1.0), shadowOpacity:0.17, shadowRadius: 2.0)
        btnTimeRate1.setRound(withBorderColor: UIColor.black, andCornerRadious: 3.0)
        btnTimeRate2.setRound(withBorderColor: UIColor.black, andCornerRadious: 3.0)
        btnTimeRate3.setRound(withBorderColor: UIColor.black, andCornerRadious: 3.0)
        btnPriceRate1.setRound(withBorderColor: UIColor.black, andCornerRadious: 3.0)
        btnPriceRate2.setRound(withBorderColor: UIColor.black, andCornerRadious: 3.0)
        btnPriceRate3.setRound(withBorderColor: UIColor.black, andCornerRadious: 3.0)
        btnPriceRate4.setRound(withBorderColor: UIColor.black, andCornerRadious: 3.0)
        
        btnDistanceRate1.setRound(withBorderColor: UIColor.black, andCornerRadious: 3.0)
        btnDistanceRate2.setRound(withBorderColor: UIColor.black, andCornerRadious: 3.0)
        btnDistanceRate3.setRound(withBorderColor: UIColor.black, andCornerRadious: 3.0)
        
        btnDeliveryRadiousAll.setRound(withBorderColor: UIColor.black, andCornerRadious: 3.0)
        btnDeliveryRadiousMyLocation.setRound(withBorderColor: UIColor.black, andCornerRadious: 3.0)
        btnDeliveryRadiousAnywhere.setRound(withBorderColor: UIColor.black, andCornerRadious: 3.0)
        
        
        btnByTag.setRound(withBorderColor: UIColor.black, andCornerRadious: 3.0)
        btnByItem.setRound(withBorderColor: UIColor.black, andCornerRadious: 3.0)
        btnByStoreName.setRound(withBorderColor: UIColor.black, andCornerRadious: 3.0)
        
        viewForSearch.backgroundColor = UIColor.themeViewBackgroundColor
        viewForSearch.setShadow(shadowColor: UIColor.lightGray.cgColor, shadowOffset: CGSize.init(width: 0.0, height: 1.0), shadowOpacity:0.17, shadowRadius: 2.0)
        
        btnFilterDropDown.backgroundColor = UIColor.themeViewBackgroundColor
        
        lblGradient.setGradient(startColor:UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.0),endColor:UIColor(red: 26/255, green: 26/255, blue: 25/255, alpha: 0.65))
        viewForHeader.sizeToFit()
        viewForHeader.autoresizingMask = UIView.AutoresizingMask()
    }
    
    func setLocalization() {
        btnFilterDropDown.setTitle(downArrow, for: .normal)
        
        searchStore.placeholder = "TXT_SEARCH_BY_STORE".localized
        searchStore.barTintColor = UIColor.themeViewBackgroundColor
        searchStore.backgroundColor = UIColor.themeViewBackgroundColor
        searchStore.backgroundImage = UIImage()
        searchStore.setTextColor(color: UIColor.themeTextColor)
        lblTags.font = FontHelper.textRegular()
        lblTags.text = "TXT_TAGS".localizedCapitalized
        lblTags.textColor = UIColor.themeTextColor
        
//        btnMap.setImage(UIImage.init(named: "map")!, for: .normal)
//        btnMap.addTarget(self, action: #selector(onClickMap), for: .touchUpInside)
//        let barButton = UIBarButtonItem.init(customView: btnMap)
//
//        btnFilter.setImage(UIImage.init(named: "filter")!, for: .normal)
//        btnFilter.addTarget(self, action: #selector(onClickFilter), for: .touchUpInside)
//        btnMap.frame = CGRect.init(x: 0, y: 0, width: 25, height: 25)
//        btnFilter.frame = CGRect.init(x: 0, y: 0, width: 25, height: 25)
//
//        let barButton2 = UIBarButtonItem.init(customView: btnFilter)
//
//        super.navigationItem.rightBarButtonItems = [barButton, barButton2]
        if LocalizeLanguage.isRTL {
            btnBack.setImage(UIImage.init(named: "back_blackRTL"), for: .normal)
        }else{
            btnBack.setImage(UIImage.init(named: "back_black"), for: .normal)
        }
        
        view.backgroundColor = UIColor.themeViewBackgroundColor
        tblForStoreList.backgroundColor = UIColor.themeViewBackgroundColor
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        
        
        btnPriceRate4.setTitle(currentBooking.currency + currentBooking.currency + currentBooking.currency + currentBooking.currency  , for: UIControl.State.normal)
        btnPriceRate3.setTitle(currentBooking.currency + currentBooking.currency + currentBooking.currency, for: UIControl.State.normal)
        btnPriceRate2.setTitle(currentBooking.currency + currentBooking.currency , for: UIControl.State.normal)
        btnPriceRate1.setTitle(currentBooking.currency, for: UIControl.State.normal)
        
        btnCart.setTitle("TXT_GO_TO_CART".localizedCapitalized, for: .normal)
        btnCart.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnCart.backgroundColor = UIColor.themeButtonBackgroundColor
        
        
        lblPriceFilter.textColor = UIColor.themeTextColor
        lblDeliveryTimeFilter.textColor = UIColor.themeTextColor
        lblDeliryRadiousFilter.textColor = UIColor.themeTextColor
        lblPriceFilter.font = FontHelper.textRegular()
        lblDeliveryTimeFilter.font = FontHelper.textRegular()
        lblDeliryRadiousFilter.font = FontHelper.textRegular()
        lblDistanceFilter.textColor = UIColor.themeTextColor
        
        lblDistanceFilter.font = FontHelper.textRegular()
        lblDistanceFilter.text = "TXT_DISTANCE".localizedCapitalized
        lblDeliveryTimeFilter.text = "TXT_DELIVERY_TIME".localizedCapitalized
        lblDeliryRadiousFilter.text = "TXT_PROVIDE_DELIVEY_IN_CITY".localizedCapitalized
        lblPriceFilter.text = "TXT_PRICE".localizedCapitalized
        btnResetFilter.setTitle("TXT_RESET".localizedCapitalized, for: .normal)
        btnApplyFilter.setTitle("TXT_APPLY".localizedCapitalized, for: .normal)
        
        btnByStoreName.setTitle("TXT_STORE".localizedCapitalized, for: .normal)
        btnByItem.setTitle("TXT_ITEM".localizedCapitalized, for: .normal)
        btnByTag.setTitle("TXT_TAG".localizedCapitalized, for: .normal)
        
        btnDeliveryRadiousMyLocation.setTitle("TXT_AT_MY_LOCATION".localizedCapitalized, for: .normal)
        btnDeliveryRadiousAll.setTitle("TXT_ALL".localizedCapitalized, for: .normal)
        btnDeliveryRadiousAnywhere.setTitle("TXT_ANYWHERE".localizedCapitalized, for: .normal)
        
        //Filter Button Setup
        btnDistanceRate1.setTitleColor(UIColor.themeButtonTitleColor, for: .selected)
        btnDistanceRate2.setTitleColor(UIColor.themeButtonTitleColor, for: .selected)
        btnDistanceRate3.setTitleColor(UIColor.themeButtonTitleColor, for: .selected)
        btnDistanceRate1.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnDistanceRate2.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnDistanceRate3.setTitleColor(UIColor.themeTextColor, for: .normal)
        
        btnTimeRate1.setTitleColor(UIColor.themeButtonTitleColor, for: .selected)
        btnTimeRate2.setTitleColor(UIColor.themeButtonTitleColor, for: .selected)
        btnTimeRate3.setTitleColor(UIColor.themeButtonTitleColor, for: .selected)
        btnTimeRate1.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnTimeRate2.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnTimeRate3.setTitleColor(UIColor.themeTextColor, for: .normal)
        
        btnDeliveryRadiousAll.setTitleColor(UIColor.themeButtonTitleColor, for: .selected)
        btnDeliveryRadiousMyLocation.setTitleColor(UIColor.themeButtonTitleColor, for: .selected)
        btnDeliveryRadiousAnywhere.setTitleColor(UIColor.themeButtonTitleColor, for: .selected)
        btnDeliveryRadiousAll.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnDeliveryRadiousMyLocation.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnDeliveryRadiousAnywhere.setTitleColor(UIColor.themeTextColor, for: .normal)
        
        
        btnPriceRate1.setTitleColor(UIColor.themeButtonTitleColor, for: .selected)
        btnPriceRate2.setTitleColor(UIColor.themeButtonTitleColor, for: .selected)
        btnPriceRate3.setTitleColor(UIColor.themeButtonTitleColor, for: .selected)
        btnPriceRate4.setTitleColor(UIColor.themeButtonTitleColor, for: .selected)
        btnPriceRate1.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnPriceRate2.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnPriceRate3.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnPriceRate4.setTitleColor(UIColor.themeTextColor, for: .normal)
        
        
        btnByItem.setTitleColor(UIColor.themeButtonTitleColor, for: .selected)
        btnByTag.setTitleColor(UIColor.themeButtonTitleColor, for: .selected)
        btnByStoreName.setTitleColor(UIColor.themeButtonTitleColor, for: .selected)
        btnByStoreName.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnByItem.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnByTag.setTitleColor(UIColor.themeTextColor, for: .normal)
        
        
        btnByStoreName.setBackgroundColor(color: UIColor.themeButtonBackgroundColor, forState: .selected)
        btnByItem.setBackgroundColor(color: UIColor.themeButtonBackgroundColor, forState: .selected)
        btnByTag.setBackgroundColor(color: UIColor.themeButtonBackgroundColor, forState: .selected)
        
        btnByStoreName.setBackgroundColor(color: UIColor.themeButtonTitleColor  , forState: .normal)
        btnByItem.setBackgroundColor(color: UIColor.themeButtonTitleColor  , forState: .normal)
        btnByTag.setBackgroundColor(color: UIColor.themeButtonTitleColor  , forState: .normal)
        
        
        
        btnDistanceRate1.setBackgroundColor(color: UIColor.themeButtonBackgroundColor, forState: .selected)
        btnDistanceRate2.setBackgroundColor(color: UIColor.themeButtonBackgroundColor, forState: .selected)
        btnDistanceRate3.setBackgroundColor(color: UIColor.themeButtonBackgroundColor, forState: .selected)
        
        btnDistanceRate1.setBackgroundColor(color: UIColor.themeButtonTitleColor  , forState: .normal)
        btnDistanceRate2.setBackgroundColor(color: UIColor.themeButtonTitleColor  , forState: .normal)
        btnDistanceRate3.setBackgroundColor(color: UIColor.themeButtonTitleColor  , forState: .normal)
        
        btnTimeRate1.setBackgroundColor(color: UIColor.themeButtonBackgroundColor, forState: .selected)
        btnTimeRate2.setBackgroundColor(color: UIColor.themeButtonBackgroundColor, forState: .selected)
        btnTimeRate3.setBackgroundColor(color: UIColor.themeButtonBackgroundColor, forState: .selected)
        btnTimeRate1.setBackgroundColor(color: UIColor.themeButtonTitleColor  , forState: .normal)
        btnTimeRate2.setBackgroundColor(color: UIColor.themeButtonTitleColor  , forState: .normal)
        btnTimeRate3.setBackgroundColor(color: UIColor.themeButtonTitleColor  , forState: .normal)
        
        
        
        btnDeliveryRadiousAll.setBackgroundColor(color: UIColor.themeButtonBackgroundColor, forState: .selected)
        btnDeliveryRadiousAnywhere.setBackgroundColor(color: UIColor.themeButtonBackgroundColor, forState: .selected)
        btnDeliveryRadiousMyLocation.setBackgroundColor(color: UIColor.themeButtonBackgroundColor, forState: .selected)
        btnDeliveryRadiousAll.setBackgroundColor(color: UIColor.themeButtonTitleColor  , forState: .normal)
        btnDeliveryRadiousAnywhere.setBackgroundColor(color: UIColor.themeButtonTitleColor  , forState: .normal)
        btnDeliveryRadiousMyLocation.setBackgroundColor(color: UIColor.themeButtonTitleColor  , forState: .normal)
        
        
        
        btnPriceRate1.setBackgroundColor(color: UIColor.themeButtonBackgroundColor, forState: .selected)
        btnPriceRate2.setBackgroundColor(color: UIColor.themeButtonBackgroundColor, forState: .selected)
        btnPriceRate3.setBackgroundColor(color: UIColor.themeButtonBackgroundColor, forState: .selected)
        btnPriceRate4.setBackgroundColor(color: UIColor.themeButtonBackgroundColor, forState: .selected)
        btnPriceRate1.setBackgroundColor(color: UIColor.themeButtonTitleColor  , forState: .normal)
        btnPriceRate2.setBackgroundColor(color: UIColor.themeButtonTitleColor  , forState: .normal)
        btnPriceRate3.setBackgroundColor(color: UIColor.themeButtonTitleColor  , forState: .normal)
        btnPriceRate4.setBackgroundColor(color: UIColor.themeButtonTitleColor  , forState: .normal)
        
        self.hideBackButtonTitle()
    }
    
    @IBAction func onClickBtnCart(_ sender: Any) {
        if let navigationVC = self.navigationController {
            for controller in navigationVC.viewControllers {
                if controller.isKind(of: CartVC.self) {
                    self.navigationController?.popToViewController(controller, animated: true)
                    return
                }
            }
        }
        
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "Cart", bundle: nil)
        if let cartvc: CartVC = mainView.instantiateInitialViewController() as? CartVC {
            self.navigationController?.pushViewController(cartvc, animated: true)
        }
    }
    
    //MARK:- ACTION FUNCTION
    
    @IBAction func onClickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickBtnStoreName(_ sender: Any) {
        btnByStoreName.isSelected = true
        btnByTag.isSelected = false
        btnByItem.isSelected = false
        searchStore.placeholder = "TXT_SEARCH_BY_STORE".localized
        searching(searchStore.text  ?? "")
    }
    
    @IBAction func onClickBtnItemName(_ sender: Any) {
        
        btnByStoreName.isSelected = false
        btnByTag.isSelected = false
        btnByItem.isSelected = true
        
        searchStore.placeholder = "TXT_SEARCH_BY_ITEM".localized
        searching(searchStore.text  ?? "")
    }
    
    @IBAction func onClickBtnTag(_ sender: Any) {
        
        btnByStoreName.isSelected = false
        btnByTag.isSelected = true
        btnByItem.isSelected = false
        searchStore.placeholder = "TXT_SEARCH_BY_TAG".localized
        searching(searchStore.text  ?? "")
    }
    
    @IBAction func onClickBtnDropDown(_ sender: Any) {
        if heightForFilterType.constant == 0 {
            btnFilterDropDown.setTitle(upArraow, for: .normal)
            heightForFilterType.constant = 34
        }else {
            btnFilterDropDown.setTitle(downArrow, for: .normal)
            heightForFilterType.constant = 0
        }
        
    }
    
    @IBAction func onClickFilter() {
        viewForMap.isHidden = true
//        btnMap.setImage(UIImage.init(named: "map")!, for: .normal)
        IBbtnMap.setImage(UIImage.init(named: "map")!, for: .normal)

        if viewForFilter.isHidden {
            viewForFilter.isHidden = false
//            btnFilter.setImage(UIImage.init(named: "cancel")!, for: .normal)
            IBbtnFilter.setImage(UIImage.init(named: "cancel")!, for: .normal)

            
        }else {
            viewForFilter.isHidden = true
//            btnFilter.setImage(UIImage.init(named: "filter")!, for: .normal)
            IBbtnFilter.setImage(UIImage.init(named: "filter")!, for: .normal)

        }
    }
    @IBAction func onClickMap() {
        viewForFilter.isHidden = true
//        btnFilter.setImage(UIImage.init(named: "filter")!, for: .normal)
        IBbtnFilter.setImage(UIImage.init(named: "filter")!, for: .normal)

        if viewForMap.isHidden {
            viewForMap.isHidden = false
//            btnMap.setImage(UIImage.init(named: "cancel")!, for: .normal)
            IBbtnMap.setImage(UIImage.init(named: "cancel")!, for: .normal)
            focusMapToShowAllMarkers(loctions: arrForStoreLatLong)
            
            
        }else {
            viewForMap.isHidden = true
//            btnMap.setImage(UIImage.init(named: "map")!, for: .normal)
            IBbtnMap.setImage(UIImage.init(named: "map")!, for: .normal)
        }
    }
    
    @IBAction func onClickBtnApply(_ sender: Any) {
        isFilterApply = true
        searchStore.text = ""
        if originalArrStoreList?.isEmpty ?? true {
            Utility.showToast(message: "TXT_NO_STORE_FOUND".localizedLowercase)
            
        }
        else
        {
            applyFilter()
            
        }
    }

    @IBAction func onClickBtnReset(_ sender: Any) {
        isFilterApply = false
        searchStore.text = ""
        self.onClickFilter()
        resetFilterButtons()
        self.reloadTableWithArray(array: originalArrStoreList)
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
    }
    @IBAction func onClickBtnPriceTag(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            sender.backgroundColor = UIColor.white
            
        }else {
            sender.isSelected = true
            sender.backgroundColor = UIColor.black
        }
        
        if let index = arrForPriceRate.index(of: sender.tag) {
            arrForPriceRate.remove(at: index)
        }else {
            arrForPriceRate.append(sender.tag)
        }
    }
    
    @IBAction func onClickBtnTimeTag(_ sender: UIButton) {
        btnTimeRate1.backgroundColor = UIColor.white
        btnTimeRate2.backgroundColor = UIColor.white
        btnTimeRate3.backgroundColor = UIColor.white
        btnTimeRate1.isSelected = false
        btnTimeRate2.isSelected = false
        btnTimeRate3.isSelected = false
        
        
        sender.backgroundColor = UIColor.black
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
    @IBAction func onClickBtnDeliveryTag(_ sender: UIButton) {
        btnDeliveryRadiousAnywhere.backgroundColor = UIColor.white
        btnDeliveryRadiousAll.backgroundColor = UIColor.white
        btnDeliveryRadiousMyLocation.backgroundColor = UIColor.white
        
        btnDeliveryRadiousAnywhere.isSelected = false
        btnDeliveryRadiousAll.isSelected = false
        btnDeliveryRadiousMyLocation.isSelected = false
        
        
        sender.backgroundColor = UIColor.black
        sender.isSelected = true
    }
    @IBAction func onClickBtnDistanceTag(_ sender: UIButton) {
        btnDistanceRate1.backgroundColor = UIColor.white
        btnDistanceRate2.backgroundColor = UIColor.white
        btnDistanceRate3.backgroundColor = UIColor.white
        btnDistanceRate1.isSelected = false
        btnDistanceRate2.isSelected = false
        btnDistanceRate3.isSelected = false
        
        
        sender.backgroundColor = UIColor.black
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
    
    //MARK:- USER DEFINE FUNCTION
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
        
        
        for storesItem:StoreItem in originalArrStoreList! {
            
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
                var isAdd:Bool = false
                
                for tag in arrForSelectedTags {
                    print("---\(storeItem.famousProductsTags)")
                    if storeItem.famousProductsTags.count > 0 {
                     if storeItem.famousProductsTags.contains(where: { (storeTag) -> Bool in
                        print("***\(storeTag)")
                         return storeTag.tag == tag
                     })
                     {
                         isAdd = true
                     }
                    }
                }
                return isAdd
            })
            self.reloadTableWithArray(array: newList)
        }else {
            self.reloadTableWithArray(array: filteredArrStoreList)
        }
        
        self.onClickFilter()
        searchStore.text = ""
    }
    
    func loadStoreList() {
        isFilterApply = false
        if (currentDeliveryItem != nil) {
            wsGetStoreList(storeDeliveryId: (currentDeliveryItem?._id)!)
            self.title = currentDeliveryItem?.delivery_name
        }
    }
    
    func reloadTableWithArray(array:Array<StoreItem>?) {
        if let finalArray = array {
            finalFilteredArray.removeAll()
            for storeItem in finalArray {
                finalFilteredArray.append(storeItem)
            }
        }
        tblForStoreList.reloadData()
    }
    
    //MARK:- WEB SERVICE CALLS
    func wsGetStoreList(storeDeliveryId:String) {
        Utility.showLoading()
        let dictParam: Dictionary<String,Any> = [PARAMS.STORE_DELIVERY_ID:storeDeliveryId,
                                                 PARAMS.CITY_ID :currentBooking.bookCityId ?? "",
                                                 PARAMS.USER_ID:preferenceHelper.getUserId(),
                                                 PARAMS.IPHONE_ID:preferenceHelper.getRandomCartID(),
                                                 PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken(),
                                                 PARAMS.LATITUDE:currentBooking.currentLatLng[0],
                                                 PARAMS.LONGITUDE:currentBooking.currentLatLng[1]]
        print(Utility.convertDictToJson(dict: dictParam))

        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_GET_STORELIST, methodName: "POST", paramData: dictParam) {(response, error) -> (Void) in
            
            print(Utility.convertDictToJson(dict: response as! Dictionary<String, Any>))
            Utility.hideLoading()
            self.refreshControl.endRefreshing()
            self.isFilterApply = false
            self.searchStore.text = ""
            self.resetFilterButtons()
            print(response)
            if Parser.isSuccess(response: response) {
                let storeResponse:StoreResponse = StoreResponse.init(dictionary: response)!
                print(response)
                self.arrForAddList.removeAll()
                self.arrForAddList = storeResponse.ads
                self.originalArrStoreList = Parser.parseStoreList(response)
                if (self.originalArrStoreList != nil) {
                    self.storeListLength = self.originalArrStoreList?.count
                }
                
                if self.originalArrStoreList?.isEmpty ?? true {
                    self.IBbtnMap.isHidden = true
                    self.IBbtnFilter.isHidden = true

                }else {
                    self.IBbtnMap.isHidden = false
                    self.IBbtnFilter.isHidden = false
                }
                self.searchStore.text = ""
                self.reloadTableWithArray(array: self.originalArrStoreList!)
                self.setMarkers()
                self.imgEmpty.isHidden = true
                self.configureHeaderView()
            }else {
                self.imgEmpty.isHidden = false
            }
        }
    }
    
    //MARK: Set Markers
    
    func focusMapToShowAllMarkers(loctions: [CLLocationCoordinate2D]) {
        var bounds = GMSCoordinateBounds()
        for location:CLLocationCoordinate2D in loctions {
            bounds = bounds.includingCoordinate(location)
        }
        CATransaction.begin()
        CATransaction.setValue(3.0, forKey: kCATransactionAnimationDuration)
        CATransaction.setCompletionBlock {
        }
        viewForMap.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 80.0))
        CATransaction.commit()
    }
    
    func setMarkers() {
        viewForMap.clear()
        arrForStoreLatLong.removeAll()
        if imageDownloaded {
            for storesItem:StoreItem in originalArrStoreList ?? [] {
                
                let location:CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: storesItem.location![0], longitude: storesItem.location![1])
                self.arrForStoreLatLong.append(location)
                let marker:GMSMarker = GMSMarker.init(position:location)
                marker.icon =  iconImage
                var snippetString:String = ""
                if storesItem.isStoreClosed {
                    snippetString = storesItem.reopenAt + "\n" + "TXT_DELIVERY_TIME".localized + "  " + String(storesItem.deliveryTime) + " " +  "UNIT_MIN".localized
                }else {
                    snippetString = "TXT_OPEN".localized + "\n" + "TXT_DELIVERY_TIME".localized + "  " + String(storesItem.deliveryTime) + " " +  "UNIT_MIN".localized
                }
                marker.snippet = snippetString
                marker.title = storesItem.name
                marker.map = viewForMap
                marker.userData = storesItem
            }
            
            let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: currentBooking.currentPlaceData.latitude, longitude: currentBooking.currentPlaceData.longitude)
            let marker:GMSMarker = GMSMarker.init(position:coordinate)
            marker.icon =  UIImage.init(named: "user_pin")
            marker.map = viewForMap
        }
    }
    
    
    //MARK:- Navigation Methods
    func goToProductVC(storeID:String = "",indAdList : Int = 0) {
        timerForAdd?.invalidate()
        
        let productVc : ProductVC = ProductVC.init(nibName: "Product", bundle: nil)
        productVc.isShowGroupItems = self.isShowGroupItems
        productVc.selectedStore = self.selectedStoreItem
        productVc.isFromDeliveryList = false
        var isIndexMatch : Bool = false
        var selectedInd : Int = 0
        
        if preferenceHelper.getSelectedLanguageCode() != Constants.selectedLanguageCode{
            Constants.selectedLanguageCode = preferenceHelper.getSelectedLanguageCode()
        }
        
        if storeID.isEmpty {
            for obj in currentBooking.selectedStore!.langItems!{
                if (obj.code == Constants.selectedLanguageCode) && (obj.is_visible! == true){
                    isIndexMatch = true
                    selectedInd = currentBooking.selectedStore!.langItems!.index(where: { $0.code == obj.code })!
                    break
                }else{
                    isIndexMatch = false
                }
            }
        }else{
                    
            for obj in (self.arrForAddList[selectedIndex].store_detail?.langItems)!{
                if obj.code == Constants.selectedLanguageCode{
                    isIndexMatch = true
                    selectedInd = (self.arrForAddList[selectedIndex].store_detail?.langItems!.index(where: { $0.code == obj.code })!)!

                    break
                }else{
                    isIndexMatch = false
                }
            }
        }

        if !isIndexMatch{
            if selectedStoreItem!.langItems!.count  > 0{
                productVc.languageCode = selectedStoreItem!.langItems![0].code!
            }
            productVc.languageCode = "en"
            productVc.languageCodeInd = "0"
        }else{
            productVc.languageCode = Constants.selectedLanguageCode
            productVc.languageCodeInd = "\(selectedInd)"
        }
        
        if storeID.isEmpty {
            productVc.selectedStore = self.selectedStoreItem
            self.navigationController?.delegate = self
        }else {
            productVc.selectedStoreId = storeID
            self.navigationController?.delegate = nil
        }
        
        self.navigationController?.pushViewController(productVc, animated: true)
    }
}

extension StoreVC:UITableViewDataSource, UISearchBarDelegate,UITableViewDelegate,GMSMapViewDelegate {

    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        self.selectedStoreItem = marker.userData as? StoreItem
        selectedFrom = SelectedFrom.fromMapView
        self.goToProductVC()
    }
    
    //MARK: TABLEVIEW DELEGATE METHODS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return finalFilteredArray.count
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = UITableViewCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 270
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        selectedStoreItem = finalFilteredArray[indexPath.row]
        selectedFrom = SelectedFrom.fromTableView
        selectedIndex = indexPath.row
        currentBooking.isSelectedStoreClosed = (selectedStoreItem?.isStoreClosed)!
        currentBooking.selectedStore =  selectedStoreItem!
        self.goToProductVC()
    }
    
    @objc func handleRefresh(refreshControl: UIRefreshControl) {
        isFilterApply = false
        self.wsGetStoreList(storeDeliveryId: (currentDeliveryItem?._id)!)
    }
    
    fileprivate func searching(_ mySearchText: String) {
        if mySearchText.isEmpty() {
            if isFilterApply {
                self.reloadTableWithArray(array: filteredArrStoreList)
            }else {
                self.reloadTableWithArray(array: originalArrStoreList)
            }
        }
        else
        {
            
            let tempArray:Array<StoreItem> = (isFilterApply ? filteredArrStoreList:originalArrStoreList) ?? []
            
            var tempFiltereArray:Array<StoreItem> = []
            
            if btnByItem.isSelected {
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
            }else if btnByTag.isSelected {
                for storesItem:StoreItem in tempArray {
                    
                    for  tagName in storesItem.famousProductsTags
                    {
                        if tagName.tag.lowercased().contains(mySearchText.lowercased())
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
            } else {
                for storesItem:StoreItem in tempArray {
                    if (storesItem.name?.lowercased().contains(mySearchText.lowercased()))! {
                        tempFiltereArray.append(storesItem)
                    }
                }
            }
            self.reloadTableWithArray(array: tempFiltereArray)
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let mySearchText = searchText.trimmingCharacters(in: .whitespaces)
        searching(mySearchText)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        let storeId:String = self.arrForAddList[indexPath.row].storeId
        if (storeId.isEmpty()) {
        } else {
            selectedStoreItem = currentBooking.deliveryAdsList![indexPath.item].store_detail
            currentBooking.isSelectedStoreClosed = (selectedStoreItem?.isStoreClosed)!
            currentBooking.selectedStore =  selectedStoreItem!
            selectedIndex = indexPath.item
            selectedFrom = SelectedFrom.fromCollectionView
            self.goToProductVC(storeID: storeId,indAdList:selectedIndex)
        }
    }
}

extension StoreVC:UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {
    func configureHeaderView() {
        if (arrForAddList.count > 0) {
            viewForHeader?.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width/1.75)
            tblForStoreList?.tableHeaderView = viewForHeader
            collectionView?.reloadData()
            viewForHeader.isHidden = false
            self.pgControl.currentPage = 0
            self.lblAddDetails.text = arrForAddList[0].adsDetail
            if (arrForAddList.count > 1) {  
                timerSetup()
            }
        } else {
            viewForHeader.isHidden = true
            viewForHeader?.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 0)
            tblForStoreList?.tableHeaderView = viewForHeader
        }
        pgControl.numberOfPages = arrForAddList.count 
    }

    //MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (arrForAddList.count)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdvertiseCell", for: indexPath) as! AdvertiseCell
        cell.bannerImageView.downloadedFrom(link: Utility.getDynamicResizeImageURL(width: cell.bannerImageView.frame.width, height: cell.bannerImageView.frame.height, imgUrl: (arrForAddList[indexPath.row].imageForBanner) ?? ""),isFromResize: true)
        cell.bannerImageView.contentMode = .scaleAspectFill
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width/1.25)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.collectionView {
            var currentCellOffset = self.collectionView?.contentOffset
            currentCellOffset?.x += (self.collectionView?.frame.width)! / 2
            if let indexPath = self.collectionView?.indexPathForItem(at: currentCellOffset!) {
                self.collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                self.pgControl.currentPage = indexPath.row
                self.lblAddDetails.text = arrForAddList[indexPath.row].adsDetail
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}

extension StoreVC:HTagViewDelegate,HTagViewDataSource {
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
    }
}

extension StoreVC : UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        switch operation {
        case .push:
            
            if toVC is ProductVC {
                let indexPath = IndexPath(row: selectedIndex, section: 0)
                transition.isPresenting = true
                transition.transtionFromTo = TransitionFromTo.StoreToProduct
                return transition
            }
            return nil
            
            
        case .pop:
            self.navigationController?.isNavigationBarHidden = true
            if fromVC is ProductVC {
                transition.isPresenting = false
                transition.transtionFromTo = TransitionFromTo.ProductToStore
                return transition
            }
            return nil
            
        default:
            return nil
        }
    }
    
}
