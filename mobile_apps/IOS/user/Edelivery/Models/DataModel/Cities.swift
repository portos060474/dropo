
import Foundation

public class Cities {
	public var _id : String?
	public var city_name : String?
    public class func modelsFromDictionaryArray(array:NSArray) -> [Cities] {
        var models:[Cities] = []
        for item in array {
            models.append(Cities(dictionary: item as! NSDictionary)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {

		_id = dictionary["_id"] as? String
		city_name = dictionary["city_name"] as? String
	}
	public func dictionaryRepresentation() -> NSDictionary {
        let dictionary = NSMutableDictionary()

		dictionary.setValue(self._id, forKey: "_id")
		dictionary.setValue(self.city_name, forKey: "city_name")

		return dictionary
	}

}
