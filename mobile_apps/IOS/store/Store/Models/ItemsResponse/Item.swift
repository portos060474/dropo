//
//	Item.swift
//
//	Create by Jaydeep Vyas on 1/8/2017
//	Copyright © 2017 Elluminati. All rights reserved.

import Foundation


class Item : NSObject{
    
    var v : Int!
    var id : String!
    var createdAt : String!
    var details : String!
    var imageUrl : [String]!
    var instruction : String!
    var isItemInStock : Bool!
    var isVisibleInStore : Bool!
    var itemDiscountText : String!
    var name : String!
    var noOfOrder : Int!
    var price : Double!
    var productId : String!
    var specifications : [ItemSpecification]!
    var specificationsUniqueIdCount : Int!
    var storeId : String!
    var totalItemPrice : Double!
    var totalPrice : Double!
    var totalSpecificationPrice : Double!
    var uniqueId : Int!
    var updatedAt : String!
    var itemPriceWithoutOffer:Double!
    var offerMessageOrPercentage:String!
    var tax:Double!
    //    var nameLanguages:[String:String] = [:]
    var nameLanguages = [String]()
    //    var detailsLanguage : [String:String] = [:]
    var detailsLanguage = [String]()
    var sequence_number : Int!
    var itemTaxes = [String]()
    var taxDetails : [TaxesDetail]!
    var tax_applied:Double!

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    override init()
    {
    }
    init(fromDictionary dictionary: [String:Any]){
        v = dictionary["__v"] as? Int
        tax = (dictionary["tax"] as? Double) ?? 0.0
        tax_applied = (dictionary["tax_applied"] as? Double) ?? 0.0

        //itemTax = (dictionary["item_tax"] as? Double) ?? 0.0
        id = dictionary["_id"] as? String
        createdAt = dictionary["created_at"] as? String
        details = dictionary["details"] as? String
        
        imageUrl = dictionary["image_url"] as? [String]
        instruction = dictionary["instruction"] as? String
        isItemInStock = dictionary["is_item_in_stock"] as? Bool
        isVisibleInStore = dictionary["is_visible_in_store"] as? Bool
        itemDiscountText = dictionary["item_discount_text"] as? String
        //name = dictionary["name"] as? String
        noOfOrder = dictionary["no_of_order"] as? Int
        price = (dictionary["price"] as? Double)?.roundTo() ?? 0.0
        productId = dictionary["product_id"] as? String
        specifications = [ItemSpecification]()
        if let specificationsArray = dictionary["specifications"] as? [[String:Any]]{
            for dic in specificationsArray{
                let value = ItemSpecification(fromDictionary: dic)
                specifications.append(value)
            }
        }
        
        itemTaxes = dictionary["item_taxes"] as? [String] ?? [""]
        
        //        nameLanguages = (dictionary["name"] as? [String : String]) ?? [:]
        
        //        if !(nameLanguages.isEmpty)
        //        {
        //            if (nameLanguages[defaultLanguage] ?? "").count > 0
        //            {
        //               // name = (nameLanguages[defaultLanguage]) ?? ""
        //            }
        //            if (nameLanguages[selectedLanguage] ?? "").count > 0
        //            {
        //               // name = (nameLanguages[selectedLanguage] ) ?? ""
        //            }
        //        } else {
        //           // name = ""
        //        }
        sequence_number = dictionary["sequence_number"] as? Int ?? 0
        print("sequence_number : \(sequence_number!)")
        
        
        if dictionary["name"] != nil{
            print("Item : \(dictionary["name"]!)")
            
            var arr = [String]()
            if let _ = dictionary["name"] as? NSArray {
                for obj in dictionary["name"]! as! NSArray{
                    if StoreSingleton.shared.isNotNSNull(object: obj as AnyObject){
                        arr.append(obj as! String)
                    }else{
                        arr.append("")
                    }
                }
                nameLanguages.removeAll()
                nameLanguages.append(contentsOf: arr)
                
                if dictionary["name"] != nil{
                    name = StoreSingleton.shared.returnStringAccordingtoLanguage(arrStr: arr)
                }
                print("Item name : \(name!)")
            }else{
                name = dictionary["name"]! as? String
            }
        }else{
            name = ""
        }
        
        print("nameLanguages \(nameLanguages)")
        
        if dictionary["details"] != nil{
            print("Item : \(dictionary["details"]!)")
            
            var arr = [String]()
            if let _ = dictionary["details"] as? NSArray {
                for obj in dictionary["details"]! as! NSArray{
                    if StoreSingleton.shared.isNotNSNull(object: obj as AnyObject){
                        arr.append(obj as! String)
                    }else{
                        arr.append("")
                    }
                }
                
                detailsLanguage.removeAll()
                detailsLanguage.append(contentsOf: arr)
                
                if dictionary["details"] != nil{
                    details = StoreSingleton.shared.returnStringAccordingtoLanguage(arrStr: arr)
                }
                print("Item details : \(details!)")
            }else{
                details = dictionary["details"]! as? String
            }
        }else{
            details = ""
        }
        
        print("detailsLanguage \(detailsLanguage)")
        
        
        //        detailsLanguage = (dictionary["details"] as? [String : String]) ?? [:]
        //
        //        if !(detailsLanguage.isEmpty)
        //        {
        //            if (detailsLanguage[defaultLanguage] ?? "").count > 0
        //            {
        //                details = (detailsLanguage[defaultLanguage] as? String) ?? ""
        //            }
        //            if (detailsLanguage[selectedLanguage]  ?? "").count > 0
        //            {
        //                details = (detailsLanguage[selectedLanguage] as? String) ?? ""
        //            }
        //        } else {
        //            details = ""
        //        }
        
        //Janki
        //            if dictionary["details"] != nil{
        //                detailsLanguage = ((dictionary["details"] as? [String])!)
        //                if !(detailsLanguage.isEmpty) {
        //                    if detailsLanguage.count > 0
        //                    {
        //                        if detailsLanguage.count-1 == storeLanguageInd{
        //                            details = (detailsLanguage[storeLanguageInd])
        //                        }else{
        //                            details = (detailsLanguage[0])
        //                        }
        //                    }
        //                }
        //            }else {
        //                details = ""
        //            }
        
        itemPriceWithoutOffer = (dictionary["item_price_without_offer"] as? Double)?.roundTo() ?? 0.0
        specificationsUniqueIdCount = dictionary["specifications_unique_id_count"] as? Int
        storeId = dictionary["store_id"] as? String
        totalItemPrice = (dictionary["total_item_price"] as? Double)?.roundTo() ?? 0.0
        totalPrice = (dictionary["total_price"] as? Double)?.roundTo() ?? 0.0
        totalSpecificationPrice = (dictionary["total_specification_price"] as? Double)?.roundTo() ?? 0.0
        uniqueId = (dictionary["unique_id"] as? Int) ?? 0
        updatedAt = dictionary["updated_at"] as? String
        offerMessageOrPercentage = (dictionary["offer_message_or_percentage"] as? String) ?? ""
        
        
        taxDetails = [TaxesDetail]()
        if let taxDetailsArray = dictionary["tax_details"] as? [[String:Any]]{
            for dic in taxDetailsArray{
                let value = TaxesDetail(fromDictionary: dic)
                taxDetails.append(value)
            }
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any] {
        var dictionary = [String:Any]()
        
//        if tax != nil{
//            dictionary["tax"] = tax
//        }
        
        if v != nil{
            dictionary["__v"] = v
        }
        if id != nil{
            dictionary["_id"] = id
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        //Storeapp
        if sequence_number != nil{
            dictionary["sequence_number"] = sequence_number
        }
        //Storeapp
        if details != nil{
            dictionary["details"] = detailsLanguage
        }
        //        if details != nil{
        //            dictionary["details"] = details
        //        }
        if imageUrl != nil{
            dictionary["image_url"] = imageUrl
        }
        if instruction != nil{
            dictionary["instruction"] = instruction
        }
        if isItemInStock != nil{
            dictionary["is_item_in_stock"] = isItemInStock
        }
        
        if isVisibleInStore != nil{
            dictionary["is_visible_in_store"] = isVisibleInStore
        }
        if itemDiscountText != nil{
            dictionary["item_discount_text"] = itemDiscountText
        }
        //Storeapp
        if nameLanguages != nil{
            dictionary["name"] = nameLanguages
        }
        //        if name != nil{
        //            dictionary["name"] = name
        //        }
        if noOfOrder != nil{
            dictionary["no_of_order"] = noOfOrder
        }
        if price != nil{
            dictionary["price"] = price
        }
        if productId != nil{
            dictionary["product_id"] = productId
        }
        if specifications != nil{
            var dictionaryElements = [[String:Any]]()
            for specificationsElement in specifications {
                dictionaryElements.append(specificationsElement.toDictionary())
            }
            dictionary["specifications"] = dictionaryElements
        }
        if specificationsUniqueIdCount != nil{
            dictionary["specifications_unique_id_count"] = specificationsUniqueIdCount
        }
        if storeId != nil{
            dictionary["store_id"] = storeId
        }
        if totalItemPrice != nil{
            dictionary["total_item_price"] = totalItemPrice
        }
        if totalPrice != nil{
            dictionary["total_price"] = totalPrice
        }
        if totalSpecificationPrice != nil{
            dictionary["total_specification_price"] = totalSpecificationPrice
        }
        if uniqueId != nil{
            dictionary["unique_id"] = uniqueId
        }
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        if offerMessageOrPercentage != nil {
            dictionary["offer_message_or_percentage"] = offerMessageOrPercentage
        }
        if itemPriceWithoutOffer != nil {
            dictionary["item_price_without_offer"] = itemPriceWithoutOffer
        }
        if itemTaxes != nil{
            dictionary["item_taxes"] = itemTaxes
        }
        
        if taxDetails != nil{
            var dictionaryElements = [[String:Any]]()
            for taxDetailsElement in taxDetails {
                dictionaryElements.append(taxDetailsElement.toDictionary())
            }
            dictionary["tax_details"] = dictionaryElements
        }
        if tax_applied != nil{
            dictionary["tax_applied"] = tax_applied
        }
        return dictionary
    }
    
    
    
    
}
