//
//  DeliveryLocationVC.swift
//  edelivery
//
//  Created by Elluminati on 14/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftUI
protocol DelegateDeliveryListChanged {
    func didChangeDeliveryList()
}
class DeliveryLocationVC: BaseVC,GMSMapViewDelegate,UITextFieldDelegate, LeftDelegate,RightDelegate {
    // MARK: - OUTLETS
    
    @IBOutlet weak var lblSchedualAnOrder: UILabel!
    @IBOutlet weak var lblAsap: UILabel!
    @IBOutlet weak var heightForAutocomplete: NSLayoutConstraint!
    
    @IBOutlet weak var viewDateAndTime: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var tblForAutocomplete: UITableView!
    @IBOutlet weak var txtAutoComplete: UITextField!

    @IBOutlet weak var btnExpandMap: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var btnCurrentLocation: UIButton!
    
    @IBOutlet weak var imgForDeliveryLocation:UIImageView!
    
    @IBOutlet weak var viewForDescription: UIView!
    @IBOutlet weak var lblWhen: UILabel!
    @IBOutlet weak var viewForDeliveryTime: UIView!
    @IBOutlet weak var lblNoDeliveryAvailable: UILabel!
    
    @IBOutlet weak var viewForAsap: UIView!
    @IBOutlet weak var btnAsap: UIButton!
    @IBOutlet weak var btnUserPickUp: UIButton!
    
    @IBOutlet weak var viewForschedual: UIView!
    @IBOutlet weak var btnSchedualOrder: UIButton!
    @IBOutlet weak var viewForAutoComplete: UIView!
    @IBOutlet weak var lblUserPickUp: UILabel!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtTime: UITextField!
    
    @IBOutlet weak var viewForDate: UIView!
    @IBOutlet weak var viewForTime: UIView!
    
    @IBOutlet weak var imgASAP: UIImageView!
    @IBOutlet weak var imgSchedule: UIImageView!
    @IBOutlet weak var imgPickUp: UIImageView!
    @IBOutlet weak var btnASAPIcon: UIButton!
    @IBOutlet weak var btnScheduleIcon: UIButton!
    @IBOutlet weak var btnPickUpIcon: UIButton!
    @IBOutlet weak var viewDateIcon: UIView!
    @IBOutlet weak var viewTimeIcon: UIView!
    @IBOutlet weak var imgMapIcon: UIImageView!
    @IBOutlet weak var viewEmptyImage: UIView!
    
    @IBOutlet weak var viewFalatNo: UIView!
    @IBOutlet weak var viewStreet: UIView!
    @IBOutlet weak var viewLandmark: UIView!
    
    @IBOutlet weak var lblTapOnFavAddress: ActiveLabel!
    
    @IBOutlet weak var txtFlatNo: UITextField!
    @IBOutlet weak var txtStreet: UITextField!
    @IBOutlet weak var txtLandmark: UITextField!
    
    @IBOutlet weak var viewFavAddress: UIView!
    
    var minDate = Date()
    var maxDate = Date()
    var favAddressPush = false
    
    // MARK: - VARIABLES
    var futureDateMillisecond:Int64 = 0
    var isMoveThroughGesture:Bool = false
    var myDeliveryAddress:String? = nil
    var myCoordinate:CLLocationCoordinate2D? = nil
    let btnFavAddress = UIButton.init(type: .custom)
    
    var locationManager : LocationManager? = LocationManager()
    var arrForAdress:[(title:String,subTitle:String,address: String)] = []
    var delegateCheckDeliveryList: DelegateDeliveryListChanged? = nil
    var isAddressSelect = true
    
    // MARK: - LIFECYCLE
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let selectors = [#selector(self.locationUpdate(_:)), #selector(self.locationFail(_:))]
        LocationCenter.default.addObservers(self, selectors)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalization()
        delegateLeft = self
        delegateRight = self
        
        if !preferenceHelper.getUserId().isEmpty() {
            btnFavAddress.setImage(UIImage(named: "menuFavourite")?.imageWithColor(color: UIColor.themeColor), for: .normal)
            self.setRightBarButton(button: btnFavAddress);
        }

        self.mapView.bringSubviewToFront(self.btnExpandMap)
        self.mapView.bringSubviewToFront(self.imgForDeliveryLocation)
        self.mapView.bringSubviewToFront(self.btnCurrentLocation)
        self.mapView.delegate = self
        //        self.mapView.translatesAutoresizingMaskIntoConstraints = false
        self.mapView.settings.allowScrollGesturesDuringRotateOrZoom = false
        if currentBooking.currentPlaceData.address.isEmpty() {
        }else {
            let camera = GMSCameraPosition.camera(withLatitude: currentBooking.currentPlaceData.latitude, longitude: currentBooking.currentPlaceData.longitude, zoom: 15.0)
            self.mapView.camera = camera
            self.txtAutoComplete.text = currentBooking.currentPlaceData.address
            self.checkForDelivery()
            txtFlatNo.text! = currentBooking.currentSendPlaceData.flat_no
            txtLandmark.text! = currentBooking.currentSendPlaceData.landmark
            txtStreet.text! = currentBooking.currentSendPlaceData.street
        }
        
        self.setNavigationTitle(title:"TXT_DELIVERY_LOCATION".localized)
        let gesture:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(DeliveryLocationVC.onClickBtnSchedualTime(_:)))
        viewDateAndTime.addGestureRecognizer(gesture)
        viewDateAndTime.isUserInteractionEnabled = true
        self.setBackBarItem(isNative: false)
        self.tblForAutocomplete.estimatedRowHeight = UITableView.automaticDimension
        APPDELEGATE.setupNavigationbar()
        /*    UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
         UINavigationBar.appearance().isTranslucent = true
         UINavigationBar.appearance().shadowImage = UIImage() */
        addTapOnFavAddress()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Utility.hideLoading()
        btnSchedualOrder.isSelected = currentBooking.isFutureOrder
        btnScheduleIcon.isSelected = btnSchedualOrder.isSelected
        btnAsap.isSelected = !currentBooking.isFutureOrder
        btnASAPIcon.isSelected = btnAsap.isSelected
        viewDateAndTime.isHidden = !currentBooking.isFutureOrder
        lblAsap.textColor = btnAsap.isSelected ? UIColor.themeColor : UIColor.themeTextColor
        lblSchedualAnOrder.textColor = btnSchedualOrder.isSelected ? UIColor.themeColor : UIColor.themeTextColor
        if currentBooking.isFutureOrder
        {
            futureDateMillisecond = currentBooking.futureDateMilliSecond
            let components = Utility.millisecondToDateComponents(milliSeconds: currentBooking.futureDateMilliSecond)
            /*self.lblDate.text = */
            self.txtDate.text =
                String(components.day!)  +  "-" + String(components.month!) +  "-" +  String(components.year!)
            //self.lblTime.text = String(components.hour!) +  "-" + String(components.minute!)
            
            if currentBooking.futureDateMilliSecond2 > 0{
                let components2 = Utility.millisecondToDateComponents(milliSeconds: currentBooking.futureDateMilliSecond2)
                /* self.lblTime.text */self.txtTime.text = String(components.hour!) +  "-" + String(components2.hour!)
            }else{
                /* self.lblTime.text */ self.txtTime.text =  String(components.hour!) +  "-" + String(components.minute!)
            }
        }
        
        if currentBooking.currentPlaceData.address.isEmpty() {
            //self.goToCurrentLocation()
        }else {
            self.checkForDelivery()
            //               let camera = GMSCameraPosition.camera(withLatitude: currentBooking.currentPlaceData.latitude, longitude: currentBooking.currentPlaceData.longitude, zoom: 15.0)
            //               self.mapView.camera = camera
            //               self.txtAutoComplete.text = currentBooking.currentPlaceData.address
            
            let camera = GMSCameraPosition.camera(withLatitude: currentBooking.currentSendPlaceData.latitude, longitude: currentBooking.currentSendPlaceData.longitude, zoom: 15.0)
            self.mapView.camera = camera
            self.txtAutoComplete.text = currentBooking.currentSendPlaceData.address
            isAddressSelect = true
            txtFlatNo.text! = currentBooking.currentSendPlaceData.flat_no
            txtLandmark.text! = currentBooking.currentSendPlaceData.landmark
            txtStreet.text! = currentBooking.currentSendPlaceData.street
        }
        
        
        let dateImage = UIImageView(image: UIImage(named: "schedule_order_icon")?.imageWithColor(color: .themeColor))
        let timeImage = UIImageView(image: UIImage(named: "asap_icon"))
        self.txtDate.rightView = dateImage
        self.txtDate.rightViewMode = .always
        self.txtTime.rightView = timeImage
        self.txtTime.rightViewMode = .always
        self.txtDate.layer.borderWidth = 0.1
        self.txtTime.layer.borderWidth = 0.1
        self.txtDate.layer.borderColor = UIColor.themeLightLineColor.cgColor
        self.txtTime.layer.borderColor = UIColor.themeLightLineColor.cgColor
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.favAddressPush = false
    }
    
    override func viewDidLayoutSubviews() {
        btnDone.applyRoundedCornersWithHeight()
        viewForAutoComplete.addShadow(shadowColor: UIColor.themeLightLineColor, cornerRadius: 5.0, shadowRadius: 3)
        viewDateIcon.setRound(withBorderColor: UIColor.themeTextColor, andCornerRadious: 3.0, borderWidth: 0.1)
        viewTimeIcon.setRound(withBorderColor: UIColor.themeTextColor, andCornerRadious: 3.0, borderWidth: 0.1)
        
        viewFalatNo.addShadow(shadowColor: UIColor.themeLightLineColor, cornerRadius: 5.0, shadowRadius: 3)
        viewStreet.addShadow(shadowColor: UIColor.themeLightLineColor, cornerRadius: 5.0, shadowRadius: 3)
        viewLandmark.addShadow(shadowColor: UIColor.themeLightLineColor, cornerRadius: 5.0, shadowRadius: 3)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool){
        super.viewDidDisappear(animated)
        if currentBooking.currentPlaceData.address.isEmpty() {
            self.goToCurrentLocation()
        }
    }
    
    func addTapOnFavAddress() {
        let clickHere = ActiveType.custom(pattern: "\\s\("txt_click_here".localized)\\b")
        
        lblTapOnFavAddress.enabledTypes.append(clickHere)

        lblTapOnFavAddress.customize { label in
            label.text = "txt_do_you_want_to_add_fav_address".localized.replacingOccurrences(of: "****", with: "txt_click_here".localized)
            label.textColor = UIColor.themeTextColor
            label.customColor[clickHere] = UIColor.themeTextColor
            label.numberOfLines = 0
            label.handleCustomTap(for: clickHere) { [self]_ in
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
                PARAMS.FLAT_NO: self.txtFlatNo.text!,
                PARAMS.LANDMARK: self.txtLandmark.text!,
                PARAMS.STREET: self.txtStreet.text!,
                PARAMS.COUNTRY: currentBooking.currentSendPlaceData.country,
                PARAMS.COUNTRY_CODE: currentBooking.currentSendPlaceData.country_code,
            ]
            self.wsAddFavAddress(parameter: dictParam)
        }
    }
    
    
    func onClickLeftButton() {
        switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                if (currentBooking.deliveryStoreList.isEmpty) {
                    openExitDialog()
                } else {
                    removeObserver()
                    _ = self.navigationController?.popViewController(animated: true)
                }
                
            case .authorizedAlways, .authorizedWhenInUse:
                removeObserver()
                //            _ = self.navigationController?.popViewController(animated: true)
                if (currentBooking.deliveryStoreList.isEmpty) {
                    openExitDialog()
                } else {
                    
                    removeObserver()
                    _ = self.navigationController?.popViewController(animated: true)
                }
                
        }
    }
    
    func onClickRightButton() {
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "MainStoryboard", bundle: nil)
        favAddressPush = true
        if let vc : FavAddressListVC = mainView.instantiateViewController(withIdentifier: "FavAddressListVC") as? FavAddressListVC
        {
            vc.isFromDeliveryLocationScreen = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func removeObserver() {
        Common.nCd.removeObserver(self, name: Common.locationUpdateNtfNm, object: LocationCenter.default)
        Common.nCd.removeObserver(self, name: Common.locationFailNtfNm, object: LocationCenter.default)
    }
    
    func openExitDialog() {
        
        let dialogForExit = CustomAlertDialog.showCustomAlertDialog(title: "TXT_EXIT".localized, message: "MSG_ARE_YOU_SURE".localized, titleLeftButton: "".localizedCapitalized, titleRightButton: "TXT_OK".localizedCapitalized)
        dialogForExit.onClickLeftButton = {
            [unowned dialogForExit] in
            dialogForExit.removeFromSuperview()
            
        }
        dialogForExit.onClickRightButton = {
            [unowned dialogForExit] in
            
            dialogForExit.removeFromSuperview()
            exit(0)
        }
    }
    
    func setLocalization() {
        //Set Colors
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        viewForDescription.backgroundColor = UIColor.themeViewBackgroundColor
        viewDateAndTime.backgroundColor = UIColor.themeViewBackgroundColor
        viewForDate.backgroundColor = UIColor.themeViewBackgroundColor
        viewForTime.backgroundColor = UIColor.themeViewBackgroundColor
        viewForAutoComplete.backgroundColor = UIColor.themeViewBackgroundColor
        lblNoDeliveryAvailable.textColor = UIColor.themeTextColor
        lblNoDeliveryAvailable.backgroundColor = UIColor.themeViewBackgroundColor
        lblWhen.textColor = UIColor.themeTextColor
        //        lblAsap.textColor = UIColor.themeTextColor
        //        lblSchedualAnOrder.textColor = UIColor.themeTextColor
        txtAutoComplete.textColor = UIColor.themeTextColor
        btnDone.backgroundColor = UIColor.themeButtonBackgroundColor
        //        btnDone.titleLabel?.font = FontHelper.buttonText()
        btnDone.setTitleColor(UIColor.themeButtonTitleColor, for: .normal)
        btnDone.setTitle("TXT_DONE".localized, for: .normal)
        //Set Localization
        self.title = "TXT_DELIVERY_LOCATION".localized
        lblNoDeliveryAvailable.text = "TXT_NO_DELIVERY_FOUND".localized
        lblWhen.text = "TXT_WHEN".localized
        lblAsap.text = "TXT_APSA".localized
        lblSchedualAnOrder.text = "TXT_SCHEDULE_AN_ORDER".localized
        lblUserPickUp.text = "TXT_CUSTOMER_PICKUP".localized
        self.lblDate.text = "TXT_DATE".localized
        self.lblTime.text = "TXT_TIME".localized

        txtFlatNo.placeholder = "txt_flat_no_name".localized
        txtStreet.placeholder = "txt_street_no".localized
        txtLandmark.placeholder = "txt_landmark".localized
        
        lblTapOnFavAddress.text = "txt_do_you_want_to_add_fav_address".localized.replacingOccurrences(of: "****", with: "txt_click_here".localized)
        
        txtAutoComplete.font = FontHelper.textRegular()
        lblDate.textColor = UIColor.themeTextColor
        lblDate.font = FontHelper.textRegular()
        
        lblTime.textColor = UIColor.themeTextColor
        lblTime.font = FontHelper.textRegular()
        lblUserPickUp.textColor = UIColor.themeTextColor
        //Set View hide show
        lblNoDeliveryAvailable.isHidden = true
        /* Set Font */
        lblNoDeliveryAvailable.font = FontHelper.textLarge(size: 20)
        lblWhen.font = FontHelper.textMedium(size: FontHelper.medium)
        lblAsap.font = FontHelper.textRegular()
        lblSchedualAnOrder.font = FontHelper.textRegular()
        lblUserPickUp.font = FontHelper.textRegular()
        
        imgASAP.image = UIImage(named: "asap_icon")?.imageWithColor(color: UIColor.themeImageColor)
        txtDate.layer.borderColor = UIColor.themeTextColor.cgColor
        txtDate.layer.borderWidth = 0.1
        txtDate.borderStyle = .roundedRect
        txtDate.tintColor = .themeTextColor
        
        txtTime.layer.borderColor = UIColor.themeTextColor.cgColor
        txtTime.layer.borderWidth = 0.1
        txtTime.borderStyle = .roundedRect
        txtTime.tintColor = .themeTextColor
        
        btnASAPIcon.setImage(UIImage(named:"asap_icon")?.imageWithColor(color: UIColor.themeTitleColor), for: .normal)
        
        btnScheduleIcon.setImage(UIImage(named:"schedule_gray_icon")?.imageWithColor(color: UIColor.themeTitleColor), for: .normal)
        
        btnPickUpIcon.setImage(UIImage(named:"pickup_icon"), for: .normal)
        btnPickUpIcon.setImage(UIImage(named:"pickup_color_icon")?.imageWithColor(color: .themeColor), for: .selected)
        btnASAPIcon.setImage(UIImage(named:"asap_icon")?.imageWithColor(color: UIColor.themeColor), for: .selected)
        btnScheduleIcon.setImage(UIImage(named:"schedule_gray_icon")?.imageWithColor(color: UIColor.themeColor), for: .selected)
        imgMapIcon.image = UIImage(named: "map")?.imageWithColor(color: UIColor.themeTitleColor)
        txtAutoComplete.tintColor = UIColor.themeTextColor
        
        if preferenceHelper.getUserId().isEmpty() {
            viewFavAddress.isHidden = true
        } else {
            viewFavAddress.isHidden = false
        }
    }
    
    override func updateUIAccordingToTheme() {
        
        imgMapIcon.image = UIImage(named:"map")?.imageWithColor(color: UIColor.themeTitleColor)
        btnASAPIcon.setImage(UIImage(named:"asap_icon")?.imageWithColor(color: UIColor.themeTitleColor), for: .normal)
        btnScheduleIcon.setImage(UIImage(named:"schedule_gray_icon")?.imageWithColor(color: UIColor.themeTitleColor), for: .normal)
        btnFavAddress.setImage(UIImage(named: "menuFavourite")?.imageWithColor(color: UIColor.themeColor), for: .normal)
        self.setBackBarItem(isNative: false)
    }
    @IBAction func onClickBtnSchedualTime(_ sender: Any) {
        
        let datePickerDialog:CustomDatePickerDialog = CustomDatePickerDialog.showCustomDatePickerDialog(title: "TXT_SELECT_FUTURE_ORDER_TIME".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_SELECT".localized,mode: .dateAndTime)
        
        datePickerDialog.datePicker.locale = Locale(identifier: "en_GB")
        datePickerDialog.datePicker.timeZone = TimeZone.init(identifier: currentBooking.selectedCityTimezone)
        datePickerDialog.setMinDate(mindate: Date().addHours(hoursToAdd: 1))
        datePickerDialog.onClickLeftButton = {
            [unowned datePickerDialog] in
            
            datePickerDialog.removeFromSuperview()
        }
        
        datePickerDialog.onClickRightButton = { [unowned self, unowned datePickerDialog] (selectedDate:Date) in
            
            self.futureDateMillisecond = Utility.convertSelectedDateToMilliSecond(serverDate: selectedDate, strTimeZone: currentBooking.selectedCityTimezone)
            
            let components = Calendar.current.dateComponents(in: TimeZone.init(identifier: currentBooking.selectedCityTimezone)!, from: selectedDate)
            /*self.lblDate.text = */
            self.txtDate.text =
                String(components.day!)  +  "-" + String(components.month!) +  "-" +  String(components.year!)
            /* self.lblTime.text = */
            self.txtTime.text =
                String(components.hour!) +  "-" + String(components.minute!)
            
            datePickerDialog.removeFromSuperview()
        }
    }
    
    //MARK: TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        isAddressSelect = false
        return true
    }
    
    // MARK: - ACTION METHODS
    @IBAction func onClickBtnSchedualOrder(_ sender: Any) {
        viewDateAndTime.isHidden = false
        btnAsap.isSelected = false
        btnSchedualOrder.isSelected = true
        btnUserPickUp.isSelected = false
        btnASAPIcon.isSelected = false
        btnScheduleIcon.isSelected = true
        btnPickUpIcon.isSelected = false
        self.lblAsap.textColor = UIColor.themeTextColor
        self.lblSchedualAnOrder.textColor = UIColor.themeColor
        currentBooking.isUserPickUpOrder = false
    }
    
    @IBAction func onClickBtnCurrentLocation(_ sender: Any) {
        switch(CLLocationManager.authorizationStatus()) {
            
            case .notDetermined:
                //Asking location permission
                locationManager?.currentLocation(blockCompletion: { (location, error) in
                })
            case  .restricted, .denied:
                //openLocationDialog()
                allowAlert()
            case .authorizedAlways, .authorizedWhenInUse:
                self.goToCurrentLocation()
        }
    }
    
    @IBAction func onClickBtnAsap(_ sender: UIButton) {
        viewDateAndTime.isHidden = true
        btnAsap.isSelected = true
        btnSchedualOrder.isSelected = false
        btnUserPickUp.isSelected = false
        
        btnASAPIcon.isSelected = true
        btnScheduleIcon.isSelected = false
        btnPickUpIcon.isSelected = false
        
        futureDateMillisecond = 0
        self.lblDate.text = "TXT_DATE".localized
        self.lblTime.text = "TXT_TIME".localized
        self.lblAsap.textColor = UIColor.themeColor
        self.lblSchedualAnOrder.textColor = UIColor.themeTextColor
        self.lblUserPickUp.textColor = UIColor.themeTextColor
        currentBooking.isUserPickUpOrder = false
    }
    @IBAction func onClickBtnUserPickup(_ sender: UIButton) {
        viewDateAndTime.isHidden = true
        btnAsap.isSelected = false
        btnSchedualOrder.isSelected = false
        btnUserPickUp.isSelected = true
        
        btnASAPIcon.isSelected = false
        btnScheduleIcon.isSelected = false
        btnPickUpIcon.isSelected = true
        
        futureDateMillisecond = 0
        self.lblDate.text = "TXT_DATE".localized
        self.lblTime.text = "TXT_TIME".localized
        self.lblAsap.textColor = UIColor.themeTextColor
        self.lblSchedualAnOrder.textColor = UIColor.themeTextColor
        self.lblUserPickUp.textColor = UIColor.themeColor
        currentBooking.isUserPickUpOrder = true
    }
    
    @IBAction func onClickBtnExpandMapView(_ sender: UIButton){
        if sender.tag == 1 {
            sender.tag = 0
            UIView.animate(withDuration: 0.5, animations: {
                
            }, completion: { (complete) in
                self.viewForDescription.isHidden = false
                self.updateViewConstraints()
                self.stackView.layoutIfNeeded()
            })
            
        }
        else {
            
            sender.tag = 1
            UIView.animate(withDuration: 0.5, animations: {
                self.viewForDescription.isHidden = true
                
            }, completion: { (complete) in
                self.updateViewConstraints()
                self.stackView.layoutIfNeeded()
            })
            
        }
    }
    @IBAction func searching(_ sender: UITextField){
        if (sender.text?.count)! > 2 {
            
            LocationManager().googlePlacesResult(input: sender.text!, completion: { [unowned self](array) in
                
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
    @IBAction func onClickBtnDone(_ sender: Any) {
        if !checkValidation() {
            return
        }
        if (currentBooking.deliveryStoreList.isEmpty) {
            Utility.showToast(message: "MSG_PLEASE_SELECT_VALID_ADDRESS".localized)
        } else {
            if btnAsap.isSelected {
                currentBooking.currentSendPlaceData.flat_no = txtFlatNo.text!
                currentBooking.currentSendPlaceData.landmark = txtLandmark.text!
                currentBooking.currentSendPlaceData.street = txtStreet.text!
                currentBooking.isFutureOrder = false
                _ = self.navigationController?.popToRootViewController(animated:true)
            } else {
                if futureDateMillisecond != 0 {
                    currentBooking.futureDateMilliSecond = futureDateMillisecond
                    let offSetMiliSecond = Int64((TimeZone.init(identifier: currentBooking.selectedCityTimezone) ?? TimeZone.current).secondsFromGMT() * 1000)
                    currentBooking.isFutureOrder = true
                    currentBooking.currentSendPlaceData.flat_no = txtFlatNo.text!
                    currentBooking.currentSendPlaceData.landmark = txtLandmark.text!
                    currentBooking.currentSendPlaceData.street = txtStreet.text!
                    currentBooking.futureUTCMilliSecond = currentBooking.futureDateMilliSecond - offSetMiliSecond
                    _ = self.navigationController?.popToRootViewController(animated:true)
                } else {
                    Utility.showToast(message: "MSG_PLEASE_SELECT_VALID_DATE".localized)
                }
            }
        }
    }

    //MARK: - MAP VIEW DELEGATE METHODS    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        isMoveThroughGesture = gesture
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition){
        
        if isMoveThroughGesture {
            myCoordinate = position.target
            locationManager?.getAddressFromLatLong(latitude: (myCoordinate?.latitude)!, longitude: (myCoordinate?.longitude)!)
            self.txtAutoComplete.text = currentBooking.currentSendPlaceData.address
            isAddressSelect = true
        }
        self.checkForDelivery()
    }
    
    func goToCurrentLocation() {
        if LocationCenter.isServicesEnabled && (!LocationCenter.isDenied) && favAddressPush == false {
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

        self.myCoordinate = location.coordinate
        self.locationManager?.getAddressFromLatLong(latitude: (self.myCoordinate?.latitude)!, longitude: (self.myCoordinate?.longitude)!)

        if self.txtAutoComplete == nil {
            removeObserver()
            return
        }
        self.txtAutoComplete.text = currentBooking.currentSendPlaceData.address
        isAddressSelect = true
        DispatchQueue.main.async {
            let camera = GMSCameraPosition.camera(withLatitude: currentBooking.currentSendPlaceData.latitude, longitude: currentBooking.currentSendPlaceData.longitude, zoom: 15.0)
            self.checkForDelivery()
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

    func allowAlert() {
        OperationQueue.main.addOperation {
            let msg = String(format: "%@", "\nPlease enable location services from the Settings app.\n\n1. Go to Settings > Privacy > Location Services.\n\n2. Make sure that location services is on.")
            
            let aC = UIAlertController(title: "Allow location",
                                       message: msg,
                                       preferredStyle: UIAlertController.Style.alert)
            
            let act = UIAlertAction(title: "OK",
                                    style: UIAlertAction.Style.default,
                                    handler: { (act: UIAlertAction) in
                                        Common.openSettingsApp()
                                    })
            
            let act2 = UIAlertAction(title: "CANCEL",
                                     style: UIAlertAction.Style.default,
                                     handler: { (act: UIAlertAction) in
                                        aC.dismiss(animated: true, completion: nil)
                                     })
            
            aC.addAction(act2)
            aC.addAction(act)
            
            Common.appDelegate.window?.rootViewController?.present(aC, animated: true, completion: {
                print(#function)
            })
        }
    }
    
    //MARK:- USER DEFINE METHODS
    func checkForDelivery(){
        
        currentBooking.currentAddress = currentBooking.currentSendPlaceData.address
        currentBooking.currentLatLng =
            [currentBooking.currentSendPlaceData.latitude,
             currentBooking.currentSendPlaceData.longitude]
        
        
        if ((currentBooking.currentCity ?? ""  != currentBooking.currentSendPlaceData.city1 )
                || currentBooking.bookCityId == "") {
            
            let dictParam: [String:Any] = currentBooking.currentSendPlaceData.toDictionary()
            print("wsGetDeliveriesInNearestCity Deliveryloacation : \(dictParam)")
            self.wsGetDeliveriesInNearestCity(parameter:dictParam)
            
        }else {
            currentBooking.currentPlaceData.latitude = currentBooking.currentSendPlaceData.latitude
            currentBooking.currentPlaceData.longitude = currentBooking.currentSendPlaceData.longitude
            currentBooking.currentPlaceData.address =  currentBooking.currentSendPlaceData.address
            
            self.updateUiWhenDeliveryAvailable(isUpdate:true)
        }
        
        
    }
    
    func updateUiWhenDeliveryAvailable(isUpdate:Bool){
       
        if (isUpdate) {
            if lblNoDeliveryAvailable != nil{
                lblNoDeliveryAvailable.isHidden = true
            }
            if viewEmptyImage != nil{
                viewEmptyImage.isHidden = true
                viewFalatNo.isHidden = false
                viewStreet.isHidden = false
                viewLandmark.isHidden = false
            }
            
        }
        else {
            lblNoDeliveryAvailable.isHidden = false
            viewEmptyImage.isHidden = false
            viewFalatNo.isHidden = true
            viewStreet.isHidden = true
            viewLandmark.isHidden = true
        }
    }
    
    //MARK:- WEB SERVICE CALL
    func wsGetDeliveriesInNearestCity(parameter:Dictionary<String,Any>){
        
        print("WS_GET_NEAREST_DELIVERY_LIST \(parameter)")
        
        Utility.showLoading()
        let afn:AlamofireHelper = AlamofireHelper.init()
        afn.getResponseFromURL(url: WebService.WS_GET_NEAREST_DELIVERY_LIST, methodName: AlamofireHelper.POST_METHOD, paramData: parameter) {(response, error) -> (Void) in
            
            print("WS_GET_NEAREST_DELIVERY_LIST \(response)")
            Utility.hideLoading()
            if Parser.parseDeliveryStore(response) {
                DispatchQueue.main.async
                {
                    CommonFunctions.addLocationToLocalDB()
                    self.updateUiWhenDeliveryAvailable(isUpdate:true)
                    self.delegateCheckDeliveryList?.didChangeDeliveryList()
                }
            }else {
                DispatchQueue.main.async
                {
                    self.updateUiWhenDeliveryAvailable(isUpdate:false)
                }
            }
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
    
    func checkValidation() -> Bool {
        if txtAutoComplete.text!.isEmpty || !isAddressSelect {
            Utility.showToast(message: "MSG_PLEASE_SELECT_VALID_ADDRESS".localized)
            return false
        }
        return true
    }
}

extension DeliveryLocationVC: UITableViewDataSource,UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrForAdress.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let autoCompleteCell = tableView.dequeueReusableCell(withIdentifier: "autoCompleteCell", for: indexPath) as! AutocompleteCell
        if indexPath.row < arrForAdress.count {
            autoCompleteCell.setCellData(place: arrForAdress[indexPath.row])
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
            Utility.showLoading()
            self.locationManager?.setPlaceDataFromAddress(address: address)
            let camera = GMSCameraPosition.camera(withLatitude: (currentBooking.currentSendPlaceData.latitude), longitude: (currentBooking.currentSendPlaceData.longitude), zoom: 15.0)
            DispatchQueue.main.async {
                self.view.endEditing(true)
                Utility.hideLoading()
                self.mapView.camera = camera
            }
        }
    }
}

class AutocompleteCell: CustomTableCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var viewForAutocomplete: UIView!
    @IBOutlet weak var lblDivider: UILabel!
    @IBOutlet weak var imgMapIcon: UIImageView!
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
        lblDivider.textColor = UIColor.themeLightLineColor
        
        /*Set Font*/
        lblTitle.font =  FontHelper.textRegular(size: 14)
        lblSubTitle.font =  FontHelper.tiny()
        imgMapIcon.image = UIImage(named: "map")?.imageWithColor(color: UIColor.themeTitleColor)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    override func updateUIAccordingToTheme() {
        imgMapIcon.image = UIImage(named: "map")?.imageWithColor(color: UIColor.themeTitleColor)
        
    }
}
