/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class StoreData {
	public var _id : String?
	public var is_table_reservation : Bool?
	public var is_table_reservation_with_order : Bool?
	public var is_cancellation_charges_for_with_order : Bool?
	public var is_set_booking_fees : Bool?
	public var is_cancellation_charges_for_without_order : Bool?
	public var booking_fees : Double?
	public var with_order_cancellation_charges : Array<With_order_cancellation_charges>?
	public var without_order_cancellation_charges : Array<Without_order_cancellation_charges>?
	public var table_reservation_time : Int?
	public var user_come_before_time : Int?
	public var reservation_max_days : Int?
	public var reservation_person_min_seat : Int?
	public var reservation_person_max_seat : Int?
    var booking_time : Array<StoreTime>?
	public var store_id : String?
	public var created_at : String?
	public var updated_at : String?
	public var unique_id : Int?
	public var __v : Int?
	public var table_list : Array<Table_list>?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let data_list = Data.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Data Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [StoreData]
    {
        var models:[StoreData] = []
        for item in array
        {
            models.append(StoreData(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let data = Data(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Data Instance.
*/
	required public init?(dictionary: NSDictionary) {

		_id = dictionary["_id"] as? String
		is_table_reservation = dictionary["is_table_reservation"] as? Bool
		is_table_reservation_with_order = dictionary["is_table_reservation_with_order"] as? Bool
		is_cancellation_charges_for_with_order = dictionary["is_cancellation_charges_for_with_order"] as? Bool
		is_set_booking_fees = dictionary["is_set_booking_fees"] as? Bool
		is_cancellation_charges_for_without_order = dictionary["is_cancellation_charges_for_without_order"] as? Bool
        booking_fees = dictionary["booking_fees"] as? Double ?? 0.0
        if (dictionary["with_order_cancellation_charges"] != nil) { with_order_cancellation_charges = With_order_cancellation_charges.modelsFromDictionaryArray(array: dictionary["with_order_cancellation_charges"] as! NSArray) }
        if (dictionary["without_order_cancellation_charges"] != nil) { without_order_cancellation_charges = Without_order_cancellation_charges.modelsFromDictionaryArray(array:dictionary["without_order_cancellation_charges"] as! NSArray) }
		table_reservation_time = dictionary["table_reservation_time"] as? Int
		user_come_before_time = dictionary["user_come_before_time"] as? Int
		reservation_max_days = dictionary["reservation_max_days"] as? Int
		reservation_person_min_seat = dictionary["reservation_person_min_seat"] as? Int
		reservation_person_max_seat = dictionary["reservation_person_max_seat"] as? Int
        if (dictionary["booking_time"] != nil) { booking_time = StoreTime.modelsFromDictionaryArray(array:dictionary["booking_time"] as! NSArray) }
		store_id = dictionary["store_id"] as? String
		created_at = dictionary["created_at"] as? String
		updated_at = dictionary["updated_at"] as? String
		unique_id = dictionary["unique_id"] as? Int
		__v = dictionary["__v"] as? Int
        if (dictionary["table_list"] != nil) { table_list = Table_list.modelsFromDictionaryArray(array:dictionary["table_list"] as! NSArray) }
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self._id, forKey: "_id")
		dictionary.setValue(self.is_table_reservation, forKey: "is_table_reservation")
		dictionary.setValue(self.is_table_reservation_with_order, forKey: "is_table_reservation_with_order")
		dictionary.setValue(self.is_cancellation_charges_for_with_order, forKey: "is_cancellation_charges_for_with_order")
		dictionary.setValue(self.is_set_booking_fees, forKey: "is_set_booking_fees")
		dictionary.setValue(self.is_cancellation_charges_for_without_order, forKey: "is_cancellation_charges_for_without_order")
		dictionary.setValue(self.booking_fees, forKey: "booking_fees")
		dictionary.setValue(self.table_reservation_time, forKey: "table_reservation_time")
		dictionary.setValue(self.user_come_before_time, forKey: "user_come_before_time")
		dictionary.setValue(self.reservation_max_days, forKey: "reservation_max_days")
		dictionary.setValue(self.reservation_person_min_seat, forKey: "reservation_person_min_seat")
		dictionary.setValue(self.reservation_person_max_seat, forKey: "reservation_person_max_seat")
		dictionary.setValue(self.store_id, forKey: "store_id")
		dictionary.setValue(self.created_at, forKey: "created_at")
		dictionary.setValue(self.updated_at, forKey: "updated_at")
		dictionary.setValue(self.unique_id, forKey: "unique_id")
		dictionary.setValue(self.__v, forKey: "__v")

		return dictionary
	}

}
