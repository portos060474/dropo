//
//  ManualProviderSelectionDialog.swift
//  Store
//
//  Created by Soft Eaven on 5/7/20.
//  Copyright © 2020 Elluminati. All rights reserved.
//

import Foundation
import UIKit

class ManualProviderSelectionDialog: CustomDialog, UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate,keyboardWasShownDelegate,keyboardWillBeHiddenDelegate{
    
    //MARK:- Outlets
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnAssignAuto: UIButton!
    @IBOutlet weak var btnAssignManually: UIButton!
    @IBOutlet weak var searchBarItem: UISearchBar!

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var heightOfTableView: NSLayoutConstraint!
    @IBOutlet weak var tableForItems: UITableView!
    @IBOutlet weak var alertView: UIView!
    
    @IBOutlet weak var constraintButtomSuperView: NSLayoutConstraint!

    //MARK:- Variables
    //var arrForItemList = [StoreLanguage]();
   // var addedLanguagess:[String:String] = [:];
    var tblDataOriginal = [ModelProvider]()
    var tblDataFilterd = [ModelProvider]()

    var isFromProfile: Bool = false
    var cellIdentifier = "SelectableProviderCell"
    var onItemSelected : ((_ selectedId:String) -> Void)? = nil
    var onClickAssignManuallySelected : (() -> Void)? = nil
    var onClickAssignAutoSelected : (() -> Void)? = nil
    var isAllowMultiselect: Bool!
    var selectedId: String = ""
    
    override func awakeFromNib()
    {
        self.backgroundColor = UIColor.themeOverlayColor
        
    }
    public static func  showDialog(languages:[String:Any], title: String, options: [ModelProvider], isFromProfile: Bool = false,isAllowMultiselect:Bool = true) -> ManualProviderSelectionDialog
    {
        let view = UINib(nibName: "ManualProviderSelectionDialog", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ManualProviderSelectionDialog
        
        view.setShadow()
        view.lblTitle.text = "TXT_SELECT_ASSIGN_DELIVERYMAN".localized

        view.lblTitle.textColor = UIColor.themeTextColor
        view.lblTitle.font = FontHelper.textLarge(size: 18.0)
//        "TXT_ASSIGN" = "Assign";

        view.btnDone.setTitle("TXT_ASSIGN".localizedUppercase, for: .normal)
//        view.btnDone.setTitleColor(UIColor.themeTextColor, for: .normal)
//        view.btnDone.titleLabel?.font = FontHelper.textMedium()
        
//        view.btnCancel.setTitle("TXT_CANCEL".localizedUppercase, for: .normal)
//        view.btnCancel.setTitleColor(UIColor.themeTextColor, for: .normal)
        view.btnCancel.titleLabel?.font = FontHelper.textMedium()
        
        view.isFromProfile = isFromProfile
        view.tblDataOriginal.removeAll()
        view.tblDataOriginal.append(contentsOf: options)
        view.tblDataFilterd.removeAll()
        view.tblDataFilterd.append(contentsOf: view.tblDataOriginal)
        
        view.tblDataFilterd[0].isSelected = true
        view.selectedId = view.tblDataFilterd[0].id
        
        view.searchBarItem.placeholder = "TXT_SEARCH_DELIVERYMAN".localized
        view.searchBarItem.backgroundImage = UIImage()
        view.searchBarItem.barTintColor = UIColor.themeTextColor
        view.searchBarItem.backgroundColor = UIColor.themeViewBackgroundColor
        view.searchBarItem.layer.borderColor = UIColor.themeLightLineColor.cgColor
        view.searchBarItem.layer.borderWidth = 1.0
        view.searchBarItem.tintColor = UIColor.themeTextColor
        view.searchBarItem.setTextColor(color: UIColor.themeTextColor)
        
        view.registerForKeyboardObserver()
        view.delegatekeyboardWasShown = view
        view.delegatekeyboardWillBeHidden = view
        
        view.isAllowMultiselect = isAllowMultiselect
//        view.nameLang.removeAll()
//        view.nameLang.append(contentsOf: nameLang)
        
        view.tableForItems.delegate = view;
        view.tableForItems.dataSource = view;
        view.tableForItems.register(UINib.init(nibName: view.cellIdentifier, bundle: nil), forCellReuseIdentifier: view.cellIdentifier)
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame
                
        view.backgroundColor = UIColor.themeOverlayColor
        APPDELEGATE.window?.addSubview(view)
        APPDELEGATE.window?.bringSubviewToFront(view);
        view.animationBottomTOTop(view.alertView)

        let tapForOverlayLanguage = UITapGestureRecognizer(target: view, action:#selector(ManualProviderSelectionDialog.closeDialog))
        tapForOverlayLanguage.delegate = view
        view.addGestureRecognizer(tapForOverlayLanguage)
        view.tableForItems.tableFooterView = UIView()
        view.updateUIAccordingToTheme()
        
        view.heightOfTableView.constant = (view.tableForItems.contentSize.height < UIScreen.main.bounds.height - 200) ?view.tableForItems.contentSize.height : 200
        
        return view;
    }
    
    override func keyboardWasShown(notification: NSNotification)
    {
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        var aRect : CGRect = self.frame
        aRect.size.height -= keyboardSize!.height
        self.constraintButtomSuperView.constant = keyboardSize!.height

        if (aRect.contains(searchBarItem!.frame.origin))
        {
            constraintButtomSuperView.constant = 0.0
            UIView.animate(withDuration: 1.0) {
                self.constraintButtomSuperView.constant = keyboardSize!.height
            }
        }
    }
    
    override func keyboardWillBeHidden(notification: NSNotification)
    {
        //Once keyboard disappears, restore original positions
        UIView.animate(withDuration: 1.0) {
            self.constraintButtomSuperView.constant = 0.0
        }
        self.endEditing(true)
    }

    public override func layoutSubviews() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.alertView.applyTopCornerRadius()
        }
    }
    
    override func updateUIAccordingToTheme() {
        btnCancel.setImage(UIImage(named: "cross")?.imageWithColor(color: .themeColor), for: .normal)
        self.tableForItems.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
       if isAllowMultiselect {
           //tblDataFilterd[indexPath.row].1 = !tblDataFilterd[indexPath.row].1
           tableView.reloadData()
        
       }else {
           for i in 0..<tblDataFilterd.count {
               tblDataFilterd[i].isSelected = false
           }
           tblDataFilterd[indexPath.row].isSelected = true
        
            if tblDataFilterd[indexPath.row].isSelected{
                selectedId = tblDataFilterd[indexPath.row].id
            }
           tableView.reloadData()
       }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
         return tblDataFilterd.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        var cell :SelectableProviderCell?
         if let sCell: SelectableProviderCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SelectableProviderCell {
             cell=sCell
             
         }else {
             cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellIdentifier) as? SelectableProviderCell
         }
        cell?.selectionStyle = .none
        cell?.lblName.text = "\(self.tblDataFilterd[indexPath.row].firstName!) \(self.tblDataFilterd[indexPath.row].lastName!)"
        cell?.lblPhoneNo.text = "\(self.tblDataFilterd[indexPath.row].countryPhoneCode!) \(self.tblDataFilterd[indexPath.row].phone!)"
        cell?.btnCheck.isSelected = tblDataFilterd[indexPath.row].isSelected
        cell?.imgPhoto.downloadedFrom(link: (self.tblDataFilterd[indexPath.row].imageUrl))
        cell?.btnCheck.setImage(UIImage.init(named: "unchecked"), for: .normal)
        cell?.btnCheck.setImage(UIImage.init(named: "checked")?.imageWithColor(color: .themeColor), for: .selected)

//        cell?.btnCheck.isSelected = self.tblData[indexPath.row].1
        
        return cell!
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: self.tableForItems) == true {
            return false
        }
        return false
    }
    
    @objc func closeDialog()
    {
        self.removeFromSuperview();
    }
    
    @IBAction func onClickBtnCancel(_ sender: Any)
    {
        closeDialog()
    }
    @IBAction func onClickBtnDone(_ sender: Any)
    {
        let count = tblDataFilterd.filter({$0.isSelected}).count
        if count <= 0 {
            return
        }
        
        if self.onItemSelected != nil
        {
            self.onItemSelected!(selectedId)
        }
    }
}

extension ManualProviderSelectionDialog : UISearchBarDelegate {
    //MARK: - UITableview delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchBar.text!)
        tblDataFilterd.removeAll()
        tblDataFilterd = searchText.isEmpty ? tblDataOriginal : tblDataOriginal.filter({(obj: ModelProvider) -> Bool in
            return "\(obj.firstName!) \(obj.lastName!)".range(of: searchText, options: .caseInsensitive) != nil
           })
        
        for i in 0..<tblDataFilterd.count {
            tblDataFilterd[i].isSelected = false
            if selectedId == tblDataFilterd[i].id{
                tblDataFilterd[i].isSelected = true
            }                      
        }
        
        for obj in tblDataOriginal{
            for i in 0..<tblDataFilterd.count {
                if obj.id == tblDataFilterd[i].id{
                    tblDataFilterd[i].isSelected = obj.isSelected
                }
            }
        }
        
        let count = tblDataFilterd.filter({$0.isSelected}).count
        
        if count > 0 {
            btnDone.alpha = 1
        } else {
            btnDone.alpha = 0.5
        }
        
        tableForItems.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.endEditing(true)
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            //self.searchBarItem.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
           // searchBarItem.showsCancelButton = false
            searchBarItem.text = ""
            searchBarItem.resignFirstResponder()
    }
}

class SelectableProviderCell: CustomCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhoneNo: UILabel!
    @IBOutlet weak var imgPhoto: UIImageView!

    @IBOutlet weak var btnCheck: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblName.textColor = UIColor.themeTextColor
        self.lblName.font = FontHelper.labelMeduim_News()
        
        self.lblPhoneNo.textColor = UIColor.themeLightTextColor
        self.lblPhoneNo.font = FontHelper.labelRegular()
        
        self.btnCheck.isUserInteractionEnabled = false
        
        imgPhoto.layer.cornerRadius = self.imgPhoto.frame.height/2
        imgPhoto.clipsToBounds = true
        imgPhoto.layer.borderColor = UIColor.themeTextColor.cgColor
        imgPhoto.layer.borderWidth = 1.0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func onClickCheckBox (_ sender: Any) {
        if (self.btnCheck.isSelected) {
            self.btnCheck.isSelected = false
     
        }else {
            self.btnCheck.isSelected = true
           
        }
    }
}
