//
//	DailyEarningResponse.swift
//
//	Create by Jaydeep Vyas on 8/8/2017
//	Copyright © 2017 Elluminati. All rights reserved.


import Foundation

class DailyEarningResponse{

	var currency : String!
	var message : Int!
	var orderPayments : [OrderPayment]!
	var orderTotal : OrderTotal!
	var storeAnalyticDaily : StoreAnalyticDaily!
    var success : Bool!
    var orderDate : OrderDate!
    var orderDayTotal : OrderDayTotal!

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		currency = dictionary["currency"] as? String
		message = dictionary["message"] as? Int
		orderPayments = [OrderPayment]()
		if let orderPaymentsArray = dictionary["order_payments"] as? [[String:Any]]{
			for dic in orderPaymentsArray{
				let value = OrderPayment(fromDictionary: dic)
				orderPayments.append(value)
			}
		}
		if let orderTotalData = dictionary["order_total"] as? [String:Any]{
			orderTotal = OrderTotal(fromDictionary: orderTotalData)
		}
        if let orderDayDate = dictionary["date"] as? [String:Any] {
            orderDate = OrderDate(fromDictionary: orderDayDate)
        }
        if let orderDayTotalEarning = dictionary["order_day_total"] as? [String:Any] {
            orderDayTotal = OrderDayTotal(fromDictionary: orderDayTotalEarning)
        }
        
		if let storeAnalyticDailyData = dictionary["store_analytic_daily"] as? [String:Any] {
			storeAnalyticDaily = StoreAnalyticDaily(fromDictionary: storeAnalyticDailyData)
		}else if let storeAnalyticDailyData = dictionary["store_analytic_weekly"] as? [String:Any] {
            storeAnalyticDaily = StoreAnalyticDaily(fromDictionary: storeAnalyticDailyData)
        }
		success = dictionary["success"] as? Bool
	}

}
