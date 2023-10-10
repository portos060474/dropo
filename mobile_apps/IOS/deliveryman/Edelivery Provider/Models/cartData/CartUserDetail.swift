//
//	UserDetail.swift
//
//	Create by Elluminati iMac on 12/1/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class CartUserDetail : NSObject{

	var countryPhoneCode : String!
	var email : String!
	var name : String!
	var phone : String!
    var image_url : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		countryPhoneCode = (dictionary["country_phone_code"] as? String) ?? ""
		email = (dictionary["email"] as? String) ?? ""
		name = (dictionary["name"] as? String) ?? ""
		phone = (dictionary["phone"] as? String) ?? ""
        if dictionary["image_url"] != nil{
            image_url = (dictionary["image_url"] as? String) ?? ""
        }else{
            image_url = ""
        }

	}
    public required override init() {
        
    }
	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if countryPhoneCode != nil{
			dictionary["country_phone_code"] = countryPhoneCode
		}
		if email != nil{
			dictionary["email"] = email
		}
		if name != nil{
			dictionary["name"] = name
		}
		if phone != nil{
			dictionary["phone"] = phone
		}
		return dictionary
	}


}
