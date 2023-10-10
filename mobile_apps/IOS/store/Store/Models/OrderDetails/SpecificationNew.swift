//
//	Specification.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class SpecificationNew : NSObject, NSCoding{

	var list : [List]!
	var name : String!
	var price : Double!
	var type : Int!
	var uniqueId : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		list = [List]()
		if let listArray = dictionary["list"] as? [[String:Any]]{
			for dic in listArray{
				let value = List(fromDictionary: dic)
				list.append(value)
			}
		}
		name = dictionary["name"] as? String
        price = dictionary["price"] as? Double ?? 0.0
		type = dictionary["type"] as? Int
		uniqueId = dictionary["unique_id"] as? Int
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if list != nil{
			var dictionaryElements = [[String:Any]]()
			for listElement in list {
				dictionaryElements.append(listElement.toDictionary())
			}
			dictionary["list"] = dictionaryElements
		}
		if name != nil{
			dictionary["name"] = name
		}
		if price != nil{
			dictionary["price"] = price
		}
		if type != nil{
			dictionary["type"] = type
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
         list = aDecoder.decodeObject(forKey :"list") as? [List]
         name = aDecoder.decodeObject(forKey: "name") as? String
         price = aDecoder.decodeObject(forKey: "price") as? Double ?? 0.0
         type = aDecoder.decodeObject(forKey: "type") as? Int
         uniqueId = aDecoder.decodeObject(forKey: "unique_id") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if list != nil{
			aCoder.encode(list, forKey: "list")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if price != nil{
			aCoder.encode(price, forKey: "price")
		}
		if type != nil{
			aCoder.encode(type, forKey: "type")
		}
		if uniqueId != nil{
			aCoder.encode(uniqueId, forKey: "unique_id")
		}

	}

}
