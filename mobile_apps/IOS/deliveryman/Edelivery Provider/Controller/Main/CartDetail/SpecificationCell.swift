//
//  TableViewCell.swift
//  Edelivery Provider
//
//  Created by MacPro3 on 30/03/22.
//  Copyright © 2022 Elluminati iMac. All rights reserved.
//

import UIKit

class SpecificationCell: UITableViewCell {
    
    @IBOutlet weak var lblSpecificationName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblSpecificationName.textColor = UIColor.themeLightTextColor
        self.lblSpecificationName.font = FontHelper.labelSmall()
        self.lblSpecificationName.numberOfLines = 0
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setData(listItemDetail: OrderListItem) {
        
        let strMultablAttribute = NSMutableAttributedString(string: (listItemDetail.name ?? "") + " ", attributes: [NSAttributedString.Key.font : lblSpecificationName.font!, NSAttributedString.Key.foregroundColor: lblSpecificationName.textColor as Any])
        
        let strQuantity = NSMutableAttributedString(string: "x\(listItemDetail.quantity)", attributes: [NSAttributedString.Key.font : FontHelper.textMedium(size: lblSpecificationName.font.pointSize), NSAttributedString.Key.foregroundColor: lblSpecificationName.textColor!])
        
        strMultablAttribute.append(strQuantity)
        
        lblSpecificationName.attributedText = strMultablAttribute
        
    }
}

class myTableView: UITableView {
   

  override var intrinsicContentSize: CGSize {
    self.layoutIfNeeded()
    return self.contentSize
  }

  override var contentSize: CGSize {
    didSet{
      self.invalidateIntrinsicContentSize()
    }
  }

  override func reloadData() {
    super.reloadData()
    self.invalidateIntrinsicContentSize()
  }

}
