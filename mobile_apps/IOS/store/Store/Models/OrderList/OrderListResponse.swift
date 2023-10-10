//
//	OrderListResponse.swift
//
//	Create by Jaydeep Vyas on 10/8/2017
//	Copyright © 2017 Elluminati. All rights reserved.


import Foundation

class OrderListResponse{

	var message : Int!
	var orders : [Order]!
    var adminVehicles:[VehicleDetail];
    var vehicles:[VehicleDetail];
    var success : Bool!
//    var orderPaymentDetail : OrderPayment!
    
    var requests : [Requests]!

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		message = dictionary["message"] as? Int
		orders = [Order]()
		if let ordersArray = dictionary["requests"] as? [[String:Any]]{
			for dic in ordersArray{
				let value = Order(fromDictionary: dic)
				orders.append(value)
			}
		}
        if let ordersArray = dictionary["orders"] as? [[String:Any]]{
            for dic in ordersArray{
                let value = Order(fromDictionary: dic)
                orders.append(value)
            }
        }
       
        vehicles = [VehicleDetail]()
        if let vehicleArray = dictionary["vehicles"] as? [[String:Any]]{
            for dic in vehicleArray{
                let value = VehicleDetail(fromDictionary: dic)
                vehicles.append(value)
            }
        }
        
        adminVehicles = [VehicleDetail]()
        if let vehicleArray = dictionary["admin_vehicles"] as? [[String:Any]]{
            for dic in vehicleArray{
                let value = VehicleDetail(fromDictionary: dic)
                adminVehicles.append(value)
            }
        }
        
//        if let orderPaymentDetail = dictionary["order_payment_detail"] as? [String:Any] {
//         self.orderPaymentDetail = OrderPayment.init(fromDictionary: orderPaymentDetail)
//        }
		success = dictionary["success"] as? Bool
        
        requests = [Requests]()
        if let requestsArray = dictionary["requests"] as? [[String:Any]]{
            for dic in requestsArray{
                let value = Requests(fromDictionary: dic)
                requests.append(value)
            }
        }

	}

}
