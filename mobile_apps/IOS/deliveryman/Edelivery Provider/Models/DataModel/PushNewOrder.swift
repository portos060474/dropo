//
//	PushNewOrder.swift
//
//	Create by Elluminati on 15/7/2017
//	Copyright © 2017 Elluminati. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class PushNewOrder {

	var message : String!
	var orderDetail : PushOrderData!
	var remainingSecond : Int!

    /**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */

	init(fromDictionary dictionary: [String:Any]){
		message = dictionary["message"] as? String
		if let orderDetail = dictionary["push_data1"] as? [String:Any]{
			self.orderDetail = PushOrderData(fromDictionary: orderDetail)
		}
		remainingSecond = (dictionary["push_data2"] as? Int) ?? 60
	}

    init() {}
}
