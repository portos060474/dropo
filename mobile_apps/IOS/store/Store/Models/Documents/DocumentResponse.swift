//
//	DocumentResponse.swift
//
//	Create by Jaydeep Vyas on 22/7/2017
//	Copyright © 2017 Elluminati. All rights reserved.


import Foundation

class DocumentResponse{

	var documents : [Document]!
	var isDocumentUploaded : Bool!
	var message : Int!
	var success : Bool!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		documents = [Document]()
		if let documentsArray = dictionary["documents"] as? [[String:Any]]{
			for dic in documentsArray{
				let value = Document(fromDictionary: dic)
				documents.append(value)
			}
		}
		isDocumentUploaded = dictionary["is_document_uploaded"] as? Bool
		message = dictionary["message"] as? Int
		success = dictionary["success"] as? Bool
	}

}
