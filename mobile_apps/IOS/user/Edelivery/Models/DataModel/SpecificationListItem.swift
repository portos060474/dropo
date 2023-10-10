import Foundation
public class SpecificationListItem {
	public var is_default_selected : Bool = false
	public var _id : String?
	public var price : Double?
	public var name : String?
	public var is_user_selected : Bool = false
    public var unique_id : Int?
    public var quantity : Int = 1
     var nameArray = [String]()

    public class func modelsFromDictionaryArray(array:NSArray) -> [SpecificationListItem] {
        var models:[SpecificationListItem] = []
        for item in array {
            models.append(SpecificationListItem(dictionary: item as! NSDictionary)!)
        }
        return models
    }
	required public init?(dictionary: NSDictionary) {

		is_default_selected = (dictionary["is_default_selected"] as? Bool) ?? false
		_id = dictionary["_id"] as? String
		price = dictionary["price"] as? Double ??  0.0
//		name = dictionary["name"] as? String
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

        unique_id = (dictionary["unique_id"] as? Int) ?? 0
		is_user_selected = (dictionary["is_user_selected"] as? Bool) ?? false
        quantity = dictionary["quantity"] as? Int ??  1
	}
		
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.is_default_selected, forKey: "is_default_selected")
		dictionary.setValue(self._id, forKey: "_id")
		dictionary.setValue(self.price, forKey: "price")
        //Userapp
        if nameArray.count > 0
        {
            dictionary.setValue(self.nameArray, forKey: "name")
        }else{
            dictionary.setValue(self.name, forKey: "name")
        }
		dictionary.setValue(self.is_user_selected, forKey: "is_user_selected")
		dictionary.setValue(self.unique_id, forKey: "unique_id")
        dictionary.setValue(self.quantity, forKey: "quantity")
        
		return dictionary
	}
    
    public func getProductJson() -> NSDictionary {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.unique_id, forKey: "unique_id")
        dictionary.setValue(self.quantity, forKey: "quantity")
        
        return dictionary
    }

}
