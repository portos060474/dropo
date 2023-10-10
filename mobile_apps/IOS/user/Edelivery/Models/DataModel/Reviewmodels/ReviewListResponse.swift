//
//	ReviewListResponse.swift
//
//	Create by Elluminati iMac on 5/12/2017
//	Copyright © 2017. All rights reserved.

import Foundation

class ReviewListResponse {

	var message : Int!
	var remainingReviewList : [RemainingReviewList]!
	var storeAvgReview : Double!
	var storeReviewList : [StoreReviewList]!
	var success : Bool!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		message = (dictionary["message"] as? Int) ?? 0
		remainingReviewList = [RemainingReviewList]()
		if let remainingReviewListArray = dictionary["remaining_review_list"] as? [[String:Any]]{
			for dic in remainingReviewListArray {
				let value = RemainingReviewList(fromDictionary: dic)
				remainingReviewList.append(value)
			}
		}
        storeAvgReview = (dictionary["store_avg_review"] as? Double) ?? 0.0
		storeReviewList = [StoreReviewList]()
		if let storeReviewListArray = dictionary["store_review_list"] as? [[String:Any]]{
			for dic in storeReviewListArray{
                let value = StoreReviewList(fromDictionary: dic)
				storeReviewList.append(value)
			}
		}
		success = (dictionary["success"] as? Bool) ?? false
	}

}
