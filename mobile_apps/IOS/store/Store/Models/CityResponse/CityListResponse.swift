//
//	CityListResponse.swift
//
//	Create by Jaydeep Vyas on 17/7/2017
//	Copyright © 2017 Elluminati. All rights reserved.

import Foundation


class CityListResponse : NSObject{

	var cities : [City]!
	var countryPhoneCode : String!
	var maximumPhoneNumberLength : Int!
	var message : Int!
	var minimumPhoneNumberLength : Int!
	var success : Bool!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
    init(fromDictionary dictionary: [String:Any]){
		cities = [City]()
		if let citiesArray = dictionary["cities"] as? [[String:Any]]{
			for dic in citiesArray{
				let value = City(fromDictionary: dic)
				cities.append(value)
			}
		}
		countryPhoneCode = dictionary["country_phone_code"] as? String
		maximumPhoneNumberLength = dictionary["maximum_phone_number_length"] as? Int
		message = dictionary["message"] as? Int
		minimumPhoneNumberLength = dictionary["minimum_phone_number_length"] as? Int
		success = dictionary["success"] as? Bool
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if cities != nil{
			var dictionaryElements = [[String:Any]]()
			for citiesElement in cities {
				dictionaryElements.append(citiesElement.toDictionary())
			}
			dictionary["cities"] = dictionaryElements
		}
		if countryPhoneCode != nil{
			dictionary["country_phone_code"] = countryPhoneCode
		}
		if maximumPhoneNumberLength != nil{
			dictionary["maximum_phone_number_length"] = maximumPhoneNumberLength
		}
		if message != nil{
			dictionary["message"] = message
		}
		if minimumPhoneNumberLength != nil{
			dictionary["minimum_phone_number_length"] = minimumPhoneNumberLength
		}
		if success != nil{
			dictionary["success"] = success
		}
		return dictionary
	}
}
