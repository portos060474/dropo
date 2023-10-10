import Foundation
public class PaymentGatewayItem {
    var id : String!
    var descriptionField : String!
    var isPaymentByLogin : Bool!
    var isPaymentByWebUrl : Bool!
    var isPaymentVisible : Bool!
    var isUsingCardDetails : Bool!
    var name : String!
    var paymentKey : String!
    var paymentKeyId : String!
    var uniqueId : Int!


/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let PaymentGatewayItem_list = PaymentGatewayItem.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of PaymentGatewayItem Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [PaymentGatewayItem] {
        var models:[PaymentGatewayItem] = []
        for item in array {
            models.append(PaymentGatewayItem(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let PaymentGatewayItem = PaymentGatewayItem(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: PaymentGatewayItem Instance.
*/
    public init() {
    }
	required public init?(dictionary: NSDictionary) {

        id = (dictionary["_id"] as? String) ?? ""
        descriptionField = (dictionary["description"] as? String) ?? ""
        isPaymentByLogin = (dictionary["is_payment_by_login"] as? Bool) ?? false
        isPaymentByWebUrl = (dictionary["is_payment_by_web_url"] as? Bool) ?? false
        isPaymentVisible = (dictionary["is_payment_visible"] as? Bool) ?? false
        isUsingCardDetails = (dictionary["is_using_card_details"] as? Bool) ?? false
        name = (dictionary["name"] as? String) ?? ""
        paymentKey = (dictionary["payment_key"] as? String) ?? ""
        paymentKeyId = (dictionary["payment_key_id"] as? String) ?? ""
        uniqueId = (dictionary["unique_id"] as? Int) ?? 0
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
    func toDictionary() -> [String:Any] {
        var dictionary = [String:Any]()
        if id != nil{
            dictionary["_id"] = id
        }
        if descriptionField != nil{
            dictionary["description"] = descriptionField
        }
        if isPaymentByLogin != nil{
            dictionary["is_payment_by_login"] = isPaymentByLogin
        }
        if isPaymentByWebUrl != nil{
            dictionary["is_payment_by_web_url"] = isPaymentByWebUrl
        }
        if isPaymentVisible != nil{
            dictionary["is_payment_visible"] = isPaymentVisible
        }
        if isUsingCardDetails != nil{
            dictionary["is_using_card_details"] = isUsingCardDetails
        }
        if name != nil{
            dictionary["name"] = name
        }
        if paymentKey != nil{
            dictionary["payment_key"] = paymentKey
        }
        if paymentKeyId != nil{
            dictionary["payment_key_id"] = paymentKeyId
        }
        if uniqueId != nil{
            dictionary["unique_id"] = uniqueId
        }
        return dictionary
    }


}
