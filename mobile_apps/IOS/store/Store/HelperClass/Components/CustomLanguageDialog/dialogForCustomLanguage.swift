import UIKit
class dialogForCustomLanguage: CustomDialog, UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate {
    
    //MARK:- Outlets
    
    @IBOutlet var heightForContent: NSLayoutConstraint!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var lblChangeLanguage: UILabel!
    @IBOutlet weak var tableForItems: UITableView!
    @IBOutlet weak var btnCancel: UIButton!

    //MARK:- Variables
    var cellIdentifier = "dialogForCustomLanguageCell"
    var onItemSelected : ((_ selectedItem:Int) -> Void)? = nil
    var onClickLeftButton : (() -> Void)? = nil

    let selectedIndex = preferenceHelper.getLanguage()
    static var arrUpdatedInd = [Bool]()
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
    }
    
    public static func showCustomLanguageDialogSetting() -> dialogForCustomLanguage {
        let view = UINib(nibName: "dialogForCustomLanguageSetting", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! dialogForCustomLanguage
        view.alertView.setShadow()
        view.alertView.setRound(withBorderColor: UIColor.clear
            , andCornerRadious: 10.0, borderWidth: 1.0)
        view.lblChangeLanguage.text = "TXT_CHANGE_LANGUAGE".localized
        
        view.lblChangeLanguage.font = FontHelper.textLarge()
        
        view.lblChangeLanguage.textColor = UIColor.themeTextColor
        
        view.tableForItems.register(UINib.init(nibName: view.cellIdentifier, bundle: nil), forCellReuseIdentifier: view.cellIdentifier)
        
        view.tableForItems.delegate = view;
        view.tableForItems.dataSource = view;
        view.tableForItems.tableFooterView = UIView()
        
        if dialogForCustomLanguage.arrUpdatedInd.count <= 0{
            for _ in ConstantsLang.adminLanguages{
                dialogForCustomLanguage.arrUpdatedInd.append(false)
            }
            
            for i in 0...ConstantsLang.adminLanguages.count-1{
                if ConstantsLang.storeLanguages.count > 0{
                for j in 0...ConstantsLang.storeLanguages.count-1{
                    if ConstantsLang.adminLanguages[i].languageCode == ConstantsLang.storeLanguages[j].code{
                        print(ConstantsLang.storeLanguages[j].is_visible)
                        dialogForCustomLanguage.arrUpdatedInd[i] = ConstantsLang.storeLanguages[j].is_visible
                    }
                }
            }
            }
        }

        print(dialogForCustomLanguage.arrUpdatedInd)
        
        view.backgroundColor = UIColor.themeOverlayColor
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame
        APPDELEGATE.window?.addSubview(view)
        APPDELEGATE.window?.bringSubviewToFront(view);
        view.animationBottomTOTop(view.alertView)

        let tapForOverlayLanguage = UITapGestureRecognizer(target: view, action:#selector(CustomLanguageDialog.closeLanguageDialog))
        tapForOverlayLanguage.delegate = view
//        view.heightForContent.constant = CGFloat(40 * arrForLanguages.count)
        view.addGestureRecognizer(tapForOverlayLanguage)
        view.tableForItems.reloadData()
        view.heightForContent.constant = view.preferredContentSize.height
        
        view.updateUIAccordingToTheme()
        return view;
    }
    
    override func updateUIAccordingToTheme() {
        btnCancel.setImage(UIImage(named: "cross")?.imageWithColor(color: .themeColor), for: .normal)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ConstantsLang.adminLanguages.count > 0 {
            return ConstantsLang.adminLanguages.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dialogForCustomLanguageCell", for: indexPath) as! dialogForCustomLanguageCell
        
        cell.lblLanguageName.text = ConstantsLang.adminLanguages[indexPath.row].languageName
        cell.selectionStyle = .none
        
//        let isContain =  ConstantsLang.storeLanguages.contains(where: { (obj) -> Bool in
//            obj.code == ConstantsLang.adminLanguages[indexPath.row].languageCode
//        })
        
//        var isContain : Bool = false
//        
//        for i in 0...ConstantsLang.storeLanguages.count-1{
//            if ConstantsLang.storeLanguages[i].code == ConstantsLang.adminLanguages[indexPath.row].languageCode{
//                isContain = ConstantsLang.storeLanguages[i].is_visible
//            }
//        }
        
        
        cell.btnCheckBox.tag = indexPath.row
        cell.btnCheckBox.addTarget(self, action: #selector(onClickCheckBox(_sender:)), for: .touchUpInside)
        cell.btnCheckBox.setImage(UIImage.init(named: "unchecked"), for: .normal)
        cell.btnCheckBox.setImage(UIImage.init(named: "checked")?.imageWithColor(color: .themeColor), for: .selected)

        
        if indexPath.row == 0{
            cell.btnCheckBox.isSelected = true
            cell.btnCheckBox.alpha = 0.6
            dialogForCustomLanguage.arrUpdatedInd[0] = true
        }else{
            cell.btnCheckBox.alpha = 1.0
            cell.btnCheckBox.isSelected = dialogForCustomLanguage.arrUpdatedInd[indexPath.row]
        }
        return cell
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
    
    var selectedInd: Int = 0
    var isSelectedVisibility: Bool = false

    @objc func closeLanguageDialog(sender: AnyObject?) {
        self.removeFromSuperview();
            
        for i in 0...ConstantsLang.adminLanguages.count-1{
            if ConstantsLang.storeLanguages.count > 0{
                for j in 0...ConstantsLang.storeLanguages.count-1{
                   if ConstantsLang.storeLanguages[j].code == ConstantsLang.adminLanguages[i].languageCode{
                        ConstantsLang.storeLanguages[j].is_visible = dialogForCustomLanguage.arrUpdatedInd[i]
                    }
                }
            }
        }
        
        var count : Int = 0
        if ConstantsLang.adminLanguages.count != ConstantsLang.storeLanguages.count{
            for i in 0...ConstantsLang.adminLanguages.count-1{
                
                count = 0
                for j in 0...ConstantsLang.storeLanguages.count-1{
                    if ConstantsLang.storeLanguages[j].code != ConstantsLang.adminLanguages[i].languageCode{
                        if dialogForCustomLanguage.arrUpdatedInd[i] == true{
                            count = 1
                        }
                    }else{
                        count = 0
                        break
                    }
                }
                
                if count == 1{
                    print(i)
                    let dic : [String : Any] = ["is_visible" :dialogForCustomLanguage.arrUpdatedInd[i]
                              ,"name" :ConstantsLang.adminLanguages[i].languageName
                              ,"code" :ConstantsLang.adminLanguages[i].languageCode
                              ,"string_file_path" :""]
                    ConstantsLang.storeLanguages.append(StoreLanguage(fromDictionary: dic))
                }
            }
        }
        
        print(ConstantsLang.storeLanguages)

    }
    
    @objc func onClickCheckBox(_sender:UIButton){
        if _sender.tag != 0{
            _sender.isSelected = !_sender.isSelected
            dialogForCustomLanguage.arrUpdatedInd[_sender.tag] = _sender.isSelected
           // ConstantsLang.adminLanguages[_sender.tag].isVisible = _sender.isSelected
            selectedInd = _sender.tag
        }
    }
    
    @IBAction func onClickBtnLeft(_ sender: Any) {
        if self.onClickLeftButton != nil {
            self.animationForHideAView(alertView) {
                self.closeLanguageDialog(sender: self)
                self.onClickLeftButton!()
                
            }
        }
    }
}

class dialogForCustomLanguageCell: CustomCell,UITextFieldDelegate {
    @IBOutlet weak var lblLanguageName: UILabel!
    @IBOutlet weak var btnCheckBox: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        lblLanguageName.textColor = .themeTextColor
        lblLanguageName.font = FontHelper.textRegular()
    }
}
