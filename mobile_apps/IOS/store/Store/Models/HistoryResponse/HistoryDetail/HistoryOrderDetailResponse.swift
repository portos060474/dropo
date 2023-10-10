//
//	HistoryOrderDetailResponse.swift
//
//	Create by Jaydeep Vyas on 6/8/2017
//	Copyright © 2017 Elluminati. All rights reserved.

import Foundation

class HistoryOrderDetailResponse{

	var message : Int!
	var orderList : HistoryOrderList!
	var paymentGatewayName : String!
	var providerDetail : HistoryProviderDetail!
	var userDetail : HistoryUserDetail!
    var currency:String!
    var success : Bool!
	


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		message = dictionary["message"] as? Int
		if let orderListData = dictionary["order_list"] as? [String:Any]{
			orderList = HistoryOrderList(fromDictionary: orderListData)
		}
		paymentGatewayName = dictionary["payment_gateway_name"] as? String
		if let providerDetailData = dictionary["provider_detail"] as? [String:Any]{
			providerDetail = HistoryProviderDetail(fromDictionary: providerDetailData)
		}
		success = dictionary["success"] as? Bool
		if let userDetailData = dictionary["user_detail"] as? [String:Any] {
			userDetail = HistoryUserDetail(fromDictionary: userDetailData)
		}
        currency = (dictionary["currency"] as? String) ?? ""

	}

}
