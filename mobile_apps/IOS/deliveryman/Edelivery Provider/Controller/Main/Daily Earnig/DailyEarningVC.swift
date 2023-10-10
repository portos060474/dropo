
//
//  DailyEarningVC.swift
//  Edelivery Provider
//
//  Created by Elluminati iMac on 25/04/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit

class DailyEarningVC: BaseVC {
  
    //Outlets For Earning
    @IBOutlet weak var btnDate: UIButton!
    @IBOutlet weak var scrDailyEarning: UIScrollView!
    @IBOutlet weak var mainViewForEarning: UIView!
    @IBOutlet weak var lblTotalProviderEarning: UILabel!
    @IBOutlet weak var tblEarning: UITableView!
    @IBOutlet weak var tblOrders: UITableView!
    @IBOutlet weak var lblPaymentToProvider: UILabel!
    @IBOutlet weak var lblProviderEarning: UILabel!
    @IBOutlet weak var collectionViewForAnalytic: UICollectionView!
    @IBOutlet weak var lblOrders: UILabel!
    @IBOutlet weak var imgEmpty: UIImageView!
    @IBOutlet weak var lblEmptyMsg: UILabel!
    @IBOutlet weak var heightForTblEarning: NSLayoutConstraint!
    @IBOutlet weak var heightCollectionAnalytic: NSLayoutConstraint!
    @IBOutlet weak var heightForTblOrder: NSLayoutConstraint!
    @IBOutlet weak var viewForTableViewHeader : UIView!
    @IBOutlet weak var lblEarn : UILabel!
    @IBOutlet weak var lblCashHave : UILabel!
    @IBOutlet weak var lblPaidOrder : UILabel!
    @IBOutlet weak var lblProfit : UILabel!
    @IBOutlet weak var lblServiceFee : UILabel!
    @IBOutlet weak var lblTotal : UILabel!
    @IBOutlet weak var lblPayBy : UILabel!
    @IBOutlet weak var lblOrder : UILabel!
   
    var arrForEarning = NSMutableArray()
    var arrForAnalytic = NSMutableArray()
    var arrForOrders = NSMutableArray()
    var strDateOfEarning:String = "";
    
    //MARK: View life cycle
   
    override func viewDidLoad() {
        super.viewDidLoad()
        lblEmptyMsg.isHidden = true
        strDateOfEarning = Utility.dateToString(date: Date(), withFormat: DATE_CONSTANT.DATE_MM_DD_YYYY)
        btnDate.setTitle(Utility.convertDateFormate(date: Date()), for: .normal)
        self.setLocalization()
        self.tblEarning.estimatedRowHeight = 40
        self.tblEarning.rowHeight = UITableView.automaticDimension
        wsGetDailyEarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayout()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        guard let flowLayout = collectionViewForAnalytic?.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        flowLayout.invalidateLayout()
    }
    
    //MARK: Set localized layout
    func setLocalization() {
        
        updateUI(isUpdate: false)
        self.title = "TXT_EARNING".localized
        lblPaymentToProvider.text = "TXT_PAY_TO_PROVIDER".localizedUppercase
        lblOrders.text = "TXT_ORDER".localizedUppercase
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        self.tblEarning.backgroundColor = UIColor.themeViewBackgroundColor
        self.collectionViewForAnalytic.backgroundColor = UIColor.themeViewBackgroundColor
        scrDailyEarning.backgroundColor = UIColor.themeViewBackgroundColor
        mainViewForEarning.backgroundColor = UIColor.themeViewBackgroundColor
        lblOrders.font = FontHelper.textMedium()
        btnDate.setTitleColor(UIColor.themeTextColor, for: .normal)
        lblProviderEarning.textColor = UIColor.themeLightTextColor
        lblPaymentToProvider.textColor = UIColor.themeLightTextColor
        lblOrders.textColor = UIColor.themeTextColor
        lblTotalProviderEarning.textColor = UIColor.themeColor
        
        /*Set Font*/
        btnDate.titleLabel?.font = FontHelper.textRegular(size: 20)
        lblPaymentToProvider.font = FontHelper.textMedium()
        lblProviderEarning.font = FontHelper.textMedium()
        lblTotalProviderEarning.font = FontHelper.textMedium(size:30)
        lblEmptyMsg.textColor = UIColor.themeTextColor
        lblEmptyMsg.font = FontHelper.textRegular()
        lblEmptyMsg.text = "TXT_DAILY_EARNING_LIST_EMPTY".localized
        viewForTableViewHeader.backgroundColor = .themeViewLightBackgroundColor
        tblOrders.backgroundColor = .themeViewBackgroundColor
        lblOrder.text = "TXT_ORDER".localizedCapitalized
        lblPayBy.text = "TXT_PAY_BY".localized
        lblTotal.text = "TXT_TOTAL".localizedCapitalized
        lblServiceFee.text = "TXT_SERVICE_FEE".localizedCapitalized
        lblProfit.text = "TXT_PROFIT".localizedCapitalized
        lblPaidOrder.text = "TXT_PAID_ORDER".localizedCapitalized
        lblCashHave.text = "TXT_CASH_HAVE".localizedCapitalized
        lblEarn.text = "TXT_EARNS".localizedCapitalized
    }
    
    func setupLayout() {
        collectionViewForAnalytic.layer.borderColor = UIColor.gray.cgColor
        collectionViewForAnalytic.layer.borderWidth = 0.5
    }
    
    @IBAction func onClickDate(_ sender: UIButton) {
        openDatePicker()
    }
   
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
 
    //MARK: Memory Mngmnt
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //MARK: User Define Function
    func updateUI(isUpdate:Bool = false) {
       heightForTblEarning.constant = tblEarning.contentSize.height
       heightCollectionAnalytic.constant = 360
       heightForTblOrder.constant = tblOrders.contentSize.height
       imgEmpty.isHidden = isUpdate
       mainViewForEarning.isHidden = !isUpdate
       self.view.layoutIfNeeded()
    }
  
    //MARK: wsGetEarning
    func wsGetDailyEarning() {
        Utility.showLoading()
        
        let dictParam:[String:String] =
            [PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken(),
             PARAMS.PROVIDER_ID : preferenceHelper.getUserId(),
             PARAMS.START_DATE : strDateOfEarning]
        
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_GET_DAILY_EARNING, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
       
            Parser.parseEarning(response, arrayListForEarning: self.arrForEarning, arrayListForAnalytic: self.arrForAnalytic, arrayListForOrders: self.arrForOrders, completetion: { (result) in
                if result {
                    
                    let dailyEarningResponse:DailyEarningResponse = DailyEarningResponse.init(fromDictionary: response )
                    self.lblProviderEarning.text = String(dailyEarningResponse.orderTotal.payToProvider!.roundTo())
                    self.lblTotalProviderEarning.text =
                        (dailyEarningResponse.orderTotal.totalEarning).toCurrencyString()
                    self.collectionViewForAnalytic.reloadData()
                    self.tblEarning.reloadData()
                    self.tblOrders.reloadData()
                    self.updateUI(isUpdate: true)
                }else {
                    self.updateUI(isUpdate: false)
                }
            })
                Utility.hideLoading()
       }
    }
    
    func openDatePicker() {
        let datePickerDialog: CustomDatePickerDialog = CustomDatePickerDialog.showCustomDatePickerDialog(title: "TXT_SELECT_DATE".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_SELECT".localized)
        datePickerDialog.setMaxDate(maxdate: Date())
        datePickerDialog.onClickLeftButton = { [unowned datePickerDialog] in
                datePickerDialog.removeFromSuperview()
        }
        datePickerDialog.onClickRightButton = { [unowned datePickerDialog, unowned self] (selectedDate:Date) in
                self.strDateOfEarning = Utility.dateToString(date: selectedDate, withFormat: DATE_CONSTANT.DATE_MM_DD_YYYY)
                self.btnDate.setTitle(Utility.convertDateFormate(date: selectedDate), for: .normal)
                self.wsGetDailyEarning()
                datePickerDialog.removeFromSuperview()
        }
    }
}
class EarningSectionCell: CustomTableCell {
    @IBOutlet weak var lblSection: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        lblSection.font = FontHelper.textMedium()
        lblSection.textColor = UIColor.themeTextColor
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
    }
    
    func setData(title: String){
        lblSection.text = title.uppercased()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
class EarningCell: CustomTableCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor =  UIColor.themeViewBackgroundColor;
        self.backgroundColor = UIColor.themeViewBackgroundColor
        lblTitle.font = FontHelper.labelRegular()
        lblPrice.font = FontHelper.labelRegular()
        lblPrice.textColor = UIColor.themeTextColor
        lblTitle.textColor = UIColor.themeTextColor
    }
    
    //MARK:- SET CELL DATA
    func setCellData(cellItem:Earning) {
        lblTitle.text = cellItem.title!
        lblPrice.text = cellItem.price!
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

extension DailyEarningVC: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
  
    //MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrForAnalytic.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollection
        cell.backgroundColor = .themeViewBackgroundColor
        cell.lblTitle.text = (arrForAnalytic.object(at: indexPath.row) as! Analytic).title!
        cell.lblValu.text = (arrForAnalytic.object(at: indexPath.row) as! Analytic).value!
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 0.25
        return cell
        
    }
   
    //MARK: UICollectionViewDelegateFlowLayout
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = ((collectionView.bounds.size.width) / CGFloat(2))
        return CGSize(width: itemWidth, height: 60)
    }
}

extension DailyEarningVC:UITableViewDelegate,UITableViewDataSource {
    
    //MARK: Tableview Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tblOrders {
            return 1
        }else {
        return self.arrForEarning.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblOrders {
            return arrForOrders.count
        }else {
            return (((arrForEarning.object(at: section)) as! [Earning]).count)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblOrders {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OrderCell
            let orderPayment:OrderPayment = (arrForOrders .object(at: indexPath.row) as! OrderPayment)
            cell.setCellData(cellItem:orderPayment)
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EarningCell
            let earning:Earning = ((arrForEarning .object(at: indexPath.section)) as! [Earning])[indexPath.row]
            cell.setCellData(cellItem:earning)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == tblOrders {
            return 0
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblOrders {
            return 20
        }
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == tblOrders {
            return UIView()
        }else {
            let sectionHeader = tableView.dequeueReusableCell(withIdentifier: "section")! as! EarningSectionCell
            sectionHeader.setData(title: ((arrForEarning.object(at: section) as! [Earning])[0].sectionTitle!))
            return sectionHeader
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

class CustomCollection: CustomCollectionCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblValu: UILabel!
    override func awakeFromNib() {
        self.contentView.backgroundColor =  UIColor.themeViewBackgroundColor;
        self.backgroundColor = UIColor.themeViewBackgroundColor
        lblTitle.font = FontHelper.labelRegular()
        lblValu.font = FontHelper.textRegular()
        lblTitle.textColor = UIColor.themeLightTextColor
        lblValu.textColor = UIColor.themeTextColor
    }
}

class OrderCell: CustomTableCell {
//MARK: Outlets
    @IBOutlet weak var lblOrderNo: UILabel!
    @IBOutlet weak var lblPayBy: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblServiceFee: UILabel!
    @IBOutlet weak var lblProfit: UILabel!
    @IBOutlet weak var lblPaid: UILabel!
    @IBOutlet weak var lblCash: UILabel!
    @IBOutlet weak var lblEarn: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor =  UIColor.themeViewBackgroundColor;
        self.backgroundColor = UIColor.themeViewBackgroundColor
        lblOrderNo.font = FontHelper.tiny()
        lblTotal.font = FontHelper.tiny()
        lblServiceFee.font = FontHelper.tiny()
        lblProfit.font = FontHelper.tiny()
        lblPaid.font = FontHelper.tiny()
        lblCash.font = FontHelper.tiny()
        lblEarn.font = FontHelper.tiny()
        lblOrderNo.textColor = UIColor.themeTextColor
        lblTotal.textColor = UIColor.themeTextColor
        lblServiceFee.textColor = UIColor.themeTextColor
        lblProfit.textColor = UIColor.themeTextColor
        lblPaid.textColor = UIColor.themeTextColor
        lblCash.textColor = UIColor.themeTextColor
        lblEarn.textColor = UIColor.themeTextColor
    }
    
    //MARK:- SET CELL DATA
    func setCellData(cellItem:OrderPayment) {
        lblOrderNo.text = String(cellItem.order_unique_id!)
        lblTotal.text  = String(cellItem.total!)
        lblServiceFee.text = String(cellItem.total_delivery_price!)
        lblProfit.text = String(cellItem.total_provider_income!)
        lblPaid.text = String(cellItem.provider_paid_order_payment!)
        lblCash.text = String(cellItem.provider_have_cash_payment!)
        lblEarn.text = String(cellItem.pay_to_provider!)
        
        if cellItem.isPaymentModeCash {
            lblPayBy.text = "TXT_CASH".localizedCapitalized
        }else {
            lblPayBy.text = "TXT_CARD".localizedCapitalized
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
