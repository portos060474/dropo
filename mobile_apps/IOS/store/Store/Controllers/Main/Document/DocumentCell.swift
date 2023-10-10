//
//  HomeCell.swift
// Edelivery Store
//
//  Created by Jaydeep Vyas on 15/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class DocumentCell: CustomCell {

//MARK:- OUTLET
    @IBOutlet weak var stkDocID: UIStackView!
    @IBOutlet weak var stkExpDate: UIStackView!
    @IBOutlet weak var lblDocumentName: UILabel!
    @IBOutlet weak var lblIDNumber: UILabel!
    @IBOutlet weak var lblExpDate: UILabel!
    @IBOutlet weak var lblIDNumberValue: UILabel!
    @IBOutlet weak var lblExpDateValue: UILabel!
    @IBOutlet weak var imgDocument: UIImageView!
    @IBOutlet weak var lblStar: UILabel!

   //MARK:- LIFECYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        
                //LOCALIZED
        lblIDNumber.text = "TXT_ID_NUMBER".localized
        lblExpDate.text = "TXT_EXP_DATE".localized
        
        //COLORS
        lblDocumentName.textColor = UIColor.themeTextColor
        lblIDNumberValue.textColor = UIColor.themeTextColor
        lblExpDateValue.textColor = UIColor.themeTextColor
        lblIDNumber.textColor = UIColor.themeLightTextColor
        lblExpDate.textColor = UIColor.themeLightTextColor
        lblStar.textColor = .themeRedColor
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
       
        //Make View Hidden
        stkDocID.isHidden = true
        lblIDNumber .isHidden = true
        lblIDNumberValue.isHidden = true
        stkExpDate.isHidden = true
        lblExpDateValue.isHidden = true
        lblExpDate.isHidden = true
        
        /* Set Font */
        
        lblDocumentName.font = FontHelper.textRegular()
        lblIDNumberValue.font = FontHelper.textMedium()
        lblExpDateValue.font = FontHelper.textMedium()
        lblIDNumber.font = FontHelper.labelRegular()
        lblExpDate.font = FontHelper.labelRegular()
        imgDocument.setRound(withBorderColor: .themeLightLineColor, andCornerRadious: 2.0, borderWidth: 0.3)
        

    }
//MARK:- SET CELL DATA
    func setCellData(cellItem:Document) {
//        imgDocument.setRound(withBorderColor: UIColor.white, andCornerRadious: 3.0, borderWidth: 1.0)
        
        let docDetail:DocumentDetail = cellItem.documentDetails
        
        lblDocumentName.text = docDetail.documentName!.uppercased()
        if((cellItem.imageUrl!.isEmpty())) {
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
            }else {
                stkDocID.isHidden = true
                lblIDNumber .isHidden = true
                lblIDNumberValue.isHidden = true
                
            }
            
        }else {
            imgDocument.downloadedFrom(link: cellItem.imageUrl!, placeHolder: "document_placeholder")
            
            if (docDetail.isExpiredDate)! {
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = DATE_CONSTANT.DATE_TIME_FORMAT_WEB
                let currentDate = dateFormatter.date(from: cellItem.expiredDate ?? "")
                dateFormatter.dateFormat = DATE_CONSTANT.DATE_FORMAT
                lblExpDateValue.text = dateFormatter.string(from: currentDate!)
                
                
                stkExpDate.isHidden = false
                lblExpDateValue.isHidden = false
                lblExpDate.isHidden = false
                
            }else {
                 stkExpDate.isHidden = true
                lblExpDateValue.isHidden = true
                lblExpDate.isHidden = true
            }
            if (docDetail.isUniqueCode)! {
                lblIDNumberValue.text = cellItem.uniqueCode!
                
                stkDocID.isHidden = false
                lblIDNumber .isHidden = false
                lblIDNumberValue.isHidden = false
            }else {
                stkDocID.isHidden = true
                lblIDNumber .isHidden = true
                lblIDNumberValue.isHidden = true

                
            }
            
        }
        
        if (docDetail.isMandatory)! {
//            lblDocumentName.text?.append("*")
            lblStar.text = "*"
        }else{
            lblStar.text = ""
        }
        
        
       
        
        
         }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
   
}
