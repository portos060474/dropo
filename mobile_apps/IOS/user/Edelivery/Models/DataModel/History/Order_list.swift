
import Foundation
 

public class Order_list {
	public var _id : String?
	public var created_at : String?
	public var total_order_price : Double?
	public var currency : String!
    public var currencyCode : String = ""
	public var store_detail : Store_detail?
	public var user_detail : User_detail?
    public var uniqueID: Int?
    public var order_status : Int?
    public var total:Double?
    public var total_service_price:Double?
    public var delivery_type: Int?
    public var order_change: Bool?
    public var refund_amount : Double?
    var destination_addresses : [Address]?
    var imageUrl = [String]()

    //userapp //API changes
    public var order_status_id : Int?
    
    required public init() {
    
    }
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [Order_list] {
        var models:[Order_list] = []
        for item in array {
            models.append(Order_list(dictionary: item as! NSDictionary)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {
        _id = dictionary["_id"] as? String
		created_at = dictionary["created_at"] as? String
		total_order_price = (dictionary["total_order_price"] as? Double)?.roundTo() ?? 0.00
        order_status = dictionary["order_status"] as? Int
        delivery_type = (dictionary["delivery_type"] as? Int) ?? 0
		currency = (dictionary["currency"] as? String) ?? ""
        currencyCode = (dictionary["currency_code"] as? String) ?? ""
		if (dictionary["store_detail"] != nil) { store_detail = Store_detail(dictionary: dictionary["store_detail"] as! NSDictionary) }
		if (dictionary["provider_detail"] != nil) { user_detail = User_detail(dictionary: dictionary["provider_detail"] as! NSDictionary) }
        uniqueID = dictionary["unique_id"] as? Int
        total = (dictionary["total"] as? Double)?.roundTo() ?? 0.00
        total_service_price = (dictionary["total_service_price"] as? Double)?.roundTo() ?? 0.00
        order_change = (dictionary["order_change"] as? Bool)
        refund_amount = (dictionary["refund_amount"] as? Double)?.roundTo()
        order_status_id = dictionary["order_status_id"] as? Int ?? 0
        if let destinationDics = dictionary["destination_addresses"] as? [[String:Any]] {
            var arr = [Address]()
            for obj in destinationDics {
                arr.append(Address(fromDictionary: obj))
            }
            destination_addresses = arr
        }
        if let arrStr = dictionary["image_url"] as? [String] {
            var arr = [String]()
            for obj in arrStr {
                arr.append(obj)
            }
            imageUrl = arr
        }
    }

    public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self._id, forKey: "_id")
		dictionary.setValue(self.created_at, forKey: "created_at")
		dictionary.setValue(self.total_order_price, forKey: "total_order_price")
		dictionary.setValue(self.currency, forKey: "currency")
        dictionary.setValue(self.delivery_type!, forKey: "delivery_type")
		dictionary.setValue(self.store_detail?.dictionaryRepresentation(), forKey: "store_detail")
		dictionary.setValue(self.user_detail?.dictionaryRepresentation(), forKey: "provider_detail")
        dictionary.setValue(self.uniqueID, forKey: "unique_id")
        dictionary.setValue(self.order_status, forKey: "order_status")
        dictionary.setValue(self.order_change, forKey: "order_change")
      //  dictionary.setValue(self.refund_amount, forKey: "refund_amount")

		return dictionary
	}

}
