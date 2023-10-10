//
//	Delivery.swift
//
//	Create by Jaydeep Vyas on 19/7/2017
//	Copyright © 2017 Elluminati. All rights reserved.


import Foundation

class Delivery{

	var v : Int!
	var id : String!
	var createdAt : String!
	var deliveryTypeId : String!
	var descriptionField : String!
	var iconUrl : String!
	var imageUrl : String!
	var isBusiness : Bool!
	var uniqueId : Int!
	var updatedAt : String!
    //var deliveryName : String!
    var deliveryName : String!
    var isStoreCanCreateGroup : Bool!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		v = dictionary["__v"] as? Int
		id = dictionary["_id"] as? String
		createdAt = dictionary["created_at"] as? String
    
        deliveryName = StoreSingleton.shared.returnStringAccordingtoLanguage(arrStr: dictionary["delivery_name"] as! [String])
            
		deliveryTypeId = dictionary["delivery_type_id"] as? String
		descriptionField = dictionary["description"] as? String
		iconUrl = dictionary["icon_url"] as? String
		imageUrl = dictionary["image_url"] as? String
		isBusiness = dictionary["is_business"] as? Bool
		uniqueId = dictionary["unique_id"] as? Int
		updatedAt = dictionary["updated_at"] as? String
        isStoreCanCreateGroup = (dictionary["is_store_can_create_group"] as? Bool) ?? false
        
        preferenceHelper.setStoreCanCreateGroup(isStoreCanCreateGroup)

	}

}
