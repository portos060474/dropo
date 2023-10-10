//
//	OffersModal.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class OffersModal : NSObject, NSCoding{

	var message : Int!
	var promoCodes : [PromoCodeModal]!
	var success : Bool!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		message = dictionary["message"] as? Int
		promoCodes = [PromoCodeModal]()
		if let promoCodesArray = dictionary["promo_codes"] as? [[String:Any]]{
			for dic in promoCodesArray{
				let value = PromoCodeModal(fromDictionary: dic)
				promoCodes.append(value)
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
		if promoCodes != nil{
			var dictionaryElements = [[String:Any]]()
			for promoCodesElement in promoCodes {
				dictionaryElements.append(promoCodesElement.toDictionary())
			}
			dictionary["promo_codes"] = dictionaryElements
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
         promoCodes = aDecoder.decodeObject(forKey :"promo_codes") as? [PromoCodeModal]
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
		if promoCodes != nil{
			aCoder.encode(promoCodes, forKey: "promo_codes")
		}
		if success != nil{
			aCoder.encode(success, forKey: "success")
		}

	}

}
