//
//  SplashVC.swift
//  Store
//
//  Created by Jaydeep Vyas on 18/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
import SKPhotoBrowser

class CourierDetailVC: BaseVC {
    
    @IBOutlet var collectionForCourierImages: UICollectionView!
    @IBOutlet var lblOrderNumber: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var btnLeft: UIButton!
    @IBOutlet var alertView: UIView!
    @IBOutlet var heightForCollection: NSLayoutConstraint!
    @IBOutlet var pickUpImage: UIImageView!
    @IBOutlet var lblDeliveryBy: UILabel!
    @IBOutlet var lblDeliverTo: UILabel!
    @IBOutlet var lblAddress: UILabel!
    
    @IBOutlet var tblCartItem: UITableView!
    @IBOutlet var heightTbl: NSLayoutConstraint!
    var arrSpecifications = [Specifications]()
    
    var pickUpImageUrl: String =  ""
    var selectedOrder: Order = Order.init()
    var orderList: HistoryOrderList = HistoryOrderList.init()
    var historyResponse: HistoryOrderDetailResponse?
    var isFromHistory = false
    var arrImageURL = [String]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setLocalization()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onClickTapOnImage))
        pickUpImage.isUserInteractionEnabled = true
        pickUpImage.addGestureRecognizer(tap)
        
        self.hideBackButtonTitle()
        
        if pickUpImageUrl != "" {
            pickUpImage.isHidden = false
            pickUpImage.downloadedFrom(link: Utility.getDynamicResizeImageURL(width: pickUpImage.frame.width, height: pickUpImage.frame.height, imgUrl: pickUpImageUrl),isFromResize: true)
            heightForCollection.constant = UIScreen.main.bounds.width - 2*16
        }
        else {
            if isFromHistory {
                arrImageURL = orderList.image_url
                arrSpecifications.removeAll()
                for obj in (historyResponse?.cartDetail?.orderDetails ?? []) {
                    for objItem in (obj.items ?? []) {
                        for objSpecification in objItem.specifications {
                            arrSpecifications.append(objSpecification)
                        }
                    }
                }
            } else {
                arrImageURL = selectedOrder.image_urls
                arrSpecifications.removeAll()
                for obj in (selectedOrder.cartDetail?.orderDetails ?? []) {
                    for objSpecification in (obj.items ?? []) {
                        arrSpecifications.append(contentsOf: objSpecification.specifications)
                    }
                }
            }
            if arrImageURL.count == 0 {
                heightForCollection.constant = 0
                collectionForCourierImages.isHidden = true
            } else {
                pickUpImage.isHidden = true
                self.reloadCollectionView()
                DispatchQueue.main.async { [unowned self] in
                    self.heightForCollection.constant = (self.collectionForCourierImages.bounds.width / 3) - 10
                }
                collectionForCourierImages.isHidden = false
            }
        }
        tblCartItem.isHidden = !(arrSpecifications.count > 0)
        tblCartItem.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.animationBottomTOTop(self.alertView)
        tblCartItem.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        alertView.applyTopCornerRadius()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
        tblCartItem.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func viewDidDisappear(_ animated: Bool){
        super.viewDidDisappear(animated)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        heightTbl.constant = tblCartItem.contentSize.height
    }
    
    @objc func onClickTapOnImage() {
        guard let img = pickUpImage.image else { return }
        
        var images = [SKPhoto]()
        let photo = SKPhoto.photoWithImage(img)
        images.append(photo)

        SKPhotoBrowserOptions.displayAction = false
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(0)
        present(browser, animated: true, completion: {})
    }
    
    func setLocalization() {
        self.view.backgroundColor = .themeOverlayColor
        self.alertView.backgroundColor = .themeViewBackgroundColor
        self.setNavigationTitle(title:"TXT_COURIER_DETAIL".localizedCapitalized)
        self.lblOrderNumber.text = "TXT_ORDER_NO".localized + String((self.selectedOrder.unique_id) ?? 0)
        self.lblOrderNumber.textColor = UIColor.themeTextColor
        self.lblOrderNumber.font = FontHelper.labelRegular()
        lblTitle.text = "TXT_COURIER_DETAIL".localizedCapitalized
        lblTitle.font = FontHelper.textLarge()
        lblTitle.textColor = .themeTitleColor
        btnLeft.tintColor = .themeColor
        btnLeft.setImage(UIImage.init(named: "cancelIcon")?.imageWithColor(color: .themeColor), for: .normal)
        
        lblDeliveryBy.text = "TXT_ORDER_RECEVIED_BY".localizedCapitalized
        lblDeliveryBy.font = FontHelper.textMedium(size: 13)
        lblDeliveryBy.textColor = .themeLightTextColor
        
        lblDeliverTo.font = FontHelper.textMedium(size: 17)
        lblDeliverTo.textColor = .themeTitleColor
        
        lblAddress.font = FontHelper.textRegular()
        lblAddress.textColor = .themeTitleColor
        
        if isFromHistory {
            lblDeliverTo.text = orderList.destination_addresses?[0].userDetails?.name ?? ""
            lblAddress.text = orderList.destination_addresses?[0].address ?? ""
        } else {
            lblDeliverTo.text = selectedOrder.destination_addresses?[0].userDetails?.name ?? ""
            lblAddress.text = selectedOrder.destination_addresses?[0].address ?? ""
        }
        
        setCartTableView()
    }
    
    func setConstraintForCollectionView() {
        if collectionForCourierImages.contentSize.height >= (UIScreen.main.bounds.height - (140 + UIApplication.shared.statusBarFrame.height)) {
            heightForCollection.constant = (UIScreen.main.bounds.height - (140 + UIApplication.shared.statusBarFrame.height))
        }else {
            heightForCollection.constant = collectionForCourierImages.contentSize.height + collectionForCourierImages.frame.origin.y
        }
    }
    
    func setCartTableView() {
        tblCartItem.delegate = self
        tblCartItem.dataSource = self
        tblCartItem.separatorColor = .clear
        tblCartItem.backgroundColor = .clear
        if #available(iOS 15.0, *) {
            tblCartItem.sectionHeaderTopPadding = 0
        }
        tblCartItem.register(cellTypes: [CourierSpecificationCell.self, CourierSpecificationTitleCell.self])
    }
    
    @IBAction func onClickClose(_ sender: UIButton)  {
        self.view.animationForHideView(alertView) {
            
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    override func updateUIAccordingToTheme() {
        setLocalization()
    }
}

extension CourierDetailVC: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    //MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImageURL.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellForAddImage", for: indexPath) as! ImageCollectionViewCell
       cell.imgCollection.downloadedFrom(link:arrImageURL[indexPath.row])
        //cell.imgCollection.delegate = self
       cell.btnDeleteImage.isHidden = true
       return cell
    }
    
    //MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var images = [SKPhoto]()
        for obj in arrImageURL {
            let photo = SKPhoto.photoWithImageURL(WebService.BASE_URL_ASSETS + obj)
            photo.shouldCachePhotoURLImage = true
            images.append(photo)
        }
        SKPhotoBrowserOptions.displayAction = false
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(indexPath.row)
        present(browser, animated: true, completion: {})
    }
    
    func reloadCollectionView() {
        collectionForCourierImages.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let square = (collectionView.bounds.width / 3) - 10
        return CGSize(width: square, height:square)
    }
    
}

extension CourierDetailVC: UITableViewDelegate,UITableViewDataSource {
    
    //MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrSpecifications.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSpecifications[section].list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = tableView.dequeueReusableCell(withIdentifier: "CourierSpecificationTitleCell")! as! CourierSpecificationTitleCell
        let obj = arrSpecifications[section]
        sectionHeader.setData(data: obj)
        return sectionHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourierSpecificationCell", for: indexPath) as! CourierSpecificationCell
        let objSpecificationList = arrSpecifications[indexPath.section].list ?? []
        let obj = objSpecificationList[indexPath.row]
        cell.setData(data: obj)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
