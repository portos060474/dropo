//
//  HistoryRequestDetail.swift
//  Edelivery
//
//  Created by Elluminati on 3/30/21.
//  Copyright © 2021 Elluminati. All rights reserved.
//

import Foundation
public class HistoryRequestDetail {
    
    public var provider_detail: ProviderDetail?
    public var provider_location : Array<Double>?
    var destination_addresses: [Address] = []
    public class func modelsFromDictionaryArray(array:NSArray) -> [HistoryRequestDetail] {
        var models:[HistoryRequestDetail] = []
        for item in array {
            models.append(HistoryRequestDetail(dictionary: item as! NSDictionary)!)
        }
        return models
    }


    required public init?(dictionary: NSDictionary) {

       
         if isNotNSNull(object: dictionary["provider_detail"] as AnyObject){
             if (dictionary["provider_detail"] != nil) { provider_detail = ProviderDetail(dictionary: dictionary["provider_detail"] as! NSDictionary) }
         }
        
        if isNotNSNull(object: dictionary["provider_location"] as AnyObject){
                    if (dictionary["provider_location"] != nil) {
                        provider_location = dictionary["provider_location"] as! Array<Double>
                        
            }
        }
        
        if let dict =  dictionary["destination_addresses"] {
            destination_addresses = [Address.init(fromDictionary: ((dict as! Array<Any>)[0] as! [String:Any]) )]
        }
    }

    public init?() {
    }
    public func dictionaryRepresentation() -> NSDictionary {

        let dictionary = NSMutableDictionary()

        
        dictionary.setValue(provider_detail, forKey: "provider_detail")
        dictionary.setValue(provider_location, forKey: "provider_location")
        
        var myDestinationArray:[Any] = []
        for address in self.destination_addresses {
          myDestinationArray.append(address.toDictionary())
        }
        dictionary.setValue(myDestinationArray, forKey: "destination_addresses")
        return dictionary
    }

}
