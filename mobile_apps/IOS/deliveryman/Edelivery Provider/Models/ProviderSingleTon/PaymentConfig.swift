//
//  SocketHelper.swift
//  Edelivery Provider
//
//  Created by Jaydeep on 22/09/17.
//  Copyright © 2017 Elluminati iMac. All rights reserved.
//

import Foundation


public class PaymentConfig {
    static let shared = PaymentConfig()
    private init() {
        paymentGateways = [PaymentGatewayItem].init()
    }
    var paymentGateways:[PaymentGatewayItem]
    var isUseWallet : Bool = false
    var wallet : Double?
    var total : Double? /*Current Order Total Price*/
    var walletCurrencyCode : String?
    var paymentId:String?
    func clearPaymentConfig() {
        
        paymentGateways.removeAll()
        isUseWallet = false
        walletCurrencyCode = ""
        wallet = 0.0
    }
}

