//
//  CustomCityDialog.swift
//  edelivery
//
//  Created by Elluminati on 27/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class CustomCityDialog: CustomDialog, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var tblForCity: UITableView!
    var citylist:NSMutableArray = []
    
    @IBOutlet weak var heightForCityTable: NSLayoutConstraint!
    static let  CityyDialog = "dialogForCity"
    static let  ReuseCellIdentifier = "cellForCity"
    var onCitySelected : ((_ countryID:String, _ countryName:String) -> Void)? = nil
    override func awakeFromNib() {
        lblTitle.textColor = UIColor.themeTextColor
        lblTitle.font = FontHelper.textLarge()
        btnClose.titleLabel?.font = FontHelper.textRegular()
    }
    public static func showCustomCityDialog(withDataSource:NSMutableArray = []) -> CustomCityDialog {
    let view = UINib(nibName: CityyDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomCityDialog
    view.setShadow()
    view.tblForCity.register(Cell.self as AnyClass, forCellReuseIdentifier: ReuseCellIdentifier)
    view.tblForCity.delegate = view
    view.tblForCity.dataSource = view
    view.lblTitle.text = "TXT_SELECT_CITY".localizedUppercase
    view.citylist = withDataSource
    let frame = (APPDELEGATE.window?.frame)!
    view.frame = frame
        DispatchQueue.main.async {

    APPDELEGATE.window?.addSubview(view)
    APPDELEGATE.window?.bringSubviewToFront(view)
        }
    return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city:Cities = citylist[indexPath.row] as! Cities
        
        if self.onCitySelected != nil {
            self.onCitySelected!(city._id!,city.city_name!)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if citylist.count > 0 {
    return citylist.count
    }
    return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:Cell? = tableView.dequeueReusableCell(withIdentifier: CustomCityDialog.ReuseCellIdentifier, for: indexPath) as? Cell
        if cell == nil {
            
            cell = Cell(style: UITableViewCell.CellStyle.default, reuseIdentifier: CustomCityDialog.ReuseCellIdentifier)
        }
    
        let city:Cities = citylist[indexPath.row] as! Cities
        cell?.textLabel?.text =  city.city_name
        return cell!
    }
    
    @IBAction func onClickBtnClose(_ sender: Any) {
    self.removeFromSuperview()
    }
    
}

class Cell : CustomTableCell {
    
}

