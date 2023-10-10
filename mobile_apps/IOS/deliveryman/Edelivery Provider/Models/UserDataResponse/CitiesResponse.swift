
import Foundation

public class CitiesResponse {
	public var success : Bool?
	public var message : Int?
	public var cities : Array<Cities>?
	public var country_phone_code : String?
	public var phone_number_length : Int?
    public class func modelsFromDictionaryArray(array:NSArray) -> [CitiesResponse] {
        var models:[CitiesResponse] = []
        for item in array {
            models.append(CitiesResponse(dictionary: item as! [String:Any])!)
        }
        return models
    }

	required public init?(dictionary: [String:Any]) {

		success = (dictionary["success"] as? Bool?)!
		message = dictionary["message"] as? Int
		if (dictionary["cities"] != nil) { cities = Cities.modelsFromDictionaryArray(array: dictionary["cities"] as! NSArray) }
		country_phone_code = (dictionary["country_phone_code"] as? String?)!
		phone_number_length = dictionary["phone_number_length"] as? Int
	}

    public func dictionaryRepresentation() -> [String:Any] {

		 var dictionary:[String:Any] = [:]
        dictionary["success"] = self.success
        dictionary["message"] = self.message
        dictionary["country_phone_code"] = self.country_phone_code
        dictionary["phone_number_length"] = self.phone_number_length
	
		return dictionary
	}

}
