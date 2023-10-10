//
//	UserDetail.swift
//
//	Create by Elluminati iMac on 12/1/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class CartUserDetail : NSObject{

	var countryPhoneCode : String!
	var email : String?
	var name : String?
    var lastName : String?
	var phone : String?
    var imageUrl: String?

	init(fromDictionary dictionary: [String:Any]){
		countryPhoneCode = dictionary["country_phone_code"] as? String
		email = dictionary["email"] as? String
		name = dictionary["name"] as? String
		phone = dictionary["phone"] as? String
        imageUrl = dictionary["image_url"] as? String
	}
    public required override init() {
    }
    
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
        if imageUrl != nil{
            dictionary["image_url"] = imageUrl
        }
		return dictionary
	}
    
    init(name: String, code:String, phone: String) {
        self.name = name
        self.countryPhoneCode = code
        self.phone = phone
    }

}
