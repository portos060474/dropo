//
//	Url.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class SubStoreUrl{

	var name : String!
	var permission : Int!
	var url : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		name = dictionary["name"] as? String
		permission = dictionary["permission"] as? Int
		url = dictionary["url"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if name != nil{
			dictionary["name"] = name
		}
		if permission != nil{
			dictionary["permission"] = permission
		}
		if url != nil{
			dictionary["url"] = url
		}
		return dictionary
	}
}
