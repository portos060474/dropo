//
//  ProductVC.swift
// Edelivery Store
//
//  Created by Jaydeep Vyas on 09/03/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class FamousForVC: BaseVC,UITableViewDataSource,UITableViewDelegate {
    
  
//MARK:- OUTLETS
    
    @IBOutlet weak var tblForTags: UITableView!
    @IBOutlet weak var btnDone: UIButton!
    var arrSelectedTag:[[String]] = [[]];
    var arrTagList:[[String]] = [[]];
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLocalization()
        tblForTags.tableFooterView = UIView()
     }
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        arrTagList = StoreSingleton.shared.store.deliveryDetail.famousProductsTags
        
        arrSelectedTag.removeAll()
        for tag in StoreSingleton.shared.store.famousProductsTags {
            arrSelectedTag.append(tag)
        }
        
        tblForTags.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
    }
   
    func setLocalization() {
        self.btnDone.setTitle("TXT_DONE".localizedUppercase, for: .normal)
            self.view.backgroundColor = UIColor.themeViewBackgroundColor
            self.tblForTags.backgroundColor = UIColor.themeViewBackgroundColor
        self.btnDone.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
            self.btnDone.backgroundColor = UIColor.themeColor
        self.setNavigationTitle(title: "TXT_FAMOUS_FOR".localizedCapitalized)
        self.tblForTags.estimatedRowHeight = 40
        self.tblForTags.rowHeight = UITableView.automaticDimension
    }
    
    override func updateUIAccordingToTheme() {
        self.tblForTags.reloadData()
    }
    
    @IBAction func onClickBtnDone(_ sender: Any) {
        StoreSingleton.shared.store.famousProductsTags.removeAll()
        StoreSingleton.shared.store.famousProductsTags = arrSelectedTag

//        for i in 0...StoreSingleton.shared.store.deliveryDetail.famousProductsTags.count-1{
//            for obj in arrSelectedTag{
//                if StoreSingleton.shared.store.deliveryDetail.famousProductsTags.contains(obj) {
////                    StoreSingleton.shared.store.famousProductsTagsToUpdate.append(obj)
//                    StoreSingleton.shared.store.famousProductsTags.append(obj)
//
//                    break
//                }
//            }
//        }
        self.navigationController?.popViewController(animated: true);
    }
    
    //MARK: TABLEVIEW DELEGATE METHODS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTagList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:FamousForCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FamousForCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        cell.lblTagName.text =  StoreSingleton.shared.returnStringAccordingtoAdminLanguage(arrStr: arrTagList[indexPath.row]) //arrTagList[indexPath.row][ConstantsLang.AdminLanguageIndexSelected]
        cell.btnCheckBox.isUserInteractionEnabled = false
        
        cell.btnCheckBox.isSelected = arrSelectedTag.contains(arrTagList[indexPath.row])
        
        cell.btnCheckBox.setImage(UIImage(named: "unchecked")?.imageWithColor(color: .themeIconTintColor), for: .normal)
        cell.btnCheckBox.setImage(UIImage(named: "checked")?.imageWithColor(color: .themeColor), for: .selected)
        
        return cell;
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return UITableView.automaticDimension;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if arrSelectedTag.contains(arrTagList[indexPath.row]) {
            if let index = arrSelectedTag.index(of: arrTagList[indexPath.row]) {
                arrSelectedTag.remove(at: index)
            }
        }else {
                arrSelectedTag.append(arrTagList[indexPath.row])
        }
        self.tblForTags.reloadData()
        
    }
    
    
}
class FamousForCell: CustomCell {
    
        @IBOutlet weak var btnCheckBox: UIButton!
        @IBOutlet weak var lblTagName: UILabel!
    
        //MARK:- LIFECYCLE
        override func awakeFromNib() {
            super.awakeFromNib()
            self.contentView.backgroundColor =  UIColor.themeViewBackgroundColor;
            self.backgroundColor = UIColor.themeViewBackgroundColor
            lblTagName.font = FontHelper.textRegular()
            lblTagName.textColor = UIColor.themeTextColor
        }
}
