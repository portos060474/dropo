//
//  TableviewDialogVehicle.swift
//  Store
//
//  Created by Soft Eaven on 5/7/20.
//  Copyright © 2020 Elluminati. All rights reserved.
//

import Foundation
import UIKit

class TableviewDialogVehicle: CustomDialog, UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate{
    
    //MARK:- Outlets
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var btnCancel: UIButton!

    @IBOutlet weak var btnAssignAuto: UIButton!
    @IBOutlet weak var btnAssignManually: UIButton!
    @IBOutlet weak var lblTitleAssignProvider: UILabel!

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var heightOfTableView: NSLayoutConstraint!
    @IBOutlet weak var tableForItems: UITableView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var viewAssignDeliverymanHeight: NSLayoutConstraint!
    @IBOutlet weak var viewAssignDeliveryman: UIView!

    //MARK:- Variables
    //var arrForItemList = [StoreLanguage]();
   // var addedLanguagess:[String:String] = [:];
    var tblData = [(String,Bool)]()
    var isFromProfile: Bool = false
    var cellIdentifier = "cellForSelectableItem"
    var onItemSelected : ((_ selectedItem:[Int]) -> Void)? = nil
    var onClickAssignManuallySelected : (() -> Void)? = nil
    var onClickAssignAutoSelected : (() -> Void)? = nil

    var isAllowMultiselect: Bool!
    var selectedIndex: [Int] = []
    
    override func awakeFromNib()
    {
        self.backgroundColor = UIColor.themeOverlayColor
        
    }
    public static func  showDialog(languages:[String:Any], title: String, options: [(String,Bool)], isFromProfile: Bool = false,isAllowMultiselect:Bool = true,viewAssignDeliverymanHidden:Bool = false) -> TableviewDialogVehicle
    {
        let view = UINib(nibName: "TableviewDialogVehicle", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TableviewDialogVehicle
        view.setShadow()
        view.lblTitle.text = "TXT_SELECT_VEHICLE".localized
        view.lblTitle.textColor = UIColor.themeTextColor
        view.lblTitle.font = FontHelper.textLarge()
        
        view.lblTitleAssignProvider.text = "TXT_ASSIGN_DELIVERYMAN".localized
        view.lblTitleAssignProvider.textColor = UIColor.themeTextColor
        view.lblTitleAssignProvider.font = FontHelper.textMedium()
        
        
        view.btnOk.setTitle("TXT_OK".localizedUppercase, for: .normal)
//        view.btnOk.setTitleColor(UIColor.themeTextColor, for: .normal)
//        view.btnOk.titleLabel?.font = FontHelper.textMedium()
        
//        view.btnCancel.setTitle("TXT_CANCEL".localizedUppercase, for: .normal)
//        view.btnCancel.setTitleColor(UIColor.themeTextColor, for: .normal)
//        view.btnCancel.titleLabel?.font = FontHelper.textMedium()
        view.viewAssignDeliveryman.isHidden = viewAssignDeliverymanHidden
        if viewAssignDeliverymanHidden{
            view.viewAssignDeliverymanHeight.constant = 0
        }else{
            view.viewAssignDeliverymanHeight.constant = 130
        }
        
        if LocalizeLanguage.isRTL{
            view.btnAssignAuto.setTitle("    "+"TXT_ASSIGN_AUTOMATICALLY".localized, for: .normal)
            view.btnAssignManually.setTitle("    "+"TXT_ASSIGN_MANUALLY".localized, for: .normal)
        }else{
            view.btnAssignAuto.setTitle("TXT_ASSIGN_AUTOMATICALLY".localized, for: .normal)
            view.btnAssignManually.setTitle("TXT_ASSIGN_MANUALLY".localized, for: .normal)
        }
        
        view.btnAssignAuto.setTitleColor(UIColor.themeTextColor, for: .normal)
        view.btnAssignAuto.titleLabel?.font = FontHelper.textRegular()
        
        view.btnAssignManually.setTitleColor(UIColor.themeTextColor, for: .normal)
        view.btnAssignManually.titleLabel?.font = FontHelper.textRegular()
        
        view.isFromProfile = isFromProfile
        view.tblData.removeAll()
        view.tblData.append(contentsOf: options)
        view.isAllowMultiselect = isAllowMultiselect
//        view.nameLang.removeAll()
//        view.nameLang.append(contentsOf: nameLang)
        
        view.tableForItems.delegate = view;
        view.tableForItems.dataSource = view;
        view.tableForItems.register(UINib.init(nibName: view.cellIdentifier, bundle: nil), forCellReuseIdentifier: view.cellIdentifier)
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame
        view.btnAssignAuto.isSelected = true
        view.updateUIAccordingToTheme()
        view.backgroundColor = UIColor.themeOverlayColor
        APPDELEGATE.window?.addSubview(view)
        APPDELEGATE.window?.bringSubviewToFront(view);
        view.animationBottomTOTop(view.alertView)


        let tapForOverlayLanguage = UITapGestureRecognizer(target: view, action:#selector(TableviewDialogVehicle.closeDialog))
        tapForOverlayLanguage.delegate = view
        view.addGestureRecognizer(tapForOverlayLanguage)
        view.tableForItems.tableFooterView = UIView()
        
        view.heightOfTableView.constant = (view.tableForItems.contentSize.height < UIScreen.main.bounds.height - 200) ?view.tableForItems.contentSize.height : 200
        
        return view;
    }
    public override func layoutSubviews() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.alertView.applyTopCornerRadius()
        }
    }
    override func updateUIAccordingToTheme() {
        btnCancel.setImage(UIImage(named: "cross")?.imageWithColor(color: .themeColor), for: .normal)
        btnAssignAuto.setImage(UIImage(named: "radio_btn_unchecked_icon"), for: .normal)
        btnAssignManually.setImage(UIImage(named: "radio_btn_unchecked_icon"), for: .normal)
        
        btnAssignAuto.setImage(UIImage(named: "radio_btn_checked_icon")?.imageWithColor(color: .themeColor), for: .selected)
        btnAssignManually.setImage(UIImage(named: "radio_btn_checked_icon")?.imageWithColor(color: .themeColor), for: .selected)
        self.tableForItems.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
       if isAllowMultiselect {
       tblData[indexPath.row].1 = !tblData[indexPath.row].1
       tableView.reloadData()
       }else {
           selectedIndex = [indexPath.row]
           for i in 0..<tblData.count {
               tblData[i].1 = false
           }
           tblData[indexPath.row].1 = true
           tableView.reloadData()
       }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
         return tblData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        var cell :SelectableItemCell?
         if let sCell: SelectableItemCell = tableView.dequeueReusableCell(withIdentifier: "cellForSelectableItem", for: indexPath) as? SelectableItemCell {
             cell=sCell
             
         }else {
             cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cellForSelectableItem") as? SelectableItemCell
         }
        cell?.selectionStyle = .none
        cell?.lblName.text = self.tblData[indexPath.row].0
        cell?.btnCheck.isSelected = self.tblData[indexPath.row].1
        cell?.btnCheck.setImage(UIImage(named: "radio_btn_unchecked_icon"), for: .normal)
        cell?.btnCheck.setImage(UIImage(named: "radio_btn_checked_icon")?.imageWithColor(color: .themeColor), for: .selected)
        return cell!
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
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
        if selectedIndex.count > 0 {
            if self.onItemSelected != nil
            {
                self.onItemSelected!(selectedIndex)
            }
            
            if btnAssignManually.isSelected{
                if self.onClickAssignManuallySelected != nil
                {
                   self.onClickAssignManuallySelected!()
                }
            }
            
            if btnAssignAuto.isSelected{
                if self.onClickAssignAutoSelected != nil
                {
                    self.onClickAssignAutoSelected!()
                }
            }
        }else{
            Utility.showToast(message: "MSG_PLEASE_SELECT_VEHICLE_TYPE".localized)
        }
        
        
    }
    
    
   @IBAction func onClickBtnAssignManually(_ sender: UIButton) {
        btnAssignAuto.isSelected = false
        btnAssignManually.isSelected = true
   }
   
   @IBAction func onClickBtnAssignAuto(_ sender: UIButton) {
        btnAssignAuto.isSelected = true
        btnAssignManually.isSelected = false
   }
    
    
}
