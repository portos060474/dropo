
import Foundation

public class Cities {
	public var _id : String?
	public var city_name : String?
    public class func modelsFromDictionaryArray(array:NSArray) -> [Cities] {
        var models:[Cities] = []
        for item in array {
            models.append(Cities(dictionary: item as! [String:Any])!)
        }
        return models
    }

	required public init?(dictionary: [String:Any]) {

		_id = dictionary["_id"] as? String
		city_name = dictionary["city_name"] as? String
	}
	public func dictionaryRepresentation() -> [String:Any] {
         var dictionary:[String:Any] = [:]

		dictionary["_id"] = self._id
		dictionary["city_name"] = self.city_name

		return dictionary
	}

}
