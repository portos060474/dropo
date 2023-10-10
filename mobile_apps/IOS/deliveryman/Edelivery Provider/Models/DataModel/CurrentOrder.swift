//
//  CurrentBooking.swift
//  edelivery
//
//  Created by Elluminati on 02/03/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
/**
 * Created by Jaydeep on 13-Feb-17.
 */

public class CurrentOrder {
    static let shared = CurrentOrder()
    private init() {
       
        
    }
    public var providerType : Int = 0
    public var availableOrders:Int = 0;
    public var currency:String = "$";
    public var orderID:String = ""
    public var mapPinUrl:String = ""
    public var currentLatitude:Double = 0.0
    public var currentLongitude:Double = 0.0
    public var bearing:Double = 0.0
    weak public var timerAcceptReject:Timer? = nil
    public func clearOrder() {
       availableOrders = 0
       currency = ""
       orderID = ""
    }
}

public class CurrencyHelper {
    static let shared = CurrencyHelper()
    public var myLocale:Locale = Locale.current
    public var currencyCode:String = "$"
    private init() {
        
    }
}

