//
//	StoreAnalyticWeekly.swift
//
//	Create by Jaydeep Vyas on 8/8/2017
//	Copyright © 2017 Elluminati. All rights reserved.


import Foundation

class StoreAnalyticWeekly{

	var id : String!
	var accepted : Int!
	var acceptionRatio : Int!
	var cancellationRatio : Int!
	var cancelled : Int!
	var completed : Int!
	var completedRatio : Int!
	var dateInServerTime : String!
	var dateTag : String!
	var endDateTag : String!
	var orderReady : Int!
	var received : Int!
	var rejected : Int!
	var rejectionRatio : Int!
	var startDateTag : String!
	var storeId : String!
	var totalItems : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		id = dictionary["_id"] as? String
		accepted = dictionary["accepted"] as? Int
		acceptionRatio = dictionary["acception_ratio"] as? Int
		cancellationRatio = dictionary["cancellation_ratio"] as? Int
		cancelled = dictionary["cancelled"] as? Int
		completed = dictionary["completed"] as? Int
		completedRatio = dictionary["completed_ratio"] as? Int
		dateInServerTime = dictionary["date_in_server_time"] as? String
		dateTag = dictionary["date_tag"] as? String
		endDateTag = dictionary["end_date_tag"] as? String
		orderReady = dictionary["order_ready"] as? Int
		received = dictionary["received"] as? Int
		rejected = dictionary["rejected"] as? Int
		rejectionRatio = dictionary["rejection_ratio"] as? Int
		startDateTag = dictionary["start_date_tag"] as? String
		storeId = dictionary["store_id"] as? String
		totalItems = dictionary["total_items"] as? Int
	}

}
public class Analytic {
    
    public var title:String?
    public var value:String?
    
    
    required public init!(title:String,value:String) {
        self.title = title
        self.value = value
        
    }
}
