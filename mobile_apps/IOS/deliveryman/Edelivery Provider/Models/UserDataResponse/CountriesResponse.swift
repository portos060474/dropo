
import Foundation
 
public class CountriesResponse {
	public var success : Bool?
	public var message : Int?
	public var countries : Array<Countries>?
    public class func modelsFromDictionaryArray(array:NSArray) -> [CountriesResponse] {
        var models:[CountriesResponse] = []
        for item in array {
            models.append(CountriesResponse(dictionary: item as! [String:Any])!)
        }
        return models
    }

	required public init?(dictionary: [String:Any]) {

		success = dictionary["success"] as? Bool
		message = dictionary["message"] as? Int
		if (dictionary["countries"] != nil) { countries = Countries.modelsFromDictionaryArray(array: dictionary["countries"] as! NSArray) }
	}
	
}
