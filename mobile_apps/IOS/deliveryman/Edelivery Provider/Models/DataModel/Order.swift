import Foundation
public class Order {
    public var _id : String?

    public var order_status : Int?
    public var order_status_id : String?
    public var order_id : String?
    public var store_image : String?
    public var store_name : String?
    public var store_id : String?


    public var time_left_to_responds_trip : Int?
    public var total_distance : Double?
    public var total_time : Double?
    public var confirmation_code_for_pickup:String?
    public var confirmation_code_for_complete_delivery:String?
    public var unique_id : Int?
    public var orderUniqueId : Int!
    public var deliveryNote : String! = ""
    var destinationAddresses : [Address]!
    var pickupAddresses : [Address]!
    var isConfirmationCodeRequiredAtPickupDelivery:Bool!
    var isConfirmationCodeRequiredAtCompletedelivery:Bool!
    var estimated_time_for_ready_order:String = ""
    var total_provider_income : Double = 0.0
    var currency:String = ""
    var orderDetails : [CartProduct]!
    var image_url : [String]!
    var delivery_type: Int!
    var isAllowContactlessDelivery:Bool = false
    var is_allow_pickup_order_verification:Bool = false
    var userDetails : CartUserDetail!
    var arrived_at_stop_no = 0

    public class func modelsFromDictionaryArray(array:NSArray) -> [Order] {
        var models:[Order] = []
        for item in array {
            models.append(Order(dictionary: item as! [String:Any])!)
        }
        return models
    }
    init() {
        
    }
    required public init?(dictionary: [String:Any]) {
        
        _id = (dictionary["_id"] as? String) ?? ""
        image_url = (dictionary["image_url"] as? [String]) ?? []
        order_id = (dictionary["order_id"] as? String) ?? ""
        order_status = (dictionary["delivery_status"] as? Int) ?? 0
        isAllowContactlessDelivery =  dictionary["is_allow_contactless_delivery"] as? Bool ?? false
        
        if dictionary["is_allow_pickup_order_verification"] != nil{
            is_allow_pickup_order_verification =  dictionary["is_allow_pickup_order_verification"] as? Bool ?? false
        }else{
            is_allow_pickup_order_verification = false
        }

        delivery_type = (dictionary["delivery_type"] as? Int) ?? 0
        order_status_id = (dictionary["order_status_id"] as? String) ?? ""
        store_image = (dictionary["store_image"] as? String) ?? ""
        store_id = (dictionary["store_id"] as? String) ?? ""


        store_name = (dictionary["store_name"] as? String) ?? ""
        time_left_to_responds_trip = (dictionary["time_left_to_responds_trip"] as? Int) ?? 59
        unique_id = (dictionary["unique_id"] as? Int) ?? 0
        orderUniqueId = (dictionary["order_unique_id"] as? Int) ?? 0
        total_distance = (dictionary["total_distance"] as? Double)?.roundTo() ?? 0.0
        total_time = (dictionary["total_time"] as? Double)?.roundTo() ?? 0.0
        confirmation_code_for_pickup = String( (dictionary["confirmation_code_for_pick_up_delivery"]  as? Int) ?? 0)
        confirmation_code_for_complete_delivery = String( (dictionary["confirmation_code_for_complete_delivery"]  as? Int) ?? 0 )
        
        deliveryNote = (dictionary["note_for_deliveryman"] as? String) ?? ""
        
        isConfirmationCodeRequiredAtPickupDelivery
            = (dictionary["is_confirmation_code_required_at_pickup_delivery"] as? Bool) ?? false
        
        isConfirmationCodeRequiredAtCompletedelivery
            = (dictionary["is_confirmation_code_required_at_complete_delivery"] as? Bool) ?? false
        
        estimated_time_for_ready_order = (dictionary["estimated_time_for_ready_order"] as? String) ?? ""
        total_provider_income = (dictionary["total_provider_income"] as? Double)?.roundTo() ?? 0.0
        currency = (dictionary["currency"] as? String) ?? ""
        arrived_at_stop_no = (dictionary["arrived_at_stop_no"] as? Int) ?? 0
        
        destinationAddresses = [Address]()
        if let destinationAddressesArray = dictionary["destination_addresses"] as? [[String:Any]]{
            for dic in destinationAddressesArray{
                let value = Address(fromDictionary: dic)
                destinationAddresses.append(value)
            }
        }
        
        pickupAddresses = [Address]()
        if let pickupAddressesArray = dictionary["pickup_addresses"] as? [[String:Any]]{
            for dic in pickupAddressesArray{
                let value = Address(fromDictionary: dic)
                pickupAddresses.append(value)
            }
        }
        
        orderDetails = [CartProduct]()
        if let orderDetailsArray = dictionary["order_details"] as? [[String:Any]]{
            for dic in orderDetailsArray{
                
                let value = CartProduct.init(fromDictionary: dic)
                orderDetails.append(value)
            }
        }
        
        if let userDetailsData = dictionary["user_details"] as? [String:Any]{
            userDetails = CartUserDetail(fromDictionary: userDetailsData)
        }
    }
   
}


