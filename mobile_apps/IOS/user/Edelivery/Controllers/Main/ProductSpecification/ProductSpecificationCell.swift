//
//  HomeCell.swift
//  edelivery
//
//  Created by Elluminati on 15/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

protocol SpecificationCellDelegae: AnyObject {
    func specificationButtonAction(cell: ProductSpecificationCell, sender: UIButton)
}

class ProductSpecificationCell: CustomTableCell {

    //MARK:- OUTLET
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imgButtonType: UIButton!
    @IBOutlet weak var lblSpecificationName: UILabel!
    var isAllowMultipleSelect:Int = 1
    @IBOutlet weak var viewQty: UIView!
    @IBOutlet weak var btnPluse: UIButton!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var lblQty: UILabel!
    
    @IBOutlet weak var lblLine1: UILabel!
    @IBOutlet weak var lblLine2: UILabel!
    
    weak var delegate: SpecificationCellDelegae?
   
    //MARK:- LIFECYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor =  UIColor.themeViewBackgroundColor
        self.backgroundColor = UIColor.themeViewBackgroundColor
        
        lblSpecificationName.font = FontHelper.labelRegular(size: FontHelper.medium)
        lblPrice.font = FontHelper.labelRegular(size: FontHelper.medium)
        
        lblPrice.textColor = UIColor.themeTextColor
        lblSpecificationName.textColor = UIColor.themeTextColor
        
        lblQty.textColor = UIColor.themeTextColor
        lblQty.font = FontHelper.labelRegular(size: FontHelper.medium)
        
        lblLine1.backgroundColor = UIColor.themeColor
        lblLine2.backgroundColor = UIColor.themeColor
        
        btnMinus.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnPluse.setTitleColor(UIColor.themeTextColor, for: .normal)
    }
    
    //MARK:- SET CELL DATA
    func setCellData(cellItem:SpecificationListItem, isAllowMultipleSelect:Int, currency:String,arrSpecificationFromProductVC: SpecificationListItem,isFromCart:Bool) {
     
        self.isAllowMultipleSelect = isAllowMultipleSelect
        lblSpecificationName.text = cellItem.name!
        if cellItem.price! > 0.0 {
            lblPrice.text = currency + " " + (cellItem.price ?? 0.0).toString()
        }else {
            lblPrice.text =  " "
        }
        self.contentView.backgroundColor =  UIColor.themeViewBackgroundColor
        self.backgroundColor = UIColor.themeViewBackgroundColor
        
        viewQty.isHidden = true
        lblQty.text = "\(cellItem.quantity)"
        
        if (isAllowMultipleSelect == 2) {
            
            imgButtonType.setImage( UIImage.init(named: "checked_checkbox_icon")?.imageWithColor(color: UIColor.themeColor)
                , for: UIControl.State.selected)
            imgButtonType.setImage( UIImage.init(named: "unchecked_checkbox_icon")
                , for: UIControl.State.normal)
            
            if cellItem.is_default_selected {
                viewQty.isHidden = false
            }
        }else {
            imgButtonType.setImage( UIImage.init(named: "radio_btn_checked_icon")?.imageWithColor(color: UIColor.themeColor)
                , for: UIControl.State.selected)
            imgButtonType.setImage( UIImage.init(named: "radio_btn_unchecked_icon")
                , for: UIControl.State.normal)
        }
        imgButtonType.isSelected = cellItem.is_default_selected
        
        DispatchQueue.main.async { [weak self] in
            self?.viewQty.setRound(withBorderColor: UIColor.themeColor, andCornerRadious: (self?.viewQty.frame.size.height ?? 35)/2, borderWidth: 1)
        }
    }
    override func updateUIAccordingToTheme() {
        let _ = imgButtonType.imageView?.image?.imageWithColor(color: UIColor.themeTitleColor)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func onClickButton(_ sender: UIButton) {
        self.delegate?.specificationButtonAction(cell: self, sender: sender)
    }
}
