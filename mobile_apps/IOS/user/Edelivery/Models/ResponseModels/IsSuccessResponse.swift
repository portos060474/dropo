//
//  IsSuccessResponse.swift
//  edelivery
//
//  Created by Elluminati on 22/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
public class IsSuccessResponse {
    public var success : Bool?
    public var message : Int?
    public var errorCode : Int?
    public var status_phrase : String = ""
    
    required public init?(dictionary: NSDictionary) {
        success = (dictionary["success"] as? Bool) ?? false
        
        if  success! {
            message =  (dictionary["message"] as? Int) ?? 0
        }else {
            errorCode = (dictionary["error_code"] as? Int) ?? 0
        }
        
        status_phrase = (dictionary["status_phrase"] as? String) ?? ""
    }
    
    public func dictionaryRepresentation() -> NSDictionary {
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.success, forKey: "success")
        if  success! {
            dictionary.setValue(self.message, forKey: "message")
            
        }else {
            dictionary.setValue(self.errorCode, forKey: "error_code")
        }
        
        dictionary.setValue(self.status_phrase, forKey: "status_phrase")
        
        return dictionary
    }

}
