//
//	PushData1.swift
//
//	Create by Jaydeep Vyas on 15/7/2017
//	Copyright © 2017 Elluminati. All rights reserved.


import Foundation

class PushOrderData{

    var firstName : String!
    var isPaymentModeCash : Bool!
    var lastName : String!
    var orderCount : Int!
    var orderId : String!
    var totalOrderPrice : Double!
    var uniqueId : Int!
    var userImage : String!
    var currency :String!
    var destinationAddresses : [Address]!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        
        firstName = dictionary["first_name"] as? String ?? ""
        isPaymentModeCash = dictionary["is_payment_mode_cash"] as? Bool ?? false
        lastName = dictionary["last_name"] as? String ?? ""
        orderCount = dictionary["order_count"] as? Int ?? 0
        orderId = dictionary["order_id"] as? String ?? ""
        totalOrderPrice = (dictionary["total_order_price"] as? Double)?.roundTo() ?? 0.0
        uniqueId = dictionary["unique_id"] as? Int ?? 0
        userImage = dictionary["user_image"] as? String ?? ""
        currency = (dictionary["currency"] as? String) ?? ""
        destinationAddresses = [Address]()
        if let destinationAddressesArray = dictionary["destination_addresses"] as? [[String:Any]]{
            for dic in destinationAddressesArray{
                let value = Address(fromDictionary: dic)
                destinationAddresses.append(value)
            }
        }
    }
    
}
