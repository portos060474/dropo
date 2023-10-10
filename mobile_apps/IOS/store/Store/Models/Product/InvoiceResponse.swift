
import Foundation


public class InvoiceResponse {
	public var success : Bool?
	public var message : Int?
	public var order_payment : OrderPayment?
    public var store: StoreItem?
    public var serverTime:String = "";
    public var timeZone:String = "";
    
/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let InvoiceResponse_list = InvoiceResponse.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of InvoiceResponse Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [InvoiceResponse]
    {
        var models:[InvoiceResponse] = []
        for item in array
        {
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

		success = (dictionary["success"] as? Bool?)!
		message = dictionary["message"] as? Int
		if (dictionary["order_payment"] != nil) { order_payment = OrderPayment(dictionary: dictionary["order_payment"] as! NSDictionary) }
        if (dictionary["store"] != nil) {
            store = StoreItem(dictionary: dictionary["store"] as! NSDictionary)
        }
        serverTime = (dictionary["server_time"] as? String) ?? ""
        timeZone = (dictionary["timezone"] as? String) ?? ""
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.success, forKey: "success")
		dictionary.setValue(self.message, forKey: "message")
        dictionary.setValue(self.order_payment?.dictionaryRepresentation(), forKey: "order_payment")
        dictionary.setValue(self.store?.dictionaryRepresentation(), forKey: "store")
		return dictionary
	}

}
