//
//	UserDetail.swift
//
//	Create by Elluminati iMac on 5/12/2017
//	Copyright © 2017. All rights reserved.


import Foundation

class UserDetail{

	var firstName : String!
	var imageUrl : String!
	var lastName : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		firstName = (dictionary["first_name"] as? String) ?? ""
		imageUrl = (dictionary["image_url"] as? String) ?? ""
		lastName = (dictionary["last_name"] as? String) ?? ""
	}

}
