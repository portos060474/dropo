//
//  HomeCell.swift
//  edelivery
//
//  Created by Elluminati on 15/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
import  ImageIO
import SDWebImage

protocol ProductCellDelegate: AnyObject {
    func productCellButtonActions(sender: UIButton, cell: ProductCell)
}

class ProductCell: CustomTableCell {
    
    //MARK:- OUTLET
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductDescription: UILabel!
    @IBOutlet weak var lblPricerWithoutOffer: UILabel!
    @IBOutlet weak var viewForProduct: UIView!
    @IBOutlet weak var viewForImage: UIView!
    
    @IBOutlet weak var viewQtyMain: UIView!
    @IBOutlet weak var viewQty: UIView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnPluse: UIButton!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var lblQty: UILabel!
    
    @IBOutlet weak var lblLine1: UILabel!
    @IBOutlet weak var lblLine2: UILabel!
    
    weak var delegate: ProductCellDelegate?
    
    //MARK:- LIFECYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        //Colors
        lblProductName.textColor = UIColor.themeTextColor
        lblPricerWithoutOffer.textColor = UIColor.themeTextColor
        lblProductDescription.textColor = UIColor.themeLightTextColor
        lblPrice.textColor = UIColor.themeTextColor
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        viewForProduct.backgroundColor = UIColor.themeViewBackgroundColor
        
        /* Set Font */
        lblPricerWithoutOffer.font = FontHelper.textSmall()
        self.lblProductName.font = FontHelper.textMedium(size: 17)
        self.lblPrice.font = FontHelper.textMedium(size: 17)
        self.lblProductDescription.font = FontHelper.textSmall()
        self.imgProduct.isHidden = true
        self.viewForImage.isHidden = true
        imgProduct.setRound(withBorderColor: UIColor.clear, andCornerRadious: 8.0, borderWidth: 0.5)
        
        DispatchQueue.main.async { [weak self] in
            self?.viewQtyMain.setRound(withBorderColor: UIColor.themeColor, andCornerRadious: (self?.viewQtyMain.frame.size.height ?? 35)/2, borderWidth: 1)
        }
        
        btnAdd.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnPluse.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnMinus.setTitleColor(UIColor.themeTextColor, for: .normal)

        lblLine1.backgroundColor = UIColor.themeViewLightBackgroundColor
        lblLine2.backgroundColor = UIColor.themeViewLightBackgroundColor
        
        btnAdd.titleLabel?.font = FontHelper.textRegular(size: 12)
        
        lblQty.font = FontHelper.textRegular(size: 12)
        lblQty.textColor = UIColor.themeTextColor
        lblQty.isUserInteractionEnabled = true
    }
    
    //MARK:- SET CELL DATA
    func setCellData(cellItem:ProductItemsItem, currency:String, isUpdateOrder: Bool = false) {
        
        viewQty.isHidden = true
        btnAdd.isHidden = false
        
        cellItem.currency = currency
        
        if !(cellItem.image_url?.isEmpty)! {
            imgProduct.downloadedFrom(link: Utility.getDynamicResizeImageURL(width: imgProduct.frame.width , height:
                                                                                    imgProduct.frame.height, imgUrl:
                                                                                    (cellItem.image_url?[0])!),
                                                                                    mode:.scaleAspectFit, isFromResize: true)
            self.viewForImage.isHidden = false
        }else {
            self.viewForImage.isHidden = true
            imgProduct.isHidden = true
            imgProduct.image = UIImage.init(named: "placeholder")
        }
        
        lblProductName.text = cellItem.name!
        lblProductDescription.text = String(cellItem.details!)
        if cellItem.itemPriceWithoutOffer! > 0.0 {
            
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string:cellItem.currency + " " + (cellItem.itemPriceWithoutOffer).toString())
            
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
            
            lblPricerWithoutOffer.attributedText =  attributeString
        }else {
            lblPricerWithoutOffer.text = ""
        }
        if cellItem.price! > 0.0 {
            lblPrice.text = cellItem.currency + " " + (cellItem.price ?? 0.0).toString()
        }else {
            var price:Double = 0.0
            if cellItem.specifications != nil{
                lblPrice.text = cellItem.currency + " " + calculatePrice(arr: cellItem.specifications ?? []).toString()
            }
        }
        
        if cellItem.isAdded && !isUpdateOrder {
            viewQty.isHidden = false
            lblQty.text = "\(cellItem.quantity)"
            btnAdd.isHidden = true
        } else {
            if cellItem.specifications?.count ?? 0 > 0 {
                btnAdd.setTitle("TXT_CUSTOMIZE".localized, for: .normal)
            } else {
                btnAdd.setTitle("TXT_ADD_TEXT".localized, for: .normal)
            }
            btnAdd.isHidden = false
            viewQty.isHidden = true
        }
        
        self.layoutIfNeeded()
    }
    
    func calculatePrice(arr: [Specifications]) -> Double {
        var arrSpecificationList = [Specifications]()
        
        var arrReArrage = [Specifications]()
        arrReArrage = arr.filter({!$0.isAssociated})
        
        for obj in arrReArrage {
            arrSpecificationList.append(obj)
        }
        
        let arrId = arrSpecificationList.map({$0._id})
        var arrSelected = [SpecificationListItem]()
        
        for obj in arrSpecificationList {
            for objList in (obj.list ?? []) {
                if objList.is_default_selected {
                    arrSelected.append(objList)
                }
            }
        }
        
        for objMain in arr {
            for obj in arrSelected {
                if objMain.modifierId == obj._id && !arrId.contains(objMain._id) {
                    arrSpecificationList.append(objMain)
                } else if objMain.modifierId == obj._id && arrId.contains(objMain._id){
                    if let index = arrSpecificationList.firstIndex(where: {$0._id == objMain._id}) {
                        arrSpecificationList.remove(at: index)
                        arrSpecificationList.insert(objMain, at: index)
                    }
                }
            }
        }
        
        var price: Double = 0
        
        for specification in arrSpecificationList {
            for listItem in specification.list! {
                if listItem.is_default_selected
                {
                    price = price + ((listItem.price) ?? 0.0)
                }
            }
        }
        
        return price
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.contentView.backgroundColor = UIColor.green
        } else {
            self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        }
    }
    
    @IBAction func onClickButton(_ sender: UIButton) {
        delegate?.productCellButtonActions(sender:sender, cell: self)
    }
    
}


