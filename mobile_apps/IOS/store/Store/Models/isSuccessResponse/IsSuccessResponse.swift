//
//  IsSuccessResponse.swift
// Edelivery Store
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
        success = (dictionary["success"] as? Bool) ?? false
        if  success! {
            message = (dictionary["message"] as? Int) ?? 0
        }else {
           errorCode = (dictionary["error_code"] as? Int) ?? 0
        }
        status_phrase = (dictionary["status_phrase"] as? String) ?? ""
    }
}
