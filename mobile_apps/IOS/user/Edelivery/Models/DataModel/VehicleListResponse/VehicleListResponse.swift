//
//	LanguageResponse.swift
//
//	Create by MacPro3 on 15/9/2018
//	Copyright © 2018. All rights reserved.

import Foundation

class VehicleListResponse{

	var success : Bool!
	var adminVehicles:[VehicleDetail]
    var vehicles:[VehicleDetail]
    
	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		success = dictionary["success"] as? Bool
        vehicles = [VehicleDetail]()
        if let vehicleArray = dictionary["vehicles"] as? [[String:Any]]{
            for dic in vehicleArray{
                let value = VehicleDetail(fromDictionary: dic)
                vehicles.append(value)
            }
        }
        
        adminVehicles = [VehicleDetail]()
        if let vehicleArray = dictionary["admin_vehicles"] as? [[String:Any]]{
            for dic in vehicleArray{
                let value = VehicleDetail(fromDictionary: dic)
                adminVehicles.append(value)
            }
        }

	}

}
