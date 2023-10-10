//
//	Order.swift
//
//	Create by Jaydeep Vyas on 11/8/2017
//	Copyright © 2017 Elluminati. All rights reserved.


import Foundation

class CurrentOrder{

	var id : String!
	var bearing : Int!
	var confirmationCodeForPickUpDelivery : Int!
	var createdAt : String!
	var currency : String!
	var currentProvider : String!
	var orderPaymentId : String!
	var orderStatus : Int!
    var deliveryStatus : Int!
    var requestId : String = ""
	var providerId : String = ""
	var providerLocation : [Double]!
	var serviceId : String!
	var totalOrderPrice : Int!
	var uniqueId : Int!
	var userId : String!
    var isConfirmationCodeRequiredAtPickupDelivery:Bool!
    var isConfirmationCodeRequiredAtCompleteDelivery:Bool!
    var confirmationCodeForCompleteDelivery: Int!
    var isUserPickupOrder:Bool!
    var destinationAddresses : [Address]!
    var pickupAddresses : [Address]!
    
	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		id = (dictionary["_id"] as? String) ?? ""
		bearing = (dictionary["bearing"] as? Int) ?? 0
        isConfirmationCodeRequiredAtPickupDelivery
        = (dictionary["is_confirmation_code_required_at_pickup_delivery"] as? Bool) ?? false
        requestId = (dictionary["request_id"] as? String) ?? ""
        isConfirmationCodeRequiredAtCompleteDelivery
            = (dictionary["is_confirmation_code_required_at_complete_delivery"] as? Bool) ?? false
        
		confirmationCodeForPickUpDelivery = (dictionary["confirmation_code_for_pick_up_delivery"] as? Int) ?? 0
        isUserPickupOrder = (dictionary["is_user_pick_up_order"] as? Bool) ?? false
        confirmationCodeForCompleteDelivery = (dictionary["confirmation_code_for_complete_delivery"] as? Int) ?? 0
        
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
        
        
		createdAt = dictionary["created_at"] as? String
		currency = (dictionary["currency"] as? String) ?? ""
		currentProvider = (dictionary["current_provider"] as? String) ?? ""
		orderPaymentId = dictionary["order_payment_id"] as? String
		orderStatus = (dictionary["order_status"] as? Int) ?? 0
		providerId = (dictionary["provider_id"] as? String) ?? ""
		providerLocation = (dictionary["provider_location"] as? [Double]) ?? [0.0,0.0]
		serviceId = (dictionary["service_id"] as? String) ?? ""
		totalOrderPrice = (dictionary["total_order_price"] as? Int) ?? 0
		uniqueId = (dictionary["unique_id"] as? Int) ?? 0
		userId = (dictionary["user_id"] as? String) ?? ""
        deliveryStatus =  (dictionary["delivery_status"] as? Int) ?? 0
	}

}
