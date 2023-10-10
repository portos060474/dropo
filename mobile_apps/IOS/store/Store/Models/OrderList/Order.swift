//
//	Order.swift
//
//	Create by Jaydeep Vyas on 10/8/2017
//	Copyright © 2017 Elluminati. All rights reserved.


import Foundation

class Order{

	var v : Int!
	var id : String!
	var acceptedAt : String!
	var adminCurrency : String!
	var arrivedOnStoreAt : String!
	var cancelledAt : String!
	var completedAt : String!
	var createdAt : String!
	var currentProvider : String!
	var deliveredAt : String!

	var invoiceNumber : Int!
	var isCancellationFee : Bool!
	var isDistanceUnitMile : Bool!
	var isMinFareUsed : Bool!
	var isPaymentModeCash : Bool!
	var isPaymentPaid : Bool!
	var isPendingPayment : Bool!
	var isScheduleOrder : Bool!
	var isSurgeHours : Bool!
	var cartDetail : CartDetail!
	var orderPaymentId : String!
	var orderReadyAt : String!
	var orderStatus : Int!
    var deliveryStatus:Int!
	var orderStatusBy : String!
	var orderStatusId : Int!
	var orderType : Int!
	var pickedOrderAt : String!
	var promoCode : String!
	var promoId : String!
	var providersDetail : [OrderProviderDetail]!
    var providerId : String!
	var providerLocation : [Double]!
	var providerPreviousLocation : [Double]!
	var providerType : Int!
	var providerTypeId : String!
	var providersIdThatRejectedOrder : [String]!
	var scheduleOrderServerStartAt : String!
	var scheduleOrderStartAt : String!
    var scheduleOrderStartAt2 : String!
	var serviceId : String!
    var destinationAddresses : [Address]!
    var pickupAddresses : [Address]!
    
	var startForDeliveryAt : String!
	var startForPickupAt : String!
	var startPreparingOrderAt : String!
	var storeAcceptedAt : String!
	var storeId : String!
	var storeNotify : Int!
	var storeOrderCreatedAt : String!
	var totalOrderPrice1 : Double!
    var total : Double!

	var uniqueCode : Int!
	var uniqueId : Int!
    
    var order_unique_id : Int!

	var updatedAt : String!
    /*user details*/
	var userDetail : OrderUserDetail!
	var userId : String!
	var userType : Int!
	var userTypeId : String!
    var requestId : String!
    var timeZone:String!
    var order_change:Bool!
    var isUserPickupOrder:Bool!    
    var orderPaymentDetail:OrderPayment!
    var delivery_type : Int!

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		v = dictionary["__v"] as? Int
		id = dictionary["_id"] as? String
		acceptedAt = dictionary["accepted_at"] as? String
		adminCurrency = dictionary["admin_currency"] as? String
		arrivedOnStoreAt = dictionary["arrived_on_store_at"] as? String
		cancelledAt = dictionary["cancelled_at"] as? String
		completedAt = dictionary["completed_at"] as? String
		createdAt = dictionary["created_at"] as? String
		requestId = (dictionary["request_id"] as? String) ?? ""
      	currentProvider = dictionary["current_provider"] as? String
		deliveredAt = dictionary["delivered_at"] as? String
		invoiceNumber = dictionary["invoice_number"] as? Int
		isCancellationFee = dictionary["is_cancellation_fee"] as? Bool
		isDistanceUnitMile = dictionary["is_distance_unit_mile"] as? Bool
		isMinFareUsed = dictionary["is_min_fare_used"] as? Bool
		isPaymentModeCash = (dictionary["is_payment_mode_cash"] as? Bool) ?? false
		isPaymentPaid = dictionary["is_payment_paid"] as? Bool
		isPendingPayment = dictionary["is_pending_payment"] as? Bool
		isScheduleOrder = dictionary["is_schedule_order"] as? Bool
		isSurgeHours = dictionary["is_surge_hours"] as? Bool
        timeZone = (dictionary["timezone"] as? String) ?? TimeZone.ReferenceType.local.identifier
        if let cartDetailData = dictionary["cart_detail"] as? [String:Any] {
            cartDetail = CartDetail(fromDictionary: cartDetailData)
        }else {
            cartDetail = CartDetail(fromDictionary: [:])
        }
        if let orderPaymentData = dictionary["order_payment_detail"] as? [String:Any] {
            orderPaymentDetail = OrderPayment.init(fromDictionary: orderPaymentData)
        }else{
            orderPaymentDetail = OrderPayment.init(fromDictionary: [:])
        }
        
        
        destinationAddresses = [Address]()
        if let destinationAddressesArray = dictionary["destination_addresses"] as? [[String:Any]]{
            for dic in destinationAddressesArray{
                let value = Address(fromDictionary: dic)
                destinationAddresses.append(value)
            }
        }
        pickupAddresses = [Address]()
        if let pickupAddressesArray = dictionary["pickup_addresses"] as? [[String:Any]]{
            for dic in pickupAddressesArray{
                let value = Address(fromDictionary: dic)
                pickupAddresses.append(value)
            }
        }
		orderPaymentId = dictionary["order_payment_id"] as? String
		orderReadyAt = dictionary["order_ready_at"] as? String
        
		orderStatus = dictionary["order_status"] as? Int
        order_change = dictionary["order_change"] as? Bool

        deliveryStatus = dictionary["delivery_status"] as? Int
		orderStatusBy = dictionary["order_status_by"] as? String
		orderStatusId = dictionary["order_status_id"] as? Int
		orderType = (dictionary["order_type"] as? Int) ?? 0
		pickedOrderAt = dictionary["picked_order_at"] as? String
		promoCode = dictionary["promo_code"] as? String
		promoId = dictionary["promo_id"] as? String
		providersDetail = [OrderProviderDetail]()
		if let providerDetailArray = dictionary["provider_detail"] as? [[String:Any]]{
			for dic in providerDetailArray{
				let value = OrderProviderDetail(fromDictionary: dic)
				providersDetail.append(value)
			}
		}
        
		providerId = dictionary["provider_id"] as? String
        providerLocation = (dictionary["provider_location"] as? [Double]) ?? [0.0,0.0];
        if providerLocation.isEmpty {
            providerLocation = [0.0,0.0]
        }
        
		providerPreviousLocation = (dictionary["provider_previous_location"] as? [Double]) ?? [0.0,0.0];
		providerType = dictionary["provider_type"] as? Int
		providerTypeId = dictionary["provider_type_id"] as? String
		providersIdThatRejectedOrder = dictionary["providers_id_that_rejected_order"] as? [String]
		scheduleOrderServerStartAt = dictionary["schedule_order_server_start_at"] as? String
		scheduleOrderStartAt = dictionary["schedule_order_start_at"] as? String
        //Storeapp
        scheduleOrderStartAt2 = dictionary["schedule_order_start_at2"] as? String ?? ""

		serviceId = dictionary["service_id"] as? String
		startForDeliveryAt = dictionary["start_for_delivery_at"] as? String
		startForPickupAt = dictionary["start_for_pickup_at"] as? String
		startPreparingOrderAt = dictionary["start_preparing_order_at"] as? String
		storeAcceptedAt = dictionary["store_accepted_at"] as? String
		storeId = dictionary["store_id"] as? String
		storeNotify = dictionary["store_notify"] as? Int
		storeOrderCreatedAt = dictionary["store_order_created_at"] as? String
		totalOrderPrice1 = (dictionary["total_order_price"] as? Double)?.roundTo() ?? 0.0
        total = (dictionary["total"] as? Double)?.roundTo() ?? 0.0

		uniqueCode = dictionary["unique_code"] as? Int
		uniqueId = dictionary["unique_id"] as? Int ?? 0
        order_unique_id = dictionary["order_unique_id"] as? Int ?? 0

		updatedAt = dictionary["updated_at"] as? String
		if let userDetailData = dictionary["user_detail"] as? [String:Any]{
			userDetail = OrderUserDetail(fromDictionary: userDetailData)
        }else{
            userDetail = OrderUserDetail(fromDictionary: [:])
        }
		userId = dictionary["user_id"] as? String
		userType = dictionary["user_type"] as? Int
		userTypeId = dictionary["user_type_id"] as? String

        isUserPickupOrder = (dictionary["is_user_pick_up_order"] as? Bool) ?? false
        delivery_type = dictionary["delivery_type"] as? Int
    }
}
