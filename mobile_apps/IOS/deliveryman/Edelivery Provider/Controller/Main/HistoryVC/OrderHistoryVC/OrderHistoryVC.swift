
//
//  OrderHistoryVC.swift
//  Edelivery Provider
//
//  Created by Elluminati iMac on 25/04/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import UIKit

class OrderHistoryVC: BaseVC, UITableViewDelegate, UITableViewDataSource,RightDelegate{

    //MARK: - Outlets
    @IBOutlet weak var imgEmpty: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblEmptyMsg: UILabel!
    var arrForSection = NSMutableArray()
    var arrForHistory = NSMutableArray()
    var arrForCreateAt = NSMutableArray()
    var sectionDate = Array<Any>()
    var strFromDate = ""
    var strToDate = ""

    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        lblEmptyMsg.isHidden = true
        self.delegateRight = self
        
        self.setLocalization()
        wsGetHistory()
        super.hideBackButtonTitle()
        setMenuButton()
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        super.setRightBarItem(isNative: false)
        super.setRightBarItemImage(image: UIImage.init(named: "filterIcon")!)
        self.hideBackButtonTitle()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayout()
    }

    override func updateUIAccordingToTheme() {
        setMenuButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationTitle(title: "TXT_HISTORY".localized)
    }

    //MARK: - Set localized layout
    func setLocalization() {
        view.backgroundColor = UIColor.themeViewBackgroundColor;
        tableView.tableFooterView = UIView()
        updateUI(isUpdate: false)
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        lblEmptyMsg.textColor = UIColor.themeTextColor
        lblEmptyMsg.font = FontHelper.textRegular()
        lblEmptyMsg.text = "TXT_HISTORY_LIST_EMPTY".localized
    }

    func setupLayout() {
        tableView.tableFooterView = UIView()
    }

    //MARK: - Tableview Delegate
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HistoryCell
        let dict = ((arrForSection .object(at: indexPath.section)) as! NSMutableArray).object(at: indexPath.row) as! Order_list
        cell.setHistoryData(dictData: dict )
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = tableView.dequeueReusableCell(withIdentifier: "section")! as! historySectionCell
        let dict = ((arrForSection .object(at: section)) as! NSMutableArray).object(at: 0) as! Order_list
        sectionHeader.setData(title: Utility.relativeDateStringForDate(strDate: Utility.stringToString(strDate: dict.completed_at!, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_FORMAT)) as String)
        return sectionHeader
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let dict = ((arrForSection .object(at: indexPath.section)) as! NSMutableArray).object(at: indexPath.row) as! Order_list
        if dict.order_status != 25 {
            Utility.showToast(message: "MSG_ORDER_CANCELED".localized);
        } else {
            self.performSegue(withIdentifier:SEGUE.HISTORY_TO_DETAIL, sender: dict._id!)
        }
    }

    //MARK: - Create for section
    func createSection() {
        arrForSection.removeAllObjects()
        let arrtemp = NSMutableArray()
        arrtemp.addObjects(from: (self.arrForHistory as NSArray) as! [Any])
        for i in 0 ..< arrtemp.count {
            let dict:Order_list = arrtemp .object(at: i) as! Order_list
            let strDate:String = dict.completed_at!
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
                let dict:Order_list = arrtemp .object(at: i) as! Order_list
                let strDate:String = dict.completed_at!
                let arr = strDate .components(separatedBy:"T")
                let str:String = (arr as NSArray) .object(at: 0) as! String
                if(str == strTempDate) {
                    arr1.add(dict)
                }
            }
            arrForSection.add(arr1)
        }
    }

    //MARK: - Button action method
    func onClickRightButton() {
        let filter = DailogForFilter.showCustomFilterDialog()
        filter.onClickApplyButton = { (From , To) in
            self.strFromDate = From
            self.strToDate = To
            self.wsGetHistory(startDate: self.strFromDate, endDate: self.strToDate);
            filter.removeFromSuperview()
        }
        filter.onClickResetButton = {
            self.strFromDate = ""
            self.strToDate = ""
            self.wsGetHistory(startDate: self.strFromDate, endDate: self.strToDate);
            filter.removeFromSuperview()
        }
    }

    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let obj = segue.destination as! HistoryDetailVC
        obj.strOrderID = sender as! String
    }

    //MARK: - Memory Mngmnt
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: - User Define Function
    func updateUI(isUpdate:Bool = false) {
        imgEmpty.isHidden = isUpdate
        tableView.isHidden = !isUpdate
        strToDate = "";
        strFromDate = "";
        self.setRightBarItemImage(image: UIImage.init(named: "filterIcon")!)
    }

    //MARK: - WS Method
    func wsGetHistory(startDate: String = "",endDate: String = "") {
        Utility.showLoading()
        let dictParam:[String:String] =
            [PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken(),
             PARAMS.PROVIDER_ID : preferenceHelper.getUserId(),
             PARAMS.START_DATE : startDate,
             PARAMS.END_DATE : endDate]

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
                } else {
                    self.updateUI(isUpdate: false)
                }
            })
        }
    }
}
