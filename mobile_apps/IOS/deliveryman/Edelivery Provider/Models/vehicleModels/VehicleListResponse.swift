//
//	VehicleListResonse.swift
//
//	Create by Elluminati iMac on 8/1/2018
//	Copyright © 2018. All rights reserved.


import Foundation


class VehicleListResonse : NSObject{

	var message : Int!
	var vehicles : [Vehicle]!
	var success : Bool!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		message = dictionary["message"] as? Int
		vehicles = [Vehicle]()
		if let providerVehiclesArray = dictionary["provider_vehicles"] as? [[String:Any]]{
			for dic in providerVehiclesArray{
				let value = Vehicle(fromDictionary: dic)
				vehicles.append(value)
			}
		}
		success = dictionary["success"] as? Bool
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if message != nil{
			dictionary["message"] = message
		}
		if vehicles != nil{
			var dictionaryElements = [[String:Any]]()
			for providerVehiclesElement in vehicles {
				dictionaryElements.append(providerVehiclesElement.toDictionary())
			}
			dictionary["provider_vehicles"] = dictionaryElements
		}
		if success != nil{
			dictionary["success"] = success
		}
		return dictionary
	}
}
