

import Foundation


public class Specifications {
	public var list : Array<SpecificationListItem>?
	public var type : Int?
	public var is_required : Bool?
	public var name : String?
    public var unique_id:Int?
    public var price:Double?
    var user_can_add_specification_quantity: Bool = false
    
    var range : Int!
    var rangeMax : Int!
    var selectionMessage:String = ""
    var selectedCount = 0
    var nameArray = [String]()
    var isAssociated: Bool = false
    var isParentAssociate: Bool = false
    var modifierName: String = ""
    var modifierGroupName: String = ""
    var modifierId: String = ""
    var modifierGroupId: String = ""
    var _id: String = ""
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [Specifications] {
        var models:[Specifications] = []
        for item in array {
            models.append(Specifications(dictionary: item as! NSDictionary)!)
        }
        return models
    }
	required public init?(dictionary: NSDictionary) {

		if (dictionary["list"] != nil) { list = SpecificationListItem.modelsFromDictionaryArray(array: dictionary["list"] as! NSArray)
        }
        range = (dictionary["range"] as? Int) ?? 0
        _id = (dictionary["_id"] as? String) ?? ""
        rangeMax = (dictionary["max_range"] as? Int) ?? 0
		type = (dictionary["type"] as? Int) ?? 0
		is_required = dictionary["is_required"] as? Bool
        user_can_add_specification_quantity = dictionary["user_can_add_specification_quantity"] as? Bool ?? false
        
        //Userapp //8-7
         if isNotNSNull(object: dictionary["name"] as AnyObject){
                 if dictionary["name"] as? String == nil{
                     if let name = dictionary["name"] as? [Any] {
                         nameArray.removeAll()
                         
                         for obj in name {
                             if let strName = obj as? String {
                                 nameArray.append(strName)
                             } else {
                                 nameArray.append("")
                             }
                         }
                         
                         if nameArray.count > 0{
                             self.name = nameArray[0]
                         }else{
                             self.name = ""
                         }
                     }
                 }else{
                     name = dictionary["name"] as? String ?? ""
                 }
             }else{
                 name = ""
             }
        
//		//name = dictionary["name"] as? String
        unique_id = (dictionary["unique_id"] as? Int) ?? 0
        price = dictionary["price"] as? Double ?? 0.0
        
        modifierId = dictionary["modifierId"] as? String ?? ""
        modifierGroupId = dictionary["modifierGroupId"] as? String ?? ""
        modifierName = dictionary["modifierName"] as? String ?? ""
        modifierGroupName = dictionary["modifierGroupName"] as? String ?? ""
        isAssociated = dictionary["isAssociated"] as? Bool ?? false
        isParentAssociate = dictionary["isParentAssociate"] as? Bool ?? false
	}
    
    public init () {
    }
    
	public func dictionaryRepresentation() -> NSDictionary {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.range, forKey: "range")
        dictionary.setValue(self.rangeMax, forKey: "max_range")
        dictionary.setValue(self.type, forKey: "type")
		dictionary.setValue(self.is_required, forKey: "is_required")
        //Userapp
//		dictionary.setValue(self.name, forKey: "name")
        if nameArray.count > 0
        {
            dictionary.setValue(self.nameArray, forKey: "name")
        }else{
            dictionary.setValue(self.name, forKey: "name")
        }
        dictionary.setValue(self.unique_id, forKey: "unique_id")
        dictionary.setValue(self.price, forKey: "price")
        dictionary.setValue(self.user_can_add_specification_quantity, forKey: "user_can_add_specification_quantity")
        
        var myArray:[Any] = []
        for item in self.list! {
            myArray.append(item.dictionaryRepresentation())
        }
        
        dictionary.setValue(myArray, forKey: "list")
        dictionary.setValue(self._id, forKey: "_id")
        
		return dictionary
	}
    
    public func getProductJson() -> NSDictionary {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.unique_id, forKey: "unique_id")
        
        var myArray:[Any] = []
        for item in self.list! {
            myArray.append(item.getProductJson())
        }
        
        dictionary.setValue(myArray, forKey: "list")
        
        return dictionary
    }

}
