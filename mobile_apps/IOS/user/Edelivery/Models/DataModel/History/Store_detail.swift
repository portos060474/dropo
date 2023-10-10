
import Foundation
 

public class Store_detail {
	public var name : String?
	public var image_url : String?
    public var phone : String?


    public class func modelsFromDictionaryArray(array:NSArray) -> [Store_detail] {
        var models:[Store_detail] = []
        for item in array {
            models.append(Store_detail(dictionary: item as! NSDictionary)!)
        }
        return models
    }


	required public init?(dictionary: NSDictionary) {

		name = dictionary["name"] as? String
		image_url = dictionary["image_url"] as? String
        phone = dictionary["phone"] as? String

	}
    

		

	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.name, forKey: "name")
		dictionary.setValue(self.image_url, forKey: "image_url")
        dictionary.setValue(self.phone, forKey: "phone")

		return dictionary
	}

}
