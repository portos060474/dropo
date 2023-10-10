//
//	WalletRequestDetail.swift
//
//	Create by Elluminati on 27/10/2017
//	Copyright © 2017 Elluminati. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class WalletRequestDetail{

	var v : Int!
	var id : String!
	var adminCurrencyCode : String!
	var afterTotalWalletAmount : Double!
	var approvedRequstedWalletAmount : Double!
	var completedDate : String!
	var countryId : String!
	var createdAt : String!
	var descriptionForRequestWalletAmount : String!
	var requstedWalletAmount : Double!
	var totalWalletAmount : Double!
	var transactionDate : String!
	var transactionDetails : String!
	var uniqueId : Int!
	var updatedAt : String!
	var userId : String!
	var userType : Int!
	var userUniqueId : Int!
	var walletCurrencyCode : String!
	var walletStatus : Int!
	var walletToAdminCurrentRate : Int!
    var isPaymentModeCash:Bool!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		v = dictionary["__v"] as? Int
		id = dictionary["_id"] as? String
		adminCurrencyCode = dictionary["admin_currency_code"] as? String
		afterTotalWalletAmount = (dictionary["after_total_wallet_amount"] as? Double)?.roundTo() ?? 0.0
		approvedRequstedWalletAmount = (dictionary["approved_requested_wallet_amount"] as? Double)?.roundTo() ?? 0.0
		completedDate = dictionary["completed_date"] as? String
		countryId = dictionary["country_id"] as? String
		createdAt = dictionary["created_at"] as? String
		descriptionForRequestWalletAmount = dictionary["description_for_request_wallet_amount"] as? String
		requstedWalletAmount = (dictionary["requested_wallet_amount"] as? Double)?.roundTo() ?? 0.0
		totalWalletAmount = (dictionary["total_wallet_amount"] as? Double)?.roundTo() ?? 0.0
		transactionDate = dictionary["transaction_date"] as? String
		transactionDetails = dictionary["transaction_details"] as? String
		uniqueId = dictionary["unique_id"] as? Int
		updatedAt = dictionary["updated_at"] as? String
		userId = dictionary["user_id"] as? String
		userType = dictionary["user_type"] as? Int
		userUniqueId = dictionary["user_unique_id"] as? Int
		walletCurrencyCode = dictionary["wallet_currency_code"] as? String
		walletStatus = dictionary["wallet_status"] as? Int
		walletToAdminCurrentRate = dictionary["wallet_to_admin_current_rate"] as? Int
        isPaymentModeCash = (dictionary["is_payment_mode_cash"] as? Bool) ?? false
	}

}
