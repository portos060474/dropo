
import Foundation


public class StoreProductResponse {
	 var products : Array<ProductItem>?
	 var message : Int?
	 var currency : String?
	 var success : Bool?
     var storeItem:StoreItem?
    var serverTime:String!
    var timeZone:String!
    

    public class func modelsFromDictionaryArray(array:NSArray) -> [StoreProductResponse] {
        var models:[StoreProductResponse] = []
        for item in array {
            models.append(StoreProductResponse(dictionary: item as! NSDictionary)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {

		if (dictionary["products"] != nil) { products = ProductItem.modelsFromDictionaryArray(array: dictionary["products"] as! NSArray) }
		message = dictionary["message"] as? Int
		currency = dictionary["currency"] as? String
		success = dictionary["success"] as? Bool
        storeItem =  StoreItem.init(dictionary:dictionary["store"] as! NSDictionary)
        serverTime = (dictionary["server_time"] as? String) ?? ""
        timeZone = (dictionary["timezone"] as? String) ?? ""
        
	}

    public func dictionaryRepresentation() -> NSDictionary {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.message, forKey: "message")
		dictionary.setValue(self.currency, forKey: "currency")
		dictionary.setValue(self.success, forKey: "success")
		return dictionary
	}

}
