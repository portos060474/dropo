
import Foundation

public class UserDataResponse {
	public var success : Bool?
	public var message : Int?
	public var user : User?
    var vehicleDetail : VehicleDetail?
	public var is_all_document_optional : Bool?
    public var minimum_phone_number_length:Int?
    public var maximum_phone_number_length:Int?
    public var is_all_vehicle_document_uploaded : Bool! = false
    public class func modelsFromDictionaryArray(array:NSArray) -> [UserDataResponse] {
        var models:[UserDataResponse] = []
        for item in array {
            models.append(UserDataResponse(dictionary: item as! [String:Any])!)
        }
        return models
    }

	required public init?(dictionary: [String:Any]) {

		success = (dictionary["success"] as? Bool?)!
		message = dictionary["message"] as? Int
        if (dictionary["vehicle_detail"] != nil) {
            vehicleDetail = VehicleDetail.init(fromDictionary:  dictionary["vehicle_detail"] as! [String:Any])
        }
        if (dictionary["provider"] != nil) { user = User(dictionary: dictionary["provider"] as! [String:Any]) }
		is_all_document_optional = (dictionary["is_document_optional"] as? Bool?)!
        
        minimum_phone_number_length = dictionary["minimum_phone_number_length"] as? Int
        maximum_phone_number_length = dictionary["maximum_phone_number_length"] as? Int
        is_all_vehicle_document_uploaded = (dictionary["is_vehicle_document_uploaded"] as? Bool) ?? false
        
	}
}

