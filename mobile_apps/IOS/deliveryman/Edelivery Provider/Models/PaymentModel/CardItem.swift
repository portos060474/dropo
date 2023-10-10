
import Foundation
 

public class CardItem {
    var id : String!
    var cardExpiryDate : String!
    var cardHolderName : String!
    var cardType : String!
    var createdAt : String!
    var customerId : String!
    var isDefault : Bool!
    var lastFour : String!
    var paymentId : String!
    var paymentToken : String!
    var uniqueId : Int!
    var updatedAt : String!
    var userId : String!
    var userType : Int!
    public class func modelsFromDictionaryArray(array:NSArray) -> [CardItem] {
        var models:[CardItem] = []
        for item in array {
            models.append(CardItem.init(fromDictionary: item as! [String:Any]))
        }
        return models
    }
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary:[String:Any]){
        
        id = dictionary["_id"] as? String
        cardExpiryDate = dictionary["card_expiry_date"] as? String
        cardHolderName = dictionary["card_holder_name"] as? String
        cardType = dictionary["card_type"] as? String
        createdAt = dictionary["created_at"] as? String
        customerId = dictionary["customer_id"] as? String
        isDefault = dictionary["is_default"] as? Bool
        lastFour = dictionary["last_four"] as? String
        paymentId = dictionary["payment_id"] as? String
        paymentToken = dictionary["payment_token"] as? String
        uniqueId = dictionary["unique_id"] as? Int
        updatedAt = dictionary["updated_at"] as? String
        userId = dictionary["user_id"] as? String
        userType = dictionary["user_type"] as? Int
    }
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any] {
        var dictionary = [String:Any]()
        if id != nil{
            dictionary["_id"] = id
        }
        if cardExpiryDate != nil{
            dictionary["card_expiry_date"] = cardExpiryDate
        }
        if cardHolderName != nil{
            dictionary["card_holder_name"] = cardHolderName
        }
        if cardType != nil{
            dictionary["card_type"] = cardType
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if customerId != nil{
            dictionary["customer_id"] = customerId
        }
        if isDefault != nil{
            dictionary["is_default"] = isDefault
        }
        if lastFour != nil{
            dictionary["last_four"] = lastFour
        }
        if paymentId != nil{
            dictionary["payment_id"] = paymentId
        }
        if paymentToken != nil{
            dictionary["payment_token"] = paymentToken
        }
        if uniqueId != nil{
            dictionary["unique_id"] = uniqueId
        }
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        if userId != nil{
            dictionary["user_id"] = userId
        }
        if userType != nil{
            dictionary["user_type"] = userType
        }
        return dictionary
    }
}
