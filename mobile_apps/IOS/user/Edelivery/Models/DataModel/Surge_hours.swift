/* 
Copyright (c) 2017 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at  */

public class Surge_hours {
	public var surge_multiplier : Double?
	public var surge_start_hour : String?
	public var surge_end_hour : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let surge_hours_list = Surge_hours.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Surge_hours Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Surge_hours] {
        var models:[Surge_hours] = []
        for item in array {
            models.append(Surge_hours(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let surge_hours = Surge_hours(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Surge_hours Instance.
*/
	required public init?(dictionary: NSDictionary) {

		surge_multiplier = (dictionary["surge_multiplier"] as? Double)?.roundTo() ?? 0.00
        surge_start_hour = dictionary["surge_start_hour"] as? String
		surge_end_hour = dictionary["surge_end_hour"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.surge_multiplier, forKey: "surge_multiplier")
		dictionary.setValue(self.surge_start_hour, forKey: "surge_start_hour")
		dictionary.setValue(self.surge_end_hour, forKey: "surge_end_hour")

		return dictionary
	}

}
