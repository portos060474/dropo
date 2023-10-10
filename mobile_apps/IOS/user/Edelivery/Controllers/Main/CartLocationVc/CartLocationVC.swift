//
//  CartLocationVC.swift
//  edelivery
//
//  Created by Elluminati on 30/01/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
import GoogleMaps
//import StripeUICore

@objc protocol LocationHandlerDelegate: class {
    func finalAddressAndLocation(address:String,latitude:Double,longitude:Double)
    @objc optional func didSetUserDetail(name: String, countryCode: String, phone: String, note: String)
}

class CartLocationVC: BaseVC,UITextFieldDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,GMSMapViewDelegate, FavAddressListVCDelegate {
    
//MARK: Outlets
    @IBOutlet weak var tblAutocomplete: UITableView!
    @IBOutlet weak var viewForNavigation: UIView!
    @IBOutlet weak var heightForAutoComplete: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var viewForAddress: UIView!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var imgForLocation: UIImageView!
    @IBOutlet weak var btnCurrentLocation: UIButton!
    @IBOutlet weak var imgMapIcon: UIImageView!
    @IBOutlet weak var btnLeft: UIButton!
    
    @IBOutlet weak var stackviewAddressDetail: UIStackView!
    @IBOutlet weak var stackviewUserDetail: UIStackView!
    
    @IBOutlet weak var viewFlat: UIView!
    @IBOutlet weak var viewStreet: UIView!
    @IBOutlet weak var viewLandmark: UIView!
    @IBOutlet weak var viewName: UIView!
    @IBOutlet weak var viewPhoneNo: UIView!
    @IBOutlet weak var viewDeliveryNote: UIView!
    @IBOutlet weak var viewCode: UIView!
    
    @IBOutlet weak var txtFlat: UITextField!
    @IBOutlet weak var txtStreet: UITextField!
    @IBOutlet weak var txtLandmark: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPhoneNo: UITextField!
    @IBOutlet weak var txtDeliveryNote: UITextField!
    @IBOutlet weak var txtCode: UITextField!
    
    @IBOutlet weak var btnFavAddress: UIButton!
    
    @IBOutlet weak var lblTapOnFavAddress: ActiveLabel!
    @IBOutlet weak var viewYouWantToAddAdress: UIView!
    
    @IBOutlet weak var heightNavigation: NSLayoutConstraint!

//MARK: Variables
    var delegate:LocationHandlerDelegate?
    var locationManager : LocationManager? = LocationManager()
    var address:String = ""
    var deliveryType:Int = DeliveryType.store
    var location:[Double] = [0.0,0.0]
    var arrForAdress:[(title:String,subTitle:String,address: String)] = []
    var userDetail: Address?
   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let selectors = [#selector(self.locationUpdate(_:)), #selector(self.locationFail(_:))]
        LocationCenter.default.addObservers(self, selectors)
    }
    
//MARK: View life cycle
    override func viewDidLoad(){
        super.viewDidLoad()
        setLocalization()
        self.tblAutocomplete.estimatedRowHeight = UITableView.automaticDimension
        
        txtFlat.text = currentBooking.currentSendPlaceData.flat_no
        txtLandmark.text = currentBooking.currentSendPlaceData.landmark
        txtStreet.text = currentBooking.currentSendPlaceData.street
        
        if let cartUserDetail = userDetail {
            txtName.text = cartUserDetail.userDetails?.name ?? ""
            txtCode.text = cartUserDetail.userDetails?.countryPhoneCode ?? ""
            txtPhoneNo.text = cartUserDetail.userDetails?.phone ?? ""
            txtDeliveryNote.text = cartUserDetail.note ?? ""
        }
        
        btnFavAddress.setImage(UIImage(named: "menuFavourite")?.imageWithColor(color: UIColor.themeColor), for: .normal)
        
        if preferenceHelper.getUserId().isEmpty() {
            btnFavAddress.isHidden = true
            viewYouWantToAddAdress.isHidden = true
        }
        
        addTapOnFavAddress()
        
        txtPhoneNo.keyboardType = .numberPad
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        setupLayout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        }
    
    override func viewDidDisappear(_ animated: Bool){
        super.viewDidDisappear(animated)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func addTapOnFavAddress() {
        
        let clickHere = ActiveType.custom(pattern: "\\s\("txt_click_here".localized)\\b")
        
        lblTapOnFavAddress.enabledTypes.append(clickHere)

        lblTapOnFavAddress.customize { label in
            label.text = "txt_do_you_want_to_add_fav_address".localized.replacingOccurrences(of: "****", with: "txt_click_here".localized)
            label.numberOfLines = 0
            label.customColor[clickHere] = UIColor.themeTextColor
            label.handleCustomTap(for: clickHere) {_ in
                self.showAddressTitleDailog()
            }
        }
    }
    
    func showAddressTitleDailog() {
        
        let dailog = CustomAddressTitleDialog.showCustomAddressTitleDialog(title: "txt_add_address_name".localized, titleLeftButton: "", titleRightButton: "TXT_ADD_TEXT".localizedCapitalized)
        
        dailog.onClickRightButton = { str in
            let dictParam : [String : Any] = [
                PARAMS.ADDRESS  : currentBooking.currentSendPlaceData.address,
                PARAMS.SERVER_TOKEN: preferenceHelper.getSessionToken(),
                PARAMS.USER_ID: preferenceHelper.getUserId(),
                PARAMS.LATITUDE: currentBooking.currentSendPlaceData.latitude,
                PARAMS.LONGITUDE: currentBooking.currentSendPlaceData.longitude,
                PARAMS.ADDRESS_NAME: str,
                PARAMS.FLAT_NO: self.txtFlat.text!,
                PARAMS.LANDMARK: self.txtLandmark.text!,
                PARAMS.STREET: self.txtStreet.text!,
                PARAMS.COUNTRY: currentBooking.currentSendPlaceData.country,
                PARAMS.COUNTRY_CODE: currentBooking.currentSendPlaceData.country_code,
            ]
            self.wsAddFavAddress(parameter: dictParam)
        }
    }
    
    func wsAddFavAddress(parameter:Dictionary<String,Any>){
        
        print("WS_ADD_FAV_ADDRESS \(parameter)")
        
        Utility.showLoading()
        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_ADD_FAV_ADDRESS, methodName: AlamofireHelper.POST_METHOD, paramData: parameter) {(response, error) -> (Void) in
            
            print("WS_ADD_FAV_ADDRESS \(response)")
            Utility.hideLoading()
            
            if Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true) {
                Utility.showToast(message: "txt_address_added_to_fav_address".localized)
            }
        }
    }
    
    @IBAction func onClickfavAddress() {
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "MainStoryboard", bundle: nil)
        if let vc : FavAddressListVC = mainView.instantiateViewController(withIdentifier: "FavAddressListVC") as? FavAddressListVC
        {
            vc.delegate = self
            vc.isFromDeliveryLocationScreen = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func didSelectFavAddress(address: FavouriteAddressesApi) {
        let camera = GMSCameraPosition.camera(withLatitude: address.latitude, longitude: address.longitude, zoom: 15.0)
        txtFlat.text = address.flat_no
        txtStreet.text = address.street
        txtLandmark.text = address.landmark
        txtAddress.text = address.address
        self.mapView.camera = camera
    }
    
    func setLocalization(){
        //COLORS
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        self.viewForNavigation.backgroundColor = UIColor.themeNavigationBackgroundColor
        
        self.txtAddress.placeholder = "TXT_ADDRESS".localizedCapitalized
        self.txtAddress.textColor = UIColor.themeTextColor
        self.txtFlat.placeholder = "txt_flat_no_name".localizedCapitalized
        self.txtFlat.textColor = UIColor.themeTextColor
        self.txtStreet.placeholder = "txt_street_no".localizedCapitalized
        self.txtStreet.textColor = UIColor.themeTextColor
        self.txtLandmark.placeholder = "txt_landmark".localizedCapitalized
        self.txtLandmark.textColor = UIColor.themeTextColor
        self.txtName.placeholder = "TXT_NAME".localizedCapitalized
        self.txtName.textColor = UIColor.themeTextColor
        self.txtPhoneNo.placeholder = "TXT_MOBILE_NO".localizedCapitalized
        self.txtPhoneNo.textColor = UIColor.themeTextColor
        self.txtCode.placeholder = "txt_code".localized
        self.txtCode.textColor = UIColor.themeTextColor
        if Utility.isTableBooking() {
            txtDeliveryNote.placeholder = "TXT_RESERVATION_NOTE".localizedCapitalized
        } else {
            txtDeliveryNote.placeholder = "TXT_DELIVERY_NOTE".localizedCapitalized
        }
        self.txtDeliveryNote.textColor = UIColor.themeTextColor
        self.btnDone.backgroundColor = UIColor.themeButtonBackgroundColor
        self.btnDone.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        self.btnDone.setTitle("TXT_DONE".localizedCapitalized, for: .normal)
        self.btnDone.titleLabel?.font = FontHelper.buttonText()
        self.lblTitle.text =  "TXT_ADDRESS".localized
        self.lblTitle.font = FontHelper.textMedium()
        self.lblTitle.textColor = UIColor.themeTitleColor
        self.mapView.bringSubviewToFront(self.imgForLocation)
        self.mapView.bringSubviewToFront(self.btnCurrentLocation)
        self.mapView.delegate = self
        self.mapView.settings.allowScrollGesturesDuringRotateOrZoom = false
        if deliveryType == DeliveryType.store {
            self.location = currentBooking.deliveryLatLng
            self.txtAddress.text = currentBooking.deliveryAddress
            stackviewAddressDetail.isHidden = false
            viewFlat.isHidden = false
            viewYouWantToAddAdress.isHidden = false
            for vw in stackviewUserDetail.subviews {
                vw.isHidden = false
            }
        }else {
            self.txtAddress.text = address
            stackviewAddressDetail.isHidden = true
            viewYouWantToAddAdress.isHidden = true
            viewFlat.isHidden = true
            for vw in stackviewUserDetail.subviews {
                vw.isHidden = true
            }
        }
        if location[0] == 0.0 &&   location[1] == 0.0 {
            self.goToCurrentLocation()
        }else {
        let camera = GMSCameraPosition.camera(withLatitude: location[0], longitude:location[1], zoom: 15.0)
       
        self.mapView.camera = camera
        }
        self.viewForAddress.backgroundColor = UIColor.themeViewBackgroundColor
        self.viewFlat.backgroundColor = UIColor.themeViewBackgroundColor
        self.viewStreet.backgroundColor = UIColor.themeViewBackgroundColor
        self.viewLandmark.backgroundColor = UIColor.themeViewBackgroundColor
        self.viewName.backgroundColor = UIColor.themeViewBackgroundColor
        self.viewPhoneNo.backgroundColor = UIColor.themeViewBackgroundColor
        self.viewDeliveryNote.backgroundColor = UIColor.themeViewBackgroundColor
        self.viewCode.backgroundColor = UIColor.themeViewBackgroundColor
        self.imgMapIcon.image = UIImage(named: "map")?.imageWithColor(color: UIColor.themeTitleColor)
        txtAddress.tintColor = UIColor.themeTitleColor
        btnLeft.setImage(UIImage.init(named: "back_black")?.imageWithColor(color: UIColor.themeTitleColor), for: .normal)
        btnLeft.setImage(UIImage.init(named: "back_black")?.imageWithColor(color: UIColor.themeTitleColor), for: .normal)
        if LocalizeLanguage.isRTL {
            btnLeft.setImage( UIImage.init(named: "back_blackRTL")?.imageWithColor(color: UIColor.themeTitleColor), for: .normal)
        }
        lblTapOnFavAddress.text = "txt_do_you_want_to_add_fav_address".localized.replacingOccurrences(of: "****", with: "txt_click_here".localized)
    }
    
    override func updateUIAccordingToTheme() {
        imgMapIcon.image = UIImage(named: "map")?.imageWithColor(color: UIColor.themeTitleColor)
        btnLeft.setImage(UIImage.init(named: "back_black")?.imageWithColor(color: UIColor.themeTitleColor), for: .normal)
        txtAddress.tintColor = UIColor.themeTitleColor
        self.setLocalization()
    }
   
    @IBAction func onClickDismiss(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupLayout(){
        self.viewForAddress.viewWithTag(1)?.removeFromSuperview()
        self.viewForAddress.setRound(withBorderColor: UIColor.themeLightTextColor, andCornerRadious: 3.0, borderWidth: 0.5)
        
        self.viewFlat.setRound(withBorderColor: UIColor.themeLightTextColor, andCornerRadious: 3.0, borderWidth: 0.5)
        self.viewStreet.setRound(withBorderColor: UIColor.themeLightTextColor, andCornerRadious: 3.0, borderWidth: 0.5)
        self.viewLandmark.setRound(withBorderColor: UIColor.themeLightTextColor, andCornerRadious: 3.0, borderWidth: 0.5)
        self.viewName.setRound(withBorderColor: UIColor.themeLightTextColor, andCornerRadious: 3.0, borderWidth: 0.5)
        self.viewPhoneNo.setRound(withBorderColor: UIColor.themeLightTextColor, andCornerRadious: 3.0, borderWidth: 0.5)
        self.viewDeliveryNote.setRound(withBorderColor: UIColor.themeLightTextColor, andCornerRadious: 3.0, borderWidth: 0.5)
        self.viewCode.setRound(withBorderColor: UIColor.themeLightTextColor, andCornerRadious: 3.0, borderWidth: 0.5)
        
        heightNavigation.constant = UIApplication.topSafeAreaHeight + UINavigationController().navigationBar.frame.size.height
    }
    

    //MARK: Button action methods
    @IBAction func onClickBtnDone(_ sender: UIButton){
       
       if !address.isEmpty() && location[0] != 0.0 && location[1] != 0.0
       {
           if deliveryType == DeliveryType.store
           {
               if checkValidation() {
                   currentBooking.currentSendPlaceData.landmark = txtLandmark.text!
                   currentBooking.currentSendPlaceData.street = txtStreet.text!
                   currentBooking.currentSendPlaceData.flat_no = txtFlat.text!
                   wsUpdateCartAddress()
               }
           }
           else
           {
               self.wsCheckAddress(latitude: self.location[0], longitude: self.location[1], address: self.address)
           }
       }
       else
       {
        Utility.showToast(message: "MSG_LOCATION_NOT_GETTING".localized)
       }
    }
    
    func wsCheckAddress(latitude:Double,longitude:Double, address: String) {

        let dictParam:[String:Any] =
            [PARAMS.LATITUDE:latitude,
             PARAMS.LONGITUDE:longitude,
             PARAMS.CITY_ID:currentBooking.bookCityId ?? ""]

        Utility.showLoading()
        print(Utility.convertDictToJson(dict: dictParam))
        print(WebService.WS_CHECK_DELIVERY_AVAILABLE)

        let alamoFire:AlamofireHelper = AlamofireHelper()
        alamoFire.getResponseFromURL(url: WebService.WS_CHECK_DELIVERY_AVAILABLE, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            Utility.hideLoading()
            if Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true) {
                self.delegate?.finalAddressAndLocation(address: address, latitude: latitude, longitude: longitude)
                self.onClickDismiss(self)
            }
        }
    }
    
    func checkValidation() -> Bool {
        let validMobileNumber = txtPhoneNo.text!.isValidMobileNumber()

        if (txtName.text?.isEmpty())! {
            txtName.becomeFirstResponder()
            Utility.showToast(message:"MSG_PLEASE_ENTER_VALID_NAME".localized)
            return false
        } else if validMobileNumber.0 == false {
            txtPhoneNo.becomeFirstResponder()
            Utility.showToast(message:validMobileNumber.1)
            return false
        } else if (txtCode.text?.isEmpty())! {
            txtCode.becomeFirstResponder()
            Utility.showToast(message:"MSG_TXT_PLEASE_ENTER_VALID_MOBILE_NUMBER".localized)
            return false
        } else {
            return true
        }
    }
    
    func wsUpdateCartAddress() {
        
        let destinationAddress:Address = Address.init()
        destinationAddress.address = address
        destinationAddress.addressType = AddressType.DESTINATION
        destinationAddress.userType = CONSTANT.TYPE_USER
        destinationAddress.note = txtDeliveryNote.text!
        destinationAddress.city = currentBooking.currentSendPlaceData.city1
        destinationAddress.location = location
        destinationAddress.flat_no = currentBooking.currentSendPlaceData.flat_no
        destinationAddress.street = currentBooking.currentSendPlaceData.street
        destinationAddress.landmark = currentBooking.currentSendPlaceData.landmark
        
        let cartUserDetail:CartUserDetail = CartUserDetail()
        cartUserDetail.email = preferenceHelper.getEmail()
        cartUserDetail.countryPhoneCode = txtCode.text!
        cartUserDetail.name = txtName.text!
        cartUserDetail.phone = txtPhoneNo.text!
        destinationAddress.userDetails = cartUserDetail
        
        currentBooking.destinationAddress = [destinationAddress]
        let addressDict:[[String:Any]] = [destinationAddress.toDictionary()]
        Utility.showLoading()
        let dictParam : [String : Any] =
            [Google.DESTINATION_ADDRESSES : addressDict,
             PARAMS.CART_ID : currentBooking.cartId,
             ]
        print(dictParam)
        let alamoFire:AlamofireHelper = AlamofireHelper()
        alamoFire.getResponseFromURL(url: WebService.WS_CHANGE_DELIVERY_ADDRESS, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            self.delegate?.didSetUserDetail?(name: self.txtName.text!, countryCode: self.txtCode.text!, phone: self.txtPhoneNo.text!, note: self.txtDeliveryNote.text!)
            if  Parser.isSuccess(response: response, withSuccessToast: true, andErrorToast: true) {
                currentBooking.deliveryLatLng = self.location
                currentBooking.deliveryAddress = self.address
                self.delegate?.finalAddressAndLocation(address: self.address, latitude: self.location[0], longitude: self.location[1])
                self.onClickDismiss(self)
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition){
        
        let myCoordinate = position.target
        locationManager?.getAddressFromLatLong(latitude: myCoordinate.latitude, longitude: myCoordinate.longitude)
        self.address = currentBooking.currentSendPlaceData.address
        self.txtAddress.text = address
        self.location = [currentBooking.currentSendPlaceData.latitude,currentBooking.currentSendPlaceData.longitude]
    }
    
    @IBAction func onClickBtnCurrentLocation(_ sender: Any) {
        goToCurrentLocation()
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
        DispatchQueue.main.async {
            Utility.showLoading()
        }
        
        self.location = [location.coordinate.latitude, location.coordinate.longitude]
        self.locationManager?.getAddressFromLatLong(latitude: (location.coordinate.latitude),
                                                    longitude: (location.coordinate.longitude))
        if self.txtAddress == nil {
            removeObserver()
            return
        }
        self.txtAddress.text = currentBooking.currentSendPlaceData.address
        DispatchQueue.main.async {
            let camera = GMSCameraPosition.camera(withLatitude: currentBooking.currentSendPlaceData.latitude,
                                                  longitude: currentBooking.currentSendPlaceData.longitude,
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
    
    func removeObserver() {
        Common.nCd.removeObserver(self, name: Common.locationUpdateNtfNm, object: LocationCenter.default)
        Common.nCd.removeObserver(self, name: Common.locationFailNtfNm, object: LocationCenter.default)
    }
    
    @IBAction func searching(_ sender: UITextField){
        if (sender.text?.count)! > 2 {
            
            locationManager?.googlePlacesResult(input: sender.text!, completion: { [unowned self,  weak locationManager = self.locationManager] (array) in
                self.arrForAdress = array
                if self.arrForAdress.count > 0 {
                    self.heightForAutoComplete.constant = self.tblAutocomplete.contentSize.height
                    self.tblAutocomplete.reloadData()
                    self.tblAutocomplete.isHidden = false
                }else {
                    self.tblAutocomplete.isHidden = true
                }
            })
        }else {
            self.tblAutocomplete.isHidden = true
        }
    }
}


extension CartLocationVC: UITableViewDataSource,UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrForAdress.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let autoCompleteCell = tableView.dequeueReusableCell(withIdentifier: "autoCompleteCell", for: indexPath) as! AutocompleteCell
        autoCompleteCell.setCellData(place: arrForAdress[indexPath.row])
        return autoCompleteCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.row < arrForAdress.count {
            tblAutocomplete.isHidden = true
            self.txtAddress.text = arrForAdress[indexPath.row].2
            address = self.txtAddress.text ?? ""
            if address.isEmpty() {
                
            }else {
                location = locationManager?.getLatLongFromAddress(address: address) ?? [0.0,0.0]
                let camera = GMSCameraPosition.camera(withLatitude: location[0], longitude: location[1], zoom: 15.0)
                DispatchQueue.main.async
                {
                    self.mapView.camera = camera
                }
            }
        }
    }
}
