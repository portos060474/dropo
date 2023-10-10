//
//	OrderDetail.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class OrderDetailNew : NSObject, NSCoding{

	var items : [ItemNew]!
	var productId : String!
	var productName : String!
	var totalItemPrice : Int!
	var totalItemTax : Int!
	var uniqueId : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		items = [ItemNew]()
		if let itemsArray = dictionary["items"] as? [[String:Any]]{
			for dic in itemsArray{
				let value = ItemNew(fromDictionary: dic)
				items.append(value)
			}
		}
		productId = dictionary["product_id"] as? String
		productName = dictionary["product_name"] as? String
		totalItemPrice = dictionary["total_item_price"] as? Int
		totalItemTax = dictionary["total_item_tax"] as? Int
		uniqueId = dictionary["unique_id"] as? Int
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if items != nil{
			var dictionaryElements = [[String:Any]]()
			for itemsElement in items {
				dictionaryElements.append(itemsElement.toDictionary())
			}
			dictionary["items"] = dictionaryElements
		}
		if productId != nil{
			dictionary["product_id"] = productId
		}
		if productName != nil{
			dictionary["product_name"] = productName
		}
		if totalItemPrice != nil{
			dictionary["total_item_price"] = totalItemPrice
		}
		if totalItemTax != nil{
			dictionary["total_item_tax"] = totalItemTax
		}
		if uniqueId != nil{
			dictionary["unique_id"] = uniqueId
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         items = aDecoder.decodeObject(forKey :"items") as? [ItemNew]
         productId = aDecoder.decodeObject(forKey: "product_id") as? String
         productName = aDecoder.decodeObject(forKey: "product_name") as? String
         totalItemPrice = aDecoder.decodeObject(forKey: "total_item_price") as? Int
         totalItemTax = aDecoder.decodeObject(forKey: "total_item_tax") as? Int
         uniqueId = aDecoder.decodeObject(forKey: "unique_id") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if items != nil{
			aCoder.encode(items, forKey: "items")
		}
		if productId != nil{
			aCoder.encode(productId, forKey: "product_id")
		}
		if productName != nil{
			aCoder.encode(productName, forKey: "product_name")
		}
		if totalItemPrice != nil{
			aCoder.encode(totalItemPrice, forKey: "total_item_price")
		}
		if totalItemTax != nil{
			aCoder.encode(totalItemTax, forKey: "total_item_tax")
		}
		if uniqueId != nil{
			aCoder.encode(uniqueId, forKey: "unique_id")
		}

	}

}
