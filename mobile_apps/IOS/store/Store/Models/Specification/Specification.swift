//
//	Specification.swift
//
//	Create by Jaydeep Vyas on 27/7/2017
//	Copyright © 2017 Elluminati. All rights reserved.

import Foundation

class Specification{
    
    var v : Int!
    var id : String!
    var createdAt : String!
    var isDefaultSelected : Bool!
    var isUserSelected : Bool!
    var name : String!
    var price : Double!
    var productId : String!
    var specificationGroupId : String!
    var storeId : String!
    var uniqueId : Int!
    var updatedAt : String!
    var sequence_number : Int!

   // var nameLanguages:[String:String] = [:]
    var nameLanguages = [String]()

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]) {
        v = dictionary["__v"] as? Int
        id = dictionary["_id"] as? String
        createdAt = dictionary["created_at"] as? String
        isDefaultSelected = dictionary["is_default_selected"] as? Bool
        isUserSelected = dictionary["is_user_selected"] as? Bool


        if dictionary["name"] != nil{
           // print("Specification : \(dictionary["name"]!)")

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
              // print("Specification name : \(name!)")
            }else{
                name = dictionary["name"]! as? String
            }
        }else{
            name = ""
        }
        
        // print("nameLanguages \(nameLanguages)")
        
        
//        if !(nameLanguages.isEmpty)
//        {
//            if (nameLanguages[defaultLanguage] ?? "").count > 0
//            {
//                //name = (nameLanguages[defaultLanguage]) ?? ""
//            }
//            if (nameLanguages[selectedLanguage] ?? "").count > 0
//            {
//                //name = (nameLanguages[selectedLanguage] ) ?? ""
//            }
//        } else {
//           // name = ""
//        }
        
        //Janki
//       print(dictionary["name"]!)
//       if dictionary["name"] != nil{
//           nameLanguages = ((dictionary["name"] as! [String?]))
//           if !(nameLanguages.isEmpty) {
//               if nameLanguages.count > 0
//               {
//                   if nameLanguages[storeLanguageInd] != nil{
//                           name = (nameLanguages[storeLanguageInd]!)
//                       }else{
//                           name = ""
//                       }
//               }else{
//                       name = ""
//                  }
//              }
//       }else {
//           name = ""
//       }
//       print(name)
        sequence_number = dictionary["sequence_number"] as? Int ?? 0
        print(sequence_number!)
        price = (dictionary["price"] as? Double)?.roundTo() ?? 0.0
        productId = dictionary["product_id"] as? String
        specificationGroupId = dictionary["specification_group_id"] as? String
        storeId = dictionary["store_id"] as? String
        uniqueId = dictionary["unique_id"] as? Int
        updatedAt = dictionary["updated_at"] as? String
    }
    
}
