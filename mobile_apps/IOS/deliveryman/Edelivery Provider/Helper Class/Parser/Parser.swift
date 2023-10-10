//
//  Parser.swift
//  Edelivery Provider
//
//  Created by Kamlesh on 07/03/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//


import Foundation
import FirebaseMessaging
import GoogleMaps
import GooglePlaces

class Parser: NSObject {
    //MARK:
    //MARK:- Basic Setting Details
    class func parseAppSettingDetail(response:[String:Any])-> Bool {
        if isSuccess(response: response, withSuccessToast: false, andErrorToast: true) {
            let setting:SettingDetailResponse = SettingDetailResponse.init(dictionary: response)!
            preferenceHelper.setIsShowOptionalFieldInRegister(setting.isShowOptionalField!)
            preferenceHelper.setIsEmailVerification(setting.isVerifyEmail!);
            preferenceHelper.setIsProfilePicRequired(setting
                .isProfilePictureRequired!);
            preferenceHelper.setIsPhoneNumberVerification(setting.isVerifyPhone!);
            preferenceHelper.setIsReferralOn(setting.isUseReferral!);
            preferenceHelper.setIsAdminDocumentMandatory(setting.isUploadDocuments!);
            preferenceHelper.setIsRequiredForceUpdate(setting.isForceUpdate!)
            Google.API_KEY = setting.googleKey!
            GMSServices.provideAPIKey(Google.MAP_KEY)

            preferenceHelper.setLatestAppVersion(setting.versionCode!)
            preferenceHelper.setIsLoginByEmail(setting.isLoginByEmail!)
            preferenceHelper.setIsLoginByPhone(setting.isLoginByPhone!)
            preferenceHelper.setIsSocialLoginEnable(setting.isSocialLoginEnable)
            
            preferenceHelper.setAdminEmail(setting.adminEmail)
            preferenceHelper.setAdminContact(setting.adminContact)
            preferenceHelper.setTermsAndCondition(setting.termsAndCondition)
            preferenceHelper.setPrivacyPolicy(setting.privacyPolicy)
            
            preferenceHelper.setMinMobileLength(setting.mobileMinLenfth)
            preferenceHelper.setMaxMobileLength(setting.mobileMaxLenfth)
            
            preferenceHelper.setUserPanelUrl(setting.userBaseUrl)
            preferenceHelper.setIsEnableTwilioCallMask(setting.is_enable_twilio_call_masking)
            
            return true;
        } else {
            return false;
        }
    }

    //MARK: - ProviderOnline/Offline
    class func parseChangeStatus(response: [String:Any])-> Bool {
        if isSuccess(response: response) {
            let appKeys:AppKeyResponse = AppKeyResponse.init(dictionary: response)!
            let myAppKey:AppKeys = appKeys.appKeys!;
            preferenceHelper.setGoogleKey(myAppKey.iosUserAppGoogleKey!)
            preferenceHelper.setIsRequiredForceUpdate(myAppKey.iosUserAppForceUpdate!)
            preferenceHelper.setLatestAppVersion(myAppKey.iosUserAppVersionCode!)
            return true;
        } else {
            return false;
        }
    }

    //MARK: - Login/Register/Profile Response
    class func parseUserStorageData(response: [String:Any],isShowToast:Bool = true, completion: @escaping (_ result: Bool) -> Void) {
        if (isSuccess(response: response, withSuccessToast: isShowToast, andErrorToast: true)) {
            let userData:UserDataResponse = UserDataResponse.init(dictionary: response)!
            if let user:User = userData.user {
                preferenceHelper.setAuthToken(user.firebase_token)
                preferenceHelper.setCityId(user.city_id ?? "")
                preferenceHelper.setUserId(user._id!);
                preferenceHelper.setSessionToken(user.server_token!);
                preferenceHelper.setFirstName(user.first_name!);
                preferenceHelper.setLastName(user.last_name!);
                preferenceHelper.setAddress(user.address!);
                preferenceHelper.setPhoneNumber(user.phone!);
                preferenceHelper.setPhoneCountryCode(user.country_phone_code!);
                preferenceHelper.setEmail(user.email!);
                preferenceHelper.setProfilePicUrl(user.image_url!)
                preferenceHelper.setPhoneNumberLength((user.phone?.count)!);
                preferenceHelper.setIsOnlineOffline(user.is_online!)
                preferenceHelper.setIsActiveJob(user.is_active!)
                preferenceHelper.setIsProviderApprove(user.is_approved!)
                preferenceHelper.setIsProviderDocumentUploaded(user.is_document_uploaded!)
                preferenceHelper.setIsEmailVerified(user.is_email_verified!)
                preferenceHelper.setIsPhoneNumberVerified(user.is_phone_number_verified!)
                preferenceHelper.setReferralCode(user.referral_code!)
                preferenceHelper.setWalletCurrencyCode(user.wallet_currency_code!)
                preferenceHelper.setWalletAmount((user.wallet?.toString()) ?? "0.0")
                if user.socialIds.count > 0 {
                    preferenceHelper.setSocialId(user.socialIds[0])
                } else {
                    preferenceHelper.setSocialId("")
                }

                preferenceHelper.setUniqueId(user.unique_id ?? 0)
                preferenceHelper.setSelectedVehicleId(user.selectedVehicleId)

                CurrentOrder.shared.mapPinUrl = (userData.vehicleDetail?.mapPinImageUrl) ?? ""
                preferenceHelper.setIsAllVehicleDocumentUploaded(userData.is_all_vehicle_document_uploaded)

                //Deliverymanapp
                Messaging.messaging().subscribe(toTopic:"\(preferenceHelper.getUserId())") { error in
                    print("Subscribed to \(preferenceHelper.getUserId()) topic")
                }
                completion(true)
            }
            completion(false)
         } else {
            completion(false)
        }
    }

    //MARK:- Countries
    class func parseCountries(_ response:[String:Any] ,toArray:NSMutableArray , completion: @escaping (_ result: Bool) -> Void) {
        if (isSuccess(response: response, withSuccessToast: false, andErrorToast: true)) {
            let coutries:CountriesResponse = CountriesResponse.init(dictionary: response)!
            let coutryList:[Countries] = coutries.countries!
            if coutryList.count > 0 {
                for country in coutryList {
                    toArray.add(country)
                }
                completion(true)
            }else {
                completion(false)
            }
        }
    }
    //MARK: - parse Wallet History
    class func parseWalletTrasactionHistory(_ response:[String:Any], _ successToast:Bool = false , _ errorToast:Bool = false ,toArray:NSMutableArray , completion: @escaping (_ result: Bool) -> Void) {
        toArray.removeAllObjects()
        if (isSuccess(response: response, withSuccessToast: successToast , andErrorToast: errorToast)) {
            let walletListResponse:WalletTransactionHistoryResponse = WalletTransactionHistoryResponse.init(fromDictionary: response)
            
            let walletRequestList:[WalletRequestDetail] = walletListResponse.walletRequestDetail
            
            if walletRequestList.count > 0 {
                for walletRequestDetail in walletRequestList {
                    toArray.add(walletRequestDetail)
                }
                completion(true)
            }else {
                completion(false)
            }
        }
    }
    class func parseWalletHistory(_ response:[String:Any], _ successToast:Bool = false , _ errorToast:Bool = false ,toArray:NSMutableArray , completion: @escaping (_ result: Bool) -> Void) {
        toArray.removeAllObjects()
        if (isSuccess(response: response, withSuccessToast: successToast, andErrorToast: errorToast)) {
            let walletListResponse:WalletHistoryResponse = WalletHistoryResponse.init(fromDictionary: response )
            
            let walletHistoryList:[WalletHistoryItem] = walletListResponse.walletHistoryList
            
            if walletHistoryList.count > 0 {
                for walletHistoryItem in walletHistoryList {
                    toArray.add(walletHistoryItem)
                }
                completion(true)
            }else {
                completion(false)
            }
        }
    }
    //MARK:
    //MARK:- Active Orders/New Orders
    class func parseAvailableOrders(_ response:[String:Any] ,toArray:NSMutableArray, isNewOrder: Bool , completion: @escaping (_ result: Bool) -> Void) {
        if (isSuccess(response: response, withSuccessToast: false, andErrorToast: false)) {
            let activeOrderResposnse:ActiveOrdersResponse = ActiveOrdersResponse.init(dictionary: response,isNewOrder: isNewOrder)!
            let activeOrderList:[ActiveOrderList] = activeOrderResposnse.arrOrderList!
            if activeOrderList.count > 0 {
                for i in 0..<activeOrderList.count {
                    if isNewOrder {
                        let orderlist:[NewOrder] = activeOrderList[i].arrNewOrder!
                        for order in orderlist
                        {
                            toArray.add(order)
                        }
                    }else {
                        let orderlist:[ActiveOrder] = activeOrderList[i].arrOrder!
                        for order in orderlist
                        {
                            toArray.add(order)
                        }
                    }
                    
                }
                completion(true)
            }else {
                completion(false)
            }
        }else {
            completion(false)
        }
    }
    //MARK:
    //MARK:- Orders History
    class func parseOrderHistory(_ response:[String:Any] ,toArray:NSMutableArray, completion: @escaping (_ result: Bool) -> Void) {
        if (isSuccess(response: response, withSuccessToast: false, andErrorToast: false)) {
            let historyOrderResposnse:OrderHistoryResponse = OrderHistoryResponse.init(dictionary: response)!
            let historyOrderList:[Order_list] = historyOrderResposnse.order_list!
            if historyOrderList.count > 0 {
                let sortedArray = historyOrderList.sorted{ $0.completed_at! > $1.completed_at! }
                for order in sortedArray {
                    toArray.add(order)
                }
                completion(true)
            }else{
                completion(false)
                
            }
        }else{
            completion(false)
        }
    }
    //MARK:
    //MARK:- Document List
    class func parseDocumentList( response:[String:Any] ,toArray:NSMutableArray , completion: @escaping ( _ result: Bool) -> Void) {
        if (isSuccess(response: response, withSuccessToast: false, andErrorToast: false)) {
            let documentResponse:DocumentsResponse = DocumentsResponse.init(fromDictionary: response)
            preferenceHelper.setIsProviderDocumentUploaded(documentResponse.isDocumentUploaded!)
            toArray.removeAllObjects()
            for document in documentResponse.documents! {
                toArray.add(document)
            }
            completion(true)
        }else {
            completion(false)
        }
    }
    class func parseVehicleDocumentList( response:[String:Any] ,toArray:NSMutableArray , completion: @escaping ( _ result: Bool) -> Void) {
        if (isSuccess(response: response, withSuccessToast: false, andErrorToast: true)) {
            let documentResponse:DocumentsResponse = DocumentsResponse.init(fromDictionary: response)
            preferenceHelper.setIsAllVehicleDocumentUploaded(documentResponse.isDocumentUploaded!)
            toArray.removeAllObjects()
            for document in documentResponse.documents! {
                toArray.add(document)
                
            }
            completion(true)
        }else {
            completion(false)
        }
    }
    //MARK:
    //MARK:- History Details
    class func parseOrderHistoryDetail(_ response:[String:Any] ,toHistoryOrderDetail:NSMutableDictionary, completion: @escaping (_ result: Bool) -> Void) {
        if (isSuccess(response: response, withSuccessToast: false, andErrorToast: false)) {
            let historyOrderResposnse:HistoryOrderDetailResponse = HistoryOrderDetailResponse.init(fromDictionary: response)
            toHistoryOrderDetail.setValue(historyOrderResposnse, forKey: PARAMS.HISTORY_DETAIL)
            completion(true)
            
        }else{
            completion(false)
        }
    }
    //MARK:
    //MARK:- Order Status
    class func parseOrderStatus(_ response:[String:Any] ,toOrdersStatus:NSMutableDictionary , completion: @escaping (_ result: Bool) -> Void) {
        if (isSuccess(response: response, withSuccessToast: false, andErrorToast: false)) {
            let orderStatus:OrderStatusResponse = OrderStatusResponse.init(dictionary: response)
            toOrdersStatus.setValue(orderStatus, forKey: CONSTANT.STATUS)
            completion(true)
        }else {
            print("FALSE")
           
        }
    }
    //MARK
    //MARK:- Cities
    class func parseCities(_ response:[String:Any] ,toArray:NSMutableArray , completion: @escaping (_ result: Bool) -> Void) {
        if (isSuccess(response: response, withSuccessToast: false, andErrorToast: true)) {
            toArray.removeAllObjects()
            
            let cityResponse:CitiesResponse = CitiesResponse.init(dictionary: response)!
            let cityList:[Cities] = cityResponse.cities!
            if cityList.count > 0 {
                for city in cityList {
                    toArray.add(city)
                }
                completion(true)
            }else {
                completion(false)
            }
        }else {
            toArray.removeAllObjects()
            completion(false)
        }
    }
   
    //MARK:
    //MARK:- Invoice For History Detail
    class func parseInvoice(_ orderPayment:OrderPayment, toArray:NSMutableArray, currency:String = "",isTaxIncluded:Bool, completetion: @escaping (_ result:Bool) -> Void) {
        toArray.removeAllObjects()
        let unit = (orderPayment.is_distance_unit_mile) ? "UNIT_MILE".localized : "UNIT_KM".localized;
        let tag1:String = "TXT_PAYMENT_DETAIL".localizedCapitalized
        let tag2:String = "TXT_OTHER_EARNING".localizedCapitalized

        
        func appendString(currency:String,price:Double = 0.0,value:Double, unit:String)->String {
            var strPrice:String = "";
            strPrice.append(currency)
            if (price > 0.0) {
                strPrice.append(price.toString());
            }
            if (!unit.isEmpty) {
                strPrice.append("/");
                if (value > 1.0) {
                    strPrice.append(String(value));
                }
                strPrice.append(unit);
            }
            return strPrice;
        }
        func loadInvoice(title:String,mainPrice:Double,currency:String,subprice:Double,subText:String,unitValue:Double,unit:String, sectionTitle:String = "", toArray:NSMutableArray) -> Void {
            if mainPrice > 0.0 {
                let price = mainPrice.toCurrencyString()
                let subTitle = appendString(currency: subText, price: subprice, value: unitValue, unit: unit);
                toArray.add((Invoice.init(title: title, subTitle: subTitle
                    , price: price,sectionTitle: sectionTitle, tip_amount: orderPayment.tip_amount))!)
            }
            
        }
        
        let invoiceArrayList:NSMutableArray = NSMutableArray();
        
        loadInvoice(title:"TXT_BASE_PRICE".localized , mainPrice: orderPayment.total_base_price,currency:currency,subprice:orderPayment.base_price!,subText:currency,unitValue:orderPayment.base_price_distance!,unit:unit,sectionTitle: tag1, toArray:invoiceArrayList)
        
        
        loadInvoice(title:"TXT_DISTANCE_PRICE".localized , mainPrice: orderPayment.distance_price!,currency:currency,subprice:orderPayment.price_per_unit_distance!,subText:currency,unitValue:0.0,unit:unit,sectionTitle: tag1, toArray:invoiceArrayList)

        
        loadInvoice(title:"TXT_TIME_PRICE".localized , mainPrice: orderPayment.total_time_price!,currency:currency,subprice:orderPayment.price_per_unit_time!,subText:currency,unitValue:0.0,unit:unit,sectionTitle: tag1, toArray:invoiceArrayList)

        
        
        
        
        
        loadInvoice(title:"TXT_SERVICE_COST".localized , mainPrice: orderPayment.total_service_price!,currency:currency,subprice:0.0,subText:"",unitValue:0.0,unit:"",sectionTitle: tag1,toArray: invoiceArrayList)
        if orderPayment.total_admin_tax_price! > 0.0 {
            loadInvoice(title:"TXT_SERVICE_TAX".localized , mainPrice: orderPayment.total_admin_tax_price!,currency:currency,subprice:0.0,subText:String(orderPayment.service_tax!) + " %",unitValue:0.0,unit:"",sectionTitle: tag1, toArray:invoiceArrayList)
        }
        if orderPayment.is_promo_for_delivery_service && orderPayment.promo_payment! > 0.0 {
            
            loadInvoice(title:"TXT_PROMO_BONUS".localized , mainPrice: orderPayment.promo_payment!,currency:currency,subprice:0.0,subText:"",unitValue:0.0,unit:"",sectionTitle: tag1, toArray:invoiceArrayList)
            
        }
      
        loadInvoice(title:"TXT_TOTAL_SERVICE_PRICE".localized , mainPrice: orderPayment.total_delivery_price!,currency:currency,subprice:0.0,subText:"",unitValue:0.0,unit:"",sectionTitle: tag1, toArray:invoiceArrayList)
        
       /* loadInvoice(title:"TXT_ITEM_PRICE".localized , mainPrice:orderPayment.total_cart_price,currency:currency,subprice:0.0,subText:String(orderPayment.total_item!) + "TXT_ITEM".localizedCapitalized,unitValue:0.0,unit:"",sectionTitle: tag1, toArray: invoiceArrayList)
        var strTax = ""
        if (orderPayment.taxDetails.count > 0){
            for obj in orderPayment.taxDetails{
                strTax = strTax + "\(obj.taxName![preferenceHelper.getLanguage()]) \(obj.tax!)%,"
            }
        }
        if strTax.count > 0{
            strTax.removeLast()
        }
         if isTaxIncluded {
            strTax = strTax.isEmpty ? "" : "(\(strTax)) Exc"
            loadInvoice(title:"TXT_TAX".localized , mainPrice: orderPayment.total_store_tax_price ?? 0.0,currency:currency,subprice:0.0,subText:strTax,unitValue:0.0,unit:"",sectionTitle: tag1, toArray: invoiceArrayList)
        }*/
        
        
        loadInvoice(title:"TXT_TOTAL_ITEM_PRICE".localized , mainPrice: orderPayment.total_order_price!,currency:currency,subprice:0.0,subText:"",unitValue:0.0,unit:"",sectionTitle: tag1, toArray:invoiceArrayList)
        
        //DELIVERYMANapp
        if orderPayment.tip_amount > 0{
            loadInvoice(title:"TXT_TIP_AMOUNT".localized , mainPrice: orderPayment.tip_amount,currency:currency,subprice:0.0,subText:"",unitValue:0.0,unit:"",sectionTitle: tag1, toArray:invoiceArrayList)
        }

        toArray.add(invoiceArrayList)
        let earningArrayList:NSMutableArray = NSMutableArray()
        
        loadInvoice(title:"TXT_CASH_AMOUNT".localizedUppercase , mainPrice: orderPayment.provider_have_cash_payment!,currency:currency,subprice:0.0,subText:"",unitValue:0.0,unit:"",sectionTitle: tag2, toArray:earningArrayList)
        
        loadInvoice(title:"TXT_PAID_ORDER_AMOUNT".localizedUppercase , mainPrice: orderPayment.provider_paid_order_payment!,currency:currency,subprice:0.0,subText:"",unitValue:0.0,unit:"",sectionTitle: tag2, toArray:earningArrayList)
        
        loadInvoice(title:"TXT_PROFIT".localizedUppercase, mainPrice: orderPayment.total_provider_income!,currency:currency,subprice:0.0,subText:"",unitValue:0.0,unit:"",sectionTitle: tag2, toArray:earningArrayList)
        
        if earningArrayList.count > 0 {
        toArray.add(earningArrayList)
        }
        completetion(true)
    }
    //MARK:
    //MARK:- Invoice For Earning Detail
    class func parseEarning(_ response: [String:Any], arrayListForEarning:NSMutableArray,arrayListForAnalytic:NSMutableArray ,arrayListForOrders:NSMutableArray,isWeeklyEarning:Bool = false,completetion: @escaping (_ result:Bool) -> Void) {
        
        arrayListForEarning.removeAllObjects()
        arrayListForAnalytic.removeAllObjects()
        arrayListForOrders.removeAllObjects()
        if (isSuccess(response: response, withSuccessToast: false, andErrorToast: true)) {
            
            
            
            let dailyEarningResponse:DailyEarningResponse = DailyEarningResponse.init(fromDictionary: response)
            let orderTotalItem:OrderTotal = dailyEarningResponse.orderTotal!
          
            let tag1:String = "TXT_TRIP_EARNING".localized
            let tag2:String = "TXT_PROVIDER_TRANSACTIONS".localized
            let tag3:String = "TXT_PAYMENT_DETAIL".localized
            
            var earningDataArrayList:Array<Earning> = Array();
            
            earningDataArrayList.append(Earning.init(sectionTitle: tag1, title: "TXT_SERVICE_PRICE".localized, price: (orderTotalItem.totalServicePrice).toString()))
            
            earningDataArrayList.append(Earning.init(sectionTitle: tag1, title: "TXT_TAX_PRICE".localized, price: "+" + (orderTotalItem.totalAdminTaxPrice).toString()))
            
//            earningDataArrayList.append(Earning.init(sectionTitle: tag1, title: "TXT_SURGE_PRICE".localized, price: "+" + (orderTotalItem.totalSurgePrice).toString()))
            
            earningDataArrayList.append(Earning.init(sectionTitle: tag1, title: "TXT_DELIVERY_PRICE".localized, price:(orderTotalItem.totalDeliveryPrice).toString()))
            earningDataArrayList.append(Earning.init(sectionTitle: tag1, title: "TXT_ADMIN_PROFIT".localized, price:"-" + (orderTotalItem.totalAdminProfitOnDelivery).toString()))
            earningDataArrayList.append(Earning.init(sectionTitle: tag1, title: "TXT_DELIVERYMAN_PROFIT".localized, price:(orderTotalItem.totalProviderProfit).toString()))

            
            
            arrayListForEarning.add(earningDataArrayList);
            
            var earningDataArrayList2:Array<Earning> = Array();
            
            earningDataArrayList2.append(Earning.init(sectionTitle: tag2, title: "TXT_PAID_ORDER_AMOUNT".localizedUppercase, price:(orderTotalItem.providerPaidOrderPayment).toString()))
            earningDataArrayList2.append(Earning.init(sectionTitle: tag2, title: "TXT_CASH_AMOUNT".localizedUppercase, price:  (orderTotalItem.providerHaveCashPayment).toString()))
            earningDataArrayList2.append(Earning.init(sectionTitle: tag2, title: "TXT_CASH_ON_HAND".localizedUppercase, price: (orderTotalItem.totalProviderHaveCashPaymentOnHand).toString()))
            
            earningDataArrayList2.append(Earning.init(sectionTitle: tag2, title: "TXT_DEDUCT_FROM_WALLET_ON_CASH_TRIP".localized, price: (orderTotalItem.totalWalletIncomeSetInCashOrder).toString()))
            
            
            
            earningDataArrayList2.append(Earning.init(sectionTitle: tag2, title: "TXT_ADDED_IN_WALLET_ON_CARD_TRIP".localized, price: (orderTotalItem.totalWalletIncomeSetInOtherOrder).toString()))
            
            arrayListForEarning.add(earningDataArrayList2);
            
            var earningDataArrayList3:Array<Earning> = Array();
            
            
            earningDataArrayList3.append(Earning.init(sectionTitle: tag3, title: "TXT_TOTAL_EARNING".localizedUppercase, price: (orderTotalItem.totalEarning).toString()))
            earningDataArrayList3.append(Earning.init(sectionTitle: tag3, title: "TXT_PAID_IN_WALLET".localized, price: (orderTotalItem.totalWalletIncomeSet).toString()))
            
//            if isWeeklyEarning {
                earningDataArrayList3.append(Earning.init(sectionTitle: tag3, title: "TXT_TOTAL_PAID".localizedUppercase, price: (orderTotalItem.totalPaid).toString()))
               // earningDataArrayList3.append(Earning.init(sectionTitle: tag3, title: "TXT_TOTAL_REMAINING_TO_PAY".localized, price: (orderTotalItem.totalRemainingToPaid).toString()))

//            }
            

            
            
           arrayListForEarning.add(earningDataArrayList3);
            
            
            
            let analyticDaily:ProviderAnalyticDaily = dailyEarningResponse.providerAnalyticDaily
            
            

            
            
        
            arrayListForAnalytic.add(Analytic.init(title: "TXT_TIME_ONLINE".localizedUppercase, value: Utility.secondsToHoursMinutes(seconds: analyticDaily.totalOnlineTime))!)
                
            arrayListForAnalytic.add(Analytic.init(title: "TXT_JOB_TIME".localizedUppercase, value: Utility.secondsToHoursMinutes(seconds: analyticDaily.totalActiveJobTime))!)
            
       
            arrayListForAnalytic.add(Analytic.init(title: "TXT_TOTAL_ORDER".localizedUppercase, value: String(analyticDaily.received!))!)
            arrayListForAnalytic.add(Analytic.init(title: "TXT_NOT_ANSWERED".localizedUppercase, value: String(analyticDaily.notAnswered!))!)
            
            arrayListForAnalytic.add(Analytic.init(title: "TXT_ACCEPTED_ORDER".localizedUppercase, value: String(analyticDaily.accepted))!)
            arrayListForAnalytic.add(Analytic.init(title: "TXT_ACCEPTED_RATIO".localizedUppercase, value: String(analyticDaily.acceptionRatio) + "%")!)
           
            
            arrayListForAnalytic.add(Analytic.init(title: "TXT_COMPLETED_ORDER".localizedUppercase, value: String(analyticDaily.completed))!)
            arrayListForAnalytic.add(Analytic.init(title: "TXT_COMPLETED_RATIO".localizedUppercase, value: String(analyticDaily.completedRatio) + "%")!)
            
            
            arrayListForAnalytic.add(Analytic.init(title: "TXT_REJECTED_ORDER".localizedUppercase, value: String(analyticDaily.rejected))!)
            arrayListForAnalytic.add(Analytic.init(title: "TXT_REJECTED_RATIO".localizedUppercase, value: String(analyticDaily.rejectionRatio) + "%")!)
            
            arrayListForAnalytic.add(Analytic.init(title: "TXT_CANCELLED_ORDER".localizedUppercase, value: String(analyticDaily.cancelled))!)
            arrayListForAnalytic.add(Analytic.init(title: "TXT_CANCELLED_RATIO".localizedUppercase, value: String(analyticDaily.cancellationRatio) + "%")!)
      
            
            if isWeeklyEarning {
                let date:OrderDate = dailyEarningResponse.orderDate!
                let earning:OrderDayTotal = dailyEarningResponse.orderDayTotal!
                
                
                arrayListForOrders.add(Analytic.init(title: date.date1 , value: earning.date1)!)
                arrayListForOrders.add(Analytic.init(title: date.date2 , value: earning.date2)!)
                arrayListForOrders.add(Analytic.init(title: date.date3 , value: earning.date3)!)
                arrayListForOrders.add(Analytic.init(title: date.date4 , value: earning.date4)!)
                arrayListForOrders.add(Analytic.init(title: date.date5 , value: earning.date5)!)
                arrayListForOrders.add(Analytic.init(title: date.date6 , value: earning.date6)!)
                arrayListForOrders.add(Analytic.init(title: date.date7 , value: earning.date7)!)
                
                
            }else {
            for orderPayment in dailyEarningResponse.orderPayments {
                arrayListForOrders.add(orderPayment)
            }
            }
            completetion(true)
        } else {
            completetion(false)
        }
    }

    //MARK:- pargeWeatherResponse is Success Or Not
    static func isSuccess(response:[String:Any], withSuccessToast:Bool = false, andErrorToast:Bool = true) -> Bool {
        if response.keys.count > 0 {
            let isSuccess:IsSuccessResponse = IsSuccessResponse.init(dictionary: response)!
            let msgString = isSuccess.status_phrase
            if isSuccess.success! {
                if withSuccessToast {
                    DispatchQueue.main.async {
                        //let messageCode:String = "MSG_CODE_" + String(isSuccess.message!)
                        Utility.hideLoading()
                        Utility.showToast(message:msgString.localized);
                    }
                }
                return true;
            } else {
                let errorCode:String = "ERROR_CODE_" + String(isSuccess.errorCode ?? 0)
                if (errorCode.compare("ERROR_CODE_999") == ComparisonResult.orderedSame || errorCode.compare("ERROR_CODE_424") == ComparisonResult.orderedSame || errorCode.compare("ERROR_CODE_2003") == ComparisonResult.orderedSame) {
                    DispatchQueue.main.async {
                        Utility.hideLoading()
                        Utility.showToast(message: msgString.localized);
                        preferenceHelper.setSessionToken("");
                        preferenceHelper.setUserId("")
                        
                        APPDELEGATE.goToHome();
                        return
                    }
                } else if andErrorToast {
                    DispatchQueue.main.async {
                        Utility.hideLoading()
                        Utility.showToast(message: msgString.localized);
                    }
                }
                return false;
            }
        } else {
            return false;
        }
    }

    //MARK:- parsePaymentGateways
    class func parsePaymentGateways(_ response:[String:Any], completion: @escaping (_ result: Bool) -> Void) {
        if (isSuccess(response: response, withSuccessToast: false, andErrorToast: true)) {
            let payment:PaymentConfig = PaymentConfig.shared
            payment.clearPaymentConfig();
            
            let paymentGatewayResponse:PaymentGatewayResponse = PaymentGatewayResponse.init(fromDictionary:response)
            
            
            let paymentGatewayItems:[PaymentGatewayItem] = paymentGatewayResponse.paymentGateway
            
            payment.wallet = paymentGatewayResponse.wallet
            payment.walletCurrencyCode = paymentGatewayResponse.walletCurrencyCode
            
            for paymentGateway in paymentGatewayItems {
                if paymentGateway.id == Payment.STRIPE {
                    CONSTANT.STRIPE_KEY = paymentGateway.paymentKeyId!
                }
                payment.paymentGateways.append(paymentGateway)
            }
            
            completion(true)
        }else {
            completion(false)
        }
    }
    class func parseCards(_ response:[String:Any],toArray:NSMutableArray , completion: @escaping (_ result: Bool) -> Void) {
        if (isSuccess(response: response, withSuccessToast: false, andErrorToast: false)) {
            toArray.removeAllObjects()
            let cardResponse:CardResponse = CardResponse.init(fromDictionary: response)
            let cardList:[CardItem] = cardResponse.cards
            if cardList.count > 0 {
                for card in cardList {
                    toArray.add(card)
                }
                completion(true)
            } else {
                completion(false)
            }
        }
    }

    //MARK:- parseCard
    class func parseCard(_ response: [String:Any] ,toArray:NSMutableArray , completion: @escaping (_ result: Bool) -> Void) {
        if (isSuccess(response: response, withSuccessToast: false, andErrorToast: true)) {
            let cardResponse:CardResponse = CardResponse.init(fromDictionary: response)
            let card:CardItem = cardResponse.card!
            toArray.add(card)
            completion(true)
        } else {
            completion(false)
        }
    }
}
