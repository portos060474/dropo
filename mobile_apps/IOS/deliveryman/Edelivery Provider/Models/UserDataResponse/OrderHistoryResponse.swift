

import Foundation
 
public class OrderHistoryResponse {
	public var success : String?
	public var message : Int?
	public var order_list : Array<Order_list>?


    public class func modelsFromDictionaryArray(array:NSArray) -> [OrderHistoryResponse] {
        var models:[OrderHistoryResponse] = []
        for item in array {
            models.append(OrderHistoryResponse(dictionary: item as! [String:Any])!)
        }
        return models
    }


	required public init?(dictionary: [String:Any]) {

		success = dictionary["success"] as? String
		message = dictionary["message"] as? Int
		if (dictionary["request_list"] != nil) {
            order_list = Order_list.modelsFromDictionaryArray(array: dictionary["request_list"] as! NSArray) }
	}


	public func dictionaryRepresentation() -> [String:Any] {

		 var dictionary:[String:Any] = [:]
        dictionary["success"] = self.success
        dictionary["message"] = self.message
        return dictionary
	}

}
