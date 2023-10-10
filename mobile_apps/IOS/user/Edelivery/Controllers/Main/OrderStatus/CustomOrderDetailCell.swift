//
//  CustomOrderDetailCell.swift
//  Store
//
//  Created by Elluminati on 04/04/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class CustomOrderDetailCell: CustomTableCell {

    @IBOutlet weak var viewForItem: UIView!
    @IBOutlet weak var lblItemPrice: UILabel!
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var lblItemQty: UILabel!
    @IBOutlet weak var lblnote: UILabel!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var lblItemnote: UILabel!
    @IBOutlet weak var heightForTable: NSLayoutConstraint!
    @IBOutlet weak var tableForItemSpecification: UITableView!
    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var btnIncrement: UIButton!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var btnDecrement: UIButton!
    @IBOutlet weak var viewForQuantity: UIView!
    
    @IBOutlet weak var lblAllSpecification: UILabel!
    
    var section:Int?
    var row:Int?
    var myCurrentItem:CartProductItems?;
    var arrForOrderItemSpecification:[Specifications] = []
    var strCurrency:String = ""
    weak var orderPlacedObject:OrderBeingPrepared?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableForItemSpecification.dataSource = self
        tableForItemSpecification.delegate = self
        tableForItemSpecification.estimatedRowHeight = 30
        tableForItemSpecification.rowHeight = UITableView.automaticDimension
        viewForItem.backgroundColor = UIColor.themeViewBackgroundColor
        lblItemPrice.textColor = UIColor.themeTextColor
        lblAllSpecification.textColor = UIColor.themeLightGrayColor
        lblItemName.textColor = UIColor.themeTextColor
        lblItemQty.textColor = UIColor.themeTextColor
        lblItemQty.font = FontHelper.textSmall()
        lblItemName.font = FontHelper.textMedium()
        lblAllSpecification.font = FontHelper.textMedium(size: 11)
        lblItemPrice.font = FontHelper.textMedium()
        lblItemnote.textColor = UIColor.themeTextColor
        lblItemnote.font = FontHelper.textSmall()
        footerView.backgroundColor = UIColor.themeViewBackgroundColor
        lblnote.textColor = UIColor.themeTextColor
        lblnote.font = FontHelper.textSmall()
        lblnote.text = "TXT_NOTE_FOR_ITEM".localizedCapitalized
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        self.tableForItemSpecification.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        lblQuantity.textColor =  UIColor.themeTextColor
        lblQuantity.font = FontHelper.labelRegular()
        viewForQuantity.backgroundColor = UIColor.themeViewBackgroundColor
        viewForQuantity.layer.borderWidth = 1
        viewForQuantity.layer.borderColor = UIColor.themeColor.cgColor
        btnIncrement.layer.borderColor = UIColor.themeColor.cgColor
        btnDecrement.layer.borderColor = UIColor.themeColor.cgColor
        btnIncrement.layer.borderWidth = 1
        btnDecrement.layer.borderWidth = 1
        btnIncrement.setTitleColor(UIColor.themeColor, for: .normal)
        btnDecrement.setTitleColor(UIColor.themeColor, for: .normal)
        btnRemove.tintColor = .themeColor
        btnRemove.setImage(UIImage(named: "cancelIcon")?.imageWithColor(color: .themeColor), for: .normal)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setCellData(itemDetail:CartProductItems,currency:String, isEdit: Bool,section:Int, row:Int, parent:OrderBeingPrepared, isEditSelect: Bool = false) {
        myCurrentItem = itemDetail
        self.section = section
        self.row = row
        self.orderPlacedObject = parent
        self.strCurrency = currency
        
        if (itemDetail.item_price! > 0.0) {
            lblItemQty.text = "TXT_QTY".localized + " " + String(itemDetail.quantity!)  + " X " + currency + " " + (itemDetail.item_price ?? 0.0).toString()
            
        }else {
            lblItemQty.text = "TXT_QTY".localized + " " + String(itemDetail.quantity!)
            
        }
        lblItemName.text = itemDetail.item_name!
        lblItemPrice.text = currency + " " +  ((itemDetail.total_specification_price! +  itemDetail.item_price!) * Double(itemDetail.quantity!)).toString()
        
        if !(itemDetail.image_url?.isEmpty)! {
            
        }
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
        
        if itemDetail.specifications.count > 0{
            arrForOrderItemSpecification.removeAll()
            if !isEditSelect {
                for i in 0...itemDetail.specifications.count-1{
                    if itemDetail.specifications[i].list!.count > 0{
                        arrForOrderItemSpecification.append(itemDetail.specifications[i])
                    }
                }
            } else {
                heightForTable.constant = 0
            }
        }
        
        var arrSpecification = [String]()
        for obj in itemDetail.specifications {
            for list in (obj.list ?? []) {
                if list.quantity > 1 {
                    arrSpecification.append("\(list.name ?? "") (\(list.quantity))")
                } else {
                    arrSpecification.append(list.name ?? "")
                }
            }
        }
        
        if arrSpecification.count > 0 && isEditSelect {
            lblAllSpecification.text = arrSpecification.joined(separator: ", ")
            lblAllSpecification.isHidden = false
        } else {
            lblAllSpecification.isHidden = true
        }
        
        btnRemove.isHidden = !isEdit
        viewForQuantity.superview?.isHidden = !isEdit
        lblItemQty.isHidden = isEdit
        lblQuantity.text = String(itemDetail.quantity!)
        self.tableForItemSpecification.reloadData()
        //heightForTable.constant = tableForItemSpecification.contentSize.height
        //self.layoutIfNeeded()
      
    }
    @IBAction func onClickBtnDecrement(_ sender: Any) {
        orderPlacedObject?.decreaseQuantity(currentProductItem: myCurrentItem!)
    }
    @IBAction func onClickBtnIncrement(_ sender: AnyObject) {
        orderPlacedObject?.increaseQuantity(currentProductItem: myCurrentItem!)
    }
    
    @IBAction func onClickBtnRemove(_ sender: Any) {
        orderPlacedObject?.removeItemFromCart(currentProductItem:  myCurrentItem!,section: section!,row: row!)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        tableForItemSpecification.layer.removeAllAnimations()
        heightForTable.constant = tableForItemSpecification.contentSize.height
        UIView.animate(withDuration: 0.1) {
            self.updateConstraints()
            self.layoutIfNeeded()
        }
    }
    override func layoutSubviews() {
        viewForQuantity.applyRoundedCornersWithHeight()
    }
    
}

extension CustomOrderDetailCell:UITableViewDataSource,UITableViewDelegate {//MARK: Tableview DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return    arrForOrderItemSpecification.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  arrForOrderItemSpecification[section].list!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OrderItemSpecificationCell
        cell.setCellData(listItemDetail:arrForOrderItemSpecification[indexPath.section].list![indexPath.row],currency: strCurrency)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionHeader = tableView.dequeueReusableCell(withIdentifier: "section")! as! OrderItemSpecificationSection
        sectionHeader.setCellData(title: arrForOrderItemSpecification[section].name ?? "",price:arrForOrderItemSpecification[section].price!,currency: strCurrency)
        return sectionHeader
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

class OrderItemSpecificationCell: CustomTableCell {
    @IBOutlet weak var lblSpecificationName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.lblSpecificationName.textColor = UIColor.themeTextColor
        self.lblSpecificationName.font = FontHelper.labelSmall()
        self.lblPrice.textColor = UIColor.themeTextColor
        self.lblPrice.font = FontHelper.labelSmall()
    }
    
    func setCellData(listItemDetail:SpecificationListItem, currency:String) {
        let strMultablAttribute = NSMutableAttributedString(string: (listItemDetail.name ?? "") + " ", attributes: [NSAttributedString.Key.font : lblSpecificationName.font!, NSAttributedString.Key.foregroundColor: lblSpecificationName.textColor as Any])
        
        if listItemDetail.quantity > 1 {
            let strQuantity = NSMutableAttributedString(string: "x\(listItemDetail.quantity)", attributes: [NSAttributedString.Key.font : FontHelper.textMedium(size: lblSpecificationName.font.pointSize), NSAttributedString.Key.foregroundColor: lblSpecificationName.textColor!])
            strMultablAttribute.append(strQuantity)
        }

        lblSpecificationName.attributedText = strMultablAttribute
            if listItemDetail.price! > 0.0 {
            lblPrice.text = currency + " " + (listItemDetail.price ?? 0.0).toString()
            }else {
                lblPrice.text = ""
            }
    }
}
class OrderItemSpecificationSection: CustomTableCell {
    @IBOutlet weak var lblSpecifiationGroupName: UILabel!
    @IBOutlet weak var lblSpecificationPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.lblSpecifiationGroupName.textColor = UIColor.themeTextColor
        self.lblSpecifiationGroupName.font = FontHelper.textMedium(size: FontHelper.labelRegular)
        self.lblSpecificationPrice.textColor = UIColor.themeTextColor
        self.lblSpecificationPrice.font = FontHelper.textMedium(size: FontHelper.labelRegular)
        
    }
    
    func setCellData(title:String, price:Double, currency:String) {
        lblSpecifiationGroupName.text = title
        if price > 0.0 {
            lblSpecificationPrice.text = currency + " "  + price.toString()
        }else {
            lblSpecificationPrice.text =  " "
            
        }
    }
}
