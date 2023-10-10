//
//    Request.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class Requests : NSObject, NSCoding{

    var id : String!
    var deliveryStatus : Int!
    var destinationAddresses : [Address]!
    var isPaymentModeCash : Bool!
    var orderId : String!
    var orderUniqueId : Int!
    var providerTypeId : Int!
    var total : Double!
    var userDetail : CartUserDetail!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        id = dictionary["_id"] as? String
        deliveryStatus = dictionary["delivery_status"] as? Int
        destinationAddresses = [Address]()
        if let destinationAddressesArray = dictionary["destination_addresses"] as? [[String:Any]]{
            for dic in destinationAddressesArray{
                let value = Address(fromDictionary: dic)
                destinationAddresses.append(value)
            }
        }
        isPaymentModeCash = dictionary["is_payment_mode_cash"] as? Bool ?? false
        orderId = dictionary["order_id"] as? String
        orderUniqueId = dictionary["order_unique_id"] as? Int ?? 0
        providerTypeId = dictionary["provider_type_id"] as? Int ?? 0
        total = dictionary["total"] as? Double ?? 0.0
        if let userDetailData = dictionary["user_detail"] as? [String:Any]{
            userDetail = CartUserDetail(fromDictionary: userDetailData)
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if id != nil{
            dictionary["_id"] = id
        }
        if deliveryStatus != nil{
            dictionary["delivery_status"] = deliveryStatus
        }
        if destinationAddresses != nil{
            var dictionaryElements = [[String:Any]]()
            for destinationAddressesElement in destinationAddresses {
                dictionaryElements.append(destinationAddressesElement.toDictionary())
            }
            dictionary["destination_addresses"] = dictionaryElements
        }
        if isPaymentModeCash != nil{
            dictionary["is_payment_mode_cash"] = isPaymentModeCash
        }
        if orderId != nil{
            dictionary["order_id"] = orderId
        }
        if orderUniqueId != nil{
            dictionary["order_unique_id"] = orderUniqueId
        }
        if providerTypeId != nil{
            dictionary["provider_type_id"] = providerTypeId
        }
        if total != nil{
            dictionary["total"] = total
        }
        if userDetail != nil{
            dictionary["user_detail"] = userDetail.toDictionary()
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         id = aDecoder.decodeObject(forKey: "_id") as? String
         deliveryStatus = aDecoder.decodeObject(forKey: "delivery_status") as? Int
         destinationAddresses = aDecoder.decodeObject(forKey :"destination_addresses") as? [Address]
         isPaymentModeCash = aDecoder.decodeObject(forKey: "is_payment_mode_cash") as? Bool
         orderId = aDecoder.decodeObject(forKey: "order_id") as? String
         orderUniqueId = aDecoder.decodeObject(forKey: "order_unique_id") as? Int
         providerTypeId = aDecoder.decodeObject(forKey: "provider_type_id") as? Int
         total = aDecoder.decodeObject(forKey: "total") as? Double 
         userDetail = aDecoder.decodeObject(forKey: "user_detail") as? CartUserDetail

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
    {
        if id != nil{
            aCoder.encode(id, forKey: "_id")
        }
        if deliveryStatus != nil{
            aCoder.encode(deliveryStatus, forKey: "delivery_status")
        }
        if destinationAddresses != nil{
            aCoder.encode(destinationAddresses, forKey: "destination_addresses")
        }
        if isPaymentModeCash != nil{
            aCoder.encode(isPaymentModeCash, forKey: "is_payment_mode_cash")
        }
        if orderId != nil{
            aCoder.encode(orderId, forKey: "order_id")
        }
        if orderUniqueId != nil{
            aCoder.encode(orderUniqueId, forKey: "order_unique_id")
        }
        if providerTypeId != nil{
            aCoder.encode(providerTypeId, forKey: "provider_type_id")
        }
        if total != nil{
            aCoder.encode(total, forKey: "total")
        }
        if userDetail != nil{
            aCoder.encode(userDetail, forKey: "user_detail")
        }

    }

}
