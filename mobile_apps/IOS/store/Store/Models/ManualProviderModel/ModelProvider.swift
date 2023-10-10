//
//	ModelProvider.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class ModelProvider : NSObject, NSCoding{

	var v : Int!
	var id : String!
	var accountId : String!
	var address : String!
	var adminType : Int!
	var appVersion : String!
	var bankId : String!
	var bearing : Int!
	var cityId : String!
	var comments : String!
	var countryId : String!
	var countryPhoneCode : String!
	var createdAt : String!
	var currentRequest : [AnyObject]!
	var customerId : String!
	var deviceToken : String!
	var deviceType : String!
	var email : String!
	var firstName : String!
	var imageUrl : String!
	var isActiveForJob : Bool!
	var isApproved : Bool!
	var isDocumentUploaded : Bool!
	var isEmailVerified : Bool!
	var isInDelivery : Bool!
	var isOnline : Bool!
	var isPhoneNumberVerified : Bool!
	var isProviderTypeApproved : Bool!
	var lastName : String!
	var location : [Float]!
	var locationUpdatedTime : String!
	var loginBy : String!
	var password : String!
	var paymentIntentId : String!
	var phone : String!
	var previousLocation : [Float]!
	var providerType : Int!
	var providerTypeId : AnyObject!
	var referralCode : String!
	var requests : [AnyObject]!
	var selectedVehicleId : String!
	var serverToken : String!
	var serviceId : [AnyObject]!
	var socialId : String!
	var socialIds : [AnyObject]!
	var startActiveJobTime : String!
	var startOnlineTime : String!
	var storeRate : Int!
	var storeRateCount : Int!
	var totalAcceptedRequests : Int!
	var totalActiveJobTime : Int!
	var totalCancelledRequests : Int!
	var totalCompletedRequests : Int!
	var totalOnlineTime : Int!
	var totalReferrals : Int!
	var totalRejectedRequests : Int!
	var totalRequests : Int!
	var uniqueId : Int!
	var updatedAt : String!
	var userRate : Int!
	var userRateCount : Int!
	var vehicleId : String!
	var vehicleIds : [String]!
	var vehicleModel : String!
	var vehicleNumber : String!
	var wallet : Int!
	var walletCurrencyCode : String!
    var isSelected : Bool!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		v = dictionary["__v"] as? Int
		id = dictionary["_id"] as? String
		accountId = dictionary["account_id"] as? String
		address = dictionary["address"] as? String
		adminType = dictionary["admin_type"] as? Int
		appVersion = dictionary["app_version"] as? String
		bankId = dictionary["bank_id"] as? String
		bearing = dictionary["bearing"] as? Int
		cityId = dictionary["city_id"] as? String
		comments = dictionary["comments"] as? String
		countryId = dictionary["country_id"] as? String
		countryPhoneCode = dictionary["country_phone_code"] as? String
		createdAt = dictionary["created_at"] as? String
		currentRequest = dictionary["current_request"] as? [AnyObject]
		customerId = dictionary["customer_id"] as? String
		deviceToken = dictionary["device_token"] as? String
		deviceType = dictionary["device_type"] as? String
		email = dictionary["email"] as? String
		firstName = dictionary["first_name"] as? String
		imageUrl = dictionary["image_url"] as? String
		isActiveForJob = dictionary["is_active_for_job"] as? Bool
		isApproved = dictionary["is_approved"] as? Bool
		isDocumentUploaded = dictionary["is_document_uploaded"] as? Bool
		isEmailVerified = dictionary["is_email_verified"] as? Bool
		isInDelivery = dictionary["is_in_delivery"] as? Bool
		isOnline = dictionary["is_online"] as? Bool
		isPhoneNumberVerified = dictionary["is_phone_number_verified"] as? Bool
		isProviderTypeApproved = dictionary["is_provider_type_approved"] as? Bool
		lastName = dictionary["last_name"] as? String
		location = dictionary["location"] as? [Float]
		locationUpdatedTime = dictionary["location_updated_time"] as? String
		loginBy = dictionary["login_by"] as? String
		password = dictionary["password"] as? String
		paymentIntentId = dictionary["payment_intent_id"] as? String
		phone = dictionary["phone"] as? String
		previousLocation = dictionary["previous_location"] as? [Float]
		providerType = dictionary["provider_type"] as? Int
		providerTypeId = dictionary["provider_type_id"] as? AnyObject
		referralCode = dictionary["referral_code"] as? String
		requests = dictionary["requests"] as? [AnyObject]
		selectedVehicleId = dictionary["selected_vehicle_id"] as? String
		serverToken = dictionary["server_token"] as? String
		serviceId = dictionary["service_id"] as? [AnyObject]
		socialId = dictionary["social_id"] as? String
		socialIds = dictionary["social_ids"] as? [AnyObject]
		startActiveJobTime = dictionary["start_active_job_time"] as? String
		startOnlineTime = dictionary["start_online_time"] as? String
		storeRate = dictionary["store_rate"] as? Int
		storeRateCount = dictionary["store_rate_count"] as? Int
		totalAcceptedRequests = dictionary["total_accepted_requests"] as? Int
		totalActiveJobTime = dictionary["total_active_job_time"] as? Int
		totalCancelledRequests = dictionary["total_cancelled_requests"] as? Int
		totalCompletedRequests = dictionary["total_completed_requests"] as? Int
		totalOnlineTime = dictionary["total_online_time"] as? Int
		totalReferrals = dictionary["total_referrals"] as? Int
		totalRejectedRequests = dictionary["total_rejected_requests"] as? Int
		totalRequests = dictionary["total_requests"] as? Int
		uniqueId = dictionary["unique_id"] as? Int
		updatedAt = dictionary["updated_at"] as? String
		userRate = dictionary["user_rate"] as? Int
		userRateCount = dictionary["user_rate_count"] as? Int
		vehicleId = dictionary["vehicle_id"] as? String
		vehicleIds = dictionary["vehicle_ids"] as? [String]
		vehicleModel = dictionary["vehicle_model"] as? String
		vehicleNumber = dictionary["vehicle_number"] as? String
		wallet = dictionary["wallet"] as? Int
		walletCurrencyCode = dictionary["wallet_currency_code"] as? String
        isSelected = false
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
		if accountId != nil{
			dictionary["account_id"] = accountId
		}
		if address != nil{
			dictionary["address"] = address
		}
		if adminType != nil{
			dictionary["admin_type"] = adminType
		}
		if appVersion != nil{
			dictionary["app_version"] = appVersion
		}
		if bankId != nil{
			dictionary["bank_id"] = bankId
		}
		if bearing != nil{
			dictionary["bearing"] = bearing
		}
		if cityId != nil{
			dictionary["city_id"] = cityId
		}
		if comments != nil{
			dictionary["comments"] = comments
		}
		if countryId != nil{
			dictionary["country_id"] = countryId
		}
		if countryPhoneCode != nil{
			dictionary["country_phone_code"] = countryPhoneCode
		}
		if createdAt != nil{
			dictionary["created_at"] = createdAt
		}
		if currentRequest != nil{
			dictionary["current_request"] = currentRequest
		}
		if customerId != nil{
			dictionary["customer_id"] = customerId
		}
		if deviceToken != nil{
			dictionary["device_token"] = deviceToken
		}
		if deviceType != nil{
			dictionary["device_type"] = deviceType
		}
		if email != nil{
			dictionary["email"] = email
		}
		if firstName != nil{
			dictionary["first_name"] = firstName
		}
		if imageUrl != nil{
			dictionary["image_url"] = imageUrl
		}
		if isActiveForJob != nil{
			dictionary["is_active_for_job"] = isActiveForJob
		}
		if isApproved != nil{
			dictionary["is_approved"] = isApproved
		}
		if isDocumentUploaded != nil{
			dictionary["is_document_uploaded"] = isDocumentUploaded
		}
		if isEmailVerified != nil{
			dictionary["is_email_verified"] = isEmailVerified
		}
		if isInDelivery != nil{
			dictionary["is_in_delivery"] = isInDelivery
		}
		if isOnline != nil{
			dictionary["is_online"] = isOnline
		}
		if isPhoneNumberVerified != nil{
			dictionary["is_phone_number_verified"] = isPhoneNumberVerified
		}
		if isProviderTypeApproved != nil{
			dictionary["is_provider_type_approved"] = isProviderTypeApproved
		}
		if lastName != nil{
			dictionary["last_name"] = lastName
		}
		if location != nil{
			dictionary["location"] = location
		}
		if locationUpdatedTime != nil{
			dictionary["location_updated_time"] = locationUpdatedTime
		}
		if loginBy != nil{
			dictionary["login_by"] = loginBy
		}
		if password != nil{
			dictionary["password"] = password
		}
		if paymentIntentId != nil{
			dictionary["payment_intent_id"] = paymentIntentId
		}
		if phone != nil{
			dictionary["phone"] = phone
		}
		if previousLocation != nil{
			dictionary["previous_location"] = previousLocation
		}
		if providerType != nil{
			dictionary["provider_type"] = providerType
		}
		if providerTypeId != nil{
			dictionary["provider_type_id"] = providerTypeId
		}
		if referralCode != nil{
			dictionary["referral_code"] = referralCode
		}
		if requests != nil{
			dictionary["requests"] = requests
		}
		if selectedVehicleId != nil{
			dictionary["selected_vehicle_id"] = selectedVehicleId
		}
		if serverToken != nil{
			dictionary["server_token"] = serverToken
		}
		if serviceId != nil{
			dictionary["service_id"] = serviceId
		}
		if socialId != nil{
			dictionary["social_id"] = socialId
		}
		if socialIds != nil{
			dictionary["social_ids"] = socialIds
		}
		if startActiveJobTime != nil{
			dictionary["start_active_job_time"] = startActiveJobTime
		}
		if startOnlineTime != nil{
			dictionary["start_online_time"] = startOnlineTime
		}
		if storeRate != nil{
			dictionary["store_rate"] = storeRate
		}
		if storeRateCount != nil{
			dictionary["store_rate_count"] = storeRateCount
		}
		if totalAcceptedRequests != nil{
			dictionary["total_accepted_requests"] = totalAcceptedRequests
		}
		if totalActiveJobTime != nil{
			dictionary["total_active_job_time"] = totalActiveJobTime
		}
		if totalCancelledRequests != nil{
			dictionary["total_cancelled_requests"] = totalCancelledRequests
		}
		if totalCompletedRequests != nil{
			dictionary["total_completed_requests"] = totalCompletedRequests
		}
		if totalOnlineTime != nil{
			dictionary["total_online_time"] = totalOnlineTime
		}
		if totalReferrals != nil{
			dictionary["total_referrals"] = totalReferrals
		}
		if totalRejectedRequests != nil{
			dictionary["total_rejected_requests"] = totalRejectedRequests
		}
		if totalRequests != nil{
			dictionary["total_requests"] = totalRequests
		}
		if uniqueId != nil{
			dictionary["unique_id"] = uniqueId
		}
		if updatedAt != nil{
			dictionary["updated_at"] = updatedAt
		}
		if userRate != nil{
			dictionary["user_rate"] = userRate
		}
		if userRateCount != nil{
			dictionary["user_rate_count"] = userRateCount
		}
		if vehicleId != nil{
			dictionary["vehicle_id"] = vehicleId
		}
		if vehicleIds != nil{
			dictionary["vehicle_ids"] = vehicleIds
		}
		if vehicleModel != nil{
			dictionary["vehicle_model"] = vehicleModel
		}
		if vehicleNumber != nil{
			dictionary["vehicle_number"] = vehicleNumber
		}
		if wallet != nil{
			dictionary["wallet"] = wallet
		}
		if walletCurrencyCode != nil{
			dictionary["wallet_currency_code"] = walletCurrencyCode
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         v = aDecoder.decodeObject(forKey: "__v") as? Int
         id = aDecoder.decodeObject(forKey: "_id") as? String
         accountId = aDecoder.decodeObject(forKey: "account_id") as? String
         address = aDecoder.decodeObject(forKey: "address") as? String
         adminType = aDecoder.decodeObject(forKey: "admin_type") as? Int
         appVersion = aDecoder.decodeObject(forKey: "app_version") as? String
         bankId = aDecoder.decodeObject(forKey: "bank_id") as? String
         bearing = aDecoder.decodeObject(forKey: "bearing") as? Int
         cityId = aDecoder.decodeObject(forKey: "city_id") as? String
         comments = aDecoder.decodeObject(forKey: "comments") as? String
         countryId = aDecoder.decodeObject(forKey: "country_id") as? String
         countryPhoneCode = aDecoder.decodeObject(forKey: "country_phone_code") as? String
         createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
         currentRequest = aDecoder.decodeObject(forKey: "current_request") as? [AnyObject]
         customerId = aDecoder.decodeObject(forKey: "customer_id") as? String
         deviceToken = aDecoder.decodeObject(forKey: "device_token") as? String
         deviceType = aDecoder.decodeObject(forKey: "device_type") as? String
         email = aDecoder.decodeObject(forKey: "email") as? String
         firstName = aDecoder.decodeObject(forKey: "first_name") as? String
         imageUrl = aDecoder.decodeObject(forKey: "image_url") as? String
         isActiveForJob = aDecoder.decodeObject(forKey: "is_active_for_job") as? Bool
         isApproved = aDecoder.decodeObject(forKey: "is_approved") as? Bool
         isDocumentUploaded = aDecoder.decodeObject(forKey: "is_document_uploaded") as? Bool
         isEmailVerified = aDecoder.decodeObject(forKey: "is_email_verified") as? Bool
         isInDelivery = aDecoder.decodeObject(forKey: "is_in_delivery") as? Bool
         isOnline = aDecoder.decodeObject(forKey: "is_online") as? Bool
         isPhoneNumberVerified = aDecoder.decodeObject(forKey: "is_phone_number_verified") as? Bool
         isProviderTypeApproved = aDecoder.decodeObject(forKey: "is_provider_type_approved") as? Bool
         lastName = aDecoder.decodeObject(forKey: "last_name") as? String
         location = aDecoder.decodeObject(forKey: "location") as? [Float]
         locationUpdatedTime = aDecoder.decodeObject(forKey: "location_updated_time") as? String
         loginBy = aDecoder.decodeObject(forKey: "login_by") as? String
         password = aDecoder.decodeObject(forKey: "password") as? String
         paymentIntentId = aDecoder.decodeObject(forKey: "payment_intent_id") as? String
         phone = aDecoder.decodeObject(forKey: "phone") as? String
         previousLocation = aDecoder.decodeObject(forKey: "previous_location") as? [Float]
         providerType = aDecoder.decodeObject(forKey: "provider_type") as? Int
         providerTypeId = aDecoder.decodeObject(forKey: "provider_type_id") as? AnyObject
         referralCode = aDecoder.decodeObject(forKey: "referral_code") as? String
         requests = aDecoder.decodeObject(forKey: "requests") as? [AnyObject]
         selectedVehicleId = aDecoder.decodeObject(forKey: "selected_vehicle_id") as? String
         serverToken = aDecoder.decodeObject(forKey: "server_token") as? String
         serviceId = aDecoder.decodeObject(forKey: "service_id") as? [AnyObject]
         socialId = aDecoder.decodeObject(forKey: "social_id") as? String
         socialIds = aDecoder.decodeObject(forKey: "social_ids") as? [AnyObject]
         startActiveJobTime = aDecoder.decodeObject(forKey: "start_active_job_time") as? String
         startOnlineTime = aDecoder.decodeObject(forKey: "start_online_time") as? String
         storeRate = aDecoder.decodeObject(forKey: "store_rate") as? Int
         storeRateCount = aDecoder.decodeObject(forKey: "store_rate_count") as? Int
         totalAcceptedRequests = aDecoder.decodeObject(forKey: "total_accepted_requests") as? Int
         totalActiveJobTime = aDecoder.decodeObject(forKey: "total_active_job_time") as? Int
         totalCancelledRequests = aDecoder.decodeObject(forKey: "total_cancelled_requests") as? Int
         totalCompletedRequests = aDecoder.decodeObject(forKey: "total_completed_requests") as? Int
         totalOnlineTime = aDecoder.decodeObject(forKey: "total_online_time") as? Int
         totalReferrals = aDecoder.decodeObject(forKey: "total_referrals") as? Int
         totalRejectedRequests = aDecoder.decodeObject(forKey: "total_rejected_requests") as? Int
         totalRequests = aDecoder.decodeObject(forKey: "total_requests") as? Int
         uniqueId = aDecoder.decodeObject(forKey: "unique_id") as? Int
         updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? String
         userRate = aDecoder.decodeObject(forKey: "user_rate") as? Int
         userRateCount = aDecoder.decodeObject(forKey: "user_rate_count") as? Int
         vehicleId = aDecoder.decodeObject(forKey: "vehicle_id") as? String
         vehicleIds = aDecoder.decodeObject(forKey: "vehicle_ids") as? [String]
         vehicleModel = aDecoder.decodeObject(forKey: "vehicle_model") as? String
         vehicleNumber = aDecoder.decodeObject(forKey: "vehicle_number") as? String
         wallet = aDecoder.decodeObject(forKey: "wallet") as? Int
         walletCurrencyCode = aDecoder.decodeObject(forKey: "wallet_currency_code") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if v != nil{
			aCoder.encode(v, forKey: "__v")
		}
		if id != nil{
			aCoder.encode(id, forKey: "_id")
		}
		if accountId != nil{
			aCoder.encode(accountId, forKey: "account_id")
		}
		if address != nil{
			aCoder.encode(address, forKey: "address")
		}
		if adminType != nil{
			aCoder.encode(adminType, forKey: "admin_type")
		}
		if appVersion != nil{
			aCoder.encode(appVersion, forKey: "app_version")
		}
		if bankId != nil{
			aCoder.encode(bankId, forKey: "bank_id")
		}
		if bearing != nil{
			aCoder.encode(bearing, forKey: "bearing")
		}
		if cityId != nil{
			aCoder.encode(cityId, forKey: "city_id")
		}
		if comments != nil{
			aCoder.encode(comments, forKey: "comments")
		}
		if countryId != nil{
			aCoder.encode(countryId, forKey: "country_id")
		}
		if countryPhoneCode != nil{
			aCoder.encode(countryPhoneCode, forKey: "country_phone_code")
		}
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "created_at")
		}
		if currentRequest != nil{
			aCoder.encode(currentRequest, forKey: "current_request")
		}
		if customerId != nil{
			aCoder.encode(customerId, forKey: "customer_id")
		}
		if deviceToken != nil{
			aCoder.encode(deviceToken, forKey: "device_token")
		}
		if deviceType != nil{
			aCoder.encode(deviceType, forKey: "device_type")
		}
		if email != nil{
			aCoder.encode(email, forKey: "email")
		}
		if firstName != nil{
			aCoder.encode(firstName, forKey: "first_name")
		}
		if imageUrl != nil{
			aCoder.encode(imageUrl, forKey: "image_url")
		}
		if isActiveForJob != nil{
			aCoder.encode(isActiveForJob, forKey: "is_active_for_job")
		}
		if isApproved != nil{
			aCoder.encode(isApproved, forKey: "is_approved")
		}
		if isDocumentUploaded != nil{
			aCoder.encode(isDocumentUploaded, forKey: "is_document_uploaded")
		}
		if isEmailVerified != nil{
			aCoder.encode(isEmailVerified, forKey: "is_email_verified")
		}
		if isInDelivery != nil{
			aCoder.encode(isInDelivery, forKey: "is_in_delivery")
		}
		if isOnline != nil{
			aCoder.encode(isOnline, forKey: "is_online")
		}
		if isPhoneNumberVerified != nil{
			aCoder.encode(isPhoneNumberVerified, forKey: "is_phone_number_verified")
		}
		if isProviderTypeApproved != nil{
			aCoder.encode(isProviderTypeApproved, forKey: "is_provider_type_approved")
		}
		if lastName != nil{
			aCoder.encode(lastName, forKey: "last_name")
		}
		if location != nil{
			aCoder.encode(location, forKey: "location")
		}
		if locationUpdatedTime != nil{
			aCoder.encode(locationUpdatedTime, forKey: "location_updated_time")
		}
		if loginBy != nil{
			aCoder.encode(loginBy, forKey: "login_by")
		}
		if password != nil{
			aCoder.encode(password, forKey: "password")
		}
		if paymentIntentId != nil{
			aCoder.encode(paymentIntentId, forKey: "payment_intent_id")
		}
		if phone != nil{
			aCoder.encode(phone, forKey: "phone")
		}
		if previousLocation != nil{
			aCoder.encode(previousLocation, forKey: "previous_location")
		}
		if providerType != nil{
			aCoder.encode(providerType, forKey: "provider_type")
		}
		if providerTypeId != nil{
			aCoder.encode(providerTypeId, forKey: "provider_type_id")
		}
		if referralCode != nil{
			aCoder.encode(referralCode, forKey: "referral_code")
		}
		if requests != nil{
			aCoder.encode(requests, forKey: "requests")
		}
		if selectedVehicleId != nil{
			aCoder.encode(selectedVehicleId, forKey: "selected_vehicle_id")
		}
		if serverToken != nil{
			aCoder.encode(serverToken, forKey: "server_token")
		}
		if serviceId != nil{
			aCoder.encode(serviceId, forKey: "service_id")
		}
		if socialId != nil{
			aCoder.encode(socialId, forKey: "social_id")
		}
		if socialIds != nil{
			aCoder.encode(socialIds, forKey: "social_ids")
		}
		if startActiveJobTime != nil{
			aCoder.encode(startActiveJobTime, forKey: "start_active_job_time")
		}
		if startOnlineTime != nil{
			aCoder.encode(startOnlineTime, forKey: "start_online_time")
		}
		if storeRate != nil{
			aCoder.encode(storeRate, forKey: "store_rate")
		}
		if storeRateCount != nil{
			aCoder.encode(storeRateCount, forKey: "store_rate_count")
		}
		if totalAcceptedRequests != nil{
			aCoder.encode(totalAcceptedRequests, forKey: "total_accepted_requests")
		}
		if totalActiveJobTime != nil{
			aCoder.encode(totalActiveJobTime, forKey: "total_active_job_time")
		}
		if totalCancelledRequests != nil{
			aCoder.encode(totalCancelledRequests, forKey: "total_cancelled_requests")
		}
		if totalCompletedRequests != nil{
			aCoder.encode(totalCompletedRequests, forKey: "total_completed_requests")
		}
		if totalOnlineTime != nil{
			aCoder.encode(totalOnlineTime, forKey: "total_online_time")
		}
		if totalReferrals != nil{
			aCoder.encode(totalReferrals, forKey: "total_referrals")
		}
		if totalRejectedRequests != nil{
			aCoder.encode(totalRejectedRequests, forKey: "total_rejected_requests")
		}
		if totalRequests != nil{
			aCoder.encode(totalRequests, forKey: "total_requests")
		}
		if uniqueId != nil{
			aCoder.encode(uniqueId, forKey: "unique_id")
		}
		if updatedAt != nil{
			aCoder.encode(updatedAt, forKey: "updated_at")
		}
		if userRate != nil{
			aCoder.encode(userRate, forKey: "user_rate")
		}
		if userRateCount != nil{
			aCoder.encode(userRateCount, forKey: "user_rate_count")
		}
		if vehicleId != nil{
			aCoder.encode(vehicleId, forKey: "vehicle_id")
		}
		if vehicleIds != nil{
			aCoder.encode(vehicleIds, forKey: "vehicle_ids")
		}
		if vehicleModel != nil{
			aCoder.encode(vehicleModel, forKey: "vehicle_model")
		}
		if vehicleNumber != nil{
			aCoder.encode(vehicleNumber, forKey: "vehicle_number")
		}
		if wallet != nil{
			aCoder.encode(wallet, forKey: "wallet")
		}
		if walletCurrencyCode != nil{
			aCoder.encode(walletCurrencyCode, forKey: "wallet_currency_code")
		}

	}

}
