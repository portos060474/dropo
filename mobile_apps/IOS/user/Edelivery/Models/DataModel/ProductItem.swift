import Foundation
public class ProductItem {
	public var productDetail : ProductDetail?
	public var items : Array<ProductItemsItem>?
    public var isProductFiltered : Bool = true
    public class func modelsFromDictionaryArray(array:NSArray) -> [ProductItem] {
        var models:[ProductItem] = []
        for item in array {
            models.append(ProductItem(dictionary: item as! NSDictionary)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {
        if (dictionary["_id"] != nil) {
            productDetail = ProductDetail(dictionary: dictionary["_id"] as! NSDictionary)
        }
		if (dictionary["items"] != nil) { items = ProductItemsItem.modelsFromDictionaryArray(array: dictionary["items"] as! NSArray)
        }
	}
    
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.productDetail?.dictionaryRepresentation(), forKey: "_id")
        var myArray:[Any] = []
        for productItem in self.items! {
            myArray.append(productItem.dictionaryRepresentation())
        }
        dictionary.setValue(myArray, forKey: "items")

		return dictionary
	}

}
