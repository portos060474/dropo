//
//	OrderDetail.swift
//
//	Create by Jaydeep Vyas on 10/8/2017
//	Copyright © 2017 Elluminati. All rights reserved.


import Foundation

class OrderDetail{

	var items : [OrderItem]!
	var productId : String!
	var productName : String!
	var totalItemPrice : Double!
    var totalItemTax : Double!
	var uniqueId : Int!
    var taxDetails : [TaxesDetail]!

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		items = [OrderItem]()
		if let itemsArray = dictionary["items"] as? [[String:Any]]{
			for dic in itemsArray{
				let value = OrderItem(fromDictionary: dic)
				items.append(value)
			}
		}
		productId = dictionary["product_id"] as? String
		productName = dictionary["product_name"] as? String
		totalItemPrice = (dictionary["total_item_price"] as? Double) ?? 0.0
        totalItemTax = (dictionary["total_item_tax"] as? Double) ?? 0.0
		uniqueId = dictionary["unique_id"] as? Int
        taxDetails = [TaxesDetail]()
        if let taxDetailsArray = dictionary["tax_details"] as? [[String:Any]]{
            for dic in taxDetailsArray{
                let value = TaxesDetail(fromDictionary: dic)
                taxDetails.append(value)
            }
        }
      
	}
    func toDictionary(isPassArray:Bool) -> [String:Any] {
        var dictionary = [String:Any]()
        if items != nil{
            var dictionaryElements = [[String:Any]]()
            for itemsElement in items {
                dictionaryElements.append(itemsElement.toDictionary(isPassArray: isPassArray))
            }
            dictionary["items"] = dictionaryElements
        }
        if productId != nil{
            dictionary["product_id"] = productId
        }
        if totalItemTax != nil{
            dictionary["total_item_tax"] = totalItemTax
        }
        if productName != nil{
            dictionary["product_name"] = productName
        }
        if totalItemPrice != nil{
            dictionary["total_item_price"] = totalItemPrice
        }
        if uniqueId != nil{
            dictionary["unique_id"] = uniqueId
        }
        if taxDetails != nil{
            var dictionaryElements = [[String:Any]]()
            for taxDetailsElement in taxDetails {
                dictionaryElements.append(taxDetailsElement.toDictionary())
            }
            dictionary["tax_details"] = dictionaryElements
        }
        return dictionary
    }
    
    func getProductJson() -> NSDictionary {
        let dictionary = NSMutableDictionary()
        
        if items != nil{
            var itemsDics = [NSDictionary]()
            for itemsElement in items {
                itemsDics.append(itemsElement.getProductJson())
            }
            dictionary.setValue(itemsDics, forKey: "items")
        }
        
        dictionary.setValue(uniqueId, forKey: "unique_id")
        
        return dictionary
    }
}
