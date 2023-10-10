//
//  CurrentBooking.swift
//  edelivery
//
//  Created by Elluminati on 02/03/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import CoreLocation

/**
 * Created by Jaydeep on 13-Feb-17.
 */

public class PaymentConfig {
    static let shared = PaymentConfig()
    private init() {
        paymentGateways = [PaymentGatewayItem].init()
    }
    public var paymentGateways:[PaymentGatewayItem]
    public var isUseWallet : Bool = false
    public var wallet : Double = 0.0
    public var total : Double = 0.0 /*Current Order Total Price*/
    public var walletCurrencyCode : String = ""
    public var paymentId:String = ""
    public func clearPaymentConfig() {
      
       paymentGateways.removeAll()
       isUseWallet = false
       walletCurrencyCode = ""
       wallet = 0.0
    }
}
public class SelectedFilterOptions {
    static let shared = SelectedFilterOptions()
    private init() {
        arrForPriceRate = [Int]()
    }
    public var arrForPriceRate:[Int]
    var arrForSelectedTags:[String] = []
    public var deliveryTime : Int = -1
    public var distanceValue : Int = -1
    
    
    public func clear() {
        arrForPriceRate.removeAll()
        arrForSelectedTags.removeAll()
        deliveryTime = -1
        distanceValue = -1
       
    }
}
public class UserSingleton {
    static let shared = UserSingleton()
    public var SendplaceData:CurrentPlaceData = CurrentPlaceData.init()

    var currentCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: 0.0, longitude: 0.0)
    var address : String = ""
    var city : String = ""
    var country : String = ""
    var title : String = ""

}
