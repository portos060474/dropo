//
//	CartDetail.swift
//
//	Create by Elluminati iMac on 13/1/2018
//	Copyright © 2018. All rights reserved.

import Foundation


class CartDetail : NSObject{

	var v : Int!
	var id : String!
	var cartUniqueToken : String!
	var cityId : String!
	var createdAt : String!
	var destinationAddresses : [Address]!
	var orderDetails : [CartProduct]!
	var orderId : String!
	var orderPaymentId : String!
	var pickupAddresses : [Address]!
	var storeId : String!
	var totalItemCount : Int!
	var uniqueId : Int!
	var updatedAt : String!
	var userId : String!
	var userType : Int!
	var userTypeId : String!
    var deliveryType: Int!
    var isTaxIncluded = false
    var isUseItemTax = false
    var storeTaxDetails = [TaxesDetail]()
    var no_of_persons:Int!
    var table_no:Int!
    var booking_type : Int!
    
	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]) {
        deliveryType = (dictionary["delivery_type"] as? Int) ?? 0
		v = dictionary["__v"] as? Int
		id = dictionary["_id"] as? String
		cartUniqueToken = dictionary["cart_unique_token"] as? String
		cityId = dictionary["city_id"] as? String
		createdAt = dictionary["created_at"] as? String
		destinationAddresses = [Address]()
		if let destinationAddressesArray = dictionary["destination_addresses"] as? [[String:Any]]{
			for dic in destinationAddressesArray{
				let value = Address(fromDictionary: dic)
				destinationAddresses.append(value)
			}
		}
		orderDetails = [CartProduct]()
		if let orderDetailsArray = dictionary["order_details"] as? [NSDictionary]{
			for dic in orderDetailsArray{
                let value = CartProduct(dictionary: dic)
                orderDetails.append(value!)
			}
		}
		orderId = dictionary["order_id"] as? String
		orderPaymentId = dictionary["order_payment_id"] as? String
		pickupAddresses = [Address]()
		if let pickupAddressesArray = dictionary["pickup_addresses"] as? [[String:Any]]{
			for dic in pickupAddressesArray{
				let value = Address(fromDictionary: dic)
				pickupAddresses.append(value)
			}
		}
		storeId = dictionary["store_id"] as? String
		totalItemCount = dictionary["total_item_count"] as? Int
		uniqueId = dictionary["unique_id"] as? Int
		updatedAt = dictionary["updated_at"] as? String
		userId = dictionary["user_id"] as? String
		userType = dictionary["user_type"] as? Int
		userTypeId = dictionary["user_type_id"] as? String
        
        if dictionary["is_tax_included"] != nil{
            isTaxIncluded = (dictionary["is_tax_included"] as? Bool ?? false)
        }
        
        if dictionary["is_use_item_tax"] != nil{
            isUseItemTax
                = (dictionary["is_use_item_tax"] as? Bool ?? false)
        }
        
        storeTaxDetails = [TaxesDetail]()
        if let taxDetailsArray = dictionary["store_taxes"] as? [[String:Any]]{
            for dic in taxDetailsArray{
                let value = TaxesDetail(fromDictionary: dic)
                storeTaxDetails.append(value)
            }
        }
        
        no_of_persons = dictionary["no_of_persons"] as? Int ?? 0
        table_no = dictionary["table_no"] as? Int ?? 0
        booking_type = dictionary["booking_type"] as? Int
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if v != nil{
			dictionary["__v"] = v
		}
		if id != nil{
			dictionary["_id"] = id
		}
		if cartUniqueToken != nil{
			dictionary["cart_unique_token"] = cartUniqueToken
		}
		if cityId != nil{
			dictionary["city_id"] = cityId
		}
		if createdAt != nil{
			dictionary["created_at"] = createdAt
		}
		if destinationAddresses != nil{
			var dictionaryElements = [[String:Any]]()
			for destinationAddressesElement in destinationAddresses {
				dictionaryElements.append(destinationAddressesElement.toDictionary())
			}
			dictionary["destination_addresses"] = dictionaryElements
		}
		if orderDetails != nil{
			var dictionaryElements = [[String:Any]]()
			for orderDetailsElement in orderDetails {
                dictionaryElements.append(orderDetailsElement.dictionaryRepresentation() as! [String : Any])
			}
			dictionary["order_details"] = dictionaryElements
		}
		if orderId != nil{
			dictionary["order_id"] = orderId
		}
		if orderPaymentId != nil{
			dictionary["order_payment_id"] = orderPaymentId
		}
		if pickupAddresses != nil{
			var dictionaryElements = [[String:Any]]()
			for pickupAddressesElement in pickupAddresses {
				dictionaryElements.append(pickupAddressesElement.toDictionary())
			}
			dictionary["pickup_addresses"] = dictionaryElements
		}
		if storeId != nil{
			dictionary["store_id"] = storeId
		}
		if totalItemCount != nil{
			dictionary["total_item_count"] = totalItemCount
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
		if userTypeId != nil{
			dictionary["user_type_id"] = userTypeId
		}
        if isTaxIncluded != nil{
            dictionary["is_tax_included"] = isTaxIncluded
        }
        if isUseItemTax != nil{
            dictionary["is_use_item_tax"] = isUseItemTax
        }
        
        if storeTaxDetails != nil{
            var dictionaryElements = [[String:Any]]()
            for taxDetailsElement in storeTaxDetails {
                dictionaryElements.append(taxDetailsElement.toDictionary())
            }
            dictionary["store_taxes"] = dictionaryElements
        }
        
        if booking_type != nil {
            dictionary["booking_type"] = booking_type
        }
		return dictionary
	}
}
