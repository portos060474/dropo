//
//	CountryListResponse.swift
//
//	Create by Jaydeep Vyas on 18/7/2017
//	Copyright © 2017 Elluminati. All rights reserved.


import Foundation

class CountryListResponse{

	var countries : [Country]!
	var message : Int!
	var success : Bool!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		countries = [Country]()
		if let countriesArray = dictionary["countries"] as? [[String:Any]]{
			for dic in countriesArray{
				let value = Country(fromDictionary: dic)
				countries.append(value)
			}
		}
		message = dictionary["message"] as? Int
		success = dictionary["success"] as? Bool
	}

}