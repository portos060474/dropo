//
//	CancelReason.swift
//
//	Create by Elluminati iMac on 17/1/2018
//	Copyright © 2018. All rights reserved.


import Foundation

class CancelReason{

	var cancelReason : String!
	var cancelledAt : String!
	var userDetails : UserDetail!
	var userType : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		cancelReason = dictionary["cancel_reason"] as? String
		cancelledAt = dictionary["cancelled_at"] as? String
		if let userDetailsData = dictionary["user_details"] as? [String:Any]{
			userDetails = UserDetail(fromDictionary: userDetailsData)
		}else {
           userDetails = UserDetail(fromDictionary: [:])
        }
		userType = dictionary["user_type"] as? Int
	}
    
   func toDictionary() -> [String:Any] {
        var dictionary = [String:Any]()
        if cancelReason != nil{
            dictionary["cancel_reason"] = cancelReason
        }
        if cancelledAt != nil{
            dictionary["cancelled_at"] = cancelledAt
        }
        if userDetails != nil{
            dictionary["user_details"] = userDetails.toDictionary()
        }
        if userType != nil{
            dictionary["user_type"] = userType
        }
        return dictionary
    }


}
class UserDetail{
    var id : String!
    var countryPhoneCode : String!
    var email : String!
    var name : String!
    var phone : String!
    var uniqueId : Int!
    var image_url : String!

    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        id = dictionary["_id"] as? String
        countryPhoneCode = dictionary["country_phone_code"] as? String
        email = dictionary["email"] as? String
        
        if dictionary["name"] != nil{
            name = dictionary["name"] as? String ?? ""
        }else if dictionary["first_name"] != nil && dictionary["last_name"] != nil{
            name = "\(dictionary["first_name"] as? String ?? "") \(dictionary["last_name"] as? String ?? "")"
        }else{
            name = ""
        }
        phone = dictionary["phone"] as? String ?? ""
        image_url = dictionary["image_url"] as? String ?? ""

        uniqueId = dictionary["unique_id"] as? Int
    }
    
    func toDictionary() -> [String:Any] {
        var dictionary = [String:Any]()
        if id != nil{
            dictionary["_id"] = id
        }
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
        if uniqueId != nil{
            dictionary["unique_id"] = uniqueId
        }
        return dictionary
    }
}
