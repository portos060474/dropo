//
//	WalletHistoryResponse.swift
//
//	Create by Jaydeep Vyas on 27/10/2017
//	Copyright © 2017 Elluminati. All rights reserved.


import Foundation

class WalletTransactionHistoryResponse{

	var message : Int!
	var success : Bool!
	var walletRequestDetail : [WalletRequestDetail]!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		message = dictionary["message"] as? Int
		success = dictionary["success"] as? Bool
		walletRequestDetail = [WalletRequestDetail]()
		if let walletRequestDetailArray = dictionary["wallet_request_detail"] as? [[String:Any]]{
			for dic in walletRequestDetailArray{
				let value = WalletRequestDetail(fromDictionary: dic)
				walletRequestDetail.append(value)
			}
		}
	}

}
