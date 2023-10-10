//
//	ProviderAnalyticDaily.swift
//
//	Create by Elluminati on 28/6/2017
//	Copyright © 2017 Elluminati. All rights reserved.

import Foundation
class ProviderAnalyticDaily {
    var v : Int!
	var id : String!
	var accepted : Int!
	var acceptionRatio : Double!
	var cancellationRatio : Double!
	var cancelled : Int!
	var completed : Int!
	var completedRatio : Double!
	var date : String!
	var dateInServerTime : String!
	var notAnswered : Int!
	var providerId : String!
	var received : Int!
	var rejected : Int!
	var rejectionRatio : Double!
	var tag : String!
	var totalActiveJobTime : Int64!
	var totalOnlineTime : Int64!
	var uniqueId : Int!
	var workingHours : Int!

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		v = (dictionary["__v"] as? Int) ?? 0
		id = (dictionary["_id"] as? String) ?? ""
		accepted = (dictionary["accepted"] as? Int) ?? 0
		acceptionRatio = (dictionary["acception_ratio"] as? Double) ?? 0.0
		cancellationRatio = (dictionary["cancellation_ratio"] as? Double) ?? 0.0
		cancelled = (dictionary["cancelled"] as? Int) ?? 0
		completed = (dictionary["completed"] as? Int) ?? 0
		completedRatio = (dictionary["completed_ratio"] as? Double) ?? 0.0
		date = (dictionary["date"] as? String) ?? ""
		dateInServerTime = (dictionary["date_in_server_time"] as? String) ?? ""
		notAnswered = (dictionary["not_answered"] as? Int) ?? 0
		providerId = (dictionary["provider_id"] as? String) ?? ""
		received = (dictionary["received"] as? Int) ?? 0
		rejected = (dictionary["rejected"] as? Int) ?? 0
		rejectionRatio = (dictionary["rejection_ratio"] as? Double) ?? 0.0
		tag = (dictionary["tag"] as? String) ?? ""
		totalActiveJobTime = (dictionary["total_active_job_time"] as? Int64) ?? 0
		totalOnlineTime = (dictionary["total_online_time"] as? Int64) ?? 0
		uniqueId = (dictionary["unique_id"] as? Int) ?? 0
		workingHours = (dictionary["working_hours"] as? Int) ?? 0
        
	}

}
