

import Foundation
public class AvailableOrderCellData {
	var orderNumber : String!
    var requestNumber : String!
	var userName : String!
    var userImage : String!
	var storeName :String!
    var storeImage :String!
	var sourceAddress : String!
	var destinationAddress : String!
    var arrAddress = [Address]()
	var status : OrderStatus!
    var date:String!
    var deliveryType: Int!
    var estimated_time_for_ready_order:String!
    var isAllowContactlessDelivery : Bool!
}
