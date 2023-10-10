import Foundation
public class ActiveOrderList {
    public var success : Bool?
    public var message : Int?
    public var arrOrder : Array<ActiveOrder>?
    public var arrNewOrder : Array<NewOrder>?
    public class func modelsFromDictionaryArray(array:NSArray, isNewOrder:Bool) -> [ActiveOrderList] {
        var models:[ActiveOrderList] = []
        for item in array {
            models.append(ActiveOrderList(dictionary: item as! [String:Any], isNewOrder: isNewOrder)!)
        }
        return models
    }
    required public init?(dictionary: [String:Any], isNewOrder:Bool) {
        
        if (dictionary["requests"] != nil) {
            if isNewOrder {
                arrNewOrder = NewOrder.modelsFromDictionaryArray(array: dictionary["requests"] as! NSArray)
            }else {
                arrOrder = ActiveOrder.modelsFromDictionaryArray(array: dictionary["requests"] as! NSArray)
            }
        }
    }
}
