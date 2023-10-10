import UIKit
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    var blockCompletion: ((CLLocation?, _ error: Error?)->())!
    var autoUpdate:Bool = false;
     
    lazy var locationManager: CLLocationManager! = {
        let location = CLLocationManager()
        location.delegate = self
        location.distanceFilter = 3
        location.desiredAccuracy = kCLLocationAccuracyBest
        location.requestWhenInUseAuthorization();
        location.allowsBackgroundLocationUpdates = true
        location.pausesLocationUpdatesAutomatically = false
        NotificationCenter.default.addObserver(self, selector: #selector(self.didChangeCustomNotification), name: .didChangeCustomLocation, object: nil)
        return location
    }()
    let geocoder = CLGeocoder()
    //MARK: Core Location delegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.locationManager.stopUpdatingLocation()
        self.blockCompletion(nil,error)
    }
    
    func  locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if autoUpdate == false {
            self.locationManager.stopUpdatingLocation()
        }
        if preferenceHelper.getIsCustomLocation() {
            if preferenceHelper.getCustomLocation().count > 1 {
                self.blockCompletion(CLLocation(latitude: preferenceHelper.getCustomLocation()[0], longitude: preferenceHelper.getCustomLocation()[1]), nil)
            }
        } else {
            self.blockCompletion(locations.last, nil)
        }
    }
    //MARK: My LocationManager API
    func currentLocation(blockCompletion:@escaping (CLLocation?, Error?)->Void) {
        self.blockCompletion = blockCompletion;
        self.locationManager.requestLocation()
        
    }
    
    func currentUpdatingLocation(blockCompletion:@escaping (CLLocation?, Error?)->Void) {
        self.blockCompletion = blockCompletion;
        self.locationManager.startUpdatingLocation()
    }
    
    func currentAddressLocation(blockCompletion:@escaping ((_ currentAddress: [CLPlacemark]?, _ error: Error?)->())) {
        self.currentLocation { (currentLocation, error) -> () in
            if error != nil {
                blockCompletion(nil,error)
                return
            }else {
            self.geocoder.reverseGeocodeLocation(currentLocation!, completionHandler: { (objects: [CLPlacemark]?, err: Error?) -> Void in
                if err != nil {
                    blockCompletion(nil, err)
                    return
                }
                blockCompletion(objects, err)
            })
            }
        }
    }
    
    func getAddressForGeocoding(location: CLLocation!, _ blockCompletion:@escaping ((_ address: [CLPlacemark]?, _ error: Error?)->Void)) {
        if (location) != nil {
            self.geocoder.reverseGeocodeLocation(location, completionHandler: { (objects:[CLPlacemark]?, err: Error?) -> Void in
                if err != nil {
                    blockCompletion(nil, err)
                    return
                }
                blockCompletion(objects, err)
            })
        }else {
            blockCompletion(nil, nil)
        }
    }
    
   /* func getAddressString(placemark: CLPlacemark) -> String? {
        var originAddress : String?
        
        if let addrList = placemark.addressDictionary?["FormattedAddressLines"] as? [String] {
            originAddress =  addrList.joined(separator: ", ")
        }
        
        return originAddress
    }*/

    func getLocationFromGeocoding(address: String!, _ blockCompletion:@escaping ((_ location: CLLocationCoordinate2D?, _ error: Error?)->())) {
        
        self.geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil) {
                print("Error  \(error!)")
                blockCompletion(nil, error)
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                blockCompletion(coordinates, nil)
            }
        })
    }
    /*Without Using Geocoder */
    func getAddressForLocation(location:CLLocation!) -> String {
        if (location) != nil {

        let latitude = String(location.coordinate.latitude)
        let longitude = String(location.coordinate.longitude)
        let url = URL(string: "\(Google.GEOCODE_URL)\(Google.LAT_LNG)=\(latitude),\(longitude)&\(Google.KEY)=\(Google.API_KEY)")
            let data = NSData(contentsOf: url!)
            let json = try! JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
            if let result = json[Google.RESULTS] as? NSArray {
                let addresses = result[0] as? NSDictionary
                return addresses![Google.FORMATTED_ADDRESS] as! String
            }
        }
        return ""
    }
    
    @objc func didChangeCustomNotification() {
        let location = CLLocation(latitude: preferenceHelper.getCustomLocation()[0], longitude: preferenceHelper.getCustomLocation()[1])
        self.blockCompletion(location, nil)
    }
}
