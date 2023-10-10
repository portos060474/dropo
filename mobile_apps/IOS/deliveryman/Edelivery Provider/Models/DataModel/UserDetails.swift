import Foundation

public class UserDetails {

    public var __v : String?
    public var _id : String?
    public var address : String?
    public var cart_id : String?
    public var city_id : String?
    public var comments : String?
    public var country_id : String?
    public var country_phone_code : String?
    public var created_at : String?
    public var current_order : String?
    public var device_token : String?
    public var device_type : String?
    public var email : String?
    public var first_name : String?
    public var image_url : String?
    public var is_approved : Bool?
    public var is_document_uploaded : Bool?
    public var is_email_verified : Bool?
    public var is_phone_number_verified : Bool?
    public var is_referral : Bool?
    public var is_use_wallet : Bool?
    public var is_user_type_approved : Bool?
    public var last_name : String?
    public var location : Array<Any>?
    public var orders : Array<Any>?
    public var password : String?
    public var phone : String?
    public var promo_count : String?
    public var rate : String?
    public var rate_count : String?
    public var referral_code : String?
    public var referred_by : String?
    public var server_token : String?
    public var total_referrals : String?
    public var unique_id : String?
    public var updated_at : String?
    public var user_type : String?
    public var user_type_id : String?
    public var wallet : String?
    public var wallet_currency_code : String?

    public class func modelsFromDictionaryArray(array:NSArray) -> [UserDetails] {
        var models:[UserDetails] = []
        for item in array {
            models.append(UserDetails(dictionary: item as! [String:Any])!)
        }
        return models
    }

    required public init?(dictionary: [String:Any]) {

        __v = dictionary["__v"] as? String
        _id = dictionary["_id"] as? String
        address = dictionary["address"] as? String
        cart_id = dictionary["cart_id"] as? String
        city_id = dictionary["city_id"] as? String
        comments = dictionary["comments"] as? String
        country_id = dictionary["country_id"] as? String
        country_phone_code = dictionary["country_phone_code"] as? String
        created_at = dictionary["created_at"] as? String
        current_order = dictionary["current_order"] as? String
        device_token = dictionary["device_token"] as? String
        email = dictionary["email"] as? String
        first_name = dictionary["first_name"] as? String
        image_url = dictionary["image_url"] as? String
        is_approved = dictionary["is_approved"] as? Bool
        is_document_uploaded = dictionary["is_document_uploaded"] as? Bool
        is_email_verified = dictionary["is_email_verified"] as? Bool
        is_phone_number_verified = dictionary["is_phone_number_verified"] as? Bool
        is_referral = dictionary["is_referral"] as? Bool
        is_use_wallet = dictionary["is_use_wallet"] as? Bool
        is_user_type_approved = dictionary["is_user_type_approved"] as? Bool
        last_name = dictionary["last_name"] as? String
        location = dictionary["location"] as? Array
        orders = dictionary["orders"] as? Array
        password = dictionary["password"] as? String
        phone = dictionary["phone"] as? String
        promo_count = dictionary["promo_count"] as? String
        rate = dictionary["rate"] as? String
        rate_count = dictionary["rate_count"] as? String
        referral_code = dictionary["referral_code"] as? String
        referred_by = dictionary["referred_by"] as? String
    }
}
