//
//  HomeCell.swift
// Edelivery Store
//
//  Created by Jaydeep Vyas on 15/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class EditOrderCell: CustomCell {

    @IBOutlet weak var viewForOrderItem: UIView!
    weak var editOrderObject:EditOrderVC?
    var section:Int?
    var row:Int?
    @IBOutlet weak var lblQuantity: UILabel!

    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var btnIncrement: UIButton!
    @IBOutlet weak var btnDecrement: UIButton!
    @IBOutlet weak var lblQuantitySep1: UILabel!
       @IBOutlet weak var lblQuantitySep2: UILabel!
    @IBOutlet weak var viewForQuantity: UIView!
//MARK:- OUTLET
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var lblItemDescription: UILabel!
    
    @IBOutlet weak var lblAllSpecification: UILabel!
    
    var myCurrentItem:OrderItem?;
   
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
        lblAllSpecification.textColor = UIColor.themeLightTextColor
        lblItemName.textColor = UIColor.themeTextColor
        btnDecrement.setTitleColor(UIColor.themeColor, for: UIControl.State.normal)
        btnIncrement.setTitleColor(UIColor.themeColor, for: UIControl.State.normal)
        viewForQuantity.backgroundColor = UIColor.themeViewBackgroundColor
        lblQuantity.textColor =  UIColor.themeColor
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        viewForOrderItem.backgroundColor = UIColor.themeViewBackgroundColor
//        btnRemove.setTitleColor(UIColor.themeColor, for: .normal)
        /*Set Text*/
        lblPrice.text = "TXT_DEFAULF".localized
        lblItemDescription.text = "TXT_DEFAULF".localized
        lblItemName.text = "TXT_DEFAULF".localized
        btnDecrement.setTitle("TXT_MINUS".localized, for: UIControl.State.normal)
        btnIncrement.setTitle("TXT_PLUS".localized, for: UIControl.State.normal)
        lblQuantity.text =  "TXT_DEFAULF".localized
        
        /*Set Font*/
        lblPrice.font = FontHelper.textMedium()
        lblItemDescription.font = FontHelper.textRegular()
        lblAllSpecification.font = FontHelper.textMedium(size: FontHelper.regular)
        lblItemName.font = FontHelper.textMedium()
        lblQuantity.font = FontHelper.textRegular()
        btnDecrement.titleLabel?.font = FontHelper.textRegular()
        btnIncrement.titleLabel?.font = FontHelper.textRegular()
//        btnRemove.setTitle("TXT_REMOVE".localizedCapitalized, for: .normal)
        
        viewForQuantity.layer.cornerRadius = viewForQuantity.frame.size.height/2;
        viewForQuantity.layer.borderWidth = 1
        viewForQuantity.layer.borderColor = UIColor.themeColor.cgColor

        lblQuantitySep1.backgroundColor = .themeColor
        lblQuantitySep2.backgroundColor = .themeColor
    }
    
//MARK:- SET CELL DATA
    func setCellData(cellItem:OrderItem, section:Int, row:Int,parent:EditOrderVC ) {
        myCurrentItem = cellItem
        self.section = section
        self.row = row
        editOrderObject = parent
        
        lblItemName.text = cellItem.itemName
        lblItemDescription.text = cellItem.details
        
        lblPrice.text = (cellItem.totalItemPrice?.roundTo() ?? 0.0).toCurrencyString()
        lblQuantity.text = String(cellItem.quantity!)
        btnRemove.setImage(UIImage(named: "cross")?.imageWithColor(color: .themeColor), for: .normal)

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
            lblAllSpecification.text = arrSpecification.joined(separator: ", ")
            lblAllSpecification.isHidden = false
        } else {
            lblAllSpecification.isHidden = true
        }
    }
    
    @IBAction func onClickBtnDecrement(_ sender: Any) {
        editOrderObject?.decreaseQuantity(currentProductItem: myCurrentItem!)
    }
    @IBAction func onClickBtnIncrement(_ sender: AnyObject) {
        editOrderObject?.increaseQuantity(currentProductItem: myCurrentItem!)
    }
    
    @IBAction func onClickBtnRemove(_ sender: Any) {
        editOrderObject?.removeItemFromCart(currentProductItem:  myCurrentItem!,section: section!,row: row!)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    

}
