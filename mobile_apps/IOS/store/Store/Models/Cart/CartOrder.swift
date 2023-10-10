import Foundation
 
public class CartOrder :NSObject {
    var userId : String!
    var serverToken : String!
    var isPaymentModeCash : Bool!
    var storeId : String!
    var totalOrderPrice : Double!
    
    var orderDetails :[CartProduct] = []
    
    var orderPaymentId : String!
    
    var deliveryNote : String!
    var pickupAddress: [Address] = []
    var destinationAddress: [Address] = []
    var totalCartPrice : Double! = 0.0
    var totalItemTax : Double! = 0.0
    var id : String!
    
    
    
    
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
            models.append(CartOrder(fromDictionary: item as!  [String:Any]))
        }
        return models
    }
    
    public required override init() {
        
    }
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let CartOrder = CartOrder(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: CartOrder Instance.
     */
    init(fromDictionary dictionary: [String:Any]){
        
        
        userId = (dictionary["user_id"] as? String) ?? ""
        id = (dictionary["_id"] as? String) ?? ""
        serverToken = (dictionary["server_token"] as? String) ?? ""
        if let dict =  dictionary["pickup_addresses"] {
            pickupAddress = [Address.init(fromDictionary: dict as! [String:Any])]
        }
        if let dict =  dictionary["destination_addresses"] {
            destinationAddress = [Address.init(fromDictionary: dict as! [String:Any])]
        }
        isPaymentModeCash = (dictionary["is_payment_mode_cash"] as? Bool) ?? false
        storeId = (dictionary["store_id"] as? String) ?? ""
        totalOrderPrice = (dictionary["total_order_price"] as? Double)?.roundTo()
        orderPaymentId = dictionary["order_payment_id"] as? String
        totalCartPrice = (dictionary["total_cart_price"] as? Double)?.roundTo()
        totalItemTax = (dictionary["total_item_tax"] as? Double)?.roundTo()
        if (dictionary["order_details"] != nil) { orderDetails = CartProduct.modelsFromDictionaryArray(array: dictionary["order_details"] as! NSArray)
        }
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func toDictionary() -> [String:Any] {
        
        var dictionary = [String:Any]()
        
        dictionary[PARAMS.USER_ID] = ""
        if serverToken != nil {dictionary[PARAMS.SERVER_TOKEN] = self.serverToken;}
        if isPaymentModeCash != nil {dictionary["is_payment_mode_cash"] = self.isPaymentModeCash;}
        if storeId != nil {dictionary[PARAMS.STORE_ID] = preferenceHelper.getUserId();}
        if totalOrderPrice != nil {dictionary[PARAMS.TOTAL_ORDER_PRICE] = self.totalOrderPrice;}
        if totalCartPrice != nil {dictionary["total_cart_price"] = self.totalCartPrice;}
        if orderPaymentId != nil {dictionary[PARAMS.ORDER_PAYMENT_ID] = self.orderPaymentId;}
        if id != nil {dictionary[PARAMS._ID] = self.id;}
        if !preferenceHelper.getCartID().isEmpty() {
            dictionary[PARAMS.CART_ID] = preferenceHelper.getCartID()
        }
        
        if deliveryNote != nil {dictionary["note_for_deliveryman"] = self.deliveryNote;}
        
       
        var myPickupArray:[Any] = [];
        var myDestinationArray:[Any] = [];
        for address in self.pickupAddress {
            myPickupArray.append(address.toDictionary())
        }
        for address in self.destinationAddress {
            myDestinationArray.append(address.toDictionary())
        }
        dictionary["pickup_addresses"] = myPickupArray
        dictionary["destination_addresses"] = myDestinationArray
        dictionary["total_cart_price"] = self.totalCartPrice
        dictionary["total_item_tax"] = self.totalItemTax
        dictionary[PARAMS.CART_UNIQUE_TOKEN] = preferenceHelper.getRandomCartID()
        dictionary["user_type"] = CONSTANT.TYPE_STORE
        var myArray:[Any] = [];
        for productItem in self.orderDetails {
            myArray.append(productItem.toDictionary())
        }
        dictionary["order_details"] = myArray
        return dictionary
    }
    
    
}
