//
//  HomeCell.swift
//  edelivery
//
//  Created by tag on 15/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class DocumentCell: CustomTableCell {

//MARK:- OUTLET
    @IBOutlet weak var stkDocID: UIStackView!
    @IBOutlet weak var stkExpDate: UIStackView!
    @IBOutlet weak var lblDocumentName: UILabel!
    @IBOutlet weak var lblIDNumber: UILabel!
    @IBOutlet weak var lblExpDate: UILabel!
    @IBOutlet weak var lblIDNumberValue: UILabel!
    @IBOutlet weak var lblExpDateValue: UILabel!
    @IBOutlet weak var imgDocument: UIImageView!

//MARK:- LIFECYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        imgDocument.setRound(withBorderColor: UIColor.white, andCornerRadious: 3)
        //LOCALIZED
        lblIDNumber.text = "TXT_ID_NUMBER".localized
        lblExpDate.text = "TXT_EXP_DATE".localized
        //COLORS
        lblDocumentName.textColor = UIColor.themeLightTextColor
        lblIDNumberValue.textColor = UIColor.themeTextColor
        lblExpDateValue.textColor = UIColor.themeTextColor
        lblIDNumber.textColor = UIColor.themeTextColor
        lblExpDate.textColor = UIColor.themeTextColor
       //Font
        lblDocumentName.font = FontHelper.textRegular()
        lblIDNumberValue.font = FontHelper.textMedium(size: FontHelper.regular)
        lblExpDateValue.font = FontHelper.textMedium(size: FontHelper.regular)
        lblIDNumber.font = FontHelper.textRegular()
        lblExpDate.font = FontHelper.textRegular()
        //Make View Hidden
        stkDocID.isHidden = true
        lblIDNumber .isHidden = true
        lblIDNumberValue.isHidden = true
        stkExpDate.isHidden = true
        lblExpDateValue.isHidden = true
        lblExpDate.isHidden = true
    }
    
//MARK:- SET CELL DATA
    func setCellData(cellItem:Document) {
        imgDocument.setRound(withBorderColor: UIColor.white, andCornerRadious: 3.0, borderWidth: 1.0)
        let docDetail:DocumentDetail = cellItem.documentDetails
        lblDocumentName.text = docDetail.documentName!
        if((cellItem.imageUrl!.isEmpty)) {
            imgDocument.image = UIImage.init(named:"document_placeholder")
            if (docDetail.isExpiredDate)! {
                lblExpDateValue.text = ""
                stkExpDate.isHidden = false
                lblExpDateValue.isHidden = false
                lblExpDate.isHidden = false
            }else {
                stkExpDate.isHidden = true
                lblExpDateValue.isHidden = true
                lblExpDate.isHidden = true
            }
            if (docDetail.isUniqueCode)! {
                lblIDNumberValue.text = ""
                
                stkDocID.isHidden = false
                lblIDNumber .isHidden = false
                lblIDNumberValue.isHidden = false
            } else {
                stkDocID.isHidden = true
                lblIDNumber .isHidden = true
                lblIDNumberValue.isHidden = true
            }
        } else {
            imgDocument.downloadedFrom(link: cellItem.imageUrl!, placeHolder: "document_placeholder")
            if (docDetail.isExpiredDate)! {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = DATE_CONSTANT.DATE_TIME_FORMAT_WEB
                let currentDate = dateFormatter.date(from: cellItem.expiredDate ?? "")
                dateFormatter.dateFormat = DATE_CONSTANT.DATE_FORMAT
                lblExpDateValue.text = dateFormatter.string(from: currentDate ?? Date())
                stkExpDate.isHidden = false
                lblExpDateValue.isHidden = false
                lblExpDate.isHidden = false
            } else {
                stkExpDate.isHidden = true
                lblExpDateValue.isHidden = true
                lblExpDate.isHidden = true
            }
            if (docDetail.isUniqueCode)! {
                lblIDNumberValue.text = String(cellItem.uniqueCode ?? "")
                stkDocID.isHidden = false
                lblIDNumber .isHidden = false
                lblIDNumberValue.isHidden = false
            } else {
                stkDocID.isHidden = true
                lblIDNumber .isHidden = true
                lblIDNumberValue.isHidden = true
            }
        }
        if (docDetail.isMandatory)! {
            lblDocumentName.text?.append("*")
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
