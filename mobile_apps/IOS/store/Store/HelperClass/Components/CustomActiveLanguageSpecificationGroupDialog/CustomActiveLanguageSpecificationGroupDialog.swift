//
//  CustomTableDialog.swift
// Jazzly Store
//
//  Created by Jaydeep Vyas on 24/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class CustomActiveLanguageSpecificationGroupDialog: CustomDialog, UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate,UITextFieldDelegate,keyboardWasShownDelegate,keyboardWillBeHiddenDelegate
{
    //MARK:- Outlets
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var heightOfTableView: NSLayoutConstraint!
    @IBOutlet weak var tableForItems: UITableView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var bottomAnchorView: NSLayoutConstraint!
    
    //MARK:- Variables
    var arrForItemList = [StoreLanguage]();
    var addedLanguagess:[String:String] = [:];
    var nameLang = [String]()
    var isFromProfile: Bool = false
    var sequenceNumber: Int = 0
    var price: Double = 0.0
    var isNewItem: Bool = false
    var isFromSpecGroup: Bool = false
    var activeField: UITextField?

    var cellIdentifier = "cellForLanguage"
    var onItemSelected : ((_ view: CustomActiveLanguageSpecificationGroupDialog,_ selectedItem:[String:String], _ sequenceNumber:Int, _ price:Double) -> Void)? = nil
    var onClickCancel : (() -> Void)? = nil
    
    var preferredContentSize: CGSize {
        get {
            // Force the table view to calculate its height
            self.tableForItems.layoutIfNeeded()
            return self.tableForItems.contentSize
        }
        set {}
    }
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.themeOverlayColor
        self.alertView.backgroundColor = UIColor.themeViewBackgroundColor
    }
    
    public static func  showCustomLanguageSpecGroupDialog(languages:[String:Any], title: String, nameLang: [String]? = nil, isFromProfile: Bool = false, sequenceNumber:Int, isNewItem: Bool,isFromSpecGroup:Bool, isUserCanAdd: Bool = false) -> CustomActiveLanguageSpecificationGroupDialog
    {
        let view = UINib(nibName: "dialogForCustomActiveSpecificationGroupLanguage", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomActiveLanguageSpecificationGroupDialog
        view.setShadow()
        view.sequenceNumber = sequenceNumber
        view.isNewItem = isNewItem
        view.isFromSpecGroup = isFromSpecGroup
        
        view.lblTitle.text = title
        view.lblTitle.textColor = UIColor.themeTextColor
        view.lblTitle.font = FontHelper.textLarge()
        view.btnDone.setTitle("TXT_DONE".localizedUppercase, for: .normal)
        
        view.nameLang.removeAll()
        view.isFromProfile = isFromProfile
        view.nameLang.append(contentsOf: nameLang!)
        view.tableForItems.delegate = view;
        view.tableForItems.dataSource = view;
        view.tableForItems.register(UINib.init(nibName: view.cellIdentifier, bundle: nil), forCellReuseIdentifier: view.cellIdentifier)
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame
        
        //Janki
        view.setLanguage(lanuguageList: languages)
        
        view.backgroundColor = UIColor.themeOverlayColor
        view.alertView.backgroundColor = UIColor.themeViewBackgroundColor
        
        if view.preferredContentSize.height <= UIScreen.main.bounds.height - 150{
            view.heightOfTableView.constant = view.preferredContentSize.height + 20
        }else{
            view.heightOfTableView.constant = UIScreen.main.bounds.height - 140
        }
        
        APPDELEGATE.window?.addSubview(view)
        APPDELEGATE.window?.bringSubviewToFront(view);
        view.animationBottomTOTop(view.alertView)
        
        view.registerForKeyboardObserver()
        view.delegatekeyboardWasShown = view
        view.delegatekeyboardWillBeHidden = view
        
        view.updateUIAccordingToTheme()

        return view;
    }
    
    public override func layoutSubviews() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.alertView.applyTopCornerRadius()
        }
    }
    
    override func updateUIAccordingToTheme() {
        btnCancel.setImage(UIImage(named: "cross")?.imageWithColor(color: .themeColor), for: .normal)
    }
    
    func setLanguage(lanuguageList:[String:Any])
    {
        arrForItemList.removeAll()
        if !isFromSpecGroup{
            let dic : [String : Any] = ["is_visible" :true
                                        ,"name" :"TXT_SEQUENCE_NUMBER".localized
                                        ,"code" :"\(sequenceNumber)"
                                        ,"string_file_path" :""]
            
            arrForItemList.append(StoreLanguage(fromDictionary: dic))
        }
        
        if isNewItem && !isFromSpecGroup{
            let dic : [String : Any] = ["is_visible" :true
                                        ,"name" :"TXT_SPECIFICATION_PRICE".localized
                                        ,"code" :""
                                        ,"string_file_path" :""]
            
            arrForItemList.append(StoreLanguage(fromDictionary: dic))
        }
        
        if !isFromProfile{
            if ConstantsLang.storeLanguages.count > 0{
                for i in 0...ConstantsLang.storeLanguages.count-1
                {
                    if ConstantsLang.storeLanguages[i].is_visible{
                        arrForItemList.append(ConstantsLang.storeLanguages[i])
                        
                        print(arrForItemList)
                        
                        if nameLang.count > i{
                            addedLanguagess[ConstantsLang.storeLanguages[i].code] = nameLang[i]
                        }
                    }
                }
            }
            print(addedLanguagess)
            
        }else{
            for i in 0...ConstantsLang.adminLanguages.count-1
            {
                //JAnki
                let dic : [String : Any] = ["is_visible" :true
                                            ,"name" :ConstantsLang.adminLanguages[i].languageName!
                                            ,"code" :ConstantsLang.adminLanguages[i].languageCode!
                                            ,"string_file_path" :""]
                
                arrForItemList.append(StoreLanguage(fromDictionary: dic))
                
                if nameLang.count > i{
                    addedLanguagess[ConstantsLang.adminLanguages[i].languageCode] = nameLang[i]
                }else{
                    addedLanguagess[ConstantsLang.adminLanguages[i].languageCode] = ""
                }
            }
            print(arrForItemList)
            print(addedLanguagess)
        }
        tableForItems.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrForItemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell:CustomLocalizedLanguage? = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as? CustomLocalizedLanguage
        cell?.txtLanguageName.delegate = self
        cell?.txtLanguageName.tag = indexPath.row
        cell?.txtLanguageName.textColor = UIColor.themeTextColor
        cell?.txtLanguageName.font = FontHelper.labelRegular()
        cell?.selectionStyle = .none
        if cell == nil {
            cell = CustomLocalizedLanguage(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellIdentifier)
        }
        cell?.txtLanguageName.placeholder = arrForItemList[indexPath.row].name
        
        if indexPath.row == 0
        {
            
            
            if !self.isNewItem && self.isFromSpecGroup{
                cell?.txtLanguageName.isEnabled = false
            }else{
                cell?.txtLanguageName.isEnabled = true
            }
            
            if isFromSpecGroup{
                cell?.txtLanguageName.isEnabled = true
                cell?.txtLanguageName.text = addedLanguagess[arrForItemList[indexPath.row].code]
            }else{
                cell?.txtLanguageName.text = arrForItemList[indexPath.row].code
            }
            
        }else{
            cell?.txtLanguageName.text = addedLanguagess[arrForItemList[indexPath.row].code]
            cell?.txtLanguageName.isEnabled = true
        }
        
        if indexPath.row == 1{
            if self.isNewItem && self.isFromSpecGroup{
                cell?.txtLanguageName.keyboardType = .default
            }else if self.isNewItem && !self.isFromSpecGroup{
                cell?.txtLanguageName.keyboardType = .numberPad
            }else{
                cell?.txtLanguageName.keyboardType = .default
            }
        }
        
        
        return cell!
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: self.tableForItems) == true {
            return false
        }
        return true
    }

    @objc func closeLanguageDialog(sender: AnyObject?) {
        self.removeFromSuperview();
    }
    
    @IBAction func onClickBtnCancel(_ sender: Any)
    {
        if self.onClickCancel != nil
        {
            self.onClickCancel!()
        }
    }
    
    @IBAction func onClickBtnDone(_ sender: Any)
    {
        self.endEditing(true)
        fillSelectedData()
        if self.onItemSelected != nil
        {
            self.onItemSelected!(self, addedLanguagess, sequenceNumber, price)
        }
    }
    
    func  fillSelectedData()
    {
        var cell = CustomLocalizedLanguage()
        for i in 0...self.arrForItemList.count-1
        {
            let indexPath = IndexPath(row: i, section:0)
            cell = self.tableForItems.cellForRow(at: indexPath) as! CustomLocalizedLanguage
            addedLanguagess[arrForItemList[indexPath.row].code] = cell.txtLanguageName.text ?? ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0
        {
            sequenceNumber = Int(textField.text ?? "0") ?? 0
            arrForItemList[textField.tag].code = "\(sequenceNumber)"
        }
        
        if isNewItem{
            if textField.tag == 1
            {
                price = Double(textField.text ?? "0.0") ?? 0.0
                arrForItemList[textField.tag].code = "\(price)"
            }
        }
        activeField = nil
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let textFieldString = textField.text! as NSString;
        let newString = textFieldString.replacingCharacters(in: range, with:string)
        
        if textField.tag == 0 && !self.isFromSpecGroup
        {
            let floatRegEx = "^[0-9]*$"
            let floatExPredicate = NSPredicate(format:"SELF MATCHES %@", floatRegEx)
            return floatExPredicate.evaluate(with: newString)
            
        }
        if isNewItem && !self.isFromSpecGroup{
            if textField.tag == 1
            {
                let floatRegEx = "^([0-9]+)?(\\.([0-9]+)?)?$"
                //^[0-9]*$
                let floatExPredicate = NSPredicate(format:"SELF MATCHES %@", floatRegEx)
                return floatExPredicate.evaluate(with: newString)
            }
        }
        

        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        return true
    }

    
    
    
    // MARK: - Keyboard methods
    
    override func keyboardWasShown(notification: NSNotification)
    {
        //Need to calculate keyboard exact size due to Apple suggestions
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        var aRect : CGRect = self.frame
        aRect.size.height -= keyboardSize!.height
        if let activeFieldPresent = activeField
        {
            _ = (activeFieldPresent.superview as? UIStackView)?.convert((activeFieldPresent.superview as? UIStackView)?.frame.origin ?? CGPoint.zero, to: nil) ?? CGPoint.zero
            
            if (aRect.contains(activeField!.frame.origin))
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

/*class CustomLocalizedLanguage: UITableViewCell
 {
 /*Cell For Country*/
 @IBOutlet weak var txtLanguageName:UITextField!
 
 override func awakeFromNib()
 {
 super.awakeFromNib()
 // Initialization code
 self.txtLanguageName.textColor = UIColor.themeTextColor
 self.txtLanguageName.font = FontHelper.labelRegular()
 
 }
 
 override func setSelected(_ selected: Bool, animated: Bool) {
 super.setSelected(selected, animated: animated)
 
 // Configure the view for the selected state
 }
 }*/
