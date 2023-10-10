//
//	HistoryOrderList.swift
//
//	Create by Jaydeep Vyas on 6/8/2017
//	Copyright © 2017 Elluminati. All rights reserved.


import Foundation

class HistoryOrderList {

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
	var isScheduleOrder : Bool!
    var cartDetail:CartDetail!
	var orderPaymentDetail : OrderPayment!
	var orderPaymentId : String!
	var orderReadyAt : String!
	var orderStatus : Int!
	var orderStatusBy : String!
	var orderStatusId : Int!
	var orderType : Int!
	var pickedOrderAt : String!
	var promoCode : String!
	var promoId : String!
	var providerId : String!
	var providerLocation : [Double]!
	var providerPreviousLocation : [Double]!
	var providerType : Int!
	var providerTypeId : String!
	var providersIdThatRejectedOrder : [String]!
	var scheduleOrderServerStartAt : String!
	var scheduleOrderStartAt : String!
	var serviceId : String!
	var startForDeliveryAt : String!
	var startForPickupAt : String!
	var startPreparingOrderAt : String!
	var storeAcceptedAt : String!
	var storeId : String!
	var storeNotify : Int!
	var storeOrderCreatedAt : String!
	var totalOrderPrice : Double!
	var uniqueCode : Int!
	var uniqueId : Int!
	var updatedAt : String!
	var userId : String!
	var userType : Int!
	var userTypeId : String!
    var isStoreRatedToProvider:Bool = false
    var isStoreRatedToUser:Bool = false
    var timeZone:String!
    var reviewDetail : ReviewDetail!

   // var scheduleOrderStartAt2 : String!


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
		currentProvider = dictionary["current_provider"] as? String
		deliveredAt = dictionary["delivered_at"] as? String
		timeZone = (dictionary["timezone"] as? String) ?? TimeZone.ReferenceType.local.description
        
		invoiceNumber = dictionary["invoice_number"] as? Int
		isScheduleOrder = dictionary["is_schedule_order"] as? Bool
		
        if let cartDetailData = dictionary["cart_detail"] as? [String:Any]{
            cartDetail = CartDetail(fromDictionary: cartDetailData)
        }

        
		if let orderPaymentDetailData = dictionary["order_payment_detail"] as? [String:Any]{
			orderPaymentDetail = OrderPayment(fromDictionary: orderPaymentDetailData)
		}
		orderPaymentId = dictionary["order_payment_id"] as? String
		orderReadyAt = dictionary["order_ready_at"] as? String
		orderStatus = dictionary["order_status"] as? Int
		orderStatusBy = dictionary["order_status_by"] as? String
		orderStatusId = dictionary["order_status_id"] as? Int
		orderType = dictionary["order_type"] as? Int
		pickedOrderAt = dictionary["picked_order_at"] as? String
		promoCode = dictionary["promo_code"] as? String
		promoId = dictionary["promo_id"] as? String
		providerId = dictionary["provider_id"] as? String
		providerLocation = dictionary["provider_location"] as? [Double]
		providerPreviousLocation = dictionary["provider_previous_location"] as? [Double]
		providerType = dictionary["provider_type"] as? Int
		providerTypeId = dictionary["provider_type_id"] as? String
		providersIdThatRejectedOrder = dictionary["providers_id_that_rejected_order"] as? [String]
		scheduleOrderServerStartAt = dictionary["schedule_order_server_start_at"] as? String
		scheduleOrderStartAt = dictionary["schedule_order_start_at"] as? String
        //scheduleOrderStartAt2 = dictionary["schedule_order_start_at2"] as? String ?? ""

		serviceId = dictionary["service_id"] as? String
		startForDeliveryAt = dictionary["start_for_delivery_at"] as? String
		startForPickupAt = dictionary["start_for_pickup_at"] as? String
		startPreparingOrderAt = dictionary["start_preparing_order_at"] as? String
		storeAcceptedAt = dictionary["store_accepted_at"] as? String
		storeId = dictionary["store_id"] as? String
		storeNotify = dictionary["store_notify"] as? Int
		storeOrderCreatedAt = dictionary["store_order_created_at"] as? String
		totalOrderPrice = (dictionary["total_order_price"] as? Double)?.roundTo() ?? 0.00
		uniqueCode = dictionary["unique_code"] as? Int
		uniqueId = dictionary["unique_id"] as? Int
		updatedAt = dictionary["updated_at"] as? String
		userId = dictionary["user_id"] as? String
		userType = dictionary["user_type"] as? Int
		userTypeId = dictionary["user_type_id"] as? String
        isStoreRatedToUser = (dictionary["is_store_rated_to_user"] as? Bool) ?? false
        isStoreRatedToProvider = (dictionary["is_store_rated_to_provider"] as? Bool) ?? false
        if let reviewDetailData = dictionary["review_detail"] as? [String:Any]{
            reviewDetail = ReviewDetail(fromDictionary: reviewDetailData)
        }
	}

}




class ReviewDetail {

    var v : Int!
    var id : String!
    var createdAt : String!
    var idOfUsersDislikeStoreComment : [AnyObject]!
    var idOfUsersLikeStoreComment : [AnyObject]!
    var numberOfUsersDislikeStoreComment : Int!
    var numberOfUsersLikeStoreComment : Int!
    var orderId : String!
    var orderUniqueId : Int!
    var providerId : String!
    var providerRatingToStore : Int!
    var providerRatingToUser : Int!
    var providerReviewToStore : String!
    var providerReviewToUser : String!
    var storeId : String!
    var storeRatingToProvider : Float!
    var storeRatingToUser : Float!
    var storeReviewToProvider : String!
    var storeReviewToUser : String!
    var uniqueId : Int!
    var updatedAt : String!
    var userId : String!
    var userRatingToProvider : Int!
    var userRatingToStore : Int!
    var userReviewToProvider : String!
    var userReviewToStore : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        v = dictionary["__v"] as? Int
        id = dictionary["_id"] as? String
        createdAt = dictionary["created_at"] as? String
        idOfUsersDislikeStoreComment = dictionary["id_of_users_dislike_store_comment"] as? [AnyObject]
        idOfUsersLikeStoreComment = dictionary["id_of_users_like_store_comment"] as? [AnyObject]
        numberOfUsersDislikeStoreComment = dictionary["number_of_users_dislike_store_comment"] as? Int
        numberOfUsersLikeStoreComment = dictionary["number_of_users_like_store_comment"] as? Int
        orderId = dictionary["order_id"] as? String
        orderUniqueId = dictionary["order_unique_id"] as? Int
        providerId = dictionary["provider_id"] as? String
        providerRatingToStore = dictionary["provider_rating_to_store"] as? Int
        providerRatingToUser = dictionary["provider_rating_to_user"] as? Int
        providerReviewToStore = dictionary["provider_review_to_store"] as? String
        providerReviewToUser = dictionary["provider_review_to_user"] as? String
        storeId = dictionary["store_id"] as? String
        storeRatingToProvider = dictionary["store_rating_to_provider"] as? Float ?? 0.0
        storeRatingToUser = dictionary["store_rating_to_user"] as? Float ?? 0.0
        storeReviewToProvider = dictionary["store_review_to_provider"] as? String
        storeReviewToUser = dictionary["store_review_to_user"] as? String
        uniqueId = dictionary["unique_id"] as? Int
        updatedAt = dictionary["updated_at"] as? String
        userId = dictionary["user_id"] as? String
        userRatingToProvider = dictionary["user_rating_to_provider"] as? Int
        userRatingToStore = dictionary["user_rating_to_store"] as? Int
        userReviewToProvider = dictionary["user_review_to_provider"] as? String
        userReviewToStore = dictionary["user_review_to_store"] as? String
    }

}
