

import Foundation
 

public class User_detail {
	public var first_name : String!
	public var last_name : String!
	public var image_url : String!


    public class func modelsFromDictionaryArray(array:NSArray) -> [User_detail] {
        var models:[User_detail] = []
        for item in array {
            models.append(User_detail(dictionary: item as! [String:Any])!)
        }
        return models
    }


	required public init?(dictionary: [String:Any]) {

		first_name = (dictionary["first_name"] as? String) ?? ""
		last_name = (dictionary["last_name"] as? String) ?? ""
		image_url = (dictionary["image_url"] as? String) ?? ""
	}
		

	public func dictionaryRepresentation() -> [String:Any] {

	    var dictionary:[String:Any] = [:]
        dictionary["first_name"] = self.first_name
        dictionary["image_url"] = self.image_url
        dictionary["last_name"] = self.last_name
        
        
		
		return dictionary
	}

}
