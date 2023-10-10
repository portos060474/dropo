
import Foundation
 


class CartProduct {
	var productId : String!
	var uniqueId : Int!
	var productName : String!
	var totalItemPrice : Double!
	var items : [CartProductItems] = []
    var productItem : CartProductItemDetail!
    var totalItemTax : Double!
/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let CartProduct_list = CartProduct.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of CartProduct Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [CartProduct] {
        var models:[CartProduct] = []
        for item in array {
            models.append(CartProduct(dictionary: item as! [String:Any])!)
        }
        return models
    }

    public init() {
    }
/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let CartProduct = CartProduct(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: CartProduct Instance.
*/
    required public init?(dictionary: [String:Any]) {

		productId = (dictionary["product_id"] as? String) ?? ""
		uniqueId = (dictionary["unique_id"] as? Int) ?? 0
		productName = (dictionary["product_name"] as? String) ?? ""
		totalItemPrice = (dictionary["total_item_price"] as? Double)?.roundTo() ?? 0.00
        totalItemTax  = (dictionary["total_item_tax"] as? Double)?.roundTo() ?? 0.00
        productItem = dictionary["product_detail"] as? CartProductItemDetail
		if (dictionary["items"] != nil) {
            items = CartProductItems.modelsFromDictionaryArray(array: dictionary["items"] as! NSArray)
        }
        if (dictionary["product_detail"] != nil) {
            productItem = CartProductItemDetail(fromDictionary: dictionary["product_detail"] as! [String:Any])
        }
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
    

    func toDictionary() -> [String:Any] {
        var dictionary = [String:Any]()
        if uniqueId != nil{    dictionary["unique_id"] = uniqueId}
        if productId != nil{dictionary["product_id"] = productId}
        if productName != nil{dictionary["product_name"] = productName}
        if totalItemPrice != nil{dictionary["total_item_price"] = totalItemPrice}
        if totalItemTax != nil{dictionary["total_item_tax"] = totalItemTax}
        
        if productItem != nil {
            dictionary["product_detail"] = productItem.toDictionary()
        }
        if items != nil {
            var dictionaryElements = [[String:Any]]()
            for cartProductItem in items {
                dictionaryElements.append(cartProductItem.toDictionary())
            }
            dictionary["items"] = dictionaryElements
        }
        return dictionary
    }
    
    public func getProductJson() -> NSDictionary {

        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.productId, forKey: "product_id")
        dictionary.setValue(self.uniqueId, forKey: "unique_id")
        var myArray:[Any] = []
        for item in self.items {
            myArray.append(item.getProductJson())
        }
        dictionary.setValue(myArray, forKey: "items")
        return dictionary
    }
}
