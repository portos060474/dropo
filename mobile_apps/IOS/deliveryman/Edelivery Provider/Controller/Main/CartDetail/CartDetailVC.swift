//
// CartDetailVC.swift
//  edelivery
//
//  Created by Elluminati on 14/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class CartDetailVC: BaseVC {
    
    //MARK: - OutLets
    @IBOutlet weak var viewForDialog: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var mainOrderTable: UITableView!
    @IBOutlet weak var lblOrderDetail: UILabel!
    @IBOutlet weak var lblOrderNumber: UILabel!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!

    //MARK: - Variables
    var arrForProducts:[CartProduct] = []
    var currency:String = "";
    var strOrderNumber:String = "";

    //MARK: - LIFE CYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnCancel.setTitleColor(UIColor.themeIconTintColor, for: .normal)
        btnCancel.tintColor = UIColor.themeIconTintColor
        btnCancel.setTitle("", for: .normal)
        btnCancel.tintColor = .themeColor
        btnCancel.setImage(UIImage.init(named: "cancel_icon")?.imageWithColor(), for: .normal)
        btnCancel.backgroundColor = UIColor.clear
        lblOrderNumber.text = strOrderNumber
        lblOrderDetail.textColor = UIColor.themeTextColor
        lblOrderNumber.textColor = UIColor.themeLightTextColor
        lblOrderNumber.font = FontHelper.textRegular()
        lblOrderDetail.font = FontHelper.textLarge()
        viewForDialog.isHidden = true
        view.isOpaque = false
        view.backgroundColor = UIColor.themeOverlayColor
        viewForDialog.setShadow(shadowColor: UIColor.lightGray.cgColor, shadowOffset: CGSize.init(width: 0.0, height: 0.0), shadowOpacity: 0.17, shadowRadius: 3.0)
        viewForDialog.backgroundColor = UIColor.themeAlertViewBackgroundColor
        
        if arrForProducts.isEmpty {
            
        } else {
            self.mainOrderTable.estimatedRowHeight = 150
            self.mainOrderTable.rowHeight = UITableView.automaticDimension
            self.mainOrderTable.reloadData()
            //setConstraintForTableview()
            self.viewForDialog.isHidden = true
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mainOrderTable.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.view.animationBottomTOTop(self.viewForDialog)
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.mainOrderTable.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        self.tableViewHeight.constant = mainOrderTable.contentSize.height
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //self.setConstraintForTableview()
        self.viewForDialog.roundCorner(corners: [.topRight , .topLeft], withRadius: 20)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.mainOrderTable.reloadData()
    }

    func setConstraintForTableview() {
        if mainOrderTable.contentSize.height >= (UIScreen.main.bounds.height - (140 + UIApplication.shared.statusBarFrame.height)) {
            tableViewHeight.constant = (UIScreen.main.bounds.height - (140 + UIApplication.shared.statusBarFrame.height))
        }else {
            tableViewHeight.constant = mainOrderTable.contentSize.height
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onClickCancel(_ sender: Any) {
        print(mainOrderTable.contentSize.height)
        self.view.animationForHideAView(self.viewForDialog) {
            self.dismiss(animated: false) {
                
            }
        }
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomOrderDetailCell
        cell.setCellData(itemDetail: arrForProducts[indexPath.section].items![indexPath.row],currency: self.currency)
        cell.layoutIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionHeader = tableView.dequeueReusableCell(withIdentifier: "section")! as! OrderItemSection
        sectionHeader.setData(title: (arrForProducts[section].productName))
        return sectionHeader
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (arrForProducts[section].productName)
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

class OrderItemSection: CustomTableCell {
    @IBOutlet weak var lblSection: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        self.backgroundColor = UIColor.themeViewBackgroundColor
        lblSection.backgroundColor = UIColor.themeViewLightBackgroundColor
        lblSection.textColor = UIColor.themeButtonTitleColor
        lblSection.font = FontHelper.labelRegular()
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

class CustomOrderDetailCell: CustomTableCell {
    /*View For Items*/
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var lblItemDetail: UILabel!
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
    @IBOutlet weak var heightItem: NSLayoutConstraint?
    
    var arrForOrderItemSpecification:[OrderSpecification] = []
    var currency:String = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        tableForItemSpecification.dataSource = self
        tableForItemSpecification.delegate = self
        tableForItemSpecification.rowHeight = UITableView.automaticDimension
        tableForItemSpecification.estimatedRowHeight = 50
        tableForItemSpecification.tableFooterView = UIView()
        tableForItemSpecification.tableHeaderView = UIView()
        self.tableForItemSpecification.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        viewForItem.backgroundColor = UIColor.themeViewBackgroundColor
        lblItemPrice.textColor = UIColor.themeTextColor
        lblItemName.textColor = UIColor.themeTextColor
        lblItemQty.textColor = UIColor.themeTextColor
        lblItemQty.font = FontHelper.textSmall(size: 14)
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
        self.lblItemDetail.font = FontHelper.textRegular(size: 13)
        self.lblItemDetail.textColor = UIColor.themeLightTextColor
        //setConstraintForTableview()
        lblQty.font = FontHelper.textMedium(size: 14)
        lblQty.textColor = UIColor.themeLightTextColor
        lblQty.text = ""
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        self.heightForTable.constant = tableForItemSpecification.contentSize.height  + 10
    }
    
    func setCellData(itemDetail:OrderItem, currency:String) {
        lblQty.text = "TXT_QTY".localized + " "
        self.currency = currency
        
        self.lblItemDetail.text = itemDetail.details ?? ""
        
        if (itemDetail.itemPrice > 0.0) {
            lblItemQty.text =   String(itemDetail.quantity)  + " X " + itemDetail.itemPrice.toCurrencyString()
        }else {
            lblItemQty.text =  String(itemDetail.quantity)
        }
        
        lblItemName.text = itemDetail.itemName
        lblItemPrice.text =  ((itemDetail.totalSpecificationPrice +  itemDetail.itemPrice) * Double(itemDetail.quantity)).toCurrencyString()
       
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
        self.tableForItemSpecification.reloadData()
        self.layoutIfNeeded()
    }
}

extension CustomOrderDetailCell:UITableViewDataSource,UITableViewDelegate {//MARK: Tableview DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return    arrForOrderItemSpecification.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OrderItemSpecificationCell
        cell.setCellData(listItemDetail:arrForOrderItemSpecification[indexPath.section], currency:currency)
        heightForTable.constant = tableView.contentSize.height
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = tableView.dequeueReusableCell(withIdentifier: "section")! as! OrderItemSpecificationSection
        sectionHeader.setCellData(title: arrForOrderItemSpecification[section].specificationName ?? " ",price: arrForOrderItemSpecification[section].specificationPrice,currency: self.currency)
        sectionHeader.selectionStyle = .none
        return sectionHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//Cell For Item Detail
class OrderItemSpecificationCell: CustomTableCell {
    @IBOutlet weak var lblSpecificationName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.lblSpecificationName.textColor = UIColor.themeLightTextColor
        self.lblSpecificationName.font = FontHelper.labelSmall()
        self.lblSpecificationName.numberOfLines = 0
        self.lblPrice.textColor = UIColor.themeTextColor
        self.lblPrice.font = FontHelper.labelSmall()
        self.lblPrice.text = ""
        self.lblPrice.isHidden = true
    }
    
    func setCellData(listItemDetail:OrderSpecification,currency:String) {
        
        var specificationList = ""
       
        for i in listItemDetail.list {
            if listItemDetail.list.count == 1 || i.id == listItemDetail.list.last?.id {
                if i.quantity > 1 {
                    specificationList = specificationList + i.name  + ((i.price > 0.0) ? " (\(i.price.toCurrencyString()))" : "") + " x\(i.quantity)"
                } else {
                    specificationList = specificationList + i.name  + ((i.price > 0.0) ? " (\(i.price.toCurrencyString()))" : "")
                }
            } else {
                if i.quantity > 1 {
                    specificationList = specificationList  + i.name + ((i.price > 0.0) ? "(\(i.price.toCurrencyString()))" : "") + " x\(i.quantity)" + "\n"
                } else {
                    specificationList = specificationList  + i.name + ((i.price > 0.0) ? "(\(i.price.toCurrencyString()))" : "") + "\n"
                }
            }
        }
        lblSpecificationName.text = specificationList
        
    }
}

class OrderItemSpecificationSection: CustomTableCell {
    @IBOutlet weak var lblSpecifiationGroupName: UILabel!
    @IBOutlet weak var lblSpecificationPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.lblSpecificationPrice.textColor = UIColor.themeLightGrayTextColor
    }
    
    func setCellData(title:String, price:Double, currency:String) {
        lblSpecifiationGroupName.text = title
        if price > 0.0 {
            lblSpecificationPrice.text =  price.toCurrencyString()
        }else {
            lblSpecificationPrice.text = ""
        }
    }
}







