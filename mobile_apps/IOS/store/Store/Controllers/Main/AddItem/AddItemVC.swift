//
//  AddItemVC.swift
//  Store
//
//  Created by Jaydeep on 01/04/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit


class AddItemVC: MainVC,UINavigationControllerDelegate,UITextFieldDelegate,SendSubItemDetailDelegate {
    
    @IBOutlet weak var viewForProductItem: UIView!
    var dialogForImage:CustomPhotoDialog? = nil
    @IBOutlet weak var imgItem: UIImageView!
    @IBOutlet weak var txtProductTitle: UITextField!
    @IBOutlet weak var txtItemName: UITextField!
    @IBOutlet weak var txtItemDesc: UITextField!
    
    @IBOutlet weak var lblMakeVisible: UILabel!
    @IBOutlet weak var swMakeVisible: UISwitch!
    
    @IBOutlet weak var lblSpecifications: UILabel!
    @IBOutlet weak var tableSpecifications: UITableView!
    @IBOutlet weak var btnAddNewSpecification: UIButton!
    
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var lblCurrency: UILabel!
    
    @IBOutlet weak var lblOfferPrice: UILabel!
    @IBOutlet weak var lblOfferPriceCurrency: UILabel!
    @IBOutlet weak var txtOfferPrice: UITextField!
    
    @IBOutlet weak var lblOfferMsg: UILabel!
    @IBOutlet weak var txtOfferMsg: UITextField!
    
    
    @IBOutlet weak var lblInStock: UILabel!
    @IBOutlet weak var swInStock: UISwitch!
    
    @IBOutlet weak var viewForTax: UIView!
    @IBOutlet weak var lblTax: UILabel!
    @IBOutlet weak var lblSequenceNumber: UILabel!
    
    @IBOutlet weak var lblPercentage: UILabel!
    @IBOutlet weak var txtTax: UITextField!
    @IBOutlet weak var txtSequenceNumber: UITextField!
    
    @IBOutlet weak var collectionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionForAddImage: UICollectionView!
    @IBOutlet weak var collVTax: UICollectionView!

    @IBOutlet weak var collVTaxHeight: NSLayoutConstraint!

    
    var arrProductList:[ProductListItem] = []
    var productCategory:String? = nil
    var arrItemSpecification = [ItemSpecification]()
    var arrForSpecificationItemGroupOrignal:[ItemSpecification] = []
    
    var isForEditItem:Bool = false
    var isForEditItemSpecification:Bool = false
    var itemDetail:Item? = nil;
    var selectedIndex:Int = 0
    var selectedProductItem:ProductListItem? = nil
    
    var arrForItemImage : [ItemImageViewer] = []
    var arrForUploadItemImage : [UIImage] = []
    var arrForDeleteItemImage : [String] = []
    
    var specificationsUniqueIdCount = 0;
    var selectedProductGroupItem:ItemSpecification? =  nil;
//    var arrTax = ["IGST 5%"]
    var arrTax:[TaxesDetail] = []

//    var arrSelectedIndex = [IndexPath]()
//    var arrSelectedData = [String]()
//    var selectedRow : Int = 0

    var maxWidth:Int = 0
    var maxHeight:Int = 0
    var minWidth:Int = 0
    var minHeight:Int = 0
    
    override var preferredContentSize: CGSize {
        get {
            // Force the table view to calculate its height
            self.tableSpecifications.layoutIfNeeded()
            return self.tableSpecifications.contentSize
        }
        set {}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLocalization()
        self.wsGetImageSettings()
        self.wsGetSpecificationGroup()
        self.navigationBar?.backgroundColor = UIColor.themeViewBackgroundColor
        self.tableSpecifications.estimatedRowHeight = 50
        self.tableSpecifications.rowHeight = UITableView.automaticDimension
        
        self.lblTitle?.text = "TXT_ITEMS".localizedCapitalized
//        self.setNavigationTitle(title: "TXT_ITEMS".localizedCapitalized)
        if isForEditItem {
            self.setData()
        }else {
            itemDetail = Item.init()
            self.enableFields()
        }
        
        if StoreSingleton.shared.store.isStoreEditItem {
            self.btnRight?.isHidden = false
        }else {
            self.btnRight?.isHidden = true
        }
        
        if arrTax.count > 0{
            viewForTax.isHidden = false
        }else{
            viewForTax.isHidden = true
        }
        
        self.collVTax.register(UINib(nibName: "EasyAmountCell", bundle: nil), forCellWithReuseIdentifier: "EasyAmountCell")
        updateUIAccordingToTheme()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setupLayout() {
        self.collVTax.collectionViewLayout = LeftAlignedCollectionViewFlowLayout()
        self.collVTax.reloadData()
        self.collVTaxHeight.constant = self.collVTax.contentSize.height;
        self.collVTax.layoutIfNeeded()
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews();
        setupLayout()
    }
    
    override func updateUIAccordingToTheme() {
     
        if UIApplication.isRTL() {
            self.btnLeft?.setImage(UIImage.init(named: "back_right")?.imageWithColor(color: .themeTextColor), for: .normal)
        }else{
            self.btnLeft?.setImage(UIImage.init(named: "back")!.imageWithColor(color: .themeTextColor), for: .normal)
        }
        
        self.btnRight?.setImage(UIImage.init(named: "edit")!.imageWithColor(color: .themeColor)!, for: .normal)
        self.btnRight?.setTitle("", for: .normal)
        self.btnRight?.setImage(UIImage.init(named: "correct")!.imageWithColor(color: .themeColor)!, for: .selected)
        self.btnAddNewSpecification.setImage(UIImage.init(named: "add")!.imageWithColor(color: .themeColor)!, for: .normal)
    }
    
    //MARK: -
    //MARK: - Custom setup,Localization,Color & Font
    func setLocalization() -> Void {
        self.lblMakeVisible.text = "TXT_MAKE_VISIBLE_OR_NOT".localized
        
        self.lblSpecifications.text = "TXT_SPECIFICATIONS".localized
        self.lblPrice.text = "TXT_PRICE".localized
        self.lblTax.text = "TXT_TAX".localized
        
        
        self.lblInStock.text = "IN_STOCK_OR_NOT".localized
        self.lblCurrency.text = "\(StoreSingleton.shared.store.currency)"
//        self.btnAddNewSpecification.setTitle("+  " + "TXT_ADD_NEW_SPECIFICATIONS".localized, for: .normal)
        
        self.lblOfferPrice.text  = "TXT_WITHOUT_OFFER_PRICE".localized
        self.lblOfferPriceCurrency.text = "\(StoreSingleton.shared.store.currency)"
        self.txtOfferMsg.placeholder = "TXT_OFFER_MSG".localized
//        self.lblOfferMsg.text = "TXT_OFFER_MSG".localized
//        self.lblSequenceNumber.text = "TXT_SEQUENCE_NUMBER".localized
        self.txtSequenceNumber.placeholder =  "TXT_SEQUENCE_NUMBER".localized
        //Set Colors
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        collectionForAddImage.backgroundColor = UIColor.themeViewBackgroundColor
        lblMakeVisible.textColor = UIColor.themeTextColor
        lblSpecifications.textColor = UIColor.themeTextColor
        lblPrice.textColor = UIColor.themeTextColor
        lblInStock.textColor = UIColor.themeTextColor
        
        lblCurrency.textColor = UIColor.themeTextColor
        self.lblOfferPrice.textColor = UIColor.themeTextColor
        self.lblOfferPriceCurrency.textColor = UIColor.themeTextColor
        self.txtOfferMsg.textColor = UIColor.themeTextColor
        self.lblOfferMsg.textColor = UIColor.themeTextColor
        self.txtOfferPrice.textColor = UIColor.themeTextColor
        self.txtTax.textColor = UIColor.themeTextColor
        self.txtSequenceNumber.textColor = UIColor.themeTextColor
        
        self.txtItemName.text = ""
        self.txtTax.text = ""
        self.txtSequenceNumber.text = ""
        
        self.txtProductTitle.text = ""
        self.txtItemDesc.text = ""
        self.txtOfferMsg.text = ""
        self.txtOfferPrice.text = ""
        
        
        self.txtItemName.textColor = UIColor.themeTextColor
        self.txtProductTitle.textColor = UIColor.themeTextColor
        self.txtItemDesc.textColor = UIColor.themeTextColor
        self.swInStock.tintColor = .themeLightTextColor
        self.swMakeVisible.tintColor = .themeLightTextColor
        
        self.swInStock.onTintColor = .themeColor
        self.swMakeVisible.onTintColor = .themeColor
        
        self.txtProductTitle.placeholder = "TXT_PRODUCT_TITLE".localizedCapitalized
        self.txtItemName.placeholder = "TXT_ITEM_NAME".localizedCapitalized
        self.txtItemDesc.placeholder = "TXT_DESCRIPTION".localizedCapitalized

       /* (self.txtProductTitle as! SkyFloatingLabelTextField).setTextFieldPropertyWhite(placeholder: "TXT_PRODUCT_TITLE".localizedCapitalized)
        (self.txtItemName as! SkyFloatingLabelTextField).setTextFieldPropertyWhite(placeholder: "TXT_ITEM_NAME".localizedCapitalized)
        (self.txtItemDesc as! SkyFloatingLabelTextField).setTextFieldPropertyWhite(placeholder: "TXT_DESCRIPTION".localizedCapitalized)*/
        
        
        
        self.txtPrice.textColor = UIColor.themeTextColor
//        self.btnAddNewSpecification.setTitleColor(UIColor.themeColor, for: .normal)
//        self.btnAddNewSpecification.titleLabel?.textColor = UIColor.themeColor
        self.imgItem.alpha = 0.3
        self.imgItem.backgroundColor = UIColor.black
        self.viewForProductItem.backgroundColor = UIColor.black
        
        //Set Fonts
        lblMakeVisible.font = FontHelper.textSmall()
        lblSpecifications.font = FontHelper.textRegular()
//        btnAddNewSpecification.titleLabel?.font = FontHelper.buttonText()
        txtSequenceNumber.font = FontHelper.textRegular()

        lblPrice.font = FontHelper.textRegular()
        lblInStock.font = FontHelper.textSmall()
        lblCurrency.font = FontHelper.textRegular()
        self.txtPrice.font = FontHelper.textRegular()
        self.lblOfferPrice.font = FontHelper.textRegular()
        self.lblOfferPriceCurrency.font = FontHelper.textRegular()
        lblTax.font = FontHelper.textRegular()
        lblSequenceNumber.font = FontHelper.textRegular()
        
        self.txtOfferMsg.font = FontHelper.textRegular()
        self.lblOfferMsg.font = FontHelper.textRegular()
        self.txtOfferPrice.font = FontHelper.textRegular()
        
        txtProductTitle.font = FontHelper.textRegular()
        txtItemName.font = FontHelper.textRegular()
        txtItemDesc.font = FontHelper.textRegular()
        
        txtProductTitle.delegate = self
        txtItemName.delegate = self
        txtItemDesc.delegate = self
        
        //self.tableSpecifications.estimatedRowHeight = 20
        self.tableSpecifications.rowHeight = UITableView.automaticDimension
        self.disableFields()

        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ItemListVC.isCallGetItemAPI = false
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: -
    //MARK: - Set data
    func setData() {
        DispatchQueue.main.async {
            self.txtItemName.text = self.itemDetail?.name
            self.txtItemDesc.text = self.itemDetail?.details
            self.txtProductTitle.text = self.selectedProductItem?.name
            self.swMakeVisible.setOn((self.itemDetail?.isVisibleInStore)!, animated: true)
            self.swInStock.setOn((self.itemDetail?.isItemInStock)!, animated: true)
            
            self.txtPrice.text = String(self.itemDetail!.price!)

//            if (self.itemDetail?.price) ?? 0.0 > 0.0 {
//                self.txtPrice.text = String(self.itemDetail!.price!)
//            }else {
//                self.txtPrice.text = ""
//            }
            
            self.txtTax.text = String(self.itemDetail!.tax!)

            
//            if (self.itemDetail?.tax) ?? 0.0 > 0.0 {
//                self.txtTax.text = String(self.itemDetail!.tax!)
//            }else {
//                self.txtTax.text = ""
//            }
            
            self.txtOfferPrice.text = String(self.itemDetail!.itemPriceWithoutOffer ?? 0.0)

//            if (self.itemDetail?.itemPriceWithoutOffer) ?? 0.0 > 0.0 {
//                self.txtOfferPrice.text = String(self.itemDetail!.itemPriceWithoutOffer ?? 0.0)
//            }else {
//                self.txtOfferPrice.text = ""
//            }
                
            if !((self.itemDetail?.offerMessageOrPercentage) ?? "").isEmpty() {
                self.txtOfferMsg.text = self.itemDetail!.offerMessageOrPercentage ?? ""
            }else {
                self.txtOfferMsg.text = ""
            }
            //Storeapp
            //        if (self.itemDetail?.sequence_number) ?? 0 > 0 {
            //              txtSequenceNumber.text = String(self.itemDetail!.sequence_number!)
            //          }else {
            //              txtSequenceNumber.text = ""
            //          }
            
            self.txtSequenceNumber.text = String(self.itemDetail!.sequence_number ?? 0)
            
            
            self.arrItemSpecification = (self.itemDetail?.specifications)!
            self.specificationsUniqueIdCount = (self.itemDetail?.specificationsUniqueIdCount)!
            if let url  = self.selectedProductItem?.imageUrl {
                self.imgItem.downloadedFrom(link:url)
            }
            
            for strurl:String in (self.itemDetail?.imageUrl)! {
                self.arrForItemImage.append(ItemImageViewer.init(url: strurl, image: nil,isForUpload:false)!)
            }
            if self.arrForItemImage.count > 0 {
                self.collectionForAddImage.reloadData()
                self.collectionForAddImage.isHidden = false
                self.collectionHeightConstraint.constant = 100
            }else {
                self.collectionForAddImage.isHidden = true
                self.collectionHeightConstraint.constant = 0
            }
            self.txtProductTitle.isUserInteractionEnabled = false
            self.reloadTableData()
            
        }
        
        
    }
    
    //MARK: -
    //MARK: - Button Click events
    
    @IBAction func onClickDismiss (_ sender: Any) {
        DispatchQueue.main.async {
            Utility.hideLoading()
            if self.isForEditItem {
                self.navigationController?.popViewController(animated: true)
            }else {
                self.navigationController?.popViewController(animated: false)
            }
        }
        
    }
    
    @IBAction func onClickAddPhoto(_ sender: Any) {
        self.view.endEditing(true)
    }
    override func btnLeftTapped(_ btn: UIButton = UIButton()) {
        self.navigationController?.popViewController(animated: true)
    }
    override func btnRightTapped(_ btn: UIButton = UIButton()) {
        DispatchQueue.main.async {
            if self.btnRight!.isSelected {
                if self.imgItem.image == nil {
                    Utility.showToast(message: "MSG_PLEASE_ITEM_IMAGE".localized)
                }else if (self.txtProductTitle.text?.isEmpty()) ?? true {
                    Utility.showToast(message: "MSG_PLEASE_SELECT_PRODUCT".localized)
                }else if (self.txtItemName.text?.isEmpty())! {
                    Utility.showToast(message: "MSG_PLEASE_ITEM_NAME".localized)
                }else if (self.txtPrice.text?.isEmpty())! {
                    Utility.showToast(message: "MSG_PLEASE_ITEM_PRICE".localized)
                }else {
                    if self.isForEditItem {
                        self.updateItem()
                    }
                    else {
                        self.setNewItemData()
                    }
                }
            }else {
                self.enableFields()
            }
        }
        
    }
    
    @IBAction func onClickIsVisible(sender:Any) {
        itemDetail?.isVisibleInStore = swMakeVisible.isOn
    }
    @IBAction func onClickIsInStock(sender:Any) {
        itemDetail?.isItemInStock = swInStock.isOn
    }
    
    
    @IBAction func onClickRemoveSpecifications (_ sender: Any) {
        let tag:NSInteger = (sender as! UIButton).tag
        self.removeSpecification(index: tag)
    }
    
    @IBAction func onClickAddSpecifications (_ sender: Any) {
        isForEditItemSpecification = false
        let arrToSend:NSMutableArray = []
        for specification in arrForSpecificationItemGroupOrignal {
            arrToSend.add(specification)
        }
        
        let arrRemove = NSMutableArray()
        
        //remove spec once added all added
        for objarrSend in arrToSend {
            let mainCount = (objarrSend as! ItemSpecification).list!.count
            var count = 0
            for selectedSpecification in arrItemSpecification{
                if selectedSpecification.isParentAssociate {
                    let obj = arrToSend.filter({($0 as! ItemSpecification).id == selectedSpecification.id})
                    arrRemove.add(obj[0])
                    continue
                } else if selectedSpecification.modifierGroupId == (objarrSend as! ItemSpecification).id {
                    count += 1
                    if count == mainCount {
                        if arrItemSpecification.filter({$0.id == selectedSpecification.id && $0.modifierGroupId == ""}).count > 0 {
                            let obj = arrToSend.filter({($0 as! ItemSpecification).id == selectedSpecification.id})
                            arrRemove.add(obj[0])
                            continue
                        }
                    }
                } else {
                    let arrCanAssociated = arrItemSpecification.filter({(($0.id != selectedSpecification.id) && ($0.type == 1 && !$0.isParentAssociate)) || ($0.type == 1 && $0.isParentAssociate)})
                    if arrCanAssociated.count == 0 {
                        let obj = arrToSend.filter({($0 as! ItemSpecification).id == selectedSpecification.id})
                        arrRemove.add(obj[0])
                    }
                }
                /*else if !selectedSpecification.isAssociated {
                    let obj = arrToSend.filter({($0 as! ItemSpecification).id == selectedSpecification.id})
                    arrRemove.add(obj[0])
                    continue
                }*/
            }
        }
        
        for obj in arrRemove {
            arrToSend.remove(obj)
        }
            
        if arrToSend.count > 0 {

        let dialogForSelectSpecificationGroup:CustomTableDialog = CustomTableDialog.showCustomTableDialog(withDataSource: arrToSend, cellIdentifier: CustomCellIdentifiers.cellForSpecificationGroup,title: "TXT_SELECT_SPECIFICATION_GROUP".localized)
        
        dialogForSelectSpecificationGroup.onItemSelected = {[unowned self, unowned dialogForSelectSpecificationGroup]
            (selectedItem:Any) in
            
            self.selectedProductGroupItem = ItemSpecification.init(fromDictionary: ((selectedItem as? ItemSpecification)?.toDictionary())!)
            self.goToItemSpecification()
            dialogForSelectSpecificationGroup .removeFromSuperview()
        }
        }else{
            Utility.showToast(message: "No specifications are left to add.")
        }
    }
    
    func saveSubItemDetail(_ item_spec: ItemSpecification?, parentSpec: ItemSpecification?, isEditedSpec: Bool) {
        
        if parentSpec != nil {
            for obj in arrItemSpecification {
                if obj.id == parentSpec!.id {
                    obj.isParentAssociate = parentSpec!.isParentAssociate
                    break
                }
            }
        }
        if isEditedSpec {
            arrItemSpecification[selectedIndex] = item_spec!
        }else {
            arrItemSpecification.append(item_spec!)
        }
        reloadTableData()
    }
    
    func deleteAndReplace(_ item_spec: ItemSpecification?) {
        self.arrItemSpecification = self.arrItemSpecification.filter({$0.modifierGroupId != item_spec!.id && item_spec?.id != $0.id})
        arrItemSpecification.append(item_spec!)
        reloadTableData()
    }
    
    
    // MARK: - Settings
    func enableFields() {
        if !isForEditItem {
            self.txtProductTitle.isUserInteractionEnabled = true
        }
        self.collectionForAddImage.isUserInteractionEnabled  = true
        self.txtItemName.isUserInteractionEnabled = true
        self.txtItemDesc.isUserInteractionEnabled = true
        self.txtPrice.isUserInteractionEnabled = true
        collectionHeightConstraint.constant = 100
        collectionForAddImage.isHidden = false
        collectionForAddImage.reloadData()
        self.swMakeVisible.isUserInteractionEnabled = true
        self.swInStock.isUserInteractionEnabled = true
        self.btnRight?.isSelected = true
        self.tableSpecifications.allowsSelection = true
        self.btnAddNewSpecification.isUserInteractionEnabled = true
        self.txtOfferPrice.isUserInteractionEnabled = true
        self.txtOfferMsg.isUserInteractionEnabled = true
        self.txtTax.isUserInteractionEnabled = true
        self.txtSequenceNumber.isUserInteractionEnabled = true
        self.tableSpecifications.isUserInteractionEnabled = true
        self.collVTax.isUserInteractionEnabled = true

        self.reloadTableData()
    }
    func disableFields() {
        self.collectionForAddImage.isUserInteractionEnabled  = false
        self.txtProductTitle.isUserInteractionEnabled = false
        self.txtItemName.isUserInteractionEnabled = false
        self.txtItemDesc.isUserInteractionEnabled = false
        self.txtPrice.isUserInteractionEnabled = false
        self.txtTax.isUserInteractionEnabled = false
        self.txtSequenceNumber.isUserInteractionEnabled = false
        self.btnAddNewSpecification.isUserInteractionEnabled = false

        self.swMakeVisible.isUserInteractionEnabled = false
        self.swInStock.isUserInteractionEnabled = false
        self.txtOfferPrice.isUserInteractionEnabled = false
        self.txtOfferMsg.isUserInteractionEnabled = false
        self.btnRight?.isSelected = false
        self.tableSpecifications.allowsSelection = false
        self.tableSpecifications.isUserInteractionEnabled = false
        self.collVTax.isUserInteractionEnabled = false

        self.reloadTableData()
    }
    
    
    // MARK:
    //MARK: - UITextField delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == self.txtProductTitle {
            self.view.endEditing(true)
            
            if arrProductList.count > 0 {
                let arrForSend:NSMutableArray = []
                for product in arrProductList {
                    arrForSend.add(product)
                }
                
                
                let dialogForProductList:CustomTableDialog = CustomTableDialog.showCustomTableDialog(withDataSource: arrForSend, cellIdentifier: CustomCellIdentifiers.cellForProductList,title: "TXT_SELECT_PRODUCT_CATEGORY".localized)
                
                dialogForProductList.onItemSelected = {[unowned self, unowned dialogForProductList]
                    (selectedItem:Any) in
                    self.selectedProductItem = selectedItem as? ProductListItem
                    self.imgItem.downloadedFrom(link: (self.selectedProductItem?.imageUrl) ?? "")
                    dialogForProductList .removeFromSuperview()
                    
                    self.txtProductTitle.text = (self.selectedProductItem?.name)!
                }
            }else {
                Utility.showToast(message: "MSG_PLEASE_FIRST_ADD_PRODUCT_CATEGORIES".localized);
            }
            return false
        }
        if textField == self.txtItemName {
            self.openLocalizedLanguagDialog(textFiled: txtItemName)
            return false
        }
        if textField == self.txtItemDesc {
            self.openLocalizedLanguagDialog(textFiled: txtItemDesc)
            return false
        }
        return true
    }
    
    func openLocalizedLanguagDialog(textFiled: UITextField)
    {
        self.view.endEditing(true)
        if textFiled == txtItemName {
            
            //JAnki
            //            itemDetail?.nameLanguages[selectedLanguage] = txtItemName.text
            
            //Janki: Replace this
            
            //Janki: Needs to change
            //            let dialogForLocalizedLanguage = CustomActiveLanguageDialog.showCustomLanguageDialog(languages: (itemDetail?.nameLanguages) ?? [:], title: txtItemName.placeholder ?? "")
            
            //let  arrForLanguages:[String:String] = ["English" : "en","عربى": "ar", "Française": "fr"]
            print(itemDetail!.nameLanguages)
            
            //            let dialogForLocalizedLanguage = CustomActiveLanguageDialog.showCustomLanguageDialog(languages: arrForLanguages, title: txtItemName.placeholder ?? "")
            
            let dialogForLocalizedLanguage = CustomActiveLanguageDialog.showCustomLanguageDialog(languages: [:], title: txtItemName.placeholder ?? "",nameLang: itemDetail!.nameLanguages)
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
                self.itemDetail?.nameLanguages = namelang
                self.txtItemName.text = self.itemDetail?.nameLanguages[ConstantsLang.StoreLanguageIndexSelected]
                
                //                self.itemDetail?.nameLanguages = selectedArray
                //                self.txtItemName.text = self.itemDetail?.nameLanguages[ConstantsLang.StoreLanguageIndexSelected]
                
                dialogForLocalizedLanguage.removeFromSuperview()
                
            }
        } else {
            
            print(itemDetail!.detailsLanguage)
            
            //Janki: Needs to change
            
            // itemDetail?.detailsLanguage[ConstantsLang.StoreLanguageIndexSelected] = txtItemDesc.text!
            
            //            let  arrForLanguages:[String:String] = ["English" : "en","عربى": "ar", "Française": "fr"]
            //            let dialogForLocalizedLanguage = CustomActiveLanguageDialog.showCustomLanguageDialog(languages: arrForLanguages, title: txtItemDesc.placeholder ?? "")
            //          dialogForLocalizedLanguage.onItemSelected = { (selectedArray) in
            ////              self.itemDetail?.detailsLanguage = selectedArray
            ////              self.txtItemDesc.text = self.itemDetail?.detailsLanguage[selectedLanguage]
            //              dialogForLocalizedLanguage.removeFromSuperview()
            //          }
            
            //            itemDetail?.detailsLanguage[selectedLanguage] = txtItemDesc.text
            //            let dialogForLocalizedLanguage = CustomActiveLanguageDialog.showCustomLanguageDialog(languages: (itemDetail?.detailsLanguage) ?? [:], title: txtItemDesc.placeholder ?? "")
            //            dialogForLocalizedLanguage.onItemSelected = { (selectedArray) in
            //                self.itemDetail?.detailsLanguage = selectedArray
            //                self.txtItemDesc.text = self.itemDetail?.detailsLanguage[selectedLanguage]
            //                dialogForLocalizedLanguage.removeFromSuperview()
            //            }
            
            let dialogForLocalizedLanguage = CustomActiveLanguageDialog.showCustomLanguageDialog(languages: [:], title: txtItemDesc.placeholder ?? "",nameLang: itemDetail!.detailsLanguage)
            dialogForLocalizedLanguage.onItemSelected = { (selectedArray) in
                
                print(selectedArray)
                var detailslang = [String]()
                var count : Int = 0
                if ConstantsLang.storeLanguages.count > 0{
                    for i in 0...ConstantsLang.storeLanguages.count-1
                    {
                        count = 0
                        for j in 0...selectedArray.count-1
                        {
                            if Array(selectedArray.keys)[j] == ConstantsLang.storeLanguages[i].code{
                                detailslang.append(selectedArray[ConstantsLang.storeLanguages[i].code]!)
                                count = 1
                            }
                        }
                        if count == 0{
                            detailslang.append("")
                        }
                    }
                }
                print("detailslang \(detailslang)")
                self.itemDetail?.detailsLanguage = detailslang
                self.txtItemDesc.text = self.itemDetail?.detailsLanguage[ConstantsLang.StoreLanguageIndexSelected]
                
                dialogForLocalizedLanguage.removeFromSuperview()
            }
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtPrice || textField == txtOfferPrice {
            if  (string == "") || string.count < 1 {
                return true
            }
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let decimalRegex = try! NSRegularExpression(pattern: "^\\d*\\.?\\d{0,2}$", options: [])
            let matches = decimalRegex.matches(in: newString, options: [], range: NSMakeRange(0, newString.count))
            if matches.count == 1 {
                return true
            }
            return false
        }
        
        return true;
    }
    //MARK: -
    //MARK: - Custom web service methods
    
    func updateItem() {
        self.arrForUploadItemImage.removeAll()
        for item in self.arrForItemImage {
            if item.isForUpload! {
                arrForUploadItemImage.append(item.image!)
            }
        }
        self.wsUpdateItem()
        
        
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == SEGUE.ADD_ITEM_SPECIFICATIONS {
            let toViewController = segue.destination as! AddItemSpecificationVC
            toViewController.delegate = self as SendSubItemDetailDelegate
            toViewController.arrSavedProductSpecification = arrItemSpecification
            if ((sender as? ItemSpecification) != nil) {
                if isForEditItemSpecification
                {
                    toViewController.isForEditSpecification = true
                }
                else
                {
                    toViewController.isForEditSpecification = false
                }
                toViewController.specificationOrignalDetail = sender as? ItemSpecification
            }
            
        }
    }
    
    @IBAction func onClickAddImage(_ sender: UIButton) {
        
        dialogForImage =  CustomPhotoDialog.showPhotoDialog("TXT_SELECT_IMAGE".localized, andParent: self, leftTitle: "TXT_GALLERY".localized, rightTitle: "TXT_CAMERA".localized, isCropRequired: false)
        
        dialogForImage?.onImageSelected = { [unowned self] (image:UIImage) in
            
            if Utility.checkImageSize(image: image, maxWidth: self.maxWidth, maxHeight: self.maxHeight, minWidth: self.minWidth, minHeight: self.minHeight) {
                
                self.arrForItemImage.append(ItemImageViewer.init(url: "", image: image,isForUpload: true)!)
                self.collectionForAddImage.reloadData()
                
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
                    self.arrForItemImage.append(ItemImageViewer.init(url: "", image: image,isForUpload: true)!)
                    self.collectionForAddImage.reloadData()
                }
                
            }
        }
    }
    
    //Web Services
    func wsGetImageSettings() {
        let dictParam = [String:String]()
        Utility.showLoading()
        let alamofire = AlamofireHelper.init()
        alamofire.getResponseFromURL(url: WebService.WS_GET_IMAGE_SETTING, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam, block: { (response, error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response) {
                let imageSettingResponse:ImageSettingResponse = ImageSettingResponse.init(fromDictionary: response)
                self.maxWidth = imageSettingResponse.imageSetting.itemImageMaxWidth
                self.minWidth = imageSettingResponse.imageSetting.itemImageMinWidth
                self.maxHeight = imageSettingResponse.imageSetting.itemImageMaxHeight
                self.minHeight = imageSettingResponse.imageSetting.itemImageMinHeight
            }
            
        })
    }
    func wsUpdateItemImage() {
        Utility.showLoading();
        
        let dictParam : [String : String] =
            [PARAMS.ITEM_ID:(itemDetail?.id)!,
             PARAMS.STORE_ID: preferenceHelper.getUserId(),
             PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken()]
        
        let alamoFire:AlamofireHelper = AlamofireHelper.init()
        
        
        alamoFire.getResponseFromURL(url: WebService.WS_UPLOAD_ITEM_IMAGE, paramData: dictParam, images: arrForUploadItemImage, block: { (response, error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response) {
                if self.arrForDeleteItemImage.count > 0 && self.isForEditItem {
                    self.wsDeleteItemImage()
                }
                else {
                    self.onClickDismiss(self)
                }
            }
        })
    }
    func wsDeleteItemImage() {
        Utility.showLoading();
        let dictParam : [String : Any] =
            [PARAMS._ID:(itemDetail?.id)!,
             PARAMS.STORE_ID: preferenceHelper.getUserId(),
             PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken(),
             PARAMS.IMAGE_URL: arrForDeleteItemImage]
        
        let alamoFire:AlamofireHelper = AlamofireHelper.init()
        
        alamoFire.getResponseFromURL(url: WebService.WS_DELETE_ITEM_IMAGE, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response) {
                
                self.onClickDismiss(self)
                
            }
        }
        
    }
    func wsUpdateItem() {
        
        
        Utility.showLoading();
        itemDetail?.specifications = arrItemSpecification
        itemDetail?.specificationsUniqueIdCount = specificationsUniqueIdCount
        itemDetail?.details = txtItemDesc.text
        itemDetail?.name = txtItemName.text
        itemDetail?.price = txtPrice.text?.doubleValue
        itemDetail?.isItemInStock = swInStock.isOn
        itemDetail?.isVisibleInStore = swMakeVisible.isOn
        itemDetail?.itemPriceWithoutOffer = (txtOfferPrice.text?.doubleValue) ?? 0.0
        itemDetail?.offerMessageOrPercentage = txtOfferMsg.text
//        itemDetail?.tax = txtTax.text?.doubleValue ?? 0.0
        itemDetail?.sequence_number = txtSequenceNumber.text?.integerValue ?? 0

        itemDetail?.itemTaxes.removeAll()
        for obj in self.arrTax{
            if obj.isTaxSelected {
                itemDetail?.itemTaxes.append(obj.id)
            }
        }
        print(self.itemDetail?.itemTaxes)

        var dictParam : [String : Any] = (itemDetail?.toDictionary())!
        dictParam.updateValue(preferenceHelper.getUserId(), forKey: PARAMS.STORE_ID)
        dictParam.updateValue(preferenceHelper.getSessionToken(), forKey: PARAMS.SERVER_TOKEN)
        dictParam.updateValue(dictParam[PARAMS._ID] ?? "", forKey: PARAMS.ITEM_ID)
        
        print(Utility.conteverDictToJson(dict: dictParam))
        ItemListVC.isCallGetItemAPI = true
        
        let alamoFire:AlamofireHelper = AlamofireHelper.init()
        alamoFire.getResponseFromURL(url: WebService.WS_UPDATE_ITEM, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            Utility.hideLoading()
            print(response)
            
            if Parser.isSuccess(response: response) {
                if self.arrForUploadItemImage.count > 0 {
                    self.wsUpdateItemImage()
                }
                else {
                    if self.arrForDeleteItemImage.count > 0
                    {
                        self.wsDeleteItemImage()
                    }
                    else
                    {
                        self.onClickDismiss(self)
                    }
                    
                }
            }
        }
    }
    
    func wsGetSpecificationGroup() {
        Utility.showLoading();
        let dictParam : [String : Any] = [PARAMS.STORE_ID:preferenceHelper.getUserId(), PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken()];
        let alamoFire:AlamofireHelper = AlamofireHelper.init()
        
        alamoFire.getResponseFromURL(url: WebService.WS_GET_PRODUCT_SPECIFICATION_GROUP, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            Utility.hideLoading()
            print("WS_GET_PRODUCT_SPECIFICATION_GROUP \(response)")
            
            if Parser.isSuccess(response: response) {
                let spGrpRes:SpecificationGroupAddItemResponse = SpecificationGroupAddItemResponse.init(fromDictionary: response)
                self.arrForSpecificationItemGroupOrignal = spGrpRes.specificationGroup
            }
        }
    }
    
    func wsAddItem() {
        Utility.showLoading();
        itemDetail?.tax = txtTax.text?.doubleValue ?? 0.0
        itemDetail?.sequence_number = txtSequenceNumber.text?.integerValue ?? 0
        
        var dictParam : [String : Any] = (itemDetail?.toDictionary())!
        dictParam.updateValue(preferenceHelper.getUserId(), forKey: PARAMS.STORE_ID)
        dictParam.updateValue(preferenceHelper.getSessionToken(), forKey: PARAMS.SERVER_TOKEN)
        print(Utility.conteverDictToJson(dict: dictParam))
        let alamoFire:AlamofireHelper = AlamofireHelper.init()
        
        ItemListVC.isCallGetItemAPI = true
        alamoFire.getResponseFromURL(url: WebService.WS_ADD_ITEM, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response) {
                self.itemDetail = Item.init(fromDictionary: response["item"] as! [String:Any])
                if self.arrForUploadItemImage.count > 0 {
                    self.wsUpdateItemImage()
                }
                else {
                    self.onClickDismiss(self)
                }
            }
        }
        
    }
    func setNewItemData() {
        itemDetail?.details = txtItemDesc.text
        itemDetail?.name = txtItemName.text
        itemDetail?.productId = selectedProductItem?.id
        itemDetail?.price = txtPrice.text?.doubleValue
        itemDetail?.isItemInStock = swInStock.isOn
        itemDetail?.isVisibleInStore = swMakeVisible.isOn
        itemDetail?.specificationsUniqueIdCount = specificationsUniqueIdCount
        itemDetail?.specifications = arrItemSpecification
        itemDetail?.itemPriceWithoutOffer = txtOfferPrice.text?.doubleValue
        itemDetail?.offerMessageOrPercentage = txtOfferMsg.text
        

        self.arrForUploadItemImage.removeAll()
        for item in self.arrForItemImage {
            if item.isForUpload! {
                arrForUploadItemImage.append(item.image!)
            }
        }
        wsAddItem()
    }
    func goToItemSpecification() {
        
        var finalItemSpecificationModel:ItemSpecification? = nil;
        if isForEditItemSpecification {
            let itemSpecificationModel:ItemSpecification = arrItemSpecification[selectedIndex]
            let arrForItemGroupSpecificationList:[List] = itemSpecificationModel.list
            
            arrForItemGroupSpecificationList.filter({$0.isUserSelected == false}).forEach { $0.isUserSelected = true }
            
            let selectedProductGroupItem =  arrForSpecificationItemGroupOrignal.first(where: { $0.id == itemSpecificationModel.id})
            
            let arrForProductItemGroupSpecificationList:[List] = (selectedProductGroupItem?.list) ?? itemSpecificationModel.list
            finalItemSpecificationModel = ItemSpecification.init(fromDictionary: itemSpecificationModel.toDictionary())
            
            
            var filteredArray:[List] = arrForItemGroupSpecificationList
            filteredArray.append(contentsOf:
                arrForProductItemGroupSpecificationList.filter {
                    item in
                    !(arrForItemGroupSpecificationList.contains(where: { $0.id == item.id }))
            })
            finalItemSpecificationModel?.list = filteredArray
            
            
        }else {
            finalItemSpecificationModel = selectedProductGroupItem
        }
        
        self.performSegue(withIdentifier: SEGUE.ADD_ITEM_SPECIFICATIONS, sender: finalItemSpecificationModel)
    }
    
    func removeSpecification(index: Int) {

        let obj = arrItemSpecification[index]
        
        if obj.isParentAssociate {
            let dialogForUpdateApp = CustomAlertDialog.showCustomAlertDialog(title: "TXT_ATTENTION".localized, message: "txt_deleting_conflict_modifier".localized, titleLeftButton: "TXT_EXIT".localizedUppercase, titleRightButton: "TXT_REMOVE".localizedUppercase)
            
            dialogForUpdateApp.onClickLeftButton = { [weak dialogForUpdateApp] in
                dialogForUpdateApp?.removeFromSuperview()
            }
            
            dialogForUpdateApp.onClickRightButton = { [weak self] in
                guard let self = self else { return }
                self.arrItemSpecification.remove(at: index)
                self.arrItemSpecification = self.arrItemSpecification.filter({$0.modifierGroupId != obj.id})
                dialogForUpdateApp.removeFromSuperview()
                self.reloadTableData()
            }
        } else if obj.isAssociated {
            arrItemSpecification.remove(at: index)
            let arrGropAssociated = arrItemSpecification.filter({($0.modifierGroupId == obj.modifierGroupId) && $0.isAssociated})
            if arrGropAssociated.count == 0 {
                if let parentAssociate = arrItemSpecification.first(where: {$0.id == obj.modifierGroupId && $0.isParentAssociate}) {
                    parentAssociate.isParentAssociate = false
                    parentAssociate.modifierGroupId = ""
                    parentAssociate.modifierName = ""
                    parentAssociate.modifierGroupName = ""
                    parentAssociate.modifierId = ""
                    parentAssociate.isAssociated = false
                }
            }
            print(arrGropAssociated.count)
            self.reloadTableData()
        } else {
            arrItemSpecification.remove(at: index)
        }
        
        self.reloadTableData()
    }
}
extension AddItemVC:UITableViewDelegate,UITableViewDataSource {
    //MARK: -
    //MARK: - UITableview delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrItemSpecification.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:SpecificationCell?
        
        cell = tableView.dequeueReusableCell(withIdentifier: "SpecificationCell", for: indexPath) as? SpecificationCell
        
        
        if (cell == nil) {
            cell = UITableViewCell(style: .default, reuseIdentifier: "SpecificationCell") as? SpecificationCell
        }
        
        if self.self.btnRight!.isSelected {
            cell?.isCellSelected = true
        }else {
            cell?.isCellSelected = false
        }
        
        cell?.btnRemoveSpecification.addTarget(self, action: #selector(onClickRemoveSpecifications), for: .touchUpInside)
        
        let itemSpecification = arrItemSpecification[indexPath.row]
        cell?.btnRemoveSpecification.tag = indexPath.row
        cell?.btnRemoveSpecification.isSelected = self.btnRight!.isSelected
        //Storeapp sequence_number
        let item:ProductDisplaySpecification = ProductDisplaySpecification.init(name: itemSpecification.name, id:String(itemSpecification.id), index: indexPath.row, price: itemSpecification.price ?? 0.0, nameLanguages: itemSpecification.nameLanguages, sequence_number: itemSpecification.sequence_number ?? 0, modifierGroupName: itemSpecification.modifierGroupName)!
        item.modifierName = itemSpecification.modifierName
        item.modifierGroupName = itemSpecification.modifierGroupName
        cell?.setCellData(data: item)
        
        
        return cell!
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedIndex = indexPath.row
        isForEditItemSpecification = true
        self.goToItemSpecification()
        
        
    }
    func reloadTableData() {
        tableSpecifications.tableFooterView = UIView()
        self.tableSpecifications.reloadData()
//        tableHeightConstraint.constant = self.tableSpecifications.contentSize.height-10
        
        tableHeightConstraint.constant = preferredContentSize.height
    }
}

extension AddItemVC: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    //MARK: UICollectionViewDataSource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collVTax{
            return arrTax.count
        }else{
            return arrForItemImage.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collVTax{
            let cell:EasyAmountCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EasyAmountCell", for: indexPath) as! EasyAmountCell
            cell.lblAmount.text =  " \(StoreSingleton.shared.returnStringAccordingtoLanguage(arrStr: arrTax[indexPath.row].taxName)) \(arrTax[indexPath.row].tax!)% "

            if arrTax[indexPath.item].isTaxSelected{
                cell.lblAmount.textColor = UIColor.white
                cell.lblAmount.backgroundColor = UIColor.themeColor
            }else{
                cell.lblAmount.textColor = UIColor.themeLightTextColor
                cell.lblAmount.backgroundColor = .clear
            }
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellForAddImage", for: indexPath) as! ImageCollectionViewCell
        let isForUpload = arrForItemImage[indexPath.row].isForUpload ?? false
        
        if !isForUpload {
            cell.imgCollection.downloadedFrom(link: arrForItemImage[indexPath.row].url!,mode: .scaleAspectFit)
        }else {
            cell.imgCollection.image = arrForItemImage[indexPath.row].image!
        }
        cell.btnDeleteImage.tag = indexPath.row
        cell.btnDeleteImage.addTarget(self, action:#selector(AddItemVC.deleteImage(sender:)
            ), for: .touchUpInside)
        
        return cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == collVTax{
            return UIView() as! UICollectionReusableView
        }else{
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footerId", for: indexPath)
            return footerView
        }
    }
    
    //MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collVTax{
            collectionView.deselectItem(at: indexPath, animated: true)
            arrTax[indexPath.item].isTaxSelected = !arrTax[indexPath.item].isTaxSelected
            
            DispatchQueue.main.async {
                self.collVTax.reloadData()
                self.collVTaxHeight.constant = self.collVTax.contentSize.height;
                self.collVTax.layoutIfNeeded()

            }
        }
    }
    
    func reloadCollectionView() {
        collectionForAddImage.reloadData()
    }
    
    @objc func deleteImage(sender:UIButton) {
        if (arrForItemImage[sender.tag].url?.isEmpty())! {
            arrForItemImage.remove(at: sender.tag)
        }else {
            arrForDeleteItemImage.append(arrForItemImage[sender.tag].url!)
            arrForItemImage.remove(at: sender.tag)
            
        }
        reloadCollectionView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collVTax{
            print(CGSize.init(width: String(" \(StoreSingleton.shared.returnStringAccordingtoLanguage(arrStr: arrTax[indexPath.row].taxName)) \(arrTax[indexPath.row].tax!)% ").size(withAttributes: nil).width, height: 35))
            return CGSize.init(width: String(" \(StoreSingleton.shared.returnStringAccordingtoLanguage(arrStr: arrTax[indexPath.row].taxName)) \(arrTax[indexPath.row].tax!)% ").size(withAttributes: nil).width + 20, height: 35)
        }else{
           return CGSize(width: 100, height:100)
        }
    }
    
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView != collVTax{
            return 8.0
        }
        return 0.0
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
            if ((touch.view?.isDescendant(of: self.collVTax)) != nil) {
                self.view.endEditing(true)
                return false
            } else {
                return true
            }
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        if collectionView == collVTax{
//            return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
//        }else{
//            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        }
//    }
    
}



class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var btnDeleteImage: UIButton!
    @IBOutlet weak var imgCollection: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        self.imgCollection.clipsToBounds = true
        self.imgCollection.setRound(withBorderColor: .themeLightTextColor, andCornerRadious: 5.0, borderWidth: 0.5)

    }
}

class ItemImageViewer {
    public var url : String?
    public var image : UIImage?
    public var isForUpload : Bool?
    
    required public init?(url:String,image:UIImage?,isForUpload:Bool = false) {
        self.url =  url
        self.image = image
        self.isForUpload = isForUpload
    }
}

/*
class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes
                guard let collectionView = collectionView else { return attributes }
                attributes?.bounds.size.width = collectionView.bounds.width - sectionInset.left - sectionInset.right
                return attributes
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)

        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            layoutAttribute.frame.origin.x = leftMargin

            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }

        return attributes
    }
}*/
