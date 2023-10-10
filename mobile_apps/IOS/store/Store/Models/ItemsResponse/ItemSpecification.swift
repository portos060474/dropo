//
//	ItemSpecification.swift
//
//	Create by Jaydeep Vyas on 1/8/2017
//	Copyright © 2017 Elluminati. All rights reserved.

//
//	ItemSpecification.swift
//
//	Create by Jaydeep Vyas on 1/8/2017
//	Copyright © 2017 Elluminati. All rights reserved.

import Foundation


class ItemSpecification : NSObject{
    
    var id : String!
    var isRequired : Bool!
    var list : [List]!
    var name : String!
    var type : Int!
    var uniqueId : Int!
    var selectedCount : Int = 0
    var range : Int!
    var rangeMax : Int!
    var selectionMessage:String = ""
    var nameLanguages = [String]()
    var sequence_number : Int!
    var modifierId: String = ""
    var modifierGroupId: String = ""
    var user_can_add_specification_quantity: Bool = false
    var isAssociated: Bool = false
    var isParentAssociate: Bool = false
    var modifierName: String = ""
    var modifierGroupName: String = ""
    
    public var price:Double?
    
    /*Model from array*/
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [ItemSpecification] {
        var models:[ItemSpecification] = []
        for item in array {
            models.append(ItemSpecification.init(fromDictionary: item as! [String:Any]))
        }
        return models
    }
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        
        id = dictionary["_id"] as? String
        isRequired = (dictionary["is_required"] as? Bool) ?? false
        list = [List]()
        if let listArray = dictionary["list"] as? [[String:Any]]{
            for dic in listArray {
                let value = List(fromDictionary: dic)
                list.append(value)
            }
        }
        range = (dictionary["range"] as? Int) ?? 0
        rangeMax = (dictionary["max_range"] as? Int) ?? 0
        type = (dictionary["type"] as? Int) ?? 1
        uniqueId = dictionary["unique_id"] as? Int
        price = dictionary["price"] as? Double ?? 0.0
        sequence_number = dictionary["sequence_number"] as? Int ?? 0
        user_can_add_specification_quantity = dictionary["user_can_add_specification_quantity"] as? Bool ?? false
        
        modifierId = dictionary["modifierId"] as? String ?? ""
        modifierGroupId = dictionary["modifierGroupId"] as? String ?? ""
        modifierName = dictionary["modifierName"] as? String ?? ""
        modifierGroupName = dictionary["modifierGroupName"] as? String ?? ""
        isAssociated = dictionary["isAssociated"] as? Bool ?? false
        isParentAssociate = dictionary["isParentAssociate"] as? Bool ?? false
        
        print("sequence_number 3 : \(sequence_number!)")

        if dictionary["name"] != nil{
            print("Item : \(dictionary["name"]!)")

           var arr = [String]()
            if let _ = dictionary["name"] as? NSArray {
               for obj in dictionary["name"]! as! NSArray{
                   if StoreSingleton.shared.isNotNSNull(object: obj as AnyObject){
                       arr.append(obj as! String)
                   }else{
                       arr.append("")
                   }
               }
                nameLanguages.removeAll()
                nameLanguages.append(contentsOf: arr)

               if dictionary["name"] != nil{
                   name = StoreSingleton.shared.returnStringAccordingtoLanguage(arrStr: arr)
               }
               print("ItemSpecification issue name : \(name!)")
            }else{
                name = dictionary["name"]! as? String
            }
        }else{
            name = ""
        }
        
        print("ItemSpecification issue nameLanguages \(nameLanguages)")
    }

    func toDictionary() -> [String:Any] {
        var dictionary = [String:Any]()
        if id != nil{
            dictionary["_id"] = id
        }
        if range != nil{
            dictionary["range"] = range
        }
        if rangeMax != nil{
            dictionary["max_range"] = rangeMax
        }
        if isRequired != nil{
            dictionary["is_required"] = isRequired
        }
        if list != nil{
            var dictionaryElements = [[String:Any]]()
            for listElement in list {
                dictionaryElements.append(listElement.toDictionary())
            }
            dictionary["list"] = dictionaryElements
        }

        if nameLanguages != nil{
            dictionary["name"] = nameLanguages
        }
        
        if type != nil{
            dictionary["type"] = type
        }
        if uniqueId != nil{
            dictionary["unique_id"] = uniqueId
        }
        if price != nil{
        dictionary["price"] = price
        }
        
        if sequence_number != nil{
            dictionary["sequence_number"] = sequence_number
        }
        
        
        if modifierId != "" {
            dictionary["modifierId"] = modifierId
        }
        if modifierGroupId != "" {
            dictionary["modifierGroupId"] = modifierGroupId
        }
        if modifierGroupName != "" {
            dictionary["modifierGroupName"] = modifierGroupName
        }
        if modifierName != "" {
            dictionary["modifierName"] = modifierName
        }
        dictionary["isAssociated"] = isAssociated
        dictionary["isParentAssociate"] = isParentAssociate
        dictionary["user_can_add_specification_quantity"] = user_can_add_specification_quantity
        
        return dictionary
    }
    
    public func getProductJson() -> NSDictionary {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.uniqueId, forKey: "unique_id")
        
        var myArray:[Any] = []
        for item in self.list! {
            myArray.append(item.getProductJson())
        }
        
        dictionary.setValue(myArray, forKey: "list")
        dictionary.setValue(self.id, forKey: "_id")
        
        return dictionary
    }
}
