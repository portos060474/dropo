//
//	Item.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class ItemNew : NSObject, NSCoding{

	var details : String!
	var imageUrl : [String]!
	var itemId : String!
	var itemName : String!
	var itemPrice : Double!
	var maxItemQuantity : Int!
	var noteForItem : String!
	var quantity : Int!
	var specifications : [SpecificationNew]!
	var tax : Int!
	var totalItemPrice : Int!
	var totalItemTax : Int!
	var totalPrice : Int!
	var totalSpecificationPrice : Double!
	var totalSpecificationTax : Int!
	var totalTax : Int!
	var uniqueId : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		details = dictionary["details"] as? String
		imageUrl = dictionary["image_url"] as? [String]
		itemId = dictionary["item_id"] as? String
		itemName = dictionary["item_name"] as? String
        itemPrice = dictionary["item_price"] as? Double ?? 0.0
		maxItemQuantity = dictionary["max_item_quantity"] as? Int
		noteForItem = dictionary["note_for_item"] as? String
		quantity = dictionary["quantity"] as? Int
		specifications = [SpecificationNew]()
		if let specificationsArray = dictionary["specifications"] as? [[String:Any]]{
			for dic in specificationsArray{
				let value = SpecificationNew(fromDictionary: dic)
				specifications.append(value)
			}
		}
		tax = dictionary["tax"] as? Int
		totalItemPrice = dictionary["total_item_price"] as? Int
		totalItemTax = dictionary["total_item_tax"] as? Int
		totalPrice = dictionary["total_price"] as? Int
        totalSpecificationPrice = dictionary["total_specification_price"] as? Double ?? 0.0
		totalSpecificationTax = dictionary["total_specification_tax"] as? Int
		totalTax = dictionary["total_tax"] as? Int
		uniqueId = dictionary["unique_id"] as? Int
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if details != nil{
			dictionary["details"] = details
		}
		if imageUrl != nil{
			dictionary["image_url"] = imageUrl
		}
		if itemId != nil{
			dictionary["item_id"] = itemId
		}
		if itemName != nil{
			dictionary["item_name"] = itemName
		}
		if itemPrice != nil{
			dictionary["item_price"] = itemPrice
		}
		if maxItemQuantity != nil{
			dictionary["max_item_quantity"] = maxItemQuantity
		}
		if noteForItem != nil{
			dictionary["note_for_item"] = noteForItem
		}
		if quantity != nil{
			dictionary["quantity"] = quantity
		}
		if specifications != nil{
			var dictionaryElements = [[String:Any]]()
			for specificationsElement in specifications {
				dictionaryElements.append(specificationsElement.toDictionary())
			}
			dictionary["specifications"] = dictionaryElements
		}
		if tax != nil{
			dictionary["tax"] = tax
		}
		if totalItemPrice != nil{
			dictionary["total_item_price"] = totalItemPrice
		}
		if totalItemTax != nil{
			dictionary["total_item_tax"] = totalItemTax
		}
		if totalPrice != nil{
			dictionary["total_price"] = totalPrice
		}
		if totalSpecificationPrice != nil{
			dictionary["total_specification_price"] = totalSpecificationPrice
		}
		if totalSpecificationTax != nil{
			dictionary["total_specification_tax"] = totalSpecificationTax
		}
		if totalTax != nil{
			dictionary["total_tax"] = totalTax
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
         details = aDecoder.decodeObject(forKey: "details") as? String
         imageUrl = aDecoder.decodeObject(forKey: "image_url") as? [String]
         itemId = aDecoder.decodeObject(forKey: "item_id") as? String
         itemName = aDecoder.decodeObject(forKey: "item_name") as? String
        itemPrice = aDecoder.decodeObject(forKey: "item_price") as? Double ?? 0.0
         maxItemQuantity = aDecoder.decodeObject(forKey: "max_item_quantity") as? Int
         noteForItem = aDecoder.decodeObject(forKey: "note_for_item") as? String
         quantity = aDecoder.decodeObject(forKey: "quantity") as? Int
         specifications = aDecoder.decodeObject(forKey :"specifications") as? [SpecificationNew]
         tax = aDecoder.decodeObject(forKey: "tax") as? Int
         totalItemPrice = aDecoder.decodeObject(forKey: "total_item_price") as? Int
         totalItemTax = aDecoder.decodeObject(forKey: "total_item_tax") as? Int
         totalPrice = aDecoder.decodeObject(forKey: "total_price") as? Int
         totalSpecificationPrice = aDecoder.decodeObject(forKey: "total_specification_price") as? Double ?? 0.0
         totalSpecificationTax = aDecoder.decodeObject(forKey: "total_specification_tax") as? Int
         totalTax = aDecoder.decodeObject(forKey: "total_tax") as? Int
         uniqueId = aDecoder.decodeObject(forKey: "unique_id") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if details != nil{
			aCoder.encode(details, forKey: "details")
		}
		if imageUrl != nil{
			aCoder.encode(imageUrl, forKey: "image_url")
		}
		if itemId != nil{
			aCoder.encode(itemId, forKey: "item_id")
		}
		if itemName != nil{
			aCoder.encode(itemName, forKey: "item_name")
		}
		if itemPrice != nil{
			aCoder.encode(itemPrice, forKey: "item_price")
		}
		if maxItemQuantity != nil{
			aCoder.encode(maxItemQuantity, forKey: "max_item_quantity")
		}
		if noteForItem != nil{
			aCoder.encode(noteForItem, forKey: "note_for_item")
		}
		if quantity != nil{
			aCoder.encode(quantity, forKey: "quantity")
		}
		if specifications != nil{
			aCoder.encode(specifications, forKey: "specifications")
		}
		if tax != nil{
			aCoder.encode(tax, forKey: "tax")
		}
		if totalItemPrice != nil{
			aCoder.encode(totalItemPrice, forKey: "total_item_price")
		}
		if totalItemTax != nil{
			aCoder.encode(totalItemTax, forKey: "total_item_tax")
		}
		if totalPrice != nil{
			aCoder.encode(totalPrice, forKey: "total_price")
		}
		if totalSpecificationPrice != nil{
			aCoder.encode(totalSpecificationPrice, forKey: "total_specification_price")
		}
		if totalSpecificationTax != nil{
			aCoder.encode(totalSpecificationTax, forKey: "total_specification_tax")
		}
		if totalTax != nil{
			aCoder.encode(totalTax, forKey: "total_tax")
		}
		if uniqueId != nil{
			aCoder.encode(uniqueId, forKey: "unique_id")
		}

	}

}
