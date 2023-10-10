//
//	ImageSettingResponse.swift
//
//	Create by Elluminati iMac on 14/12/2017
//	Copyright © 2017. All rights reserved.


import Foundation

class ImageSettingResponse{

	var imageSetting : ImageSetting!
	var message : Int!
	var success : Bool!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		if let imageSettingData = dictionary["image_setting"] as? [String:Any]{
			imageSetting = ImageSetting(fromDictionary: imageSettingData)
		}
		message = dictionary["message"] as? Int
		success = dictionary["success"] as? Bool
	}

}
