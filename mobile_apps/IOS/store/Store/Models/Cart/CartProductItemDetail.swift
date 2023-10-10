import Foundation
public class CartProductItemDetail {
	var _id : String!
	var details : String!
	var uniqueId : Int!
	var createdAt : String!
	var imageURL : String!
	var isVisibleInStore : Bool!
	var updatedAt : String!
	var storeId : String!
	var name : String!
	
    public class func modelsFromDictionaryArray(array:NSArray) -> [CartProductItemDetail] {
        var models:[CartProductItemDetail] = []
        for item in array {
            models.append(CartProductItemDetail(fromDictionary: item as! [String:Any]))
        }
        return models
    }

    init(fromDictionary dictionary: [String:Any]) {
        let imageUrl = (dictionary["image_url"] as? String) ?? ""
        
		_id = (dictionary["_id"] as? String) ?? ""
		details = (dictionary["details"] as? String) ?? ""
		uniqueId = (dictionary["unique_id"] as? Int) ?? 0
		createdAt = (dictionary["created_at"] as? String) ?? ""
		imageURL = imageUrl
		isVisibleInStore = (dictionary["is_visible_in_store"] as? Bool) ?? false

		updatedAt = (dictionary["updated_at"] as? String) ?? ""
		storeId = (dictionary["store_id"] as? String) ?? ""
		name = (dictionary["name"] as? String) ?? ""
	
    }
    
    
    public func toDictionary() -> [String:Any] {

		
        
        var dictionary = [String:Any]()
        
        if details != nil{dictionary["details"] = details}
        if _id != nil {dictionary["_id"] = _id}
        
        if uniqueId != nil{dictionary["unique_id"] = uniqueId}
        if createdAt != nil{ dictionary["created_at"] = createdAt}
        if imageURL != nil{dictionary["image_url"] = imageURL}
        if isVisibleInStore != nil{dictionary["is_visible_in_store"] = isVisibleInStore}
        if updatedAt != nil{dictionary["updated_at"] = updatedAt}
        if storeId != nil{dictionary["store_id"] = storeId}
        if name != nil{dictionary["name"] = name}
        return dictionary
	}

}
