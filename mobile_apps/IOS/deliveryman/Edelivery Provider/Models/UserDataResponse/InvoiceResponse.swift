

import Foundation
 
public class InvoiceResponse {
	public var success : String?
	public var message : Int?
	public var order_id : String?
	public var order_status : Int?
	public var payment_gateway_name : String?
	public var currency : String?
	public var order_payment : OrderPayment?


    public class func modelsFromDictionaryArray(array:NSArray) -> [InvoiceResponse] {
        var models:[InvoiceResponse] = []
        for item in array {
            models.append(InvoiceResponse(dictionary: item as! [String:Any])!)
        }
        return models
    }

	required public init?(dictionary: [String:Any]) {

		success = dictionary["success"] as? String
		message = dictionary["message"] as? Int
		order_id = dictionary["order_id"] as? String
		order_status = dictionary["order_status"] as? Int
		payment_gateway_name = dictionary["payment_gateway_name"] as? String
		currency = dictionary["currency"] as? String
		if (dictionary["order_payment"] != nil) { order_payment = OrderPayment(dictionary: dictionary["order_payment"] as! [String:Any]) }
	}


	public func dictionaryRepresentation() -> [String:Any] {

		 var dictionary:[String:Any] = [:]
        dictionary["success"] = self.success
        dictionary["message"] = self.message
        dictionary["order_id"] = self.order_id
        dictionary["order_status"] = self.order_status
        dictionary["payment_gateway_name"] = self.payment_gateway_name
        dictionary["currency"] = self.currency
        dictionary["order_payment"] = self.order_payment?.dictionaryRepresentation()
       
		return dictionary
	}

}
