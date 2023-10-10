

import Foundation
 

public class User_detail {
	public var first_name : String?
	public var last_name : String?
	public var image_url : String?


    public class func modelsFromDictionaryArray(array:NSArray) -> [User_detail] {
        var models:[User_detail] = []
        for item in array {
            models.append(User_detail(dictionary: item as! NSDictionary)!)
        }
        return models
    }


	required public init?(dictionary: NSDictionary) {

		first_name = dictionary["first_name"] as? String
		last_name = dictionary["last_name"] as? String
		image_url = dictionary["image_url"] as? String
	}
		

	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.first_name, forKey: "first_name")
		dictionary.setValue(self.last_name, forKey: "last_name")
		dictionary.setValue(self.image_url, forKey: "image_url")

		return dictionary
	}

}
public class ProviderDetail {
    public var name : String?
    public var phone : String?
    public var image_url : String?
    public var email : String?
    public var _id: String?
    required public init?(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        phone = dictionary["phone"] as? String
        image_url = dictionary["image_url"] as? String
        email = dictionary["email"] as? String
        _id = dictionary["_id"] as? String

    }
        
}
