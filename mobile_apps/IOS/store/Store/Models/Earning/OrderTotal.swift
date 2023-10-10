//
//	OrderTotal.swift
//
//	Create by Jaydeep Vyas on 8/8/2017
//	Copyright © 2017 Elluminati. All rights reserved.


import Foundation

class OrderTotal{

	var payToStore : Double!
	var storeHaveOrderPayment : Double!
	var storeHaveServicePayment : Double!
	var totalAdminProfitOnStore : Double!
	var totalEarning : Double!
	var totalItemPrice : Double!
	var totalOrderPrice : Double!
	var totalStoreIncome : Double!
	var totalStoreTaxPrice : Double!
    var totalWalletIncomeSet : Double! = 0.0
    var totalWalletIncomeSetInCashOrder : Double! = 0.0
    var totalWalletIncomeSetInOtherOrder : Double! = 0.0
    var totalRemainingToPaid : Double! = 0.0
    var totalPaid : Double! = 0.0


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
        payToStore = (dictionary["pay_to_store"] as? Double) ?? 0.0

        storeHaveOrderPayment = (dictionary["store_have_order_payment"] as? Double) ?? 0.0

        storeHaveServicePayment = (dictionary["store_have_service_payment"] as? Double) ?? 0.0

		totalAdminProfitOnStore = (dictionary["total_admin_profit_on_store"] as? Double) ?? 0.0
		totalEarning = (dictionary["total_earning"] as? Double) ?? 0.0
		totalItemPrice = (dictionary["total_item_price"] as? Double) ?? 0.0
		totalOrderPrice = (dictionary["total_order_price"] as? Double) ?? 0.0
		totalStoreIncome = (dictionary["total_store_income"] as? Double) ?? 0.0
		totalStoreTaxPrice = (dictionary["total_store_tax_price"] as? Double) ?? 0.0
        totalWalletIncomeSetInCashOrder = (dictionary["total_deduct_wallet_income"] as? Double) ?? 0.0
        totalWalletIncomeSetInOtherOrder = (dictionary["total_added_wallet_income"] as? Double) ?? 0.0
        totalPaid = (dictionary["total_transferred_amount"] as? Double) ?? 0.0
        totalRemainingToPaid = (dictionary["total_remaining_to_paid"] as? Double) ?? 0.0
        totalWalletIncomeSet = (dictionary["total_wallet_income_set"] as? Double) ?? 0.0
	}

}
