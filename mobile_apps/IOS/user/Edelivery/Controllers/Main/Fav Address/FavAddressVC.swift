//
//  FavAddressVC.swift
//  Edelivery
//
//  Created by Trusha on 01/07/20.
//  Copyright © 2020 Elluminati. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreData
protocol DelegateRefreshData {
    func didRefreshData()
}
class FavAddressVC: BaseVC,GMSMapViewDelegate,UITextFieldDelegate, LeftDelegate {
// MARK: - OUTLETS
    
    @IBOutlet weak var lblAsap: UILabel!
    @IBOutlet weak var heightForAutocomplete: NSLayoutConstraint!
    @IBOutlet weak var tblForAutocomplete: UITableView!
    @IBOutlet weak var txtAutoComplete: UITextField!
    @IBOutlet weak var btnExpandMap: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var btnCurrentLocation: UIButton!
    @IBOutlet weak var imgForDeliveryLocation:UIImageView!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var viewForAutoComplete: UIView!
    @IBOutlet weak var imgMapIcon: UIImageView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var txtFlat: UITextField!
    @IBOutlet weak var txtStreet: UITextField!
    @IBOutlet weak var txtLandmark: UITextField!

    // MARK: - VARIABLES
    var futureDateMillisecond:Int64 = 0
    var isMoveThroughGesture:Bool = false
    var myDeliveryAddress:String? = nil
    var myCoordinate:CLLocationCoordinate2D? = nil
    var isFromEditAddress : Bool = false
    var locationManager : LocationManager? = LocationManager()
    var arrForAdress:[(title:String,subTitle:String,address: String)] = []
    var arrLocation = [String:Any]()
    var delegateRefreshData: DelegateRefreshData?
    var isAddressSelect = true
    var objUpdateAddress: FavouriteAddressesApi?

    // MARK: - LIFECYCLE
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let selectors = [#selector(self.locationUpdate(_:)), #selector(self.locationFail(_:))]
        LocationCenter.default.addObservers(self, selectors)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    override func updateUIAccordingToTheme() {
        imgMapIcon.image = UIImage.init(named: "map")?.imageWithColor(color: UIColor.themeImageColor)
        tblForAutocomplete.reloadData()
        btnLeft.setImage(UIImage(named:"cancelIcon")?.imageWithColor(color: UIColor.themeColor), for: .normal)
        self.setBackBarItem(isNative: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalization()
        delegateLeft = self
       
        self.mapView.bringSubviewToFront(self.btnExpandMap)
        self.mapView.bringSubviewToFront(self.imgForDeliveryLocation)
        self.mapView.bringSubviewToFront(self.btnCurrentLocation)
        self.mapView.delegate = self
        self.mapView.settings.allowScrollGesturesDuringRotateOrZoom = false
        
        if !isFromEditAddress{
            UserSingleton.shared.country = ""
            UserSingleton.shared.city = ""
            UserSingleton.shared.address = ""
            UserSingleton.shared.currentCoordinate.latitude = 0.0
            UserSingleton.shared.currentCoordinate.longitude = 0.0
            self.txtTitle.text = ""
        } else {
            if let obj = objUpdateAddress {
                UserSingleton.shared.SendplaceData.address = obj.address ?? ""
                UserSingleton.shared.SendplaceData.address = obj.address ?? ""
                UserSingleton.shared.SendplaceData.latitude = obj.latitude
                UserSingleton.shared.SendplaceData.longitude = obj.longitude
                self.txtTitle.text = obj.address_name ?? ""
                self.txtStreet.text = obj.street ?? ""
                self.txtFlat.text = obj.flat_no ?? ""
                self.txtLandmark.text = obj.landmark ?? ""
                self.txtAutoComplete.text = obj.address ?? ""
            }
        }
        print(UserSingleton.shared.country)
        print(UserSingleton.shared.city)
        print(UserSingleton.shared.currentCoordinate.latitude)
        print(UserSingleton.shared.currentCoordinate.longitude)
        print(UserSingleton.shared.address)
        
        self.tblForAutocomplete.estimatedRowHeight = UITableView.automaticDimension
        self.tblForAutocomplete.register(cellTypes: [FavAddressCell.self], bundle: nil)
        self.view.animationBottomTOTop(self.alertView)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.setBackBarItem(isNative: true)
        
    }
    func onClickLeftButton() {
        switch(CLLocationManager.authorizationStatus()) {
        case .notDetermined, .restricted, .denied:
               removeObserver()
               self.goToBack()
            
        case .authorizedAlways, .authorizedWhenInUse:
            removeObserver()
            self.goToBack()
            
        }
    }
    @IBAction func onClickBtnClose(_ sender: UIButton)  {
        switch(CLLocationManager.authorizationStatus()) {
            
        case .notDetermined, .restricted, .denied:
            removeObserver()
            self.goToBack()
            
        case .authorizedAlways, .authorizedWhenInUse:
            removeObserver()
            self.goToBack()
            
        }
    }
    
    func goToBack() {
        self.view.endEditing(true)
        self.view.animationForHideView(self.alertView) {
            self.dismiss(animated: false, completion: nil)
            self.delegateRefreshData?.didRefreshData()
        }
    }
    
    func removeObserver() {
        Common.nCd.removeObserver(self, name: Common.locationUpdateNtfNm, object: LocationCenter.default)
        Common.nCd.removeObserver(self, name: Common.locationFailNtfNm, object: LocationCenter.default)
    }
    
    func openExitDialog() {
        
        let dialogForExit = CustomAlertDialog.showCustomAlertDialog(title: "TXT_EXIT".localized, message: "MSG_ARE_YOU_SURE".localized, titleLeftButton: "".localizedCapitalized, titleRightButton: "TXT_CANCEL".localizedCapitalized)
        dialogForExit.onClickLeftButton = {
                [unowned dialogForExit] in
                dialogForExit.removeFromSuperview()
                exit(0)
            }
        dialogForExit.onClickRightButton = {
                [unowned dialogForExit] in
                dialogForExit.removeFromSuperview()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserSingleton.shared.address.isEmpty() {
            self.goToCurrentLocation()
        }
        else {
            if !isFromEditAddress {
                let camera = GMSCameraPosition.camera(withLatitude: UserSingleton.shared.currentCoordinate.latitude, longitude: UserSingleton.shared.currentCoordinate.longitude, zoom: 15.0)
                self.mapView.camera = camera
                self.txtAutoComplete.text = UserSingleton.shared.address
                self.txtTitle.text = UserSingleton.shared.title
            } else {
                if let obj = objUpdateAddress {
                    let camera = GMSCameraPosition.camera(withLatitude: obj.latitude, longitude: obj.longitude, zoom: 15.0)
                    self.mapView.camera = camera
                }
            }
        }
    }
    override func viewDidDisappear(_ animated: Bool){
        super.viewDidDisappear(animated)
        if UserSingleton.shared.address.isEmpty() {
            if self.isFromEditAddress {
                self.goToCurrentLocation()
            }
        }
    }
    
    func setLocalization() {
        //Set Colors
        self.view.backgroundColor = UIColor.themeOverlayColor
        self.alertView.backgroundColor = UIColor.themeViewBackgroundColor
        btnDone.backgroundColor = UIColor.themeButtonBackgroundColor
        btnDone.titleLabel?.font = FontHelper.buttonText()
        btnDone.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        if isFromEditAddress{
            btnDone.setTitle("TXT_UPDATE".localizedCapitalized, for: .normal)
            self.setNavigationTitle(title:"TXT_UPDATE_FAV_ADD".localized)
        }else{
            btnDone.setTitle("TXT_DONE".localizedCapitalized, for: .normal)
            self.setNavigationTitle(title:"TXT_ADD_FAV_ADD".localized)
        }
        self.title = "TXT_DELIVERY_LOCATION".localized
        txtTitle.textColor = UIColor.themeTextColor
        txtTitle.placeholder = "Would you like to Add Title?"
        txtTitle.font = FontHelper.textRegular()
        self.txtTitle.placeholder = "TXT_WOULD_LIKE_ADD_TITLE".localized
        self.txtAutoComplete.placeholder = "TXT_ENTER_NEW_ADD".localized
        viewForAutoComplete.backgroundColor = UIColor.themeViewBackgroundColor
        updateUIAccordingToTheme()
        btnLeft.setImage(UIImage(named:"cancelIcon")?.imageWithColor(color: UIColor.themeColor), for: .normal)
        lblTitle.textColor = UIColor.themeTextColor
        lblTitle.font = FontHelper.textMedium(size: FontHelper.large)
        lblTitle.text = "TXT_ADD_FAV_ADD".localized
    }
    
    override func viewDidLayoutSubviews() {
        setUpLayout()
    }
    
    func setUpLayout()  {
        alertView.roundCorner(corners: [.topLeft,.topRight], withRadius: 20.0)
    }
    
    //MARK: TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField == txtAutoComplete {
            isAddressSelect = false
        }
        return true
    }
    
    // MARK: - ACTION METHODS

    @IBAction func onClickBtnCurrentLocation(_ sender: Any) {
        switch(CLLocationManager.authorizationStatus()) {
        case .notDetermined, .restricted, .denied:
            openLocationDialog()
            
        case .authorizedAlways, .authorizedWhenInUse:
            self.goToCurrentLocation()
            
        }
    }

    @IBAction func onClickBtnExpandMapView(_ sender: UIButton){
        if sender.tag == 1 {
            sender.tag = 0
            UIView.animate(withDuration: 0.5, animations: {
                
            }, completion: { (complete) in
                self.updateViewConstraints()
            })
            
        }
        else        {
            
            sender.tag = 1
            UIView.animate(withDuration: 0.5, animations: {
            
            }, completion: { (complete) in
                self.updateViewConstraints()
            })
            
        }
    }
    @IBAction func searching(_ sender: UITextField){
        if (sender.text?.count)! > 2 {
            
            LocationManager().googlePlacesResultForFavAddress(input: sender.text!, completion: { [unowned self](array) in
                
                self.arrForAdress = array
                if self.arrForAdress.count > 0 {
                    self.tblForAutocomplete.reloadData()
                    self.heightForAutocomplete.constant = self.tblForAutocomplete.contentSize.height + 5
                    self.tblForAutocomplete.isHidden = false
                }else {
                    self.tblForAutocomplete.isHidden = true
                }
            })
        }else {
            self.tblForAutocomplete.isHidden = true
        }
    }
    
    
    @IBAction func onClickBtnAddAddress(_ sender: Any) {
        
        if checkValidation() {
            var dictParam : [String : Any] = [
                PARAMS.ADDRESS  : UserSingleton.shared.SendplaceData.address,
                PARAMS.SERVER_TOKEN: preferenceHelper.getSessionToken(),
                PARAMS.USER_ID: preferenceHelper.getUserId(),
                PARAMS.LATITUDE: UserSingleton.shared.SendplaceData.latitude,
                PARAMS.LONGITUDE: UserSingleton.shared.SendplaceData.longitude,
                PARAMS.ADDRESS_NAME: txtTitle.text!.isEmpty() ? "Other" : txtTitle.text!,
                PARAMS.FLAT_NO: txtFlat.text!,
                PARAMS.LANDMARK: txtLandmark.text!,
                PARAMS.STREET: txtStreet.text!,
                PARAMS.COUNTRY: currentBooking.currentSendPlaceData.country,
                PARAMS.COUNTRY_CODE: currentBooking.currentSendPlaceData.country_code,
            ]
            
            if isFromEditAddress {
                if let obj = objUpdateAddress {
                    dictParam[PARAMS.ADDRESS_ID] = obj._id
                }
                wsUpdateAddress(parameter: dictParam)
            } else {
                wsAddFavAddress(parameter: dictParam)
            }
        }
        
        print(UserSingleton.shared.SendplaceData.country_code)
        print(UserSingleton.shared.SendplaceData.country)
        print(UserSingleton.shared.SendplaceData.country_code_2)
        
        /*
        UserSingleton.shared.SendplaceData.title = self.txtTitle.text ?? ""
       

        if isFromEditAddress{
            APPDELEGATE.updateLocationToDB(objectId: arrLocation["ID"] as! NSManagedObjectID)
        }else{
            APPDELEGATE.addLocationToDb()
        }
        self.goToBack()*/
    }
    
    func wsAddFavAddress(parameter:Dictionary<String,Any>){
        
        print("WS_ADD_FAV_ADDRESS \(parameter)")
        
        Utility.showLoading()
        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_ADD_FAV_ADDRESS, methodName: AlamofireHelper.POST_METHOD, paramData: parameter) {(response, error) -> (Void) in
            
            print("WS_ADD_FAV_ADDRESS \(response)")
            Utility.hideLoading()
            
            if Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true) {
                self.goToBack()
                Utility.showToast(message: "txt_address_added_to_fav_address".localized)
            }
        }
    }
    
    func wsUpdateAddress(parameter:Dictionary<String,Any>){
        Utility.showLoading()
        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_UPDATE_FAV_ADDRESS, methodName: AlamofireHelper.POST_METHOD, paramData: parameter) {(response, error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true) {
                self.goToBack()
                Utility.showToast(message: "txt_address_updated_successfully".localized)
            }
        }
    }
    
    func checkValidation() -> Bool {
        if txtAutoComplete.text!.isEmpty || !isAddressSelect {
            Utility.showToast(message: "MSG_PLEASE_SELECT_VALID_ADDRESS".localized)
            return false
        }
        return true
    }
    
    
// MARK: - MAP VIEW DELEGATE METHODS

    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        isMoveThroughGesture = gesture
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition){
        
        if isMoveThroughGesture {
            myCoordinate = position.target
            locationManager?.getAddressFromLatLongForFavAddress(latitude: (myCoordinate?.latitude)!, longitude: (myCoordinate?.longitude)!)
            self.txtAutoComplete.text = UserSingleton.shared.SendplaceData.address
            isAddressSelect = true
        }
    }
    
    func goToCurrentLocation() {
        
        if LocationCenter.isServicesEnabled && (!LocationCenter.isDenied){
            Utility.showLoading()
        }
        LocationCenter.default.startUpdatingLocation()
    
    }
    
    @objc func locationUpdate(_ ntf: Notification = Common.defaultNtf) {
        LocationCenter.default.stopUpdatingLocation()
        guard let userInfo = ntf.userInfo else { return }
        guard let location = userInfo[Common.locationKey] as? CLLocation else { return }
        print("locationUpdate: \(location)")
        myCoordinate = location.coordinate
        self.locationManager?.getAddressFromLatLongForFavAddress(latitude: (self.myCoordinate?.latitude)!,
                                                                 longitude: (self.myCoordinate?.longitude)!)
        if self.txtAutoComplete == nil {
            removeObserver()
            return
        }
        print(APPDELEGATE.fetchLocationFromDB())
        self.txtAutoComplete.text = UserSingleton.shared.SendplaceData.address
        isAddressSelect = true
        DispatchQueue.main.async {
            let camera = GMSCameraPosition.camera(withLatitude: UserSingleton.shared.SendplaceData.latitude,
                                                  longitude: UserSingleton.shared.SendplaceData.longitude,
                                                  zoom: 15.0)
            Utility.hideLoading()
            self.mapView.camera = camera
        }
    }
    
    @objc func locationFail(_ ntf: Notification = Common.defaultNtf) {
        LocationCenter.default.stopUpdatingLocation()
        guard let userInfo = ntf.userInfo else { return }
        guard let error = userInfo[Common.locationErrorKey] as? Error else { return }
        print("locationFail: \(error)")
        Utility.hideLoading()
        Utility.showToast(message: "MSG_LOCATION_NOT_GETTING".localized)
    }
    
    func openLocationDialog() {
        
        let dialogForLocation = CustomAlertDialog.showCustomAlertDialog(title: "TXT_ATTENTION".localized, message: "MSG_LOCATION_ENABLE".localized, titleLeftButton: "".localizedCapitalized, titleRightButton: "TXT_OK".localizedCapitalized)
        dialogForLocation.onClickLeftButton = {
                [unowned dialogForLocation] in
                dialogForLocation.removeFromSuperview()
        }
        dialogForLocation.onClickRightButton = {
                [unowned dialogForLocation] in
                dialogForLocation.removeFromSuperview()
        }
    }
}

extension FavAddressVC: UITableViewDataSource,UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrForAdress.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let autoCompleteCell = tableView.dequeueReusableCell(withIdentifier: "FavAddressCell", for: indexPath) as! FavAddressCell
        if indexPath.row < arrForAdress.count {
         autoCompleteCell.setCellData(place: arrForAdress[indexPath.row])
            autoCompleteCell.imgForPin.image = UIImage.init(named: "map")?.imageWithColor(color: UIColor.themeImageColor)
        }

        return autoCompleteCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.row < arrForAdress.count {
        tblForAutocomplete.isHidden = true
        
        let address = arrForAdress[indexPath.row].2
        setAddress(address: address)
        }
    }
    
    func setAddress(address:String) {
        isAddressSelect = true
        self.txtAutoComplete.text = address
        if address.isEmpty() {
    
        }else {

            self.locationManager?.setPlaceDataFromAddressFaVAddress(address: address)
            
            let camera = GMSCameraPosition.camera(withLatitude: (UserSingleton.shared.SendplaceData.latitude), longitude: (UserSingleton.shared.SendplaceData.longitude), zoom: 15.0)
            DispatchQueue.main.async {
                    self.view.endEditing(true)
                    Utility.hideLoading()
                    self.mapView.camera = camera
            }
        }
    }
}

class FavAddressCell: CustomTableCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var viewForAutocomplete: UIView!
    @IBOutlet weak var imgForPin: UIImageView!
   
    //MARK:- LIFECYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        setLocalization()
    }
    
    //MARK:- SET CELL DATA
    func setCellData(place:(title:String,subTitle:String,address: String)) {
        lblTitle.text = place.title
        lblSubTitle.text = place.subTitle
    }
    
    func setLocalization() {
        
        //Colors
        self.backgroundColor = UIColor.themeViewBackgroundColor
        self.contentView.backgroundColor = UIColor.themeViewBackgroundColor
        viewForAutocomplete.backgroundColor = UIColor.themeViewBackgroundColor
        lblTitle.textColor = UIColor.themeTextColor
        lblSubTitle.textColor = UIColor.themeLightTextColor
        
        /*Set Font*/
        lblTitle.font =  FontHelper.textRegular(size: 14)
        lblSubTitle.font =  FontHelper.tiny()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

