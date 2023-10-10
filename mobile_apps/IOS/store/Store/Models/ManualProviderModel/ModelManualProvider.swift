//
//	ModelManualProvider.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class ModelManualProvider : NSObject, NSCoding{

	var providers : [ModelProvider]!
	var success : Bool!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		providers = [ModelProvider]()
		if let providersArray = dictionary["providers"] as? [[String:Any]]{
			for dic in providersArray{
				let value = ModelProvider(fromDictionary: dic)
				providers.append(value)
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
		if providers != nil{
			var dictionaryElements = [[String:Any]]()
			for providersElement in providers {
				dictionaryElements.append(providersElement.toDictionary())
			}
			dictionary["providers"] = dictionaryElements
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
         providers = aDecoder.decodeObject(forKey :"providers") as? [ModelProvider]
         success = aDecoder.decodeObject(forKey: "success") as? Bool

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if providers != nil{
			aCoder.encode(providers, forKey: "providers")
		}
		if success != nil{
			aCoder.encode(success, forKey: "success")
		}

	}

}