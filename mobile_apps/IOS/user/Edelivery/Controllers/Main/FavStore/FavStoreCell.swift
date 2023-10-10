//
//  FavStoreCell.swift
//  edelivery
//
//  Created by Elluminati on 15/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit



import UIKit

class FavStoreCell: CustomTableCell {
    
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
    @IBOutlet weak var btnCheckBox: UIButton!
    var storeItem:StoreItem?
    
    //MARK:- LIFECYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgStore.setRound(withBorderColor: UIColor.white, andCornerRadious: 3.0, borderWidth: 1.0)
        lblShopClosed.setRound(withBorderColor: UIColor.white, andCornerRadious: 3.0)
        lblShopClosed.textColor = UIColor.themeButtonTitleColor
        lblShopClosed.backgroundColor = UIColor.themeRedColor
        viewForStoreCell.setRound(withBorderColor: UIColor.clear, andCornerRadious: 3.0, borderWidth: 0.5)
        viewForStoreCell.setShadow(shadowColor: UIColor.darkGray.cgColor, shadowOffset: CGSize.init(width: 0.0, height: 0.0), shadowOpacity: 0.8, shadowRadius: 3.0)
        viewForStoreCell.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        self.backgroundColor = UIColor.themeViewBackgroundColor
        viewForStore.backgroundColor = UIColor.white
        
        /* Set Font */
        lblStoreEstimatedTime.font = FontHelper.textMedium()
        lblRate.font = FontHelper.textRegular()
        lblStoreName.font = FontHelper.textMedium()
        lblPrice.font = FontHelper.textRegular()
    }
    
    //MARK:- SET CELL DATA
    func setCellData(cellItem:StoreItem) {
        
        self.storeItem = cellItem
        updateUI(isStoreOpen: !cellItem.isStoreClosed, reopenAt: cellItem.reopenAt,isStoreBusy: cellItem.isStoreBusy)
        btnCheckBox.isSelected =  cellItem.isSelectedToDelete
        imgStore.downloadedFrom(link: Utility.getDynamicResizeImageURL(width: imgStore.frame.width, height: imgStore.frame.height, imgUrl: cellItem.image_url!),isFromResize: true)
        imgStore.contentMode = UIView.ContentMode.scaleAspectFill
        lblStoreName.text = cellItem.name!
        lblPrice.text =  cellItem.strFamousProductsTagsWithComma
        lblRate.text = String(cellItem.rate ?? 0.0)  + "(\(String(cellItem.rate_count ?? 0)))"
        if cellItem.deliveryMaxTime > cellItem.deliveryTime {
            lblStoreEstimatedTime.text = String(cellItem.deliveryTime!) + " - " + String(cellItem.deliveryMaxTime!) + "  "  + "UNIT_MIN".localizedLowercase
        }else {
            lblStoreEstimatedTime.text = String(cellItem.deliveryTime!) + "  "  + "UNIT_MIN".localizedLowercase
        }
        lblStoreEstimatedTime.textColor = UIColor.themeLightTextColor
        lblRate.textColor = UIColor.themeLightTextColor
        lblStoreName.textColor = UIColor.themeTextColor
        lblPrice.textColor = UIColor.themeLightTextColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
    
   
    @IBAction func onClickCheckBox(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        }else {
            sender.isSelected = true
        }
        self.storeItem?.isSelectedToDelete = sender.isSelected
    }
    
}
