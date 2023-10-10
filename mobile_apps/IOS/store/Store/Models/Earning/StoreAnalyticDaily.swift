//
//	StoreAnalyticDaily.swift
//
//	Create by Jaydeep Vyas on 8/8/2017
//	Copyright © 2017 Elluminati. All rights reserved.


import Foundation

class StoreAnalyticDaily{

	var id : String!
	var accepted : Int!
	var acceptionRatio : Double!
	var cancellationRatio : Double!
	var cancelled : Int!
	var completed : Int!
	var completedRatio : Double!
	var date : String!
	var dateInServerTime : String!
	var orderReady : Int!
	var received : Int!
	var rejected : Int!
	var rejectionRatio : Double!
	var storeId : String!
	var tag : String!
	var totalItems : Int!
    var totalOrders:Int!

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		id = (dictionary["_id"] as? String) ?? ""
		accepted = (dictionary["accepted"] as? Int) ?? 0
		acceptionRatio = (dictionary["acception_ratio"] as? Double) ?? 0.0
		cancellationRatio = (dictionary["cancellation_ratio"] as? Double) ?? 0.0
		cancelled = (dictionary["cancelled"] as? Int) ?? 0
		completed = (dictionary["completed"] as? Int) ?? 0
		completedRatio = (dictionary["completed_ratio"] as? Double) ?? 0.0
		date = (dictionary["date"] as? String) ?? ""
		dateInServerTime = (dictionary["date_in_server_time"] as? String) ?? ""
		orderReady = (dictionary["order_ready"] as? Int) ?? 0
		received = (dictionary["received"] as? Int) ?? 0
		rejected = (dictionary["rejected"] as? Int) ?? 0
		rejectionRatio = (dictionary["rejection_ratio"] as? Double) ?? 0.0
		storeId = (dictionary["store_id"] as? String) ?? ""
		tag = (dictionary["tag"] as? String) ?? ""
		totalItems = (dictionary["total_items"] as? Int) ?? 0
        totalOrders = (dictionary["total_orders"] as? Int) ?? 0
	}

}
