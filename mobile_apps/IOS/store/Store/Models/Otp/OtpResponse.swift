//
//	OtpResponse.swift
//
//	Create by Jaydeep Vyas on 18/7/2017
//	Copyright © 2017 Elluminati. All rights reserved.


import Foundation

class OtpResponse{

	var message : Int!
	var otpForEmail : String!
	var otpForSms : String!
	var success : Bool!
    var otpID : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		message = dictionary["message"] as? Int
		otpForEmail = dictionary["otp_for_email"] as? String
		otpForSms = dictionary["otp_for_sms"] as? String
		success = dictionary["success"] as? Bool
        if dictionary["otp_id"] != nil{
            otpID = dictionary["otp_id"] as? String
        }else{
            otpID = ""
        }
	}

}
