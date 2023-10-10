

import Foundation
import Alamofire
//import StripeUICore
 

public class Order {
	public var _id : String?
    public var timezone : String?
	public var currency : String!
	public var promo_code : String?
	public var unique_id : Int?
	public var total_order_price : Double?
    public var user_pay_payment: Double?
	public var unique_code : Int?
	public var created_at : String?
	public var order_status : Int?
    public var order_change : Bool?

    public var is_user_show_invoice : Bool?
	public var source_address : String?
	public var destination_address : String?
    var destination_addresses : [Address]?
	public var store_name : String?
	public var store_image : String?
	public var store_country_phone_code : String?
	public var store_phone : String?
    var cartDetail: CartDetail?
    public var provider_first_name : String?
    public var provider_last_name : String?
    public var provider_image : String?
    public var total_time: Double?
    public var delivery_status : Int?
    public var delivery_type : Int?
    public var image_urls: [String] = []
    
    
    //userapp //API changes
    public var request_id : String?
    public var request_unique_id : Int?
    public var store_id : String?
    public var store_detail : StoreItem?
    var storeTaxDetails : [TaxesDetail]!
    public var table_settings_details : Table_settings_details?
    public var schedule_order_start_at : String?
    public var server_time : String?
    public var total : Double?
/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let Order = Order.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Order Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Order] {
        var models:[Order] = []
        for item in array {
            models.append(Order(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let Order = Order(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Order Instance.
*/
	required public init?(dictionary: NSDictionary) {

		_id = dictionary["_id"] as? String
        timezone = dictionary["timezone"] as? String
        user_pay_payment =  (dictionary["user_pay_payment"] as? Double)?.roundTo() ?? 0.00
		currency = (dictionary["currency"] as? String) ?? ""
		promo_code = dictionary["promo_code"] as? String
		unique_id = dictionary["unique_id"] as? Int
        if dictionary["total_order_price"] != nil{
            total_order_price = (dictionary["total_order_price"] as? Double)?.roundTo() ?? 0.00
        }else if dictionary["total"] != nil {
            total_order_price = (dictionary["total"] as? Double)?.roundTo() ?? 0.00
        }else{
            total_order_price = 0.00
        }
		
        order_change = (dictionary["order_change"] as? Bool)
		unique_code = dictionary["unique_code"] as? Int
		created_at = dictionary["created_at"] as? String
		order_status = dictionary["order_status"] as? Int
        delivery_status = (dictionary["delivery_status"] as? Int) ?? 0
		source_address = dictionary["source_address"] as? String
		destination_address = dictionary["destination_address"] as? String
        if let destinationDics = dictionary["destination_addresses"] as? [[String:Any]] {
            var arr = [Address]()
            for obj in destinationDics {
                arr.append(Address(fromDictionary: obj))
            }
            destination_addresses = arr
        }
        
		store_name = dictionary["store_name"] as? String
        //API Changes
        if dictionary["store_image"] != nil{
            store_image = dictionary["store_image"] as? String
        }else if dictionary["store_image_url"] != nil{
            store_image = dictionary["store_image_url"] as? String
        }else{
            store_image = ""
        }
        
		store_country_phone_code = dictionary["store_country_phone_code"] as? String
		store_phone = dictionary["store_phone"] as? String
        total_time = dictionary["total_time"] as? Double
        provider_first_name = dictionary["provider_first_name"] as? String
        provider_last_name = dictionary["provider_last_name"] as? String
         is_user_show_invoice = dictionary["is_user_show_invoice"] as? Bool
        provider_image = dictionary["provider_image"] as? String
        delivery_type = (dictionary["delivery_type"] as? Int) ?? 0
        image_urls = (dictionary["image_url"] as? [String]) ?? []
        if let cartDetailData = dictionary["cart_detail"] as? [String:Any]{
            cartDetail = CartDetail(fromDictionary: cartDetailData)
        }
        request_id = dictionary["request_id"] as? String ?? ""
               request_unique_id = dictionary["request_unique_id"] as? Int ?? 0
               store_id = dictionary["store_id"] as? String ?? ""
         if (dictionary["store_detail"] != nil) {

                   if isNotNSNull(object: dictionary["store_detail"] as AnyObject){
                        store_detail = StoreItem(dictionary: dictionary["store_detail"] as! NSDictionary)
                   }
               }
        
        storeTaxDetails = [TaxesDetail]()
        if let taxDetailsArray = dictionary["store_tax_details"] as? [[String:Any]]{
            for dic in taxDetailsArray{
                let value = TaxesDetail(fromDictionary: dic)
                storeTaxDetails.append(value)
            }
        }
        if (dictionary["table_settings_details"] != nil) { table_settings_details = Table_settings_details(dictionary: dictionary["table_settings_details"] as! NSDictionary) }
        
        schedule_order_start_at = dictionary["schedule_order_start_at"] as? String
        server_time = dictionary["schedule_order_server_start_at"] as? String
        total = dictionary["total"] as? Double
	}

	
    required public init() {
    
    }
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
    
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.timezone, forKey: "timezone")
		dictionary.setValue(self.currency, forKey: "currency")
		dictionary.setValue(self.promo_code, forKey: "promo_code")
		dictionary.setValue(self.unique_id, forKey: "unique_id")
		dictionary.setValue(self.total_order_price, forKey: "total_order_price")
		dictionary.setValue(self.unique_code, forKey: "unique_code")
		dictionary.setValue(self.created_at, forKey: "created_at")
		dictionary.setValue(self.order_status, forKey: "order_status")
		dictionary.setValue(self.source_address, forKey: "source_address")
		dictionary.setValue(self.destination_address, forKey: "destination_address")
		dictionary.setValue(self.store_name, forKey: "store_name")
		dictionary.setValue(self.store_image, forKey: "store_image")
		dictionary.setValue(self.store_country_phone_code, forKey: "store_country_phone_code")
		dictionary.setValue(self.store_phone, forKey: "store_phone")
        dictionary.setValue(self.is_user_show_invoice, forKey: "is_user_show_invoice")
        dictionary.setValue(self.order_change, forKey: "order_change")
        dictionary.setValue(self.table_settings_details?.dictionaryRepresentation(), forKey: "table_settings_details")
        dictionary.setValue(self.schedule_order_start_at, forKey: "schedule_order_start_at")
        dictionary.setValue(self.server_time, forKey: "schedule_order_server_start_at")
        dictionary.setValue(self.total, forKey: "total")
		return dictionary
	}

}


public class Table_settings_details {
    public var _id : String?
    public var is_table_reservation : Bool?
    public var is_table_reservation_with_order : Bool?
    public var is_cancellation_charges_for_with_order : Bool?
    public var is_set_booking_fees : Bool?
    public var is_cancellation_charges_for_without_order : Bool?
    public var booking_fees : Int?
    public var with_order_cancellation_charges : Array<With_order_cancellation_charges>?
    public var without_order_cancellation_charges : Array<Without_order_cancellation_charges>?
    public var table_reservation_time : Int?
    public var user_come_before_time : Int?
    public var reservation_max_days : Int?
    public var reservation_person_min_seat : Int?
    public var reservation_person_max_seat : Int?
    public var booking_time : Array<Booking_time>?
    public var store_id : String?
    public var created_at : String?
    public var updated_at : String?
    public var unique_id : Int?
    public var __v : Int?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let table_settings_details_list = Table_settings_details.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Table_settings_details Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Table_settings_details]
    {
        var models:[Table_settings_details] = []
        for item in array
        {
            models.append(Table_settings_details(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let table_settings_details = Table_settings_details(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Table_settings_details Instance.
*/
    required public init?(dictionary: NSDictionary) {

        _id = dictionary["_id"] as? String
        is_table_reservation = dictionary["is_table_reservation"] as? Bool
        is_table_reservation_with_order = dictionary["is_table_reservation_with_order"] as? Bool
        is_cancellation_charges_for_with_order = dictionary["is_cancellation_charges_for_with_order"] as? Bool
        is_set_booking_fees = dictionary["is_set_booking_fees"] as? Bool
        is_cancellation_charges_for_without_order = dictionary["is_cancellation_charges_for_without_order"] as? Bool
        booking_fees = dictionary["booking_fees"] as? Int
        /*
        if (dictionary["with_order_cancellation_charges"] != nil) {
            with_order_cancellation_charges = (dictionary["with_order_cancellation_charges"] as! NSArray) as? Array<String>
        }*/
        if (dictionary["with_order_cancellation_charges"] != nil) {
            with_order_cancellation_charges = With_order_cancellation_charges.modelsFromDictionaryArray(array: dictionary["with_order_cancellation_charges"] as! NSArray)
            
        }
        
        if (dictionary["without_order_cancellation_charges"] != nil) {
            without_order_cancellation_charges = Without_order_cancellation_charges.modelsFromDictionaryArray(array: dictionary["without_order_cancellation_charges"] as! NSArray)
            
        }
       
        table_reservation_time = dictionary["table_reservation_time"] as? Int
        user_come_before_time = dictionary["user_come_before_time"] as? Int
        reservation_max_days = dictionary["reservation_max_days"] as? Int
        reservation_person_min_seat = dictionary["reservation_person_min_seat"] as? Int
        reservation_person_max_seat = dictionary["reservation_person_max_seat"] as? Int
   
        if (dictionary["booking_time"] != nil) { booking_time = Booking_time.modelsFromDictionaryArray(array:dictionary["booking_time"] as! NSArray) }
        store_id = dictionary["store_id"] as? String
        created_at = dictionary["created_at"] as? String
        updated_at = dictionary["updated_at"] as? String
        unique_id = dictionary["unique_id"] as? Int
        __v = dictionary["__v"] as? Int
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
