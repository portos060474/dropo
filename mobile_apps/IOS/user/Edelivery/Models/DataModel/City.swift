

import Foundation

public class City {
	public var _id : String?
	public var unique_id : Int?
	public var updated_at : String?
	public var country_id : String?
	public var city_name : String?
	public var city_code : String?
	public var city_radius : Int?
	public var timezone : String?
	public var created_at : String?
	public var deliveries_in_city : Array<String>?
	public var city_lat_long : Array<Double>?
	public var payment_gateway : Array<String>?
	public var is_business : Bool? = false
	public var is_promo_apply_for_other : Bool? = false
	public var is_promo_apply_for_cash : Bool? = false
	public var is_other_payment_mode : Bool? = false
	public var is_cash_payment_mode : Bool? = false
	public var __v : Int?
	


    public class func modelsFromDictionaryArray(array:NSArray) -> [City] {
        var models:[City] = []
        for item in array {
            models.append(City(dictionary: item as! NSDictionary)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {

		_id = dictionary["_id"] as? String
		unique_id = dictionary["unique_id"] as? Int
		updated_at = dictionary["updated_at"] as? String
		country_id = dictionary["country_id"] as? String
		city_name = dictionary["city_nick_name"] as? String
		city_code = dictionary["city_code"] as? String
		city_radius = dictionary["city_radius"] as? Int
		timezone = dictionary["timezone"] as? String
		created_at = dictionary["created_at"] as? String
		if (dictionary["deliveries_in_city"] != nil) {
        deliveries_in_city = (dictionary["deliveries_in_city"] as! NSArray) as? Array<String>
        }
		if (dictionary["city_lat_long"] != nil) {
            city_lat_long = (dictionary["city_lat_long"] as! NSArray) as? Array<Double>
        }
        if (dictionary["payment_gateway"] != nil) { payment_gateway = (dictionary["payment_gateway"] as! NSArray) as? Array<String>
 }
		is_business = dictionary["is_business"] as? Bool
		is_promo_apply_for_other = dictionary["is_promo_apply_for_other"] as? Bool
		is_promo_apply_for_cash = dictionary["is_promo_apply_for_cash"] as? Bool
		is_other_payment_mode = dictionary["is_other_payment_mode"] as? Bool
		is_cash_payment_mode = dictionary["is_cash_payment_mode"] as? Bool
		__v = dictionary["__v"] as? Int
		
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
		dictionary.setValue(self.city_name, forKey: "city_name")
		dictionary.setValue(self.city_code, forKey: "city_code")
		dictionary.setValue(self.city_radius, forKey: "city_radius")
		dictionary.setValue(self.timezone, forKey: "timezone")
		dictionary.setValue(self.created_at, forKey: "created_at")
		dictionary.setValue(self.is_business, forKey: "is_business")
		dictionary.setValue(self.is_promo_apply_for_other, forKey: "is_promo_apply_for_other")
		dictionary.setValue(self.is_promo_apply_for_cash, forKey: "is_promo_apply_for_cash")
		dictionary.setValue(self.is_other_payment_mode, forKey: "is_other_payment_mode")
		dictionary.setValue(self.is_cash_payment_mode, forKey: "is_cash_payment_mode")
		dictionary.setValue(self.__v, forKey: "__v")

		return dictionary
	}

}
public class CityData {
    
    var city1 : String!
    var city2 : String!
    var city3 : String!
    var country : String!
    var countryCode : String!
    var latitude : Double = 0.0
    var longitude : Double = 0.0
    var serverToken : String!
    var userId : String!
    var country_code_2:String = ""
    var cityCode:String = ""
    var address:String = ""
    

    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]) {
        city1 = dictionary["city1"] as? String
        city2 = dictionary["city2"] as? String
        city3 = dictionary["city3"] as? String
        country = dictionary["country"] as? String
        countryCode = dictionary["country_code"] as? String
        latitude = (dictionary["latitude"] as? Double) ?? 0.0
        longitude = (dictionary["longitude"] as? Double) ?? 0.0
        address = ((dictionary["address"]) as? String) ?? ""
        country_code_2 = ((dictionary["country_code_2"]) as? String) ?? ""
        cityCode = ((dictionary["city_code"]) as? String) ?? ""
        serverToken = dictionary["server_token"] as? String
        userId = dictionary["user_id"] as? String
    }
    
}
