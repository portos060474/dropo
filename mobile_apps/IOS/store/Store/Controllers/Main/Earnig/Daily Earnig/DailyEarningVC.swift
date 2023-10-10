
//
//  DailyEarningVC.swift
//  // Edelivery Store
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
    @IBOutlet weak var lblTotalStoreEarning: UILabel!
    @IBOutlet weak var tblEarning: UITableView!
    @IBOutlet weak var tblOrders: UITableView!
    @IBOutlet weak var lblPaymentToStore: UILabel!
    @IBOutlet weak var lblStoreEarning: UILabel!
    @IBOutlet weak var collectionViewForAnalytic: UICollectionView!
    @IBOutlet weak var lblOrders: UILabel!
    @IBOutlet weak var imgEmpty: UIImageView!
    
    @IBOutlet weak var viewBG: UIView!

    var arrForEarning = NSMutableArray()
    var arrForAnalytic = NSMutableArray()
    var arrForOrders = NSMutableArray()
    var strDateOfEarning:String = "";
    
    @IBOutlet weak var heightForTblEarning: NSLayoutConstraint!
    @IBOutlet weak var heightCollectionAnalytic: NSLayoutConstraint!
    @IBOutlet weak var heightForTblOrder: NSLayoutConstraint!

    @IBOutlet weak var lblOrderNo: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblOrderFee: UILabel!
    @IBOutlet weak var lblProfit: UILabel!
    @IBOutlet weak var lblPaid: UILabel!
    @IBOutlet weak var lblPaidOrder: UILabel!
    @IBOutlet weak var lblEarn: UILabel!

    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        strDateOfEarning = Utility.dateToString(date: Date(), withFormat: DATE_CONSTANT.DATE_MM_DD_YYYY)
        btnDate.setTitle(Utility.convertDateFormate(date: Date()), for: .normal)
        self.setLocalization()
        self.tblEarning.estimatedRowHeight = 40
        self.tblEarning.rowHeight = UITableView.automaticDimension
        scrDailyEarning.showsVerticalScrollIndicator = false
        collectionViewForAnalytic.isScrollEnabled = false
        
        self.tblEarning.tableFooterView = UIView.init(frame: CGRect.zero)

        lblOrderNo.text = "TXT_ORDER".localizedCapitalized
        lblTotal.text = "TXT_TOTAL".localizedCapitalized
        lblOrderFee.text = "TXT_SERVICE_FEE".localizedCapitalized
        lblProfit.text = "TXT_PROFIT".localizedCapitalized
        lblPaid.text = "TXT_PAID_DELIVERY".localizedCapitalized
        lblPaidOrder.text = "TXT_PAID_ORDER".localizedCapitalized
        lblEarn.text = "TXT_EARN".localizedCapitalized
        wsGetDailyEarning()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayout()

    }
    
    override func viewWillLayoutSubviews() {
        self.collectionViewForAnalytic.reloadData()
    }
    //MARK: Set localized layout
    func setLocalization() {
        updateUI(isUpdate: false)
        //LOCALIZED
        self.title = "TXT_EARNING".localized
        lblPaymentToStore.text = "TXT_PAY_TO_STORE".localizedUppercase
        lblOrders.text = "TXT_ORDER".localizedUppercase


        //COLORS
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        self.tblEarning.backgroundColor = UIColor.themeViewBackgroundColor
        self.collectionViewForAnalytic.backgroundColor = UIColor.themeViewBackgroundColor
        scrDailyEarning.backgroundColor = UIColor.themeViewBackgroundColor
        
        mainViewForEarning.backgroundColor = UIColor.themeViewBackgroundColor
        
        lblOrders.font = FontHelper.textMedium()
        btnDate.setTitleColor(UIColor.themeTextColor, for: .normal)

        lblStoreEarning.textColor = UIColor.themeColor
        lblPaymentToStore.textColor = UIColor.themeColor
        lblOrders.textColor = UIColor.themeTextColor
        lblTotalStoreEarning.textColor = UIColor.themeColor
        
        /*Set Font*/
        btnDate.titleLabel?.font = FontHelper.textLarge()
        lblPaymentToStore.font = FontHelper.textMedium()
        lblStoreEarning.font = FontHelper.textMedium()
        lblTotalStoreEarning.font = FontHelper.textMedium(size: 30)
        viewBG.backgroundColor = UIColor(named: "themeSectionBGColor")
        
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
        heightCollectionAnalytic.constant = 300
        heightForTblOrder.constant = tblOrders.contentSize.height
        imgEmpty.isHidden = isUpdate
        mainViewForEarning.isHidden = !isUpdate
        self.view.layoutIfNeeded()
        self.mainViewForEarning.layoutIfNeeded()
    }
    //MARK: wsGetEarning
    func wsGetDailyEarning() {
        Utility.showLoading()
        
        
        let dictParam:[String:String] =
            [PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken(),
             PARAMS.STORE_ID : preferenceHelper.getUserId(),
             PARAMS.START_DATE : strDateOfEarning]
        print(Utility.conteverDictToJson(dict: dictParam))
        
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_GET_DAILY_EARNING, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in

            print(Utility.conteverDictToJson(dict: response))

            
            Parser.parseEarning(response, arrayListForEarning: self.arrForEarning, arrayListForAnalytic: self.arrForAnalytic, arrayListForOrders: self.arrForOrders, completetion: { (result) in
                if result {
                    let dailyEarningResponse:DailyEarningResponse = DailyEarningResponse.init(fromDictionary: response)
                    
                    self.lblStoreEarning.text = (dailyEarningResponse.orderTotal.payToStore!).toString()
                    self.lblTotalStoreEarning.text =  (dailyEarningResponse.orderTotal.totalEarning!).toCurrencyString()
                    
                    
                    self.collectionViewForAnalytic.reloadData()
                    self.tblEarning.reloadData()
                    self.tblOrders.reloadData()
                    self.updateUI(isUpdate: true)
                }
                else {
                    self.updateUI(isUpdate: false)
                    
                }
            })
            Utility.hideLoading()
        }
    }
    
    func openDatePicker() {
        let datePickerDialog:CustomDatePickerDialog = CustomDatePickerDialog.showCustomDatePickerDialog(title: "TXT_SELECT_DATE".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_SELECT".localized)
        datePickerDialog.setMaxDate(maxdate: Date())
        datePickerDialog.onClickLeftButton = { [unowned datePickerDialog] in
            datePickerDialog.removeFromSuperview()
        }
        
        datePickerDialog.onClickRightButton = { [unowned datePickerDialog, unowned self]  (selectedDate:Date) in
            self.strDateOfEarning = Utility.dateToString(date: selectedDate, withFormat: DATE_CONSTANT.DATE_MM_DD_YYYY)
            self.btnDate.setTitle(Utility.convertDateFormate(date: selectedDate), for: .normal)
            self.wsGetDailyEarning()
            datePickerDialog.removeFromSuperview()
        }
        
        
    }
    
    
}
class EarningSectionCell: CustomCell {
    
    
    
    @IBOutlet weak var lblSection: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblSection.font = FontHelper.textMedium()
        lblSection.textColor = UIColor.themeTextColor
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        
    }
    
    func setData(title: String)
         {
        
        lblSection.text = title.uppercased()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
class EarningCell: CustomCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor =  UIColor.themeViewBackgroundColor;
        self.backgroundColor = UIColor.themeViewBackgroundColor
        lblTitle.font = FontHelper.textRegular()
        lblPrice.font = FontHelper.textRegular()
        
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionViewForAnalytic?.collectionViewLayout.invalidateLayout()
        super.viewWillTransition(to: size, with: coordinator)
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EarningOrderCell
            
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
        return 50
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
        
        sectionHeader.setData(title: ((arrForEarning.object(at: section) as! [Earning]).first?.sectionTitle) ?? "")
        
            return sectionHeader
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }



}
class CustomCollection:UICollectionViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblValu: UILabel!
   
    override func awakeFromNib() {
            lblTitle.font = FontHelper.textSmall()
            lblValu.font = FontHelper.textSmall()
            lblTitle.textColor = UIColor.themeLightTextColor
            lblValu.textColor = UIColor.themeTextColor
        }
}
class EarningOrderCell: CustomCell {
    @IBOutlet weak var lblOrderNo: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblOrderFee: UILabel!
    @IBOutlet weak var lblProfit: UILabel!
    @IBOutlet weak var lblPaid: UILabel!
    @IBOutlet weak var lblPaidOrder: UILabel!
    @IBOutlet weak var lblEarn: UILabel!
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor =  UIColor(named: "themeSectionBGColor");
        self.backgroundColor = UIColor(named: "themeSectionBGColor")
        
        lblOrderNo.font = FontHelper.tiny()
        lblTotal.font = FontHelper.tiny()
        lblOrderFee.font = FontHelper.tiny()
        lblProfit.font = FontHelper.tiny()
        lblPaid.font = FontHelper.tiny()
        lblPaidOrder.font = FontHelper.tiny()
        lblEarn.font = FontHelper.tiny()
        
        lblOrderNo.textColor = UIColor.themeTextColor
        lblTotal.textColor = UIColor.themeTextColor
        lblOrderFee.textColor = UIColor.themeTextColor
        lblProfit.textColor = UIColor.themeTextColor
        lblPaid.textColor = UIColor.themeTextColor
        lblPaidOrder.textColor = UIColor.themeTextColor
        lblEarn.textColor = UIColor.themeTextColor

    }
    
    //MARK:- SET CELL DATA
    func setCellData(cellItem:OrderPayment) {

        
        lblOrderNo.text = String(cellItem.orderUniqueId)
        lblTotal.text  = (cellItem.total).toString()
        lblOrderFee.text = (cellItem.totalOrderPrice).toString()
        lblProfit.text = (cellItem.totalStoreIncome).toString()
        lblPaid.text = (cellItem.storeHaveServicePayment).toString()
        lblPaidOrder.text = (cellItem.storeHaveOrderPayment!).toString()
        lblEarn.text = (cellItem.payToStore!).toString()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }


}

