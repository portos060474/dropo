
import Foundation
 


public class Order_payment_detail {
	public var _id : String?
	public var unique_id : Int?
	public var updated_at : String?
	public var createdAt : String?
	public var order_id : String?
	public var user_id : String?
	public var provider_id : String?
	public var currency_code : String?
	public var admin_currency_code : String?
	public var current_rate : Int?
	public var admin_profit_mode_on_delivery : Int?
	public var admin_profit_value_on_delivery : Int?
	public var total_admin_profit_on_delivery : Int?
	public var total_provider_income : Int?
	public var admin_profit_mode_on_store : Int?
	public var admin_profit_value_on_store : Int?
	public var total_admin_profit_on_store : Double?
	public var total_store_income : Double?
	public var base_price_distance : Double?
	public var base_price : Double?
	public var price_per_unit_distance : Int?
	public var price_per_unit_time : Int?
	public var total_distance : Double?
	public var total_time : Int?
	public var service_tax : Double?
	public var surge_charges : Double?
	public var min_fare : Double?
	public var total_base_price : Double?
	public var distance_price : Double?
	public var total_distance_price : Double?
	public var total_time_price : Double?
	public var total_service_price : Double?
	public var total_admin_tax_price : Double?
	public var total_after_tax_price : Double?
	public var total_surge_price : Double?
	public var total_delivery_price_after_surge : Double?
    public var total_item_price : Double?
    public var total_item_specification_price : Double?
	public var delivery_price : Double?
	public var total_delivery_price : Double?
	public var total_item : Int?
	public var total_specifications : Int?
	public var item_tax : Int?
	public var total_store_tax_price : Double?
	public var total_order_price : Double?
	public var total_delivery_and_store_price : Double?
	public var promo_payment : Double?
	public var total : Int?
	public var wallet_payment : Int?
	public var total_after_wallet_payment : Int?
	public var cash_payment : Int?
	public var card_payment : Int?
	public var remaining_payment : Int?
	public var payment_id : String?
	public var delivered_at : String?
	public var is_payment_mode_cash : String?
	public var is_distance_unit_mile : String?
	public var is_pending_payment : String?
	public var is_payment_paid : String?
	public var is_cancellation_fee : String?
	public var is_surge_hours : String?
	public var is_min_fare_used : String?
	public var __v : Int?
    public var tip_value : Int?
    public var tip_amount : Double = 0.0

    public class func modelsFromDictionaryArray(array:NSArray) -> [Order_payment_detail] {
        var models:[Order_payment_detail] = []
        for item in array {
            models.append(Order_payment_detail(dictionary: item as! [String:Any])!)
        }
        return models
    }

	required public init?(dictionary: [String:Any]) {

		_id = dictionary["_id"] as? String
		unique_id = dictionary["unique_id"] as? Int
		updated_at = dictionary["updated_at"] as? String
		createdAt = dictionary["createdAt"] as? String
		order_id = dictionary["order_id"] as? String
		user_id = dictionary["user_id"] as? String
		provider_id = dictionary["provider_id"] as? String
		currency_code = dictionary["currency_code"] as? String
		admin_currency_code = dictionary["admin_currency_code"] as? String
		current_rate = dictionary["current_rate"] as? Int
		admin_profit_mode_on_delivery = dictionary["admin_profit_mode_on_delivery"] as? Int
		admin_profit_value_on_delivery = dictionary["admin_profit_value_on_delivery"] as? Int
		total_admin_profit_on_delivery = dictionary["total_admin_profit_on_delivery"] as? Int
		total_provider_income = dictionary["total_provider_income"] as? Int
		admin_profit_mode_on_store = dictionary["admin_profit_mode_on_store"] as? Int
		admin_profit_value_on_store = dictionary["admin_profit_value_on_store"] as? Int
		total_admin_profit_on_store = dictionary["total_admin_profit_on_store"] as? Double
		total_store_income = dictionary["total_store_income"] as? Double
		base_price_distance = dictionary["base_price_distance"] as? Double
		base_price = dictionary["base_price"] as? Double
		price_per_unit_distance = dictionary["price_per_unit_distance"] as? Int
		price_per_unit_time = dictionary["price_per_unit_time"] as? Int
		total_distance = dictionary["total_distance"] as? Double
		total_time = dictionary["total_time"] as? Int
		service_tax = dictionary["service_tax"] as? Double
		surge_charges = dictionary["surge_charges"] as? Double
		min_fare = dictionary["min_fare"] as? Double
		total_base_price = dictionary["total_base_price"] as? Double
		distance_price = dictionary["distance_price"] as? Double
		total_distance_price = dictionary["total_distance_price"] as? Double
		total_time_price = dictionary["total_time_price"] as? Double
		total_service_price = dictionary["total_service_price"] as? Double
		total_admin_tax_price = dictionary["total_admin_tax_price"] as? Double
		total_after_tax_price = dictionary["total_after_tax_price"] as? Double
		total_surge_price = dictionary["total_surge_price"] as? Double
		total_delivery_price_after_surge = dictionary["total_delivery_price_after_surge"] as? Double
		delivery_price = dictionary["delivery_price"] as? Double
		total_delivery_price = dictionary["total_delivery_price"] as? Double
        total_item = dictionary["total_item_count"] as? Int
        total_specifications = dictionary["total_specification_count"] as? Int
        total_item_price = dictionary["total_item_price"] as? Double
        total_item_specification_price = dictionary["total_specification_price"] as? Double
        
		item_tax = dictionary["item_tax"] as? Int
		total_store_tax_price = dictionary["total_store_tax_price"] as? Double
		total_order_price = dictionary["total_order_price"] as? Double
		total_delivery_and_store_price = dictionary["total_delivery_and_store_price"] as? Double
		promo_payment = dictionary["promo_payment"] as? Double
		total = dictionary["total"] as? Int
		wallet_payment = dictionary["wallet_payment"] as? Int
		total_after_wallet_payment = dictionary["total_after_wallet_payment"] as? Int
		cash_payment = dictionary["cash_payment"] as? Int
		card_payment = dictionary["card_payment"] as? Int
		remaining_payment = dictionary["remaining_payment"] as? Int
		payment_id = dictionary["payment_id"] as? String
		delivered_at = dictionary["delivered_at"] as? String
		is_payment_mode_cash = dictionary["is_payment_mode_cash"] as? String
		is_distance_unit_mile = dictionary["is_distance_unit_mile"] as? String
		is_pending_payment = dictionary["is_pending_payment"] as? String
		is_payment_paid = dictionary["is_payment_paid"] as? String
		is_cancellation_fee = dictionary["is_cancellation_fee"] as? String
		is_surge_hours = dictionary["is_surge_hours"] as? String
		is_min_fare_used = dictionary["is_min_fare_used"] as? String
		__v = dictionary["__v"] as? Int
        tip_value = dictionary["tip_value"] as? Int
        tip_amount =  (dictionary["tip_amount"] as? Double) ?? 0.0
	}


	public func dictionaryRepresentation() -> [String:Any] {

		var dictionary:[String:Any] = [:]

        dictionary["_id"] = self._id
        dictionary["unique_id"] = self.unique_id
        dictionary["updated_at"] = self.updated_at
        dictionary["createdAt"] = self.createdAt
        dictionary["order_id"] = self.order_id
        dictionary["user_id"] = self.user_id
        dictionary["provider_id"] = self.provider_id
        dictionary["currency_code"] = self.currency_code
        dictionary["admin_currency_code"] = self.admin_currency_code
        dictionary["current_rate"] = self.current_rate
        dictionary["admin_profit_mode_on_delivery"] = self.admin_profit_mode_on_delivery
        dictionary["admin_profit_value_on_delivery"] = self.admin_profit_value_on_delivery
        dictionary["total_admin_profit_on_delivery"] = self.total_admin_profit_on_delivery
        dictionary["total_provider_income"] = self.total_provider_income
        dictionary["admin_profit_mode_on_store"] = self.admin_profit_mode_on_store
        dictionary["admin_profit_value_on_store"] = self.admin_profit_value_on_store
        dictionary["total_admin_profit_on_store"] = self.total_admin_profit_on_store
        dictionary["total_store_income"] = self.total_store_income
        dictionary["base_price_distance"] = self.base_price_distance
        dictionary["base_price"] = self.base_price
        dictionary["price_per_unit_distance"] = self.price_per_unit_distance
        dictionary["price_per_unit_time"] = self.price_per_unit_time
        dictionary["total_distance"] = self.total_distance
        dictionary["total_time"] = self.total_time
        dictionary["service_tax"] = self.service_tax
        dictionary["surge_charges"] = self.surge_charges
        dictionary["min_fare"] = self.min_fare
        dictionary["total_base_price"] = self.total_base_price
        dictionary["distance_price"] = self.distance_price
        dictionary["total_distance_price"] = self.total_distance_price
        dictionary["total_time_price"] = self.total_time_price
        dictionary["total_service_price"] = self.total_service_price
        dictionary["total_admin_tax_price"] = self.total_admin_tax_price
        dictionary["total_after_tax_price"] = self.total_after_tax_price
        dictionary["total_surge_price"] = self.total_surge_price
        dictionary["total_delivery_price_after_surge"] = self.total_delivery_price_after_surge
        dictionary["delivery_price"] = self.delivery_price
        dictionary["total_delivery_price"] = self.total_delivery_price
        dictionary["total_item"] = self.total_item
        dictionary["total_specifications"] = self.total_specifications
        dictionary["item_tax"] = self.item_tax
        dictionary["total_store_tax_price"] = self.total_store_tax_price
        dictionary["total_order_price"] = self.total_order_price
        dictionary["total_delivery_and_store_price"] = self.total_delivery_and_store_price
        dictionary["promo_payment"] = self.promo_payment
        dictionary["total"] = self.total
        dictionary["wallet_payment"] = self.wallet_payment
        dictionary["total_after_wallet_payment"] = self.total_after_wallet_payment
        dictionary["cash_payment"] = self.cash_payment
        dictionary["card_payment"] = self.card_payment
        dictionary["remaining_payment"] = self.remaining_payment
        dictionary["payment_id"] = self.payment_id
        dictionary["delivered_at"] = self.delivered_at
        dictionary["is_payment_mode_cash"] = self.is_payment_mode_cash
        dictionary["is_distance_unit_mile"] = self.is_distance_unit_mile
        dictionary["is_pending_payment"] = self.is_pending_payment
        dictionary["is_payment_paid"] = self.is_payment_paid
        dictionary["is_cancellation_fee"] = self.is_cancellation_fee
        dictionary["is_surge_hours"] = self.is_surge_hours
        dictionary["is_min_fare_used"] = self.is_min_fare_used
        dictionary["__v"] = self.__v
		return dictionary
	}

}
