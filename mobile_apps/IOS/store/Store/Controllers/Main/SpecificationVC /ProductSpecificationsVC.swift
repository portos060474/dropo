//
//  ProductSpecificationsVC.swift
//  Store
//
//  Created by Jaydeep Vyas on 03/03/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class ProductSpecificationsVC: BaseVC,UITableViewDelegate,UITableViewDataSource {
    
    /* Product Specification Group View */

    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var btnEditSpecification: UIButton!
    @IBOutlet weak var btnAdd: UIButton!

    @IBOutlet weak var tblSpecifications: UITableView!
    var arrForDisplaySpecificationItems = [ProductDisplaySpecification]()
    var selectedGroup:ProductDisplaySpecificationGroup? = nil
    var isForEdit:Bool = false
    var numberOfItems:Int = 0
    var arrForAddItems = [SpecificationNameValuePair]()
    var arrForDeleteItems = [String]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLocalization()
        /*Auto Resize Header Footer*/
    
        self.tblSpecifications.rowHeight = UITableView.automaticDimension;
        self.tblSpecifications.estimatedRowHeight = 60.0;
        /* End update */
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        arrForDisplaySpecificationItems.removeAll()
        
        for specification in (selectedGroup?.productSpecifications)! {
           // arrForDisplaySpecificationItems.append(ProductDisplaySpecification.init(name: specification.name, id: specification.id, index: 0, price: specification.price, nameLanguages: specification.nameLanguages)!)
            
            //Janki
            arrForDisplaySpecificationItems.append(ProductDisplaySpecification.init(name: specification.name, id: specification.id, index: 0, price: specification.price, nameLanguages: specification.nameLanguages, sequence_number: specification.sequence_number, modifierGroupName: "")!)
        }
        
       var arrSortForDisplaySpecificationItems = [ProductDisplaySpecification]()
       let sortedArray = arrForDisplaySpecificationItems.sorted{ $0.sequence_number < $1.sequence_number }
        for obj in sortedArray
        {
            arrSortForDisplaySpecificationItems.append(obj)
        }
        arrForDisplaySpecificationItems.removeAll()
        arrForDisplaySpecificationItems.append(contentsOf: arrSortForDisplaySpecificationItems)
        tblSpecifications.reloadData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
   
    func setLocalization() -> Void {
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        footerView.isHidden = true
        super.hideBackButtonTitle()
        self.setNavigationTitle(title: selectedGroup?.name ?? "")
        self.btnAdd.setTitle("TXT_ADD".localized, for: .normal)
        self.btnAdd.setTitleColor(.themeColor, for: .normal)
        self.btnEditSpecification.backgroundColor = .themeColor
        self.btnEditSpecification.layer.cornerRadius = btnEditSpecification.frame.height/2.0
        updateUIAccordingToTheme()
    }
   
    override func updateUIAccordingToTheme() {
      
        btnEditSpecification.setImage(UIImage(named: "plus_icon")?.imageWithColor(color: .white), for: .normal)
        btnEditSpecification.setImage(UIImage(named: "correct_icon")?.imageWithColor(color: .white), for: .selected)
        
        self.tblSpecifications.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: -
    //MARK: - UITableview delegate
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrForDisplaySpecificationItems.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
            return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        if (arrForDisplaySpecificationItems[indexPath.row]._id ?? "").isEmpty() {
            let newProductSpecificationCell:NewProductSpecificationCell = tableView.dequeueReusableCell(withIdentifier: "inputItemCell", for: indexPath) as! NewProductSpecificationCell
            newProductSpecificationCell.txtItemName.tag = indexPath.row
            newProductSpecificationCell.productDetail =
                arrForDisplaySpecificationItems[indexPath.row]
            return newProductSpecificationCell
            
            
        }else {

            let specificationCell:SpecificationCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SpecificationCell
            specificationCell.setCellData(data: arrForDisplaySpecificationItems[indexPath.row])
            specificationCell.btnRemoveSpecification.isHidden = !isForEdit
            specificationCell.btnRemoveSpecification.tag = indexPath.row
            specificationCell.btnRemoveSpecification.addTarget(self, action: #selector(onClickRemoveSpecification(_:)), for: .touchUpInside)
            

            return specificationCell
        }
    }
   
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Show edit dialog \(self.arrForDisplaySpecificationItems[indexPath.row].nameLanguages)")
        openLocalizedLanguagDialog(ind: indexPath.row)
    }
    

    func openLocalizedLanguagDialog(ind:Int)
    {
        //Storeapp
        let dialogForLocalizedLanguage = CustomActiveLanguageSpecificationGroupDialog.showCustomLanguageSpecGroupDialog(languages: [:], title: "TXT_SPECIFICATION_NAME".localized,nameLang: self.arrForDisplaySpecificationItems[ind].nameLanguages,sequenceNumber: self.arrForDisplaySpecificationItems[ind].sequence_number, isNewItem: false, isFromSpecGroup: false)
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
            
            self.arrForDisplaySpecificationItems[ind].nameLanguages = namelang
            self.arrForDisplaySpecificationItems[ind].sequence_number = sequenceNumber
//                self.txtItemName.text = self.productDetail.nameLanguages[ConstantsLang.StoreLanguageIndexSelected]
                    self.wsUpdateSpecName(ind: ind)
            dialogForLocalizedLanguage.removeFromSuperview()
        }
    }
    
    
    func wsUpdateSpecName(ind:Int) {
        Utility.showLoading()
        let dictParam: Dictionary<String,Any> =
            [PARAMS.STORE_ID:preferenceHelper.getUserId(),
            PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken(),
            PARAMS.NAME:self.arrForDisplaySpecificationItems[ind].nameLanguages,
            PARAMS.SP_ID:self.arrForDisplaySpecificationItems[ind]._id ?? "0",
            PARAMS.SEQUENCE_NUMBER:self.arrForDisplaySpecificationItems[ind].sequence_number,
            "specification_price":self.arrForDisplaySpecificationItems[ind].price

        ];
        
        
        print("WS_UPDATE_SPECIFICATION_NAME Dictparam \(dictParam)")
        print(Utility.conteverDictToJson(dict: dictParam))
        
        let afn:AlamofireHelper = AlamofireHelper.init();
        afn.getResponseFromURL(url: WebService.WS_UPDATE_SPECIFICATION_NAME, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Utility.hideLoading()
            if (Parser.isSuccess(response: response)) {
                print("WS_UPDATE_SPECIFICATION_NAME response \(response)")

                self.navigationController?.popViewController(animated: true)
                return
            }
        }
    }
    
    @IBAction func onClickBtnAddNewItem(_ sender: Any) {

        var languageArray: [String:String] = [:]
        for language in ConstantsLang.adminLanguages
        {
            languageArray[language.languageCode] = ""
        }
        self.openLocalizedLanguagDialogForAddNewItem()
        //Storeapp
//        arrForDisplaySpecificationItems.append(ProductDisplaySpecification.init(name: "", id: "", price: 0.0, nameLanguages: languageArray)!)
        //Storeapp
        /*arrForDisplaySpecificationItems.append(ProductDisplaySpecification.init(name: "", id: "", price: 0.0, nameLanguages: [], sequence_number: 0)!)
            let indexPath = IndexPath(row: self.arrForDisplaySpecificationItems.count - 1, section: 0)
            self.tblSpecifications.beginUpdates()
            self.tblSpecifications.insertRows(at: [indexPath], with: .automatic)
            self.tblSpecifications.endUpdates()*/
    }
    
    func openLocalizedLanguagDialogForAddNewItem()
    {

        let arr = ProductDisplaySpecification.init(name: "", id: "", price: 0.0, nameLanguages: [], sequence_number: 0, modifierGroupName: "")!
        //Storeapp
        let dialogForLocalizedLanguage = CustomActiveLanguageSpecificationGroupDialog.showCustomLanguageSpecGroupDialog(languages: [:], title: "TXT_SPECIFICATIONS".localized,nameLang: arr.nameLanguages,sequenceNumber: 0, isNewItem: true, isFromSpecGroup: false)
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
                
                self.arrForAddItems.removeAll()
                self.arrForAddItems.append(SpecificationNameValuePair.init(name: "", price: price , nameLanguages: namelang, sequence_number: sequenceNumber)!)
                self.wsAddSpecification()

                dialogForLocalizedLanguage.removeFromSuperview()
        }
    }
    func addIdToDeletedArray(id:String,index:Int) {
        self.arrForDeleteItems.append(id)
        arrForDisplaySpecificationItems.remove(at: index)
        tblSpecifications.reloadData()
    }
    
    @IBAction func onClickEditSpecificationsGroup (_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            isForEdit = true
            footerView.isHidden = false
            arrForAddItems.removeAll()
            tblSpecifications.reloadData()
        }else {
            Utility.showLoading()
            footerView.isHidden = true
            isForEdit = false
            
            var arrIndexPath: [IndexPath] = []
            
            for i in 0..<arrForDisplaySpecificationItems.count {
                let indexPath = IndexPath(row: i, section: 0)
                if (arrForDisplaySpecificationItems[indexPath.row]._id?.isEmpty())! {
                    
                    let cell:NewProductSpecificationCell = tblSpecifications.cellForRow(at:indexPath) as! NewProductSpecificationCell
                    if !((cell.txtItemName.text?.isEmpty()) ?? true)
                    {
                        self.arrForAddItems.append(SpecificationNameValuePair.init(name: cell.txtItemName.text!, price: (cell.txtSpecificationPrice.text?.doubleValue ) ?? 0.0, nameLanguages: cell.productDetail!.nameLanguages, sequence_number: 0)!)
                    }else {
                        arrIndexPath.append(indexPath)
                    }
                }
            }
            print(arrForDeleteItems)
            if arrForAddItems.count > 0 {
                wsAddSpecification()
            }else {
                for indexPath in arrIndexPath.reversed() {
                    arrForDisplaySpecificationItems.remove(at: indexPath.row)
                    tblSpecifications.beginUpdates()
                    tblSpecifications.deleteRows(at: [indexPath], with: .none)
                    tblSpecifications.endUpdates()
                }
                tblSpecifications.reloadData()
                Utility.hideLoading()
            }
            if arrForDeleteItems.count > 0 {
                wsDeleteSpecification()
            }else {
                Utility.hideLoading()
            }
            
        }
        
    }
    @IBAction func onClickRemoveSpecification (_ sender: UIButton) {
        addIdToDeletedArray(id: arrForDisplaySpecificationItems[sender.tag]._id ?? "", index: sender.tag)
    }
}

extension ProductSpecificationsVC {
    func wsAddSpecification() {
        var dictParam = [String:Any]()
        var newArray:[[String:Any]] = [[:]];
        
        newArray.removeAll()
        for item in arrForAddItems {
            newArray.append(item.toDictionary())
        }
        
        if newArray.count > 0{
            dictParam[PARAMS.SEQUENCE_NUMBER] = newArray[0]["sequence_number"] ?? "0"
            dictParam["specification_price"] = newArray[0]["price"] ?? "0"
        }
        
        dictParam[PARAMS.STORE_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.SERVER_TOKEN] = preferenceHelper.getSessionToken()
        dictParam[PARAMS.SPECIFICATION_GROUP_ID] = selectedGroup?._id
        dictParam[PARAMS.SPECIFICATION_NAME] = newArray
        
        Utility.showLoading()
        print("WS_ADD_PRODUCT_SPECIFICATION dicdetail \(Utility.conteverDictToJson(dict: dictParam))")
        let alamofire = AlamofireHelper.init()
        alamofire.getResponseFromURL(url: WebService.WS_ADD_PRODUCT_SPECIFICATION, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            
            print("WS_ADD_PRODUCT_SPECIFICATION response \(response)")
            if Parser.isSuccess(response: response) {
                self.arrForAddItems.removeAll()
                self.tblSpecifications.reloadData()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func wsDeleteSpecification() {
        if arrForDeleteItems.count > 0 {
            var dictParam = [String:Any]()
            dictParam[PARAMS.STORE_ID] = preferenceHelper.getUserId()
            dictParam[PARAMS.SERVER_TOKEN] = preferenceHelper.getSessionToken()
            dictParam[PARAMS.SPECIFICATION_GROUP_ID] = selectedGroup?._id
            dictParam[PARAMS.SPECIFICATION_ID] = arrForDeleteItems
            Utility.showLoading()
            let alamofire = AlamofireHelper.init()
            alamofire.getResponseFromURL(url: WebService.WS_DELETE_PRODUCT_SPECIFICATION, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
                if Parser.isSuccess(response: response) {
                    self.arrForDeleteItems.removeAll()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
       
    }
}
    
    
class NewProductSpecificationCell: CustomCell,UITextFieldDelegate {
    @IBOutlet weak var txtItemName: UITextField!
    @IBOutlet weak var txtSpecificationPrice: UITextField!
    var productDetail: ProductDisplaySpecification!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        self.txtItemName.delegate = self
        self.txtItemName.text = ""
        self.txtItemName.placeholder = "TXT_SPECIFICATION_NAME".localized
        self.txtSpecificationPrice.delegate = self
        self.txtSpecificationPrice.text = ""
        self.txtSpecificationPrice.placeholder = "TXT_SPECIFICATION_PRICE".localized
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
        if textField == txtItemName {
            self.openLocalizedLanguagDialog()
            return false
        }
        return true
    }

    func openLocalizedLanguagDialog() {
//        productDetail.nameLanguages[selectedLanguage] = txtItemName.text
//        let dialogForLocalizedLanguage = CustomActiveLanguageDialog.showCustomLanguageDialog(languages: ( productDetail!.nameLanguages) ?? [:], title: txtItemName.placeholder ?? "")
//
//        dialogForLocalizedLanguage.onItemSelected = { (selectedArray) in
//            self.productDetail.nameLanguages = selectedArray
//            self.txtItemName.text = self.productDetail.nameLanguages[selectedLanguage]
//            dialogForLocalizedLanguage.removeFromSuperview()
//        }
        
        self.endEditing(true)
        let dialogForLocalizedLanguage = CustomActiveLanguageDialog.showCustomLanguageDialog(languages: [:], title: txtItemName.placeholder ?? "",nameLang: self.productDetail!.nameLanguages)
                            dialogForLocalizedLanguage.onItemSelected = { (selectedArray) in
                        
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
                        self.txtItemName.text = self.productDetail.nameLanguages[ConstantsLang.StoreLanguageIndexSelected]
                                            
                        dialogForLocalizedLanguage.removeFromSuperview()
                    }
        
    }
}

/*Model used for displaying Specification Groupt Sections*/
public class ProductDisplaySpecification {
    public var _id : String?
    public var name : String?
    public var price : Double?
    public var type : Bool?
    public var index: Int
    public var sequence_number: Int
    public var modifierGroupName = ""
    public var modifierName = ""
    public var nameLanguages = [String]()

    required public init?(name:String,id:String,type:Bool = false, index:Int = 0, price: Double, nameLanguages:[String],sequence_number:Int, modifierGroupName: String) {

        self._id =  id
        self.name = name
        self.type = type
        self.index = index
        self.price = price
        self.nameLanguages = nameLanguages
        self.sequence_number = sequence_number
        self.modifierGroupName = modifierGroupName

    }
    
    func updateIndex(index:Int) {
        self.index = index
    }
}
public class SpecificationNameValuePair {
    
    public var name : String?
    public var price : Double?
    public var nameLanguages = [String]()
    public var sequence_number: Int

    required public init?(name:String,price:Double, nameLanguages:[String],sequence_number:Int) {
        
        self.name = name
        self.price = price
        self.nameLanguages = nameLanguages
        self.sequence_number = sequence_number

        
    }
    func toDictionary() -> [String:Any] {
        var dictionary:[String:Any] = [:]
        dictionary["name"] = self.nameLanguages
        dictionary["price"] = self.price ?? 0.0
        
        //Storeapp
        dictionary["sequence_number"] = self.sequence_number

        return dictionary
    }
}


