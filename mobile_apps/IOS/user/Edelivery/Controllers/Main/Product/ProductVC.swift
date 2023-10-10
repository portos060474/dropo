//
//  ProductVC.swift
//  edelivery
//
//  Created by Elluminati on 09/03/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class ProductVC: BaseVC,UINavigationBarDelegate,UIScrollViewDelegate, LeftDelegate , UIGestureRecognizerDelegate,refreshCartBadgeDelegate {

    @IBOutlet weak var imgStore: UIImageView!
    @IBOutlet weak var lblReopenAt: UILabel!
    @IBOutlet weak var lblClosed: UILabel!
    @IBOutlet var lblStoreName: UILabel!
    @IBOutlet var lblEstimateTime: UILabel!
    @IBOutlet var lblRate: UILabel!
    @IBOutlet var lblPriceRate: UILabel!
    @IBOutlet weak var lblPriceLevel: UILabel!
    @IBOutlet weak var lblSeperator1: UILabel!
    @IBOutlet weak var lblSeperator2: UILabel!
    @IBOutlet weak var lblCartQuantity: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgProductHeader: UIImageView!
    @IBOutlet weak var lblProductNameHeader: UILabel!
    @IBOutlet weak var viewForImageHeader: UIView!
    @IBOutlet weak var collVHeader: UICollectionView!
    @IBOutlet weak var btnGotoCartHeight: NSLayoutConstraint!
    @IBOutlet weak var imgTopConstraints: NSLayoutConstraint!
    @IBOutlet weak var navigationHeight: NSLayoutConstraint!
    @IBOutlet weak var categoryInfoViewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewForClosedStore: UIView!
    @IBOutlet weak var viewForSearchOverlay: UIView!
    @IBOutlet weak var viewForSearchItem: UIView!
    @IBOutlet weak var viewForHeader: UIView!
    @IBOutlet weak var viewForNavigation: UIView!
    @IBOutlet weak var viewForNavigationGradient: UIView!
    @IBOutlet var viewForStore: UIView!
    @IBOutlet weak var searchBarItem: UISearchBar!
    @IBOutlet weak var tblForSearchItem: UITableView!
    @IBOutlet weak var tblForProduct: UITableView!
    @IBOutlet weak var collVForProduct: UICollectionView!
    @IBOutlet weak var btnReviewStore: UIButton!
    @IBOutlet weak var btnSearchFilter: UIButton!
    @IBOutlet weak var btnApplySearch: UIButton!
    @IBOutlet weak var btnFav: UIButton!
    @IBOutlet weak var btnGoToCart: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tableTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionVTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewCartContainer: UIView!
    @IBOutlet weak var lblCartText: UILabel!
    @IBOutlet weak var viewRatingContainer: UIView!
    @IBOutlet weak var lblDivider1: UILabel!
    @IBOutlet weak var lblDivider2: UILabel!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var imgProductFilter: UIImageView!
    @IBOutlet weak var imgReview: UIImageView!
    @IBOutlet weak var lblSeperator2Height: NSLayoutConstraint!
    @IBOutlet weak var viewProductGroupTop: NSLayoutConstraint!
    @IBOutlet weak var viewProductGroupBottom: NSLayoutConstraint!
    @IBOutlet weak var reviewWhiteIcon: UIImageView!
    @IBOutlet weak var vwBookTable: UIView!
    @IBOutlet weak var btnBookTable: UIButton!

    var cartButton:MyBadgeButton? = nil
    var reviewButton:UIButton? = nil
    var statusBarHeight:CGFloat = 20.0
    var barHeight: CGFloat = 44.0
    weak var timerForStore:Timer? = nil
    var tapGesture:UITapGestureRecognizer?
    var viewForPopup:UIView?
    var selecetedProduct:ProductItem? = nil
    var arrProductList:Array<ProductItem>? = nil
    var arrProductItemList:Array<ProductItemsItem>? = nil
    var filteredArrProductItemList:Array<ProductItem> = []
    var productItemListLength:Int? = 0
    var productListLength:Int? = 0
    var selectedProductItem:ProductItemsItem? = nil
    var arrProductGroupList = [ProductGroupModel]()
    var arrProductids = [String]()
    var selectedStore:StoreItem? = nil
    var selectedStoreId:String? = nil
    var selectdedImage:UIImageView?
    var selectdedCellView:UIView?
    var isStoreOpen:Bool = true
    var isFromDeliveryList:Bool = false
    var isShowGroupItems:Bool = false
    var selectedProductIDHeader : String = ""
    var selectedindexPathProductHeader = IndexPath(item: 0, section: 0)
    var count:Int = 1
    var newImage: UIImage!
    let transition = CustomAnimator.init(duration: TimeInterval.init(0.3), isPresenting: true)
    var tableViewContentHeight: CGFloat = 0
    var isFilterViewVisible = true
    var isFromUpdateOrder: Bool = false
    var editOrderType: Int = 1
    var arrEditOrders = [CartProduct]()
    var languageCode : String = "en"
    var languageCodeInd : String = "1"
    var onClickRightButton : (() -> Void)? = nil
    var onClickClearButton : (() -> Void)? = nil
    var selectedDelivery: DeliveriesItem?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if LocalizeLanguage.isRTL {
            btnBack.setImage( btnBack.image(for: .normal)?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)
        }

        currentBooking.selectedBranchIoStore = ""
        if isShowGroupItems {
            self.btnSearchFilter.isHidden = true
            self.collVForProduct.isHidden = false
        } else {
            self.btnSearchFilter.isHidden = true
            self.collVForProduct.isHidden = true
        }
        tblForProduct?.autoresizingMask = UIView.AutoresizingMask()
        tblForProduct?.estimatedRowHeight = 250
        tblForProduct?.rowHeight = UITableView.automaticDimension
        tblForSearchItem?.estimatedRowHeight = 25
        tblForSearchItem?.rowHeight = UITableView.automaticDimension
        tblForSearchItem?.register(cellType: ProductSearchCell.self)
        tblForProduct?.register(cellTypes: [ProductCell.self,ProductSection.self], bundle: nil)
        viewForImageHeader.setRound(withBorderColor: UIColor.themeLightLineColor, andCornerRadious: 3.0, borderWidth: 0.5)
        searchBarItem?.delegate = self
        statusBarHeight = UIApplication.shared.statusBarFrame.height
        barHeight = self.navigationController?.navigationBar.frame.height ?? 0
        self.viewForHeader?.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 350)
        self.tblForProduct?.tableHeaderView = viewForHeader
        categoryInfoViewHeight.constant = 0
        collVForProduct.delegate = self
        collVForProduct.dataSource = self
        collVHeader.delegate = self
        collVHeader.dataSource = self
        collVForProduct?.register(cellType: ProductCollectionCell.self)
        collVHeader?.register(cellType: ProductHeaderCollectionCell.self)
        if currentBooking.isQrCodeScanBooking {
            getTableBookingSetting()
        } else {
            wsGetCart()
        }
        setLocalization()
        setItemCountInBasket()
        delegateLeft = self
        self.setBackBarItem(isNative:false)
        cartButton = MyBadgeButton.init(frame: CGRect.init(x: 0, y: 0, width: 32, height: 32))
        cartButton?.setImage(UIImage.init(named: "filter_blue")?.imageWithColor(color: .themeColor), for: .normal)
        cartButton?.addTarget(self, action: #selector(ProductVC.onClickBtnSearch(_:)), for: .touchUpInside)
        let rightButton:UIBarButtonItem = UIBarButtonItem.init(customView: cartButton!)
        reviewButton = UIButton.init(type: .custom)
        reviewButton?.frame = CGRect.init(x: 0, y: 0, width: 32, height: 32)
        reviewButton?.setTitle("", for: .normal)
        reviewButton?.addTarget(self, action: #selector(ProductVC.btnOnClickReviewStore(_:)), for: .touchUpInside)
        reviewButton?.setImage(UIImage.init(named: "reviewWhiteIcon"), for: .normal)
        let rightButton2:UIBarButtonItem = UIBarButtonItem.init(customView: reviewButton!)
        self.navigationItem.rightBarButtonItems = [rightButton,rightButton2]
        let gesture:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(ProductVC.onClickCloseSearchView(_:)))
        gesture.delegate = self
        viewForSearchOverlay.addGestureRecognizer(gesture)
        viewForSearchOverlay.isUserInteractionEnabled = true
        viewForSearchOverlay.isHidden = true
        for s in searchBarItem.subviews[0].subviews {
            if s is UITextField {
                s.backgroundColor = UIColor.white
                (s as! UITextField).font = FontHelper.textRegular(size: 12)
            }
        }
        lblDivider2.isHidden = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.onClickBtnCart(_:)))
        gestureRecognizer.delegate = self
        viewCartContainer.addGestureRecognizer(gestureRecognizer)
        let reviewGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapOnRating(_:)))
        reviewGestureRecognizer.delegate = self
        viewRatingContainer.addGestureRecognizer(reviewGestureRecognizer)
        APPDELEGATE.setupNavigationbar()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tblForProduct.reloadData()
    }

    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        setItemCountInBasket()
        wsGetCart()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        setupLayout()
        self.navigationController?.view.setNeedsLayout()
    }

    func onClickLeftButton() {
        self.onClickBtnBack(btnBack)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayout()
    }

    func setLocalization() {
      
        /*SearchView*/
        viewForSearchItem.backgroundColor = UIColor.themeViewBackgroundColor
        btnApplySearch.backgroundColor = UIColor.themeButtonBackgroundColor
        btnApplySearch.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnApplySearch.setTitle("TXT_APPLY".localizedCapitalized, for: .normal)
        btnApplySearch.titleLabel?.font = FontHelper.buttonText()
        searchBarItem.backgroundImage = UIImage()
        searchBarItem.barTintColor = UIColor.themeAlertViewBackgroundColor
        searchBarItem.backgroundColor = UIColor.themeAlertViewBackgroundColor
        searchBarItem.tintColor = UIColor.themeAlertViewBackgroundColor
        searchBarItem.setTextColor(color: UIColor.themeTextColor)
        tblForSearchItem.backgroundColor = UIColor.themeViewBackgroundColor
        searchBarItem.placeholder = "TXT_ENTER_ITEM_NAME".localized
       
        /*main View*/
        self.viewForHeader.backgroundColor = UIColor.themeViewBackgroundColor
        self.tblForProduct.backgroundColor = UIColor.themeViewBackgroundColor
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        self.tblForProduct.backgroundColor = UIColor.themeViewBackgroundColor
        lblCartQuantity.textColor = UIColor.themeButtonTitleColor
        lblCartQuantity.font = FontHelper.tiny()
        btnGoToCart.backgroundColor = UIColor.themeButtonBackgroundColor
        btnGoToCart.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnGoToCart.setTitle("TXT_GO_TO_CART".localizedCapitalized, for: .normal)
       
        /* Storeview*/
        self.viewForStore.backgroundColor = UIColor.themeAlertViewBackgroundColor
        lblStoreName.textColor = UIColor.themeTextColor
        lblHeaderTitle.textColor = UIColor.themeTitleColor
        lblEstimateTime.textColor = UIColor.themeLightTextColor
        lblPriceRate.textColor = UIColor.themeLightTextColor
        lblRate.textColor = UIColor.themeButtonTitleColor
        lblCartText.textColor = UIColor.themeButtonTitleColor
        lblPriceLevel.textColor = UIColor.themeLightTextColor

        lblStoreName.font = FontHelper.textMedium(size: FontHelper.large)
        lblHeaderTitle.font = FontHelper.textMedium(size: FontHelper.large)
        lblEstimateTime.font = FontHelper.textRegular()
        lblPriceRate.font = FontHelper.textRegular()
        lblPriceLevel.font = FontHelper.textRegular()
        lblRate.font = FontHelper.textRegular()
        lblCartText.font = FontHelper.textMedium()
        self.viewCartContainer.backgroundColor = UIColor.themeColor
        lblCartText.text = "TXT_VIEW_CART".localized
        lblHeaderTitle.text = "TXT_MENU".localized
        viewRatingContainer.backgroundColor = UIColor.themeColor

        self.hideBackButtonTitle()
        self.automaticallyAdjustsScrollViewInsets = false
        self.imgProductFilter.image = UIImage.init(named: "store_filter")
        self.imgReview.image = UIImage.init(named: "reviewWhiteIcon")
        self.btnBookTable.titleLabel?.font = FontHelper.textMedium()
        self.btnBookTable.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        if currentBooking.selectedTable == nil {
            self.btnBookTable.setTitle("store_filter_book_a_table".localized, for: .normal)
        } else {
            self.btnBookTable.setTitle("edit_a_table".localized, for: .normal)
        }
        
        self.vwBookTable.isHidden = true
    }

    override func updateUIAccordingToTheme() {
        self.setBackBarItem(isNative:false)
    }

    func setupLayout() {
        navigationHeight.constant = statusBarHeight + barHeight
        lblClosed.textColor = UIColor.themeButtonTitleColor
        lblClosed.backgroundColor = UIColor.themeColor
        lblClosed.applyRoundedCornersWithHeight()
        lblCartQuantity.backgroundColor = UIColor.themeRedBGColor
        lblCartQuantity.textColor = UIColor.themeButtonTitleColor
        tblForProduct.tableFooterView = UIView()
        tblForProduct.tableFooterView?.backgroundColor = UIColor.themeViewBackgroundColor
        viewForSearchItem.setShadow(shadowColor: UIColor.black.cgColor, shadowOffset: CGSize.init(width: 1, height: 1), shadowOpacity: 0.5, shadowRadius: 3)
        self.viewForNavigationGradient.setGradient(startColor: UIColor.themeStartGradientColor, endColor: UIColor.themeEndGradientColor)
        imgTopConstraints.constant = -statusBarHeight
        collectionVTopConstraint.constant = viewForHeader.frame.height - (navigationHeight.constant)
        viewRatingContainer.applyRoundedCornersWithHeight()
        lblCartQuantity.applyRoundedCornersWithHeight()
        self.view.setNeedsUpdateConstraints()
        self.view.layoutIfNeeded()
        self.view.setNeedsLayout()
        self.view.setNeedsDisplay()
        self.viewCartContainer.applyRoundedCornersWithHeight()
        self.vwBookTable.backgroundColor = UIColor.themeColor
        self.vwBookTable.setRound(andCornerRadious: self.vwBookTable.frame.height/2)
    }

    func setTblHeader() {
        if !isShowGroupItems && self.arrProductGroupList.count > 0{
            self.viewForHeader?.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 480)
            self.tblForProduct?.tableHeaderView = viewForHeader
            categoryInfoViewHeight.constant = 160
            lblSeperator2Height.constant = 8
            viewProductGroupTop.constant =  5
            viewProductGroupBottom.constant = 5
            self.lblProductNameHeader.isHidden = false
            self.imgProductHeader.isHidden = false
            self.collVHeader.isHidden = false
            lblDivider2.isHidden = false
            collVForProduct.isHidden  = true
            collectionVTopConstraint.constant = viewForHeader.frame.height - (navigationHeight.constant)
            //self.view.setNeedsLayout()
            //self.view.setNeedsUpdateConstraints()

        }else{
            self.viewForHeader?.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 350)
            self.tblForProduct?.tableHeaderView = viewForHeader
            categoryInfoViewHeight.constant = 0
            lblSeperator2Height.constant = 0
            viewProductGroupTop.constant =  0
            viewProductGroupBottom.constant = 0
            self.lblProductNameHeader.isHidden = true
            self.imgProductHeader.isHidden = true
            self.collVHeader.isHidden = true
            lblDivider2.isHidden = true
            collVForProduct.isHidden  = false
            //self.view.setNeedsLayout()
            //self.view.setNeedsUpdateConstraints()
        }
    }
    
    //ACtion Method
    @IBAction func onClickBtnBack(_ sender: Any) {
        
        if isFromDeliveryList {
            if (self.navigationController != nil) {
                self.navigationController?.popToRootViewController(animated: true)
            } else {
                APPDELEGATE.goToMain()
            }
        } else {
            if (self.navigationController != nil) {
                self.navigationController?.setNavigationBarHidden(true, animated: true)
                self.navigationController?.popViewController(animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    @IBAction func btnOnClickReviewStore(_ sender: UIButton) {
        openOverviewDialog()
    }

    func gotoStoreDetail() {
        if let navigationVC = self.navigationController {
            for controller in navigationVC.viewControllers {
                if controller.isKind(of: StoreReviewVC.self) {
                    self.navigationController?.popToViewController(controller, animated: true)
                    return
                }
            }
        }

        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "StoreDetail", bundle: nil)
        if let _ : StoreReviewVC = mainView.instantiateInitialViewController() as? StoreReviewVC {}
    }

    @IBAction func onClickBtnCart(_ sender: AnyObject) {
        if self.isFromUpdateOrder {
            self.navigationController?.popViewController(animated: true)
        } else {
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
            if let cartvc:CartVC = mainView.instantiateInitialViewController() as? CartVC {
                self.navigationController?.pushViewController(cartvc, animated: true)
            }
        }
    }

    @objc func handleTapOnRating(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name:"StoreDetail", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier:"ReviewVC") as! ReviewVC
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false, completion: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

    //MARK: - User Define Functions
    func setStoreData(storedata:StoreItem) {
        imgStore.downloadedFrom(link: (selectedStore?.image_url!)!)
        imgStore.backgroundColor = (selectedStore?.image_url ?? "").isEmpty ? UIColor.themeTextColor : UIColor.clear
        lblStoreName.text = storedata.name!
        lblRate.text = String(storedata.rate ?? 0.0)

        let data = Utility.isStoreOpen(storeTime: storedata.store_time, milliSeconds: currentBooking.currentDateMilliSecond)
        storedata.isStoreClosed = !data.0
        storedata.reopenAt = data.1
        if storedata.isStoreClosed {
            viewForClosedStore.isHidden = false
            lblReopenAt.text = storedata.reopenAt
        } else {
            if storedata.isStoreBusy {
                viewForClosedStore.isHidden = false
                lblClosed.text = "TXT_BUSY".localizedCapitalized
                lblReopenAt.text = ""
            } else {
                viewForClosedStore.isHidden = true
            }
        }
        
        if storedata.is_provide_table_booking && (storedata.isTableReservation || storedata.isTableReservationWithOrder) {
            if currentBooking.isQrCodeScanBooking || (editOrderType != DeliveryType.tableBooking && isFromUpdateOrder) {
                vwBookTable.isHidden = true
            } else {
                vwBookTable.isHidden = false
            }
        } else {
            vwBookTable.isHidden = true
        }

        self.setNavigationTitle(title: storedata.name ?? "")

        if preferenceHelper.getUserId().isEmpty() {
            btnFav.isHidden = true
        } else {
            storedata.isFavourite = currentBooking.favouriteStores.contains(selectedStore?._id ?? "")
            btnFav.isSelected = storedata.isFavourite
        }

        storedata.strFamousProductsTags = Utility.bindPriceTag(arrForFamousTags: storedata.famousProductsTags, currency: storedata.currency, numberOfTags: storedata.price_rating ?? 0)

        self.lblPriceRate.text = storedata.strFamousProductsTagsWithComma
        let priceTag = Utility.numberOfTag(numberOfTags: storedata.price_rating ?? 0, currency: storedata.currency)
        self.lblPriceLevel.text = priceTag
        if storedata.deliveryMaxTime > storedata.deliveryTime {
            lblEstimateTime.text = String(storedata.deliveryTime!) + " - " + String(storedata.deliveryMaxTime!) + " "  + "UNIT_MIN".localizedLowercase
        } else {
            lblEstimateTime.text = String(storedata.deliveryTime!) + " "  + "UNIT_MIN".localizedLowercase
        }
        currentBooking.selectedStore = storedata
        selectedStore = storedata
        self.selectedStore?.storeTaxDetails = storedata.storeTaxDetails
        self.selectedStore?.isUseItemTax = storedata.isUseItemTax
        self.selectedStore?.isTaxInlcuded = storedata.isTaxInlcuded

        currentBooking.isUseItemTax = self.selectedStore?.isUseItemTax ?? false
        currentBooking.isTaxIncluded = self.selectedStore?.isTaxInlcuded ?? false
    }

    func setItemCountInBasket() {
        var numberOfItems = 0
        for cartProduct in currentBooking.cart {
            numberOfItems = numberOfItems + (cartProduct.items?.count)!
        }
        currentBooking.totalItemInCart = numberOfItems
        lblCartQuantity.text = String(currentBooking.totalItemInCart)
       
        if isFromUpdateOrder || numberOfItems < 1 {
            viewCartContainer.isHidden = true
            btnGotoCartHeight.constant = 0
        } else {
            viewCartContainer.isHidden = false
            btnGotoCartHeight.constant = 45
        }
    }

    func loadStoreProduct() {
        if selectedStore != nil {
            wsGetProductGroupList(storeId: (selectedStore?._id!)!)
            //setStoreData(storedata: selectedStore!)
        } else {
            wsGetProductGroupList(storeId: selectedStoreId ?? "")
        }
    }

    func refreshCartBadge() {
        reloadCart()
        self.navigationController?.isNavigationBarHidden = true
        self.setItemCountInBasket()
    }

    func openOverviewDialog() {
    
        let dialogForRatingReview = CustomOverviewDialogue.showCustomReviewRatingDialog(title: "TXT_STORE_OVERVIEW".localized, message: "".localized, titleLeftButton: "TXT_APPLY".localized, titleRightButton: "TXT_CLEAR".localized, editTextOneHint: "TXT_PHONE".localized, editTextTwoHint: "", isEdiTextTwoIsHidden: false)
        dialogForRatingReview.onClickRightButton = {
            dialogForRatingReview.removeFromSuperview()
        }
        dialogForRatingReview.onClickLeftButton  = {
            
        }
        dialogForRatingReview.onClickShareButton = {
            self.handleShare()
        }
    }

    func handleShare() {
        let store = currentBooking.selectedStore!
        var myString = ""
        if store.branch_io_url.isEmpty {
            myString = String(format: "TXT_SHARE_STORE_DETAIL".localized.replacingOccurrences(of: "****", with: "APP_NAME".localized),(store.name ?? "") , (store.website_url ?? ""))
        } else {
            myString = store.branch_io_url
        }
        let textToShare = [ myString ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        self.navigationController?.present(activityViewController, animated: true, completion: nil)
    }

    //MARK:- Navigation Bar Animations
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if UIScreen.main.bounds.height < (tableViewContentHeight - (viewForHeader.frame.height - viewForStore.frame.height/2)) {
            if(self.tblForProduct.isTableHeaderViewVisible) {
                self.viewForNavigationGradient.setGradient(startColor: UIColor.themeStartGradientColor, endColor: UIColor.themeEndGradientColor)
                self.viewForNavigation.isHidden = false
                self.viewForNavigationGradient.isHidden = false
                self.navigationController?.setNavigationBarHidden(true, animated: true)
                lblTitle.text = ""
                tableTopConstraint.constant = 0
            } else {
                self.viewForNavigation.isHidden = true
                self.viewForNavigationGradient.isHidden = true
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                lblTitle.text = selectedStore?.name!
                tableTopConstraint.constant = -self.barHeight - self.statusBarHeight
            }
        }
    }

    func goToProductSPecificationVC() {
        let productSpecificationVC = ProductSpecificationVC.init(nibName: "ProductSpecification", bundle: nil)
        let selectedProductItem:ProductItemsItem = ProductItemsItem.init(dictionary:(self.selectedProductItem?.dictionaryRepresentation())!)!
        productSpecificationVC.selectedProductItem = selectedProductItem
        productSpecificationVC.productName = self.selecetedProduct?.productDetail?.name
        productSpecificationVC.productUniqueId = self.selecetedProduct?.productDetail?.unique_id
        productSpecificationVC.languageCodeInd = self.languageCodeInd
        productSpecificationVC.languageCode = self.languageCode
        productSpecificationVC.delegateRefreshCartBadge = self

        let nav = UINavigationController.init(rootViewController: productSpecificationVC)
        nav.setNavigationBarHidden(true, animated: false)
        nav.modalPresentationStyle = .overCurrentContext
        nav.modalPresentationCapturesStatusBarAppearance = true
        self.present(nav, animated: true, completion: nil)
    }

    func goToEditOrderProductSpecification() {
        let productSpecificationVC = EditOrderProductSpecificationVC.init(nibName: "EditOrderProductSpecification", bundle: nil)
        let selectedProductItem:ProductItemsItem = ProductItemsItem.init(dictionary:(self.selectedProductItem?.dictionaryRepresentation())!)!
        selectedProductItem.total_item_price = self.selectedProductItem?.total_item_price
        productSpecificationVC.selectedProductItem = selectedProductItem
        productSpecificationVC.productName = self.selecetedProduct?.productDetail?.name
        productSpecificationVC.productUniqueId = self.selecetedProduct?.productDetail?.unique_id
        productSpecificationVC.selectedStore = self.selectedStore
        self.navigationController?.pushViewController(productSpecificationVC, animated: true)
    }

    //MARK: - WEB SERVICE CALLS
    func wsGetProductList(storeId:String) {
        
        let dictParam: Dictionary<String,Any> =
            [PARAMS.USER_ID:preferenceHelper.getUserId(),
             PARAMS.IPHONE_ID:preferenceHelper.getRandomCartID(),
             PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken(),
             PARAMS.STORE_ID:storeId ]
        print("wsGetProductList dictParam\(dictParam)")

        Utility.showLoading()
        let afn:AlamofireHelper = AlamofireHelper.init()
        
        afn.getResponseFromStoreURL(langInd: languageCodeInd,url: WebService.WS_GET_STORE_PRODUCT_ITEM_LIST, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            
            self.arrProductList = Parser.parseStoreProductList(response)
            print("WS_GET_STORE_PRODUCT_ITEM_LIST response \(Utility.convertDictToJson(dict: response as! Dictionary<String, Any>))")

            DispatchQueue.main.async {
                if (response["store"] != nil) {
                    self.selectedStore = StoreItem.init(dictionary: response["store"] as! NSDictionary)
                    self.selectedStore?.currency = (response["currency"] as? String) ?? ""
                    self.selectedStore?.strFamousProductsTagsWithComma = Utility.bindTagWithComma(arrForFamousTags: self.selectedStore?.famousProductsTags ?? [], numberOfTags: self.selectedStore?.price_rating ?? 0)

                    self.setStoreData(storedata: self.selectedStore!)
                    if (response["is_store_can_create_group"] != nil) {
                        self.isShowGroupItems = response["is_store_can_create_group"] as! Bool
                        if self.isShowGroupItems{
                            self.wsGetProductGroupList(storeId: (self.selectedStore?._id!)!)
                        }
                    }
                } else {}
                
                if (self.arrProductList != nil) {
                    self.productListLength = self.arrProductList?.count
                    self.reloadTableWithArray(array: self.arrProductList)
                    self.tblForSearchItem.reloadData()
                    self.btnSearchFilter.isHidden = true
                } else {
                    self.btnSearchFilter.isHidden = true
                }
                
                Utility.hideLoading()
            }
        }
    }
    
    func wsGetProductGroupList(storeId:String) {
        
        let dictParam: Dictionary<String,Any> =
            [PARAMS.USER_ID:preferenceHelper.getUserId(),
             PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken(),
             PARAMS.STORE_ID:storeId
            ]
        print("get_product_group_list dictParam\(dictParam)")

        Utility.showLoading()
        let afn:AlamofireHelper = AlamofireHelper.init()
        
        afn.getResponseFromStoreURL(langInd: languageCodeInd,url: WebService.WS_GET_PRODUCT_GROUP_LIST, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Utility.hideLoading()
            self.arrProductGroupList.removeAll()
            self.arrProductGroupList = Parser.parseStoreProductGroupList(response)
            DispatchQueue.main.async {
                
                print("get_product_group_list response\(response)")
                self.arrProductids.removeAll()
                if self.arrProductGroupList.count > 0{
                    for obj in self.arrProductGroupList[0].productGroups{
                        self.arrProductids.append(contentsOf: obj.product_ids)
                    }
                   
                    self.collVForProduct.isHidden = true
                    self.isShowGroupItems = false
                    self.arrProductids.removeAll()
                    if self.arrProductGroupList.count > 0{
                        self.arrProductids.append(contentsOf: self.arrProductGroupList[0].productGroups[0].product_ids)
                        
                    }
                    print(self.arrProductids)
                    
                    self.selectedProductIDHeader = self.arrProductGroupList[0].productGroups[0].id
                    self.selectedindexPathProductHeader = IndexPath(item: 0, section: 0)
                    self.collVHeader.reloadData()

                    self.wsGetProductGroupItemList(storeId: self.arrProductGroupList[0].productGroups[0].storeId, groupID:
                                                    self.arrProductGroupList[0].productGroups[0].id)
                    
                }else{
                    self.collVForProduct.isHidden = true
                    self.isShowGroupItems = false
                    self.wsGetProductList(storeId:storeId)
                }
                self.setTblHeader()
                print(self.arrProductids)
                
                self.collVForProduct.reloadData()
                self.collVHeader.reloadData()

            }
        }
    }
    
    func wsGetProductGroupItemList(storeId:String,groupID:String) {
        
        let dictParam: Dictionary<String,Any> =
            [PARAMS.USER_ID:preferenceHelper.getUserId(),
             PARAMS.IPHONE_ID:preferenceHelper.getRandomCartID(),
             PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken(),
             PARAMS.STORE_ID:storeId,
             PARAMS.PRODUCT_IDS:arrProductids
            ]
        
        print("wsGetProductGroupItemList dictParam \(dictParam)")
        Utility.showLoading()
        let afn:AlamofireHelper = AlamofireHelper.init()
        
        afn.getResponseFromStoreURL(langInd: languageCodeInd,url: WebService.WS_GET_STORE_PRODUCT_ITEM_LIST, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            
            Utility.hideLoading()
            
            print("wsGetProductGroupItemList dictParam \(Utility.convertDictToJson(dict: response as! Dictionary<String, Any>))")
            self.arrProductList = Parser.parseStoreProductList(response)
 
            if currentBooking.isQrCodeScanBooking {
                self.selectedStore = StoreItem.init(dictionary: response["store"] as! NSDictionary)
                self.checkForAvailable()
            }
            
            DispatchQueue.main.async {
                if (response["store"] != nil) {
                    self.selectedStore = StoreItem.init(dictionary: response["store"] as! NSDictionary)
                    self.selectedStore?.currency = (response["currency"] as? String) ?? ""
                    self.selectedStore?.strFamousProductsTagsWithComma = Utility.bindTagWithComma(arrForFamousTags: self.selectedStore?.famousProductsTags ?? [], numberOfTags: self.selectedStore?.price_rating ?? 0)
                    self.setStoreData(storedata: self.selectedStore!)
                }
                if (self.arrProductList != nil) {
                    self.isShowGroupItems = false
                    self.productListLength = self.arrProductList?.count
                    self.reloadTableWithArray(array: self.arrProductList)
                    self.tblForSearchItem.reloadData()
                    self.tblForProduct.reloadData()
                    self.btnSearchFilter.isHidden = true
                    self.collVForProduct.isHidden = true
                    self.setTblHeader()
                }else {
                    self.reloadTableWithArray(array: [])
                    self.btnSearchFilter.isHidden = true
                }
            }
        }
    }
    
    func checkForAvailable(msg:String? = nil) {
        var strMsg: String?
        if msg != nil {
            strMsg = msg!
        } else {
            if let store = selectedStore {
                if !(store.is_approved ?? false) || !(store.is_business ?? false) || (store.isStoreBusy ?? false) || (store.isStoreClosed) || !(store.is_business ?? false) || !(store.is_business ?? false) || !(store.is_country_business ?? false) || !(store.is_city_business ?? false) || !(store.is_delivery_business ?? false) {
                    strMsg = "TXT_STORE_BUSSINESS_NOT_AVAILABLE".localized
                } else if !store.isTableReservationWithOrder {
                    strMsg = "TXT_TABLE_RECERVATION_IS_NOT_AVAILABLE".localized
                }
            }
        }
        
        if let strMsg = strMsg {
            let dialogForServerError = CustomAlertDialog.showCustomAlertDialog(title: "TXT_ATTENTION".localized, message: strMsg, titleLeftButton: "TXT_EXIT".localizedCapitalized, titleRightButton: "TXT_OK".localizedCapitalized)
            dialogForServerError.onClickLeftButton = { [unowned dialogForServerError] in
                dialogForServerError.removeFromSuperview()
                self.navigationController?.popViewController(animated: true)
            }
            dialogForServerError.onClickRightButton = { [unowned dialogForServerError] in
                dialogForServerError.removeFromSuperview()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    //WEb service Favourite store
    func wsAddFavStore() {
        Utility.showLoading()
        let dictParam : [String : Any] =
            [PARAMS.USER_ID : preferenceHelper.getUserId(),
             PARAMS.STORE_ID: (self.selectedStore?._id) ?? " "
            ]
        
        let alamoFire:AlamofireHelper = AlamofireHelper()
        alamoFire.getResponseFromURL(url: WebService.WS_ADD_FAVOURITE_STORE, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Utility.hideLoading()
            Parser.parseFavouriteStores(response, completion: { (result) in
                
                if result {
                    self.btnFav.isSelected = !self.btnFav.isSelected
                    self.selectedStore?.isFavourite = self.btnFav.isSelected
                }
            })
        }
    }
    
    func wsRemoveFavStore() {
        Utility.showLoading()
        let dictParam : [String : Any] =
            [PARAMS.USER_ID : preferenceHelper.getUserId(),
             PARAMS.STORE_ID: [(self.selectedStore?._id) ?? " "]
            ]
        let alamoFire:AlamofireHelper = AlamofireHelper()
        alamoFire.getResponseFromURL(url: WebService.WS_REMOVE_FAVOURITE_STORE, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Utility.hideLoading()
            Parser.parseFavouriteStores(response, completion: { (result) in
                if result {
                    self.btnFav.isSelected = !self.btnFav.isSelected
                    self.selectedStore?.isFavourite = self.btnFav.isSelected
                    
                }
            })
        }
    }
    
    func getTableBookingSetting() {
        var dictParam: [String:Any] = APPDELEGATE.getCommonDictionary()
        dictParam[PARAMS.STORE_ID] = selectedStoreId ?? ""

        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.FETCH_TABLE_BOOKING_BASIC_SETTING, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { [weak self] (response, error) -> (Void) in
            if Parser.isSuccess(response: response) {
                let tableSetting = ResponseFetchStoreSetting(dictionary: response)
                let arrTableList = tableSetting?.storeData?.table_list ?? []
                for table in arrTableList {
                    if currentBooking.tableID == table._id ?? "" {
                        currentBooking.table_no = table.table_no ?? 0
                        currentBooking.number_of_pepole = table.table_max_person ?? 0
                        if !(table.is_bussiness ?? false) || !(table.is_user_can_book ?? false)  {
                            self?.checkForAvailable(msg: "TXT_TABLE_RECERVATION_IS_NOT_AVAILABLE".localized)
                        }
                        break
                    }
                }
            }
            self?.loadStoreProduct()
        }
    }
    
    func reloadTableWithArray(array:Array<ProductItem>?) {
        if let finalArray = array {
            filteredArrProductItemList.removeAll()
            for productItem in finalArray {
                let objItem = productItem
                for obj in objItem.items ?? [] {
                    obj.isAdded = false
                    var qty = 0
                    for cartProduct in currentBooking.cart {
                        for items in cartProduct.items ?? [] {
                            if ((items.item_id?.compare((obj._id)!)) == .orderedSame) {
                                obj.isAdded = true
                                qty += items.quantity
                            }
                        }
                    }
                    if obj.isAdded {
                        obj.quantity = qty
                    }
                }
                if objItem.isProductFiltered {
                    filteredArrProductItemList.append(objItem)
                }
            }
        }
        tblForProduct.reloadData()
    }
    
    func reloadCart() {
        for productItem in filteredArrProductItemList {
            let objItem = productItem
            for obj in objItem.items ?? [] {
                obj.isAdded = false
                var qty = 0
                for cartProduct in currentBooking.cart {
                    for items in cartProduct.items ?? [] {
                        if ((items.item_id?.compare((obj._id)!)) == .orderedSame) {
                            obj.isAdded = true
                            qty += items.quantity
                        }
                    }
                }
                if obj.isAdded {
                    obj.quantity = qty
                }
            }
        }
        tblForProduct.reloadData()
    }
    
    @IBAction func onClickBtnSearch(_ sender: Any) {
        searchBarItem.text = ""
        self.openProductFilterDialog()
        
    }
    
    @IBAction func onClickCloseSearchView(_ sender: Any) {
        searchBarItem.text = ""
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: self.tblForSearchItem) == true {
            return false
        }
        return true
    }
    
    func viewGone() {
        if isFilterViewVisible {
            isFilterViewVisible = false
            if self.isShowGroupItems{
                self.btnSearchFilter.isHidden = true
            }else{
                self.btnSearchFilter.isHidden = true
            }
            
            setTblHeader()
            
            let oldFrame:CGRect = self.viewForSearchItem.frame
            if LocalizeLanguage.isRTL {
                self.viewForSearchItem.layer.anchorPoint = CGPoint(x: 0, y: 1)
            }else {
                self.viewForSearchItem.layer.anchorPoint = CGPoint(x: 1, y: 1)
            }
            self.viewForSearchItem.frame = oldFrame
            self.viewForSearchItem.transform = CGAffineTransform.identity
            UIView.animate(withDuration: 0.5, animations: {
                self.viewForSearchItem.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
            },completion: { _ in
                self.isFilterViewVisible = true
                self.viewVisible(isGone: true)
            })
        }
    }
    
    func viewVisible(isGone:Bool = false) {
        if isFilterViewVisible {
            isFilterViewVisible = false
            viewForSearchOverlay.isHidden = isGone
            if self.isShowGroupItems{
                self.btnSearchFilter.isHidden = true
            }else{
                self.btnSearchFilter.isHidden = true
            }
            setTblHeader()
            
            self.view.bringSubviewToFront( viewForSearchItem)
            var  oldFrame:CGRect = self.viewForSearchItem.frame
            let frame = btnSearchFilter.frame
            if LocalizeLanguage.isRTL {
                self.viewForSearchItem.layer.anchorPoint = CGPoint(x: 0, y: 1)
                oldFrame.origin = CGPoint.init(x:frame.minX , y:frame.maxY - (oldFrame.height + 10))
            }else {
                oldFrame.origin = CGPoint.init(x:frame.maxX - (oldFrame.width + 10) , y:frame.maxY - (oldFrame.height + 10))
                self.viewForSearchItem.layer.anchorPoint = CGPoint(x: 1, y: 1)
            }
            self.viewForSearchItem.frame = oldFrame
            self.viewForSearchItem.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
            if isGone {
                self.viewForSearchItem.transform = CGAffineTransform.identity
                isFilterViewVisible = true
            }else {
                UIView.animate(withDuration: 0.5 ,animations: {
                    self.viewForSearchItem.transform = CGAffineTransform.identity
                },completion: { _ in
                    self.isFilterViewVisible = true
                })
            }
        }
    }
    func openProductFilterDialog()  {
        let dialogProductFilter = CustomProductFilter.showProductFilter(title: "TXT_FILTERS".localized, message: "", arrProductList: arrProductList)
        dialogProductFilter.onClickLeftButton = {
            
        }
        dialogProductFilter.onClickApplySearch = {
            (searchText, arrSearchList) in
            dialogProductFilter.removeFromSuperview()
            self.arrProductList = arrSearchList
            self.applyItemFilter(searchText: searchText)
        }
    }
    @IBAction func onClickBtnFav(_ sender: UIButton) {
        if btnFav.isSelected {
            wsRemoveFavStore()
        }else {
            wsAddFavStore()
        }
    }
    
    
    @IBAction func onClickBtnApplySearch(_ sender: Any) {
        let searchText = searchBarItem.text ?? ""
        self.view.endEditing(true)
        if searchText.isEmpty() {
            self.reloadTableWithArray(array: arrProductList)
        }
        else
        {
            var product_array:Array<ProductItem> = []
            self.arrProductList?.forEach({ (product) in
                if product.isProductFiltered {
                    let producttemp = ProductItem.init(dictionary: product.dictionaryRepresentation())
                    let itemArray = producttemp?.items?.filter({ (itemData) -> Bool in
                        let a = itemData.name?.lowercased().contains(searchText.lowercased())
                        return a!
                    })
                    if((itemArray?.count) ?? 0 > 0) {
                        producttemp?.items = itemArray
                        product_array.append(producttemp!)
                    }
                }
            })
            if product_array.isEmpty {
                Utility.showToast(message:"TXT_NO_SEARCH_ITEM_NOT_AVAILABLE".localized)
            }
            self.reloadTableWithArray(array: product_array)
        }
        viewGone()
    }

    func applyItemFilter(searchText: String)  {
        self.view.endEditing(true)
        if searchText.isEmpty() {
            self.reloadTableWithArray(array: arrProductList)
        } else {
            var product_array:Array<ProductItem> = []
            self.arrProductList?.forEach({ (product) in
                if product.isProductFiltered {
                    let producttemp = ProductItem.init(dictionary: product.dictionaryRepresentation())
                    let itemArray = producttemp?.items?.filter({ (itemData) -> Bool in
                        let a = itemData.name?.lowercased().contains(searchText.lowercased())
                        return a!
                    })
                    if((itemArray?.count) ?? 0 > 0)
                    {
                        producttemp?.items = itemArray
                        product_array.append(producttemp!)
                    }
                }
            })
            if product_array.isEmpty {
                Utility.showToast(message:"TXT_NO_SEARCH_ITEM_NOT_AVAILABLE".localized)
            }
            self.reloadTableWithArray(array: product_array)
        }
        viewGone()
    }

    @IBAction func onClickBtnBookTable(_ sender: Any) {
        if currentBooking.selectedTable == nil{
            if currentBooking.cart.count > 0{
                openClearCartDialog()
            }else{
                openTableBookingDialog(storeID: currentBooking.selectedStore?._id ?? "")
            }
        }else{
            openTableBookingDialog(storeID: currentBooking.selectedStore?._id ?? "")
        }
    }

    func openClearCartDialog(indexPath: IndexPath? = nil) {
        
        let dialogForClearCart = CustomAlertDialog.showCustomAlertDialog(title: "TXT_ATTENTION".localized, message: "MSG_OTHER_STORE_ITEM_IN_CART".localized, titleLeftButton: "".localizedCapitalized, titleRightButton: "TXT_OK".localizedCapitalized)
        dialogForClearCart.onClickLeftButton = {
            [unowned self,unowned dialogForClearCart] in
            dialogForClearCart.removeFromSuperview()
            if currentBooking.isQrCodeScanBooking {
                currentBooking.isQrCodeScanBooking = false
                self.navigationController?.popViewController(animated: true)
            }
        }
        dialogForClearCart.onClickRightButton = {
            [unowned self,unowned dialogForClearCart] in
            dialogForClearCart.removeFromSuperview()
            self.wsClearCart(indexPath: indexPath)
        }
    }
    
    func wsGetCart() {
        let dictParam: [String:Any] = APPDELEGATE.getCommonDictionary()
        print(dictParam)
        Utility.showLoading()
        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_GET_CART, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { [weak self] (response, error) -> (Void) in
            Utility.hideLoading()
            guard let self = self else { return }
            if currentBooking.isQrCodeScanBooking {
                currentBooking.clearCart()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    CurrentBooking.shared.PushNotification = false
                    print("CurrentBooking.shared.logout = ",CurrentBooking.shared.PushNotification)
                }
            }
            if Parser.parseCart(response) {
                self.setItemCountInBasket()
            }
            if self.filteredArrProductItemList.count > 0 {
                self.reloadCart()
            } else {
                self.loadStoreProduct()
            }
        }
    }
    
    func wsClearCart(indexPath: IndexPath? = nil) {
        var dictParam: [String:Any] = APPDELEGATE.getCommonDictionary()
        dictParam[PARAMS.CART_ID] = currentBooking.cartId
        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_CLEAR_CART, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { [weak self] (response,error) -> (Void) in
            guard let self = self else { return }
            Utility.hideLoading()
            currentBooking.clearCart()
            currentBooking.clearTableBooking()
            self.refreshCartBadge()
            if indexPath != nil {
                self.addToCart(indexPath: indexPath!)
            }
        }
    }
    
    func addToCart(indexPath: IndexPath, updateItem: CardItem? = nil) {
        
        var arrCurrentAdded = [CartProductItems]()
        if currentBooking.cart.count > 0 {
            for obj in CurrentBooking.shared.cart {
                for item in (obj.items ?? []) {
                    arrCurrentAdded.append(item)
                }
            }
        }
        
        let objSection = filteredArrProductItemList[indexPath.section]
        let itemObj = objSection.items?[indexPath.row]
        let qty = itemObj?.quantity ?? 1
            
        currentBooking.deliveryAddress = currentBooking.currentAddress
        currentBooking.deliveryLatLng = currentBooking.currentLatLng
        var specificationPriceTotal = 0.0
        var specificationPrice = 0.0
        var specificationList:[Specifications] = [Specifications].init()
        
        for specificationListItem in itemObj?.specifications ?? [] {
            
            var specificationItemCartList:[SpecificationListItem] = [SpecificationListItem].init()
            
            for listItem in specificationListItem.list! {
                print(listItem.is_default_selected)
                
                if (listItem.is_default_selected) {
                    specificationPrice = specificationPrice + listItem.price!
                    specificationPriceTotal = specificationPriceTotal + (listItem.price! * Double(listItem.quantity))
                    specificationItemCartList.append(listItem)
                }
            }
            
            if !specificationItemCartList.isEmpty {
                let specificationsItem:Specifications = Specifications()
                specificationsItem.list = specificationItemCartList
                specificationsItem.unique_id = specificationListItem.unique_id
                specificationsItem.name = specificationListItem.name
                specificationsItem.price = specificationPrice
                specificationsItem.type = specificationListItem.type
                specificationsItem.range = specificationListItem.range
                specificationsItem.rangeMax = specificationListItem.rangeMax
                specificationsItem.is_required = specificationListItem.is_required
                

                specificationList.append(specificationsItem)
            }
            specificationPrice = 0
        }
        
        let cartProductItems:CartProductItems = CartProductItems.init()
        guard let currentSelectedProductItem = itemObj else {
            return
        }
        
        cartProductItems.item_id = currentSelectedProductItem._id
        cartProductItems.unique_id = currentSelectedProductItem.unique_id
        cartProductItems.item_name = currentSelectedProductItem.name
        cartProductItems.quantity = 1
        cartProductItems.image_url = currentSelectedProductItem.image_url
        cartProductItems.details = currentSelectedProductItem.details
        cartProductItems.specifications = specificationList
        cartProductItems.item_price = currentSelectedProductItem.price
        cartProductItems.total_specification_price = specificationPriceTotal
        cartProductItems.totalItemPrice = Double(qty) * (itemObj?.price ?? 0)
        cartProductItems.taxDetails = currentSelectedProductItem.taxDetails
        cartProductItems.noteForItem = ""
        cartProductItems.totalPrice = currentSelectedProductItem.price + specificationPriceTotal
        
        var tax = 0.0
        
        if !currentBooking.selectedStore!.isUseItemTax{
            for obj in currentBooking.selectedStore!.storeTaxDetails{
                tax = tax + Double(obj.tax)
            }
        }else{
            for obj in currentSelectedProductItem.taxDetails{
                tax = tax + Double(obj.tax)
            }
        }
        
        print(tax)
        
        let itemTax = Utility.getTax(itemAmount: currentSelectedProductItem.price, taxValue: tax)
        let specificationTax = Utility.getTax(itemAmount: specificationPriceTotal, taxValue: tax)
        let totalTax = itemTax + specificationTax
        cartProductItems.tax = tax
        cartProductItems.itemTax = itemTax
        cartProductItems.totalSpecificationTax = specificationTax
        cartProductItems.totalTax = totalTax
        cartProductItems.totalItemTax =  totalTax * Double(qty)
        
        if itemObj?.isAdded ?? false {
            //increaseQuantity(currentProductItem: <#T##CartProductItems#>)
        }else {
            if !isFromUpdateOrder {
                if !(currentBooking.cartWithAllSpecification.contains(where: { (item) -> Bool in
                    item._id == currentSelectedProductItem._id!
                })) {
                    currentBooking.cartWithAllSpecification.append(currentSelectedProductItem)
                }

                let isAdded = arrCurrentAdded.filter { obj in
                    if obj.getProductJson().isEqual(to: cartProductItems.getProductJson() as! [AnyHashable : Any]) {
                        return true
                    }
                    return false
                }

                if isAdded.count > 0 {
                    var section = 0
                    var row = 0
                    
                    for obj in currentBooking.cart {
                        for item in (obj.items ?? []) {
                            if isAdded[0].getProductJson().isEqual(to: item.getProductJson() as! [AnyHashable : Any]) {
                                section = currentBooking.cart.firstIndex(where: {$0.getProductJson() == obj.getProductJson()}) ?? 0
                                row = (obj.items ?? []).firstIndex(where: {$0.getProductJson() == item.getProductJson()}) ?? 0
                                print("break")
                                break
                            }
                        }
                    }
                    
                    print("section \(section) row \(row)")
                                        
                    currentBooking.cart[section].items![row] = cartProductItems
                    currentBooking.cart[section].items![row].quantity = isAdded[0].quantity + 1
                    currentBooking.cart[section].items![row].totalItemTax = totalTax * Double((isAdded[0].quantity + 1))
                    wsAddItemInServerCart()
                }else {
                    var cartProductItemsList:[CartProductItems] = [CartProductItems].init()
                    cartProductItemsList.append(cartProductItems)
                    let cartProducts:CartProduct = CartProduct.init()
                    cartProducts.items = cartProductItemsList
                    cartProducts.product_id = currentSelectedProductItem.product_id
                    cartProducts.product_name = objSection.productDetail?.name ?? ""
                    cartProducts.unique_id = objSection.productDetail?.unique_id ?? 0
                    cartProducts.total_item_price = (itemObj?.price ?? 0.0) * Double(qty)
                    cartProducts.totalItemTax =  cartProductItems.totalItemTax
                    currentBooking.cart.append(cartProducts)
                    currentBooking.selectedStoreId = currentSelectedProductItem.store_id
                    wsAddItemInServerCart()
                }
            } else {
                
                var arrCurrentAddedInEdit = [CartProductItems]()
                if OrderBeingPrepared.selectedOrder.cartDetail!.orderDetails.count > 0 {
                    for obj in OrderBeingPrepared.selectedOrder.cartDetail!.orderDetails {
                        for item in (obj.items ?? []) {
                            arrCurrentAddedInEdit.append(item)
                        }
                    }
                }
                
                let isAdded = arrCurrentAddedInEdit.filter({$0.getProductJson().isEqual(to: cartProductItems.getProductJson() as! [AnyHashable : Any])})
                        
                if isAdded.count > 0 {
                    var section = 0
                    var row = 0
                    for obj in OrderBeingPrepared.selectedOrder.cartDetail!.orderDetails {
                        for item in (obj.items ?? []) {
                            if isAdded[0].getProductJson().isEqual(to: item.getProductJson() as! [AnyHashable : Any]) {
                                section = OrderBeingPrepared.selectedOrder.cartDetail!.orderDetails.firstIndex(where: {$0.getProductJson().isEqual(to: obj.getProductJson() as! [AnyHashable : Any])}) ?? 0
                                row = (obj.items ?? []).firstIndex(where: {$0.getProductJson().isEqual(to: item.getProductJson() as! [AnyHashable : Any])}) ?? 0
                                break
                            }
                        }
                    }
                    
                    OrderBeingPrepared.selectedOrder.cartDetail!.orderDetails[section].items![row] = cartProductItems
                    OrderBeingPrepared.selectedOrder.cartDetail!.orderDetails[section].items![row].quantity = isAdded[0].quantity + 1
                    OrderBeingPrepared.selectedOrder.cartDetail!.orderDetails[section].items![row].totalItemTax = totalTax * Double(1) * Double((isAdded[0].quantity + 1))
                }else{
                    if OrderBeingPrepared.selectedOrder.cartDetail != nil{
                        
                        var cartProductItemsList:[CartProductItems] = [CartProductItems].init()
                        cartProductItemsList.append(cartProductItems)
                        let cartProducts:CartProduct = CartProduct.init()
                        cartProducts.items = cartProductItemsList
                        cartProducts.product_id = currentSelectedProductItem.product_id
                        cartProducts.product_name = cartProductItems.item_name
                        cartProducts.unique_id = cartProductItems.unique_id
                        cartProducts.total_item_price = cartProductItems.totalItemPrice

                        cartProducts.totalItemTax =  cartProductItems.totalItemTax
                        OrderBeingPrepared.selectedOrder.cartDetail!.orderDetails.append(cartProducts)
                    }
                }
                
                self.navigationController?.popViewController(animated: true)
                for VC in self.navigationController?.viewControllers ?? [] {
                    if VC is OrderBeingPrepared {
                        (VC as! OrderBeingPrepared).updateData()
                    }
                }
            }
        }
        setItemCountInBasket()
    }
    
    func wsAddItemInServerCart() {
        
        let cartOrder:CartOrder = CartOrder.init()
        cartOrder.server_token = preferenceHelper.getSessionToken()
        cartOrder.user_id = preferenceHelper.getUserId()
        cartOrder.store_id = currentBooking.selectedStoreId ?? ""
        cartOrder.order_details = currentBooking.cart
        
        var totalPrice:Double = 0.0
        var totalTax:Double = 0.0
        for cartProduct in currentBooking.cart {
            totalTax = totalTax + cartProduct.totalItemTax
            totalPrice = totalPrice + (cartProduct.total_item_price ?? 0.0)
            
        }
        cartOrder.totalCartPrice =  totalPrice
        cartOrder.totalItemTax = totalTax
        
        if (currentBooking.destinationAddress.isEmpty || currentBooking.destinationAddress[0].address != currentBooking.deliveryAddress ) {
            
            let destinationAddress:Address = Address.init()
            destinationAddress.address = currentBooking.deliveryAddress
            destinationAddress.addressType = AddressType.DESTINATION
            destinationAddress.userType = CONSTANT.TYPE_USER
            destinationAddress.note = ""
            destinationAddress.city = currentBooking.currentSendPlaceData.city1
            destinationAddress.location = currentBooking.deliveryLatLng
            destinationAddress.flat_no = currentBooking.currentSendPlaceData.flat_no
            destinationAddress.street = currentBooking.currentSendPlaceData.street
            destinationAddress.landmark = currentBooking.currentSendPlaceData.landmark
            
            let cartUserDetail:CartUserDetail = CartUserDetail()
            cartUserDetail.email = preferenceHelper.getEmail()
            cartUserDetail.countryPhoneCode = preferenceHelper.getPhoneCountryCode()
            cartUserDetail.name = preferenceHelper.getFirstName() + " " + preferenceHelper.getLastName()
            cartUserDetail.phone = preferenceHelper.getPhoneNumber()
            destinationAddress.userDetails = cartUserDetail
            currentBooking.destinationAddress = [destinationAddress]
            
        }
        if currentBooking.pickupAddress.isEmpty && (currentBooking.selectedStore != nil) {
            let mySelectedStore:StoreItem = currentBooking.selectedStore!
            let pickupAddress:Address = Address.init()
            pickupAddress.address = mySelectedStore.address
            pickupAddress.addressType = AddressType.PICKUP
            pickupAddress.userType = CONSTANT.TYPE_USER
            pickupAddress.note = ""
            pickupAddress.city = ""
            pickupAddress.location = mySelectedStore.location ?? [0.0,0.0]
            let cartStoreDetail:CartUserDetail = CartUserDetail()
            cartStoreDetail.email = mySelectedStore.email ?? ""
            cartStoreDetail.countryPhoneCode = mySelectedStore.country_phone_code ?? ""
            cartStoreDetail.name = mySelectedStore.name ?? ""
            cartStoreDetail.phone = mySelectedStore.phone ?? ""
            cartStoreDetail.imageUrl = mySelectedStore.image_url
            pickupAddress.userDetails = cartStoreDetail
            currentBooking.pickupAddress = [pickupAddress]
        }

        cartOrder.pickupAddress = currentBooking.pickupAddress
        cartOrder.destinationAddress = currentBooking.destinationAddress
        if Utility.isTableBooking() || currentBooking.isQrCodeScanBooking {
            cartOrder.table_no = currentBooking.table_no
            cartOrder.booking_type = currentBooking.bookingType
            cartOrder.delivery_type = DeliveryType.tableBooking
            currentBooking.deliveryType = DeliveryType.tableBooking
            cartOrder.no_of_persons = currentBooking.number_of_pepole
            cartOrder.order_start_at = currentBooking.futureDateMilliSecondTable
            cartOrder.order_start_at2 = currentBooking.futureDateMilliSecondTable2
            cartOrder.table_id = currentBooking.tableID
        }

        let dictData:NSDictionary = (cartOrder.dictionaryRepresentation())
        dictData.setValue(currentBooking.isUseItemTax, forKey: PARAMS.IS_USE_ITEM_TAX)
        dictData.setValue(currentBooking.isTaxIncluded, forKey: PARAMS.IS_TAX_INCLUDED)
        dictData.setValue(currentBooking.totalCartAmountWithoutTax, forKey: PARAMS.TOTAL_CART_AMOUNT_WITHOUT_TAX)

        print(Utility.convertDictToJson(dict: dictData as! Dictionary<String, Any>))
        Utility.showLoading()
        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_ADD_ITEM_IN_CART, methodName: AlamofireHelper.POST_METHOD, paramData: dictData as? Dictionary<String, Any>) { (response,error) -> (Void) in
            if (Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true)) {
                print(Utility.convertDictToJson(dict: response as! Dictionary<String, Any>))
                currentBooking.cartCurrency = self.selectedProductItem?.currency ?? ""
                currentBooking.cartId = (response.value(forKey: PARAMS.CART_ID) as? String) ?? ""
                currentBooking.cartCityId = (response.value(forKey: PARAMS.CITY_ID)as? String) ?? ""
                currentBooking.storeLatLng = currentBooking.selectedStore?.location ?? [0.0,0.0]
                self.wsGetCart()
            } else {
                if response["error_code"] != nil{
                    if response["error_code"] as! Int == 968{
                        self.openClearCartDialogForChangeSetting()
                    }
                } else {
                    self.wsGetCart()
                }
            }
            Utility.hideLoading()
        }
    }
    
    func increaseQuantity(currentProductItem:CartProductItems) {
        printE("Increment Method Called")
        var quantity = currentProductItem.quantity!
        quantity = quantity + 1
        let total = (currentProductItem.total_specification_price! + currentProductItem.item_price!) * Double(quantity)
        currentProductItem.totalItemPrice = total
        currentProductItem.quantity = quantity
        currentProductItem.totalItemTax = ((currentProductItem.totalItemPrice ?? 0.0) * (currentProductItem.tax)) / 100
        calculateTotalAmount()
        wsAddItemInServerCart()
    }
    
    func decreaseQuantity(currentProductItem:CartProductItems) {
        printE("Decrement Method Called")
        var quantity = currentProductItem.quantity!
        if (quantity > 1 ) {
            quantity = quantity - 1
            let total = (currentProductItem.total_specification_price! + currentProductItem.item_price!) * Double(quantity)
            currentProductItem.totalItemPrice = total
            currentProductItem.quantity = quantity

            var tax = 0.0

            if !currentBooking.isUseItemTax {
                for obj in currentBooking.StoreTaxDetails {
                    tax = tax + Double(obj.tax)
                }
            } else {
                for obj in currentProductItem.taxDetails {
                    tax = tax + Double(obj.tax)
                }
            }
            print(tax)

            let specificationPriceTotal = currentProductItem.total_specification_price!
            let itemTax = Utility.getTax(itemAmount: currentProductItem.item_price!, taxValue: tax)
            let specificationTax = Utility.getTax(itemAmount: specificationPriceTotal, taxValue: tax)
            let totalTax = itemTax + specificationTax
            currentProductItem.itemTax = itemTax
            currentProductItem.totalSpecificationTax = specificationTax
            currentProductItem.totalTax = totalTax
            currentProductItem.totalItemTax =   totalTax * Double(quantity)

            calculateTotalAmount()
            wsAddItemInServerCart()
        }
    }
    
    func removeItemFromCart(currentProductItem:CartProductItems, section:Int, row:Int) {
        printE("Remove Method Called")
        if currentBooking.cart.count >= section {
            let currentProduct:CartProduct = currentBooking.cart[section]
            currentProduct.items?.remove(at: row)
            let itemCount = (currentProduct.items?.count) ?? 0
            if itemCount == 0 {
                currentBooking.cart.remove(at: section)
            }
            var isModifyCart = false
            for cartProduct in currentBooking.cart {
                if (cartProduct.items?.count)! > 0 {
                    isModifyCart = true
                }
            }
            if isModifyCart {
                wsAddItemInServerCart()
            } else {
                wsClearCart()
            }
            calculateTotalAmount()
        }
    }
    
    func goToProductSpecification(currentProduct:CartProductItems, selectedIndexPath: IndexPath) {
        let myServerSelectedProductItem:ProductItemsItem = currentBooking.cartWithAllSpecification.first { (item) -> Bool in
            item.unique_id! == currentProduct.unique_id!
            }!
        myServerSelectedProductItem.quantity = currentProduct.quantity
        myServerSelectedProductItem.instruction = currentProduct.noteForItem

        for specification in myServerSelectedProductItem.specifications! {
            for subSpecification in specification.list!{
                subSpecification.is_default_selected = false
            }
            
            for currentProductspecification in currentProduct.specifications {
                if currentProductspecification.unique_id == specification.unique_id {
                    for subSpecification in specification.list! {
                        for currentSubSpecification in currentProductspecification.list! {
                            if subSpecification.unique_id == currentSubSpecification.unique_id {
                                subSpecification.is_default_selected = true
                                print(subSpecification.name ?? "")
                            }
                        }
                    }
                }
            }
        }
        let myFinalProduct:ProductItemsItem = ProductItemsItem.init(dictionary: myServerSelectedProductItem.dictionaryRepresentation())!
        myFinalProduct.quantity = myServerSelectedProductItem.quantity
        myFinalProduct.currency = currentBooking.cartCurrency

        let productSpecificationVC = ProductSpecificationVC.init(nibName: "ProductSpecification", bundle: nil)
        productSpecificationVC.selectedProductItem = myFinalProduct
        productSpecificationVC.selectedProductItem?.name = currentProduct.item_name
        productSpecificationVC.selectedProductItem?.details = currentProduct.details
        productSpecificationVC.productName = currentBooking.cart[selectedIndexPath.section].product_name ?? ""
        productSpecificationVC.productUniqueId = currentBooking.cart[selectedIndexPath.section].unique_id ?? 0
        productSpecificationVC.selectedIndexPath = selectedIndexPath
        productSpecificationVC.quantity = myFinalProduct.quantity

        var isIndexMatch:Bool = false
        var selectedInd:Int = 0
        print(currentBooking.CartResponselangItems ?? "")

        if currentBooking.selectedStore != nil {
            for obj in currentBooking.selectedStore!.langItems!{
                if (obj.code == Constants.selectedLanguageCode) && (obj.is_visible! == true){
                    isIndexMatch = true
                    selectedInd = currentBooking.selectedStore!.langItems!.firstIndex(where: { $0.code == obj.code })!
                    break
                } else {
                    isIndexMatch = false
                }
            }
        } else {
            for obj in currentBooking.CartResponselangItems!{
                if (obj.code == Constants.selectedLanguageCode) && (obj.is_visible! == true){
                    isIndexMatch = true
                    selectedInd = currentBooking.CartResponselangItems!.firstIndex(where: { $0.code == obj.code })!
                    break
                } else {
                    isIndexMatch = false
                }
            }
        }

        if !isIndexMatch {
            if currentBooking.selectedStore != nil {
                if currentBooking.selectedStore!.langItems!.count > 0 {
                    productSpecificationVC.languageCode = currentBooking.selectedStore!.langItems![0].code!
                } else {
                    productSpecificationVC.languageCode = "en"
                }
                productSpecificationVC.languageCodeInd = "0"
            } else {
                if currentBooking.CartResponselangItems!.count > 0 {
                    productSpecificationVC.languageCode = currentBooking.CartResponselangItems![0].code!
                } else {
                    productSpecificationVC.languageCode = "en"
                }
                productSpecificationVC.languageCodeInd = "0"
            }
        } else {
            productSpecificationVC.languageCode = Constants.selectedLanguageCode
            productSpecificationVC.languageCodeInd = "\(selectedInd)"
        }
        self.navigationController?.pushViewController(productSpecificationVC, animated: true)
    }

    
    func calculateTotalAmount()
    {
        var total = 0.0
        var totalCartAmountWithoutTax = 0.0

        for currentProduct in currentBooking.cart {
            for currentProductItem in currentProduct.items! {
                
                total = total + Double(currentProductItem.totalItemPrice!)
                var eachItemTax = 0

                if !currentBooking.isUseItemTax{
                    for obj in currentBooking.StoreTaxDetails{
                        eachItemTax = eachItemTax + obj.tax
                    }
                }else{
                    for obj in currentProductItem.taxDetails{
                        eachItemTax = eachItemTax + obj.tax
                    }
                }
                print(eachItemTax)
                
                let specificationPriceTotal = currentProductItem.total_specification_price!

                let itemTax = Utility.getTax(itemAmount: currentProductItem.item_price!, taxValue: Double(eachItemTax)) * Double(currentProductItem.quantity)
                let specificationTax = Utility.getTax(itemAmount: specificationPriceTotal, taxValue: Double(eachItemTax)) * Double(currentProductItem.quantity)
                let totalTax = itemTax + specificationTax
                print(totalTax)
                
                if currentBooking.isTaxIncluded{
                    total = total - totalTax
                }
                totalCartAmountWithoutTax = totalCartAmountWithoutTax + Double(currentProductItem.totalItemPrice!)

           }
        }
        currentBooking.totalCartAmount = total
        currentBooking.totalCartAmountWithoutTax = totalCartAmountWithoutTax
    }
    
    func openClearCartDialogForChangeSetting() {
        
        let dialogForClearCart = CustomAlertDialog.showCustomAlertDialog(title: "TXT_ATTENTION".localized, message: "Item Tax Miss Match, Please Clear Cart", titleLeftButton: "".localizedCapitalized, titleRightButton: "TXT_OK".localizedCapitalized)
        dialogForClearCart.onClickLeftButton = {
            [unowned self,unowned dialogForClearCart] in
            dialogForClearCart.removeFromSuperview()
        }
        dialogForClearCart.onClickRightButton = {
            [unowned dialogForClearCart] in
            dialogForClearCart.removeFromSuperview()
            self.wsClearCart()
        }
    }
    
    func openTableBookingDialog(storeID:String) {
        let dialogForFilter = CustomTableBookingDialog.showCustomTableBookingDialog(title: "text_table_reservation".localized, titleRightButton: "btn_reserve_a_table".localized, storeID: storeID)
        dialogForFilter.setReserveTableButtonEnableDisable()
        dialogForFilter.onClickLeftButton = {
            dialogForFilter.removeFromSuperview()
        }
        dialogForFilter.onClickRightButton = {
            if currentBooking.bookingType == 1 {
                var mainView: UIStoryboard!
                mainView = UIStoryboard(name: "Cart", bundle: nil)
                currentBooking.isQrCodeScanBooking = false
                if let invoiceVC:InvoiceVC = mainView.instantiateViewController(withIdentifier: "InvoiceVC") as? InvoiceVC {
                    self.navigationController?.pushViewController(invoiceVC, animated: true)
                }
            } else {
                if currentBooking.selectedTable == nil {
                    self.btnBookTable.setTitle("store_filter_book_a_table".localized, for: .normal)
                } else {
                    self.btnBookTable.setTitle("edit_a_table".localized, for: .normal)
                }
            }
            dialogForFilter.removeFromSuperview()
        }
    }
}

extension UITableView{
    
    var isTableHeaderViewVisible: Bool {
        guard let tableHeaderView = tableHeaderView else {
            return false
        }
        let currentYOffset = self.contentOffset.y
        let headerHeight = tableHeaderView.frame.size.height - 160
        return currentYOffset < headerHeight
    }
    
}

extension ProductVC:UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate, ProductCellDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == tblForProduct {
            return 45
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isShowGroupItems{
            return 0
        }
        if tableView == tblForProduct {return (filteredArrProductItemList.count) }
        return 1
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.indexPathsForVisibleRows?.count ?? 0 > 0{
            if indexPath.row == (tableView.indexPathsForVisibleRows!.last!).row {
                let contentSize : CGSize = self.tblForProduct.contentSize
                tableViewContentHeight = contentSize.height
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == tblForProduct {
            return (filteredArrProductItemList[section].productDetail!.name)!
        }else {
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == tblForProduct {
            let sectionHeader = tableView.dequeueReusableCell(withIdentifier: "ProductSection")! as! ProductSection
            sectionHeader.setData(title:(filteredArrProductItemList[section].productDetail!.name)!,isTaxIncluded:(self.selectedStore?.isTaxInlcuded)!)
            if section == 0{
                sectionHeader.lbltaxInfo.isHidden = false
            }else{
                sectionHeader.lbltaxInfo.isHidden = true
            }
            return sectionHeader
        }else {
            return UIView.init()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblForProduct {
            productItemListLength = filteredArrProductItemList[section].items?.count ?? 0
            return productItemListLength!
        }
        return arrProductList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblForProduct {
            let productCell = tableView.dequeueReusableCell(with: ProductCell.self, for: indexPath)
            let currentProduct:ProductItem = filteredArrProductItemList[indexPath.section]
            let currentProductItem:ProductItemsItem = currentProduct.items![indexPath.row]
            productCell.setCellData(cellItem: currentProductItem, currency: selectedStore?.currency ?? "", isUpdateOrder: isFromUpdateOrder)
            productCell.delegate = self
            //productCell.layoutIfNeeded()
            return productCell
        }else {
            var cell:ProductSearchCell? =  tableView.dequeueReusableCell(with: ProductSearchCell.self, for: indexPath)
            if cell == nil {
                cell = ProductSearchCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cellForProductName")
            }
            cell?.setCellData(cellItem:(arrProductList?[indexPath.row])!)
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if tableView == tblForProduct {
            let currentProduct:ProductItem = filteredArrProductItemList[indexPath.section]
            let currentProductItem:ProductItemsItem = currentProduct.items![indexPath.row]
            if currentProductItem.isAdded && currentProductItem.specifications?.count ?? 0 == 0 {
                var cartProductItem = CartProductItems()
                var section: Int?
                var row: Int?
                let arrFitler = currentBooking.cart.filter { obj in
                    for objCartItem in obj.items ?? [] {
                        if objCartItem.item_id == currentProductItem._id {
                            cartProductItem = objCartItem
                            section = currentBooking.cart.firstIndex(where: {$0 === obj})
                            row = obj.items?.firstIndex(where: {$0 === objCartItem})
                            return true
                        }
                    }
                    return true
                }
                if arrFitler.count > 0 {
                    goToProductSpecification(currentProduct: cartProductItem, selectedIndexPath: IndexPath(row: row!, section: section!))
                }
                return
            }
            selecetedProduct = filteredArrProductItemList[indexPath .section]
            arrProductItemList = selecetedProduct?.items
            selectedProductItem = arrProductItemList![indexPath.row]
            let x:ProductCell = tableView.cellForRow(at: indexPath) as! ProductCell
            selectdedImage = x.imgProduct
            selectdedCellView = x.imgProduct
            if self.isFromUpdateOrder {
                self.goToEditOrderProductSpecification()
            }
            else {
                self.goToProductSPecificationVC()
            }
        }else {
            arrProductList?[indexPath.row].isProductFiltered = !(arrProductList?[indexPath.row].isProductFiltered)!
            tblForSearchItem.reloadData()
        }
    }
    
    func productCellButtonActions(sender: UIButton, cell: ProductCell) {
        if let indexPath = tblForProduct.indexPath(for: cell) {
            
            let arrProduct = filteredArrProductItemList[indexPath.section]
            let itemObj = arrProduct.items?[indexPath.row]
            
            if sender == cell.btnAdd {
                if itemObj?.specifications?.count ?? 0 > 0 {
                    self.tableView(tblForProduct, didSelectRowAt: indexPath)
                } else {
                    if(currentBooking.cart.count == 0) {
                        addToCart(indexPath: indexPath)
                    }else {
                        if (currentBooking.selectedStoreId!.compare((itemObj!.store_id!)) == .orderedSame) {
                            addToCart(indexPath: indexPath)
                        }else {
                            openClearCartDialog(indexPath: indexPath)
                        }
                    }
                }
            } else if sender == cell.btnPluse {
                if itemObj?.specifications?.count ?? 0 > 0 {
                    self.showChooseAndRepeat(indexPath: indexPath)
                } else {
                    if let item = itemObj {
                        if item.isAdded {
                            var cartProductItem = CartProductItems()
                            let arrFitler = currentBooking.cart.filter { obj in
                                for objCartItem in obj.items ?? [] {
                                    if objCartItem.item_id == itemObj?._id {
                                        cartProductItem = objCartItem
                                        return true
                                    }
                                }
                                return true
                            }
                            if arrFitler.count > 0 {
                               increaseQuantity(currentProductItem: cartProductItem)
                            }
                        }
                    }
                }
            } else if sender == cell.btnMinus {
                if !checkIsMultipleItemOrNot(indexPath: indexPath) {
                    if let item = itemObj {
                        if item.isAdded {
                            var cartProductItem = CartProductItems()
                            var section: Int?
                            var row: Int?
                            let arrFitler = currentBooking.cart.filter { obj in
                                for objCartItem in obj.items ?? [] {
                                    if objCartItem.item_id == itemObj?._id {
                                        cartProductItem = objCartItem
                                        section = currentBooking.cart.firstIndex(where: {$0 === obj})
                                        row = obj.items?.firstIndex(where: {$0 === objCartItem})
                                        return true
                                    }
                                }
                                return true
                            }
                            if item.quantity == 1 {
                                if arrFitler.count > 0 {
                                    removeItemFromCart(currentProductItem: cartProductItem, section: section ?? 0, row: row ?? 0)
                                }
                            } else {
                                if arrFitler.count > 0 {
                                   decreaseQuantity(currentProductItem: cartProductItem)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func checkIsMultipleItemOrNot(indexPath: IndexPath) -> Bool {
        let arrProduct = filteredArrProductItemList[indexPath.section]
        let itemObj = arrProduct.items?[indexPath.row]
        
        var arr = [CartProductItems]()
        for obj in currentBooking.cart {
            for objItem in (obj.items ?? []) {
                if objItem.item_id == (itemObj?._id ?? "") {
                    arr.append(objItem)
                }
            }
        }
        
        let isShowAlert: Bool = {
            if arr.count > 0 {
                let dics = arr.first!.getProductJson()
                for obj in arr {
                    if !obj.getProductJson().isEqual(to: dics as! [AnyHashable : Any]) {
                        return true
                    }
                }
            }
            return false
        }()
        
        if itemObj != nil {
            if itemObj?.specifications?.count ?? 0 > 0 {
                if isShowAlert {
                    showAttensionForRemoveProduct()
                }
                return isShowAlert
            } else {
                return false
            }
        }
        return false
    }
    
    func showAttensionForRemoveProduct() {
        
        let dailog = CustomAlertDialog.showCustomAlertDialog(title: "TXT_ATTENTION".localized, message: "txt_item_hase_multiple_customizations".localized, titleLeftButton: "", titleRightButton: "TXT_OK".localized)
        
        dailog.onClickLeftButton = {
            dailog.removeFromSuperview()
        }
        
        dailog.onClickRightButton = { [weak self] in
            guard let self = self else { return }
            dailog.removeFromSuperview()
            self.onClickBtnCart(self.btnGoToCart)
        }
    }
    
    func showChooseAndRepeat(indexPath: IndexPath) {
        let arrProduct = filteredArrProductItemList[indexPath.section]
        let itemObj = arrProduct.items?[indexPath.row]
 
        var arr = [CartProductItems]()
        for obj in currentBooking.cart {
            for objItem in (obj.items ?? []) {
                if objItem.item_id == (itemObj?._id ?? "") {
                    arr.append(objItem)
                }
            }
        }
        
        var strCustomization = ""
        var arrSpecification = [String]()
        if arr.count > 0 {

            let cartItem = arr.last!
            
            for obj in cartItem.specifications {
                for list in (obj.list ?? []) {
                    if list.quantity > 1 {
                        arrSpecification.append("\(list.name ?? "") (\(list.quantity))")
                    } else {
                        arrSpecification.append(list.name ?? "")
                    }
                }
            }
            
            if arrSpecification.count > 0 {
                strCustomization = arrSpecification.joined(separator: ", ")
            }
            
            let dialog = ChooseOrRepeat.showChooseOrRepeatDialog(title: "txt_repeat_last_or_not".localized, customization: "txt_customization".localized.replacingOccurrences(of: "****", with: strCustomization), titleLeftButton: "", strRepeat: "txt_repeat_product".localized, strChoose: "TXT_CUSTOMIZE".localized)
            
            dialog.onClickLeftButton = {
                dialog.removeFromSuperview()
            }
            
            dialog.onClickRightButton = { [weak self] in
                guard let self = self else { return }
                dialog.removeFromSuperview()
                
                var section = 0
                var row = 0
                
                for obj in currentBooking.cart {
                    for item in (obj.items ?? []) {
                        if cartItem.getProductJson().isEqual(to: item.getProductJson() as! [AnyHashable : Any]) {
                            section = currentBooking.cart.firstIndex(where: {$0.getProductJson() == obj.getProductJson()}) ?? 0
                            row = (obj.items ?? []).firstIndex(where: {$0.getProductJson() == item.getProductJson()}) ?? 0
                            break
                        }
                    }
                }
                
                currentBooking.cart[section].items![row] = cartItem
                currentBooking.cart[section].items![row].quantity = cartItem.quantity + 1
                currentBooking.cart[section].items![row].totalItemTax = cartItem.totalTax * Double((cartItem.quantity + 1))
                self.calculateTotalAmount()
                self.wsAddItemInServerCart()
            }
            
            dialog.onClickChoose = { [weak self] in
                guard let self = self else { return }
                dialog.removeFromSuperview()
                self.tableView(self.tblForProduct, didSelectRowAt: indexPath)
            }
        }
    }
}

//MARK: UICollectionView
extension ProductVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.arrProductGroupList.count > 0{
            return self.arrProductGroupList[0].productGroups.count
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if collectionView != collVHeader{
            let width1 = 260.0
            return CGSize(width: width1, height: width1/1.25)
        }else{
            let width1 = 260.0
            return CGSize(width: collVHeader.frame.height/1.25, height: collVHeader.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? ProductHeaderCollectionCell {
            cell.lblProductName.restartLabel()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView != collVHeader{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionCell", for: indexPath) as! ProductCollectionCell
            
            if self.arrProductGroupList[0].productGroups[indexPath.row].name != nil {
                cell.lblProductName.text = self.arrProductGroupList[0].productGroups[indexPath.row].name
            }else{
                cell.lblProductName.text = "TXT_PRODUCT_GROUP_NAME".localized
            }
            
            if self.arrProductGroupList[0].productGroups[indexPath.row].imageUrl.count <= 0{
                cell.imgProduct.image = UIImage.init(named: "placeholder")
            }else{

                cell.imgProduct.contentMode = .scaleAspectFit
                cell.imgProduct.downloadedFrom(link: Utility.getDynamicResizeImageURL(width: cell.imgProduct.frame.width, height: cell.imgProduct.frame.height, imgUrl: self.arrProductGroupList[0].productGroups[indexPath.row].imageUrl),isFromResize: true)
            }
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductHeaderCollectionCell", for: indexPath) as! ProductHeaderCollectionCell

            if selectedProductIDHeader.count > 0 && self.arrProductGroupList[0].productGroups[indexPath.row].id == selectedProductIDHeader{
                cell.lblProductName.textColor = UIColor.themeColor
            }else{
                cell.lblProductName.textColor = UIColor.themeTextColor
            }
            
            if self.arrProductGroupList[0].productGroups[indexPath.row].name != nil {
                cell.lblProductName.text = self.arrProductGroupList[0].productGroups[indexPath.row].name
            }else{
                cell.lblProductName.text = "TXT_PRODUCT_GROUP_NAME".localized
            }

            if self.arrProductGroupList[0].productGroups[indexPath.row].imageUrl.count <= 0{
                cell.imgProduct.image = UIImage.init(named: "placeholder")
            }else{
                cell.imgProduct.contentMode = .scaleAspectFit
                cell.imgProduct.downloadedFrom(link: Utility.getDynamicResizeImageURL(width: cell.imgProduct.frame.width, height:
                                                                                             cell.imgProduct.frame.height, imgUrl: self.arrProductGroupList[0].productGroups[indexPath.row].imageUrl),isFromResize: true)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.arrProductids.removeAll()
        if self.arrProductGroupList.count > 0{
            self.arrProductids.append(contentsOf: self.arrProductGroupList[0].productGroups[indexPath.item].product_ids)
        }
        print(self.arrProductids)

        
        if self.arrProductGroupList[0].productGroups[indexPath.item].name != nil {
            lblProductNameHeader.text = self.arrProductGroupList[0].productGroups[indexPath.row].name
        }else{
            lblProductNameHeader.text = "TXT_PRODUCT_GROUP_NAME".localized
        }
        
        if self.arrProductGroupList[0].productGroups[indexPath.item].imageUrl.count <= 0{
            imgProductHeader.image = UIImage.init(named: "placeholder")
        }else{
            imgProductHeader.contentMode = .scaleAspectFit
            imgProductHeader.downloadedFrom(link: Utility.getDynamicResizeImageURL(width: imgProductHeader.frame.width, height: imgProductHeader.frame.height, imgUrl: self.arrProductGroupList[0].productGroups[indexPath.row].imageUrl),isFromResize: true)
            
        }
        selectedProductIDHeader = self.arrProductGroupList[0].productGroups[indexPath.row].id
        selectedindexPathProductHeader = indexPath
        self.collVHeader.reloadData()

        self.wsGetProductGroupItemList(storeId: self.arrProductGroupList[0].productGroups[indexPath.item].storeId, groupID: self.arrProductGroupList[0].productGroups[indexPath.item].id)

    }
}

class ProductSection: CustomTableCell {
    
    //MARK:- OUTLET
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lbltaxInfo: UILabel!

    //MARK:- LIFECYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        lblProductName.backgroundColor = UIColor.themeViewBackgroundColor
        lblProductName.textColor = UIColor.themeTextColor
        lblProductName.font = FontHelper.textMedium(size: FontHelper.mediumLarge)
        lbltaxInfo.textColor = UIColor.themePromocodeGreenColor
        lbltaxInfo.font = FontHelper.textSmall()

    }
    
    func setData(title:String,isTaxIncluded:Bool) {
        lblProductName.text = title.appending("     ")
        lblProductName.sectionRound(lblProductName)
        
        if isTaxIncluded{
            lbltaxInfo.text = "TXT_INCLUSIVE_OF_ALL_TAXES".localized
        }else{
            lbltaxInfo.text = "TXT_EXCLUSIVE_OF_ALL_TAXES".localized
        }
    }
    
    //MARK:- SET CELL DATA
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
struct StoreDetail {
    var key: String
    var value: String
}
class ProductSearchCell: CustomTableCell {
    
    //MARK:- OUTLET
    
    @IBOutlet weak var imgButtonType: UIButton!
    @IBOutlet weak var lblProductName: UILabel!
    
    //MARK:- LIFECYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor =  UIColor.themeViewBackgroundColor
        self.backgroundColor = UIColor.themeViewBackgroundColor
        lblProductName.font = FontHelper.textRegular()
        lblProductName.textColor = UIColor.themeTextColor
        imgButtonType.setImage( UIImage.init(named: "checked_checkbox_icon")?.imageWithColor(color: UIColor.themeColor)
                                , for: UIControl.State.selected)
        imgButtonType.setImage( UIImage.init(named: "unchecked_checkbox_icon"), for: UIControl.State.normal)
    }
    
    //MARK:- SET CELL DATA
    func setCellData(cellItem:ProductItem) {
        lblProductName.text = cellItem.productDetail?.name
        imgButtonType.isSelected = cellItem.isProductFiltered
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    override func updateUIAccordingToTheme() {
        imgButtonType.setImage( UIImage.init(named: "checked_checkbox_icon")?.imageWithColor(color: UIColor.themeTextColor)
                                , for: UIControl.State.selected)
        imgButtonType.setImage(UIImage.init(named: "unchecked_checkbox_icon")
                               , for: UIControl.State.normal)
    }
}

extension ProductVC : UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        switch operation {
            case .push:

                if toVC is ProductSpecificationVC {
                    var isCartVCFound: Bool = false
                    self.navigationController?.viewControllers.forEach({ (vc) in
                        if vc.isKind(of: CartVC.self) {
                            isCartVCFound = true
                        }
                    })

                    if isCartVCFound {
                        return nil
                    }else {
                        var frame:CGRect = (selectdedCellView?.frame)!
                        frame.origin = selectdedImage!.superview!.convert(selectdedImage!.frame, to: nil).origin
                        transition.productToProductSpecificationData.imgOriginFrame = frame
                        transition.productToProductSpecificationData.image = selectdedImage?.image ?? UIImage.init()
                        transition.isPresenting = true
                        transition.transtionFromTo = TransitionFromTo.ProductToProductSpecification
                        return transition
                    }
                }
                return nil

            case .pop:
                if fromVC is ProductSpecificationVC {
                    var isCartVCFound: Bool = false
                    self.navigationController?.viewControllers.forEach({ (vc) in
                        if vc.isKind(of: CartVC.self) {
                            isCartVCFound = true
                        }
                    })

                    if isCartVCFound {
                        return nil
                    }else {
                        transition.isPresenting = false
                        let tempFrame = transition.productToProductSpecificationData.imgOriginFrame
                        transition.productToProductSpecificationData.imgOriginFrame = transition.productToProductSpecificationData.imgDestFrame
                        transition.productToProductSpecificationData.imgDestFrame = tempFrame
                        transition.transtionFromTo = TransitionFromTo.ProductSpecificationToProduct
                        for viewController in self.navigationController?.viewControllers ?? []
                        {
                            if viewController is StoreVC
                            {
                                self.navigationController?.delegate = (viewController as! StoreVC)
                            }
                        }
                        return transition
                    }

                }else if fromVC is ProductVC {

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

