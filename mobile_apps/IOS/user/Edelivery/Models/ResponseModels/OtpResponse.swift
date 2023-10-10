
import Foundation
 

public class OtpResponse {
	public var success : Bool
	public var message : Int?
	public var otp_for_sms : String? = ""
	public var otp_for_email : String? = ""

   public class func modelsFromDictionaryArray(array:NSArray) -> [OtpResponse] {
        var models:[OtpResponse] = []
        for item in array {
            models.append(OtpResponse(dictionary: item as! NSDictionary)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {

		success = (dictionary["success"] as? Bool)!
		message = dictionary["message"] as? Int
        otp_for_sms = (dictionary["otp_for_sms"] as? String?)!
        otp_for_email = (dictionary["otp_for_email"] as? String?)!
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.success, forKey: "success")
		dictionary.setValue(self.message, forKey: "message")
		dictionary.setValue(self.otp_for_sms, forKey: "otp_for_sms")
		dictionary.setValue(self.otp_for_email, forKey: "otp_for_email")

		return dictionary
	}

}
