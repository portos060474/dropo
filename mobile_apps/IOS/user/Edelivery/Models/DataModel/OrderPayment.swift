
import Foundation
 
/* For support, please feel free to contact me at  */

public class OrderPayment {
	public var __v : Int?
	public var unique_id : Int?
	public var updated_at : String?
	public var createdAt : String?
	public var order_id : String?
	public var user_id : String?
	public var provider_id : String?
	public var currency_code : String?
	public var admin_currency_code : String?
	public var current_rate : Double?
	public var admin_profit_mode_on_delivery : Double?
	public var admin_profit_value_on_delivery : Double?
	public var total_admin_profit_on_delivery : Double?
	public var total_provider_income : Double?
	public var admin_profit_mode_on_store : Double?
	public var admin_profit_value_on_store : Double?
	public var total_admin_profit_on_store : Double?
	public var total_store_income : Double?
	public var base_price_distance : Double?
	public var base_price : Double?
	public var price_per_unit_distance : Double?
	public var price_per_unit_time : Double?
	public var total_distance : Double?
	public var total_time : Double?
	public var service_tax : Double?
	public var surge_multiplier : Double?
	public var min_fare : Double?
	public var base_distance_price : Double?
	public var distance_price : Double?
	public var total_distance_price : Double?
	public var total_time_price : Double?
	public var total_service_price : Double?
	public var total_admin_tax_price : Double?
	public var total_after_tax_price : Double?
	public var total_surge_price : Double?
	public var total_delivery_price_after_surge : Double?
	public var total_delivery_price : Double?
	public var total_item : Int?
	public var total_specifications : Int?
	public var total_item_price : Double?
	public var total_item_specification_price : Double?
	public var item_tax : Double?
	public var total_store_tax_price : Double?
	public var total_order_price : Double?
	public var total_delivery_and_store_price : Double?
	public var promo_payment : Double?
	public var total : Double?
	public var wallet_payment : Double?
    public var userPayPayment : Double!
	public var total_after_wallet_payment : Double?
	public var cash_payment : Double?
	public var card_payment : Double?
	public var remaining_payment : Double?
	public var _id : String?
	public var delivered_at : String?
    public var is_promo_for_delivery_service: Bool = false
    public var is_distance_unit_mile : Bool = false
     public var isPaymentModeCash : Bool = false
    public var total_base_price:Double = 0.0
    public var is_store_pay_delivery_fees:Bool = false
    public var total_cart_price:Double = 0.0
    public var isUserPickupOrder:Bool = false
    var isMinFareApplied:Bool = false
    public var tip_value : Int?
    public var tip_amount : Double = 0.0
    var taxDetails : [TaxesDetail]!
    public var booking_fees:Double = 0.0
    public var round_trip_charge:Double = 0.0
    public var total_round_trip_charge:Double = 0.0
    public var additional_stop_price:Double = 0.0
    public var total_waiting_time:Int = 0
    public var total_waiting_time_price:Double = 0.0

    public class func modelsFromDictionaryArray(array:NSArray) -> [OrderPayment] {
        var models:[OrderPayment] = []
        for item in array {
            models.append(OrderPayment(dictionary: item as! NSDictionary)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {

		__v = dictionary["__v"] as? Int
        userPayPayment = (dictionary["user_pay_payment"] as? Double) ?? 0.0
        unique_id = dictionary["unique_id"] as? Int
		updated_at = dictionary["updated_at"] as? String
		createdAt = dictionary["createdAt"] as? String
		order_id = dictionary["order_id"] as? String
		user_id = dictionary["user_id"] as? String
		provider_id = dictionary["provider_id"] as? String
		currency_code = dictionary["currency_code"] as? String
		admin_currency_code = dictionary["admin_currency_code"] as? String
		current_rate = (dictionary["current_rate"] as? Double)?.roundTo() ?? 0.00
        
        
        isMinFareApplied = (dictionary["is_min_fare_applied"] as? Bool) ?? false
		admin_profit_mode_on_delivery = (dictionary["admin_profit_mode_on_delivery"] as? Double)?.roundTo() ?? 0.00
		admin_profit_value_on_delivery = (dictionary["admin_profit_value_on_delivery"] as? Double)?.roundTo() ?? 0.00
		total_admin_profit_on_delivery = (dictionary["total_admin_profit_on_delivery"] as? Double)?.roundTo() ?? 0.00
		total_provider_income = (dictionary["total_provider_income"] as? Double)?.roundTo() ?? 0.00
		admin_profit_mode_on_store = (dictionary["admin_profit_mode_on_store"] as? Double)?.roundTo() ?? 0.00
		admin_profit_value_on_store = (dictionary["admin_profit_value_on_store"] as? Double)?.roundTo() ?? 0.00
		total_admin_profit_on_store = (dictionary["total_admin_profit_on_store"] as? Double)?.roundTo() ?? 0.00
		total_store_income = (dictionary["total_store_income"] as? Double)?.roundTo() ?? 0.00
		base_price_distance = (dictionary["base_price_distance"] as? Double)?.roundTo() ?? 0.00
		base_price = (dictionary["base_price"] as? Double)?.roundTo() ?? 0.00
		price_per_unit_distance = (dictionary["price_per_unit_distance"] as? Double)?.roundTo() ?? 0.00
		price_per_unit_time = (dictionary["price_per_unit_time"] as? Double)?.roundTo() ?? 0.00
		total_distance = (dictionary["total_distance"] as? Double)?.roundTo() ?? 0.00
		total_time = (dictionary["total_time"] as? Double)?.roundTo() ?? 0.00
		service_tax = (dictionary["service_tax"] as? Double)?.roundTo() ?? 0.00
        surge_multiplier = (dictionary["surge_multiplier"] as? Double)?.roundTo() ?? 0.00
		min_fare = (dictionary["min_fare"] as? Double)?.roundTo() ?? 0.00
		base_distance_price = (dictionary["base_distance_price"] as? Double)?.roundTo() ?? 0.00
		distance_price = (dictionary["distance_price"] as? Double)?.roundTo() ?? 0.00
		total_distance_price = (dictionary["total_distance_price"] as? Double)?.roundTo() ?? 0.00
		total_time_price = (dictionary["total_time_price"] as? Double)?.roundTo() ?? 0.00
		total_service_price = (dictionary["total_service_price"] as? Double)?.roundTo() ?? 0.00
		total_admin_tax_price = (dictionary["total_admin_tax_price"] as? Double)?.roundTo() ?? 0.00
		total_after_tax_price = (dictionary["total_after_tax_price"] as? Double)?.roundTo() ?? 0.00
		total_surge_price = (dictionary["total_surge_price"] as? Double)?.roundTo() ?? 0.00
		total_delivery_price_after_surge = (dictionary["total_delivery_price_after_surge"] as? Double)?.roundTo() ?? 0.00
		total_delivery_price = (dictionary["total_delivery_price"] as? Double)?.roundTo() ?? 0.00
		total_item = dictionary["total_item_count"] as? Int
		total_specifications = dictionary["total_specification_count"] as? Int
		total_item_price = (dictionary["total_item_price"] as? Double)?.roundTo() ?? 0.00
		total_item_specification_price = (dictionary["total_specification_price"] as? Double)?.roundTo() ?? 0.00
		item_tax = (dictionary["item_tax"] as? Double)?.roundTo() ?? 0.00
		total_store_tax_price = (dictionary["total_store_tax_price"] as? Double)?.roundTo() ?? 0.00
		total_order_price = (dictionary["total_order_price"] as? Double)?.roundTo() ?? 0.00
		total_delivery_and_store_price = (dictionary["total_delivery_and_store_price"] as? Double)?.roundTo() ?? 0.00
		promo_payment = (dictionary["promo_payment"] as? Double)?.roundTo() ?? 0.00
		total = (dictionary["total"] as? Double)?.roundTo() ?? 0.00
		wallet_payment = (dictionary["wallet_payment"] as? Double)?.roundTo() ?? 0.00
		total_after_wallet_payment = (dictionary["total_after_wallet_payment"] as? Double)?.roundTo() ?? 0.00
		cash_payment = (dictionary["cash_payment"] as? Double)?.roundTo() ?? 0.00
		card_payment = (dictionary["card_payment"] as? Double)?.roundTo() ?? 0.00
        total_base_price = (dictionary["total_base_price"] as? Double)?.roundTo() ?? 0.00
		remaining_payment = (dictionary["remaining_payment"] as? Double)?.roundTo() ?? 0.00
		_id = dictionary["_id"] as? String
		delivered_at = dictionary["delivered_at"] as? String
        if dictionary["is_promo_for_delivery_service"] != nil {
        is_promo_for_delivery_service = (dictionary["is_promo_for_delivery_service"] as? Bool)!
        }
         is_distance_unit_mile = (dictionary["is_distance_unit_mile"] as? Bool) ?? false
        is_store_pay_delivery_fees = (dictionary["is_store_pay_delivery_fees"] as? Bool) ?? false
        
        isPaymentModeCash = (dictionary["is_payment_mode_cash"] as? Bool) ?? false
        isUserPickupOrder = (dictionary["is_user_pick_up_order"] as? Bool) ?? false
        total_cart_price = (dictionary["total_cart_price"] as? Double) ?? 0.0
        tip_value = dictionary["tip_value"] as? Int
        tip_amount = (dictionary["tip_amount"] as? Double) ?? 0.0
        taxDetails = [TaxesDetail]()
        if let taxDetailsArray = dictionary["taxes"] as? [[String:Any]]{
            for dic in taxDetailsArray{
                let value = TaxesDetail(fromDictionary: dic)
                taxDetails.append(value)
            }
        }
        booking_fees = (dictionary["booking_fees"] as? Double) ?? 0.0
        round_trip_charge = (dictionary["round_trip_charge"] as? Double) ?? 0.0
        total_round_trip_charge = (dictionary["total_round_trip_charge"] as? Double) ?? 0.0
        additional_stop_price = (dictionary["additional_stop_price"] as? Double) ?? 0.0
        total_waiting_time = (dictionary["total_waiting_time"] as? Int) ?? 1
        total_waiting_time_price = (dictionary["total_waiting_time_price"] as? Double) ?? 0.0
	}

	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.__v, forKey: "__v")
		dictionary.setValue(self.unique_id, forKey: "unique_id")
		dictionary.setValue(self.updated_at, forKey: "updated_at")
		dictionary.setValue(self.createdAt, forKey: "createdAt")
		dictionary.setValue(self.order_id, forKey: "order_id")
		dictionary.setValue(self.user_id, forKey: "user_id")
		dictionary.setValue(self.provider_id, forKey: "provider_id")
		dictionary.setValue(self.currency_code, forKey: "currency_code")
		dictionary.setValue(self.admin_currency_code, forKey: "admin_currency_code")
		dictionary.setValue(self.current_rate, forKey: "current_rate")
		dictionary.setValue(self.admin_profit_mode_on_delivery, forKey: "admin_profit_mode_on_delivery")
		dictionary.setValue(self.admin_profit_value_on_delivery, forKey: "admin_profit_value_on_delivery")
		dictionary.setValue(self.total_admin_profit_on_delivery, forKey: "total_admin_profit_on_delivery")
		dictionary.setValue(self.total_provider_income, forKey: "total_provider_income")
		dictionary.setValue(self.admin_profit_mode_on_store, forKey: "admin_profit_mode_on_store")
		dictionary.setValue(self.admin_profit_value_on_store, forKey: "admin_profit_value_on_store")
		dictionary.setValue(self.total_admin_profit_on_store, forKey: "total_admin_profit_on_store")
		dictionary.setValue(self.total_store_income, forKey: "total_store_income")
		dictionary.setValue(self.base_price_distance, forKey: "base_price_distance")
		dictionary.setValue(self.base_price, forKey: "base_price")
		dictionary.setValue(self.price_per_unit_distance, forKey: "price_per_unit_distance")
		dictionary.setValue(self.price_per_unit_time, forKey: "price_per_unit_time")
		dictionary.setValue(self.total_distance, forKey: "total_distance")
		dictionary.setValue(self.total_time, forKey: "total_time")
		dictionary.setValue(self.service_tax, forKey: "service_tax")
		dictionary.setValue(self.surge_multiplier, forKey: "surge_multiplier")
		dictionary.setValue(self.min_fare, forKey: "min_fare")
		dictionary.setValue(self.base_distance_price, forKey: "base_distance_price")
		dictionary.setValue(self.distance_price, forKey: "distance_price")
		dictionary.setValue(self.total_distance_price, forKey: "total_distance_price")
		dictionary.setValue(self.total_time_price, forKey: "total_time_price")
		dictionary.setValue(self.total_service_price, forKey: "total_service_price")
		dictionary.setValue(self.total_admin_tax_price, forKey: "total_admin_tax_price")
		dictionary.setValue(self.total_after_tax_price, forKey: "total_after_tax_price")
		dictionary.setValue(self.total_surge_price, forKey: "total_surge_price")
		dictionary.setValue(self.total_delivery_price_after_surge, forKey: "total_delivery_price_after_surge")
		dictionary.setValue(self.total_delivery_price, forKey: "total_delivery_price")
		dictionary.setValue(self.total_item, forKey: "total_item")
		dictionary.setValue(self.total_specifications, forKey: "total_specifications")
		dictionary.setValue(self.total_item_price, forKey: "total_item_price")
		dictionary.setValue(self.total_item_specification_price, forKey: "total_item_specification_price")
		dictionary.setValue(self.item_tax, forKey: "item_tax")
		dictionary.setValue(self.total_store_tax_price, forKey: "total_store_tax_price")
		dictionary.setValue(self.total_order_price, forKey: "total_order_price")
		dictionary.setValue(self.total_delivery_and_store_price, forKey: "total_delivery_and_store_price")
		dictionary.setValue(self.promo_payment, forKey: "promo_payment")
		dictionary.setValue(self.total, forKey: "total")
		dictionary.setValue(self.wallet_payment, forKey: "wallet_payment")
		dictionary.setValue(self.total_after_wallet_payment, forKey: "total_after_wallet_payment")
		dictionary.setValue(self.cash_payment, forKey: "cash_payment")
		dictionary.setValue(self.card_payment, forKey: "card_payment")
		dictionary.setValue(self.remaining_payment, forKey: "remaining_payment")
		dictionary.setValue(self._id, forKey: "_id")
		dictionary.setValue(self.delivered_at, forKey: "delivered_at")
        dictionary.setValue(self.is_promo_for_delivery_service, forKey:"is_promo_for_delivery_service")
        dictionary.setValue(self.total_base_price, forKey: "total_base_price")
        dictionary.setValue(self.is_distance_unit_mile, forKey: "is_distance_unit_mile")
        dictionary.setValue(self.total_cart_price, forKey: "total_cart_price")
        dictionary.setValue(self.taxDetails, forKey: "taxes")
        dictionary.setValue(self.booking_fees, forKey: "booking_fees")
        dictionary.setValue(self.round_trip_charge, forKey: "round_trip_charge")
        dictionary.setValue(self.total_round_trip_charge, forKey: "total_round_trip_charge")
        dictionary.setValue(self.additional_stop_price, forKey: "additional_stop_price")
        dictionary.setValue(self.total_waiting_time, forKey: "total_waiting_time")
        dictionary.setValue(self.total_waiting_time_price, forKey: "total_waiting_time_price")

		return dictionary
    }
}
