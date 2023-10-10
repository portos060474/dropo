
import Foundation


public class InvoiceResponse {
	public var success : Bool?
	public var message : Int?
	public var order_payment : OrderPayment?
    public var store: StoreItem?
    public var itemDetail: ProductItemsItem?
    
    public var serverTime:String = ""
    public var timeZone:String = ""
    var vehicles:[VehicleDetail]
    var isAllowContactlessDelivery = false
    var isAllowUserToGiveTip = false
    public var tip_type:Int = 0
    var isTaxIncluded = false
    var isUseItemTax = false


/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let InvoiceResponse_list = InvoiceResponse.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of InvoiceResponse Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [InvoiceResponse] {
        var models:[InvoiceResponse] = []
        for item in array {
            models.append(InvoiceResponse(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let InvoiceResponse = InvoiceResponse(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: InvoiceResponse Instance.
*/
	required public init?(dictionary: NSDictionary) {
        isAllowContactlessDelivery = (dictionary["is_allow_contactless_delivery"] as? Bool ?? false)
		success = (dictionary["success"] as? Bool?)!
		message = dictionary["message"] as? Int
		if (dictionary["order_payment"] != nil) { order_payment = OrderPayment(dictionary: dictionary["order_payment"] as! NSDictionary) }
        if (dictionary["store"] != nil) {
            store = StoreItem(dictionary: dictionary["store"] as! NSDictionary)
        }
        vehicles = []
        if let vehicleArray = dictionary["vehicles"] as? [[String:Any]]{
            for dic in vehicleArray{
                let value = VehicleDetail(fromDictionary: dic)
                vehicles.append(value)
            }
        }
        serverTime = (dictionary["server_time"] as? String) ?? ""
        timeZone = (dictionary["timezone"] as? String) ?? ""
        
        if dictionary["is_allow_user_to_give_tip"] != nil{
            isAllowUserToGiveTip = (dictionary["is_allow_user_to_give_tip"] as? Bool ?? false)
        }
        if dictionary["tip_type"] != nil{
            tip_type = (dictionary["tip_type"] as? Int)!
        }
        
        if dictionary["is_tax_included"] != nil{
            isTaxIncluded = (dictionary["is_tax_included"] as? Bool ?? false)
        }
        if dictionary["is_use_item_tax"] != nil{
            isUseItemTax
                = (dictionary["is_use_item_tax"] as? Bool ?? false)
        }

        if let itemDetail = dictionary["item_detail"] as? [String:Any] {
            self.itemDetail = ProductItemsItem(dictionary: itemDetail as NSDictionary)
        }
    }
}



public class VehicleDetail{
    
    var descriptionField : String!
    var imageUrl : String!
    var isBusiness : Bool!
    var mapPinImageUrl : String!
    var uniqueId : Int!
    var vehicleName : String!
    var vehicleId : String!
    var isSelected: Bool = false
    var price_per_unit_distance: Double = 0.0
    var is_round_trip = false
    var round_trip_charge: Double = 0
    var additional_stop_price: Double = 0
    var size_type: Int = 0 // 1 = meter, 2 = centimeter, else no unit show
    var weight_type: Int = 0 // 1 = kg, 2 = gram, else no unit show
    var length: Double = 0
    var width: Double = 0
    var height: Double = 0
    var min_weight: Double = 0
    var max_weight: Double = 0
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]) {
        descriptionField = (dictionary["description"] as? String) ?? ""
        imageUrl = (dictionary["image_url"] as? String) ?? ""
        isBusiness = (dictionary["is_business"] as? Bool) ?? false
        mapPinImageUrl = (dictionary["map_pin_image_url"] as? String) ?? ""
        uniqueId = (dictionary["unique_id"] as? Int) ?? 0
        vehicleName = (dictionary["vehicle_name"] as? String) ?? ""
        vehicleId = (dictionary["_id"] as? String) ?? ""
        price_per_unit_distance = (dictionary["price_per_unit_distance"] as? Double) ?? 0.0
        is_round_trip = (dictionary["is_round_trip"] as? Bool) ?? false
        round_trip_charge = (dictionary["additional_stop_price"] as? Double) ?? 0
        additional_stop_price = (dictionary["is_round_trip"] as? Double) ?? 0
        size_type = (dictionary["size_type"] as? Int) ?? 0
        weight_type = (dictionary["weight_type"] as? Int) ?? 0
        length = (dictionary["length"] as? Double) ?? 0
        width = (dictionary["width"] as? Double) ?? 0
        height = (dictionary["height"] as? Double) ?? 0
        min_weight = (dictionary["min_weight"] as? Double) ?? 0
        max_weight = (dictionary["max_weight"] as? Double) ?? 0
        
    }
    
}
