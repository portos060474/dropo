//
//  CustomTableDialog.swift
// Jazzly Store
//
//  Created by Jaydeep Vyas on 24/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class CustomActiveLanguageDialog: CustomDialog, UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate,UITextFieldDelegate,keyboardWasShownDelegate,keyboardWillBeHiddenDelegate
{
    
    //MARK:- Outlets
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var heightOfTableView: NSLayoutConstraint!
    @IBOutlet weak var tableForItems: UITableView!
    @IBOutlet weak var bottomAnchorView: NSLayoutConstraint!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var btnLeft: UIButton!

    //MARK:- Variables
    var arrForItemList = [StoreLanguage]();
    var addedLanguagess:[String:String] = [:];
    var nameLang = [String]()
    var isFromProfile: Bool = false
    var isFromCategory: Bool = false

    var cellIdentifier = "cellForLanguage"
    var onItemSelected : ((_ selectedItem:[String:String]) -> Void)? = nil
    var onClickLeftButton : (() -> Void)? = nil

    var activeField: UITextField?

    var preferredContentSize: CGSize {
        get {
            // Force the table view to calculate its height
            self.tableForItems.layoutIfNeeded()
            return self.tableForItems.contentSize
        }
        set {}
    }
    
    override func awakeFromNib()
    {
        self.backgroundColor = UIColor.themeOverlayColor
        
    }
    public static func  showCustomLanguageDialog(languages:[String:Any], title: String, nameLang: [String]? = nil, isFromProfile: Bool = false, isFromCategory: Bool = false) -> CustomActiveLanguageDialog
    {
        let view = UINib(nibName: "dialogForCustomActiveLanguage", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomActiveLanguageDialog
        view.lblTitle.text = title
        view.lblTitle.textColor = UIColor.themeTextColor
        view.lblTitle.font = FontHelper.textLarge()
        view.btnDone.setTitle("TXT_SAVE".localized, for: .normal)
//        view.btnDone.setTitleColor(UIColor.themeTextColor, for: .normal)
//        view.btnDone.titleLabel?.font = FontHelper.textRegular()
        view.nameLang.removeAll()
        view.isFromProfile = isFromProfile
        view.isFromCategory = isFromCategory

        view.nameLang.append(contentsOf: nameLang!)
        view.tableForItems.delegate = view;
        view.tableForItems.dataSource = view;
        view.tableForItems.register(UINib.init(nibName: view.cellIdentifier, bundle: nil), forCellReuseIdentifier: view.cellIdentifier)
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame
        
        view.alertView.backgroundColor = UIColor.themeViewBackgroundColor
        //Janki
        view.setLanguage(lanuguageList: languages)
        view.alertView.setShadow()
        view.backgroundColor = UIColor.themeOverlayColor
        APPDELEGATE.window?.addSubview(view)
        APPDELEGATE.window?.bringSubviewToFront(view);
        view.animationBottomTOTop(view.alertView)

        view.registerForKeyboardObserver()
        view.delegatekeyboardWasShown = view
        view.delegatekeyboardWillBeHidden = view
        
        
        
        let tapForOverlayLanguage = UITapGestureRecognizer(target: view, action:#selector(CustomLanguageDialog.closeLanguageDialog))
        tapForOverlayLanguage.delegate = view
        view.addGestureRecognizer(tapForOverlayLanguage)
        view.tableForItems.tableFooterView = UIView()
        
        view.updateUIAccordingToTheme()
//        view.heightOfTableView.constant = (view.tableForItems.contentSize.height < UIScreen.main.bounds.height - 200) ?view.tableForItems.contentSize.height : 200
        
        return view;
    }
    
    public override func layoutSubviews() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.alertView.applyTopCornerRadius()
//            self.btnRight.applyRoundedCornersWithHeight()
        }
    }
    override func updateUIAccordingToTheme() {
        btnLeft.setImage(UIImage(named: "cross")?.imageWithColor(color: .themeColor), for: .normal)
    }
    
    func setLanguage(lanuguageList:[String:Any])
    {
        arrForItemList.removeAll()
        
        if !isFromProfile{
            if ConstantsLang.storeLanguages.count > 0{
                for i in 0...ConstantsLang.storeLanguages.count-1
                {
                    //JAnki
        //            addedLanguagess[language.languageCode] = (lanuguageList[language.languageCode] as? String) ?? ""
                    if ConstantsLang.storeLanguages[i].is_visible{
                        arrForItemList.append(ConstantsLang.storeLanguages[i])
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
        
        if preferredContentSize.height <= UIScreen.main.bounds.height - 250{
            heightOfTableView.constant = preferredContentSize.height
            self.tableForItems.isScrollEnabled = false
        }else{
            heightOfTableView.constant = UIScreen.main.bounds.height - 250
            self.tableForItems.isScrollEnabled = true

        }

    }
    // MARK: - UITextField methods

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
        print(textField.tag)
        print(textField.viewWithTag(textField.tag+1))
        let nextTag = textField.tag + 1
        // Try to find next responder
        let nextResponder = textField.superview?.superview?.superview?.viewWithTag(nextTag) as UIResponder?

        if nextResponder != nil {
            // Found next responder, so set it
            nextResponder?.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard
            textField.resignFirstResponder()
        }

        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldString = textField.text! as NSString;
        let newString = textFieldString.replacingCharacters(in: range, with:string)
        if isFromCategory{
            if textField.placeholder == "TXT_SEQUENCE_NUMBER".localized
          {
              let floatRegEx = "^[0-9]*$"
              let floatExPredicate = NSPredicate(format:"SELF MATCHES %@", floatRegEx)
              return floatExPredicate.evaluate(with: newString)
              
          }
        }
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
    // MARK: - UITableView methods

    
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
        cell?.selectionStyle = .none
        cell?.txtLanguageName.delegate = self
        if cell == nil {
            
            cell = CustomLocalizedLanguage(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellIdentifier)
        }
        cell?.txtLanguageName.placeholder = arrForItemList[indexPath.row].name
        cell?.txtLanguageName.text = addedLanguagess[arrForItemList[indexPath.row].code]
        cell?.txtLanguageName.tag = indexPath.row+1
        
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
    
    
    @IBAction func onClickBtnDone(_ sender: Any)
    {
       fillSelectedData()
        if self.onItemSelected != nil
        {
            self.onItemSelected!(addedLanguagess)
            
        }
    }
    
    @IBAction func onClickBtnLeft(_ sender: Any) {
        self.removeFromSuperview();
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

class CustomLocalizedLanguage: UITableViewCell
{
    /*Cell For Country*/
    @IBOutlet weak var txtLanguageName:UITextField!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        self.txtLanguageName.textColor = UIColor.themeTextColor
        self.txtLanguageName.font = FontHelper.labelRegular()
        self.txtLanguageName.autocorrectionType = .no
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
