import Foundation
import UIKit



class OrderDeliveryDataVC:BaseVC,LocationHandlerDelegate,UITextFieldDelegate {
    
    //MARK: OutLets
    var storeOpen:(Bool,String) = (true,"");
    
    @IBOutlet weak var viewForHeader: UIView!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtAddNote: UITextField!
    @IBOutlet weak var txtContactNo: UITextField!
    @IBOutlet weak var txtCountryCode: UITextField!
    @IBOutlet weak var btnPlaceOrder: UIButton!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var stkAddress: UIStackView!
    @IBOutlet weak var stkDateTime: UIStackView!
    @IBOutlet weak var imgAsap: UIImageView!
    @IBOutlet weak var imgTakeaway: UIImageView!

    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblUserPickupDelivery: UILabel!
    @IBOutlet weak var cbPickupDelivery: UIButton!
    @IBOutlet weak var scrInvoice: UIScrollView!
    @IBOutlet weak var viewForPickupDelivery: UIView!
    
    @IBOutlet weak var txtFlat: UITextField!
    @IBOutlet weak var txtStreet: UITextField!
    @IBOutlet weak var txtLandmark: UITextField!

    //MARK: Variables
    var cartListLength:Int = 0;
    var myDeliveryLatitude:Double = 0.0;
    var myDeliveryLongitude:Double = 0.0;
    var userId:String = ""
    var currentBooking:StoreSingleton = StoreSingleton.shared;
    
    var myAddressArray:NSArray? = nil;
    var selectedStoreTime:[StoreTime]=[]
    var timeZone:TimeZone = TimeZone.init(identifier: StoreSingleton.shared.store.timeZone) ?? TimeZone.current
    
    
    var userToken:String = ""
    
    //ViewForAsAp
    
    @IBOutlet weak var viewForAsap: UIView!
    @IBOutlet weak var lblAsap: UILabel!
    
    @IBOutlet weak var lblReopenAt: UILabel!
    //ViewForDate&Time
    @IBOutlet weak var viewForDate: UIView!
    @IBOutlet weak var btnForDate: UIButton!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDateValue: UILabel!
    
    @IBOutlet weak var viewForTime: UIView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblTimeValue: UILabel!
    @IBOutlet weak var btnTime: UIButton!
    
    @IBOutlet weak var btnMap: UIButton!
    @IBOutlet weak var heightForHeaderView: NSLayoutConstraint!

    var minDate = Date()
    var maxDate = Date()
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        super.hideBackButtonTitle()
        setLocalization()
        cbPickupDelivery.isSelected = false
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(self.onClickBtnAddress(_:)));
        stkAddress.addGestureRecognizer(tapGesture)
        stkAddress.isUserInteractionEnabled = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if currentBooking.store.isProvidePickupDelivery{
            viewForPickupDelivery.isHidden = false
            heightForHeaderView.constant = 80
        }else{
            viewForPickupDelivery.isHidden = true
            heightForHeaderView.constant = 40
        }

        if currentBooking.isFutureOrder {
            viewForAsap.isHidden = true
            viewForDate.isHidden = false
            viewForTime.isHidden = false
            stkDateTime.isHidden = false
//            self.storeOpen = Utility.isStoreOpen(storeTime: self.selectedStoreTime,milliSeconds: currentBooking.futureDateMilliSecond)
        }else {
            viewForAsap.isHidden = false
            viewForDate.isHidden = true
            viewForTime.isHidden = true
            stkDateTime.isHidden = true
//            self.storeOpen = Utility.isStoreOpen(storeTime:currentBooking.store.storeTime,milliSeconds: currentBooking.currentDateMilliSecond)
        }
        
        
        
        if (!storeOpen.0) {
            let strMsg:String = self.storeOpen.1;
            lblReopenAt.text = strMsg;
            lblReopenAt.isHidden = false
        }
    }
        
    
    func adjustLabel(label:UILabel) {
        label.text = "TXT_CUSTOMER_DETAIL".localized + "    "
        label.sectionRound(label)
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
        
        /*Set Color*/
        txtFirstName.textColor = UIColor.themeTextColor
        txtContactNo.textColor = UIColor.themeTextColor
        txtAddress.textColor = UIColor.themeTextColor
        txtLastName.textColor = UIColor.themeTextColor
        txtEmail.textColor = UIColor.themeTextColor
        txtCountryCode.textColor = UIColor.themeTextColor
        lblMobileNumber.textColor = UIColor.themeLightTextColor
        txtFlat.textColor = UIColor.themeTextColor
        txtStreet.textColor = UIColor.themeTextColor
        txtLandmark.textColor = UIColor.themeTextColor
        
        btnPlaceOrder.setTitle("TXT_PLACEORDER".localizedUppercase, for: .normal)
        
        self.setNavigationTitle(title:"TXT_CHECKOUT".localizedCapitalized)
        
        self.view.backgroundColor = UIColor.themeViewBackgroundColor
        viewForHeader.backgroundColor = UIColor.themeViewBackgroundColor
        btnPlaceOrder.backgroundColor = UIColor.themeColor;
        btnPlaceOrder.setTitleColor(UIColor.themeButtonTitleColor, for: UIControl.State.normal)
        btnPlaceOrder.setRound(withBorderColor: .clear, andCornerRadious: btnPlaceOrder.frame.size.height/2, borderWidth: 1.0)
        
        lblAsap.textColor = UIColor.themeTextColor
        lblDate.textColor = UIColor.themeLightTextColor
        lblTime.textColor = UIColor.themeLightTextColor
        lblDateValue.textColor = UIColor.themeTextColor
        lblTimeValue.textColor = UIColor.themeTextColor
        lblReopenAt.textColor = UIColor.themeColor
        lblUserPickupDelivery.textColor = UIColor.themeTextColor
        txtContactNo.tintColor = .themeTextColor
        /* Set text */
        txtFirstName.placeholder = "TXT_FIRST_NAME".localizedCapitalized
        txtLastName.placeholder = "TXT_LAST_NAME".localized
        txtEmail.placeholder = "TXT_EMAIL".localized
        txtContactNo.placeholder = "TXT_CONTACT_NO".localizedCapitalized
        txtAddress.placeholder = "TXT_DELIVERY_ADDRESS".localizedCapitalized
        txtAddNote.placeholder = "TXT_ADD_NOTE".localizedCapitalized
        lblUserPickupDelivery.text = "TXT_I_WILL_PICKUP_A_DELIVERY".localizedCapitalized
        lblMobileNumber.text = "TXT_MOBILE_NO".localizedCapitalized
        txtFlat.placeholder = "txt_flat_no_name".localizedCapitalized
        txtStreet.placeholder = "txt_street_no".localizedCapitalized
        txtLandmark.placeholder = "txt_landmark".localizedCapitalized
        
        txtFirstName.text = ""
        txtContactNo.text = ""
        txtAddNote.text = ""
        txtLastName.text = ""
        txtEmail.text = ""
        txtCountryCode.text = StoreSingleton.shared.store.countryPhoneCode
        txtAddress.text = currentBooking.deliveryAddress
        txtAddress.isUserInteractionEnabled = false
        txtAddress.isEnabled = false
        
         lblAsap.text = "TXT_APSA".localized
        lblDate.text = "TXT_DATE".localizedCapitalized
        lblTime.text = "TXT_TIME".localizedCapitalized
        lblReopenAt.text = ""
        
        let components = Utility.millisecondToDateComponents(milliSeconds: currentBooking.futureDateMilliSecond)
        self.lblDateValue.text = String(components.day!) + "-" + String(components.month!) + "-" + String(components.year!)
        lblTimeValue.text = String(components.hour!) + ":" + String(components.minute!)
        
        /* Set Font */
        txtFirstName.font = FontHelper.textRegular()
        txtLastName.font = FontHelper.textRegular()
        txtContactNo.font = FontHelper.textRegular()
        txtAddress.font = FontHelper.textRegular()
        txtEmail.font = FontHelper.textRegular()
        txtAddNote.font = FontHelper.textRegular()
        
        btnPlaceOrder.titleLabel?.font = FontHelper.textRegular()
        lblAsap.font = FontHelper.textRegular()
        lblDate.font = FontHelper.textSmall()
        lblTime.font = FontHelper.textSmall()
        lblDateValue.font = FontHelper.textSmall()
        lblTimeValue.font = FontHelper.textSmall()
        lblReopenAt.font = FontHelper.textRegular()
        lblUserPickupDelivery.font = FontHelper.textRegular()
        
        updateUIAccordingToTheme()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gestureRecognizer:)))
        self.view.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func handleTap(gestureRecognizer: UIGestureRecognizer)
    {
        self.view.endEditing(true)
    }
    
    func setupLayout() {
       
    }
    
    override func updateUIAccordingToTheme() {
        btnMap.setImage(UIImage(named: "location_arrow"), for: .normal)
        imgAsap.image = UIImage.init(named: "asap")!.imageWithColor(color: .themeIconTintColor)!
        imgTakeaway.image = UIImage.init(named: "takeway")!.imageWithColor(color: .themeIconTintColor)!
        cbPickupDelivery.setImage(UIImage.init(named: "unchecked"), for: .normal)
        cbPickupDelivery.setImage(UIImage.init(named: "checked")?.imageWithColor(color: .themeColor), for: .selected)

    }
    
    //MARK:- ACTION METHODS
    
    @IBAction func onClickCbPickupDelivery(_ sender: Any) {
        cbPickupDelivery.isSelected = !cbPickupDelivery.isSelected
        btnMap.isEnabled = !cbPickupDelivery.isSelected
        stkAddress.isHidden = cbPickupDelivery.isSelected
        txtAddNote.text = ""
        txtAddNote.isHidden = cbPickupDelivery.isSelected
        
    }
    
    @IBAction func onClickPlaceOrder(_ sender: Any) {
        self.view.endEditing(true)
        if self.checkValidation() {
           wsAddItemInServerCart()
        }
    }
    
    func checkValidation() -> Bool {
        let validEmail = txtEmail.text!.checkEmailValidation()
        let validPhone = txtContactNo.text!.isValidMobileNumber()
        if (
                (txtFirstName.text?.isEmpty())! ||
                (txtLastName.text?.isEmpty())! ||
                (txtEmail.text?.isEmpty())! ||
                (txtContactNo.text?.isEmpty())!  ||
                (txtCountryCode.text?.isEmpty())!  ||
                ((txtAddress.text?.isEmpty())!  && !cbPickupDelivery.isSelected)
            ) {
            if (txtFirstName.text?.isEmpty())! {
                txtFirstName.becomeFirstResponder();
                Utility.showToast(message:"MSG_PLEASE_ENTER_VALID_NAME".localized)
                
            }else if (txtCountryCode.text?.isEmpty())! {
                txtCountryCode.becomeFirstResponder();
                Utility.showToast(message:"MSG_PLEASE_ENTER_VALID_COUNTRYCODE".localized)
                
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
            if(validEmail.0 == false) {
                txtEmail.becomeFirstResponder();
                Utility.showToast(message:validEmail.1)
            }
//                else if (!(txtContactNo.text!.isValidMobileNumber(minLength:8,maxLength:15))) {
            else if (validPhone.0 == false) {

                txtContactNo.becomeFirstResponder();
//                let myString = String(format: NSLocalizedString("MSG_PLEASE_ENTER_VALID_MOBILE_NUMBER", comment: ""),String(8),String(15))
//                
//                Utility.showToast(message:myString)
                Utility.showToast(message:validPhone.1)

            }else{
                return true
            }
            return false
        }
        
    }
    
    
    func finalAddressAndLocation(address: String, latitude: Double, longitude: Double) {
        self.txtAddress.text = address
        currentBooking.deliveryAddress = address
        currentBooking.deliveryLatLng = [latitude,longitude]
    }
    
    
    
    @IBAction func searching(_ sender: UITextField) {
        if (sender.text?.count)! > 2 {
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFirstName {
            txtLastName.becomeFirstResponder()
        }else if textField == txtLastName {
            txtEmail.becomeFirstResponder()
            
        }else if textField == txtEmail {
            txtContactNo.becomeFirstResponder()
        }else if textField == txtContactNo {
            txtAddNote.becomeFirstResponder()
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
        if segue.identifier == SEGUE.TO_INVOICE {
            let invoiceVc:CartInvoiceVC =  segue.destination as! CartInvoiceVC
            invoiceVc.invoieResponse = sender as? InvoiceResponse
            invoiceVc.noteForDeliveryMan = txtAddNote.text ?? ""
            
        }
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
    
    @IBAction func onClickBtnAddress(_ sender: Any) {
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "Prelogin", bundle: nil)
        
        let locationVC : StoreLocationVC = mainView.instantiateViewController(withIdentifier: "storeLocationVC") as! StoreLocationVC
        locationVC.delegate = self
        locationVC.comingFrom = SourceVC.CART_VC
        self.navigationController?.pushViewController(locationVC, animated: true)
    }
    @IBAction func onClickBtnDate(_ sender: UIButton) {
        lblReopenAt.isHidden = true
        let datePickerDialog:CustomDatePickerDialog = CustomDatePickerDialog.showCustomDatePickerDialog(title: "TXT_SELECT_FUTURE_ORDER_TIME".localized, titleLeftButton: "TXT_CANCEL".localized, titleRightButton: "TXT_SELECT".localized,mode: .dateAndTime)
        
        datePickerDialog.datePicker.locale = Locale(identifier: "en_GB")
        datePickerDialog.datePicker.timeZone = TimeZone.init(identifier: currentBooking.store.timeZone)
        
        datePickerDialog.onClickLeftButton = { [unowned datePickerDialog] in
                datePickerDialog.removeFromSuperview()
        }
        
        datePickerDialog.onClickRightButton = { [unowned datePickerDialog, unowned self]  (selectedDate:Date) in
                
                
                
                self.currentBooking.futureDateMilliSecond = Utility.convertSelectedDateToMilliSecond(serverDate: selectedDate, strTimeZone: self.currentBooking.store.timeZone)
                
                let offSetMiliSecond:Int64 =  Int64(self.timeZone.secondsFromGMT() * 1000)
                
                
                self.currentBooking.futureUTCMilliSecond = self.currentBooking.futureDateMilliSecond - offSetMiliSecond
                
                
                
                let components = Calendar.current.dateComponents(in: TimeZone.init(identifier: self.currentBooking.store.timeZone)!, from: selectedDate)
                
                
                self.lblDateValue.text =
                    String(components.year!) +  "-" + String(components.month!) +  "-" + String(components.day!)
                self.lblTimeValue.text = String(components.hour!) +  "-" + String(components.minute!)
                
                
                datePickerDialog.removeFromSuperview()
        }
        
    }
    @IBAction func onClickBtnTime(_ sender: UIButton) {
        
    }
    
    func getTax(itemAmount:Double, taxValue:Double) -> Double {
        if !StoreSingleton.shared.store.isTaxInlcuded{
            return itemAmount * taxValue * 0.01
        }else{
            return (itemAmount - (100*itemAmount)/(100+taxValue))
        }
        
    }
    
    func prepareInvoicePARAMS() {
        let storeLatLong = currentBooking.store.location!
        let deliveryLatLong = currentBooking.deliveryLatLng
        var time:Double = 0.0
        var distance:Double = 0.0
        
        if !cbPickupDelivery.isSelected {
            let timeAndDistance = getTimeAndDistance(srcLat:storeLatLong[0], srcLong: storeLatLong[1], destLat: deliveryLatLong[0], destLong: deliveryLatLong[1])
            time = Double(timeAndDistance.0) ?? 0.0
            distance = Double(timeAndDistance.1) ?? 0.0
        }
        
        var totalSpecificationPriceWithQuantity = 0.0;
        var totalItemsPriceWithQuantity = 0.0;
        var totalSpecificationCount = 0;
        var totalItemsCount = 0;
        var taxDetails = [TaxesDetail]()
        var taxDetailArr = [[String:Any]]()
//        var taxAmount = 0

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
                
                let itemTax = getTax(itemAmount: cartProductItem.itemPrice, taxValue: Double(eachItemTax))
                let specificationTax = getTax(itemAmount: cartProductItem.totalSpecificationPrice, taxValue: Double(eachItemTax))
//                let totalTax = itemTax + specificationTax
//                print(totalTax)
                
                totalItemsPriceWithQuantity += (cartProductItem.itemPrice * Double(cartProductItem.quantity!)) - (itemTax * Double(cartProductItem.quantity!))
                totalSpecificationPriceWithQuantity += (cartProductItem.totalSpecificationPrice * Double(cartProductItem.quantity!)) - (specificationTax * Double(cartProductItem.quantity!))
                totalItemsCount += cartProductItem.quantity!
                
                for specificationItem  in cartProductItem.specifications! {
                    totalSpecificationCount +=  (specificationItem.list?.count)!
                }
            }
        }
        
        for obj in taxDetails{
            taxDetailArr.append(obj.toDictionary())
        }

        print(taxDetailArr)
        
        let dictParam: Dictionary<String,Any> = [
            PARAMS.USER_ID:userId,
            PARAMS.CART_UNIQUE_TOKEN :preferenceHelper.getRandomCartID(),
            PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken(),
            PARAMS.STORE_ID:preferenceHelper.getUserId(),
            PARAMS.CART_ID: preferenceHelper.getCartID(),
            PARAMS.TOTAL_ITEM_COUNT:totalItemsCount,
            PARAMS.TOTAL_SPECIFICATION_COUNT:totalSpecificationCount,
            PARAMS.TOTAL_CART_PRICE:currentBooking.totalCartAmount!,
            PARAMS.TOTAL_TIME:time,
            PARAMS.TOTAL_DISTANCE:distance,
            PARAMS.TOTAL_SPECIFICATION_PRICE: totalSpecificationPriceWithQuantity,
            PARAMS.TOTAL_ITEM_PRICE: totalItemsPriceWithQuantity,
            PARAMS.IS_USER_PICK_UP_ORDER: cbPickupDelivery.isSelected,
            PARAMS.ORDER_TYPE : CONSTANT.TYPE_STORE,
            PARAMS.TOTAL_CART_AMOUNT_WITHOUT_TAX: currentBooking.totalCartAmountWithoutTax!,
            PARAMS.TAX_DETAILS : taxDetailArr,
            PARAMS.IS_TAX_INCLUDED : StoreSingleton.shared.store.isTaxInlcuded!,
            PARAMS.IS_USE_ITEM_TAX : StoreSingleton.shared.store.isUseItemTax!
        ]
        wsGetInvoice(dictParam: dictParam)
        
    }
    //MARK: WEB SERVICE CALLS
    
   
    
    
    func wsGetInvoice(dictParam:Dictionary<String,Any>) {
        
        print(Utility.conteverDictToJson(dict: dictParam))
        let afn:AlamofireHelper = AlamofireHelper.init();
        afn.getResponseFromURL(url: WebService.WS_GET_CART_INVOICE, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response,error) -> (Void) in
            Utility.hideLoading();
            if Parser.isSuccess(response: response) {
                
                let invoiceResponse:InvoiceResponse = InvoiceResponse.init(fromDictionary: response)!
                
                self.currentBooking.currentServerTime = invoiceResponse.serverTime
                self.selectedStoreTime = (invoiceResponse.store?.storeTime)!
                self.currentBooking.orderPaymentId = (invoiceResponse.order_payment?.id) ?? ""
                self.timeZone = TimeZone.init(identifier:invoiceResponse.timeZone)!
                self.currentBooking.currentDateMilliSecond = Utility.convertServerDateToMilliSecond(serverDate:self.currentBooking.currentServerTime , strTimeZone: self.timeZone.identifier)
                
                self.performSegue(withIdentifier: SEGUE.TO_INVOICE, sender: invoiceResponse)
               
            }else {
                let isSuccess:IsSuccessResponse = IsSuccessResponse.init(dictionary: response)!
                if isSuccess.errorCode! == 557 {
                    let minAmount = (response["min_order_price"] as? Double)?.roundTo() ?? 0.0
                    self.openMinAmountDialog(amount:String(minAmount))
                }
            }
        }
    }
    func openMinAmountDialog(amount:String) {
        let minAmountMessage:String = "TXT_MIN_INVOICE_AMOUNT_MSG".localized + amount;
        let dialogForMinAmount = CustomAlertDialog.showCustomAlertDialog(title: "TXT_MIN_AMOUNT".localized, message: minAmountMessage, titleLeftButton: "", titleRightButton: "TXT_ADD_MORE_ITEMS".localizedUppercase)
        dialogForMinAmount.onClickLeftButton = {
                [unowned dialogForMinAmount, unowned self] in
                dialogForMinAmount.removeFromSuperview();
        }
        dialogForMinAmount.onClickRightButton = {
                 [unowned dialogForMinAmount, unowned self] in
                dialogForMinAmount.removeFromSuperview();
                self.navigationController?.popViewController(animated: true)
        }
    }
    func wsAddItemInServerCart() {
        Utility.showLoading()
        let cartOrder:CartOrder = CartOrder.init();
        cartOrder.serverToken = preferenceHelper.getSessionToken()
        cartOrder.userId = ""
        cartOrder.storeId = preferenceHelper.getUserId()
        cartOrder.orderDetails = currentBooking.cart
        
        var totalPrice:Double = 0.0
        var totalTax:Double = 0.0
   
        for cartProduct in currentBooking.cart {
            var productTotalItemPrice:Double = 0.0
            var productTotalTax:Double = 0.0
            
            for cartItem in cartProduct.items {
                productTotalItemPrice = productTotalItemPrice + cartItem.totalItemPrice!
                //changed
//                productTotalTax = productTotalTax + (cartItem.totalTax)
                productTotalTax = productTotalTax + (cartItem.totalItemTax)
            }
            cartProduct.totalItemTax = productTotalTax
            cartProduct.totalItemPrice = productTotalItemPrice
                //- cartProduct.totalItemTax
            
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
        dictData[PARAMS.IS_USE_ITEM_TAX] = StoreSingleton.shared.store.isUseItemTax
        dictData[PARAMS.IS_TAX_INCLUDED] = StoreSingleton.shared.store.isTaxInlcuded
        
        print("WS_ADD_ITEM_IN_CART  param \(Utility.conteverDictToJson(dict: dictData))")
        let afn:AlamofireHelper = AlamofireHelper.init();
        afn.getResponseFromURL(url: WebService.WS_ADD_ITEM_IN_CART, methodName: AlamofireHelper.POST_METHOD, paramData: dictData) { (response,error) -> (Void) in
            Utility.hideLoading();
            if (Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true)) {
                preferenceHelper.setCartID((response[PARAMS.CART_ID] as? String) ?? "")
                self.userId = ((response[PARAMS.USER_ID] as? String) ?? "")
                self.currentBooking.cartCityId = (response[PARAMS.CITY_ID] as? String) ?? ""
                
                DispatchQueue.main.async {
                    self.prepareInvoicePARAMS()
                }
            }else {
                if self.currentBooking.cart.count > 0{
                    self.currentBooking.cart.removeLast()
                }
            }
            
        }
    }
}

