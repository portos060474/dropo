//
//  FavStoreVC.swift
//  edelivery
//
//  Created by tag on 07/03/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//


import UIKit

class FavStoreVC: BaseVC,RightDelegate, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
   
    func onClickRightButton() {
        wsRemoveFavStore()
    }
    
    // MARK: - OUTLET
    @IBOutlet weak var imgEmpty: UIImageView!
    @IBOutlet weak var viewStoreList: UIView?
    @IBOutlet weak var collViewStoreList: UICollectionView?
    @IBOutlet weak var lblStoreListTitle: UILabel!
    
    //MARK: OutLets
    
    let btnDelete = UIButton.init(type: .custom)
    var arrForFavStoreList:[StoreItem] = []
    var password:String = ""
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalization()
        wsGetFavStoreList()
        self.btnDelete.setTitle(" " + "".localized + " ", for: UIControl.State.normal)
        self.btnDelete.sizeToFit()
        self.btnDelete.titleLabel?.font = FontHelper.cartText()
        self.btnDelete.setImage(UIImage.init(named: "doneIcon")?.imageWithColor(color: .themeColor), for: .normal)
        self.setRightBarButton(button: self.btnDelete)
        self.setNavigationTitle(title: "TXT_FAVOURITE_STORE".localizedCapitalized)
        
        /* Store Cell Collectionview Setup */
        collViewStoreList?.backgroundColor = UIColor.themeViewBackgroundColor
        collViewStoreList?.isUserInteractionEnabled = true
        collViewStoreList?.showsHorizontalScrollIndicator = false
        collViewStoreList?.delegate = self
        collViewStoreList?.dataSource = self
        collViewStoreList?.register(cellType: StoreCell.self)
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        Utility.hideLoading()
         self.setBackBarItem(isNative: true)
    }
    override func updateUIAccordingToTheme() {
         self.setBackBarItem(isNative: true)
    }
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        
        
    btnDelete.setRound(withBorderColor: UIColor.clear, andCornerRadious: 7.0, borderWidth: 1.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool){
        super.viewDidDisappear(animated)
    }
    
    func setLocalization(){
       delegateRight = self
       updateUI(isUpdate:false)
       lblStoreListTitle.font = FontHelper.textMedium(size: FontHelper.large)
       lblStoreListTitle.text = "TXT_STORE".localized
       lblStoreListTitle.textColor = UIColor.themeTextColor
       lblStoreListTitle.isHidden = true
   }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return arrForFavStoreList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell:StoreCell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreCell", for: indexPath) as! StoreCell
            let currentStore:StoreItem = arrForFavStoreList[indexPath.row]
            cell.setCellData(cellItem: currentStore, isFromFavStore: true)
            return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let selectedStore:StoreItem = arrForFavStoreList[indexPath.row]
        self.goToProductVC(selectedStore: selectedStore)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.collViewStoreList {
            var width:CGFloat = 0.0
            var height:CGFloat = 0.0
            if UIDevice.current.userInterfaceIdiom == .pad {
                width = collectionView.frame.size.width
                width -= (collectionView.contentInset.left+collectionView.contentInset.right)
                width -= 45.0
                width = width/2.0
                height =  450.0
            }
            else {
                width = collectionView.frame.size.width
                width -= (collectionView.contentInset.left+collectionView.contentInset.right)
                width -= 45.0
                width = width/2.0
                height =  width/0.8
            }
            return CGSize(width: width, height: height)
        } else {
            return CGSize(width: 100.0, height: 100.0)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView ==  collViewStoreList {
            return 5.0
        } else {
            return 10.0
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == collViewStoreList {
            return UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
        } else {
            return UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 0.0)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == collViewStoreList {
            return 0.0
        } else {
            return 0.0
        }
    }

    func goToProductVC(selectedStore:StoreItem) {
        let productVc : ProductVC = ProductVC.init(nibName: "Product", bundle: nil)
        productVc.selectedStore = selectedStore
        productVc.isFromDeliveryList = false
        productVc.isShowGroupItems = selectedStore.is_store_can_create_group!
        var isIndexMatch : Bool = false
        var selectedInd : Int = 0

        if preferenceHelper.getSelectedLanguageCode() != Constants.selectedLanguageCode{
            Constants.selectedLanguageCode = preferenceHelper.getSelectedLanguageCode()
        }

        if arrForFavStoreList != nil && arrForFavStoreList.count > 0{
            for obj in arrForFavStoreList[0].langItems!{
                if (obj.code == Constants.selectedLanguageCode) && (obj.is_visible! == true){
                    isIndexMatch = true
                    selectedInd = selectedStore.langItems!.index(where: { $0.code == obj.code })!
                    break
                } else {
                    isIndexMatch = false
                }
            }
        } else {
            isIndexMatch = false
        }

        if !isIndexMatch {
           productVc.languageCode = "en"
           productVc.languageCodeInd = "0"
        } else {
           productVc.languageCode = Constants.selectedLanguageCode
           productVc.languageCodeInd = "\(selectedInd)"
        }
        self.navigationController?.pushViewController(productVc, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

    func updateUI(isUpdate:Bool = false) {
        imgEmpty.isHidden = isUpdate
        btnDelete.isHidden = !isUpdate
    }

    //MARK: - WEB SERVICE CALLS
    func wsGetFavStoreList(){
        Utility.showLoading()
        let dictParam: Dictionary<String,Any> =
            [PARAMS.USER_ID:preferenceHelper.getUserId(),
             PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken()]

        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_GET_FAVOURITE_STORE_LIST, methodName: "POST", paramData: dictParam) {(respons, error) -> (Void) in
            Utility.hideLoading()
            self.arrForFavStoreList = Parser.parseFavouriteStoreList(respons)
            if self.arrForFavStoreList.count > 0 {
                DispatchQueue.main.async {
                    self.updateUI(isUpdate:true)
                }
            } else {
                self.updateUI(isUpdate:false)
            }
            self.collViewStoreList?.reloadData()
            for vc in self.navigationController?.viewControllers ?? [] {
                if vc is MainVC {
                    let childVCs = (vc as! MainVC).children
                    for vc in childVCs {
                        if vc is HomeVC {
                            (vc as! HomeVC).isChangeInFavorite = true
                        }
                    }
                }
            }
        }
    }

    func openVerifyAccountDialog() {
        self.view.endEditing(true)

        if !preferenceHelper.getSocialId().isEmpty() {
            self.password = ""
        } else {
            let dialogForVerification = CustomVerificationDialog.showCustomVerificationDialog(title: "TXT_VERIFY_ACCOUNT".localized, message: "MSG_PLEASE_ENTER_CURRENT_PASSWORD".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_OK".localized, editTextOneHint: "TXT_PASSWORD".localized, editTextTwoHint: "", isEdiTextTwoIsHidden: true, editTextOneInputType: true)
            dialogForVerification.onClickLeftButton = { [unowned dialogForVerification] in
                dialogForVerification.removeFromSuperview()
            }
            dialogForVerification.onClickRightButton = { [unowned self, unowned dialogForVerification] (text1:String,text2:String) in
                let validPassword = text1.checkPasswordValidation()
                if validPassword.0 == false {
                    Utility.showToast(message: validPassword.1)
                } else {
                    self.password = text1
                    self.wsRemoveFavStore()
                    dialogForVerification.removeFromSuperview()
                }
            }
        }
    }

    func wsRemoveFavStore() {
        var arrForDeleting:[String] = []
        for store in arrForFavStoreList {
            if store.isSelectedToDelete {
                arrForDeleting.append(store._id ?? "")
            }
        }

        if arrForDeleting.count > 0 {
            Utility.showLoading()
            let dictParam : [String : Any] =
            [PARAMS.USER_ID : preferenceHelper.getUserId(),
             PARAMS.STORE_ID: arrForDeleting
            ]

            let alamoFire:AlamofireHelper = AlamofireHelper()
            alamoFire.getResponseFromURL(url: WebService.WS_REMOVE_FAVOURITE_STORE, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
                Utility.hideLoading()
                if Parser.isSuccess(response:response) {
                    self.wsGetFavStoreList()
                }
            }
        } else {
            Utility.showToast(message: "MSG_NO_ITEM_TO_DELETE".localized)
        }
    }
}
