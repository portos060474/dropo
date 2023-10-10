//
//	StoreReviewList.swift
//
//	Create by Elluminati iMac on 5/12/2017
//	Copyright © 2017. All rights reserved.

import Foundation

class StoreReviewList{

	var id : String!
	var createdAt : String!
	var idOfUsersDislikeStoreComment : [String]!
	var idOfUsersLikeStoreComment : [String]!
	var orderUniqueId : Int!
	var userDetail : UserDetail!
	var userRatingToStore : Double!
	var userReviewToStore : String!
    var isLike : Bool = false
    var isDisLike : Bool = false


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		id = dictionary["_id"] as? String
		createdAt = dictionary["created_at"] as? String
		idOfUsersDislikeStoreComment = (dictionary["id_of_users_dislike_store_comment"] as? [String]) ?? []
		idOfUsersLikeStoreComment = (dictionary["id_of_users_like_store_comment"] as? [String]) ?? []
		orderUniqueId = dictionary["order_unique_id"] as? Int
		if let userDetailData = dictionary["user_detail"] as? [String:Any]{
			userDetail = UserDetail(fromDictionary: userDetailData)
		}
        userRatingToStore = (dictionary["user_rating_to_store"] as? Double)?.roundTo() ?? 0.0
		userReviewToStore = dictionary["user_review_to_store"] as? String
        
    }

}
