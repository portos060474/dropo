
import Foundation


public class HistoryOrderDetailResponse {
    var currency : String!
    var message : Int!
    var paymentGatewayName : String!
    var request : Request!
    var storeDetail : HistoryStoreDetail!
    var success : Bool!
    var userDetail : HistoryUserDetails!
    
    var cartDetail : CartDetail!
    var orderDetail : OrderDetail!
    var orderPaymentDetail : OrderPayment!
    var provider_rating_to_user : Double!
    var provider_rating_to_store : Double!
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        currency = dictionary["currency"] as? String ?? ""
        
        message = dictionary["message"] as? Int
        paymentGatewayName = dictionary["payment_gateway_name"] as? String
        if let requestData = dictionary["request"] as? [String:Any]{
            request = Request(fromDictionary: requestData)
        }
        if let storeDetailData = dictionary["store_detail"] as? [String:Any]{
            storeDetail = HistoryStoreDetail(fromDictionary: storeDetailData)
        }
        success = dictionary["success"] as? Bool
        if let userDetailData = dictionary["user_detail"] as? [String:Any]{
            userDetail = HistoryUserDetails(fromDictionary: userDetailData)
        }
        //API CHANGES
//        if let cartDetailData = dictionary["cart_detail"] as? [String:Any]{
//                cartDetail = CartDetail(fromDictionary: cartDetailData)
//        }
        
        if let cartDetailData = dictionary["cart_data"] as? [String:Any]{
                cartDetail = CartDetail(fromDictionary: cartDetailData)
        }
        
        if let orderDetailData = dictionary["order_detail"] as? [String:Any]{
            orderDetail = OrderDetail(fromDictionary: orderDetailData)
        }
        
        if let orderPaymentDetailData = dictionary["order_payment"] as? [String:Any]{
            orderPaymentDetail = OrderPayment(dictionary: orderPaymentDetailData)
        }
        if let providerRatingToUser = dictionary["provider_rating_to_user"] as? Double {
            provider_rating_to_user = providerRatingToUser
        }
        if let providerRatingToUser = dictionary["provider_rating_to_user"] as? Int {
            provider_rating_to_user = Double.init(providerRatingToUser)
        }
        if let providerRatingToStore = dictionary["provider_rating_to_store"] as? Double {
            provider_rating_to_store = providerRatingToStore
        }
        if let providerRatingToStore = dictionary["provider_rating_to_store"] as? Int {
            provider_rating_to_store = Double.init(providerRatingToStore)
        }
    }
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
   /* func toDictionary() -> [String:Any] {
        var dictionary = [String:Any]()
        if currency != nil{
            dictionary["currency"] = currency
        }
        if message != nil{
            dictionary["message"] = message
        }
        if paymentGatewayName != nil{
            dictionary["payment_gateway_name"] = paymentGatewayName
        }
        if request != nil{
            dictionary["request"] = request.toDictionary()
        }
        if storeDetail != nil{
            dictionary["store_detail"] = storeDetail.toDictionary()
        }
        if success != nil{
            dictionary["success"] = success
        }
        if userDetail != nil{
            dictionary["user_detail"] = userDetail.toDictionary()
        }
        return dictionary
    }*/
}

public class DeliveryStatusDetails {
    var date : String!
    var status:Int!
    var imageUrl:String=""
    
    init(fromDictionary dictionary: [String:Any]) {
        date = (dictionary["date"] as? String) ?? ""
        status = (dictionary["status"] as? Int) ?? 0
        imageUrl = dictionary["image_url"] as? String ?? ""
    }
    
    func toDictionary() -> [String:Any] {
        var dictionary = [String:Any]()
        if date != nil{
            dictionary["date"] = date
        }
        if status != nil{
            dictionary["status"] = status
        }
        dictionary["image_url"] = imageUrl
        return dictionary
    }
}

class Request {
    var v : Int!
    var id : String!
    
    //API CHANGES //PROVIDER APPS
    //var cartDetail : CartDetail!
  //  var orderDetail : OrderDetail!
  //  var orderPaymentDetail : OrderPayment!
    
    var destinationAddresses : [Address]!

    var pickupAddresses : [Address]!
    var timezone : String!
    var createdAt:String!
    var completedAt:String!
    var uniqueID:Int!
    var deliveryStatus:Int = 0
    var deliveryType:Int = 0
    var arrStatusDetails = [DeliveryStatusDetails]()
   

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        v = dictionary["__v"] as? Int
        id = dictionary["_id"] as? String
         
        //API CHANGES
        /*if let cartDetailData = dictionary["cart_detail"] as? [String:Any]{
            cartDetail = CartDetail(fromDictionary: cartDetailData)
        }
        if let orderDetailData = dictionary["order_detail"] as? [String:Any]{
            orderDetail = OrderDetail(fromDictionary: orderDetailData)
        }

        if let orderPaymentDetailData = dictionary["order_payment_detail"] as? [String:Any]{
                orderPaymentDetail = OrderPayment(dictionary: orderPaymentDetailData)
        }*/
        
        createdAt = dictionary["created_at"] as? String
        completedAt = dictionary["completed_at"] as? String
        deliveryType = dictionary["delivery_type"] as? Int ?? 0
        
        destinationAddresses = [Address]()
        if let destinationAddressesArray = dictionary["destination_addresses"] as? [[String:Any]]{
            for dic in destinationAddressesArray{
                let value = Address(fromDictionary: dic)
                destinationAddresses.append(value)
            }
        }
       
        pickupAddresses = [Address]()
       
        if let pickupAddressesArray = dictionary["pickup_addresses"] as? [[String:Any]]{
            for dic in pickupAddressesArray{
                let value = Address(fromDictionary: dic)
                pickupAddresses.append(value)
            }
        }
        uniqueID = (dictionary["unique_id"] as? Int) ?? 0
        timezone = dictionary["timezone"] as? String
        arrStatusDetails = [DeliveryStatusDetails]()
        if let deliveryStatusDetail = dictionary["date_time"] as? [[String:Any]] {
            for dic in deliveryStatusDetail{
                let value = DeliveryStatusDetails(fromDictionary: dic)
                arrStatusDetails.append(value)
            }
        }
        //API changes
//        arrStatusDetails.append(contentsOf: orderDetail.arrStatusDetails)
        deliveryStatus = dictionary["delivery_status"] as? Int ?? 0
        
       
    }
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
  /*
    func toDictionary() -> [String:Any] {
        var dictionary = [String:Any]()
        if v != nil{
            dictionary["__v"] = v
        }
        if uniqueID != nil {
           dictionary["unique_id"] = uniqueID
        }
        if id != nil{
            dictionary["_id"] = id
        }
        if createdAt != nil{
             dictionary["created_at"] = createdAt
        }
        if completedAt != nil{
             dictionary["completed_at"] = completedAt
        }
        if cartDetail != nil{
            dictionary["cart_detail"] = cartDetail.toDictionary()
        }
        if destinationAddresses != nil{
            var dictionaryElements = [[String:Any]]()
            for destinationAddressesElement in destinationAddresses {
                dictionaryElements.append(destinationAddressesElement.toDictionary())
            }
            dictionary["destination_addresses"] = dictionaryElements
        }
        if orderPaymentDetail != nil{
            dictionary["order_payment_detail"] = orderPaymentDetail.dictionaryRepresentation()
        }
        if pickupAddresses != nil{
            var dictionaryElements = [[String:Any]]()
            for pickupAddressesElement in pickupAddresses {
                dictionaryElements.append(pickupAddressesElement.toDictionary())
            }
            dictionary["pickup_addresses"] = dictionaryElements
        }
        if timezone != nil{
            dictionary["timezone"] = timezone
        }
        return dictionary
    }*/
}

class CancelReasong{
    var cancelReason : String!
    var cancelledAt : String!
    var userType : Int!
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        cancelReason = dictionary["cancel_reason"] as? String
        cancelledAt = dictionary["cancelled_at"] as? String
        userType = dictionary["user_type"] as? Int
    }
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any] {
        var dictionary = [String:Any]()
        if cancelReason != nil{
            dictionary["cancel_reason"] = cancelReason
        }
        if cancelledAt != nil{
            dictionary["cancelled_at"] = cancelledAt
        }
      
        if userType != nil{
            dictionary["user_type"] = userType
        }
        return dictionary
    }
 }

class OrderDetail {
    var confirmationCodeForCompleteDelivery : Int!
    var confirmationCodeForPickUpDelivery : Int!
    var isProviderRatedToStore : Bool!
    var isProviderRatedToUser : Bool!
    var isScheduleOrder : Bool!
    var isScheduleOrderInformedToStore : Bool!
    var isStoreRatedToProvider : Bool!
    var isStoreRatedToUser : Bool!
    var isUserRatedToProvider : Bool!
    var isUserRatedToStore : Bool!
    var uniqueID:Int!
    var arrStatusDetails = [DeliveryStatusDetails]()
    var orderStatus:Int = 0
   
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        isProviderRatedToStore = dictionary["is_provider_rated_to_store"] as? Bool
        isProviderRatedToUser = dictionary["is_provider_rated_to_user"] as? Bool
        isScheduleOrder = dictionary["is_schedule_order"] as? Bool
        isScheduleOrderInformedToStore = dictionary["is_schedule_order_informed_to_store"] as? Bool
          uniqueID = (dictionary["unique_id"] as? Int) ?? 0
        isStoreRatedToProvider = dictionary["is_store_rated_to_provider"] as? Bool
        isStoreRatedToUser = dictionary["is_store_rated_to_user"] as? Bool
        isUserRatedToProvider = dictionary["is_user_rated_to_provider"] as? Bool
        isUserRatedToStore = dictionary["is_user_rated_to_store"] as? Bool
        arrStatusDetails = [DeliveryStatusDetails]()
        if let deliveryStatusDetail = dictionary["date_time"] as? [[String:Any]] {
            for dic in deliveryStatusDetail{
                let value = DeliveryStatusDetails(fromDictionary: dic)
                arrStatusDetails.append(value)
            }
        }
        orderStatus =  (dictionary["order_status"] as? Int) ?? 0
    }
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any] {
        var dictionary = [String:Any]()
        
        if isProviderRatedToStore != nil{
            dictionary["is_provider_rated_to_store"] = isProviderRatedToStore
        }
        if isProviderRatedToUser != nil{
            dictionary["is_provider_rated_to_user"] = isProviderRatedToUser
        }
        if isScheduleOrder != nil{
            dictionary["is_schedule_order"] = isScheduleOrder
        }
        if isScheduleOrderInformedToStore != nil{
            dictionary["is_schedule_order_informed_to_store"] = isScheduleOrderInformedToStore
        }
        if isStoreRatedToProvider != nil{
            dictionary["is_store_rated_to_provider"] = isStoreRatedToProvider
        }
        if isStoreRatedToUser != nil{
            dictionary["is_store_rated_to_user"] = isStoreRatedToUser
        }
        if isUserRatedToProvider != nil{
            dictionary["is_user_rated_to_provider"] = isUserRatedToProvider
        }
        if isUserRatedToStore != nil{
            dictionary["is_user_rated_to_store"] = isUserRatedToStore
        }
        if uniqueID != nil {
            dictionary["unique_id"] = uniqueID
        }
        
        return dictionary
    }
}
