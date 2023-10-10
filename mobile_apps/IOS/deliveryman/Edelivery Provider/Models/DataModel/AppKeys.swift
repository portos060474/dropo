
import Foundation
 


public class AppKeys {
	public var _id : String?
	public var iosUserAppGoogleKey : String?
	public var iosUserAppVersionCode : String?
	public var iosUserAppForceUpdate : Bool?

    public class func modelsFromDictionaryArray(array:NSArray) -> [AppKeys] {
        var models:[AppKeys] = []
        for item in array {
            models.append(AppKeys(dictionary: item as! [String:Any])!)
        }
        return models
    }

	required public init?(dictionary: [String:Any]) {

		_id = dictionary["_id"] as? String
		iosUserAppGoogleKey = dictionary["ios_provider_app_google_key"] as? String
		iosUserAppVersionCode = dictionary["ios_provider_app_version_code"] as? String
		iosUserAppForceUpdate = dictionary["is_ios_provider_app_force_update"] as? Bool
	}
	

}
