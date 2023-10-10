//
//	RemainingReviewList.swift
//
//	Create by Elluminati iMac on 5/12/2017
//	Copyright © 2017. All rights reserved.

import Foundation

class RemainingReviewList{

	var id : String!
	var orderId : String!
	var orderUniqueId : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		id = (dictionary["_id"] as? String) ?? ""
		orderId = (dictionary["order_id"] as? String) ?? ""
		orderUniqueId = (dictionary["order_unique_id"] as? Int) ?? 0
	}

}
