
import Foundation


public class CardResponse {
    var card : CardItem!
    var cards : [CardItem]!
    var message : Int!
    var success : Bool!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        if let cardData = dictionary["card"] as? [String:Any]{
            card = CardItem(fromDictionary: cardData)
        }
        if (dictionary["cards"] != nil) {
            cards = CardItem.modelsFromDictionaryArray(array: dictionary["cards"] as! NSArray)
        }
        message = dictionary["message"] as? Int
        success = dictionary["success"] as? Bool
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any] {
        var dictionary = [String:Any]()
        if card != nil{
            dictionary["card"] = card.toDictionary()
        }
        if message != nil{
            dictionary["message"] = message
        }
        if success != nil{
            dictionary["success"] = success
        }
        return dictionary
    }

}
