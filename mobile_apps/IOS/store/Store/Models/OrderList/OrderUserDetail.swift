//
//	OrderUserDetail.swift
//
//	Create by Jaydeep Vyas on 10/8/2017
//	Copyright © 2017 Elluminati. All rights reserved.


import Foundation

class OrderUserDetail{

	var v : Int!
	var id : String!
	var address : String!
	var cityId : String!
	var countryId : String!
	var countryPhoneCode : String!
	var createdAt : String!
	var currentRequest : String!
	var deviceToken : String!
	var deviceType : String!
	var email : String!
	var firstName : String!
    var name : String!

	var imageUrl : String!
	var isApproved : Bool!
	var isDocumentUploaded : Bool!
	var isEmailVerified : Bool!
	var isPhoneNumberVerified : Bool!
	var isReferral : Bool!
	var isUseWallet : Bool!
	var isUserTypeApproved : Bool!
	var lastName : String!
	var loginBy : String!
	var orders : [AnyObject]!
	var password : String!
	var phone : String!
	var promoCount : Int!
	var rate : Int!
	var rateCount : Int!
	var referralCode : String!
	var referredBy : String!
	var requests : [AnyObject]!
	var serverToken : String!
	var socialId : String!
	var totalReferrals : Int!
	var uniqueId : Int!
	var updatedAt : String!
	var userType : Int!
	var userTypeId : String!
	var wallet : Int!
	var walletCurrencyCode : String!
	

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		v = dictionary["__v"] as? Int
		id = dictionary["_id"] as? String
		address = dictionary["address"] as? String
		cityId = dictionary["city_id"] as? String
		countryId = dictionary["country_id"] as? String
		countryPhoneCode = dictionary["country_phone_code"] as? String
		createdAt = dictionary["created_at"] as? String
		currentRequest = dictionary["current_request"] as? String
		deviceToken = dictionary["device_token"] as? String
		deviceType = dictionary["device_type"] as? String
		email = dictionary["email"] as? String
		firstName = dictionary["first_name"] as? String
        name = dictionary["name"] as? String

		imageUrl = dictionary["image_url"] as? String ?? ""
		isApproved = dictionary["is_approved"] as? Bool
		isDocumentUploaded = dictionary["is_document_uploaded"] as? Bool
		isEmailVerified = dictionary["is_email_verified"] as? Bool
		isPhoneNumberVerified = dictionary["is_phone_number_verified"] as? Bool
		isReferral = dictionary["is_referral"] as? Bool
		isUseWallet = dictionary["is_use_wallet"] as? Bool
		isUserTypeApproved = dictionary["is_user_type_approved"] as? Bool
		lastName = dictionary["last_name"] as? String
		loginBy = dictionary["login_by"] as? String
		orders = dictionary["orders"] as? [AnyObject]
		password = dictionary["password"] as? String
		phone = dictionary["phone"] as? String ?? ""
		promoCount = dictionary["promo_count"] as? Int
		rate = dictionary["rate"] as? Int
		rateCount = dictionary["rate_count"] as? Int
		referralCode = dictionary["referral_code"] as? String
		referredBy = dictionary["referred_by"] as? String
		requests = dictionary["requests"] as? [AnyObject]
		serverToken = dictionary["server_token"] as? String
		socialId = dictionary["social_id"] as? String
		totalReferrals = dictionary["total_referrals"] as? Int
		uniqueId = dictionary["unique_id"] as? Int
		updatedAt = dictionary["updated_at"] as? String
		userType = dictionary["user_type"] as? Int
		userTypeId = dictionary["user_type_id"] as? String
		wallet = dictionary["wallet"] as? Int
		walletCurrencyCode = dictionary["wallet_currency_code"] as? String
	}

}
