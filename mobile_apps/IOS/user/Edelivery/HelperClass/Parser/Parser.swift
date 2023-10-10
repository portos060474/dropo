//
//  AlamofireHelper.swift
//  Store
//
//  Created by Disha Ladani on 07/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import FirebaseMessaging
import GoogleMaps
import UserNotifications
import GooglePlaces
import IQKeyboardManagerSwift
import GoogleSignIn

class Parser: NSObject {
    //MARK: - parseBasicSettingDetails
    class func parseAppSettingDetail(response:NSDictionary)-> Bool {
        if isSuccess(response: response, withSuccessToast: false, andErrorToast: true) {
            let setting:SettingDetailResponse = SettingDetailResponse.init(dictionary: response)!
            preferenceHelper.setIsShowOptionalFieldInRegister(setting.isShowOptionalField!)
            preferenceHelper.setIsEmailVerification(setting.isVerifyEmail!)
            preferenceHelper.setIsProfilePicRequired(setting.isProfilePictureRequired!)
            preferenceHelper.setIsPhoneNumberVerification(setting.isVerifyPhone!)
            preferenceHelper.setIsReferralOn(setting.isUseReferral!)
            preferenceHelper.setIsAdminDocumentMandatory(setting.isUploadDocuments!)
            preferenceHelper.setIsRequiredForceUpdate(setting.isForceUpdate!)
            if !setting.googleKey!.isEmpty {
                Google.API_KEY = setting.googleKey!
            }
            GMSServices.provideAPIKey(Google.MAP_KEY)
            GMSPlacesClient.provideAPIKey(Google.API_KEY)
            preferenceHelper.setLatestAppVersion(setting.versionCode!)
            preferenceHelper.setIsLoginByEmail(setting.isLoginByEmail!)
            preferenceHelper.setIsLoginByPhone(setting.isLoginByPhone!)
            preferenceHelper.setIsSocialLoginEnable(setting.isSocialLoginEnable)
            preferenceHelper.setAdminEmail(setting.adminEmail)
            preferenceHelper.setAdminContact(setting.adminContact)
            preferenceHelper.setTermsAndCondition(setting.termsAndCondition)
            preferenceHelper.setPrivacyPolicy(setting.privacyPolicy)
            preferenceHelper.setUserPanelUrl(setting.userBaseUrl)
            preferenceHelper.setIsAllowBringChange(setting.isAllowBringChange)
            preferenceHelper.setMinMobileLength(setting.mobileMinLenfth)
            preferenceHelper.setMaxMobileLength(setting.mobileMaxLenfth)
            preferenceHelper.setIsTwillowMaskEnable(setting.is_enable_twilio_call_masking)
            preferenceHelper.setMaxCourierStop(setting.max_courier_stop_limit)
            arrLanguages.append(contentsOf: setting.langItems!)
            print(arrLanguages)
            return true
        } else {
            return false
        }
    }

    //MARK: - parseLogin/Register/Profile Response
    class func parseUserStorageData(response:NSDictionary,isQRUser: Bool = false, completion: @escaping (_ result: Bool) -> Void) {
        if (isSuccess(response: response, withSuccessToast: false, andErrorToast: true)) {
            let userData:UserDataResponse = UserDataResponse.init(dictionary: response)!
            let user:User = userData.user!
            preferenceHelper.setUserId(user._id!)
            if isQRUser {
                preferenceHelper.setIsQRUser(true)
            } else {
                preferenceHelper.setAuthToken(userData.firebaseToken!)
            }
            preferenceHelper.setSessionToken(user.server_token!)
            preferenceHelper.setFirstName(user.first_name!)
            preferenceHelper.setLastName(user.last_name!)
            preferenceHelper.setAddress(user.address!)
            preferenceHelper.setPhoneNumber(user.phone!)
            preferenceHelper.setPhoneCountryCode(user.country_phone_code!)
            preferenceHelper.setCountryCode(user.country_code!)
            if user.country_code != nil {
                preferenceHelper.setCountryId(user.country_id!)
            }
            preferenceHelper.setEmail(user.email!)
            preferenceHelper.setProfilePicUrl(user.image_url!)
            preferenceHelper.setPhoneNumberLength((user.phone?.count)!)
            preferenceHelper.setIsUserApprove(user.is_approved!)
            preferenceHelper.setIsUserDocumentUploaded(user.is_document_uploaded!)
            preferenceHelper.setIsEmailVerified(user.is_email_verified!)
            preferenceHelper.setIsPhoneNumberVerified(user.is_phone_number_verified!)
            preferenceHelper.setReferralCode(user.referral_code!)
            preferenceHelper.setWalletCurrencyCode(user.wallet_currency_code ?? "")
            preferenceHelper.setWalletAmount(String(user.wallet ?? 0.0))
            PaymentConfig.shared.wallet = user.wallet ?? 0.0
            

            if user.socialIds.count > 0 {
                preferenceHelper.setSocialId(user.socialIds[0])
            } else {
                preferenceHelper.setSocialId("")
            }

            currentBooking.favouriteStores.removeAll()
            for storeId in user.favourite_store {
                currentBooking.favouriteStores.append(storeId)
            }

            //User app
            Messaging.messaging().subscribe(toTopic:"\(preferenceHelper.getUserId())") { error in
                 print("Subscribed to \(preferenceHelper.getUserId()) topic")
            }
            currentBooking.currentRunningOrder = user.orders?.count ?? 0
            completion(true)
        } else {
            completion(false)
        }
    }

    //MARK: - parseInvoice
    class func parseInvoice(_ orderPayment:OrderPayment, toArray:NSMutableArray, currency:String = currentBooking.cartCurrency,isTaxIncluded:Bool, isShowPromo:Bool = true, completetion: @escaping (_ result:Bool) -> Void) {
        toArray.removeAllObjects()
        currentBooking.orderPaymentId = orderPayment._id
        PaymentConfig.shared.total = orderPayment.userPayPayment ?? 0.0
        let unit = (orderPayment.is_distance_unit_mile) ? "UNIT_MILE".localized : "UNIT_KM".localized

        func appendString(currency:String,price:Double = 0.0,value:Double, unit:String)->String {
            var strPrice:String = ""
            strPrice.append(currency)
            if (price > 0.0) {
                strPrice.append(price.toString())
            }
            if (!unit.isEmpty()) {
                strPrice.append("/")
                if (value > 1.0) {
                    strPrice.append(String(value))
                }
                strPrice.append(unit)
            }
            return strPrice
        }

        func loadInvoice(title:String,mainPrice:Double,currency:String,subprice:Double,subText:String,unitValue:Double,unit:String) -> Void {
            let price = currency + " " + mainPrice.toString()
            let subTitle = appendString(currency: subText, price: subprice, value: unitValue, unit: unit)
            if mainPrice <= 0.0 {} else {
                toArray.add(Invoice.init(title: title, subTitle: subTitle, price: price)!)
            }
        }
        loadInvoice(title:"TXT_BASE_PRICE".localized , mainPrice: orderPayment.total_base_price,currency:currency,subprice:orderPayment.base_price!,subText:currency,unitValue:orderPayment.base_price_distance!,unit:unit)
        
        loadInvoice(title:"TXT_DISTANCE_PRICE".localized , mainPrice: orderPayment.distance_price!,currency:currency,subprice:orderPayment.price_per_unit_distance!,subText:currency,unitValue:0.0,unit:unit)
        
        loadInvoice(title:"TXT_TIME_PRICE".localized , mainPrice: orderPayment.total_time_price!,currency:currency,subprice:orderPayment.price_per_unit_time!,subText:currency,unitValue:0.0,unit:"UNIT_MIN".localizedLowercase)
        
        loadInvoice(title:"TXT_SERVICE_COST".localized , mainPrice: orderPayment.total_service_price!,currency:currency,subprice:0.0,subText:"",unitValue:0.0,unit:"")

        loadInvoice(title:"txt_additional_stop_price".localized , mainPrice: orderPayment.additional_stop_price,currency:currency,subprice:0.0,subText:"",unitValue:0.0,unit:"")
        
        loadInvoice(title:"txt_round_trip".localized , mainPrice: orderPayment.total_round_trip_charge,currency:currency,subprice:0.0,subText:"\(orderPayment.round_trip_charge) %",unitValue:0.0,unit:"")
        
        if currentBooking.deliveryType == DeliveryType.courier {
            loadInvoice(title:"txt_additional_service_price".localized , mainPrice: orderPayment.total_order_price!,currency:currency,subprice:0.0,subText:"",unitValue:0.0,unit:"")
        }
        
        loadInvoice(title:"txt_total_waiting_time".localized , mainPrice: Double(orderPayment.total_waiting_time_price),currency:currency,subprice:0.0,subText:"\(orderPayment.total_waiting_time_price)",unitValue:0.0,unit:"")
        
        if orderPayment.total_admin_tax_price! > 0.0 {
            loadInvoice(title:"TXT_SERVICE_TAX".localized , mainPrice: orderPayment.total_admin_tax_price!,currency:currency,subprice:0.0,subText:orderPayment.service_tax!.toString() + "%",unitValue:0.0,unit:"")
        }
        
        loadInvoice(title:"txt_surge_price".localized , mainPrice: Double(orderPayment.total_surge_price ?? 0),currency:currency,subprice:0.0,subText:"X\(orderPayment.surge_multiplier ?? 1)",unitValue:0.0,unit:"")
        
        if currentBooking.deliveryType != DeliveryType.courier {
            loadInvoice(title:"TXT_TOTAL_SERVICE_PRICE".localized , mainPrice: orderPayment.total_delivery_price!,currency:currency,subprice:0.0,subText:"",unitValue:0.0,unit:"")
            
            loadInvoice(title:"TXT_ITEM_PRICE".localized , mainPrice:orderPayment.total_cart_price,currency:currency,subprice:0.0,subText:String(orderPayment.total_item!) + " " + "TXT_ITEM".localizedCapitalized,unitValue:0.0,unit:"")
        }

        loadInvoice(title:"txt_booking_fees".localized , mainPrice: orderPayment.booking_fees, currency:currency, subprice:0.0, subText:"", unitValue:0.0, unit:"")

        var strTax = ""

        if (orderPayment.taxDetails.count > 0){
            for obj in orderPayment.taxDetails{
                strTax = strTax + "\(obj.taxName![preferenceHelper.getSelectedLanguage()]) \(obj.tax!)%,"
            }
        }

        if strTax.count > 0 {
            strTax.removeLast()
        }

        if isTaxIncluded == true {
            loadInvoice(title:"TXT_TAX".localized , mainPrice: orderPayment.total_store_tax_price!,currency:currency,subprice:0.0,subText:"(\(strTax)) Inc",unitValue:0.0,unit:"")
        } else {
            loadInvoice(title:"TXT_TAX".localized , mainPrice: orderPayment.total_store_tax_price!,currency:currency,subprice:0.0,subText:"(\(strTax)) Exc",unitValue:0.0,unit:"")
        }

        if currentBooking.deliveryType != DeliveryType.courier {
            loadInvoice(title:"TXT_TOTAL_ITEM_PRICE".localized , mainPrice: orderPayment.total_order_price!,currency:currency,subprice:0.0,subText:"",unitValue:0.0,unit:"")
        }
        
        if orderPayment.tip_amount > 0 {
            loadInvoice(title:"TXT_TIP_AMOUNT".localized,mainPrice: Double(orderPayment.tip_amount) ,currency:currency,subprice:0.0,subText:"",unitValue:0.0,unit:"")
        }
        
        if orderPayment.promo_payment! > 0.0 && isShowPromo {
            loadInvoice(title:"TXT_PROMO_BONUS".localized , mainPrice: orderPayment.promo_payment!,currency:currency,subprice:0.0,subText:"",unitValue:0.0,unit:"")
        }

        completetion(true)
    }

    //MARK:- parseCountries
    class func parseCountries(_ response: NSDictionary ,toArray:NSMutableArray , completion: @escaping (_ result: Bool) -> Void) {
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
    
    //Parse Fav
    class func parseFavouriteStores(_ response: NSDictionary , completion: @escaping (_ result: Bool) -> Void) {
        if (isSuccess(response: response, withSuccessToast: false, andErrorToast: true)) {
            currentBooking.favouriteStores.removeAll()
            let favStoreList:[String] =  (response.value(forKey: "favourite_stores") as? [String]) ?? []
            
            if !favStoreList.isEmpty {
                for storeId in favStoreList {
                    currentBooking.favouriteStores.append(storeId)
                }
            }
            completion(true)
        }else {
            completion(false)
            
        }
    }
    
    
    class func parseFavouriteStoreList(_ response: NSDictionary) -> [StoreItem] {
        var arrForStores:[StoreItem] = []
        
        if (isSuccess(response: response, withSuccessToast: false, andErrorToast: true)) {
            currentBooking.currentServerTime = (response ["server_time"] as? String) ?? ""
            if let storeDetailArray = response["favourite_stores"] as? [[String:Any]] {
                for dic in storeDetailArray {
                    let value = StoreItem(dictionary: dic as NSDictionary)
                    let currentMilliseconds = Utility.convertServerDateToMilliSecond(serverDate:currentBooking.currentServerTime,strTimeZone:(value?.timezone) ?? "")
                    
                    let storeOpen =
                        Utility.isStoreOpen(storeTime: (value?.store_time)! , milliSeconds: currentMilliseconds)
                    
                    value?.isStoreClosed = !storeOpen.0
                    value?.reopenAt = storeOpen.1
                    value?.strFamousProductsTags =  Utility.bindPriceTag(arrForFamousTags: value!.famousProductsTags, currency:  (value?.currency)!, numberOfTags: (value?.price_rating) ?? 0)
                    value?.strFamousProductsTagsWithComma = Utility.bindTagWithComma(arrForFamousTags: value!.famousProductsTags, numberOfTags: (value?.price_rating) ?? 0)
                    arrForStores.append(value!)
                }
            }
            
            return arrForStores
            
        }else {
            return arrForStores
        }
    }
    
    //Parser Orderlist
    class func parseOrders(_ response: NSDictionary ,toArray:NSMutableArray , completion: @escaping (_ result: Bool) -> Void) {
        toArray.removeAllObjects()
        if (isSuccess(response: response, withSuccessToast: false, andErrorToast: false)) {
            let orders:OrdersResponse = OrdersResponse.init(dictionary: response)!
            var orderList:[Order] = orders.orderList!
            orderList = orderList.sorted(by: { $0.unique_id! > $1.unique_id! })
            
            if orderList.count > 0 {
                for order in orderList {
                    toArray.add(order)
                }
                completion(true)
            }else {
                completion(false)
            }
        }else {
            completion(false)
        }
    }
    
    class func parseCurrentOrder(_ response: NSDictionary , completion: @escaping (_ result: Bool,_ order:Order) -> Void) {
        var order:Order? = nil
        if (isSuccess(response: response, withSuccessToast: false, andErrorToast: true)) {
            let orderDictionary:NSDictionary = response["order"] as! NSDictionary
            order = Order.init(dictionary: orderDictionary)
            completion(true,order!)
            
        }else {
            completion(false,order ?? Order.init())
        }
    }
    
    //MARK:- parseDeliveryResponse
    class func parseDeliveryStore(_ response: NSDictionary) -> Bool {
        
        if (isSuccess(response: response, withSuccessToast: false, andErrorToast: true)) {
            
            let deliveryStoreResponse:DeliveryStoreResponse = DeliveryStoreResponse.init(dictionary: response)!
            let deliveryCity:City = deliveryStoreResponse.city!
            currentBooking.isAllowContactLessDelivery = deliveryStoreResponse.isAllowContactlessDelivery
            currentBooking.currentCity = currentBooking.currentSendPlaceData.city1
            currentBooking.bookCityId = deliveryCity._id
            currentBooking.bookCountryId = deliveryCity.country_id
            currentBooking.isCashPaymentMode = deliveryCity.is_cash_payment_mode!
            currentBooking.isOtherPaymentMode = deliveryCity.is_other_payment_mode!
            currentBooking.deliveryStoreList.removeAll()
            
            for deliveryItem in deliveryStoreResponse.deliveries {
                currentBooking.deliveryStoreList.append(deliveryItem)
            }
            currentBooking.deliveryStoreList.sort { (deliveryItem1, deliveryItem2) -> Bool in
                return deliveryItem1.sequence_number < deliveryItem2.sequence_number
            }
            currentBooking.currency = deliveryStoreResponse.currency!
            currentBooking.selectedCityTimezone = (deliveryCity.timezone) ?? TimeZone.current.identifier
            currentBooking.currentServerTime = deliveryStoreResponse.server_time!
            
            currentBooking.currentDateMilliSecond = Utility.convertServerDateToMilliSecond(serverDate:deliveryStoreResponse.server_time!,strTimeZone: currentBooking.selectedCityTimezone)
            
            let cityData:CityData = deliveryStoreResponse.cityData!
            currentBooking.deliveryAdsList?.removeAll()
            //currentBooking.deliveryAdsList = deliveryStoreResponse.ads
            currentBooking.currentPlaceData.country = cityData.country
            currentBooking.currentPlaceData.country_code = cityData.countryCode
            currentBooking.currentPlaceData.city3 = cityData.city3
            currentBooking.currentPlaceData.city2 = cityData.city2
            currentBooking.currentPlaceData.city1 = cityData.city1
            currentBooking.currentPlaceData.latitude = cityData.latitude
            currentBooking.currentPlaceData.longitude = cityData.longitude
            currentBooking.currentPlaceData.address = cityData.address
            currentBooking.currentPlaceData.country_code_2 = cityData.countryCode
            currentBooking.currentPlaceData.city_code = cityData.cityCode
            return true
        } else {
            currentBooking.deliveryStoreList.removeAll()
            currentBooking.bookCityId = ""
            return false
        }
    }

    //MARK: - parsePromoCodeListResponse
    var promoCodeList:Array<PromoCodeItem>? = []
    class func parsePromoCodeList(_ response: NSDictionary) -> Array<PromoCodeItem>? {
        var promoCodeList:Array<PromoCodeItem>? = []
        if (isSuccess(response: response, withSuccessToast: false, andErrorToast: true)) {
            let promoCodeListResponse:PromoCodeListResponse = PromoCodeListResponse.init(dictionary: response)!
            promoCodeList?.removeAll()
            for promoCodeItem:PromoCodeItem in promoCodeListResponse.promoCodeList ?? Array<PromoCodeItem>() {
                promoCodeList?.append(promoCodeItem)
            }
            return promoCodeList
        } else {
            return promoCodeList
        }
    }

    //MARK: - parseStoreResponse
    var storeList:Array<StoreItem>? = []
    class func parseStoreList(_ response: NSDictionary) -> Array<StoreItem>? {
        var storeList:Array<StoreItem>? = []
        if (isSuccess(response: response, withSuccessToast: false, andErrorToast: true)) {
            let storeResponse:StoreResponse = StoreResponse.init(dictionary: response)!
            currentBooking.currentServerTime = storeResponse.server_time ?? Utility.dateToString(date: Date(), withFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB)
            currentBooking.currentDateMilliSecond =  Utility.convertServerDateToMilliSecond(serverDate:currentBooking.currentServerTime , strTimeZone: currentBooking.selectedCityTimezone)
            storeList?.removeAll()
            let myLatitude:Double = currentBooking.currentPlaceData.latitude
            let myLongitude:Double = currentBooking.currentPlaceData.longitude
            for store:StoreItem in storeResponse.stores?.results! ?? Array<StoreItem>() {
                let storeOpen = Utility.isStoreOpen(storeTime: store.store_time, milliSeconds: currentBooking.currentDateMilliSecond)
                store.isStoreClosed = !storeOpen.0
                store.reopenAt = storeOpen.1
                if store.location != nil {
                    store.distanceFromMyLocation = Utility.distance(lat1: myLatitude, lon1: myLongitude, lat2: store.location![0], lon2: store.location![1], isUnitKiloMeter: true)
                }
                store.currency = currentBooking.currency
                store.strFamousProductsTags =  Utility.bindPriceTag(arrForFamousTags: store.famousProductsTags, currency:  store.currency, numberOfTags: store.price_rating ?? 0)
                store.strFamousProductsTagsWithComma = Utility.bindTagWithComma(arrForFamousTags: store.famousProductsTags, numberOfTags: store.price_rating ?? 0)
                store.isFavourite = currentBooking.favouriteStores.contains(store._id ?? "")
                if currentBooking.isFutureOrder {
                    if store.is_taking_schedule_order == true {
                        storeList?.append(store)
                    }
                } else {
                    storeList?.append(store)
                }
            }
            return storeList
        } else {
            return storeList
        }
    }

    //MARK: - parseStoreProductList
    class func parseStoreProductList(_ response: NSDictionary) -> Array<ProductItem>? {
        var productList:Array<ProductItem>? = nil
        if (isSuccess(response: response, withSuccessToast: false, andErrorToast: true)) {
            let productResponse:StoreProductResponse = StoreProductResponse.init(dictionary: response)!
            productList = productResponse.products!
            currentBooking.currentServerTime = productResponse.serverTime ?? Utility.dateToString(date: Date(), withFormat: DATE_CONSTANT.DATE_TIME_FORMAT_WEB)
            currentBooking.currentDateMilliSecond = Utility.convertServerDateToMilliSecond(serverDate:currentBooking.currentServerTime , strTimeZone: productResponse.timeZone)
            return productList
        } else {
            return productList
        }
    }

    //MARK: - parseStoreProductGroupList
    class func parseStoreProductGroupList(_ response: NSDictionary) -> [ProductGroupModel] {
        var productResponse = [ProductGroupModel]()
        if (isSuccessGroup(response: response, withSuccessToast: false, andErrorToast: true)) {
            productResponse.append(ProductGroupModel(fromDictionary: response as! [String : Any]))
            return productResponse
        } else {
            return productResponse
        }
    }

    //MARK: - parsePaymentGateways
    class func parsePaymentGateways(_ response: NSDictionary,isShowCash:Bool = true, completion: @escaping (_ result: Bool) -> Void) {
        if (isSuccess(response: response, withSuccessToast: false, andErrorToast: true)) {
            let payment:PaymentConfig = PaymentConfig.shared
            payment.clearPaymentConfig()
            let paymentGatewayResponse:PaymentGatewayResponse = PaymentGatewayResponse.init(dictionary: response)!
            let paymentGatewayItems:[PaymentGatewayItem] = paymentGatewayResponse.paymentGateway
            payment.isUseWallet = paymentGatewayResponse.isUseWallet
            payment.wallet = paymentGatewayResponse.wallet
            payment.walletCurrencyCode = paymentGatewayResponse.walletCurrencyCode
            currentBooking.isCashPaymentMode = paymentGatewayResponse.isCashPaymentMode
            
            if currentBooking.isCashPaymentMode && isShowCash {
                let paymentCash:PaymentGatewayItem = PaymentGatewayItem.init()
                paymentCash.id = Payment.CASH
                paymentCash.uniqueId = 0
                paymentCash.name = "CASH"
                paymentCash.descriptionField = "CASH"
                paymentCash.paymentKeyId = "Cash"
                paymentCash.paymentKey = "Cash"
                paymentCash.isPaymentVisible =  true
                paymentCash.isPaymentByLogin = false
                paymentCash.isPaymentByWebUrl = false
                paymentCash.isUsingCardDetails = false
                payment.paymentGateways.append(paymentCash)
            }
            
            for paymentGateway in paymentGatewayItems {
                if paymentGateway.id == Payment.STRIPE {
                    CONSTANT.STRIPE_KEY = paymentGateway.paymentKeyId
                }
                payment.paymentGateways.append(paymentGateway)
            }
            
            completion(true)
        }else {
            completion(false)
        }
    }
    //MARK:- parseCountries
    class func parseCities(_ response: NSDictionary ,toArray:NSMutableArray , completion: @escaping (_ result: Bool) -> Void) {
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
    
    //MARK: - parseSpecifications
    class func parseSpecifications(_ response: NSDictionary) -> [Specifications] {
        var productList = [Specifications]()

        if (isSuccess(response: response, withSuccessToast: false, andErrorToast: true)) {
            let arr = (response["specification_group"]! as! NSArray).mutableCopy() as! NSMutableArray

            if arr.count > 0 {
                for obj in arr {
                    let specificationsResponse:Specifications = Specifications.init(dictionary: obj as! NSDictionary)!
                    productList.append(specificationsResponse)
                }
            }
            return productList
        } else {
            return productList
        }
    }

    //MARK: - parseCart
    class func parseCart(_ response: NSDictionary) -> Bool {
        if (isSuccess(response: response, withSuccessToast: false, andErrorToast: false)) {
            currentBooking.clearCart()

            print("Parse cart ----- \(Utility.convertDictToJson(dict: response as! Dictionary<String, Any>))")
            var numberOfItemInCart:Int = 0
            let cartResponse:CartResponse = CartResponse.init(dictionary: response)!

            func getTax(itemAmount:Double, taxValue:Double) -> Double {
                if !cartResponse.isTaxInlcuded{
                    return itemAmount * taxValue * 0.01
                } else {
                    return (itemAmount - (100*itemAmount)/(100+taxValue))
                }
            }

            currentBooking.destinationAddress = (cartResponse.destinationAddress)
            currentBooking.pickupAddress = (cartResponse.pickupAddress)
            currentBooking.cartCurrency = cartResponse.currency ?? ""
            currentBooking.storeLatLng = currentBooking.pickupAddress[0].location
            currentBooking.deliveryAddress = currentBooking.destinationAddress[0].address
            currentBooking.deliveryLatLng = currentBooking.destinationAddress[0].location
            currentBooking.cartId = cartResponse.cartId
            currentBooking.cartCityId = cartResponse.cartCityId
            currentBooking.CartResponselangItems = cartResponse.langItems
            currentBooking.storeIdInCart = cartResponse.store_id
            
            //changed
            currentBooking.isUseItemTax = cartResponse.isUseItemTax
            currentBooking.isTaxIncluded = cartResponse.isTaxInlcuded
            currentBooking.StoreTaxDetails = cartResponse.StoreTaxDetails

            let cartProductsList:[CartProduct] = (cartResponse.cart?.order_details)!
            
            for cartProduct in cartProductsList {
                var itemPriceAndSpecificationPriceTotal:Double = 0
                let products:CartProduct = CartProduct.init() 
                products.product_name = (cartProduct.productItem?.name)!
                products.unique_id = (cartProduct.productItem?.unique_id)!
                products.product_id = (cartProduct.productItem?._id)!
                var cartProductItemsNew:CartProductItems? = nil
                var cartProductItemsListNew:[CartProductItems] = [CartProductItems].init()
                for cartProductItems in cartProduct.items! {
                    var specificationListNew:[Specifications] = [Specifications].init()
                    cartProductItemsNew = CartProductItems()
                    cartProductItemsNew?.image_url = cartProductItems.producuItemsItem?.image_url
                    cartProductItemsNew?.item_id = cartProductItems.producuItemsItem?._id
                    cartProductItemsNew?.item_name = cartProductItems.producuItemsItem?.name
                    cartProductItemsNew?.item_price = cartProductItems.producuItemsItem?.price
                    cartProductItemsNew?.details = cartProductItems.producuItemsItem?.details
                    cartProductItemsNew?.quantity = cartProductItems.quantity
                    cartProductItemsNew?.unique_id = cartProductItems.unique_id
                    cartProductItemsNew?.noteForItem = cartProductItems.noteForItem
                    cartProductItemsNew?.taxDetails = cartProductItems.producuItemsItem?.taxDetails
                    itemPriceAndSpecificationPriceTotal = (cartProductItems.producuItemsItem?.price!)!
                    let cartSpecificationsItems:[Specifications] = cartProductItems.specifications
                    let specificationsItems:[Specifications] = (cartProductItems.producuItemsItem?.specifications)!
                    let specificationSize = cartSpecificationsItems.count
                    var specificationPriceTotal = 0.0
                    var specificationPrice = 0.0
                    var specificationItemCartListNew:[SpecificationListItem] = [SpecificationListItem]()
                    for i in 0..<specificationSize {
                        var specificationsItemNew:Specifications? = nil
                        for a in 0..<specificationsItems.count {
                            if cartSpecificationsItems[i].unique_id ?? 0 == specificationsItems[a].unique_id ??  0 {
                                specificationItemCartListNew = [SpecificationListItem].init()
                                let cartSpecificationListItemList:[SpecificationListItem] = cartSpecificationsItems[i].list!
                                let specificationListItemList:[SpecificationListItem] = specificationsItems[a].list!
                                let cartSpecificationItemListSize = cartSpecificationListItemList.count
                                let specificationListItemListSize = specificationsItems[a].list!.count
                                for j in 0..<cartSpecificationItemListSize {
                                    for k in 0..<specificationListItemListSize {
                                        for obj in cartProductItems.producuItemsItem!.specifications ?? [] {
                                            for list in obj.list ?? [] {
                                                if (cartSpecificationListItemList[j].unique_id! == list.unique_id!) {
                                                    list.quantity = cartSpecificationListItemList[j].quantity
                                                }
                                            }
                                        }
                                        if (cartSpecificationListItemList[j].unique_id! == specificationListItemList[k].unique_id!) {
                                            specificationPrice = specificationPrice + specificationListItemList[k].price!
                                            specificationPriceTotal = specificationPriceTotal + (specificationListItemList[k].price! * Double(specificationListItemList[k].quantity))
                                            specificationItemCartListNew.append(specificationListItemList[k])
                                            break
                                        }
                                    }
                                }

                                if !specificationItemCartListNew.isEmpty {
                                    specificationsItemNew = Specifications()
                                    specificationsItemNew?.list = specificationItemCartListNew
                                    specificationsItemNew?.name = specificationsItems[a].name
                                    specificationsItemNew?.price = specificationsItems[a].price
                                    specificationsItemNew?.type = specificationsItems[a].type
                                    specificationsItemNew?.unique_id = specificationsItems[a].unique_id
                                    specificationsItemNew?.range = specificationsItems[a].range
                                    specificationsItemNew?.rangeMax = specificationsItems[a].rangeMax
                                    specificationsItemNew?.is_required = specificationsItems[a].is_required
                                }
                                specificationPrice = 0
                                break
                            }
                        }

                        if specificationsItemNew != nil {
                            specificationListNew.append(specificationsItemNew!)
                        }
                    }
                    cartProductItemsNew?.specifications = specificationListNew
                    cartProductItemsNew?.total_specification_price = specificationPriceTotal
                    itemPriceAndSpecificationPriceTotal = (itemPriceAndSpecificationPriceTotal + specificationPriceTotal) * Double(cartProductItems.quantity!)
                    cartProductItemsNew?.totalItemPrice = itemPriceAndSpecificationPriceTotal

                    var storeTax : Int = 0
                    for obj in cartResponse.StoreTaxDetails{
                        storeTax = storeTax + obj.tax
                    }
                    cartProductItemsNew?.tax = cartResponse.isUseItemTax ? cartProductItems.tax : Double(storeTax)
                    cartProductItemsNew?.itemTax = getTax(itemAmount: (cartProductItems.item_price)!, taxValue: (cartProductItems.tax))
                    cartProductItemsNew?.totalSpecificationTax = getTax(itemAmount: (cartProductItems.total_specification_price)!, taxValue: (cartProductItems.tax))
                    cartProductItemsNew?.totalTax =  (cartProductItemsNew!.itemTax) + (cartProductItemsNew!.totalSpecificationTax)
                    cartProductItemsNew?.totalItemTax = (cartProductItemsNew!.totalTax) * Double((cartProductItems.quantity)!)

                    cartProductItemsListNew.append(cartProductItemsNew!)
                    numberOfItemInCart = numberOfItemInCart + cartProductsList.count
                    
                    currentBooking.cartWithAllSpecification.append(cartProductItems.producuItemsItem!)
                }

                products.items = cartProductItemsListNew
                products.total_item_price = itemPriceAndSpecificationPriceTotal
                currentBooking.selectedStoreId = cartProduct.productItem?.store_id
                currentBooking.table_no = cartResponse.table_no
                currentBooking.number_of_pepole = cartResponse.no_of_persons
                currentBooking.deliveryType = cartResponse.delivery_type
                currentBooking.bookingType = cartResponse.booking_type
                currentBooking.cart.append(products)

                if cartResponse.isTaxInlcuded {
                    currentBooking.totalCartAmount = currentBooking.totalCartAmount! + ((cartProductItemsNew?.totalItemPrice)! - cartProductItemsNew!.totalItemTax)
                } else {
                    currentBooking.totalCartAmount = currentBooking.totalCartAmount! + (cartProductItemsNew?.totalItemPrice)!
                }
            }
            currentBooking.totalItemInCart = numberOfItemInCart
            return true
        } else {
            return false
        }
    }

    //MARK: - parseCards
    class func parseCards(_ response: NSDictionary ,toArray:NSMutableArray , completion: @escaping (_ result: Bool) -> Void) {
        if (isSuccess(response: response, withSuccessToast: false, andErrorToast: false)) {
            toArray.removeAllObjects()
            let cardResponse:CardResponse = CardResponse.init(dictionary: response)!
            let cardList:[CardItem] = cardResponse.cards!
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
    class func parseCard(_ response: NSDictionary ,toArray:NSMutableArray , completion: @escaping (_ result: Bool) -> Void) {
        if (isSuccess(response: response, withSuccessToast: false, andErrorToast: true)) {
            let cardResponse:CardResponse = CardResponse.init(dictionary: response)!
            let card:CardItem = cardResponse.card!
            toArray.add(card)
            completion(true)
            
        }else {
            completion(false)
        }
    }
    //MARK:- parseDocumentList
    class func parseDocumentList(_ response: NSDictionary ,toArray:NSMutableArray , completion: @escaping (_ result: Bool) -> Void) {
        if (isSuccess(response: response, withSuccessToast: false, andErrorToast: false)) {
            let documentResponse:DocumentsResponse = DocumentsResponse.init(fromDictionary: response as! [String : Any])
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
    //MARK:- Orders History
    class func parseOrderHistory(_ response: NSDictionary ,toArray:NSMutableArray, completion: @escaping (_ result: Bool) -> Void) {
        if (isSuccess(response: response, withSuccessToast: false, andErrorToast: false)) {
            let historyOrderResposnse:OrderHistoryResponse = OrderHistoryResponse.init(dictionary: response)!
            let historyOrderList:[Order_list] = historyOrderResposnse.order_list!
            if historyOrderList.count > 0 {
                let sortedArray = historyOrderList.sorted{ $0.created_at! > $1.created_at! }
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
    
    //MARK:- History Detail
    class func parseOrderHistoryDetail(_ response: NSDictionary ,toHistoryOrderDetail:NSMutableDictionary, completion: @escaping (_ result: Bool) -> Void) {
        if (isSuccess(response: response, withSuccessToast: false, andErrorToast: false)) {
            let historyOrderResposnse:HistoryOrderDetailResponse = HistoryOrderDetailResponse.init(dictionary: response)!
            toHistoryOrderDetail.setValue(historyOrderResposnse, forKey: PARAMS.HISTORY_DETAIL)
            completion(true)
            
        }else{
            completion(false)
        }
    }
    // Wallet History
    class func parseWalletHistory(_ response: [String:Any] ,toArray:NSMutableArray , completion: @escaping (_ result: Bool) -> Void) {
        toArray.removeAllObjects()
        var isShowToast: Bool = false
        if response["error_code"] != nil {
                isShowToast = true
        }
        if (isSuccess(response: response as NSDictionary, withSuccessToast: false, andErrorToast: isShowToast)) {
            let walletListResponse:WalletHistoryResponse = WalletHistoryResponse.init(fromDictionary: response)
            
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
        else {
            Utility.showToast(message: "ERROR_CODE_833".localized)
        }
    }
    //MARK:- pargeWeatherResponse is Success Or Not
    static func isSuccess(response:NSDictionary, withSuccessToast:Bool = false, andErrorToast:Bool = true) -> Bool {
        
        if response.allKeys.count > 0 {
            let isSuccess:IsSuccessResponse = IsSuccessResponse.init(dictionary: response)!
            let msgString = isSuccess.status_phrase
            if isSuccess.success! {
                if withSuccessToast {
                    DispatchQueue.main.async {
                        //let messageCode:String = "MSG_CODE_" + String(isSuccess.message ?? 0)
                        Utility.hideLoading()
                        Utility.showToast(message:msgString.localized)
                    }
                }
                return true
                
            }else {
                let errorCode:String = "ERROR_CODE_" + String(isSuccess.errorCode ?? 0)
                if (errorCode.compare("ERROR_CODE_999") == ComparisonResult.orderedSame || errorCode.compare("ERROR_CODE_534") == ComparisonResult.orderedSame) {
                    DispatchQueue.main.async {
                        Utility.hideLoading()
                        Utility.showToast(message: msgString.localized)
                        preferenceHelper.setSessionToken("")
                        preferenceHelper.setUserId("")
                        preferenceHelper.setRandomCartID(String.random(length: 20))
                        APPDELEGATE.goToHome()
                        return
                    }
                }else if andErrorToast {
                    DispatchQueue.main.async {
                        Utility.hideLoading()
                        Utility.showToast(message: msgString.localized)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        Utility.hideLoading()
                    }
                }
                return false
            }
        }else {
            return false
        }
    }
    
    
    //Removing no group found by showing up
    static func isSuccessGroup(response:NSDictionary, withSuccessToast:Bool = false, andErrorToast:Bool = true) -> Bool {
        
        if response.allKeys.count > 0 {
            let isSuccess:IsSuccessResponse = IsSuccessResponse.init(dictionary: response)!
            if isSuccess.success! {
                if withSuccessToast {
                    DispatchQueue.main.async {
                        let msgString = isSuccess.status_phrase
                        //let messageCode:String = "MSG_CODE_" + String(isSuccess.message ?? 0)
                        Utility.hideLoading()
                        Utility.showToast(message:msgString.localized)
                    }
                }
                return true
                
            }else {
                let errorCode:String = "ERROR_CODE_" + String(isSuccess.errorCode ?? 0)
                if (errorCode.compare("ERROR_CODE_999") == ComparisonResult.orderedSame || errorCode.compare("ERROR_CODE_534") == ComparisonResult.orderedSame) {
                    DispatchQueue.main.async {
                        Utility.hideLoading()
                        Utility.showToast(message: errorCode.localized)
                        preferenceHelper.setSessionToken("")
                        preferenceHelper.setUserId("")
                        preferenceHelper.setRandomCartID(String.random(length: 20))
                        APPDELEGATE.goToHome()
                        return
                    }
                }else if andErrorToast {
                    DispatchQueue.main.async {
                        Utility.hideLoading()
                    }
                }
                return false
            }
        }else {
            return false
        }
    }
}
