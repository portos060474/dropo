//
//  CustomCityDialog.swift
//  edelivery
//
//  Created by Elluminati on 27/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class CustomCityDialog: CustomDialog, UITableViewDelegate, UITableViewDataSource ,keyboardWasShownDelegate, keyboardWillBeHiddenDelegate {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var tblForCity: UITableView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var height:  NSLayoutConstraint!
    @IBOutlet weak var searchBarItem: UISearchBar!
    @IBOutlet weak var constraintBottomSuperView: NSLayoutConstraint!
    
    var citylist:[Cities] = [];
    var arrFilterCity:[Cities] = [];
    var isSearch = false
    var keyBoardHeight: CGFloat = 0
    
    static let  CityyDialog = "dialogForCity"
    static let  ReuseCellIdentifier = "cellForCity"
    var onCitySelected : ((_ countryID:String, _ countryName:String) -> Void)? = nil
    
    override func awakeFromNib() {
        
        lblTitle.font = FontHelper.textMedium(size: FontHelper.large)
        lblTitle.textColor = UIColor.themeTextColor
        btnClose.titleLabel?.font = FontHelper.textRegular()
        btnClose.setTitleColor(UIColor.themeTextColor, for: .normal)
        self.backgroundColor = UIColor.themeOverlayColor
        btnClose.setImage(UIImage.init(named: "close")?.imageWithColor(), for: .normal)
        btnClose.backgroundColor = .clear
        // tblForCity.separatorStyle = .none
        tblForCity.separatorColor = .themeLightTextColor
        alertView.backgroundColor = .themeAlertViewBackgroundColor
        self.alertView.updateConstraintsIfNeeded()
        self.alertView.roundCorner(corners: [.topRight , .topLeft], withRadius: 20)
        
        searchBarItem.backgroundImage = UIImage()
        searchBarItem.barTintColor = UIColor.themeAlertViewBackgroundColor
        searchBarItem.backgroundColor = UIColor.themeAlertViewBackgroundColor
        searchBarItem.tintColor = UIColor.themeAlertViewBackgroundColor
        searchBarItem.setTextColor(color: UIColor.themeTextColor)
        searchBarItem.placeholder = "TXT_SEARCH_CITY".localized
        searchBarItem?.delegate = self
        for s in searchBarItem.subviews[0].subviews {
            if s is UITextField {
                s.backgroundColor = UIColor.white
                (s as! UITextField).font = FontHelper.textRegular(size: 12)
            }
        }
    }
    
    public static func showCustomCityDialog(withDataSource:NSMutableArray = []) -> CustomCityDialog {
        let view = UINib(nibName: CityyDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomCityDialog
        view.setShadow()
        view.tblForCity.register(Cell.self as AnyClass, forCellReuseIdentifier: ReuseCellIdentifier)
        view.tblForCity.delegate = view;
        view.tblForCity.dataSource = view;
        view.lblTitle.text = "TXT_SELECT_CITY".localizedCapitalized
        view.lblTitle.font = FontHelper.textMedium(size: FontHelper.large)
        
        if let arrCity = withDataSource as? [Cities] {
            view.citylist = arrCity
        }
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame
        APPDELEGATE.window?.addSubview(view)
        APPDELEGATE.window?.bringSubviewToFront(view);
        if view.tblForCity.contentSize.height > (UIScreen.main.bounds.height - (160 + UIApplication.shared.statusBarFrame.height)){
            view.height.constant = (UIScreen.main.bounds.height - (160 + UIApplication.shared.statusBarFrame.height))
        }
        else {
            view.height.constant = view.tblForCity.contentSize.height
        }
        
        view.deregisterFromKeyboardNotifications()
        view.registerForKeyboardNotifications()
        view.delegatekeyboardWasShown = view
        view.delegatekeyboardWillBeHidden = view
        
        view.alertView.layoutIfNeeded()
        view.animationBottomTOTop(view.alertView)
        return view;
    }
    
    override func keyboardWasShown(notification: NSNotification)
    {
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        var aRect : CGRect = self.frame
        aRect.size.height -= keyboardSize!.height
        keyBoardHeight = keyboardSize!.height
        
        constraintBottomSuperView.constant = 0.0
        
        var alertFrame = self.searchBarItem.superview!.frame
        alertFrame.origin.y = keyboardSize!.height

        UIView.animate(withDuration: 1.0) {
            self.constraintBottomSuperView.constant = -keyboardSize!.height
            DispatchQueue.main.async {
                let tempHeight = self.frame.size.height - keyboardSize!.height - 160 - UIApplication.shared.statusBarFrame.height
                if self.tblForCity.contentSize.height > (tempHeight) {
                    self.height.constant = tempHeight
                } else {
                    self.height.constant = self.tblForCity.contentSize.height
                }
            }
        }
    }

    override func keyboardWillBeHidden(notification: NSNotification)
    {
        keyBoardHeight = 0
        //Once keyboard disappears, restore original positions
        UIView.animate(withDuration: 1.0) {
            self.constraintBottomSuperView.constant = 0.0
        }
        self.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city:Cities = {
            if isSearch {
                return arrFilterCity[indexPath.row]
            }
            return citylist[indexPath.row]
        }()
        
        if self.onCitySelected != nil {
            self.onCitySelected!(city._id!,city.city_name!)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            return arrFilterCity.count
        }
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
        let city:Cities = {
            if isSearch {
                return arrFilterCity[indexPath.row]
            }
            return citylist[indexPath.row]
        }()
        cell?.textLabel?.text =  city.city_name
        cell?.textLabel?.font = FontHelper.textRegular()
        cell?.selectionStyle = .none
        return cell!
    }
    @IBAction func onClickBtnClose(_ sender: Any) {
        self.animationForHideAView(alertView) {
            self.removeFromSuperview();
        }
    }
}

extension CustomCityDialog: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchbarSearchText()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchbarSearchText()
        searchBarItem.endEditing(true)
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBarItem.endEditing(true)
    }
    
    func searchbarSearchText() {
        arrFilterCity.removeAll()
        let searchText = searchBarItem.text ?? ""
        if searchText.isEmpty() {
            isSearch = false
            self.tblForCity.reloadData()
        }
        else
        {
            isSearch = true
            arrFilterCity = citylist.filter({ (itemData) -> Bool in
                if let a = itemData.city_name?.lowercased().contains(searchText.lowercased()) {
                    return a
                }
                return false
            })
            self.tblForCity.reloadData()
        }
        
        DispatchQueue.main.async {
            let tempHeight = self.frame.size.height - self.keyBoardHeight - 160 - UIApplication.shared.statusBarFrame.height
            if self.tblForCity.contentSize.height > (tempHeight) {
                self.height.constant = tempHeight
            } else {
                self.height.constant = self.tblForCity.contentSize.height
            }
        }
    }
}

class Cell : CustomTableCell {
}

