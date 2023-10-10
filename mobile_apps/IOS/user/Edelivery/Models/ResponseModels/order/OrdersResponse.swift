

import Foundation
 
/* For support, please feel free to contact me at  */

public class OrdersResponse {
	public var success : Bool?
	public var message : Int?
	public var orderList : Array<Order>?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let OrdersResponse_list = OrdersResponse.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of OrdersResponse Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [OrdersResponse] {
        var models:[OrdersResponse] = []
        for item in array {
            models.append(OrdersResponse(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let OrdersResponse = OrdersResponse(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: OrdersResponse Instance.
*/
	required public init?(dictionary: NSDictionary) {

		success = dictionary["success"] as? Bool
		message = dictionary["message"] as? Int
		if (dictionary["order_list"] != nil) {
            orderList = Order.modelsFromDictionaryArray(array: dictionary["order_list"] as! NSArray)
        }
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.success, forKey: "success")
		dictionary.setValue(self.message, forKey: "message")

		return dictionary
	}

}
