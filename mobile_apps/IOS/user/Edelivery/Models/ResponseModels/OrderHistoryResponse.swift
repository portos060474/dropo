

import Foundation
 
public class OrderHistoryResponse {
	public var success : String?
	public var message : Int?
	public var order_list : Array<Order_list>?


    public class func modelsFromDictionaryArray(array:NSArray) -> [OrderHistoryResponse] {
        var models:[OrderHistoryResponse] = []
        for item in array {
            models.append(OrderHistoryResponse(dictionary: item as! NSDictionary)!)
        }
        return models
    }


	required public init?(dictionary: NSDictionary) {

		success = dictionary["success"] as? String
		message = dictionary["message"] as? Int
		if (dictionary["order_list"] != nil) { order_list = Order_list.modelsFromDictionaryArray(array: dictionary["order_list"] as! NSArray) }
	}


	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.success, forKey: "success")
		dictionary.setValue(self.message, forKey: "message")

		return dictionary
	}

}
