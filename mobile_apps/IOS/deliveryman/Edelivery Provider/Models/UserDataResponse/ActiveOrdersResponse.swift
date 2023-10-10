
import Foundation
 
public class ActiveOrdersResponse {
	public var success : Bool?
	public var message : Int?
    public var arrOrderList : Array<ActiveOrderList>?
    public class func modelsFromDictionaryArray(array:NSArray) -> [ActiveOrdersResponse] {
        let models:[ActiveOrdersResponse] = []
        /*for item in array {
            models.append(ActiveOrdersResponse(dictionary: item as! [String:Any])!)
        }*/
        return models
    }

    required public init?(dictionary: [String:Any], isNewOrder:Bool) {

		success = dictionary["success"] as? Bool
		message = dictionary["message"] as? Int
        
        if (dictionary["request_list"] != nil) {
            arrOrderList = ActiveOrderList.modelsFromDictionaryArray(array: dictionary["request_list"] as! NSArray, isNewOrder:isNewOrder)
        }
	}
	
}
