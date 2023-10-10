//
//	ImageSetting.swift
//
//	Create by Elluminati iMac on 14/12/2017
//	Copyright © 2017. All rights reserved.


import Foundation

class ImageSetting{


	
    var iconImageType : [String]!
	var imageType : [String]!
	var itemImageMaxHeight : Int!
	var itemImageMaxWidth : Int!
	var itemImageMinHeight : Int!
	var itemImageMinWidth : Int!
	var itemImageRatio : Double!
	
    var productImageMaxHeight : Int!
	var productImageMaxWidth : Int!
	var productImageMinHeight : Int!
	var productImageMinWidth : Int!
	var productImageRatio : Double!
	
    
	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]) {
	    imageType = (dictionary["image_type"] as? [String]) ?? []
		
        itemImageMaxHeight = (dictionary["item_image_max_height"] as? Int) ?? 0
		itemImageMaxWidth = (dictionary["item_image_max_width"] as? Int) ?? 0
		itemImageMinHeight = (dictionary["item_image_min_height"] as? Int) ?? 0
		itemImageMinWidth = (dictionary["item_image_min_width"] as? Int) ?? 0
        itemImageRatio = (dictionary["item_image_ratio"] as? Double)?.roundTo() ?? 0.0
		
        productImageMaxHeight = (dictionary["product_image_max_height"] as? Int) ?? 0
		productImageMaxWidth = (dictionary["product_image_max_width"] as? Int) ?? 0
		productImageMinHeight = (dictionary["product_image_min_height"] as? Int) ?? 0
		productImageMinWidth = (dictionary["product_image_min_width"] as? Int) ?? 0
		productImageRatio = (dictionary["product_image_ratio"] as? Double)?.roundTo() ?? 0.0
    }

}
