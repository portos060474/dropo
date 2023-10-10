//
//  SubStoreListVC.swift
//  Store
//
//  Created by Trusha on 14/07/20.
//  Copyright © 2020 Elluminati. All rights reserved.
//

import UIKit

class SubStoreListVC: BaseVC {

    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var tblSubStoreList: UITableView!

    var arrSubStore = [SubStore]()

    
    let dict : [[String:Any]] = [["url":"store/create_order",
                                  "name":"TXT_CREATE_ORDER".localized,
    "permission":0],["url" : "store/providers",
    "name" : "TXT_PROVIDER".localized,
    "permission" : 0],["url" : "store/service",
    "name" : "TXT_SERVICE".localized,
    "permission": 0],["url" : "store/order",
    "name" : "TXT_ORDER".localized,
    "permission": 0],["url" : "store/deliveries",
    "name" : "TXT_DELIVERIES".localized,
    "permission": 0],["url" : "store/history",
    "name" : "TXT_HISTORY".localized,
    "permission": 0],["url" : "store/group",
    "name": "TXT_GROUP".localized,
    "permission": 0],["url" : "store/product",
    "name": "TXT_PRODUCT_".localized,
    "permission": 0],["url" : "store/promocode",
    "name": "TXT_PROMO_CODE_ONLY".localized,
    "permission": 0],["url" : "store/setting",
    "name": "TXT_SETTING_".localized,
    "permission": 0],["url" : "store/earning",
    "name": "TXT_EARNING".localized,
    "permission": 0],["url" : "store/weekly_earning",
    "name": "TXT_WEEKLY_EARNING".localized,
    "permission": 0]]



    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalization()
        
        tblSubStoreList.estimatedRowHeight = 70
        tblSubStoreList.rowHeight = UITableView.automaticDimension
    }
    
    func setLocalization() -> Void {
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        super.hideBackButtonTitle()
        self.setNavigationTitle(title: "TXT_SUB_STORE".localized)
        btnAdd.backgroundColor = .themeColor
        btnAdd.layer.cornerRadius = btnAdd.frame.height/2.0
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        wsGetSubStoreList()
    }
    
    override func updateUIAccordingToTheme() {
        self.tblSubStoreList.reloadData()
    }
    //MARK: - IBAction Method
    @IBAction func onClickBtnAddNewItem(_ sender: Any) {
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "SubStore", bundle: nil)
        if let VC : SubStoreAddEditVC = mainView.instantiateViewController(withIdentifier: "SubStoreAddEditVC") as? SubStoreAddEditVC{
            VC.arrSubStore.name = [""]
            VC.arrSubStore.email = ""
            VC.arrSubStore.phone = ""
            VC.arrSubStore.password = ""
            if arrSubStore.count > 0{
                VC.arrSubStore.urls = arrSubStore[0].urls
            }else{
                var arr = [SubStoreUrl]()
                for obj in dict{
                    arr.append(SubStoreUrl(fromDictionary: obj))
                }
                VC.arrSubStore.urls = arr
            }
            VC.isFromAdd = true
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
}


extension SubStoreListVC : UITableViewDataSource, UITableViewDelegate{
    //MARK: -
     //MARK: - UITableview delegate
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSubStore.count
     }
     
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
     }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc : SubStoreAddEditVC = storyboard?.instantiateViewController(withIdentifier: "SubStoreAddEditVC") as! SubStoreAddEditVC
        vc.arrSubStore = arrSubStore[indexPath.row]
        vc.isFromAdd = false
        self.navigationController?.pushViewController(vc, animated: true)
     }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubStoreCell", for: indexPath) as! SubStoreCell
        if self.arrSubStore[indexPath.row].name.count > 0{
            if self.arrSubStore[indexPath.row].name.count-1 >= ConstantsLang.AdminLanguageIndexSelected{
              cell.lblName.text = self.arrSubStore[indexPath.row].name[ConstantsLang.AdminLanguageIndexSelected]
            }else{
                cell.lblName.text = self.arrSubStore[indexPath.row].name[0]
            }
        }else{
            cell.lblName.text = "DJ"
        }
        cell.imgSubStore.downloadedFrom(link: "")
        cell.lblEmail.text = self.arrSubStore[indexPath.row].email
        cell.lblPhNo.text = "\(self.arrSubStore[indexPath.row].countryPhoneCode ?? "") \(self.arrSubStore[indexPath.row].phone ?? "")"
        var str = ""
        for _ in 0..<(self.arrSubStore[indexPath.row].password.count-1){
            str = str + "*"
        }
        cell.lblPassword.text = str

        
        if self.arrSubStore[indexPath.row].isApproved{
            cell.lblStatus.backgroundColor = UIColor.themeGreenColor
        }else{
            cell.lblStatus.backgroundColor = .themeRedColor
        }
        //cell.setCellData(place: arrForAdress[indexPath.row])
        return cell
    }

     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return UITableView.automaticDimension
     }
}

//MAKR:- Web Service Calls

extension SubStoreListVC {
    func wsGetSubStoreList() {
        var dictParam = [String:Any]()
        dictParam[PARAMS.STORE_ID] = preferenceHelper.getUserId()
        dictParam[PARAMS.SERVER_TOKEN] = preferenceHelper.getSessionToken()
        
        print("WS_GET_SUB_STORE_LIST \(dictParam)")
        Utility.showLoading()
        let alamofire = AlamofireHelper.init()
        alamofire.getResponseFromURL(url: WebService.WS_GET_SUB_STORE_LIST, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            Utility.hideLoading()
            
            print("WS_GET_SUB_STORE_LIST \(response)")

            self.arrSubStore.removeAll()
            if Parser.isSuccess(response: response) {
                let subStoreResponse:SubStoreModel = SubStoreModel.init(fromDictionary: response)

                for obj in subStoreResponse.subStore {
                    self.arrSubStore.append(obj)
                }
            }
            self.tblSubStoreList.reloadData()
        }
    }
    
}

class SubStoreCell: CustomCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPhNo: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var imgSubStore: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        lblName.textColor = UIColor.themeTextColor;
        lblEmail.textColor = UIColor.themeLightTextColor;
        lblPhNo.textColor = UIColor.themeLightTextColor;
        lblPassword.textColor = UIColor.themeLightTextColor;
        lblName.font = FontHelper.textMedium()
        lblEmail.font = FontHelper.textRegular()
        lblPhNo.font = FontHelper.textRegular()
        lblPassword.font = FontHelper.textRegular()
        
        lblStatus.layer.cornerRadius = lblStatus.frame.height/2;
        lblStatus.layer.masksToBounds = true
        
        imgSubStore.layer.cornerRadius = imgSubStore.frame.height/2;
        imgSubStore.layer.masksToBounds = true
        imgSubStore.layer.borderColor = UIColor.themeLightLineColor.cgColor
        imgSubStore.layer.borderWidth = 0.3
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
