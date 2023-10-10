import Foundation

class UpdateOrder {
    var orderId : String!
    var totalOrderPrice : Double!
    var totalCartPrice : Double! = 0.0
    var totalItemTax : Double! = 0.0
    var totalItemCount : Int!
    var serverItems:[OrderItem] = []
    var orderDetails : [OrderDetail] = []
    var isUseItemTaxNew:Bool = false
    var isTaxIncludedNew:Bool = false
    
    var isUseItemTaxOld:Bool = false
    var isTaxIncludedOld:Bool = false
    
    var totalCartAmountWithoutTax:Double?;
    var storeTaxDetailsOld = [TaxesDetail]()
    var storeTaxDetailsNew = [TaxesDetail]()

    
    init() {
        orderId = ""
        orderDetails = []
        totalOrderPrice = 0.0
        totalItemTax = 0.0
        totalCartPrice = 0.0
        totalItemCount = 0
        storeTaxDetailsOld = []
        storeTaxDetailsNew = []
        totalCartAmountWithoutTax = 0.0
    }
    func toDictionary() -> [String:Any] {
        
        var dictionary :[String:Any] = [:];
        dictionary[PARAMS.STORE_ID] = preferenceHelper.getUserId()
        dictionary[PARAMS.SERVER_TOKEN] = preferenceHelper.getSessionToken()
        dictionary[PARAMS.TOTAL_CART_PRICE] = self.totalOrderPrice
        
        var dictionaryElements = [[String:Any]]()
        for orderDetailsElement in orderDetails {
            dictionaryElements.append(orderDetailsElement.toDictionary(isPassArray: false))
        }
        
        dictionary["order_details"] = dictionaryElements
        dictionary["order_id"] = orderId
        dictionary[PARAMS.TOTAL_ITEM_COUNT] = totalItemCount
        dictionary[PARAMS.TOTAL_CART_PRICE] = self.totalCartPrice
        dictionary["total_item_tax"] = self.totalItemTax
        dictionary[PARAMS.TOTAL_CART_AMOUNT_WITHOUT_TAX] = self.totalCartAmountWithoutTax
        
        return dictionary
    }
}
