//
//	PaymentGateway.swift
//
//	Create by Elluminati iMac on 3/1/2018
//	Copyright © 2018. All rights reserved.


import Foundation


class PaymentGatewayItem : NSObject{

	var id : String!
	var descriptionField : String!
	var isPaymentByLogin : Bool!
	var isPaymentByWebUrl : Bool!
	var isPaymentVisible : Bool!
	var isUsingCardDetails : Bool!
	var name : String!
	var paymentKey : String!
	var paymentKeyId : String!
	var uniqueId : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		id = (dictionary["_id"] as? String) ?? ""
		descriptionField = (dictionary["description"] as? String) ?? ""
		isPaymentByLogin = (dictionary["is_payment_by_login"] as? Bool) ?? false
		isPaymentByWebUrl = (dictionary["is_payment_by_web_url"] as? Bool) ?? false
		isPaymentVisible = (dictionary["is_payment_visible"] as? Bool) ?? false
		isUsingCardDetails = (dictionary["is_using_card_details"] as? Bool) ?? false
		name = (dictionary["name"] as? String) ?? ""
		paymentKey = (dictionary["payment_key"] as? String) ?? ""
		paymentKeyId = (dictionary["payment_key_id"] as? String) ?? ""
		uniqueId = (dictionary["unique_id"] as? Int) ?? 0
	}

    public override init() {
    }
	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if id != nil{
			dictionary["_id"] = id
		}
		if descriptionField != nil{
			dictionary["description"] = descriptionField
		}
		if isPaymentByLogin != nil{
			dictionary["is_payment_by_login"] = isPaymentByLogin
		}
		if isPaymentByWebUrl != nil{
			dictionary["is_payment_by_web_url"] = isPaymentByWebUrl
		}
		if isPaymentVisible != nil{
			dictionary["is_payment_visible"] = isPaymentVisible
		}
		if isUsingCardDetails != nil{
			dictionary["is_using_card_details"] = isUsingCardDetails
		}
		if name != nil{
			dictionary["name"] = name
		}
		if paymentKey != nil{
			dictionary["payment_key"] = paymentKey
		}
		if paymentKeyId != nil{
			dictionary["payment_key_id"] = paymentKeyId
		}
		if uniqueId != nil{
			dictionary["unique_id"] = uniqueId
		}
		return dictionary
	}

}
