//
//	UserDetail.swift
//
//	Create by Jaydeep Vyas on 6/8/2017
//	Copyright © 2017 Elluminati. All rights reserved.


import Foundation

class UserDetail{

	var firstName : String!
	var imageUrl : String!
	var lastName : String!
    var name : String!
    var phone : String!



	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
        //Storeapp //Api changes
        
        if dictionary["first_name"] != nil{
            firstName = dictionary["first_name"] as? String
        }else if dictionary["name"] != nil{
            firstName = dictionary["name"] as? String
        }else{
            firstName = ""
        }
		
		imageUrl = dictionary["image_url"] as? String ?? ""
		lastName = dictionary["last_name"] as? String ?? ""
        phone = dictionary["phone"] as? String ?? ""

	}

}

class RequestDetail{
    
    var uniqueID : Int!
    var deliveryStatus : Int!
    var deliveryStatusManageId : Int!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        uniqueID = (dictionary["request_unique_id"] as? Int) ?? 0
        deliveryStatus = (dictionary["delivery_status"] as? Int) ?? 0
        deliveryStatusManageId = (dictionary["delivery_status_manage_id"] as? Int) ?? 0
    }
    
}
