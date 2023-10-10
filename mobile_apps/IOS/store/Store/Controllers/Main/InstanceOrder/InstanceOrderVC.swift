 //
//  InstanceOrderVC.swift
//
//
//  Created by Jaydeep Vyas on 14/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit

class InstanceOrderVC:BaseVC,UITextFieldDelegate,LocationHandlerDelegate,UIGestureRecognizerDelegate {
    
    //MARK: OutLets
    @IBOutlet weak var txtProductPrice: UITextField!
    @IBOutlet weak var viewForHeader: UIView!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtContactNo: UITextField!
    @IBOutlet weak var btnPlaceOrder: UIButton!
    @IBOutlet weak var btnLocation: UIButton!

    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var txtCountryCode: UITextField!
    
    @IBOutlet weak var stkAddress: UIStackView!
    @IBOutlet weak var txtAddNote: UITextField!
    
    @IBOutlet weak var txtFlat: UITextField!
    @IBOutlet weak var txtStreet: UITextField!
    @IBOutlet weak var txtLandmark: UITextField!
    
    //MARK: Variables
    
    var myDeliveryAddress:String = "";
    var myDeliveryLatitude:Double = 0.0;
    var myDeliveryLongitude:Double = 0.0;
    var userId:String = ""
    var selectedVehicleId:String = ""
    var isManuallyAssignProvider : Bool = false
    var provider_id:String = ""

    
    var currentBooking:StoreSingleton = StoreSingleton.shared;
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        Utility.showLoading()
        self.wsgetVehicleList()
        super.hideBackButtonTitle()
        setLocalization()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gestureRecognizer:)))
               gestureRecognizer.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)
        
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(self.onClickBtnAddress(_:)));
        stkAddress.addGestureRecognizer(tapGesture)
        
        txtContactNo.keyboardType = .numberPad
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
    }
   
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayout()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    func setLocalization() {
        self.setNavigationTitle(title:"TXT_INSTANT_ORDER".localizedCapitalized)
        
        /*Set Color*/
        txtFirstName.textColor = UIColor.themeTextColor
        txtLastName.textColor = UIColor.themeTextColor
        txtEmail.textColor = UIColor.themeTextColor
        txtContactNo.textColor = UIColor.themeTextColor
        txtAddress.textColor = UIColor.themeTextColor
        txtProductPrice.textColor = UIColor.themeTextColor
        txtAddNote.textColor = UIColor.themeTextColor
        txtFlat.textColor = UIColor.themeTextColor
        txtStreet.textColor = UIColor.themeTextColor
        txtLandmark.textColor = UIColor.themeTextColor
        
        view.backgroundColor = UIColor.themeViewBackgroundColor
        btnPlaceOrder.backgroundColor = UIColor.themeColor;
        btnPlaceOrder.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        
        txtCountryCode.textColor = UIColor.themeTextColor
        lblMobileNumber.textColor = UIColor.themeLightTextColor
        
        lblMobileNumber.text = "TXT_MOBILE_NO".localizedCapitalized
        txtCountryCode.text = StoreSingleton.shared.store.countryPhoneCode
      /* Set text */
        txtAddNote.placeholder = "TXT_ADD_NOTE".localizedCapitalized
        txtFirstName.placeholder = "TXT_FIRST_NAME".localizedCapitalized
        txtLastName.placeholder = "TXT_LAST_NAME".localized
        txtEmail.placeholder = "TXT_EMAIL".localized
        txtContactNo.placeholder = "TXT_CONTACT_NO".localizedCapitalized
        txtAddress.placeholder = "TXT_DELIVERY_ADDRESS".localizedCapitalized
        txtProductPrice.placeholder =   "TXT_ENTER_PRICE".localizedCapitalized
        btnPlaceOrder.setTitle("TXT_INVOICE".localizedUppercase, for: .normal)
        txtFlat.placeholder = "txt_flat_no_name".localizedCapitalized
        txtStreet.placeholder = "txt_street_no".localizedCapitalized
        txtLandmark.placeholder = "txt_landmark".localizedCapitalized
        
        txtFirstName.text = ""
        txtContactNo.text = ""
        txtLastName.text = ""
        txtEmail.text = ""
        txtProductPrice.text = ""
        txtAddress.text = ""
        txtAddNote.text = ""
        txtAddress.isUserInteractionEnabled = false
        txtAddress.isEnabled = false
        /* Set Font */
        txtFirstName.font = FontHelper.textRegular()
        txtContactNo.font = FontHelper.textRegular()
        txtAddress.font = FontHelper.textRegular()
        txtLastName.font = FontHelper.textRegular()
        txtCountryCode.font = FontHelper.textRegular()
        txtFlat.font = FontHelper.textRegular()
        txtStreet.font = FontHelper.textRegular()
        txtLandmark.font = FontHelper.textRegular()
        
        txtEmail.font = FontHelper.textRegular()
        txtAddNote.font = FontHelper.textRegular()
        txtProductPrice.font = FontHelper.textRegular()
        btnPlaceOrder.titleLabel?.font = FontHelper.textRegular()
        updateUIAccordingToTheme()
    }
    func setupLayout() {
        
    }
    
    override func updateUIAccordingToTheme() {
        btnLocation.setImage(UIImage(named: "location_arrow"), for: .normal)
        txtContactNo.tintColor = .themeTextColor
    }
    
    @objc func handleTap(gestureRecognizer: UIGestureRecognizer)
        {
            self.view.endEditing(true)
        }
    
    @IBAction func onClickPlaceOrder(_ sender: Any) {
        self.view.endEditing(true)
        
        if self.checkValidation() {
            self.openVehicleDialog()
        }
        
        
    }
    func checkValidation() -> Bool {
        let validMobileNumber = txtContactNo.text!.isValidMobileNumber()
        let validEmail = txtEmail.text!.checkEmailValidation()
        if (
            (txtFirstName.text?.isEmpty())! ||
                (txtLastName.text?.isEmpty())! ||
                (txtEmail.text?.isEmpty())! ||
                (txtContactNo.text?.isEmpty())!  ||
                (txtAddress.text?.isEmpty())! ||
                (txtCountryCode.text?.isEmpty())!  ||
                (txtProductPrice.text?.isEmpty())!
            ) {
            if (txtProductPrice.text?.isEmpty())! {
                txtProductPrice.becomeFirstResponder()
                
                Utility.showToast(message:"MSG_ENTER_VALID_AMOUNT".localized)
            }else if (txtCountryCode.text?.isEmpty())! {
                txtCountryCode.becomeFirstResponder();
                Utility.showToast(message:"MSG_PLEASE_ENTER_VALID_COUNTRYCODE".localized)
                
            }else if (txtFirstName.text?.isEmpty())! {
                txtFirstName.becomeFirstResponder();
                Utility.showToast(message:"MSG_PLEASE_ENTER_VALID_NAME".localized)
                
            }else if (txtLastName.text?.isEmpty())! {
                txtLastName.becomeFirstResponder();
                Utility.showToast(message:"MSG_PLEASE_ENTER_VALID_NAME".localized)
                
            }else if (txtEmail.text?.isEmpty())! {
                txtEmail.becomeFirstResponder();
                Utility.showToast(message:"MSG_PLEASE_ENTER_EMAIL".localized)
                
                
            }else if (txtContactNo.text?.isEmpty())! {
                txtContactNo.becomeFirstResponder();
                
                Utility.showToast(message:"MSG_PLEASE_ENTER_MOBILE_NUMBER".localized)
            }else if (txtAddress.text?.isEmpty())! {
                txtAddress.becomeFirstResponder();
                
                Utility.showToast(message:"MSG_PLEASE_ENTER_ADDRESS".localized)
            }
           
            return false
            
        }else {
            
            if (txtProductPrice.text!.doubleValue == nil) {
                txtProductPrice.becomeFirstResponder();
                Utility.showToast(message:"MSG_ENTER_VALID_AMOUNT".localized)
            }else if(validEmail.0 == false) {
                txtEmail.becomeFirstResponder();
                Utility.showToast(message:validEmail.1)
            }else if validMobileNumber.0 == false{
                txtContactNo.becomeFirstResponder();
                Utility.showToast(message:validMobileNumber.1)

            }

            //if (txtContactNo.text!.count < 8) {
//                txtContactNo.becomeFirstResponder();
//                let myString = String(format: NSLocalizedString("MSG_PLEASE_ENTER_VALID_MOBILE_NUMBER", comment: ""),String(8),String(15))
//
//                Utility.showToast(message:myString)
//            }
        else {
                return true
            }
            return false
        }
        
    }
    
    
    func finalAddressAndLocation(address: String, latitude: Double, longitude: Double) {
        self.txtAddress.text = address
        self.myDeliveryAddress = address
        self.myDeliveryLatitude = latitude
        self.myDeliveryLongitude = longitude
    }
    
  
    @IBAction func searching(_ sender: UITextField) {
        if (sender.text?.count)! > 2 {
            
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if txtProductPrice == textField {
            txtFirstName.becomeFirstResponder()
        }else if txtFirstName == textField {
            txtLastName.becomeFirstResponder()
        }else if txtLastName == textField {
            txtEmail.becomeFirstResponder()
        }else if txtEmail === textField {
                txtContactNo.becomeFirstResponder()
        }else {
            textField.resignFirstResponder()
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtContactNo {
            if  (string == "") || string.count < 1 {
                return true
            }
                else if  (textField.text?.count)! >= 15 {
                return false
            }
        }
        return true;
    }
    //MARK:- NAVIGATION METHODS
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationInvoiceVC:InstanceOrderInvoice =  segue.destination as! InstanceOrderInvoice
        destinationInvoiceVC.invoieResponse = sender as? InvoiceResponse
        destinationInvoiceVC.selectedVehicleId = self.selectedVehicleId
    }
    //MARK:- WEB SERVICE
    func getTimeAndDistance(srcLat:Double, srcLong:Double, destLat:Double, destLong:Double)->(String,String) {
        
        var timeAndDistance:(time:String, distance:String)
        timeAndDistance.time = "0";
        timeAndDistance.distance = "0";
        let src_lat: String = String(srcLat)
        let src_long: String = String(srcLong)
        let dest_lat: String = String(destLat)
        let dest_long: String = String(destLong)
        
        let request = URL(string: "https://maps.googleapis.com/maps/api/distancematrix/json?origins=\(src_lat),\(src_long)&destinations=\(dest_lat),\(dest_long)&key=\(Google.API_KEY)")
        
        
        let parseData = parseJSON(inputData: getJSON(urlToRequest: request!))
        
        
        let googleRsponse: GoogleDistanceMatrixResponse = GoogleDistanceMatrixResponse(dictionary:parseData)!
        if ((googleRsponse.status?.compare("OK")) == ComparisonResult.orderedSame) {
            timeAndDistance.time = String((googleRsponse.rows?[0].elements?[0].duration?.value) ?? 0)
            timeAndDistance.distance = String((googleRsponse.rows?[0].elements?[0].distance?.value) ?? 0)
            
        }
        return timeAndDistance
        
    }
    func getJSON(urlToRequest:URL) -> Data {
        var content:Data?
        do {
            content = try Data(contentsOf:urlToRequest)
        }
        catch let error {
            print(error)
        }
        return content!
    }
    func parseJSON(inputData:Data) -> NSDictionary{
        let dictData = (try! JSONSerialization.jsonObject(with: inputData, options: .mutableContainers)) as! NSDictionary
        return dictData
    }
    
    
    func wsAddItemInServerCart() {
        Utility.showLoading()
        
        let cartOrder:CartOrder = CartOrder.init();
        cartOrder.serverToken = ""
        cartOrder.userId = ""
        cartOrder.storeId = preferenceHelper.getUserId()
        cartOrder.orderDetails = []
        var totalPrice:Double = txtProductPrice.text?.doubleValue ?? 0.0
        var totalTax:Double = 0.0
        
        for cartProduct in currentBooking.cart {
            var productTotalItemPrice:Double = 0.0
            var productTotalTax:Double = 0.0
            
            for cartItem in cartProduct.items {
                productTotalItemPrice = productTotalItemPrice + cartItem.totalItemPrice!
                productTotalTax = productTotalTax + cartItem.totalTax
            }
            cartProduct.totalItemTax = productTotalTax
            cartProduct.totalItemPrice = productTotalItemPrice
            
            
            totalTax = totalTax + cartProduct.totalItemTax;
            totalPrice = totalPrice + cartProduct.totalItemPrice
            
        }
        cartOrder.totalCartPrice =  totalPrice
        cartOrder.totalItemTax = totalTax
        
        let destinationAddress:Address = Address.init()
        destinationAddress.address = currentBooking.deliveryAddress
        destinationAddress.addressType = AddressType.DESTINATION
        destinationAddress.userType = CONSTANT.TYPE_STORE
        destinationAddress.note = txtAddNote.text ?? ""
        destinationAddress.city = currentBooking.store.cityId
        destinationAddress.location = currentBooking.deliveryLatLng
        destinationAddress.flat_no = txtFlat.text!
        destinationAddress.landmark = txtLandmark.text!
        destinationAddress.street = txtStreet.text!
        
        let cartUserDetail:CartUserDetail = CartUserDetail();
        cartUserDetail.email = txtEmail.text
        cartUserDetail.countryPhoneCode = txtCountryCode.text!
        cartUserDetail.name = (txtFirstName.text)! + " " + (txtLastName.text)!
        cartUserDetail.phone = txtContactNo.text!
        destinationAddress.userDetails = cartUserDetail
        currentBooking.destinationAddress = [destinationAddress]
        let pickupAddress:Address = Address.init()
        pickupAddress.address = currentBooking.store.address
        pickupAddress.addressType = AddressType.PICKUP
        pickupAddress.userType = CONSTANT.TYPE_STORE
        pickupAddress.note = ""
        pickupAddress.city = ""
        pickupAddress.location = currentBooking.store.location
        
        
        let cartStoreDetail:CartUserDetail = CartUserDetail();
        cartStoreDetail.email = currentBooking.store.email
        cartStoreDetail.countryPhoneCode = currentBooking.store.countryPhoneCode
        cartStoreDetail.name = currentBooking.store.name
        cartStoreDetail.phone = currentBooking.store.phone
        pickupAddress.userDetails = cartStoreDetail
        
        currentBooking.pickpuAddress = [pickupAddress]
        cartOrder.pickupAddress = currentBooking.pickpuAddress
        cartOrder.destinationAddress = currentBooking.destinationAddress
        
        var dictData:[String:Any] = cartOrder.toDictionary()
        
        let afn:AlamofireHelper = AlamofireHelper.init();
        dictData[PARAMS.IS_USE_ITEM_TAX] = StoreSingleton.shared.store.isUseItemTax
        dictData[PARAMS.IS_TAX_INCLUDED] = StoreSingleton.shared.store.isTaxInlcuded
        print("WS_ADD_ITEM_IN_CART  param \(dictData)")

        
        afn.getResponseFromURL(url: WebService.WS_ADD_ITEM_IN_CART, methodName: AlamofireHelper.POST_METHOD, paramData: dictData) { (response,error) -> (Void) in
            Utility.hideLoading();
            if (Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true)) {
                
                preferenceHelper.setCartID((response[PARAMS.CART_ID] as? String) ?? "")
                self.currentBooking.cartCityId = (response[PARAMS.CITY_ID] as? String) ?? ""
                self.userId = ((response[PARAMS.USER_ID] as? String) ?? "")
                self.prepareInvoicePARAMS()
            }
        }
    }
    
    func wsGetInvoice(dictParam:Dictionary<String,Any>) {
        let afn:AlamofireHelper = AlamofireHelper.init();
        afn.getResponseFromURL(url: WebService.WS_GET_CART_INVOICE, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response,error) -> (Void) in
            Utility.hideLoading();
            if Parser.isSuccess(response: response) {
                let invoiceResponse:InvoiceResponse = InvoiceResponse.init(fromDictionary: response)!
               self.performSegue(withIdentifier: SEGUE.INSTANCE_ORDER_INVOICE, sender: invoiceResponse)
            }
        }
        
        
    }
    
    //Actions
    
    @IBAction func onClickBtnAddress(_ sender: Any) {
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "Prelogin", bundle: nil)
        
        let locationVC : StoreLocationVC = mainView.instantiateViewController(withIdentifier: "storeLocationVC") as! StoreLocationVC
        locationVC.delegate = self
        locationVC.comingFrom = SourceVC.CART_VC
        self.navigationController?.pushViewController(locationVC, animated: true)
        
    }
    
    func prepareInvoicePARAMS() {
        let storeLatLong = currentBooking.store.location!
        let timeAndDistance = getTimeAndDistance(srcLat:storeLatLong[0], srcLong: storeLatLong[1], destLat: myDeliveryLatitude, destLong: myDeliveryLongitude)
        let time = Double(timeAndDistance.0)
        let distance = Double(timeAndDistance.1)

        
        var taxDetails = [TaxesDetail]()
        var taxDetailArr = [[String:Any]]()

        for cartProduct in  currentBooking.cart {
            for cartProductItem in cartProduct.items {
                var eachItemTax = 0
                if StoreSingleton.shared.store.isUseItemTax{
                    for obj in cartProductItem.taxDetails{
                        
                        eachItemTax = eachItemTax + obj.tax
                        let x = taxDetails.contains(where: { (a) -> Bool in
                            a.id == obj.id
                        })
                        if !x{
                            taxDetails.append(obj)
                        }
                        for i in taxDetails{
                            if i.id == obj.id{
                                i.tax_amount = obj.tax
                            }
                        }
                    }
                    
                }else{
                    for obj in StoreSingleton.shared.store.taxesDetails{
                        eachItemTax = eachItemTax + obj.tax
                        let x = taxDetails.contains(where: { (a) -> Bool in
                            a.id == obj.id
                        })
                        if !x{
                            taxDetails.append(obj)
                        }
                        for i in taxDetails{
                            if i.id == obj.id{
                                i.tax_amount = obj.tax
                            }
                        }
                    }
                }
            }
        }
        

        for obj in taxDetails{
            taxDetailArr.append(obj.toDictionary())
        }

        print(taxDetailArr)
        
        let dictParam: Dictionary<String,Any> = [
            PARAMS.ORDER_TYPE:CONSTANT.TYPE_STORE,
            PARAMS.CART_UNIQUE_TOKEN :preferenceHelper.getRandomCartID(),
            PARAMS.USER_ID:userId,
            PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken(),
            PARAMS.STORE_ID:preferenceHelper.getUserId(),
            PARAMS.TOTAL_TIME:time ?? 0.0,
            PARAMS.TOTAL_DISTANCE:distance ?? 0.0,
            PARAMS.TOTAL_CART_PRICE: Double(txtProductPrice.text ?? "0.0") ?? 0.0,
            PARAMS.TOTAL_ITEM_PRICE: Double(txtProductPrice.text ?? "0.0") ?? 0.0,
            PARAMS.TOTAL_ITEM_COUNT: 1,
            PARAMS.TOTAL_SPECIFICATION_COUNT:0,
            PARAMS.TOTAL_SPECIFICATION_PRICE:0.0,
            PARAMS.VEHICLE_ID : selectedVehicleId,
            PARAMS.TAX_DETAILS : taxDetailArr,
            PARAMS.IS_USE_ITEM_TAX : StoreSingleton.shared.store.isUseItemTax!,
            PARAMS.IS_TAX_INCLUDED : StoreSingleton.shared.store.isTaxInlcuded!,
            PARAMS.TOTAL_CART_AMOUNT_WITHOUT_TAX : Double(txtProductPrice.text ?? "0.0") ?? 0.0
            ]
        print(Utility.conteverDictToJson(dict: dictParam))
        self.wsGetInvoice(dictParam:dictParam)
    }
}


 extension InstanceOrderVC
 {
    func wsgetVehicleList() {
        let dictParam : [String : Any] =
            [PARAMS.STORE_ID      : preferenceHelper.getUserId(),
             PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken()]
        
        
        let alamoFire:AlamofireHelper = AlamofireHelper();
        
        alamoFire.getResponseFromURL(url: WebService.WS_GET_VEHICLE_LIST, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {   (response, error) -> (Void) in
            
            Utility.hideLoading()
            if  Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: false) {
                let vehicleListResponse:VehicleListResponse = VehicleListResponse.init(fromDictionary: response)
                StoreSingleton.shared.vehicalList.removeAll()
                StoreSingleton.shared.adminVehicalList.removeAll()
                
                for vehicle in vehicleListResponse.vehicles {
                    StoreSingleton.shared.vehicalList.append(vehicle)
                }
                for vehicle in vehicleListResponse.adminVehicles {
                    StoreSingleton.shared.adminVehicalList.append(vehicle)
                }
                
            }
        }
    }
    
    func openVehicleDialog() {
        if StoreSingleton.shared.store.isStoreCanAddProvider ||  StoreSingleton.shared.store.isStoreCanCompleteOrder {
            var itemListArray:[(String,Bool)] = []
            
            for i in StoreSingleton.shared.vehicalList {
                itemListArray.append((i.vehicleName,false))
            }
            if itemListArray.isEmpty {
                Utility.showToast(message: "TXT_NO_VEHICLE_AVAILABLE".localized)
            }else {
                //STOREDEV
//                TableDialog().show(title: "TXT_SELECT_VEHICLE".localized, doneButtonTitle: "TXT_DONE".localized, cancelButtonTitle: "TXT_CANCEL".localized, options: itemListArray, isAllowMultiselect: false) { [unowned self](selectedIndex) in
//
//                    self.selectedVehicleId =  StoreSingleton.shared.vehicalList[selectedIndex[0]].vehicleId
//                    self.wsAddItemInServerCart()
//                }
                
                let dialogForLocalizedLanguage = TableviewDialogVehicle.showDialog(languages: [:], title: "",options: itemListArray, isAllowMultiselect: false,viewAssignDeliverymanHidden: true)
                                           dialogForLocalizedLanguage.onItemSelected = { [unowned self] (selectedIndex) in

                    self.selectedVehicleId =  StoreSingleton.shared.adminVehicalList[selectedIndex[0]].vehicleId
                                            self.isManuallyAssignProvider = false

                    //self.wsCreateRequest(orderId: self.selectedOrderId)
                    dialogForLocalizedLanguage.removeFromSuperview()
                }

               dialogForLocalizedLanguage.onClickAssignAutoSelected = {
                    self.isManuallyAssignProvider = false
                    self.wsAddItemInServerCart()
               }

               dialogForLocalizedLanguage.onClickAssignManuallySelected = {
                    self.wsAddItemInServerCart()
               }
                
            }
        }else {
            var itemListArray:[(String,Bool)] = []
            
            for i in StoreSingleton.shared.adminVehicalList {
                itemListArray.append((i.vehicleName,false))
            }
            if itemListArray.isEmpty {
                Utility.showToast(message: "TXT_NO_VEHICLE_AVAILABLE".localized)
            }else {
//                TableDialog().show(title: "TXT_SELECT_VEHICLE".localized, doneButtonTitle: "TXT_DONE".localized, cancelButtonTitle: "TXT_CANCEL".localized, options: itemListArray, isAllowMultiselect: false) { [unowned self] (selectedIndex) in
//
//                    self.selectedVehicleId =  StoreSingleton.shared.adminVehicalList[selectedIndex[0]].vehicleId
//                    self.wsAddItemInServerCart()
//                }
                
                let dialogForLocalizedLanguage = TableviewDialogVehicle.showDialog(languages: [:], title: "",options: itemListArray, isAllowMultiselect: false,viewAssignDeliverymanHidden: true)
                                           dialogForLocalizedLanguage.onItemSelected = { [unowned self] (selectedIndex) in

                    self.selectedVehicleId =  StoreSingleton.shared.adminVehicalList[selectedIndex[0]].vehicleId
                                            //self.wsCreateRequest(orderId: self.selectedOrderId)
                                            
                                            self.isManuallyAssignProvider = false

                    dialogForLocalizedLanguage.removeFromSuperview()
                }

               dialogForLocalizedLanguage.onClickAssignAutoSelected = {
                    self.isManuallyAssignProvider = false
                    self.wsAddItemInServerCart()
               }

               dialogForLocalizedLanguage.onClickAssignManuallySelected = {
                    self.wsAddItemInServerCart()
               }
            }
        }
        
    }
 }
