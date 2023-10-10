

import Foundation
 

public class CartProduct {
    var items : [OrderItem]!
    var productId : String!
    var productName : String!
    var totalItemPrice : Double!
    var uniqueId : Int!
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        items = [OrderItem]()
        if let itemsArray = dictionary["items"] as? [[String:Any]]{
            for dic in itemsArray{
                let value = OrderItem(fromDictionary: dic)
                items.append(value)
            }
        }
        productId = dictionary["product_id"] as? String
        productName = dictionary["product_name"] as? String
        totalItemPrice = (dictionary["total_item_price"] as? Double) ?? 0.0
        uniqueId = dictionary["unique_id"] as? Int
        
    }
    
    func toDictionary() -> [String:Any] {
        var dictionary = [String:Any]()
        if items != nil{
            var dictionaryElements = [[String:Any]]()
            for itemsElement in items {
                dictionaryElements.append(itemsElement.toDictionary())
            }
            dictionary["items"] = dictionaryElements
        }
        if productId != nil{
            dictionary["product_id"] = productId
        }
        if productName != nil{
            dictionary["product_name"] = productName
        }
        if totalItemPrice != nil{
            dictionary["total_item_price"] = totalItemPrice
        }
        if uniqueId != nil{
            dictionary["unique_id"] = uniqueId
        }
        return dictionary
    }
}
