import Foundation
public class NewOrder {
	public var _id : String?
    public var created_at : String?
    public var order_status : Int?
    public var store_image : String?
    public var store_name : String?
    public var unique_id : Int?
    public var orderUniqueId : Int!
    public var estimated_time_for_ready_order:String!
    var destinationAddresses : [Address]!
    var pickupAddresses : [Address]!
    var delivery_type: Int = 0
    
    var isAllowContactlessDelivery:Bool = false

    public class func modelsFromDictionaryArray(array:NSArray) -> [NewOrder] {
        var models:[NewOrder] = []
        for item in array {
            models.append(NewOrder(dictionary: item as! [String:Any])!)
        }
        return models
    }
    public init?() {
        
    }
	required public init?(dictionary: [String:Any]) {

		_id = (dictionary["_id"] as? String) ?? ""
		created_at = (dictionary["created_at"] as? String) ?? ""
		order_status = (dictionary["delivery_status"] as? Int) ?? 0
        delivery_type = (dictionary["delivery_type"] as? Int) ?? 0
        if dictionary["store_image_url"] != nil{
            store_image = (dictionary["store_image_url"] as? String) ?? ""
        }
		store_name = (dictionary["store_name"] as? String) ?? ""
        unique_id = (dictionary["unique_id"] as? Int) ?? 0
        orderUniqueId = (dictionary["order_unique_id"] as? Int) ?? 0
        estimated_time_for_ready_order = (dictionary["estimated_time_for_ready_order"] as? String) ?? ""
        isAllowContactlessDelivery =  dictionary["is_allow_contactless_delivery"] as? Bool ?? false

        pickupAddresses = [Address]()
        if let pickupAddressesArray = dictionary["pickup_addresses"] as? [[String:Any]]{
            for dic in pickupAddressesArray{
                let value = Address(fromDictionary: dic)
                pickupAddresses.append(value)
            }
        }
        destinationAddresses = [Address]()
        if let destinationAddressesArray = dictionary["destination_addresses"] as? [[String:Any]]{
            for dic in destinationAddressesArray{
                let value = Address(fromDictionary: dic)
                destinationAddresses.append(value)
            }
        }
        
	}
	public func dictionaryRepresentation() -> [String:Any] {

		var dictionary:[String:Any] = [:]
        dictionary["_id "] = self._id
        dictionary["created_at"] = self.created_at
        dictionary["delivery_status"] = self.order_status
        dictionary["store_image"] = self.store_image
        dictionary["store_name"] = self.store_name
        dictionary["order_unique_id"] = self.orderUniqueId
        dictionary["estimated_time_for_ready_order"] = self.estimated_time_for_ready_order
        
		return dictionary
	}

}
