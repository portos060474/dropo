
import Foundation
 

public class Store_detail {
	public var name : String?
	public var image_url : String?


    public class func modelsFromDictionaryArray(array:NSArray) -> [Store_detail] {
        var models:[Store_detail] = []
        for item in array {
            models.append(Store_detail(dictionary: item as! [String:Any])!)
        }
        return models
    }


	required public init?(dictionary: [String:Any]) {

		name = dictionary["name"] as? String
		image_url = dictionary["image_url"] as? String
	}

		

	public func dictionaryRepresentation() -> [String:Any] {

		var dictionary:[String:Any] = [:]
        dictionary["name"] = self.name
        dictionary["image_url"] = self.image_url
        
		
		return dictionary
	}

}
