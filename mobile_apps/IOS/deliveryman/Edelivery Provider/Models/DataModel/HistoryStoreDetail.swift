
import Foundation
 


public class HistoryStoreDetail {
    var imageUrl : String!
    var name : String!
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        imageUrl = (dictionary["image_url"] as? String) ?? ""
        name = (dictionary["name"] as? String) ?? ""
    }
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any] {
        var dictionary = [String:Any]()
        if imageUrl != nil{
            dictionary["image_url"] = imageUrl
        }
        if name != nil{
            dictionary["name"] = name
        }
        return dictionary
    }
	

}
