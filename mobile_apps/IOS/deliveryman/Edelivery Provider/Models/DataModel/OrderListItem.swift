
import Foundation
 


class OrderListItem{
    var id : String! = ""
    var name : String! = ""
    var price : Double! = 0.0
    var quantity: Int = 1
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        id = dictionary["_id"] as? String
        if dictionary["name"] as? String != nil {
            name = dictionary["name"] as? String ?? ""
        }
        else {
            name = (dictionary["name"] as? [String])?.first
        }
        price = (dictionary["price"] as? Double)?.roundTo() ?? 0.0
        quantity = dictionary["quantity"] as? Int ?? 1
    }
    
    func toDictionary() -> [String:Any] {
        var dictionary = [String:Any]()
        if id != nil{
            dictionary["_id"] = id
        }
        
        if name != nil{
            dictionary["name"] = name
        }
        if price != nil{
            dictionary["price"] = price
        }
        dictionary["quantity"] = quantity
        return dictionary
    }
}
