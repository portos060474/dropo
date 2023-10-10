import Foundation
public class CartProductItemDetail {
	public var _id : String?
	public var details : String?
	public var unique_id : Int?
	public var created_at : String?
	public var image_url : String?
	public var is_visible_in_store : Bool?
	public var __v : Int?
	public var updated_at : String?
	public var store_id : String?
	public var name : String?
	public var items : Array<ProductItemsItem>?
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [CartProductItemDetail] {
        var models:[CartProductItemDetail] = []
        for item in array {
            models.append(CartProductItemDetail(dictionary: item as! NSDictionary)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {
        let imageUrl = (dictionary["image_url"] as? String) ?? ""
        
		_id = dictionary["_id"] as? String
		details = dictionary["details"] as? String
		unique_id = dictionary["unique_id"] as? Int
		created_at = dictionary["created_at"] as? String
		image_url = imageUrl
		is_visible_in_store = dictionary["is_visible_in_store"] as? Bool
		__v = dictionary["__v"] as? Int
		updated_at = dictionary["updated_at"] as? String
		store_id = dictionary["store_id"] as? String
		name = dictionary["name"] as? String
		if (dictionary["items"] != nil) { items = ProductItemsItem.modelsFromDictionaryArray(array: dictionary["items"] as! NSArray)
        }
	}
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self._id, forKey: "_id")
		dictionary.setValue(self.details, forKey: "details")
		dictionary.setValue(self.unique_id, forKey: "unique_id")
		dictionary.setValue(self.created_at, forKey: "created_at")
		dictionary.setValue(self.image_url, forKey: "image_url")
		dictionary.setValue(self.is_visible_in_store, forKey: "is_visible_in_store")
		dictionary.setValue(self.__v, forKey: "__v")
		dictionary.setValue(self.updated_at, forKey: "updated_at")
		dictionary.setValue(self.store_id, forKey: "store_id")
		dictionary.setValue(self.name, forKey: "name")

		return dictionary
	}

}
