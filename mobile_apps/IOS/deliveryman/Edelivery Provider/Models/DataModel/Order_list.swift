import Foundation

public class Order_list {
	public var _id : String?
	public var created_at : String?
	public var total_order_price : Int?
	public var currency : String?
	public var store_detail : Store_detail?
    var user_detail : UserDetail?
    public var uniqueID: Int?
    public var order_status : Int?
    public var provider_profit:Double?
    public var total:Double?
    public var total_service_price:Double?
    public var completed_at : String?
    public var delivery_type : Int!

    public class func modelsFromDictionaryArray(array:NSArray) -> [Order_list] {
        var models:[Order_list] = []
        for item in array {
            models.append(Order_list(dictionary: item as! [String:Any])!)
        }
        return models
    }

	required public init?(dictionary: [String:Any]) {
		_id = (dictionary["_id"] as? String) ?? ""
		created_at = (dictionary["created_at"] as? String) ?? ""
        completed_at = (dictionary["completed_at"] as? String) ?? ""
		total_order_price = (dictionary["total_order_price"] as? Int) ?? 0
        order_status = (dictionary["delivery_status"] as? Int) ?? 0
        delivery_type = (dictionary["delivery_type"] as? Int) ?? 0
		currency = (dictionary["currency"] as? String) ?? ""
		uniqueID = (dictionary["unique_id"] as? Int) ?? 0
        total = (dictionary["total"] as? Double)?.roundTo() ?? 0.00
        total_service_price = (dictionary["total_service_price"] as? Double)?.roundTo()
        provider_profit = (dictionary["provider_profit"] as? Double)?.roundTo()

        if (dictionary["store_detail"] != nil) {
            store_detail = Store_detail(dictionary: dictionary["store_detail"] as! [String:Any])
        }

        if (dictionary["user_detail"] != nil) {
            user_detail = UserDetail(fromDictionary: dictionary["user_detail"] as! [String:Any])
        } else {
            user_detail = UserDetail(fromDictionary: [:])
        }
	}
}
