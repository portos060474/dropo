
import Foundation
 

public class AppKeyResponse {
	public var success : Bool?
	public var message : Int?
	public var appKeys :AppKeys?

    public class func modelsFromDictionaryArray(array:NSArray) -> [AppKeyResponse] {
        var models:[AppKeyResponse] = []
        for item in array {
            models.append(AppKeyResponse(dictionary: item as! [String:Any])!)
        }
        return models
    }

	required public init?(dictionary: [String:Any]) {

		success = dictionary["success"] as? Bool
		message = dictionary["message"] as? Int
		if (dictionary["app_keys"] != nil) { appKeys = AppKeys(dictionary: dictionary["app_keys"] as! [String:Any]) }
	}

		
	

}
