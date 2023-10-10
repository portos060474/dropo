//
//  StoreSingleton.swift
// Edelivery Store
//
//  Created by Jaydeep Vyas on 02/03/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import CoreLocation
/**
 * Created by Jaydeep on 13-Feb-17.
 */

public class StoreSingleton {
    var store : Store!
    var subStore : SubStore!
    
    static let shared = StoreSingleton()
    var cart:[CartProduct]
    var updateOrder:UpdateOrder!
    var cartCityId:String = ""
    var totalCartAmount:Double?;
    var totalCartAmountWithoutTax:Double?;
    
    var totalItemInCart:Int = 0;
    var isFutureOrder:Bool = false
    /*Future Date millisecond as per Timezone*/
    var futureDateMilliSecond:Int64 = 0;
    /*Future Date millisecond as per UTC Timezone*/
    var futureUTCMilliSecond:Int64 = 0;
    var currentDateMilliSecond:Int64 = 0;
    var currentServerTime:String = "";
    var orderPaymentId:String = "";
    var totalInvoice:Double = 0.0;
    var currentCountryCode:String = ""
    var currentCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: 0.0, longitude: 0.0)
    
    public var deliveryAddress:String = "";
    public var deliveryLatLng :[Double] = [0.0,0.0];
    
    var pickpuAddress:[Address] = []
    var destinationAddress:[Address] = []
    
    var vehicalList:[VehicleDetail] = []
    var adminVehicalList:[VehicleDetail] = []
    
    private init() {
        cart = [CartProduct].init()
        updateOrder = UpdateOrder.init()
        store = Store.init(fromDictionary: [:])
        
    }
    public func clearCart() {
        cart.removeAll()
        totalCartAmount = 0.0
        totalCartAmountWithoutTax = 0.0
        totalItemInCart = 0
    }
    
    public func returnStringAccordingtoLanguage(arrStr:[String])-> String{
        if ConstantsLang.storeLanguages.count > 0{
            if arrStr.count > 0{
                if arrStr.count > ConstantsLang.StoreLanguageIndexSelected{
                    if arrStr[ConstantsLang.StoreLanguageIndexSelected].count <= 0{
                        return arrStr[0]
                    }else{
                        return arrStr[ConstantsLang.StoreLanguageIndexSelected]
                    }
                }else{
                    return arrStr[0]
                }
            }else{
                return ""
            }
        }else{
            if arrStr.count > ConstantsLang.AdminLanguageIndexSelected{
                if arrStr[ConstantsLang.AdminLanguageIndexSelected].count <= 0{
                    return arrStr[0]
                }else{
                    return arrStr[ConstantsLang.AdminLanguageIndexSelected]
                }
                
            }else{
                if arrStr.count > 0{
                    return arrStr[0]
                }else
                {
                    return ""
                }
            }
        }
    }
    
    public func returnStringAccordingtoAdminLanguage(arrStr:[String])-> String{
        if ConstantsLang.adminLanguages.count > 0{
            if arrStr.count > 0{
                if arrStr.count > ConstantsLang.AdminLanguageIndexSelected{
                    if arrStr[ConstantsLang.AdminLanguageIndexSelected].count <= 0{
                        return arrStr[0]
                    }else{
                        return arrStr[ConstantsLang.AdminLanguageIndexSelected]
                    }
                }else{
                    return arrStr[0]
                }
            }else{
                return ""
            }
        }else{
            return ""
        }
    }
    
    public func isNotNSNull(object:AnyObject) -> Bool {
        return object.classForCoder != NSNull.classForCoder()
    }
}

class AdminLanguage{
    
    //    var isVisible : Bool!
    var languageName : String!
    var languageCode:String!
    var displayName:String!
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        languageName = (dictionary["name"] as? String) ?? "English"
        languageCode = (dictionary["code"] as? String) ?? "en"
        displayName = (dictionary["display_name"] as? String) ?? "en"
    }
}

class StoreLanguage{
    
    var is_visible : Bool!
    var name : String!
    var code:String!
    var string_file_path:String!
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        
        name = (dictionary["name"] as? String) ?? "English"
        code = (dictionary["code"] as? String) ?? "en"
        string_file_path = (dictionary["string_file_path"] as? String) ?? ""
        if code ==  "en" && name.lowercased() == "English".lowercased(){
            is_visible = true
        }else{
            is_visible = (dictionary["is_visible"] as? Bool) ?? true
        }
        
    }
}


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

public class CurrencyHelper {
    static let shared = CurrencyHelper()
    public var myLocale:Locale = Locale.current
    public var currencyCode:String = "INR"
    private init() {
        
    }
    
}
