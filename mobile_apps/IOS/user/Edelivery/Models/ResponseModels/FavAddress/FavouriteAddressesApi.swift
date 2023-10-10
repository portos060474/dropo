/* 
 Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar
 
 */

import Foundation
class FavouriteAddressesApi {
    var _id : String!
    var latitude : Double!
    var longitude : Double!
    var address : String!
    var address_name : String!
    var street : String!
    var flat_no : String!
    var landmark : String!
    var country : String!
    var country_code : String?
    
    required  init(dictionary: NSDictionary) {
        
        _id = dictionary["_id"] as? String ?? ""
        latitude = dictionary["latitude"] as? Double ?? 0
        longitude = dictionary["longitude"] as? Double ?? 0
        address = dictionary["address"] as? String ?? ""
        address_name = dictionary["address_name"] as? String ?? ""
        street = dictionary["street"] as? String ?? ""
        flat_no = dictionary["flat_no"] as? String ?? ""
        landmark = dictionary["landmark"] as? String ?? ""
        country = dictionary["country"] as? String ?? ""
        country_code = dictionary["country_code"] as? String ?? ""
    }
    
    func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.latitude, forKey: "latitude")
        dictionary.setValue(self.longitude, forKey: "longitude")
        dictionary.setValue(self.address, forKey: "address")
        dictionary.setValue(self.address_name, forKey: "address_name")
        dictionary.setValue(self.street, forKey: "street")
        dictionary.setValue(self.flat_no, forKey: "flat_no")
        dictionary.setValue(self.landmark, forKey: "landmark")
        dictionary.setValue(self.country, forKey: "country")
        dictionary.setValue(self.country_code, forKey: "country_code")
        
        return dictionary
    }
    
}
