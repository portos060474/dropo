//
//	CountryDetail.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class CountryDetail {

	var v : Int!
	var id : String!
	var autoTransferDayForDeliveryman : Int!
	var autoTransferDayForStore : Int!
	var countryCode : String!
	var countryCode2 : String!
	var countryFlag : String!
	var countryName : String!
	var countryPhoneCode : String!
	var countryTimezone : [String]!
	var createdAt : String!
	var currencyCode : String!
	var currencyName : String!
	var currencyRate : Int!
	var currencySign : String!
	var isAdsVisible : Bool!
	var isAutoTransferForDeliveryman : Bool!
	var isAutoTransferForStore : Bool!
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
		autoTransferDayForDeliveryman = dictionary["auto_transfer_day_for_deliveryman"] as? Int
		autoTransferDayForStore = dictionary["auto_transfer_day_for_store"] as? Int
		countryCode = dictionary["country_code"] as? String
		countryCode2 = dictionary["country_code_2"] as? String
		countryFlag = dictionary["country_flag"] as? String
		countryName = dictionary["country_name"] as? String
		countryPhoneCode = dictionary["country_phone_code"] as? String
		countryTimezone = dictionary["country_timezone"] as? [String]
		createdAt = dictionary["created_at"] as? String
		currencyCode = dictionary["currency_code"] as? String
		currencyName = dictionary["currency_name"] as? String
		currencyRate = dictionary["currency_rate"] as? Int
		currencySign = dictionary["currency_sign"] as? String
		isAdsVisible = dictionary["is_ads_visible"] as? Bool
		isAutoTransferForDeliveryman = dictionary["is_auto_transfer_for_deliveryman"] as? Bool
		isAutoTransferForStore = dictionary["is_auto_transfer_for_store"] as? Bool
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
		referralBonusToProvider = dictionary["referral_bonus_to_provider"] as? Int
		referralBonusToProviderFriend = dictionary["referral_bonus_to_provider_friend"] as? Int
		referralBonusToStore = dictionary["referral_bonus_to_store"] as? Int
		referralBonusToStoreFriend = dictionary["referral_bonus_to_store_friend"] as? Int
		referralBonusToUser = dictionary["referral_bonus_to_user"] as? Int
		referralBonusToUserFriend = dictionary["referral_bonus_to_user_friend"] as? Int
		uniqueId = dictionary["unique_id"] as? Int
		updatedAt = dictionary["updated_at"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if v != nil{
			dictionary["__v"] = v
		}
		if id != nil{
			dictionary["_id"] = id
		}
		if autoTransferDayForDeliveryman != nil{
			dictionary["auto_transfer_day_for_deliveryman"] = autoTransferDayForDeliveryman
		}
		if autoTransferDayForStore != nil{
			dictionary["auto_transfer_day_for_store"] = autoTransferDayForStore
		}
		if countryCode != nil{
			dictionary["country_code"] = countryCode
		}
		if countryCode2 != nil{
			dictionary["country_code_2"] = countryCode2
		}
		if countryFlag != nil{
			dictionary["country_flag"] = countryFlag
		}
		if countryName != nil{
			dictionary["country_name"] = countryName
		}
		if countryPhoneCode != nil{
			dictionary["country_phone_code"] = countryPhoneCode
		}
		if countryTimezone != nil{
			dictionary["country_timezone"] = countryTimezone
		}
		if createdAt != nil{
			dictionary["created_at"] = createdAt
		}
		if currencyCode != nil{
			dictionary["currency_code"] = currencyCode
		}
		if currencyName != nil{
			dictionary["currency_name"] = currencyName
		}
		if currencyRate != nil{
			dictionary["currency_rate"] = currencyRate
		}
		if currencySign != nil{
			dictionary["currency_sign"] = currencySign
		}
		if isAdsVisible != nil{
			dictionary["is_ads_visible"] = isAdsVisible
		}
		if isAutoTransferForDeliveryman != nil{
			dictionary["is_auto_transfer_for_deliveryman"] = isAutoTransferForDeliveryman
		}
		if isAutoTransferForStore != nil{
			dictionary["is_auto_transfer_for_store"] = isAutoTransferForStore
		}
		if isBusiness != nil{
			dictionary["is_business"] = isBusiness
		}
		if isDistanceUnitMile != nil{
			dictionary["is_distance_unit_mile"] = isDistanceUnitMile
		}
		if isReferralProvider != nil{
			dictionary["is_referral_provider"] = isReferralProvider
		}
		if isReferralStore != nil{
			dictionary["is_referral_store"] = isReferralStore
		}
		if isReferralUser != nil{
			dictionary["is_referral_user"] = isReferralUser
		}
		if maximumPhoneNumberLength != nil{
			dictionary["maximum_phone_number_length"] = maximumPhoneNumberLength
		}
		if minimumPhoneNumberLength != nil{
			dictionary["minimum_phone_number_length"] = minimumPhoneNumberLength
		}
		if noOfProviderUseReferral != nil{
			dictionary["no_of_provider_use_referral"] = noOfProviderUseReferral
		}
		if noOfStoreUseReferral != nil{
			dictionary["no_of_store_use_referral"] = noOfStoreUseReferral
		}
		if noOfUserUseReferral != nil{
			dictionary["no_of_user_use_referral"] = noOfUserUseReferral
		}
		if referralBonusToProvider != nil{
			dictionary["referral_bonus_to_provider"] = referralBonusToProvider
		}
		if referralBonusToProviderFriend != nil{
			dictionary["referral_bonus_to_provider_friend"] = referralBonusToProviderFriend
		}
		if referralBonusToStore != nil{
			dictionary["referral_bonus_to_store"] = referralBonusToStore
		}
		if referralBonusToStoreFriend != nil{
			dictionary["referral_bonus_to_store_friend"] = referralBonusToStoreFriend
		}
		if referralBonusToUser != nil{
			dictionary["referral_bonus_to_user"] = referralBonusToUser
		}
		if referralBonusToUserFriend != nil{
			dictionary["referral_bonus_to_user_friend"] = referralBonusToUserFriend
		}
		
		if uniqueId != nil{
			dictionary["unique_id"] = uniqueId
		}
		if updatedAt != nil{
			dictionary["updated_at"] = updatedAt
		}
		return dictionary
	}

    

    

}
