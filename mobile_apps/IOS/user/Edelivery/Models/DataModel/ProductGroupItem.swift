//
//	ProductGroup.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class ProductGroupItem : NSObject, NSCoding{

	var v : Int!
	var id : String!
	var createdAt : String!
	var imageUrl : String!
	var name : String!
	var sequenceNumber : Int!
	var storeId : String!
    var image_url : String!

	var uniqueId : Int!
	var updatedAt : String!

    var product_ids = [String]()

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		v = dictionary["__v"] as? Int
		id = dictionary["_id"] as? String
		createdAt = dictionary["created_at"] as? String
		imageUrl = dictionary["image_url"] as? String
		name = dictionary["name"] as? String
		sequenceNumber = dictionary["sequence_number"] as? Int
		storeId = dictionary["store_id"] as? String
        image_url = dictionary["image_url"] as? String

		uniqueId = dictionary["unique_id"] as? Int
		updatedAt = dictionary["updated_at"] as? String
        product_ids = (dictionary["product_ids"] as? [String])!
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if v != nil{
			dictionary["__v"] = v
		}
		if id != nil{
			dictionary["_id"] = id
		}
		if createdAt != nil{
			dictionary["created_at"] = createdAt
		}
		if imageUrl != nil{
			dictionary["image_url"] = imageUrl
		}
		if name != nil{
			dictionary["name"] = name
		}
		if sequenceNumber != nil{
			dictionary["sequence_number"] = sequenceNumber
		}
		if storeId != nil{
			dictionary["store_id"] = storeId
		}
        if image_url != nil{
            dictionary["image_url"] = image_url
        }
		if uniqueId != nil{
			dictionary["unique_id"] = uniqueId
		}
		if updatedAt != nil{
			dictionary["updated_at"] = updatedAt
		}
        if product_ids != nil{
            dictionary["product_ids"] = product_ids
        }
        

		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         v = aDecoder.decodeObject(forKey: "__v") as? Int
         id = aDecoder.decodeObject(forKey: "_id") as? String
         createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
         imageUrl = aDecoder.decodeObject(forKey: "image_url") as? String
         name = aDecoder.decodeObject(forKey: "name") as? String
         sequenceNumber = aDecoder.decodeObject(forKey: "sequence_number") as? Int
         storeId = aDecoder.decodeObject(forKey: "store_id") as? String
        image_url = aDecoder.decodeObject(forKey: "image_url") as? String
         uniqueId = aDecoder.decodeObject(forKey: "unique_id") as? Int
         updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? String
        product_ids = (aDecoder.decodeObject(forKey: "product_ids") as? [String])!

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if v != nil{
			aCoder.encode(v, forKey: "__v")
		}
		if id != nil{
			aCoder.encode(id, forKey: "_id")
		}
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "created_at")
		}
		if imageUrl != nil{
			aCoder.encode(imageUrl, forKey: "image_url")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if sequenceNumber != nil{
			aCoder.encode(sequenceNumber, forKey: "sequence_number")
		}
		if storeId != nil{
			aCoder.encode(storeId, forKey: "store_id")
		}
        if image_url != nil{
            aCoder.encode(image_url, forKey: "image_url")
        }
		if uniqueId != nil{
			aCoder.encode(uniqueId, forKey: "unique_id")
		}
		if updatedAt != nil{
			aCoder.encode(updatedAt, forKey: "updated_at")
		}
        if product_ids != nil{
            aCoder.encode(product_ids, forKey: "product_ids")
        }
	}

}
