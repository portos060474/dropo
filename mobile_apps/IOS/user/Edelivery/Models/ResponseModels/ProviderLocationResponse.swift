//
//  ProviderLocationResponse.swift
//  Edelivery
//
//  Created by Jaydeep on 13/09/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation

class ProviderLocationResponse {
    
    var bearing : Int!
    var mapPinImageUrl : String!
    var message : Int!
    var providerLocation : [Double]!
    var success : Bool!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        bearing = dictionary["bearing"] as? Int
        mapPinImageUrl = dictionary["map_pin_image_url"] as? String
        message = dictionary["message"] as? Int
        providerLocation = dictionary["provider_location"] as? [Double]
        success = dictionary["success"] as? Bool
    }
    
}
