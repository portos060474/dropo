//
//  StoreLocationVC.swift
// Edelivery Store
//
//  Created by Elluminati on 30/01/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

@objc protocol LocationHandlerDelegate: class {
    func finalAddressAndLocation(address:String,latitude:Double,longitude:Double)
}

class StoreLocationVC: BaseVC,UITextFieldDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,GMSMapViewDelegate {
    
    @IBOutlet weak var tblForAutocomplete: UITableView!
    @IBOutlet weak var viewForAddress: Vw!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var imgForLocation: UIImageView!
    @IBOutlet weak var btnCurrentLocation: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var imgForStoreLocationIcon: UIImageView!

    var delegate:LocationHandlerDelegate?
    var isMoveThroughGesture = true;
    var address:String = "";
    var location:[Double] = [0.0,0.0];
    var arrForAdress:[(String,String,String)] = []
    var comingFrom:SourceVC = SourceVC.REGISTER_VC
    var strCityID:String = "";
    var isNavigaitonBarHidden:Bool = true
    
    //MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad();
        self.tblForAutocomplete.isHidden = true
        setLocalization()
        //viewForAddress.setCustomShadow()
        isNavigaitonBarHidden  = self.navigationController?.isNavigationBarHidden ?? true
    }
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.isHidden = false

    }
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
    }
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews();
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(_ animated: Bool){
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func searchAddress(_ sender: Any) {
        let text = txtAddress.text ?? ""
        if text.count >= 2 {
            let locationManager = LocationManager();
            
            locationManager.googlePlacesResult(input: text, completion: {
                
                [unowned locationManager, unowned self](array:[(String,String,String)]) in
                
                self.arrForAdress = array
                if self.arrForAdress.count > 0 {
                    self.tblForAutocomplete.reloadData({
                        self.tblForAutocomplete.isHidden = false
                    })
                }else {
                    self.tblForAutocomplete.isHidden = true
                }
            })
        }
    }
    
    func setLocalization() {
        //COLORS
        self.view.backgroundColor = UIColor.themeViewBackgroundColor;
        self.viewForAddress.backgroundColor = UIColor.themeViewBackgroundColor
        self.txtAddress.placeholder = "TXT_ADDRESS".localizedCapitalized
        self.btnDone.backgroundColor = UIColor.themeColor
        self.btnDone.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        self.btnDone.setTitle("TXT_DONE".localizedUppercase, for: .normal)
        self.btnDone.titleLabel?.font = FontHelper.textRegular()
        self.txtAddress.font = FontHelper.textRegular(size: 14)
        self.setNavigationTitle(title: "TXT_ADDRESS".localized)
        self.mapView.bringSubviewToFront(self.imgForLocation)
        self.mapView.bringSubviewToFront(self.btnCurrentLocation)
        self.mapView.delegate = self;
        self.tblForAutocomplete.delegate = self
        self.tblForAutocomplete.dataSource = self
        self.mapView.translatesAutoresizingMaskIntoConstraints = false
        self.mapView.settings.allowScrollGesturesDuringRotateOrZoom = false;
        self.mapView.settings.rotateGestures = false;
        if comingFrom ==  SourceVC.CART_VC {
            if StoreSingleton.shared.deliveryAddress.isEmpty() {
                self.goToCurrentLocation()
            }else {
                location = StoreSingleton.shared.deliveryLatLng
                self.txtAddress.text = StoreSingleton.shared.deliveryAddress
                let camera = GMSCameraPosition.camera(withLatitude: location[0], longitude: location[1], zoom: 15.0)
                self.mapView.camera = camera;
            }
        }else {
            self.goToCurrentLocation()
        }
        
        tblForAutocomplete.estimatedRowHeight = 50
        tblForAutocomplete.rowHeight = UITableView.automaticDimension
        updateUIAccordingToTheme()
    }
    
    override func updateUIAccordingToTheme() {
        imgForStoreLocationIcon.image = UIImage.init(named: "store_location")!.imageWithColor(color: .themeIconTintColor)!
        tblForAutocomplete.reloadData()
    }
    
    //MARK: Button action methods
    @IBAction func onClickBtnDone(_ sender: UIButton){
        if !address.isEmpty() && location[0] != 0.0 && location[1] != 0.0 {
            if comingFrom == SourceVC.CART_VC {
                wsUpdateOrderAddress()
            }else if comingFrom == SourceVC.CREATE_ORDER_VC {
                self.wsUpdateOrderAddress()

            }else {
                //                self.wsCheckStoreLocation()
                self.delegate?.finalAddressAndLocation(address: self.address, latitude: self.location[0], longitude: self.location[1])
                self.navigationController?.popViewController(animated: true)

            }
        }else {
            Utility.showToast(message: "MSG_LOCATION_NOT_GETTING".localized)
        }
    }
    /*func wsUpdateCartAddress() {
     Utility.showLoading()


     let destinationAddress:Address = Address.init()
     destinationAddress.address = address
     destinationAddress.addressType = AddressType.DESTINATION
     destinationAddress.userType = CONSTANT.TYPE_STORE
     destinationAddress.note = "Note"
     destinationAddress.city = ""
     destinationAddress.location = location



     let cartUserDetail:CartUserDetail = CartUserDetail();
     cartUserDetail.email = ""
     cartUserDetail.countryPhoneCode = preferenceHelper.getPhoneCountryCode()
     cartUserDetail.name = ""
     cartUserDetail.phone = ""
     destinationAddress.userDetails = cartUserDetail
     StoreSingleton.shared.destinationAddress = [destinationAddress]

     let addressDict:[[String:Any]] = [destinationAddress.toDictionary()]
     Utility.showLoading()

     let dictParam : [String : Any] =
     [Google.DESTINATION_ADDRESSES : addressDict,
     PARAMS.CART_ID : preferenceHelper.getCartID(),
     ]
     let alamoFire:AlamofireHelper = AlamofireHelper();
     alamoFire.getResponseFromURL(url: WebService.WS_CHANGE_DELIVERY_ADDRESS, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in

     if  Parser.isSuccess(response: response, withSuccessToast: true, andErrorToast: true) {
     StoreSingleton.shared.deliveryLatLng = self.location
     StoreSingleton.shared.deliveryAddress = self.address

     self.delegate?.finalAddressAndLocation(address: self.address, latitude: self.location[0], longitude: self.location[1])
     self.navigationController?.popViewController(animated: true)

     }

     }
     }*/
    
    func wsCheckStoreLocation() {
        Utility.showLoading()
        let dictParam : [String : Any] =
            [
                PARAMS.LATITUDE : location[0],
                PARAMS.LONGITUDE : location[1],
                PARAMS.CITY_ID : strCityID
            ]
        print(dictParam)
        
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_CHECK_STORE_LOCATION, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            print(response)
            if  Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true) {
                Utility.hideLoading()

                self.delegate?.finalAddressAndLocation(address: self.address, latitude: self.location[0], longitude: self.location[1])
                self.navigationController?.popViewController(animated: true)
                
            }
            
        }
    }
    
    func wsUpdateOrderAddress() {
        Utility.showLoading()
        let destinationAddress:Address = Address.init()
        destinationAddress.address = address
        destinationAddress.addressType = AddressType.DESTINATION
        destinationAddress.userType = CONSTANT.TYPE_STORE
        destinationAddress.note = "Note"
        destinationAddress.city = ""
        destinationAddress.location = location
        
        let cartUserDetail:CartUserDetail = CartUserDetail();
        cartUserDetail.email = ""
        cartUserDetail.countryPhoneCode = preferenceHelper.getPhoneCountryCode()
        cartUserDetail.name = ""
        cartUserDetail.phone = ""
        destinationAddress.userDetails = cartUserDetail
        
        
        let dictParam : [String : Any] =
            [PARAMS.DESTINATION_ADDRESSES : address,
             PARAMS.LATITUDE : location[0],
             PARAMS.LONGITUDE : location[1],
             PARAMS.STORE_ID : preferenceHelper.getUserId(),
             PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken()
            ]
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.CHANGE_DELIVERY_ADDRESS_WITHOUT_ITEM, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            
            if  Parser.isSuccess(response: response, withSuccessToast: true, andErrorToast: true) {
                StoreSingleton.shared.deliveryLatLng = self.location
                StoreSingleton.shared.deliveryAddress = self.address
                StoreSingleton.shared.destinationAddress = [destinationAddress]
                self.delegate?.finalAddressAndLocation(address: self.address, latitude: self.location[0], longitude: self.location[1])
                self.navigationController?.popViewController(animated: true)
                
            }
            
        }
    }

    @IBAction func onClickBtnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        isMoveThroughGesture = gesture;
    }

    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition){
        if isMoveThroughGesture {
            let myCoordinate = position.target
            let locationManager = LocationManager()
            let locationAddress =
                locationManager.getAddressFromLatLong(latitude: (myCoordinate.latitude), longitude: (myCoordinate.longitude))
            self.address = locationAddress.0
            self.txtAddress.text = locationAddress.0
            self.location = locationAddress.1
        }
    }
    
    @IBAction func onClickBtnCurrentLocation(_ sender: Any) {
        goToCurrentLocation()
    }
    func goToCurrentLocation() {
        if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() != CLAuthorizationStatus.denied {
            let locationManager = LocationManager()
            
            locationManager.currentAddressLocation { [unowned locationManager, unowned self]
                (myPlace, error) in
                
                DispatchQueue.main.async
                {
                    Utility.hideLoading()

                    if myPlace != nil
                    {
                        let camera = GMSCameraPosition.camera(withLatitude: (myPlace?.location?.coordinate.latitude)!, longitude: (myPlace?.location?.coordinate.longitude)!, zoom: 15.0)
                        let myCoordinate = (myPlace?.location?.coordinate) ?? CLLocationCoordinate2DMake(0.0, 0.0)
                        let locationAddress =
                            LocationManager().getAddressFromLatLong(latitude: (myCoordinate.latitude), longitude: (myCoordinate.longitude))
                        self.address = locationAddress.0
                        self.txtAddress.text = locationAddress.0
                        self.location = locationAddress.1
                        self.mapView.camera = camera;
                    }
                }
                
            }
        }else {
            
            openLocationDialog()
        }
    }
    
    func openLocationDialog() {
        let dialogForLocation = CustomAlertDialog.showCustomAlertDialog(title: "TXT_ATTENTION".localized, message: "MSG_LOCATION_ENABLE".localized, titleLeftButton: "".localizedUppercase, titleRightButton: "TXT_OK".localizedUppercase)
        dialogForLocation.onClickLeftButton = { [unowned dialogForLocation] in
            dialogForLocation.removeFromSuperview();
        }
        dialogForLocation.onClickRightButton = { [unowned dialogForLocation] in
            dialogForLocation.removeFromSuperview();
        }
    }

    //MARK: UITextField methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if txtAddress == textField {
            txtAddress.resignFirstResponder()
        }
        return true
    }
}

extension StoreLocationVC: UITableViewDataSource,UITableViewDelegate {

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
        tblForAutocomplete.isHidden = true
        self.txtAddress.text = arrForAdress[indexPath.row].2
        address  = self.txtAddress.text ?? ""
        if address.isEmpty() {
        }else {
            Utility.showLoading()
            location =  LocationManager().getLocationFromAddress(address: address)
            let camera = GMSCameraPosition.camera(withLatitude: location[0], longitude: location[1], zoom: 15.0)
            DispatchQueue.main.async {
                Utility.hideLoading()
                self.mapView.camera = camera;
            }
        }
    }
}

class AutocompleteCell: CustomCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var viewForAutocomplete: UIView!
    @IBOutlet weak var imgForStoreLocationIcon: UIImageView!

    //MARK:- LIFECYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        setLocalization()
        
    }
    //MARK:- SET CELL DATA
    func setCellData(place:(title:String,subTitle:String,detailText:String)) {
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
        imgForStoreLocationIcon.image = UIImage.init(named: "store_location")!.imageWithColor(color: .themeIconTintColor)!

        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

