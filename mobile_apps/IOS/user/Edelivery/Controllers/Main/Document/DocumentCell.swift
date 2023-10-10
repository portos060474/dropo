//
//  HomeCell.swift
//  edelivery
//
//  Created by Elluminati on 15/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
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
        lblDocumentName.textColor = UIColor.themeTextColor
        lblIDNumberValue.textColor = UIColor.themeTextColor
        lblExpDateValue.textColor = UIColor.themeTextColor
        lblIDNumber.textColor = UIColor.themeLightTextColor
        lblExpDate.textColor = UIColor.themeLightTextColor
     
        //Font
        lblDocumentName.font = FontHelper.textRegular()
        lblIDNumberValue.font = FontHelper.textRegular()
        lblExpDateValue.font = FontHelper.textRegular()
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
     func setCellData(cellItem:Document) {imgDocument.setRound(withBorderColor: UIColor.white, andCornerRadious: 3.0, borderWidth: 1.0)
            
            let docDetail:DocumentDetail = cellItem.documentDetails
            
            if((cellItem.imageUrl!.isEmpty())) {
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
    
                imgDocument.downloadedFrom(link: Utility.getDynamicResizeImageURL(width: imgDocument.frame.width, height: imgDocument.frame.height, imgUrl: cellItem.imageUrl!),isFromResize: true)
                
                if (docDetail.isExpiredDate)! {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = DATE_CONSTANT.DATE_TIME_FORMAT_WEB
                    if cellItem.expiredDate != nil {
                        let currentDate = dateFormatter.date(from: cellItem.expiredDate!)
                        dateFormatter.dateFormat = DATE_CONSTANT.DATE_FORMAT
                        lblExpDateValue.text = dateFormatter.string(from: currentDate!)
                    }
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
                
                let attributes = [
                    convertFromNSAttributedStringKey(NSAttributedString.Key.font) : FontHelper.textRegular(),
                    convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor.themeTextColor
                    ] as [String : Any]
                    let title1 = NSMutableAttributedString(string: docDetail.documentName!.uppercased() , attributes: convertToOptionalNSAttributedStringKeyDictionary(attributes))
                let subTitle = NSMutableAttributedString(string: " *", attributes: convertToOptionalNSAttributedStringKeyDictionary([
                    convertFromNSAttributedStringKey(NSAttributedString.Key.font) : FontHelper.textRegular(),
                    convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor.themeRedBGColor
                    ] as [String : Any]))
                    title1.append(subTitle)
                    lblDocumentName.attributedText = title1
                }
                else {
                    lblDocumentName.text = docDetail.documentName!.uppercased()
                }
            
        }
    override func layoutSubviews() {
        imgDocument.setRound(withBorderColor: .clear, andCornerRadious: 8.0, borderWidth: 0.5)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
        return input.rawValue
    }

    fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
        guard let input = input else { return nil }
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
    }

    fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
    }
}
