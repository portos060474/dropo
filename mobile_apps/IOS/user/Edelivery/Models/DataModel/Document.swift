
import Foundation
class Document {
    
    var v : Int!
    var id : String!
    var createdAt : String!
    var documentFor : Int!
    var documentId : String!
    var expiredDate : String!
    var imageUrl : String!
    
    var uniqueCode : String!
    var updatedAt : String!
    var userId:String!
    var documentDetails : DocumentDetail!
    var isDocumentUploaded : Bool!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        
     
        v = dictionary["__v"] as? Int
        id = dictionary["_id"] as? String
        createdAt = dictionary["created_at"] as? String
        documentFor = dictionary["document_for"] as? Int
        documentId = dictionary["document_id"] as? String
        expiredDate = dictionary["expired_date"] as? String ?? ""
        imageUrl = dictionary["image_url"] as? String
        uniqueCode = dictionary["unique_code"] as? String ?? ""
        updatedAt = dictionary["updated_at"] as? String
        userId = dictionary["user_id"] as? String
        
        if let documentDetailsData = dictionary["document_details"] as? [String:Any]{
            documentDetails = DocumentDetail(fromDictionary: documentDetailsData)
        }
    }
}

class DocumentDetail{
    
    var v : Int!
    var id : String!
    var countryId : String!
    var createdAt : String!
    var documentFor : Int!
    var documentName : String!
    var isExpiredDate : Bool!
    var isMandatory : Bool!
    var isShow : Bool!
    var isUniqueCode : Bool!
    var uniqueId : Int!
    var updatedAt : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        v = dictionary["__v"] as? Int
        id = dictionary["_id"] as? String
        countryId = dictionary["country_id"] as? String
        createdAt = dictionary["created_at"] as? String
        documentFor = dictionary["document_for"] as? Int
        documentName = dictionary["document_name"] as? String
        isExpiredDate = dictionary["is_expired_date"] as? Bool
        isMandatory = dictionary["is_mandatory"] as? Bool
        isShow = dictionary["is_show"] as? Bool
        isUniqueCode = dictionary["is_unique_code"] as? Bool
        uniqueId = dictionary["unique_id"] as? Int
        updatedAt = dictionary["updated_at"] as? String
    }
    
}
