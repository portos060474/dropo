//
//  SpecificationItemCell.swift
//  Store
//
//  Created by Jaydeep Vyas on 04/04/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class SpecificationItemCell: CustomCell, UITextFieldDelegate {

    @IBOutlet weak var lblSpecificationName: UILabel!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var btnDefault: UIButton!
    @IBOutlet weak var swDefault: UISwitch!

    @IBOutlet weak var lblCurrency: UILabel!
    weak var parentClass:AddItemSpecificationVC? = nil;
    var specificationItem:List? = nil;
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lblSpecificationName.textColor = UIColor.themeTextColor
        self.lblSpecificationName.font = FontHelper.labelRegular()
        self.lblCurrency.textColor = UIColor.themeTextColor
        self.lblCurrency.font = FontHelper.textRegular()
        self.txtPrice.textColor = UIColor.themeTextColor
        self.txtPrice.font = FontHelper.textRegular()
        
        self.btnDefault.setTitle("TXT_DEFAULT_TEXT".localized,  for: .normal)
        self.btnDefault.titleLabel?.font = FontHelper.textSmall()
        self.btnDefault.setTitleColor(UIColor.themeLightTextColor, for: .normal)
        self.btnDefault.setTitleColor(UIColor.themeTextColor, for: .selected)
        self.txtPrice.delegate = self
        txtPrice.borderStyle = .roundedRect
        
        swDefault.onTintColor = .themeColor
        swDefault.tintColor = .themeLightTextColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (textField.text?.isNumber())! {
            textField.text = ""
            Utility.showToast(message: "MSG_ENTER_VALID_AMOUNT".localized)
            return false;
        }
        textField.resignFirstResponder()
        return true;
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !(textField.text?.isEmpty())! {
            specificationItem?.price =  (txtPrice.text?.doubleValue) ?? 0.0
        }
    }
    func setCellData(specificationItem:List,parent:AddItemSpecificationVC) {
        
        self.specificationItem = specificationItem
        self.lblSpecificationName.text = specificationItem.name
        self.lblCurrency.text = StoreSingleton.shared.store.currency
        self.txtPrice.text = String(specificationItem.price)
        self.parentClass = parent
        if specificationItem.isDefaultSelected {
            self.btnDefault.isSelected = true
            self.swDefault.isOn = true
        }else {
            self.btnDefault.isSelected = false
            self.swDefault.isOn = false
        }
        
        if specificationItem.isUserSelected {
            self.btnCheck.isSelected = true
        }else {
            self.btnCheck.isSelected = false
        }
    }
    
    
    @IBAction func onClickCheckBox (_ sender: Any) {
        if (self.btnCheck.isSelected) {
            self.btnCheck.isSelected = false
            self.btnDefault.isSelected = false
            self.swDefault.isOn = false
            self.txtPrice.isEnabled = false
            parentClass?.onClickBtnCheckBox(self.btnCheck)
        }else {
            self.btnCheck.isSelected = true
            self.txtPrice.isEnabled = true
            parentClass?.onClickBtnCheckBox(self.btnCheck)
        }
    }
    
    @IBAction func onClickDefault (_ sender: Any) {
        if (self.btnCheck.isSelected) {
            self.btnDefault.isSelected = !self.btnDefault.isSelected
            self.swDefault.isOn = !self.swDefault.isOn

            parentClass?.onClickBtnDefault(btnDefault)
        }
    }
}
