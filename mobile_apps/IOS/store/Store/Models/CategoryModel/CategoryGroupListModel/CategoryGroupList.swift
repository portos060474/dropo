//
//	CategoryGroupList.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class CategoryGroupList : NSObject, NSCoding{

	var productArray : [CategoryProductArray]!
	var success : Bool!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		productArray = [CategoryProductArray]()
		if let productArrayArray = dictionary["product_array"] as? [[String:Any]]{
			for dic in productArrayArray{
				let value = CategoryProductArray(fromDictionary: dic)
				productArray.append(value)
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
		if productArray != nil{
			var dictionaryElements = [[String:Any]]()
			for productArrayElement in productArray {
				dictionaryElements.append(productArrayElement.toDictionary())
			}
			dictionary["product_array"] = dictionaryElements
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
         productArray = aDecoder.decodeObject(forKey :"product_array") as? [CategoryProductArray]
         success = aDecoder.decodeObject(forKey: "success") as? Bool

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if productArray != nil{
			aCoder.encode(productArray, forKey: "product_array")
		}
		if success != nil{
			aCoder.encode(success, forKey: "success")
		}

	}

}