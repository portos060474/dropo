
import Foundation


public class ProductDetail {
	public var _id : String?
	public var unique_id : Int?
	public var name : String?
	public var details : String?
	public var image_url : String?
	public var is_visible_in_store : String?
	public var created_at : String?
	public var updated_at : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let ProductDetail_list = ProductDetail.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of ProductDetail Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [ProductDetail] {
        var models:[ProductDetail] = []
        for item in array {
            models.append(ProductDetail(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let ProductDetail = ProductDetail(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: ProductDetail Instance.
*/
	required public init?(dictionary: NSDictionary) {

		_id = dictionary["_id"] as? String
		unique_id = dictionary["unique_id"] as? Int
		name = dictionary["name"] as? String
		details = dictionary["details"] as? String
        
        if preferenceHelper.getIsLoadItemImage() {
            image_url = dictionary["image_url"] as? String
        }else {
            image_url = ""
        }
		
		is_visible_in_store = dictionary["is_visible_in_store"] as? String
		created_at = dictionary["created_at"] as? String
		updated_at = dictionary["updated_at"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self._id, forKey: "_id")
		dictionary.setValue(self.unique_id, forKey: "unique_id")
		dictionary.setValue(self.name, forKey: "name")
		dictionary.setValue(self.details, forKey: "details")
		dictionary.setValue(self.image_url, forKey: "image_url")
		dictionary.setValue(self.is_visible_in_store, forKey: "is_visible_in_store")
		dictionary.setValue(self.created_at, forKey: "created_at")
		dictionary.setValue(self.updated_at, forKey: "updated_at")

		return dictionary
	}

}
