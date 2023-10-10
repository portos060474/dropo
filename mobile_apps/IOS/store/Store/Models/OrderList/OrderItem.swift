//
//	OrderItem.swift
//
//	Create by Jaydeep Vyas on 10/8/2017
//	Copyright © 2017 Elluminati. All rights reserved.


import Foundation

class OrderItem{

	var details : String!
	var itemId : String!
	var itemName : String!

	var quantity : Int!
	var specifications : [OrderSpecification]!

	var uniqueId : Int!
    var imageURL:[String]!
    var noteForItem:String! = ""
    var productId:String!

    var itemPrice : Double!
    var totalSpecificationPrice : Double!
    var totalItemPrice: Double!
    var tax : Double!
    
    var itemTax :  Double!
    var totalItemTax :  Double!
    var totalSpecificationTax: Double!
    var totalPrice: Double!
    var totalTax: Double!
    var detailLanguages = [String]()
    var nameLanguages = [String]()
    var itemTaxes = [String]()
    var taxDetails : [TaxesDetail]!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		details = (dictionary["details"] as? String) ?? ""
		itemId = (dictionary["item_id"] as? String) ?? (dictionary["_id"] as? String) ?? ""
        //Storeapp
		
		quantity = (dictionary["quantity"] as? Int) ?? 1
		specifications = [OrderSpecification]()
		if let specificationsArray = dictionary["specifications"] as? [[String:Any]]{
			for dic in specificationsArray{
				let value = OrderSpecification(fromDictionary: dic)
				specifications.append(value)
			}
		}
        if let imageURLS  = dictionary["image_url"] as? [String] {
         imageURL = imageURLS
        }
        noteForItem = (dictionary["note_for_item"] as? String) ?? ""
		uniqueId = (dictionary["unique_id"] as? Int) ?? 0
        totalItemPrice = (dictionary["total_item_price"] as? Double)?.roundTo() ?? 0.0
        productId = (dictionary["product_id"] as? String) ?? ""
        
        
        itemPrice = (dictionary["item_price"] as? Double)?.roundTo() ?? 0.0
        tax = ((dictionary["tax"] as? Double)?.roundTo()) ?? 0.0
        itemTax = ((dictionary["item_tax"] as? Double)?.roundTo()) ?? 0.0
        totalItemTax = ((dictionary["total_item_tax"] as? Double)?.roundTo()) ?? 0.0
        totalSpecificationTax =  ((dictionary["total_specification_tax"] as? Double)?.roundTo()) ?? 0.0
        totalItemPrice = (dictionary["total_item_price"] as? Double)?.roundTo() ?? 0.00
        totalPrice = (dictionary["total_price"] as? Double)?.roundTo() ?? 0.00
        totalTax = (dictionary["total_tax"] as? Double)?.roundTo() ?? 0.00
        totalSpecificationPrice = (dictionary["total_specification_price"] as? Double)?.roundTo() ?? 0.00
        
        
        let name : Any = (dictionary["item_name"])  ?? (dictionary["name"]) ?? ""
        //Storeapp

          var arr = [String]()
           if let _ = name as? NSArray {
            for obj in name as! NSArray{
                  if StoreSingleton.shared.isNotNSNull(object: obj as AnyObject){
                      arr.append(obj as! String)
                  }else{
                      arr.append("")
                  }
              }
               nameLanguages.removeAll()
               nameLanguages.append(contentsOf: arr)

                itemName = StoreSingleton.shared.returnStringAccordingtoLanguage(arrStr: arr)
              
              print("Item name : \(itemName!)")
           }else{
            itemName = name as? String
           }
    
                           
        print("nameLanguages \(nameLanguages)")
        print("itemName \(itemName ?? "")")

        
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
                detailLanguages.removeAll()
                detailLanguages.append(contentsOf: arr)

               if dictionary["details"] != nil{
                   details = StoreSingleton.shared.returnStringAccordingtoLanguage(arrStr: arr)
               }
               print("details : \(details!)")
            }else{
                details = dictionary["details"]! as? String
            }
        }else{
            details = ""
        }
                            
         print("detailLanguages \(detailLanguages)")
         print("details \(details)")
        itemTaxes = dictionary["item_taxes"] as? [String] ?? [""]
        taxDetails = [TaxesDetail]()
        if let taxDetailsArray = dictionary["tax_details"] as? [[String:Any]]{
            for dic in taxDetailsArray{
                let value = TaxesDetail(fromDictionary: dic)
                taxDetails.append(value)
            }
        }
	}
    
    
    func toDictionary(isPassArray:Bool) -> [String:Any] {
        var dictionary = [String:Any]()
        
        
        if details != nil{dictionary["details"] = details}
        if itemPrice != nil {dictionary["item_price"] = itemPrice}
        if tax != nil{dictionary["tax"] = tax}
        if itemTax != nil{ dictionary["item_tax"] = itemTax}
        if totalItemTax != nil{dictionary["total_item_tax"] = totalItemTax}
        if totalSpecificationTax != nil{dictionary["total_specification_tax"] = totalSpecificationTax}
        if totalItemPrice != nil{dictionary["total_item_price"] = totalItemPrice   }
        if totalSpecificationPrice != nil{ dictionary["total_specification_price"] = totalSpecificationPrice }
        if totalPrice != nil{ dictionary["total_price"] = totalPrice}
        if totalTax != nil{dictionary["total_tax"] = totalTax}
        if imageURL != nil{ dictionary["image_url"] = imageURL}
        if itemId != nil{dictionary["item_id"] = itemId}
        if itemName != nil{ dictionary["item_name"] = itemName}
        if quantity != nil{ dictionary["quantity"] = quantity}
        if uniqueId != nil{    dictionary["unique_id"] = uniqueId}
        if productId != nil{dictionary["product_id"] = productId}
        if noteForItem != nil{dictionary["note_for_item"] = noteForItem}

        
        
        if specifications != nil {
            var dictionaryElements = [[String:Any]]()
            for specificationsElement in specifications {
                dictionaryElements.append(specificationsElement.toDictionary(isPassArray: isPassArray))
            }
            dictionary["specifications"] = dictionaryElements
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
      
        return dictionary
    }
    
    func getProductJson() -> NSDictionary {
        let dictionary = NSMutableDictionary.init()
        
        dictionary.setValue(uniqueId, forKey: "unique_id")
        
        if specifications != nil {
            var arr = [NSDictionary]()
            for specificationsElement in specifications {
                arr.append(specificationsElement.getProductJson())
            }
            dictionary.setValue(arr, forKey: "specifications")
        }
        
        return dictionary
    }

}
