import Foundation
public class Earning {
    public var sectionTitle:String?
    public var title:String?
    public var price:String?
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [Earning] {
        var models:[Earning] = []
        for _ in array {
            models.append(Earning(sectionTitle:"",title:"",price:"0.00"))
        }
        return models
    }
    
    required public init!(sectionTitle:String = "",title:String = "",price:String = "0.00") {
        
        self.sectionTitle = sectionTitle
        self.title = title
        self.price = price
        
    }
    public func toDictionary() -> [String:Any] {
        
        var dictionary : [String :Any] = [:]
        if self.sectionTitle != nil {
            dictionary["sectionTitle"] =  self.sectionTitle
        }
        if self.title != nil {
            dictionary["title"] =  self.title
        }
        if self.price != nil {
            dictionary["price"] =  self.price
        }
        return dictionary
    }
}
