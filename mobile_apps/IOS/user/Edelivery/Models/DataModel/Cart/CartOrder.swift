import Foundation
 
public class CartOrder {
	public var user_id : String?
    public var server_token : String?
	public var is_payment_mode_cash : Bool?
	public var store_id : String?
	public var total_order_price : Double?

    public var order_details : Array<CartProduct>?
    
    public var orderPaymentId : String?
    
    public var deliveryNote : String?
    var pickupAddress: [Address] = []
    var destinationAddress: [Address] = []
    public var totalCartPrice : Double! = 0.0
    public var totalItemTax : Double! = 0.0

    public var id : String?
    
    public var booking_type:Int?
    public var delivery_type:Int?
    public var no_of_persons:Int?
    public var table_no:Int?
    public var order_start_at:Int64 = 0
    public var order_start_at2:Int64 = 0
    public var table_id:String = ""

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let CartOrder_list = CartOrder.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of CartOrder Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [CartOrder] {
        var models:[CartOrder] = []
        for item in array {
            models.append(CartOrder(dictionary: item as! NSDictionary)!)
        }
        return models
    }
   
    public required  init() {
    }
/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let CartOrder = CartOrder(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: CartOrder Instance.
*/
	required public init?(dictionary: NSDictionary) {
        
		user_id = dictionary["user_id"] as? String
        id = (dictionary["_id"] as? String) ?? ""
		server_token = dictionary["server_token"] as? String
        if let dict =  dictionary["pickup_addresses"] {
            pickupAddress = [Address.init(fromDictionary: dict as! [String:Any])]
        }
        if let dict =  dictionary["destination_addresses"] {
            destinationAddress = [Address.init(fromDictionary: dict as! [String:Any])]
        }
		is_payment_mode_cash = dictionary["is_payment_mode_cash"] as? Bool
		store_id = dictionary["store_id"] as? String
		total_order_price = (dictionary["total_order_price"] as? Double)?.roundTo()
        totalCartPrice = (dictionary["total_cart_price"] as? Double)?.roundTo()
        totalItemTax = (dictionary["total_item_tax"] as? Double)?.roundTo()
        orderPaymentId = dictionary["order_payment_id"] as? String ?? ""
        if (dictionary["order_details"] != nil) {
            order_details = CartProduct.modelsFromDictionaryArray(array: dictionary["order_details"] as! NSArray)
        }
        booking_type = (dictionary["booking_type"] as? Int) ?? 0
        delivery_type = (dictionary["delivery_type"] as? Int) ?? 0
        no_of_persons = (dictionary["no_of_persons"] as? Int) ?? 0
        table_no = (dictionary["table_no"] as? Int) ?? 0
        
        if let number = dictionary["order_start_at"] as? NSNumber {
            order_start_at = Int64(truncating: number)
        }
        if let number = dictionary["order_start_at2"] as? NSNumber {
            order_start_at2 = Int64(truncating: number)
        }
        table_no = (dictionary["table_no"] as? Int) ?? 0
        table_id = (dictionary["table_id"] as? String) ?? ""
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

        if preferenceHelper.getSessionToken().isEmpty {
            dictionary.setValue("", forKey: PARAMS.USER_ID)
            dictionary.setValue(preferenceHelper.getRandomCartID(), forKey: PARAMS.IPHONE_ID)
            
        }else {
            dictionary.setValue(preferenceHelper.getUserId(), forKey: PARAMS.USER_ID)
            dictionary.setValue(preferenceHelper.getRandomCartID(), forKey: PARAMS.IPHONE_ID)
        }
		dictionary.setValue(CONSTANT.TYPE_USER, forKey: "user_type")
        
        dictionary.setValue(self.server_token, forKey: "server_token")
	
		dictionary.setValue(self.is_payment_mode_cash, forKey: "is_payment_mode_cash")
		dictionary.setValue(self.store_id, forKey: "store_id")
		dictionary.setValue(self.total_order_price, forKey: "total_order_price")
        dictionary.setValue(self.orderPaymentId, forKey: "order_payment_id")
        dictionary.setValue(self.totalCartPrice, forKey: "total_cart_price")
        dictionary.setValue(self.totalItemTax, forKey: "total_item_tax")
        
        dictionary.setValue(self.id, forKey: "_id")
        var myArray:[Any] = []
        for productItem in self.order_details! {
            myArray.append(productItem.dictionaryRepresentation())
        }
        
        dictionary.setValue(myArray, forKey: "order_details")
        dictionary.setValue(deliveryNote ?? "", forKey: "note_for_deliveryman")
        var myPickupArray: [Any] = []
        var myDestinationArray:[Any] = []
        for address in self.pickupAddress {
            myPickupArray.append(address.toDictionary())
        }
        for address in self.destinationAddress {
          myDestinationArray.append(address.toDictionary())
        }
        dictionary.setValue(myPickupArray, forKey: "pickup_addresses")
        dictionary.setValue(myDestinationArray, forKey: "destination_addresses")
        dictionary.setValue(CONSTANT.TYPE_USER, forKey: "user_type")

        dictionary.setValue(self.booking_type, forKey: "booking_type")
        dictionary.setValue(self.delivery_type, forKey: "delivery_type")
        dictionary.setValue(self.no_of_persons, forKey: "no_of_persons")
        dictionary.setValue(self.table_no, forKey: "table_no")
        
        dictionary.setValue(self.order_start_at, forKey: "order_start_at")
        dictionary.setValue(self.order_start_at2, forKey: "order_start_at2")
        dictionary.setValue(self.table_id, forKey: "table_id")

		return dictionary
	}
    
    
    public func dictionaryRepresentationOrder_details() -> NSDictionary {

        let dictionary = NSMutableDictionary()
        var myArray:[Any] = []
        for productItem in self.order_details! {
            myArray.append(productItem.dictionaryRepresentation())
        }
        dictionary.setValue(myArray, forKey: "order_details")
        return dictionary
    }
    
    
}
