
import Foundation
 

public class CartProductItems {
	public var item_id : String?
	public var unique_id : Int?
	public var quantity : Int!
	public var item_name : String?
	public var image_url : Array<String>?
	public var item_price : Double?
    public var itemTax : Double = 0.0
    public var tax : Double = 0.0
    public var totalItemTax : Double = 0.0
	public var details : String?
	public var total_specification_price : Double?
    public var totalItemPrice:Double?
	public var specifications : [Specifications] = []
    public var producuItemsItem:ProductItemsItem?
    public var noteForItem:String! = ""
    public var maxItemQuantity:Int = 10
    public var totalSpecificationTax:Double = 0.0
    public var totalPrice:Double = 0.0
    public var totalTax:Double = 0.0
    public var taxDetails : [TaxesDetail]!

    public class func modelsFromDictionaryArray(array:NSArray) -> [CartProductItems] {
        var models:[CartProductItems] = []
        for item in array {
            models.append(CartProductItems(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
	required public init?(dictionary: NSDictionary) {

		item_id = (dictionary["item_id"] as? String) ?? ""
		unique_id = (dictionary["unique_id"] as? Int) ?? 0
		quantity = (dictionary["quantity"] as? Int) ?? 1
		item_name = (dictionary["item_name"] as? String) ?? ""
		item_price = (dictionary["item_price"] as? Double)?.roundTo()
        tax = ((dictionary["tax"] as? Double)?.roundTo()) ?? 0.0
        itemTax = ((dictionary["item_tax"] as? Double)?.roundTo()) ?? 0.0
        totalItemTax = ((dictionary["total_item_tax"] as? Double)?.roundTo()) ?? 0.0
        totalSpecificationTax =  ((dictionary["total_specification_tax"] as? Double)?.roundTo()) ?? 0.0
        producuItemsItem = dictionary["item_details"] as? ProductItemsItem
        totalItemPrice = (dictionary["total_item_price"] as? Double)?.roundTo() ?? 0.00
        maxItemQuantity = (dictionary["max_item_quantity"] as? Int) ?? 10
		details = dictionary["details"] as? String
        totalPrice = (dictionary["total_price"] as? Double)?.roundTo() ?? 0.00
        totalTax = (dictionary["total_tax"] as? Double)?.roundTo() ?? 0.00
        
		total_specification_price = (dictionary["total_specification_price"] as? Double)?.roundTo() ?? 0.00
		if (dictionary["specifications"] != nil) {
            specifications = Specifications.modelsFromDictionaryArray(array: dictionary["specifications"] as! NSArray)
        }
        if (dictionary["item_details"] != nil) {
            producuItemsItem = ProductItemsItem(dictionary: dictionary["item_details"] as! NSDictionary)
        }
        if preferenceHelper.getIsLoadItemImage() {
            if  (dictionary["image_url"] != nil) {
                image_url = (dictionary["image_url"] as! NSArray) as? Array<String>
            }
        }else {
            image_url = []
        }
        noteForItem = (dictionary["note_for_item"] as? String) ?? ""
        taxDetails = [TaxesDetail]()
        if let taxDetailsArray = dictionary["tax_details"] as? [[String:Any]]{
            for dic in taxDetailsArray{
                let value = TaxesDetail(fromDictionary: dic)
                taxDetails.append(value)
            }
        }
	}
    public init() {
    
    }

	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.item_id, forKey: "item_id")
		dictionary.setValue(self.unique_id, forKey: "unique_id")
		dictionary.setValue(self.quantity, forKey: "quantity")
		dictionary.setValue(self.item_name, forKey: "item_name")
		dictionary.setValue(self.image_url, forKey: "image_url")
		dictionary.setValue(self.item_price, forKey: "item_price")
		dictionary.setValue(self.details, forKey: "details")
		dictionary.setValue(self.total_specification_price, forKey: "total_specification_price")
        dictionary.setValue(self.totalItemPrice, forKey: "total_item_price")
        dictionary.setValue(self.totalSpecificationTax, forKey: "total_specification_tax")
        dictionary.setValue(noteForItem, forKey: "note_for_item")
        dictionary.setValue(totalPrice, forKey: "total_price")
        dictionary.setValue(totalTax, forKey: "total_tax")
        dictionary.setValue(totalItemTax, forKey: "total_item_tax")
        dictionary.setValue(tax, forKey: "tax")
        
        if (self.producuItemsItem != nil) {
            dictionary.setValue(self.producuItemsItem, forKey: "item_details")
        }
        var myArray:[Any] = []
        for item in self.specifications {
            myArray.append(item.dictionaryRepresentation())
        }
        
        dictionary.setValue(myArray, forKey: "specifications")
        
        dictionary.setValue(self.maxItemQuantity, forKey: "max_item_quantity")
        if taxDetails != nil{
            var dictionaryElements = [[String:Any]]()
            for taxDetailsElement in taxDetails {
                dictionaryElements.append(taxDetailsElement.toDictionary())
            }
            dictionary["tax_details"] = dictionaryElements
        }
		return dictionary
	}
    
    public func getProductJson() -> NSDictionary {

        let dictionary = NSMutableDictionary()

        dictionary.setValue(self.item_id, forKey: "item_id")
        dictionary.setValue(self.unique_id, forKey: "unique_id")

        var myArray:[Any] = []
        for item in self.specifications {
            myArray.append(item.getProductJson())
        }
        
        dictionary.setValue(myArray, forKey: "specifications")
        
        return dictionary
    }

}
