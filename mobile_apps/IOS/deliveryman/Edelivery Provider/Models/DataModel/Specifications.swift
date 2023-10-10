
import Foundation
 

public class OrderSpecification {
    var id : String!
    var isRequired : Bool!
    var list : [OrderListItem]!
    var specificationName : String!
    var specificationPrice : Double!
    var type : Int!
    var uniqueId : Int!
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        list = [OrderListItem]()
        if let listArray = dictionary["list"] as? [[String:Any]]{
            for dic in listArray{
                let value = OrderListItem(fromDictionary: dic)
                list.append(value)
            }
        }
        if dictionary["name"] as? String != nil {
            specificationName = dictionary["name"] as? String
        }
        else {
            specificationName = (dictionary["name"] as? [String])?.first
        }
        specificationPrice = (dictionary["price"] as? Double)?.roundTo() ?? 0.0
        type = (dictionary["type"] as? Int) ?? 0
        uniqueId = (dictionary["unique_id"] as? Int) ?? 0
        
        id = dictionary["_id"] as? String
        isRequired = (dictionary["is_required"] as? Bool) ?? false
    }
    
    func toDictionary() -> [String:Any] {
        var dictionary = [String:Any]()
        if list != nil{
            var dictionaryElements = [[String:Any]]()
            for listElement in list {
                dictionaryElements.append(listElement.toDictionary())
            }
            dictionary["list"] = dictionaryElements
        }
        if specificationName != nil{
            dictionary["name"] = specificationName
        }
        if specificationPrice != nil{
            dictionary["price"] = specificationPrice
        }
        if type != nil{
            dictionary["type"] = type
        }
        if uniqueId != nil{
            dictionary["unique_id"] = uniqueId
        }
        if id != nil{
            dictionary["_id"] = id
        }
        if isRequired != nil{
            dictionary["is_required"] = id
        }
        return dictionary
    }

	
}
