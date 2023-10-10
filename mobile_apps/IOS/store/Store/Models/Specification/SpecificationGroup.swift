//
//	SpecificationGroup.swift
//
//	Create by Jaydeep Vyas on 27/7/2017
//	Copyright © 2017 Elluminati. All rights reserved.


import Foundation

class SpecificationGroup {

	var v : Int!
	var id : String!
	var createdAt : String!
	var name : String!
	var productId : String!
	var storeId : String!
	var uniqueId : Int!
    var sequence_number : Int!

	var updatedAt : String!
    var specifications : [Specification]! = []
    var nameLanguages = [String]()
    var user_can_add_specification_quantity = false

	init(fromDictionary dictionary: [String:Any]){
		v = dictionary["__v"] as? Int
		id = dictionary["_id"] as? String
		createdAt = dictionary["created_at"] as? String
		productId = dictionary["product_id"] as? String
		storeId = dictionary["store_id"] as? String
		uniqueId = dictionary["unique_id"] as? Int
		updatedAt = dictionary["updated_at"] as? String
        if let specificationsArray = dictionary["list"] as? [[String:Any]] {
            for dic in specificationsArray {
                specifications.append(Specification(fromDictionary: dic))
            }
        }
        sequence_number = dictionary["sequence_number"] as? Int ?? 0
        user_can_add_specification_quantity = dictionary["user_can_add_specification_quantity"] as? Bool ?? false
                
        if dictionary["name"] != nil{

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
            }else{
                name = dictionary["name"]! as? String
            }
        }else{
            name = ""
        }
        
	}

}
