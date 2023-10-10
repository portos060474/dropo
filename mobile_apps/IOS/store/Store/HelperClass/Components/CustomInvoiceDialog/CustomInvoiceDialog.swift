//
//  ManualProviderSelectionDialog.swift
//  Store
//
//  Created by  on 5/7/20.
//  Copyright © 2020 Elluminati. All rights reserved.
//

import Foundation
import UIKit

class CustomInvoiceDialog: CustomDialog, UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate{
    
    //MARK:- Outlets
//    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
   // @IBOutlet weak var lblPaymentDetails: UILabel!
   // @IBOutlet weak var lblOtherEarnings: UILabel!
    //@IBOutlet weak var lblTotalValue: UILabel!
   // @IBOutlet weak var lblCash: UILabel!
    //@IBOutlet weak var lblCashValue: UILabel!

//    @IBOutlet weak var heightOfTableView: NSLayoutConstraint!
    @IBOutlet weak var tableV: UITableView!
    
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblWallet: UILabel!
    @IBOutlet weak var lblWalletValue: UILabel!
    @IBOutlet weak var lblCard: UILabel!
    @IBOutlet weak var lblCardValue: UILabel!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var alertView: UIView!

    //MARK:- Variables
    //var arrForItemList = [StoreLanguage]();
   // var addedLanguagess:[String:String] = [:];
//    var tblDataOriginal = [ModelProvider]()
//    var tblDataFilterd = [ModelProvider]()
    var orderPaymentDetailObj : OrderPayment?
    var isFromProfile: Bool = false
    var cellIdentifier = "InvoiceDialogCell"
    var onItemSelected : ((_ selectedId:String) -> Void)? = nil
    var onClickAssignManuallySelected : (() -> Void)? = nil
    var onClickAssignAutoSelected : (() -> Void)? = nil
    var isAllowMultiselect: Bool!
    var selectedId: String = ""
    var arrForInvoice:NSMutableArray = [];
    var preferredContentSize: CGSize {
        get {
            // Force the table view to calculate its height
            self.tableV.layoutIfNeeded()
            return self.tableV.contentSize
        }
        set {}
    }
    
    override func awakeFromNib()
    {
        self.backgroundColor = UIColor.themeOverlayColor
        
    }
    public static func  showDialog(languages:[String:Any], title: String, options: OrderPayment, isFromProfile: Bool = false,isAllowMultiselect:Bool = true,isTaxIncluded:Bool, isTableBooking:Bool = false) -> CustomInvoiceDialog
    {
        let view = UINib(nibName: "CustomInvoiceDialog", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomInvoiceDialog
        
        view.setShadow()
        view.tableV.delegate = view;
        view.tableV.dataSource = view;
        view.tableV.register(UINib.init(nibName: view.cellIdentifier, bundle: nil), forCellReuseIdentifier: view.cellIdentifier)
        view.tableV.register(UINib.init(nibName: "InvoiceDialogSectionCell", bundle: nil), forCellReuseIdentifier: "InvoiceDialogSectionCell")

        view.orderPaymentDetailObj = options
        
        view.lblTitle.text = "TXT_INVOICE_DETAILS".localized
        view.lblTitle.textColor = UIColor.themeTextColor
        view.lblTitle.font = FontHelper.textLarge()
        view.lblWallet.textColor = UIColor.themeLightTextColor
        view.lblWalletValue.textColor = UIColor.themeTextColor
        view.lblCard.textColor = UIColor.themeLightTextColor
        view.lblCardValue.textColor = UIColor.themeTextColor
        view.lblTotal.textColor = UIColor.themeTextColor
        view.lblTotalPrice.textColor = UIColor.themeTextColor
        
        
        view.lblWallet.text = "TXT_WALLET".localized
        view.lblCard.text = "TXT_CARD".localized
        view.lblTotal.text = "TXT_TOTAL".localized
        
        view.lblWallet.font = FontHelper.textSmall()
        view.lblWalletValue.font = FontHelper.textSmall()
        view.lblCard.font = FontHelper.textSmall()
        view.lblCardValue.font = FontHelper.textSmall()
        
        view.lblTotal.font = FontHelper.textSmall()
        view.lblTotalPrice.font = FontHelper.textLargest()
        
        if view.orderPaymentDetailObj!.walletPayment != nil{
            view.lblWalletValue.text = "\((view.orderPaymentDetailObj!.walletPayment))"
                //(view.orderPaymentDetailObj!.walletPayment).toCurrencyString()
        }else{
            view.lblWalletValue.text = "0"
        }
        
        view.lblTotalPrice.text = Double(view.orderPaymentDetailObj!.total!).toCurrencyString()
           
        if view.orderPaymentDetailObj!.isPaymentModeCash != nil{
            if view.orderPaymentDetailObj!.isPaymentModeCash {
                view.lblCard.text = "TXT_CASH".localizedCapitalized
                view.lblCardValue.text = "\(view.orderPaymentDetailObj!.cashPayment)"
                //(view.orderPaymentDetailObj!.cashPayment).toCurrencyString()
            } else {
                view.lblCard.text = "TXT_CARD".localizedCapitalized
                if view.orderPaymentDetailObj!.cardPayment != nil{
                    view.lblCardValue.text = "\(view.orderPaymentDetailObj!.cardPayment)"
                    //(view.orderPaymentDetailObj!.cardPayment).toCurrencyString()
                } else {
                    view.lblCardValue.text = "0"
                }
            }
        }

        Parser.parseInvoice(view.orderPaymentDetailObj!, toArray: view.arrForInvoice, currency:"", isTaxIncluded: isTaxIncluded, isTableBooking: isTableBooking, completetion: { (result) in
            if result {
                view.tableV?.reloadData()
            }
        })
        
        view.isFromProfile = isFromProfile
        view.isAllowMultiselect = isAllowMultiselect
        
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame
        
        if view.preferredContentSize.height <= UIScreen.main.bounds.height - 150{
            view.viewHeight.constant = view.preferredContentSize.height + 140 + 50
        }else{
            view.viewHeight.constant = UIScreen.main.bounds.height - 140
        }
        
//        view.viewHeight.constant = 90+170+view.tableV.contentSize.height+50
        view.backgroundColor = UIColor.themeOverlayColor
        view.alertView.backgroundColor = UIColor.themeViewBackgroundColor

        APPDELEGATE.window?.addSubview(view)
        APPDELEGATE.window?.bringSubviewToFront(view);
        view.animationBottomTOTop(view.alertView)

        view.updateUIAccordingToTheme()
        let tapForOverlayLanguage = UITapGestureRecognizer(target: view, action:#selector(ManualProviderSelectionDialog.closeDialog))
        tapForOverlayLanguage.delegate = view
        view.addGestureRecognizer(tapForOverlayLanguage)
        return view;
    }

    
    public override func layoutSubviews() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.alertView.applyTopCornerRadius()
        }
    }
    
    override func updateUIAccordingToTheme() {
        btnClose.setImage(UIImage(named: "cross")?.imageWithColor(color: .themeColor), for: .normal)
    }
    
    //MARK: Tableview Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrForInvoice.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = tableView.dequeueReusableCell(withIdentifier: "InvoiceDialogSectionCell")! as! InvoiceDialogSectionCell
        sectionHeader.selectionStyle = .none
        if ((arrForInvoice[section] as? [Invoice])?.count)! > 0 {
            sectionHeader.setData(title: ((arrForInvoice.object(at: section) as! [Invoice])[0].sectionTitle!))
        }
        return sectionHeader
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.arrForInvoice.object(at: section) as! [Invoice]).count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
       var cell :InvoiceDialogCell?
       if let sCell: InvoiceDialogCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? InvoiceDialogCell {
           cell=sCell
           
       }else {
           cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellIdentifier) as? InvoiceDialogCell
       }
        cell?.selectionStyle = .none
//        let cell = tableView.dequeueReusableCell(withIdentifier: "InvoiceDialogCell", for: indexPath) as! InvoiceDialogCell
        let currentInvoiceItem:Invoice = ((arrForInvoice .object(at: indexPath.section)) as! [Invoice])[indexPath.row]
        cell!.setCellData(cellItem: currentInvoiceItem)
        
        return cell!
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: self.tableV) == true {
            return false
        }
        return true
    }
    
    @objc func closeDialog()
    {
        self.removeFromSuperview();
    }
    
    @IBAction func onClickBtnCancel(_ sender: Any)
    {
        closeDialog()
    }
    @IBAction func onClickBtnDone(_ sender: Any)
    {
        if self.onItemSelected != nil
        {
            self.onItemSelected!(selectedId)
        }
    }
}

class InvoiceDialogCell: CustomCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    //MARK:- LIFECYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        setLocalization()
    }
    
    //MARK:- SET CELL DATA
    func setCellData(cellItem:Invoice) {
        lblTitle.text = cellItem.title!
        lblSubTitle.text = cellItem.subTitle!
        lblPrice.text = cellItem.price!
        if cellItem.title! == "TXT_TOTAL_SERVICE_PRICE".localized || cellItem.title! == "TXT_TOTAL_ITEM_PRICE".localized {
            lblTitle.textColor = UIColor.themeTextColor
            lblPrice.textColor = UIColor.themeTextColor
            lblTitle.font =  FontHelper.textMedium()
            lblPrice.font =  FontHelper.textMedium()

            lblTitle.text = cellItem.title!.localizedUppercase
            lblSubTitle.text = cellItem.subTitle!.localizedUppercase
            
        }else {
            lblTitle.textColor = UIColor.themeTextColor
            lblPrice.textColor = UIColor.themeTextColor
            lblTitle.font =  FontHelper.textSmall()
            lblPrice.font =  FontHelper.textSmall()

            lblTitle.text = cellItem.title!.localizedCapitalized
            lblSubTitle.text = cellItem.subTitle!.localized
        }
    }
    
    func setLocalization() {
        //Colors
//        self.backgroundColor = UIColor.themeViewBackgroundColor
//        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        lblTitle.textColor = UIColor.themeTextColor
        lblSubTitle.textColor = UIColor.themeLightTextColor
        lblPrice.textColor = UIColor.themeTextColor
        /*Set Font*/
        lblTitle.font =  FontHelper.textSmall()
        lblSubTitle.font =  FontHelper.labelSmall()
        lblPrice.font =  FontHelper.textSmall()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
}
class InvoiceDialogSectionCell: CustomCell {
    
    @IBOutlet weak var lblSection: CustomPaddingLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        lblSection.backgroundColor = UIColor.themeViewLightBackgroundColor
//        lblSection.textColor = UIColor.themeButtonTitleColor
        lblSection.font = FontHelper.textRegular()
//        self.backgroundColor = UIColor.clear
//        self.contentView.backgroundColor = UIColor.clear
        lblSection.text = ""
    }
    
    func setData(title: String)
    {
        lblSection.text = title
//        lblSection.text = "   " + title + "   "
//        lblSection.text = title.appending("     ")
//        lblSection.sectionRound(lblSection)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
