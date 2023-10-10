//
//	Product.swift
//
//	Create by Jaydeep Vyas on 29/7/2017
//	Copyright © 2017 Elluminati. All rights reserved.


import Foundation

class ProductItem{

	var v : Int!
	var id : String!
	var createdAt : String!
	var details : String!
	var imageUrl : String!
	var isVisibleInStore : Bool!
	var items : [Item]!
    var name : String!
//    var nameLanguages:[String:Any] = [:]
    var nameLanguages = [String]()
    var storeId : String!
	var uniqueId : Int!
	var updatedAt : String!
    public var isProductFiltered : Bool = true
    var sequence_number : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */

	init(fromDictionary dictionary: [String:Any]){
		v = dictionary["__v"] as? Int
		id = dictionary["_id"] as? String
		createdAt = dictionary["created_at"] as? String
		details = dictionary["details"] as? String
		imageUrl = dictionary["image_url"] as? String
		isVisibleInStore = dictionary["is_visible_in_store"] as? Bool
		items = [Item]()
		if let itemsArray = dictionary["items"] as? [[String:Any]]{
			for dic in itemsArray{
				let value = Item(fromDictionary: dic)
				items.append(value)
			}
		}
        sequence_number = dictionary["sequence_number"] as? Int ?? 0

//        nameLanguages = (dictionary["name"] as? [String : Any]) ?? [:]
//        if !(nameLanguages.isEmpty)
//        {
//            if (nameLanguages[defaultLanguage] as? String ?? "").count > 0
//            {
//                //name = (nameLanguages[defaultLanguage] as? String) ?? ""
//            }
//            if (nameLanguages[selectedLanguage] as? String ?? "").count > 0
//            {
//               // name = (nameLanguages[selectedLanguage] as? String) ?? ""
//            }
//        } else {
//            //name = ""
//        }
//
//
//        print("ProductItem : \(dictionary["name"])")
//
//             if dictionary["name"] != nil{
//                var arr = [String]()
//                 if let _ = dictionary["name"] as? NSArray {
//                    for obj in dictionary["name"]! as! NSArray{
//                        if StoreSingleton.shared.isNotNSNull(object: obj as AnyObject){
//                            arr.append(obj as! String)
//                        }else{
//                            arr.append("")
//                        }
//                    }
//                    if dictionary["name"] != nil{
//                        name = StoreSingleton.shared.returnStringAccordingtoLanguage(arrStr: arr)
//                    }
//                    print("ProductItem name : \(name!)")
//                 }else{
//                     name = dictionary["name"]! as? String
//                 }
//             }else{
//                 name = ""
//             }
        
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
        print("ProductItem \(sequence_number) \(name)")

        storeId = dictionary["store_id"] as? String
		uniqueId = dictionary["unique_id"] as? Int
		updatedAt = dictionary["updated_at"] as? String
	}
    
    func toDictionary() -> [String:Any] {
        var dictionary = [String:Any]()
        if v != nil{
            dictionary["__v"] = v
        }
        if id != nil{
            dictionary["_id"] = id
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if details != nil{
            dictionary["details"] = details
        }
        if imageUrl != nil{
            dictionary["image_url"] = imageUrl
        }
       
        if isVisibleInStore != nil{
            dictionary["is_visible_in_store"] = isVisibleInStore
        }
        if items != nil
        {
        var myArray:Array<Any> = Array.init();
        for productItem in self.items! {
            myArray.append(productItem.toDictionary())
        }
        dictionary["items"] = myArray
        }
        if name != nil{
            dictionary["name"] = name
        }
        if storeId != nil{
            dictionary["store_id"] = storeId
        }
        if uniqueId != nil{
            dictionary["unique_id"] = uniqueId
        }
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        return dictionary
    }
    

}



class ProductListItem{
    
    var v : Int!
    var id : String!
    var createdAt : String!
    var details : String!
    var imageUrl : String!
    var isVisibleInStore : Bool!
    var name : String!
    var storeId : String!
    var uniqueId : Int!
    var updatedAt : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        v = dictionary["__v"] as? Int
        id = dictionary["_id"] as? String
        createdAt = dictionary["created_at"] as? String
        details = dictionary["details"] as? String
        imageUrl = dictionary["image_url"] as? String
        isVisibleInStore = dictionary["is_visible_in_store"] as? Bool
        name = dictionary["name"] as? String
        storeId = dictionary["store_id"] as? String
        uniqueId = dictionary["unique_id"] as? Int
        updatedAt = dictionary["updated_at"] as? String
    }
    
}
