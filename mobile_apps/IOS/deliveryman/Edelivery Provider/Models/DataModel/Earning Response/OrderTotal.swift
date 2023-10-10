//
//	OrderTotal.swift
//
//	Create by Elluminati on 28/6/2017
//	Copyright © 2017 Elluminati. All rights reserved.


import Foundation

class OrderTotal{

	var id : Any!
	var payToProvider : Double! = 0.0
	var providerHaveCashPayment : Double! = 0.0
	var providerPaidOrderPayment : Double! = 0.0
	var totalAdminProfitOnDelivery : Double! = 0.0
	var totalAdminTaxPrice : Double! = 0.0
	var totalDeliveryPrice : Double! = 0.0
	var totalEarning : Double! = 0.0
	var totalProviderProfit : Double! = 0.0
	var totalServicePrice : Double! = 0.0
	var totalSurgePrice : Double! = 0.0
	var totalProviderHaveCashPaymentOnHand : Double! = 0.0
    var totalWalletIncomeSet : Double! = 0.0
    var totalWalletIncomeSetInCashOrder : Double! = 0.0
    var totalWalletIncomeSetInOtherOrder : Double! = 0.0
    var totalRemainingToPaid : Double! = 0.0
    var totalPaid : Double! = 0.0
	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		id = dictionary["_id"] ?? "0.0."
		payToProvider = (dictionary["pay_to_provider"] as? Double) ?? 0.0
		providerHaveCashPayment = (dictionary["provider_have_cash_payment"] as? Double) ?? 0.0
		providerPaidOrderPayment = (dictionary["provider_paid_order_payment"] as? Double) ?? 0.0
		totalAdminProfitOnDelivery = (dictionary["total_admin_profit_on_delivery"] as? Double) ?? 0.0
		totalAdminTaxPrice = (dictionary["total_admin_tax_price"] as? Double) ?? 0.0
		totalDeliveryPrice = (dictionary["total_delivery_price"] as? Double) ?? 0.0
		totalEarning = (dictionary["total_earning"] as? Double) ?? 0.0
		totalProviderProfit = (dictionary["total_provider_profit"] as? Double) ?? 0.0
		totalServicePrice = (dictionary["total_service_price"] as? Double) ?? 0.0
		totalSurgePrice = (dictionary["total_surge_price"] as? Double) ?? 0.0
        totalWalletIncomeSetInCashOrder = (dictionary["total_deduct_wallet_income"] as? Double) ?? 0.0
        totalWalletIncomeSetInOtherOrder = (dictionary["total_added_wallet_income"] as? Double) ?? 0.0
       
        totalProviderHaveCashPaymentOnHand = (dictionary["total_provider_have_cash_payment_on_hand"] as? Double) ?? 0.0
        
        totalPaid = (dictionary["total_transferred_amount"] as? Double) ?? 0.0
        totalRemainingToPaid = (dictionary["total_remaining_to_paid"] as? Double) ?? 0.0
		totalWalletIncomeSet = (dictionary["total_wallet_income_set"] as? Double) ?? 0.0
	}

}
