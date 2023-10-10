//
//	OrderStatusResponse.swift
//
//	Create by Jaydeep Vyas on 11/8/2017
//	Copyright © 2017 Elluminati. All rights reserved.


import Foundation

class OrderStatusResponse {

	var message : Int!
	var order : CurrentOrder!
    var orderRequest : CurrentOrder!
	var providerDetail : OrderProviderDetail!
	var success : Bool!
    var vehicleDetail : VehicleDetail!
    
    
	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		message = dictionary["message"] as? Int
		if let orderData = dictionary["order"] as? [String:Any] {
			order = CurrentOrder(fromDictionary: orderData)
		}
        if let orderData = dictionary["request"] as? [String:Any] {
            orderRequest = CurrentOrder(fromDictionary: orderData)
        }
		if let providerDetailData = dictionary["provider_detail"] as? [String:Any]{
			providerDetail = OrderProviderDetail(fromDictionary: providerDetailData)
		}
        if let vehicleDetailData = dictionary["vehicle_detail"] as? [String:Any]{
            vehicleDetail = VehicleDetail(fromDictionary: vehicleDetailData)
        }
		success = dictionary["success"] as? Bool
	}

}
public class VehicleDetail{
    
    var descriptionField : String!
    var imageUrl : String!
    var isBusiness : Bool!
    var mapPinImageUrl : String!
    var uniqueId : Int!
    var vehicleName : String!
    var vehicleId : String!
    //Delivery list API changes
    var createdAt : String!
    var updatedAt : String!

    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]) {
        descriptionField = (dictionary["description"] as? String) ?? ""
        imageUrl = (dictionary["image_url"] as? String) ?? ""
        isBusiness = (dictionary["is_business"] as? Bool) ?? false
        mapPinImageUrl = (dictionary["map_pin_image_url"] as? String) ?? ""
        uniqueId = (dictionary["unique_id"] as? Int) ?? 0
        vehicleName = (dictionary["vehicle_name"] as? String) ?? ""
        
        //Delivery list API changes
        if dictionary["_id"] != nil{
            vehicleId = (dictionary["_id"] as? String) ?? ""
        }else if dictionary["id"] != nil{
            vehicleId = (dictionary["id"] as? String) ?? ""
        }else{
            vehicleId = ""
        }
        
        createdAt = dictionary["created_at"] as? String ?? ""
        updatedAt = dictionary["updated_at"] as? String ?? ""

    }
    
}
