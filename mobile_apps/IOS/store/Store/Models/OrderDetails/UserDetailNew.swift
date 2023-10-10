//
//	UserDetail.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class UserDetailNew : NSObject, NSCoding{

	var countryPhoneCode : String!
	var email : String!
	var name : String!
	var phone : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		countryPhoneCode = dictionary["country_phone_code"] as? String ?? ""
		email = dictionary["email"] as? String ?? ""
		name = dictionary["name"] as? String ?? ""
		phone = dictionary["phone"] as? String ?? ""
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

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         countryPhoneCode = aDecoder.decodeObject(forKey: "country_phone_code") as? String
         email = aDecoder.decodeObject(forKey: "email") as? String
         name = aDecoder.decodeObject(forKey: "name") as? String
         phone = aDecoder.decodeObject(forKey: "phone") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if countryPhoneCode != nil{
			aCoder.encode(countryPhoneCode, forKey: "country_phone_code")
		}
		if email != nil{
			aCoder.encode(email, forKey: "email")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if phone != nil{
			aCoder.encode(phone, forKey: "phone")
		}

	}

}
