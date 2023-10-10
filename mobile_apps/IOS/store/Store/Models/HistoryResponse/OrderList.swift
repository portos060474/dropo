//
//	OrderList.swift
//
//	Create by Jaydeep Vyas on 6/8/2017
//	Copyright © 2017 Elluminati. All rights reserved.


import Foundation

class OrderList{

	var id : String!
	var completedAt : String!
	var createdAt : String!
	var currency : String!
	var orderStatus : Int!
	var storeProfit : Double!
	var total : Double!
	var totalOrderPrice : Double!
	var totalServicePrice : Double!
	var uniqueId : Int!
	var userDetail : UserDetail!
    var requestDetail : RequestDetail!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		id = dictionary["_id"] as? String
		completedAt = dictionary["completed_at"] as? String
		createdAt = dictionary["created_at"] as? String
		currency = dictionary["currency"] as? String
		orderStatus = dictionary["order_status"] as? Int
		storeProfit = (dictionary["store_profit"] as? Double)?.roundTo() ?? 0.0
		total = (dictionary["total"] as? Double)?.roundTo() ?? 0.0
		totalOrderPrice = (dictionary["total_order_price"] as? Double)?.roundTo() ?? 0.0
		totalServicePrice = (dictionary["total_service_price"] as? Double)?.roundTo() ?? 0.0
		uniqueId = dictionary["unique_id"] as? Int
		if let userDetailData = dictionary["user_detail"] as? [String:Any]{
			userDetail = UserDetail(fromDictionary: userDetailData)
        }else{
            userDetail = UserDetail(fromDictionary: [:])

        }
        
        if let requestDetailData = dictionary["request_detail"] as? [String:Any]{
            requestDetail = RequestDetail(fromDictionary: requestDetailData)
        }
	}

}
