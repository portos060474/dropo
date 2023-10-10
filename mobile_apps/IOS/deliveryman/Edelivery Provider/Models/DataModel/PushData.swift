//
//	PushData1.swift
//
//	Create by Elluminati on 15/7/2017
//	Copyright © 2017 Elluminati. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class PushOrderData {
    var createdAt : String!
    var destinationAddresses : [Address]!
    var pickupAddresses : [Address]!
    var orderId : String!
    var storeImage : String!
    var storeName : String!
    var orderCount: Int!
    var unique_id:Int!
    var orderUniqueId:Int!
    var currency:String!
    var estimateTime:String!
    var orderPrice:Double!
    var providerIncome:Double!
    var total:Double!
    var deliveryType: Int!
    var is_schedule_order:Bool!

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */

    init(fromDictionary dictionary: [String:Any]) {
        createdAt = dictionary["created_at"] as? String
        orderId = dictionary["request_id"] as? String
        storeImage = dictionary["store_image"] as? String
        storeName = dictionary["store_name"] as? String
        orderCount = (dictionary["request_count"] as? Int) ?? 0
        unique_id = (dictionary["unique_id"] as? Int) ?? 0
        currency = (dictionary["currency"] as? String) ?? ""
        estimateTime = (dictionary["estimated_time_for_ready_order"] as? String) ?? ""
        orderPrice = (dictionary["total_order_price"] as? Double)?.roundTo() ?? 0.0
        total = (dictionary["total"] as? Double)?.roundTo() ?? 0.0
        deliveryType = (dictionary["delivery_type"] as? Int) ?? 0
        providerIncome = (dictionary["total_provider_income"] as? Double)?.roundTo() ?? 0.0
        currency = (dictionary["currency"] as? String) ?? ""
        orderUniqueId = (dictionary["order_unique_id"] as? Int) ?? 0
        pickupAddresses = [Address]()
        if let pickupAddressesArray = dictionary["pickup_addresses"] as? [[String:Any]] {
            for dic in pickupAddressesArray {
                let value = Address(fromDictionary: dic)
                pickupAddresses.append(value)
            }
        }
        destinationAddresses = [Address]()
        if let destinationAddressesArray = dictionary["destination_addresses"] as? [[String:Any]] {
            for dic in destinationAddressesArray {
                let value = Address(fromDictionary: dic)
                destinationAddresses.append(value)
            }
        }
        is_schedule_order = (dictionary["is_schedule_order"] as? Bool) ?? false
    }
}
