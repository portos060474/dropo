//
//	BankDetail.swift
//
//	Create by Jaydeep Vyas on 24/10/2017
//	Copyright © 2017 Elluminati. All rights reserved.


import Foundation

class BankDetail {
    var v : Int!
    var id : String!
    var accountHolderType : String!
    var accountId : String!
    var accountNumber : String!
    var bankAccountHolderName : String!
    var bankHolderId : String!
    var bankHolderType : String!
    var bankId : String!
    var createdAt : String!
    var routingNumber : String!
    var uniqueId : Int!
    var updatedAt : String!
    var isSelected:Bool!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        v = (dictionary["__v"] as? Int) ?? 0
        id = (dictionary["_id"] as? String) ?? ""
        accountHolderType = (dictionary["account_holder_type"] as? String) ?? ""
        accountId = (dictionary["account_id"] as? String) ?? ""
        accountNumber = (dictionary["account_number"] as? String) ?? ""
        bankAccountHolderName = (dictionary["bank_account_holder_name"] as? String) ?? ""
        bankHolderId = (dictionary["bank_holder_id"] as? String) ?? ""
        bankHolderType = (dictionary["bank_holder_type"] as? String) ?? ""
        bankId = (dictionary["bank_id"] as? String) ?? ""
        createdAt = (dictionary["created_at"] as? String) ?? ""
        routingNumber = (dictionary["routing_number"] as? String) ?? ""
        uniqueId = (dictionary["unique_id"] as? Int) ?? 0
        updatedAt = (dictionary["updated_at"] as? String) ?? ""
        isSelected = (dictionary["is_selected"]as? Bool) ?? false
    }
    
    func toDictionary() -> [String:Any] {
        var dictionary = [String:Any]()
        if v != nil{
            dictionary["__v"] = v
        }
        if id != nil{
            dictionary["_id"] = id
        }
        if accountHolderType != nil{
            dictionary["account_holder_type"] = accountHolderType
        }
        if accountId != nil{
            dictionary["account_id"] = accountId
        }
        if accountNumber != nil{
            dictionary["account_number"] = accountNumber
        }
        if bankAccountHolderName != nil{
            dictionary["bank_account_holder_name"] = bankAccountHolderName
        }
        if bankHolderId != nil{
            dictionary["bank_holder_id"] = bankHolderId
        }
        if bankHolderType != nil{
            dictionary["bank_holder_type"] = bankHolderType
        }
        if bankId != nil{
            dictionary["bank_id"] = bankId
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if routingNumber != nil{
            dictionary["routing_number"] = routingNumber
        }
        if uniqueId != nil{
            dictionary["unique_id"] = uniqueId
        }
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        dictionary["isSelected"] = isSelected
        return dictionary
    }
}
