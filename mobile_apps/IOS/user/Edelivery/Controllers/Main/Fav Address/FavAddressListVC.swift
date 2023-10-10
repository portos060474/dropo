//
//  FavAddressListVC.swift
//  Edelivery
//
//  Created by Trusha on 02/07/20.
//  Copyright © 2020 Elluminati. All rights reserved.
//

import UIKit

protocol FavAddressListVCDelegate: class {
    func didSelectFavAddress(address: FavouriteAddressesApi)
}

class FavAddressListVC: BaseVC, LeftDelegate,UITableViewDelegate, UITableViewDataSource {
    // MARK: - OUTLETS
    @IBOutlet weak var btnAddNewAddress: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgEmpty: UIImageView!
    
    weak var delegate: FavAddressListVCDelegate?

    // MARK: - VARIABLES
    var arrLocation = [[String:Any]]()
    var isFromDeliveryLocationScreen : Bool = false
    var arrFavLocation = [FavouriteAddressesApi]()
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
       super.viewDidLoad()
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        setLocalization()
        delegateLeft = self
        wsGetFavAddressList()
    }
    
    override func updateUIAccordingToTheme() {
        tableView.reloadData()
         self.setBackBarItem(isNative: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print(APPDELEGATE.fetchLocationFromDB())
        if isFromDeliveryLocationScreen{
            self.btnAddNewAddress.isHidden = true
        }else{
            self.btnAddNewAddress.isHidden = false
        }
        /*
        if self.arrLocation.count > 0 {
            self.updateUI(isUpdate: true)
        }else {
            self.updateUI(isUpdate: false)
         }*/
        self.tableView.reloadData()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.tableFooterView = UIView()
        btnAddNewAddress.applyRoundedCornersWithHeight()
    }
    
    func wsGetFavAddressList() {
        
        let dictParam : [String : Any] = [
            PARAMS.ID: preferenceHelper.getUserId(),
            PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken()
        ]
        
        print("WS_ADD_FAV_ADDRESS_LIST \(dictParam)")
        
        Utility.showLoading()
        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_GET_FAV_ADDRESS_LIST, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            
            print("WS_ADD_FAV_ADDRESS \(response)")
            Utility.hideLoading()
            
            if Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true) {
                self.arrFavLocation.removeAll()
                if let arrAddress = response["favourite_addresses"] as? [NSDictionary] {
                    for dic in arrAddress {
                        let favAddress = FavouriteAddressesApi(dictionary: dic)
                        self.arrFavLocation.append(favAddress)
                    }
                }
            }
            if self.arrFavLocation.count > 0 {
                self.updateUI(isUpdate: true)
            } else {
                self.updateUI(isUpdate: false)
            }
            self.tableView.reloadData()
        }
    }
    
    func wsGetRemoveFavAddress(index: Int) {
        
        let obj = arrFavLocation[index]
        
        let dictParam : [String : Any] = [
            PARAMS.USER_ID: preferenceHelper.getUserId(),
            PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken(),
            PARAMS.ADDRESS_ID : obj._id ?? ""
        ]
        
        print("WS_DELETE_FAV_ADDRESS \(dictParam)")
        
        Utility.showLoading()
        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_DELETE_FAV_ADDRESS, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            
            print("WS_DELETE_FAV_ADDRESS \(response)")
            Utility.hideLoading()
            
            if Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true) {
                self.arrFavLocation.remove(at: index)
            }
            if self.arrFavLocation.count > 0 {
                self.updateUI(isUpdate: true)
            } else {
                self.updateUI(isUpdate: false)
            }
            self.tableView.reloadData()
        }
    }
    
    //MARK: User Define Function
    func setLocalization() {
       self.view.backgroundColor = UIColor.themeViewBackgroundColor
       self.setBackBarItem(isNative: true)
       self.setNavigationTitle(title:"TXT_FAVOURITE_ADDRESS".localized)
    }
    
    func updateUI(isUpdate:Bool = false) {
        imgEmpty.isHidden = isUpdate
        tableView.isHidden = !isUpdate
    }
    func refreshAddressData()  {
        if isFromDeliveryLocationScreen{
            self.btnAddNewAddress.isHidden = true
        }else{
            self.btnAddNewAddress.isHidden = false
        }
        self.wsGetFavAddressList()
    }
   
    // MARK: - ACTION METHODS
    func onClickLeftButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickBtnAddNewAdd(_ sender: UIButton){
        pushAddFavAddressVC(isFromEditAddress: false,ind: -1)
    }
}

extension FavAddressListVC : DelegateRefreshData {
    func didRefreshData() {
        refreshAddressData()
    }
}

extension FavAddressListVC{
    //MARK: Tableview Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrFavLocation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavAddressListCell", for: indexPath) as! FavAddressListCell
        let obj = arrFavLocation[indexPath.row]
        cell.setData(dictData: obj)
        if isFromDeliveryLocationScreen{
            cell.btnCancle.isHidden = true
        }else{
            cell.btnCancle.isHidden = false
        }
        cell.btnCancle.tag = indexPath.row
        cell.btnCancle.addTarget(self, action: #selector(btnDeleteAddressTapped(sender:)), for: .touchUpInside)
        cell.imgIcon.image = UIImage.init(named: "map")?.imageWithColor(color: UIColor.themeImageColor)
        cell.btnCancle.setImage(UIImage(named: "cancel_black_outline")?.imageWithColor(color: .themeColor), for: .normal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = tableView.dequeueReusableCell(withIdentifier: "section")! as! historySectionCell
        
        sectionHeader.lblSection.text = ""
        sectionHeader.lblSection.font = FontHelper.labelRegular(size: 17)
        return sectionHeader
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let obj = arrFavLocation[indexPath.row]
        delegate?.didSelectFavAddress(address: obj)

        UserSingleton.shared.country = obj.country
        //UserSingleton.shared.city = self.arrLocation[indexPath.row]["city"]  as! String
        UserSingleton.shared.currentCoordinate.latitude = obj.latitude
        UserSingleton.shared.currentCoordinate.longitude = obj.longitude
        UserSingleton.shared.address = obj.address
        UserSingleton.shared.title = obj.address_name

        DispatchQueue.main.async {
            if self.isFromDeliveryLocationScreen{
                currentBooking.currentSendPlaceData.address = UserSingleton.shared.address
                currentBooking.currentSendPlaceData.latitude = UserSingleton.shared.currentCoordinate.latitude
                currentBooking.currentSendPlaceData.longitude = UserSingleton.shared.currentCoordinate.longitude
                currentBooking.currentSendPlaceData.city1 = UserSingleton.shared.city
                currentBooking.currentSendPlaceData.country = UserSingleton.shared.country
                currentBooking.currentSendPlaceData.flat_no = obj.flat_no
                currentBooking.currentSendPlaceData.landmark = obj.landmark
                currentBooking.currentSendPlaceData.street = obj.street
                self.navigationController?.popViewController(animated: true)
            }else{
                self.pushAddFavAddressVC(isFromEditAddress: true, ind: indexPath.row)
            }
        }
    }
    
    @objc func btnDeleteAddressTapped(sender: UIButton){
        self.wsGetRemoveFavAddress(index: sender.tag)
    }
    
    func pushAddFavAddressVC(isFromEditAddress:Bool, ind:Int){
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "MainStoryboard", bundle: nil)
        if let VC : FavAddressVC = mainView.instantiateViewController(withIdentifier: "FavAddressVC") as? FavAddressVC {
            VC.isFromEditAddress = isFromEditAddress
            if ind >= 0{
                VC.objUpdateAddress = self.arrFavLocation[ind]
            }
            VC.modalPresentationStyle = .overCurrentContext
            VC.delegateRefreshData = self
            self.present(VC, animated: false, completion: nil)
        }
    }
}

class FavAddressListCell: CustomTableCell {

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnCancle: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        lblTitle.font = FontHelper.textMedium()
        lblAddress.font = FontHelper.textSmall()
        lblTitle.textColor = UIColor.themeTextColor
        lblAddress.textColor = UIColor.themeLightTextColor
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
    }
    
    func setData(dictData: FavouriteAddressesApi) {
        lblTitle.text = dictData.address_name
        lblAddress.text = dictData.address
        
        let flatNo = dictData.flat_no ?? ""
        let street = dictData.street ?? ""
        let landmark = dictData.landmark ?? ""
        
        var finalAddress = dictData.address ?? ""
        var newLine = "\n"
        
        if !flatNo.isEmpty && !street.isEmpty {
            finalAddress += "\n\n" + "\(flatNo), \(street)"
        } else if !flatNo.isEmpty {
            finalAddress += "\n\n" + "\(flatNo)"
        } else if !street.isEmpty {
            finalAddress += "\n\n" + "\(street)"
        } else {
            newLine = "\n\n"
        }
        if !landmark.isEmpty {
            finalAddress += newLine + "\(landmark)"
        }
        
        lblAddress.text = finalAddress
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
    }
    
}
