
import Foundation


public class HistoryOrderList {
	public var _id : String?
	public var unique_id : Int?
	public var updated_at : String?
	public var order_payment_id : String?
	public var order_type : Int?
	public var invoice_number : Int?
	public var store_id : String?
	public var user_type : Int?
	public var user_type_id : String?
	public var provider_type : Int?
	public var provider_type_id : String?
	public var user_id : String?
	public var provider_id : String?
	public var current_provider : String?
	public var service_id : String?
	public var promo_id : String?
	public var promo_code : String?
	public var unique_code : Int?
	public var currency : String?
	public var admin_currency : String?
	public var order_status : Int?
	public var order_status_by : String?
	public var order_status_id : Int?
	public var total_order_price : Double?
	public var created_at : String?
	public var completed_at : String?
	public var cancelled_at : String?
	public var delivered_at : String?
	public var start_for_delivery_at : String?
	public var arrived_on_store_at : String?
	public var start_for_pickup_at : String?
	public var accepted_at : String?
	public var store_order_created_at : String?
	public var picked_order_at : String?
	public var store_accepted_at : String?
	public var order_ready_at : String?
	public var start_preparing_order_at : String?
	public var schedule_order_server_start_at : String?
	public var schedule_order_start_at : String?
	public var is_schedule_order : Bool?
    
	public var provider_previous_location : Array<String>?
	public var provider_location : Array<String>?
	public var isAllowContactlessDelivery = false
	public var providers_id_that_rejected_order : Array<String>?
	public var store_notify : Int?
    public var __v : Int?
    //Userapp //API changes
	//public var orderPayment : OrderPayment?
//    var cartDetail:CartDetail?

    public var is_user_rated_to_store:Bool = false
    public var is_user_rated_to_provider:Bool = false
    
    public var user_rating_to_provider:Float?
    public var user_rating_to_store:Float?
    
    public var image_url: [String] = []
    public var arrDatetime:[DeliveryStatusDetails] = []
    var provider_detail : ProviderDetail?
    var deliveryType:Int!
    var destination_addresses : [Address]?
    var date_time : [DateTime] = []

    public class func modelsFromDictionaryArray(array:NSArray) -> [HistoryOrderList] {
        var models:[HistoryOrderList] = []
        for item in array {
            models.append(HistoryOrderList(dictionary: item as! NSDictionary)!)
        }
        return models
    }

    public init() {
    }

    required public init?(dictionary: NSDictionary) {
        isAllowContactlessDelivery = dictionary["is_allow_contactless_delivery"] as? Bool ?? false
        image_url = (dictionary["image_url"] as? [String]) ?? []
		_id = dictionary["_id"] as? String
		unique_id = dictionary["unique_id"] as? Int
		updated_at = dictionary["updated_at"] as? String
		order_payment_id = dictionary["order_payment_id"] as? String
		order_type = dictionary["order_type"] as? Int
		invoice_number = dictionary["invoice_number"] as? Int
		store_id = dictionary["store_id"] as? String
		user_type = dictionary["user_type"] as? Int
		user_type_id = dictionary["user_type_id"] as? String
		provider_type = dictionary["provider_type"] as? Int
		provider_type_id = dictionary["provider_type_id"] as? String
		user_id = dictionary["user_id"] as? String
		provider_id = dictionary["provider_id"] as? String
		current_provider = dictionary["current_provider"] as? String
		service_id = dictionary["service_id"] as? String
		promo_id = dictionary["promo_id"] as? String
		promo_code = dictionary["promo_code"] as? String

		unique_code = dictionary["unique_code"] as? Int
        arrDatetime.removeAll()
        if let orderStatusDetail = dictionary["date_time"] as? [[String:Any]] {
            for dic in orderStatusDetail {
                let value = DeliveryStatusDetails(fromDictionary: dic)
                arrDatetime.append(value)
            }
        }
		currency = dictionary["currency"] as? String
		admin_currency = dictionary["admin_currency"] as? String
		order_status = dictionary["order_status"] as? Int
		order_status_by = dictionary["order_status_by"] as? String
		order_status_id = dictionary["order_status_id"] as? Int
		total_order_price = (dictionary["total_order_price"] as? Double)?.roundTo() ?? 0.00
		created_at = dictionary["created_at"] as? String
		completed_at = dictionary["completed_at"] as? String
		cancelled_at = dictionary["cancelled_at"] as? String
		delivered_at = dictionary["delivered_at"] as? String
		start_for_delivery_at = dictionary["start_for_delivery_at"] as? String
		arrived_on_store_at = dictionary["arrived_on_store_at"] as? String
		start_for_pickup_at = dictionary["start_for_pickup_at"] as? String
		accepted_at = dictionary["accepted_at"] as? String
		store_order_created_at = dictionary["store_order_created_at"] as? String
		picked_order_at = dictionary["picked_order_at"] as? String
		store_accepted_at = dictionary["store_accepted_at"] as? String
		order_ready_at = dictionary["order_ready_at"] as? String
		start_preparing_order_at = dictionary["start_preparing_order_at"] as? String
		schedule_order_server_start_at = dictionary["schedule_order_server_start_at"] as? String
		schedule_order_start_at = dictionary["schedule_order_start_at"] as? String
		is_schedule_order = dictionary["is_schedule_order"] as? Bool
        is_user_rated_to_provider = dictionary["is_user_rated_to_provider"] as! Bool
        is_user_rated_to_store = dictionary["is_user_rated_to_store"] as! Bool
        user_rating_to_store = dictionary["user_rating_to_store"] as? Float
        user_rating_to_provider = dictionary["user_rating_to_provider"] as? Float
        deliveryType = dictionary["delivery_type"] as? Int
        
        if let destinationDics = dictionary["destination_addresses"] as? [[String:Any]] {
            var arr = [Address]()
            for obj in destinationDics {
                arr.append(Address(fromDictionary: obj))
            }
            destination_addresses = arr
        }

        __v = dictionary["__v"] as? Int

//        if (dictionary["cart_detail"] != nil) {
//
//            cartDetail = CartDetail.init(fromDictionary: dictionary["cart_detail"] as! [String:Any])
//
//        }
        //API changes
//		if (dictionary["order_payment_detail"] != nil) { orderPayment = OrderPayment(dictionary: dictionary["order_payment_detail"] as! NSDictionary) }
        
      if isNotNSNull(object: dictionary["provider_detail"] as AnyObject){
          if (dictionary["provider_detail"] != nil) { provider_detail = ProviderDetail(dictionary: dictionary["provider_detail"] as! NSDictionary) }
      }
    
    }


	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self._id, forKey: "_id")
		dictionary.setValue(self.unique_id, forKey: "unique_id")
		dictionary.setValue(self.updated_at, forKey: "updated_at")
		dictionary.setValue(self.order_payment_id, forKey: "order_payment_id")
		dictionary.setValue(self.order_type, forKey: "order_type")
		dictionary.setValue(self.invoice_number, forKey: "invoice_number")
		dictionary.setValue(self.store_id, forKey: "store_id")
		dictionary.setValue(self.user_type, forKey: "user_type")
		dictionary.setValue(self.user_type_id, forKey: "user_type_id")
		dictionary.setValue(self.provider_type, forKey: "provider_type")
		dictionary.setValue(self.provider_type_id, forKey: "provider_type_id")
		dictionary.setValue(self.user_id, forKey: "user_id")
		dictionary.setValue(self.provider_id, forKey: "provider_id")
		dictionary.setValue(self.current_provider, forKey: "current_provider")
		dictionary.setValue(self.service_id, forKey: "service_id")
		dictionary.setValue(self.promo_id, forKey: "promo_id")
		dictionary.setValue(self.promo_code, forKey: "promo_code")
		dictionary.setValue(self.unique_code, forKey: "unique_code")
		
		dictionary.setValue(self.currency, forKey: "currency")
		dictionary.setValue(self.admin_currency, forKey: "admin_currency")
		dictionary.setValue(self.order_status, forKey: "order_status")
		dictionary.setValue(self.order_status_by, forKey: "order_status_by")
		dictionary.setValue(self.order_status_id, forKey: "order_status_id")
		dictionary.setValue(self.total_order_price, forKey: "total_order_price")
		dictionary.setValue(self.created_at, forKey: "created_at")
		dictionary.setValue(self.completed_at, forKey: "completed_at")
		dictionary.setValue(self.cancelled_at, forKey: "cancelled_at")
		dictionary.setValue(self.delivered_at, forKey: "delivered_at")
		dictionary.setValue(self.start_for_delivery_at, forKey: "start_for_delivery_at")
		dictionary.setValue(self.arrived_on_store_at, forKey: "arrived_on_store_at")
		dictionary.setValue(self.start_for_pickup_at, forKey: "start_for_pickup_at")
		dictionary.setValue(self.accepted_at, forKey: "accepted_at")
		dictionary.setValue(self.store_order_created_at, forKey: "store_order_created_at")
		dictionary.setValue(self.picked_order_at, forKey: "picked_order_at")
		dictionary.setValue(self.store_accepted_at, forKey: "store_accepted_at")
		dictionary.setValue(self.order_ready_at, forKey: "order_ready_at")
		dictionary.setValue(self.start_preparing_order_at, forKey: "start_preparing_order_at")
		dictionary.setValue(self.schedule_order_server_start_at, forKey: "schedule_order_server_start_at")
		dictionary.setValue(self.schedule_order_start_at, forKey: "schedule_order_start_at")
		dictionary.setValue(self.is_schedule_order, forKey: "is_schedule_order")
		dictionary.setValue(self.store_notify, forKey: "store_notify")
		dictionary.setValue(self.__v, forKey: "__v")
        dictionary.setValue(provider_detail, forKey: "provider_detail")
        dictionary.setValue(deliveryType, forKey: "delivery_type")
//		dictionary.setValue(self.orderPayment?.dictionaryRepresentation(), forKey: "order _payment_detail")

		return dictionary
	}
}

public class DateTime {
    public var status : Int = 0
    public var date : String = ""
    public var stop_no : Int = 0
    public var waiting_time : Int = 0
    public var image_url : String = ""
    
    required public init(dictionary: NSDictionary) {
        if let status = dictionary["status"] as? Int {
            self.status = status
        }
        if let strDate = dictionary["date"] as? String {
            self.date = strDate
        }
        stop_no = dictionary["stop_no"] as? Int ?? 0
        waiting_time = dictionary["waiting_time"] as? Int ?? 0
        image_url = dictionary["image_url"] as? String ?? ""
    }
}
