//
//	OrderPaymentDetail.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

/*
class OrderPaymentDetailNew : NSObject, NSCoding{

	var v : Int!
	var id : String!
	var adminCurrencyCode : String!
	var adminProfitModeOnDelivery : Int!
	var adminProfitModeOnStore : Int!
	var adminProfitValueOnDelivery : Int!
	var adminProfitValueOnStore : Int!
	var captureAmount : Int!
	var cardPayment : Int!
	var cartId : String!
	var cashPayment : Int!
	var cityId : String!
	var completedDateInCityTimezone : AnyObject!
	var completedDateTag : String!
	var countryId : String!
	var createdAt : String!
	var currencyCode : String!
	var currentRate : Int!
	var deliveryPriceUsedType : Int!
	var deliveryPriceUsedTypeId : AnyObject!
	var invoiceNumber : String!
	var isCancellationFee : Bool!
	var isDistanceUnitMile : Bool!
	var isMinFareApplied : Bool!
	var isOrderPaymentRefund : Bool!
	var isOrderPaymentStatusSetByStore : Bool!
	var isOrderPricePaidByStore : Bool!
	var isPaidFromWallet : Bool!
	var isPaymentModeCash : Bool!
	var isPaymentPaid : Bool!
	var isPromoForDeliveryService : Bool!
	var isProviderIncomeSetInWallet : Bool!
	var isStoreIncomeSetInWallet : Bool!
	var isStorePayDeliveryFees : Bool!
    var isStoreSetScheduleDeliveryTime : Bool!

	var isTransferedToProvider : Bool!
	var isTransferedToStore : Bool!
	var isUserPickUpOrder : Bool!
	var itemTax : Int!
	var orderCancellationCharge : Int!
	var orderCurrencyCode : String!
	var orderId : String!
	var orderUniqueId : Int!
	var otherPromoPaymentLoyalty : Int!
	var payToProvider : Int!
	var payToStore : Int!
	var paymentIntentId : String!
	var promoId : AnyObject!
	var promoPayment : Int!
	var providerIncomeSetInWallet : Int!
	var refundAmount : Int!
	var remainingPayment : Int!
	var serviceTax : Int!
	var storeId : String!
	var storeIncomeSetInWallet : Int!
	var tipAmount : Int!
	var tipValue : Int!
	var total : Double!
	var totalAdminProfitOnDelivery : Int!
	var totalAdminProfitOnStore : Int!
	var totalAdminTaxPrice : Float!
	var totalAfterWalletPayment : Int!
	var totalCartPrice : Int!
	var totalDeliveryPrice : Int!
	var totalDistance : Float!
	var totalItemCount : Int!
	var totalOrderPrice : Int!
	var totalProviderIncome : Int!
	var totalServicePrice : Float!
	var totalStoreIncome : Int!
	var totalStoreTaxPrice : Int!
	var totalTime : Float!
	var uniqueId : Int!
	var updatedAt : String!
	var userId : String!
	var userPayPayment : Int!
	var walletPayment : Int!
	var walletToAdminCurrentRate : Int!
	var walletToOrderCurrentRate : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		v = dictionary["__v"] as? Int
		id = dictionary["_id"] as? String
		adminCurrencyCode = dictionary["admin_currency_code"] as? String
		adminProfitModeOnDelivery = dictionary["admin_profit_mode_on_delivery"] as? Int
		adminProfitModeOnStore = dictionary["admin_profit_mode_on_store"] as? Int
		adminProfitValueOnDelivery = dictionary["admin_profit_value_on_delivery"] as? Int
		adminProfitValueOnStore = dictionary["admin_profit_value_on_store"] as? Int
		captureAmount = dictionary["capture_amount"] as? Int
		cardPayment = dictionary["card_payment"] as? Int
		cartId = dictionary["cart_id"] as? String
		cashPayment = dictionary["cash_payment"] as? Int
		cityId = dictionary["city_id"] as? String
		completedDateInCityTimezone = dictionary["completed_date_in_city_timezone"] as? AnyObject
		completedDateTag = dictionary["completed_date_tag"] as? String
		countryId = dictionary["country_id"] as? String
		createdAt = dictionary["created_at"] as? String
		currencyCode = dictionary["currency_code"] as? String
		currentRate = dictionary["current_rate"] as? Int
		deliveryPriceUsedType = dictionary["delivery_price_used_type"] as? Int
		deliveryPriceUsedTypeId = dictionary["delivery_price_used_type_id"] as? AnyObject
		invoiceNumber = dictionary["invoice_number"] as? String
		isCancellationFee = dictionary["is_cancellation_fee"] as? Bool
		isDistanceUnitMile = dictionary["is_distance_unit_mile"] as? Bool
		isMinFareApplied = dictionary["is_min_fare_applied"] as? Bool
		isOrderPaymentRefund = dictionary["is_order_payment_refund"] as? Bool
		isOrderPaymentStatusSetByStore = dictionary["is_order_payment_status_set_by_store"] as? Bool
		isOrderPricePaidByStore = dictionary["is_order_price_paid_by_store"] as? Bool
		isPaidFromWallet = dictionary["is_paid_from_wallet"] as? Bool
		isPaymentModeCash = dictionary["is_payment_mode_cash"] as? Bool ?? false
		isPaymentPaid = dictionary["is_payment_paid"] as? Bool
		isPromoForDeliveryService = dictionary["is_promo_for_delivery_service"] as? Bool
		isProviderIncomeSetInWallet = dictionary["is_provider_income_set_in_wallet"] as? Bool
		isStoreIncomeSetInWallet = dictionary["is_store_income_set_in_wallet"] as? Bool
		isStorePayDeliveryFees = dictionary["is_store_pay_delivery_fees"] as? Bool
        isStoreSetScheduleDeliveryTime = dictionary["is_store_set_schedule_delivery_time"] as? Bool

		isTransferedToProvider = dictionary["is_transfered_to_provider"] as? Bool
		isTransferedToStore = dictionary["is_transfered_to_store"] as? Bool
		isUserPickUpOrder = dictionary["is_user_pick_up_order"] as? Bool
		itemTax = dictionary["item_tax"] as? Int
		orderCancellationCharge = dictionary["order_cancellation_charge"] as? Int
		orderCurrencyCode = dictionary["order_currency_code"] as? String
		orderId = dictionary["order_id"] as? String ?? ""
		orderUniqueId = dictionary["order_unique_id"] as? Int ?? 0
		otherPromoPaymentLoyalty = dictionary["other_promo_payment_loyalty"] as? Int
		payToProvider = dictionary["pay_to_provider"] as? Int
		payToStore = dictionary["pay_to_store"] as? Int
		paymentIntentId = dictionary["payment_intent_id"] as? String
		promoId = dictionary["promo_id"] as? AnyObject
		promoPayment = dictionary["promo_payment"] as? Int
		providerIncomeSetInWallet = dictionary["provider_income_set_in_wallet"] as? Int
		refundAmount = dictionary["refund_amount"] as? Int
		remainingPayment = dictionary["remaining_payment"] as? Int
		serviceTax = dictionary["service_tax"] as? Int
		storeId = dictionary["store_id"] as? String
		storeIncomeSetInWallet = dictionary["store_income_set_in_wallet"] as? Int
		tipAmount = dictionary["tip_amount"] as? Int
		tipValue = dictionary["tip_value"] as? Int
        total = dictionary["total"] as? Double ?? 0.0
		totalAdminProfitOnDelivery = dictionary["total_admin_profit_on_delivery"] as? Int
		totalAdminProfitOnStore = dictionary["total_admin_profit_on_store"] as? Int
		totalAdminTaxPrice = dictionary["total_admin_tax_price"] as? Float
		totalAfterWalletPayment = dictionary["total_after_wallet_payment"] as? Int
		totalCartPrice = dictionary["total_cart_price"] as? Int
		totalDeliveryPrice = dictionary["total_delivery_price"] as? Int
		totalDistance = dictionary["total_distance"] as? Float
		totalItemCount = dictionary["total_item_count"] as? Int
		totalOrderPrice = dictionary["total_order_price"] as? Int
		totalProviderIncome = dictionary["total_provider_income"] as? Int
		totalServicePrice = dictionary["total_service_price"] as? Float
		totalStoreIncome = dictionary["total_store_income"] as? Int
		totalStoreTaxPrice = dictionary["total_store_tax_price"] as? Int
		totalTime = dictionary["total_time"] as? Float
		uniqueId = dictionary["unique_id"] as? Int
		updatedAt = dictionary["updated_at"] as? String
		userId = dictionary["user_id"] as? String
		userPayPayment = dictionary["user_pay_payment"] as? Int
		walletPayment = dictionary["wallet_payment"] as? Int
		walletToAdminCurrentRate = dictionary["wallet_to_admin_current_rate"] as? Int
		walletToOrderCurrentRate = dictionary["wallet_to_order_current_rate"] as? Int
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if v != nil{
			dictionary["__v"] = v
		}
		if id != nil{
			dictionary["_id"] = id
		}
		if adminCurrencyCode != nil{
			dictionary["admin_currency_code"] = adminCurrencyCode
		}
		if adminProfitModeOnDelivery != nil{
			dictionary["admin_profit_mode_on_delivery"] = adminProfitModeOnDelivery
		}
		if adminProfitModeOnStore != nil{
			dictionary["admin_profit_mode_on_store"] = adminProfitModeOnStore
		}
		if adminProfitValueOnDelivery != nil{
			dictionary["admin_profit_value_on_delivery"] = adminProfitValueOnDelivery
		}
		if adminProfitValueOnStore != nil{
			dictionary["admin_profit_value_on_store"] = adminProfitValueOnStore
		}
		if captureAmount != nil{
			dictionary["capture_amount"] = captureAmount
		}
		if cardPayment != nil{
			dictionary["card_payment"] = cardPayment
		}
		if cartId != nil{
			dictionary["cart_id"] = cartId
		}
		if cashPayment != nil{
			dictionary["cash_payment"] = cashPayment
		}
		if cityId != nil{
			dictionary["city_id"] = cityId
		}
		if completedDateInCityTimezone != nil{
			dictionary["completed_date_in_city_timezone"] = completedDateInCityTimezone
		}
		if completedDateTag != nil{
			dictionary["completed_date_tag"] = completedDateTag
		}
		if countryId != nil{
			dictionary["country_id"] = countryId
		}
		if createdAt != nil{
			dictionary["created_at"] = createdAt
		}
		if currencyCode != nil{
			dictionary["currency_code"] = currencyCode
		}
		if currentRate != nil{
			dictionary["current_rate"] = currentRate
		}
		if deliveryPriceUsedType != nil{
			dictionary["delivery_price_used_type"] = deliveryPriceUsedType
		}
		if deliveryPriceUsedTypeId != nil{
			dictionary["delivery_price_used_type_id"] = deliveryPriceUsedTypeId
		}
		if invoiceNumber != nil{
			dictionary["invoice_number"] = invoiceNumber
		}
		if isCancellationFee != nil{
			dictionary["is_cancellation_fee"] = isCancellationFee
		}
		if isDistanceUnitMile != nil{
			dictionary["is_distance_unit_mile"] = isDistanceUnitMile
		}
		if isMinFareApplied != nil{
			dictionary["is_min_fare_applied"] = isMinFareApplied
		}
		if isOrderPaymentRefund != nil{
			dictionary["is_order_payment_refund"] = isOrderPaymentRefund
		}
		if isOrderPaymentStatusSetByStore != nil{
			dictionary["is_order_payment_status_set_by_store"] = isOrderPaymentStatusSetByStore
		}
		if isOrderPricePaidByStore != nil{
			dictionary["is_order_price_paid_by_store"] = isOrderPricePaidByStore
		}
		if isPaidFromWallet != nil{
			dictionary["is_paid_from_wallet"] = isPaidFromWallet
		}
		if isPaymentModeCash != nil{
			dictionary["is_payment_mode_cash"] = isPaymentModeCash
		}
		if isPaymentPaid != nil{
			dictionary["is_payment_paid"] = isPaymentPaid
		}
		if isPromoForDeliveryService != nil{
			dictionary["is_promo_for_delivery_service"] = isPromoForDeliveryService
		}
		if isProviderIncomeSetInWallet != nil{
			dictionary["is_provider_income_set_in_wallet"] = isProviderIncomeSetInWallet
		}
		if isStoreIncomeSetInWallet != nil{
			dictionary["is_store_income_set_in_wallet"] = isStoreIncomeSetInWallet
		}
		if isStorePayDeliveryFees != nil{
			dictionary["is_store_pay_delivery_fees"] = isStorePayDeliveryFees
		}
        
        if isStoreSetScheduleDeliveryTime != nil{
            dictionary["is_store_set_schedule_delivery_time"] = isStoreSetScheduleDeliveryTime
        }
		if isTransferedToProvider != nil{
			dictionary["is_transfered_to_provider"] = isTransferedToProvider
		}
		if isTransferedToStore != nil{
			dictionary["is_transfered_to_store"] = isTransferedToStore
		}
		if isUserPickUpOrder != nil{
			dictionary["is_user_pick_up_order"] = isUserPickUpOrder
		}
		if itemTax != nil{
			dictionary["item_tax"] = itemTax
		}
		if orderCancellationCharge != nil{
			dictionary["order_cancellation_charge"] = orderCancellationCharge
		}
		if orderCurrencyCode != nil{
			dictionary["order_currency_code"] = orderCurrencyCode
		}
		if orderId != nil{
			dictionary["order_id"] = orderId
		}
		if orderUniqueId != nil{
			dictionary["order_unique_id"] = orderUniqueId
		}
		if otherPromoPaymentLoyalty != nil{
			dictionary["other_promo_payment_loyalty"] = otherPromoPaymentLoyalty
		}
		if payToProvider != nil{
			dictionary["pay_to_provider"] = payToProvider
		}
		if payToStore != nil{
			dictionary["pay_to_store"] = payToStore
		}
		if paymentIntentId != nil{
			dictionary["payment_intent_id"] = paymentIntentId
		}
		if promoId != nil{
			dictionary["promo_id"] = promoId
		}
		if promoPayment != nil{
			dictionary["promo_payment"] = promoPayment
		}
		if providerIncomeSetInWallet != nil{
			dictionary["provider_income_set_in_wallet"] = providerIncomeSetInWallet
		}
		if refundAmount != nil{
			dictionary["refund_amount"] = refundAmount
		}
		if remainingPayment != nil{
			dictionary["remaining_payment"] = remainingPayment
		}
		if serviceTax != nil{
			dictionary["service_tax"] = serviceTax
		}
		if storeId != nil{
			dictionary["store_id"] = storeId
		}
		if storeIncomeSetInWallet != nil{
			dictionary["store_income_set_in_wallet"] = storeIncomeSetInWallet
		}
		if tipAmount != nil{
			dictionary["tip_amount"] = tipAmount
		}
		if tipValue != nil{
			dictionary["tip_value"] = tipValue
		}
		if total != nil{
			dictionary["total"] = total
		}
		if totalAdminProfitOnDelivery != nil{
			dictionary["total_admin_profit_on_delivery"] = totalAdminProfitOnDelivery
		}
		if totalAdminProfitOnStore != nil{
			dictionary["total_admin_profit_on_store"] = totalAdminProfitOnStore
		}
		if totalAdminTaxPrice != nil{
			dictionary["total_admin_tax_price"] = totalAdminTaxPrice
		}
		if totalAfterWalletPayment != nil{
			dictionary["total_after_wallet_payment"] = totalAfterWalletPayment
		}
		if totalCartPrice != nil{
			dictionary["total_cart_price"] = totalCartPrice
		}
		if totalDeliveryPrice != nil{
			dictionary["total_delivery_price"] = totalDeliveryPrice
		}
		if totalDistance != nil{
			dictionary["total_distance"] = totalDistance
		}
		if totalItemCount != nil{
			dictionary["total_item_count"] = totalItemCount
		}
		if totalOrderPrice != nil{
			dictionary["total_order_price"] = totalOrderPrice
		}
		if totalProviderIncome != nil{
			dictionary["total_provider_income"] = totalProviderIncome
		}
		if totalServicePrice != nil{
			dictionary["total_service_price"] = totalServicePrice
		}
		if totalStoreIncome != nil{
			dictionary["total_store_income"] = totalStoreIncome
		}
		if totalStoreTaxPrice != nil{
			dictionary["total_store_tax_price"] = totalStoreTaxPrice
		}
		if totalTime != nil{
			dictionary["total_time"] = totalTime
		}
		if uniqueId != nil{
			dictionary["unique_id"] = uniqueId
		}
		if updatedAt != nil{
			dictionary["updated_at"] = updatedAt
		}
		if userId != nil{
			dictionary["user_id"] = userId
		}
		if userPayPayment != nil{
			dictionary["user_pay_payment"] = userPayPayment
		}
		if walletPayment != nil{
			dictionary["wallet_payment"] = walletPayment
		}
		if walletToAdminCurrentRate != nil{
			dictionary["wallet_to_admin_current_rate"] = walletToAdminCurrentRate
		}
		if walletToOrderCurrentRate != nil{
			dictionary["wallet_to_order_current_rate"] = walletToOrderCurrentRate
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         v = aDecoder.decodeObject(forKey: "__v") as? Int
         id = aDecoder.decodeObject(forKey: "_id") as? String
         adminCurrencyCode = aDecoder.decodeObject(forKey: "admin_currency_code") as? String
         adminProfitModeOnDelivery = aDecoder.decodeObject(forKey: "admin_profit_mode_on_delivery") as? Int
         adminProfitModeOnStore = aDecoder.decodeObject(forKey: "admin_profit_mode_on_store") as? Int
         adminProfitValueOnDelivery = aDecoder.decodeObject(forKey: "admin_profit_value_on_delivery") as? Int
         adminProfitValueOnStore = aDecoder.decodeObject(forKey: "admin_profit_value_on_store") as? Int
         captureAmount = aDecoder.decodeObject(forKey: "capture_amount") as? Int
         cardPayment = aDecoder.decodeObject(forKey: "card_payment") as? Int
         cartId = aDecoder.decodeObject(forKey: "cart_id") as? String
         cashPayment = aDecoder.decodeObject(forKey: "cash_payment") as? Int
         cityId = aDecoder.decodeObject(forKey: "city_id") as? String
         completedDateInCityTimezone = aDecoder.decodeObject(forKey: "completed_date_in_city_timezone") as? AnyObject
         completedDateTag = aDecoder.decodeObject(forKey: "completed_date_tag") as? String
         countryId = aDecoder.decodeObject(forKey: "country_id") as? String
         createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
         currencyCode = aDecoder.decodeObject(forKey: "currency_code") as? String
         currentRate = aDecoder.decodeObject(forKey: "current_rate") as? Int
         deliveryPriceUsedType = aDecoder.decodeObject(forKey: "delivery_price_used_type") as? Int
         deliveryPriceUsedTypeId = aDecoder.decodeObject(forKey: "delivery_price_used_type_id") as? AnyObject
         invoiceNumber = aDecoder.decodeObject(forKey: "invoice_number") as? String
         isCancellationFee = aDecoder.decodeObject(forKey: "is_cancellation_fee") as? Bool
         isDistanceUnitMile = aDecoder.decodeObject(forKey: "is_distance_unit_mile") as? Bool
         isMinFareApplied = aDecoder.decodeObject(forKey: "is_min_fare_applied") as? Bool
         isOrderPaymentRefund = aDecoder.decodeObject(forKey: "is_order_payment_refund") as? Bool
         isOrderPaymentStatusSetByStore = aDecoder.decodeObject(forKey: "is_order_payment_status_set_by_store") as? Bool
         isOrderPricePaidByStore = aDecoder.decodeObject(forKey: "is_order_price_paid_by_store") as? Bool
         isPaidFromWallet = aDecoder.decodeObject(forKey: "is_paid_from_wallet") as? Bool
         isPaymentModeCash = aDecoder.decodeObject(forKey: "is_payment_mode_cash") as? Bool
         isPaymentPaid = aDecoder.decodeObject(forKey: "is_payment_paid") as? Bool
         isPromoForDeliveryService = aDecoder.decodeObject(forKey: "is_promo_for_delivery_service") as? Bool
         isProviderIncomeSetInWallet = aDecoder.decodeObject(forKey: "is_provider_income_set_in_wallet") as? Bool
         isStoreIncomeSetInWallet = aDecoder.decodeObject(forKey: "is_store_income_set_in_wallet") as? Bool
         isStorePayDeliveryFees = aDecoder.decodeObject(forKey: "is_store_pay_delivery_fees") as? Bool
        isStoreSetScheduleDeliveryTime = aDecoder.decodeObject(forKey: "is_store_set_schedule_delivery_time") as? Bool

         isTransferedToProvider = aDecoder.decodeObject(forKey: "is_transfered_to_provider") as? Bool
         isTransferedToStore = aDecoder.decodeObject(forKey: "is_transfered_to_store") as? Bool
         isUserPickUpOrder = aDecoder.decodeObject(forKey: "is_user_pick_up_order") as? Bool
         itemTax = aDecoder.decodeObject(forKey: "item_tax") as? Int
         orderCancellationCharge = aDecoder.decodeObject(forKey: "order_cancellation_charge") as? Int
         orderCurrencyCode = aDecoder.decodeObject(forKey: "order_currency_code") as? String
         orderId = aDecoder.decodeObject(forKey: "order_id") as? String
         orderUniqueId = aDecoder.decodeObject(forKey: "order_unique_id") as? Int
         otherPromoPaymentLoyalty = aDecoder.decodeObject(forKey: "other_promo_payment_loyalty") as? Int
         payToProvider = aDecoder.decodeObject(forKey: "pay_to_provider") as? Int
         payToStore = aDecoder.decodeObject(forKey: "pay_to_store") as? Int
         paymentIntentId = aDecoder.decodeObject(forKey: "payment_intent_id") as? String
         promoId = aDecoder.decodeObject(forKey: "promo_id") as? AnyObject
         promoPayment = aDecoder.decodeObject(forKey: "promo_payment") as? Int
         providerIncomeSetInWallet = aDecoder.decodeObject(forKey: "provider_income_set_in_wallet") as? Int
         refundAmount = aDecoder.decodeObject(forKey: "refund_amount") as? Int
         remainingPayment = aDecoder.decodeObject(forKey: "remaining_payment") as? Int
         serviceTax = aDecoder.decodeObject(forKey: "service_tax") as? Int
         storeId = aDecoder.decodeObject(forKey: "store_id") as? String
         storeIncomeSetInWallet = aDecoder.decodeObject(forKey: "store_income_set_in_wallet") as? Int
         tipAmount = aDecoder.decodeObject(forKey: "tip_amount") as? Int
         tipValue = aDecoder.decodeObject(forKey: "tip_value") as? Int
         total = aDecoder.decodeObject(forKey: "total") as? Double ?? 0.0
         totalAdminProfitOnDelivery = aDecoder.decodeObject(forKey: "total_admin_profit_on_delivery") as? Int
         totalAdminProfitOnStore = aDecoder.decodeObject(forKey: "total_admin_profit_on_store") as? Int
         totalAdminTaxPrice = aDecoder.decodeObject(forKey: "total_admin_tax_price") as? Float
         totalAfterWalletPayment = aDecoder.decodeObject(forKey: "total_after_wallet_payment") as? Int
         totalCartPrice = aDecoder.decodeObject(forKey: "total_cart_price") as? Int
         totalDeliveryPrice = aDecoder.decodeObject(forKey: "total_delivery_price") as? Int
         totalDistance = aDecoder.decodeObject(forKey: "total_distance") as? Float
         totalItemCount = aDecoder.decodeObject(forKey: "total_item_count") as? Int
         totalOrderPrice = aDecoder.decodeObject(forKey: "total_order_price") as? Int
         totalProviderIncome = aDecoder.decodeObject(forKey: "total_provider_income") as? Int
         totalServicePrice = aDecoder.decodeObject(forKey: "total_service_price") as? Float
         totalStoreIncome = aDecoder.decodeObject(forKey: "total_store_income") as? Int
         totalStoreTaxPrice = aDecoder.decodeObject(forKey: "total_store_tax_price") as? Int
         totalTime = aDecoder.decodeObject(forKey: "total_time") as? Float
         uniqueId = aDecoder.decodeObject(forKey: "unique_id") as? Int
         updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? String
         userId = aDecoder.decodeObject(forKey: "user_id") as? String
         userPayPayment = aDecoder.decodeObject(forKey: "user_pay_payment") as? Int
         walletPayment = aDecoder.decodeObject(forKey: "wallet_payment") as? Int
         walletToAdminCurrentRate = aDecoder.decodeObject(forKey: "wallet_to_admin_current_rate") as? Int
         walletToOrderCurrentRate = aDecoder.decodeObject(forKey: "wallet_to_order_current_rate") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if v != nil{
			aCoder.encode(v, forKey: "__v")
		}
		if id != nil{
			aCoder.encode(id, forKey: "_id")
		}
		if adminCurrencyCode != nil{
			aCoder.encode(adminCurrencyCode, forKey: "admin_currency_code")
		}
		if adminProfitModeOnDelivery != nil{
			aCoder.encode(adminProfitModeOnDelivery, forKey: "admin_profit_mode_on_delivery")
		}
		if adminProfitModeOnStore != nil{
			aCoder.encode(adminProfitModeOnStore, forKey: "admin_profit_mode_on_store")
		}
		if adminProfitValueOnDelivery != nil{
			aCoder.encode(adminProfitValueOnDelivery, forKey: "admin_profit_value_on_delivery")
		}
		if adminProfitValueOnStore != nil{
			aCoder.encode(adminProfitValueOnStore, forKey: "admin_profit_value_on_store")
		}
		if captureAmount != nil{
			aCoder.encode(captureAmount, forKey: "capture_amount")
		}
		if cardPayment != nil{
			aCoder.encode(cardPayment, forKey: "card_payment")
		}
		if cartId != nil{
			aCoder.encode(cartId, forKey: "cart_id")
		}
		if cashPayment != nil{
			aCoder.encode(cashPayment, forKey: "cash_payment")
		}
		if cityId != nil{
			aCoder.encode(cityId, forKey: "city_id")
		}
		if completedDateInCityTimezone != nil{
			aCoder.encode(completedDateInCityTimezone, forKey: "completed_date_in_city_timezone")
		}
		if completedDateTag != nil{
			aCoder.encode(completedDateTag, forKey: "completed_date_tag")
		}
		if countryId != nil{
			aCoder.encode(countryId, forKey: "country_id")
		}
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "created_at")
		}
		if currencyCode != nil{
			aCoder.encode(currencyCode, forKey: "currency_code")
		}
		if currentRate != nil{
			aCoder.encode(currentRate, forKey: "current_rate")
		}
		if deliveryPriceUsedType != nil{
			aCoder.encode(deliveryPriceUsedType, forKey: "delivery_price_used_type")
		}
		if deliveryPriceUsedTypeId != nil{
			aCoder.encode(deliveryPriceUsedTypeId, forKey: "delivery_price_used_type_id")
		}
		if invoiceNumber != nil{
			aCoder.encode(invoiceNumber, forKey: "invoice_number")
		}
		if isCancellationFee != nil{
			aCoder.encode(isCancellationFee, forKey: "is_cancellation_fee")
		}
		if isDistanceUnitMile != nil{
			aCoder.encode(isDistanceUnitMile, forKey: "is_distance_unit_mile")
		}
		if isMinFareApplied != nil{
			aCoder.encode(isMinFareApplied, forKey: "is_min_fare_applied")
		}
		if isOrderPaymentRefund != nil{
			aCoder.encode(isOrderPaymentRefund, forKey: "is_order_payment_refund")
		}
		if isOrderPaymentStatusSetByStore != nil{
			aCoder.encode(isOrderPaymentStatusSetByStore, forKey: "is_order_payment_status_set_by_store")
		}
		if isOrderPricePaidByStore != nil{
			aCoder.encode(isOrderPricePaidByStore, forKey: "is_order_price_paid_by_store")
		}
		if isPaidFromWallet != nil{
			aCoder.encode(isPaidFromWallet, forKey: "is_paid_from_wallet")
		}
		if isPaymentModeCash != nil{
			aCoder.encode(isPaymentModeCash, forKey: "is_payment_mode_cash")
		}
		if isPaymentPaid != nil{
			aCoder.encode(isPaymentPaid, forKey: "is_payment_paid")
		}
		if isPromoForDeliveryService != nil{
			aCoder.encode(isPromoForDeliveryService, forKey: "is_promo_for_delivery_service")
		}
		if isProviderIncomeSetInWallet != nil{
			aCoder.encode(isProviderIncomeSetInWallet, forKey: "is_provider_income_set_in_wallet")
		}
		if isStoreIncomeSetInWallet != nil{
			aCoder.encode(isStoreIncomeSetInWallet, forKey: "is_store_income_set_in_wallet")
		}
		if isStorePayDeliveryFees != nil{
			aCoder.encode(isStorePayDeliveryFees, forKey: "is_store_pay_delivery_fees")
		}
        if isStoreSetScheduleDeliveryTime != nil{
            aCoder.encode(isStorePayDeliveryFees, forKey: "is_store_set_schedule_delivery_time")
        }
		if isTransferedToProvider != nil{
			aCoder.encode(isTransferedToProvider, forKey: "is_transfered_to_provider")
		}
		if isTransferedToStore != nil{
			aCoder.encode(isTransferedToStore, forKey: "is_transfered_to_store")
		}
		if isUserPickUpOrder != nil{
			aCoder.encode(isUserPickUpOrder, forKey: "is_user_pick_up_order")
		}
		if itemTax != nil{
			aCoder.encode(itemTax, forKey: "item_tax")
		}
		if orderCancellationCharge != nil{
			aCoder.encode(orderCancellationCharge, forKey: "order_cancellation_charge")
		}
		if orderCurrencyCode != nil{
			aCoder.encode(orderCurrencyCode, forKey: "order_currency_code")
		}
		if orderId != nil{
			aCoder.encode(orderId, forKey: "order_id")
		}
		if orderUniqueId != nil{
			aCoder.encode(orderUniqueId, forKey: "order_unique_id")
		}
		if otherPromoPaymentLoyalty != nil{
			aCoder.encode(otherPromoPaymentLoyalty, forKey: "other_promo_payment_loyalty")
		}
		if payToProvider != nil{
			aCoder.encode(payToProvider, forKey: "pay_to_provider")
		}
		if payToStore != nil{
			aCoder.encode(payToStore, forKey: "pay_to_store")
		}
		if paymentIntentId != nil{
			aCoder.encode(paymentIntentId, forKey: "payment_intent_id")
		}
		if promoId != nil{
			aCoder.encode(promoId, forKey: "promo_id")
		}
		if promoPayment != nil{
			aCoder.encode(promoPayment, forKey: "promo_payment")
		}
		if providerIncomeSetInWallet != nil{
			aCoder.encode(providerIncomeSetInWallet, forKey: "provider_income_set_in_wallet")
		}
		if refundAmount != nil{
			aCoder.encode(refundAmount, forKey: "refund_amount")
		}
		if remainingPayment != nil{
			aCoder.encode(remainingPayment, forKey: "remaining_payment")
		}
		if serviceTax != nil{
			aCoder.encode(serviceTax, forKey: "service_tax")
		}
		if storeId != nil{
			aCoder.encode(storeId, forKey: "store_id")
		}
		if storeIncomeSetInWallet != nil{
			aCoder.encode(storeIncomeSetInWallet, forKey: "store_income_set_in_wallet")
		}
		if tipAmount != nil{
			aCoder.encode(tipAmount, forKey: "tip_amount")
		}
		if tipValue != nil{
			aCoder.encode(tipValue, forKey: "tip_value")
		}
		if total != nil{
			aCoder.encode(total, forKey: "total")
		}
		if totalAdminProfitOnDelivery != nil{
			aCoder.encode(totalAdminProfitOnDelivery, forKey: "total_admin_profit_on_delivery")
		}
		if totalAdminProfitOnStore != nil{
			aCoder.encode(totalAdminProfitOnStore, forKey: "total_admin_profit_on_store")
		}
		if totalAdminTaxPrice != nil{
			aCoder.encode(totalAdminTaxPrice, forKey: "total_admin_tax_price")
		}
		if totalAfterWalletPayment != nil{
			aCoder.encode(totalAfterWalletPayment, forKey: "total_after_wallet_payment")
		}
		if totalCartPrice != nil{
			aCoder.encode(totalCartPrice, forKey: "total_cart_price")
		}
		if totalDeliveryPrice != nil{
			aCoder.encode(totalDeliveryPrice, forKey: "total_delivery_price")
		}
		if totalDistance != nil{
			aCoder.encode(totalDistance, forKey: "total_distance")
		}
		if totalItemCount != nil{
			aCoder.encode(totalItemCount, forKey: "total_item_count")
		}
		if totalOrderPrice != nil{
			aCoder.encode(totalOrderPrice, forKey: "total_order_price")
		}
		if totalProviderIncome != nil{
			aCoder.encode(totalProviderIncome, forKey: "total_provider_income")
		}
		if totalServicePrice != nil{
			aCoder.encode(totalServicePrice, forKey: "total_service_price")
		}
		if totalStoreIncome != nil{
			aCoder.encode(totalStoreIncome, forKey: "total_store_income")
		}
		if totalStoreTaxPrice != nil{
			aCoder.encode(totalStoreTaxPrice, forKey: "total_store_tax_price")
		}
		if totalTime != nil{
			aCoder.encode(totalTime, forKey: "total_time")
		}
		if uniqueId != nil{
			aCoder.encode(uniqueId, forKey: "unique_id")
		}
		if updatedAt != nil{
			aCoder.encode(updatedAt, forKey: "updated_at")
		}
		if userId != nil{
			aCoder.encode(userId, forKey: "user_id")
		}
		if userPayPayment != nil{
			aCoder.encode(userPayPayment, forKey: "user_pay_payment")
		}
		if walletPayment != nil{
			aCoder.encode(walletPayment, forKey: "wallet_payment")
		}
		if walletToAdminCurrentRate != nil{
			aCoder.encode(walletToAdminCurrentRate, forKey: "wallet_to_admin_current_rate")
		}
		if walletToOrderCurrentRate != nil{
			aCoder.encode(walletToOrderCurrentRate, forKey: "wallet_to_order_current_rate")
		}

	}

}
*/

//
//    OrderPaymentDetail.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class OrderPaymentDetailNew : NSObject, NSCoding{

    var v : Int!
    var id : String!
    var adminCurrencyCode : String!
    var adminProfitModeOnDelivery : Int!
    var adminProfitModeOnStore : Int!
    var adminProfitValueOnDelivery : Int!
    var adminProfitValueOnStore : Int!
    var captureAmount : Int!
    var cardPayment : Int!
    var cartId : String!
    var cashPayment : Int!
    var cityId : String!
    var completedDateInCityTimezone : AnyObject!
    var completedDateTag : String!
    var countryId : String!
    var createdAt : String!
    var currencyCode : String!
    var currentRate : Int!
    var deliveryPriceUsedType : Int!
    var deliveryPriceUsedTypeId : AnyObject!
    var invoiceNumber : String!
    var isCancellationFee : Bool!
    var isDistanceUnitMile : Bool!
    var isMinFareApplied : Bool!
    var isOrderPaymentRefund : Bool!
    var isOrderPaymentStatusSetByStore : Bool!
    var isOrderPricePaidByStore : Bool!
    var isPaidFromWallet : Bool!
    var isPaymentModeCash : Bool!
    var isPaymentPaid : Bool!
    var isPromoForDeliveryService : Bool!
    var isProviderIncomeSetInWallet : Bool!
    var isStoreIncomeSetInWallet : Bool!
    var isStorePayDeliveryFees : Bool!
    var isTransferedToProvider : Bool!
    var isTransferedToStore : Bool!
    var isUserPickUpOrder : Bool!
    var itemTax : Int!
    var orderCancellationCharge : Int!
    var orderCurrencyCode : String!
    var orderId : String!
    var orderUniqueId : Int!
    var otherPromoPaymentLoyalty : Int!
    var payToProvider : Int!
    var payToStore : Int!
    var paymentIntentId : String!
    var promoId : AnyObject!
    var promoPayment : Int!
    var providerIncomeSetInWallet : Int!
    var refundAmount : Int!
    var remainingPayment : Int!
    var serviceTax : Int!
    var storeId : String!
    var storeIncomeSetInWallet : Int!
    var tipAmount : Int!
    var tipValue : Int!
    var total : Int!
    var totalAdminProfitOnDelivery : Int!
    var totalAdminProfitOnStore : Float!
    var totalAdminTaxPrice : Int!
    var totalAfterWalletPayment : Int!
    var totalCartPrice : Int!
    var totalDeliveryPrice : Int!
    var totalDistance : Float!
    var totalItemCount : Int!
    var totalOrderPrice : Int!
    var totalProviderIncome : Int!
    var totalServicePrice : Int!
    var totalStoreIncome : Float!
    var totalStoreTaxPrice : Int!
    var totalTime : Float!
    var uniqueId : Int!
    var updatedAt : String!
    var userId : String!
    var userPayPayment : Int!
    var walletPayment : Int!
    var walletToAdminCurrentRate : Int!
    var walletToOrderCurrentRate : Int!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        v = dictionary["__v"] as? Int
        id = dictionary["_id"] as? String
        adminCurrencyCode = dictionary["admin_currency_code"] as? String
        adminProfitModeOnDelivery = dictionary["admin_profit_mode_on_delivery"] as? Int
        adminProfitModeOnStore = dictionary["admin_profit_mode_on_store"] as? Int
        adminProfitValueOnDelivery = dictionary["admin_profit_value_on_delivery"] as? Int
        adminProfitValueOnStore = dictionary["admin_profit_value_on_store"] as? Int
        captureAmount = dictionary["capture_amount"] as? Int
        cardPayment = dictionary["card_payment"] as? Int
        cartId = dictionary["cart_id"] as? String
        cashPayment = dictionary["cash_payment"] as? Int
        cityId = dictionary["city_id"] as? String
        completedDateInCityTimezone = dictionary["completed_date_in_city_timezone"] as? AnyObject
        completedDateTag = dictionary["completed_date_tag"] as? String
        countryId = dictionary["country_id"] as? String
        createdAt = dictionary["created_at"] as? String
        currencyCode = dictionary["currency_code"] as? String
        currentRate = dictionary["current_rate"] as? Int
        deliveryPriceUsedType = dictionary["delivery_price_used_type"] as? Int
        deliveryPriceUsedTypeId = dictionary["delivery_price_used_type_id"] as? AnyObject
        invoiceNumber = dictionary["invoice_number"] as? String
        isCancellationFee = dictionary["is_cancellation_fee"] as? Bool
        isDistanceUnitMile = dictionary["is_distance_unit_mile"] as? Bool
        isMinFareApplied = dictionary["is_min_fare_applied"] as? Bool
        isOrderPaymentRefund = dictionary["is_order_payment_refund"] as? Bool
        isOrderPaymentStatusSetByStore = dictionary["is_order_payment_status_set_by_store"] as? Bool
        isOrderPricePaidByStore = dictionary["is_order_price_paid_by_store"] as? Bool
        isPaidFromWallet = dictionary["is_paid_from_wallet"] as? Bool
        isPaymentModeCash = dictionary["is_payment_mode_cash"] as? Bool
        isPaymentPaid = dictionary["is_payment_paid"] as? Bool
        isPromoForDeliveryService = dictionary["is_promo_for_delivery_service"] as? Bool
        isProviderIncomeSetInWallet = dictionary["is_provider_income_set_in_wallet"] as? Bool
        isStoreIncomeSetInWallet = dictionary["is_store_income_set_in_wallet"] as? Bool
        isStorePayDeliveryFees = dictionary["is_store_pay_delivery_fees"] as? Bool
        isTransferedToProvider = dictionary["is_transfered_to_provider"] as? Bool
        isTransferedToStore = dictionary["is_transfered_to_store"] as? Bool
        isUserPickUpOrder = dictionary["is_user_pick_up_order"] as? Bool
        itemTax = dictionary["item_tax"] as? Int
        orderCancellationCharge = dictionary["order_cancellation_charge"] as? Int
        orderCurrencyCode = dictionary["order_currency_code"] as? String
        orderId = dictionary["order_id"] as? String
        orderUniqueId = dictionary["order_unique_id"] as? Int
        otherPromoPaymentLoyalty = dictionary["other_promo_payment_loyalty"] as? Int
        payToProvider = dictionary["pay_to_provider"] as? Int
        payToStore = dictionary["pay_to_store"] as? Int
        paymentIntentId = dictionary["payment_intent_id"] as? String
        promoId = dictionary["promo_id"] as? AnyObject
        promoPayment = dictionary["promo_payment"] as? Int
        providerIncomeSetInWallet = dictionary["provider_income_set_in_wallet"] as? Int
        refundAmount = dictionary["refund_amount"] as? Int
        remainingPayment = dictionary["remaining_payment"] as? Int
        serviceTax = dictionary["service_tax"] as? Int
        storeId = dictionary["store_id"] as? String
        storeIncomeSetInWallet = dictionary["store_income_set_in_wallet"] as? Int
        tipAmount = dictionary["tip_amount"] as? Int
        tipValue = dictionary["tip_value"] as? Int
        total = dictionary["total"] as? Int
        totalAdminProfitOnDelivery = dictionary["total_admin_profit_on_delivery"] as? Int
        totalAdminProfitOnStore = dictionary["total_admin_profit_on_store"] as? Float
        totalAdminTaxPrice = dictionary["total_admin_tax_price"] as? Int
        totalAfterWalletPayment = dictionary["total_after_wallet_payment"] as? Int
        totalCartPrice = dictionary["total_cart_price"] as? Int
        totalDeliveryPrice = dictionary["total_delivery_price"] as? Int
        totalDistance = dictionary["total_distance"] as? Float
        totalItemCount = dictionary["total_item_count"] as? Int
        totalOrderPrice = dictionary["total_order_price"] as? Int
        totalProviderIncome = dictionary["total_provider_income"] as? Int
        totalServicePrice = dictionary["total_service_price"] as? Int
        totalStoreIncome = dictionary["total_store_income"] as? Float
        totalStoreTaxPrice = dictionary["total_store_tax_price"] as? Int
        totalTime = dictionary["total_time"] as? Float
        uniqueId = dictionary["unique_id"] as? Int
        updatedAt = dictionary["updated_at"] as? String
        userId = dictionary["user_id"] as? String
        userPayPayment = dictionary["user_pay_payment"] as? Int
        walletPayment = dictionary["wallet_payment"] as? Int
        walletToAdminCurrentRate = dictionary["wallet_to_admin_current_rate"] as? Int
        walletToOrderCurrentRate = dictionary["wallet_to_order_current_rate"] as? Int
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if v != nil{
            dictionary["__v"] = v
        }
        if id != nil{
            dictionary["_id"] = id
        }
        if adminCurrencyCode != nil{
            dictionary["admin_currency_code"] = adminCurrencyCode
        }
        if adminProfitModeOnDelivery != nil{
            dictionary["admin_profit_mode_on_delivery"] = adminProfitModeOnDelivery
        }
        if adminProfitModeOnStore != nil{
            dictionary["admin_profit_mode_on_store"] = adminProfitModeOnStore
        }
        if adminProfitValueOnDelivery != nil{
            dictionary["admin_profit_value_on_delivery"] = adminProfitValueOnDelivery
        }
        if adminProfitValueOnStore != nil{
            dictionary["admin_profit_value_on_store"] = adminProfitValueOnStore
        }
        if captureAmount != nil{
            dictionary["capture_amount"] = captureAmount
        }
        if cardPayment != nil{
            dictionary["card_payment"] = cardPayment
        }
        if cartId != nil{
            dictionary["cart_id"] = cartId
        }
        if cashPayment != nil{
            dictionary["cash_payment"] = cashPayment
        }
        if cityId != nil{
            dictionary["city_id"] = cityId
        }
        if completedDateInCityTimezone != nil{
            dictionary["completed_date_in_city_timezone"] = completedDateInCityTimezone
        }
        if completedDateTag != nil{
            dictionary["completed_date_tag"] = completedDateTag
        }
        if countryId != nil{
            dictionary["country_id"] = countryId
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if currencyCode != nil{
            dictionary["currency_code"] = currencyCode
        }
        if currentRate != nil{
            dictionary["current_rate"] = currentRate
        }
        if deliveryPriceUsedType != nil{
            dictionary["delivery_price_used_type"] = deliveryPriceUsedType
        }
        if deliveryPriceUsedTypeId != nil{
            dictionary["delivery_price_used_type_id"] = deliveryPriceUsedTypeId
        }
        if invoiceNumber != nil{
            dictionary["invoice_number"] = invoiceNumber
        }
        if isCancellationFee != nil{
            dictionary["is_cancellation_fee"] = isCancellationFee
        }
        if isDistanceUnitMile != nil{
            dictionary["is_distance_unit_mile"] = isDistanceUnitMile
        }
        if isMinFareApplied != nil{
            dictionary["is_min_fare_applied"] = isMinFareApplied
        }
        if isOrderPaymentRefund != nil{
            dictionary["is_order_payment_refund"] = isOrderPaymentRefund
        }
        if isOrderPaymentStatusSetByStore != nil{
            dictionary["is_order_payment_status_set_by_store"] = isOrderPaymentStatusSetByStore
        }
        if isOrderPricePaidByStore != nil{
            dictionary["is_order_price_paid_by_store"] = isOrderPricePaidByStore
        }
        if isPaidFromWallet != nil{
            dictionary["is_paid_from_wallet"] = isPaidFromWallet
        }
        if isPaymentModeCash != nil{
            dictionary["is_payment_mode_cash"] = isPaymentModeCash
        }
        if isPaymentPaid != nil{
            dictionary["is_payment_paid"] = isPaymentPaid
        }
        if isPromoForDeliveryService != nil{
            dictionary["is_promo_for_delivery_service"] = isPromoForDeliveryService
        }
        if isProviderIncomeSetInWallet != nil{
            dictionary["is_provider_income_set_in_wallet"] = isProviderIncomeSetInWallet
        }
        if isStoreIncomeSetInWallet != nil{
            dictionary["is_store_income_set_in_wallet"] = isStoreIncomeSetInWallet
        }
        if isStorePayDeliveryFees != nil{
            dictionary["is_store_pay_delivery_fees"] = isStorePayDeliveryFees
        }
        if isTransferedToProvider != nil{
            dictionary["is_transfered_to_provider"] = isTransferedToProvider
        }
        if isTransferedToStore != nil{
            dictionary["is_transfered_to_store"] = isTransferedToStore
        }
        if isUserPickUpOrder != nil{
            dictionary["is_user_pick_up_order"] = isUserPickUpOrder
        }
        if itemTax != nil{
            dictionary["item_tax"] = itemTax
        }
        if orderCancellationCharge != nil{
            dictionary["order_cancellation_charge"] = orderCancellationCharge
        }
        if orderCurrencyCode != nil{
            dictionary["order_currency_code"] = orderCurrencyCode
        }
        if orderId != nil{
            dictionary["order_id"] = orderId
        }
        if orderUniqueId != nil{
            dictionary["order_unique_id"] = orderUniqueId
        }
        if otherPromoPaymentLoyalty != nil{
            dictionary["other_promo_payment_loyalty"] = otherPromoPaymentLoyalty
        }
        if payToProvider != nil{
            dictionary["pay_to_provider"] = payToProvider
        }
        if payToStore != nil{
            dictionary["pay_to_store"] = payToStore
        }
        if paymentIntentId != nil{
            dictionary["payment_intent_id"] = paymentIntentId
        }
        if promoId != nil{
            dictionary["promo_id"] = promoId
        }
        if promoPayment != nil{
            dictionary["promo_payment"] = promoPayment
        }
        if providerIncomeSetInWallet != nil{
            dictionary["provider_income_set_in_wallet"] = providerIncomeSetInWallet
        }
        if refundAmount != nil{
            dictionary["refund_amount"] = refundAmount
        }
        if remainingPayment != nil{
            dictionary["remaining_payment"] = remainingPayment
        }
        if serviceTax != nil{
            dictionary["service_tax"] = serviceTax
        }
        if storeId != nil{
            dictionary["store_id"] = storeId
        }
        if storeIncomeSetInWallet != nil{
            dictionary["store_income_set_in_wallet"] = storeIncomeSetInWallet
        }
        if tipAmount != nil{
            dictionary["tip_amount"] = tipAmount
        }
        if tipValue != nil{
            dictionary["tip_value"] = tipValue
        }
        if total != nil{
            dictionary["total"] = total
        }
        if totalAdminProfitOnDelivery != nil{
            dictionary["total_admin_profit_on_delivery"] = totalAdminProfitOnDelivery
        }
        if totalAdminProfitOnStore != nil{
            dictionary["total_admin_profit_on_store"] = totalAdminProfitOnStore
        }
        if totalAdminTaxPrice != nil{
            dictionary["total_admin_tax_price"] = totalAdminTaxPrice
        }
        if totalAfterWalletPayment != nil{
            dictionary["total_after_wallet_payment"] = totalAfterWalletPayment
        }
        if totalCartPrice != nil{
            dictionary["total_cart_price"] = totalCartPrice
        }
        if totalDeliveryPrice != nil{
            dictionary["total_delivery_price"] = totalDeliveryPrice
        }
        if totalDistance != nil{
            dictionary["total_distance"] = totalDistance
        }
        if totalItemCount != nil{
            dictionary["total_item_count"] = totalItemCount
        }
        if totalOrderPrice != nil{
            dictionary["total_order_price"] = totalOrderPrice
        }
        if totalProviderIncome != nil{
            dictionary["total_provider_income"] = totalProviderIncome
        }
        if totalServicePrice != nil{
            dictionary["total_service_price"] = totalServicePrice
        }
        if totalStoreIncome != nil{
            dictionary["total_store_income"] = totalStoreIncome
        }
        if totalStoreTaxPrice != nil{
            dictionary["total_store_tax_price"] = totalStoreTaxPrice
        }
        if totalTime != nil{
            dictionary["total_time"] = totalTime
        }
        if uniqueId != nil{
            dictionary["unique_id"] = uniqueId
        }
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        if userId != nil{
            dictionary["user_id"] = userId
        }
        if userPayPayment != nil{
            dictionary["user_pay_payment"] = userPayPayment
        }
        if walletPayment != nil{
            dictionary["wallet_payment"] = walletPayment
        }
        if walletToAdminCurrentRate != nil{
            dictionary["wallet_to_admin_current_rate"] = walletToAdminCurrentRate
        }
        if walletToOrderCurrentRate != nil{
            dictionary["wallet_to_order_current_rate"] = walletToOrderCurrentRate
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         v = aDecoder.decodeObject(forKey: "__v") as? Int
         id = aDecoder.decodeObject(forKey: "_id") as? String
         adminCurrencyCode = aDecoder.decodeObject(forKey: "admin_currency_code") as? String
         adminProfitModeOnDelivery = aDecoder.decodeObject(forKey: "admin_profit_mode_on_delivery") as? Int
         adminProfitModeOnStore = aDecoder.decodeObject(forKey: "admin_profit_mode_on_store") as? Int
         adminProfitValueOnDelivery = aDecoder.decodeObject(forKey: "admin_profit_value_on_delivery") as? Int
         adminProfitValueOnStore = aDecoder.decodeObject(forKey: "admin_profit_value_on_store") as? Int
         captureAmount = aDecoder.decodeObject(forKey: "capture_amount") as? Int
         cardPayment = aDecoder.decodeObject(forKey: "card_payment") as? Int
         cartId = aDecoder.decodeObject(forKey: "cart_id") as? String
         cashPayment = aDecoder.decodeObject(forKey: "cash_payment") as? Int
         cityId = aDecoder.decodeObject(forKey: "city_id") as? String
         completedDateInCityTimezone = aDecoder.decodeObject(forKey: "completed_date_in_city_timezone") as? AnyObject
         completedDateTag = aDecoder.decodeObject(forKey: "completed_date_tag") as? String
         countryId = aDecoder.decodeObject(forKey: "country_id") as? String
         createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
         currencyCode = aDecoder.decodeObject(forKey: "currency_code") as? String
         currentRate = aDecoder.decodeObject(forKey: "current_rate") as? Int
         deliveryPriceUsedType = aDecoder.decodeObject(forKey: "delivery_price_used_type") as? Int
         deliveryPriceUsedTypeId = aDecoder.decodeObject(forKey: "delivery_price_used_type_id") as? AnyObject
         invoiceNumber = aDecoder.decodeObject(forKey: "invoice_number") as? String
         isCancellationFee = aDecoder.decodeObject(forKey: "is_cancellation_fee") as? Bool
         isDistanceUnitMile = aDecoder.decodeObject(forKey: "is_distance_unit_mile") as? Bool
         isMinFareApplied = aDecoder.decodeObject(forKey: "is_min_fare_applied") as? Bool
         isOrderPaymentRefund = aDecoder.decodeObject(forKey: "is_order_payment_refund") as? Bool
         isOrderPaymentStatusSetByStore = aDecoder.decodeObject(forKey: "is_order_payment_status_set_by_store") as? Bool
         isOrderPricePaidByStore = aDecoder.decodeObject(forKey: "is_order_price_paid_by_store") as? Bool
         isPaidFromWallet = aDecoder.decodeObject(forKey: "is_paid_from_wallet") as? Bool
         isPaymentModeCash = aDecoder.decodeObject(forKey: "is_payment_mode_cash") as? Bool
         isPaymentPaid = aDecoder.decodeObject(forKey: "is_payment_paid") as? Bool
         isPromoForDeliveryService = aDecoder.decodeObject(forKey: "is_promo_for_delivery_service") as? Bool
         isProviderIncomeSetInWallet = aDecoder.decodeObject(forKey: "is_provider_income_set_in_wallet") as? Bool
         isStoreIncomeSetInWallet = aDecoder.decodeObject(forKey: "is_store_income_set_in_wallet") as? Bool
         isStorePayDeliveryFees = aDecoder.decodeObject(forKey: "is_store_pay_delivery_fees") as? Bool
         isTransferedToProvider = aDecoder.decodeObject(forKey: "is_transfered_to_provider") as? Bool
         isTransferedToStore = aDecoder.decodeObject(forKey: "is_transfered_to_store") as? Bool
         isUserPickUpOrder = aDecoder.decodeObject(forKey: "is_user_pick_up_order") as? Bool
         itemTax = aDecoder.decodeObject(forKey: "item_tax") as? Int
         orderCancellationCharge = aDecoder.decodeObject(forKey: "order_cancellation_charge") as? Int
         orderCurrencyCode = aDecoder.decodeObject(forKey: "order_currency_code") as? String
         orderId = aDecoder.decodeObject(forKey: "order_id") as? String
         orderUniqueId = aDecoder.decodeObject(forKey: "order_unique_id") as? Int
         otherPromoPaymentLoyalty = aDecoder.decodeObject(forKey: "other_promo_payment_loyalty") as? Int
         payToProvider = aDecoder.decodeObject(forKey: "pay_to_provider") as? Int
         payToStore = aDecoder.decodeObject(forKey: "pay_to_store") as? Int
         paymentIntentId = aDecoder.decodeObject(forKey: "payment_intent_id") as? String
         promoId = aDecoder.decodeObject(forKey: "promo_id") as? AnyObject
         promoPayment = aDecoder.decodeObject(forKey: "promo_payment") as? Int
         providerIncomeSetInWallet = aDecoder.decodeObject(forKey: "provider_income_set_in_wallet") as? Int
         refundAmount = aDecoder.decodeObject(forKey: "refund_amount") as? Int
         remainingPayment = aDecoder.decodeObject(forKey: "remaining_payment") as? Int
         serviceTax = aDecoder.decodeObject(forKey: "service_tax") as? Int
         storeId = aDecoder.decodeObject(forKey: "store_id") as? String
         storeIncomeSetInWallet = aDecoder.decodeObject(forKey: "store_income_set_in_wallet") as? Int
         tipAmount = aDecoder.decodeObject(forKey: "tip_amount") as? Int
         tipValue = aDecoder.decodeObject(forKey: "tip_value") as? Int
         total = aDecoder.decodeObject(forKey: "total") as? Int
         totalAdminProfitOnDelivery = aDecoder.decodeObject(forKey: "total_admin_profit_on_delivery") as? Int
         totalAdminProfitOnStore = aDecoder.decodeObject(forKey: "total_admin_profit_on_store") as? Float
         totalAdminTaxPrice = aDecoder.decodeObject(forKey: "total_admin_tax_price") as? Int
         totalAfterWalletPayment = aDecoder.decodeObject(forKey: "total_after_wallet_payment") as? Int
         totalCartPrice = aDecoder.decodeObject(forKey: "total_cart_price") as? Int
         totalDeliveryPrice = aDecoder.decodeObject(forKey: "total_delivery_price") as? Int
         totalDistance = aDecoder.decodeObject(forKey: "total_distance") as? Float
         totalItemCount = aDecoder.decodeObject(forKey: "total_item_count") as? Int
         totalOrderPrice = aDecoder.decodeObject(forKey: "total_order_price") as? Int
         totalProviderIncome = aDecoder.decodeObject(forKey: "total_provider_income") as? Int
         totalServicePrice = aDecoder.decodeObject(forKey: "total_service_price") as? Int
         totalStoreIncome = aDecoder.decodeObject(forKey: "total_store_income") as? Float
         totalStoreTaxPrice = aDecoder.decodeObject(forKey: "total_store_tax_price") as? Int
         totalTime = aDecoder.decodeObject(forKey: "total_time") as? Float
         uniqueId = aDecoder.decodeObject(forKey: "unique_id") as? Int
         updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? String
         userId = aDecoder.decodeObject(forKey: "user_id") as? String
         userPayPayment = aDecoder.decodeObject(forKey: "user_pay_payment") as? Int
         walletPayment = aDecoder.decodeObject(forKey: "wallet_payment") as? Int
         walletToAdminCurrentRate = aDecoder.decodeObject(forKey: "wallet_to_admin_current_rate") as? Int
         walletToOrderCurrentRate = aDecoder.decodeObject(forKey: "wallet_to_order_current_rate") as? Int

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
    {
        if v != nil{
            aCoder.encode(v, forKey: "__v")
        }
        if id != nil{
            aCoder.encode(id, forKey: "_id")
        }
        if adminCurrencyCode != nil{
            aCoder.encode(adminCurrencyCode, forKey: "admin_currency_code")
        }
        if adminProfitModeOnDelivery != nil{
            aCoder.encode(adminProfitModeOnDelivery, forKey: "admin_profit_mode_on_delivery")
        }
        if adminProfitModeOnStore != nil{
            aCoder.encode(adminProfitModeOnStore, forKey: "admin_profit_mode_on_store")
        }
        if adminProfitValueOnDelivery != nil{
            aCoder.encode(adminProfitValueOnDelivery, forKey: "admin_profit_value_on_delivery")
        }
        if adminProfitValueOnStore != nil{
            aCoder.encode(adminProfitValueOnStore, forKey: "admin_profit_value_on_store")
        }
        if captureAmount != nil{
            aCoder.encode(captureAmount, forKey: "capture_amount")
        }
        if cardPayment != nil{
            aCoder.encode(cardPayment, forKey: "card_payment")
        }
        if cartId != nil{
            aCoder.encode(cartId, forKey: "cart_id")
        }
        if cashPayment != nil{
            aCoder.encode(cashPayment, forKey: "cash_payment")
        }
        if cityId != nil{
            aCoder.encode(cityId, forKey: "city_id")
        }
        if completedDateInCityTimezone != nil{
            aCoder.encode(completedDateInCityTimezone, forKey: "completed_date_in_city_timezone")
        }
        if completedDateTag != nil{
            aCoder.encode(completedDateTag, forKey: "completed_date_tag")
        }
        if countryId != nil{
            aCoder.encode(countryId, forKey: "country_id")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "created_at")
        }
        if currencyCode != nil{
            aCoder.encode(currencyCode, forKey: "currency_code")
        }
        if currentRate != nil{
            aCoder.encode(currentRate, forKey: "current_rate")
        }
        if deliveryPriceUsedType != nil{
            aCoder.encode(deliveryPriceUsedType, forKey: "delivery_price_used_type")
        }
        if deliveryPriceUsedTypeId != nil{
            aCoder.encode(deliveryPriceUsedTypeId, forKey: "delivery_price_used_type_id")
        }
        if invoiceNumber != nil{
            aCoder.encode(invoiceNumber, forKey: "invoice_number")
        }
        if isCancellationFee != nil{
            aCoder.encode(isCancellationFee, forKey: "is_cancellation_fee")
        }
        if isDistanceUnitMile != nil{
            aCoder.encode(isDistanceUnitMile, forKey: "is_distance_unit_mile")
        }
        if isMinFareApplied != nil{
            aCoder.encode(isMinFareApplied, forKey: "is_min_fare_applied")
        }
        if isOrderPaymentRefund != nil{
            aCoder.encode(isOrderPaymentRefund, forKey: "is_order_payment_refund")
        }
        if isOrderPaymentStatusSetByStore != nil{
            aCoder.encode(isOrderPaymentStatusSetByStore, forKey: "is_order_payment_status_set_by_store")
        }
        if isOrderPricePaidByStore != nil{
            aCoder.encode(isOrderPricePaidByStore, forKey: "is_order_price_paid_by_store")
        }
        if isPaidFromWallet != nil{
            aCoder.encode(isPaidFromWallet, forKey: "is_paid_from_wallet")
        }
        if isPaymentModeCash != nil{
            aCoder.encode(isPaymentModeCash, forKey: "is_payment_mode_cash")
        }
        if isPaymentPaid != nil{
            aCoder.encode(isPaymentPaid, forKey: "is_payment_paid")
        }
        if isPromoForDeliveryService != nil{
            aCoder.encode(isPromoForDeliveryService, forKey: "is_promo_for_delivery_service")
        }
        if isProviderIncomeSetInWallet != nil{
            aCoder.encode(isProviderIncomeSetInWallet, forKey: "is_provider_income_set_in_wallet")
        }
        if isStoreIncomeSetInWallet != nil{
            aCoder.encode(isStoreIncomeSetInWallet, forKey: "is_store_income_set_in_wallet")
        }
        if isStorePayDeliveryFees != nil{
            aCoder.encode(isStorePayDeliveryFees, forKey: "is_store_pay_delivery_fees")
        }
        if isTransferedToProvider != nil{
            aCoder.encode(isTransferedToProvider, forKey: "is_transfered_to_provider")
        }
        if isTransferedToStore != nil{
            aCoder.encode(isTransferedToStore, forKey: "is_transfered_to_store")
        }
        if isUserPickUpOrder != nil{
            aCoder.encode(isUserPickUpOrder, forKey: "is_user_pick_up_order")
        }
        if itemTax != nil{
            aCoder.encode(itemTax, forKey: "item_tax")
        }
        if orderCancellationCharge != nil{
            aCoder.encode(orderCancellationCharge, forKey: "order_cancellation_charge")
        }
        if orderCurrencyCode != nil{
            aCoder.encode(orderCurrencyCode, forKey: "order_currency_code")
        }
        if orderId != nil{
            aCoder.encode(orderId, forKey: "order_id")
        }
        if orderUniqueId != nil{
            aCoder.encode(orderUniqueId, forKey: "order_unique_id")
        }
        if otherPromoPaymentLoyalty != nil{
            aCoder.encode(otherPromoPaymentLoyalty, forKey: "other_promo_payment_loyalty")
        }
        if payToProvider != nil{
            aCoder.encode(payToProvider, forKey: "pay_to_provider")
        }
        if payToStore != nil{
            aCoder.encode(payToStore, forKey: "pay_to_store")
        }
        if paymentIntentId != nil{
            aCoder.encode(paymentIntentId, forKey: "payment_intent_id")
        }
        if promoId != nil{
            aCoder.encode(promoId, forKey: "promo_id")
        }
        if promoPayment != nil{
            aCoder.encode(promoPayment, forKey: "promo_payment")
        }
        if providerIncomeSetInWallet != nil{
            aCoder.encode(providerIncomeSetInWallet, forKey: "provider_income_set_in_wallet")
        }
        if refundAmount != nil{
            aCoder.encode(refundAmount, forKey: "refund_amount")
        }
        if remainingPayment != nil{
            aCoder.encode(remainingPayment, forKey: "remaining_payment")
        }
        if serviceTax != nil{
            aCoder.encode(serviceTax, forKey: "service_tax")
        }
        if storeId != nil{
            aCoder.encode(storeId, forKey: "store_id")
        }
        if storeIncomeSetInWallet != nil{
            aCoder.encode(storeIncomeSetInWallet, forKey: "store_income_set_in_wallet")
        }
        if tipAmount != nil{
            aCoder.encode(tipAmount, forKey: "tip_amount")
        }
        if tipValue != nil{
            aCoder.encode(tipValue, forKey: "tip_value")
        }
        if total != nil{
            aCoder.encode(total, forKey: "total")
        }
        if totalAdminProfitOnDelivery != nil{
            aCoder.encode(totalAdminProfitOnDelivery, forKey: "total_admin_profit_on_delivery")
        }
        if totalAdminProfitOnStore != nil{
            aCoder.encode(totalAdminProfitOnStore, forKey: "total_admin_profit_on_store")
        }
        if totalAdminTaxPrice != nil{
            aCoder.encode(totalAdminTaxPrice, forKey: "total_admin_tax_price")
        }
        if totalAfterWalletPayment != nil{
            aCoder.encode(totalAfterWalletPayment, forKey: "total_after_wallet_payment")
        }
        if totalCartPrice != nil{
            aCoder.encode(totalCartPrice, forKey: "total_cart_price")
        }
        if totalDeliveryPrice != nil{
            aCoder.encode(totalDeliveryPrice, forKey: "total_delivery_price")
        }
        if totalDistance != nil{
            aCoder.encode(totalDistance, forKey: "total_distance")
        }
        if totalItemCount != nil{
            aCoder.encode(totalItemCount, forKey: "total_item_count")
        }
        if totalOrderPrice != nil{
            aCoder.encode(totalOrderPrice, forKey: "total_order_price")
        }
        if totalProviderIncome != nil{
            aCoder.encode(totalProviderIncome, forKey: "total_provider_income")
        }
        if totalServicePrice != nil{
            aCoder.encode(totalServicePrice, forKey: "total_service_price")
        }
        if totalStoreIncome != nil{
            aCoder.encode(totalStoreIncome, forKey: "total_store_income")
        }
        if totalStoreTaxPrice != nil{
            aCoder.encode(totalStoreTaxPrice, forKey: "total_store_tax_price")
        }
        if totalTime != nil{
            aCoder.encode(totalTime, forKey: "total_time")
        }
        if uniqueId != nil{
            aCoder.encode(uniqueId, forKey: "unique_id")
        }
        if updatedAt != nil{
            aCoder.encode(updatedAt, forKey: "updated_at")
        }
        if userId != nil{
            aCoder.encode(userId, forKey: "user_id")
        }
        if userPayPayment != nil{
            aCoder.encode(userPayPayment, forKey: "user_pay_payment")
        }
        if walletPayment != nil{
            aCoder.encode(walletPayment, forKey: "wallet_payment")
        }
        if walletToAdminCurrentRate != nil{
            aCoder.encode(walletToAdminCurrentRate, forKey: "wallet_to_admin_current_rate")
        }
        if walletToOrderCurrentRate != nil{
            aCoder.encode(walletToOrderCurrentRate, forKey: "wallet_to_order_current_rate")
        }

    }

}
