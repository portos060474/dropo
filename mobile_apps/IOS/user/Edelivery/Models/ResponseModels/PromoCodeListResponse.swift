//
//  PromoCodeListResponse.swift
//  Edelivery
//
//  Created by Elluminati on 4/6/21.
//  Copyright © 2021 Elluminati. All rights reserved.
//

import Foundation
public class PromoCodeListResponse {
    public var success : Bool = false
    public var message : Int?
    public var promoCodeList:[PromoCodeItem] = []
    public var isPromoAvailable: Bool?
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [PromoCodeListResponse] {
        var models:[PromoCodeListResponse] = []
        for item in array {
            models.append(PromoCodeListResponse(dictionary: item as! NSDictionary)!)
        }
        return models
    }

    required public init?(dictionary: NSDictionary) {
        success = (dictionary["success"] as? Bool)!
        message = dictionary["message"] as? Int
        isPromoAvailable = dictionary["is_promo_availabel"] as? Bool
        if let promoCodeArray =  dictionary[ "promo_codes"] as? [[String:Any]] {
            
            for item in promoCodeArray {
                
                let promoCodeItem:PromoCodeItem  = PromoCodeItem.init(fromDictionary: item)
                  self.promoCodeList.append(promoCodeItem)
            }
        }
    }

    public func dictionaryRepresentation() -> NSDictionary {

        let dictionary = NSMutableDictionary()

        dictionary.setValue(self.success, forKey: "success")
        dictionary.setValue(self.message, forKey: "message")
        dictionary.setValue(self.isPromoAvailable, forKey: "is_promo_availabel")

        return dictionary
    }

}
