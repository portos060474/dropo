//
//  HomeVC.swift
//  edelivery
//
//  Created by Elluminati on 14/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
import GooglePlaces

class HomeVC: BaseVC, UIGestureRecognizerDelegate, UIScrollViewDelegate {

    //MARK: - OutLets
    @IBOutlet weak var lblEmpty: UILabel!
    @IBOutlet weak var imgEmpty: UIImageView!
    @IBOutlet weak var imgStoreEmpty: UIImageView!
    @IBOutlet weak var viewForHeader: UIView!
    @IBOutlet weak var pgControl: UIPageControl!
    @IBOutlet weak var lblGradient: UILabel!
    @IBOutlet weak var collectionView: UICollectionView?
    @IBOutlet weak var collViewDeliveryList: UICollectionView?
    @IBOutlet weak var collViewStoreAds: UICollectionView?
    @IBOutlet weak var collViewStoreList: UICollectionView?
    @IBOutlet weak var lblAddDetail: UILabel!
    @IBOutlet weak var collViewNewList: UICollectionView?
    @IBOutlet weak var containerForStoreVC: UIView!
    @IBOutlet weak var tableForDelivery: UITableView?
    @IBOutlet weak var btnSearchLocation: UIButton!
    @IBOutlet weak var viewDeliveryAds: UIView?
    @IBOutlet weak var viewStoreAds: UIView?
    @IBOutlet weak var viewDeliveryList: UIView?
    @IBOutlet weak var viewStoreList: UIView?
    @IBOutlet weak var lblDeliveryAdsTitle: UILabel!
    @IBOutlet weak var lblStoreAdsTitle: UILabel!
    @IBOutlet weak var lblDeliveryListTitle: UILabel!
    @IBOutlet weak var lblStoreListTitle: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnFilterStore: UIButton!
    @IBOutlet weak var btnSearchStore: UIButton!
    @IBOutlet weak var txtSearchStore: UITextField!
    @IBOutlet weak var viewForOffers: UIView?
    @IBOutlet weak var collViewOffers: UICollectionView?
    @IBOutlet weak var lblOffers: UILabel!
    @IBOutlet weak var viewCartContainer: UIView?
    @IBOutlet weak var lblCartText: UILabel?
    @IBOutlet weak var lblCartQuantity: UILabel?
    @IBOutlet weak var heightForHeader: NSLayoutConstraint!
    @IBOutlet weak var heightForStoreList: NSLayoutConstraint?
    @IBOutlet weak var stackViewStoreList: UIStackView?

    //MARK: - Variables
    var apicallCount : Int = 0
    var deliveryListLength:Int = 0
    var currentAddIndex = 0
    weak var timerForAdd: Timer? = nil
    var selectedDeliveryItem:DeliveriesItem? = nil
    var locationManager : LocationManager? = LocationManager()
    var storeFragmentVC:StoreFragmentVC? = nil
    var selectedStoreItem:StoreItem? = nil
    var indC : Int = 0
    var arrForAddList:[AdItem] = []
    var finalFilteredArray:Array<StoreItem> = []
    var originalArrStoreList:Array<StoreItem>? = nil
    var filteredArrStoreList:Array<StoreItem>? = nil
    var arrPromoCodeList:Array<PromoCodeItem>? = nil
    var storeListLength:Int? = 0
    var filterSingleton: SelectedFilterOptions = SelectedFilterOptions.shared
    var isFilterApply:Bool = false
    var isChangeInFavorite:Bool = false
    var isFromUpdateOrder: Bool = false
    var totalStoreCount = 0
    let refreshControl = UIRefreshControl()
    var isVisible = false
    var newList:[[Any]] = [["store_filter_delivery".localized, false],["store_filter_takeaway".localized, false],["store_filter_book_a_table".localized, false]]
    var deliveryArrStoreList:[StoreItem] = []
    var pickupArrStoreList:[StoreItem] = []
    var bookTableArrStoreList:[StoreItem] = []
    var isTableBooking:Bool = false
    var isDeliveryChanged:Bool = false
    var lastSelectedDeliveryIndex:Int = 0
    var lastSelectedColorIndex:Int = 0

    //MARK: - View life cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        LocationCenter.default.addObservers(self, [#selector(self.locationUpdate(_:)), #selector(self.locationFail(_:))])
        LocationCenter.default.startUpdatingLocation()
        Utility.showLoading()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.firebaseAuthentication()
        scrollView.delegate = self
        self.hideBackButtonTitle()
        collectionView?.backgroundColor = UIColor.themeViewBackgroundColor
        collectionView?.isUserInteractionEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.register(cellType: AdvertiseCell.self)
        collViewDeliveryList?.backgroundColor = UIColor.themeViewBackgroundColor
        collViewDeliveryList?.isUserInteractionEnabled = true
        collViewDeliveryList?.showsHorizontalScrollIndicator = false
        collViewDeliveryList?.delegate = self
        collViewDeliveryList?.dataSource = self
        collViewDeliveryList?.register(cellType: DeliveryCell.self)
        collViewStoreAds?.backgroundColor = UIColor.themeViewBackgroundColor
        collViewStoreAds?.isUserInteractionEnabled = true
        collViewStoreAds?.showsHorizontalScrollIndicator = false
        collViewStoreAds?.delegate = self
        collViewStoreAds?.dataSource = self
        collViewStoreAds?.register(cellType: AdvertiseCell.self)
        /* Store Cell Collectionview Setup */
        collViewStoreList?.backgroundColor = UIColor.themeViewBackgroundColor
        collViewStoreList?.isUserInteractionEnabled = true
        collViewStoreList?.showsHorizontalScrollIndicator = false
        collViewStoreList?.delegate = self
        collViewStoreList?.dataSource = self
        collViewStoreList?.isScrollEnabled = true
        collViewStoreList?.scrollsToTop = true
        collViewStoreList?.register(cellType: StoreCell.self)
        collViewOffers?.isUserInteractionEnabled = true
        collViewOffers?.showsHorizontalScrollIndicator = false
        collViewOffers?.delegate = self
        collViewOffers?.dataSource = self
        collViewOffers?.register(cellType: AdvertiseCell.self)
        collViewNewList?.backgroundColor = UIColor.themeViewBackgroundColor
        collViewNewList?.isUserInteractionEnabled = true
        collViewNewList?.delegate = self
        collViewNewList?.dataSource = self
        
        setLocalization()
        txtSearchStore.isHidden = true
        setUpCartView()
        self.viewForOffers?.isHidden = true
        self.txtSearchStore.autocorrectionType = .no
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.basicSetup()
        self.setItemCountInBasket()
        self.isVisible = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.topViewController?.title = "APP_NAME".localized
        self.navigationController?.isNavigationBarHidden = false
        timerForAdd?.invalidate()
        self.isVisible = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        guard let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        flowLayout.invalidateLayout()
        setupLayout()
    }
    
    func firebaseAuthentication() {
        if firebaseAuth.currentUser == nil {
            firebaseAuth.signIn(withCustomToken:  preferenceHelper.getAuthToken()) { user, error in
                if error == nil {
                    print("Firebase authentication successfull...")
                } else {
                    print(error ?? "Error in firebase authentication")
                }
            }
        }
    }

    //MARK: - setup to get delivery list
    func basicSetup() {
        containerForStoreVC.isHidden = true
        deliveryListLength = currentBooking.deliveryStoreList.count
        self.viewDeliveryAds?.isHidden = true//(currentBooking.deliveryAdsList?.count ?? 0 > 0) ? (false) : (true)
        if deliveryListLength == 0 {
            self.setDataForTheDelivery()
        } else if isChangeInFavorite {
            checkForStoreList(selectedIndex: lastSelectedDeliveryIndex)
            isChangeInFavorite =  false
        } else {
            self.collViewDeliveryList?.reloadData()
            self.collectionView?.reloadData()
            self.collViewStoreAds?.reloadData()
            self.collViewStoreList?.reloadData()
            Utility.hideLoading()
            configureHeaderView()
            checkForStoreList(selectedIndex: lastSelectedDeliveryIndex)
            self.hideEmptyScreen(isHide: true)
            self.goToProductScreen()
        }
        
        let dictionary: [String:Any] = currentBooking.currentSendPlaceData.toDictionary()
        if ((currentBooking.currentCity ?? ""  != currentBooking.currentSendPlaceData.city3) || (currentBooking.bookCityId?.isEmpty()) ?? true) && UserSingleton.shared.address.count > 0 {
            self.wsGetDeliveriesInNearestCity(parameter: dictionary)
        }
        if !(currentBooking.bookCityId?.isEmpty ?? true) {
            self.checkForPromoCodeList()
        }
        if isChangedLanguageFromSettings {
            isChangedLanguageFromSettings = false
        }
        if currentBooking.deliveryType == DeliveryType.tableBooking {
            APPDELEGATE.wsClearCart {}
            currentBooking.clearCart()
            currentBooking.clearTableBooking()
            self.setItemCountInBasket()
        } else {
            self.wsGetCart()
        }
    }
    
    func timerSetup() {
        timerForAdd?.invalidate()
        timerForAdd = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(HomeVC.handleAddTimer), userInfo: nil, repeats: true)
    }
    
    @objc func handleAddTimer() {
        currentAddIndex = currentAddIndex +  1
        if (currentAddIndex == (currentBooking.deliveryAdsList?.count)!) {
            currentAddIndex = 0
        }
        let indexPath = IndexPath(row: currentAddIndex, section: 0)
        pgControl?.currentPage = currentAddIndex
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        lblAddDetail?.text = currentBooking.deliveryAdsList![currentAddIndex].adsDetail
    }
    
    func setupLayout() {
        if !viewForHeader.isHidden {
            lblGradient.setGradient(startColor:UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.0),endColor:UIColor(red: 26/255, green: 26/255, blue: 25/255, alpha: 0.65))
            viewForHeader.sizeToFit()
            viewForHeader.autoresizingMask = UIView.AutoresizingMask()
        }
        self.btnSearchLocation.applyRoundedCornersWithHeight()
        self.viewCartContainer?.applyRoundedCornersWithHeight()
        lblCartQuantity?.applyRoundedCornersWithHeight()
    }
    
    func setLocalization() {
        view.backgroundColor = UIColor.themeViewBackgroundColor
        viewDeliveryAds?.backgroundColor = UIColor.themeViewBackgroundColor
        viewStoreAds?.backgroundColor = UIColor.themeViewBackgroundColor
        viewDeliveryList?.backgroundColor = UIColor.themeViewBackgroundColor
        viewStoreList?.backgroundColor = UIColor.themeViewBackgroundColor
        viewForOffers?.backgroundColor = UIColor.themeViewBackgroundColor
        lblDeliveryAdsTitle.font = FontHelper.textMedium(size: FontHelper.large)
        lblStoreListTitle.font = FontHelper.textMedium(size: FontHelper.large)
        lblDeliveryListTitle.font = FontHelper.textMedium(size: FontHelper.large)
        lblStoreAdsTitle.font = FontHelper.textMedium(size: FontHelper.large)
        lblDeliveryAdsTitle.text = "TXT_DELIVERIES_ADS".localized
        lblStoreListTitle.text = "TXT_STORE".localized
        lblDeliveryListTitle.text = "TXT_DELIVERIES".localized
        lblStoreAdsTitle.text = "TXT_STORE_ADS".localized
        collViewDeliveryList?.backgroundColor = UIColor.themeViewBackgroundColor
        lblAddDetail.font = FontHelper.textRegular()
        lblAddDetail.textColor = UIColor.themeButtonTitleColor
        lblAddDetail.text = ""
        lblEmpty.textColor = UIColor.themeLightTextColor
        lblEmpty.text = "TXT_NO_DELIVERY_AVAILABLE".localized
        lblEmpty.font = FontHelper.textLarge()
        lblOffers.font = FontHelper.textMedium(size: FontHelper.large)
        lblOffers.text = "TXT_OFFERS".localized
        lblOffers.textColor = .themeTitleColor
        viewForHeader.clipsToBounds = true
        btnSearchLocation.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnSearchLocation.titleLabel?.font = FontHelper.textRegular()
        btnSearchLocation.setBackgroundColor(color: UIColor.themeColor, forState: .normal)
        btnSearchLocation.setTitle("TXT_SEARCH_LOCATION".localized, for: .normal)
        txtSearchStore.font = FontHelper.textRegular()
        txtSearchStore.textColor = UIColor.themeTextColor
        txtSearchStore.placeholder = "TXT_SEARCH_BY_STORE".localized
        txtSearchStore.setRound(withBorderColor: UIColor.themeLightTextColor, andCornerRadious: 5.0, borderWidth: 0.5)
        txtSearchStore.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: txtSearchStore.frame.size.height))
        txtSearchStore.leftViewMode = .always
        txtSearchStore.tintColor = .themeTextColor
        btnSearchStore.setImage(UIImage(named: "cancelIcon")?.imageWithColor(color: UIColor.themeTitleColor), for: .selected)
        self.viewCartContainer?.backgroundColor = UIColor.themeColor
        lblCartQuantity?.textColor = UIColor.themeButtonTitleColor
        lblCartQuantity?.font = FontHelper.tiny()
        lblCartQuantity?.backgroundColor = UIColor.themeRedBGColor
        lblCartQuantity?.textColor = UIColor.themeButtonTitleColor
        lblCartText?.textColor = UIColor.themeButtonTitleColor
        lblCartText?.font = FontHelper.textMedium()
        lblCartText?.text = "TXT_VIEW_CART".localized
        btnFilterStore.tintColor = .themeColor
        btnFilterStore.setImage(UIImage.init(named: "filter_blue")?.imageWithColor(color: .themeColor), for: .normal)
        btnSearchStore.setImage(UIImage.init(named: "search_blue")?.imageWithColor(color: .themeColor), for: .normal)
    }
    
    @IBAction func onClickBtnSearchLocation(_ sender: Any) {
        (self.parent as? MainVC)?.onClickBtnNavigation(self)
    }
    
    @IBAction func onClickBtnSearchStore(_ sender: UIButton) {
        if sender.isSelected {
            txtSearchStore.isHidden = true
            txtSearchStore.text =  ""
            searchStore("")
        } else {
            txtSearchStore.isHidden = false
        }
        btnSearchStore.isSelected = !sender.isSelected
    }
    
    @IBAction func onClickBtnFilterStore(_ sender: Any) {
        self.openFilterStoreDialog()
    }
    
    @IBAction func onClickBtnCart(_ sender: AnyObject) {
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
    
    @objc func refereshStoreList() {}
    
    func hideEmptyScreen(isHide: Bool)  {
        self.imgEmpty?.isHidden = isHide
        self.lblEmpty?.isHidden = isHide
        self.btnSearchLocation?.isHidden = isHide
    }
    
    func hideViewScreen(isHide: Bool)  {
        self.btnSearchLocation?.isHidden = isHide
        self.viewDeliveryAds?.isHidden = true//isHide
        self.viewDeliveryList?.isHidden = isHide
        self.viewStoreAds?.isHidden = isHide
        self.viewStoreList?.isHidden = isHide
    }
    
    func setUpCartView()  {
        viewCartContainer?.isHidden = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.onClickBtnCart(_:)))
        gestureRecognizer.delegate = self
        viewCartContainer?.addGestureRecognizer(gestureRecognizer)
    }
    
    func setItemCountInBasket() {
        var numberOfItems = 0
        for cartProduct in currentBooking.cart {
            numberOfItems = numberOfItems + (cartProduct.items?.count)!
        }
        currentBooking.totalItemInCart = numberOfItems
        lblCartQuantity?.text = String(currentBooking.totalItemInCart)
        if numberOfItems > 0 {
            if self.deliveryListLength > 0 {
                viewCartContainer?.isHidden = false
            } else {
                viewCartContainer?.isHidden = true
            }
        } else {
            viewCartContainer?.isHidden = true
        }
    }

    //MARK: - Dialogs
    func openFilterStoreDialog() {
        guard let selectedDeliveryItem = selectedDeliveryItem else {
            return
        }
        let dialogForFilter = CustomFilterDialog.showCustomFilterDialog(title: "TXT_FILTERS".localized, message: "".localized, titleLeftButton: "TXT_APPLY".localized, titleRightButton: "TXT_CLEAR".localized, editTextOneHint: "TXT_PHONE".localized, editTextTwoHint: "", isEdiTextTwoIsHidden: true, selectedDeliveryItem: selectedDeliveryItem,originalStoreList: self.originalArrStoreList)
        dialogForFilter.onClickLeftButton = {
            (arrList:Array<StoreItem>?) in
            dialogForFilter.removeFromSuperview()
            self.isFilterApply = true
            DispatchQueue.main.async {
                let offSetY = self.stackViewStoreList!.frame.origin.y + self.viewStoreList!.frame.origin.y
                if self.scrollView.contentSize.height - self.scrollView!.frame.size.height > offSetY  {
                    self.scrollView.setContentOffset(CGPoint(x: self.scrollView.contentOffset.x, y: offSetY), animated: true)
                } else {
                    self.scrollView.setContentOffset(CGPoint(x: self.scrollView.contentOffset.x, y: self.scrollView.contentSize.height - self.scrollView!.frame.size.height), animated: true)
                }
            }
            //self.scrollView.scrollToView(view: self.viewStoreList ?? UIView(), animated: true)
            self.reloadTableWithArray(array: arrList)
        }
        dialogForFilter.onClickRightButton = {
            dialogForFilter.removeFromSuperview()
        }
        dialogForFilter.onClickClearButton = {
            self.isFilterApply = false
            self.reloadTableWithArray(array: self.originalArrStoreList)
        }
    }
    
    func openTableBookingDialog(storeID:String) {
        let dialogForFilter = CustomTableBookingDialog.showCustomTableBookingDialog(title: "text_table_reservation".localized, titleRightButton: "btn_reserve_a_table".localized, storeID: storeID)
        dialogForFilter.onClickLeftButton = {
            currentBooking.clearTableBooking()
            dialogForFilter.removeFromSuperview()
        }
        dialogForFilter.onClickRightButton = {
            if currentBooking.bookingType == 2 {
                self.goToProductVC()
            } else {
                var mainView: UIStoryboard!
                mainView = UIStoryboard(name: "Cart", bundle: nil)
                if let invoiceVC:InvoiceVC = mainView.instantiateViewController(withIdentifier: "InvoiceVC") as? InvoiceVC {
                    self.navigationController?.pushViewController(invoiceVC, animated: true)
                }
            }
            dialogForFilter.removeFromSuperview()
        }
    }
    
    //MARK: - WEB SERVICE CALLS
    func wsGetCart() {
        let dictParam: [String:Any] = APPDELEGATE.getCommonDictionary()
        print(dictParam)
        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_GET_CART, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            currentBooking.clearCart()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                CurrentBooking.shared.PushNotification = false
                print("CurrentBooking.shared.logout = ",CurrentBooking.shared.PushNotification)
            }
            if Parser.parseCart(response) {
                self.setItemCountInBasket()
                if currentBooking.deliveryType == DeliveryType.tableBooking {
                    APPDELEGATE.wsClearCart {
                        self.setItemCountInBasket()
                    }
                }
            }
        }
    }
    
    func wsGetDeliveriesInNearestCity(parameter:Dictionary<String,Any>) {
        print("WS_GET_NEAREST_DELIVERY_LIST \(parameter)")
        print(Utility.convertDictToJson(dict: parameter))
        Utility.showLoading()
        
        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url:WebService.WS_GET_NEAREST_DELIVERY_LIST, methodName: AlamofireHelper.POST_METHOD, paramData: parameter) { (response, error) -> (Void) in
            print("WS_GET_NEAREST_DELIVERY_LIST response homevc \(response)")
            Utility.hideLoading()
            if Parser.parseDeliveryStore(response) {
                DispatchQueue.main.async {
                    self.deliveryListLength = (currentBooking.deliveryStoreList.count)
                    if (self.parent as? MainVC)?.cvForHome.isHidden == false{
                        (self.parent as? MainVC)?.updateTitle()
                    }
                    self.viewDeliveryAds?.isHidden = true//(currentBooking.deliveryAdsList?.count ?? 0 > 0) ? (false) : (true)
                    self.collViewDeliveryList?.reloadData()
                    self.configureHeaderView()
                    self.imgEmpty?.isHidden = true
                    self.lblEmpty?.isHidden = true
                    self.btnSearchLocation?.isHidden = true
                    
                    if self.deliveryListLength > 0 {
                        self.checkForStoreList()
                        self.checkForPromoCodeList()
                    }
                    self.setItemCountInBasket()
                }
            } else {
                DispatchQueue.main.async {
                    self.hideViewScreen(isHide: true)
                    self.imgEmpty?.isHidden = false
                    self.lblEmpty?.isHidden = false
                    self.btnSearchLocation?.isHidden = false
                    self.viewCartContainer?.isHidden = true
                }
            }
            self.goToProductScreen()
        }
    }
    
    func wsGetStoreList(storeDeliveryId:String, isNeedMoreData: Bool = false) {
        if !storeDeliveryId.isEmpty {
            if selectedDeliveryItem?.is_provide_table_booking ?? false {
                newList = [["store_filter_delivery".localized, false],["store_filter_takeaway".localized, false],["store_filter_book_a_table".localized, false]]
                if let perent = self.parent as? MainVC {
                    perent.viewQrCodeScan.isHidden = false
                }
            } else {
                newList = [["store_filter_delivery".localized, false],["store_filter_takeaway".localized, false]]
                if let perent = self.parent as? MainVC {
                    perent.viewQrCodeScan.isHidden = true
                }
            }
            collViewNewList?.reloadData()
            
            (self.isChangeInFavorite) ? () : Utility.showLoading()
            let dictParam: Dictionary<String,Any> = [PARAMS.STORE_DELIVERY_ID:storeDeliveryId,
                                                     PARAMS.CITY_ID :currentBooking.bookCityId ?? "",
                                                     PARAMS.USER_ID:preferenceHelper.getUserId(),
                                                     PARAMS.IPHONE_ID:preferenceHelper.getRandomCartID(),
                                                     PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken(),
                                                     PARAMS.LATITUDE:currentBooking.currentLatLng[0],
                                                     PARAMS.LONGITUDE:currentBooking.currentLatLng[1],
                                                     PARAMS.PAGE:CONSTANT.CURRENT_PAGE,
                                                     PARAMS.PER_PAGE: CONSTANT.STORE_PER_PAGE
            ]
            print("WebService.WS_GET_STORELIST \(Utility.convertDictToJson(dict: dictParam))")
            
            let afn:AlamofireHelper = AlamofireHelper.init()
            afn.getResponseFromURL(url: WebService.WS_GET_STORELIST, methodName: "POST", paramData: dictParam) { [weak self] (response, error) -> (Void) in
                print("self.originalArrStoreList API \(Utility.convertDictToJson(dict: response as! Dictionary<String, Any>))")
                Utility.hideLoading()
                guard let self = self else { return }
                print(response)
                if Parser.isSuccess(response: response) {
                    let storeResponse:StoreResponse = StoreResponse.init(dictionary: response)!
                    print(Utility.convertDictToJson(dict: response as! Dictionary<String, Any>))
                    
                    self.pickupArrStoreList.removeAll()
                    self.deliveryArrStoreList.removeAll()
                    self.bookTableArrStoreList.removeAll()
                    self.arrForAddList.removeAll()
                    self.arrForAddList = storeResponse.ads
                    self.viewStoreAds?.isHidden = !(storeResponse.ads.count > 0)
                    self.totalStoreCount = storeResponse.stores?.count ?? 0
                    //self.originalArrStoreList = Parser.parseStoreList(response)

                    if isNeedMoreData {
                        let tempArrStoreList = Parser.parseStoreList(response)
                        for store:StoreItem in tempArrStoreList! {
                            self.originalArrStoreList?.append(store)
                        }
                    } else {
                        self.originalArrStoreList = Parser.parseStoreList(response)
                    }

                    if (self.originalArrStoreList != nil) {
                        self.storeListLength = storeResponse.stores?.results?.count
                    }

                    if self.originalArrStoreList?.isEmpty ?? true {
                        self.viewStoreList?.isHidden = true
                    } else {
                        self.viewStoreList?.isHidden = false
                    }

                    DispatchQueue.main.async {
                        self.reloadTableWithArray(array: self.originalArrStoreList)
                    }

                    self.configureHeaderView()
                    self.scrollView?.scrollsToTop = true
                } else {
                    self.isDeliveryChanged = false
                    self.viewStoreAds?.isHidden = true
                    self.viewStoreList?.isHidden = true
                }
                if self.imgStoreEmpty != nil {
                    self.imgStoreEmpty.isHidden = !(self.viewStoreList?.isHidden ?? false)
                }
            }
        } else {
            Utility.hideLoading()
            self.isDeliveryChanged = false
            self.viewStoreAds?.isHidden = true
            self.viewStoreList?.isHidden = true
            self.imgStoreEmpty.isHidden = !(self.viewStoreList?.isHidden ?? false)
        }
    }
    
    func wsGetPromoCodeList() {
        let dictParam: Dictionary<String,Any> = [
            PARAMS.DELIVERY_ID:selectedDeliveryItem?._id ?? "",
            PARAMS.CITY_ID: currentBooking.bookCityId ?? ""
        ]
        print(Utility.convertDictToJson(dict: dictParam))
        
        Utility.showLoading()
        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url:WebService.WS_GET_PROMO_CODE_LIST, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { [self] (response, error) -> (Void) in
            print("WS_GET_PROMO_CODE_LIST response homevc \(response)")
            print(dictParam)
            Utility.hideLoading()
            if Parser.isSuccess(response: response) {
                let promoListResponse:PromoCodeListResponse = PromoCodeListResponse.init(dictionary: response)!
                print(response)
                self.arrPromoCodeList = Parser.parsePromoCodeList(response)
                IS_PROMOCODE_AVAILABLE = (promoListResponse.isPromoAvailable ?? false) ? true : false
                if promoListResponse.isPromoAvailable ?? false {
                    self.viewForOffers?.isHidden = ((self.arrPromoCodeList?.count ?? 0) > 0) ? false : true
                    self.collViewOffers?.isHidden = ((self.arrPromoCodeList?.count ?? 0) > 0) ? false : true
                    self.viewForOffers?.updateConstraints()
                    self.collViewOffers?.updateConstraints()
                } else {
                    self.viewForOffers?.isHidden = true
                }
                
                DispatchQueue.main.async {
                    self.collViewOffers?.reloadData()
                }
            }
        }
    }
    
    func wsGetPromoDetail(promoId:String) {
        Utility.showLoading()
        let dictParam: Dictionary<String,Any> = [
            PARAMS.PROMO_ID:promoId,
        ]
        print(dictParam)
        
        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_GET_PROMO_DETAIL, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response,error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response) {
                print("WS_GET_PROMO_DETAIL response \(Utility.convertDictToJson(dict: response as! Dictionary<String, Any>))")
                if (Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true)) {
                    let promoDetail:PromoCodeDetail = PromoCodeDetail.init(fromDictionary: response as! [String : Any])
                    if promoDetail.promoCodes.count > 0{
                        self.openOffersDialog(arrPromoCodes: promoDetail.promoCodes)
                    }
                } else {}
            } else {}
        }
    }
    
    func openOffersDialog(arrPromoCodes:Array<PromoCodeModal>)  {
        let dialogProductFilter = CustomOffersDialog.showOffers(title: "Offers", message: "", arrPromoCodes: arrPromoCodes, isFromHome: true)
        dialogProductFilter.onClickLeftButton = {
            dialogProductFilter.removeFromSuperview()
        }
    }
    
    func goToProductScreen() {
        if !currentBooking.selectedBranchIoStore.isEmpty {
            self.goToProductVC(storeID: currentBooking.selectedBranchIoStore)
            return
        }
        if currentBooking.deliveryStoreList.count > 0 {
            if currentBooking.deliveryStoreList[0].deliveryType != DeliveryType.courier {
                if currentBooking.deliveryStoreList.count == 1 {
                    //viewDeliveryList?.isHidden = true
                } else {
                    //viewDeliveryList?.isHidden = false
                    self.containerForStoreVC.isHidden = true
                }
            }
        }
    }
    
    func checkForStoreList(selectedIndex: Int = 0) {
        CONSTANT.CURRENT_PAGE = 1
        var findObjForStore: DeliveriesItem?
        if currentBooking.deliveryStoreList.count > 0 {
            for obj in currentBooking.deliveryStoreList {
                if obj.deliveryType == DeliveryType.store {
                    findObjForStore = obj
                    break
                }
            }
            if selectedIndex == 0 && currentBooking.deliveryStoreList[0].deliveryType == DeliveryType.courier {
                if findObjForStore != nil {
                    self.selectedDeliveryItem = findObjForStore!
                    self.wsGetStoreList(storeDeliveryId: selectedDeliveryItem?._id ?? "")
                }
            } else {
                if currentBooking.deliveryStoreList.count > 0 {
                    self.selectedDeliveryItem = currentBooking.deliveryStoreList[selectedIndex]
                }
                if let selectedDeliveryItem = selectedDeliveryItem {
                    if selectedDeliveryItem.deliveryType != DeliveryType.courier {
                        self.wsGetStoreList(storeDeliveryId: selectedDeliveryItem._id ?? "")
                    }
                }
            }
        }
        if findObjForStore == nil {
            self.isDeliveryChanged = false
            self.viewStoreAds?.isHidden = true
            self.viewStoreList?.isHidden = true
        }
        collViewDeliveryList?.reloadData()
    }
    
    func checkForPromoCodeList(selectedIndex: Int = 0) {
        if !(selectedDeliveryItem?._id ?? "").isEmpty() {
            self.wsGetPromoCodeList()
        }
    }
    
    func reloadTableWithArray(array:Array<StoreItem>?) {
        if let finalArray = array {
            finalFilteredArray.removeAll()
            for storeItem in finalArray {
                finalFilteredArray.append(storeItem)
            }
        }
        
        if finalFilteredArray.count == 0 {
            self.isDeliveryChanged = false
            Utility.showToast(message: "ERROR_CODE_561".localized, endEditing: false)
        } else {
            if self.isDeliveryChanged {
                self.isDeliveryChanged = false
                //self.scrollView.scrollToView(view:self.collViewStoreList!, animated: true)
                DispatchQueue.main.async {
                    let offSetY = self.stackViewStoreList!.frame.origin.y + self.viewStoreList!.frame.origin.y
                    if self.scrollView.contentSize.height - self.scrollView!.frame.size.height > offSetY  {
                        self.scrollView.setContentOffset(CGPoint(x: self.scrollView.contentOffset.x, y: offSetY), animated: true)
                    } else {
                        if  self.scrollView.contentSize.height > self.scrollView.frame.size.height {
                            self.scrollView.setContentOffset(CGPoint(x: self.scrollView.contentOffset.x, y: self.scrollView.contentSize.height - self.scrollView!.frame.size.height), animated: true)
                        }
                    }
                }
            }
        }

        self.collViewStoreAds?.reloadData()
        self.collViewStoreList?.reloadData()
        self.heightForStoreList?.constant = collViewStoreList?.collectionViewLayout.collectionViewContentSize.height ?? 0
        self.collViewNewList?.reloadData()
    }
    
    fileprivate func searchStore(_ mySearchText: String) {
        if mySearchText.isEmpty() {
            if isFilterApply {
                self.reloadTableWithArray(array: filteredArrStoreList)
            } else {
                self.reloadTableWithArray(array: originalArrStoreList)
            }
        } else {
            let tempArray:Array<StoreItem> = (isFilterApply ? filteredArrStoreList:originalArrStoreList) ?? []
            var tempFiltereArray:Array<StoreItem> = []
            for storesItem:StoreItem in tempArray {
                if (storesItem.name?.lowercased().contains(mySearchText.lowercased()))! {
                    tempFiltereArray.append(storesItem)
                }
            }
            self.reloadTableWithArray(array: tempFiltereArray)
        }
    }

    //MARK: - SET DATA FOR THE DELIVERY
    func setDataForTheDelivery() {
        switch(CLLocationManager.authorizationStatus()) {
        case .notDetermined, .restricted, .denied:
            if CommonFunctions.fetchLocationFromDB(vc: self) {} else {
                if (currentBooking.deliveryStoreList.isEmpty) && (currentBooking.selectedBranchIoStore.isEmpty) {
                    (self.parent as? MainVC)?.onClickBtnNavigation(self)
                } else {
                    self.goToProductScreen()
                }
            }
        case .authorizedAlways, .authorizedWhenInUse:
            break
        }
    }
    
    @objc func locationUpdate(_ ntf: Notification = Common.defaultNtf) {
        if self.isVisible {
            if !CommonFunctions.fetchLocationFromDB(vc: self){
                guard let userInfo = ntf.userInfo else { return }
                guard let location = userInfo[Common.locationKey] as? CLLocation else { return }
                print("locationUpdate: \(location)")
                
                let latitude = location.coordinate.latitude
                let longitude = location.coordinate.longitude
                
                self.locationManager?.getAddressFromLatLong(latitude: latitude, longitude: longitude)
                currentBooking.currentAddress = currentBooking.currentSendPlaceData.address
                currentBooking.currentLatLng = [currentBooking.currentSendPlaceData.latitude, currentBooking.currentSendPlaceData.longitude]
                
                if ((currentBooking.currentCity ?? "" != currentBooking.currentSendPlaceData.city1) || (currentBooking.bookCityId?.isEmpty()) ?? true) {
                    let dictionary: [String:Any] = currentBooking.currentSendPlaceData.toDictionary()
                    print("wsGetDeliveriesInNearestCity Homevc : \(dictionary)")
                    CommonFunctions.addLocationToLocalDB()
                    self.wsGetDeliveriesInNearestCity(parameter: dictionary)
                } else {
                    Utility.hideLoading()
                    self.goToProductScreen()
                }
            }
        }
        LocationCenter.default.stopUpdatingLocation()
    }
    
    @objc func locationFail(_ ntf: Notification = Common.defaultNtf) {
        guard let userInfo = ntf.userInfo else { return }
        guard let error = userInfo[Common.locationErrorKey] as? Error else { return }
        print("locationFail: \(error)")
        
        Utility.showToast(message: "MSG_LOCATION_NOT_GETTING".localized)
        Utility.hideLoading()
        self.goToProductScreen()
        (self.parent as! MainVC).onClickBtnNavigation(self)
        
    }

    //MARK: - NAVIGATION METHODS
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier?.compare(SEGUE.SEGUE_STORE_LIST) == ComparisonResult.orderedSame) {
            let myStoreVC:StoreVC = segue.destination as! StoreVC
            myStoreVC.currentDeliveryItem = selectedDeliveryItem
            myStoreVC.isShowGroupItems = selectedDeliveryItem!.is_store_can_create_group!
        }
        if (segue.identifier?.compare(SEGUE.SEGUE_STORE_FRAGMENT_VC) == ComparisonResult.orderedSame) {}
    }
}

//MARK:- Collection Data Source and delegate
extension HomeVC:UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    /*Header Configuration for advertise ment*/
    func configureHeaderView() {
        if ((currentBooking.deliveryAdsList?.count) ?? 0)  >  0 {
            viewForHeader?.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width/1.75)
            if heightForHeader != nil {
                heightForHeader.constant = view.frame.width/1.75
            }
            viewForHeader?.isHidden = false
            collectionView?.reloadData()
            pgControl?.currentPage = 0
            self.lblAddDetail?.text = currentBooking.deliveryAdsList?[0].adsDetail
            if ((currentBooking.deliveryAdsList?.count)! > 1) {
            }
        } else {
            if heightForHeader != nil {
                heightForHeader.constant = 0
            }
            viewForHeader?.isHidden = true
            viewForHeader?.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 0)
        }
        pgControl?.numberOfPages = (currentBooking.deliveryAdsList?.count) ?? 0
    }
    
    //MARK:- UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collViewOffers {
            return (arrPromoCodeList?.count) ?? 0
        } else if collectionView == self.collectionView {
            return (currentBooking.deliveryAdsList?.count) ?? 0
        } else if collectionView == self.collViewDeliveryList {
            return currentBooking.deliveryStoreList.count
        } else if collectionView == self.collViewStoreAds {
            return (arrForAddList.count)
        } else if collectionView == self.collViewNewList {
            return (newList.count)
        } else {
            return finalFilteredArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collViewOffers {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdvertiseCell", for: indexPath) as! AdvertiseCell
            
            cell.bannerImageView.contentMode = .scaleAspectFit
            cell.bannerImageView.downloadedFrom(link: Utility.getDynamicResizeImageURL(width: cell.frame.width, height: cell.frame.height, imgUrl: (arrPromoCodeList?[indexPath.row].imageUrl) ?? ""), placeHolder: "no_offer", isFromResize: true)
            return cell
            
        } else if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdvertiseCell", for: indexPath) as! AdvertiseCell
            
            cell.bannerImageView.contentMode = .scaleAspectFit
            cell.bannerImageView.downloadedFrom(link: Utility.getDynamicResizeImageURL(width: cell.bannerImageView.frame.width, height: cell.bannerImageView.frame.height, imgUrl: (currentBooking.deliveryAdsList?[indexPath.row].imageForBanner) ?? ""),placeHolder: "no_ads", isFromResize: true)
            cell.bannerImageView.contentMode = .scaleAspectFill
            return cell
            
        } else if collectionView == self.collViewDeliveryList {
            let cell:DeliveryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DeliveryCell", for: indexPath) as! DeliveryCell
            if currentBooking.deliveryStoreList.count > indexPath.row {
                let currentItem:DeliveriesItem = currentBooking.deliveryStoreList[indexPath.row]
                cell.setCellData(cellItem: currentItem)
                if selectedDeliveryItem?._id == currentItem._id && currentItem.deliveryType != DeliveryType.courier {
                    cell.lblName.textColor = UIColor.themeColor
                }
                else {
                    cell.lblName.textColor = UIColor.themeTextColor
                }
                cell.layoutIfNeeded()
            }
            return cell
            
        } else if collectionView == collViewStoreAds {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdvertiseCell", for: indexPath) as! AdvertiseCell
            cell.bannerImageView.contentMode = .scaleAspectFit
            cell.bannerImageView.downloadedFrom(link:Utility.getDynamicResizeImageURL(width: cell.bannerImageView.frame.width, height: cell.bannerImageView.frame.height, imgUrl: (arrForAddList[indexPath.row].imageForBanner) ?? ""), placeHolder: "no_ads" , isFromResize: true)
            return cell
            
        } else if collectionView == collViewNewList {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TableBookCell", for: indexPath) as! TableBookCell
            cell.setData(labelTitle: newList[indexPath.row])
            return cell
            
        } else {
            let cell:StoreCell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreCell", for: indexPath) as! StoreCell
            let currentStore:StoreItem = finalFilteredArray[indexPath.row]
            cell.setCellData(cellItem: currentStore)
            return cell
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == self.collViewStoreList{
            let visibleIndexPaths = collViewStoreList!.indexPathsForVisibleItems
            print(visibleIndexPaths)
            let sec = collectionView.numberOfSections - 1
            let it = collectionView.numberOfItems(inSection: sec) - 1
            if indexPath.section == sec && indexPath.row == it && (self.totalStoreCount >= self.storeListLength ?? 0) {
                print("willDisplay \(indexPath.item)")
            }
        } else if collectionView == self.collViewDeliveryList {
            if let cell = cell as? DeliveryCell {
                cell.lblName.restartLabel()
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            if CGRect(origin: self.scrollView.contentOffset, size: self.scrollView.bounds.size).maxY >= CGRect(origin: collViewStoreList!.contentOffset, size: collViewStoreList!.bounds.size).maxY {
                if (self.totalStoreCount > self.originalArrStoreList?.count ?? 0) && storeListLength! != 0 {
                    apicallCount = apicallCount + 1
                    CONSTANT.CURRENT_PAGE = CONSTANT.CURRENT_PAGE + 1
                    self.wsGetStoreList(storeDeliveryId: selectedDeliveryItem?._id ?? "", isNeedMoreData: true)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if collectionView == self.collViewOffers {
            guard let promoId = (arrPromoCodeList?[indexPath.item])?.id else { return  }
            self.wsGetPromoDetail(promoId: promoId)
        } else if collectionView == self.collectionView {
            if currentBooking.deliveryAdsList![indexPath.row].isAdsRedirectToStore{
                let storeId:String = (currentBooking.deliveryAdsList![indexPath.item].storeId)
                if (storeId.isEmpty()) {
                } else {
                    selectedStoreItem = currentBooking.deliveryAdsList![indexPath.item].store_detail
                    currentBooking.isSelectedStoreClosed = (selectedStoreItem?.isStoreClosed)!
                    currentBooking.selectedStore = selectedStoreItem!
                    indC = indexPath.item
                    self.goToProductVC(storeID: storeId)
                }
            }
        } else if collectionView == self.collViewDeliveryList {
            isTableBooking = false
            lastSelectedDeliveryIndex = indexPath.item
            selectedDeliveryItem = currentBooking.deliveryStoreList[indexPath.row]
            if selectedDeliveryItem!.deliveryType == DeliveryType.courier {
                if preferenceHelper.getUserId().isEmpty {
                    Utility.showToast(message: "TXT_NEED_LOGIN_FOR_COURIER".localized)
                } else {
                    currentBooking.courierDeliveryId = (selectedDeliveryItem?._id) ?? ""
                    self.performSegue(withIdentifier: SEGUE.SEGUE_COURIER, sender: nil)
                }
            } else {
                self.originalArrStoreList = []
                self.isDeliveryChanged = true
                checkForStoreList(selectedIndex: indexPath.item)
            }
            selectedDeliveryItem = currentBooking.deliveryStoreList[indexPath.row]
            self.checkForPromoCodeList()
        } else if collectionView == self.collViewStoreAds {
            if self.arrForAddList[indexPath.item].isAdsRedirectToStore {
                let storeId:String = self.arrForAddList[indexPath.row].storeId
                if (storeId.isEmpty()) {
                } else {
                    selectedStoreItem = self.arrForAddList[indexPath.item].store_detail
                    currentBooking.isSelectedStoreClosed = (selectedStoreItem?.isStoreClosed)!
                    currentBooking.selectedStore = selectedStoreItem!
                    self.goToProductVC(storeID: storeId)
                }
            }
        } else if collectionView == self.collViewStoreList {
            selectedStoreItem = finalFilteredArray[indexPath.row]
            currentBooking.isSelectedStoreClosed = (selectedStoreItem?.isStoreClosed)!
            currentBooking.selectedStore = selectedStoreItem!
            if isTableBooking {
                self.openTableBookingDialog(storeID: selectedStoreItem?._id ?? "")
            } else {
                self.goToProductVC()
            }
        } else if collectionView == collViewNewList {
            print(newList[indexPath.row])
            isTableBooking = false
            for (index, _) in newList.enumerated() {
                newList[index][1] = false
            }
            newList[indexPath.row][1] = true
            collViewNewList?.reloadData()
            
            if indexPath.row == 0 {
                self.reloadTableWithArray(array: self.originalArrStoreList ?? [])
            } else if indexPath.row == 1 {
                self.pickupArrStoreList.removeAll()
                for store:StoreItem in self.originalArrStoreList ?? [] {
                    if store.isProvidePickupDelivery {
                        self.pickupArrStoreList.append(store)
                    }
                }
                self.reloadTableWithArray(array: pickupArrStoreList)
            } else {
                isTableBooking = true
                self.bookTableArrStoreList.removeAll()
                for store:StoreItem in self.originalArrStoreList ?? [] {
                    if store.isTableReservation || store.isTableReservationWithOrder {
                        self.bookTableArrStoreList.append(store)
                    }
                }
                self.reloadTableWithArray(array: bookTableArrStoreList)
            }
        }
    }
    
    func goToProductVC(storeID:String = "") {
        timerForAdd?.invalidate()
        
        let productVc : ProductVC = ProductVC.init(nibName: "Product", bundle: nil)
        
        if storeID.isEmpty {} else {
            productVc.selectedStoreId = storeID
        }
        
        productVc.isFromDeliveryList = true
        productVc.selectedDelivery = selectedDeliveryItem
        if currentBooking.deliveryStoreList.count > 0 {
            productVc.isShowGroupItems = currentBooking.deliveryStoreList[0].is_store_can_create_group!
        }
        productVc.selectedStore = self.selectedStoreItem
        
        var isIndexMatch : Bool = false
        var selectedInd : Int = 0
        
        if preferenceHelper.getSelectedLanguageCode() != Constants.selectedLanguageCode {
            Constants.selectedLanguageCode = preferenceHelper.getSelectedLanguageCode()
        }
        
        if storeID.isEmpty {
            if currentBooking.selectedStore != nil {
                for obj in currentBooking.selectedStore!.langItems! {
                    if (obj.code == Constants.selectedLanguageCode) && (obj.is_visible! == true) {
                        isIndexMatch = true
                        selectedInd = currentBooking.selectedStore!.langItems!.firstIndex(where: { $0.code == obj.code })!
                        break
                    } else {
                        isIndexMatch = false
                    }
                }
            }
        } else {
            if self.selectedStoreItem != nil {
                for obj in self.selectedStoreItem!.langItems! {
                    if obj.code == Constants.selectedLanguageCode {
                        isIndexMatch = true
                        selectedInd = self.selectedStoreItem!.langItems!.firstIndex(where: { $0.code == obj.code })!
                        break
                    } else {
                        isIndexMatch = false
                    }
                }
            }
        }
        
        if !isIndexMatch {
            if self.selectedStoreItem != nil {
                productVc.languageCode = selectedStoreItem!.langItems![0].code!
                productVc.languageCodeInd = "0"
            } else {
                productVc.languageCode = "en"
                productVc.languageCodeInd = "0"
            }
        } else {
            productVc.languageCode = Constants.selectedLanguageCode
            productVc.languageCodeInd = "\(selectedInd)"
        }

        self.navigationController?.pushViewController(productVc, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collViewOffers {
            if UIDevice.current.userInterfaceIdiom == .pad {
                let height = collectionView.frame.size.height-80.0
                let width = height*1.25
                return CGSize(width: width, height: height)
            } else {
                let height = 100.0
                let width = height*1.25
                print("Offers size",width,height)
                return CGSize(width: width, height: height)
            }
        } else if collectionView == self.collectionView {
            if UIDevice.current.userInterfaceIdiom == .pad {
                let height = collectionView.frame.size.height-80.0
                let width = height*1.25
                return CGSize(width: width, height: height)
            } else {
                let height = 120.0
                let width = height*1.25
                print("Delivery Ads size",width,height)
                return CGSize(width: width, height: height)
            }
        } else if collectionView == self.collViewDeliveryList {
            if UIDevice.current.userInterfaceIdiom == .pad {
                var width = collectionView.frame.size.width
                width -= collectionView.frame.origin.x
                width = width/3
                let height  = width*1.25
                return CGSize(width: width, height: height)
            } else {
                let width = 100.0
                let height = width*1.25
                print("Delivery List size",width,height)
                return CGSize(width: width, height: height)
            }
        } else if collectionView == self.collViewStoreAds {
            if UIDevice.current.userInterfaceIdiom == .pad {
                let height = collectionView.frame.size.height-80.0
                let width = height*1.25
                return CGSize(width: width, height: height)
            } else {
                let height = 120.0
                let width = height*1.25
                print("Store ads size",width,height)
                return CGSize(width: width, height: height)
            }
        } else if collectionView == self.collViewStoreList {
            var width:CGFloat = 0.0
            var height:CGFloat = 0.0
            if UIDevice.current.userInterfaceIdiom == .pad {
                width = collectionView.frame.size.width
                width -= (collectionView.contentInset.left+collectionView.contentInset.right)
                width -= 50.0
                width = width/2.0
                height =  width*0.8
            } else {
                width = collectionView.frame.size.width
                width -= (collectionView.contentInset.left+collectionView.contentInset.right)
                width -= 30.0
                width = width/2.0
                height =  width/0.8
            }
            if height < 230 {
                height = 230
            }
            return CGSize(width: width, height: height)
        } else {
            let labelTitle:[Any] = newList[indexPath.row]
            let label = UILabel(frame: .zero)
            label.text = labelTitle.first as? String ?? ""
            label.sizeToFit()
            return CGSize(width:label.frame.width, height:collViewNewList?.frame.height ?? 40)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView != self.collViewNewList {
            return 10.0
        } else {
            return 0.0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == collViewStoreList || collectionView == collViewOffers {
            return UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
        } else {
            return UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 0.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

extension HomeVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let mySearchText = string.trimmingCharacters(in: .whitespaces)
        let string1 = mySearchText
        let string2 = textField.text
        var finalString = ""

        if string.count > 0 {
            finalString = string2! + string1
        } else if string2?.count ?? 0 > 0 {
            finalString = String(string2!.dropLast())
        }

        searchStore(finalString)
        return true
    }
}

class AdvertiseCell: CustomCollectionCell {
    
    @IBOutlet weak var bannerImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layoutIfNeeded()
        bannerImageView.setRound(withBorderColor: UIColor.clear, andCornerRadious:8.0, borderWidth: 0.5)
        self.setRound(withBorderColor: UIColor.clear, andCornerRadious:8.0, borderWidth: 0.5)
    }
}
