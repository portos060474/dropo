//
//	OrderList.swift
//
//	Create by Jaydeep Vyas on 10/8/2017
//	Copyright © 2017 Elluminati. All rights reserved.


import Foundation

class OrderListItem{
    
    var id : String! = ""
    var name : String! = ""
    var price : Double! = 0.0
    var isDefaultSelected : Bool!
    var isUserSelected : Bool!
    var uniqueId : Int!
    var nameLanguages = [String]()
    static var isPassArray : Bool = true
    var quantity : Int = 1
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        id = dictionary["_id"] as? String
        //name = dictionary["name"] as? String
        price = (dictionary["price"] as? Double)?.roundTo() ?? 0.0
        isDefaultSelected = (dictionary["is_default_selected"] as? Bool) ?? true
        isUserSelected = (dictionary["is_user_selected"] as? Bool) ?? true
        
        uniqueId = (dictionary["unique_id"] as? Int) ?? 0
        
        quantity = (dictionary["quantity"] as? Int) ?? 1
        
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
                print("Item name : \(name!)")
            }else{
                name = dictionary["name"]! as? String
            }
        }else{
            name = ""
        }
        
        print("nameLanguages \(nameLanguages)")
    }
    
    
    func toDictionary(isPassArray:Bool) -> [String:Any] {
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
        //Storeapp //Changed 1-7 from name to namearray
        if isPassArray{
            dictionary["name"] = nameLanguages
        }else{
            dictionary["name"] = name
        }
        
        //        if name != nil{
        //            dictionary["name"] = nameLanguages
        //        }
        if price != nil{
            dictionary["price"] = price
        }
        if uniqueId != nil{
            dictionary["unique_id"] = uniqueId
        }
        
        dictionary["quantity"] = quantity
        
        return dictionary
    }
    
    func getProductJson() -> NSDictionary {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(uniqueId, forKey: "unique_id")
        dictionary.setValue(quantity, forKey: "quantity")
        return dictionary
    }
}
