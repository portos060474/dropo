
//
//  DailyEarningVC.swift
//  // Edelivery Store
//
//  Created by Elluminati iMac on 25/04/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit

class WeeklyEarningVC: BaseVC {
    
    
    
    //Outlets For Earning
    @IBOutlet weak var btnDate: UIButton!
    @IBOutlet weak var scrMonthlyEarning: UIScrollView!
    @IBOutlet weak var mainViewForEarning: UIView!
    @IBOutlet weak var lblTotalProviderEarning: UILabel!
    @IBOutlet weak var tblEarning: UITableView!
    @IBOutlet weak var lblPaymentToProvider: UILabel!
    @IBOutlet weak var lblProviderEarning: UILabel!
    @IBOutlet weak var collectionViewForAnalytic: UICollectionView!
    @IBOutlet weak var imgEmpty: UIImageView!
    var arrForEarning = NSMutableArray()
    var arrForAnalytic = NSMutableArray()
    var arrForOrders = NSMutableArray()
    var strStartDateOfEarning:String = "";
    var strEndDateOfEarning:String = "";
    
    @IBOutlet weak var heightForTblEarning: NSLayoutConstraint!
    @IBOutlet weak var heightCollectionAnalytic: NSLayoutConstraint!
    @IBOutlet weak var heightForTblOrder: NSLayoutConstraint!
    var chart: SimpleBarChart = SimpleBarChart.init();
    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        strEndDateOfEarning = Utility.dateToString(date: Date(), withFormat: DATE_CONSTANT.DATE_MM_DD_YYYY)
        
        strEndDateOfEarning = Utility.dateToString(date: Date(), withFormat: DATE_CONSTANT.DATE_MM_DD_YYYY)
        
        
        self.setLocalization()
        let date1 = getDate(myDate: Date(),day: 1)
        let date2 = getDate(myDate: Date(),day: 7)
        
        
        strStartDateOfEarning = Utility.dateToString(date: date1 , withFormat: DATE_CONSTANT.DATE_MM_DD_YYYY)
        
        strEndDateOfEarning =  Utility.dateToString(date: date2, withFormat: DATE_CONSTANT.DATE_MM_DD_YYYY)
        setDateTitle()
        self.tblEarning.estimatedRowHeight = 40
        self.tblEarning.rowHeight = UITableView.automaticDimension
        setupChart()
        
        wsGetWeeklyEarning()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayout()
        
    }
    //MARK: Set localized layout
    func setLocalization() {
        updateUI(isUpdate: false)
        //LOCALIZED
        self.title = "TXT_EARNING".localized
        lblPaymentToProvider.text = "TXT_PAY_TO_STORE".localizedUppercase
        
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        self.tblEarning.backgroundColor = UIColor.themeViewBackgroundColor
        self.collectionViewForAnalytic.backgroundColor = UIColor.themeViewBackgroundColor
        scrMonthlyEarning.backgroundColor = UIColor.themeViewBackgroundColor
        
        mainViewForEarning.backgroundColor = UIColor.themeViewBackgroundColor
        
        
        
        
        btnDate.setTitleColor(UIColor.themeTextColor, for: .normal)
        
        
        lblProviderEarning.textColor = UIColor.themeColor
        lblPaymentToProvider.textColor = UIColor.themeColor
        lblTotalProviderEarning.textColor = UIColor.themeColor
        
        /*Set Font*/
        btnDate.titleLabel?.font = FontHelper.textRegular(size: 20)
        lblTotalProviderEarning.font = FontHelper.textMedium(size:30)
        lblPaymentToProvider.font = FontHelper.textMedium()
        lblProviderEarning.font = FontHelper.textMedium()
    }
    
    override func viewWillLayoutSubviews() {
        self.collectionViewForAnalytic.reloadData()
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
        if tblEarning != nil{
            heightForTblEarning.constant = tblEarning.contentSize.height
            heightCollectionAnalytic.constant = 300
            imgEmpty.isHidden = isUpdate
            mainViewForEarning.isHidden = !isUpdate
            
            self.view.layoutIfNeeded()
            self.mainViewForEarning.layoutIfNeeded()
        }
    }
    
    override func updateUIAccordingToTheme() {
        if #available(iOS 13.0, *) {
            chart.chartBorderColor = .themeTextColor
            chart.reloadData()
        }
    }
    func setupChart() {
        scrMonthlyEarning.addSubview(chart);
        chart.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            
            chart.topAnchor.constraint(equalTo: lblTotalProviderEarning.bottomAnchor, constant: 10),
            chart.widthAnchor.constraint(equalTo: scrMonthlyEarning.widthAnchor, constant: -20),
            chart.centerXAnchor.constraint(equalTo: scrMonthlyEarning.centerXAnchor),
            chart.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        
        
        
        chart.delegate                    = self;
        chart.dataSource                = self;
        chart.barShadowOffset            = CGSize.init(width: 2.0, height: 1.0)
        chart.animationDuration        = 1.0;
        chart.barShadowColor            = UIColor.gray;
        chart.barShadowAlpha            = 0.5;
        chart.barShadowRadius            = 1.0;
        chart.barWidth =  20.0 ;
        chart.xLabelType                = SimpleBarChartXLabelTypeHorizontal;
        chart.incrementValue            = 10;
        chart.barTextType                = SimpleBarChartBarTextTypeRoof;
        chart.barTextColor                = UIColor.black
        chart.gridColor                = UIColor.clear;
        chart.xLabelFont = UIFont.systemFont(ofSize: 8.0)
        chart.yLabelFont = UIFont.systemFont(ofSize: 8.0)
        chart.barTextFont = UIFont.systemFont(ofSize: 8.0)
        if #available(iOS 13.0, *) {
            chart.yLabelColor = .themeTextColor
            chart.xLabelColor = .themeTextColor
            chart.chartBorderColor = .themeTextColor

        }
        
    }
    /*   func setupChart() {
     scrMonthlyEarning.addSubview(chart);
     chart.translatesAutoresizingMaskIntoConstraints = false
     
     
     NSLayoutConstraint.activate([
     
     chart.topAnchor.constraint(equalTo: lblTotalProviderEarning.bottomAnchor, constant: 10),
     chart.widthAnchor.constraint(equalTo: scrMonthlyEarning.widthAnchor, constant: -20),
     chart.centerXAnchor.constraint(equalTo: scrMonthlyEarning.centerXAnchor),
     chart.heightAnchor.constraint(equalToConstant: 120)
     ])
     chart.delegate                    = self;
     chart.dataSource                = self;
     chart.barShadowOffset            = CGSize.init(width: 2.0, height: 1.0)
     chart.animationDuration        = 1.0;
     chart.barShadowColor            = UIColor.themeLightTextColor;
     chart.barShadowAlpha            = 0.5;
     chart.barShadowRadius            = 1.0;
     chart.barWidth = 20 ;
     chart.xLabelType                = SimpleBarChartXLabelTypeHorizontal;
     chart.incrementValue            = 10;
     chart.barTextType                = SimpleBarChartBarTextTypeRoof;
     chart.barTextColor                = UIColor.themeTextColor
     chart.gridColor                = UIColor.clear;
     chart.xLabelFont = UIFont.systemFont(ofSize: 8.0)
     chart.yLabelFont = UIFont.systemFont(ofSize: 8.0)
     chart.barTextFont = UIFont.systemFont(ofSize: 8.0)
     chart.yLabelColor = .themeTextColor
     chart.xLabelColor = .themeTextColor
     chart.chartBorderColor = .themeTextColor
     }*/
    //MARK: wsGetEarning
    func wsGetWeeklyEarning() {
        Utility.showLoading()
        
        
        let dictParam:[String:String] =
            [PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken(),
             PARAMS.STORE_ID : preferenceHelper.getUserId(),
             PARAMS.START_DATE : strStartDateOfEarning,
             PARAMS.END_DATE : strEndDateOfEarning
            ]
        
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_GET_WEEKLY_EARNING, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            
            
            Parser.parseEarning(response, arrayListForEarning: self.arrForEarning, arrayListForAnalytic: self.arrForAnalytic, arrayListForOrders: self.arrForOrders,isWeeklyEarning: true, completetion: { (result) in
                if result {
                    
                    var maxValue:Double = 0.0;
                    for i in 0..<self.arrForOrders.count
                    {
                        let currentValue:Double = (self.arrForOrders.object(at: i) as! Analytic).value?.doubleValue ?? 0.0
                        if(currentValue > maxValue)
                        {
                            maxValue = currentValue;
                        }
                    }
                    
                    let extraDigit:Int = lround(maxValue/5) % 100;
                    
                    maxValue = Double((lround(maxValue/5) - extraDigit) + 100);
                    self.chart.incrementValue = CGFloat(maxValue)
                    self.chart.reloadData()
                    
                    let dailyEarningResponse:DailyEarningResponse = DailyEarningResponse.init(fromDictionary: response)
                    
                    self.lblProviderEarning.text = (dailyEarningResponse.orderTotal.payToStore!).toString()
                    self.lblTotalProviderEarning.text = (dailyEarningResponse.orderTotal.totalEarning!).toCurrencyString()
                    
                    self.collectionViewForAnalytic.reloadData()
                    self.tblEarning.reloadData()
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
        let datePickerDialog:CustomPicker = CustomPicker.showCustomPicker(title: "TXT_SELECT_WEEK".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_SELECT".localized)
        datePickerDialog.onClickLeftButton = { [unowned datePickerDialog] in
            datePickerDialog.removeFromSuperview()
        }
        
        datePickerDialog.onClickRightButton = {[unowned datePickerDialog, unowned self]
            (selectedDate:(Date,Date)) in
            self.strStartDateOfEarning = Utility.dateToString(date: selectedDate.0, withFormat: DATE_CONSTANT.DATE_MM_DD_YYYY)
            self.strEndDateOfEarning = Utility.dateToString(date: selectedDate.1, withFormat: DATE_CONSTANT.DATE_MM_DD_YYYY)
            self.setDateTitle()
            self.wsGetWeeklyEarning()
            datePickerDialog.removeFromSuperview()
        }
        
        
    }
}

extension WeeklyEarningVC: SimpleBarChartDelegate,SimpleBarChartDataSource {
    func numberOfBars(in barChart: SimpleBarChart!) -> UInt {
        return UInt(arrForOrders.count)
    }
    
    func barChart(_ barChart: SimpleBarChart!, valueForBarAt index: UInt) -> CGFloat {
        return CGFloat((self.arrForOrders.object(at: Int(index)) as! Analytic).value?.doubleValue ?? 0.0)
    }
    
    func barChart(_ barChart: SimpleBarChart!, clickBarAt index: UInt) {
        
        let date = (arrForOrders .object(at: Int(index)) as! Analytic).title
        let currentDate = Date()
        let selectedDate:Date = Utility.stringToDate(strDate: date!, withFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB)
        if selectedDate > currentDate {
            Utility.showToast(message: "MSG_NO_EARNING_FOR_FUTURE_DATE".localized)
        }else
        {
            let parent:EarningVC = ((self.parent) as! EarningVC)
            parent.tabBar(parent.tabBar, didSelect: parent.tabBar.items![0])
            
            parent.dailyVC?.strDateOfEarning = Utility.stringToString(strDate: date!, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_MM_DD_YYYY)
            
            parent.dailyVC?.btnDate.setTitle(Utility.convertDateFormate(date:Utility.stringToDate(strDate: date!, withFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB)), for: .normal)
            parent.dailyVC?.wsGetDailyEarning();
        }
    }
    func barChart(_ barChart: SimpleBarChart!, textForBarAt index: UInt) -> String! {
        return  (self.arrForOrders.object(at: Int(index)) as! Analytic).value ?? ""
    }
    func barChart(_ barChart: SimpleBarChart!, colorForBarAt index: UInt) -> UIColor! {
        return UIColor.themeColor
    }
    func barChart(_ barChart: SimpleBarChart!, xLabelForBarAt index: UInt) -> String! {
        let strDate = (self.arrForOrders.object(at: Int(index)) as! Analytic).title ?? ""
        let xLabelDate:String =  Utility.stringToString(strDate: strDate, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: "dd MMM");
        return xLabelDate
    }
    
}

extension WeeklyEarningVC: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
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

extension WeeklyEarningVC:UITableViewDelegate,UITableViewDataSource {
    //MARK: Tableview Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrForEarning.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (((arrForEarning.object(at: section)) as! [Earning]).count)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EarningCell
        
        let earning:Earning = ((arrForEarning .object(at: indexPath.section)) as! [Earning])[indexPath.row]
        cell.setCellData(cellItem:earning)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionHeader = tableView.dequeueReusableCell(withIdentifier: "section")! as! EarningSectionCell
        
        sectionHeader.setData(title: ((arrForEarning.object(at: section) as! [Earning])[0].sectionTitle!))
        return sectionHeader
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK: - User Define Method
    //    func getDate(myDate: Date, day:Int) -> Date {.
    //        let cal = Calendar.current.
    //        var comps = cal.dateComponents([.weekOfYear, .yearForWeekOfYear], from: myDate).
    //        comps.weekday = day.
    //        let dayInWeek = cal.date(from: comps)!.
    //        return  dayInWeek.
    //    }
    
    func getDate(myDate: Date, day:Int) -> Date {
            let cal = Calendar(identifier: .gregorian)
            var comps = cal.dateComponents([.weekOfYear, .yearForWeekOfYear], from: myDate)
            comps.weekday = day
            let dayInWeek = cal.date(from: comps)!
            return  dayInWeek
        }
    func setDateTitle() {
        let title:String =
            Utility.stringToString(strDate: strStartDateOfEarning, fromFormat: DATE_CONSTANT.DATE_MM_DD_YYYY, toFormat: DATE_CONSTANT.DD_MMM_YY)
            +
            " - "
            +
            Utility.stringToString(strDate: strEndDateOfEarning, fromFormat: DATE_CONSTANT.DATE_MM_DD_YYYY, toFormat: DATE_CONSTANT.DD_MMM_YY)
        
        btnDate.setTitle(title, for: .normal)
        
        
    }
    
}
class WeeklyEarningCell: CustomCell {
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblEarning: UILabel!
    override func awakeFromNib() {
        lblDate.font = FontHelper.textSmall()
        lblEarning.font = FontHelper.textSmall()
        lblDate.textColor = UIColor.themeTextColor
        lblEarning.textColor = UIColor.themeTextColor
        
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
    }
    func setCellData(date:String, total:String) {
        
        lblDate.text = Utility.stringToString(strDate: date, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.WEEK_FORMAT)
        lblEarning.text = total
    }
}

