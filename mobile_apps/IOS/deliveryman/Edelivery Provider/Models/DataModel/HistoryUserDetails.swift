

import Foundation

public class HistoryUserDetails {
   
    var firstName : String!
    var imageUrl : String!
    var lastName : String!
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        firstName = (dictionary["first_name"] as? String) ?? ""
        imageUrl = (dictionary["image_url"] as? String) ?? ""
        lastName = (dictionary["last_name"] as? String) ?? ""
    }
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any] {
        var dictionary = [String:Any]()
      
        if firstName != nil{
            dictionary["first_name"] = firstName
        }
        if imageUrl != nil{
            dictionary["image_url"] = imageUrl
        }
        if lastName != nil{
            dictionary["last_name"] = lastName
        }
        return dictionary
    }

	
}
