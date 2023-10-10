//
//	DayTime.swift
//
//	Create by Jaydeep Vyas on 6/10/2017
//	Copyright © 2017 Elluminati. All rights reserved.


import Foundation


class DayTime : NSObject{
    
    var storeCloseTime : String!
    var storeOpenTime : String!
    
    var storeCloseTimeMin : Int!
    var storeOpenTimeMin : Int!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]) {
        //		storeCloseTime = dictionary["store_close_time"] as? String
        //		storeOpenTime = dictionary["store_open_time"] as? String
        
        if dictionary["store_close_time"] as? String != nil{
            storeCloseTime = dictionary["store_close_time"] as? String
            storeOpenTime = dictionary["store_open_time"] as? String
        }else{
            storeCloseTime = Utility.minuteToString(min: (dictionary["store_close_time"] as? Int) ?? 0)
            storeOpenTime = Utility.minuteToString(min: (dictionary["store_open_time"] as? Int) ?? 0)
            
            storeOpenTimeMin = dictionary["store_open_time"] as? Int
            storeCloseTimeMin = dictionary["store_close_time"] as? Int
        }
    }
    override init() {
        
    }
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        //		if storeCloseTime != nil{
        //			dictionary["store_close_time"] = storeCloseTime
        //		}
        //		if storeOpenTime != nil{
        //			dictionary["store_open_time"] = storeOpenTime
        //		}
        if storeOpenTimeMin == nil{
            dictionary["store_open_time"] = Utility.stringToMinute(strDate: storeOpenTime)
        }else{
            dictionary["store_open_time"] = storeOpenTimeMin
        }
        if storeCloseTimeMin == nil{
            dictionary["store_close_time"] = Utility.stringToMinute(strDate: storeCloseTime)
        }else{
            dictionary["store_close_time"] = storeCloseTimeMin
        }
        return dictionary
    }
    
    
}
