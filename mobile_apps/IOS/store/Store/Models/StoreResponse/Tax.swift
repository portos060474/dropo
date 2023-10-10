//
//	Taxe.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class TaxesDetail {

    var v : Int!
    var id : String!
    var countryId : String!
    var createdAt : String!
    var isTaxVisible : Bool!
    var tax : Int!
    var taxName : [String]!
    var updatedAt : String!
    var isTaxSelected : Bool
    var tax_amount : Int!

    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        v = dictionary["__v"] as? Int
        id = dictionary["_id"] as? String
        countryId = dictionary["country_id"] as? String
        createdAt = dictionary["created_at"] as? String
        isTaxVisible = dictionary["is_tax_visible"] as? Bool
        tax = dictionary["tax"] as? Int
        taxName = dictionary["tax_name"] as? [String]
        updatedAt = dictionary["updated_at"] as? String
        isTaxSelected = false
        if dictionary["tax_amount"] != nil{
            tax_amount = dictionary["tax_amount"] as? Int
        }else{
            tax_amount = 0
        }
        
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
        if countryId != nil{
            dictionary["country_id"] = countryId
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if isTaxVisible != nil{
            dictionary["is_tax_visible"] = isTaxVisible
        }
        if tax != nil{
            dictionary["tax"] = tax
        }
        if taxName != nil{
            dictionary["tax_name"] = taxName
        }
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        
        if tax_amount != nil{
            dictionary["tax_amount"] = tax_amount
        }
        return dictionary
    }

    

}
