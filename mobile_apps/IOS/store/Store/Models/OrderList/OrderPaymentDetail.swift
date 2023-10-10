import Foundation

class OrderPaymentDetail{
    
    var v : Int!
    var id : String!
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
    //var currencyCode : String!
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
    var isPromoForDeliveryService : Bool!
    var isSurgeHours : Bool!
    var itemTax : Double!
    var minFare : Double!
    var orderId : String!
    var orderPrice : Double!
    var payToProvider : Double!
    var payToStore : Double!
    var paymentId : String!
    var pricePerUnitDistance : Double!
    var pricePerUnitTime : Double!
    var promoPayment : Double!
    var providerHaveCashPayment : Double!
    var providerId : String!
    var providerPaidOrderPayment : Double!
    var remainingPayment : Double!
    var serviceTax : Double!
    var storeHaveOrderPayment : Double!
    var storeHaveServicePayment : Double!
    var storeId : String!
    var surgeCharges : Double!
    var total : Double!
    var totalAdminProfitOnDelivery : Double!
    var totalAdminProfitOnStore : Double!
    var totalAdminTaxPrice : Double!
    var totalAfterTaxPrice : Double!
    var totalAfterWalletPayment : Double!
    var totalBasePrice : Double!
    var totalDeliveryPrice : Double!
    var totalDeliveryPriceAfterSurge : Double!
    var totalDistance : Double!
    var totalDistancePrice : Double!
    var totalItemCount : Double!
    var totalItemPrice : Double!
    var totalOrderPrice : Double!
    var totalProviderHavePayment : Double!
    var totalProviderIncome : Double!
    var totalServicePrice : Double!
    var totalSpecificationCount : Int!
    //var totalSpecificationPrice : Double!
    var totalStoreHavePayment : Double!
    var totalStoreIncome : Double!
    var totalStoreTaxPrice : Double!
    var totalSurgePrice : Double!
    var totalTime : Double!
    var totalTimePrice : Double!
    var uniqueId : Int!
    var updatedAt : String!
    var userId : String!
    var walletPayment : Double!
    var isOrderPaymentStatusSetByStore: Bool!
    var isUserPickupOrder:Bool!
    var orderUniqueId:Int!
    var deliveryPriceUsedType:Int!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        v = dictionary["__v"] as? Int
        id = dictionary["_id"] as? String
        deliveryPriceUsedType = (dictionary["delivery_price_used_type"] as? Int) ?? 0
        isUserPickupOrder = (dictionary["is_user_pick_up_order"] as? Bool) ?? false
        adminCurrencyCode = dictionary["admin_currency_code"] as? String
        adminProfitModeOnDelivery = dictionary["admin_profit_mode_on_delivery"] as? Int
        adminProfitModeOnStore = dictionary["admin_profit_mode_on_store"] as? Int
        adminProfitValueOnDelivery = (dictionary["admin_profit_value_on_delivery"] as? Double)?.roundTo() ?? 0.0
        adminProfitValueOnStore = (dictionary["admin_profit_value_on_store"] as? Double)?.roundTo() ?? 0.00
        basePrice = (dictionary["base_price"] as? Double)?.roundTo() ?? 0.00
        basePriceDistance = (dictionary["base_price_distance"] as? Double)?.roundTo() ?? 0.00
        
        cardPayment = (dictionary["card_payment"] as? Double)?.roundTo() ?? 0.00
        cashPayment = (dictionary["cash_payment"] as? Double)?.roundTo() ?? 0.00
        createdAt = dictionary["created_at"] as? String
       // currencyCode = dictionary["currency_code"] as? String
        currentRate = (dictionary["current_rate"] as? Double)?.roundTo() ?? 0.00
        deliveredAt = dictionary["delivered_at"] as? String
        deliveryPrice = (dictionary["delivery_price"] as? Double)?.roundTo() ?? 0.00
        distancePrice = (dictionary["distance_price"] as? Double)?.roundTo() ?? 0.00
        isCancellationFee = dictionary["is_cancellation_fee"] as? Bool
        isDistanceUnitMile = dictionary["is_distance_unit_mile"] as? Bool
        isMinFareUsed = dictionary["is_min_fare_used"] as? Bool
        isPaymentModeCash = dictionary["is_payment_mode_cash"] as? Bool ?? true
        isPaymentPaid = dictionary["is_payment_paid"] as? Bool
        isPendingPayment = dictionary["is_pending_payment"] as? Bool
        isPromoForDeliveryService = dictionary["is_promo_for_delivery_service"] as? Bool
        isSurgeHours = dictionary["is_surge_hours"] as? Bool
        itemTax = (dictionary["item_tax"] as? Double)?.roundTo() ?? 0.00
        minFare = (dictionary["min_fare"] as? Double)?.roundTo() ?? 0.00
        orderId = (dictionary["order_id"] as? String) ?? ""
        orderPrice = (dictionary["order_price"] as? Double)?.roundTo() ?? 0.00
        payToProvider = (dictionary["pay_to_provider"] as? Double)?.roundTo() ?? 0.00
        payToStore = (dictionary["pay_to_store"] as? Double)?.roundTo() ?? 0.00
        paymentId = dictionary["payment_id"] as? String
        pricePerUnitDistance = (dictionary["price_per_unit_distance"] as? Double)?.roundTo() ?? 0.00
        pricePerUnitTime = (dictionary["price_per_unit_time"] as? Double)?.roundTo() ?? 0.00
        promoPayment = (dictionary["promo_payment"] as? Double)?.roundTo() ?? 0.00
        providerHaveCashPayment = (dictionary["provider_have_cash_payment"] as? Double)?.roundTo() ?? 0.00
        providerId = dictionary["provider_id"] as? String
        providerPaidOrderPayment = (dictionary["provider_paid_order_payment"] as? Double)?.roundTo() ?? 0.00
        remainingPayment = (dictionary["remaining_payment"] as? Double)?.roundTo() ?? 0.00
        serviceTax = (dictionary["service_tax"] as? Double)?.roundTo() ?? 0.00
        storeHaveOrderPayment = (dictionary["store_have_order_payment"] as? Double)?.roundTo() ?? 0.00
        storeHaveServicePayment = (dictionary["store_have_service_payment"] as? Double)?.roundTo() ?? 0.00
        storeId = dictionary["store_id"] as? String
        surgeCharges = (dictionary["surge_charges"] as? Double)?.roundTo() ?? 0.00
        total = (dictionary["total"] as? Double)?.roundTo() ?? 0.00
        totalAdminProfitOnDelivery = (dictionary["total_admin_profit_on_delivery"] as? Double)?.roundTo() ?? 0.00
        totalAdminProfitOnStore = (dictionary["total_admin_profit_on_store"] as? Double)?.roundTo() ?? 0.00
        totalAdminTaxPrice = (dictionary["total_admin_tax_price"] as? Double)?.roundTo() ?? 0.00
        totalAfterTaxPrice = (dictionary["total_after_tax_price"] as? Double)?.roundTo() ?? 0.00
        totalAfterWalletPayment = (dictionary["total_after_wallet_payment"] as? Double)?.roundTo() ?? 0.00
        totalBasePrice = (dictionary["total_base_price"] as? Double)?.roundTo() ?? 0.00
        totalDeliveryPrice = (dictionary["total_delivery_price"] as? Double)?.roundTo() ?? 0.00
        totalDeliveryPriceAfterSurge = (dictionary["total_delivery_price_after_surge"] as? Double)?.roundTo() ?? 0.00
        totalDistance = (dictionary["total_distance"] as? Double)?.roundTo() ?? 0.00
        totalDistancePrice = (dictionary["total_distance_price"] as? Double)?.roundTo() ?? 0.00
        totalItemCount = (dictionary["total_item_count"] as? Double)?.roundTo() ?? 0.00
        totalItemPrice = (dictionary["total_item_price"] as? Double)?.roundTo() ?? 0.00
        totalOrderPrice = (dictionary["total_order_price"] as? Double)?.roundTo() ?? 0.00
        totalProviderHavePayment = (dictionary["total_provider_have_payment"] as? Double)?.roundTo() ?? 0.00
        totalProviderIncome = (dictionary["total_provider_income"] as? Double)?.roundTo() ?? 0.00
        totalServicePrice = (dictionary["total_service_price"] as? Double)?.roundTo() ?? 0.00
        totalSpecificationCount = dictionary["total_specification_count"] as? Int
        //totalSpecificationPrice = (dictionary["total_specification_price"] as? Double)?.roundTo() ?? 0.00
        totalStoreHavePayment = (dictionary["total_store_have_payment"] as? Double)?.roundTo() ?? 0.00
        totalStoreIncome = (dictionary["total_store_income"] as? Double)?.roundTo() ?? 0.00
        totalStoreTaxPrice = (dictionary["total_store_tax_price"] as? Double)?.roundTo() ?? 0.00
        totalSurgePrice = (dictionary["total_surge_price"] as? Double)?.roundTo() ?? 0.00
        totalTime = (dictionary["total_time"] as? Double)?.roundTo() ?? 0.00
        totalTimePrice = (dictionary["total_time_price"] as? Double)?.roundTo() ?? 0.00
        uniqueId = dictionary["unique_id"] as? Int
        updatedAt = dictionary["updated_at"] as? String
        userId = dictionary["user_id"] as? String
        walletPayment = (dictionary["wallet_payment"] as? Double)?.roundTo() ?? 0.00
        isOrderPaymentStatusSetByStore = (dictionary["is_order_payment_status_set_by_store"] as? Bool) ?? false
        orderUniqueId = (dictionary["order_unique_id"] as? Int) ?? 0
    }
    
}
