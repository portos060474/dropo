//
//	StoreTime.swift
//
//	Create by Jaydeep Vyas on 6/10/2017
//	Copyright © 2017 Elluminati. All rights reserved.


import Foundation


class StoreTime : NSObject{

	var day : Int!
	var dayTime : [DayTime]!
	var isStoreOpen : Bool!
	var isStoreOpenFullTime : Bool!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		day = (dictionary["day"] as? Int) ?? 0
		dayTime = [DayTime]()
		if let dayTimeArray = dictionary["day_time"] as? [[String:Any]]{
			for dic in dayTimeArray{
				let value = DayTime(fromDictionary: dic)
				dayTime.append(value)
			}
		}
		isStoreOpen = (dictionary["is_store_open"] as? Bool) ?? false
		isStoreOpenFullTime = (dictionary["is_store_open_full_time"] as? Bool) ?? false
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if day != nil{
			dictionary["day"] = day
		}
		if dayTime != nil{
			var dictionaryElements = [[String:Any]]()
			for dayTimeElement in dayTime {
				dictionaryElements.append(dayTimeElement.toDictionary())
			}
			dictionary["day_time"] = dictionaryElements
		}
		if isStoreOpen != nil{
			dictionary["is_store_open"] = isStoreOpen
		}
		if isStoreOpenFullTime != nil{
			dictionary["is_store_open_full_time"] = isStoreOpenFullTime
		}
		return dictionary
	}
}
