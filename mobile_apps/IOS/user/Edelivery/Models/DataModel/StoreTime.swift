
import Foundation
 
/* For support, please feel free to contact me at  */

class StoreTime : NSObject {
    
    var is_booking_open : Bool!
    var is_booking_open_full_time : Bool!

    var day : Int!
    var dayTime : [DayTime]!
    var isStoreOpen : Bool!
    var isStoreOpenFullTime : Bool!
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [StoreTime] {
        var models:[StoreTime] = []
        for item in array {
            models.append(StoreTime.init(fromDictionary: item as! [String:Any]))
        }
        return models
    }
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        day = (dictionary["day"] as? Int) ?? 0
        dayTime = [DayTime]()
        if let dayTimeArray = dictionary["day_time"] as? [[String:Any]]{
            for dic in dayTimeArray{
                let value = DayTime(fromDictionary: dic)
                dayTime.append(value)
            }
        }
        isStoreOpen = (dictionary["is_store_open"] as? Bool) ?? false
        isStoreOpenFullTime = (dictionary["is_store_open_full_time"] as? Bool) ?? false

        is_booking_open = dictionary["is_booking_open"] as? Bool
        is_booking_open_full_time = dictionary["is_booking_open_full_time"] as? Bool
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any] {
        var dictionary = [String:Any]()
        if day != nil{
            dictionary["day"] = day
        }
        if dayTime != nil{
            var dictionaryElements = [[String:Any]]()
            for dayTimeElement in dayTime {
                dictionaryElements.append(dayTimeElement.toDictionary())
            }
            dictionary["day_time"] = dictionaryElements
        }
        if isStoreOpen != nil{
            dictionary["is_store_open"] = isStoreOpen
        }
        if isStoreOpenFullTime != nil{
            dictionary["is_store_open_full_time"] = isStoreOpenFullTime
        }
        return dictionary
    }
}

class DayTime : NSObject{
    
    var storeCloseTime : String!
    var storeOpenTime : String!
    
    var storeCloseTimeMin : Int!
    var storeOpenTimeMin : Int!
    
    var booking_close_time:String!
    var booking_open_time:String!
    var booking_close_time_min:Int!
    var booking_open_time_min:Int!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]) {
        //        storeCloseTime = dictionary["store_close_time"] as? String
        //        storeOpenTime = dictionary["store_open_time"] as? String
        
        if dictionary["store_close_time"] as? String != nil{
            storeCloseTime = dictionary["store_close_time"] as? String
            storeOpenTime = dictionary["store_open_time"] as? String
        }else{
            storeCloseTime = Utility.minuteToString(min: (dictionary["store_close_time"] as? Int) ?? 0)
            storeOpenTime = Utility.minuteToString(min: (dictionary["store_open_time"] as? Int) ?? 0)
            
            storeOpenTimeMin = dictionary["store_open_time"] as? Int
            storeCloseTimeMin = dictionary["store_close_time"] as? Int
            
            booking_close_time_min = dictionary["booking_close_time"] as? Int ?? 0
            booking_open_time_min = dictionary["booking_open_time"] as? Int ?? 0
            
            booking_close_time = Utility.minuteToString(min: booking_close_time_min)
            booking_open_time = Utility.minuteToString(min: booking_open_time_min)
            
            
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
        //        if storeCloseTime != nil{
        //            dictionary["store_close_time"] = storeCloseTime
        //        }
        //        if storeOpenTime != nil{
        //            dictionary["store_open_time"] = storeOpenTime
        //        }
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
