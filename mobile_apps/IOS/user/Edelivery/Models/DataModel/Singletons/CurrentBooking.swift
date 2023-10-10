//
//  CurrentBooking.swift
//  edelivery
//
//  Created by Elluminati on 02/03/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import UIKit
/**
 * Created by Jaydeep on 13-Feb-17.
 */

public class CurrentBooking {
    static let shared = CurrentBooking()
    private init() {
        cart = [CartProduct].init()
        cartWithAllSpecification = [ProductItemsItem].init()
    }
    public var currentRunningOrder:Int = 0
    
    
    public var cartCurrency:String = ""
    public var currency:String = ""
    
    var selectedVehicleId:String = ""
    var courierDeliveryId:String = ""
    var isRoundTrip = false
    var courierNoOfStop = 0
    
    var courierImage:[UIImage] = []
    var courierPickupAddress:[Address] = []
    var courierDestinationAddress:[Address] = []
    var CartResponselangItems : Array<SettingDetailLang>?

    
    public var isHidePayNow:Bool = false
    public var isContactLessDelivery:Bool = false
    public var isAllowUserToGiveTip:Bool = false
    public var tip_type:Int = 0


    public var isAllowContactLessDelivery:Bool = false
    /*Future Request Date*/
    public var isFutureOrder:Bool = false
    
    /*Future Date millisecond as per Timezone*/
    public var futureDateMilliSecond:Int64 = 0
    public var futureDateMilliSecond2:Int64 = 0
    
    /*Future Date millisecond as per Timezone*/
    public var futureDateMilliSecondTable:Int64 = 0
    public var futureDateMilliSecondTable2:Int64 = 0

    /*Future Date millisecond as per UTC Timezone*/
    public var futureUTCMilliSecond:Int64 = 0
    public var futureUTCMilliSecond2:Int64 = 0

    public var currentDateMilliSecond:Int64 = 0
    public var currentServerTime:String = ""
    public var currentCountryCode:String = ""
    
    /*nearest DeliverStorelist in  selected city*/
    public var deliveryStoreList : [DeliveriesItem] = []
    public var deliveryAdsList : Array<AdItem>?
    public var isCashPaymentMode:Bool = false
    public var isOtherPaymentMode:Bool = false
    public var isPromoApply:Bool = false
    public var isPromoApplyForOther:Bool = false
    public var selectedCityTimezone:String = "Asia/Kolkata"
    
    public var PushNotification = false

    public var bookCityId:String?
    public var bookCountryId:String?
    public var currentCity:String?

    /*SelectedStoreDetails*/
    public var selectedStoreId:String?
    public var selectedStore:StoreItem?
    public var currentDateCompontent:DateComponents = DateComponents.init()
    public var isSelectedStoreClosed:Bool = false
    public var isStoreCreateGroup:Bool = false
    public var storeLatLng:[Double] = [0.0,0.0]
    public var isQrCodeScanBooking:Bool = false
    public var qrCodeUrl:String?
    
    /*Slected Order Detail*/
    
    public var selectedOrderId:String?
    public var orderPaymentId:String?
    public var deliveryName:String = ""
    public var deliveryContact:String = ""

    /*Cart Data*/
    public var cartId:String = ""
    public var isUserPickUpOrder:Bool = false
    public var cart:[CartProduct]
    public var cartWithAllSpecification:[ProductItemsItem]
    public var cartCityId:String = ""
    public var totalCartAmount:Double?
    public var totalCartAmountWithoutTax:Double?
    public var storeIdInCart:String?

    public var totalItemInCart:Int = 0

    public var deliveryAddress:String = ""
    public var currentAddress:String = ""
    public var currentLatLng :[Double] = [0.0,0.0]
    public var deliveryLatLng :[Double] = [0.0,0.0]

    public var favouriteStores:[String] = []
    var pickupAddress:[Address] = []
    var destinationAddress:[Address] = []
    var isCourier:Bool = false
    public var isUseItemTax:Bool = false
    public var isTaxIncluded:Bool = false
    public var StoreTaxDetails = [TaxesDetail]()

    public var currentPlaceData:CurrentPlaceData = CurrentPlaceData.init()
    public var currentSendPlaceData:CurrentPlaceData = CurrentPlaceData.init()
    public var selectedBranchIoStore:String = ""

    public var tableList:[Table_list] = []
    public var selectedTable:Table_list? = nil//Table_list(dictionary: NSDictionary())!
    public var table_no:Int = 0
    public var number_of_pepole:Int = 0
    public var bookingType:Int = 0
    public var deliveryType:Int = DeliveryType.store
    public var booking_fees:Double = 0.0
    public var tableBookingDate:String = ""
    public var tableBookingTime:String = ""
    public var tableID:String = ""

    public func checkTableBookingValidation() -> Bool {
        if !self.tableBookingDate.isEmpty() && !self.tableBookingTime.isEmpty() && self.selectedTable != nil {
            return true
        }
        return false
    }

    public func clearCart() {
        cart.removeAll()
        isSelectedStoreClosed = false
        selectedStoreId = ""
        totalCartAmount = 0.0
        totalCartAmountWithoutTax = 0.0
        totalItemInCart = 0
        deliveryLatLng =  currentLatLng
        deliveryAddress = currentAddress
        cartId = ""
        storeIdInCart = nil
        pickupAddress = []
        clearCourierCart()
        //clearTableBooking()
    }

    public func clearTableBooking() {
        selectedTable = nil//Table_list(dictionary: NSDictionary())!
        number_of_pepole = 0
        table_no = 0
        bookingType = 0
        booking_fees = 0.0
        if !currentBooking.isQrCodeScanBooking {
            deliveryType = DeliveryType.store
        }
        isFutureOrder = false
        futureUTCMilliSecond = 0
        futureUTCMilliSecond2 = 0
        futureDateMilliSecond = 0
        futureDateMilliSecond2 = 0
        tableBookingDate = ""
        tableBookingTime = ""
        tableList = []
    }

    public func clearBooking() {
        bookCityId = ""
        bookCountryId = ""
        currentCity = ""
        cartCurrency  = ""
        isCashPaymentMode = false
        isOtherPaymentMode = false
        isPromoApply = false
        isPromoApplyForOther = false
        isSelectedStoreClosed = false
        selectedStoreId =  ""
        deliveryAddress = ""
        deliveryLatLng = [0.0]
        storeLatLng = [0.0]
        totalCartAmount = 0.0
        totalCartAmountWithoutTax = 0.0
        currentRunningOrder = 0
        self.clearCart()
        orderPaymentId = ""
        totalItemInCart = 0
        currentAddress = ""
        selectedBranchIoStore = ""
        favouriteStores.removeAll()
        deliveryStoreList.removeAll()
        pickupAddress = []
        destinationAddress = []
        StoreTaxDetails.removeAll()
        clearTableBooking()
        isQrCodeScanBooking = false
        preferenceHelper.setIsQRUser(false)
        storeIdInCart = nil
    }

    public func clearCourierCart() {
        selectedVehicleId = ""
        courierImage = []
        courierPickupAddress = []
        courierDestinationAddress = []
        isCourier = false
    }
}

public class CurrentPlaceData {

    public var country:String = ""
    public var country_code:String = ""
    public var country_code_2:String = ""
    
    public var city1:String = ""
    public var city2:String = ""
    public var city3:String = ""
    public var city_code:String = ""
    
    public var latitude:Double = 0.0
    public var longitude:Double = 0.0
    public var address:String = ""
    public var title:String = ""
    
    public var flat_no:String = ""
    public var landmark:String = ""
    public var street:String = ""

    public init() {}
    
    func toDictionary() -> [String:Any] {
        var dictionary = [String:Any]()
        dictionary["server_token"] = preferenceHelper.getSessionToken()
        dictionary["user_id"] = preferenceHelper.getUserId()
        dictionary["city1"] = city1
        dictionary["city2"] = city2
        dictionary["city3"] = city3
        dictionary["country"] = country
        dictionary["country_code"] = country_code
        dictionary["country_code_2"] = country_code
        dictionary["latitude"] = latitude
        dictionary["longitude"] = longitude
        dictionary["city_code"] = city_code
        dictionary["address"] = address
        dictionary["title"] = title
        dictionary["flat_no"] = flat_no
        dictionary["landmark"] = landmark
        dictionary["street"] = street
        dictionary[PARAMS.IPHONE_ID] = preferenceHelper.getRandomCartID()
        
        return dictionary
    }
}


public class CurrencyHelper {
    static let shared = CurrencyHelper()
    public var myLocale:Locale = Locale.current
    public var currencyCode:String = "$"
    private init() {
       
    }
        
}
