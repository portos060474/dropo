

import Foundation
 


public class Items {
	public var specifications : Array<Specifications>?
	public var total_specification_price : Int?
	public var details : String?
	public var item_price : Int?
	public var image_url : String?
	public var item_name : String?
	public var quantity : Int?
	public var unique_id : Int?
	public var item_id : String?
    public var totalItemPrice : Double?
    var taxDetails : [TaxesDetail]!

    public class func modelsFromDictionaryArray(array:NSArray) -> [Items] {
        var models:[Items] = []
        for item in array {
            models.append(Items(dictionary: item as! NSDictionary)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {

		if (dictionary["specifications"] != nil) { specifications = Specifications.modelsFromDictionaryArray(array: dictionary["specifications"] as! NSArray) }
		total_specification_price = dictionary["total_specification_price"] as? Int
		details = dictionary["details"] as? String
		item_price = dictionary["item_price"] as? Int
        
        
        
        if preferenceHelper.getIsLoadItemImage() {
            if  (dictionary["image_url"] != nil) {
                
                image_url = dictionary["image_url"] as? String
            }
            
        }else {
            image_url = ""
        }
       
		item_name = dictionary["item_name"] as? String
		quantity = dictionary["quantity"] as? Int
		unique_id = dictionary["unique_id"] as? Int
		item_id = dictionary["item_id"] as? String
        totalItemPrice = (dictionary["total_item_price"] as? Double)?.roundTo() ?? 0.00
        taxDetails = [TaxesDetail]()
        if let taxDetailsArray = dictionary["tax_details"] as? [[String:Any]]{
            for dic in taxDetailsArray{
                let value = TaxesDetail(fromDictionary: dic)
                taxDetails.append(value)
            }
        }
	}


	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.total_specification_price, forKey: "total_specification_price")
		dictionary.setValue(self.details, forKey: "details")
		dictionary.setValue(self.item_price, forKey: "item_price")
		dictionary.setValue(self.image_url, forKey: "image_url")
		dictionary.setValue(self.item_name, forKey: "item_name")
		dictionary.setValue(self.quantity, forKey: "quantity")
		dictionary.setValue(self.unique_id, forKey: "unique_id")
		dictionary.setValue(self.item_id, forKey: "item_id")
        dictionary.setValue(self.totalItemPrice, forKey: "total_item_price")
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
