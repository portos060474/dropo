//
//  OrdersVC.swift
//  Store
//
//  Created by Jaydeep Vyas on 24/03/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import UIKit
import FirebaseMessaging

class OrdersVC: BaseVC,UITableViewDataSource,UITableViewDelegate,UITabBarDelegate {
    
    @IBOutlet weak var tblForOrders: UITableView!
    @IBOutlet weak var imgEmpty: UIImageView!
    @IBOutlet weak var viewForTab: UIView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var btnCreateNewOrder: UIButton!
    
    var timerForGetOrders: Timer?
    var arrOrders = [Order]()
    var arrCurrentOrders = [Order]()
    var arrScheduleOrders = [Order]()
    var arrForTableOrder = [Order]()
    var selectedOrder:Order!
    var  isViewCurrentOrder:Bool = true;
    var buttonMenu = UIButton.init(type: .custom)

    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
       

        updateUi(isUpdate: false)
        btnCreateNewOrder.isHidden = true
        btnCreateNewOrder.backgroundColor = .themeColor
        btnCreateNewOrder.layer.cornerRadius = btnCreateNewOrder.frame.height/2.0
        setupRevealViewController()
        setMenuButton()
        
        setLocalization()
        NotificationCenter.default.addObserver(self, selector: #selector(doSomething), name: UIApplication.didBecomeActiveNotification, object: nil)
        APPDELEGATE.setupTabbar(tabBar: tabBar)
    }
    
    @objc private func doSomething() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.startTimer()
        }
    }

    @objc func onClickMenu(){
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            tblForOrders.estimatedRowHeight = 140
            tblForOrders.rowHeight = UITableView.automaticDimension
            self.wsGetUserInfo()
            doSomething()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setScreenVisibility(isShowLoading:false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setupLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.isHidden = true
        stopTimer()
    }
    
    
    func firebaseAuthentication(){
        if firebaseAuth.currentUser == nil{
            firebaseAuth.signIn(withCustomToken:  preferenceHelper.getAuthToken()) { user, error in
                if error == nil{
                    print("Firebase authentication successfull...")
                }
                else{
                    print(error ?? "Error in firebase authentication")
                }
            }
        }
    }
    
    
    func setScreenVisibility(isShowLoading:Bool){
        if isShowLoading{
            Utility.showLoading()
        }
        print("")
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.tintColor = UIColor.black
        self.tabBarController?.tabBar.barTintColor = UIColor.themeViewBackgroundColor
        self.tabBarController?.tabBar.items?[0].isEnabled = true
        self.tabBarController?.tabBar.items?[1].isEnabled = true
        self.tabBarController?.tabBar.items?[2].isEnabled = true
        self.tabBarController?.tabBar.items?[3].isEnabled = true
        
        if !ScreenVisibilityPermission.Deliveries && !ScreenVisibilityPermission.Order && !ScreenVisibilityPermission.Product{
            self.tabBarController?.tabBar.items?[0].isEnabled = false
            self.tabBarController?.tabBar.items?[1].isEnabled = false
            self.tabBarController?.tabBar.items?[2].isEnabled = false
            self.tabBarController?.selectedIndex = 3
        }else if !ScreenVisibilityPermission.Deliveries && !ScreenVisibilityPermission.Product{
            self.tabBarController?.tabBar.items?[1].isEnabled = false
            self.tabBarController?.tabBar.items?[2].isEnabled = false
            self.tabBarController?.selectedIndex = 0
        }else if !ScreenVisibilityPermission.Order && !ScreenVisibilityPermission.Product{
            self.tabBarController?.tabBar.items?[0].isEnabled = false
            self.tabBarController?.tabBar.items?[2].isEnabled = false
            self.tabBarController?.selectedIndex = 1
        }
        else if !ScreenVisibilityPermission.Deliveries && !ScreenVisibilityPermission.Order{
            self.tabBarController?.tabBar.items?[0].isEnabled = false
            self.tabBarController?.tabBar.items?[1].isEnabled = false
            self.tabBarController?.selectedIndex = 2
        }else{
            if !ScreenVisibilityPermission.Order{
                self.tabBarController?.tabBar.items?[0].isEnabled = false
                self.tabBarController?.selectedIndex = 1
            }
            if !ScreenVisibilityPermission.Deliveries{
                self.tabBarController?.tabBar.items?[1].isEnabled = false
                self.tabBarController?.selectedIndex = 0
            }
        }

        if preferenceHelper.getIsSubStoreLogin() && !ScreenVisibilityPermission.Order{
            self.arrOrders.removeAll()
            self.imgEmpty.isHidden = true
            self.tblForOrders.isHidden = true
        }else{
            self.imgEmpty.isHidden = false
            self.tblForOrders.isHidden = false
            
        }
        
        if !ScreenVisibilityPermission.CreateOrder{
            btnCreateNewOrder.isHidden = true
        }else{
            btnCreateNewOrder.isHidden = false
        }

        self.tabBarController?.tabBar.items?[0].title = "TXT_ORDERS".localized
        self.tabBarController?.tabBar.items?[1].title = "TXT_DELIVERIES".localized
        self.tabBarController?.tabBar.items?[2].title = "TXT_MENU".localized
        self.tabBarController?.tabBar.items?[3].title = "TXT_ACCOUNT".localized
        
        if #available(iOS 10.0, *) {
            self.tabBarController?.tabBar.unselectedItemTintColor = UIColor.black
        }
    }
    func setLocalization() {
        //COLORS
        super.setNavigationTitle(title: "TXT_ORDERS".localized)
        self.view.backgroundColor = UIColor.themeViewBackgroundColor;
        
        viewForTab.backgroundColor = UIColor.gray
        let firstItem = tabBar.addTabBarItem(title: "TXT_CURRENT_ORDERS".localized.localized, imageName: "", selectedImageName: "", tagIndex: 1)
        let secondItem = tabBar.addTabBarItem(title: "TXT_SCHEDULE_ORDERS".localized, imageName: "", selectedImageName: "", tagIndex: 2)
        
        tabBar.setItems([firstItem,secondItem], animated: false)
        tabBar.selectedItem = tabBar.items![0]
        // Set Font
        tabBar.delegate = self
        tabBar.barTintColor = UIColor.themeNavigationBackgroundColor
        tabBar.backgroundColor = UIColor.themeNavigationBackgroundColor
        tblForOrders.tableFooterView = UIView.init(frame: CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: UIScreen.main.bounds.width, height: 0)))
        tblForOrders.showsVerticalScrollIndicator = false
        super.hideBackButtonTitle()
    }
    
    func setupLayout() {
        viewForTab.setShadow(shadowColor: UIColor.gray.cgColor, shadowOffset:CGSize.init(width: 0.0, height: 3.0), shadowOpacity: 0.8, shadowRadius: 3.0)
        tabBar.layoutIfNeeded()
        tabBar.tintColor = UIColor.themeTitleColor
        tabBar.selectionIndicatorImage = APPDELEGATE.getImageWithColorPosition(color: UIColor.themeColor, size: CGSize.init(width: tabBar.bounds.width/2, height: tabBar.bounds.height ), lineSize: CGSize.init(width: tabBar.bounds.width/2, height: 1.5))
        
        tabBar.frame.size.width = self.view.frame.width + 4
        tabBar.frame.origin.x = -2
    }
    
    override func updateUIAccordingToTheme() {
        self.tblForOrders.reloadData()
        setMenuButton()
    }
    
    
    //MARK: Button action methods
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 1 {
            tabBar.selectedItem = tabBar.items![0]
            isViewCurrentOrder = true
        }else {
            tabBar.selectedItem = tabBar.items![1]
            isViewCurrentOrder = false
        }
        reloadTableWithArray()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onClickBtnCreateNewOrder(_ sender: Any) {
        
    }
    
    func updateUi(isUpdate:Bool = false) {
        if viewForTab != nil{
            if preferenceHelper.getIsSubStoreLogin() && !ScreenVisibilityPermission.Order{
                viewForTab.isHidden = true
                imgEmpty?.isHidden = true
                tblForOrders?.isHidden = true
            }else{
                viewForTab.isHidden = false
                imgEmpty?.isHidden = isUpdate
                tblForOrders?.isHidden = !isUpdate
                tblForOrders?.reloadData()
            }
//            if ScreenVisibilityPermission.Order{
//                viewForTab.isHidden = false
//                imgEmpty?.isHidden = isUpdate
//                tblForOrders?.isHidden = !isUpdate
//                tblForOrders?.reloadData()
//            }else{
//                viewForTab.isHidden = true
//                imgEmpty?.isHidden = true
//                tblForOrders?.isHidden = true
//            }
        }
       
        Utility.hideLoading()

    }
    
    func reloadTableWithArray() {
        arrForTableOrder.removeAll()
        if isViewCurrentOrder {
            for order in arrCurrentOrders {
                self.arrForTableOrder.append(order)
            }
        }else {
            for order in arrScheduleOrders {
                self.arrForTableOrder.append(order)
            }
        }
        updateUi(isUpdate: !self.arrForTableOrder.isEmpty)
    }
    
    @objc func onClickEditOrder(sender:UIButton) {
        let selectedOrder:Order =  arrForTableOrder[sender.tag]
        
        
        StoreSingleton.shared.updateOrder?.orderId  = selectedOrder.id
        StoreSingleton.shared.updateOrder?.orderDetails = selectedOrder.cartDetail.orderDetails
        self.performSegue(withIdentifier: SEGUE.EDIT_ORDER, sender: nil)
    }
    
    
    /* Table Delegate */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrForTableOrder.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:OrderCell?
        
        cell = tableView.dequeueReusableCell(withIdentifier: "orderCell") as? OrderCell
        
        if (cell == nil) {
            cell = UITableViewCell(style: .default, reuseIdentifier: "orderCell") as? OrderCell
        }
        cell?.selectionStyle = .none
        cell?.setCellData(orderItem: arrForTableOrder[indexPath.row])
        //        cell?.btnEditOrder.tag = indexPath.row
        //        cell?.btnEditOrder.backgroundColor = UIColor.themeSectionBackgroundColor
        //        cell?.btnEditOrder.addTarget(self, action: #selector(onClickEditOrder(sender:)), for: .touchUpInside)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        selectedOrder = arrForTableOrder[indexPath.row]
        self.performSegue(withIdentifier: SEGUE.ORDERDETAIL, sender: self)
    }
    
    // MARK :- Web Services
    func wsGetUserInfo() {
        let currentAppVersion: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)
        let afh:AlamofireHelper = AlamofireHelper.init()
        let dictParam : [String : Any] = [ PARAMS.STORE_ID: preferenceHelper.getUserId(),
                                           PARAMS.SERVER_TOKEN: preferenceHelper.getSessionToken(),
                                           PARAMS.APP_VERSION: currentAppVersion,
                                           PARAMS.DEVICE_TOKEN: preferenceHelper.getDeviceToken()]
        
        print(dictParam)
        afh.getResponseFromURL(url: WebService.WS_GET_STORE_INFO, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) { (response, error) -> (Void) in
            Parser.parseUserStorageData(response: response, completion: { result in
                
                print(Utility.conteverDictToJson(dict: response))
                
                if result {
                    if(preferenceHelper.getIsUserApprove()) {
                        if(preferenceHelper.getIsAdminDocumentMandatory() && !preferenceHelper.getIsUserDocumentUploaded()) {
                            self.gotoDocument()
                            return
                        }else {
                            DispatchQueue.main.async {
                                self.openConfirmationDialog()
                            }
                        }
                    }else {
                        if(preferenceHelper.getIsAdminDocumentMandatory() && !preferenceHelper.getIsUserDocumentUploaded()) {
                            self.gotoDocument()
                            return
                        }else {
                            self.openApprovelDialog()
                        }
                    }
                    if preferenceHelper.getIsSubStoreLogin(){
                        if(!StoreSingleton.shared.subStore.isApproved) {
                            self.openApprovelDialog()
                        }
                        
                        if self.btnCreateNewOrder != nil {
                            self.btnCreateNewOrder.isHidden = !ScreenVisibilityPermission.CreateOrder }
                    }else{
                        if self.btnCreateNewOrder != nil {
                            self.btnCreateNewOrder.isHidden = !StoreSingleton.shared.store.isStoreCreateOrder
                        }
                    }
                    self.setScreenVisibility(isShowLoading: true)
                    //To show updated Store flags
                    self.reloadTableWithArray()
                    
                    self.firebaseAuthentication()
                }else {
                    //APPDELEGATE.goToHome();
                    return
                }
            })
        }
    }
    
    func wsLogout() {
        Utility.showLoading()
        let dictParam : [String : Any] = [PARAMS.STORE_ID      : preferenceHelper.getUserId(),
                                          PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken()]
        
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_STORE_LOGOUT, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            
            Utility.hideLoading()
            if  Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true) {
                APPDELEGATE.removeFirebaseTokenAndTopic()
                preferenceHelper.setSessionToken("")
                APPDELEGATE.goToHome()
                StoreSingleton.shared.cart.removeAll()
                return
            }
        }
    }
    
    func wsGenerateOtp(_ dictParam:[String:Any]) {
        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_GENERATE_OTP, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            
            if  Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true) {
                let otpResponse:OtpResponse = OtpResponse.init(fromDictionary:  response)
                Log.i(otpResponse)

                switch (self.checkWhichOtpValidationON()) {
                case CONSTANT.SMS_AND_EMAIL_VERIFICATION_ON:
                    self.openOTPVerifyDialog(otpEmailVerification: otpResponse.otpForEmail ?? "", otpSmsVerification: otpResponse.otpForSms ?? "", editTextOneHint:"TXT_EMAIL_OTP".localized, ediTextTwoHint: "TXT_PHONE_OTP".localized, isEditTextTwoIsHidden: false, OTPID: otpResponse.otpID, params: dictParam)
                    break;
                case CONSTANT.SMS_VERIFICATION_ON:
                    self.openOTPVerifyDialog(otpEmailVerification: otpResponse.otpForEmail ?? "", otpSmsVerification: otpResponse.otpForSms ?? "", editTextOneHint:"TXT_PHONE_OTP".localized, ediTextTwoHint: "TXT_PHONE_OTP".localized, isEditTextTwoIsHidden: true,OTPID: otpResponse.otpID, params: dictParam)
                    break;
                case CONSTANT.EMAIL_VERIFICATION_ON:
                    self.openOTPVerifyDialog(otpEmailVerification: otpResponse.otpForEmail ?? "", otpSmsVerification: otpResponse.otpForSms ?? "", editTextOneHint:"TXT_EMAIL_OTP".localized, ediTextTwoHint: "TXT_PHONE_OTP".localized, isEditTextTwoIsHidden: true,OTPID: otpResponse.otpID, params: dictParam)
                    break;
                default:
                    break;
                }
            }
        }
    }

    func openOTPVerifyDialog(otpEmailVerification:String, otpSmsVerification:String,editTextOneHint:String, ediTextTwoHint:String, isEditTextTwoIsHidden:Bool, OTPID:String, params:[String:Any]) {
        let dialogForVerification = CustomVerificationDialog.showCustomVerificationDialog(title: "TXT_VERIFY_ACCOUNT".localizedCapitalized, message: "MSG_VERIFY_DETAIL".localizedCapitalized, titleLeftButton: "TXT_CANCEL".localizedUppercase, titleRightButton: "TXT_OK".localizedUppercase, editTextOneHint: editTextOneHint, editTextTwoHint:ediTextTwoHint, isEdiTextTwoIsHidden: isEditTextTwoIsHidden, isForVerifyOtp: true, params: params, isLogoutLeftBtn: true)
        dialogForVerification.startTimer()
        dialogForVerification.onClickRightButton = {  [unowned dialogForVerification, unowned self]
            (text1:String, text2:String) in
            switch (self.checkWhichOtpValidationON()) {
            case CONSTANT.SMS_AND_EMAIL_VERIFICATION_ON:
                self.wsUpdateOtpVerification(oTPID: OTPID,EmailOTP:text1,SmsOTP:text2, dialogForVerification: dialogForVerification)

//                if (text1.compare(otpEmailVerification) == ComparisonResult.orderedSame && text2.compare(otpSmsVerification) == ComparisonResult.orderedSame ) {
//                    dialogForVerification.removeFromSuperview()
//                    self.wsUpdateOtpVerification(oTPID: OTPID,EmailOTP:text1,SmsOTP:text2)
//                }else {
//                    if !(text1.compare(otpEmailVerification) == ComparisonResult.orderedSame) {
//                        Utility.showToast(message: "MSG_EMAIL_OTP_WRONG".localized)
//                    }else if !(text2.compare(otpSmsVerification) == ComparisonResult.orderedSame) {Utility.showToast(message: "MSG_SMS_OTP_WRONG".localized)
//                    }
//                }
                break;
            case CONSTANT.SMS_VERIFICATION_ON:
//                if (text1.compare(otpSmsVerification) == ComparisonResult.orderedSame) {
//                    dialogForVerification.removeFromSuperview()
//                    self.wsUpdateOtpVerification(oTPID: OTPID,EmailOTP:text1,SmsOTP:text2)
//                }else {
//                    Utility.showToast(message: "MSG_SMS_OTP_WRONG".localized)
//                }
                self.wsUpdateOtpVerification(oTPID: OTPID,EmailOTP:text1,SmsOTP:text2, dialogForVerification: dialogForVerification)

                break;
            case CONSTANT.EMAIL_VERIFICATION_ON:
//                if (text1.compare(otpEmailVerification) == ComparisonResult.orderedSame) {
//                    dialogForVerification.removeFromSuperview()
//                    self.wsUpdateOtpVerification(oTPID: OTPID,EmailOTP:text1,SmsOTP:text2)
//                }else {
//                    Utility.showToast(message: "MSG_EMAIL_OTP_WRONG".localized)
//                }
                self.wsUpdateOtpVerification(oTPID: OTPID,EmailOTP:text1,SmsOTP:text2, dialogForVerification: dialogForVerification)
                break;

            default:
                break;
            }
        }
        dialogForVerification.onClickLeftButton = { [unowned dialogForVerification, unowned self] in
            dialogForVerification.removeFromSuperview();
            self.wsLogout()
        }
    }
    /* func wsGetOtpVerify(otpID:String,emailOTP:String,smsOtp:String,dialogForVerification:CustomVerificationDialog){
     let dictParam : [String : Any] =
     [PARAMS.OTP_ID:otpID,
     PARAMS.EMAIL_OTP : emailOTP,
     PARAMS.SMS_OTP:smsOtp]
     
     let alamoFire:AlamofireHelper = AlamofireHelper();
     alamoFire.getResponseFromURL(url: WebService.WS_OTP_VERFICATION, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
     
     if  Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true) {
     //                    let otpResponse:OtpResponse = OtpResponse.init(fromDictionary: response)
     preferenceHelper.setIsEmailVerified(true)
     preferenceHelper.setIsPhoneNumberVerified(true)
     dialogForVerification.removeFromSuperview()
     }
     }
     }*/
    
    func wsUpdateOtpVerification(oTPID:String, EmailOTP:String, SmsOTP:String, dialogForVerification:CustomVerificationDialog) {
        var dictParam : [String : Any] = [PARAMS.USER_ID: preferenceHelper.getUserId(),
                                          PARAMS.SERVER_TOKEN: preferenceHelper.getSessionToken()]

        dictParam.updateValue(oTPID, forKey: PARAMS.OTP_ID)

        if preferenceHelper.getIsEmailVerification() && !preferenceHelper.getIsEmailVerified() {
//            dictParam.updateValue(true, forKey: PARAMS.IS_EMAIL_VERIFIED);
//            dictParam.updateValue(preferenceHelper.getTempEmail(), forKey: PARAMS.EMAIL_OTP)

            dictParam.updateValue(EmailOTP, forKey: PARAMS.EMAIL_OTP)
        }
        if preferenceHelper.getIsPhoneNumberVerification() && !preferenceHelper.isProxy() {
//            dictParam.updateValue(true, forKey: PARAMS.IS_PHONE_NUMBER_VERIFIED);
//            dictParam.updateValue(preferenceHelper.getPhoneCountryCode(), forKey: PARAMS.COUNTRY_PHONE_CODE)
//            dictParam.updateValue(preferenceHelper.getTempPhoneNumber(), forKey: PARAMS.SMS_OTP)
             dictParam.updateValue(SmsOTP, forKey: PARAMS.SMS_OTP)


        }

        let alamoFire:AlamofireHelper = AlamofireHelper();
        alamoFire.getResponseFromURL(url: WebService.WS_OTP_VERFICATION, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {(response, error) -> (Void) in
            
            if  Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: true) {
                switch (self.checkWhichOtpValidationON()) {
                    case CONSTANT.SMS_AND_EMAIL_VERIFICATION_ON:
                        preferenceHelper.setIsEmailVerified(true)
                        preferenceHelper.setIsPhoneNumberVerified(true)
                        dialogForVerification.removeFromSuperview()
                        break;

                    case CONSTANT.SMS_VERIFICATION_ON:
                        dialogForVerification.removeFromSuperview()
                        preferenceHelper.setIsPhoneNumberVerified(true);
                        break;

                    case CONSTANT.EMAIL_VERIFICATION_ON:
                        preferenceHelper.setIsEmailVerified(true);
                        dialogForVerification.removeFromSuperview()

                        break;
                    default:
                        break;
                }
                //Doing this after dialog remove from superview
                Utility.showToast(message: "MSG_CODE_140".localized)
            }
        }
    }
    
    @objc func wsGetOrders() {
        
        if (preferenceHelper.getSessionToken().isEmpty()){
                //&& preferenceHelper.getSubStoreSessionToken().isEmpty() ){

//        if (preferenceHelper.getSessionToken().isEmpty() && !preferenceHelper.getIsSubStoreLogin()) || (preferenceHelper.getSubStoreSessionToken().isEmpty() && preferenceHelper.getIsSubStoreLogin()){

            self.stopTimer()
            Utility.hideLoading()
            APPDELEGATE.goToHome()
            return
        }else {
            let dictParam : [String : Any] =
                [PARAMS.STORE_ID      : preferenceHelper.getUserId(),
                 PARAMS.SERVER_TOKEN : preferenceHelper.getSessionToken()]
            
            print(dictParam)
            print("dictParam WS_GET_ORDER_LIST --> \(Utility.conteverDictToJson(dict: dictParam))")
            
            let alamoFire:AlamofireHelper = AlamofireHelper();
            alamoFire.getResponseFromURL(url: WebService.WS_GET_ORDER_LIST, methodName: AlamofireHelper.POST_METHOD, paramData: dictParam) {   (response, error) -> (Void) in
                
                print("response WS_GET_ORDER_LIST --> \(Utility.conteverDictToJson(dict: response))")
                Utility.showLoading()
                self.arrOrders.removeAll()
                self.arrScheduleOrders.removeAll()
                self.arrCurrentOrders.removeAll()
                
                if  Parser.isSuccess(response: response, withSuccessToast: false, andErrorToast: false) {
                    let orderListReponse:OrderListResponse = OrderListResponse.init(fromDictionary: response)
                    self.arrOrders = orderListReponse.orders
                    
                    StoreSingleton.shared.vehicalList.removeAll()
                    StoreSingleton.shared.adminVehicalList.removeAll()
                    
                    for vehicle in orderListReponse.vehicles {
                        StoreSingleton.shared.vehicalList.append(vehicle)
                    }
                    for vehicle in orderListReponse.adminVehicles {
                        StoreSingleton.shared.adminVehicalList.append(vehicle)
                    }
                    
                    for order in self.arrOrders {
                        if order.isScheduleOrder {
                            self.arrScheduleOrders.append(order)
                        }else {
                            self.arrCurrentOrders.append(order)
                        }
                    }
                }
                self.reloadTableWithArray()
            }
        }
    }
    
    func gotoDocument() {
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "Account", bundle: nil)
        if let documentVC : DocumentVC = mainView.instantiateViewController(withIdentifier: "DocumentVC") as? DocumentVC {
            self.navigationController?.pushViewController(documentVC, animated: true)
        }
    }
    
    //MARK:- User Define Function
    func checkWhichOtpValidationON() -> Int {
        if (checkEmailVerification() && checkPhoneNumberVerification()) {
            return CONSTANT.SMS_AND_EMAIL_VERIFICATION_ON;
        }else if (checkPhoneNumberVerification()) {
            return CONSTANT.SMS_VERIFICATION_ON;
        }else if (checkEmailVerification()) {
            return CONSTANT.EMAIL_VERIFICATION_ON;
        }
        return 0;
    }
    
    func checkEmailVerification() -> Bool{
        return preferenceHelper.getIsEmailVerification() && !preferenceHelper.getIsEmailVerified()
    }
    
    func checkPhoneNumberVerification() -> Bool{
        return preferenceHelper.getIsPhoneNumberVerification() && !preferenceHelper.getIsPhoneNumberVerified();
    }
    
    //MARK: Dialogs
    func openApprovelDialog() {
        //left btn Logout
        //Right contact admin
        
        let dialogForAdminApprove = CustomAlertDialog.showCustomAlertDialog(title: "Admin Alert!", message: "MSG_APPROVE_ERROR".localized, titleLeftButton: "TXT_EXIT".localizedUppercase, titleRightButton: "Email",isFromAdminConfimationDialog: true)
        //"TXT_LOGOUT".localizedUppercase
        
        dialogForAdminApprove.onClickLeftButton = { [unowned dialogForAdminApprove] in
//            dialogForAdminApprove.removeFromSuperview();
            preferenceHelper.setSessionToken("")
            NotificationCenter.default.removeObserver(self)
            self.stopTimer()

            APPDELEGATE.goToHome()
//            exit(0)
        }
        dialogForAdminApprove.onClickRightButton = { [unowned dialogForAdminApprove] in
//            dialogForAdminApprove.removeFromSuperview();
            let email = preferenceHelper.getAdminEmail()
            if let url = URL(string: "mailto:\(email)") {
              if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
              } else {
                UIApplication.shared.openURL(url)
              }
            }
            return;
        }
    }
    
    func openConfirmationDialog() {
        
       
        var dictParam : [String : Any] = [PARAMS.TYPE : CONSTANT.TYPE_STORE,
                                          PARAMS.STORE_ID :preferenceHelper.getUserId(),
                                          PARAMS.SERVER_TOKEN:preferenceHelper.getSessionToken()]
        
        switch (self.checkWhichOtpValidationON()) {
        case CONSTANT.SMS_AND_EMAIL_VERIFICATION_ON:
            
            let dialogForConfirmation = CustomConfirmationDialog.showCustomConfirmationDialog(title: "TXT_CONFIRMATION_DIALOG".localized, message: "MSG_CONFIRMATION_EMAIL_PHONE".localized, titleLeftButton: "TXT_LOGOUT".localized, titleRightButton: "TXT_SEND".localized, editTextOneText: preferenceHelper.getEmail(), editTextTwoText: preferenceHelper.getPhoneNumber(), isEdiTextTwoIsHidden: false, isEdiTextOneIsHidden: false)
            dialogForConfirmation.onClickRightButton = { [unowned dialogForConfirmation, unowned self](text1:String, text2:String) in
                if text1.checkEmailValidation().0 == true && text2.isValidMobileNumber().0 == true {
                    preferenceHelper.setTempEmail(text1)
                    preferenceHelper.setTempPhoneNumber(text2)
                    dictParam.updateValue(text1, forKey: PARAMS.EMAIL)
                    dictParam.updateValue(text2, forKey: PARAMS.PHONE)
                    dictParam.updateValue(preferenceHelper.getPhoneCountryCode(), forKey: PARAMS.COUNTRY_PHONE_CODE)
                    DispatchQueue.main.async {
                        dialogForConfirmation.removeFromSuperview()
                    }
                    self.wsGenerateOtp(dictParam)
                }else {
                    Utility.showToast(message: "MSG_PLEASE_ENTER_VALID_EMAIL_OR_PHONE_NUMBER".localized)
                }
            }
            dialogForConfirmation.onClickLeftButton = { [unowned dialogForConfirmation] in
                dialogForConfirmation.removeFromSuperview()
                preferenceHelper.setSessionToken("")
                NotificationCenter.default.removeObserver(self)
                self.stopTimer()

                APPDELEGATE.goToHome()
               // exit(0)
            }
            break;
        case CONSTANT.SMS_VERIFICATION_ON:
            let dialogForConfirmation = CustomConfirmationDialog.showCustomConfirmationDialog(title: "TXT_CONFIRMATION_DIALOG".localized, message: "MSG_CONFIRMATION_PHONE".localized, titleLeftButton: "TXT_LOGOUT".localized, titleRightButton: "TXT_SEND".localized, editTextOneText: "", editTextTwoText: preferenceHelper.getPhoneNumber(), isEdiTextTwoIsHidden: false, isEdiTextOneIsHidden: true)
            dialogForConfirmation.onClickRightButton = {  [unowned dialogForConfirmation, unowned self] (text1:String, text2:String) in
                let validPhoneNo = text2.isValidMobileNumber()
                if validPhoneNo.0 == true {
                    dictParam.updateValue(text2, forKey: PARAMS.PHONE)
                    dictParam.updateValue(preferenceHelper.getPhoneCountryCode(), forKey: PARAMS.COUNTRY_PHONE_CODE)
                    preferenceHelper.setTempPhoneNumber(text2)
                    self.wsGenerateOtp(dictParam)
                    DispatchQueue.main.async {
                        dialogForConfirmation.removeFromSuperview();
                    }
                    
                }else {
                    Utility.showToast(message:validPhoneNo.1)
                }
            }
            dialogForConfirmation.onClickLeftButton = { [unowned dialogForConfirmation, unowned self] in
                dialogForConfirmation.removeFromSuperview();
                preferenceHelper.setSessionToken("")
                NotificationCenter.default.removeObserver(self)
                self.stopTimer()

                APPDELEGATE.goToHome()
              //  exit(0)
            }
            break;
            
        case CONSTANT.EMAIL_VERIFICATION_ON:
            let dialogForConfirmation = CustomConfirmationDialog.showCustomConfirmationDialog(title: "TXT_CONFIRMATION_DIALOG".localized, message: "MSG_CONFIRMATION_EMAIL".localized, titleLeftButton: "TXT_LOGOUT".localized, titleRightButton: "TXT_SEND".localized, editTextOneText: preferenceHelper.getEmail(), editTextTwoText: "", isEdiTextTwoIsHidden: true, isEdiTextOneIsHidden: false)
            dialogForConfirmation.onClickRightButton = {  [unowned dialogForConfirmation, unowned self] (text1:String, text2:String) in
                let validEmail = text1.checkEmailValidation()
                if validEmail.0 == true {
                    preferenceHelper.setTempEmail(text1)
                    dictParam.updateValue(text1, forKey: PARAMS.EMAIL)
                    DispatchQueue.main.async {
                        dialogForConfirmation.removeFromSuperview();
                    }
                    self.wsGenerateOtp(dictParam)
                }else {
                    Utility.showToast(message: validEmail.1);
                }
            }
            dialogForConfirmation.onClickLeftButton = { [unowned dialogForConfirmation, unowned self] in
                dialogForConfirmation.removeFromSuperview();
                preferenceHelper.setSessionToken("")
                NotificationCenter.default.removeObserver(self)
                self.stopTimer()

                APPDELEGATE.goToHome()
             //   exit(0)
            }
            break;
        default:
            break
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SEGUE.ORDERDETAIL {
            let currentOrder = segue.destination as! OrderDetailVC
            //Storeapp //API changes
            currentOrder.selectedOrder = selectedOrder!
            
        }
    }
    
    //MARK: TIMERS FOR GET ORDERS
    func startTimer() {
        if (preferenceHelper.getUserId().count > 0 && preferenceHelper.getSessionToken().count > 0) || (preferenceHelper.getSubStoreId().count > 0 && preferenceHelper.getSessionToken().count > 0){
                     self.wsGetOrders()
        }
        timerForGetOrders?.invalidate()
        timerForGetOrders = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(self.wsGetOrders), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        if timerForGetOrders != nil {
            timerForGetOrders?.invalidate()
            timerForGetOrders = nil
        }
        timerForGetOrders?.invalidate()
        //Utility.hideLoading()
    }
}

class OrderCell: CustomCell {

    @IBOutlet weak var btnDeliveryMan: UIButton!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblDeliveryAddress: UILabel!
    @IBOutlet weak var lblTotalOrderPriceValue: UILabel!
    @IBOutlet weak var imgPayment: UIImageView!
    @IBOutlet weak var lblOrderNo: UILabel!
    @IBOutlet weak var lblOrderStatus: UILabel!
    @IBOutlet weak var lblScheduleOrderDate: UILabel!
    //    @IBOutlet weak var btnEditOrder: UIButton!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var lblTopSeprator: CustomLabelSeprator!
    @IBOutlet weak var lblCallDeliverymanSeprator: CustomLabelSeprator!

    var strUserPhone:String = "";
    var orderId:String = "";

    override func awakeFromNib() {
        super.awakeFromNib()
        // Set Font
        lblUserName.font = FontHelper.textMedium()
        lblTotalOrderPriceValue.font = FontHelper.textMedium()
        
        lblOrderNo.font = FontHelper.textSmall()
        lblOrderStatus.font = FontHelper.textSmall()
        lblDeliveryAddress.font = FontHelper.textSmall()
        lblScheduleOrderDate.font = FontHelper.textSmall()
        
        //Set Text Color
        lblUserName.textColor = UIColor.themeTextColor
        lblDeliveryAddress.textColor = UIColor.themeLightTextColor
        lblTotalOrderPriceValue.textColor = UIColor.themeTextColor
        lblOrderNo.textColor = UIColor.themeTextColor
//        lblOrderStatus.textColor = UIColor.themeColor
        lblScheduleOrderDate.textColor = UIColor.themeTextColor
        //        btnEditOrder.setTitle(" "+"TXT_EDIT".localizedCapitalized+" ", for: .normal)
        
        btnCall.titleLabel?.font = FontHelper.labelRegular()
        btnDeliveryMan.titleLabel?.font = FontHelper.labelRegular()
        btnCall.setTitleColor(.themeColor, for: .normal)
        btnDeliveryMan.setTitleColor(.themeTextColor, for: .normal)

        //        btnCall.tintColor = .themeTextColor
        //        btnPickupOption.tintColor = .themeTextColor
        
        btnCall.backgroundColor = .themeViewBackgroundColor
        btnDeliveryMan.backgroundColor = .themeViewBackgroundColor
        
        imgUser.setRound()
        //        btnEditOrder.isHidden = true
    }

    func setCellData(orderItem:Order) {
        //        self.btnEditOrder.layer.cornerRadius = 5.0
        //        self.btnEditOrder.layer.masksToBounds = true

        //API changes
        //Storeapp
        imgUser.downloadedFrom(link: orderItem.userDetail.imageUrl)

        btnCall.setImage(UIImage(named: "callIcon")?.imageWithColor(color: .themeColor), for: .normal)
        btnCall.setTitle("  " + "TXT_CALL_USER".localizedCapitalized + "  " , for: .normal)

        //API changes
        //        lblUserName.text = orderItem.cartDetail.destinationAddresses[0].userDetails.name
        lblUserName.text = orderItem.userDetail.name
        strUserPhone = orderItem.userDetail.phone
        orderId = orderItem.id

        lblDeliveryAddress.text = orderItem.cartDetail.destinationAddresses[0].address
        lblTotalOrderPriceValue.text =  (orderItem.total).toCurrencyString()

        if orderItem.delivery_type == DeliveryType.tableBooking {
            btnDeliveryMan.isHidden = true
            lblCallDeliverymanSeprator.isHidden = true
        } else {
            btnDeliveryMan.isHidden = false
            lblCallDeliverymanSeprator.isHidden = false
        }

        if !orderItem.isUserPickupOrder {
            btnDeliveryMan.setImage(UIImage(named: "deliveryMan")?.imageWithColor(color: .themeIconTintColor), for: .normal)
            btnDeliveryMan.setTitle("  " + "TX_PROVIDER_DELIVERY".localizedCapitalized + "  " , for: .normal)
        } else {
            btnDeliveryMan.setImage(UIImage(named: "takeway")?.imageWithColor(color: .themeIconTintColor), for: .normal)
            btnDeliveryMan.setTitle("  " + "TXT_PICKUP".localizedCapitalized + " ", for: .normal)
        }
        
        //        btnDeliveryMan.isHidden = orderItem.orderPaymentDetail.isUserPickupOrder
        //        btnDeliveryMan.isHidden = orderItem.isUserPickupOrder
        
        ////        if orderItem.orderPaymentDetail.isPaymentModeCash {
        //        if orderItem.isPaymentModeCash {
        //            imgPayment.image = UIImage.init(named: "cash_icon")
        //        }else {
        //            imgPayment.image = UIImage.init(named: "card_icon")
        //        }
        
        if orderItem.isScheduleOrder {
            lblTopSeprator.isHidden = false
            
            lblScheduleOrderDate.isHidden = false
            //Storeapp
            if orderItem.scheduleOrderStartAt2.count > 0{
                let str2 : String = Utility.stringToString(strDate: orderItem.scheduleOrderStartAt2, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.TIME_FORMAT_24Hours,timezone:orderItem.timeZone)
                if str2.count > 0{
                    lblScheduleOrderDate.text = "\(Utility.stringToString(strDate: orderItem.scheduleOrderStartAt, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_TIME_FORMAT,timezone:orderItem.timeZone)) - \(str2)"
                }
            } else {
                lblScheduleOrderDate.text = "\(Utility.stringToString(strDate: orderItem.scheduleOrderStartAt, fromFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB, toFormat: DATE_CONSTANT.DATE_TIME_FORMAT,timezone:orderItem.timeZone))"
            }
        } else {
            lblScheduleOrderDate.isHidden = true
            lblTopSeprator.isHidden = true
        }
        //       lblOrderNo.text = "TXT_ORDER_NO".localized + String(orderItem.uniqueId)
        lblOrderNo.text = "TXT_ORDER_NO".localized + String(orderItem.order_unique_id)

        let orderStatus:OrderStatus = OrderStatus(rawValue: orderItem.orderStatus) ?? .Unknown;
        lblOrderStatus.text = orderStatus.text(orderItem: orderItem)
        lblOrderStatus.textColor = orderStatus.textColor(orderItem: orderItem)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func onClickBtnCall(_ sender: Any) {
        if preferenceHelper.getIsEnableTwilioCallMask() {
            TwilioCallMasking.shared.wsTwilloCallMasking(id: orderId, type: "\(CONSTANT.TYPE_USER)")
        } else {
            if strUserPhone.isEmpty() {
                Utility.showToast(message: "MSG_UNABLE_TO_CALL".localized)
            } else {
                if let url = URL(string: "tel://\(strUserPhone)"), UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                } else {
                    Utility.showToast(message: "MSG_UNABLE_TO_CALL".localized)
                }
            }
        }
    }
}

extension OrdersVC:PBRevealViewControllerDelegate
{
    func setupRevealViewController() {
       // self.revealViewController()?.panGestureRecognizer?.isEnabled = true
        self.revealViewController()?.delegate = self
//        btnMenu.addTarget(self.revealViewController(), action: #selector(PBRevealViewController.revealSideView), for: .touchUpInside)
    }

    func revealController(_ revealController: PBRevealViewController, willShowLeft viewController: UIViewController) {
        revealController.mainViewController?.view.isUserInteractionEnabled = false;
    }

    func revealController(_ revealController: PBRevealViewController, willHideLeft viewController: UIViewController) {
        revealController.mainViewController?.view.isUserInteractionEnabled = true;
    }
}
