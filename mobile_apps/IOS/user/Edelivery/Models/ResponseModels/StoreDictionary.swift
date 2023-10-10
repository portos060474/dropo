//
//  StoreDictionary.swift
//  Edelivery
//
//  Created by Elluminati on 3/31/21.
//  Copyright © 2021 Elluminati. All rights reserved.
//

import Foundation

public class StoreDictionary {
    public var _id : String?
    public var results : Array<StoreItem>?
    public var count : Int?

    
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [StoreDictionary] {
        var models:[StoreDictionary] = []
        for item in array {
            models.append(StoreDictionary(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    required public init?(dictionary: NSDictionary) {
        _id = dictionary["_id"] as? String
        count = dictionary["count"] as? Int
        if (dictionary["results"] != nil) { results = StoreItem.modelsFromDictionaryArray(array: dictionary["results"] as! NSArray) }
        
    }

    public func dictionaryRepresentation() -> NSDictionary {

        let dictionary = NSMutableDictionary()

        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.results, forKey: "results")
        dictionary.setValue(self.count, forKey: "count")

        return dictionary
    }

}
