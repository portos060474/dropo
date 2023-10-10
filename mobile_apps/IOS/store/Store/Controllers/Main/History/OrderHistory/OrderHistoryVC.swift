
//
//  HistoryVC.swift
//  // Edelivery Store
//
//  Created by Elluminati iMac on 25/04/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit

class OrderHistoryVC: BaseVC,RightDelegate {
    
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var imgEmpty: UIImageView!
    @IBOutlet weak var stackForDate: UIStackView!
    @IBOutlet weak var viewForFrom: UIView!
    @IBOutlet weak var viewForTo: UIView!
    @IBOutlet weak var btnFrom: UIButton!
    @IBOutlet weak var btnTo: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewForFilter: UIView!
    
    var arrForSection = NSMutableArray()
    var arrForHistory = NSMutableArray()
    var arrForCreateAt = NSMutableArray()
    var sectionDate = Array<Any>()
    var strFromDate = ""
    var strToDate = ""
    
    //MARK: View life cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setLocalization()
        wsGetHistory()
        delegateRight = self
        self.setRightBarItem(isNative: false)
        self.setRightBarItemImage(image: UIImage.init(named: "filterIcon")!.imageWithColor(color: .themeColor)!)
        self.setNavigationTitle(title: "TXT_HISTORY".localizedCapitalized)
        self.hideBackButtonTitle()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayout()

    }
    //MARK: Set localized layout
    func setLocalization() {
        view.backgroundColor = UIColor.themeViewBackgroundColor;
        tableView.tableFooterView = UIView()
        updateUI(isUpdate: false)
        //LOCALIZED
        self.title = "TXT_HISTORY".localized
        btnFrom.setTitle("TXT_FROM".localized, for: UIControl.State.normal)
        btnTo.setTitle("TXT_TO".localized, for: UIControl.State.normal)
        btnApply.setTitle("TXT_APPLY".localized, for: UIControl.State.normal)
        btnReset.setTitle("TXT_RESET".localized, for: UIControl.State.normal)
        
        //COLORS
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        viewForFilter.backgroundColor = UIColor.themeAlertViewBackgroundColor
        viewForTo.backgroundColor = UIColor.themeAlertViewBackgroundColor
        viewForFrom.backgroundColor = UIColor.themeAlertViewBackgroundColor
        btnFrom.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        btnTo.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        
        btnFrom.backgroundColor = UIColor.themeLightTextColor
        btnTo.backgroundColor = UIColor.themeLightTextColor
        
        btnApply.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
        btnReset.setTitleColor(UIColor.themeTextColor, for: UIControl.State.normal)
        
        /*Set Font*/
        btnFrom.titleLabel?.font = FontHelper.textRegular()
        btnTo.titleLabel?.font = FontHelper.textRegular()
        btnApply.titleLabel?.font = FontHelper.textRegular()
        btnReset.titleLabel?.font = FontHelper.textRegular()
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
   
    }
    func setupLayout() {
        btnFrom.applyRoundedCornersWithHeight(4)
        btnTo.applyRoundedCornersWithHeight(4)
        tableView.tableFooterView = UIView()
        viewForFilter.setShadow(shadowColor: UIColor.gray.cgColor, shadowOffset:CGSize.init(width: 0.0, height: 3.0), shadowOpacity: 0.8, shadowRadius: 3.0)
        
    }
    //MARK: Create for section
    func createSection() {
        arrForSection.removeAllObjects()
        let arrtemp = NSMutableArray()
        arrtemp.addObjects(from: (self.arrForHistory as NSArray) as! [Any])
        for i in 0 ..< arrtemp.count {
            let dict:OrderList = arrtemp .object(at: i) as! OrderList
            let strDate:String = dict.createdAt
            let arr = strDate .components(separatedBy:"T")
            let str:String = (arr as NSArray) .object(at: 0) as! String
            
            if(!arrForCreateAt .contains(str)) {
                arrForCreateAt.add(str)
            }
        }
        for j in 0 ..< arrForCreateAt.count {
            let strTempDate:String = arrForCreateAt .object(at: j) as! String
            let arr1 = NSMutableArray()
            
            for i in 0 ..< arrtemp.count {
                let dict:OrderList = arrtemp .object(at: i) as! OrderList
                let strDate:String = dict.createdAt
                let arr = strDate .components(separatedBy:"T")
                let str:String = (arr as NSArray) .object(at: 0) as! String
                if(str == strTempDate) {
                    arr1.add(dict)
                }
            }
            arrForSection.add(arr1)
        }
    }
    //MARK: Button action method
    @IBAction func onClickFromTo(_ sender: UIButton) {
        if sender.tag == 10 {
            let datePickerDialog:CustomDatePickerDialog = CustomDatePickerDialog.showCustomDatePickerDialog(title: "TXT_SELECT_FROM_DATE".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_OK".localized)
            datePickerDialog.setMaxDate(maxdate: Date())
            if !strToDate.isEmpty() {
                let maxDate = Utility.stringToDate(strDate: strToDate, withFormat: DATE_CONSTANT.DATE_MM_DD_YYYY)
                datePickerDialog.setMaxDate(maxdate: maxDate)
                
            }
            datePickerDialog.onClickLeftButton = { [unowned datePickerDialog] in
                    datePickerDialog.removeFromSuperview()
            }
            
            datePickerDialog.onClickRightButton = { [unowned datePickerDialog, unowned self]  (selectedDate:Date) in
                    self.strFromDate = Utility.dateToString(date: selectedDate, withFormat: DATE_CONSTANT.DATE_MM_DD_YYYY)
                    self.btnFrom.setTitle(String(format: "%@",self.strFromDate), for: UIControl.State.normal)
                    self.strToDate = self.strFromDate
                    datePickerDialog.removeFromSuperview()
            }
        }else {
            if btnFrom.titleLabel?.text == "TXT_FROM".localized
                 {
                let alertController = UIAlertController(title: "TXT_WARNING".localized, message: "MSG_INVALID_DATE_WARNING".localized, preferredStyle: .alert)
                
                let yesAction = UIAlertAction(title: "TXT_OK".localized, style: .default, handler: { _ in
                })
                alertController.addAction(yesAction)
                present(alertController, animated: true, completion: nil)
            }else {
                let datePickerDialog:CustomDatePickerDialog = CustomDatePickerDialog.showCustomDatePickerDialog(title: "TXT_SELECT_TO_DATE".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_OK".localized)
                let minidate = Utility.stringToDate(strDate: strFromDate, withFormat: DATE_CONSTANT.DATE_MM_DD_YYYY)
                
                datePickerDialog.setMaxDate(maxdate: Date())
                datePickerDialog.setMinDate(mindate: minidate)
                datePickerDialog.onClickLeftButton =
                    { [unowned datePickerDialog] in
                        datePickerDialog.removeFromSuperview()
                }
                
                datePickerDialog.onClickRightButton =
                    { [unowned datePickerDialog, unowned self]  (selectedDate:Date) in
                        
                        self.strToDate = Utility.dateToString(date: selectedDate, withFormat: DATE_CONSTANT.DATE_MM_DD_YYYY)
                        self.btnTo.setTitle(String(format: "%@",self.strToDate), for: UIControl.State.normal)
                        datePickerDialog.removeFromSuperview()
                }
                
            }
        }
    }
    @IBAction func onClickBtnResetFilter(_ sender: UIButton) {
        self.onClickRightButton()
        strToDate = "";
        strFromDate = "";
        
        self.wsGetHistory(startDate: strFromDate, endDate: strToDate);
    }
    @IBAction func onClickBtnApplyFilter(_ sender: UIButton) {
        if (strFromDate.isEmpty() || strToDate.isEmpty()) {
            Utility.showToast(message: "MSG_PLEASE_SELECT_DATE_FIRST".localized);
            
        }else {
            self.onClickRightButton()
            self.wsGetHistory(startDate: strFromDate, endDate: strToDate);
        }
    }
    func onClickRightButton() {
       /* if viewForFilter.isHidden {
            viewForFilter.isHidden = false
            btnFrom.setTitle("TXT_FROM".localized, for: UIControl.State.normal)
            btnTo.setTitle("TXT_TO".localized, for: UIControl.State.normal)
            self.setRightBarItemImage(image: UIImage.init(named: "cancelBlackIcon")!.imageWithColor(color: .themeIconTintColor)!)
            
        }else {
            viewForFilter.isHidden = true
            btnFrom.setTitle("TXT_FROM".localized, for: UIControl.State.normal)
            btnTo.setTitle("TXT_TO".localized, for: UIControl.State.normal)
            self.setRightBarItemImage(image: UIImage.init(named: "filterIcon")!.imageWithColor(color: .themeColor)!)
        }*/
        
        let dialogueFilterHistory = DailogForFilter.showCustomFilterDialog()
        dialogueFilterHistory.onClickApplyButton = {
            (strFromDate,strToDate) in
            dialogueFilterHistory.removeFromSuperview()
            if (strFromDate.isEmpty() || strToDate.isEmpty()) {
                Utility.showToast(message: "MSG_PLEASE_SELECT_DATE_FIRST".localized)
                
            }else {
                self.wsGetHistory(startDate: strFromDate, endDate: strToDate)
            }
        }
        
        dialogueFilterHistory.onClickResetButton = {
            dialogueFilterHistory.removeFromSuperview()
            self.strToDate = ""
            self.strFromDate = ""
            self.wsGetHistory(startDate: self.strFromDate, endDate: self.strToDate)
        }
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let obj = segue.destination as! HistoryDetailVC
        obj.strOrderID = sender as! String
    }
    
    //MARK: Memory Mngmnt
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: User Define Function
    
    func updateUI(isUpdate:Bool = false) {
        imgEmpty.isHidden = isUpdate
        tableView.isHidden = !isUpdate
        viewForFilter.isHidden = true
        strToDate = "";
        strFromDate = "";
        btnFrom.setTitle("TXT_FROM".localized, for: UIControl.State.normal)
        btnTo.setTitle("TXT_TO".localized, for: UIControl.State.normal)
        self.setRightBarItemImage(image: UIImage.init(named: "filterIcon")!.imageWithColor(color: .themeColor)!)
    }
    //MARK: wsGetHistory
    func wsGetHistory(startDate: String = "",endDate: String = "") {
        Utility.showLoading()
        let dictParam:[String:String] =
            [PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken(),
             PARAMS.STORE_ID : preferenceHelper.getUserId(),
             PARAMS.START_DATE : startDate,
             PARAMS.END_DATE : endDate]
        print(dictParam)
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_GET_HISTORY, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            self.arrForCreateAt .removeAllObjects()
            self.arrForHistory .removeAllObjects()
            Utility.hideLoading()
            Parser.parseOrderHistory(response, toArray: self.arrForHistory, completion: { result in
                if result {
                    self.createSection()
                    self.tableView.reloadData()
                    self.updateUI(isUpdate: true)
                }
                else {
                    self.updateUI(isUpdate: false)
                    
                }
            })
    
        }
    }
  
}
extension OrderHistoryVC : UITableViewDataSource,UITableViewDelegate {
    //MARK: Tableview Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.arrForSection.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (((arrForSection .object(at: section)) as! NSMutableArray).count)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! OrderHistoryCell
        
        let dict = ((arrForSection .object(at: indexPath.section)) as! NSMutableArray).object(at: indexPath.row) as! OrderList
        cell.setHistoryData(dictData: dict )
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = tableView.dequeueReusableCell(withIdentifier: "section")! as! OrderHistorySectionCell
        
        let dict = ((arrForSection .object(at: section)) as! NSMutableArray).object(at: 0) as! OrderList
        
        sectionHeader.setData(title: Utility.relativeDateStringForDate(strDate: Utility.stringToString(strDate: dict.createdAt, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_FORMAT)) as String)
        return sectionHeader
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let dict = ((arrForSection .object(at: indexPath.section)) as! NSMutableArray).object(at: indexPath.row) as! OrderList
         self.performSegue(withIdentifier:SEGUE.HISTORY_DETAIL, sender: dict.id!)
       
        
    }

}
