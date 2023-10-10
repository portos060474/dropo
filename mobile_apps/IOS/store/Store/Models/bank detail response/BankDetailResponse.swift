//
//	RootClass.swift
//
//	Create by Jaydeep Vyas on 24/10/2017
//	Copyright © 2017 Elluminati. All rights reserved.


import Foundation

class BankDetailResponse{

	var bankDetail : [BankDetail]!
	var message : Int!
	var success : Bool!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		bankDetail = [BankDetail]()
		if let bankDetailArray = dictionary["bank_detail"] as? [[String:Any]]{
			for dic in bankDetailArray{
				let value = BankDetail(fromDictionary: dic)
				bankDetail.append(value)
			}
		}
		message = dictionary["message"] as? Int
		success = dictionary["success"] as? Bool
	}

}
