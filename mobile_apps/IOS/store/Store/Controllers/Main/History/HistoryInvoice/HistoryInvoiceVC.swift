//
//  HistoryInvoiceVC.swift
//  Edelivery
//   Created by Ellumination 23/04/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit

class HistoryInvoiceVC: BaseVC, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewForHeader: UIView!
    @IBOutlet weak var viewForBottom: UIView!

    @IBOutlet weak var imgTime: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblTimeValue: UILabel!

    @IBOutlet weak var imgDistance: UIImageView!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblDistanceValue: UILabel!

    @IBOutlet weak var imgPaymentIn: UIImageView!
    @IBOutlet weak var imgPaymentBy: UIImageView!
    @IBOutlet weak var lblPayment: UILabel!
    @IBOutlet weak var lblPaymentValue: UILabel!

    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblWallet: UILabel!
    @IBOutlet weak var lblWalletValue: UILabel!
    @IBOutlet weak var lblCard: UILabel!
    @IBOutlet weak var lblCardValue: UILabel!

    @IBOutlet weak var btnSubmitHeight: NSLayoutConstraint!
    var dict = NSMutableDictionary()
    var arr = [NSString]()

    public var orderPayment: OrderPayment!
    public var paymentType:String = ""
    public var strCurrency: String = ""

    public var strOrderID: String = ""
    public var imgurl: String = ""
    public var name: String = ""
    public var isTaxIncluded: Bool = false
    public var isTableBooking: Bool = false
    public var orderCartDetail:CartDetail!

    var arrForInvoice:NSMutableArray = [];

    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLocalization()
    }

    //MARK:- Set localized layout
    func setLocalization() {
        self.tableView.estimatedRowHeight = 30
        self.tableView.rowHeight = UITableView.automaticDimension
        // COLORS
        view.backgroundColor = UIColor.themeViewBackgroundColor
        lblTime.textColor = UIColor.themeLightTextColor
        lblTimeValue.textColor = UIColor.themeTextColor
        lblDistance.textColor = UIColor.themeLightTextColor
        lblDistanceValue.textColor = UIColor.themeTextColor
        lblPayment.textColor = UIColor.themeLightTextColor
        lblPaymentValue.textColor = UIColor.themeTextColor
        lblWallet.textColor = UIColor.themeLightTextColor
        lblWalletValue.textColor = UIColor.themeTextColor
        lblCard.textColor = UIColor.themeLightTextColor
        lblCardValue.textColor = UIColor.themeTextColor
        lblTotal.textColor = UIColor.themeLightTextColor
        lblTotalPrice.textColor = UIColor.themeTextColor
        viewForHeader.backgroundColor = UIColor.themeViewBackgroundColor
        viewForBottom.backgroundColor = UIColor.themeViewBackgroundColor
        tableView.backgroundColor = UIColor.themeViewBackgroundColor
        
         // LOCALIZED
        
        self.title = "TXT_INVOICE".localized
        lblPayment.text = "TXT_PAYMENT".localized.localizedCapitalized
        lblWallet.text = "TXT_WALLET".localized
        lblCard.text = "TXT_CARD".localized
        lblTotal.text = "TXT_TOTAL_AMOUNT".localized
        
        /* Set Font */
        lblTime.font = FontHelper.textRegular()
        lblTimeValue.font = FontHelper.textRegular()
        lblDistance.font = FontHelper.textRegular()
        lblDistanceValue.font = FontHelper.textRegular()
        
        lblPayment.font = FontHelper.textRegular()
        lblPaymentValue.font = FontHelper.textRegular()
        
        lblWallet.font = FontHelper.textSmall()
        lblWalletValue.font = FontHelper.textSmall()
        lblCard.font = FontHelper.textSmall()
        lblCardValue.font = FontHelper.textSmall()
        
        lblTotal.font = FontHelper.textRegular()
        lblTotalPrice.font = FontHelper.textLargest()
        self.hideBackButtonTitle()
        updateUIAccordingToTheme()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
         viewForBottom.setShadow(shadowColor: UIColor.lightGray.cgColor, shadowOffset: CGSize.init(width: 0.0, height: -1.0), shadowOpacity: 0.25, shadowRadius: 1.0)
    }

    override func updateUIAccordingToTheme() {
        if orderPayment != nil{
            getInvoiceData()
        }
    }

    //MARK:- Get Invoice Data
    func getInvoiceData() {
        let unit = (orderPayment.isDistanceUnitMile) ? "UNIT_MILE".localized : "UNIT_KM".localized;

        if self.isTableBooking {
            lblTime.text = "text_table_no".localized
            lblTimeValue.text = String(format:"%d", self.orderCartDetail.table_no)
            imgTime.image = UIImage.init(named: "table_booking")!.imageWithColor(color: .themeIconTintColor)!
            lblDistance.text = "text_persons".localized
            lblDistanceValue.text = String(format:"%d", self.orderCartDetail.no_of_persons)
            imgDistance.image = UIImage.init(named: "table_persons")!.imageWithColor(color: .themeIconTintColor)!
        } else {
            lblTime.text = "TXT_TIME_HH_MM".localized
            lblTimeValue.text = Utility.minutToHoursMinutes(minut: orderPayment.totalTime ?? 0.0)
            imgTime.image = UIImage.init(named: "time")!.imageWithColor(color: .themeIconTintColor)!
            lblDistance.text = "TXT_DISTANCE".localized
            lblDistanceValue.text = String(orderPayment.totalDistance!) + " " + unit
            imgDistance.image = UIImage.init(named: "distance")!.imageWithColor(color: .themeIconTintColor)!
        }

        lblPaymentValue.text = paymentType
        lblWalletValue.text = (orderPayment.walletPayment).toCurrencyString()
        lblTotalPrice.text = (orderPayment.total!).toCurrencyString()

        if orderPayment.isPaymentModeCash {
            imgPaymentBy.image = UIImage.init(named: "cash_icon")!.imageWithColor(color: .themeIconTintColor)!
            imgPaymentIn.image = UIImage.init(named: "cash_icon")!.imageWithColor(color: .themeIconTintColor)!
            lblCard.text = "TXT_CASH".localizedCapitalized
            lblCardValue.text =  (orderPayment.cashPayment).toCurrencyString()
        } else {
            imgPaymentBy.image = UIImage.init(named: "card_icon")!.imageWithColor(color: .themeIconTintColor)!
            imgPaymentIn.image = UIImage.init(named: "card_icon")!.imageWithColor(color: .themeIconTintColor)!
            lblCard.text = "TXT_CARD".localizedCapitalized
            lblCardValue.text = (orderPayment.cardPayment).toCurrencyString()
        }

        Parser.parseInvoice(orderPayment, toArray: self.arrForInvoice, currency:strCurrency, isTaxIncluded: isTaxIncluded, isTableBooking:isTableBooking, completetion: { (result) in
            if result {
                self.tableView?.reloadData()
            }
        })
    }

    //MARK:- Tableview Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrForInvoice.count
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = tableView.dequeueReusableCell(withIdentifier: "section")! as! InvoiceSectionCell
        if ((arrForInvoice[section] as? [Invoice])?.count)! > 0 {
            sectionHeader.setData(title: ((arrForInvoice.object(at: section) as! [Invoice])[0].sectionTitle!))
        }
        return sectionHeader
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.arrForInvoice.object(at: section) as! [Invoice]).count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! InvoiceCell
        let currentInvoiceItem:Invoice = ((arrForInvoice .object(at: indexPath.section)) as! [Invoice])[indexPath.row]
        cell.setCellData(cellItem: currentInvoiceItem)
        return cell
    }

    //MARK:- Memory mngmnt
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

class InvoiceCell: CustomCell {
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
            lblTitle.text = cellItem.title!.localizedUppercase
            lblSubTitle.text = cellItem.subTitle!.localizedUppercase

            lblTitle.font = FontHelper.textMedium()
            lblSubTitle.font = FontHelper.textSmall()
            lblPrice.font = FontHelper.textMedium()
        } else {
            lblTitle.textColor = UIColor.themeTextColor
            lblPrice.textColor = UIColor.themeTextColor
            lblTitle.text = cellItem.title!.localizedCapitalized
            lblSubTitle.text = cellItem.subTitle!.localized

            lblTitle.font = FontHelper.textRegular()
            lblSubTitle.font = FontHelper.textSmall()
            lblPrice.font = FontHelper.textRegular()
        }
    }

    func setLocalization() {
        //Colors
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor

        lblTitle.textColor = UIColor.themeTextColor
        lblSubTitle.textColor = UIColor.themeLightTextColor
        lblPrice.textColor = UIColor.themeTextColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

class InvoiceSectionCell: CustomCell {

    @IBOutlet weak var lblSection: CustomPaddingLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
//        lblSection.backgroundColor = UIColor.themeSectionBackgroundColor
//        lblSection.textColor = UIColor.themeButtonTitleColor
        lblSection.font = FontHelper.textRegular()
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        lblSection.text = ""
        
    }
    
    func setData(title: String)
         {
        
//        lblSection.text = "   " + title + "   "
        lblSection.paddingLeft = 10
        lblSection.paddingRight = 10
        lblSection.text = title.uppercased()
        lblSection.sectionRound(lblSection)
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

