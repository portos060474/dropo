//
//	City.swift
//
//	Create by Jaydeep Vyas on 17/7/2017
//	Copyright © 2017 Elluminati. All rights reserved.

import Foundation


class City : NSObject{

	var id : String!
	var cityName : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		id = dictionary["_id"] as? String
		cityName = dictionary["city_name"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if id != nil{
			dictionary["_id"] = id
		}
		if cityName != nil{
			dictionary["city_name"] = cityName
		}
		return dictionary
	}

    

}
