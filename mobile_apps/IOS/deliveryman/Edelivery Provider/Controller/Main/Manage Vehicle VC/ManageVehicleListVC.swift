//
//  ManageVehicleListVC.swift
//  edelivery
//
//  Created by Elluminati on 28/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class ManageVehicleListVC: BaseVC,LeftDelegate , vehicleFunction {
   
//MARK: OutLets
    @IBOutlet weak var btnAddVehicle: UIButton!
    @IBOutlet weak var lblEmptyMsg: UILabel!
    @IBOutlet weak var imgEmpty: UIImageView!
    @IBOutlet weak var tblForVehicleDetail: UITableView!
   
//MARK: Variables
    var arrForVehicleList:[Vehicle] = []
    var selectedVehicle:Vehicle? = nil
    var isComeFirstTime:Bool = false

//MARK: View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblEmptyMsg.isHidden = true
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        tblForVehicleDetail.estimatedRowHeight = 130
        tblForVehicleDetail.separatorStyle = .none
        self.setBackBarItem(isNative: false)
        delegateLeft = self
        tblForVehicleDetail.rowHeight = UITableView.automaticDimension
        self.hideBackButtonTitle()
        self.setNavigationTitle(title: "TXT_VEHICLE".localizedCapitalized)
    }
    override func updateUIAccordingToTheme() {
        tblForVehicleDetail.reloadData()
    }
    func onClickLeftButton() {
        if isComeFirstTime && self.arrForVehicleList.isEmpty {
            self.openLogoutDialog()
        }else {
            self.navigationController?.popViewController(animated: true);
        }
    }
    @IBAction func onClickBtnAdd(_ sender: Any) {
       
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VehicleDetailVC") as! VehicleDetailVC
        vc.vehicle = self
        vc.modalPresentationStyle = .overCurrentContext
        vc.isForAddVehicle = true
        self.present(vc, animated: false, completion: nil)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.wsGetVehicleList()
        if CurrentOrder.shared.providerType == ProviderType.store {
            btnAddVehicle.isHidden = true
        }
    }
    
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews();
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews();
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidDisappear(_ animated: Bool){
        super.viewDidDisappear(animated)
    }
    
    func updateUI(isUpdate:Bool = false) {
        imgEmpty.isHidden = isUpdate
        tblForVehicleDetail.isHidden = !isUpdate
    }
    
    func  setLocalization() {
        self.view.backgroundColor = UIColor.themeViewBackgroundColor;
    }
    
    func openLogoutDialog(){
        
        let dialogForLogout = CustomAlertDialog.showCustomAlertDialog(title: "TXT_LOGOUT".localized, message: "MSG_ARE_YOU_SURE".localized, titleLeftButton: "TXT_CANCEL".localizedUppercase, titleRightButton: "TXT_OK".localizedUppercase)
        dialogForLogout.onClickLeftButton = {
                [unowned dialogForLogout] in
                dialogForLogout.removeFromSuperview();
        }
        dialogForLogout.onClickRightButton = { [unowned dialogForLogout, unowned self] in
                dialogForLogout.removeFromSuperview();
                self.wsLogout()
        }
    }
    
    func wsLogout(){
        Utility.showLoading()
        let dictParam:[String:String] =
            [PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken(),
             PARAMS.PROVIDER_ID : preferenceHelper.getUserId()]
        
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_PROVIDER_LOGOUT, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            
            Utility.hideLoading()
            if (Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true)) {
                preferenceHelper.setSessionToken("")
                preferenceHelper.setUserId("")
                APPDELEGATE.goToHome()
            }
        }
    }
    
    func getVehicle() {
        self.wsGetVehicleList()
    }
    func wsGetVehicleList() {
        let dictParam : [String : Any] =
        [PARAMS.PROVIDER_ID: preferenceHelper.getUserId(),
         PARAMS.SERVER_TOKEN: preferenceHelper.getSessionToken()]
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_GET_VEHICLE_LIST, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            
            if Parser.isSuccess(response: response) {
                self.arrForVehicleList.removeAll()
                let vehicleListResponse:VehicleListResonse = VehicleListResonse.init(fromDictionary: response )
                let vehicleList:[Vehicle] = vehicleListResponse.vehicles
                if vehicleList.count > 0 {
                    for vehicle in vehicleList {
                        self.arrForVehicleList.append(vehicle)
                    }
                }
                if self.arrForVehicleList.count > 0 {
                    self.updateUI(isUpdate:true)
                }else {
                    self.updateUI(isUpdate:false)
                }
                self.tblForVehicleDetail.reloadData()
            }else {
                self.updateUI(isUpdate:false)
            }
        }
    }
    
    func wsSelectVehicle(id:String = "") {
        Utility.showLoading()
        let dictParam : [String : Any] =
            [PARAMS.PROVIDER_ID: preferenceHelper.getUserId(),
             PARAMS.SERVER_TOKEN: preferenceHelper.getSessionToken(),
             PARAMS.VEHICLE_ID: id]
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_SELECT_VEHICLE, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response) {
                preferenceHelper.setSelectedVehicleId(id)
            }else {
                
            }
            self.tblForVehicleDetail.reloadData()
        }
    }
   
    @objc func onClickSelectVehicle(button:UIButton) {
        self.selectedVehicle =   arrForVehicleList[button.tag]
        if ((self.selectedVehicle?.isApproved) ?? false) && !(self.selectedVehicle?.adminVehicleId.isEmpty)! {
                self.wsSelectVehicle(id: arrForVehicleList[button.tag].id)
        }else {
            Utility.showToast(message: "MSG_YOU_CAN'T_SELECT_VEHICLE".localized)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
}

extension ManageVehicleListVC: UITableViewDelegate,UITableViewDataSource {
    //MARK: Tableview Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrForVehicleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VehicleDetailCell
        let dict = arrForVehicleList[indexPath.row]
        cell.btnSelected.tag = indexPath.row
        cell.btnSelected.addTarget(self, action:#selector(self.onClickSelectVehicle(button:)), for: .touchUpInside)
        cell.setData(data: dict)
        return cell
    }
   
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.selectedVehicle =   arrForVehicleList[indexPath.row]
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "VehicleDetailVC") as! VehicleDetailVC
            vc.selectedVehicle = self.selectedVehicle
            vc.vehicle = self
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: false, completion: nil)
    }
}

class VehicleDetailCell: CustomTableCell {
    @IBOutlet weak var lblVehicleName: UILabel!
    @IBOutlet weak var lblVehicleModel: UILabel!
    @IBOutlet weak var imgVehicle: UIImageView!
    @IBOutlet weak var btnSelected: UIButton!
    @IBOutlet var lblVehicleType: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        lblVehicleName.textColor = UIColor.themeTextColor
        lblVehicleName.font = FontHelper.textMedium()
        lblVehicleType.textColor = UIColor.themeLightTextColor
        lblVehicleType.font = FontHelper.textMedium()
        lblVehicleModel.textColor = UIColor.themeLightTextColor
        lblVehicleModel.font = FontHelper.textRegular()
        imgVehicle.setRound(withBorderColor: UIColor.themeLightTextColor, andCornerRadious: imgVehicle.frame.height/2, borderWidth: 0.5)
      }
    
    func setData(data: Vehicle) {
        
        lblVehicleName.text = data.vehicleName + " " + data.vehicleModel
        lblVehicleModel.text = data.vehiclePlateNo
        btnSelected.setImage(UIImage.init(named: "radio_btn_unchecked_icon")?.imageWithColor(color: .themeLightTextColor), for: .normal)
        btnSelected.setImage(UIImage.init(named: "selected_icon")?.imageWithColor(), for: .selected)
        
        if data.id == preferenceHelper.getSelectedVehicleId() {
            btnSelected.isSelected = true
        }else {
            btnSelected.isSelected = false
        }
        
        if !data.vehicleDetail.isEmpty {
            if !data.vehicleDetail[0].imageUrl.isEmpty {
                imgVehicle.downloadedFrom(link: data.vehicleDetail[0].imageUrl)
            }
            lblVehicleType.text = data.vehicleDetail[0].vehicleName
            lblVehicleType.isHidden = false
        }else {
            lblVehicleType.isHidden = true
        }
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

