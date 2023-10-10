//
//  ProductListVC.swift
//  Store
//
//  Created by Jaydeep Vyas on 20/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class ProductListVC: BaseVC,UITableViewDelegate,UITableViewDataSource {
    
    var indexCell = 0
    @IBOutlet weak var tableProductList: UITableView!
    var arrProductList = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.hideBackButtonTitle()
        self.setLocalization()
    
        self.tableProductList.rowHeight = UITableView.automaticDimension;
        self.tableProductList.estimatedRowHeight = 150.0;
        self.tableProductList.tableFooterView = UIView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
          self.wsGetProductList()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setLocalization() {
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        super.setNavigationTitle(title: "TXT_PRODUCT".localized)
    }
    
    //MARK: - Custom web service methods
    func wsGetProductList() -> Void {
        var dictParam = [String:Any]()
        dictParam[PARAMS.STORE_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.SERVER_TOKEN] = preferenceHelper.getSessionToken()
        Utility.showLoading()
        
        let alamofire = AlamofireHelper.init()
        alamofire.getResponseFromURL(url: WebService.WS_GET_PRODUCT_LIST , methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            
             Utility.hideLoading()
            
            if Parser.isSuccess(response: response) {
               
                let productListResponse = ProductListReposnse.init(fromDictionary:
                response)
                self.arrProductList = productListResponse.products
                if (self.tableProductList != nil) {
                    self.tableProductList.reloadData()
                }
            }
            
        }
    }
    
    
    
    //MARK: -
    //MARK: - button click methods
    
    @IBAction func onClickAddProduct (_ sender: Any) {
        
        let addProductObj = storyboard!.instantiateViewController(withIdentifier: "addProduct") as! AddProductVC
        present(addProductObj, animated: true, completion: nil)
        
        
    }
    @IBAction func onClickUpdateVisibility (_ sender: Any) {
        let swVisibility :UISwitch = sender as! UISwitch
        let product = arrProductList[swVisibility.tag] as? Product
        
        var dictParam = [String:Any]()
        dictParam[PARAMS.STORE_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.SERVER_TOKEN] = preferenceHelper.getSessionToken()
        dictParam[PARAMS.PRODUCT_ID] = product?.id
        dictParam[PARAMS.NAME] = product?.name
        dictParam[PARAMS.DETAILS] = product?.details
        dictParam[PARAMS.IS_VISIBLE_IN_STORE] = swVisibility.isOn
        Utility.showLoading()
        let alamofire = AlamofireHelper.init()
        alamofire.getResponseFromURL(url: WebService.WS_UPDATE_PRODUCT, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            
            if Parser.isSuccess(response: response) {
                self.wsGetProductList()
            }else {
                self.wsGetProductList()
            }
        }
    }
    
    
    //MARK: -
    //MARK: - UITableview delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return arrProductList.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:ProductCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as? ProductCell
        
        if (cell == nil) {
            cell = UITableViewCell(style: .default, reuseIdentifier: "ProductCell") as? ProductCell
        }
        cell?.selectionStyle = .none
        cell?.btnSpecifications.tag = indexPath.row
        cell?.swIsVisible.tag = indexPath.row
        cell?.swIsVisible.addTarget(self, action: #selector(onClickUpdateVisibility(_:)), for: .touchUpInside)
        
        let product = arrProductList[indexPath.row] as! Product
        cell?.setCellData(product: product, parent: self)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        indexCell = indexPath.row
//        let product = arrProductList[indexPath.row] as! Product
//        let addProductObj = storyboard!.instantiateViewController(withIdentifier: "addProduct") as! AddProductVC
//        addProductObj.productDetail = product
//        addProductObj.isForEditProduct = true
//        DispatchQueue.main.async(execute: { () -> Void in
//            self.present(addProductObj, animated: true, completion: nil)
//        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    func goToProductSpecification(productDetail:Product) -> Void {
    }
}

