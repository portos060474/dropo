

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
	public var social_id : String?
	public var login_by : String?
	public var country_phone_code : String?
	public var phone : String?
	public var address : String?
	public var zipcode : String?
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
    public var is_online : Bool?
    public var is_active : Bool?
	public var requests : Array<String>?
	public var image_url : String?
    public var orders : Array<String>?
    var vehicle_ids :[String]
    var socialIds : [String]!
    var selectedVehicleId:String!
    public var provider_type:Int
    public var firebase_token:String
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
            models.append(User(dictionary: item as! [String:Any])!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    Sample usage:
    let user = User(someDictionaryFromJSON)

    - parameter dictionary:  [String:Any] from JSON.

    - returns: User Instance.
*/
	required public init?(dictionary: [String:Any]) {

		__v = dictionary["__v"] as? Int
		unique_id = dictionary["unique_id"] as? Int
		updated_at = dictionary["updated_at"] as? String
		user_type = dictionary["user_type"] as? Int
		user_type_id = dictionary["user_type_id"] as? String
		first_name = dictionary["first_name"] as? String
		last_name = dictionary["last_name"] as? String
		email = dictionary["email"] as? String
		password = dictionary["password"] as? String
		social_id = dictionary["social_id"] as? String
		login_by = dictionary["login_by"] as? String
		country_phone_code = dictionary["country_phone_code"] as? String
		phone = dictionary["phone"] as? String ?? ""
		address = dictionary["address"] as? String
		country_id = dictionary["country_id"] as? String
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
        rate_count = dictionary["rate_count"] as? Int
		wallet = (dictionary["wallet"] as? Double) ?? 0.0
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
        is_online = dictionary["is_online"] as? Bool
        is_active = dictionary["is_active_for_job"] as? Bool
        selectedVehicleId = (dictionary["selected_vehicle_id"] as? String) ?? ""
		if (dictionary["requests"] != nil) {
            requests = (dictionary["requests"] as! NSArray) as? Array<String>
        }
        if (dictionary["orders"] != nil) {
            orders = (dictionary["orders"] as! NSArray) as? Array<
                String>
        }
		image_url = dictionary["image_url"] as? String
        socialIds = []
        if (dictionary["social_ids"] != nil) {
            
            socialIds = ((dictionary["social_ids"] as! NSArray) as? Array<String>) ?? []
        }
        vehicle_ids = (dictionary["vehicle_ids"] as? [String]) ?? []
        provider_type = (dictionary["provider_type"] as? Int) ?? 1
        firebase_token = (dictionary["firebase_token"] as? String ) ?? ""
	}
}
