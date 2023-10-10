//
//  PromoCodeList.swift
//  Edelivery
//
//  Created by Elluminati on 4/6/21.
//  Copyright © 2021 Elluminati. All rights reserved.
//

import Foundation
public class PromoCodeItem {
    var id : String!
    var adsFor : Int!
    var imageUrl:String!
    var isActive : Bool!
    var isApproved : Bool!
    var promoCodeDetails : String!
    var promoCodeName : String!
    var promoApplyOn: [String]?
    var promoFor : String!
    
    

     init(fromDictionary dictionary: [String:Any]){
        id = (dictionary["_id"] as? String) ?? ""
        imageUrl = (dictionary["image_url"] as? String) ?? ""
        isActive = (dictionary["is_active"] as? Bool) ?? false
        isApproved = (dictionary["is_approved"] as? Bool) ?? false
        promoCodeDetails = (dictionary["promo_details"] as? String) ?? ""
        promoCodeName = (dictionary["promo_code_name"] as? String) ?? ""
        promoFor = (dictionary["promo_for"] as? String) ?? ""
        promoApplyOn = (dictionary["promo_apply_on"] as? [String]) ?? []
    }
}
