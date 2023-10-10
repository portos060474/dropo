//
//	StoreResponse.swift
//
//	Create by Jaydeep Vyas on 18/7/2017
//	Copyright © 2017 Elluminati. All rights reserved.

import Foundation

class StoreResponse{

	var maximumPhoneNumberLength : Int!
	var message : Int!
	var minimumPhoneNumberLength : Int!
	var store : Store!
    var currency : String! = ""
    var timeZone : String! = ""
    var success : Bool!
    var isStoreCanCreateGroup : Bool!
    var subStore : SubStore!
    var isStoreCanEditOrder : Bool!
    var countryCode : String! = ""
    var countryPhoneCode : String! = ""

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
    init(fromDictionary dictionary:[String:Any]) {
        countryCode = dictionary["country_code"] as? String ?? ""
		maximumPhoneNumberLength = dictionary["maximum_phone_number_length"] as? Int
        maximumPhoneNumberLength = 10
		message = dictionary["message"] as? Int
		minimumPhoneNumberLength = dictionary["minimum_phone_number_length"] as? Int
        
		if let storeData = dictionary["sub_store"] as? [String:Any]{
			subStore = SubStore(fromDictionary: storeData)
		}
        if let storeData = dictionary["store"] as? [String:Any]{
            store = Store(fromDictionary: storeData)
        }
        
        timeZone = (dictionary["timezone"] as? String) ?? "";
        currency = (dictionary["currency"] as? String) ?? "" ;
		success = dictionary["success"] as? Bool
        isStoreCanCreateGroup = (dictionary["is_store_can_create_group"] as? Bool) ?? false

        preferenceHelper.setStoreCanCreateGroup(isStoreCanCreateGroup!)
        
        isStoreCanEditOrder = (dictionary["is_store_can_edit_order"] as? Bool) ?? false
        preferenceHelper.setStoreCanEditOrder(isStoreCanEditOrder)
        
        countryPhoneCode = (dictionary["country_phone_code"] as? String) ?? "+91"

	}

}
