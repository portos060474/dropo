

import Foundation
 


class OrderItem{
    var details : String!
    var itemId : String!
    var itemName : String!
    var itemPrice : Double!
    var quantity : Int!
    var specifications : [OrderSpecification]!
    var totalSpecificationPrice : Double!
    var totalItemAndSpecificationPrice : Double!
    var uniqueId : Int!
    var imageURL:[String]!
    var noteForItem:String! = ""
    var productId:String!
    var totalItemPrice: Double!
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        details = (dictionary["details"] as? String) ?? ""
        itemId = (dictionary["item_id"] as? String) ?? (dictionary["_id"] as? String) ?? ""
        itemName = (dictionary["item_name"] as? String)  ?? (dictionary["name"] as? String) ?? ""
        itemPrice = (dictionary["item_price"] as? Double)?.roundTo() ??  (dictionary["price"] as? Double)?.roundTo() ?? 0.0
        quantity = (dictionary["quantity"] as? Int) ?? 1
        specifications = [OrderSpecification]()
        if let specificationsArray = dictionary["specifications"] as? [[String:Any]]{
            for dic in specificationsArray{
                let value = OrderSpecification(fromDictionary: dic)
                specifications.append(value)
            }
        }
        if let imageURLS  = dictionary["image_url"] as? [String] {
            imageURL = imageURLS
        }
        noteForItem = (dictionary["note_for_item"] as? String) ?? ""
        totalSpecificationPrice = (dictionary["total_specification_price"] as? Double)?.roundTo() ?? 0.0
        uniqueId = dictionary["unique_id"] as? Int
        totalItemAndSpecificationPrice = (dictionary["total_item_and_specification_price"] as? Double)?.roundTo() ?? 0.0
        totalItemPrice = (dictionary["total_item_price"] as? Double)?.roundTo() ?? 0.0
        productId = (dictionary["product_id"] as? String) ?? ""
    }
    
    func toDictionary() -> [String:Any] {
        var dictionary = [String:Any]()
        if details != nil{
            dictionary["details"] = details
        }
        if imageURL != nil{
            dictionary["image_url"] = imageURL
        }
        if itemId != nil{
            dictionary["item_id"] = itemId
        }
        if itemName != nil{
            dictionary["item_name"] = itemName
        }
        if itemPrice != nil{
            dictionary["item_price"] = itemPrice
        }
        if quantity != nil{
            dictionary["quantity"] = quantity
        }
        if specifications != nil{
            var dictionaryElements = [[String:Any]]()
            for specificationsElement in specifications {
                dictionaryElements.append(specificationsElement.toDictionary())
            }
            dictionary["specifications"] = dictionaryElements
        }
        if totalItemAndSpecificationPrice != nil{
            dictionary["total_item_and_specification_price"] = totalItemAndSpecificationPrice
        }
        if totalSpecificationPrice != nil{
            dictionary["total_specification_price"] = totalSpecificationPrice
        }
        if uniqueId != nil{
            dictionary["unique_id"] = uniqueId
        }
        if productId != nil{
            dictionary["product_id"] = productId
        }
        return dictionary
    }
}
