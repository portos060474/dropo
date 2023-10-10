//
//  ProductSpecificationsVC.swift
//  Store
//
//  Created by Jaydeep Vyas on 03/03/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class ProductCatGroupVC: BaseVC,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnEditSpecificationGroup: UIButton!
    @IBOutlet weak var tblSpecificationsGroups: UITableView!
    @IBOutlet weak var footeView: UIView!

    let btnCancelOrder = UIButton.init(type: .custom)
    var arrForDisplayCatGroupItems = [CategoryProductGroup]()
    var arrForAddItems = [[String]]()
    var arrForDeleteItems = [String]()
    var isDeleteBtnShow:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLocalization()

        self.tblSpecificationsGroups.rowHeight = UITableView.automaticDimension;
        self.tblSpecificationsGroups.estimatedRowHeight = 60.0;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.wsGetProductCategoryGroup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
   
    func setLocalization() -> Void {
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        self.setNavigationTitle(title: "TXT_PRODUCT_CATEGORY_GROUP".localized)
        super.hideBackButtonTitle()
        
        btnCancelOrder.setImage(UIImage.init(named: "cancelIcon")?.imageWithColor(color: .themeColor), for: .normal)
        btnCancelOrder.setImage(UIImage.init(named: "correct")?.imageWithColor(color: .themeColor), for: .selected)

//        btnCancelOrder.titleLabel?.font = FontHelper.textSmall()
        btnCancelOrder.sizeToFit()
//        btnCancelOrder.backgroundColor = UIColor.white
//        btnCancelOrder.setTitleColor(UIColor.themeNavigationBackgroundColor, for: .normal)
        btnCancelOrder.addTarget(self, action: #selector(onClickRightButton), for: .touchUpInside)
        btnEditSpecificationGroup.backgroundColor = .themeColor
        btnEditSpecificationGroup.setRound(withBorderColor: .clear, andCornerRadious: btnEditSpecificationGroup.frame.size.height/2, borderWidth: 1.0)
        self.setRightBarButton(button: btnCancelOrder);
//        btnAdd.setTitleColor(.themeColor, for: .normal)
    }
    
    @objc func onClickRightButton() {
        isDeleteBtnShow = !isDeleteBtnShow
        btnCancelOrder.isSelected = !btnCancelOrder.isSelected
     
        self.tblSpecificationsGroups.reloadData()
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func updateUIAccordingToTheme() {
        tblSpecificationsGroups.reloadData()
    }
    
    //MARK: -
    //MARK: - UITableview delegate
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrForDisplayCatGroupItems.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
            return 1;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        isDeleteBtnShow = false
        self.tblSpecificationsGroups.reloadData()

        let vc : CategoryListGroupVC = storyboard?.instantiateViewController(withIdentifier: "CategoryListGroupVC") as! CategoryListGroupVC
        vc.imageStr = self.arrForDisplayCatGroupItems[indexPath.row].imageUrl
        vc.strCatTitle = StoreSingleton.shared.returnStringAccordingtoLanguage(arrStr: self.arrForDisplayCatGroupItems[indexPath.row].nameLanguages)
        vc.sequenceNumber = self.arrForDisplayCatGroupItems[indexPath.row].sequenceNumber
        vc.arrGroupItems.removeAll()
        vc.arrGroupItems.append(self.arrForDisplayCatGroupItems[indexPath.row])
        vc.isForEditProduct = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SEGUE.SPECIFICATION_GROUP_TO_SPECIFICATION {
            if let destinationVC =  segue.destination  as? ProductSpecificationsVC {
                destinationVC.selectedGroup = sender as? ProductDisplaySpecificationGroup
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SpecificationGroupCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SpecificationGroupCell
        cell.selectionStyle = .none
        cell.lblSpecificationGroupName.text = "\( StoreSingleton.shared.returnStringAccordingtoLanguage(arrStr: self.arrForDisplayCatGroupItems[indexPath.row].nameLanguages)) (\(arrForDisplayCatGroupItems[indexPath.row].productIds.count))"
        
        cell.btnRemoveSpecification.tag = indexPath.row
        cell.btnRemoveSpecification.isSelected = isDeleteBtnShow
        cell.btnRemoveSpecification.addTarget(self, action: #selector(onClickRemoveGroups(sender:)), for: .touchUpInside)
        cell.setCellUI(isFromCat: true)
        return cell

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    @objc func onClickRemoveGroups(sender: UIButton){
        wsDeleteSpecificationGroup(id: arrForDisplayCatGroupItems[sender.tag].id)
    }
    
    @IBAction func onClickBtnAddNewItem(_ sender: Any) {
        isDeleteBtnShow = false
        self.tblSpecificationsGroups.reloadData()
        
        let vc : CategoryListGroupVC = storyboard?.instantiateViewController(withIdentifier: "CategoryListGroupVC") as! CategoryListGroupVC
        vc.imageStr = ""
        vc.strCatTitle = ""
        vc.arrGroupItems = [CategoryProductGroup(fromDictionary: [:])]
        vc.isForEditProduct = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onClickEditSpecificationsGroup (_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
}
    
//MAKR:- Web Service Calls

extension ProductCatGroupVC {
    func wsGetProductCategoryGroup() {
        var dictParam = [String:Any]()
        dictParam[PARAMS.STORE_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.SERVER_TOKEN] = preferenceHelper.getSessionToken()
        
        print("WS_GET_PRODUCT_GROUP_LIST \(dictParam)")
        Utility.showLoading()
        let alamofire = AlamofireHelper.init()
        alamofire.getResponseFromURL(url: WebService.WS_GET_PRODUCT_GROUP_LIST, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            Utility.hideLoading()
            
            print("WS_GET_PRODUCT_GROUP_LIST \(response)")

            self.arrForDisplayCatGroupItems.removeAll()
            if Parser.isSuccess(response: response) {
                                let productResponse:CategoryGroupModel = CategoryGroupModel.init(fromDictionary: response)
                
                for obj in productResponse.productGroups {
                    self.arrForDisplayCatGroupItems.append(obj)
                }
            }
            if self.arrForDisplayCatGroupItems.count <= 0 {
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            }else{
                self.navigationItem.rightBarButtonItem!.isEnabled = true
            }
            self.tblSpecificationsGroups.reloadData()
        }
    }
    
    
        func wsDeleteSpecificationGroup(id:String) {
            
            var dictParam = [String:Any]()
            dictParam[PARAMS.STORE_ID] = preferenceHelper.getUserId()
            dictParam[PARAMS.SERVER_TOKEN] = preferenceHelper.getSessionToken()
            dictParam[PARAMS.PRODUCT_GROUP_ID] = id

            print("WS_DELETE_PRODUCT_GROUP \(dictParam)")
            Utility.showLoading()
            let alamofire = AlamofireHelper.init()
            alamofire.getResponseFromURL(url: WebService.WS_DELETE_PRODUCT_GROUP, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
                
                print("WS_DELETE_PRODUCT_GROUP \(response)")
                if Parser.isSuccess(response: response) {
                                       
                    self.wsGetProductCategoryGroup()
                }
                //self.wsGetProductSpecificationGroup()
            }
            
        }

        func wsAddProductSpecificationGroup() {
                if arrForAddItems.count > 0 {
                    var dictParam = [String:Any]()
                    dictParam[PARAMS.STORE_ID] = preferenceHelper.getUserId()
                    dictParam[PARAMS.SERVER_TOKEN] = preferenceHelper.getSessionToken()
                    dictParam[PARAMS.SPECIFICATION_GROUP_NAME] = arrForAddItems
                    
                    Utility.showLoading()
                    
                    let alamofire = AlamofireHelper.init()
                    alamofire.getResponseFromURL(url: WebService.WS_ADD_PRODUCT_SPECIFICATION_GROUP, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
                        
                        
                        if Parser.isSuccess(response: response)
                        {
                            self.arrForAddItems.removeAll()
                            //self.wsGetProductSpecificationGroup()
                        }
                        else
                        {
                            self.arrForAddItems.removeAll()
                            //self.wsGetProductSpecificationGroup()
                        }
                    }
                }
                else {
                    self.arrForAddItems.removeAll()
                    self.tblSpecificationsGroups.reloadData()
                 
                }
            }
    }
