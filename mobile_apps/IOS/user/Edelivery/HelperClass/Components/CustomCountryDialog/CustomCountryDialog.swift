//
//  CustomCountryDialog.swift
//  edelivery
//
//  Created by Elluminati on 24/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class CustomCountryDialog: CustomDialog, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate {
    struct Identifiers {
        static let  CountryDialog = "dialogForCountry"
        static let  CellForCountry = "CustomCountryCell"
        static let  reuseCellIdentifier = "cellForCountry"
    }
    
    //MARK:- Outlets
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableForCountry: UITableView!
    @IBOutlet weak var searchBarItem: UISearchBar!
    @IBOutlet weak var height:  NSLayoutConstraint!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var bottomAnchorView: NSLayoutConstraint!
    //MARK:- Variables
    var coutrylist = [CountryModal]()
    var coutrylistFilter = [CountryModal]()
    
    var onCountrySelected : ((_ country:CountryModal) -> Void)? = nil
    
    override func awakeFromNib() {
        lblTitle.font = FontHelper.textMedium(size: FontHelper.large)
        lblTitle.textColor = UIColor.themeTextColor
        btnClose.titleLabel?.font = FontHelper.textRegular()
        btnClose.setTitleColor(UIColor.themeTextColor, for: .normal)
        btnClose.setImage(UIImage.init(named: "cancelIcon")?.imageWithColor(color: UIColor.themeColor), for: .normal)
        btnClose.backgroundColor = .clear
        self.backgroundColor = UIColor.themeOverlayColor
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
        searchBarItem.placeholder = "TXT_SELECT_COUNTRY".localized
        searchBarItem?.delegate = self
        for s in searchBarItem.subviews[0].subviews {
            if s is UITextField {
               s.backgroundColor = UIColor.white
               (s as! UITextField).font = FontHelper.textRegular(size: 12)
            }
        }
    }
    
    public static func showCustomCountryDialog(withDataSource:[CountryModal]) -> CustomCountryDialog {
        let view = UINib(nibName: Identifiers.CountryDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomCountryDialog
        
        view.tableForCountry.delegate = view;
        view.tableForCountry.dataSource = view;
        view.coutrylist = withDataSource
        view.coutrylistFilter = withDataSource
        
        view.tableForCountry.register(UINib.init(nibName: Identifiers.CellForCountry, bundle: nil), forCellReuseIdentifier: Identifiers.reuseCellIdentifier)
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame
        APPDELEGATE.window?.addSubview(view)
        APPDELEGATE.window?.bringSubviewToFront(view);
        if view.tableForCountry.contentSize.height > (UIScreen.main.bounds.height - (500 + UIApplication.shared.statusBarFrame.height)){
            view.height.constant = (UIScreen.main.bounds.height - (500 + UIApplication.shared.statusBarFrame.height))
        }
        else {
            view.height.constant = view.tableForCountry.contentSize.height
        }
        
        view.alertView.layoutIfNeeded()
        view.animationBottomTOTop(view.alertView)
        view.deregisterFromKeyboardNotifications()
        view.registerForKeyboardNotifications()
        return view;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let country:CountryModal = coutrylistFilter[indexPath.row]
        if self.onCountrySelected != nil {
            self.onCountrySelected!(country)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if coutrylistFilter.count > 0 {
            return coutrylistFilter.count
        }else{
            return 0
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:Identifiers.reuseCellIdentifier, for: indexPath) as! CustomCountryCell
        let country:CountryModal = coutrylistFilter[indexPath.row]
        cell.lblCountryName.text = country.name
        cell.lblCountryPhoneCode.text = country.code
        return cell
    }
    
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
    @IBAction func onClickBtnClose(_ sender: Any) {
        self.animationForHideView(alertView) {
            
            self.removeFromSuperview();
        }
    }

     func searchbarSearchText() {
        let searchText = searchBarItem.text ?? ""
        if searchText.isEmpty() {
            self.tableForCountry.reloadData()
        }
        else
        {
            let itemArray = self.coutrylist.filter({ (itemData) -> Bool in
                   let a = itemData.name?.lowercased().contains(searchText.lowercased())
                   return a!
            })
            
            if((itemArray.count) > 0)
            {
                coutrylistFilter.removeAll()
                coutrylistFilter.append(contentsOf: itemArray)
            }
            
            self.tableForCountry.reloadData()
        }
    }
    deinit {
         deregisterFromKeyboardNotifications()
     }
    
     @objc override func keyboardWasShown(notification: NSNotification)
     {

         let info : NSDictionary = notification.userInfo! as NSDictionary
         let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
         var aRect : CGRect = self.frame
         aRect.size.height -= keyboardSize!.height
         if let activeFieldPresent = searchBarItem
         {
             let globalPoint = (activeFieldPresent.superview as? UIStackView)?.convert((activeFieldPresent.superview as? UIStackView)?.frame.origin ?? CGPoint.zero, to: nil) ?? CGPoint.zero
             
             if (aRect.contains(searchBarItem!.frame.origin))
             {
                 self.bottomAnchorView.constant = 0.0
                 UIView.animate(withDuration: 0.5) {
                     DispatchQueue.main.async {
                           self.bottomAnchorView.constant = keyboardSize!.height
                     }
                    
                 }
                 
             }
         }
     }

     @objc override func keyboardWillBeHidden(notification: NSNotification)
     {
         var info : NSDictionary = notification.userInfo! as NSDictionary
         var keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
         var contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: -keyboardSize!.height, right: 0.0)
         
         UIView.animate(withDuration: 0.5) {
             self.bottomAnchorView.constant = 0.0
         }
         self.endEditing(true)
     }
}

class CustomCountryCell:UITableViewCell {
    @IBOutlet weak var lblCountryPhoneCode: UILabel!
    @IBOutlet weak var lblCountryName: UILabel!
    override func awakeFromNib() {
        lblCountryName.font = FontHelper.textRegular()
        lblCountryPhoneCode.font = FontHelper.textRegular()
        lblCountryPhoneCode.textColor = UIColor.themeTextColor
        lblCountryName.textColor = UIColor.themeTextColor
   }
}
