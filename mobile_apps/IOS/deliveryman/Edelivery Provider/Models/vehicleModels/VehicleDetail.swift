//
//	VehicleDetail.swift
//
//	Create by Elluminati iMac on 8/1/2018
//	Copyright © 2018. All rights reserved.


import Foundation


class VehicleDetail : NSObject{

	var v : Int!
	var id : String!
	var createdAt : String!
	var deliveryTypeId : [String]!
	var descriptionField : String!
	var imageUrl : String!
	var isBusiness : Bool!
	var mapPinImageUrl : String!
	var uniqueId : Int!
	var updatedAt : String!
	var vehicleName : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		v = dictionary["__v"] as? Int
		id = dictionary["_id"] as? String
		createdAt = dictionary["created_at"] as? String
		deliveryTypeId = (dictionary["delivery_type_id"] as? [String]) ?? []
		descriptionField = dictionary["description"] as? String
		imageUrl = dictionary["image_url"] as? String
		isBusiness = dictionary["is_business"] as? Bool
		mapPinImageUrl = dictionary["map_pin_image_url"] as? String
		uniqueId = dictionary["unique_id"] as? Int
		updatedAt = dictionary["updated_at"] as? String
		vehicleName = dictionary["vehicle_name"] as? String
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
		if createdAt != nil{
			dictionary["created_at"] = createdAt
		}
		if deliveryTypeId != nil{
			dictionary["delivery_type_id"] = deliveryTypeId
		}
		if descriptionField != nil{
			dictionary["description"] = descriptionField
		}
		if imageUrl != nil{
			dictionary["image_url"] = imageUrl
		}
		if isBusiness != nil{
			dictionary["is_business"] = isBusiness
		}
		if mapPinImageUrl != nil{
			dictionary["map_pin_image_url"] = mapPinImageUrl
		}
		if uniqueId != nil{
			dictionary["unique_id"] = uniqueId
		}
		if updatedAt != nil{
			dictionary["updated_at"] = updatedAt
		}
		if vehicleName != nil{
			dictionary["vehicle_name"] = vehicleName
		}
		return dictionary
	}
}
