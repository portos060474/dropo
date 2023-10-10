/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Day_time {
	public var booking_open_time : Int?
	public var booking_close_time : Int?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let day_time_list = Day_time.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Day_time Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Day_time]
    {
        var models:[Day_time] = []
        for item in array
        {
            models.append(Day_time(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let day_time = Day_time(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Day_time Instance.
*/
	required public init?(dictionary: NSDictionary) {

		booking_open_time = dictionary["booking_open_time"] as? Int
		booking_close_time = dictionary["booking_close_time"] as? Int
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.booking_open_time, forKey: "booking_open_time")
		dictionary.setValue(self.booking_close_time, forKey: "booking_close_time")
        return dictionary
	}

}
