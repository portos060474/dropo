//
// CartDetailVC.swift
//  edelivery
//
//  Created by Elluminati on 14/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
/*
class HistoryCartOrderItemSection: UITableViewCell {
    @IBOutlet weak var lblSection: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        self.backgroundColor = UIColor.themeViewBackgroundColor
        lblSection.backgroundColor = UIColor.themeSectionBackgroundColor
        lblSection.textColor = UIColor.themeButtonTitleColor
        lblSection.font = FontHelper.textRegular()
        
    }
    
    func setData(title: String)
         {
        lblSection.text = title.appending("     ")
        lblSection.sectionRound(lblSection)
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}


class HistoryCartProductItemCell: UITableViewCell {
    
    /*View For Items*/
    @IBOutlet weak var viewForItem: UIView!
    @IBOutlet weak var lblItemPrice: UILabel!
    @IBOutlet weak var imgItem: UIImageView!
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var lblItemQty: UILabel!
    @IBOutlet weak var lblnote: UILabel!
    
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var lblItemnote: UILabel!
    
    @IBOutlet weak var heightForTable: NSLayoutConstraint!
    /*Table For Selected Specification of Ordered Item*/
    @IBOutlet weak var tableForItemSpecification: UITableView!
    var arrForOrderItemSpecification:[OrderSpecification] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        tableForItemSpecification.dataSource = self
        tableForItemSpecification.delegate = self
        viewForItem.backgroundColor = UIColor.themeViewBackgroundColor
        lblItemPrice.textColor = UIColor.themeTextColor
        lblItemName.textColor = UIColor.themeTextColor
        lblItemQty.textColor = UIColor.themeTextColor
        lblItemQty.font = FontHelper.textSmall()
        lblItemName.font = FontHelper.textMedium()
        lblItemPrice.font = FontHelper.textMedium()
        lblItemnote.textColor = UIColor.themeTextColor
        lblItemnote.font = FontHelper.textSmall()
        footerView.backgroundColor = UIColor.themeViewBackgroundColor
        lblnote.textColor = UIColor.themeTextColor
        lblnote.font = FontHelper.textSmall()
        lblnote.text = "TXT_NOTE".localizedCapitalized
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setCellData(itemDetail:OrderItem) {
        
        
        if itemDetail.noteForItem.isEmpty() {
            tableForItemSpecification.tableFooterView = UIView()
        }else {
            
            lblItemnote.text =  itemDetail.noteForItem
            tableForItemSpecification.tableFooterView = footerView
        }
        if (itemDetail.itemPrice > 0.0) {
            
            lblItemQty.text = "TXT_QTY".localized + " " + String(itemDetail.quantity)  + " X " + StoreSingleton.shared.store.currency + " " +  String(itemDetail.itemPrice)
            
        }else {
            lblItemQty.text = "TXT_QTY".localized + " " + String(itemDetail.quantity)
            
        }
        lblItemName.text = itemDetail.itemName
        lblItemPrice.text =  StoreSingleton.shared.store.currency + " " +  String((itemDetail.totalSpecificationPrice +  itemDetail.itemPrice) * Double(itemDetail.quantity))
        if !itemDetail.imageURL.isEmpty() {
            imgItem.downloadedFrom(link: itemDetail.imageURL[0])
        }
        
        arrForOrderItemSpecification = itemDetail.specifications
        self.tableForItemSpecification.reloadData()
        heightForTable.constant = tableForItemSpecification.contentSize.height
        
        
    }
    
    
}
extension HistoryCartProductItemCell:UITableViewDataSource,UITableViewDelegate {//MARK: Tableview DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return    arrForOrderItemSpecification.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  arrForOrderItemSpecification[section].list.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HistoryCartOrderItemSpecificationCell
        
        cell.setCellData(listItemDetail:arrForOrderItemSpecification[indexPath.section].list[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 20
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionHeader = tableView.dequeueReusableCell(withIdentifier: "section")! as! OrderItemSpecificationSection
        
        sectionHeader.setCellData(title: arrForOrderItemSpecification[section].specificationName ?? "",price: String(arrForOrderItemSpecification[section].specificationPrice))
        return sectionHeader
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
//Cell For Item Detail
class HistoryCartOrderItemSpecificationCell: UITableViewCell {
    @IBOutlet weak var lblSpecificationName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.lblSpecificationName.textColor = UIColor.themeTextColor
        self.lblSpecificationName.font = FontHelper.tiny()
        
        self.lblPrice.textColor = UIColor.themeTextColor
        self.lblPrice.font = FontHelper.tiny()
        
    }
    func setCellData(listItemDetail:OrderListItem) {
        lblSpecificationName.text = listItemDetail.name
        
        if listItemDetail.price > 0.0 {
            lblPrice.text = StoreSingleton.shared.store.currency + " " + String(listItemDetail.price)
        }else {
            lblPrice.text = ""
        }
    }
}
class OrderItemSpecificationSection: UITableViewCell {
    @IBOutlet weak var lblSpecifiationGroupName: UILabel!
    
    @IBOutlet weak var lblSpecificationPrice: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.lblSpecifiationGroupName.textColor = UIColor.themeTextColor
        self.lblSpecifiationGroupName.font = FontHelper.textSmall()
        self.lblSpecificationPrice.textColor = UIColor.themeTextColor
        self.lblSpecificationPrice.font = FontHelper.textSmall()
        
        
    }
    func setCellData(title:String, price:String) {
        lblSpecifiationGroupName.text = title
        lblSpecificationPrice.text =  StoreSingleton.shared.store.currency + " " +  price
    }
}
 */
