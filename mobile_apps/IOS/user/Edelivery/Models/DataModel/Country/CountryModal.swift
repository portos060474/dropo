//
//	CountryModal.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class CountryModal{

    var name : String!
    var code : String!
    var currency_code : String!
    var sign : String!
    var alpha2 : String!
    var alpha3 : String!
    var decimals : Int!
    var timezones : [String]!

	init(fromDictionary dictionary: [String:Any]){
	
		name = dictionary["name"] as? String
        code = dictionary["code"] as? String
        currency_code = dictionary["currency_code"] as? String
        sign = dictionary["sign"] as? String
        alpha2 = dictionary["alpha2"] as? String
        alpha3 = dictionary["alpha3"] as? String
        decimals = dictionary["decimals"] as? Int
        timezones = dictionary["timezones"] as? [String]
 
	}

	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
 
        if name != nil{
            dictionary["name"] = name
        }
        if code != nil{
            dictionary["code"] = code
        }
        if currency_code != nil{
            dictionary["currency_code"] = currency_code
        }
        if sign != nil{
            dictionary["sign"] = sign
        }
        if alpha2 != nil{
            dictionary["alpha2"] = alpha2
        }
        if alpha3 != nil{
            dictionary["alpha3"] = alpha3
        }
        if decimals != nil{
            dictionary["decimals"] = decimals
        }
        if timezones != nil{
            dictionary["timezones"] = timezones
        }
        
		return dictionary
	}
}
