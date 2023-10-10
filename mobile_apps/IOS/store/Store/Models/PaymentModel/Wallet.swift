
import Foundation
 
public class Wallet {
	public var success : Bool!
	public var message : Int!
	public var wallet : Double!
	public var walletCurrencyCode : String!


/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let Wallet = Wallet(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Wallet Instance.
*/
	init(fromDictionary dictionary: [String:Any]) {

		success = (dictionary["success"] as? Bool) ?? false
		message = (dictionary["message"] as? Int) ?? 0
		wallet = (dictionary["wallet"] as? Double)?.roundTo() ?? 0.00
		walletCurrencyCode = (dictionary["wallet_currency_code"] as? String) ?? ""
	}


}
