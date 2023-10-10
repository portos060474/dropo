import Foundation

public class DeliveryStoreResponse {
	public var success : Bool?
	public var message : Int?
	public var city : City?
    public var cityData: CityData?
	public var server_time : String?
    public var currency : String?
    public var ads:[AdItem] = []
    public var deliveries : [DeliveriesItem] = []
    public var store_detail : Store_detail?
    public var isAllowContactlessDelivery:Bool = false

    public class func modelsFromDictionaryArray(array:NSArray) -> [DeliveryStoreResponse] {
        var models:[DeliveryStoreResponse] = []
        for item in array {
            models.append(DeliveryStoreResponse(dictionary: item as! NSDictionary)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {
		success = dictionary["success"] as? Bool
		message = dictionary["message"] as? Int
        isAllowContactlessDelivery = dictionary["is_allow_contactless_delivery"] as? Bool ?? false
		if (dictionary["city"] != nil) { city = City(dictionary: dictionary["city"] as! NSDictionary) }
		server_time = dictionary["server_time"] as? String
        currency = dictionary["currency_sign"] as? String
        if (dictionary["city_data"] != nil) {
            cityData = CityData.init(fromDictionary:dictionary["city_data"] as! [String:Any])
        }
        if let adsArray =  dictionary[ "ads"] as? [[String:Any]] {
            for item in adsArray {
                let adItem:AdItem = AdItem.init(fromDictionary: item)
                self.ads.append(adItem)
            }
        }
        if (dictionary["deliveries"] != nil) {
            deliveries = DeliveriesItem.modelsFromDictionaryArray(array: dictionary["deliveries"] as! NSArray)
        }
	}

	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.success, forKey: "success")
		dictionary.setValue(self.message, forKey: "message")
		dictionary.setValue(self.city?.dictionaryRepresentation(), forKey: "city")
		dictionary.setValue(self.server_time, forKey: "server_time")
        dictionary.setValue(self.currency, forKey: "currency_sign")
        


		return dictionary
	}

}
