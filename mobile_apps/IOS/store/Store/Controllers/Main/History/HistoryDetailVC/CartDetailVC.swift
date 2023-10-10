//
// CartDetailVC.swift
//  edelivery
//
//  Created by Elluminati on 14/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class CartDetailVC: BaseVC {

   
//MARK: OutLets
    
 
     var arrForProducts:[OrderDetail] = []

//MARK: Variables

    @IBOutlet weak var mainOrderTable: UITableView!
//MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        arrForProducts.removeAll()
        //arrForProducts = selectedOrder.orderDetails!
        mainOrderTable.estimatedRowHeight = 100
        mainOrderTable.rowHeight = UITableView.automaticDimension
        mainOrderTable.reloadData()
        mainOrderTable.backgroundColor = UIColor.themeViewBackgroundColor
        mainOrderTable.setRound(withBorderColor: .themeLightTextColor, andCornerRadious: 5.0, borderWidth: 0.3)
        mainOrderTable.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}

extension CartDetailVC:UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return    arrForProducts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  arrForProducts[section].items!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCartOrderDetailCell
        
        cell.setCellData(itemDetail: arrForProducts[indexPath.section].items![indexPath.row])
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        let sectionHeader = tableView.dequeueReusableCell(withIdentifier: "section")! as! OrderItemSection
//
//        sectionHeader.setData(title: (arrForProducts[section].productName))
//        return sectionHeader
//
//    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (arrForProducts[section].productName)
    }
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 25
        return 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}



class CustomCartOrderDetailCell: CustomCell {
    
    /*View For Items*/
    @IBOutlet weak var viewForItem: UIView!
    @IBOutlet weak var lblItemPrice: UILabel!
    
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
        lblItemnote.textColor = UIColor.themeTextColor
        footerView.backgroundColor = UIColor.themeViewBackgroundColor
        tableForItemSpecification.estimatedRowHeight = 30
        tableForItemSpecification.rowHeight = UITableView.automaticDimension
        
        tableForItemSpecification.estimatedSectionHeaderHeight = 50
        
        lblItemQty.font = FontHelper.textSmall()
        lblItemName.font = FontHelper.textMedium()
        lblItemPrice.font = FontHelper.textMedium()
        lblItemnote.font = FontHelper.textSmall()
        lblnote.textColor = UIColor.themeTextColor
        lblnote.font = FontHelper.textSmall()
        
        lblnote.text = "TXT_NOTE_FOR_ITEM".localizedCapitalized
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setCellData(itemDetail:OrderItem) {
        

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
        if (itemDetail.itemPrice > 0.0) {
            lblItemQty.text = "TXT_QTY".localized + " " + String(itemDetail.quantity)  + " X " +   (itemDetail.itemPrice).toCurrencyString()
        }else {
            lblItemQty.text = "TXT_QTY".localized + " " + String(itemDetail.quantity)
            
        }
        lblItemName.text = itemDetail.itemName
        lblItemPrice.text =  ((itemDetail.totalSpecificationPrice +  itemDetail.itemPrice) * Double(itemDetail.quantity)).toCurrencyString()
        arrForOrderItemSpecification = itemDetail.specifications
        self.tableForItemSpecification.reloadData()
        heightForTable.constant = tableForItemSpecification.contentSize.height
        
     }
    
    
}

extension CustomCartOrderDetailCell:UITableViewDataSource,UITableViewDelegate {//MARK: Tableview DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return    arrForOrderItemSpecification.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  arrForOrderItemSpecification[section].list!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CartOrderItemSpecificationCell

        cell.setCellData(listItemDetail: arrForOrderItemSpecification[indexPath.section].list[indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionHeader = tableView.dequeueReusableCell(withIdentifier: "section")! as! OrderItemSpecificationSection
        
        sectionHeader.setCellData(title: arrForOrderItemSpecification[section].specificationName,price: arrForOrderItemSpecification[section].specificationPrice)
        return sectionHeader
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
class CartOrderItemSpecificationCell: CustomCell {
    @IBOutlet weak var lblSpecificationName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    
    
    
    override func awakeFromNib()
    {
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
}
