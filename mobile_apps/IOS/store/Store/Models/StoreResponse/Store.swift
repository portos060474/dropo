//
//	Store.swift
//
//	Create by Jaydeep Vyas on 18/7/2017
//	Copyright © 2017 Elluminati. All rights reserved.

import Foundation

class Store{
    
    /*Integer Values*/
    var v : Int!
    var userRateCount : Int!
    var adminProfitModeOnStore : Int!
    var adminProfitValueOnStore : Int!
    var deliveryTime : Int!
    var deliveryTimeMax : Int!
    var priceRating : Int!
    var providerRateCount : Int!
    var totalReferrals : Int!
    var uniqueId : Int!
    var scheduleOrderCreateAfterMinute : Int!
    var informScheduleOrderBeforeMin : Int!
    var orderCancellationChargeType : Int!
    var maxItemQuantityAddByUser : Int!
    
    
    /*String Values*/
    var id : String!
    var address : String!
    var appVersion : String!
    var cityId : String!
    var comments : String!
    var countryId : String!
    var countryPhoneCode : String!
    var createdAt : String!
    var currency : String = ""
    var deviceToken : String!
    var deviceType : String!
    var email : String!
    var imageUrl : String!
    var name : String!
    var nameLanguages = [String]()
    
    var password : String!
    var phone : String!
    var referralCode : String!
    var referredBy : String!
    var serverToken : String!
    var slogan : String!
    var storeDeliveryId : String!
    var storeTime : [StoreTime]!
    var storeDeliveryTime : [StoreTime]!
    
    //    var famousProductsTags : [String]!
    var famousProductsTags : [[String]]!
    
    var famousProductsTagsToUpdate : [[String]]!
    
    var updatedAt : String!
    var walletCurrencyCode : String!
    var websiteUrl : String!
    var socialIds : [String]!
    var timeZone : String = ""
    var isStoreCanCompleteOrder :Bool!
    var isStoreCanAddProvider:Bool!
    /*Double Values*/
    var userRate : Double!
    var wallet : Double!
    var freeDeliveryForAboveOrderPrice : Double!
    var freeDeliveryRadius : Double!
    var deliveryRadius : Double!
    var minOrderPrice : Double!
    var orderCancellationChargeForAboveOrderPrice : Double!
    var orderCancellationChargeValue : Double!
    var itemTax : Double!
    var location : [Double]!
    var providerRate : Double!
    var deliveryDetail:DeliveryItem!
    var laguages_supported :[String:Any] = [:]
    
    /*Boolean Values*/
    var isOrderCancellationChargeApply : Bool!
    var isProvideDeliveryAnywhere : Bool!
    var isTakingScheduleOrder : Bool!
    var isBussy : Bool!
    var isVisible : Bool!
    var isApproved : Bool!
    var isBusiness : Bool!
    var isDocumentUploaded : Bool!
    var isEmailVerified : Bool!
    var isPhoneNumberVerified : Bool!
    var isReferral : Bool!
    var isStorePayDeliveryFees : Bool!
    var isStoreSetScheduleDeliveryTime : Bool!
    
    var isAskEstimatedTimeForReadyOrder: Bool!
    var isProvidePickupDelivery:Bool!
    var isUseItemTax:Bool!
    
    var isStoreCanSetCancellationCharge:Bool!
    var isStoreCreateOrder:Bool!
    var isStoreEditMenu:Bool
    var isStoreAddPromoCode:Bool
    var isStoreEditItem:Bool
    var languages:[String:Any] = [:]
    var isStoreCanEditOrder : Bool!
    var taxesDetails : [TaxesDetail]!
    var taxes : [String]! = []

    var isTaxInlcuded : Bool!
    
    var countryDetails : CountryDetail!
    var cancellation_charge_apply_from : Int!
    var cancellation_charge_apply_till : Int!
    var firebaseToken : String!
    
    var cityDetails: City_Details?
    
    var is_provide_delivery: Bool = false

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        
        firebaseToken = (dictionary["firebase_token"] as? String) ?? ""
        isStoreCanSetCancellationCharge =  (dictionary["is_store_can_set_cancellation_charge"] as? Bool) ?? true
        isStoreCreateOrder =  (dictionary["is_store_create_order"] as? Bool) ?? true
        isStoreEditMenu =  (dictionary["is_store_edit_menu"] as? Bool) ?? true
        isStoreAddPromoCode =  (dictionary["is_store_edit_item"] as? Bool) ?? true
        isStoreEditItem =  (dictionary["is_store_add_promocode"] as? Bool) ?? true
        
        
        isUseItemTax =  (dictionary["is_use_item_tax"] as? Bool) ?? false
        v = (dictionary["__v"] as? Int) ?? 0
        id = (dictionary["_id"] as? String) ?? ""
        address = (dictionary["address"] as? String) ?? ""
        adminProfitModeOnStore = (dictionary["admin_profit_mode_on_store"] as? Int) ?? 0
        isProvidePickupDelivery =  (dictionary["is_provide_pickup_delivery"] as? Bool) ?? false
        adminProfitValueOnStore = (dictionary["admin_profit_value_on_store"] as? Int) ?? 0
        appVersion = (dictionary["app_version"] as? String) ?? ""
        cityId = (dictionary["city_id"] as? String) ?? ""
        comments = (dictionary["comments"] as? String) ?? ""
        countryId = (dictionary["country_id"] as? String) ?? ""
        countryPhoneCode = (dictionary["country_phone_code"] as? String) ?? ""
        email = (dictionary["email"] as? String) ?? ""
        createdAt = (dictionary["created_at"] as? String) ?? ""
        deliveryTime = (dictionary["delivery_time"] as? Int) ?? 0
        deliveryTimeMax = (dictionary["delivery_time_max"] as? Int) ?? 0
        deviceToken = (dictionary["device_token"] as? String) ?? ""
        deviceType = (dictionary["device_type"] as? String) ?? ""
        
        freeDeliveryForAboveOrderPrice = (dictionary["free_delivery_for_above_order_price"] as? Double)?.roundTo() ?? 0.0
        freeDeliveryRadius = (dictionary["free_delivery_within_radius"] as? Double)?.roundTo() ?? 0.0
        isBussy = (dictionary["is_store_busy"] as? Bool) ?? false
        
        imageUrl = (dictionary["image_url"] as? String) ?? ""
        isApproved = (dictionary["is_approved"] as? Bool) ?? false
        isBusiness = (dictionary["is_business"] as? Bool) ?? false
        isDocumentUploaded = (dictionary["is_document_uploaded"] as? Bool) ?? false
        isEmailVerified = (dictionary["is_email_verified"] as? Bool) ?? false
        isPhoneNumberVerified = (dictionary["is_phone_number_verified"] as? Bool) ?? false
        isReferral = (dictionary["is_referral"] as? Bool) ?? false
        isStorePayDeliveryFees = (dictionary["is_store_pay_delivery_fees"] as? Bool) ?? false
        isStoreSetScheduleDeliveryTime = (dictionary["is_store_set_schedule_delivery_time"] as? Bool) ?? false
        
        itemTax = (dictionary["item_tax"] as? Double)?.roundTo() ?? 0.0
        location = (dictionary["location"] as? [Double]) ?? [0.0,0.0]
        if let countryDetailsData = dictionary["country_details"] as? [String:Any]{
            countryDetails = CountryDetail(fromDictionary: countryDetailsData)
        }
        
        isTaxInlcuded = dictionary["is_tax_included"] as? Bool ?? false
        taxes = dictionary["taxes"] as? [String]
        
        is_provide_delivery = dictionary["is_provide_delivery"] as? Bool ?? false

        taxesDetails = [TaxesDetail]()
        if let taxesDetailsArray = dictionary["tax_details"] as? [[String:Any]]{
            for dic in taxesDetailsArray{
                let value = TaxesDetail(fromDictionary: dic)
                taxesDetails.append(value)
            }
        }
         
        if let cityDetail = dictionary["city_details"] as? [String:Any] {
            cityDetails = City_Details(fromDictionary: cityDetail)
        }
        
        if dictionary["name"] != nil{
            print("Item : \(dictionary["name"]!)")
            
            var arr = [String]()
            if let _ = dictionary["name"] as? NSArray {
                for obj in dictionary["name"]! as! NSArray{
                    if StoreSingleton.shared.isNotNSNull(object: obj as AnyObject){
                        arr.append(obj as! String)
                    }else{
                        arr.append("")
                    }
                }
                nameLanguages.removeAll()
                nameLanguages.append(contentsOf: arr)
                
                if dictionary["name"] != nil{
                    //Janki: According to Admin lang
                    name = StoreSingleton.shared.returnStringAccordingtoAdminLanguage(arrStr: arr)
                }
                print("Store name : \(name!)")
            }else{
                name = dictionary["name"]! as? String
            }
        }else{
            name = ""
        }
        
        print("nameLanguages \(nameLanguages)")
        
        //        name = (dictionary["name"] as? String) ?? ""
        
        password = (dictionary["password"] as? String) ?? ""
        phone = (dictionary["phone"] as? String) ?? ""
        priceRating = (dictionary["price_rating"] as? Int) ?? 0
        providerRate = (dictionary["provider_rate"] as? Double)?.roundTo() ?? 0.0
        providerRateCount = (dictionary["provider_rate_count"] as? Int) ?? 0
        referralCode = (dictionary["referral_code"] as? String) ?? ""
        referredBy = (dictionary["referred_by"] as? String) ?? ""
        serverToken = (dictionary["server_token"] as? String) ?? ""
        slogan = (dictionary["slogan"] as? String) ?? ""
        storeDeliveryId = (dictionary["store_delivery_id"] as? String) ?? ""
        famousProductsTags = (dictionary["famous_products_tags"] as? [[String]]) ?? [[]]
        
        famousProductsTagsToUpdate = [[String]]()
        
        
        if let languageArrya = dictionary["languages_supported"] as? [[String:Any]] {
            if languageArrya.count > 0{
                ConstantsLang.storeLanguages.removeAll()
                for item in languageArrya
                {
                    ConstantsLang.storeLanguages.append(StoreLanguage.init(fromDictionary: item))
                }
            }
        }
        
        if let storeTimeArray = dictionary["store_time"] as? [[String:Any]] {
            storeTime = [StoreTime]()
            for dic in storeTimeArray {
                let value = StoreTime(fromDictionary: dic)
                storeTime.append(value)
            }
        }
        
        if let storeDTimeArray = dictionary["store_delivery_time"] as? [[String:Any]] {
            storeDeliveryTime = [StoreTime]()
            for dic in storeDTimeArray {
                let value = StoreTime(fromDictionary: dic)
                storeDeliveryTime.append(value)
            }
        }
        
        totalReferrals = (dictionary["total_referrals"] as? Int) ?? 0
        uniqueId = (dictionary["unique_id"] as? Int) ?? 0
        updatedAt = (dictionary["updated_at"] as? String) ?? ""
        userRate = (dictionary["user_rate"] as? Double)?.roundTo() ?? 0.0
        userRateCount = (dictionary["user_rate_count"] as? Int) ?? 0
        wallet = (dictionary["wallet"] as? Double)?.roundTo() ?? 0.0
        walletCurrencyCode = (dictionary["wallet_currency_code"] as? String) ?? ""
        websiteUrl = (dictionary["website_url"] as? String) ?? ""
        if (dictionary["social_ids"] != nil) {
            socialIds = ((dictionary["social_ids"] as! NSArray) as? Array<String>) ?? []
        }
        if let tempDetail = dictionary["delivery_details"] as? [String:Any] {
            deliveryDetail = DeliveryItem.init(fromDictionary: tempDetail)
        }
        deliveryRadius = (dictionary["delivery_radius"] as? Double)?.roundTo() ?? 0.0
        informScheduleOrderBeforeMin = (dictionary["inform_schedule_order_before_min"] as? Int) ?? 0
        isOrderCancellationChargeApply = (dictionary["is_order_cancellation_charge_apply"] as? Bool) ?? false
        isProvideDeliveryAnywhere = (dictionary["is_provide_delivery_anywhere"] as? Bool) ?? false
        isTakingScheduleOrder = (dictionary["is_taking_schedule_order"] as? Bool) ?? false
        maxItemQuantityAddByUser = (dictionary["max_item_quantity_add_by_user"] as? Int) ?? 0
        minOrderPrice = (dictionary["min_order_price"] as? Double)?.roundTo() ?? 0.0
        orderCancellationChargeForAboveOrderPrice = (dictionary["order_cancellation_charge_for_above_order_price"] as? Double)?.roundTo() ?? 0.0
        orderCancellationChargeType = (dictionary["order_cancellation_charge_type"] as? Int) ?? 0
        orderCancellationChargeValue = (dictionary["order_cancellation_charge_value"] as? Double)?.roundTo() ?? 0.0
        scheduleOrderCreateAfterMinute = (dictionary["schedule_order_create_after_minute"] as? Int) ?? 0
        
        isBussy = (dictionary["is_store_busy"] as? Bool) ?? false
        isVisible = (dictionary["is_visible"] as? Bool) ?? false
        isAskEstimatedTimeForReadyOrder = (dictionary["is_ask_estimated_time_for_ready_order"] as? Bool) ?? false
        isStoreCanCompleteOrder = (dictionary["is_store_can_complete_order"] as? Bool) ?? false
        isStoreCanAddProvider = (dictionary["is_store_can_add_provider"] as? Bool) ?? false
        languages = (dictionary["languages"] as? [String : Any]) ?? [:]
        
        cancellation_charge_apply_from = (dictionary["cancellation_charge_apply_from"] as? Int) ?? 0
        cancellation_charge_apply_till = (dictionary["cancellation_charge_apply_till"] as? Int) ?? 0

    }
    
    
    func toDictionary() -> [String:Any] {
        var dictionary = [String:Any]()
        
        if address != nil{
            dictionary["address"] = address
        }
        if languages != nil{
            dictionary["languages"] = languages
        }
        //Store app
        if name != nil{
            dictionary["name"] = nameLanguages
        }
        
        if deliveryDetail != nil{
            dictionary["delivery_details"] = deliveryDetail.toDictionary()
        }
        if deliveryRadius != nil{
            dictionary["delivery_radius"] = deliveryRadius
        }
        if deliveryTime != nil{
            dictionary["delivery_time"] = deliveryTime
        }
        if deliveryTimeMax != nil{
            dictionary["delivery_time_max"] = deliveryTimeMax
        }
        if deviceToken != nil{
            dictionary["device_token"] = deviceToken
        }
        if deviceType != nil{
            dictionary["device_type"] = deviceType
        }
        
        dictionary["is_provide_delivery"] = is_provide_delivery
        
        //        if famousProductsTags != nil{
        //            dictionary["famous_products_tags"] = famousProductsTags
        //        }
        
        if famousProductsTagsToUpdate != nil{
            dictionary["famous_products_tags"] = famousProductsTagsToUpdate
        }
        
        
        if freeDeliveryForAboveOrderPrice != nil{
            dictionary["free_delivery_for_above_order_price"] = freeDeliveryForAboveOrderPrice
        }
        if freeDeliveryRadius != nil{
            dictionary["free_delivery_within_radius"] = freeDeliveryRadius
        }
        
        if informScheduleOrderBeforeMin != nil{
            dictionary["inform_schedule_order_before_min"] = informScheduleOrderBeforeMin
        }
        
        if isAskEstimatedTimeForReadyOrder != nil{
            dictionary["is_ask_estimated_time_for_ready_order"] = isAskEstimatedTimeForReadyOrder
        }
        if isBusiness != nil{
            dictionary["is_business"] = isBusiness
        }
        
        if isOrderCancellationChargeApply != nil{
            dictionary["is_order_cancellation_charge_apply"] = isOrderCancellationChargeApply
        }
        if isProvideDeliveryAnywhere != nil{
            dictionary["is_provide_delivery_anywhere"] = isProvideDeliveryAnywhere
        }
        if isProvidePickupDelivery != nil{
            dictionary["is_provide_pickup_delivery"] = isProvidePickupDelivery
        }
        
        if isBussy != nil{
            dictionary["is_store_busy"] = isBussy
        }
        if isStorePayDeliveryFees != nil{
            dictionary["is_store_pay_delivery_fees"] = isStorePayDeliveryFees
        }
        if isStoreSetScheduleDeliveryTime != nil{
            dictionary["is_store_set_schedule_delivery_time"] = isStoreSetScheduleDeliveryTime
        }
        if isTakingScheduleOrder != nil{
            dictionary["is_taking_schedule_order"] = isTakingScheduleOrder
        }   
        if isUseItemTax != nil{
            dictionary["is_use_item_tax"] = isUseItemTax
        }
        
        if itemTax != nil{
            dictionary["item_tax"] = itemTax
        }
        if location != nil{
            dictionary["location"] = location
            dictionary["latitude"] = location[0].toString(decimalPlaced : 6)
            dictionary["longitude"] = location[1].toString(decimalPlaced : 6)
        }
        
        if maxItemQuantityAddByUser != nil{
            dictionary["max_item_quantity_add_by_user"] = maxItemQuantityAddByUser
        }
        if minOrderPrice != nil{
            dictionary["min_order_price"] = minOrderPrice
        }
        
        if orderCancellationChargeForAboveOrderPrice != nil{
            dictionary["order_cancellation_charge_for_above_order_price"] = orderCancellationChargeForAboveOrderPrice
        }
        if orderCancellationChargeType != nil{
            dictionary["order_cancellation_charge_type"] = orderCancellationChargeType
        }
        if orderCancellationChargeValue != nil{
            dictionary["order_cancellation_charge_value"] = orderCancellationChargeValue
        }
        
        if priceRating != nil{
            dictionary["price_rating"] = priceRating
        }
        
        if scheduleOrderCreateAfterMinute != nil{
            dictionary["schedule_order_create_after_minute"] = scheduleOrderCreateAfterMinute
        }
        if serverToken != nil{
            dictionary["server_token"] = serverToken
        }
        if slogan != nil{
            dictionary["slogan"] = slogan
        }
        if socialIds != nil{
            dictionary["social_ids"] = socialIds
        }
        
        if storeTime != nil{
            var dictionaryElements = [[String:Any]]()
            for storeTimeElement in storeTime {
                dictionaryElements.append(storeTimeElement.toDictionary())
            }
            dictionary["store_time"] = dictionaryElements
        }
        if websiteUrl != nil{
            dictionary["website_url"] = websiteUrl
        }
        
        if let languageArrya = dictionary["languages_supported"] as? [[String:Any]] {
            if languageArrya.count > 0{
                ConstantsLang.storeLanguages.removeAll()
                for item in languageArrya
                {
                    ConstantsLang.storeLanguages.append(StoreLanguage.init(fromDictionary: item))
                }
            }
        }
        if countryDetails != nil{
            dictionary["country_details"] = countryDetails.toDictionary()
        }
        if taxes != nil{
                    dictionary["taxes"] = taxes
                }
        if taxesDetails != nil{
            var dictionaryElements = [[String:Any]]()
            for taxesDetailsElement in taxesDetails {
                dictionaryElements.append(taxesDetailsElement.toDictionary())
            }
            dictionary["taxes_details"] = dictionaryElements
        }
        if isTaxInlcuded != nil{
            dictionary["is_tax_included"] = isTaxInlcuded
        }
        if cancellation_charge_apply_from != nil{
            dictionary["cancellation_charge_apply_from"] = cancellation_charge_apply_from
        }
        if cancellation_charge_apply_till != nil{
            dictionary["cancellation_charge_apply_till"] = cancellation_charge_apply_till
        }
        
        return dictionary
    }
    
}


class DeliveryItem : NSObject{
    var famousProductsTags : [[String]]!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]) {
        famousProductsTags = (dictionary["famous_products_tags"]) as? [[String]]
    }
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any] {
        let dictionary = [String:Any]()
        return dictionary
    }
}

class City_Details {
    let _id : String!
    let city_radius : Int!

    init(fromDictionary dictionary: [String:Any]) {
        _id = dictionary["_id"] as? String ?? ""
        city_radius = dictionary["city_radius"] as? Int ?? 0
    }

    func toDictionary() -> [String:Any] {
        var dictionary = [String:Any]()
        dictionary["_id"] = _id
        dictionary["city_radius"] = city_radius
        return dictionary
    }

}

