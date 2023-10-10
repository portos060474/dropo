
import Foundation


public class CardResponse {
	public var success : Bool?
	public var message : Int?
	public var cards : Array<CardItem>?
    public var card : CardItem?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let CardResponse_list = CardResponse.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of CardResponse Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [CardResponse] {
        var models:[CardResponse] = []
        for item in array {
            models.append(CardResponse(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let CardResponse = CardResponse(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: CardResponse Instance.
*/
	required public init?(dictionary: NSDictionary) {

		success = dictionary["success"] as? Bool
            
		message = dictionary["message"] as? Int
		if (dictionary["cards"] != nil) { cards = CardItem.modelsFromDictionaryArray(array: dictionary["cards"] as! NSArray) }
        if (dictionary["card"] != nil) {
            card = CardItem.init(dictionary: dictionary["card"] as! NSDictionary)
        }
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.success, forKey: "success")
		dictionary.setValue(self.message, forKey: "message")

		return dictionary
	}

}
