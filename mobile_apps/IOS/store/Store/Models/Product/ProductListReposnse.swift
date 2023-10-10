//
//	ProductListReposnse.swift
//
//	Create by Jaydeep Vyas on 26/7/2017
//	Copyright © 2017 Elluminati. All rights reserved.

import Foundation

class ProductListReposnse{

	var message : Int!
	var products : [Product]!
	var success : Bool!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		message = dictionary["message"] as? Int
		products = [Product]()
		if let productsArray = dictionary["products"] as? [[String:Any]]{
			for dic in productsArray{
				let value = Product(fromDictionary: dic)
				products.append(value)
			}
		}
		success = dictionary["success"] as? Bool
	}

}