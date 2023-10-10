//
//  CustomOrderDetailCell.swift
//  Store
//
//  Created by Jaydeep Vyas on 04/04/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class CustomOrderDetailCell: CustomCell {
    
    /*View For Items*/
    @IBOutlet weak var viewForItem: UIView!
    @IBOutlet weak var lblItemPrice: UILabel!
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var lblItemQty: UILabel!
    
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var lblnote: UILabel!
    @IBOutlet weak var lblItemnote: UILabel!
    
    @IBOutlet weak var heightForTable: NSLayoutConstraint!
    /*Table For Selected Specification of Ordered Item*/
    @IBOutlet weak var tableForItemSpecification: UITableView!
    var arrForOrderItemSpecification:[OrderSpecification] = []
    var arrSpecificationGroup: [OrderSpecification] = []
    
    
//    var arrForOrderItemSpecificationNew:[SpecificationNew] = []
//    var arrSpecificationGroupNew: [SpecificationNew] = []
    
    var isFromCart : Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableForItemSpecification.dataSource = self
        tableForItemSpecification.delegate = self
        
        tableForItemSpecification.estimatedRowHeight = 30
        tableForItemSpecification.rowHeight = UITableView.automaticDimension
        
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
        lblnote.text = "TXT_NOTE_FOR_ITEM".localizedCapitalized
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        self.tableForItemSpecification.reloadData()
        
        setConstraintForTableview()
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setCellData(itemDetail:OrderItem) {
        isFromCart = true
        if (itemDetail.itemPrice > 0.0) {
            lblItemQty.text = "TXT_QTY".localized + " " + String(itemDetail.quantity)  + " X " + (itemDetail.itemPrice).toCurrencyString()
            
        }else {
            lblItemQty.text = "TXT_QTY".localized + " " + String(itemDetail.quantity)
            
        }
        lblItemName.text = itemDetail.itemName
        lblItemPrice.text =  ((itemDetail.totalSpecificationPrice +  itemDetail.itemPrice) * Double(itemDetail.quantity)).toCurrencyString()
        //if !itemDetail.imageURL.isEmpty {
            //imgItem.downloadedFrom(link: itemDetail.imageURL[0])
        //}
        
        if itemDetail.noteForItem.isEmpty {
            lblItemnote.isHidden = true
            lblnote.isHidden = true
            footerView.isHidden = true
        }else {
            lblItemnote.text =  itemDetail.noteForItem
            lblItemnote.isHidden = false
            lblnote.isHidden = false
            footerView.isHidden = false
        }
        arrForOrderItemSpecification = itemDetail.specifications
        arrSpecificationGroup.removeAll()
        arrForOrderItemSpecification.forEach { (itemSpecification) in
            if itemSpecification.list.count > 0 {
                arrSpecificationGroup.append(itemSpecification)
            }
        }
        
        self.tableForItemSpecification.reloadData()
        self.layoutIfNeeded()
        self.tableForItemSpecification.reloadData()
        setConstraintForTableview()
        
    }
    
    
   /* func setCellDataNew(itemDetail:ItemNew) {
        isFromCart = false
        if (itemDetail.itemPrice > 0.0) {
            lblItemQty.text = "TXT_QTY".localized + " " + String(itemDetail.quantity)  + " X " + (itemDetail.itemPrice).toCurrencyString()
        }else {
            lblItemQty.text = "TXT_QTY".localized + " " + String(itemDetail.quantity)
            
        }
        lblItemName.text = itemDetail.itemName
        lblItemPrice.text =  ((itemDetail.totalSpecificationPrice +  itemDetail.itemPrice) * Double(itemDetail.quantity)).toCurrencyString()
        //if !itemDetail.imageURL.isEmpty {
            //imgItem.downloadedFrom(link: itemDetail.imageURL[0])
       // }
        
        if itemDetail.noteForItem.isEmpty {
            lblItemnote.isHidden = true
            lblnote.isHidden = true
            footerView.isHidden = true
        }else {
            lblItemnote.text =  itemDetail.noteForItem
            lblItemnote.isHidden = false
            lblnote.isHidden = false
            footerView.isHidden = false
        }
        arrForOrderItemSpecificationNew = itemDetail.specifications
        
        arrSpecificationGroupNew.removeAll()
        arrForOrderItemSpecificationNew.forEach { (itemSpecification) in
            if itemSpecification.list.count > 0 {
                arrSpecificationGroupNew.append(itemSpecification)
            }
        }
        
        self.tableForItemSpecification.reloadData()
        self.layoutIfNeeded()
        self.tableForItemSpecification.reloadData()
        setConstraintForTableview()
        
    }*/
    
    func setConstraintForTableview() {
        heightForTable.constant = tableForItemSpecification.contentSize.height + 10
        print("Table content + \(tableForItemSpecification.contentSize )")
        self.layoutIfNeeded()
        
    }
}
extension CustomOrderDetailCell:UITableViewDataSource,UITableViewDelegate {//MARK: Tableview DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
      /*  if isFromCart{
            arrForOrderItemSpecification.forEach { (specificationGroup) in
                if specificationGroup.list.count > 0 {
                    numOfSections += 1
                }
            }
            return arrSpecificationGroup.count
        }else{
            arrForOrderItemSpecificationNew.forEach { (specificationGroup) in
                if specificationGroup.list.count > 0 {
                    numOfSections += 1
                }
            }
            return arrForOrderItemSpecificationNew.count
        }*/
        
        arrForOrderItemSpecification.forEach { (specificationGroup) in
              if specificationGroup.list.count > 0 {
                  numOfSections += 1
              }
        }
        return arrSpecificationGroup.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSpecificationGroup[section].list.count

        /*if isFromCart{
            return arrSpecificationGroup[section].list.count
        }else{
            return arrSpecificationGroupNew[section].list.count
        }*/
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OrderItemSpecificationCell
        cell.setCellData(listItemDetail:arrSpecificationGroup[indexPath.section].list[indexPath.row])

        /*if isFromCart{
            cell.setCellData(listItemDetail:arrSpecificationGroup[indexPath.section].list[indexPath.row])
        }else{
            cell.setCellDataNew(listItemDetail:arrSpecificationGroupNew[indexPath.section].list[indexPath.row])
        }*/
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionHeader = tableView.dequeueReusableCell(withIdentifier: "section")! as! OrderItemSpecificationSection
        if arrSpecificationGroup[section].list.count > 0 {
            sectionHeader.setCellData(title: arrSpecificationGroup[section].specificationName ?? "",price: arrSpecificationGroup[section].specificationPrice)
        }
       /* if isFromCart{
            if arrSpecificationGroup[section].list.count > 0 {
                sectionHeader.setCellData(title: arrSpecificationGroup[section].specificationName ?? "",price: arrSpecificationGroup[section].specificationPrice)
            }
        }else{
            if arrSpecificationGroupNew[section].list.count > 0 {
                sectionHeader.setCellData(title: arrSpecificationGroupNew[section].name ?? "",price: arrSpecificationGroupNew[section].price)
            }
        }*/
        return sectionHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
//Cell For Item Detail
class OrderItemSpecificationCell: CustomCell {
    @IBOutlet weak var lblSpecificationName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.lblSpecificationName.textColor = UIColor.themeTextColor
        self.lblSpecificationName.font = FontHelper.labelSmall(size: 12.0)
        
        self.lblPrice.textColor = UIColor.themeTextColor
        self.lblPrice.font = FontHelper.labelSmall(size: 12.0)
        
    }
    func setCellData(listItemDetail:OrderListItem) {
        
        let strMultablAttribute = NSMutableAttributedString(string: (listItemDetail.name ?? "") + " ", attributes: [NSAttributedString.Key.font : lblSpecificationName.font!, NSAttributedString.Key.foregroundColor: lblSpecificationName.textColor as Any])
        
        if listItemDetail.quantity > 1 {
            let strQuantity = NSMutableAttributedString(string: "x\(listItemDetail.quantity)", attributes: [NSAttributedString.Key.font : FontHelper.textMedium(size: lblSpecificationName.font.pointSize), NSAttributedString.Key.foregroundColor: lblSpecificationName.textColor!])
            strMultablAttribute.append(strQuantity)
        }
        
        lblSpecificationName.attributedText = strMultablAttribute
                
        if listItemDetail.price > 0.0 {
            lblPrice.text = (listItemDetail.price).toCurrencyString()
        }else {
            lblPrice.text = ""
        }
    }
    
    func setCellDataNew(listItemDetail:List) {
        lblSpecificationName.text = listItemDetail.name
        
        if listItemDetail.price > 0.0 {
            lblPrice.text = (listItemDetail.price).toCurrencyString()
        }else {
            lblPrice.text = ""
        }
    }
}

class OrderItemSpecificationSection: CustomCell {
    @IBOutlet weak var lblSpecifiationGroupName: CustomPaddingLabel!
    @IBOutlet weak var lblSpecificationPrice: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblSpecifiationGroupName.text = ""
        self.lblSpecificationPrice.text = ""
//        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
//        self.backgroundColor = UIColor.themeViewBackgroundColor
//        self.lblSpecifiationGroupName.textColor = UIColor.themeLightTextColor
        self.lblSpecifiationGroupName.font = FontHelper.textRegular(size: FontHelper.labelRegular)
        self.lblSpecificationPrice.textColor = UIColor.themeLightTextColor
        self.lblSpecificationPrice.font = FontHelper.textMedium(size: FontHelper.labelRegular)
    }
    
    func setCellData(title:String, price:Double) {
        lblSpecifiationGroupName.text = title.uppercased()
        if price > 0.0 {
            lblSpecificationPrice.text =  price.toCurrencyString()
            
        }else {
            lblSpecificationPrice.text = ""
        }
    }
    
    
}
