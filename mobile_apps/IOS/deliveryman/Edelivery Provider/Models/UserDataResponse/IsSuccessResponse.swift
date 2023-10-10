//
//  IsSuccessResponse.swift
//  edelivery
//
//  Created by tag on 22/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
public class IsSuccessResponse {
    public var success : Bool?
    public var message : Int?
    public var errorCode : Int?
    public var status_phrase : String = ""
    
    required public init?(dictionary: [String:Any]) {
        success = dictionary["success"] as? Bool
        if  success! {
            message = dictionary["message"] as? Int
        }else {
            errorCode = dictionary["error_code"] as? Int
        }
        status_phrase = dictionary["status_phrase"] as? String ?? ""
    }
    
    public func dictionaryRepresentation() -> [String:Any] {
        var dictionary:[String:Any] = [:]
        dictionary["success"] = self.success
        
        if  success! {
            dictionary["message"] = self.message
            
        }else {
            dictionary["error_code"] = self.errorCode
        }
        
        dictionary["status_phrase"] = self.status_phrase
        
        return dictionary
    }
}
