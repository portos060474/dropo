//
//  PromoListVC.swift
//  Store
//
//  Created by Jaydeep Vyas on 20/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class PromoListVC: BaseVC,UITableViewDelegate,UITableViewDataSource {
    

    @IBOutlet weak var tablePromoList: UITableView!
    
    @IBOutlet weak var btnAddPromo: UIButton!
    
    var arrPromoList = [PromoCodeItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.hideBackButtonTitle()
        self.setLocalization()
    
        self.tablePromoList.rowHeight = UITableView.automaticDimension;
        self.tablePromoList.estimatedRowHeight = 150.0;
        self.tablePromoList.tableFooterView = UIView()
        btnAddPromo.isHidden = !StoreSingleton.shared.store.isStoreAddPromoCode
        btnAddPromo.backgroundColor = .themeColor
        btnAddPromo.layer.cornerRadius = btnAddPromo.frame.height/2.0

        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
          self.wsGetPromocodeList()
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
        self.setNavigationTitle(title: "TXT_PROMO_LIST".localized)
    }
    @IBAction func onClickBtnAdd(_ sender: Any) {
        self.performSegue(withIdentifier: SEGUE.PROMOLIST_TO_PROMO, sender: nil)
    }
    //MARK: - Custom web service methods
    func wsGetPromocodeList() -> Void {
        var dictParam = [String:Any]()
        dictParam[PARAMS.STORE_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.SERVER_TOKEN] = preferenceHelper.getSessionToken()
        
        print(dictParam
        )
        Utility.showLoading()
        
        let alamofire = AlamofireHelper.init()
        
        alamofire.getResponseFromURL(url: WebService.GET_PROMO_CODE_LIST , methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            
             Utility.hideLoading()
            
            if Parser.isSuccess(response: response) {
               
                let promoListResponse = PromoCodeResponse.init(fromDictionary:
                response)
                
                self.arrPromoList = promoListResponse.promoCodeItemList
                if (self.tablePromoList != nil) {
                    self.tablePromoList.reloadData()
                }
            }
            
        }
    }
    
    
    
    
    
    //MARK: -
    //MARK: - UITableview delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return arrPromoList.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:PromoCodeCell?
        
        cell = tableView.dequeueReusableCell(withIdentifier: "promoCodeCell", for: indexPath) as? PromoCodeCell
        
        
        if (cell == nil) {
            cell = UITableViewCell(style: .default, reuseIdentifier: "promoCodeCell") as? PromoCodeCell
        }
        cell?.swIsPromoActive.tag = indexPath.row
        cell?.swIsPromoActive.addTarget(self, action: #selector(onSwitchValueChanged(_:)), for: .valueChanged)
        cell?.setCellData(promoCode: arrPromoList[indexPath.row])
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: SEGUE.PROMOLIST_TO_PROMO, sender: arrPromoList[indexPath.row])
       
    }
    @objc func onSwitchValueChanged(_ sender:UISwitch) {
        let promoCodeItem = arrPromoList[sender.tag]
        promoCodeItem.isActive = sender.isOn
        wsUpdatePromo(id:promoCodeItem)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let promoVc:PromoVC = segue.destination as! PromoVC
        if sender != nil {
        promoVc.selectedPromoItem = sender as? PromoCodeItem
        }
    }
    
    func wsUpdatePromo(id:PromoCodeItem) {
     
        let dictParam:[String:Any] = id.toDictionary()
        Utility.showLoading()
        
        let alamofire = AlamofireHelper.init()
        
        alamofire.getResponseFromURL(url: WebService.UPDATE_PROMO_CODE , methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            
            Utility.hideLoading()
            
            if Parser.isSuccess(response: response) {
                
                
            }
            
        }
    }
}

