//
//  HomeCell.swift
//  edelivery
//
//  Created by Elluminati on 15/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class CartCell: CustomTableCell {

    //MARK:- OUTLET
    @IBOutlet weak var viewForCartItem: UIView!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var btnIncrement: UIButton!
    @IBOutlet weak var btnDecrement: UIButton!
    @IBOutlet weak var viewForQuantity: UIView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var lblItemDescription: UILabel!
    @IBOutlet weak var lblSpecifications: UILabel!
    
    var myCurrentItem:CartProductItems?
    weak var cartVCObject:CartVC?
    var section:Int?
    var row:Int?
  
    //MARK:- LIFECYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        setLocalization()
    }
    
    //MARK:- setLocationzation
    
    func setLocalization() {
        
        /*Set Color*/
        lblPrice.textColor = UIColor.themeTextColor
        lblItemDescription.textColor = UIColor.themeLightTextColor
        lblItemName.textColor = UIColor.themeTextColor
        btnDecrement.setTitleColor(UIColor.themeColor, for: UIControl.State.normal)
        btnIncrement.setTitleColor(UIColor.themeColor, for: UIControl.State.normal)
        viewForQuantity.backgroundColor = UIColor.themeViewBackgroundColor
        lblQuantity.textColor =  UIColor.themeColor
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        viewForCartItem.backgroundColor = UIColor.themeViewBackgroundColor
        btnRemove.setTitleColor(UIColor.themeSectionBackgroundColor, for: .normal)
        
        lblSpecifications.textColor = UIColor.themeLightTextColor
        lblSpecifications.font = FontHelper.textMedium(size: 12)
     
        /*Set Text*/
        lblPrice.text = "TXT_DEFAULF".localized
        lblItemDescription.text = "TXT_DEFAULF".localized
        lblItemName.text = "TXT_DEFAULF".localized
        btnDecrement.setTitle("TXT_MINUS".localized, for: UIControl.State.normal)
        btnIncrement.setTitle("TXT_PLUS".localized, for: UIControl.State.normal)
        lblQuantity.text =  "TXT_DEFAULF".localized
        
        /*Set Font*/
        lblPrice.font = FontHelper.textMedium(size:FontHelper.labelRegular)
        lblItemDescription.font = FontHelper.textSmall()
        lblItemName.font = FontHelper.textMedium(size:FontHelper.labelRegular)
        lblQuantity.font = FontHelper.labelRegular()
        btnDecrement.titleLabel?.font = FontHelper.labelRegular()
        btnIncrement.titleLabel?.font = FontHelper.labelRegular()
        btnIncrement.layer.borderColor = UIColor.themeColor.cgColor
        btnDecrement.layer.borderColor = UIColor.themeColor.cgColor
        btnIncrement.layer.borderWidth = 1
        btnDecrement.layer.borderWidth = 1
        viewForQuantity.layer.borderWidth = 1
        viewForQuantity.layer.borderColor = UIColor.themeColor.cgColor
        btnRemove.setImage(UIImage(named: "cancelIcon")?.imageWithColor(color: .themeColor), for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        viewForQuantity.applyRoundedCornersWithHeight()
    }
    
    //MARK:- SET CELL DATA
    func setCellData(cellItem:CartProductItems, section:Int, row:Int,parent:CartVC ) {
        myCurrentItem = cellItem
        self.section = section
        self.row = row
        cartVCObject = parent
        lblItemName.text = cellItem.item_name
        lblItemDescription.text = cellItem.details
        lblPrice.text = currentBooking.cartCurrency + " " + (cellItem.totalItemPrice?.roundTo() ?? 0.0).toString()
        lblQuantity.text = String(cellItem.quantity!)
        
        var arrSpecification = [String]()
        for obj in cellItem.specifications {
            for list in (obj.list ?? []) {
                if list.quantity > 1 {
                    arrSpecification.append("\(list.name ?? "") (\(list.quantity))")
                } else {
                    arrSpecification.append(list.name ?? "")
                }
            }
        }
        
        if arrSpecification.count > 0 {
            lblSpecifications.text = arrSpecification.joined(separator: ", ")
            lblSpecifications.isHidden = false
        } else {
            lblSpecifications.isHidden = true
        }
    }
    
    @IBAction func onClickBtnDecrement(_ sender: Any) {
        cartVCObject?.decreaseQuantity(currentProductItem: myCurrentItem!)
    }
    
    @IBAction func onClickBtnIncrement(_ sender: AnyObject) {
        cartVCObject?.increaseQuantity(currentProductItem: myCurrentItem!)
    }
    
    @IBAction func onClickBtnRemove(_ sender: Any) {
        cartVCObject?.removeItemFromCart(currentProductItem:  myCurrentItem!,section: section!,row: row!)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
