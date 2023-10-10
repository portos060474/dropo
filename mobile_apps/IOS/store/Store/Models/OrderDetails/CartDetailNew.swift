//
//	CartDetail.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class CartDetailNew {

	var v : Int!
	var id : String!
	var cartUniqueToken : String!
	var cityId : String!
	var createdAt : String!
	var deliveryType : Int!
	var destinationAddresses : [Address]!
	var language : Int!
	var orderDetails : [OrderDetail]!
	var orderId : String!
	var orderPaymentId : String!
	var pickupAddresses : [Address]!
	var storeId : String!
	var totalCartPrice : Int!
	var totalItemCount : Int!
	var totalItemTax : Int!
	var uniqueId : Int!
	var updatedAt : String!
	var userId : String!
	var userType : Int!
	var userTypeId : String!
    var isTaxInlcuded : Bool!
    var isUseItemTax : Bool!
    var storeTaxDetails = [TaxesDetail]()
    var delivery_type : Int!
    var no_of_persons : Int!
    var table_no : Int!
    var booking_type : Int!

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		v = dictionary["__v"] as? Int
		id = dictionary["_id"] as? String
		cartUniqueToken = dictionary["cart_unique_token"] as? String
		cityId = dictionary["city_id"] as? String
		createdAt = dictionary["created_at"] as? String
		deliveryType = dictionary["delivery_type"] as? Int
		destinationAddresses = [Address]()
		if let destinationAddressesArray = dictionary["destination_addresses"] as? [[String:Any]]{
			for dic in destinationAddressesArray{
				let value = Address(fromDictionary: dic)
				destinationAddresses.append(value)
			}
		}
		language = dictionary["language"] as? Int
		orderDetails = [OrderDetail]()
		if let orderDetailsArray = dictionary["order_details"] as? [[String:Any]]{
			for dic in orderDetailsArray{
				let value = OrderDetail(fromDictionary: dic)
				orderDetails.append(value)
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
		totalCartPrice = dictionary["total_cart_price"] as? Int
		totalItemCount = dictionary["total_item_count"] as? Int
		totalItemTax = dictionary["total_item_tax"] as? Int ?? 0
		uniqueId = dictionary["unique_id"] as? Int
		updatedAt = dictionary["updated_at"] as? String
		userId = dictionary["user_id"] as? String
		userType = dictionary["user_type"] as? Int
		userTypeId = dictionary["user_type_id"] as? String
        
        isTaxInlcuded = dictionary["is_tax_included"] as? Bool
        isUseItemTax = dictionary["is_use_item_tax"] as? Bool
        
        storeTaxDetails = [TaxesDetail]()
        if let taxDetailsArray = dictionary["store_taxes"] as? [[String:Any]]{
            for dic in taxDetailsArray{
                let value = TaxesDetail(fromDictionary: dic)
                storeTaxDetails.append(value)
            }
        }
        
        delivery_type = dictionary["delivery_type"] as? Int
        no_of_persons = dictionary["no_of_persons"] as? Int
        table_no = dictionary["table_no"] as? Int
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
		if deliveryType != nil{
			dictionary["delivery_type"] = deliveryType
		}
		if destinationAddresses != nil{
			var dictionaryElements = [[String:Any]]()
			for destinationAddressesElement in destinationAddresses {
				dictionaryElements.append(destinationAddressesElement.toDictionary())
			}
			dictionary["destination_addresses"] = dictionaryElements
		}
		if language != nil{
			dictionary["language"] = language
		}
		if orderDetails != nil{
			var dictionaryElements = [[String:Any]]()
			for orderDetailsElement in orderDetails {
                dictionaryElements.append(orderDetailsElement.toDictionary(isPassArray: true))
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
		if totalCartPrice != nil{
			dictionary["total_cart_price"] = totalCartPrice
		}
		if totalItemCount != nil{
			dictionary["total_item_count"] = totalItemCount
		}
		if totalItemTax != nil{
			dictionary["total_item_tax"] = totalItemTax
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
        if isTaxInlcuded != nil{
            dictionary["is_tax_included"] = isTaxInlcuded
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

        if delivery_type != nil {
            dictionary["delivery_type"] = userType
        }
        if no_of_persons != nil {
            dictionary["no_of_persons"] = no_of_persons
        }
        if table_no != nil {
            dictionary["table_no"] = table_no
        }
        if booking_type != nil {
            dictionary["booking_type"] = booking_type
        }
		return dictionary
	}
}
