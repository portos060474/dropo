//
//	CategoryGroupModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class CategoryGroupModel : NSObject, NSCoding{

	var message : Int!
	var productGroups : [CategoryProductGroup]!
	var success : Bool!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		message = dictionary["message"] as? Int
		productGroups = [CategoryProductGroup]()
		if let productGroupsArray = dictionary["product_groups"] as? [[String:Any]]{
			for dic in productGroupsArray{
				let value = CategoryProductGroup(fromDictionary: dic)
				productGroups.append(value)
			}
		}
		success = dictionary["success"] as? Bool
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if message != nil{
			dictionary["message"] = message
		}
		if productGroups != nil{
			var dictionaryElements = [[String:Any]]()
			for productGroupsElement in productGroups {
				dictionaryElements.append(productGroupsElement.toDictionary())
			}
			dictionary["product_groups"] = dictionaryElements
		}
		if success != nil{
			dictionary["success"] = success
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         message = aDecoder.decodeObject(forKey: "message") as? Int
         productGroups = aDecoder.decodeObject(forKey :"product_groups") as? [CategoryProductGroup]
         success = aDecoder.decodeObject(forKey: "success") as? Bool

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if message != nil{
			aCoder.encode(message, forKey: "message")
		}
		if productGroups != nil{
			aCoder.encode(productGroups, forKey: "product_groups")
		}
		if success != nil{
			aCoder.encode(success, forKey: "success")
		}

	}

}