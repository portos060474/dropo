

import Foundation
public class Invoice {
	public var title : String?
	public var subTitle : String?
	public var price : String?
	public var isHideSubTitle : Bool?
    public var sectionTitle : String?

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let user = User(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: User Instance.
*/
    required public init?(title:String, subTitle:String, price:String, sectionTitle:String = "") {


		self.title = title
		self.subTitle = subTitle
		self.price = price
        self.sectionTitle = sectionTitle
	}

		

}
