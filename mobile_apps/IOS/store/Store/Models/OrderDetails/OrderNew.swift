//
//	Order.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class OrderNew : NSObject, NSCoding{

	var v : Int!
	var id : String!
	var cancelReason : String!
	var cartId : String!
	var cityId : String!
	var completedAt : String!
	var completedDateInCityTimezone : AnyObject!
	var completedDateTag : String!
	var confirmationCodeForCompleteDelivery : Int!
	var confirmationCodeForPickUpDelivery : Int!
	var countryId : String!
	var createdAt : String!
	var dateTime : [DateTime]!
	var deliveryType : Int!
	var imageUrl : [AnyObject]!
	var isAllowContactlessDelivery : Bool!
	var isPaidFromWallet : Bool!
	var isPaymentModeCash : Bool!
	var isProviderRatedToStore : Bool!
	var isProviderRatedToUser : Bool!
	var isProviderShowInvoice : Bool!
	var isScheduleOrder : Bool!
	var isScheduleOrderInformedToStore : Bool!
	var isStoreRatedToProvider : Bool!
	var isStoreRatedToUser : Bool!
	var isUserPickUpOrder : Bool!
	var isUserRatedToProvider : Bool!
	var isUserRatedToStore : Bool!
	var isUserShowInvoice : Bool!
	var orderChange : Bool!
	var orderPaymentId : String!
	var orderStatus : Int!
	var orderStatusId : Int!
	var orderStatusManageId : Int!
	var orderType : Int!
	var orderTypeId : String!
	var scheduleOrderServerStartAt : String!
	var scheduleOrderStartAt : String!
	var scheduleOrderStartAt2 : String!
	var storeDetail : StoreDetail!
	var storeId : String!
	var storeNotify : Int!
	var timezone : String!
	var total : Double!
	var uniqueId : Int!
	var updatedAt : String!
	var userDetail : UserDetailNew!
	var userOrderChange : Bool!
    var destinationAddresses : [Address]!

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		v = dictionary["__v"] as? Int
        //API changes
        //RequestDetail model Order_id is _id
        
		id = dictionary["_id"] as? String
        if dictionary["_id"] != nil{
            id = dictionary["_id"] as? String ?? ""
        }else if dictionary["order_id"] != nil{
            id = dictionary["order_id"] as? String ?? ""
        }else{
            id = ""
        }
        
		cancelReason = dictionary["cancel_reason"] as? String
		cartId = dictionary["cart_id"] as? String
		cityId = dictionary["city_id"] as? String
		completedAt = dictionary["completed_at"] as? String
		completedDateInCityTimezone = dictionary["completed_date_in_city_timezone"] as? AnyObject
		completedDateTag = dictionary["completed_date_tag"] as? String
		confirmationCodeForCompleteDelivery = dictionary["confirmation_code_for_complete_delivery"] as? Int
		confirmationCodeForPickUpDelivery = dictionary["confirmation_code_for_pick_up_delivery"] as? Int
		countryId = dictionary["country_id"] as? String
		createdAt = dictionary["created_at"] as? String
		dateTime = [DateTime]()
		if let dateTimeArray = dictionary["date_time"] as? [[String:Any]]{
			for dic in dateTimeArray{
				let value = DateTime(fromDictionary: dic)
				dateTime.append(value)
			}
		}
		deliveryType = dictionary["delivery_type"] as? Int
		imageUrl = dictionary["image_url"] as? [AnyObject]
		isAllowContactlessDelivery = dictionary["is_allow_contactless_delivery"] as? Bool
		isPaidFromWallet = dictionary["is_paid_from_wallet"] as? Bool
		isPaymentModeCash = dictionary["is_payment_mode_cash"] as? Bool
		isProviderRatedToStore = dictionary["is_provider_rated_to_store"] as? Bool
		isProviderRatedToUser = dictionary["is_provider_rated_to_user"] as? Bool
		isProviderShowInvoice = dictionary["is_provider_show_invoice"] as? Bool
		isScheduleOrder = dictionary["is_schedule_order"] as? Bool ?? false
		isScheduleOrderInformedToStore = dictionary["is_schedule_order_informed_to_store"] as? Bool
		isStoreRatedToProvider = dictionary["is_store_rated_to_provider"] as? Bool
		isStoreRatedToUser = dictionary["is_store_rated_to_user"] as? Bool
		isUserPickUpOrder = dictionary["is_user_pick_up_order"] as? Bool
		isUserRatedToProvider = dictionary["is_user_rated_to_provider"] as? Bool
		isUserRatedToStore = dictionary["is_user_rated_to_store"] as? Bool
		isUserShowInvoice = dictionary["is_user_show_invoice"] as? Bool
		orderChange = dictionary["order_change"] as? Bool
		orderPaymentId = dictionary["order_payment_id"] as? String
		orderStatus = dictionary["order_status"] as? Int
		orderStatusId = dictionary["order_status_id"] as? Int
		orderStatusManageId = dictionary["order_status_manage_id"] as? Int
		orderType = dictionary["order_type"] as? Int
		orderTypeId = dictionary["order_type_id"] as? String
		scheduleOrderServerStartAt = dictionary["schedule_order_server_start_at"] as? String
		scheduleOrderStartAt = dictionary["schedule_order_start_at"] as? String ?? ""
		scheduleOrderStartAt2 = dictionary["schedule_order_start_at2"] as? String ?? ""
		if let storeDetailData = dictionary["store_detail"] as? [String:Any]{
			storeDetail = StoreDetail(fromDictionary: storeDetailData)
		}
		storeId = dictionary["store_id"] as? String
		storeNotify = dictionary["store_notify"] as? Int
		timezone = dictionary["timezone"] as? String
        total = dictionary["total"] as? Double ?? 0.0
        //API changes
		uniqueId = dictionary["unique_id"] as? Int
		updatedAt = dictionary["updated_at"] as? String
        if dictionary["user_detail"] != nil{
            if isNotNSNull(object: dictionary["store_detail"] as AnyObject){
                if let userDetailData = dictionary["user_detail"] as? [String:Any]{
                    userDetail = UserDetailNew(fromDictionary: userDetailData)
                }
            }else{
                userDetail = UserDetailNew(fromDictionary: [:])
            }
        }else{
            userDetail = UserDetailNew(fromDictionary: [:])
        }
		userOrderChange = dictionary["user_order_change"] as? Bool
        destinationAddresses = [Address]()
        if let destinationAddressesArray = dictionary["destination_addresses"] as? [[String:Any]]{
            for dic in destinationAddressesArray{
                let value = Address(fromDictionary: dic)
                destinationAddresses.append(value)
            }
        }
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if v != nil{
			dictionary["__v"] = v
		}
		if id != nil{
			dictionary["_id"] = id
		}
		if cancelReason != nil{
			dictionary["cancel_reason"] = cancelReason
		}
		if cartId != nil{
			dictionary["cart_id"] = cartId
		}
		if cityId != nil{
			dictionary["city_id"] = cityId
		}
		if completedAt != nil{
			dictionary["completed_at"] = completedAt
		}
		if completedDateInCityTimezone != nil{
			dictionary["completed_date_in_city_timezone"] = completedDateInCityTimezone
		}
		if completedDateTag != nil{
			dictionary["completed_date_tag"] = completedDateTag
		}
		if confirmationCodeForCompleteDelivery != nil{
			dictionary["confirmation_code_for_complete_delivery"] = confirmationCodeForCompleteDelivery
		}
		if confirmationCodeForPickUpDelivery != nil{
			dictionary["confirmation_code_for_pick_up_delivery"] = confirmationCodeForPickUpDelivery
		}
		if countryId != nil{
			dictionary["country_id"] = countryId
		}
		if createdAt != nil{
			dictionary["created_at"] = createdAt
		}
		if dateTime != nil{
			var dictionaryElements = [[String:Any]]()
			for dateTimeElement in dateTime {
				dictionaryElements.append(dateTimeElement.toDictionary())
			}
			dictionary["date_time"] = dictionaryElements
		}
		if deliveryType != nil{
			dictionary["delivery_type"] = deliveryType
		}
		if imageUrl != nil{
			dictionary["image_url"] = imageUrl
		}
		if isAllowContactlessDelivery != nil{
			dictionary["is_allow_contactless_delivery"] = isAllowContactlessDelivery
		}
		if isPaidFromWallet != nil{
			dictionary["is_paid_from_wallet"] = isPaidFromWallet
		}
		if isPaymentModeCash != nil{
			dictionary["is_payment_mode_cash"] = isPaymentModeCash
		}
		if isProviderRatedToStore != nil{
			dictionary["is_provider_rated_to_store"] = isProviderRatedToStore
		}
		if isProviderRatedToUser != nil{
			dictionary["is_provider_rated_to_user"] = isProviderRatedToUser
		}
		if isProviderShowInvoice != nil{
			dictionary["is_provider_show_invoice"] = isProviderShowInvoice
		}
		if isScheduleOrder != nil{
			dictionary["is_schedule_order"] = isScheduleOrder
		}
		if isScheduleOrderInformedToStore != nil{
			dictionary["is_schedule_order_informed_to_store"] = isScheduleOrderInformedToStore
		}
		if isStoreRatedToProvider != nil{
			dictionary["is_store_rated_to_provider"] = isStoreRatedToProvider
		}
		if isStoreRatedToUser != nil{
			dictionary["is_store_rated_to_user"] = isStoreRatedToUser
		}
		if isUserPickUpOrder != nil{
			dictionary["is_user_pick_up_order"] = isUserPickUpOrder
		}
		if isUserRatedToProvider != nil{
			dictionary["is_user_rated_to_provider"] = isUserRatedToProvider
		}
		if isUserRatedToStore != nil{
			dictionary["is_user_rated_to_store"] = isUserRatedToStore
		}
		if isUserShowInvoice != nil{
			dictionary["is_user_show_invoice"] = isUserShowInvoice
		}
		if orderChange != nil{
			dictionary["order_change"] = orderChange
		}
		if orderPaymentId != nil{
			dictionary["order_payment_id"] = orderPaymentId
		}
		if orderStatus != nil{
			dictionary["order_status"] = orderStatus
		}
		if orderStatusId != nil{
			dictionary["order_status_id"] = orderStatusId
		}
		if orderStatusManageId != nil{
			dictionary["order_status_manage_id"] = orderStatusManageId
		}
		if orderType != nil{
			dictionary["order_type"] = orderType
		}
		if orderTypeId != nil{
			dictionary["order_type_id"] = orderTypeId
		}
		if scheduleOrderServerStartAt != nil{
			dictionary["schedule_order_server_start_at"] = scheduleOrderServerStartAt
		}
		if scheduleOrderStartAt != nil{
			dictionary["schedule_order_start_at"] = scheduleOrderStartAt
		}
		if scheduleOrderStartAt2 != nil{
			dictionary["schedule_order_start_at2"] = scheduleOrderStartAt2
		}
		if storeDetail != nil{
			dictionary["store_detail"] = storeDetail.toDictionary()
		}
		if storeId != nil{
			dictionary["store_id"] = storeId
		}
		if storeNotify != nil{
			dictionary["store_notify"] = storeNotify
		}
		if timezone != nil{
			dictionary["timezone"] = timezone
		}
		if total != nil{
			dictionary["total"] = total
		}
		if uniqueId != nil{
			dictionary["unique_id"] = uniqueId
		}
		if updatedAt != nil{
			dictionary["updated_at"] = updatedAt
		}
		if userDetail != nil{
			dictionary["user_detail"] = userDetail.toDictionary()
		}
		if userOrderChange != nil{
			dictionary["user_order_change"] = userOrderChange
		}
        if destinationAddresses != nil{
            var dictionaryElements = [[String:Any]]()
            for destinationAddressesElement in destinationAddresses {
                dictionaryElements.append(destinationAddressesElement.toDictionary())
            }
            dictionary["destination_addresses"] = dictionaryElements
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
        v = aDecoder.decodeObject(forKey: "__v") as? Int
        id = aDecoder.decodeObject(forKey: "_id") as? String
        cancelReason = aDecoder.decodeObject(forKey: "cancel_reason") as? String
        cartId = aDecoder.decodeObject(forKey: "cart_id") as? String
        cityId = aDecoder.decodeObject(forKey: "city_id") as? String
        completedAt = aDecoder.decodeObject(forKey: "completed_at") as? String
        completedDateInCityTimezone = aDecoder.decodeObject(forKey: "completed_date_in_city_timezone") as? AnyObject
        completedDateTag = aDecoder.decodeObject(forKey: "completed_date_tag") as? String
        confirmationCodeForCompleteDelivery = aDecoder.decodeObject(forKey: "confirmation_code_for_complete_delivery") as? Int
        confirmationCodeForPickUpDelivery = aDecoder.decodeObject(forKey: "confirmation_code_for_pick_up_delivery") as? Int
        countryId = aDecoder.decodeObject(forKey: "country_id") as? String
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        dateTime = aDecoder.decodeObject(forKey :"date_time") as? [DateTime]
        deliveryType = aDecoder.decodeObject(forKey: "delivery_type") as? Int
        imageUrl = aDecoder.decodeObject(forKey: "image_url") as? [AnyObject]
        isAllowContactlessDelivery = aDecoder.decodeObject(forKey: "is_allow_contactless_delivery") as? Bool
        isPaidFromWallet = aDecoder.decodeObject(forKey: "is_paid_from_wallet") as? Bool
        isPaymentModeCash = aDecoder.decodeObject(forKey: "is_payment_mode_cash") as? Bool
        isProviderRatedToStore = aDecoder.decodeObject(forKey: "is_provider_rated_to_store") as? Bool
        isProviderRatedToUser = aDecoder.decodeObject(forKey: "is_provider_rated_to_user") as? Bool
        isProviderShowInvoice = aDecoder.decodeObject(forKey: "is_provider_show_invoice") as? Bool
        isScheduleOrder = aDecoder.decodeObject(forKey: "is_schedule_order") as? Bool
        isScheduleOrderInformedToStore = aDecoder.decodeObject(forKey: "is_schedule_order_informed_to_store") as? Bool
        isStoreRatedToProvider = aDecoder.decodeObject(forKey: "is_store_rated_to_provider") as? Bool
        isStoreRatedToUser = aDecoder.decodeObject(forKey: "is_store_rated_to_user") as? Bool
        isUserPickUpOrder = aDecoder.decodeObject(forKey: "is_user_pick_up_order") as? Bool
        isUserRatedToProvider = aDecoder.decodeObject(forKey: "is_user_rated_to_provider") as? Bool
        isUserRatedToStore = aDecoder.decodeObject(forKey: "is_user_rated_to_store") as? Bool
        isUserShowInvoice = aDecoder.decodeObject(forKey: "is_user_show_invoice") as? Bool
        orderChange = aDecoder.decodeObject(forKey: "order_change") as? Bool
        orderPaymentId = aDecoder.decodeObject(forKey: "order_payment_id") as? String
        orderStatus = aDecoder.decodeObject(forKey: "order_status") as? Int
        orderStatusId = aDecoder.decodeObject(forKey: "order_status_id") as? Int
        orderStatusManageId = aDecoder.decodeObject(forKey: "order_status_manage_id") as? Int
        orderType = aDecoder.decodeObject(forKey: "order_type") as? Int
        orderTypeId = aDecoder.decodeObject(forKey: "order_type_id") as? String
        scheduleOrderServerStartAt = aDecoder.decodeObject(forKey: "schedule_order_server_start_at") as? String
        scheduleOrderStartAt = aDecoder.decodeObject(forKey: "schedule_order_start_at") as? String
        scheduleOrderStartAt2 = aDecoder.decodeObject(forKey: "schedule_order_start_at2") as? String
        storeDetail = aDecoder.decodeObject(forKey: "store_detail") as? StoreDetail
        storeId = aDecoder.decodeObject(forKey: "store_id") as? String
        storeNotify = aDecoder.decodeObject(forKey: "store_notify") as? Int
        timezone = aDecoder.decodeObject(forKey: "timezone") as? String
        total = aDecoder.decodeObject(forKey: "total") as? Double
        uniqueId = aDecoder.decodeObject(forKey: "unique_id") as? Int
        updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? String
        userDetail = aDecoder.decodeObject(forKey: "user_detail") as? UserDetailNew
        userOrderChange = aDecoder.decodeObject(forKey: "user_order_change") as? Bool
        destinationAddresses = aDecoder.decodeObject(forKey: "destination_addresses") as? [Address]
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if v != nil{
			aCoder.encode(v, forKey: "__v")
		}
		if id != nil{
			aCoder.encode(id, forKey: "_id")
		}
		if cancelReason != nil{
			aCoder.encode(cancelReason, forKey: "cancel_reason")
		}
		if cartId != nil{
			aCoder.encode(cartId, forKey: "cart_id")
		}
		if cityId != nil{
			aCoder.encode(cityId, forKey: "city_id")
		}
		if completedAt != nil{
			aCoder.encode(completedAt, forKey: "completed_at")
		}
		if completedDateInCityTimezone != nil{
			aCoder.encode(completedDateInCityTimezone, forKey: "completed_date_in_city_timezone")
		}
		if completedDateTag != nil{
			aCoder.encode(completedDateTag, forKey: "completed_date_tag")
		}
		if confirmationCodeForCompleteDelivery != nil{
			aCoder.encode(confirmationCodeForCompleteDelivery, forKey: "confirmation_code_for_complete_delivery")
		}
		if confirmationCodeForPickUpDelivery != nil{
			aCoder.encode(confirmationCodeForPickUpDelivery, forKey: "confirmation_code_for_pick_up_delivery")
		}
		if countryId != nil{
			aCoder.encode(countryId, forKey: "country_id")
		}
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "created_at")
		}
		if dateTime != nil{
			aCoder.encode(dateTime, forKey: "date_time")
		}
		if deliveryType != nil{
			aCoder.encode(deliveryType, forKey: "delivery_type")
		}
		if imageUrl != nil{
			aCoder.encode(imageUrl, forKey: "image_url")
		}
		if isAllowContactlessDelivery != nil{
			aCoder.encode(isAllowContactlessDelivery, forKey: "is_allow_contactless_delivery")
		}
		if isPaidFromWallet != nil{
			aCoder.encode(isPaidFromWallet, forKey: "is_paid_from_wallet")
		}
		if isPaymentModeCash != nil{
			aCoder.encode(isPaymentModeCash, forKey: "is_payment_mode_cash")
		}
		if isProviderRatedToStore != nil{
			aCoder.encode(isProviderRatedToStore, forKey: "is_provider_rated_to_store")
		}
		if isProviderRatedToUser != nil{
			aCoder.encode(isProviderRatedToUser, forKey: "is_provider_rated_to_user")
		}
		if isProviderShowInvoice != nil{
			aCoder.encode(isProviderShowInvoice, forKey: "is_provider_show_invoice")
		}
		if isScheduleOrder != nil{
			aCoder.encode(isScheduleOrder, forKey: "is_schedule_order")
		}
		if isScheduleOrderInformedToStore != nil{
			aCoder.encode(isScheduleOrderInformedToStore, forKey: "is_schedule_order_informed_to_store")
		}
		if isStoreRatedToProvider != nil{
			aCoder.encode(isStoreRatedToProvider, forKey: "is_store_rated_to_provider")
		}
		if isStoreRatedToUser != nil{
			aCoder.encode(isStoreRatedToUser, forKey: "is_store_rated_to_user")
		}
		if isUserPickUpOrder != nil{
			aCoder.encode(isUserPickUpOrder, forKey: "is_user_pick_up_order")
		}
		if isUserRatedToProvider != nil{
			aCoder.encode(isUserRatedToProvider, forKey: "is_user_rated_to_provider")
		}
		if isUserRatedToStore != nil{
			aCoder.encode(isUserRatedToStore, forKey: "is_user_rated_to_store")
		}
		if isUserShowInvoice != nil{
			aCoder.encode(isUserShowInvoice, forKey: "is_user_show_invoice")
		}
		if orderChange != nil{
			aCoder.encode(orderChange, forKey: "order_change")
		}
		if orderPaymentId != nil{
			aCoder.encode(orderPaymentId, forKey: "order_payment_id")
		}
		if orderStatus != nil{
			aCoder.encode(orderStatus, forKey: "order_status")
		}
		if orderStatusId != nil{
			aCoder.encode(orderStatusId, forKey: "order_status_id")
		}
		if orderStatusManageId != nil{
			aCoder.encode(orderStatusManageId, forKey: "order_status_manage_id")
		}
		if orderType != nil{
			aCoder.encode(orderType, forKey: "order_type")
		}
		if orderTypeId != nil{
			aCoder.encode(orderTypeId, forKey: "order_type_id")
		}
		if scheduleOrderServerStartAt != nil{
			aCoder.encode(scheduleOrderServerStartAt, forKey: "schedule_order_server_start_at")
		}
		if scheduleOrderStartAt != nil{
			aCoder.encode(scheduleOrderStartAt, forKey: "schedule_order_start_at")
		}
		if scheduleOrderStartAt2 != nil{
			aCoder.encode(scheduleOrderStartAt2, forKey: "schedule_order_start_at2")
		}
		if storeDetail != nil{
			aCoder.encode(storeDetail, forKey: "store_detail")
		}
		if storeId != nil{
			aCoder.encode(storeId, forKey: "store_id")
		}
		if storeNotify != nil{
			aCoder.encode(storeNotify, forKey: "store_notify")
		}
		if timezone != nil{
			aCoder.encode(timezone, forKey: "timezone")
		}
		if total != nil{
			aCoder.encode(total, forKey: "total")
		}
		if uniqueId != nil{
			aCoder.encode(uniqueId, forKey: "unique_id")
		}
		if updatedAt != nil{
			aCoder.encode(updatedAt, forKey: "updated_at")
		}
		if userDetail != nil{
			aCoder.encode(userDetail, forKey: "user_detail")
		}
		if userOrderChange != nil{
			aCoder.encode(userOrderChange, forKey: "user_order_change")
		}
        if destinationAddresses != nil{
            aCoder.encode(destinationAddresses, forKey: "destination_addresses")
        }
	}
}

func isNotNSNull(object:AnyObject) -> Bool {
    return object.classForCoder != NSNull.classForCoder()
}
