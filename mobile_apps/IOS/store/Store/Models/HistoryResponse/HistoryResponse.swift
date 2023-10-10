//
//	HistoryResponse.swift
//
//	Create by Jaydeep Vyas on 6/8/2017
//	Copyright © 2017 Elluminati. All rights reserved.


import Foundation

class HistoryResponse{

	var message : Int!
	var orderList : [OrderList]!
	var success : Bool!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		message = dictionary["message"] as? Int
		orderList = [OrderList]()
		if let orderListArray = dictionary["order_list"] as? [[String:Any]]{
			for dic in orderListArray{
				let value = OrderList(fromDictionary: dic)
				orderList.append(value)
			}
		}
		success = dictionary["success"] as? Bool
	}

}
