import Foundation

public class StoreItem {
	public var _id : String?
	public var unique_id : Int?
	public var updated_at : String?
	public var store_delivery_id : String?
	public var name : String?
	public var email : String?
	public var password : String?
	public var country_phone_code : String?
	public var website_url : String?
	public var slogan : String?
	public var country_id : String?
	public var city_id : String?
	public var phone : String?
	public var address : String?
	public var fax_number : String?
	public var famous_for : String?
	public var device_token : String?
	public var server_token : String?
	public var price_rating : Int?
	public var rate : Double?
	public var rate_count : Int?
	public var referral_code : String?
	public var referred_by : String?
	public var total_referrals : Int?
	public var is_approved : Bool?
	public var is_business : Bool?
    public var isStoreBusy : Bool!
	public var is_email_verified : Bool?
	public var is_phone_number_verified : Bool?
	public var is_document_uploaded : Bool?
	public var item_tax : Double!
	public var free_delivery_for_above_order_price : Double!
	public var admin_profit_mode_on_store : Int?
	public var admin_profit_value_on_store : Int?
	public var wallet : Double?
	public var wallet_currency_code : String?
	public var __v : Int?
	public var created_at : String?
	public var is_store_pay_delivery_fees : Bool!
	public var is_referral : Bool?
    public var isSelectedToDelete : Bool = false
    var store_time : [StoreTime] = []
	public var image_url : String! = ""
    public var maxItemQuantityAddByUser:Int = 0
	public var location : Array<Double>?
    public var storeTimelongs:Array<Int64>?
    public var deliveryTime:Int!
    public var deliveryMaxTime:Int!
    public var offer:String?
    public var isStoreClosed : Bool = false
    public var reopenAt:String = ""
    public var closeAt:String = ""
    public var isFavourite:Bool = false
    public var distanceFromMyLocation:Int = 0
    public var famousProductsTags = [Famous_Products_Tags]()
    public var strFamousProductsTags:String = ""
    public var strFamousProductsTagsWithComma:String = ""
    public var currency:String = ""
    public var timezone:String = ""
    public var delivryRadious:Double = 0.0
    public var isProvideDelivryAnywhere:Bool = true
    public var isUseItemTax:Bool = false
    var isProvidePickupDelivery:Bool!
    public var is_store_can_create_group : Bool?

    public var productItemNameList:[String] = []
    var is_taking_schedule_order :Bool = false
    var is_order_cancellation_charge_apply:Bool = false
    var  branch_io_url:String = ""
    public var langItems : Array<SettingDetailLang>?
    var store_delivery_time : [StoreTime] = []
    var is_store_set_schedule_delivery_time:Bool = false
     var schedule_order_create_after_minute:Double = 0.0
     var isUnFav:Bool = false
    var distance: Double = 0.0
    var isTaxInlcuded : Bool!
    var storeTaxDetails : [TaxesDetail]!
    var taxes : [String]!
    public var cancellation_charge_apply_from:Int!
    public var cancellation_charge_apply_till:Int!

    public var order_cancellation_charge_for_above_order_price:Double!
    public var order_cancellation_charge_type:Double!
    public var order_cancellation_charge_value:Double!
    public var isTableReservation:Bool!
    public var isTableReservationWithOrder:Bool!
    public var is_provide_table_booking:Bool!
    public var table_setting_details : StoreData?
    public var is_country_business : Bool?
    public var is_city_business : Bool?
    public var is_delivery_business : Bool?
    
    public var is_provide_delivery : Bool = false

    public class func modelsFromDictionaryArray(array:NSArray) -> [StoreItem] {
        var models:[StoreItem] = []
        for item in array {
            models.append(StoreItem(dictionary: item as! NSDictionary)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {
        let imageUrl =  (dictionary["image_url"] as? String) ?? ""
        delivryRadious = (dictionary["delivery_radius"] as? Double)?.roundTo() ?? 0.0
        isProvideDelivryAnywhere = (dictionary["is_provide_delivery_anywhere"] as? Bool) ?? true
		isUseItemTax = (dictionary["is_use_item_tax"] as? Bool) ?? false
        _id = dictionary["_id"] as? String
		unique_id = dictionary["unique_id"] as? Int
		updated_at = dictionary["updated_at"] as? String
		store_delivery_id = dictionary["store_delivery_id"] as? String
		name = dictionary["name"] as? String
		email = dictionary["email"] as? String
		password = dictionary["password"] as? String
		country_phone_code = dictionary["country_phone_code"] as? String
		website_url = (dictionary["website_url"] as? String) ?? ""
		slogan = (dictionary["slogan"] as? String) ?? ""
		country_id = dictionary["country_id"] as? String
		city_id = dictionary["city_id"] as? String
		phone = dictionary["phone"] as? String
		address = dictionary["address"] as? String
		fax_number = dictionary["fax_number"] as? String
		famous_for = (dictionary["famous_for"] as? String) ?? ""
		device_token = dictionary["device_token"] as? String
		server_token = dictionary["server_token"] as? String
		price_rating = dictionary["price_rating"] as? Int
		rate = (dictionary["user_rate"] as? Double)?.roundTo() ?? 0.00
		rate_count = dictionary["user_rate_count"] as? Int
		referral_code = dictionary["referral_code"] as? String
		referred_by = dictionary["referred_by"] as? String
		total_referrals = dictionary["total_referrals"] as? Int
		is_approved = dictionary["is_approved"] as? Bool
		is_business = dictionary["is_business"] as? Bool
        isStoreBusy = (dictionary["is_store_busy"] as? Bool) ?? false
		is_email_verified = dictionary["is_email_verified"] as? Bool
		is_phone_number_verified = dictionary["is_phone_number_verified"] as? Bool
        
        if let tags = dictionary["famous_products_tags"] as? [[String:Any]] {
            famousProductsTags.removeAll()
            for obj in tags {
                famousProductsTags.append(Famous_Products_Tags.init(dics: obj as NSDictionary))
            }
        }
        
        is_store_can_create_group = dictionary["is_store_can_create_group"] as? Bool

		is_document_uploaded = dictionary["is_document_uploaded"] as? Bool
        productItemNameList = (dictionary["items"] as? [String]) ?? []
        
		item_tax = (dictionary["item_tax"] as? Double)?.roundTo() ?? 0.0
        free_delivery_for_above_order_price =  (dictionary["free_delivery_for_above_order_price"]  as? Double)?.roundTo() ?? 0.0
        
		admin_profit_mode_on_store = dictionary["admin_profit_mode_on_store"] as? Int
		admin_profit_value_on_store = dictionary["admin_profit_value_on_store"] as? Int
		wallet = (dictionary["wallet"] as? Double)?.roundTo() ?? 0.00
        wallet_currency_code = dictionary["wallet_currency_code"] as? String
		__v = dictionary["__v"] as? Int
		created_at = dictionary["created_at"] as? String
        offer = (dictionary["offer"] as? String) ?? ""
		is_store_pay_delivery_fees = (dictionary["is_store_pay_delivery_fees"] as? Bool) ?? false
		is_referral = dictionary["is_referral"] as? Bool
        deliveryTime = (dictionary["delivery_time"] as? Int) ?? 0
        deliveryMaxTime = (dictionary["delivery_time_max"] as? Int) ?? 0
        maxItemQuantityAddByUser = (dictionary["max_item_quantity_add_by_user"] as? Int) ?? 0
        isProvidePickupDelivery =  (dictionary["is_provide_pickup_delivery"] as? Bool) ?? false
        isTableReservation = (dictionary["is_table_reservation"] as? Bool) ?? false
        isTableReservationWithOrder = (dictionary["is_table_reservation_with_order"] as? Bool) ?? false
        is_store_set_schedule_delivery_time =  (dictionary["is_store_set_schedule_delivery_time"] as? Bool) ?? false

		if (dictionary["store_time"] != nil) {
            self.store_time = StoreTime.modelsFromDictionaryArray(array: dictionary["store_time"] as! NSArray)
        }

        if (dictionary["store_delivery_time"] != nil) {
            self.store_delivery_time = StoreTime.modelsFromDictionaryArray(array: dictionary["store_delivery_time"] as! NSArray)
        }

        if preferenceHelper.getIsLoadStoreImage() {
                image_url = imageUrl
        } else {
            image_url = ""
        }

        if (dictionary["branchio_url"] != nil) {
            branch_io_url = (dictionary["branchio_url"] as? String) ?? ""
        }

        if (dictionary["languages_supported"] != nil) {
            langItems = SettingDetailLang.modelsFromDictionaryArray(array: dictionary["languages_supported"] as! NSArray)
        }

        if (dictionary["location"] != nil) {
            location = (dictionary["location"] as! NSArray) as? Array<Double>
        }

        if let countryDetail = dictionary["country_detail"] as? [String:Any] {
            currency = (countryDetail["currency_sign"] as? String) ?? ""
        }

        if (dictionary["languages_supported"] != nil) {
            langItems = SettingDetailLang.modelsFromDictionaryArray(array: dictionary["languages_supported"] as! NSArray)
        }

        if let cityDetail = dictionary["city_detail"] as? [String:Any] {
            timezone = (cityDetail["timezone"] as? String) ?? ""
        }

        is_taking_schedule_order = (dictionary[
        "is_taking_schedule_order"] as? Bool) ?? false
        is_order_cancellation_charge_apply = (dictionary[
            "is_order_cancellation_charge_apply"] as? Bool) ?? false
        
        schedule_order_create_after_minute = (dictionary["schedule_order_create_after_minute"] as? Double)?.roundTo() ?? 0.0
        distance = (dictionary["distance"] as? Double) ?? 0.0

        order_cancellation_charge_for_above_order_price = (dictionary["order_cancellation_charge_for_above_order_price"] as? Double) ?? 0.0
        order_cancellation_charge_type = (dictionary["order_cancellation_charge_type"] as? Double) ?? 0.0
        order_cancellation_charge_value = (dictionary["order_cancellation_charge_value"] as? Double) ?? 0.0

        isTaxInlcuded = dictionary["is_tax_included"] as? Bool ?? false
        storeTaxDetails = [TaxesDetail]()
        if let taxDetailsArray = dictionary["store_tax_details"] as? [[String:Any]]{
            for dic in taxDetailsArray{
                let value = TaxesDetail(fromDictionary: dic)
                storeTaxDetails.append(value)
            }
        } else{
            if let taxDetailsArray = dictionary["tax_details"] as? [[String:Any]]{
                for dic in taxDetailsArray{
                    let value = TaxesDetail(fromDictionary: dic)
                    storeTaxDetails.append(value)
                }
            }
        }

        taxes = dictionary["taxes"] as? [String]
        cancellation_charge_apply_from = (dictionary["cancellation_charge_apply_from"] as? Int) ?? 0
        cancellation_charge_apply_till = (dictionary["cancellation_charge_apply_till"] as? Int) ?? 0
        is_provide_table_booking = (dictionary["is_provide_table_booking"] as? Bool) ?? false
        is_country_business = (dictionary["is_country_business"] as? Bool) ?? false
        is_city_business = (dictionary["is_city_business"] as? Bool) ?? false
        is_delivery_business = (dictionary["is_delivery_business"] as? Bool) ?? false
        
        is_provide_delivery = (dictionary["is_provide_delivery"] as? Bool) ?? false

        if (dictionary["table_setting_details"] != nil) {
            if dictionary["table_setting_details"] is NSArray {
                let arr = dictionary["table_setting_details"] as! NSArray
                table_setting_details = StoreData(dictionary: arr[0] as! NSDictionary)
            } else if dictionary["table_setting_details"] is NSDictionary {
                table_setting_details = StoreData(dictionary: dictionary["table_setting_details"] as! NSDictionary)
            }
        }
	}
}

public class Famous_Products_Tags {
    public var tag : String = ""
    public var tag_id : String = ""
    
    init(dics: NSDictionary) {
        tag = dics["tag"] as? String ?? ""
        tag_id = dics["tag_id"] as? String ?? ""
    }
    
    public func dictionaryRepresentation() -> NSDictionary {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.tag, forKey: "tag")
        dictionary.setValue(self.tag_id, forKey: "tag_id")
        return dictionary
    }
}

