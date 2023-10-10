//
//  CustomProductFilter.swift
//  Edelivery
//
//  Created by Elluminati on 3/10/21.
//  Copyright © 2021 Elluminati. All rights reserved.
//

import Foundation
import  UIKit

class CustomProductFilter: CustomDialog,keyboardWasShownDelegate,keyboardWillBeHiddenDelegate  {
    
    @IBOutlet weak var viewForSearchItem: UIView!
    @IBOutlet weak var searchBarItem: UISearchBar!
    @IBOutlet weak var tblForSearchItem: UITableView!
    @IBOutlet weak var btnApplySearch: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var viewForSearchItemHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomAnchorView: NSLayoutConstraint!

    var onClickLeftButton : (() -> Void)? = nil
    var onClickApplySearch : ((_ searchText: String, _ arrSearchList: Array<ProductItem>?) -> Void)? = nil
    static let  productFilterDialog = "dialogForProductFilter"
    var arrProductList:Array<ProductItem>? = nil
    var maskLayer: CAShapeLayer?
    
    public static func showProductFilter
    (title:String,
     message:String,
     arrProductList:Array<ProductItem>?
    ) ->
    CustomProductFilter
    {
        
        
        let view = UINib(nibName: productFilterDialog, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomProductFilter
        
        let frame = (APPDELEGATE.window?.frame)!
        view.frame = frame
        view.lblTitle.text = title
        
        DispatchQueue.main.async {
            APPDELEGATE.window?.addSubview(view)
            APPDELEGATE.window?.bringSubviewToFront(view)
            view.animationBottomTOTop(view.viewForSearchItem)
        }
        
        view.registerForKeyboardObserver()
        view.delegatekeyboardWasShown = view
        view.delegatekeyboardWillBeHidden = view
        
        view.tblForSearchItem.register(UINib.init(nibName: "ProductSearchCell", bundle: nil), forCellReuseIdentifier: "ProductSearchCell")
        view.arrProductList = arrProductList
        view.setLocalization()
        return view
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        viewForSearchItem.applyTopCornerRadius()
    }
    func setLocalization(){
        
        for s in searchBarItem.subviews[0].subviews {
            if s is UITextField {
                s.backgroundColor = UIColor.white
                (s as! UITextField).font = FontHelper.textRegular(size: 12)
            }
        }
        searchBarItem?.delegate = self
        self.backgroundColor = UIColor.themeOverlayColor
        self.viewForSearchItem.backgroundColor = UIColor.themeViewBackgroundColor
        self.tblForSearchItem.backgroundColor = UIColor.themeViewBackgroundColor
        
        searchBarItem.backgroundImage = UIImage()
        searchBarItem.barTintColor = UIColor.themeTextColor
        searchBarItem.backgroundColor = UIColor.themeViewBackgroundColor
        searchBarItem.layer.borderColor = UIColor.themeLightLineColor.cgColor
        searchBarItem.layer.borderWidth = 1.0
        searchBarItem.tintColor = UIColor.themeTextColor
        searchBarItem.setTextColor(color: UIColor.themeTextColor)
        
        searchBarItem.placeholder = "TXT_ENTER_ITEM_NAME".localized
        
        lblTitle.textColor = UIColor.themeTextColor
        lblTitle.font = FontHelper.textMedium(size: FontHelper.large)
        
        tblForSearchItem.reloadData()
        tblForSearchItem.tableFooterView = UIView()
        if preferredContentSize.height <= UIScreen.main.bounds.height - 100 - 200{
            viewForSearchItemHeight.constant = preferredContentSize.height + 200
        }else{
            viewForSearchItemHeight.constant = UIScreen.main.bounds.height - 100 - 200
        }
        updateUIAccordingToTheme()
        self.layoutSubviews()
    }
    
    override func updateUIAccordingToTheme(){
        btnClose.setImage(UIImage(named: "cross")?.imageWithColor(color: .themeColor), for: .normal)
        self.tblForSearchItem.reloadData()
    }
    
    //ActionMethods
    @IBAction func onClickBtnClose(_ sender: Any) {
        if self.onClickLeftButton != nil {
            self.onClickLeftButton!()
        }
    }
    @IBAction func onClickBtnApplySearch(_ sender: Any) {
        let searchText = searchBarItem.text ?? ""
        if self.onClickApplySearch != nil {
            self.onClickApplySearch!(searchText, self.arrProductList)
        }
    }
    
    var preferredContentSize: CGSize {
        get {
            // Force the table view to calculate its height
            self.tblForSearchItem.layoutIfNeeded()
            return self.tblForSearchItem.contentSize
        }
        set {}
    }
    
    // MARK: - Keyboard methods
        
        override func keyboardWasShown(notification: NSNotification)
        {
            //Need to calculate keyboard exact size due to Apple suggestions
            let info : NSDictionary = notification.userInfo! as NSDictionary
            let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
            var aRect : CGRect = self.frame
            aRect.size.height -= keyboardSize!.height
            if let activeFieldPresent = searchBarItem
            {
                _ = (activeFieldPresent.superview as? UIStackView)?.convert((activeFieldPresent.superview as? UIStackView)?.frame.origin ?? CGPoint.zero, to: nil) ?? CGPoint.zero
                
                if (aRect.contains(searchBarItem!.frame.origin))
                {
                    bottomAnchorView.constant = 0.0
                    UIView.animate(withDuration: 1.0) {
                        self.bottomAnchorView.constant = keyboardSize!.height
                    }
                }
            }
        }
        
        override func keyboardWillBeHidden(notification: NSNotification)
        {
            //Once keyboard disappears, restore original positions
            let info : NSDictionary = notification.userInfo! as NSDictionary
            let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
            var _ : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: -keyboardSize!.height, right: 0.0)
            
            UIView.animate(withDuration: 1.0) {
                self.bottomAnchorView.constant = 0.0
            }
            self.endEditing(true)
        }
    
}

extension CustomProductFilter:UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.endEditing(true)
//        let searchText = searchBarItem.text ?? ""
//        if self.onClickApplySearch != nil {
//            self.onClickApplySearch!(searchText, self.arrProductList)
//        }
    }
    
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
        
        return arrProductList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:ProductSearchCell? =  tableView.dequeueReusableCell(with: ProductSearchCell.self, for: indexPath)
        if cell == nil {
            cell = ProductSearchCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cellForProductName")
        }
        cell?.setCellData(cellItem:(arrProductList?[indexPath.row])!)
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        arrProductList?[indexPath.row].isProductFiltered = !(arrProductList?[indexPath.row].isProductFiltered)!
        tblForSearchItem.reloadData()
        
    }
}
