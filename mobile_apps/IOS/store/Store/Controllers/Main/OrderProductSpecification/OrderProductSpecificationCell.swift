//
//  OrderProductSpecificationCell.swift
// Edelivery Store
//
//  Created by Jaydeep Vyas on 15/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

protocol OrderProductSpecificationCellDelegae: AnyObject {
    func specificationButtonAction(cell: OrderProductSpecificationCell, sender: UIButton)
}

class OrderProductSpecificationCell: CustomCell {

//MARK:- OUTLET
    
    
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imgButtonType: UIButton!
    @IBOutlet weak var lblSpecificationName: UILabel!
    var isAllowMultipleSelect:Int = 1;
    
    @IBOutlet weak var viewQty: UIView!
    @IBOutlet weak var btnPluse: UIButton!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var lblQty: UILabel!
    
    @IBOutlet weak var lblLine1: UILabel!
    @IBOutlet weak var lblLine2: UILabel!
    
    weak var delegate: OrderProductSpecificationCellDelegae?
   
//MARK:- LIFECYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor =  UIColor.themeViewBackgroundColor;
        self.backgroundColor = UIColor.themeViewBackgroundColor
        
        lblSpecificationName.font = FontHelper.labelRegular()
        lblPrice.font = FontHelper.labelRegular()
        lblQty.font = FontHelper.labelRegular()
        
        lblPrice.textColor = UIColor.themeLightTextColor
        lblQty.textColor = UIColor.themeLightTextColor
        lblSpecificationName.textColor = UIColor.themeLightTextColor
        
        btnMinus.setTitleColor(UIColor.themeLightTextColor, for: .normal)
        btnPluse.setTitleColor(UIColor.themeLightTextColor, for: .normal)
    }
    
    //MARK:- SET CELL DATA
    func setCellData(cellItem:List, isAllowMultipleSelect:Int) {
     
        self.isAllowMultipleSelect = isAllowMultipleSelect;
        lblSpecificationName.text = cellItem.name!
        if cellItem.price! > 0.0 {
            lblPrice.text = (cellItem.price!).toCurrencyString()
        }else {
            lblPrice.text =  " "
        }
        self.contentView.backgroundColor =  UIColor.themeViewBackgroundColor;
        self.backgroundColor = UIColor.themeViewBackgroundColor
        
        viewQty.isHidden = true
        lblQty.text = "\(cellItem.quantity)"
        
        if (isAllowMultipleSelect == 2) {
            
            imgButtonType.setImage( UIImage.init(named: "checked")?.imageWithColor(color: .themeColor)
                , for: UIControl.State.selected)
            imgButtonType.setImage( UIImage.init(named: "unchecked")
                , for: UIControl.State.normal)
            
            if cellItem.isDefaultSelected {
                viewQty.isHidden = false
            }
        }else {
            imgButtonType.setImage( UIImage.init(named: "radio_btn_checked_icon")?.imageWithColor(color: .themeColor)
                , for: UIControl.State.selected)
            imgButtonType.setImage( UIImage.init(named: "radio_btn_unchecked_icon")
                , for: UIControl.State.normal)
        }
        imgButtonType.isSelected = cellItem.isDefaultSelected!
        
        DispatchQueue.main.async { [weak self] in
            self?.viewQty.setRound(withBorderColor: UIColor.themeColor, andCornerRadious: (self?.viewQty.frame.size.height ?? 35)/2, borderWidth: 1)
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func onClickButton(_ sender: UIButton) {
        self.delegate?.specificationButtonAction(cell: self, sender: sender)
    }

}
