//
//	HistoryProviderDetail.swift
//
//	Create by Jaydeep Vyas on 6/8/2017
//	Copyright © 2017 Elluminati. All rights reserved.


import Foundation

class HistoryProviderDetail{

	var firstName : String!
	var imageUrl : String!
	var lastName : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		firstName = (dictionary["first_name"] as? String) ?? ""
		imageUrl = (dictionary["image_url"] as? String) ?? ""
		lastName = (dictionary["last_name"] as? String) ?? ""
	}

}
class HistoryUserDetail{
    
    var firstName : String!
    var imageUrl : String!
    var lastName : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        firstName = (dictionary["first_name"] as? String) ?? ""
        imageUrl = (dictionary["image_url"] as? String) ?? ""
            lastName = (dictionary["last_name"] as? String) ?? ""
    }
    
}
