//
//	OrderDetails.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class OrderDetailsNew {

	var message : Int!
	var order : OrderOutsideNew!
	var success : Bool!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		message = dictionary["message"] as? Int
		if let orderData = dictionary["order"] as? [String:Any]{
			order = OrderOutsideNew(fromDictionary: orderData)
		}
		success = dictionary["success"] as? Bool
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
//	func toDictionary() -> [String:Any]
//	{
//		var dictionary = [String:Any]()
//		if message != nil{
//			dictionary["message"] = message
//		}
//		if order != nil{
//			dictionary["order"] = order.toDictionary()
//		}
//		if success != nil{
//			dictionary["success"] = success
//		}
//		return dictionary
//	}

//    /**
//    * NSCoding required initializer.
//    * Fills the data from the passed decoder
//    */
//    @objc required init(coder aDecoder: NSCoder)
//	{
//         message = aDecoder.decodeObject(forKey: "message") as? Int
//         order = aDecoder.decodeObject(forKey: "order") as? OrderOutsideNew
//         success = aDecoder.decodeObject(forKey: "success") as? Bool
//
//	}
//
//    /**
//    * NSCoding required method.
//    * Encodes mode properties into the decoder
//    */
//    @objc func encode(with aCoder: NSCoder)
//	{
//		if message != nil{
//			aCoder.encode(message, forKey: "message")
//		}
//		if order != nil{
//			aCoder.encode(order, forKey: "order")
//		}
//		if success != nil{
//			aCoder.encode(success, forKey: "success")
//		}
//
//	}

}


class OrderOutsideNew{

    var orderPaymentDetail : OrderPayment!
    var order : OrderNew!
    var cartDetail : CartDetailNew!
    var currency : String!
    var isConfirmationCodeRequiredAtCompleteDelivery : Bool!
    var isConfirmationCodeRequiredAtPickupDelivery : Bool!
    var providerDetail : OrderProviderDetail!
    var requestDetail : RequestDetailNew!
    var userImageUrl : String!
    var userId : String!
    var storeTaxDetails : [TaxesDetail]!
    var isTaxIncluded : Bool!

    var isUseItemTax : Bool!

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
       
        userId = dictionary["user_id"] as? String
        if let cartDetailData = dictionary["cart_detail"] as? [String:Any]{
            cartDetail = CartDetailNew(fromDictionary: cartDetailData)
        }
        currency = dictionary["currency"] as? String
        isConfirmationCodeRequiredAtCompleteDelivery = dictionary["is_confirmation_code_required_at_complete_delivery"] as? Bool
        isConfirmationCodeRequiredAtPickupDelivery = dictionary["is_confirmation_code_required_at_pickup_delivery"] as? Bool
        if let orderData = dictionary["order"] as? [String:Any]{
            order = OrderNew(fromDictionary: orderData)
        }else{
            order = OrderNew(fromDictionary: [:])
        }
        if let orderPaymentDetailData = dictionary["order_payment_detail"] as? [String:Any]{
            orderPaymentDetail = OrderPayment(fromDictionary: orderPaymentDetailData)
        }else{
            orderPaymentDetail = OrderPayment(fromDictionary: [:])
        }
        if let providerd = dictionary["provider_detail"] as? [String:Any]{
            providerDetail = OrderProviderDetail(fromDictionary: providerd)
        }
        
        
        if let req = dictionary["request_detail"] as? [String:Any]{
            requestDetail = RequestDetailNew(fromDictionary: req)
        }
        
//        providerDetail = dictionary["provider_detail"] as? AnyObject
//        requestDetail = dictionary["request_detail"] as? AnyObject
        userImageUrl = dictionary["user_image_url"] as? String ?? ""
        
        storeTaxDetails = [TaxesDetail]()
        if let taxDetailsArray = dictionary["store_tax_details"] as? [[String:Any]]{
            for dic in taxDetailsArray{
                let value = TaxesDetail(fromDictionary: dic)
                storeTaxDetails.append(value)
            }
        }
        
        if let tax = dictionary["is_tax_included"] as? Bool{
            isTaxIncluded = tax
        }
        
        if let itemTax = dictionary["is_use_item_tax"] as? Bool{
            isUseItemTax = itemTax
        }
        
        
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
//    func toDictionary() -> [String:Any]
//    {
//        var dictionary = [String:Any]()
//
//        if userId != nil{
//            dictionary["user_id"] = userId
//        }
//        if cartDetail != nil{
//            dictionary["cart_detail"] = cartDetail.toDictionary()
//        }
//        if currency != nil{
//            dictionary["currency"] = currency
//        }
//        if isConfirmationCodeRequiredAtCompleteDelivery != nil{
//            dictionary["is_confirmation_code_required_at_complete_delivery"] = isConfirmationCodeRequiredAtCompleteDelivery
//        }
//        if isConfirmationCodeRequiredAtPickupDelivery != nil{
//            dictionary["is_confirmation_code_required_at_pickup_delivery"] = isConfirmationCodeRequiredAtPickupDelivery
//        }
//        if order != nil{
//            dictionary["order"] = order.toDictionary()
//        }
//        if orderPaymentDetail != nil{
//            dictionary["order_payment_detail"] = OrderPayment.toDictionary()
//        }
//        if providerDetail != nil{
//            dictionary["provider_detail"] = providerDetail
//        }
//        if requestDetail != nil{
//            dictionary["request_detail"] = requestDetail
//        }
//        if userImageUrl != nil{
//            dictionary["user_image_url"] = userImageUrl
//        }
//        return dictionary
//    }

    /**
//    * NSCoding required initializer.
//    * Fills the data from the passed decoder
//    */
//    @objc required init(coder aDecoder: NSCoder)
//    {
//
//         userId = aDecoder.decodeObject(forKey: "user_id") as? String
//         cartDetail = aDecoder.decodeObject(forKey: "cart_detail") as? CartDetailNew
//         currency = aDecoder.decodeObject(forKey: "currency") as? String
//         isConfirmationCodeRequiredAtCompleteDelivery = aDecoder.decodeObject(forKey: "is_confirmation_code_required_at_complete_delivery") as? Bool
//         isConfirmationCodeRequiredAtPickupDelivery = aDecoder.decodeObject(forKey: "is_confirmation_code_required_at_pickup_delivery") as? Bool
//         order = aDecoder.decodeObject(forKey: "order") as? OrderNew
//         orderPaymentDetail = aDecoder.decodeObject(forKey: "order_payment_detail") as? OrderPaymentDetailNew
//         providerDetail = aDecoder.decodeObject(forKey: "provider_detail") as? OrderProviderDetail
//         requestDetail = aDecoder.decodeObject(forKey: "request_detail") as? RequestDetailNew
//         userImageUrl = aDecoder.decodeObject(forKey: "user_image_url") as? String
//
//    }
//
//    /**
//    * NSCoding required method.
//    * Encodes mode properties into the decoder
//    */
//    @objc func encode(with aCoder: NSCoder)
//    {
//
//        if userId != nil{
//            aCoder.encode(userId, forKey: "user_id")
//        }
//        if cartDetail != nil{
//            aCoder.encode(cartDetail, forKey: "cart_detail")
//        }
//        if currency != nil{
//            aCoder.encode(currency, forKey: "currency")
//        }
//        if isConfirmationCodeRequiredAtCompleteDelivery != nil{
//            aCoder.encode(isConfirmationCodeRequiredAtCompleteDelivery, forKey: "is_confirmation_code_required_at_complete_delivery")
//        }
//        if isConfirmationCodeRequiredAtPickupDelivery != nil{
//            aCoder.encode(isConfirmationCodeRequiredAtPickupDelivery, forKey: "is_confirmation_code_required_at_pickup_delivery")
//        }
//        if order != nil{
//            aCoder.encode(order, forKey: "order")
//        }
//        if orderPaymentDetail != nil{
//            aCoder.encode(orderPaymentDetail, forKey: "order_payment_detail")
//        }
//        if providerDetail != nil{
//            aCoder.encode(providerDetail, forKey: "provider_detail")
//        }
//        if requestDetail != nil{
//            aCoder.encode(requestDetail, forKey: "request_detail")
//        }
//        if userImageUrl != nil{
//            aCoder.encode(userImageUrl, forKey: "user_image_url")
//        }
//
//    }

}
