//
//	Vehicle.swift
//
//	Create by Elluminati iMac on 8/1/2018
//	Copyright © 2018. All rights reserved.


import Foundation


class Vehicle : NSObject{

	var v : Int!
	var id : String!
	var adminServiceId : String!
	var adminVehicleId : String!
	var createdAt : String!
	var isApproved : Bool!
	var isDocumentUploaded : Bool!
	var providerId : String!
	var providerUniqueId : Int!
	var serviceId : String!
	var uniqueId : Int!
	var updatedAt : String!
	var vehicleColor : String!
	var vehicleDetail : [VehicleDetail]!
	var vehicleId : String!
	var vehicleModel : String!
	var vehicleName : String!
	var vehiclePassingYear : Int!
	var vehiclePlateNo : String!
	var vehicleYear : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		v = dictionary["__v"] as? Int
		id = dictionary["_id"] as? String
		adminServiceId = dictionary["admin_service_id"] as? String
		adminVehicleId = dictionary["admin_vehicle_id"] as? String
		createdAt = dictionary["created_at"] as? String
		isApproved = dictionary["is_approved"] as? Bool
		isDocumentUploaded = dictionary["is_document_uploaded"] as? Bool
		providerId = dictionary["provider_id"] as? String
		providerUniqueId = dictionary["provider_unique_id"] as? Int
		serviceId = dictionary["service_id"] as? String
		uniqueId = dictionary["unique_id"] as? Int
		updatedAt = dictionary["updated_at"] as? String
		vehicleColor = dictionary["vehicle_color"] as? String
		vehicleDetail = [VehicleDetail]()
		if let vehicleDetailArray = dictionary["vehicle_detail"] as? [[String:Any]]{
			for dic in vehicleDetailArray{
				let value = VehicleDetail(fromDictionary: dic)
				vehicleDetail.append(value)
			}
		}
		vehicleId = dictionary["vehicle_id"] as? String
		vehicleModel = dictionary["vehicle_model"] as? String ?? ""
		vehicleName = dictionary["vehicle_name"] as? String ?? ""
		vehiclePassingYear = dictionary["vehicle_passing_year"] as? Int
		vehiclePlateNo = dictionary["vehicle_plate_no"] as? String ?? ""
		vehicleYear = dictionary["vehicle_year"] as? Int
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if v != nil{
			dictionary["__v"] = v
		}
		if id != nil{
			dictionary["_id"] = id
		}
		if adminServiceId != nil{
			dictionary["admin_service_id"] = adminServiceId
		}
		if adminVehicleId != nil{
			dictionary["admin_vehicle_id"] = adminVehicleId
		}
		if createdAt != nil{
			dictionary["created_at"] = createdAt
		}
		if isApproved != nil{
			dictionary["is_approved"] = isApproved
		}
		if isDocumentUploaded != nil{
			dictionary["is_document_uploaded"] = isDocumentUploaded
		}
		if providerId != nil{
			dictionary["provider_id"] = providerId
		}
		if providerUniqueId != nil{
			dictionary["provider_unique_id"] = providerUniqueId
		}
		if serviceId != nil{
			dictionary["service_id"] = serviceId
		}
		if uniqueId != nil{
			dictionary["unique_id"] = uniqueId
		}
		if updatedAt != nil{
			dictionary["updated_at"] = updatedAt
		}
		if vehicleColor != nil{
			dictionary["vehicle_color"] = vehicleColor
		}
		if vehicleDetail != nil{
			var dictionaryElements = [[String:Any]]()
			for vehicleDetailElement in vehicleDetail {
				dictionaryElements.append(vehicleDetailElement.toDictionary())
			}
			dictionary["vehicle_detail"] = dictionaryElements
		}
		if vehicleId != nil{
			dictionary["vehicle_id"] = vehicleId
		}
		if vehicleModel != nil{
			dictionary["vehicle_model"] = vehicleModel
		}
		if vehicleName != nil{
			dictionary["vehicle_name"] = vehicleName
		}
		if vehiclePassingYear != nil{
			dictionary["vehicle_passing_year"] = vehiclePassingYear
		}
		if vehiclePlateNo != nil{
			dictionary["vehicle_plate_no"] = vehiclePlateNo
		}
		if vehicleYear != nil{
			dictionary["vehicle_year"] = vehicleYear
		}
		return dictionary
	}


}
