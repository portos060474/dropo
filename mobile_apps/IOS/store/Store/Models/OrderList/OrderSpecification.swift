//
//	OrderSpecification.swift
//
//	Create by Jaydeep Vyas on 10/8/2017
//	Copyright © 2017 Elluminati. All rights reserved.


import Foundation

class OrderSpecification{

    var id : String!
    var isRequired : Bool!
	var list : [OrderListItem]!
	var specificationName : String!
	var specificationPrice : Double!
    var type : Int!
    var uniqueId : Int!
    var range : Int!
    var rangeMax : Int!
    var selectionMessage:String = ""
    var selectedCount : Int = 0
    var nameLanguages = [String]()
    var user_can_add_specification_quantity = false

    var isAssociated: Bool = false
    var isParentAssociate: Bool = false
    var modifierName: String = ""
    var modifierGroupName: String = ""
    var modifierId: String = ""
    var modifierGroupId: String = ""

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
                  specificationName = StoreSingleton.shared.returnStringAccordingtoLanguage(arrStr: arr)
              }
              print("Item name : \(specificationName!)")
           }else{
               specificationName = dictionary["name"]! as? String
           }
        }else{
           specificationName = ""
        }

        print("nameLanguages \(nameLanguages)")
        
		specificationPrice = (dictionary["price"] as? Double)?.roundTo() ?? 0.0
        type = (dictionary["type"] as? Int) ?? 0
        uniqueId = (dictionary["unique_id"] as? Int) ?? 0
        range = (dictionary["range"] as? Int) ?? 0
        rangeMax = (dictionary["max_range"] as? Int) ?? 0
        user_can_add_specification_quantity = (dictionary["user_can_add_specification_quantity"] as? Bool) ?? false
        
        id = dictionary["_id"] as? String
        isRequired = (dictionary["is_required"] as? Bool) ?? false
        
        modifierId = dictionary["modifierId"] as? String ?? ""
        modifierGroupId = dictionary["modifierGroupId"] as? String ?? ""
        modifierName = dictionary["modifierName"] as? String ?? ""
        modifierGroupName = dictionary["modifierGroupName"] as? String ?? ""
        isAssociated = dictionary["isAssociated"] as? Bool ?? false
        isParentAssociate = dictionary["isParentAssociate"] as? Bool ?? false
	}
    
    func toDictionary(isPassArray:Bool) -> [String:Any] {
        var dictionary = [String:Any]()
        if list != nil{
            var dictionaryElements = [[String:Any]]()
            for listElement in list {
                dictionaryElements.append(listElement.toDictionary(isPassArray: isPassArray))
            }
            dictionary["list"] = dictionaryElements
        }
        if range != nil{
            dictionary["range"] = range
        }
        if rangeMax != nil{
            dictionary["max_range"] = rangeMax
        }
        //1-7
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
            dictionary["is_required"] = isRequired
        }
        dictionary["user_can_add_specification_quantity"] = user_can_add_specification_quantity
        
        return dictionary
    }
    
    func getProductJson() -> NSDictionary {
        let dictionary = NSMutableDictionary()
        
        if list != nil{
            var dictionaryElements = [NSDictionary]()
            for listElement in list {
                dictionaryElements.append(listElement.getProductJson())
            }
            dictionary.setValue(dictionaryElements, forKey: "list")
        }

        dictionary.setValue(uniqueId, forKey: "unique_id")

        return dictionary
    }

}
