//
//	OrderProviderDetail.swift
//
//	Create by Jaydeep Vyas on 10/8/2017
//	Copyright © 2017 Elluminati. All rights reserved.


import Foundation

class OrderProviderDetail {

    var bearing : Double!
    var countryPhoneCode : String!
    var firstName : String!
    var imageUrl : String!
    var lastName : String!
    var phone : String!
    var providerLocation : [Double]!
    var rate : Double!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        bearing = (dictionary["bearing"] as? Double) ?? 0.0
        countryPhoneCode = (dictionary["country_phone_code"] as? String) ?? ""
        //Storeapp
        //Deliverylist API changes

        if dictionary["first_name"] != nil{
            firstName = (dictionary["first_name"] as? String) ?? ""
        }else if dictionary["name"] != nil{
            firstName = (dictionary["name"] as? String) ?? ""
        }else{
            firstName = ""
        }
        
        
        imageUrl = (dictionary["image_url"] as? String) ?? ""
        lastName = (dictionary["last_name"] as? String) ?? ""
        phone = (dictionary["phone"] as? String) ?? ""
        
      providerLocation = (dictionary["provider_location"] as? [Double]) ?? [0.0,0.0]
        rate = (dictionary["user_rate"] as? Double) ?? 0.0
        
    }

}
