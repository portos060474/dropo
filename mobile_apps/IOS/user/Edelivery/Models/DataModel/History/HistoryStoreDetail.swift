
import Foundation
 


public class HistoryStoreDetail {
	public var name : String?
	public var image_url : String?
    public var langItems : Array<SettingDetailLang>?
    var isTaxIncluded = false
    var isUseItemTax = false
    var storeTaxDetails = [TaxesDetail]()

    
   public class func modelsFromDictionaryArray(array:NSArray) -> [HistoryStoreDetail] {
        var models:[HistoryStoreDetail] = []
        for item in array {
            models.append(HistoryStoreDetail(dictionary: item as! NSDictionary)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {

		name = dictionary["name"] as? String
		image_url = dictionary["image_url"] as? String
        if (dictionary["languages_supported"] != nil) {
            langItems = SettingDetailLang.modelsFromDictionaryArray(array: dictionary["languages_supported"] as! NSArray)
        }

        if dictionary["is_tax_included"] != nil{
            isTaxIncluded = (dictionary["is_tax_included"] as? Bool ?? false)
        }
        if dictionary["is_use_item_tax"] != nil{
            isUseItemTax
                = (dictionary["is_use_item_tax"] as? Bool ?? false)
        }

        storeTaxDetails = [TaxesDetail]()
        if let taxDetailsArray = dictionary["store_taxes"] as? [[String:Any]]{
            for dic in taxDetailsArray{
                let value = TaxesDetail(fromDictionary: dic)
                storeTaxDetails.append(value)
            }
        }
	}

    public init?() {
    }
    
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.name, forKey: "name")
		dictionary.setValue(self.image_url, forKey: "image_url")
        if isTaxIncluded != nil{
            dictionary["is_tax_included"] = isTaxIncluded
        }
        if isUseItemTax != nil{
            dictionary["is_use_item_tax"] = isUseItemTax
        }

        if storeTaxDetails != nil{
            var dictionaryElements = [[String:Any]]()
            for taxDetailsElement in storeTaxDetails {
                dictionaryElements.append(taxDetailsElement.toDictionary())
            }
            dictionary["store_taxes"] = dictionaryElements
        }
		return dictionary
	}

}
