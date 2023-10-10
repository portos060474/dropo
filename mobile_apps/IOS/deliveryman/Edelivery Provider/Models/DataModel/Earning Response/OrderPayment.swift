
import Foundation



public class OrderPayment {
    public var __v : Int?
    public var unique_id : Int?
    public var order_unique_id :Int?
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
    public var surge_charges : Double?
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
    public var total_after_wallet_payment : Double?
    public var cash_payment : Double?
    public var card_payment : Double?
    public var remaining_payment : Double?
    public var _id : String?
    public var delivered_at : String?
    public var is_promo_for_delivery_service: Bool = false
    public var is_distance_unit_mile : Bool = false
    public var total_cart_price:Double = 0.0
    public var provider_paid_order_payment: Double?
    public var provider_have_cash_payment:Double?
    public var pay_to_provider:Double?
    public var isPaymentModeCash : Bool = false
     public var total_base_price:Double = 0.0
    public var tip_value : Int?
    public var tip_amount : Double = 0.0
    public var is_store_pay_delivery_fees:Bool = false
    var taxDetails : [TaxesDetail]!
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let OrderPayment_list = OrderPayment.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of OrderPayment Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [OrderPayment] {
        var models:[OrderPayment] = []
        for item in array {
            models.append(OrderPayment(dictionary: item as! [String:Any])!)
        }
        return models
    }
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let OrderPayment = OrderPayment(someDictionaryFromJSON)
     
     - parameter dictionary:  [String:Any] from JSON.
     
     - returns: OrderPayment Instance.
     */
    required public init?(dictionary: [String:Any]) {
        
        __v = (dictionary["__v"] as? Int) ?? 0
        unique_id = (dictionary["unique_id"] as? Int) ?? 0
        updated_at = (dictionary["updated_at"] as? String) ?? ""
        createdAt = (dictionary["createdAt"] as? String) ?? ""
        order_id = (dictionary["order_id"] as? String) ?? ""
        order_unique_id = (dictionary["order_unique_id"] as? Int) ?? 0
        user_id = (dictionary["user_id"] as? String) ?? ""
        provider_id = (dictionary["provider_id"] as? String) ?? ""
        currency_code = (dictionary["currency_code"] as? String) ?? ""
        admin_currency_code = (dictionary["admin_currency_code"] as? String) ?? ""
        current_rate = (dictionary["current_rate"] as? Double)?.roundTo() ?? 0.00
        admin_profit_mode_on_delivery = (dictionary["admin_profit_mode_on_delivery"] as? Double)?.roundTo() ?? 0.00
        admin_profit_value_on_delivery = (dictionary["admin_profit_value_on_delivery"] as? Double)?.roundTo() ?? 0.00
        total_admin_profit_on_delivery = (dictionary["total_admin_profit_on_delivery"] as? Double)?.roundTo() ?? 0.00
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
        surge_charges = (dictionary["surge_charges"] as? Double)?.roundTo() ?? 0.00
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
        total_item = (dictionary["total_item_count"] as? Int) ?? 0
        total_specifications = (dictionary["total_specification_count"] as? Int) ?? 0
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
        remaining_payment = (dictionary["remaining_payment"] as? Double)?.roundTo() ?? 0.00
        
        provider_paid_order_payment = (dictionary["provider_paid_order_payment"] as? Double)?.roundTo() ?? 0.00
        pay_to_provider = (dictionary["pay_to_provider"] as? Double)?.roundTo() ?? 0.00
        provider_have_cash_payment = (dictionary["provider_have_cash_payment"] as? Double)?.roundTo() ?? 0.00
        total_provider_income = (dictionary["total_provider_income"] as? Double)?.roundTo() ?? 0.00
        
        isPaymentModeCash = (dictionary["is_payment_mode_cash"] as? Bool) ?? false
        
        _id = (dictionary["_id"] as? String) ?? ""
        delivered_at = dictionary["delivered_at"] as? String
        if dictionary["is_promo_for_delivery_service"] != nil {
            is_promo_for_delivery_service = (dictionary["is_promo_for_delivery_service"] as? Bool)!
        }
        is_distance_unit_mile = (dictionary["is_distance_unit_mile"] as? Bool)!
        total_base_price = (dictionary["total_base_price"] as? Double)?.roundTo() ?? 0.00
        total_cart_price = (dictionary["total_cart_price"] as? Double) ?? 0.0
        tip_value = dictionary["tip_value"] as? Int
        tip_amount =  (dictionary["tip_amount"] as? Double) ?? 0.0
        
        is_store_pay_delivery_fees = (dictionary["is_store_pay_delivery_fees"] as? Bool) ?? false
        
        taxDetails = [TaxesDetail]()
        if let taxDetailsArray = dictionary["taxes"] as? [[String:Any]]{
            for dic in taxDetailsArray{
                let value = TaxesDetail(fromDictionary: dic)
                taxDetails.append(value)
            }
        }
    }
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: [String:Any].
     */
    public func dictionaryRepresentation() -> [String:Any] {
        
         var dictionary:[String:Any] = [:]
        
        dictionary["__v "] =  self.__v
        dictionary["unique_id "] =  self.unique_id
        dictionary["updated_at "] = self.updated_at
        dictionary["createdAt "] = self.createdAt
        dictionary["order_id "] = self.order_id
        dictionary["user_id "] = self.user_id
        dictionary["provider_id "] = self.provider_id
        dictionary["currency_code "] = self.currency_code
        dictionary["admin_currency_code "] = self.admin_currency_code
        dictionary["current_rate "] = self.current_rate
        dictionary[ "admin_profit_mode_on_delivery "] =  self.admin_profit_mode_on_delivery
        dictionary[ "admin_profit_value_on_delivery "] = self.admin_profit_value_on_delivery
        dictionary[ "total_admin_profit_on_delivery "] = self.total_admin_profit_on_delivery
        dictionary["total_provider_income "] = self.total_provider_income
        dictionary["admin_profit_mode_on_store "] = self.admin_profit_mode_on_store
        dictionary["admin_profit_value_on_store "] = self.admin_profit_value_on_store
        dictionary["total_admin_profit_on_store "] = self.total_admin_profit_on_store
        dictionary[ "total_store_income "] = self.total_store_income
        dictionary["base_price_distance "] = self.base_price_distance
        dictionary["base_price "] = self.base_price
        dictionary["price_per_unit_distance "] = self.price_per_unit_distance
        dictionary[ "price_per_unit_time "] = self.price_per_unit_time
        dictionary[ "total_distance "] = self.total_distance
        dictionary["total_time "] = self.total_time
        dictionary["service_tax "] = self.service_tax
        dictionary[ "surge_charges "] = self.surge_charges
        dictionary[ "min_fare "] = self.min_fare
        dictionary["base_distance_price "] = self.base_distance_price
        dictionary[ "distance_price "] = self.distance_price
        dictionary["total_distance_price "] = self.total_distance_price
        dictionary["total_time_price "] = self.total_time_price
        dictionary["total_service_price "] = self.total_service_price
        dictionary["total_admin_tax_price "] = self.total_admin_tax_price
        dictionary["total_after_tax_price "] = self.total_after_tax_price
        dictionary["total_surge_price "] = self.total_surge_price
        dictionary["total_delivery_price_after_surge "] = self.total_delivery_price_after_surge
        dictionary["total_delivery_price "] = self.total_delivery_price
        dictionary["total_item "] = self.total_item
        dictionary["total_specifications "] = self.total_specifications
        dictionary["total_item_price "] = self.total_item_price
        dictionary["total_item_specification_price "] = self.total_item_specification_price
        dictionary["item_tax "] = self.item_tax
        dictionary["total_store_tax_price "] = self.total_store_tax_price
        dictionary["total_order_price "] = self.total_order_price
        dictionary["total_delivery_and_store_price "] = self.total_delivery_and_store_price
        dictionary["promo_payment "] = self.promo_payment
        dictionary["total "] = self.total
        dictionary["wallet_payment "] = self.wallet_payment
        dictionary["total_after_wallet_payment "] = self.total_after_wallet_payment
        dictionary["cash_payment "] = self.cash_payment
        dictionary["card_payment "] = self.card_payment
        dictionary["remaining_payment "] = self.remaining_payment
        dictionary["_id "] = self._id
        dictionary["delivered_at "] = self.delivered_at
        dictionary["is_promo_for_delivery_service "] = self.is_promo_for_delivery_service
        dictionary["is_distance_unit_mile "] = self.is_distance_unit_mile
        dictionary["order_unique_id "] = self.order_unique_id
        dictionary["total_base_price "] = self.total_base_price
        dictionary[ "total_cart_price "] = self.total_cart_price
        
        if taxDetails != nil{
            var dictionaryElements = [[String:Any]]()
            for taxDetailsElement in taxDetails {
                dictionaryElements.append(taxDetailsElement.toDictionary())
            }
            dictionary["tax_details"] = dictionaryElements
        }
        return dictionary
    }
}
public class TaxesDetail {
    
    var v : Int!
    var id : String!
    var countryId : String!
    var createdAt : String!
    var isTaxVisible : Bool!
    var tax : Int!
    var taxName : [String]!
    var updatedAt : String!
    var isTaxSelected : Bool
    var tax_amount : Int!

    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        v = dictionary["__v"] as? Int
        id = dictionary["_id"] as? String
        countryId = dictionary["country_id"] as? String
        createdAt = dictionary["created_at"] as? String
        isTaxVisible = dictionary["is_tax_visible"] as? Bool
        tax = dictionary["tax"] as? Int
        taxName = dictionary["tax_name"] as? [String]
        updatedAt = dictionary["updated_at"] as? String
        isTaxSelected = false
        if dictionary["tax_amount"] != nil{
            tax_amount = dictionary["tax_amount"] as? Int
        }else{
            tax_amount = 0
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if v != nil{
            dictionary["__v"] = v
        }
        if id != nil{
            dictionary["_id"] = id
        }
        if countryId != nil{
            dictionary["country_id"] = countryId
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if isTaxVisible != nil{
            dictionary["is_tax_visible"] = isTaxVisible
        }
        if tax != nil{
            dictionary["tax"] = tax
        }
        if taxName != nil{
            dictionary["tax_name"] = taxName
        }
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        
        if tax_amount != nil{
            dictionary["tax_amount"] = tax_amount
        }
        return dictionary
    }

    

}
