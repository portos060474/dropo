//
//  EditOrderCell.swift
//  Edelivery
//
//  Created by Trusha on 22/05/20.
//  Copyright © 2020 Elluminati. All rights reserved.
//

import UIKit

class EditOrderCell: UITableViewCell {
   
    //MARK:- OUTLET
    @IBOutlet weak var viewForOrderItem: UIView!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var btnIncrement: UIButton!
    @IBOutlet weak var btnDecrement: UIButton!
    @IBOutlet weak var viewForQuantity: UIView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var lblItemDescription: UILabel!
 
    var myCurrentItem:CartProductItems?;
    weak var editOrderObject:EditOrderVC?
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
        btnDecrement.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
        btnIncrement.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
        viewForQuantity.backgroundColor = UIColor.themeViewBackgroundColor
        lblQuantity.textColor =  UIColor.themeTextColor
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        viewForOrderItem.backgroundColor = UIColor.themeViewBackgroundColor
        btnRemove.setTitleColor(UIColor.themeSectionBackgroundColor, for: .normal)
       
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
        lblItemName.font = FontHelper.textMedium()
        lblQuantity.font = FontHelper.textRegular()
        btnDecrement.titleLabel?.font = FontHelper.textRegular()
        btnIncrement.titleLabel?.font = FontHelper.textRegular()
        btnRemove.setTitle("TXT_REMOVE".localizedCapitalized, for: .normal)
        
        viewForQuantity.layer.borderWidth = 1
        viewForQuantity.layer.borderColor = UIColor.black.cgColor
        viewForQuantity.layer.cornerRadius = 3.0
    }

    //MARK:- SET CELL DATA
    
    func setCellData(cellItem:CartProductItems, section:Int, row:Int,parent:EditOrderVC ) {
        myCurrentItem = cellItem
        self.section = section
        self.row = row
        editOrderObject = parent
        lblItemName.text = cellItem.item_name
        lblItemDescription.text = cellItem.details
        lblPrice.text = (cellItem.totalItemPrice?.roundTo() ?? 0.0).toCurrencyString()
        lblQuantity.text = String(cellItem.quantity!)
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
