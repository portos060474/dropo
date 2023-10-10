//
//	Country.swift
//
//	Create by Jaydeep Vyas on 18/7/2017
//	Copyright © 2017 Elluminati. All rights reserved.


import Foundation

class Country{

	var v : Int!
	var id : String!
	var bonusToProviderReferral : Int!
	var bonusToStoreReferral : Int!
	var bonusToUserReferral : Int!
	var countryCode : String!
	var countryFlag : String!
	var countryName : String!
	var countryPhoneCode : String!
	var countryTimezone : [String]!
	var createdAt : String!
	var currencyCode : String!
	var currencyName : String!
	var currencySign : String!
	var isBusiness : Bool!
	var isDistanceUnitMile : Bool!
	var isReferralProvider : Bool!
	var isReferralStore : Bool!
	var isReferralUser : Bool!
	var maximumPhoneNumberLength : Int!
	var minimumPhoneNumberLength : Int!
	var noOfProviderUseReferral : Int!
	var noOfStoreUseReferral : Int!
	var noOfUserUseReferral : Int!
	var phoneNumberLength : Int!
	var referralBonusToProvider : Int!
	var referralBonusToProviderFriend : Int!
	var referralBonusToStore : Int!
	var referralBonusToStoreFriend : Int!
	var referralBonusToUser : Int!
	var referralBonusToUserFriend : Int!
	var uniqueId : Int!
	var updatedAt : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		v = dictionary["__v"] as? Int
		id = dictionary["_id"] as? String
		bonusToProviderReferral = dictionary["bonus_to_provider_referral"] as? Int
		bonusToStoreReferral = dictionary["bonus_to_store_referral"] as? Int
		bonusToUserReferral = dictionary["bonus_to_user_referral"] as? Int
		countryCode = dictionary["country_code"] as? String
		countryFlag = dictionary["country_flag"] as? String
		countryName = dictionary["country_name"] as? String
		countryPhoneCode = dictionary["country_phone_code"] as? String
		countryTimezone = dictionary["country_timezone"] as? [String]
		createdAt = dictionary["created_at"] as? String
		currencyCode = dictionary["currency_code"] as? String
		currencyName = dictionary["currency_name"] as? String
		currencySign = dictionary["currency_sign"] as? String
		isBusiness = dictionary["is_business"] as? Bool
		isDistanceUnitMile = dictionary["is_distance_unit_mile"] as? Bool
		isReferralProvider = dictionary["is_referral_provider"] as? Bool
		isReferralStore = dictionary["is_referral_store"] as? Bool
		isReferralUser = dictionary["is_referral_user"] as? Bool
		maximumPhoneNumberLength = dictionary["maximum_phone_number_length"] as? Int
		minimumPhoneNumberLength = dictionary["minimum_phone_number_length"] as? Int
		noOfProviderUseReferral = dictionary["no_of_provider_use_referral"] as? Int
		noOfStoreUseReferral = dictionary["no_of_store_use_referral"] as? Int
		noOfUserUseReferral = dictionary["no_of_user_use_referral"] as? Int
		phoneNumberLength = dictionary["phone_number_length"] as? Int
		referralBonusToProvider = dictionary["referral_bonus_to_provider"] as? Int
		referralBonusToProviderFriend = dictionary["referral_bonus_to_provider_friend"] as? Int
		referralBonusToStore = dictionary["referral_bonus_to_store"] as? Int
		referralBonusToStoreFriend = dictionary["referral_bonus_to_store_friend"] as? Int
		referralBonusToUser = dictionary["referral_bonus_to_user"] as? Int
		referralBonusToUserFriend = dictionary["referral_bonus_to_user_friend"] as? Int
		uniqueId = dictionary["unique_id"] as? Int
		updatedAt = dictionary["updated_at"] as? String
	}

}