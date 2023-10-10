//
//  SplashVC.swift
//  Store
//
//  Created by Jaydeep Vyas on 18/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
class CourierHistoryDetailVC: BaseVC{
    
    @IBOutlet var collectionForCourierImages: UICollectionView!
    @IBOutlet var lblOrderNumber: UILabel!
    @IBOutlet var imgEmptyView: UIImageView!
    
    var orderId:Int = 0
    var arrForImageUrls: [String] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideBackButtonTitle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLocalization()
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool){
        super.viewDidDisappear(animated)
    }
    
    func setLocalization() {
        self.setNavigationTitle(title:"TXT_COURIER_DETAIL".localizedCapitalized)
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        self.lblOrderNumber.text = "TXT_ORDER_NO".localized + String(orderId)
        self.lblOrderNumber.textColor = UIColor.themeTextColor
        self.lblOrderNumber.font = FontHelper.labelRegular()
        self.reloadCollectionView()
        if  arrForImageUrls.isEmpty {
            imgEmptyView.isHidden = false
            self.collectionForCourierImages.isHidden = true
        }else {
            imgEmptyView.isHidden = true
            self.collectionForCourierImages.isHidden = false
        }
    }
    
}

extension CourierHistoryDetailVC: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    //MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrForImageUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellForAddImage", for: indexPath) as! ImageCollectionViewCell
      cell.imgCollection.downloadedFrom(link: Utility.getDynamicResizeImageURL(width: cell.imgCollection.frame.width, height: cell.imgCollection.frame.height, imgUrl: arrForImageUrls[indexPath.row]),isFromResize: true)
      cell.btnDeleteImage.isHidden = true
      return cell
    }
    
    //MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func reloadCollectionView() {
        collectionForCourierImages.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let square = (collectionView.bounds.width / 3) - 10
        return CGSize(width: square, height:square)
    }
    
}


