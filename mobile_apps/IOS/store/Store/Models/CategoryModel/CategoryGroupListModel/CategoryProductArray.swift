//
//	CategoryProductArray.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class CategoryProductArray : NSObject, NSCoding{

	var id : String!
	var name : String!
    var nameLanguages = [String]()
    var isSelected : Bool!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		id = dictionary["_id"] as? String
        
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
        
        isSelected = false
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if id != nil{
			dictionary["_id"] = id
		}
		if name != nil{
			dictionary["name"] = name
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         id = aDecoder.decodeObject(forKey: "_id") as? String
         name = aDecoder.decodeObject(forKey: "name") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if id != nil{
			aCoder.encode(id, forKey: "_id")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}

	}

}
