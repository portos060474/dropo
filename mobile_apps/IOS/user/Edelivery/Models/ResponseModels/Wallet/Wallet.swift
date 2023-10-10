
import Foundation
 
public class Wallet {
	public var success : Bool!
	public var message : Int!
	public var wallet : Double!
	public var walletCurrencyCode : String!

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let Wallet_list = Wallet.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Wallet Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Wallet] {
        var models:[Wallet] = []
        for item in array {
            models.append(Wallet(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let Wallet = Wallet(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Wallet Instance.
*/
	required public init?(dictionary: NSDictionary) {

        success = (dictionary["success"] as? Bool) ?? false
        message = (dictionary["message"] as? Int) ?? 0
        wallet = (dictionary["wallet"] as? Double)?.roundTo() ?? 0.00
        walletCurrencyCode = (dictionary["wallet_currency_code"] as? String) ?? ""
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.success, forKey: "success")
		dictionary.setValue(self.message, forKey: "message")
		dictionary.setValue(self.wallet, forKey: "wallet")
		dictionary.setValue(self.walletCurrencyCode, forKey: "wallet_currency_code")

		return dictionary
	}

}
