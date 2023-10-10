import UIKit
import CoreLocation
import GooglePlaces
import GoogleMaps

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    var blockCompletion: ((CLLocation?, _ error: Error?)->())?
    
    var autoUpdate:Bool = false
    
    lazy var locationManager: CLLocationManager! = {
            let location = CLLocationManager()            
            location.delegate = self
            location.distanceFilter = kCLDistanceFilterNone
            location.desiredAccuracy = kCLLocationAccuracyBest
            location.requestWhenInUseAuthorization()
            return location
    }()
    
    let geocoder = CLGeocoder()
    //MARK: Core Location delegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.locationManager.stopUpdatingLocation()
        self.blockCompletion?(nil,error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if autoUpdate == false {
            self.locationManager.stopUpdatingLocation()
        }
        self.blockCompletion?(locations.last, nil)
    }
    
    //MARK: - My LocationManager API
    func currentLocation(blockCompletion:@escaping (CLLocation?, Error?)->Void) {
        self.blockCompletion = blockCompletion
        self.locationManager.requestLocation()
    }
    
    func currentUpdatingLocation(blockCompletion:@escaping (CLLocation?, Error?)->Void) {
        self.blockCompletion = blockCompletion
        self.locationManager.startUpdatingLocation()
    }
    
    func currentAddressLocation(blockCompletion:@escaping ((_ currentAddress: CLPlacemark?, _ error: Error?)->())) {
        self.currentLocation { [unowned self] (currentLocation, error) -> () in
            if error != nil {
                blockCompletion(nil,error)
                return
            } else {
                self.geocoder.reverseGeocodeLocation(currentLocation!, completionHandler: { [unowned self, weak geocoder =  self.geocoder] (objects: [CLPlacemark]?, err: Error?) -> Void in
                    print("CurrentBooking.shared.currentCountryCode -------- \(CurrentBooking.shared.currentCountryCode)")
                    if CurrentBooking.shared.currentCountryCode.isEmpty() {
                        CurrentBooking.shared.currentCountryCode = (objects?.first?.isoCountryCode) ?? ""
                    }

                    if err != nil {
                        blockCompletion(nil, err)
                        return
                    }
                    blockCompletion(objects?.last, err)
                })
            }
        }
    }

    func googlePlacesResultForFavAddress(input: String, completion: @escaping (_ result: [(title:String,subTitle:String,address:String)]) -> Void) {
        if !input.isEmpty() {
            let token = GMSAutocompleteSessionToken.init()

            // Create a type filter.
            _ = CLLocationCoordinate2D.init(latitude: UserSingleton.shared.currentCoordinate.latitude, longitude: UserSingleton.shared.currentCoordinate.longitude)

            let filter = GMSAutocompleteFilter()
            filter.country = CurrentBooking.shared.currentCountryCode
            let placeClient = GMSPlacesClient.shared()
            
            placeClient.findAutocompletePredictions(fromQuery: input, filter: filter, sessionToken: token, callback: { (results, error) in
                var myAddressArray :[(title:String,subTitle:String,address: String)] = []
                if let error = error {
                    printE("Autocomplete error: \(error)")
                    completion(myAddressArray)
                    return
                }

                if let results = results {
                    myAddressArray = []
                    for result in results {
                        let mainString = (result.attributedPrimaryText.string)
                        let subString = (result.attributedSecondaryText?.string) ?? ""
                        
                        let detailString = result.attributedFullText.string
                        _ = result.placeID
                        
                        let myAddress:(title:String,subTitle:String,address:String) = (mainString,subString,detailString)
                        myAddressArray.append(myAddress)
                    }
                    completion(myAddressArray)
                }
                completion(myAddressArray)
            })
        }
    }

    func googlePlacesResult(input: String, completion: @escaping (_ result: [(title:String,subTitle:String,address:String)]) -> Void) {
        if !input.isEmpty() {
            let token = GMSAutocompleteSessionToken.init()
            _ = CLLocationCoordinate2D.init(latitude: CurrentBooking.shared.currentPlaceData.latitude, longitude: CurrentBooking.shared.currentPlaceData.longitude)

            let filter = GMSAutocompleteFilter()
            filter.country = CurrentBooking.shared.currentPlaceData.country_code

            let placeClient = GMSPlacesClient.shared()
            placeClient.findAutocompletePredictions(fromQuery: input, filter: filter, sessionToken: token, callback: { (results, error) in
                var myAddressArray :[(title:String,subTitle:String,address: String)] = []
                if let error = error {
                    printE("Autocomplete error: \(error)")
                    completion(myAddressArray)
                    return
                }
                if let results = results {
                    myAddressArray = []
                    for result in results {
                        let mainString = (result.attributedPrimaryText.string)
                        let subString = (result.attributedSecondaryText?.string) ?? ""
                        let detailString = result.attributedFullText.string
                        _ = result.placeID
                        let myAddress:(title:String,subTitle:String,address:String) = (mainString,subString,detailString)
                        myAddressArray.append(myAddress)
                    }
                    completion(myAddressArray)
                }
                completion(myAddressArray)
            })
            
        }
    }
    
   //MARK: - Get Lat Long From Goole API
    func getAddressFromLatLong(latitude:Double,longitude:Double) {
        let strURL:String = "\(Google.GEOCODE_URL)\(Google.LAT_LNG)=\(latitude),\(longitude)&\(Google.KEY)=\(Google.API_KEY)"
        
        let urlStr : String = strURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        
        guard let url = URL(string: urlStr) else {
            currentBooking.currentSendPlaceData.latitude = latitude
            currentBooking.currentSendPlaceData.longitude = longitude
            currentBooking.currentSendPlaceData.address = ""
            currentBooking.currentSendPlaceData.city1 = ""
            currentBooking.currentSendPlaceData.city2 = ""
            currentBooking.currentSendPlaceData.city3 = ""
            currentBooking.currentSendPlaceData.country = ""
            currentBooking.currentSendPlaceData.country_code = ""
            currentBooking.currentSendPlaceData.city_code = ""
            return
        }
        do{
            let data = try Data(contentsOf: url)
            let jsonObject:[String:Any] = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                if ((jsonObject[Google.STATUS] as! String) == Google.OK) {
            
            let resultObject:[String:Any] = ((jsonObject[Google.RESULTS] as! NSArray)[0] as! [String:Any])
            
            
            let addressComponent:[[String:Any]] = resultObject[Google.ADDRESS_COMPONENTS] as! [[String:Any]]
            
            let address:String = (resultObject[Google.FORMATTED_ADDRESS] as? String) ?? ""
            let geometryObject:[String:Any] = resultObject[Google.GEOMETRY] as! [String:Any]
            
            currentBooking.currentSendPlaceData.latitude = latitude
            currentBooking.currentSendPlaceData.address = address
            currentBooking.currentSendPlaceData.longitude = longitude
            
            let  addressSize:Int = addressComponent.count
            currentBooking.currentSendPlaceData.city1 = ""
            currentBooking.currentSendPlaceData.city2 = ""
            currentBooking.currentSendPlaceData.city3 = ""
                    
            for  i in 0 ..< addressSize {
                let address:[String:Any] = addressComponent[i]
                
                if let typesArray:[String] = (address[Google.TYPES] as? [String]),typesArray.count > 0 {
                    if (typesArray[0].compare(Google.LOCALITY) == .orderedSame)
                    {
                        currentBooking.currentSendPlaceData.city1 = address[Google.LONG_NAME] as! String
                    }
                    else if (typesArray[0].compare(Google.ADMINISTRATIVE_AREA_LEVEL_2) == .orderedSame)
                    {
                        currentBooking.currentSendPlaceData.city2 = address[Google.LONG_NAME] as! String
                        
                    }
                    else if (typesArray[0].compare(Google.ADMINISTRATIVE_AREA_LEVEL_1) == .orderedSame)
                    {
                        
                        currentBooking.currentSendPlaceData.city3 = address[Google.LONG_NAME] as! String
                        currentBooking.currentSendPlaceData.city_code = address[Google.SHORT_NAME] as! String
                        
                    }
                    else if (typesArray[0].compare(Google.COUNTRY) == .orderedSame)
                    {
                        
                        currentBooking.currentSendPlaceData.country = address[Google.LONG_NAME] as! String
                        currentBooking.currentSendPlaceData.country_code = address[Google.SHORT_NAME] as! String
                      
                            CurrentBooking.shared.currentCountryCode = currentBooking.currentSendPlaceData.country_code
                            print("CurrentBooking.shared.currentCountryCode -------- \(currentBooking.currentSendPlaceData.country_code)")
                       
                    }
                }else {
                    
                }
                
                
                
            }
            
            
        }
                if currentBooking.currentSendPlaceData.city1 == "" {
                currentBooking.currentSendPlaceData.city1 = currentBooking.currentSendPlaceData.city2
                }
        }
        catch let error as NSError {
            currentBooking.currentSendPlaceData.latitude = latitude
            currentBooking.currentSendPlaceData.address = ""
            currentBooking.currentSendPlaceData.longitude = longitude
            currentBooking.currentSendPlaceData.city1 = ""
            currentBooking.currentSendPlaceData.city2 = ""
            currentBooking.currentSendPlaceData.city3 = ""
            currentBooking.currentSendPlaceData.country = ""
            currentBooking.currentSendPlaceData.country_code = ""
            currentBooking.currentSendPlaceData.city_code = ""
            
            printE(error)
        }
    }
    
    
    func getAddressFromLatLongForFavAddress(latitude:Double,longitude:Double) {
        let strURL:String = "\(Google.GEOCODE_URL)\(Google.LAT_LNG)=\(latitude),\(longitude)&\(Google.KEY)=\(Google.API_KEY)"
        
        let urlStr : String = strURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        
        guard let url = URL(string: urlStr) else {
            UserSingleton.shared.SendplaceData.latitude = latitude
            UserSingleton.shared.SendplaceData.longitude = longitude
            UserSingleton.shared.SendplaceData.address = ""
            UserSingleton.shared.SendplaceData.city1 = ""
            UserSingleton.shared.SendplaceData.city2 = ""
            UserSingleton.shared.SendplaceData.city3 = ""
            UserSingleton.shared.SendplaceData.country = ""
            UserSingleton.shared.SendplaceData.country_code = ""
            UserSingleton.shared.SendplaceData.city_code = ""
            return
        }
        do{
            let data = try Data(contentsOf: url)
            let jsonObject:[String:Any] = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                if ((jsonObject[Google.STATUS] as! String) == Google.OK) {
            
            let resultObject:[String:Any] = ((jsonObject[Google.RESULTS] as! NSArray)[0] as! [String:Any])
            
            
            let addressComponent:[[String:Any]] = resultObject[Google.ADDRESS_COMPONENTS] as! [[String:Any]]
            
            let address:String = (resultObject[Google.FORMATTED_ADDRESS] as? String) ?? ""
            let geometryObject:[String:Any] = resultObject[Google.GEOMETRY] as! [String:Any]
            
            UserSingleton.shared.SendplaceData.latitude = latitude
            UserSingleton.shared.SendplaceData.address = address
            UserSingleton.shared.SendplaceData.longitude = longitude
            
            
            
            let  addressSize:Int = addressComponent.count
            UserSingleton.shared.SendplaceData.city1 = ""
            UserSingleton.shared.SendplaceData.city2 = ""
            UserSingleton.shared.SendplaceData.city3 = ""
                    
            for  i in 0 ..< addressSize {
                let address:[String:Any] = addressComponent[i]
                
                if let typesArray:[String] = (address[Google.TYPES] as? [String]),typesArray.count > 0 {
                    if (typesArray[0].compare(Google.LOCALITY) == .orderedSame)
                    {
                        UserSingleton.shared.SendplaceData.city1 = address[Google.LONG_NAME] as! String
                    }
                    else if (typesArray[0].compare(Google.ADMINISTRATIVE_AREA_LEVEL_2) == .orderedSame)
                    {
                        UserSingleton.shared.SendplaceData.city2 = address[Google.LONG_NAME] as! String
                        
                    }
                    else if (typesArray[0].compare(Google.ADMINISTRATIVE_AREA_LEVEL_1) == .orderedSame)
                    {
                        
                        UserSingleton.shared.SendplaceData.city3 = address[Google.LONG_NAME] as! String
                        UserSingleton.shared.SendplaceData.city_code = address[Google.SHORT_NAME] as! String
                        
                    }
                    else if (typesArray[0].compare(Google.COUNTRY) == .orderedSame)
                    {
                        
                        UserSingleton.shared.SendplaceData.country = address[Google.LONG_NAME] as! String
                        UserSingleton.shared.SendplaceData.country_code = address[Google.SHORT_NAME] as! String
//                        if CurrentBooking.shared.currentCountryCode.isEmpty() {
//                            CurrentBooking.shared.currentCountryCode = currentBooking.currentSendPlaceData.country_code
//                        }
                    }
                }else {
                    
                }
            }
        }
                if UserSingleton.shared.SendplaceData.city1 == "" {
                    UserSingleton.shared.SendplaceData.city1 = UserSingleton.shared.SendplaceData.city2
                }
        }
        catch let error as NSError {
            UserSingleton.shared.SendplaceData.latitude = latitude
            UserSingleton.shared.SendplaceData.address = ""
            UserSingleton.shared.SendplaceData.longitude = longitude
            UserSingleton.shared.SendplaceData.city1 = ""
            UserSingleton.shared.SendplaceData.city2 = ""
            UserSingleton.shared.SendplaceData.city3 = ""
            UserSingleton.shared.SendplaceData.country = ""
            UserSingleton.shared.SendplaceData.country_code = ""
            UserSingleton.shared.SendplaceData.city_code = ""
            
            printE(error)
        }
    }
    
    func setPlaceDataFromAddress(address:String) {
        if address.isEmpty() {
            return
        }else {
            let strURL:String = "\(Google.GEOCODE_URL)\(Google.ADDRESS)=\(address)&\(Google.KEY)=\(Google.API_KEY)"
            
            let urlStr : String = strURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            
            
            guard let url = URL(string: urlStr) else {
                return
            }
            
            do{
                let data = try Data(contentsOf: url)
                let jsonObject:[String:Any] = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                if ((jsonObject[Google.STATUS] as! String) == Google.OK) {
                    
                    let resultObject:[String:Any] = ((jsonObject[Google.RESULTS] as! NSArray)[0] as! [String:Any])
                    
                    
                    let addressComponent:[[String:Any]] = resultObject[Google.ADDRESS_COMPONENTS] as! [[String:Any]]
                    
                    let address:String = (resultObject[Google.FORMATTED_ADDRESS] as? String) ?? ""
                    let geometryObject:[String:Any] = resultObject[Google.GEOMETRY] as! [String:Any]
                    
                    currentBooking.currentSendPlaceData.latitude = ((geometryObject[Google.LOCATION] as! [String:Any])[Google.LAT] as? Double) ?? 0.0
                    
                    currentBooking.currentSendPlaceData.address = address
                    currentBooking.currentSendPlaceData.longitude =
                        ((geometryObject[Google.LOCATION] as! [String:Any])[Google.LNG] as? Double) ?? 0.0
                    
                    
                    
                    
                    let  addressSize:Int = addressComponent.count
                    currentBooking.currentSendPlaceData.city1 = ""
                    currentBooking.currentSendPlaceData.city2 = ""
                    currentBooking.currentSendPlaceData.city3 = ""
                    for  i in 0 ..< addressSize
                    {
                        let address:[String:Any] = addressComponent[i]
                        
                        let typesArray:[String] = address[Google.TYPES] as! [String]
                        
                        if !typesArray.isEmpty
                        {
                            if (typesArray[0].compare(Google.LOCALITY) == .orderedSame)
                            {
                                currentBooking.currentSendPlaceData.city1 = address[Google.LONG_NAME] as! String
                            }
                            else if (typesArray[0].compare(Google.ADMINISTRATIVE_AREA_LEVEL_2) == .orderedSame)
                            {
                                currentBooking.currentSendPlaceData.city2 = address[Google.LONG_NAME] as! String
                                
                            }
                            else if (typesArray[0].compare(Google.ADMINISTRATIVE_AREA_LEVEL_1) == .orderedSame)
                            {
                                
                                currentBooking.currentSendPlaceData.city3 = address[Google.LONG_NAME] as! String
                                currentBooking.currentSendPlaceData.city_code = address[Google.SHORT_NAME] as! String
                                
                            }
                            else if (typesArray[0].compare(Google.COUNTRY) == .orderedSame)
                            {
                                
                                currentBooking.currentSendPlaceData.country = address[Google.LONG_NAME] as! String
                                currentBooking.currentSendPlaceData.country_code = address[Google.SHORT_NAME] as! String
                            }
                        }
                    }
                }
                if currentBooking.currentSendPlaceData.city1 == "" {
                    currentBooking.currentSendPlaceData.city1 = currentBooking.currentSendPlaceData.city2
                }
            }
            catch let error as NSError {
                printE(error)
            }
            
            
        }
     }
    
    func setPlaceDataFromAddressFaVAddress(address:String) {
        if address.isEmpty() {
            return
        }else {
            let strURL:String = "\(Google.GEOCODE_URL)\(Google.ADDRESS)=\(address)&\(Google.KEY)=\(Google.API_KEY)"
            
            let urlStr : String = strURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            
            
            guard let url = URL(string: urlStr) else {
                return
            }
            
            do{
                let data = try Data(contentsOf: url)
                let jsonObject:[String:Any] = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                if ((jsonObject[Google.STATUS] as! String) == Google.OK) {
                    
                    let resultObject:[String:Any] = ((jsonObject[Google.RESULTS] as! NSArray)[0] as! [String:Any])
                    
                    
                    let addressComponent:[[String:Any]] = resultObject[Google.ADDRESS_COMPONENTS] as! [[String:Any]]
                    
                    let address:String = (resultObject[Google.FORMATTED_ADDRESS] as? String) ?? ""
                    let geometryObject:[String:Any] = resultObject[Google.GEOMETRY] as! [String:Any]
                    
                    UserSingleton.shared.SendplaceData.latitude = ((geometryObject[Google.LOCATION] as! [String:Any])[Google.LAT] as? Double) ?? 0.0
                    
                    UserSingleton.shared.SendplaceData.address = address
                    UserSingleton.shared.SendplaceData.longitude =
                        ((geometryObject[Google.LOCATION] as! [String:Any])[Google.LNG] as? Double) ?? 0.0
                    
                    
                    
                    
                    let  addressSize:Int = addressComponent.count
                    UserSingleton.shared.SendplaceData.city1 = ""
                    UserSingleton.shared.SendplaceData.city2 = ""
                    UserSingleton.shared.SendplaceData.city3 = ""
                    for  i in 0 ..< addressSize
                    {
                        let address:[String:Any] = addressComponent[i]
                        
                        let typesArray:[String] = address[Google.TYPES] as! [String]
                        
                        if !typesArray.isEmpty
                        {
                            if (typesArray[0].compare(Google.LOCALITY) == .orderedSame)
                            {
                                UserSingleton.shared.SendplaceData.city1 = address[Google.LONG_NAME] as! String
                            }
                            else if (typesArray[0].compare(Google.ADMINISTRATIVE_AREA_LEVEL_2) == .orderedSame)
                            {
                                UserSingleton.shared.SendplaceData.city2 = address[Google.LONG_NAME] as! String
                                
                            }
                            else if (typesArray[0].compare(Google.ADMINISTRATIVE_AREA_LEVEL_1) == .orderedSame)
                            {
                                
                                UserSingleton.shared.SendplaceData.city3 = address[Google.LONG_NAME] as! String
                                UserSingleton.shared.SendplaceData.city_code = address[Google.SHORT_NAME] as! String
                                
                            }
                            else if (typesArray[0].compare(Google.COUNTRY) == .orderedSame)
                            {
                                
                                UserSingleton.shared.SendplaceData.country = address[Google.LONG_NAME] as! String
                                UserSingleton.shared.SendplaceData.country_code = address[Google.SHORT_NAME] as! String
                            }
                        }
                    }
                }
                if UserSingleton.shared.SendplaceData.city1 == "" {
                    UserSingleton.shared.SendplaceData.city1 = UserSingleton.shared.SendplaceData.city2
                }
            }
            catch let error as NSError {
                printE(error)
            }
            
            
        }
     }
    
    func getLatLongFromAddress(address:String) -> [Double] {
        
        if address.isEmpty() {
            return [0.0,0.0]
        }else {
            let strURL:String = "\(Google.GEOCODE_URL)\(Google.ADDRESS)=\(address)&\(Google.KEY)=\(Google.API_KEY)"
            
            let urlStr : String = strURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            
            
            guard let url = URL(string: urlStr)
                else {
                return [0.0,0.0]
            }
            
            do{
                let data = try Data(contentsOf: url)
                let jsonObject:[String:Any] = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                if ((jsonObject[Google.STATUS] as! String) == Google.OK) {
                    
                    let resultObject:[String:Any] = ((jsonObject[Google.RESULTS] as! NSArray)[0] as! [String:Any])
                    
                    let geometryObject:[String:Any] = resultObject[Google.GEOMETRY] as! [String:Any]
                    
                    let latitude = ((geometryObject[Google.LOCATION] as! [String:Any])[Google.LAT] as? Double) ?? 0.0
                    
                    let longitude =
                        ((geometryObject[Google.LOCATION] as! [String:Any])[Google.LNG] as? Double) ?? 0.0
                    return [latitude,longitude]
                }
                return [0.0,0.0]
            }
            catch _ as NSError {
                return [0.0,0.0]
            }
            
        }
    }
}
