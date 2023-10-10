//
//  ProductCell.swift
//  Store
//
//  Created by Jaydeep Vyas on 20/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class ProductCell: CustomCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnSpecifications: UIButton!
    @IBOutlet weak var lblDescription: UILabel!
   
    @IBOutlet weak var swIsVisible: UISwitch!
    @IBOutlet weak var lblVisible: UILabel!
    
    @IBOutlet weak var lblTaxInfo: UILabel!

    
    var product:Product? = nil
    var parent:UIViewController? = nil
    var attrs = [
        convertFromNSAttributedStringKey(NSAttributedString.Key.font) : FontHelper.textSmall(),
        convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor.themeColor,
        convertFromNSAttributedStringKey(NSAttributedString.Key.underlineStyle) : 1] as [String : Any]

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
         swIsVisible.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        self.lblName.textColor = UIColor.themeTextColor
        
        self.lblDescription.textColor = UIColor.themeLightTextColor
        
    self.btnSpecifications.setTitleColor(UIColor.themeColor, for: .normal)
        self.lblTaxInfo.textColor = UIColor.themeGreenColor
        

        
        self.lblName.font = FontHelper.textMedium(size:FontHelper.labelRegular)
        self.lblDescription.font = FontHelper.labelSmall()
        self.lblTaxInfo.font = FontHelper.labelSmall()

        self.btnSpecifications.titleLabel?.font = FontHelper.textSmall()
       
        self.lblVisible.textColor = UIColor.themeLightTextColor
            self.lblVisible.font = FontHelper.textSmall()
            self.lblVisible.text = "TXT_VISIBLE".localized

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellData(product:Product,parent:Any) {
        self.parent = parent as! ProductListVC
        self.product = product
        self.lblName.text = product.name
        let buttonTitleStr = NSMutableAttributedString(string:"TXT_SPECIFICATIONS".localized, attributes:convertToOptionalNSAttributedStringKeyDictionary(attrs))
        self.btnSpecifications.setAttributedTitle(buttonTitleStr, for: .normal)
        self.lblDescription.text = product.details
        if (product.isVisibleInStore)! {
            self.swIsVisible.setOn(true, animated: true)
        }else {
            self.swIsVisible.setOn(false, animated: true)
        }
    }
    @IBAction func onClickSpecifications(sender:Any) {
        if (self.parent?.isKind(of: ProductListVC.self))! {
            
            (self.parent as! ProductListVC).indexCell = self.btnSpecifications.tag
            (self.parent as! ProductListVC).goToProductSpecification(productDetail: self.product!)
        
        }
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
