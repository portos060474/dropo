import Foundation
public class ActiveOrder {
	public var _id : String!
    public var created_at : String!
    public var estimated_time_for_ready_order:String!
    public var order_status : Int!
    public var source_address : String!
    public var store_image : String!
    public var store_name : String!
    public var unique_id : Int!
    public var orderUniqueId : Int!
    var user_first_name:String!
    var user_last_name:String!
    var user_image:String!
    var delivery_type: Int!
    var isAllowContactlessDelivery:Bool = false
    var user_detail : UserDetail?
    var is_bring_change : Bool!


    var destinationAddresses : [Address]!
    var pickupAddresses : [Address]!
    var arrived_at_stop_no = 0
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [ActiveOrder] {
        var models:[ActiveOrder] = []
        for item in array {
            models.append(ActiveOrder(dictionary: item as! [String:Any])!)
        }
        return models
    }

	required public init?(dictionary: [String:Any]) {

		_id = (dictionary["_id"] as? String) ??  ""
		created_at = (dictionary["created_at"] as? String) ??  ""
		estimated_time_for_ready_order = (dictionary["estimated_time_for_ready_order"] as? String) ?? ""
        
		order_status = (dictionary["delivery_status"] as? Int) ?? 0
        delivery_type = (dictionary["delivery_type"] as? Int) ?? 0
        source_address = (dictionary["source_address"] as? String) ?? ""
		store_image = (dictionary["store_image_url"] as? String) ?? ""
		store_name = (dictionary["store_name"] as? String) ?? ""
		unique_id = (dictionary["unique_id"] as? Int) ?? 0
        orderUniqueId = (dictionary["order_unique_id"] as? Int) ?? 0
         user_first_name = (dictionary["user_first_name"] as? String) ?? ""
        user_last_name = (dictionary["user_last_name"] as? String) ?? ""
        user_image = (dictionary["user_image"] as? String) ?? ""
        isAllowContactlessDelivery =  dictionary["is_allow_contactless_delivery"] as? Bool ?? false
        
        is_bring_change = (dictionary["is_bring_change"] as? Bool) ?? false
        arrived_at_stop_no = (dictionary["arrived_at_stop_no"] as? Int) ?? 0

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
        if (dictionary["user_detail"] != nil) { user_detail = UserDetail(fromDictionary: dictionary["user_detail"] as! [String:Any])}else{
            user_detail = UserDetail(fromDictionary: [:])
        }
	}
	public func dictionaryRepresentation() -> [String:Any] {

		 var dictionary:[String:Any] = [:]
        dictionary["_id"] = self._id
        dictionary["created_at"] = self.created_at
		
		dictionary["delivery_status"] = self.order_status
		dictionary["source_address"] = self.source_address
		dictionary["store_image"] = self.store_image
		dictionary["store_name"] = self.store_name
		dictionary["unique_id"] = self.unique_id
        dictionary["order_unique_id"] = self.orderUniqueId
        dictionary["estimated_time_for_ready_order"] = self.estimated_time_for_ready_order
        dictionary["arrived_at_stop_no"] = self.arrived_at_stop_no
        
        if pickupAddresses != nil{
            var dictionaryElements = [[String:Any]]()
            for pickupAddressesElement in pickupAddresses {
                dictionaryElements.append(pickupAddressesElement.toDictionary())
            }
            dictionary["pickup_addresses"] = dictionaryElements
        }
        if destinationAddresses != nil{
            var dictionaryElements = [[String:Any]]()
            for destinationAddressesElement in destinationAddresses {
                dictionaryElements.append(destinationAddressesElement.toDictionary())
            }
            dictionary["destination_addresses"] = dictionaryElements
        }
        if user_detail != nil{
            dictionary["user_detail"] = user_detail!.toDictionary()
        }
		return dictionary
	}
    

}
