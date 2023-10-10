//
//    RequestDetail.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class RequestDetailNew : NSObject, NSCoding{

    var v : Int!
    var id : String!
    var cancelReasons : [String]!
    var cityId : String!
    var completedAt : AnyObject!
    var completedDateInCityTimezone : AnyObject!
    var completedDateTag : String!
    var confirmationCodeForCompleteDelivery : Int!
    var confirmationCodeForPickUpDelivery : Int!
    var countryId : String!
    var createdAt : String!
    var currentProvider : String!
    var dateTime : [DateTime]!
    var deliveryStatus : Int!
    var deliveryStatusBy : AnyObject!
    var deliveryStatusManageId : Int!
    var deliveryType : Int!
    var destinationAddresses : [Address]!
    var estimatedTimeForDeliveryInMin : Int!
    var isForcedAssigned : Bool!
    var manualProviderId : String!
    var orders : [Order]!
    var pickupAddresses : [Address]!
    var providerDetail : OrderProviderDetail!
    var providerId : String!
    var providerLocation : [Double]!
    var providerPreviousLocation : [Double]!
    var providerType : Int!
    var providerTypeId : AnyObject!
    var providerUniqueId : Int!
    var providersIdThatRejectedOrderRequest : [AnyObject]!
    var requestType : Int!
    var requestTypeId : String!
    var storeDetail : StoreDetail!
    var timezone : String!
    var uniqueId : Int!
    var updatedAt : String!
    var userDetail : UserDetailNew!
    var userId : String!
    var userUniqueId : Int!
    var vehicleId : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        v = dictionary["__v"] as? Int
        id = dictionary["_id"] as? String
        cancelReasons = dictionary["cancel_reasons"] as? [String]
        cityId = dictionary["city_id"] as? String
        completedAt = dictionary["completed_at"] as? AnyObject
        completedDateInCityTimezone = dictionary["completed_date_in_city_timezone"] as? AnyObject
        completedDateTag = dictionary["completed_date_tag"] as? String
        confirmationCodeForCompleteDelivery = dictionary["confirmation_code_for_complete_delivery"] as? Int
        confirmationCodeForPickUpDelivery = dictionary["confirmation_code_for_pick_up_delivery"] as? Int
        countryId = dictionary["country_id"] as? String
        createdAt = dictionary["created_at"] as? String
        currentProvider = dictionary["current_provider"] as? String
        dateTime = [DateTime]()
        if let dateTimeArray = dictionary["date_time"] as? [[String:Any]]{
            for dic in dateTimeArray{
                let value = DateTime(fromDictionary: dic)
                dateTime.append(value)
            }
        }
        deliveryStatus = dictionary["delivery_status"] as? Int
        deliveryStatusBy = dictionary["delivery_status_by"] as? AnyObject
        deliveryStatusManageId = dictionary["delivery_status_manage_id"] as? Int
        deliveryType = dictionary["delivery_type"] as? Int
        destinationAddresses = [Address]()
        if let destinationAddressesArray = dictionary["destination_addresses"] as? [[String:Any]]{
            for dic in destinationAddressesArray{
                let value = Address(fromDictionary: dic)
                destinationAddresses.append(value)
            }
        }
        estimatedTimeForDeliveryInMin = dictionary["estimated_time_for_delivery_in_min"] as? Int
        isForcedAssigned = dictionary["is_forced_assigned"] as? Bool
        manualProviderId = dictionary["manual_provider_id"] as? String
        orders = [Order]()
        if let ordersArray = dictionary["orders"] as? [[String:Any]]{
            for dic in ordersArray{
                let value = Order(fromDictionary: dic)
                orders.append(value)
            }
        }
        pickupAddresses = [Address]()
        if let pickupAddressesArray = dictionary["pickup_addresses"] as? [[String:Any]]{
            for dic in pickupAddressesArray{
                let value = Address(fromDictionary: dic)
                pickupAddresses.append(value)
            }
        }
        if let providerDetailData = dictionary["provider_detail"] as? [String:Any]{
            providerDetail = OrderProviderDetail(fromDictionary: providerDetailData)
        }
        providerId = dictionary["provider_id"] as? String
        providerLocation = (dictionary["provider_location"] as? [Double]) ?? [0.0,0.0];
        if providerLocation.isEmpty {
            providerLocation = [0.0,0.0]
        }
        providerPreviousLocation = (dictionary["provider_previous_location"] as? [Double]) ?? [0.0,0.0];
        providerType = dictionary["provider_type"] as? Int
        providerTypeId = dictionary["provider_type_id"] as? AnyObject
        providerUniqueId = dictionary["provider_unique_id"] as? Int
        providersIdThatRejectedOrderRequest = dictionary["providers_id_that_rejected_order_request"] as? [AnyObject]
        requestType = dictionary["request_type"] as? Int
        requestTypeId = dictionary["request_type_id"] as? String
        if let storeDetailData = dictionary["store_detail"] as? [String:Any]{
            storeDetail = StoreDetail(fromDictionary: storeDetailData)
        }
        timezone = dictionary["timezone"] as? String
        uniqueId = dictionary["unique_id"] as? Int
        updatedAt = dictionary["updated_at"] as? String
        if let userDetailData = dictionary["user_detail"] as? [String:Any]{
            userDetail = UserDetailNew(fromDictionary: userDetailData)
        }
        userId = dictionary["user_id"] as? String
        userUniqueId = dictionary["user_unique_id"] as? Int
        vehicleId = dictionary["vehicle_id"] as? String
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
        if cancelReasons != nil{
            dictionary["cancel_reasons"] = cancelReasons
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
        if currentProvider != nil{
            dictionary["current_provider"] = currentProvider
        }
        if dateTime != nil{
            var dictionaryElements = [[String:Any]]()
            for dateTimeElement in dateTime {
                dictionaryElements.append(dateTimeElement.toDictionary())
            }
            dictionary["date_time"] = dictionaryElements
        }
        if deliveryStatus != nil{
            dictionary["delivery_status"] = deliveryStatus
        }
        if deliveryStatusBy != nil{
            dictionary["delivery_status_by"] = deliveryStatusBy
        }
        if deliveryStatusManageId != nil{
            dictionary["delivery_status_manage_id"] = deliveryStatusManageId
        }
        if deliveryType != nil{
            dictionary["delivery_type"] = deliveryType
        }
        if destinationAddresses != nil{
            var dictionaryElements = [[String:Any]]()
            for destinationAddressesElement in destinationAddresses {
                dictionaryElements.append(destinationAddressesElement.toDictionary())
            }
            dictionary["destination_addresses"] = dictionaryElements
        }
        if estimatedTimeForDeliveryInMin != nil{
            dictionary["estimated_time_for_delivery_in_min"] = estimatedTimeForDeliveryInMin
        }
        if isForcedAssigned != nil{
            dictionary["is_forced_assigned"] = isForcedAssigned
        }
        if manualProviderId != nil{
            dictionary["manual_provider_id"] = manualProviderId
        }
//        if orders != nil{
//            var dictionaryElements = [[String:Any]]()
//            for ordersElement in orders {
//                dictionaryElements.append(ordersElement.toDictionary())
//            }
//            dictionary["orders"] = dictionaryElements
//        }
        if pickupAddresses != nil{
            var dictionaryElements = [[String:Any]]()
            for pickupAddressesElement in pickupAddresses {
                dictionaryElements.append(pickupAddressesElement.toDictionary())
            }
            dictionary["pickup_addresses"] = dictionaryElements
        }
//        if providerDetail != nil{
//            dictionary["provider_detail"] = providerDetail.toDictionary()
//        }
        if providerId != nil{
            dictionary["provider_id"] = providerId
        }
        if providerLocation != nil{
            dictionary["provider_location"] = providerLocation
        }
        if providerPreviousLocation != nil{
            dictionary["provider_previous_location"] = providerPreviousLocation
        }
        if providerType != nil{
            dictionary["provider_type"] = providerType
        }
        if providerTypeId != nil{
            dictionary["provider_type_id"] = providerTypeId
        }
        if providerUniqueId != nil{
            dictionary["provider_unique_id"] = providerUniqueId
        }
        if providersIdThatRejectedOrderRequest != nil{
            dictionary["providers_id_that_rejected_order_request"] = providersIdThatRejectedOrderRequest
        }
        if requestType != nil{
            dictionary["request_type"] = requestType
        }
        if requestTypeId != nil{
            dictionary["request_type_id"] = requestTypeId
        }
        if storeDetail != nil{
            dictionary["store_detail"] = storeDetail.toDictionary()
        }
        if timezone != nil{
            dictionary["timezone"] = timezone
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
        if userId != nil{
            dictionary["user_id"] = userId
        }
        if userUniqueId != nil{
            dictionary["user_unique_id"] = userUniqueId
        }
        if vehicleId != nil{
            dictionary["vehicle_id"] = vehicleId
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
         cancelReasons = aDecoder.decodeObject(forKey: "cancel_reasons") as? [String]
         cityId = aDecoder.decodeObject(forKey: "city_id") as? String
         completedAt = aDecoder.decodeObject(forKey: "completed_at") as? AnyObject
         completedDateInCityTimezone = aDecoder.decodeObject(forKey: "completed_date_in_city_timezone") as? AnyObject
         completedDateTag = aDecoder.decodeObject(forKey: "completed_date_tag") as? String
         confirmationCodeForCompleteDelivery = aDecoder.decodeObject(forKey: "confirmation_code_for_complete_delivery") as? Int
         confirmationCodeForPickUpDelivery = aDecoder.decodeObject(forKey: "confirmation_code_for_pick_up_delivery") as? Int
         countryId = aDecoder.decodeObject(forKey: "country_id") as? String
         createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
         currentProvider = aDecoder.decodeObject(forKey: "current_provider") as? String
         dateTime = aDecoder.decodeObject(forKey :"date_time") as? [DateTime]
         deliveryStatus = aDecoder.decodeObject(forKey: "delivery_status") as? Int
         deliveryStatusBy = aDecoder.decodeObject(forKey: "delivery_status_by") as? AnyObject
         deliveryStatusManageId = aDecoder.decodeObject(forKey: "delivery_status_manage_id") as? Int
         deliveryType = aDecoder.decodeObject(forKey: "delivery_type") as? Int
         destinationAddresses = aDecoder.decodeObject(forKey :"destination_addresses") as? [Address]
         estimatedTimeForDeliveryInMin = aDecoder.decodeObject(forKey: "estimated_time_for_delivery_in_min") as? Int
         isForcedAssigned = aDecoder.decodeObject(forKey: "is_forced_assigned") as? Bool
         manualProviderId = aDecoder.decodeObject(forKey: "manual_provider_id") as? String
         orders = aDecoder.decodeObject(forKey :"orders") as? [Order]
         pickupAddresses = aDecoder.decodeObject(forKey :"pickup_addresses") as? [Address]
         providerDetail = aDecoder.decodeObject(forKey: "provider_detail") as? OrderProviderDetail
         providerId = aDecoder.decodeObject(forKey: "provider_id") as? String
         providerLocation = (aDecoder.decodeObject(forKey: "provider_id") as? [Double]) ?? [0.0,0.0]
         providerPreviousLocation = aDecoder.decodeObject(forKey: "provider_previous_location") as? [Double] ?? [0.0,0.0]
         providerType = aDecoder.decodeObject(forKey: "provider_type") as? Int
         providerTypeId = aDecoder.decodeObject(forKey: "provider_type_id") as? AnyObject
         providerUniqueId = aDecoder.decodeObject(forKey: "provider_unique_id") as? Int
         providersIdThatRejectedOrderRequest = aDecoder.decodeObject(forKey: "providers_id_that_rejected_order_request") as? [AnyObject]
         requestType = aDecoder.decodeObject(forKey: "request_type") as? Int
         requestTypeId = aDecoder.decodeObject(forKey: "request_type_id") as? String
         storeDetail = aDecoder.decodeObject(forKey: "store_detail") as? StoreDetail
         timezone = aDecoder.decodeObject(forKey: "timezone") as? String
         uniqueId = aDecoder.decodeObject(forKey: "unique_id") as? Int
         updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? String
         userDetail = aDecoder.decodeObject(forKey: "user_detail") as? UserDetailNew
         userId = aDecoder.decodeObject(forKey: "user_id") as? String
         userUniqueId = aDecoder.decodeObject(forKey: "user_unique_id") as? Int
         vehicleId = aDecoder.decodeObject(forKey: "vehicle_id") as? String

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
        if cancelReasons != nil{
            aCoder.encode(cancelReasons, forKey: "cancel_reasons")
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
        if currentProvider != nil{
            aCoder.encode(currentProvider, forKey: "current_provider")
        }
        if dateTime != nil{
            aCoder.encode(dateTime, forKey: "date_time")
        }
        if deliveryStatus != nil{
            aCoder.encode(deliveryStatus, forKey: "delivery_status")
        }
        if deliveryStatusBy != nil{
            aCoder.encode(deliveryStatusBy, forKey: "delivery_status_by")
        }
        if deliveryStatusManageId != nil{
            aCoder.encode(deliveryStatusManageId, forKey: "delivery_status_manage_id")
        }
        if deliveryType != nil{
            aCoder.encode(deliveryType, forKey: "delivery_type")
        }
        if destinationAddresses != nil{
            aCoder.encode(destinationAddresses, forKey: "destination_addresses")
        }
        if estimatedTimeForDeliveryInMin != nil{
            aCoder.encode(estimatedTimeForDeliveryInMin, forKey: "estimated_time_for_delivery_in_min")
        }
        if isForcedAssigned != nil{
            aCoder.encode(isForcedAssigned, forKey: "is_forced_assigned")
        }
        if manualProviderId != nil{
            aCoder.encode(manualProviderId, forKey: "manual_provider_id")
        }
        if orders != nil{
            aCoder.encode(orders, forKey: "orders")
        }
        if pickupAddresses != nil{
            aCoder.encode(pickupAddresses, forKey: "pickup_addresses")
        }
        if providerDetail != nil{
            aCoder.encode(providerDetail, forKey: "provider_detail")
        }
        if providerId != nil{
            aCoder.encode(providerId, forKey: "provider_id")
        }
        if providerLocation != nil{
            aCoder.encode(providerLocation, forKey: "provider_location")
        }
        if providerPreviousLocation != nil{
            aCoder.encode(providerPreviousLocation, forKey: "provider_previous_location")
        }
        if providerType != nil{
            aCoder.encode(providerType, forKey: "provider_type")
        }
        if providerTypeId != nil{
            aCoder.encode(providerTypeId, forKey: "provider_type_id")
        }
        if providerUniqueId != nil{
            aCoder.encode(providerUniqueId, forKey: "provider_unique_id")
        }
        if providersIdThatRejectedOrderRequest != nil{
            aCoder.encode(providersIdThatRejectedOrderRequest, forKey: "providers_id_that_rejected_order_request")
        }
        if requestType != nil{
            aCoder.encode(requestType, forKey: "request_type")
        }
        if requestTypeId != nil{
            aCoder.encode(requestTypeId, forKey: "request_type_id")
        }
        if storeDetail != nil{
            aCoder.encode(storeDetail, forKey: "store_detail")
        }
        if timezone != nil{
            aCoder.encode(timezone, forKey: "timezone")
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
        if userId != nil{
            aCoder.encode(userId, forKey: "user_id")
        }
        if userUniqueId != nil{
            aCoder.encode(userUniqueId, forKey: "user_unique_id")
        }
        if vehicleId != nil{
            aCoder.encode(vehicleId, forKey: "vehicle_id")
        }

    }

}
