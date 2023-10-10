import Foundation

public class DeliveriesItem {

	public var _id : String?
	public var unique_id : Int?
	public var updated_at : String?
	public var delivery_name : String?
	public var description : String?
	public var delivery_type_id : String?
	public var created_at : String?
	public var is_business : Bool?
    public var is_store_can_create_group : Bool?
	public var icon_url : String?
	public var image_url : String?
    public var map_pin_url : String?
    public var famousProductsTags:[Famous_Products_Tags] = []
	public var __v : Int?
    public var deliveryType : Int = 1
    public var sequence_number : Int = 0
    public var is_provide_table_booking:Bool! = false

    public class func modelsFromDictionaryArray(array:NSArray) -> [DeliveriesItem] {
        var models:[DeliveriesItem] = []
        for item in array {
            models.append(DeliveriesItem(dictionary: item as! NSDictionary)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {
        icon_url = (dictionary["icon_url"] as? String) ?? ""
        image_url =  (dictionary["image_url"] as? String) ?? ""
        map_pin_url = (dictionary["map_pin_url"] as? String) ?? ""
        deliveryType = (dictionary["delivery_type"] as? Int) ?? 1
        sequence_number = (dictionary["sequence_number"] as? Int) ?? 1
		_id = dictionary["_id"] as? String
		unique_id = dictionary["unique_id"] as? Int
		updated_at = dictionary["updated_at"] as? String
		delivery_name = dictionary["delivery_name"] as? String
		description = dictionary["description"] as? String
		delivery_type_id = dictionary["delivery_type_id"] as? String
		created_at = dictionary["created_at"] as? String
		is_business = dictionary["is_business"] as? Bool
        is_store_can_create_group = dictionary["is_store_can_create_group"] as? Bool
        is_provide_table_booking = dictionary["is_provide_table_booking"] as? Bool
		__v = dictionary["__v"] as? Int
        
        if let tags = dictionary["famous_products_tags"] as? [[String:Any]] {
            famousProductsTags.removeAll()
            for obj in tags {
                famousProductsTags.append(Famous_Products_Tags.init(dics: obj as NSDictionary))
            }
        }
   }

/**
    Returns the dictionary representation for the current instance.
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {
		let dictionary = NSMutableDictionary()
		dictionary.setValue(self._id, forKey: "_id")
		dictionary.setValue(self.unique_id, forKey: "unique_id")
		dictionary.setValue(self.updated_at, forKey: "updated_at")
		dictionary.setValue(self.delivery_name, forKey: "delivery_name")
		dictionary.setValue(self.description, forKey: "description")
		dictionary.setValue(self.delivery_type_id, forKey: "delivery_type_id")
		dictionary.setValue(self.created_at, forKey: "created_at")
		dictionary.setValue(self.is_business, forKey: "is_business")
        dictionary.setValue(self.is_store_can_create_group, forKey: "is_store_can_create_group")
		dictionary.setValue(self.icon_url, forKey: "icon_url")
		dictionary.setValue(self.image_url, forKey: "image_url")
		dictionary.setValue(self.__v, forKey: "__v")
        var arrTags = [NSDictionary]()
        for obj in famousProductsTags {
            let dicsObj = obj.dictionaryRepresentation()
            arrTags.append(dicsObj)
        }
        dictionary.setValue(arrTags, forKey: "famous_products_tags")
        dictionary.setValue(self.is_provide_table_booking, forKey: "is_provide_table_booking")
        return dictionary
	}
}
