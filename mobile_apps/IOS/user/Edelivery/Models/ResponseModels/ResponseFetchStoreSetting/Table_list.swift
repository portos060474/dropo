/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Table_list {
	public var _id : String?
	public var is_user_can_book : Bool?
	public var is_bussiness : Bool?
	public var table_no : Int?
	public var table_code : String?
	public var table_min_person : Int?
	public var table_max_person : Int?
	public var table_qrcode : String?
	public var store_id : String?
	public var created_at : String?
	public var updated_at : String?
	public var unique_id : Int?
	public var __v : Int?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let table_list_list = Table_list.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Table_list Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Table_list]
    {
        var models:[Table_list] = []
        for item in array
        {
            models.append(Table_list(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let table_list = Table_list(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Table_list Instance.
*/
	required public init?(dictionary: NSDictionary) {

		_id = dictionary["_id"] as? String
		is_user_can_book = dictionary["is_user_can_book"] as? Bool
		is_bussiness = dictionary["is_bussiness"] as? Bool
		table_no = dictionary["table_no"] as? Int
		table_code = dictionary["table_code"] as? String
		table_min_person = dictionary["table_min_person"] as? Int
		table_max_person = dictionary["table_max_person"] as? Int
		table_qrcode = dictionary["table_qrcode"] as? String
		store_id = dictionary["store_id"] as? String
		created_at = dictionary["created_at"] as? String
		updated_at = dictionary["updated_at"] as? String
		unique_id = dictionary["unique_id"] as? Int
		__v = dictionary["__v"] as? Int
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self._id, forKey: "_id")
		dictionary.setValue(self.is_user_can_book, forKey: "is_user_can_book")
		dictionary.setValue(self.is_bussiness, forKey: "is_bussiness")
		dictionary.setValue(self.table_no, forKey: "table_no")
		dictionary.setValue(self.table_code, forKey: "table_code")
		dictionary.setValue(self.table_min_person, forKey: "table_min_person")
		dictionary.setValue(self.table_max_person, forKey: "table_max_person")
		dictionary.setValue(self.table_qrcode, forKey: "table_qrcode")
		dictionary.setValue(self.store_id, forKey: "store_id")
		dictionary.setValue(self.created_at, forKey: "created_at")
		dictionary.setValue(self.updated_at, forKey: "updated_at")
		dictionary.setValue(self.unique_id, forKey: "unique_id")
		dictionary.setValue(self.__v, forKey: "__v")

		return dictionary
	}

}
