

import Foundation
 

public class Order_details {
	public var order_items : Array<Items>?
	public var total_item_price : Int?
	public var product_name : String?
	public var unique_id : Int?
	public var product_id : String?


    public class func modelsFromDictionaryArray(array:NSArray) -> [Order_details] {
        var models:[Order_details] = []
        for item in array {
            models.append(Order_details(dictionary: item as! NSDictionary)!)
        }
        return models
    }


	required public init?(dictionary: NSDictionary) {

		if (dictionary["items"] != nil) { order_items = Items.modelsFromDictionaryArray(array: dictionary["items"] as! NSArray) }
		total_item_price = dictionary["total_item_price"] as? Int
		product_name = dictionary["product_name"] as? String
		unique_id = dictionary["unique_id"] as? Int
		product_id = dictionary["product_id"] as? String
	}

		

	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.total_item_price, forKey: "total_item_price")
		dictionary.setValue(self.product_name, forKey: "product_name")
		dictionary.setValue(self.unique_id, forKey: "unique_id")
		dictionary.setValue(self.product_id, forKey: "product_id")

		return dictionary
	}

}
