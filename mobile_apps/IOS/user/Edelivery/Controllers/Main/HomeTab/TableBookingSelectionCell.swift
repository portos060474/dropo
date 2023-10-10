//
//  TableBookingSelectionCell.swift
//  edelivery
//
//  Created by Elluminati on 15/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class TableBookingSelectionCell: CustomTableCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var cvData: UICollectionView!
    @IBOutlet weak var lblNoTableFound: UILabel!

    var selectedIndex:Int!
    var isTableSelected:Bool = false
    var onItemSelected:((_ index:Int)->Void)? = nil
    var dataSource:[Any] = []
    var selectedTable:Table_list? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        self.cvData.register(UINib(nibName: "TableBookingSelectionCVCell", bundle: nil), forCellWithReuseIdentifier: "TableBookingSelectionCVCell")
        self.lblTitle.font = FontHelper.textRegular()
        self.lblTitle.textColor = .themeTextColor
        self.lblNoTableFound.font = FontHelper.textRegular()
        self.lblNoTableFound.textColor = .themeTextColor
        self.lblNoTableFound.text = "msg_no_table_available_for_people".localized
        self.cvData.delegate = self
        self.cvData.dataSource = self
    }

    //MARK:- SET CELL DATA
    func setCellData(cellItem:Any, isTableSelected:Bool = false, selectedTable:Table_list? = nil) {
        if cellItem is String {
            let strTitle:String = cellItem as! String
            self.lblTitle.text = strTitle
            for i in 1..<11 {
                dataSource.append(i)
            }
            self.cvData.reloadData()
            
        } else if cellItem is [Table_list] {
            self.lblTitle.text = "text_select_table".localized
            self.selectedTable = selectedTable
            dataSource = cellItem as! [Table_list]
            if dataSource.count > 0 {
                cvData.isHidden = false
                self.lblNoTableFound.isHidden = true
                self.isTableSelected = isTableSelected
                cvData.reloadData()
            } else {
                cvData.isHidden = true
                self.lblNoTableFound.isHidden = false
            }
        }
    }

    override func layoutSubviews() {}
}

extension TableBookingSelectionCell:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:TableBookingSelectionCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TableBookingSelectionCVCell", for: indexPath) as! TableBookingSelectionCVCell
        if self.dataSource is [Table_list] {
            let table:Table_list = dataSource[indexPath.row] as! Table_list
            cell.lblData.text = "\(table.table_no ?? 0)"

            if self.selectedTable != nil {
                if !isTableSelected {
                    if table._id == self.selectedTable!._id {
                        cell.viewForData.backgroundColor = .themeButtonBackgroundColor
                        cell.lblData.textColor = .themeButtonTitleColor
                        cell.viewForData.setRound(andCornerRadious: 15)
                    } else {
                        cell.viewForData.backgroundColor = .themeViewBackgroundColor
                        cell.lblData.textColor = .themeTextColor
                        cell.viewForData.setRound(withBorderColor: .themeLightGrayColor, andCornerRadious: 15, borderWidth: 1.0)
                    }
                } else {
                    if indexPath.row == selectedIndex {
                        cell.viewForData.backgroundColor = .themeButtonBackgroundColor
                        cell.lblData.textColor = .themeButtonTitleColor
                        cell.viewForData.setRound(andCornerRadious: 15)
                    } else {
                        cell.viewForData.backgroundColor = .themeViewBackgroundColor
                        cell.lblData.textColor = .themeTextColor
                        cell.viewForData.setRound(withBorderColor: .themeLightGrayColor, andCornerRadious: 15, borderWidth: 1.0)
                    }
                }
            } else {
                if self.isTableSelected && selectedIndex != nil && indexPath.row == selectedIndex {
                    cell.viewForData.backgroundColor = .themeButtonBackgroundColor
                    cell.lblData.textColor = .themeButtonTitleColor
                    cell.viewForData.setRound(andCornerRadious: 15)
                } else {
                    cell.viewForData.backgroundColor = .themeViewBackgroundColor
                    cell.lblData.textColor = .themeTextColor
                    cell.viewForData.setRound(withBorderColor: .themeLightGrayColor, andCornerRadious: 15, borderWidth: 1.0)
                }
            }
        } else {
            cell.lblData.text = "\(dataSource[indexPath.row])"
            if currentBooking.number_of_pepole > 0 {
                if selectedIndex == nil {
                    selectedIndex = currentBooking.number_of_pepole-1
                }
                if indexPath.row == selectedIndex {
                    cell.viewForData.backgroundColor = .themeButtonBackgroundColor
                    cell.lblData.textColor = .themeButtonTitleColor
                    cell.viewForData.setRound(andCornerRadious: 15)
                } else {
                    cell.viewForData.backgroundColor = .themeViewBackgroundColor
                    cell.lblData.textColor = .themeTextColor
                    cell.viewForData.setRound(withBorderColor: .themeLightGrayColor, andCornerRadious: 15, borderWidth: 1.0)
                }
            } else {
                if selectedIndex != nil && indexPath.row == selectedIndex {
                    cell.viewForData.backgroundColor = .themeButtonBackgroundColor
                    cell.lblData.textColor = .themeButtonTitleColor
                    cell.viewForData.setRound(andCornerRadious: 15)
                } else {
                    cell.viewForData.backgroundColor = .themeViewBackgroundColor
                    cell.lblData.textColor = .themeTextColor
                    cell.viewForData.setRound(withBorderColor: .themeLightGrayColor, andCornerRadious: 15, borderWidth: 1.0)
                }
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40.0, height: 40.0)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        if self.dataSource is [Table_list] {
            self.isTableSelected = true
        }
        collectionView.reloadData()
        if onItemSelected != nil {
            onItemSelected!(indexPath.row)
        }
    }
}
