
import Foundation


public class InvoiceResponse {
	 var success : Bool?
	 var message : Int?
	 var order_payment : OrderPayment?
     var store: Store?
     var serverTime:String = "";
     var timeZone:String = "";
    var isTaxInlcuded : Bool!
    var isUseItemTax : Bool!



/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let InvoiceResponse = InvoiceResponse(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: InvoiceResponse Instance.
*/
    required public init?(fromDictionary dictionary: [String:Any]) {

		success = (dictionary["success"] as? Bool?)!
		message = dictionary["message"] as? Int
		if (dictionary["order_payment"] != nil) {
            order_payment = OrderPayment(fromDictionary: dictionary["order_payment"] as! [String:Any])
        }
        if (dictionary["store"] != nil) {
            store = Store(fromDictionary: dictionary["store"]  as! [String:Any])
        }
        serverTime = (dictionary["server_time"] as? String) ?? ""
        timeZone = (dictionary["timezone"] as? String) ?? ""
        isTaxInlcuded = dictionary["is_tax_included"] as? Bool
        isUseItemTax = dictionary["is_use_item_tax"] as? Bool

	}

}
