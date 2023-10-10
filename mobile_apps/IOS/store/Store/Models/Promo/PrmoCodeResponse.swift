//
//	RootClass.swift
//
//	Create by Elluminati on 15/12/2017
//	Copyright © 2017. All rights reserved.

import Foundation

class PromoCodeResponse{

	var message : Int!
	var promoCodeItemList : [PromoCodeItem]!
	var success : Bool!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		message = dictionary["message"] as? Int
		promoCodeItemList = [PromoCodeItem]()
		if let promoCodesArray = dictionary["promo_codes"] as? [[String:Any]]{
			for dic in promoCodesArray{
				let value = PromoCodeItem(fromDictionary: dic)
				promoCodeItemList.append(value)
			}
		}
		success = dictionary["success"] as? Bool
	}

}
