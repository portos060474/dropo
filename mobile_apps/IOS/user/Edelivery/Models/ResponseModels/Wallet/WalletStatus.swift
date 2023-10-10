import Foundation
 

public class WalletStatusResponse {
	 var success : Bool!
	 var message : Int!
	 var isUseWallet : Bool!
/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let WalletStatus_list = WalletStatus.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of WalletStatus Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [WalletStatusResponse] {
        var models:[WalletStatusResponse] = []
        for item in array {
            models.append(WalletStatusResponse(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let WalletStatus = WalletStatus(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: WalletStatus Instance.
*/
	required public init?(dictionary: NSDictionary) {

		success = (dictionary["success"] as? Bool) ?? false
		message = (dictionary["message"] as? Int) ?? 0
		isUseWallet = (dictionary["is_use_wallet"] as? Bool) ?? false
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.success, forKey: "success")
		dictionary.setValue(self.message, forKey: "message")
		dictionary.setValue(self.isUseWallet, forKey: "is_use_wallet")
        return dictionary
	}

}
