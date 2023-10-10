//
//	UserDetail.swift
//
//	Create by Elluminati iMac on 12/1/2018
//	Copyright © 2018. All rights reserved.


import Foundation


class CartUserDetail : NSObject{

	var countryPhoneCode : String!
	var email : String!
	var name : String!
	var phone : String!
    //Deliverylist api changes
    var imageUrl : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		
        if let codeInt = dictionary["country_phone_code"] as? Int {
            countryPhoneCode = "\(codeInt)"
        } else if let codeStr = dictionary["country_phone_code"] as? String {
            countryPhoneCode = codeStr
        } else {
            countryPhoneCode = ""
        }
        
		email = (dictionary["email"] as? String) ?? ""
		name = (dictionary["name"] as? String) ?? ""
        if let phoneInt = dictionary["phone"] as? Int {
            phone = "\(phoneInt)"
        } else if let strPhone = dictionary["phone"] as? String {
            phone = strPhone
        } else {
            phone = ""
        }
		
        //Deliverylist api changes
        imageUrl = dictionary["image_url"] as? String ?? ""

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
        if imageUrl != nil{
            dictionary["image_url"] = imageUrl
        }
		return dictionary
	}

    
    

}
