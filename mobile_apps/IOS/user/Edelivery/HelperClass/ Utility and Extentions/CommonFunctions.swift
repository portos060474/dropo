//
//  CommonFunctions.swift
//  Edelivery
//
//  Created by Trusha on 02/11/20.
//  Copyright © 2020 Elluminati. All rights reserved.
//

import Foundation

class CommonFunctions: NSObject {
    
    class func addLocationToLocalDB(){
            APPDELEGATE.clearDeliveryLocationEntity()
            APPDELEGATE.addDeliveryLocationToDb(country: currentBooking.currentSendPlaceData.country, city: currentBooking.currentSendPlaceData.city1, address: currentBooking.currentSendPlaceData.address, country_code: currentBooking.currentSendPlaceData.country_code, lat: currentBooking.currentSendPlaceData.latitude.toString(decimalPlaced: 6), long: currentBooking.currentSendPlaceData.longitude.toString(decimalPlaced: 6))
    }
    
    class func fetchLocationFromDB(vc: AnyObject) -> Bool{
        let arr = APPDELEGATE.fetchDeliveryLocationFromDB()
        if arr.count > 0{
            if arr[0].count > 0{
                currentBooking.currentAddress = arr[0]["address"] as! String
                let lat = Double(arr[0]["latitude"] as! String)
                let long = Double(arr[0]["longitude"] as! String)
                currentBooking.currentLatLng = [(lat ?? 0.0),
                                                (long ?? 0.0)]
                currentBooking.currentSendPlaceData.address = currentBooking.currentAddress
                currentBooking.currentSendPlaceData.latitude = currentBooking.currentLatLng[0]
                currentBooking.currentSendPlaceData.longitude = currentBooking.currentLatLng[1]
                currentBooking.currentSendPlaceData.country_code = arr[0]["country_code"] as! String
                currentBooking.currentSendPlaceData.country = arr[0]["country"] as! String
                currentBooking.currentPlaceData.address = currentBooking.currentAddress
                currentBooking.currentPlaceData.latitude = currentBooking.currentLatLng[0]
                currentBooking.currentPlaceData.longitude = currentBooking.currentLatLng[1]
                currentBooking.currentPlaceData.country_code = arr[0]["country_code"] as! String
                currentBooking.currentPlaceData.country = arr[0]["country"] as! String
                
                
                let dictionary: [String:Any] = currentBooking.currentSendPlaceData.toDictionary()
                           print("wsGetDeliveriesInNearestCity Homevc : \(dictionary)")

                (vc as? HomeVC)?.wsGetDeliveriesInNearestCity(parameter: dictionary)
                
               if ((vc as? HomeVC)?.parent as? MainVC)?.cvForHome.isHidden == false{
                    ((vc as? HomeVC)?.parent as? MainVC)?.updateTitle()
                }
                return true
            }
        }else{
        
            return false
        }
        return false
    }
}
