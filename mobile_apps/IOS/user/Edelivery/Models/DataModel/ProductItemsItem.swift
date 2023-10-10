import Foundation
public class ProductItemsItem {
	public var is_default : Bool?
	public var __v : Int?
	public var instruction : String?
	public var is_out_of_stock : Bool?
	public var is_item_in_stock : Bool?
	public var updated_at : String?
	public var _id : String?
	public var unique_id : Int?
	public var store_id : String?
	public var specifications : Array<Specifications>?
	public var name : String?
	public var total_item_price : Double?
	public var details : String?
	public var totalSpecificationPrice : Double!
	public var product_id : String?
	public var total_price : Double?
    public var tax : Double!
    public var item_tax : Double!
	public var no_of_order : Int?
	public var created_at : String?
    public var currency : String = ""

    public var price : Double!
	public var image_url : Array<String>?
    public var maxItemQuantity:Int = 10
    public var quantity:Int = 1
    public var isAdded:Bool = false
    var taxDetails : [TaxesDetail]!

    
    var itemPriceWithoutOffer:Double!
    var offerMessageOrPercentage:String!
    
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [ProductItemsItem] {
        var models:[ProductItemsItem] = []
        for item in array {
            models.append(ProductItemsItem(dictionary: item as! NSDictionary)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {
      
        itemPriceWithoutOffer = (dictionary["item_price_without_offer"] as? Double)?.roundTo() ?? 0.0
        offerMessageOrPercentage = (dictionary["offer_message_or_percentage"] as? String) ?? ""
		is_default = dictionary["is_default"] as? Bool
		__v = dictionary["__v"] as? Int
		instruction = dictionary["instruction"] as? String
		is_out_of_stock = dictionary["is_out_of_stock"] as? Bool
		is_item_in_stock = dictionary["is_item_in_stock"] as? Bool
		updated_at = dictionary["updated_at"] as? String
		_id = dictionary["_id"] as? String
		unique_id = dictionary["unique_id"] as? Int
		store_id = dictionary["store_id"] as? String
        
		if (dictionary["specifications"] != nil) {
            specifications = Specifications.modelsFromDictionaryArray(array: dictionary["specifications"] as! NSArray)
        }else{
            specifications = [Specifications]()
        }
        
        
		name = dictionary["name"] as? String
		total_item_price = (dictionary["total_item_price"] as? Double)?.roundTo() ?? 0.0
		details = (dictionary["details"] as? String) ?? ""
		totalSpecificationPrice = (dictionary["total_specification_price"] as? Double)?.roundTo() ?? 0.0
        tax = (dictionary["tax"] as? Double)?.roundTo() ?? 0.0
		product_id = dictionary["product_id"] as? String
		total_price = (dictionary["total_price"] as? Double)?.roundTo() ?? 0.00
		no_of_order = dictionary["no_of_order"] as? Int
		created_at = dictionary["created_at"] as? String
		price = (dictionary["price"] as? Double)?.roundTo() ?? 0.00
		maxItemQuantity = (dictionary["max_item_quantity"] as? Int) ?? 10
        currency = (dictionary["currency"] as? String) ?? ""
        
        item_tax = (dictionary["item_tax"] as? Double)?.roundTo() ?? 0.00
        
        if preferenceHelper.getIsLoadItemImage() {
            if  (dictionary["image_url"] != nil) {
                image_url = (dictionary["image_url"] as! NSArray) as? Array<String>
            }
        }else {
            image_url = []
        }
        
        taxDetails = [TaxesDetail]()
        if let taxDetailsArray = dictionary["tax_details"] as? [[String:Any]]{
            for dic in taxDetailsArray{
                let value = TaxesDetail(fromDictionary: dic)
                taxDetails.append(value)
            }
        }
    }

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

        dictionary.setValue(self.tax, forKey: "tax")
        dictionary.setValue(self.item_tax, forKey: "item_tax")
		dictionary.setValue(self.is_default, forKey: "is_default")
		dictionary.setValue(self.__v, forKey: "__v")
		dictionary.setValue(self.instruction, forKey: "instruction")
		dictionary.setValue(self.is_out_of_stock, forKey: "is_out_of_stock")
		dictionary.setValue(self.is_item_in_stock, forKey: "is_item_in_stock")
		dictionary.setValue(self.updated_at, forKey: "updated_at")
		dictionary.setValue(self._id, forKey: "_id")
		dictionary.setValue(self.unique_id, forKey: "unique_id")
		dictionary.setValue(self.store_id, forKey: "store_id")
		dictionary.setValue(self.name, forKey: "name")
		dictionary.setValue(self.total_item_price, forKey: "total_item_price")
		dictionary.setValue(self.details, forKey: "details")
		dictionary.setValue(self.totalSpecificationPrice, forKey: "total_specification_price")
		dictionary.setValue(self.product_id, forKey: "product_id")
		dictionary.setValue(self.total_price, forKey: "total_price")
		dictionary.setValue(self.no_of_order, forKey: "no_of_order")
		dictionary.setValue(self.created_at, forKey: "created_at")
		dictionary.setValue(self.price, forKey: "price")
        dictionary.setValue(self.currency, forKey: "currency")
		dictionary.setValue(self.itemPriceWithoutOffer, forKey: "item_price_without_offer")
        
        dictionary.setValue(self.offerMessageOrPercentage, forKey: "offer_message_or_percentage")
		dictionary.setValue(self.image_url, forKey: "image_url")
        var myArray:[Any] = []
        
        //Userapp
        for specification in self.specifications! {
            myArray.append(specification.dictionaryRepresentation())
        }
        
        if taxDetails != nil{
            var dictionaryElements = [[String:Any]]()
            for taxDetailsElement in taxDetails {
                dictionaryElements.append(taxDetailsElement.toDictionary())
            }
            dictionary["tax_details"] = dictionaryElements
        }
        dictionary.setValue(myArray, forKey: "specifications")
        dictionary.setValue(maxItemQuantity, forKey: "max_item_quatity")
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
