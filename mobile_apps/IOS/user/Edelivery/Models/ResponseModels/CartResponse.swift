import Foundation

public class CartResponse {
	public var address : String?
    public var deliveryAddress : String?
	public var cart : CartOrder?
    public var cartId : String = ""
    public var cartCityId : String = ""
	public var currency : String?
    public var currencyCode : String = ""
    public var city : String?
	public var error_code : Int?
	public var location : Array<Double>?
    public var deliveryLocation : Array<Double>?
	public var message : Int?
	public var store_time : Array<String>?
	public var success : Bool?
    public var isUseItemTax : Bool! = false
    public var store_id : String = ""
//    public var tax :Double = 0.0

    var pickupAddress: [Address] = []
    var destinationAddress: [Address] = []
    var langItems : Array<SettingDetailLang>?
    var isTaxInlcuded : Bool!
    var StoreTaxDetails : [TaxesDetail]!
    var no_of_persons:Int = 0
    var table_no:Int = 0
    var booking_type:Int = 0
    var delivery_type:Int = 0

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let CartResponse_list = CartResponse.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of CartResponse Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [CartResponse] {
        var models:[CartResponse] = []
        for item in array {
            models.append(CartResponse(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let CartResponse = CartResponse(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: CartResponse Instance.
*/
	required public init?(dictionary: NSDictionary) {
		address = dictionary["address"] as? String
        deliveryAddress = dictionary["destination_address"] as? String
        currencyCode = (dictionary["currency_code"] as? String) ?? ""
		if (dictionary["cart"] != nil) {
            cart = CartOrder(dictionary: dictionary["cart"] as! NSDictionary)
        }
        if let dict =  dictionary["pickup_addresses"] {
            pickupAddress = [Address.init(fromDictionary: ((dict as! Array<Any>)[0] as! [String:Any]) )]
        }
        if let dict =  dictionary["destination_addresses"] {
            destinationAddress = [Address.init(fromDictionary: ((dict as! Array<Any>)[0] as! [String:Any]) )]
        }
		currency = dictionary["currency"] as? String ?? ""
        cartCityId = dictionary["city_id"] as? String ?? ""
        cartId = dictionary["cart_id"] as? String ?? ""
        city = dictionary["city"] as? String ?? ""
		error_code = dictionary["error_code"] as? Int
		if (dictionary["location"] != nil) {
            location = (dictionary["location"] as! NSArray) as? Array<Double>
        }
        if (dictionary["destination_location"] != nil) {
            deliveryLocation = (dictionary["destination_location"] as! NSArray) as? Array<Double>
        }
		message = dictionary["message"] as? Int
        if (dictionary["store_time"] != nil) {
            store_time =  (dictionary["store_time"] as! NSArray) as? Array<String>
        }
		success = dictionary["success"] as? Bool
        isUseItemTax = (dictionary["is_use_item_tax"] as? Bool) ?? false
//        tax = (dictionary["item_tax"] as? Double)?.roundTo() ?? 0.0
        isTaxInlcuded = dictionary["is_tax_included"] as? Bool ?? false

        if (dictionary["languages_supported"] != nil) { langItems = SettingDetailLang.modelsFromDictionaryArray(array: dictionary["languages_supported"] as! NSArray)
        }
        StoreTaxDetails = [TaxesDetail]()
        if let taxDetailsArray = dictionary["tax_details"] as? [[String:Any]]{
            for dic in taxDetailsArray{
                let value = TaxesDetail(fromDictionary: dic)
                StoreTaxDetails.append(value)
            }
        }
        table_no = dictionary["table_no"] as? Int ?? 0
        no_of_persons = dictionary["no_of_persons"] as? Int ?? 0
        booking_type = dictionary["booking_type"] as? Int ?? 0
        delivery_type = dictionary["delivery_type"] as? Int ?? 0
        store_id = dictionary["store_id"] as? String ?? ""
	}

/**
    Returns the dictionary representation for the current instance.
    - returns: NSDictionary.
*/

	public func dictionaryRepresentation() -> NSDictionary {
		let dictionary = NSMutableDictionary()
		dictionary.setValue(self.address, forKey: "address")
		dictionary.setValue(self.cart, forKey: "cart")
		dictionary.setValue(self.currency, forKey: "currency")
		dictionary.setValue(self.error_code, forKey: "error_code")
		dictionary.setValue(self.message, forKey: "message")
		dictionary.setValue(self.success, forKey: "success")
        dictionary.setValue(self.city, forKey: "city")
        dictionary.setValue(self.store_id, forKey: "store_id")
		return dictionary
	}
}
