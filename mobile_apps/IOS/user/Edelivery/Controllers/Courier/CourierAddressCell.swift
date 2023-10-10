//
//  CourierAddressCell.swift
//  Edelivery
//
//  Created by MacPro3 on 20/09/22.
//  Copyright © 2022 Elluminati. All rights reserved.
//

import UIKit

protocol CourierAddressCellDelegate: AnyObject {
    func didTapCellButton(sender: UIButton, cell: CourierAddressCell)
}

class CourierAddressCell: UITableViewCell {
    
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblNote: UILabel!
    
    @IBOutlet weak var lblTopLine: UILabel!
    @IBOutlet weak var lblBottomLine: UILabel!
    
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBOutlet weak var imgPin: UIImageView!
    @IBOutlet weak var viewRoundPin: UIView!
    
    weak var delegate: CourierAddressCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        btnDelete.setTitle("", for: .normal)
        btnDelete.setImage(UIImage(named:"cancelIcon")?.imageWithColor(color: UIColor.themeColor), for: .normal)
        
        lblAddress.textColor = .themeTextColor
        lblName.textColor = .themeLightGrayColor
        lblNote.textColor = .themeLightGrayColor
        
        lblAddress.font = FontHelper.textMedium(size: FontHelper.regular)
        lblName.font = FontHelper.textRegular(size: FontHelper.labelRegular)
        lblNote.font = FontHelper.textRegular(size: FontHelper.labelRegular)
        
        lblTopLine.backgroundColor = .themeSperatorColor234
        lblBottomLine.backgroundColor = .themeSperatorColor234
        
        viewRoundPin.backgroundColor = .themeColor
        viewRoundPin.setRound()
    }
    
    @IBAction func onClickButton(_ sender: UIButton) {
        delegate?.didTapCellButton(sender: sender, cell: self)
    }
}
