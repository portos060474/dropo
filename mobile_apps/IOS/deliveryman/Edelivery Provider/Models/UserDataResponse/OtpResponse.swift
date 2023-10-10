
import Foundation
 

public class OtpResponse {
	public var success : Bool
	public var message : Int?
	public var otp_for_sms : String?
	public var otp_for_email : String?

   public class func modelsFromDictionaryArray(array:NSArray) -> [OtpResponse] {
        var models:[OtpResponse] = []
        for item in array {
            models.append(OtpResponse(dictionary: item as! [String:Any])!)
        }
        return models
    }

	required public init?(dictionary: [String:Any]) {

		success = (dictionary["success"] as? Bool)!
		message = dictionary["message"] as? Int
		otp_for_sms = (dictionary["otp_for_sms"] as? String?)!
		otp_for_email = (dictionary["otp_for_email"] as? String?)!
	}

		
/**
    Returns the dictionary representation for the current instance.
    - returns: [String:Any].
*/
	public func dictionaryRepresentation() -> [String:Any] {

        var dictionary:[String:Any] = [:]
        dictionary["success"] = self.success
        dictionary["message"] = self.message
        dictionary["otp_for_sms"] = self.otp_for_sms
        dictionary["otp_for_email"] = self.otp_for_email
  		return dictionary
	}

}
