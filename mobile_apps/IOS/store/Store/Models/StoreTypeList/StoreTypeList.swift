//
//	StoreTypeList.swift
//
//	Create by Jaydeep Vyas on 19/7/2017
//	Copyright © 2017 Elluminati. All rights reserved.


import Foundation

class StoreTypeList{

	var deliveries : [Delivery]!
	var message : Int!
	var success : Bool!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		deliveries = [Delivery]()
		if let deliveriesArray = dictionary["deliveries"] as? [[String:Any]]{
			for dic in deliveriesArray{
				let value = Delivery(fromDictionary: dic)
				deliveries.append(value)
			}
		}
		message = dictionary["message"] as? Int
		success = dictionary["success"] as? Bool
	}

}