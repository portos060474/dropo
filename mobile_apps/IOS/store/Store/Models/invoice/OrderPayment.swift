//
//	HistoryOrderPaymentDetail.swift
//
//	Create by Jaydeep Vyas on 6/8/2017
//	Copyright © 2017 Elluminati. All rights reserved.

import Foundation

class OrderPayment {
	var v : Int!
	var id : String!
    var orderUniqueId:Int!
	var adminCurrencyCode : String!
	var adminProfitModeOnDelivery : Int!
	var adminProfitModeOnStore : Int!
	var adminProfitValueOnDelivery : Double!
	var adminProfitValueOnStore : Double!
	var basePrice : Double!
	var basePriceDistance : Double!
	var cardPayment : Double!
	var cashPayment : Double!
	var createdAt : String!
	var currencyCode : String!
	var currentRate : Double!
	var deliveredAt : String!
	var deliveryPrice : Double!
	var distancePrice : Double!
	var isCancellationFee : Bool!
	var isDistanceUnitMile : Bool!
	var isMinFareUsed : Bool!
	var isPaymentModeCash : Bool!
	var isPaymentPaid : Bool!
	var isPendingPayment : Bool!
	var isSurgeHours : Bool!
//	var itemTax : Double!
	var minFare : Double!
	var orderId : String!
	var paymentId : String!
	var pricePerUnitDistance : Double!
	var pricePerUnitTime : Double!
	var promoPayment : Double!
	var providerId : String!
	var remainingPayment : Double!
	var serviceTax : Double!
	var surgeCharges : Double!
	var total : Double!
	var totalAdminProfitOnDelivery : Double!
	var totalAdminProfitOnStore : Double!
	var totalAdminTaxPrice : Double!
	var totalAfterTaxPrice : Double!
	var totalAfterWalletPayment : Double!
	var totalBasePrice : Double!
	var totalDeliveryAndStorePrice : Double!
	var totalDeliveryPrice : Double!
	var totalDeliveryPriceAfterSurge : Double!
	var totalDistance : Double!
	var totalDistancePrice : Double!
	var totalItem : Int!
    var totalItemPrice : Double!
    var totalCartPrice : Double!
	var totalOrderPrice : Double!
	var totalProviderIncome : Double!
	var totalServicePrice : Double!
    var tipAmount : Double!

	var totalSpecifications : Int!
	var totalStoreIncome : Double!
	var totalStoreTaxPrice : Double!
	var totalSurgePrice : Double!
	var totalTime : Double!
	var totalTimePrice : Double!
	var uniqueId : Int!
	var updatedAt : String!
	var userId : String!
	var walletPayment : Double!
    var totalItemSpecificationPrice : Double!
    var isPromoForDeliveryService: Bool = false
    var providerPaidOrderPayment: Double!
    var providerHaveCashPayment:Double!
    var storeHaveServicePayment:Double!
    var storeHaveOrderPayment:Double!
    var payToStore:Double!
    var isUserPickupOrder:Bool!
    var deliveryPriceUsedType : Int!
    var isOrderPaymentStatusSetByStore : Bool!
    var taxDetails : [TaxesDetail]!
    var booking_fees:Double!

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		v = dictionary["__v"] as? Int
		id = dictionary["_id"] as? String
        isUserPickupOrder = (dictionary["is_user_pick_up_order"] as? Bool) ?? false
		adminCurrencyCode = dictionary["admin_currency_code"] as? String
        deliveryPriceUsedType = (dictionary["delivery_price_used_type"] as? Int) ?? 0
		adminProfitModeOnDelivery = dictionary["admin_profit_mode_on_delivery"] as? Int
		adminProfitModeOnStore = dictionary["admin_profit_mode_on_store"] as? Int
		adminProfitValueOnDelivery = (dictionary["admin_profit_value_on_delivery"] as?  Double)?.roundTo() ?? 0.0
		adminProfitValueOnStore = (dictionary["admin_profit_value_on_store"] as?  Double)?.roundTo() ?? 0.0
		basePrice = (dictionary["base_price"] as?  Double)?.roundTo() ?? 0.0
		basePriceDistance = (dictionary["base_price_distance"] as?  Double)?.roundTo() ?? 0.0
		cardPayment = (dictionary["card_payment"] as?  Double)?.roundTo() ?? 0.0
		cashPayment = (dictionary["cash_payment"] as?  Double)?.roundTo() ?? 0.0
		createdAt = dictionary["createdAt"] as? String
		currencyCode = dictionary["currency_code"] as? String
		currentRate = (dictionary["current_rate"] as?  Double)?.roundTo() ?? 0.0
		deliveredAt = dictionary["delivered_at"] as? String
		deliveryPrice = (dictionary["delivery_price"] as?  Double)?.roundTo() ?? 0.0
		distancePrice = (dictionary["distance_price"] as?  Double)?.roundTo() ?? 0.0
		isCancellationFee = dictionary["is_cancellation_fee"] as? Bool
		isDistanceUnitMile = dictionary["is_distance_unit_mile"] as? Bool
		isMinFareUsed = dictionary["is_min_fare_used"] as? Bool
		isPaymentModeCash = dictionary["is_payment_mode_cash"] as? Bool
		isPaymentPaid = dictionary["is_payment_paid"] as? Bool
		isPendingPayment = dictionary["is_pending_payment"] as? Bool
		isSurgeHours = dictionary["is_surge_hours"] as? Bool
//		itemTax = (dictionary["item_tax"] as? Double)?.roundTo() ?? 0.0
		minFare = (dictionary["min_fare"] as? Double)?.roundTo() ?? 0.0
		orderId = dictionary["order_id"] as? String
		paymentId = dictionary["payment_id"] as? String
		pricePerUnitDistance = (dictionary["price_per_unit_distance"] as?  Double)?.roundTo() ?? 0.0
		pricePerUnitTime = (dictionary["price_per_unit_time"] as?  Double)?.roundTo() ?? 0.0
		promoPayment = (dictionary["promo_payment"] as?  Double)?.roundTo() ?? 0.0
		providerId = dictionary["provider_id"] as? String
		remainingPayment = (dictionary["remaining_payment"] as?  Double)?.roundTo() ?? 0.0
		serviceTax = (dictionary["service_tax"] as?  Double)?.roundTo() ?? 0.0
		surgeCharges = (dictionary["surge_charges"] as?  Double)?.roundTo() ?? 0.0
		total = (dictionary["total"] as?  Double)?.roundTo() ?? 0.0
		totalAdminProfitOnDelivery = (dictionary["total_admin_profit_on_delivery"] as?  Double)?.roundTo() ?? 0.0
		totalAdminProfitOnStore = (dictionary["total_admin_profit_on_store"] as?  Double)?.roundTo() ?? 0.0
		totalAdminTaxPrice = (dictionary["total_admin_tax_price"] as?  Double)?.roundTo() ?? 0.0
		totalAfterTaxPrice = (dictionary["total_after_tax_price"] as?  Double)?.roundTo() ?? 0.0
		totalAfterWalletPayment = (dictionary["total_after_wallet_payment"] as?  Double)?.roundTo() ?? 0.0
		totalBasePrice = (dictionary["total_base_price"] as?  Double)?.roundTo() ?? 0.0
		totalDeliveryAndStorePrice = (dictionary["total_delivery_and_store_price"] as?  Double)?.roundTo() ?? 0.0
		totalDeliveryPrice = (dictionary["total_delivery_price"] as?  Double)?.roundTo() ?? 0.0
		totalDeliveryPriceAfterSurge = (dictionary["total_delivery_price_after_surge"] as?  Double)?.roundTo() ?? 0.0
		totalDistance = (dictionary["total_distance"] as?  Double)?.roundTo() ?? 0.0
		totalDistancePrice = (dictionary["total_distance_price"] as?  Double)?.roundTo() ?? 0.0
		totalItem = (dictionary["total_item_count"] as?  Int) ?? 0
        isOrderPaymentStatusSetByStore = dictionary["is_order_payment_status_set_by_store"] as? Bool

        totalItemPrice = (dictionary["total_item_price"] as?  Double)?.roundTo() ?? 0.0
		totalOrderPrice = (dictionary["total_order_price"] as?  Double)?.roundTo() ?? 0.0
		totalProviderIncome = (dictionary["total_provider_income"] as?  Double)?.roundTo() ?? 0.0
		totalServicePrice = (dictionary["total_service_price"] as?  Double)?.roundTo() ?? 0.0
        tipAmount = (dictionary["tip_amount"] as?  Double)?.roundTo() ?? 0.0

		totalSpecifications = (dictionary["total_specifications"] as? Int) ?? 0
		totalStoreIncome = (dictionary["total_store_income"] as?  Double)?.roundTo() ?? 0.0
		totalStoreTaxPrice = (dictionary["total_store_tax_price"] as?  Double)?.roundTo() ?? 0.0
		totalSurgePrice = (dictionary["total_surge_price"] as?  Double)?.roundTo() ?? 0.0
		totalTime = (dictionary["total_time"] as?  Double)?.roundTo() ?? 0.0
		totalTimePrice = (dictionary["total_time_price"] as? Double)?.roundTo() ?? 0.0
		uniqueId = dictionary["unique_id"] as? Int
		updatedAt = dictionary["updated_at"] as? String
		userId = dictionary["user_id"] as? String
		walletPayment = (dictionary["wallet_payment"] as? Double)?.roundTo() ?? 0.0
        totalItemSpecificationPrice = (dictionary["total_specification_price"] as? Double)?.roundTo() ?? 0.00
        providerPaidOrderPayment = (dictionary["provider_paid_order_payment"] as? Double)?.roundTo() ?? 0.00
         totalCartPrice = (dictionary["total_cart_price"] as? Double)?.roundTo() ?? 0.00
        orderUniqueId = (dictionary["order_unique_id"] as? Int) ?? 0
        providerHaveCashPayment = (dictionary["provider_have_cash_payment"] as? Double)?.roundTo() ?? 0.00
        storeHaveServicePayment = (dictionary["store_have_service_payment"] as? Double)?.roundTo() ?? 0.00
        storeHaveOrderPayment = (dictionary["store_have_order_payment"] as? Double)?.roundTo() ?? 0.00
        payToStore = (dictionary["pay_to_store"] as? Double)?.roundTo() ?? 0.00
        booking_fees = (dictionary["booking_fees"] as? Double)?.roundTo() ?? 0.00

        if dictionary["is_promo_for_delivery_service"] != nil {
            isPromoForDeliveryService = (dictionary["is_promo_for_delivery_service"] as? Bool)!
        }

        taxDetails = [TaxesDetail]()
        if let taxDetailsArray = dictionary["taxes"] as? [[String:Any]]{
            for dic in taxDetailsArray{
                let value = TaxesDetail(fromDictionary: dic)
                taxDetails.append(value)
            }
        }
	}
}
