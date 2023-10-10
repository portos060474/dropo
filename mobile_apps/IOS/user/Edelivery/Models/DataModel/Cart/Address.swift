//
//	Address.swift
//
//	Create by Elluminati iMac on 12/1/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class Address : NSObject{

	var address : String!
	var addressType : String!
	var city : String!
	var deliveryStatus : Int!
	var location : [Double]!
	var note : String!
	var userDetails : CartUserDetail?
	var userType : Int!
    var flat_no : String!
    var landmark : String!
    var street : String!
    var id = 0

    public required override init() {
    }
    
	init(fromDictionary dictionary: [String:Any]){
		address = dictionary["address"] as? String ?? ""
		addressType = dictionary["address_type"] as? String ?? ""
		city = dictionary["city"] as? String ?? ""
		deliveryStatus = (dictionary["delivery_status"] as? Int) ?? 0
		location = (dictionary["location"] as? [Double]) ?? [0.0,0.0]
		note = dictionary["note"] as? String ?? ""
        flat_no = dictionary["flat_no"] as? String ?? ""
        landmark = dictionary["landmark"] as? String ?? ""
        street = dictionary["street"] as? String ?? ""
		if let userDetailsData = dictionary["user_details"] as? [String:Any]{
			userDetails = CartUserDetail(fromDictionary: userDetailsData)
		}
		userType = dictionary["user_type"] as? Int ?? 0
	}
    
    init(address: String, location: [Double]!, user: CartUserDetail) {
        self.address = address
        self.location = location
        self.userDetails = user
    }

	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if address != nil{
			dictionary["address"] = address
		}
		if addressType != nil{
			dictionary["address_type"] = addressType
		}
		if city != nil{
			dictionary["city"] = city
		}
        if landmark != nil{
            dictionary["landmark"] = landmark
        }
        if flat_no != nil {
            dictionary["flat_no"] = flat_no
        }
        if street != nil {
            dictionary["street"] = street
        }
		if deliveryStatus != nil{
			dictionary["delivery_status"] = deliveryStatus
		}
		if location != nil{
			dictionary["location"] = location
		}
		if note != nil{
			dictionary["note"] = note
		}
		if userDetails != nil{
            dictionary["user_details"] = userDetails?.toDictionary()
		}
		if userType != nil{
			dictionary["user_type"] = userType
		}
		return dictionary
	}
}
