

import Foundation
public class Invoice {
	public var title : String?
	public var subTitle : String?
	public var price : String?
	public var isHideSubTitle : Bool?
    public var sectionTitle : String?
    public var tip_amount : Double = 0.0

/**
    Constructs the object based on the given dictionary.
    Sample usage:
    let user = User(someDictionaryFromJSON)

    - parameter dictionary:  [String:Any] from JSON.

    - returns: User Instance.
*/
    required public init?(title:String, subTitle:String, price:String, sectionTitle:String = "",tip_amount:Double) {


		self.title = title
		self.subTitle = subTitle
		self.price = price
        self.sectionTitle = sectionTitle
        self.tip_amount = tip_amount

	}

		
/**
    Returns the dictionary representation for the current instance.
    - returns: [String:Any].
*/
	public func dictionaryRepresentation() -> [String:Any] {

		var dictionary:[String:Any] = [:]
        dictionary["title"] = self.title
        dictionary["subTitle"] = self.subTitle
        dictionary["price"] = self.price
        dictionary["sectionTitle"] = self.sectionTitle

		return dictionary
	}

}
