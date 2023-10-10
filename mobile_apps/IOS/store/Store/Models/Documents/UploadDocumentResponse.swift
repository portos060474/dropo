//
//	UploadDocumentResponse.swift
//
//	Create by Jaydeep Vyas on 22/7/2017
//	Copyright © 2017 Elluminati. All rights reserved.


import Foundation

class UploadDocumentResponse{

    var expiredDate : String!
    var imageUrl : String!
    var isDocumentUploaded : Bool!
    var message : Int!
    var success : Bool!
    var uniqueCode : String!
    
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        expiredDate = dictionary["expired_date"] as? String
        imageUrl = dictionary["image_url"] as? String
        isDocumentUploaded = dictionary["is_document_uploaded"] as? Bool
        message = dictionary["message"] as? Int
        success = dictionary["success"] as? Bool
        uniqueCode = dictionary["unique_code"] as? String
    }

}
