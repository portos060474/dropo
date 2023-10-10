//
//  AlamofireHelper.swift
//  Store
//
//  Created by Jaydeep Vyas on 07/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//


import Foundation
import FirebaseMessaging
import GooglePlaces
import GoogleMaps

class Parser: NSObject {
//MARK:- parseBasicSettingDetails
    class func parseAppSettingDetail(response:[String:Any])-> Bool {
        if isSuccess(response: response, withSuccessToast: false, andErrorToast: true) {
            let setting:AppSettingResponse = AppSettingResponse.init(fromDictionary: response)
            preferenceHelper.setIsShowOptionalFieldInRegister(setting.isShowOptionalField!);
            preferenceHelper.setIsEmailVerification(setting.isVerifyEmail!);
            preferenceHelper.setIsProfilePicRequired(setting
                .isProfilePictureRequired!);
            preferenceHelper.setIsPhoneNumberVerification(setting.isVerifyPhone!);
            preferenceHelper.setIsReferralOn(setting.isUseReferral!);
            preferenceHelper.setIsAdminDocumentMandatory(setting.isDocumentMandatory!);
            preferenceHelper.setIsRequiredForceUpdate(setting.isForceUpdate!)

            if setting.googleKey!.count > 0{
                Google.API_KEY = setting.googleKey!
            }else{
                Google.API_KEY = "AIzaSyCY-9i70rKMrvS5KntBFCLxVY88RikU-_k"
            }
            
            GMSServices.provideAPIKey(Google.MAP_KEY)
            GMSPlacesClient.provideAPIKey(Google.MAP_KEY)
            preferenceHelper.setUserPanelUrl(setting.userBaseUrl)
            preferenceHelper.setLatestAppVersion(setting.versionCode!)
            preferenceHelper.setIsLoginByEmail(setting.isLoginByEmail!)
            preferenceHelper.setIsLoginByPhone(setting.isLoginByPhone!)
            preferenceHelper.setIsSocialLoginEnable(setting.isSocialLoginEnable)
          //  preferenceHelper.setIsSocialLoginEnable(false)

            preferenceHelper.setAdminEmail(setting.adminEmail)
            preferenceHelper.setAdminContact(setting.adminContact)
            preferenceHelper.setTermsAndCondition(setting.termsAndCondition)
            preferenceHelper.setPrivacyPolicy(setting.privacyPolicy)
        
            preferenceHelper.setMinMobileLength(setting.mobileMinLenfth)
            preferenceHelper.setMaxMobileLength(setting.mobileMaxLenfth)
            
            preferenceHelper.setIsEnableTwilioCallMask(setting.is_enable_twilio_call_masking)
            
            return true;
        }else {
        return false;
        }
    }
//MARK:- parseStore login/register/profile Response is Success Or Not
    class func parseUserStorageData(response:[String:Any], completion: @escaping (_ result: Bool) -> Void) {
        
        print(Utility.conteverDictToJson(dict: response))

        if (isSuccess(response: response, withSuccessToast: false, andErrorToast: true)) {
            let storeData:StoreResponse = StoreResponse.init(fromDictionary: response)
            if let storeData = response["store"] as? [String:Any] {
                StoreSingleton.shared.store = Store(fromDictionary: storeData)
            }
            
            let store:Store = storeData.store!;
            preferenceHelper.setUserId(store.id);
            preferenceHelper.setAuthToken(store.firebaseToken)
            preferenceHelper.setSessionToken(store.serverToken)
            if store.socialIds.count > 0 {
                preferenceHelper.setSocialId(store.socialIds[0])
            }else {
                preferenceHelper.setSocialId("")
            }
            preferenceHelper.setPhoneNumber(store.phone!);
            preferenceHelper.setPhoneCountryCode(store.countryPhoneCode!);
            
            preferenceHelper.setEmail(store.email!);
            preferenceHelper.setPhoneNumberLength((store.phone?.count)!);
            
            preferenceHelper.setIsUserApprove(store.isApproved!)
            preferenceHelper.setIsUserDocumentUploaded(store.isDocumentUploaded!)
            
            preferenceHelper.setIsEmailVerified(store.isEmailVerified!)
            preferenceHelper.setIsPhoneNumberVerified(store.isPhoneNumberVerified!)

            preferenceHelper.setCountryCode(storeData.countryCode)

            StoreSingleton.shared.store.currency = storeData.currency
            StoreSingleton.shared.store.timeZone = storeData.timeZone
            
            if let substoreData = response["sub_store"] as? [String:Any] {
                StoreSingleton.shared.subStore = SubStore(fromDictionary: substoreData)
                preferenceHelper.setSubStoreId(StoreSingleton.shared.subStore.id);
//                preferenceHelper.setSubStoreSessionToken(StoreSingleton.shared.subStore.serverToken)
            //                25-12-2020
    //                preferenceHelper.setSubStoreSessionToken(StoreSingleton.shared.subStore.serverToken)
                preferenceHelper.setSessionToken(StoreSingleton.shared.subStore.serverToken)

                
                for obj in StoreSingleton.shared.subStore.urls{
                    setScreenVisibilityPermission(name: obj.name, permission: obj.permission)
                }
            }else{
//                StoreSingleton.shared.subStore = SubStore(fromDictionary: [:])
//                preferenceHelper.setSubStoreId("");
////                preferenceHelper.setSubStoreSessionToken("")
//                clearScreenVisibilityPermission()
            }
            
            //Storeapp
            
            Messaging.messaging().subscribe(toTopic: "\(preferenceHelper.getUserId())") { error in
                print("Subscribed to \(preferenceHelper.getUserId()) topic")
            }

            completion(true)
        } else {
            completion(false)
        }
    }
    
    //MARK:- parseDocumentList
    class func parseDocumentList(_ response: [String:Any] ,toArray:NSMutableArray , completion: @escaping (_ result: Bool) -> Void) {
        if (isSuccess(response: response, withSuccessToast: false, andErrorToast: false)) {
            let documentResponse:DocumentResponse = DocumentResponse.init(fromDictionary: response)
            preferenceHelper.setIsUserDocumentUploaded(documentResponse.isDocumentUploaded!)
            toArray.removeAllObjects()
            for document in documentResponse.documents! {
                toArray.add(document)
            }
            completion(true)
        }else {
            completion(false)
        }
        
        
    }
    class func parseWalletTrasactionHistory(_ response: [String:Any] ,toArray:NSMutableArray , completion: @escaping (_ result: Bool) -> Void) {
        toArray.removeAllObjects()
        if (isSuccess(response: response, withSuccessToast: false, andErrorToast: false)) {
            let walletListResponse:WalletTransactionHistoryResponse = WalletTransactionHistoryResponse.init(fromDictionary: response)
            
            let walletRequestList:[WalletRequestDetail] = walletListResponse.walletRequestDetail
            
            if walletRequestList.count > 0 {
                for walletRequestDetail in walletRequestList
                {
                    toArray.add(walletRequestDetail)
                }
                completion(true)
            }else {
                completion(false)
            }
        }
    }
    
    //Mark:- Parse Stor Types
    class func parseStoreTypes(_ response: [String:Any] ,toArray:NSMutableArray , completion: @escaping (_ result: Bool) -> Void) {
        if (isSuccess(response: response, withSuccessToast: false, andErrorToast: true)) {
            toArray.removeAllObjects()
            let storeTypeResponse:StoreTypeList = StoreTypeList.init(fromDictionary: response)
            let storeList:[Delivery] = storeTypeResponse.deliveries!
            if storeList.count > 0 {
                for store in storeList
                {
                    toArray.add(store)
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
    
    //MARK:- Orders History
    class func parseOrderHistory(_ response: [String:Any] ,toArray:NSMutableArray, completion: @escaping (_ result: Bool) -> Void) {
        if (isSuccess(response: response, withSuccessToast: false, andErrorToast: false)) {
            let historyOrderResposnse:HistoryResponse = HistoryResponse.init(fromDictionary: response)
            let historyOrderList:[OrderList] = historyOrderResposnse.orderList
            if historyOrderList.count > 0 {
                let sortedArray = historyOrderList.sorted{ $0.createdAt > $1.createdAt }
                for order in sortedArray
                {
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
    
    
    class func parseCartInvoice(_ orderPayment:OrderPayment, toArray:NSMutableArray, currency:String = StoreSingleton.shared.store.currency,invoiceResponse:InvoiceResponse, completetion: @escaping (_ result:Bool) -> Void) {
        toArray.removeAllObjects()
        StoreSingleton.shared.orderPaymentId = orderPayment.id;
        StoreSingleton.shared.totalInvoice = orderPayment.total;
        let unit = (orderPayment.isDistanceUnitMile) ? "UNIT_MILE".localized : "UNIT_KM".localized;
        
        func appendString(currency:String,price:Double = 0.0,value:Double, unit:String)->String {
            var strPrice:String = "";
            strPrice.append(currency)
            if (price > 0.0) {
                strPrice.append(price.toString());
            }
            if (!unit.isEmpty()) {
                strPrice.append("/");
                if (value > 1.0)
                {
                    strPrice.append(String(value));
                }
                strPrice.append(unit);
            }
            return strPrice;
        }
        func loadInvoice(title:String,mainPrice:Double,currency:String,subprice:Double,subText:String,unitValue:Double,unit:String) -> Void {
           if mainPrice > 0.0
           {
            let price = mainPrice.toCurrencyString()
            let subTitle = appendString(currency: subText, price: subprice, value: unitValue, unit: unit);
            
            toArray.add(Invoice.init(title: title, subTitle: subTitle
                , price: price)!)
            }
        }
        
        
         loadInvoice(title:"TXT_SERVICE_PRICE".localized , mainPrice: orderPayment.totalServicePrice,currency:currency,subprice:0.0,subText:"",unitValue:0.0,unit:"")
        
        if orderPayment.totalAdminTaxPrice > 0.0 {
                loadInvoice(title:"TXT_SERVICE_TAX".localized , mainPrice: orderPayment.totalAdminTaxPrice,currency:currency,subprice:0.0,subText:String(orderPayment.serviceTax) + " %",unitValue:0.0,unit:"")
            }else{
                loadInvoice(title:"TXT_SERVICE_TAX".localized, mainPrice: orderPayment.totalAdminTaxPrice,currency:currency,subprice:0.0,subText:String(orderPayment.serviceTax) + " %",unitValue:0.0,unit:"")
            }
            
        if orderPayment.isPromoForDeliveryService && orderPayment.promoPayment > 0.0 {
            
            loadInvoice(title:"TXT_PROMO_BONUS".localized , mainPrice: orderPayment.promoPayment,currency:currency,subprice:0.0,subText:"",unitValue:0.0,unit:"")
        }
        
       
        
        loadInvoice(title:"TXT_TOTAL_SERVICE_PRICE".localized , mainPrice: orderPayment.totalDeliveryPrice,currency:currency,subprice:0.0,subText:"",unitValue:0.0,unit:"")
        
        
        loadInvoice(title:"TXT_ITEM_PRICE".localized , mainPrice:orderPayment.totalCartPrice,currency:currency,subprice:0.0,subText:String(orderPayment.totalItem) + " ITEM".localizedCapitalized,unitValue:0.0,unit:"")
        
        var strTax = ""
//        var totalTax : Int = 0
        if (orderPayment.taxDetails.count > 0){
            for obj in orderPayment.taxDetails{
//                totalTax = totalTax + obj.tax_amount
                strTax = strTax + "\(StoreSingleton.shared.returnStringAccordingtoLanguage(arrStr: obj.taxName!)) \(obj.tax!)%,"
            }
        }
        if strTax.count > 0{
            strTax.removeLast()
        }
 
        if (invoiceResponse.isTaxInlcuded == true){
            loadInvoice(title:"TXT_TAX".localized , mainPrice: orderPayment.totalStoreTaxPrice,currency:currency,subprice:0.0,subText:"(\(strTax)) Inc",unitValue:0.0,unit:"")
        }else{
            loadInvoice(title:"TXT_TAX".localized , mainPrice: orderPayment.totalStoreTaxPrice,currency:currency,subprice:0.0,subText:"(\(strTax)) Exc",unitValue:0.0,unit:"")
        }
        
        if !orderPayment.isPromoForDeliveryService && orderPayment.promoPayment > 0.0 {
            
            loadInvoice(title:"TXT_PROMO_BONUS".localized , mainPrice: orderPayment.promoPayment,currency:currency,subprice:0.0,subText:"",unitValue:0.0,unit:"")
        }
        
        if orderPayment.tipAmount > 0.0{
            loadInvoice(title:"Tip Amount" , mainPrice: orderPayment.tipAmount,currency:currency,subprice:0.0,subText:"",unitValue:0.0,unit:"")
        }
        loadInvoice(title:"TXT_TOTAL_ITEM_PRICE".localized , mainPrice: orderPayment.totalOrderPrice!,currency:currency,subprice:0.0,subText:"",unitValue:0.0,unit:"")
        
        completetion(true)
    }
    
    
    
    //MARK:- Invoice For History Detail
    class func parseInvoice(_ orderPayment:OrderPayment, toArray:NSMutableArray, currency:String = "",isTaxIncluded:Bool, isTableBooking:Bool = false, completetion: @escaping (_ result:Bool) -> Void) {
        toArray.removeAllObjects()
        
     
        //let unit = orderPayment.isDistanceUnitMile ? "UNIT_MILE".localized : "UNIT_KM".localized
        
        let unit = "UNIT_KM".localized
        
        let tag1:String = "TXT_PAYMENT".localizedCapitalized
        let tag2:String = "TXT_OTHER_EARNING".localizedCapitalized
        
        func appendString(currency:String,price:Double = 0.0,value:Double, unit:String)->String {
            var strPrice:String = "";
            strPrice.append(currency)
            if (price > 0.0) {
                strPrice.append(String(price));
            }
            if (!unit.isEmpty()) {
                strPrice.append("/");
                if (value > 0.0)
                {
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
                , price: price,sectionTitle: sectionTitle))!)
            }
            
        }
        
        let invoiceArrayList:NSMutableArray = NSMutableArray();
        
        loadInvoice(title:"TXT_BASE_PRICE".localized , mainPrice: orderPayment.totalBasePrice,currency:currency,subprice:orderPayment.basePrice,subText:currency,unitValue:orderPayment.basePriceDistance,unit:unit,sectionTitle: tag1, toArray:invoiceArrayList)
        
        
        loadInvoice(title:"TXT_DISTANCE_PRICE".localized , mainPrice: orderPayment.distancePrice!,currency:currency,subprice:orderPayment.pricePerUnitDistance,subText:currency,unitValue:0.0,unit:unit,sectionTitle: tag1, toArray:invoiceArrayList)
        
        
        loadInvoice(title:"TXT_TIME_PRICE".localized , mainPrice: orderPayment.totalTimePrice + orderPayment.totalItemSpecificationPrice,currency:currency,subprice:orderPayment.pricePerUnitTime,subText:currency,unitValue:0.0,unit:unit,sectionTitle: tag1, toArray:invoiceArrayList)
        
        
        loadInvoice(title:"TXT_SERVICE_PRICE".localized , mainPrice: orderPayment.totalServicePrice,currency:currency,subprice:0.0,subText:"",unitValue:0.0,unit:"", sectionTitle: tag1, toArray: invoiceArrayList)
        
        
        if orderPayment.totalAdminTaxPrice > 0.0 {
            loadInvoice(title:"TXT_SERVICE_TAX".localized , mainPrice: orderPayment.totalAdminTaxPrice,currency:currency,subprice:0.0,subText:String(orderPayment.serviceTax) + " %",unitValue:0.0,unit:"", sectionTitle: tag1,toArray: invoiceArrayList)
        }

        if orderPayment.totalSurgePrice > 0.0 {
            loadInvoice(title:"TXT_SURGE_PRICE".localized , mainPrice: orderPayment.totalSurgePrice,currency:currency,subprice:0.0,subText:"x" + String(orderPayment.surgeCharges),unitValue:0.0,unit:"",sectionTitle: tag1, toArray:invoiceArrayList)
        }

        if orderPayment.isPromoForDeliveryService && orderPayment.promoPayment > 0.0 {
            loadInvoice(title:"TXT_PROMO_BONUS".localized , mainPrice: orderPayment.promoPayment,currency:currency,subprice:0.0,subText:"",unitValue:0.0,unit:"",sectionTitle: tag1, toArray:invoiceArrayList)
        }

        loadInvoice(title:"TXT_TOTAL_SERVICE_PRICE".localized, mainPrice: orderPayment.totalDeliveryPrice,currency:currency,subprice:0.0,subText:"",unitValue:0.0,unit:"",sectionTitle: tag1, toArray:invoiceArrayList)
        loadInvoice(title:"TXT_ITEM_PRICE".localized, mainPrice: orderPayment.totalCartPrice,currency:currency,subprice:0.0,subText:"",unitValue:0.0,unit:"",sectionTitle: tag1, toArray:invoiceArrayList)
        if isTableBooking {
            loadInvoice(title:"text_booking_fees".localized, mainPrice: orderPayment.booking_fees, currency:currency, subprice:0.0, subText:"", unitValue:0.0, unit:"", sectionTitle: tag1, toArray:invoiceArrayList)
        }

        var strTax = ""
//        var totalTax : Int = 0
        if (orderPayment.taxDetails.count > 0) {
            for obj in orderPayment.taxDetails {
//                totalTax = totalTax + obj.tax_amount
                strTax = strTax + "\(StoreSingleton.shared.returnStringAccordingtoLanguage(arrStr: obj.taxName!)) \(obj.tax!)%,"
            }
        }

        if strTax.count > 0 {
            strTax.removeLast()
        }

        if (isTaxIncluded == true) {
            loadInvoice(title:"TXT_TAX".localized , mainPrice: orderPayment.totalStoreTaxPrice,currency:currency,subprice:0.0,subText:"(\(strTax)) Inc",unitValue:0.0,unit:"",sectionTitle: tag1, toArray:invoiceArrayList)
        } else {
            loadInvoice(title:"TXT_TAX".localized , mainPrice: orderPayment.totalStoreTaxPrice,currency:currency,subprice:0.0,subText:"(\(strTax)) Exc",unitValue:0.0,unit:"",sectionTitle: tag1, toArray:invoiceArrayList)
        }

//        loadInvoice(title:"TXT_TAX".localized , mainPrice: orderPayment.totalStoreTaxPrice,currency:currency,subprice:0.0,subText:"",unitValue:0.0,unit:"",sectionTitle: tag1, toArray:invoiceArrayList)
        loadInvoice(title:"TXT_TOTAL_ITEM_PRICE".localized , mainPrice: orderPayment.totalOrderPrice,currency:currency,subprice:0.0,subText:"",unitValue:0.0,unit:"",sectionTitle: tag1, toArray:invoiceArrayList)
        
        if !orderPayment.isPromoForDeliveryService && orderPayment.promoPayment > 0.0 {
            loadInvoice(title:"TXT_PROMO_BONUS".localized , mainPrice: orderPayment.promoPayment,currency:currency,subprice:0.0,subText:"",unitValue:0.0,unit:"",sectionTitle: tag1, toArray:invoiceArrayList)
        }
        
        toArray.add(invoiceArrayList)
        let earningArrayList:NSMutableArray = NSMutableArray()
        
        
        loadInvoice(title:"TXT_PAID_SERVICE_FEE".localizedUppercase , mainPrice: orderPayment.storeHaveServicePayment,currency:currency,subprice:0.0,subText:"",unitValue:0.0,unit:"",sectionTitle: tag2, toArray:earningArrayList)
        
        loadInvoice(title:"TXT_RECEIVED_ORDER_AMOUNT".localizedUppercase , mainPrice: orderPayment.storeHaveOrderPayment,currency:currency,subprice:0.0,subText:"",unitValue:0.0,unit:"",sectionTitle: tag2, toArray:earningArrayList)
        
        loadInvoice(title:"TXT_PROFIT".localizedUppercase, mainPrice: orderPayment.totalStoreIncome,currency:currency,subprice:0.0,subText:"",unitValue:0.0,unit:"",sectionTitle: tag2, toArray:earningArrayList)
        
        if orderPayment.tipAmount > 0.0{
            loadInvoice(title:"Tip Amount" , mainPrice: orderPayment.tipAmount,currency:currency,subprice:0.0,subText:"",unitValue:0.0,unit:"", toArray: earningArrayList)
        }
        
        toArray.add(earningArrayList)
        
        completetion(true)
    }

    class func parseInvoiceNew(_ orderPayment:OrderPaymentDetailNew, toArray:NSMutableArray, currency:String = "", completetion: @escaping (_ result:Bool) -> Void) {
        toArray.removeAllObjects()
        
     
        //let unit = orderPayment.isDistanceUnitMile ? "UNIT_MILE".localized : "UNIT_KM".localized
        
        let unit = "UNIT_KM".localized
        
        let tag1:String = "TXT_PAYMENT".localizedCapitalized
        let tag2:String = "TXT_OTHER_EARNING".localizedCapitalized
        
        func appendString(currency:String,price:Double = 0.0,value:Double, unit:String)->String {
            var strPrice:String = "";
            strPrice.append(currency)
            if (price > 0.0) {
                strPrice.append(String(price));
            }
            if (!unit.isEmpty()) {
                strPrice.append("/");
                if (value > 0.0)
                {
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
                , price: price,sectionTitle: sectionTitle))!)
            }
            
        }
       /*
        let invoiceArrayList:NSMutableArray = NSMutableArray();
        
        loadInvoice(title:"TXT_BASE_PRICE".localized , mainPrice: Double(orderPayment.totalOrderPrice),currency:currency,subprice:Double(orderPayment.totalCartPrice),subText:currency,unitValue:Double(orderPayment.totalDistance),unit:unit,sectionTitle: tag1, toArray:invoiceArrayList)
        
        
        loadInvoice(title:"TXT_DISTANCE_PRICE".localized , mainPrice: Double(orderPayment.totalDeliveryPrice),currency:currency,subprice:Double(orderPayment.totalDistance),subText:currency,unitValue:0.0,unit:unit,sectionTitle: tag1, toArray:invoiceArrayList)
        
        
        loadInvoice(title:"TXT_TIME_PRICE".localized , mainPrice: orderPayment.totalTimePrice + orderPayment.totalItemSpecificationPrice,currency:currency,subprice:orderPayment.pricePerUnitTime,subText:currency,unitValue:0.0,unit:unit,sectionTitle: tag1, toArray:invoiceArrayList)
        
        
        
        
        loadInvoice(title:"TXT_TOTAL_SERVICE_PRICE".localized , mainPrice: orderPayment.totalDeliveryPrice,currency:currency,subprice:0.0,subText:"",unitValue:0.0,unit:"",sectionTitle: tag1, toArray:invoiceArrayList)
        
        if orderPayment.totalAdminTaxPrice > 0.0 {
            loadInvoice(title:"TXT_SERVICE_TAX".localized , mainPrice: orderPayment.totalAdminTaxPrice,currency:currency,subprice:0.0,subText:String(orderPayment.serviceTax) + " %",unitValue:0.0,unit:"", sectionTitle: tag1,toArray: invoiceArrayList)
        }
        
        
        if orderPayment.totalSurgePrice > 0.0 {
            loadInvoice(title:"TXT_SURGE_PRICE".localized , mainPrice: orderPayment.totalSurgePrice,currency:currency,subprice:0.0,subText:"x" + String(orderPayment.surgeCharges),unitValue:0.0,unit:"",sectionTitle: tag1, toArray:invoiceArrayList)
        }
        
        if orderPayment.isPromoForDeliveryService && orderPayment.promoPayment > 0.0 {
            
            loadInvoice(title:"TXT_PROMO_BONUS".localized , mainPrice: orderPayment.promoPayment,currency:currency,subprice:0.0,subText:"",unitValue:0.0,unit:"",sectionTitle: tag1, toArray:invoiceArrayList)
            
        }
        
        
        loadInvoice(title:"TXT_ITEM_PRICE".localized , mainPrice: orderPayment.totalCartPrice,currency:currency,subprice:0.0,subText:"",unitValue:0.0,unit:"",sectionTitle: tag1, toArray:invoiceArrayList)
        loadInvoice(title:"TXT_TAX".localized , mainPrice: orderPayment.totalStoreTaxPrice,currency:currency,subprice:0.0,subText:"",unitValue:0.0,unit:"",sectionTitle: tag1, toArray:invoiceArrayList)
        loadInvoice(title:"TXT_TOTAL_ITEM_PRICE".localized , mainPrice: orderPayment.totalOrderPrice,currency:currency,subprice:0.0,subText:"",unitValue:0.0,unit:"",sectionTitle: tag1, toArray:invoiceArrayList)
        
       
        
        
        if !orderPayment.isPromoForDeliveryService && orderPayment.promoPayment > 0.0 {
            
            loadInvoice(title:"TXT_PROMO_BONUS".localized , mainPrice: orderPayment.promoPayment,currency:currency,subprice:0.0,subText:"",unitValue:0.0,unit:"",sectionTitle: tag1, toArray:invoiceArrayList)
            
        }
        
        toArray.add(invoiceArrayList)
        let earningArrayList:NSMutableArray = NSMutableArray()
        
        
        loadInvoice(title:"TXT_PAID_SERVICE_FEE".localizedUppercase , mainPrice: orderPayment.storeHaveServicePayment,currency:currency,subprice:0.0,subText:"",unitValue:0.0,unit:"",sectionTitle: tag2, toArray:earningArrayList)
        
        loadInvoice(title:"TXT_RECEIVED_ORDER_AMOUNT".localizedUppercase , mainPrice: orderPayment.storeHaveOrderPayment,currency:currency,subprice:0.0,subText:"",unitValue:0.0,unit:"",sectionTitle: tag2, toArray:earningArrayList)
        
        loadInvoice(title:"TXT_PROFIT".localizedUppercase, mainPrice: orderPayment.totalStoreIncome,currency:currency,subprice:0.0,subText:"",unitValue:0.0,unit:"",sectionTitle: tag2, toArray:earningArrayList)*/
        
        
//        toArray.add(earningArrayList)
        
        completetion(true)
    }
    
//MARK:- parseCountries
    class func parseCities(_ response: [String:Any] ,toArray:NSMutableArray , completion: @escaping (_ result: Bool) -> Void) {
        if (isSuccess(response: response, withSuccessToast: false, andErrorToast: true)) {
            toArray.removeAllObjects()
            
            let cityResponse:CityListResponse = CityListResponse.init(fromDictionary: response)
            let cityList:[City] = cityResponse.cities!
            if cityList.count > 0 {
                for city in cityList
                {
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
//MARK:- parseCountries
    class func parseCountries(_ response: [String:Any] ,toArray:NSMutableArray , completion: @escaping (_ result: Bool) -> Void) {
        if (isSuccess(response: response, withSuccessToast: false, andErrorToast: true)) {
            toArray.removeAllObjects()
            let coutries:CountryListResponse = CountryListResponse.init(fromDictionary: response)
            let coutryList:[Country] = coutries.countries!
            if coutryList.count > 0 {
                for country in coutryList
                {
                    toArray.add(country)
                }
                completion(true)
            }else {
                completion(false)
            }
        }
        
        
    }
    //MARK:- Earning Detail
    class func parseEarning(_ response:[String:Any], arrayListForEarning:NSMutableArray,arrayListForAnalytic:NSMutableArray ,arrayListForOrders:NSMutableArray,isWeeklyEarning:Bool = false,completetion: @escaping (_ result:Bool) -> Void) {
        
        arrayListForEarning.removeAllObjects()
        arrayListForAnalytic.removeAllObjects()
        arrayListForOrders.removeAllObjects()
        if (isSuccess(response: response, withSuccessToast: false, andErrorToast: true)) {
            let dailyEarningResponse:DailyEarningResponse = DailyEarningResponse.init(fromDictionary: response)
            
            let orderTotalItem:OrderTotal = dailyEarningResponse.orderTotal!
            let tag1:String = "TXT_ORDER_EARNING".localized
            let tag2:String = "TXT_STORE_TRANSACTIONS".localized
            let tag3:String = "TXT_PAYMENT".localized
            
            var earningDataArrayList1:Array<Earning> = Array();
            earningDataArrayList1.append(Earning.init(sectionTitle: tag1, title: "TXT_ITEM_PRICE".localized, price:  "+" + (orderTotalItem.totalItemPrice).toString()))
            earningDataArrayList1.append(Earning.init(sectionTitle: tag1, title: "TXT_TAX_PRICE".localized, price: "+" + (orderTotalItem.totalStoreTaxPrice).toString()))
            
            earningDataArrayList1.append(Earning.init(sectionTitle: tag1, title: "TXT_ORDER_PRICE".localized, price: (orderTotalItem.totalOrderPrice).toString()))
           earningDataArrayList1.append(Earning.init(sectionTitle: tag1, title: "TXT_ADMIN_PROFIT".localized, price:"-" + (orderTotalItem.totalAdminProfitOnStore).toString()))
           earningDataArrayList1.append(Earning.init(sectionTitle: tag1, title: "TXT_STORE_PROFIT".localized, price:(orderTotalItem.totalStoreIncome).toString()))
           arrayListForEarning.add(earningDataArrayList1);
  
            
            
            var earningDataArrayList2:Array<Earning> = Array();
            
            earningDataArrayList2.append(Earning.init(sectionTitle: tag2, title: "TXT_RECEIVED_ORDER_AMOUNT".localizedUppercase, price:  (orderTotalItem.storeHaveOrderPayment).toString()))
            earningDataArrayList2.append(Earning.init(sectionTitle:tag2, title: "TXT_PAID_SERVICE_FEE".localizedUppercase, price:  (orderTotalItem.storeHaveServicePayment).toString()))
            earningDataArrayList2.append(Earning.init(sectionTitle: tag2, title: "TXT_DEDUCT_FROM_WALLET".localized, price: (orderTotalItem.totalWalletIncomeSetInCashOrder).toString()))
            earningDataArrayList2.append(Earning.init(sectionTitle: tag2, title: "TXT_ADDED_IN_WALLET".localized, price: (orderTotalItem.totalWalletIncomeSetInOtherOrder).toString()))
            
            arrayListForEarning.add(earningDataArrayList2);
            
            var earningDataArrayList3:Array<Earning> = Array();
            
            earningDataArrayList3.append(Earning.init(sectionTitle: tag3, title: "TXT_TOTAL_EARNING".localizedUppercase, price:  (orderTotalItem.totalEarning).toString()))
            earningDataArrayList3.append(Earning.init(sectionTitle:tag3, title: "TXT_PAID_IN_WALLET".localizedUppercase, price:  (orderTotalItem.totalWalletIncomeSet).toString()))
         
            
            
            
            if isWeeklyEarning {
                
            
                earningDataArrayList3.append(Earning.init(sectionTitle: tag3, title: "TXT_PAID".localized, price: (orderTotalItem.totalPaid).toString()))
                //earningDataArrayList3.append(Earning.init(sectionTitle: tag3, title: "TXT_REMAINING_TO_PAY".localized, price: (orderTotalItem.totalRemainingToPaid).toString()))
                
            
            }
           
            arrayListForEarning.add(earningDataArrayList3);
           
            var analyticDaily:StoreAnalyticDaily = dailyEarningResponse.storeAnalyticDaily
            if isWeeklyEarning {
                analyticDaily = dailyEarningResponse.storeAnalyticDaily
            }else {
                analyticDaily = dailyEarningResponse.storeAnalyticDaily
            }
            
            
            arrayListForAnalytic.add(Analytic.init(title: "TXT_TOTAL_ORDER".localizedUppercase, value: String(analyticDaily.totalOrders)))
            
            arrayListForAnalytic.add(Analytic.init(title: "TXT_TOTAL_ITEM_SOLD".localizedUppercase, value: String(analyticDaily.totalItems) ))
            arrayListForAnalytic.add(Analytic.init(title: "TXT_ACCEPTED_ORDER".localizedUppercase, value: String(analyticDaily.accepted
            )))
            arrayListForAnalytic.add(Analytic.init(title: "TXT_ACCEPTED_RATIO".localizedUppercase, value: String(Double(analyticDaily.acceptionRatio).toString(decimalPlaced: 2)) + "%"))
            
            arrayListForAnalytic.add(Analytic.init(title: "TXT_REJECTED_ORDER".localizedUppercase, value: String(analyticDaily.rejected
            )))
            arrayListForAnalytic.add(Analytic.init(title: "TXT_REJECTED_RATIO".localizedUppercase, value: String(analyticDaily.rejectionRatio) + "%"))
            arrayListForAnalytic.add(Analytic.init(title: "TXT_COMPLETED_ORDER".localizedUppercase, value: String(analyticDaily.completed)))
            
            arrayListForAnalytic.add(Analytic.init(title: "TXT_COMPLETED_RATIO".localizedUppercase, value: String(Double(analyticDaily.completedRatio).toString(decimalPlaced: 2)) + "%"))
            
            
            arrayListForAnalytic.add(Analytic.init(title: "TXT_CANCELLED_ORDER".localizedUppercase, value: String(analyticDaily.cancelled)))
            
            arrayListForAnalytic.add(Analytic.init(title: "TXT_CANCELLED_RATIO".localizedUppercase, value: String(Double(analyticDaily.cancellationRatio).toString(decimalPlaced: 2)) + "%"))
            
            
            
            
            
            
            if isWeeklyEarning {
                let date:OrderDate = dailyEarningResponse.orderDate!
                let earning:OrderDayTotal = dailyEarningResponse.orderDayTotal!
                
                func addDate(date:String,earning:Double)
                {
                    let orderDate = Utility.stringToDate(strDate: date, withFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB)
                    arrayListForOrders.add(Analytic.init(title: date, value: earning.toString()))
                    /*if orderDate <= Date()
                    {
                        arrayListForOrders.add(Analytic.init(title: date, value: earning.toString()))
                    }*/
                    
                    
                }
                
                
                addDate(date: date.date1, earning: earning.date1)
                addDate(date: date.date2, earning: earning.date2)
                addDate(date: date.date3, earning: earning.date3)
                addDate(date: date.date4, earning: earning.date4)
                addDate(date: date.date5, earning: earning.date5)
                addDate(date: date.date6, earning: earning.date6)
                addDate(date: date.date7, earning: earning.date7)
                
                
            }else {
                for orderPayment in dailyEarningResponse.orderPayments
                {
                    arrayListForOrders.add(orderPayment)
                }
            }
         
            completetion(true)
        }else {
            completetion(false)
            
        }
        
        
    }
    
    class func parseWalletHistory(_ response: [String:Any] ,toArray:NSMutableArray , completion: @escaping (_ result: Bool) -> Void) {
        toArray.removeAllObjects()
        if (isSuccess(response: response, withSuccessToast: false, andErrorToast: false)) {
            let walletListResponse:WalletHistoryResponse = WalletHistoryResponse.init(fromDictionary: response)
            
            let walletHistoryList:[WalletHistoryItem] = walletListResponse.walletHistoryList
            
            if walletHistoryList.count > 0 {
                for walletHistoryItem in walletHistoryList
                {
                    toArray.add(walletHistoryItem)
                }
                completion(true)
            }else {
                completion(false)
            }
        }
    }

    //MARK:- parseWeatherResponse is Success Or Not
    static func isSuccess(response:[String:Any], withSuccessToast:Bool = false, andErrorToast:Bool = true) -> Bool {
        if response.keys.count > 0 {
            let isSuccess:IsSuccessResponse = IsSuccessResponse.init(dictionary: response)!
            let msgString:String = isSuccess.status_phrase
            if isSuccess.success! {
                if withSuccessToast {
                    DispatchQueue.main.async {
                        Utility.hideLoading()
                        //let messageCode:String = "MSG_CODE_" + String(isSuccess.message!)
                        Utility.showToast(message:msgString.localized);
                    }
                }
                return true;
            } else {
                let errorCode:String = "ERROR_CODE_" + String(isSuccess.errorCode ?? 0)
                if (errorCode.compare("ERROR_CODE_999") == ComparisonResult.orderedSame || errorCode.compare("ERROR_CODE_634") == ComparisonResult.orderedSame) {
                    DispatchQueue.main.async {
                        Utility.hideLoading()
                        Utility.showToast(message:msgString.localized);
                        preferenceHelper.setSessionToken("");
                        APPDELEGATE.goToHome();
                        return
                    }
                } else if andErrorToast {
                    DispatchQueue.main.async {
                        Utility.hideLoading()
                        Utility.showToast(message:msgString.localized);
                    }
                }
                return false;
            }
        } else {
            return false;
        }
    }

    //MARK:- parsePaymentGateways
    class func parsePaymentGateways(_ response: [String:Any], completion: @escaping (_ result: Bool) -> Void) {
        if (isSuccess(response: response, withSuccessToast: false, andErrorToast: true)) {
            let payment:PaymentConfig = PaymentConfig.shared
            payment.clearPaymentConfig();
    
            let paymentGatewayResponse:PaymentGatewayResponse = PaymentGatewayResponse.init(fromDictionary:response)
            
            
            let paymentGatewayItems:[PaymentGatewayItem] = paymentGatewayResponse.paymentGateway

            payment.wallet = paymentGatewayResponse.wallet
            payment.walletCurrencyCode = paymentGatewayResponse.walletCurrencyCode
            
            for paymentGateway in paymentGatewayItems {
                if paymentGateway.id == Payment.STRIPE
                {
                    CONSTANT.STRIPE_KEY = paymentGateway.paymentKeyId!
                }
                payment.paymentGateways.append(paymentGateway)
            }
            completion(true)
        } else {
            completion(false)
        }
    }

    class func parseCards(_ response: [String:Any] ,toArray:NSMutableArray , completion: @escaping (_ result: Bool) -> Void) {
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
