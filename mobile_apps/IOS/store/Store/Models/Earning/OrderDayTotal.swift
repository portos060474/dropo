//
//	OrderDayTotal.swift
//
//	Create by Jaydeep Vyas on 8/8/2017
//	Copyright © 2017 Elluminati. All rights reserved.


import Foundation

class OrderDayTotal{

	var id : String!
	var date1 : Double!
	var date2 : Double!
	var date3 : Double!
	var date4 : Double!
	var date5 : Double!
	var date6 : Double!
	var date7 : Double!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		id = dictionary["_id"] as? String
		date1 = (dictionary["date1"] as? Double) ?? 0.0
		date2 = (dictionary["date2"] as? Double) ?? 0.0
		date3 = (dictionary["date3"] as? Double) ?? 0.0
		date4 = (dictionary["date4"] as? Double) ?? 0.0
		date5 = (dictionary["date5"] as? Double) ?? 0.0
		date6 = (dictionary["date6"] as? Double) ?? 0.0
		date7 = (dictionary["date7"] as? Double) ?? 0.0
	}

}
