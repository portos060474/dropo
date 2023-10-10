

import Foundation
 
/* For support, please feel free to contact me at  */

public class PaymentGatewayResponse {


    
    var message : Int!
    var paymentGateway : [PaymentGatewayItem]!
    var success : Bool!
    var walletCurrencyCode:String!
    var isCashPaymentMode:Bool!
    var wallet:Double!
    var isUseWallet : Bool!

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let PaymentGatewayResponse_list = PaymentGatewayResponse.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of PaymentGatewayResponse Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [PaymentGatewayResponse] {
        var models:[PaymentGatewayResponse] = []
        for item in array {
            models.append(PaymentGatewayResponse(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let PaymentGatewayResponse = PaymentGatewayResponse(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: PaymentGatewayResponse Instance.
*/
	required public init?(dictionary: NSDictionary) {

        message = (dictionary["message"] as? Int) ??  0
        paymentGateway = [PaymentGatewayItem]()
        if (dictionary["payment_gateway"] != nil) {
            paymentGateway = PaymentGatewayItem.modelsFromDictionaryArray(array: dictionary["payment_gateway"] as! NSArray)
        }
        wallet = (dictionary["wallet"] as? Double)?.roundTo() ?? 0.0
        walletCurrencyCode = (dictionary["wallet_currency_code"] as? String) ?? ""
        isCashPaymentMode = (dictionary["is_cash_payment_mode"] as? Bool) ?? false
        
        
        success = (dictionary["success"] as? Bool) ?? false
        isUseWallet = (dictionary["is_use_wallet"] as? Bool) ?? false
        
	}

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any] {
        var dictionary = [String:Any]()
        if message != nil{
            dictionary["message"] = message
        }
        if paymentGateway != nil{
            var dictionaryElements = [[String:Any]]()
            for paymentGatewayElement in paymentGateway {
                dictionaryElements.append(paymentGatewayElement.toDictionary())
            }
            dictionary["payment_gateway"] = dictionaryElements
        }
        if success != nil{
            dictionary["success"] = success
        }
        if wallet != nil{
            dictionary["wallet"] = wallet
        }
        if walletCurrencyCode != nil{
            dictionary["wallet_currency_code"] = walletCurrencyCode
        }
        if isCashPaymentMode != nil{
            dictionary["is_cash_payment_mode"] = isCashPaymentMode
        }
        
        
        return dictionary
    }


}
