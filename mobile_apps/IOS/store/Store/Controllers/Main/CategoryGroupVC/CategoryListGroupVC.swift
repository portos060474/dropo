//
//  ProductSpecificationsVC.swift
//  Store
//
//  Created by Jaydeep Vyas on 03/03/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class CategoryListGroupVC: BaseVC,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate {
    /* Product Specification Group View */
    @IBOutlet weak var tblVHeader: UIView!
    @IBOutlet weak var lblProductTitleLabel: CustomPaddingLabel!

    @IBOutlet weak var btnAddPhoto: UIButton!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var txtProductName: UITextField!
    @IBOutlet weak var txtSequenceNumber: UITextField!

    //@IBOutlet weak var txtGroupNames: UITextField!
    @IBOutlet weak var btnEditDetail: UIButton!
    @IBOutlet weak var viewForAddProduct: UIView!
    @IBOutlet weak var tblV: UITableView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    let btnUpdate = UIButton.init(type: .custom)

    var arrGroupItems = [CategoryProductGroup]()
    static var arrUpdatedInd = [Bool]()
    var dialogForImage:CustomPhotoDialog? = nil
    var isPicAdded = false;
    let btnCancelOrder = UIButton.init(type: .custom)
    var arrForDisplayCatGroupItems = [CategoryProductArray]()
    var imageStr : String = ""
    var strCatTitle : String = ""
    var isForEditProduct:Bool = false
    var isFormAdd:Bool = false
    var sequenceNumber:Int = 0

    var maxWidth:Int = 0
    var maxHeight:Int = 0
    var minWidth:Int = 0
    var minHeight:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLocalization()
        wsGetImageSettings()
        self.wsGetCategoryListGroup()
//        lblTitle.text = "TXT_ADD_CATEGORY_TITLE".localized
        
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        super.hideBackButtonTitle()
        
        self.txtProductName.placeholder = "TXT_CATEGORY_TITLE".localized

        
        
        if isForEditProduct {
            self.txtProductName.text = strCatTitle
            self.txtSequenceNumber.text = "\(sequenceNumber)"
            self.imgProduct.downloadedFrom(link: imageStr)
            self.setNavigationTitle(title: "TXT_UPDATE_CATEGORY_TITLE".localized)

       }else {
            self.setNavigationTitle(title: "TXT_ADD_CATEGORY_TITLE".localized)
            self.txtProductName.placeholder = "TXT_CATEGORY_TITLE".localized
            //self.txtGroupNames.placeholder = "Select Products"
            self.txtSequenceNumber.placeholder = "TXT_SEQUENCE_NUMBER".localized
            self.txtSequenceNumber.text = "0"

       }
        self.isEnableFields(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
   
    func setLocalization() -> Void {
        self.imgProduct.layer.cornerRadius = 5.0
        self.imgProduct.layer.borderColor = UIColor.black.cgColor
        self.imgProduct.layer.borderWidth = 1
        self.imgProduct.layer.masksToBounds = true
        self.imgProduct.setRound(withBorderColor: .themeTextColor, andCornerRadious: self.imgProduct.frame.size.height/2, borderWidth: 1.0)
        
        self.btnSave.setTitle("TXT_SAVE".localizedUppercase, for: .normal)
        self.btnSave.backgroundColor = UIColor.themeColor
        self.btnSave.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        self.btnSave.titleLabel?.font = FontHelper.buttonText()
        self.btnSave.setRound(withBorderColor: .clear, andCornerRadious: self.btnSave.frame.size.height/2, borderWidth: 1.0)
        
        btnUpdate.setImage(UIImage.init(named: "correct")?.imageWithColor(color: .themeColor), for: .normal)
        btnUpdate.titleLabel?.font = FontHelper.textSmall()
        btnUpdate.sizeToFit()
//        btnUpdate.backgroundColor = UIColor.white
        btnUpdate.setTitleColor(UIColor.themeNavigationBackgroundColor, for: .normal)
        btnUpdate.addTarget(self, action: #selector(onClickRightButton), for: .touchUpInside)
        self.setRightBarButton(button: btnUpdate);
        
//        self.lblProductTitleLabel.textColor = UIColor.black
        self.lblProductTitleLabel.text = "TXT_SUB_CATEGORY".localized.uppercased()
        
        lblProductTitleLabel.font = FontHelper.textSmall(size: 12)
        self.tblVHeader.backgroundColor = .themeViewBackgroundColor
        super.hideBackButtonTitle()

//        tblV.register(UINib.init(nibName: "dialogForCustomLanguageCell", bundle: nil), forCellReuseIdentifier: "dialogForCustomLanguageCell")
        tblV.delegate = self;
        tblV.dataSource = self;
        tblV.tableHeaderView = UIView()
        tblV.tableFooterView = UIView()
    }

  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func onClickBack(){
        CategoryListGroupVC.arrUpdatedInd.removeAll()
        self.navigationController?.popViewController(animated: true)
    }
    override func updateUIAccordingToTheme() {
        self.tblV.reloadData()
    }
    @objc func onClickRightButton() {
        
        var strIDs :String = ""
        for obj in arrForDisplayCatGroupItems{
             if obj.isSelected{
                 strIDs = strIDs + "\(obj.id!),"
             }
        }
        if strIDs.count > 0{
            strIDs.remove(at: strIDs.index(before: strIDs.endIndex))
        }
        print(strIDs)
        
        if (self.txtProductName.text?.isEmpty())! {
            Utility.showToast(message: "MSG_PLEASE_ENTER_PRODUCT_NAME".localized)
        }else if self.arrForDisplayCatGroupItems.count > 0 && strIDs.count > 0{
            if self.isForEditProduct {
                self.wsUpdateProduct(productIds: strIDs)
            }
            else {
                self.wsAddProduct()
            }
        }else{
            Utility.showToast(message: "MSG_PLEASE_SELECT_ANY_PRODUCT".localized)
        }
        
         /*if (self.txtProductName.text?.isEmpty())! {
            Utility.showToast(message: "MSG_PLEASE_ENTER_PRODUCT_NAME".localized)
//            txtProductName.becomeFirstResponder()
         }else {
            if self.isForEditProduct {
                self.wsUpdateProduct()
            }
            else {
                self.wsAddProduct()
            }
        }*/
    }
    
   func isEnableFields(_ isEnable:Bool) {
        self.txtProductName.isUserInteractionEnabled = isEnable
        //self.txtGroupNames.isUserInteractionEnabled = isEnable
       // self.btnAddPhoto.isUserInteractionEnabled = isEnable
        self.tblV.isUserInteractionEnabled = isEnable
        //self.btnEditDetail.isSelected = isEnable
   }
    
    func openLocalizedLanguagDialogForTitle() {
            self.view.endEditing(true)
            let dialogForLocalizedLanguage = CustomActiveLanguageDialog.showCustomLanguageDialog(languages: [:], title: txtProductName.placeholder ?? "",nameLang: self.arrGroupItems[0].nameLanguages,isFromCategory: true)
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
                            self.arrGroupItems[0].nameLanguages = namelang
                            self.txtProductName.text = self.arrGroupItems[0].nameLanguages[ConstantsLang.StoreLanguageIndexSelected]
                                                
                            dialogForLocalizedLanguage.removeFromSuperview()
                        }
        }
    
    func openLocalizedLanguagDialog()
    {

        
       /* let dialogForProductGroup:DialogForProductGroup = DialogForProductGroup.showCustomDialogProductGroups(arrGroupProducts: self.arrForDisplayCatGroupItems)
                    dialogForProductGroup.onItemSelected = {
                            (_ arrGroupProducts:[CategoryProductArray]) in
        //                    super.changed(selectedItem)
                        
                        self.arrForDisplayCatGroupItems.removeAll()
                        self.arrForDisplayCatGroupItems.append(contentsOf: arrGroupProducts)
                           var str : String = ""
                           for obj in arrGroupProducts{
                                if obj.isSelected{
                                    str = str + "\(obj.nameLanguages[ConstantsLang.StoreLanguageIndexSelected]),"
                                }
                           }
                      if str.count > 0{
                           str.remove(at: str.index(before: str.endIndex))
                       }

                       self.txtGroupNames.text = str
                  }*/
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arrForDisplayCatGroupItems.count > 0 {
            return self.arrForDisplayCatGroupItems.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dialogForCustomLanguageCell", for: indexPath) as! dialogForCustomLanguageCell
        
        cell.lblLanguageName.text = StoreSingleton.shared.returnStringAccordingtoLanguage(arrStr:  self.arrForDisplayCatGroupItems[indexPath.row].nameLanguages)
        cell.selectionStyle = .none
        
        cell.btnCheckBox.tag = indexPath.row
        cell.btnCheckBox.addTarget(self, action: #selector(onClickCheckBox(_sender:)), for: .touchUpInside)
        cell.btnCheckBox.isSelected = CategoryListGroupVC.arrUpdatedInd[indexPath.row]
        cell.btnCheckBox.setImage(UIImage.init(named: "unchecked"), for: .normal)
        cell.btnCheckBox.setImage(UIImage.init(named: "checked")?.imageWithColor(color: .themeColor), for: .selected)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
        
    @objc func onClickCheckBox(_sender:UIButton){
        _sender.isSelected = !_sender.isSelected
        CategoryListGroupVC.arrUpdatedInd[_sender.tag] = _sender.isSelected
        arrForDisplayCatGroupItems[_sender.tag].isSelected = _sender.isSelected
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        if textField == txtGroupNames{
//            //self.openLocalizedLanguagDialog()
//        }else
        if textField == txtProductName{
            self.openLocalizedLanguagDialogForTitle()
        }else if textField == txtSequenceNumber{
            return true
        }
        return false
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldString = textField.text! as NSString;
        let newString = textFieldString.replacingCharacters(in: range, with:string)
          if textField == txtSequenceNumber
          {
              let floatRegEx = "^[0-9]*$"
              let floatExPredicate = NSPredicate(format:"SELF MATCHES %@", floatRegEx)
              return floatExPredicate.evaluate(with: newString)
              
          }
        
        return true
    }
    
    //MARK: - Button Click events
    @IBAction func onClickBack(_ sender: UIButton) {
        CategoryListGroupVC.arrUpdatedInd.removeAll()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickSave(_ sender: Any) {
        
        var strIDs :String = ""
        for obj in arrForDisplayCatGroupItems{
             if obj.isSelected{
                 strIDs = strIDs + "\(obj.id!),"
             }
        }
        if strIDs.count > 0{
            strIDs.remove(at: strIDs.index(before: strIDs.endIndex))
        }
        print(strIDs)
        
        if (self.txtProductName.text?.isEmpty())! {
            Utility.showToast(message: "MSG_PLEASE_ENTER_PRODUCT_NAME".localized)
        }else if self.arrForDisplayCatGroupItems.count > 0 && strIDs.count > 0{
            if self.isForEditProduct {
                self.wsUpdateProduct(productIds: strIDs)
            }
            else {
                self.wsAddProduct()
            }
        }else{
            Utility.showToast(message: "MSG_PLEASE_SELECT_ANY_PRODUCT".localized)
        }
        
         /*if (self.txtProductName.text?.isEmpty())! {
            Utility.showToast(message: "MSG_PLEASE_ENTER_PRODUCT_NAME".localized)
//            txtProductName.becomeFirstResponder()
         }else {
            if self.isForEditProduct {
                self.wsUpdateProduct()
            }
            else {
                self.wsAddProduct()
            }
        }*/
    }
    
    @IBAction func onClickAddPhoto(_ sender: Any) {
        self.view.endEditing(true)

        dialogForImage = CustomPhotoDialog.showPhotoDialog("TXT_SELECT_IMAGE".localized, andParent: self, leftTitle: "TXT_GALLERY".localized, rightTitle: "TXT_CAMERA".localized, isCropRequired: false)
        
        dialogForImage?.onImageSelected = {[unowned self, weak dialogForImage = self.dialogForImage] (image:UIImage) in
           
            if Utility.checkImageSize(image: image, maxWidth: self.maxWidth, maxHeight: self.maxHeight, minWidth: self.minWidth, minHeight: self.minHeight) {

                self.imgProduct.image = image
                self.isPicAdded = true
                
            }else {

                var topViewController = APPDELEGATE.window?.rootViewController
                while ((topViewController?.presentedViewController) != nil) {
                    topViewController = topViewController?.presentedViewController
                }
                var cropVC:JDImageCropVC;
                if #available(iOS 11.0, *) {
                    cropVC = JDImageCropVC.init(frame: self.view.safeAreaLayoutGuide.layoutFrame, image: image, maxWidth: self.maxWidth, maxHeight: self.maxHeight, minWidth: self.minWidth, minHeight: self.minHeight)
                } else {
                  cropVC = JDImageCropVC.init(frame: self.view.frame, image: image, maxWidth: self.maxWidth, maxHeight: self.maxHeight, minWidth: self.minWidth, minHeight: self.minHeight)
                }
                
                topViewController?.present(cropVC, animated: true, completion: nil)
                cropVC.onImageCropped = {(image:UIImage) in
                    self.imgProduct.image = image
                    self.isPicAdded = true
                }
                
            }
        }
    }
    @IBAction func onClickEditDetails(_ sender: Any) {
       /* if self.btnEditDetail.isSelected {
             if (self.txtProductName.text?.isEmpty())! {
                Utility.showToast(message: "MSG_PLEASE_ENTER_PRODUCT_NAME".localized)
                txtProductName.becomeFirstResponder()
             
             }else {
                if self.isForEditProduct {
                    self.wsUpdateProduct()
                }
                else {
                    self.wsAddProduct()
                }
            }
        }else {
            self.isEnableFields(true)
        }*/
    }
}
    
//MARK: - Custom web service methods

extension CategoryListGroupVC {
    
     func wsGetImageSettings() {
         let dictParam = [String:String]()
         Utility.showLoading()
         let alamofire = AlamofireHelper.init()
         alamofire.getResponseFromURL(url: WebService.WS_GET_IMAGE_SETTING, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam, block: { (response, error) -> (Void) in
             Utility.hideLoading()
             if Parser.isSuccess(response: response) {
                 let imageSettingResponse:ImageSettingResponse = ImageSettingResponse.init(fromDictionary: response)
                 self.maxWidth = imageSettingResponse.imageSetting.productImageMaxWidth
                 self.minWidth = imageSettingResponse.imageSetting.productImageMinWidth
                 self.maxHeight = imageSettingResponse.imageSetting.productImageMaxHeight
                 self.minHeight = imageSettingResponse.imageSetting.productImageMinHeight
             }
         })
     }
    
    func wsAddProduct() {
        var dictParam = [String:Any]()
        dictParam[PARAMS.STORE_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.SERVER_TOKEN] = preferenceHelper.getSessionToken()
        dictParam[PARAMS.NAME] = self.arrGroupItems[0].nameLanguages
        dictParam[PARAMS.PRODUCT_GROUP_ID] = self.arrGroupItems[0].id
        dictParam[PARAMS.SEQUENCE_NUMBER] = self.txtSequenceNumber.text

        
        var strIDs :String = ""
        for obj in arrForDisplayCatGroupItems{
             if obj.isSelected{
                 strIDs = strIDs + "\(obj.id!),"
             }
        }
        if strIDs.count > 0{
            strIDs.remove(at: strIDs.index(before: strIDs.endIndex))
        }
        print(strIDs)
        dictParam[PARAMS.PRODUCT_IDS] = strIDs
        
        print("WS_ADD_PRODUCT_GROUP_DATA \(dictParam)")
        Utility.showLoading()
        let alamofire = AlamofireHelper.init()
        if isPicAdded {
            alamofire.getResponseFromURL(url: WebService.WS_ADD_PRODUCT_GROUP_DATA, paramData: dictParam, image: self.imgProduct.image) { (response, error) -> (Void) in
                Utility.hideLoading()
                print("WS_ADD_PRODUCT_GROUP_DATA \(response)")
                if Parser.isSuccess(response: response) {
                   // self.isEnableFields(false)
                    self.navigationController?.popViewController(animated: true)
                }
                
            }
        }else {
            alamofire.getResponseFromURL(url: WebService.WS_ADD_PRODUCT_GROUP_DATA, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam, block: { (response, error) -> (Void) in
                Utility.hideLoading()
                print("WS_ADD_PRODUCT_GROUP_DATA \(response)")

                if Parser.isSuccess(response: response) {
                    //self.isEnableFields(false)
                    self.navigationController?.popViewController(animated: true)
                }
                
            })
            
        }
    }
    
    func wsUpdateProduct(productIds: String) {
        var dictParam = [String:Any]()
        dictParam[PARAMS.STORE_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.SERVER_TOKEN] = preferenceHelper.getSessionToken()
        dictParam[PARAMS.NAME] = self.arrGroupItems[0].nameLanguages
        dictParam[PARAMS.PRODUCT_GROUP_ID] = self.arrGroupItems[0].id
        dictParam[PARAMS.SEQUENCE_NUMBER] = self.txtSequenceNumber.text


        dictParam[PARAMS.PRODUCT_IDS] = productIds
        
        print("WS_UPDATE_PRODUCT_GROUP \(dictParam)")
        Utility.showLoading()
        let alamofire = AlamofireHelper.init()
        if isPicAdded {
            alamofire.getResponseFromURL(url: WebService.WS_UPDATE_PRODUCT_GROUP, paramData: dictParam, image: self.imgProduct.image) { (response, error) -> (Void) in
                Utility.hideLoading()
                print("WS_UPDATE_PRODUCT_GROUP \(response)")
                if Parser.isSuccess(response: response) {
                   // self.isEnableFields(false)
                    self.navigationController?.popViewController(animated: true)
                }
                
            }
        }else {
            alamofire.getResponseFromURL(url: WebService.WS_UPDATE_PRODUCT_GROUP, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam, block: { (response, error) -> (Void) in
                Utility.hideLoading()
                print("WS_UPDATE_PRODUCT_GROUP \(response)")

                if Parser.isSuccess(response: response) {
                    //self.isEnableFields(false)
                    self.navigationController?.popViewController(animated: true)
                }
                
            })
            
        }
    }
    
    func wsGetCategoryListGroup() {
        var dictParam = [String:Any]()
        dictParam[PARAMS.STORE_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.SERVER_TOKEN] = preferenceHelper.getSessionToken()
        
        print("WS_GET_GROUP_LIST_OF_GROUP \(dictParam)")
        Utility.showLoading()
        let alamofire = AlamofireHelper.init()
        alamofire.getResponseFromURL(url: WebService.WS_GET_GROUP_LIST_OF_GROUP, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            Utility.hideLoading()
            
            print("WS_GET_GROUP_LIST_OF_GROUP \(response)")

            self.arrForDisplayCatGroupItems.removeAll()
            if Parser.isSuccess(response: response) {
                                let productResponse:CategoryGroupList = CategoryGroupList.init(fromDictionary: response)
                
                var str : String = ""
                if productResponse.productArray.count > 0{
                for i in 0...productResponse.productArray.count-1 {
                        self.arrForDisplayCatGroupItems.append(productResponse.productArray[i])
                        if  self.arrGroupItems[0].productIds != nil{
                        for obj in self.arrGroupItems[0].productIds{
                            if obj == productResponse.productArray[i].id{
                                self.arrForDisplayCatGroupItems[i].isSelected = true
                                str = str + "\(productResponse.productArray[i].nameLanguages[ConstantsLang.StoreLanguageIndexSelected]),"
                                break
                            }
                        }
                        }else{
                            self.arrForDisplayCatGroupItems[i].isSelected = false

                        }
                    }
                    if str.count > 0{
                        str.remove(at: str.index(before: str.endIndex))
                    }
                    self.lblProductTitleLabel.text = "TXT_SUB_CATEGORY".localized.uppercased()


                }else{
                    self.lblProductTitleLabel.text = "TXT_NO_SUB_CATEGORY_AVAILABLE".localized.uppercased()
                }
                
                CategoryListGroupVC.arrUpdatedInd.removeAll()
                if CategoryListGroupVC.arrUpdatedInd.count <= 0{
                    for obj in self.arrForDisplayCatGroupItems{
                        CategoryListGroupVC.arrUpdatedInd.append(obj.isSelected)
                    }
                }
                
                self.tblV.reloadData()
                
                //self.txtGroupNames.text = str
            }
        }
    }
}
