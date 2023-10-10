//
//	SpecificationResponse.swift
//
//	Create by Jaydeep Vyas on 27/7/2017
//	Copyright © 2017 Elluminati. All rights reserved.
import Foundation

class SpecificationResponse{

	var message : Int!
	var specifications : [Specification]!
	var success : Bool!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		message = dictionary["message"] as? Int
		specifications = [Specification]()
		if let specificationsArray = dictionary["specifications"] as? [[String:Any]]{
			for dic in specificationsArray{
				let value = Specification(fromDictionary: dic)
				specifications.append(value)
			}
		}
		success = dictionary["success"] as? Bool
	}

}