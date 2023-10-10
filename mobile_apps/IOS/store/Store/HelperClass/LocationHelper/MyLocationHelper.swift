import UIKit
import CoreLocation
import GooglePlaces
import GoogleMaps

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    var blockCompletion: ((CLLocation?, _ error: Error?)->())!
    var autoUpdate:Bool = false;
    
    lazy var locationManager: CLLocationManager! = {
        let location = CLLocationManager()
        
        
        location.delegate = self
        location.distanceFilter = kCLDistanceFilterNone
        location.desiredAccuracy = kCLLocationAccuracyBest
        location.requestWhenInUseAuthorization();
        location.startUpdatingLocation()
        return location
    }()
    let geocoder = CLGeocoder()
    //MARK: Core Location delegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.locationManager.stopUpdatingLocation()
        self.blockCompletion(nil,error)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
       
        if autoUpdate == false {
            self.locationManager.stopUpdatingLocation()
        }
        StoreSingleton.shared.currentCoordinate = locations.last?.coordinate ?? CLLocationCoordinate2D.init(latitude: 0.0, longitude: 0.0)
        
        self.blockCompletion(locations.last, nil)
    }
    //MARK: My LocationManager API
    func currentLocation(blockCompletion:@escaping (CLLocation?, Error?)->Void) {
        self.blockCompletion = blockCompletion;
        self.locationManager.startUpdatingLocation()
        
    }
    func currentUpdatingLocation(blockCompletion:@escaping (CLLocation?, Error?)->Void) {
        
        self.blockCompletion = blockCompletion;
        self.locationManager.startUpdatingLocation()
    }
    func currentAddressLocation(blockCompletion:@escaping ((_ currentAddress: CLPlacemark?, _ error: Error?)->())) {
        
        
        self.currentLocation { (currentLocation, error) -> () in
                
                
            if error != nil {
                blockCompletion(nil,error)
                return
            }else {
                self.geocoder.reverseGeocodeLocation(currentLocation!, completionHandler: { (objects: [CLPlacemark]?, err: Error?) -> Void in
                    if err != nil
                    {
                        blockCompletion(nil, err)
                        return
                    }
                    
                    if StoreSingleton.shared.currentCountryCode.isEmpty()
                    {
                        StoreSingleton.shared.currentCountryCode = (objects?.last?.isoCountryCode) ?? ""
                        
                    }
                    blockCompletion(objects?.last, err)
                })
       
               
            }
        }
    
    }
    
   
    func googlePlacesResult(input: String, completion: @escaping (_ result: [(title:String,subTitle:String,address:String)]) -> Void) {
        
        
        if !input.isEmpty() {
            let token = GMSAutocompleteSessionToken.init()
            
            // Create a type filter.
            let currentCoordinate = CLLocationCoordinate2D.init(latitude: StoreSingleton.shared.currentCoordinate.latitude, longitude: StoreSingleton.shared.currentCoordinate.longitude)
            
            
            let filter = GMSAutocompleteFilter()
            filter.country = StoreSingleton.shared.currentCountryCode
            filter.type = .noFilter
            let placeClient = GMSPlacesClient.shared()
            placeClient.findAutocompletePredictions(fromQuery: input, filter: filter, sessionToken: token, callback: { (results, error) in
                var myAddressArray :[(title:String,subTitle:String,address: String)] = []
                if let error = error
                {
                    print("Autocomplete error: \(error)")
                    completion(myAddressArray)
                    return
                }
                if let results = results {
                    myAddressArray = []
                    for result in results
                    {
                        
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
            /*placeClient.findAutocompletePredictions(fromQuery: input,
             bounds: GMSCoordinateBounds.init(coordinate: currentCoordinate, coordinate: currentCoordinate),
             boundsMode: GMSAutocompleteBoundsMode.bias,
             filter: filter,
             sessionToken: token,
             callback: { (results, error) in
             var myAddressArray :[(title:String,subTitle:String,address: String)] = []
             if let error = error
             {
             print("Autocomplete error: \(error)")
             completion(myAddressArray)
             return
             }
             if let results = results {
             myAddressArray = []
             for result in results
             {
             
             let mainString = (result.attributedPrimaryText.string)
             
             let subString = (result.attributedSecondaryText?.string) ?? ""
             
             let detailString = result.attributedFullText.string
             let placeId = result.placeID
             
             let myAddress:(title:String,subTitle:String,address:String) = (mainString,subString,detailString)
             
             myAddressArray.append(myAddress)
             }
             
             completion(myAddressArray)
             
             }
             completion(myAddressArray)
             })*/
        }
    }
    func getLocationFromAddress(address:String) -> [Double] {
        
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
                    
                    let geometryObject:[String:Any] = resultObject[Google.GEOMETRY] as! [String:Any];
                    
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
    
    func getAddressFromLatLong(latitude:Double,longitude:Double) -> (String,[Double]) {
        let strURL:String = "\(Google.GEOCODE_URL)\(Google.LAT_LNG)=\(latitude),\(longitude)&\(Google.KEY)=\(Google.API_KEY)"
        
        let urlStr : String = strURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        
        guard let url = URL(string: urlStr) else {
            
            return ("",[0.0,0.0])
        }
        do{
            let data = try Data(contentsOf: url)
            let jsonObject:[String:Any] = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
            if ((jsonObject[Google.STATUS] as! String) == Google.OK) {
                
                let resultObject:[String:Any] = ((jsonObject[Google.RESULTS] as! NSArray)[0] as! [String:Any])
                
                let address:String = (resultObject[Google.FORMATTED_ADDRESS] as? String) ?? ""
                let geometryObject:[String:Any] = resultObject[Google.GEOMETRY] as! [String:Any];
                
                let location = [((geometryObject[Google.LOCATION] as! [String:Any])[Google.LAT] as? Double) ?? 0.0, ((geometryObject[Google.LOCATION] as! [String:Any])[Google.LNG] as? Double) ?? 0.0]
               
                return (address,location)
            }
            return ("",[0.0,0.0])
               
        }
        catch let error as NSError {
            print(error)
            return ("",[0.0,0.0])
        }
    }

}
