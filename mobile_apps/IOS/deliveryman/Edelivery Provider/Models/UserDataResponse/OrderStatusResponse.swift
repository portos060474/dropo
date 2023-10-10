
import Foundation
 
public class OrderStatusResponse {
	public var success : Bool?
	public var message : Int?
	public var order : Order?
    public var userDetails : UserDetails!
    public var delivery_type : Int?
    public var is_distance_unit_mile : Bool?
    public class func modelsFromDictionaryArray(array:NSArray) -> [OrderStatusResponse] {
        var models:[OrderStatusResponse] = []
        for item in array {
            models.append(OrderStatusResponse(dictionary: item as! [String:Any]))
        }
        return models
    }
    required public init?() {
    }
        

    required public init(dictionary: [String:Any]) {
        
        success = (dictionary["success"] as? Bool) ?? false
        message = (dictionary["message"] as? Int) ?? 0
        if (dictionary["request"] != nil) {
            order = Order(dictionary: dictionary["request"] as! [String:Any])
        }
        if (dictionary["user_detail"] != nil) && (dictionary["user_detail"] as? [String:Any]) != nil{
            userDetails = UserDetails(dictionary: (dictionary["user_detail"] as? [String:Any])!)
        }else {
            userDetails = UserDetails(dictionary: [:])
        }
        is_distance_unit_mile = dictionary["is_distance_unit_mile"] as? Bool
    }
	public func dictionaryRepresentation() -> [String:Any] {
        var dictionary:[String:Any] = [:]
        dictionary["success"] = self.success
        dictionary["message"] = self.message
        return dictionary
	}
}
