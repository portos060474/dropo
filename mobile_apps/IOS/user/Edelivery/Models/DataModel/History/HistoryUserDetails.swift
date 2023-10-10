

import Foundation

public class HistoryUserDetails {
	public var first_name : String!
	public var last_name : String!
	public var image_url : String!


    public class func modelsFromDictionaryArray(array:NSArray) -> [HistoryUserDetails] {
        var models:[HistoryUserDetails] = []
        for item in array {
            models.append(HistoryUserDetails(dictionary: item as! NSDictionary)!)
        }
        return models
    }


	required public init?(dictionary: NSDictionary) {

        first_name = (dictionary["first_name"] as? String) ?? ""
		last_name = (dictionary["last_name"] as? String) ?? ""
		image_url = (dictionary["image_url"] as? String) ?? ""
	}

    public init?() {
    }
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.first_name, forKey: "first_name")
		dictionary.setValue(self.last_name, forKey: "last_name")
		dictionary.setValue(self.image_url, forKey: "image_url")

		return dictionary
	}

}
