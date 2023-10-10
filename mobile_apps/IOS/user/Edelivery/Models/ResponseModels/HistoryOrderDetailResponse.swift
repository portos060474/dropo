
import Foundation


public class HistoryOrderDetailResponse {
	public var success : String?
	public var message : Int?
	public var store_detail : HistoryStoreDetail?
	public var user_detail : HistoryUserDetails?
	public var order_list : HistoryOrderList?
    public var orderPayment : OrderPayment?
     var cartDetail:CartDetail?
    public var payment: String?      
    public var currency: String?
    public var arrDateTime:[OrderStatusDetails] = []
    public var requestDetail : HistoryRequestDetail?
    public var date_time : [DateTime] = []

    public class func modelsFromDictionaryArray(array:NSArray) -> [HistoryOrderDetailResponse] {
        var models:[HistoryOrderDetailResponse] = []
        for item in array {
            models.append(HistoryOrderDetailResponse(dictionary: item as! NSDictionary)!)
        }
        return models
    }


	required public init?(dictionary: NSDictionary) {

		success = dictionary["success"] as? String
		message = dictionary["message"] as? Int
		if (dictionary["store_detail"] != nil) { store_detail = HistoryStoreDetail(dictionary: dictionary["store_detail"] as! NSDictionary) }
		if (dictionary["provider_detail"] != nil) { user_detail = HistoryUserDetails(dictionary: dictionary["provider_detail"] as! NSDictionary) }
		if (dictionary["order_list"] != nil) { order_list = HistoryOrderList(dictionary: dictionary["order_list"] as! NSDictionary)
        }
        payment = dictionary["payment_gateway_name"] as? String
        currency = (dictionary["currency"] as? String) ?? ""
        arrDateTime = []
        if let orderStatusDetail = dictionary["date_time"] as? [[String:Any]] {
            for dic in orderStatusDetail {
                let value = OrderStatusDetails(fromDictionary: dic)
                arrDateTime.append(value)
            }
        }
        if (dictionary["order_payment"] != nil) { orderPayment = OrderPayment(dictionary: dictionary["order_payment"] as! NSDictionary) }
        if (dictionary["cart_detail"] != nil) {
            cartDetail = CartDetail.init(fromDictionary: dictionary["cart_detail"] as! [String:Any])
        }
        
        if isNotNSNull(object: dictionary["request_detail"] as AnyObject){
                 if (dictionary["request_detail"] != nil) { requestDetail = HistoryRequestDetail.init(dictionary: dictionary["request_detail"] as! NSDictionary)
                    
            }
        }
        
        date_time.removeAll()
        if let dateTime = dictionary["date_time"] as? [[String:Any]] {
            for obj in dateTime {
                date_time.append(DateTime(dictionary: obj as NSDictionary))
            }
        }
	}

}
