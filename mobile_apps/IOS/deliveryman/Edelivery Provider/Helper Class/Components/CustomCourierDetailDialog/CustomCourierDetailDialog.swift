//
//  CustomPhotoDialog.swift
//  edelivery
//
//  Created by Elluminati on 22/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import UIKit
import SKPhotoBrowser

public class CustomCourierDetailDialog: CustomDialog,UITextFieldDelegate {
    //MARK:- OUTLETS

    @IBOutlet weak var alertView: UIView!
    @IBOutlet var collectionForCourierImages: UICollectionView!
    @IBOutlet var btnDone: UIButton!
    var onClickDoneButton : (() -> Void)? = nil
    static let  dialogXibName = "dialogForCourierDetail"
    @IBOutlet var lblCourierDetail: UILabel!
    @IBOutlet var lblOrderNumber: UILabel!
    var order: Order = Order.init(dictionary: [:]) ?? Order.init()
    
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var tblSpecification: UITableView!
    @IBOutlet weak var heightTbl: NSLayoutConstraint!
    
    var arrSpecifications = [OrderSpecification]()
    
    public override func awakeFromNib() {
        self.collectionForCourierImages.register(UINib(nibName: "CollectionViewImageCell", bundle: nil), forCellWithReuseIdentifier: "cellForImage")
    }
    
    public static func  showCustomCourierDetailDialog
    (orderDetail:Order,
     titleDoneButton:String) ->
    CustomCourierDetailDialog {
        let view = UINib(nibName: dialogXibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomCourierDetailDialog
        view.setTableview()
        view.alertView.setShadow()
        view.order = orderDetail
        view.setCourierData()
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame;
        view.btnDone.setTitle(titleDoneButton.uppercased(), for: UIControl.State.normal)
        view.collectionForCourierImages.delegate = view
        view.collectionForCourierImages.dataSource = view
        view.reloadCollectionView()
        APPDELEGATE.window?.addSubview(view)
        APPDELEGATE.window?.bringSubviewToFront(view);
        view.alertView.layoutIfNeeded()
        view.animationBottomTOTop(view.alertView)
        return view;
    }
    
    @IBAction func onClickBtnDone(_ sender: Any) {
        if self.onClickDoneButton != nil {
            self.animationForHideAView(alertView) {
                self.onClickDoneButton!();
            }
        }
    }
    
    func setCourierData() {
        lblOrderNumber.text = "TXT_ORDER_NO".localized + String(order.orderUniqueId ?? 0)
        lblOrderNumber.textColor = UIColor.themeLightTextColor
        lblOrderNumber.font = FontHelper.textRegular()
        
        lblCourierDetail.textColor = UIColor.themeTextColor
        lblCourierDetail.font = FontHelper.textLarge()
        lblCourierDetail.text = "TXT_COURIER_DETAIL".localized
        alertView.backgroundColor = .themeAlertViewBackgroundColor
        collectionForCourierImages.backgroundColor = .themeViewBackgroundColor
        self.alertView.updateConstraintsIfNeeded()
        self.alertView.roundCorner(corners: [.topRight , .topLeft], withRadius: 20)
        
        btnCancel.setTitleColor(UIColor.themeIconTintColor, for: .normal)
        btnCancel.tintColor = UIColor.themeColor
        //btnCancel.setTitle("TXT_DONE".localizedUppercase, for: .normal)
        btnCancel.setTitle("", for: .normal)
        btnCancel.setImage(UIImage.init(named: "close")?.imageWithColor(), for: .normal)
        
        arrSpecifications.removeAll()
        for obj in (order.orderDetails ?? []) {
            for objList in (obj.items ?? []) {
                for objSp in (objList.specifications ?? []) {
                    arrSpecifications.append(objSp)
                }
            }
        }
        
        if arrSpecifications.count > 0 {
            tblSpecification.isHidden = false
        } else {
            tblSpecification.isHidden = true
        }
        
        tblSpecification.reloadData()
        
        if order.image_url.count > 0 {
            collectionForCourierImages.isHidden = false
        } else {
            collectionForCourierImages.isHidden = true
        }
        
    }
    
    func setTableview() {
        tblSpecification.delegate = self
        tblSpecification.dataSource = self
        tblSpecification.separatorColor = .clear
        tblSpecification.register(cellType: CourierSpecificationCell.self)
        tblSpecification.register(cellTypes: [CourierSpecificationCell.self, CourierSpecificationTitleCell.self])
        tblSpecification.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        heightTbl.constant = tblSpecification.contentSize.height
    }
    
    @IBAction func onClickBtnCancel(_ sender: Any) {
        //self.endEditing(true)
        self.animationForHideAView(alertView) {
            self.removeFromSuperview();
        }
        
    }
}


extension CustomCourierDetailDialog: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    //MARK: UICollectionViewDataSource
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return order.image_url.count
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellForImage", for: indexPath) as! CollectionViewImageCell
        cell.imageItem.downloadedFrom(link:order.image_url[indexPath.row])
        cell.backgroundColor = .themeViewBackgroundColor
        return cell
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var images = [SKPhoto]()
        for obj in order.image_url {
            let photo = SKPhoto.photoWithImageURL(WebService.BASE_URL_ASSETS + obj)
            photo.shouldCachePhotoURLImage = true
            images.append(photo)
        }
        SKPhotoBrowserOptions.displayAction = false
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(indexPath.row)
        window?.rootViewController?.present(browser, animated: true, completion: {})
    }
    
    //MARK: UICollectionViewDelegateFlowLayout
    func reloadCollectionView() {
        collectionForCourierImages.reloadData()
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let square = (collectionView.bounds.width / 3) - 10
        return CGSize(width: square, height:square)
    }
    
}

extension CustomCourierDetailDialog: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: UITableViewDataSource
    public func numberOfSections(in tableView: UITableView) -> Int {
        return arrSpecifications.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSpecifications[section].list?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = tableView.dequeueReusableCell(withIdentifier: "CourierSpecificationTitleCell")! as! CourierSpecificationTitleCell
        let obj = arrSpecifications[section]
        sectionHeader.setData(data: obj)
        return sectionHeader
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourierSpecificationCell", for: indexPath) as! CourierSpecificationCell
        let objSpecificationList = arrSpecifications[indexPath.section].list ?? []
        let obj = objSpecificationList[indexPath.row]
        cell.setData(data: obj)
        cell.selectionStyle = .none
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
