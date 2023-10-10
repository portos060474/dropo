
import Foundation
 

public class AdItem {
    var id : String!
    var adsFor : Int!
    var adsDetail:String!
    
    var adsType : Int!
    var cityId : String!
    var countryId : String!
    var createdAt : String!
    var expiryDate : String!
    var imageForBanner : String!
    var imageForFullscreen : String!
    var isAdsApproveByAdmin : Bool!
    var isAdsHaveExpiryDate : Bool!
    var isAdsRedirectToStore : Bool!
    var isAdsVisible : Bool!
    var storeId : String!
    var uniqueId : Int!
    var updatedAt : String!
    var langItems : Array<SettingDetailLang>?
    var store_detail : StoreItem?

     init(fromDictionary dictionary: [String:Any]){
        id = (dictionary["_id"] as? String) ?? ""
        adsFor = (dictionary["ads_for"] as? Int) ?? 0
        adsType = (dictionary["ads_type"] as? Int) ?? 0
        cityId = (dictionary["city_id"] as? String) ?? ""
        countryId = (dictionary["country_id"] as? String) ?? ""
        createdAt = (dictionary["created_at"] as? String) ?? ""
        expiryDate = (dictionary["expiry_date"] as? String) ?? ""
        imageForBanner = (dictionary["image_url"] as? String) ?? ""
        imageForFullscreen = (dictionary["image_for_fullscreen"] as? String) ?? ""
        isAdsApproveByAdmin = (dictionary["is_ads_approve_by_admin"] as? Bool) ?? false
        isAdsHaveExpiryDate = (dictionary["is_ads_have_expiry_date"] as? Bool) ?? false
        isAdsRedirectToStore = (dictionary["is_ads_redirect_to_store"] as? Bool) ?? false
        isAdsVisible = (dictionary["is_ads_visible"] as? Bool) ?? false
        storeId = (dictionary["store_id"] as? String) ?? ""
        uniqueId = (dictionary["unique_id"] as? Int) ?? 0
        updatedAt = (dictionary["updated_at"] as? String) ?? ""
        adsDetail = (dictionary["ads_detail"] as? String) ?? ""
        
        if (dictionary["store_detail"] != nil) {

            if isNotNSNull(object: dictionary["store_detail"] as AnyObject){
                 store_detail = StoreItem(dictionary: dictionary["store_detail"] as! NSDictionary)
            }
        }
        
        if (dictionary["languages_supported"] != nil) { langItems = SettingDetailLang.modelsFromDictionaryArray(array: dictionary["languages_supported"] as! NSArray)
        }
    }
}

func isNotNSNull(object:AnyObject) -> Bool {
    return object.classForCoder != NSNull.classForCoder()
}

//func isNotNull(object:AnyObject?) -> Bool {
//    guard let object = object else {
//        return false
//    }
//    return (isNotNSNull(object) && isNotStringNull(object))
//}
//
//func isNotStringNull(object:AnyObject) -> Bool {
//    if let object = object as? String where object.uppercaseString == "NULL" {
//        return false
//    }
//    return true
//}
