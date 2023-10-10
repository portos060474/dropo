//
//	Date.swift
//
//	Create by Jaydeep Vyas on 8/8/2017
//	Copyright © 2017 Elluminati. All rights reserved.


import Foundation
class OrderDate{
    
    var date1 : String!
    var date2 : String!
    var date3 : String!
    var date4 : String!
    var date5 : String!
    var date6 : String!
    var date7 : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        date1 = dictionary["date1"] as? String
        date2 = dictionary["date2"] as? String
        date3 = dictionary["date3"] as? String
        date4 = dictionary["date4"] as? String
        date5 = dictionary["date5"] as? String
        date6 = dictionary["date6"] as? String
        date7 = dictionary["date7"] as? String
    }
    
}
