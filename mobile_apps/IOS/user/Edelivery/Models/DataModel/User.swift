

import Foundation
public class User {
	public var __v : Int?
	public var unique_id : Int?
	public var updated_at : String?
	public var user_type : Int?
	public var user_type_id : String?
	public var first_name : String?
	public var last_name : String?
	public var email : String?
	public var password : String?
	public var login_by : String?
	public var country_phone_code : String?
	public var phone : String?
	public var address : String?
	public var country_id : String?
	public var city_id : String?
	public var device_token : String?
	public var device_type : String?
	public var server_token : String?
	public var current_request : String?
	public var promo_count : Int?
	public var referral_code : String?
	public var referred_by : String?
	public var total_referrals : Int?
	public var rate : Int?
	public var rate_count : Int?
	public var wallet : Double?
	public var wallet_currency_code : String?
	public var _id : String?
	public var created_at : String?
	public var is_user_type_approved : Bool?
	public var is_document_uploaded : Bool?
	public var is_phone_number_verified : Bool?
 
	public var is_email_verified :Bool?
	public var is_approved : Bool?
	public var is_use_wallet : Bool?
	public var is_referral : Bool?
	public var requests : Array<String>?
	public var image_url : String?
    public var orders : Array<String>?
    var socialIds : [String] = []
    var favourite_store:[String] = []
    public var country_code : String?

   /**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let user_list = User.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of User Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [User] {
        var models:[User] = []
        for item in array {
            models.append(User(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let user = User(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: User Instance.
*/
	required public init?(dictionary: NSDictionary) {

		__v = dictionary["__v"] as? Int
		unique_id = dictionary["unique_id"] as? Int
		updated_at = dictionary["updated_at"] as? String
		user_type = dictionary["user_type"] as? Int
		user_type_id = dictionary["user_type_id"] as? String
		first_name = dictionary["first_name"] as? String
		last_name = dictionary["last_name"] as? String
		email = dictionary["email"] as? String
		password = dictionary["password"] as? String
		login_by = dictionary["login_by"] as? String
		country_phone_code = dictionary["country_phone_code"] as? String
		phone = dictionary["phone"] as? String ?? ""
		address = dictionary["address"] as? String
		if isNotNSNull(object: dictionary["country_id"] as AnyObject){
            country_id = dictionary["country_id"] as? String
        }else{
            country_id = ""
        }
		city_id = dictionary["city_id"] as? String
		device_token = dictionary["device_token"] as? String
		device_type = dictionary["device_type"] as? String
		server_token = dictionary["server_token"] as? String
		current_request = dictionary["current_request"] as? String
		promo_count = dictionary["promo_count"] as? Int
		referral_code = dictionary["referral_code"] as? String
		referred_by = dictionary["referred_by"] as? String
		total_referrals = dictionary["total_referrals"] as? Int
		rate = dictionary["rate"] as? Int
		rate_count = dictionary["user_rate_count"] as? Int
		wallet = (dictionary["wallet"] as? Double)?.roundTo() ?? 0.00
		wallet_currency_code = dictionary["wallet_currency_code"] as? String
		_id = dictionary["_id"] as? String
		created_at = dictionary["created_at"] as? String
		is_user_type_approved = dictionary["is_user_type_approved"] as? Bool
		is_document_uploaded = dictionary["is_document_uploaded"] as? Bool
		is_phone_number_verified = dictionary["is_phone_number_verified"] as? Bool
		is_email_verified = dictionary["is_email_verified"] as? Bool
		is_approved = dictionary["is_approved"] as? Bool
		is_use_wallet = dictionary["is_use_wallet"] as? Bool
		is_referral = dictionary["is_referral"] as? Bool
        country_code = dictionary["country_code"] as? String
        
		if (dictionary["requests"] != nil) {
            requests = (dictionary["requests"] as! NSArray) as? Array<String>
        }
        socialIds = []
        
        if (dictionary["social_ids"] != nil) {
            
            socialIds = ((dictionary["social_ids"] as! NSArray) as? Array<String>) ?? []
        }
        if (dictionary["orders"] != nil) {
            orders = (dictionary["orders"] as! NSArray) as? Array<
            String>
        }
        if (dictionary["favourite_stores"] != nil) {
            favourite_store = ((dictionary["favourite_stores"] as! NSArray) as? [String]) ?? []
        }
		image_url = dictionary["image_url"] as? String
        

	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.__v, forKey: "__v")
		dictionary.setValue(self.unique_id, forKey: "unique_id")
		dictionary.setValue(self.updated_at, forKey: "updated_at")
		dictionary.setValue(self.user_type, forKey: "user_type")
		dictionary.setValue(self.user_type_id, forKey: "user_type_id")
		dictionary.setValue(self.first_name, forKey: "first_name")
		dictionary.setValue(self.last_name, forKey: "last_name")
		dictionary.setValue(self.email, forKey: "email")
		dictionary.setValue(self.password, forKey: "password")
		dictionary.setValue(self.socialIds, forKey: "social_ids")
		dictionary.setValue(self.login_by, forKey: "login_by")
		dictionary.setValue(self.country_phone_code, forKey: "country_phone_code")
		dictionary.setValue(self.phone, forKey: "phone")
		dictionary.setValue(self.address, forKey: "address")
		dictionary.setValue(self.country_id, forKey: "country_id")
		dictionary.setValue(self.city_id, forKey: "city_id")
		dictionary.setValue(self.device_token, forKey: "device_token")
		dictionary.setValue(self.device_type, forKey: "device_type")
		dictionary.setValue(self.server_token, forKey: "server_token")
		dictionary.setValue(self.current_request, forKey: "current_request")
		dictionary.setValue(self.promo_count, forKey: "promo_count")
		dictionary.setValue(self.referral_code, forKey: "referral_code")
		dictionary.setValue(self.referred_by, forKey: "referred_by")
		dictionary.setValue(self.total_referrals, forKey: "total_referrals")
		dictionary.setValue(self.rate, forKey: "rate")
		dictionary.setValue(self.rate_count, forKey: "user_rate_count")
		dictionary.setValue(self.wallet, forKey: "wallet")
		dictionary.setValue(self.wallet_currency_code, forKey: "wallet_currency_code")
		dictionary.setValue(self._id, forKey: "_id")
		dictionary.setValue(self.created_at, forKey: "created_at")
		dictionary.setValue(self.is_user_type_approved, forKey: "is_user_type_approved")
		dictionary.setValue(self.is_document_uploaded, forKey: "is_document_uploaded")
		dictionary.setValue(self.is_phone_number_verified, forKey: "is_phone_number_verified")
		dictionary.setValue(self.is_email_verified, forKey: "is_email_verified")
		dictionary.setValue(self.is_approved, forKey: "is_approved")
		dictionary.setValue(self.is_use_wallet, forKey: "is_use_wallet")
		dictionary.setValue(self.is_referral, forKey: "is_referral")
		dictionary.setValue(self.image_url, forKey: "image_url")
        dictionary.setValue(self.orders, forKey: "orders")
        dictionary.setValue(self.country_code, forKey: "country_code")

     	return dictionary
	}

}
