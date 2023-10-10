//
//  StripeCardCell.swift
//  edelivery
//
//  Created by Elluminati on 15/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class StripeCardCell: CustomTableCell {

//MARK:- Outlets
    @IBOutlet weak var lblCardNumber: UILabel!
    @IBOutlet weak var btnDefault: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var imgCard: UIImageView!

//MARK:- Variables
    weak var stripeVCObject:StripeVC?
    var section:Int?
    var row:Int?
    var currentCard:CardItem?

//MARK:- LIFECYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        lblCardNumber.font = FontHelper.textRegular()
        lblCardNumber.textColor = UIColor.themeTextColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        self.backgroundColor = UIColor.themeViewBackgroundColor
        btnDefault.setImage(UIImage.init(named: "selected_icon"), for: .normal)
    }
    
//MARK:- SET CELL DATA
    func setCellData(cellItem:CardItem,section:Int, row:Int,parent:StripeVC) {
        currentCard = cellItem
        self.section = section
        self.row = row
        stripeVCObject = parent
        lblCardNumber.text = "****" + " " + cellItem.lastFour!
        btnDefault.isHidden = !cellItem.isDefault!
        self.imgCard.image = UIImage.init(named: "card_icon")?.imageWithColor(color: .themeIconTintColor)
        self.btnDelete.setImage(UIImage.init(named: "cancelBlackIcon")?.imageWithColor(), for: .normal)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func onClickBtnDeleteCard(_ sender: AnyObject) {
            openConfirmationDialog()
    }
    
    func openConfirmationDialog() {
        let dialogForLogout = CustomAlertDialog.showCustomAlertDialog(title: "TXT_DELETE_CARD".localized, message: "MSG_ARE_YOU_SURE".localized, titleLeftButton: "TXT_CANCEL".localizedUppercase, titleRightButton: "TXT_OK".localizedUppercase)
        dialogForLogout.onClickLeftButton = { [unowned dialogForLogout] in
                dialogForLogout.removeFromSuperview();
        }
        dialogForLogout.onClickRightButton = { [unowned dialogForLogout, unowned self] in
                dialogForLogout.removeFromSuperview();
                self.stripeVCObject?.wsDeletCard(card: self.currentCard!)
        }
    }
}

