//
//  TableBookingOrderNowCell.swift
//  edelivery
//
//  Created by Elluminati on 21/10/21.
//  Copyright © 2021 Elluminati. All rights reserved.
//

import UIKit

class TableBookingOrderNowCell: CustomTableCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var cvData: UICollectionView!
    @IBOutlet weak var cvDataHeight: NSLayoutConstraint!

    var selectedIndex:Int = 0
    var onItemSelected:((_ index:Int)->Void)? = nil
    var dataSource:[String] = []
    var bookingType:Int!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.cvData.register(UINib(nibName: "TableBookingOrderNowOptionsCell", bundle: nil), forCellWithReuseIdentifier: "TableBookingOrderNowOptionsCell")
        self.lblTitle.font = FontHelper.textRegular()
        self.lblTitle.textColor = .themeTextColor
        self.cvData.delegate = self
        self.cvData.dataSource = self
    }

    //MARK:- SET CELL DATA
    func setCellData(arrOrderOptions:[String], bookingType:Int) {
        self.lblTitle.text = "text_would_you_like_order_now".localized
        self.bookingType = bookingType
        dataSource = arrOrderOptions
        cvData.reloadData()
        cvDataHeight.constant = self.cvData.collectionViewLayout.collectionViewContentSize.height
    }

    override func layoutSubviews() {}
}

extension TableBookingOrderNowCell:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:TableBookingOrderNowOptionsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TableBookingOrderNowOptionsCell", for: indexPath) as! TableBookingOrderNowOptionsCell
        cell.setCellData(text: dataSource[indexPath.row])
        if self.bookingType > 0 {
            if indexPath.row == (self.bookingType - 1) {
                cell.imgRadioSelection.image = UIImage.init(named: "radio_btn_checked_icon")
            } else {
                cell.imgRadioSelection.image = UIImage.init(named: "radio_btn_unchecked_icon")
            }
        } else {
            if selectedIndex == indexPath.row {
                cell.imgRadioSelection.image = UIImage.init(named: "radio_btn_checked_icon")
            } else {
                cell.imgRadioSelection.image = UIImage.init(named: "radio_btn_unchecked_icon")
            }
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cvData.frame.width, height: 30.0)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        self.bookingType = indexPath.row+1
        collectionView.reloadData()
        if onItemSelected != nil {
            onItemSelected!(indexPath.row)
        }
    }
}
