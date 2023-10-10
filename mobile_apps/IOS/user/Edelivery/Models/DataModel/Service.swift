/*
Copyright (c) 2017 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at  */

public class Service {
	public var _id : String?
	public var unique_id : Int?
	public var updated_at : String?
	public var country_id : String?
	public var city_id : String?
	public var delivery_type : Int?
	public var delivery_service_id : String?
	public var admin_profit_mode_on_delivery : Int?
	public var admin_profit_mode_on_store : Int?
	public var admin_profit_value_on_store : Int?
	public var base_price_distance : Int?
	public var base_price : Int?
	public var price_per_unit_distance : Int?
	public var price_per_unit_time : Int?
	public var service_tax : Int?
	public var min_fare : Int?
	public var surge_price : Int?
	public var cancellation_fee : Int?
	public var admin_profit_value_on_delivery : Int?
	public var __v : Int?
	public var created_at : String?
	public var is_business : String?
	public var is_surge_hours : String?
	public var surge_hours : Array<Surge_hours>?
	public var is_distance_unit_mile : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let service_list = Service.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Service Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Service] {
        var models:[Service] = []
        for item in array {
            models.append(Service(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let service = Service(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Service Instance.
*/
	required public init?(dictionary: NSDictionary) {

		_id = dictionary["_id"] as? String
		unique_id = dictionary["unique_id"] as? Int
		updated_at = dictionary["updated_at"] as? String
		country_id = dictionary["country_id"] as? String
		city_id = dictionary["city_id"] as? String
		delivery_type = dictionary["delivery_type"] as? Int
		delivery_service_id = dictionary["delivery_service_id"] as? String
		admin_profit_mode_on_delivery = dictionary["admin_profit_mode_on_delivery"] as? Int
		admin_profit_mode_on_store = dictionary["admin_profit_mode_on_store"] as? Int
		admin_profit_value_on_store = dictionary["admin_profit_value_on_store"] as? Int
		base_price_distance = dictionary["base_price_distance"] as? Int
		base_price = dictionary["base_price"] as? Int
		price_per_unit_distance = dictionary["price_per_unit_distance"] as? Int
		price_per_unit_time = dictionary["price_per_unit_time"] as? Int
		service_tax = dictionary["service_tax"] as? Int
		min_fare = dictionary["min_fare"] as? Int
		surge_price = dictionary["surge_price"] as? Int
		cancellation_fee = dictionary["cancellation_fee"] as? Int
		admin_profit_value_on_delivery = dictionary["admin_profit_value_on_delivery"] as? Int
		__v = dictionary["__v"] as? Int
		created_at = dictionary["created_at"] as? String
		is_business = dictionary["is_business"] as? String
		is_surge_hours = dictionary["is_surge_hours"] as? String
		if (dictionary["surge_hours"] != nil) { surge_hours = Surge_hours.modelsFromDictionaryArray(array: dictionary["surge_hours"] as! NSArray) }
		is_distance_unit_mile = dictionary["is_distance_unit_mile"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self._id, forKey: "_id")
		dictionary.setValue(self.unique_id, forKey: "unique_id")
		dictionary.setValue(self.updated_at, forKey: "updated_at")
		dictionary.setValue(self.country_id, forKey: "country_id")
		dictionary.setValue(self.city_id, forKey: "city_id")
		dictionary.setValue(self.delivery_type, forKey: "delivery_type")
		dictionary.setValue(self.delivery_service_id, forKey: "delivery_service_id")
		dictionary.setValue(self.admin_profit_mode_on_delivery, forKey: "admin_profit_mode_on_delivery")
		dictionary.setValue(self.admin_profit_mode_on_store, forKey: "admin_profit_mode_on_store")
		dictionary.setValue(self.admin_profit_value_on_store, forKey: "admin_profit_value_on_store")
		dictionary.setValue(self.base_price_distance, forKey: "base_price_distance")
		dictionary.setValue(self.base_price, forKey: "base_price")
		dictionary.setValue(self.price_per_unit_distance, forKey: "price_per_unit_distance")
		dictionary.setValue(self.price_per_unit_time, forKey: "price_per_unit_time")
		dictionary.setValue(self.service_tax, forKey: "service_tax")
		dictionary.setValue(self.min_fare, forKey: "min_fare")
		dictionary.setValue(self.surge_price, forKey: "surge_price")
		dictionary.setValue(self.cancellation_fee, forKey: "cancellation_fee")
		dictionary.setValue(self.admin_profit_value_on_delivery, forKey: "admin_profit_value_on_delivery")
		dictionary.setValue(self.__v, forKey: "__v")
		dictionary.setValue(self.created_at, forKey: "created_at")
		dictionary.setValue(self.is_business, forKey: "is_business")
		dictionary.setValue(self.is_surge_hours, forKey: "is_surge_hours")
		dictionary.setValue(self.is_distance_unit_mile, forKey: "is_distance_unit_mile")

		return dictionary
	}

}
