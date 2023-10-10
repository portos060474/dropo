//
//  HomeCell.swift
//  edelivery
//
//  Created by Elluminati on 15/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class StoreCell: CustomCollectionCell {
    
    //MARK:- OUTLET
    @IBOutlet weak var imgStore: UIImageView!
    @IBOutlet weak var lblShopClosed: UILabel!
    @IBOutlet weak var lblStoreReopenAt: UILabel!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var imgRate: UIImageView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblStoreName: UILabel!
    @IBOutlet weak var lblStoreEstimatedTime: UILabel!
    @IBOutlet weak var viewForClosedStore: UIView!
    @IBOutlet weak var viewForStoreCell: UIView!
    @IBOutlet weak var viewForStore: UIView!
    @IBOutlet weak var btnFav: UIButton!
    @IBOutlet weak var viewForRating: UIView!
    @IBOutlet weak var lblPriceLevel: UILabel!
    @IBOutlet weak var lblSeperator1: UILabel!
    @IBOutlet weak var lblSeperator2: UILabel!
    @IBOutlet weak var btnUnFav: UIButton!
    
    var storeItem:StoreItem?
   
    //MARK:- LIFECYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        imgStore.setRound(withBorderColor: UIColor.white, andCornerRadious: 5.0, borderWidth: 1.0)
        lblShopClosed.textColor = UIColor.themeButtonTitleColor
        lblShopClosed.backgroundColor = UIColor.themeRedColor
        lblPriceLevel.textColor = UIColor.themeLightTextColor
        viewForStoreCell.setRound(withBorderColor: UIColor.clear, andCornerRadious: 3.0, borderWidth: 0.5)
        viewForStoreCell.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        self.backgroundColor = UIColor.themeViewBackgroundColor
        viewForStore.backgroundColor = UIColor.themeViewBackgroundColor
        lblStoreEstimatedTime.font = FontHelper.textRegular(size: FontHelper.small)
        lblRate.font = FontHelper.textSmall()
        lblStoreName.font = FontHelper.textMedium(size: FontHelper.text17)
        lblPrice.font = FontHelper.textRegular(size: FontHelper.labelRegular)
        lblPriceLevel.font = FontHelper.textMedium(size: FontHelper.small)
        lblStoreReopenAt.font = FontHelper.textRegular()
        viewForRating.backgroundColor = UIColor.themeColor
        lblShopClosed.applyRoundedCornersWithHeight()
    }
    //MARK:- SET CELL DATA
    func setCellData(cellItem:StoreItem, isFromFavStore:Bool = false) {
        
        self.storeItem = cellItem
        updateUI(isStoreOpen: !cellItem.isStoreClosed, reopenAt: cellItem.reopenAt,isStoreBusy: cellItem.isStoreBusy)
        
        if (preferenceHelper.getUserId().isEmpty()) {
            btnFav.isHidden = true
            btnUnFav.isHidden = true
        }else {
            btnFav.isHidden = false
            btnFav.isSelected = currentBooking.favouriteStores.contains(cellItem._id ?? "")
            cellItem.isFavourite =  btnFav.isSelected
            btnFav.alpha = btnFav.isSelected ? 1 : 0.8
            if isFromFavStore{
                btnFav.isHidden = true
                btnUnFav.isHidden = cellItem.isUnFav
            }else{
                btnFav.isHidden = false
                btnUnFav.isHidden = true
            }
        }
        imgStore.image = nil
        imgStore.contentMode = .scaleAspectFit
        imgStore.downloadedFrom(link: Utility.getDynamicResizeImageURL(width: imgStore.frame.width, height: imgStore.frame.height, imgUrl: cellItem.image_url!),mode: .scaleAspectFit, isFromResize: true)
        
        imgStore.contentMode = UIView.ContentMode.scaleAspectFill
        lblStoreName.text = cellItem.name ?? ""
        lblRate.text = String(cellItem.rate ?? 0.0)
        
        lblPrice.text = cellItem.strFamousProductsTagsWithComma
        
        if cellItem.deliveryMaxTime > cellItem.deliveryTime {
            lblStoreEstimatedTime.text = String(cellItem.deliveryTime!) + " - " + String(cellItem.deliveryMaxTime!) + " "  + "UNIT_MIN".localizedLowercase
        }else {
            lblStoreEstimatedTime.text = String(cellItem.deliveryTime!) + " "  + "UNIT_MIN".localizedLowercase
        }
        lblStoreEstimatedTime.textColor = UIColor.themeLightTextColor
        lblRate.textColor = UIColor.themeButtonTitleColor
        lblStoreName.textColor = UIColor.themeTextColor
        lblPrice.textColor = UIColor.themeLightTextColor
        viewForRating.applyRoundedCornersWithHeight()
        imgStore.setRound(withBorderColor: UIColor.clear, andCornerRadious: 5.0, borderWidth: 0.5)
        let priceTag = Utility.numberOfTag(numberOfTags: cellItem.price_rating ?? 0, currency: cellItem.currency)
        lblPriceLevel.text = priceTag
        imgStore.backgroundColor = isFromFavStore ? .themeLightTextColor : .clear
    }
    
    func updateUI(isStoreOpen:Bool = true, reopenAt:String = "00:00",isStoreBusy:Bool = false) {
        
        if isStoreOpen {
            if isStoreBusy {
                viewForClosedStore.isHidden = false
                lblShopClosed.text = "TXT_BUSY".localizedCapitalized
                lblStoreReopenAt.text = ""
            }else {
                viewForClosedStore.isHidden = true
            }
        }else {
            viewForClosedStore.isHidden = false
            lblShopClosed.text = "TXT_CLOSED".localizedCapitalized
            lblStoreReopenAt.text = reopenAt
        }
        
    }
    
    @IBAction func onClickBtnFav(_ sender: UIButton) {
        if sender.isSelected {
            wsRemoveFavStore()
        }else {
            wsAddFavStore()
        }
    }
    
    @IBAction func onClickBtnUnFav(_ sender: UIButton) {
        sender.isHidden = true
        storeItem?.isUnFav = true
        storeItem?.isSelectedToDelete = true
    }
    
    //WEb service Favourite store
    func wsAddFavStore() {
        Utility.showLoading()
        let dictParam : [String : Any] =
            [PARAMS.USER_ID : preferenceHelper.getUserId(),
             PARAMS.STORE_ID: (self.storeItem?._id) ?? " "
        ]
        let alamoFire:AlamofireHelper = AlamofireHelper()
        alamoFire.getResponseFromURL(url: WebService.WS_ADD_FAVOURITE_STORE, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Utility.hideLoading()
            Parser.parseFavouriteStores(response, completion: { (result) in
                
                if result
                {
                    self.btnFav.isSelected = !self.btnFav.isSelected
                    self.storeItem?.isFavourite = self.btnFav.isSelected
                }
                
            })
        }
    }
    
    func wsRemoveFavStore() {
        Utility.showLoading()
        let dictParam : [String : Any] =
            [PARAMS.USER_ID : preferenceHelper.getUserId(),
             PARAMS.STORE_ID: [(self.storeItem?._id) ?? " "],
             PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken()]
        let alamoFire:AlamofireHelper = AlamofireHelper()
        alamoFire.getResponseFromURL(url: WebService.WS_REMOVE_FAVOURITE_STORE, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Utility.hideLoading()
            Parser.parseFavouriteStores(response, completion: { (result) in
                if result {
                    self.btnFav.isSelected = !self.btnFav.isSelected
                    self.storeItem?.isFavourite = self.btnFav.isSelected
                }
                
            })
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        imgStore.image = nil
    }
}

