
import Foundation
 


public class List {
	public var _id : String?
	public var price : Int?
	public var name : String?


    public class func modelsFromDictionaryArray(array:NSArray) -> [List] {
        var models:[List] = []
        for item in array {
            models.append(List(dictionary: item as! NSDictionary)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {

		_id = dictionary["_id"] as? String
		price = dictionary["price"] as? Int
		name = dictionary["name"] as? String
	}


	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self._id, forKey: "_id")
		dictionary.setValue(self.price, forKey: "price")
		dictionary.setValue(self.name, forKey: "name")

		return dictionary
	}

}
