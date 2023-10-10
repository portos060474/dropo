//
//	SubStore.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class SubStore{

	var v : Int!
	var id : String!
	var countryPhoneCode : String!
	var createdAt : String!
	var deviceToken : String!
	var deviceType : String!
	var email : String!
	var isApproved : Bool!
	var mainStoreId : String!
	var name : [String]!
	var password : String!
	var phone : String!
	var serverToken : String!
	var uniqueId : Int!
	var updatedAt : String!
	var urls : [SubStoreUrl]!

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		v = dictionary["__v"] as? Int
		id = dictionary["_id"] as? String
		countryPhoneCode = dictionary["country_phone_code"] as? String
		createdAt = dictionary["created_at"] as? String
		deviceToken = dictionary["device_token"] as? String
		deviceType = dictionary["device_type"] as? String
		email = dictionary["email"] as? String
		isApproved = dictionary["is_approved"] as? Bool
		mainStoreId = dictionary["main_store_id"] as? String
		name = dictionary["name"] as? [String]
		password = dictionary["password"] as? String
		phone = dictionary["phone"] as? String
		serverToken = dictionary["server_token"] as? String
		uniqueId = dictionary["unique_id"] as? Int
		updatedAt = dictionary["updated_at"] as? String
		urls = [SubStoreUrl]()
		if let urlsArray = dictionary["urls"] as? [[String:Any]]{
			for dic in urlsArray{
				let value = SubStoreUrl(fromDictionary: dic)
				urls.append(value)
			}
		}
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
		if countryPhoneCode != nil{
			dictionary["country_phone_code"] = countryPhoneCode
		}
		if createdAt != nil{
			dictionary["created_at"] = createdAt
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
		if isApproved != nil{
			dictionary["is_approved"] = isApproved
		}
		if mainStoreId != nil{
			dictionary["main_store_id"] = mainStoreId
		}
		if name != nil{
			dictionary["name"] = name
		}
		if password != nil{
			dictionary["password"] = password
		}
		if phone != nil{
			dictionary["phone"] = phone
		}
		if serverToken != nil{
			dictionary["server_token"] = serverToken
		}
		if uniqueId != nil{
			dictionary["unique_id"] = uniqueId
		}
		if updatedAt != nil{
			dictionary["updated_at"] = updatedAt
		}
		if urls != nil{
			var dictionaryElements = [[String:Any]]()
			for urlsElement in urls {
				dictionaryElements.append(urlsElement.toDictionary())
			}
			dictionary["urls"] = dictionaryElements
		}
		return dictionary
	}
    
    func toDictionaryURLS() -> [String:Any]
    {

        var dictionary = [String:Any]()
        if urls != nil{
            var dictionaryElements = [[String:Any]]()
            for urlsElement in urls {
                dictionaryElements.append(urlsElement.toDictionary())
            }
            dictionary["urls"] = dictionaryElements
        }
        return dictionary

    }
    
}

class SubStoreModel{

    var message : Int!
    var subStore : [SubStore]!
    var success : Bool!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        message = dictionary["message"] as? Int
        subStore = [SubStore]()
        if let productGroupsArray = dictionary["sub_stores"] as? [[String:Any]]{
            for dic in productGroupsArray{
                let value = SubStore(fromDictionary: dic)
                subStore.append(value)
            }
        }
        success = dictionary["success"] as? Bool
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if message != nil{
            dictionary["message"] = message
        }
        if subStore != nil{
            var dictionaryElements = [[String:Any]]()
            for productGroupsElement in subStore {
                dictionaryElements.append(productGroupsElement.toDictionary())
            }
            dictionary["sub_stores"] = dictionaryElements
        }
        if success != nil{
            dictionary["success"] = success
        }
        return dictionary
    }
}
