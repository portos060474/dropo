
import Foundation
 


public class CartProduct {
	public var product_id : String?
	public var unique_id : Int?
	public var product_name : String?
	public var total_item_price : Double?
	public var items : Array<CartProductItems>?
    public var productItem : CartProductItemDetail?
    public var totalItemTax : Double = 0.0
    public var totalCartAmountWithoutTax : Double = 0.0

    public class func modelsFromDictionaryArray(array:NSArray) -> [CartProduct] {
        var models:[CartProduct] = []
        for item in array {
            models.append(CartProduct(dictionary: item as! NSDictionary)!)
        }
        return models
    }

    public init() {
    }

	required public init?(dictionary: NSDictionary) {

		product_id = dictionary["product_id"] as? String
		unique_id = dictionary["unique_id"] as? Int
		product_name = dictionary["product_name"] as? String
        if (dictionary["total_item_price"] as? Double) != nil{
            total_item_price = (dictionary["total_item_price"] as? Double)?.roundTo() ?? 0.00
        }else{
            total_item_price = Double(((dictionary["total_item_price"] as? Int) ?? 0)).roundTo() 
        }
        
        
        totalItemTax = (dictionary["total_item_tax"] as? Double)?.roundTo() ?? 0.00
        
        productItem = dictionary["product_detail"] as? CartProductItemDetail
		if (dictionary["items"] != nil) {
            items = CartProductItems.modelsFromDictionaryArray(array: dictionary["items"] as! NSArray)
        }
        if (dictionary["product_detail"] != nil) {
            productItem = CartProductItemDetail(dictionary: dictionary["product_detail"] as! NSDictionary)
        }
        totalCartAmountWithoutTax = (dictionary["total_cart_amount_without_tax"] as? Double)?.roundTo() ?? 0.00

	}

	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()
        dictionary.setValue(self.totalItemTax, forKey: "total_item_tax")
		dictionary.setValue(self.product_id, forKey: "product_id")
		dictionary.setValue(self.unique_id, forKey: "unique_id")
		dictionary.setValue(self.product_name, forKey: "product_name")
		dictionary.setValue(self.total_item_price, forKey: "total_item_price")
        if (self.productItem != nil) {
            dictionary.setValue(self.productItem, forKey: "product_detail")
        }
        var myArray:[Any] = []
        for item in self.items! {
            myArray.append(item.dictionaryRepresentation())
        }
        
        dictionary.setValue(myArray, forKey: "items")
        dictionary.setValue(self.totalCartAmountWithoutTax, forKey: "total_cart_amount_without_tax")

		return dictionary
	}
    
    public func getProductJson() -> NSDictionary {

        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.product_id, forKey: "product_id")
        dictionary.setValue(self.unique_id, forKey: "unique_id")
        var myArray:[Any] = []
        for item in self.items! {
            myArray.append(item.getProductJson())
        }
        dictionary.setValue(myArray, forKey: "items")
        return dictionary
    }


}
