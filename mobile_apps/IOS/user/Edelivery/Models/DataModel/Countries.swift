import Foundation
public class Countries {
	public var _id : String?
	public var unique_id : Int?
	public var updated_at : String?
	public var country_phone_code : String?
	public var country_name : String?
	public var country_code : String?
	public var currency_name : String?
	public var currency_code : String?
	public var currency_sign : String?
	public var referral_bonus_to_user : Double?
	public var bonus_to_user_referral : Double?
	public var no_of_user_use_referral : Int?
	public var referral_bonus_to_store : Double?
	public var bonus_to_store_referral : Double?
	public var no_of_store_use_referral : Int?
	public var referral_bonus_to_provider : Double?
	public var bonus_to_provider_referral : Double?
	public var no_of_provider_use_referral : Int?
	public var maximum_phone_number_length : Int?
    public var minimum_phone_number_length : Int?
	public var __v : Int?
	public var created_at : String?
	public var is_distance_unit_mile : Bool?
	public var is_business : Bool?
	public var country_timezone : Array<String>?
	public var country_flag : String?
    public var is_referral_to_user:Bool?
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [Countries] {
        var models:[Countries] = []
        for item in array {
            models.append(Countries(dictionary: item as! NSDictionary)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {

		_id = dictionary["_id"] as? String
		unique_id = dictionary["unique_id"] as? Int
		updated_at = dictionary["updated_at"] as? String
		country_phone_code = dictionary["country_phone_code"] as? String
		country_name = dictionary["country_name"] as? String
		country_code = dictionary["country_code"] as? String
		currency_name = dictionary["currency_name"] as? String
		currency_code = dictionary["currency_code"] as? String
		currency_sign = dictionary["currency_sign"] as? String
		referral_bonus_to_user = dictionary["referral_bonus_to_user"] as? Double
		bonus_to_user_referral = dictionary["bonus_to_user_referral"] as? Double
		no_of_user_use_referral = dictionary["no_of_user_use_referral"] as? Int
		referral_bonus_to_store = dictionary["referral_bonus_to_store"] as? Double
		bonus_to_store_referral = dictionary["bonus_to_store_referral"] as? Double
		no_of_store_use_referral = dictionary["no_of_store_use_referral"] as? Int
		referral_bonus_to_provider = dictionary["referral_bonus_to_provider"] as? Double
		bonus_to_provider_referral = dictionary["bonus_to_provider_referral"] as? Double
		no_of_provider_use_referral = dictionary["no_of_provider_use_referral"] as? Int
		minimum_phone_number_length = dictionary["minimum_phone_number_length"] as? Int
        maximum_phone_number_length = dictionary["maximum_phone_number_length"] as? Int
        
		__v = dictionary["__v"] as? Int
		created_at = dictionary["created_at"] as? String
		is_distance_unit_mile = dictionary["is_distance_unit_mile"] as? Bool
		is_business = dictionary["is_business"] as? Bool
        is_referral_to_user = dictionary["is_referral_user"] as? Bool
		if (dictionary["country_timezone"] != nil) {
            country_timezone = (dictionary["country_timezone"] as! NSArray) as? Array<String>
        }
        
        
        
       
		country_flag = dictionary["country_flag"] as? String
	}
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()
        dictionary.setValue(self._id, forKey: "_id")
		dictionary.setValue(self.unique_id, forKey: "unique_id")
		dictionary.setValue(self.updated_at, forKey: "updated_at")
		dictionary.setValue(self.country_phone_code, forKey: "country_phone_code")
		dictionary.setValue(self.country_name, forKey: "country_name")
		dictionary.setValue(self.country_code, forKey: "country_code")
		dictionary.setValue(self.currency_name, forKey: "currency_name")
		dictionary.setValue(self.currency_code, forKey: "currency_code")
		dictionary.setValue(self.currency_sign, forKey: "currency_sign")
		dictionary.setValue(self.referral_bonus_to_user, forKey: "referral_bonus_to_user")
		dictionary.setValue(self.bonus_to_user_referral, forKey: "bonus_to_user_referral")
		dictionary.setValue(self.no_of_user_use_referral, forKey: "no_of_user_use_referral")
		dictionary.setValue(self.referral_bonus_to_store, forKey: "referral_bonus_to_store")
		dictionary.setValue(self.bonus_to_store_referral, forKey: "bonus_to_store_referral")
		dictionary.setValue(self.no_of_store_use_referral, forKey: "no_of_store_use_referral")
		dictionary.setValue(self.referral_bonus_to_provider, forKey: "referral_bonus_to_provider")
		dictionary.setValue(self.bonus_to_provider_referral, forKey: "bonus_to_provider_referral")
		dictionary.setValue(self.no_of_provider_use_referral, forKey: "no_of_provider_use_referral")
		dictionary.setValue(self.__v, forKey: "__v")
		dictionary.setValue(self.created_at, forKey: "created_at")
		dictionary.setValue(self.is_distance_unit_mile, forKey: "is_distance_unit_mile")
		dictionary.setValue(self.is_business, forKey: "is_business")
		dictionary.setValue(self.country_flag, forKey: "country_flag")
        dictionary.setValue(self.minimum_phone_number_length, forKey: "minimum_phone_number_length")
        dictionary.setValue(self.maximum_phone_number_length, forKey: "maximum_phone_number_length")
		return dictionary
	}

}
