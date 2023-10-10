//
//	RootClass.swift
//
//	Create by Jaydeep Vyas on 29/7/2017
//	Copyright © 2017 Elluminati. All rights reserved.


import Foundation

class ItemListResponse{

	var currency : String!
	var message : Int!
	var products : [ProductItem]!
	var success : Bool!
    var taxesDetails : [TaxesDetail]!



	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]) {
		currency = dictionary["currency"] as? String
		message = dictionary["message"] as? Int
		products = [ProductItem]()
		if let productsArray = dictionary["products"] as? [[String:Any]]{
			for dic in productsArray{
				let value = ProductItem(fromDictionary: dic)
				products.append(value)
			}
		}
        taxesDetails = [TaxesDetail]()
        if let taxesDetailsArray = dictionary["tax_details"] as? [[String:Any]]{
            for dic in taxesDetailsArray{
                let value = TaxesDetail(fromDictionary: dic)
                taxesDetails.append(value)
            }
        }
		success = dictionary["success"] as? Bool
	}

}
class ItemListDetailResponse{
    
    var message : Int!
    var items : [OrderItem]!
    var success : Bool!
    
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]) {
        message = dictionary["message"] as? Int
        items = [OrderItem]()
        if let productsArray = dictionary["items"] as? [[String:Any]]{
            for dic in productsArray{
                let value = OrderItem.init(fromDictionary: dic)
                items.append(value)
            }
        }
        success = dictionary["success"] as? Bool
    }
    
}
