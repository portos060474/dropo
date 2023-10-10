//
//  CustomCountryDialog.swift
//  edelivery
//
//  Created by Elluminati on 24/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class CustomCountryDialog: CustomDialog, UITableViewDelegate, UITableViewDataSource,keyboardWasShownDelegate, keyboardWillBeHiddenDelegate {
    struct Identifiers {
        static let  CountryDialog = "dialogForCountry"
        static let  CellForCountry = "CustomCountryCell"
        static let  reuseCellIdentifier = "cellForCountry"
    }

    //MARK: - Outlets
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableForCountry: UITableView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var height:  NSLayoutConstraint!
    @IBOutlet weak var searchBarItem: UISearchBar!
    @IBOutlet weak var constraintBottomSuperView: NSLayoutConstraint!

    //MARK: - Variables
    var coutrylist:[Countries] = [];
    var arrFilterCountry:[Countries] = [];
    var onCountrySelected : ((_ country:Countries) -> Void)? = nil
    var isSearch = false
    var keyBoardHeight: CGFloat = 0

    override func awakeFromNib() {
        lblTitle.font = FontHelper.textMedium(size: FontHelper.large)
        lblTitle.textColor = UIColor.themeTextColor
        btnClose.titleLabel?.font = FontHelper.textRegular()
        btnClose.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnClose.setImage(UIImage.init(named: "close")?.imageWithColor(), for: .normal)
        btnClose.backgroundColor = .clear
        self.backgroundColor = UIColor.themeOverlayColor
        //tableForCountry.separatorStyle = .none
        tableForCountry.separatorColor = .themeLightTextColor
        alertView.backgroundColor = .themeAlertViewBackgroundColor
        lblTitle.text = "TXT_SELECT_COUNTRY".localizedCapitalized
        self.alertView.updateConstraintsIfNeeded()
        self.alertView.roundCorner(corners: [.topRight , .topLeft], withRadius: 20)
        
        searchBarItem.backgroundImage = UIImage()
        searchBarItem.barTintColor = UIColor.themeAlertViewBackgroundColor
        searchBarItem.backgroundColor = UIColor.themeAlertViewBackgroundColor
        searchBarItem.tintColor = UIColor.themeAlertViewBackgroundColor
        searchBarItem.setTextColor(color: UIColor.themeTextColor)
        searchBarItem.placeholder = "TXT_SEARCH_COUNTRY".localized
        searchBarItem?.delegate = self
        for s in searchBarItem.subviews[0].subviews {
            if s is UITextField {
               s.backgroundColor = UIColor.white
               (s as! UITextField).font = FontHelper.textRegular(size: 12)
            }
        }
    }

    public static func showCustomCountryDialog(withDataSource:NSMutableArray = []) -> CustomCountryDialog {
        let view = UINib(nibName: Identifiers.CountryDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomCountryDialog
        view.setShadow()
        view.tableForCountry.delegate = view;
        view.tableForCountry.dataSource = view;
        if let arrCountry = withDataSource as? [Countries] {
            view.coutrylist = arrCountry
        }
        
        view.tableForCountry.register(UINib.init(nibName: Identifiers.CellForCountry, bundle: nil), forCellReuseIdentifier: Identifiers.reuseCellIdentifier)

        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame
        APPDELEGATE.window?.addSubview(view)
        APPDELEGATE.window?.bringSubviewToFront(view);

        if view.tableForCountry.contentSize.height > (UIScreen.main.bounds.height - (160 + UIApplication.shared.statusBarFrame.height)){
            view.height.constant = (UIScreen.main.bounds.height - (160 + UIApplication.shared.statusBarFrame.height))
        } else {
            view.height.constant = view.tableForCountry.contentSize.height
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
                if self.tableForCountry.contentSize.height > (tempHeight) {
                    self.height.constant = tempHeight
                } else {
                    self.height.constant = self.tableForCountry.contentSize.height
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
            DispatchQueue.main.async {
                if self.tableForCountry.contentSize.height > (UIScreen.main.bounds.height - (160 + UIApplication.shared.statusBarFrame.height)){
                    self.height.constant = (UIScreen.main.bounds.height - (160 + UIApplication.shared.statusBarFrame.height))
                } else {
                    self.height.constant = self.tableForCountry.contentSize.height
                }
            }
        }
        self.endEditing(true)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let country:Countries = {
            if isSearch {
                return arrFilterCountry[indexPath.row]
            }
            return coutrylist[indexPath.row]
        }()
        
        if self.onCountrySelected != nil {
            self.animationForHideAView(alertView) {
                self.onCountrySelected!(country)
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            return arrFilterCountry.count
        }
        if coutrylist.count > 0 {
            return coutrylist.count
        }
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:Identifiers.reuseCellIdentifier, for: indexPath) as! CustomCountryCell;
        let country:Countries = {
            if isSearch {
                return arrFilterCountry[indexPath.row]
            }
            return coutrylist[indexPath.row]
        }()
        cell.lblCountryName.text = country.country_name
        cell.lblCountryPhoneCode.text = country.country_phone_code
        cell.selectionStyle = .none
        return cell
    }

    @IBAction func onClickBtnClose(_ sender: Any) {
        self.animationForHideAView(alertView) {
            self.removeFromSuperview();
        }
    }
}

class CustomCountryCell: CustomTableCell {
    @IBOutlet weak var lblCountryPhoneCode: UILabel!
    @IBOutlet weak var lblCountryName: UILabel!

    override func awakeFromNib() {
        lblCountryName.font = FontHelper.textRegular()
        lblCountryPhoneCode.font = FontHelper.textRegular()
        lblCountryPhoneCode.textColor = UIColor.themeTextColor
        lblCountryName.textColor = UIColor.themeTextColor
    }
}

extension CustomCountryDialog: UISearchBarDelegate {
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
        arrFilterCountry.removeAll()
        let searchText = searchBarItem.text ?? ""
        if searchText.isEmpty() {
            isSearch = false
            self.tableForCountry.reloadData()
        }
        else
        {
            isSearch = true
            arrFilterCountry = coutrylist.filter({ (itemData) -> Bool in
                if let a = itemData.country_name?.lowercased().contains(searchText.lowercased()) {
                    return a
                }
                return false
            })
            self.tableForCountry.reloadData()
        }
        
        DispatchQueue.main.async {
            let tempHeight = self.frame.size.height - self.keyBoardHeight - 160 - UIApplication.shared.statusBarFrame.height
            if self.tableForCountry.contentSize.height > (tempHeight) {
                self.height.constant = tempHeight
            } else {
                self.height.constant = self.tableForCountry.contentSize.height
            }
        }
    }
}
