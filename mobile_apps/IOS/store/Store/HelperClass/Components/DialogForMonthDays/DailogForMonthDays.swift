//
//  DailogForMonthDays.swift
//  Store
//
//  Created by Trusha on 31/03/21.
//  Copyright © 2021 Elluminati. All rights reserved.
//

import Foundation
class DialogForMonthDays: CustomDialog,UITextFieldDelegate  {
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var tblFortags: UITableView!
    @IBOutlet weak var btnApplySearch: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var viewForAlertHeight: NSLayoutConstraint!
    
    var onClickLeftButton : (() -> Void)? = nil
    var onClickApplyRecursion : ((_ type: Int, _ arrForSelectedDays: [String],  _ arrForSelectedWeeks: [String],  _ arrForSelectedMonths: [String], _ mainArrayForRecursionTags:[TagList]) -> Void)? = nil
    static let dialogForMonthDays = "DialogForMonthDays"
    
    var type : Int = 0
    let arrForDays:[String] = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
    let arrForWeeks:[String] = ["1st","2nd","3rd","4th","5th"]
    let arrForMonths:[String] = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    
    var arrForSelectedDays:[String] = []
    var arrForSelectedWeeks:[String] = []
    var arrForSelectedMonths:[String] = []
    var mainArrayForRecursionTags:[TagList] = []

    
    public static func showDialogForMonthDays
    (title:String,
     message:String,
     type : Int, arrForSelectedDays: [String], arrForSelectedWeeks: [String], arrForSelectedMonths: [String]) ->
    DialogForMonthDays
    {
//        let view = UINib(nibName: dialogForMonthDays, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DialogForMonthDays
        let view = UINib(nibName: "dailogForMonthDay", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DialogForMonthDays

        
        let frame = (APPDELEGATE.window?.frame)!
        view.frame = frame
        view.lblTitle.text = title
        
        DispatchQueue.main.async {
            APPDELEGATE.window?.addSubview(view)
            APPDELEGATE.window?.bringSubviewToFront(view)
            view.animationBottomTOTop(view.alertView)
        }
        view.type = type
        view.arrForSelectedDays = arrForSelectedDays
        view.arrForSelectedWeeks = arrForSelectedWeeks
        view.arrForSelectedMonths = arrForSelectedMonths
        
        view.showTableView(type:type)
//        view.tblFortags.register(UINib.init(nibName: "CheckListCell", bundle: nil), forCellReuseIdentifier: "cell")
        view.tblFortags.register(UINib.init(nibName: "ProductSearchCell", bundle: nil), forCellReuseIdentifier: "ProductSearchCell")

        view.setLocalization()
        return view
    }
    
    public override func layoutSubviews() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.alertView.applyTopCornerRadius()
        }
    }
    
    func setLocalization(){
        
      
        self.backgroundColor = UIColor.themeOverlayColor
        self.tblFortags.backgroundColor = UIColor.themeViewBackgroundColor
   
        
        lblTitle.textColor = UIColor.themeTextColor
        lblTitle.font = FontHelper.textMedium(size: FontHelper.large)
        
        tblFortags.reloadData()
        tblFortags.tableFooterView = UIView()
        if preferredContentSize.height <= UIScreen.main.bounds.height - 150 - 100{
            viewForAlertHeight.constant = preferredContentSize.height + 150
        }else{
            viewForAlertHeight.constant = UIScreen.main.bounds.height - 150 - 100
        }
        updateUIAccordingToTheme()
        self.layoutSubviews()
    }
    
    override func updateUIAccordingToTheme(){
        btnClose.setImage(UIImage(named: "cross")?.imageWithColor(color: .themeColor), for: .normal)
        self.tblFortags.reloadData()
    }
    
    //ActionMethods
    @IBAction func onClickBtnClose(_ sender: Any) {
        if self.onClickLeftButton != nil {
            self.onClickLeftButton!()
        }
    }
    
    @IBAction func onClickBtnApplyRecursion(_ sender: Any) {
        if self.onClickApplyRecursion != nil {
                if type == 0 {
                    arrForSelectedDays.removeAll()
                    for element in mainArrayForRecursionTags {
                        if element.isSelected {
                            arrForSelectedDays.append(element.itemName)
                        }
                    }
                    
//                    reloadTagView(tagViewForDays)
                   
                }else if type == 1 {
                    arrForSelectedWeeks.removeAll()
                    for element in mainArrayForRecursionTags {
                        if element.isSelected {
                            arrForSelectedWeeks.append(element.itemName)
                        }
                    }
                    
//                    reloadTagView(tagViewForWeeks)
                }
               else {
                    arrForSelectedMonths.removeAll()
                    for element in mainArrayForRecursionTags {
                        if element.isSelected {
                            arrForSelectedMonths.append(element.itemName)
                        }
                    }
                }
            self.onClickApplyRecursion!(type, arrForSelectedDays, arrForSelectedWeeks, arrForSelectedMonths, mainArrayForRecursionTags)
        }
    }
    
    func showTableView(type:Int) {
        mainArrayForRecursionTags.removeAll()
        if type == 0 {
            for  currentElement in arrForDays {
                let tag:TagList = TagList.init(itemName: currentElement, isSelected: arrForSelectedDays.contains(currentElement))
                mainArrayForRecursionTags.append(tag)
            }
        }else if type == 1 {
            for  currentElement in arrForWeeks {
                let tag:TagList = TagList.init(itemName: currentElement, isSelected: arrForSelectedWeeks.contains(currentElement))
                mainArrayForRecursionTags.append(tag)
            }
        }else if type == 2 {
            for  currentElement in arrForMonths {
                let tag:TagList = TagList.init(itemName: currentElement, isSelected: arrForSelectedMonths.contains(currentElement))
                mainArrayForRecursionTags.append(tag)
            }
        }
//        tblTags.reloadData()
    }
    
    
    var preferredContentSize: CGSize {
        get {
            // Force the table view to calculate its height
            self.tblFortags.layoutIfNeeded()
            return self.tblFortags.contentSize
        }
        set {}
    }
    
}
extension DialogForMonthDays:UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return UIView.init()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return mainArrayForRecursionTags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell:CheckListCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CheckListCell
//        cell.lblItemName.text = mainArrayForRecursionTags[indexPath.row].itemName.localized
//        cell.imgButtonType.isSelected = mainArrayForRecursionTags[indexPath.row].isSelected
        
        var cell:ProductSearchCell? =  tableView.dequeueReusableCell(with: ProductSearchCell.self, for: indexPath)
        if cell == nil {
            cell = ProductSearchCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cellForProductName")
        }
        cell?.lblProductName.text = mainArrayForRecursionTags[indexPath.row].itemName.localized
        cell!.imgButtonType.isSelected = mainArrayForRecursionTags[indexPath.row].isSelected
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if mainArrayForRecursionTags.count > 0 && mainArrayForRecursionTags.count >= indexPath.row{
            mainArrayForRecursionTags[indexPath.row].isSelected = !mainArrayForRecursionTags[indexPath.row].isSelected
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
