//
//	PromoCodeItem.swift
//
//	Create by Elluminati iMac on 15/12/2017
//	Copyright © 2017. All rights reserved.

import Foundation

class PromoCodeItem{

	var id : String!
	var cityId : String!
	var countryId : String!
	var isActive : Bool!
	var isPromoHaveDate : Bool!
	var isPromoForDeliveryService : Bool!
	var isPromoHaveMaxDiscountLimit : Bool!
	var isPromoHaveMinimumAmountLimit : Bool!
	var isPromoRequiredUses : Bool!
	var promoApplyOn : [String]!
	var promoCodeApplyOnMinimumAmount : Double!
	var promoCodeMaxDiscountAmount : Double!
	var promoCodeName : String!
	var promoCodeType : Int!
	var promoCodeUses : Int!
	var promoCodeValue : Double!
	var promoDetails : String!
	var promoExpireDate : String!
	var promoFor : Int!
	var promoStartDate : String!
	var uniqueId : Int!
	var usedPromoCode : Int!
    var days:[String]!
    var weeks:[String]!
    var months:[String]!
    var promoRecursionType :Int!
    var promoStartTime:String!
    var promoEndTime:String!
    var isPromoApplyOnCompletedOrder:Bool = false
    var isPromoHaveItemCountLimit:Bool = false
    var promoCodeApplyOnMinimumItemCount:Int = 0
    var promoApplyAfterCompletedOrder:Int = 0
    var promoCodeImageUrl:String!
    
	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		id = dictionary["_id"] as? String
		cityId = dictionary["city_id"] as? String
		countryId = dictionary["country_id"] as? String
        
        if dictionary["is_active"] != nil{
            if isNotNSNull(object: dictionary["is_active"] as AnyObject){
                if let Active = dictionary["is_active"] as? Bool{
                    isActive = Active
                }
            }else{
                isActive = false
            }
        }else{
            isActive = dictionary["is_active"] as? Bool
        }
        
//		isActive = dictionary["is_active"] as? Bool
		isPromoHaveDate = dictionary["is_promo_have_date"] as? Bool ?? false
		isPromoForDeliveryService = dictionary["is_promo_for_delivery_service"] as? Bool
		isPromoHaveMaxDiscountLimit = dictionary["is_promo_have_max_discount_limit"] as? Bool
		isPromoHaveMinimumAmountLimit = dictionary["is_promo_have_minimum_amount_limit"] as? Bool
		isPromoRequiredUses = dictionary["is_promo_required_uses"] as? Bool
		promoApplyOn = dictionary["promo_apply_on"] as? [String]
		promoCodeApplyOnMinimumAmount = (dictionary["promo_code_apply_on_minimum_amount"] as? Double)?.roundTo() ?? 0.0
		promoCodeMaxDiscountAmount = (dictionary["promo_code_max_discount_amount"] as? Double)?.roundTo() ?? 0.0
		promoCodeName = dictionary["promo_code_name"] as? String
		promoCodeType = dictionary["promo_code_type"] as? Int
		promoCodeUses = dictionary["promo_code_uses"] as? Int
		promoCodeValue = (dictionary["promo_code_value"] as? Double)?.roundTo() ?? 0.0
        
		promoDetails = dictionary["promo_details"] as? String
		promoExpireDate = dictionary["promo_expire_date"] as? String ?? ""
		promoFor = dictionary["promo_for"] as? Int
		promoStartDate = dictionary["promo_start_date"] as? String ?? ""
        promoStartTime = dictionary["promo_start_time"] as? String
        promoEndTime = dictionary["promo_end_time"] as? String
		uniqueId = dictionary["unique_id"] as? Int
        
		usedPromoCode = dictionary["used_promo_code"] as? Int
        days = (dictionary["days"] as? [String]) ?? []
        weeks = (dictionary["weeks"] as? [String]) ?? []
        months = (dictionary["months"] as? [String]) ?? []
         promoRecursionType = (dictionary["promo_recursion_type"] as? Int) ?? 0
        
        isPromoApplyOnCompletedOrder = (dictionary["is_promo_apply_on_completed_order"] as? Bool) ?? false
        isPromoHaveItemCountLimit = (dictionary["is_promo_have_item_count_limit"] as? Bool) ?? false
        
        promoCodeApplyOnMinimumItemCount = (dictionary["promo_code_apply_on_minimum_item_count"] as? Int) ?? 0
        promoApplyAfterCompletedOrder = (dictionary["promo_apply_after_completed_order"] as? Int) ?? 0
        promoCodeImageUrl = dictionary["image_url"] as? String ?? ""
	}
    func toDictionary() -> [String:Any] {
        var dictionary = [String:Any]()
       
        if id != nil{
            dictionary["promo_id"] = id
        }
        if cityId != nil{
            dictionary["city_id"] = cityId
        }
        if countryId != nil{
            dictionary["country_id"] = countryId
        }
        if isActive != nil{
            dictionary["is_active"] = isActive ? "true":"false"
        }
        if isPromoHaveDate != nil{
            dictionary["is_promo_have_date"] = isPromoHaveDate ? "true":"false"
        }
        if isPromoForDeliveryService != nil{
            dictionary["is_promo_for_delivery_service"] = isPromoForDeliveryService ? "true":"false"
        }
        if isPromoHaveMaxDiscountLimit != nil{
            dictionary["is_promo_have_max_discount_limit"] = isPromoHaveMaxDiscountLimit ? "true":"false"
        }
        if isPromoHaveMinimumAmountLimit != nil{
            dictionary["is_promo_have_minimum_amount_limit"] = isPromoHaveMinimumAmountLimit ? "true":"false"
        }
        if isPromoRequiredUses != nil{
            dictionary["is_promo_required_uses"] = isPromoRequiredUses ? "true":"false"
        }
        if promoApplyOn != nil{
            dictionary["promo_apply_on"] = promoApplyOn
        }
        if promoCodeApplyOnMinimumAmount != nil{
            dictionary["promo_code_apply_on_minimum_amount"] = String(promoCodeApplyOnMinimumAmount)
        }
        if promoCodeMaxDiscountAmount != nil{
            dictionary["promo_code_max_discount_amount"] = String(promoCodeMaxDiscountAmount)
        }
        if promoCodeName != nil{
            dictionary["promo_code_name"] = promoCodeName
        }
        if promoCodeType != nil{
            dictionary["promo_code_type"] = String(promoCodeType)
        }
        if promoCodeUses != nil{
            dictionary["promo_code_uses"] = String(promoCodeUses)
        }
        if promoCodeValue != nil{
            dictionary["promo_code_value"] = String(promoCodeValue)
        }
        if promoDetails != nil{
            dictionary["promo_details"] = promoDetails
        }
        if promoExpireDate != nil{
            dictionary["promo_expire_date"] = promoExpireDate
        }
        if promoFor != nil{
            dictionary["promo_for"] = String(promoFor)
        }
        if promoStartDate != nil{
            dictionary["promo_start_date"] = promoStartDate
        }
        if uniqueId != nil{
            dictionary["unique_id"] = String(uniqueId)
        }
        if usedPromoCode != nil{
            dictionary["used_promo_code"] = String(usedPromoCode)
        }
        if days != nil {
            dictionary["days"] = days
        }
        if weeks != nil {
            dictionary["weeks"] = weeks
        }
        if months != nil {
            dictionary["months"] = months
        }
        dictionary["is_promo_have_item_count_limit"] = isPromoHaveItemCountLimit ? "true":"false"
        dictionary["is_promo_apply_on_completed_order"] = isPromoApplyOnCompletedOrder ? "true":"false"
        
        if (promoCodeApplyOnMinimumItemCount != nil) {
            dictionary["promo_code_apply_on_minimum_item_count"] = String(promoCodeApplyOnMinimumItemCount)
        }
        if (promoApplyAfterCompletedOrder != nil) {
            dictionary["promo_apply_after_completed_order"] = String(promoApplyAfterCompletedOrder)
        }
        if (promoRecursionType != nil) {
            dictionary["promo_recursion_type"] = String(promoRecursionType)
            
        }
        if (promoStartTime != nil) {
            dictionary["promo_start_time"] = promoStartTime
            
        }
        if (promoEndTime != nil) {
            dictionary["promo_end_time"] = promoEndTime
            
        }
        dictionary[PARAMS.STORE_ID] = preferenceHelper.getUserId()
        dictionary[PARAMS.SERVER_TOKEN] = preferenceHelper.getSessionToken()
        return dictionary
    }
}
