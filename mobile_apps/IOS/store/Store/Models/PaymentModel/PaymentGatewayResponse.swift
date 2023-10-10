//
//	PaymentGateWayResponse.swift
//
//	Create by Elluminati iMac on 3/1/2018
//	Copyright © 2018. All rights reserved.


import Foundation


class PaymentGatewayResponse : NSObject{

	var message : Int!
	var paymentGateway : [PaymentGatewayItem]!
	var success : Bool!
    var walletCurrencyCode:String!
    var isCashPaymentMode:Bool!
    var wallet:Double!
   

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		message = (dictionary["message"] as? Int) ??  0
		paymentGateway = [PaymentGatewayItem]()
		if let paymentGatewayArray = dictionary["payment_gateway"] as? [[String:Any]]{
			for dic in paymentGatewayArray{
				let value = PaymentGatewayItem(fromDictionary: dic)
				paymentGateway.append(value)
			}
		}
        wallet = (dictionary["wallet"] as? Double)?.roundTo() ?? 0.0
        walletCurrencyCode = (dictionary["wallet_currency_code"] as? String) ?? ""
        isCashPaymentMode = (dictionary["is_cash_payment_mode"] as? Bool) ?? false
      
        
		success = (dictionary["success"] as? Bool) ?? false
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
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
