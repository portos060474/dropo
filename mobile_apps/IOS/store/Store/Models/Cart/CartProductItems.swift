
import Foundation

class CartProductItems:NSObject {
    
    var details : String!
    var itemId : String!
    var itemName : String!
    var quantity : Int!
    var specifications : [ItemSpecification]!
    var uniqueId : Int!
    var imageURL:[String]!
    var noteForItem:String! = ""
    var productId:String!
    
    
    var itemPrice : Double!
    var totalSpecificationPrice :Double!
    var totalItemPrice:Double!
    var itemTax : Double!
    var tax : Double!
    var totalItemTax : Double!
    var totalSpecificationTax:Double!
    var totalPrice:Double!
    var totalTax:Double!
    //    var itemTaxes = [String]()
    var taxDetails : [TaxesDetail]!
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let CartProductItems_list = CartProductItems.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of CartProductItems Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [CartProductItems] {
        var models:[CartProductItems] = []
        for item in array {
            models.append(CartProductItems(fromDictionary:  item as! [String : Any]))
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let CartProductItems = CartProductItems(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: CartProductItems Instance.
     */
    init(fromDictionary dictionary: [String:Any]){
        
        itemId = (dictionary["item_id"] as? String ) ??  ""
        uniqueId = (dictionary["unique_id"] as? Int) ?? 0
        quantity = (dictionary["quantity"] as? Int) ?? 1
        itemName = (dictionary["item_name"] as? String ) ??  ""
        itemPrice = (dictionary["item_price"] as? Double)?.roundTo() ?? 0.0
        tax = ((dictionary["tax"] as? Double)?.roundTo()) ?? 0.0
        itemTax = ((dictionary["item_tax"] as? Double)?.roundTo()) ?? 0.0
        totalItemTax = ((dictionary["total_item_tax"] as? Double)?.roundTo()) ?? 0.0
        totalSpecificationTax =  ((dictionary["total_specification_tax"] as? Double)?.roundTo()) ?? 0.0
        totalItemPrice = (dictionary["total_item_price"] as? Double)?.roundTo() ?? 0.00
        totalPrice = (dictionary["total_price"] as? Double)?.roundTo() ?? 0.00
        totalTax = (dictionary["total_tax"] as? Double)?.roundTo() ?? 0.00
        totalSpecificationPrice = (dictionary["total_specification_price"] as? Double)?.roundTo() ?? 0.00
        
        
        details = (dictionary["details"] as? String ) ??  ""
        totalSpecificationPrice = (dictionary["total_specification_price"] as? Double)?.roundTo() ?? 0.00
        if (dictionary["specifications"] != nil) {
            specifications = ItemSpecification.modelsFromDictionaryArray(array:dictionary["specifications"] as! NSArray)
        }
        if (dictionary["image_url"] != nil) {
            imageURL = ((dictionary["image_url"] as! NSArray) as? [String]) ?? []
        }
        noteForItem = (dictionary["note_for_item"] as? String ) ??  ""
        //        itemTaxes = dictionary["item_taxes"] as? [String] ?? [""]
        taxDetails = [TaxesDetail]()
        if let taxDetailsArray = dictionary["tax_details"] as? [[String:Any]]{
            for dic in taxDetailsArray{
                let value = TaxesDetail(fromDictionary: dic)
                taxDetails.append(value)
            }
        }
    }
    
    public required override init() {
        
    }
    
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    func toDictionary() -> [String:Any] {
        var dictionary = [String:Any]()
        
        
        if details != nil{dictionary["details"] = details}
        if itemPrice != nil {dictionary["item_price"] = itemPrice}
        if tax != nil{dictionary["tax"] = tax}
        if itemTax != nil{ dictionary["item_tax"] = itemTax}
        if totalItemTax != nil{dictionary["total_item_tax"] = totalItemTax}
        if totalSpecificationTax != nil{dictionary["total_specification_tax"] = totalSpecificationTax}
        if totalItemPrice != nil{dictionary["total_item_price"] = totalItemPrice   }
        if totalSpecificationPrice != nil{ dictionary["total_specification_price"] = totalSpecificationPrice }
        if totalPrice != nil{ dictionary["total_price"] = totalPrice}
        if totalTax != nil{dictionary["total_tax"] = totalTax}
        if imageURL != nil{ dictionary["image_url"] = imageURL}
        if itemId != nil{dictionary["item_id"] = itemId}
        if itemName != nil{ dictionary["item_name"] = itemName}
        if quantity != nil{ dictionary["quantity"] = quantity}
        if uniqueId != nil{    dictionary["unique_id"] = uniqueId}
        if productId != nil{dictionary["product_id"] = productId}
        
        
        if specifications != nil {
            var dictionaryElements = [[String:Any]]()
            for specificationsElement in specifications {
                dictionaryElements.append(specificationsElement.toDictionary())
            }
            dictionary["specifications"] = dictionaryElements
        }
        if taxDetails != nil{
            var dictionaryElements = [[String:Any]]()
            for taxDetailsElement in taxDetails {
                dictionaryElements.append(taxDetailsElement.toDictionary())
            }
            dictionary["tax_details"] = dictionaryElements
        }
        //        if itemTaxes != nil{
        //            dictionary["item_taxes"] = itemTaxes
        //        }
        
        return dictionary
    }
    
    public func getProductJson() -> NSDictionary {

        let dictionary = NSMutableDictionary()

        dictionary.setValue(self.itemId, forKey: "item_id")
        dictionary.setValue(self.uniqueId, forKey: "unique_id")

        var myArray:[Any] = []
        for item in self.specifications {
            myArray.append(item.getProductJson())
        }
        
        dictionary.setValue(myArray, forKey: "specifications")
        
        return dictionary
    }
    
}
