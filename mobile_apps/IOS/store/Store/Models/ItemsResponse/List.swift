//
//	List.swift
//
//	Create by Jaydeep Vyas on 1/8/2017
//	Copyright © 2017 Elluminati. All rights reserved.

import Foundation



//	List.swift
//
//	Create by Jaydeep Vyas on 1/8/2017
//	Copyright © 2017 Elluminati. All rights reserved.

import Foundation


class List : NSObject{
    
    var id : String!
    var isDefaultSelected : Bool!
    var isUserSelected : Bool!
    var name : String!
    var price : Double!
    var specificationGroupId : String!
    var uniqueId : Int!
    var nameLanguages = [String]()
    var sequence_number : Int!
    public var quantity : Int = 1

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        id = dictionary["_id"] as? String
        isDefaultSelected = (dictionary["is_default_selected"] as? Bool) ?? false
        isUserSelected = (dictionary["is_user_selected"] as? Bool) ?? false
        price = (dictionary["price"] as? Double)?.roundTo() ?? 0.0
        specificationGroupId = dictionary["specification_group_id"] as? String
        uniqueId = (dictionary["unique_id"] as? Int) ?? 0
        sequence_number = dictionary["sequence_number"] as? Int ?? 0

        print("sequence_number 2 : \(sequence_number)")
        
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
               print("List name : \(name!)")
            }else{
                name = dictionary["name"]! as? String
            }
        }else{
            name = ""
        }
        
        quantity = dictionary["quantity"] as? Int ??  1
        
        print("nameLanguages \(nameLanguages)")
                
    }
    
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any] {
        var dictionary = [String:Any]()
        if id != nil{
            dictionary["_id"] = id
        }
        if isDefaultSelected != nil{
            dictionary["is_default_selected"] = isDefaultSelected
        }
        if isUserSelected != nil{
            dictionary["is_user_selected"] = isUserSelected
        }

        if nameLanguages != nil{
            dictionary["name"] = nameLanguages
        }
        if price != nil{
            dictionary["price"] = price
        }
        if specificationGroupId != nil{
            dictionary["specification_group_id"] = specificationGroupId
        }
        if uniqueId != nil{
            dictionary["unique_id"] = uniqueId
        }
        if sequence_number != nil{
            dictionary["sequence_number"] = sequence_number
        }
        dictionary["quantity"] = self.quantity
        return dictionary
    }
    
    public func getProductJson() -> NSDictionary {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.id, forKey: "_id")
        dictionary.setValue(self.uniqueId, forKey: "unique_id")
        dictionary.setValue(self.quantity, forKey: "quantity")
        
        return dictionary
    }
}




