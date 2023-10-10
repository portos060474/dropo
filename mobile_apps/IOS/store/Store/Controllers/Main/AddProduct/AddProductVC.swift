//
//  AddProductVC.swift
//  Store
//
//  Created by Jaydeep Vyas on 24/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class AddProductVC: MainVC,UINavigationControllerDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var txtProductName: CustomTextfield!
    @IBOutlet weak var btnAddPhoto: UIButton!
    @IBOutlet weak var btnEditDetail: UIButton!
    @IBOutlet weak var lblMakeVisible: UILabel!
    @IBOutlet weak var swMakeVisible: UISwitch!
    @IBOutlet weak var txtSequenceNumber:UITextField!
    @IBOutlet weak var viewForAddProduct: UIView!
    
    var productDetail:ProductItem? = nil
    var isForEditProduct:Bool = false
    var isPicAdded = false;
    var dialogForImage:CustomPhotoDialog? = nil
    
    var maxWidth:Int = 0
    var maxHeight:Int = 0
    var minWidth:Int = 0
    var minHeight:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setLocalization()
        self.wsGetImageSettings()
        self.navigationBar?.backgroundColor = UIColor.themeViewBackgroundColor
        self.lblTitle?.textColor = .themeTextColor
        self.lblTitle?.text = "TXT_PRODUCT_".localized
        //        self.navigationBar!.shadow?.hide()
        btnAddPhoto.isHidden = true
        // Do any additional setup after loading the view.
        if isForEditProduct {
            self.imgProduct.downloadedFrom(link: (productDetail?.imageUrl) ?? "")
            self.txtProductName.text = self.productDetail?.name
            self.txtSequenceNumber.text = "\(self.productDetail?.sequence_number! ?? 0)"

            self.swMakeVisible.setOn((self.productDetail?.isVisibleInStore)!, animated: false)
            self.isEnableFields(false)
        }else {
            productDetail = ProductItem.init(fromDictionary: [:])
            self.isEnableFields(true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func updateUIAccordingToTheme() {
        self.btnEditDetail?.setTitle("", for: .normal)
        self.btnEditDetail?.setTitle("", for: .selected)

        self.btnEditDetail?.setImage(UIImage.init(named: "edit")!.imageWithColor(color: .themeColor)!, for: .normal)
        self.btnEditDetail?.setImage(UIImage.init(named: "correct")!.imageWithColor(color: .themeColor)!, for: .selected)
        if LocalizeLanguage.isRTL{
            self.btnLeft?.setImage(UIImage.init(named: "back_right")!.imageWithColor(color: .themeTextColor)!, for: .normal)
        }else{
            self.btnLeft?.setImage(UIImage.init(named: "back")!.imageWithColor(color: .themeTextColor)!, for: .normal)
        }
    

    }
    func openLocalizedLanguagDialog()
    {
        self.view.endEditing(true)
        // productDetail?.nameLanguages[selectedLanguage] = txtProductName.text
        let dialogForLocalizedLanguage = CustomActiveLanguageDialog.showCustomLanguageDialog(languages: [:] , title: txtProductName.placeholder ?? "", nameLang: productDetail!.nameLanguages)
        dialogForLocalizedLanguage.onItemSelected = { (selectedArray) in
            //            self.productDetail?.nameLanguages = selectedArray
            //            self.txtProductName.text = self.productDetail?.nameLanguages[selectedLanguage]
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
            self.productDetail?.nameLanguages = namelang
            self.txtProductName.text = self.productDetail?.nameLanguages[ConstantsLang.StoreLanguageIndexSelected]
            
            dialogForLocalizedLanguage.removeFromSuperview()
        }
        print(productDetail!.nameLanguages)
    }
    
    //MARK: -
    //MARK: - Custom setup,Localization,Color & Font
    func setLocalization() -> Void {
        self.txtProductName.placeholder = "TXT_PRODUCT_TITLE".localized
        self.txtProductName.textColor = UIColor.themeTextColor
        swMakeVisible.onTintColor = .themeColor
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        self.lblMakeVisible.text = "TXT_MAKE_VISIBLE_OR_NOT".localized
        imgProduct.backgroundColor = UIColor.themeTextColor
        lblMakeVisible.font = FontHelper.textSmall()
        lblMakeVisible.textColor = UIColor.themeTextColor
        self.txtSequenceNumber.placeholder =  "TXT_SEQUENCE_NUMBER".localized
        self.txtProductName.font = FontHelper.textRegular()
        self.txtProductName.font = FontHelper.textRegular()
        self.imgProduct.alpha = 0.3
        self.imgProduct.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        self.viewForAddProduct.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        self.txtProductName.keyboardType = .default
        self.txtSequenceNumber.keyboardType = .numberPad

        updateUIAccordingToTheme()
    }
    
    override func btnLeftTapped(_ btn: UIButton = UIButton()) {
        if self.isForEditProduct {
            self.navigationController?.popViewController(animated: true)
        }else {
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ItemListVC.isCallGetItemAPI = false
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: -
    //MARK: - Button Click events
    
    @IBAction func onClickAddPhoto(_ sender: Any) {
        self.view.endEditing(true)
        
        dialogForImage = CustomPhotoDialog.showPhotoDialog("TXT_SELECT_IMAGE".localized, andParent: self, leftTitle: "TXT_GALLERY".localized, rightTitle: "TXT_CAMERA".localized, isCropRequired: false)
        dialogForImage?.onImageSelected = {[unowned self, weak dialogForImage = self.dialogForImage] (image:UIImage) in
            if Utility.checkImageSize(image: image, maxWidth: self.maxWidth, maxHeight: self.maxHeight, minWidth: self.minWidth, minHeight: self.minHeight) {
                self.imgProduct.image = image
                self.isPicAdded = true
            } else {
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
        if self.btnEditDetail.isSelected {
            if (self.txtProductName.text?.isEmpty())! {
                Utility.showToast(message: "MSG_PLEASE_ENTER_PRODUCT_TITLE".localized)
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
        }
    }
    @IBAction func onClickSwitch(sender:Any) {
        if swMakeVisible.isOn {
            print("is On")
        }else {
            print("is Off")
        }
    }
    
    func isEnableFields(_ isEnable:Bool) {
        self.txtProductName.isUserInteractionEnabled = isEnable
        self.txtSequenceNumber.isUserInteractionEnabled = isEnable
        self.btnAddPhoto.isUserInteractionEnabled = isEnable
        self.swMakeVisible.isUserInteractionEnabled = isEnable
        self.btnEditDetail.isSelected = isEnable
    }
    
    //MARK: -
    //MARK: - Custom web service methods
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
        
        dictParam[PARAMS.NAME] = self.productDetail?.nameLanguages
        dictParam[PARAMS.IS_VISIBLE_IN_STORE] = String(self.swMakeVisible.isOn)
        dictParam[PARAMS.SEQUENCE_NUMBER] = self.txtSequenceNumber.text
        
        ItemListVC.isCallGetItemAPI = true
        print("WS_ADD_PRODUCT \(dictParam)")
        Utility.showLoading()
        let alamofire = AlamofireHelper.init()
        if isPicAdded {
            alamofire.getResponseFromURL(url: WebService.WS_ADD_PRODUCT, paramData: dictParam, image: self.imgProduct.image) { (response, error) -> (Void) in
                Utility.hideLoading()
                print("WS_ADD_PRODUCT \(response)")
                if Parser.isSuccess(response: response) {
                    self.isEnableFields(false)
                    self.navigationController?.popViewController(animated: true)
                }
                
            }
        }else {
            alamofire.getResponseFromURL(url: WebService.WS_ADD_PRODUCT, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam, block: { (response, error) -> (Void) in
                Utility.hideLoading()
                print("WS_ADD_PRODUCT \(response)")
                
                if Parser.isSuccess(response: response) {
                    self.isEnableFields(false)
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
    }
    
    func wsUpdateProduct() {
        var dictParam = [String:Any]()
        dictParam[PARAMS.STORE_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.SERVER_TOKEN] = preferenceHelper.getSessionToken()
        dictParam[PARAMS.PRODUCT_ID] = productDetail?.id
        dictParam[PARAMS.NAME] = self.productDetail?.nameLanguages
        dictParam[PARAMS.SEQUENCE_NUMBER] = self.txtSequenceNumber.text

        dictParam[PARAMS.IS_VISIBLE_IN_STORE] = String(self.swMakeVisible.isOn)
        
        ItemListVC.isCallGetItemAPI = true
        Utility.showLoading()
        let alamofire = AlamofireHelper.init()
        if isPicAdded {
            alamofire.getResponseFromURL(url: WebService.WS_UPDATE_PRODUCT, paramData: dictParam, image: self.imgProduct.image) { (response, error) -> (Void) in
                Utility.hideLoading()
                if Parser.isSuccess(response: response) {
                    self.isEnableFields(false)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }else {
            alamofire.getResponseFromURL(url: WebService.WS_UPDATE_PRODUCT, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam, block: { (response, error) -> (Void) in
                Utility.hideLoading()
                if Parser.isSuccess(response: response) {
                    self.isEnableFields(false)
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
    }
    
    // MARK:
    //MARK: - UITextField delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtProductName {
            self.openLocalizedLanguagDialog()
            return false
        }
        return true
    }
    
}
