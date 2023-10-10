//
//	PromoCode.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class PromoCodeModal{

	var v : Int!
	var id : String!
	var adminLoyalty : Int!
	var adminLoyaltyType : Int!
	var cityId : String!
	var countryId : String!
	var createdAt : String!
	var createdBy : Int!
	var createdId : String!
	var days : [String]!
	var imageUrl : String!
	var isActive : Bool!
	var isApproved : Bool!
	var isPromoApplyOnCompletedOrder : Bool!
	var isPromoHaveDate : Bool!
	var isPromoHaveItemCountLimit : Bool!
	var isPromoHaveMaxDiscountLimit : Bool!
	var isPromoHaveMinimumAmountLimit : Bool!
	var isPromoRequiredUses : Bool!
	var months : [String]!
	var promoApplyAfterCompletedOrder : Int!
	var promoApplyOn : [String]!
	var promoCodeApplyOnMinimumAmount : Int!
	var promoCodeApplyOnMinimumItemCount : Int!
	var promoCodeMaxDiscountAmount : Int!
	var promoCodeName : String!
	var promoCodeType : Int!
	var promoCodeUses : Int!
	var promoCodeValue : Int!
	var promoDetails : String!
	var promoEndTime : String!
	var promoExpireDate : String!
	var promoFor : Int!
	var promoRecursionType : Int!
	var promoStartDate : String!
	var promoStartTime : String!
	var storeIds : [AnyObject]!
	var uniqueId : Int!
	var updatedAt : String!
	var usedPromoCode : Int!
	var weeks : [String]!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		v = dictionary["__v"] as? Int
		id = dictionary["_id"] as? String ?? ""
		adminLoyalty = dictionary["admin_loyalty"] as? Int
		adminLoyaltyType = dictionary["admin_loyalty_type"] as? Int
		cityId = dictionary["city_id"] as? String ?? ""
		countryId = dictionary["country_id"] as? String ?? ""
		createdAt = dictionary["created_at"] as? String ?? ""
		createdBy = dictionary["created_by"] as? Int ?? 0
		createdId = dictionary["created_id"] as? String ?? ""
		days = dictionary["days"] as? [String] ?? []
		imageUrl = dictionary["image_url"] as? String ?? ""
		isActive = dictionary["is_active"] as? Bool ?? false
		isApproved = dictionary["is_approved"] as? Bool ?? false
		isPromoApplyOnCompletedOrder = dictionary["is_promo_apply_on_completed_order"] as? Bool ?? false
		isPromoHaveDate = dictionary["is_promo_have_date"] as? Bool ?? false
		isPromoHaveItemCountLimit = dictionary["is_promo_have_item_count_limit"] as? Bool ?? false
		isPromoHaveMaxDiscountLimit = dictionary["is_promo_have_max_discount_limit"] as? Bool ?? false
		isPromoHaveMinimumAmountLimit = dictionary["is_promo_have_minimum_amount_limit"] as? Bool ?? false
		isPromoRequiredUses = dictionary["is_promo_required_uses"] as? Bool ?? false
		months = dictionary["months"] as? [String] ?? []
		promoApplyAfterCompletedOrder = dictionary["promo_apply_after_completed_order"] as? Int ?? 0
		promoApplyOn = dictionary["promo_apply_on"] as? [String] ?? []
		promoCodeApplyOnMinimumAmount = dictionary["promo_code_apply_on_minimum_amount"] as? Int ?? 0
		promoCodeApplyOnMinimumItemCount = dictionary["promo_code_apply_on_minimum_item_count"] as? Int ?? 0
		promoCodeMaxDiscountAmount = dictionary["promo_code_max_discount_amount"] as? Int ?? 0
		promoCodeName = dictionary["promo_code_name"] as? String ?? ""
		promoCodeType = dictionary["promo_code_type"] as? Int ?? 0
		promoCodeUses = dictionary["promo_code_uses"] as? Int ?? 0
		promoCodeValue = dictionary["promo_code_value"] as? Int ?? 0
		promoDetails = dictionary["promo_details"] as? String ?? ""
        promoExpireDate = dictionary["promo_expire_date"] as? String ?? ""
		promoFor = dictionary["promo_for"] as? Int ?? 0
		promoRecursionType = dictionary["promo_recursion_type"] as? Int ?? 0

        if isNotNSNull(object: dictionary["promo_start_date"] as AnyObject){
            promoStartDate = dictionary["promo_start_date"] as? String ?? ""
        }else{
            promoStartDate = ""
        }
        
        if isNotNSNull(object: dictionary["promo_start_time"] as AnyObject){
            promoStartTime = dictionary["promo_start_time"] as? String ?? ""
        }else{
            promoStartTime = ""
        }
        
        if isNotNSNull(object: dictionary["promo_end_time"] as AnyObject){
            promoEndTime = dictionary["promo_end_time"] as? String ?? ""
        }else{
            promoEndTime = ""
        }
        
        storeIds = dictionary["store_ids"] as? [AnyObject] ?? []
		uniqueId = dictionary["unique_id"] as? Int ?? 0
		updatedAt = dictionary["updated_at"] as? String ?? ""
		usedPromoCode = dictionary["used_promo_code"] as? Int ?? 0
		weeks = dictionary["weeks"] as? [String] ?? []
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
		if adminLoyalty != nil{
			dictionary["admin_loyalty"] = adminLoyalty
		}
		if adminLoyaltyType != nil{
			dictionary["admin_loyalty_type"] = adminLoyaltyType
		}
		if cityId != nil{
			dictionary["city_id"] = cityId
		}
		if countryId != nil{
			dictionary["country_id"] = countryId
		}
		if createdAt != nil{
			dictionary["created_at"] = createdAt
		}
		if createdBy != nil{
			dictionary["created_by"] = createdBy
		}
		if createdId != nil{
			dictionary["created_id"] = createdId
		}
		if days != nil{
			dictionary["days"] = days
		}
		if imageUrl != nil{
			dictionary["image_url"] = imageUrl
		}
		if isActive != nil{
			dictionary["is_active"] = isActive
		}
		if isApproved != nil{
			dictionary["is_approved"] = isApproved
		}
		if isPromoApplyOnCompletedOrder != nil{
			dictionary["is_promo_apply_on_completed_order"] = isPromoApplyOnCompletedOrder
		}
		if isPromoHaveDate != nil{
			dictionary["is_promo_have_date"] = isPromoHaveDate
		}
		if isPromoHaveItemCountLimit != nil{
			dictionary["is_promo_have_item_count_limit"] = isPromoHaveItemCountLimit
		}
		if isPromoHaveMaxDiscountLimit != nil{
			dictionary["is_promo_have_max_discount_limit"] = isPromoHaveMaxDiscountLimit
		}
		if isPromoHaveMinimumAmountLimit != nil{
			dictionary["is_promo_have_minimum_amount_limit"] = isPromoHaveMinimumAmountLimit
		}
		if isPromoRequiredUses != nil{
			dictionary["is_promo_required_uses"] = isPromoRequiredUses
		}
		if months != nil{
			dictionary["months"] = months
		}
		if promoApplyAfterCompletedOrder != nil{
			dictionary["promo_apply_after_completed_order"] = promoApplyAfterCompletedOrder
		}
		if promoApplyOn != nil{
			dictionary["promo_apply_on"] = promoApplyOn
		}
		if promoCodeApplyOnMinimumAmount != nil{
			dictionary["promo_code_apply_on_minimum_amount"] = promoCodeApplyOnMinimumAmount
		}
		if promoCodeApplyOnMinimumItemCount != nil{
			dictionary["promo_code_apply_on_minimum_item_count"] = promoCodeApplyOnMinimumItemCount
		}
		if promoCodeMaxDiscountAmount != nil{
			dictionary["promo_code_max_discount_amount"] = promoCodeMaxDiscountAmount
		}
		if promoCodeName != nil{
			dictionary["promo_code_name"] = promoCodeName
		}
		if promoCodeType != nil{
			dictionary["promo_code_type"] = promoCodeType
		}
		if promoCodeUses != nil{
			dictionary["promo_code_uses"] = promoCodeUses
		}
		if promoCodeValue != nil{
			dictionary["promo_code_value"] = promoCodeValue
		}
		if promoDetails != nil{
			dictionary["promo_details"] = promoDetails
		}
		if promoEndTime != nil{
			dictionary["promo_end_time"] = promoEndTime
		}
		if promoExpireDate != nil{
			dictionary["promo_expire_date"] = promoExpireDate
		}
		if promoFor != nil{
			dictionary["promo_for"] = promoFor
		}
		if promoRecursionType != nil{
			dictionary["promo_recursion_type"] = promoRecursionType
		}
		if promoStartDate != nil{
			dictionary["promo_start_date"] = promoStartDate
		}
		if promoStartTime != nil{
			dictionary["promo_start_time"] = promoStartTime
		}
		if storeIds != nil{
			dictionary["store_ids"] = storeIds
		}
		if uniqueId != nil{
			dictionary["unique_id"] = uniqueId
		}
		if updatedAt != nil{
			dictionary["updated_at"] = updatedAt
		}
		if usedPromoCode != nil{
			dictionary["used_promo_code"] = usedPromoCode
		}
		if weeks != nil{
			dictionary["weeks"] = weeks
		}
		return dictionary
	}
}
