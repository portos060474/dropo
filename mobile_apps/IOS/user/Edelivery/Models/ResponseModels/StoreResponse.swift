import Foundation
public class StoreResponse {
	public var success : Bool = false
	public var message : Int?
	public var stores : StoreDictionary?
    public var server_time : String?
    public var ads:[AdItem] = []
    
    
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [StoreResponse] {
        var models:[StoreResponse] = []
        for item in array {
            models.append(StoreResponse(dictionary: item as! NSDictionary)!)
        }
        return models
    }
	required public init?(dictionary: NSDictionary) {

		success = (dictionary["success"] as? Bool)!
		message = dictionary["message"] as? Int
        server_time = dictionary["server_time"] as? String
	/*	if (dictionary["stores"] != nil) { stores = StoreItem.modelsFromDictionaryArray(array: dictionary["stores"] as! NSArray)
            
        }
        */
        if dictionary["stores"] != nil {
            stores = StoreDictionary.init(dictionary: dictionary["stores"]  as! NSDictionary)
        }
        if let adsArray =  dictionary[ "ads"] as? [[String:Any]] {
            
            for item in adsArray {
                
                let adItem:AdItem = AdItem.init(fromDictionary: item)
                  self.ads.append(adItem)
                
            }
            
            
        }
        
        
	}

	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.success, forKey: "success")
		dictionary.setValue(self.message, forKey: "message")
        dictionary.setValue(self.server_time, forKey: "server_time")

		return dictionary
	}

}
