

import Foundation

public class OrderStatusResponse {
    
    var confirmationCodeForCompleteDelivery : Int!
    var confirmationCodeForPickUpDelivery: Int!
    
    var currency : String!
    var deliveryStatus : Int!
    var destinationAddresses : [Address]!
    var pickupAddresses : [Address]!
    var deliveryStatusDetails : [DeliveryStatusDetails]!
    var orderStatusDetails : [OrderStatusDetails]!
    
    var isConfirmationCodeRequiredAtCompleteDelivery : Bool!
    var isConfirmationCodeRequiredAtPickupDelivery: Bool!
    var isUserPickUpOrder : Bool!
    var message : Int!
    var orderCancellationCharge : Double!
    var orderStatus : Int!
    var providerCountryPhoneCode : String!
    var providerFirstName : String!
    var providerId : String!
    var providerImage : String!
    var providerLastName : String!
    var providerPhone : String!
    var requestId : String!
    var requestUniqueId : Int!
    var success : Bool!
    var uniqueId : Int!
    var userRate : Float!
    var estimatedTimeForDeliveryInMin:Double!
    var totalTime:Double!
    var orderChange:Bool = false
    var provider_detail : ProviderDetail?
    var storeId : String = ""
    var total_order_price:Double!
    var deliveryType:Int!
    var isScheduleOrder:Bool!

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init() {
    }
    
    init(fromDictionary dictionary: [String:Any]){
        confirmationCodeForCompleteDelivery = (dictionary["confirmation_code_for_complete_delivery"] as? Int) ?? 0
        confirmationCodeForPickUpDelivery = (dictionary["confirmation_code_for_pick_up_delivery"] as? Int) ?? 0
        currency = (dictionary["currency"] as? String) ?? ""
        deliveryStatus = (dictionary["delivery_status"] as? Int) ?? 0
        destinationAddresses = [Address]()
        if let destinationAddressesArray = dictionary["destination_addresses"] as? [[String:Any]]{
            for dic in destinationAddressesArray{
                let value = Address(fromDictionary: dic)
                destinationAddresses.append(value)
            }
        }
        pickupAddresses = [Address]()
        if let pickupAddressesArray = dictionary["pickup_addresses"] as? [[String:Any]]{
            for dic in pickupAddressesArray{
                let value = Address(fromDictionary: dic)
                pickupAddresses.append(value)
            }
        }
        if isNotNSNull(object: dictionary["provider_detail"] as AnyObject){
            if (dictionary["provider_detail"] != nil) { provider_detail = ProviderDetail(dictionary: dictionary["provider_detail"] as! NSDictionary) }
        }

        deliveryStatusDetails = [DeliveryStatusDetails]()
        if let deliveryStatusDetail = dictionary["delivery_status_details"] as? [[String:Any]] {
            for dic in deliveryStatusDetail{
                let value = DeliveryStatusDetails(fromDictionary: dic)
                deliveryStatusDetails.append(value)
            }
        }
        orderStatusDetails = [OrderStatusDetails]()
        if let orderStatusDetail = dictionary["order_status_details"] as? [[String:Any]] {
            for dic in orderStatusDetail{
                let value = OrderStatusDetails(fromDictionary: dic)
                orderStatusDetails.append(value)
            }
        }
        
        isConfirmationCodeRequiredAtCompleteDelivery =  (dictionary["is_confirmation_code_required_at_complete_delivery"] as? Bool) ?? false
        isConfirmationCodeRequiredAtPickupDelivery =  (dictionary["is_confirmation_code_required_at_pickup_delivery"] as? Bool) ?? false
        
        isUserPickUpOrder = (dictionary["is_user_pick_up_order"] as? Bool) ?? false
        message = (dictionary["message"] as? Int) ?? 0
        orderCancellationCharge = (dictionary["order_cancellation_charge"] as? Double)?.roundTo() ?? 0.0
        orderStatus = (dictionary["order_status"] as? Int) ?? 0
        providerCountryPhoneCode = (dictionary["provider_country_phone_code"] as? String ) ?? ""
        providerFirstName = (dictionary["provider_first_name"] as? String) ?? ""
        providerId = (dictionary["provider_id"] as? String) ?? ""
        providerImage = (dictionary["provider_image"] as? String) ?? ""
        providerLastName = (dictionary["provider_last_name"] as? String) ?? ""
        providerPhone = (dictionary["provider_phone"] as? String) ?? ""
        requestId = (dictionary["request_id"] as? String) ?? ""
        requestUniqueId = (dictionary["request_unique_id"] as? Int) ?? 0
        success = (dictionary["success"] as? Bool) ?? false
        uniqueId = (dictionary["unique_id"] as? Int) ?? 0
        userRate = (dictionary["user_rate"] as? Float) ?? 0.0
        
        estimatedTimeForDeliveryInMin = (dictionary["estimated_time_for_delivery_in_min"] as? Double) ?? 0.0
        totalTime =  (dictionary["total_time"] as? Double) ?? 0.0
        orderChange = dictionary["order_change"] as? Bool ?? false
        storeId = dictionary["store_id"] as? String ?? ""
        total_order_price =  (dictionary["total_order_price"] as? Double) ?? 0.0
        deliveryType = (dictionary["delivery_type"] as? Int) ?? 0
        isScheduleOrder = dictionary["is_schedule_order"] as? Bool ?? false
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any] {
        var dictionary = [String:Any]()
        if confirmationCodeForCompleteDelivery != nil{
            dictionary["confirmation_code_for_complete_delivery"] = confirmationCodeForCompleteDelivery
        }
        if currency != nil{
            dictionary["currency"] = currency
        }
        if deliveryStatus != nil{
            dictionary["delivery_status"] = deliveryStatus
        }
        if destinationAddresses != nil{
            var dictionaryElements = [[String:Any]]()
            for destinationAddressesElement in destinationAddresses {
                dictionaryElements.append(destinationAddressesElement.toDictionary())
            }
            dictionary["destination_addresses"] = dictionaryElements
        }
        if pickupAddresses != nil{
            var dictionaryElements = [[String:Any]]()
            for pickupAddressesElement in destinationAddresses {
                dictionaryElements.append(pickupAddressesElement.toDictionary())
            }
            dictionary["pickup_addresses"] = dictionaryElements
        }
        
        if orderStatusDetails != nil{
            var dictionaryElements = [[String:Any]]()
            for orderStatusDetail in orderStatusDetails {
                dictionaryElements.append(orderStatusDetail.toDictionary())
            }
            dictionary["destination_addresses"] = dictionaryElements
        }
        
        if deliveryStatusDetails != nil{
            var dictionaryElements = [[String:Any]]()
            for deliveryStatusDetail in deliveryStatusDetails {
                dictionaryElements.append(deliveryStatusDetail.toDictionary())
            }
            dictionary["destination_addresses"] = dictionaryElements
        }
        
        
        if isConfirmationCodeRequiredAtCompleteDelivery != nil{
            dictionary["is_confirmation_code_required_at_complete_delivery"] = isConfirmationCodeRequiredAtCompleteDelivery
        }
        if isUserPickUpOrder != nil{
            dictionary["is_user_pick_up_order"] = isUserPickUpOrder
        }
        if message != nil{
            dictionary["message"] = message
        }
        if orderCancellationCharge != nil{
            dictionary["order_cancellation_charge"] = orderCancellationCharge
        }
        if orderStatus != nil{
            dictionary["order_status"] = orderStatus
        }
        if providerCountryPhoneCode != nil{
            dictionary["provider_country_phone_code"] = providerCountryPhoneCode
        }
        if providerFirstName != nil{
            dictionary["provider_first_name"] = providerFirstName
        }
        if providerId != nil{
            dictionary["provider_id"] = providerId
        }
        if providerImage != nil{
            dictionary["provider_image"] = providerImage
        }
        if providerLastName != nil{
            dictionary["provider_last_name"] = providerLastName
        }
        if providerPhone != nil{
            dictionary["provider_phone"] = providerPhone
        }
        if requestId != nil{
            dictionary["request_id"] = requestId
        }
        if requestUniqueId != nil{
            dictionary["request_unique_id"] = requestUniqueId
        }
        if totalTime != nil{
            dictionary["total_time"] = requestUniqueId
        }
        if estimatedTimeForDeliveryInMin != nil{
            dictionary["estimated_time_for_delivery_in_min"] = estimatedTimeForDeliveryInMin
        }
        if success != nil{
            dictionary["success"] = success
        }
        if uniqueId != nil{
            dictionary["unique_id"] = uniqueId
        }
        if userRate != nil{
            dictionary["user_rate"] = userRate
        }
        if storeId != nil {
            dictionary["store_id"] = storeId
        }
        if deliveryType != nil{
            dictionary["delivery_type"] = deliveryType
        }
        if total_order_price != nil{
            dictionary["total_order_price"] = total_order_price
        }
        if isScheduleOrder != nil{
            dictionary["is_schedule_order"] = deliveryType
        }
        dictionary["order_change"] = orderChange
        return dictionary
    }
}

public class OrderStatusDetails {
    var date : String!
    var status:Int!
    var imageUrl:String = ""
    init(fromDictionary dictionary: [String:Any]) {
        date = (dictionary["date"] as? String) ?? ""
        status = (dictionary["status"] as? Int) ?? 0
        imageUrl = dictionary["image_url"] as? String ?? ""
    }
    
    func toDictionary() -> [String:Any] {
        var dictionary = [String:Any]()
        if date != nil{
            dictionary["date"] = date
        }
        if status != nil{
            dictionary["status"] = status
        }
        dictionary["image_url"] = imageUrl
        return dictionary
    }
}

public class DeliveryStatusDetails {
    var date : String!
    var status:Int!
    var imageUrl:String=""
    
    init(fromDictionary dictionary: [String:Any]) {
        date = (dictionary["date"] as? String) ?? ""
        status = (dictionary["status"] as? Int) ?? 0
        imageUrl = dictionary["image_url"] as? String ?? ""
    }
    
    func toDictionary() -> [String:Any] {
        var dictionary = [String:Any]()
        if date != nil{
            dictionary["date"] = date
        }
        if status != nil{
            dictionary["status"] = status
        }
        dictionary["image_url"] = imageUrl
        return dictionary
    }
}

public class OrderDateWiseStatusDetails {
    var date : String!
    var time : String!
    var status:Int!
    var imageUrl:String=""
    init(fromDictionary dictionary: [String:Any]) {
        date = (dictionary["date"] as? String) ?? ""
        status = (dictionary["status"] as? Int) ?? 0
        imageUrl = dictionary["image_url"] as? String ?? ""
    }
    
    func toDictionary() -> [String:Any] {
        var dictionary = [String:Any]()
        if date != nil{
            dictionary["date"] = date
        }
        if status != nil{
            dictionary["status"] = status
        }
        dictionary["image_url"] = imageUrl
        return dictionary
    }
}
