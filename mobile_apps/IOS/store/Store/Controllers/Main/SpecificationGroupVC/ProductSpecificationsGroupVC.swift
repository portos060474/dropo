//
//  ProductSpecificationsVC.swift
//  Store
//
//  Created by Jaydeep Vyas on 03/03/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class ProductSpecificationsGroupVC: BaseVC,UITableViewDelegate,UITableViewDataSource {
    /* Product Specification Group View */

    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnEditSpecificationGroup: UIButton!
    @IBOutlet weak var tblSpecificationsGroups: UITableView!
    var arrForSpecificationGroupItems = [SpecificationGroup]()
    var arrForDisplaySpecificationGroupItems = [ProductDisplaySpecificationGroup]()
    
    /* Array Temperary contains Item want to add to the Server */
    //Janki
//    var arrForAddItems = [[String:String]]()
    
    var arrForAddItems = [[String]]()

    var arrForDeleteItems = [String]()
    var isForEdit:Bool = false
    
    @IBOutlet weak var footeView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLocalization()

        self.tblSpecificationsGroups.rowHeight = UITableView.automaticDimension;
        self.tblSpecificationsGroups.estimatedRowHeight = 60.0;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isForEdit {
            footeView.isHidden = false
        }else {
            footeView.isHidden = true
        }
        self.wsGetProductSpecificationGroup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
   
    func setLocalization() -> Void {
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        self.setNavigationTitle(title: "TXT_SPECIFICATION_GROUP".localized)
        super.hideBackButtonTitle()
        self.btnAdd.setTitle("TXT_ADD".localized, for: .normal)
        btnAdd.setTitleColor(.themeColor, for: .normal)
       
        btnEditSpecificationGroup.backgroundColor = .themeColor
        btnEditSpecificationGroup.layer.cornerRadius = btnEditSpecificationGroup.frame.height/2.0
        updateUIAccordingToTheme()
    }
   
    override func updateUIAccordingToTheme() {
        
        btnEditSpecificationGroup.setImage(UIImage(named: "plus_icon")?.imageWithColor(color: .white), for: .normal)
        btnEditSpecificationGroup.setImage(UIImage(named: "correct_icon")?.imageWithColor(color: .white), for: .selected)
        
        self.tblSpecificationsGroups.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: -
    //MARK: - UITableview delegate
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrForDisplaySpecificationGroupItems.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
            return 1;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        //Storeapp
        if isForEdit{
            self.openLocalizedLanguagDialogForEditGroup(ind: indexPath.row)

        }else{
            
            var mainView: UIStoryboard!
            mainView = UIStoryboard(name: "ProductGroupAndSpecifications", bundle: nil)
            let specificationGroup:ProductDisplaySpecificationGroup = arrForDisplaySpecificationGroupItems[indexPath.row]
            let vc : ProductSpecificationsVC = mainView?.instantiateViewController(withIdentifier: "ProductSpecificationsVC") as! ProductSpecificationsVC
            if specificationGroup._id != "" {
                vc.selectedGroup = specificationGroup
            }
            self.navigationController?.pushViewController(vc, animated: true)
            
            /*if let specificationGroup:ProductDisplaySpecificationGroup = arrForDisplaySpecificationGroupItems[indexPath.row] {
                if specificationGroup._id != "" {
                      self.performSegue(withIdentifier: SEGUE.SPECIFICATION_GROUP_TO_SPECIFICATION, sender: specificationGroup)
                }
                
            }*/
        }
        
    }
    
    
    func openLocalizedLanguagDialogForEditGroup(ind: Int)
    {
        
        let obj = self.arrForDisplaySpecificationGroupItems[ind]
        //Storeapp
        let dialogForLocalizedLanguage = CustomActiveLanguageSpecificationGroupDialog.showCustomLanguageSpecGroupDialog(languages: [:], title: "TXT_SPECIFICATION_GROUP_NAME".localized,nameLang: obj.nameLanguages, sequenceNumber: obj.sequence_number ?? 0, isNewItem: false, isFromSpecGroup: true, isUserCanAdd: obj.user_can_add_specification_quantity)
            dialogForLocalizedLanguage.onClickCancel = {
                dialogForLocalizedLanguage.removeFromSuperview()
            }
        
            dialogForLocalizedLanguage.onItemSelected = { (view, selectedArray, sequenceNumber, price) in
                print(selectedArray)
                var namelang = [String]()
                var count : Int = 0
                if ConstantsLang.storeLanguages.count > 0{
                    for i in 0...ConstantsLang.storeLanguages.count-1
                    {
                        count = 0
                        for j in 0...selectedArray.count-1
                        {
                            if Array(selectedArray.keys)[j] == ConstantsLang.storeLanguages[i].code{
                                namelang.append(selectedArray[ConstantsLang.storeLanguages[i].code]!)
                                count = 1
                            }
                        }
                        if count == 0{
                            namelang.append("")
                        }
                    }
                }
                print(namelang)
                self.arrForDisplaySpecificationGroupItems[ind].nameLanguages = namelang
                self.arrForDisplaySpecificationGroupItems[ind].sequence_number = sequenceNumber

                self.wsUpdateSpecName(ind: ind)
                dialogForLocalizedLanguage.removeFromSuperview()
        }
    }
    
    func openLocalizedLanguagDialog(obj:ProductDisplaySpecificationGroup)
    {

            //Storeapp
        let dialogForLocalizedLanguage = CustomActiveLanguageSpecificationGroupDialog.showCustomLanguageSpecGroupDialog(languages: [:], title: "TXT_SPECIFICATION_GROUP_NAME".localized,nameLang: obj.nameLanguages,sequenceNumber: 0, isNewItem: true, isFromSpecGroup: true, isUserCanAdd: obj.user_can_add_specification_quantity)
            dialogForLocalizedLanguage.onClickCancel = {
                dialogForLocalizedLanguage.removeFromSuperview()
            }
        
            dialogForLocalizedLanguage.onItemSelected = { (view, selectedArray, sequenceNumber, price) in
                print(selectedArray)
                var namelang = [String]()
                var count : Int = 0
                
                if ConstantsLang.storeLanguages.count > 0{
                    for i in 0...ConstantsLang.storeLanguages.count-1
                    {
                        count = 0
                        for j in 0...selectedArray.count-1
                        {
                            if Array(selectedArray.keys)[j] == ConstantsLang.storeLanguages[i].code{
                                namelang.append(selectedArray[ConstantsLang.storeLanguages[i].code]!)
                                count = 1
                            }
                        }
                        if count == 0{
                            namelang.append("")
                        }
                    }
                }
                    
                print(namelang)
                var isAddedName : Bool = false
                for obj in namelang{
                    if obj.count > 0 {
                        isAddedName = true
                        break
                    }
                }
                
                if !isAddedName{
                    Utility.showToast(message: "MSG_PLEASE_ADD_SPECIFICATION_NAME".localizedCapitalized)
                    return
                }
//                    self.productDetail.nameLanguages = namelang
//                self.arrForDisplaySpecificationGroupItems[ind].sequence_number = sequenceNumber
                self.arrForAddItems.removeAll()
                self.arrForAddItems.append(namelang)

                self.wsAddProductSpecificationGroup(sequence_number: sequenceNumber)
                dialogForLocalizedLanguage.removeFromSuperview()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SEGUE.SPECIFICATION_GROUP_TO_SPECIFICATION {
            if let destinationVC =  segue.destination  as? ProductSpecificationsVC {
                destinationVC.selectedGroup = sender as? ProductDisplaySpecificationGroup
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        if  ((arrForDisplaySpecificationGroupItems[indexPath.row]._id) ?? "").isEmpty() {
            let newProductSpecificationGroup:NewProductSpecificationGroup = tableView.dequeueReusableCell(withIdentifier: "inputItemCell", for: indexPath) as! NewProductSpecificationGroup
            newProductSpecificationGroup.txtItemName.tag = indexPath.row
            newProductSpecificationGroup.productDetail = arrForDisplaySpecificationGroupItems[indexPath.row]
            return newProductSpecificationGroup
        }else {
            let productSpecificationGroup:SpecificationGroupCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SpecificationGroupCell
            productSpecificationGroup.btnRemoveSpecification.isHidden = !isForEdit
//            productSpecificationGroup.lblSpecificationGroupName.text = "\(arrForDisplaySpecificationGroupItems[indexPath.row].sequence_number!)   \(arrForDisplaySpecificationGroupItems[indexPath.row].name!)"
            productSpecificationGroup.lblSpecificationGroupName.text = "\(arrForDisplaySpecificationGroupItems[indexPath.row].name!)"

            productSpecificationGroup.btnRemoveSpecification.tag = indexPath.row
            productSpecificationGroup.btnRemoveSpecification.addTarget(self, action: #selector(ProductSpecificationsGroupVC.onClickRemoveSpecificationGroup(_:)), for: .touchUpInside)
            productSpecificationGroup.setCellUI(isFromCat: false)
            return productSpecificationGroup
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @IBAction func onClickBtnAddNewItem(_ sender: Any) {
        self.openLocalizedLanguagDialog(obj: ProductDisplaySpecificationGroup.init(name: "", id: "", listOfSpecification: [Specification.init(fromDictionary: [:])], languageArray: [], sequence_number: 0, userCanAdd_qty: false))
    }
    
    @IBAction func onClickEditSpecificationsGroup (_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
       
        if sender.isSelected {
                isForEdit = true
                footeView.isHidden = false
                arrForAddItems.removeAll()
                tblSpecificationsGroups.reloadData()
        }else {
            Utility.showLoading()
            footeView.isHidden = true
            isForEdit = false
            
            var arrIndexPath: [IndexPath] = []
            
            for i in 0..<arrForDisplaySpecificationGroupItems.count {
                let indexPath = IndexPath(row: i, section: 0)
                if (arrForDisplaySpecificationGroupItems[indexPath.row]._id?.isEmpty())! {
                    let cell:NewProductSpecificationGroup = tblSpecificationsGroups.cellForRow(at:indexPath) as! NewProductSpecificationGroup
                    if !((cell.txtItemName.text?.isEmpty()) ?? true)
                    {
                        self.arrForAddItems.append(cell.productDetail!.nameLanguages)
                        cell.txtItemName.text = ""
                    }else {
                        arrIndexPath.append(indexPath)
                    }
                }
                
            }
            if arrForAddItems.count > 0 {
                wsAddProductSpecificationGroup(sequence_number: 0)
            }else {
                for indexPath in arrIndexPath.reversed() {
                    arrForDisplaySpecificationGroupItems.remove(at: indexPath.row)
                    self.tblSpecificationsGroups.beginUpdates()
                    self.tblSpecificationsGroups.deleteRows(at: [indexPath], with: .none)
                    self.tblSpecificationsGroups.endUpdates()
                }
                
                tblSpecificationsGroups.reloadData()
                Utility.hideLoading()
            }
        }
        
    }
    @IBAction func onClickRemoveSpecificationGroup (_ sender: UIButton) {
        wsDeleteSpecificationGroup(id: arrForDisplaySpecificationGroupItems[sender.tag]._id ?? "")
    }
}
    
//MAKR:- Web Service Calls

extension ProductSpecificationsGroupVC {
        
    func wsDeleteSpecificationGroup(id:String) {
        
        var dictParam = [String:Any]()
        dictParam[PARAMS.STORE_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.SERVER_TOKEN] = preferenceHelper.getSessionToken()
        dictParam[PARAMS.SPECIFICATION_GROUP_ID] = id
        
        Utility.showLoading()
        let alamofire = AlamofireHelper.init()
        alamofire.getResponseFromURL(url: WebService.WS_DELETE_PRODUCT_SPECIFICATION_GROUP, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            if Parser.isSuccess(response: response) {
                
            }
            self.wsGetProductSpecificationGroup()
        }
    }
    
    func wsGetProductSpecificationGroup() {
        var dictParam = [String:Any]()
        dictParam[PARAMS.STORE_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.SERVER_TOKEN] = preferenceHelper.getSessionToken()
        Utility.showLoading()
        let alamofire = AlamofireHelper.init()
        alamofire.getResponseFromURL(url: WebService.WS_GET_PRODUCT_SPECIFICATION_GROUP, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            Utility.hideLoading()
            self.arrForDisplaySpecificationGroupItems.removeAll()
            if Parser.isSuccess(response: response) {
                print("WS_GET_PRODUCT_SPECIFICATION_GROUP \(response)")

                let productSpecificationResponse:SpecificationGroupResponse = SpecificationGroupResponse.init(fromDictionary: response)
                
                for productSpecificationGroup:SpecificationGroup in productSpecificationResponse.specificationGroup {
                    
                    let newGroupSpecification:ProductDisplaySpecificationGroup = ProductDisplaySpecificationGroup.init(name: productSpecificationGroup.name, id: productSpecificationGroup.id, listOfSpecification: productSpecificationGroup.specifications, languageArray: productSpecificationGroup.nameLanguages, sequence_number: productSpecificationGroup.sequence_number,userCanAdd_qty: productSpecificationGroup.user_can_add_specification_quantity)
                    
                    self.arrForDisplaySpecificationGroupItems.append(newGroupSpecification)
                }
            }
            self.tblSpecificationsGroups.reloadData()
        }
    }
        
    func wsAddProductSpecificationGroup(sequence_number:Int) {
        if arrForAddItems.count > 0 {
            var dictParam = [String:Any]()
            dictParam[PARAMS.STORE_ID] = preferenceHelper.getUserId()
            dictParam[PARAMS.SERVER_TOKEN] = preferenceHelper.getSessionToken()
            dictParam[PARAMS.SPECIFICATION_GROUP_NAME] = arrForAddItems
            dictParam[PARAMS.SEQUENCE_NUMBER] = sequence_number

            Utility.showLoading()
            
            print(Utility.conteverDictToJson(dict: dictParam))
            let alamofire = AlamofireHelper.init()
            alamofire.getResponseFromURL(url: WebService.WS_ADD_PRODUCT_SPECIFICATION_GROUP, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
                print(response)
                
                if Parser.isSuccess(response: response)
                {
                    self.arrForAddItems.removeAll()
//                    self.footeView.isHidden = true
//                    self.isForEdit = false
                    self.wsGetProductSpecificationGroup()
                }
                
            }
        }
        else {
            self.arrForAddItems.removeAll()
            self.tblSpecificationsGroups.reloadData()
         
        }
    }
        
    func wsUpdateSpecName(ind:Int) {
        Utility.showLoading()
        let dictParam: Dictionary<String,Any> =
            [PARAMS.STORE_ID:preferenceHelper.getUserId(),
            PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken(),
            PARAMS.NAME:self.arrForDisplaySpecificationGroupItems[ind].nameLanguages,
            PARAMS.SP_ID:self.arrForDisplaySpecificationGroupItems[ind]._id ?? "0",
            PARAMS.SEQUENCE_NUMBER:self.arrForDisplaySpecificationGroupItems[ind].sequence_number ?? 0,
             PARAMS.user_can_add_specification_quantity:self.arrForDisplaySpecificationGroupItems[ind].user_can_add_specification_quantity];
        
        print("WS_UPDATE_SP_NAME Dictparam \(dictParam)")
        
        let afn:AlamofireHelper = AlamofireHelper.init();
        afn.getResponseFromURL(url: WebService.WS_UPDATE_SP_NAME, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Utility.hideLoading()
            if (Parser.isSuccess(response: response)) {
                print("WS_UPDATE_SP_NAME response \(response)")

                self.wsGetProductSpecificationGroup()
                return
            }
        }
    }
}
    
class NewProductSpecificationGroup: CustomCell,UITextFieldDelegate {
    @IBOutlet weak var txtItemName: UITextField!
    var productDetail: ProductDisplaySpecificationGroup!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        self.txtItemName.placeholder = "TXT_SPECIFICATION_GROUP_NAME".localized
        self.txtItemName.delegate = self
        self.txtItemName.text = ""
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //Storeapp
//        self.openLocalizedLanguagDialog()
        return false
    }

    func openLocalizedLanguagDialog()
    {
        self.endEditing(true)
        //Storeapp
        let dialogForLocalizedLanguage = CustomActiveLanguageSpecificationGroupDialog.showCustomLanguageSpecGroupDialog(languages: [:], title: "TXT_SPECIFICATION_GROUP_NAME".localized,nameLang: self.productDetail.nameLanguages,sequenceNumber: self.productDetail.sequence_number ?? 0, isNewItem: false, isFromSpecGroup: true)
            dialogForLocalizedLanguage.onClickCancel = {
                dialogForLocalizedLanguage.removeFromSuperview()
            }
        
            dialogForLocalizedLanguage.onItemSelected = { (view, selectedArray, sequenceNumber, price) in
                print(selectedArray)
                var namelang = [String]()
                var count : Int = 0
                if ConstantsLang.storeLanguages.count > 0{
                    for i in 0...ConstantsLang.storeLanguages.count-1
                    {
                        count = 0
                        for j in 0...selectedArray.count-1
                        {
                            if Array(selectedArray.keys)[j] == ConstantsLang.storeLanguages[i].code{
                                namelang.append(selectedArray[ConstantsLang.storeLanguages[i].code]!)
                                count = 1
                            }
                        }
                        if count == 0{
                            namelang.append("")
                        }
                    }
                }
                print(namelang)
                
                var isAddedName : Bool = false
                for obj in namelang{
                    if obj.count > 0 {
                        isAddedName = true
                        break
                    }
                }
                
                if !isAddedName{
                    Utility.showToast(message: "MSG_PLEASE_ADD_SPECIFICATION_NAME".localizedCapitalized)
                    return
                }
                
                self.productDetail.nameLanguages = namelang
                dialogForLocalizedLanguage.removeFromSuperview()
        }
    }
}




/*Model used for displaying Specification Groupt Sections*/
public class ProductDisplaySpecificationGroup {
    public var _id : String?
    public var name : String?
    //Janki
//    var nameLanguages:[String:String] = [:]
    var productSpecifications : [Specification]
    var nameLanguages = [String]()
    var sequence_number : Int?
    var user_can_add_specification_quantity : Bool = false

//    init(name:String,id:String,listOfSpecification:[Specification], languageArray:[String:String]) {
//        self._id = id
//        self.name = name
//        self.productSpecifications = listOfSpecification
//    }
    
    init(name:String,id:String,listOfSpecification:[Specification], languageArray:[String],sequence_number : Int, userCanAdd_qty: Bool) {
        self._id = id
        self.name = name
        self.productSpecifications = listOfSpecification
        self.nameLanguages = languageArray
        self.sequence_number = sequence_number
        self.user_can_add_specification_quantity = userCanAdd_qty
    }
}


