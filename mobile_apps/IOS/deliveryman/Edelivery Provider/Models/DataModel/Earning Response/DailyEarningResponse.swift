//
//	DailyEarningResponse.swift
//
//	Create by Elluminati on 28/6/2017
//	Copyright © 2017 Elluminati. All rights reserved.

import Foundation

class DailyEarningResponse{

	var message : Int!
	var orderPayments : [OrderPayment]!
	var orderTotal : OrderTotal!
	var providerAnalyticDaily : ProviderAnalyticDaily!
	var success : Bool!
    var orderDate : OrderDate!
    var orderDayTotal : OrderDayTotal!
    var currency:String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		message = dictionary["message"] as? Int
		orderPayments = [OrderPayment]()
		if let orderPaymentsArray = dictionary["order_payments"] as? [[String:Any]]{
			for dic in orderPaymentsArray{
				let value = OrderPayment(dictionary: dic as [String:Any])
				orderPayments.append(value!)
			}
		}
		if let orderTotalData = dictionary["order_total"] as? [String:Any] {
			orderTotal = OrderTotal(fromDictionary: orderTotalData)
		}
		if let providerAnalyticDailyData = dictionary["provider_analytic_daily"] as? [String:Any]{
			providerAnalyticDaily = ProviderAnalyticDaily(fromDictionary: providerAnalyticDailyData)
		}else if let providerAnalyticDailyData = dictionary["provider_analytic_weekly"] as? [String:Any]{
            providerAnalyticDaily = ProviderAnalyticDaily(fromDictionary: providerAnalyticDailyData)
        }
        if let dateData = dictionary["date"] as? [String:Any] {
            orderDate = OrderDate(fromDictionary: dateData)
        }
        if let orderDayTotalData = dictionary["order_day_total"] as? [String:Any]{
            orderDayTotal = OrderDayTotal(fromDictionary: orderDayTotalData)
        }
		success = dictionary["success"] as? Bool
        currency = dictionary["currency"] as? String
	}

}
class OrderDayTotal : NSObject, NSCoding{
    var id : Any!
    var date1 : String!
    var date2 : String!
    var date3 : String!
    var date4 : String!
    var date5 : String!
    var date6 : String!
    var date7 : String!
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        id = dictionary["_id"]
        date1 = ((dictionary["date1"] as? Double)?.roundTo() ?? 0.0).toString()
        date2 = ((dictionary["date2"] as? Double)?.roundTo() ?? 0.0).toString()
        date3 = ((dictionary["date3"] as? Double)?.roundTo() ?? 0.0).toString()
        date4 = ((dictionary["date4"] as? Double)?.roundTo() ?? 0.0).toString()
        date5 = ((dictionary["date5"] as? Double)?.roundTo() ?? 0.0).toString()
        date6 = ((dictionary["date6"] as? Double)?.roundTo() ?? 0.0).toString()
        date7 = ((dictionary["date7"] as? Double)?.roundTo() ?? 0.0).toString()
    }
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any] {
        var dictionary = [String:Any]()
        if id != nil{
            dictionary["_id"] = id
        }
        if date1 != nil{
            dictionary["date1"] = date1
        }
        if date2 != nil{
            dictionary["date2"] = date2
        }
        if date3 != nil{
            dictionary["date3"] = date3
        }
        if date4 != nil{
            dictionary["date4"] = date4
        }
        if date5 != nil{
            dictionary["date5"] = date5
        }
        if date6 != nil{
            dictionary["date6"] = date6
        }
        if date7 != nil{
            dictionary["date7"] = date7
        }
        return dictionary
    }
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObject(forKey: "_id")
        date1 = aDecoder.decodeObject(forKey: "date1") as? String
        date2 = aDecoder.decodeObject(forKey: "date2") as? String
        date3 = aDecoder.decodeObject(forKey: "date3") as? String
        date4 = aDecoder.decodeObject(forKey: "date4") as? String
        date5 = aDecoder.decodeObject(forKey: "date5") as? String
        date6 = aDecoder.decodeObject(forKey: "date6") as? String
        date7 = aDecoder.decodeObject(forKey: "date7") as? String
        
    }
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder) {
        if id != nil{
            aCoder.encode(id, forKey: "_id")
        }
        if date1 != nil{
            aCoder.encode(date1, forKey: "date1")
        }
        if date2 != nil{
            aCoder.encode(date2, forKey: "date2")
        }
        if date3 != nil{
            aCoder.encode(date3, forKey: "date3")
        }
        if date4 != nil{
            aCoder.encode(date4, forKey: "date4")
        }
        if date5 != nil{
            aCoder.encode(date5, forKey: "date5")
        }
        if date6 != nil{
            aCoder.encode(date6, forKey: "date6")
        }
        if date7 != nil{
            aCoder.encode(date7, forKey: "date7")
        }
    }
}
class OrderDate{
    var date1 : String!
    var date2 : String!
    var date3 : String!
    var date4 : String!
    var date5 : String!
    var date6 : String!
    var date7 : String!
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        date1 = dictionary["date1"] as? String
        date2 = dictionary["date2"] as? String
        date3 = dictionary["date3"] as? String
        date4 = dictionary["date4"] as? String
        date5 = dictionary["date5"] as? String
        date6 = dictionary["date6"] as? String
        date7 = dictionary["date7"] as? String
    }
}





