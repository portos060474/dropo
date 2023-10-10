import UIKit
class DialogForProductGroup: CustomDialog, UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate {
    
    //MARK:- Outlets
    
    @IBOutlet var heightForContent: NSLayoutConstraint!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var lblChangeLanguage: UILabel!
    @IBOutlet weak var tableForItems: UITableView!
    
    //MARK:- Variables
    var cellIdentifier = "dialogForCustomLanguageCell"
    var onItemSelected : ((_ arrGroupProducts:[CategoryProductArray]) -> Void)? = nil
    let selectedIndex = preferenceHelper.getLanguage()
    var arrGroupProducts = [CategoryProductArray]()
    var arrGroupProductsOriginal = [CategoryProductArray]()

    static var arrUpdatedInd = [Bool]()

    override func awakeFromNib() {
        self.backgroundColor = UIColor.themeOverlayColor
    }
    //(languages:[String:Any], title: String, nameLang: [String]? = nil, isFromProfile: Bool = false)
    
    public static func showCustomDialogProductGroups(arrGroupProducts: [CategoryProductArray]) -> DialogForProductGroup {
        let view = UINib(nibName: "dialogForCustomLanguage", bundle: nil).instantiate(withOwner: nil, options: nil)[1] as! DialogForProductGroup
        view.alertView.setShadow()
        view.alertView.setRound(withBorderColor: UIColor.clear
            , andCornerRadious: 10.0, borderWidth: 1.0)
        view.lblChangeLanguage.text = "Select Product"
        view.arrGroupProducts = arrGroupProducts
        view.lblChangeLanguage.font = FontHelper.textMedium()
        
        view.lblChangeLanguage.textColor = UIColor.themeTextColor
        
        view.tableForItems.register(UINib.init(nibName: view.cellIdentifier, bundle: nil), forCellReuseIdentifier: view.cellIdentifier)
        
        view.tableForItems.delegate = view;
        view.tableForItems.dataSource = view;
                
        if DialogForProductGroup.arrUpdatedInd.count <= 0{
            for obj in arrGroupProducts{
                DialogForProductGroup.arrUpdatedInd.append(obj.isSelected)
            }
        }
        print(DialogForProductGroup.arrUpdatedInd)
        
        view.backgroundColor = UIColor.themeOverlayColor
        let frame = (APPDELEGATE.window?.frame)!;
        view.frame = frame
        APPDELEGATE.window?.addSubview(view)
        APPDELEGATE.window?.bringSubviewToFront(view);
        let tapForOverlayLanguage = UITapGestureRecognizer(target: view, action:#selector(CustomLanguageDialog.closeLanguageDialog))
        tapForOverlayLanguage.delegate = view
        view.heightForContent.constant = CGFloat(40 * arrGroupProducts.count) + 10
        view.addGestureRecognizer(tapForOverlayLanguage)
        return view;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrGroupProducts.count > 0 {
            return arrGroupProducts.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dialogForCustomLanguageCell", for: indexPath) as! dialogForCustomLanguageCell
        
        cell.lblLanguageName.text = StoreSingleton.shared.returnStringAccordingtoLanguage(arrStr:  arrGroupProducts[indexPath.row].nameLanguages)
        cell.selectionStyle = .none
        
//        var isContain : Bool = false
//
//        for i in 0...ConstantsLang.storeLanguages.count-1{
//            if ConstantsLang.storeLanguages[i].code == ConstantsLang.adminLanguages[indexPath.row].languageCode{
//                isContain = ConstantsLang.storeLanguages[i].is_visible
//            }
//        }
        
        cell.btnCheckBox.tag = indexPath.row
        cell.btnCheckBox.addTarget(self, action: #selector(onClickCheckBox(_sender:)), for: .touchUpInside)
        cell.btnCheckBox.isSelected = DialogForProductGroup.arrUpdatedInd[indexPath.row]
        
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

    @objc func closeLanguageDialog() {
        self.onItemSelected!(arrGroupProducts)
        self.removeFromSuperview();
    }
    
    @objc func onClickCheckBox(_sender:UIButton){
        _sender.isSelected = !_sender.isSelected
        DialogForProductGroup.arrUpdatedInd[_sender.tag] = _sender.isSelected
        arrGroupProducts[_sender.tag].isSelected = _sender.isSelected
        selectedInd = _sender.tag
        
    }
    
    @IBAction func onClickCancel(_sender:UIButton){
        self.removeFromSuperview();
    }
    
    @IBAction func onClickSave(_sender:UIButton){
        closeLanguageDialog()
    }
}

//class dialogForCustomLanguageCell: CustomCell,UITextFieldDelegate {
//    @IBOutlet weak var lblLanguageName: UILabel!
//    @IBOutlet weak var btnCheckBox: UIButton!
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//    }
//}
