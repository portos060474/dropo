
import Foundation

public class UserDataResponse {
	public var success : Bool?
	public var message : Int?
	public var user : User?
	public var is_all_document_optional : Bool?
    public var minimum_phone_number_length:Int?
    public var maximum_phone_number_length:Int?
    public var firebaseToken : String?
    

    public class func modelsFromDictionaryArray(array:NSArray) -> [UserDataResponse] {
        var models:[UserDataResponse] = []
        for item in array {
            models.append(UserDataResponse(dictionary: item as! NSDictionary)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {

		success = (dictionary["success"] as? Bool?)!
		message = dictionary["message"] as? Int
		if (dictionary["user"] != nil) { user = User(dictionary: dictionary["user"] as! NSDictionary) }
		is_all_document_optional = (dictionary["is_all_document_optional"] as? Bool?)!
        
        minimum_phone_number_length = dictionary["minimum_phone_number_length"] as? Int
        maximum_phone_number_length = dictionary["maximum_phone_number_length"] as? Int
        firebaseToken = dictionary["firebase_token"] as? String
	}

    public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.success, forKey: "success")
		dictionary.setValue(self.message, forKey: "message")
        dictionary.setValue(self.minimum_phone_number_length, forKey: "minimum_phone_number_length")
        dictionary.setValue(self.maximum_phone_number_length, forKey: "maximum_phone_number_length")
		dictionary.setValue(self.user?.dictionaryRepresentation(), forKey: "user")
		dictionary.setValue(self.is_all_document_optional, forKey: "is_all_document_optional")
        dictionary.setValue(self.firebaseToken, forKey: "firebase_token")

		return dictionary
	}

}
