

import Foundation
public class Invoice {
	public var title : String?
	public var subTitle : String?
	public var price : String?
	public var isHideSubTitle : Bool?

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let user = User(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: User Instance.
*/
    required public init?(title:String, subTitle:String, price:String) {


		self.title = title
		self.subTitle = subTitle
		self.price = price
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.title, forKey: "title")
		dictionary.setValue(self.subTitle, forKey: "subTitle")
		dictionary.setValue(self.price, forKey: "price")
		return dictionary
	}

}
