//
//	Product.swift
//
//	Create by Jaydeep Vyas on 26/7/2017
//	Copyright © 2017 Elluminati. All rights reserved.


import Foundation

class Product{

	var v : Int!
	var id : String!
	var createdAt : String!
	var details : String!
	var imageUrl : String!
	var isVisibleInStore : Bool!
	var name : String!
	var specificationsDetails : [String]!
	var storeId : String!
	var uniqueId : Int!
	var updatedAt : String!
//    var nameLanguages:[String:String] = [:]
    var nameLanguages = [String]()

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		v = (dictionary["__v"] as? Int) ?? 0
		id = (dictionary["_id"] as? String) ?? ""
		createdAt = (dictionary["created_at"] as? String) ?? ""
		details = (dictionary["details"] as? String) ?? ""
		imageUrl = (dictionary["image_url"] as? String) ?? ""
		isVisibleInStore = (dictionary["is_visible_in_store"] as? Bool) ?? false
		specificationsDetails = (dictionary["specifications_details"] as? [String]) ?? []
		storeId = (dictionary["store_id"] as? String) ?? ""
		uniqueId = (dictionary["unique_id"] as? Int) ?? 0
		updatedAt = (dictionary["updated_at"] as? String) ?? ""
//        nameLanguages = (dictionary["name"] as? [String : String]) ?? ["en":""]
//        if !(nameLanguages.isEmpty)
//        {
//            if (nameLanguages[defaultLanguage] ?? "").count > 0
//            {
//               // name = (nameLanguages[defaultLanguage]) ?? ""
//            }
//            if (nameLanguages[selectedLanguage] ?? "").count > 0
//            {
//               // name = (nameLanguages[selectedLanguage]) ?? ""
//            }
//        } else {
//            //name = ""
//        }
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



}
