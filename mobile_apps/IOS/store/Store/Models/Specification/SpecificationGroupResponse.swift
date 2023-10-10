//
//	SpecificationGroupResponse.swift
//
//	Create by Jaydeep Vyas on 27/7/2017
//	Copyright © 2017 Elluminati. All rights reserved.


import Foundation

class SpecificationGroupResponse{

	var message : Int!
	var specificationGroup : [SpecificationGroup]!
	var success : Bool!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		message = dictionary["message"] as? Int
		specificationGroup = [SpecificationGroup]()
		if let specificationGroupArray = dictionary["specification_group"] as? [[String:Any]]{
			for dic in specificationGroupArray{
				let value = SpecificationGroup(fromDictionary: dic)
				specificationGroup.append(value)
			}
		}
		success = dictionary["success"] as? Bool
	}

}

class SpecificationGroupAddItemResponse{
    
    var message : Int!
    var specificationGroup : [ItemSpecification]!
    var success : Bool!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        message = dictionary["message"] as? Int
        specificationGroup = [ItemSpecification]()
        if let specificationGroupArray = dictionary["specification_group"] as? [[String:Any]]{
            for dic in specificationGroupArray{
                let value = ItemSpecification(fromDictionary: dic)
                specificationGroup.append(value)
            }
        }
        success = dictionary["success"] as? Bool
    }
    
}
