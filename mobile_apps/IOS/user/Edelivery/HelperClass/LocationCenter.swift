//
//  LocationCenter.swift
//  Edelivery
//
//  Created by Mac Pro5 on 01/10/19.
//  Copyright © 2019 KetanMR_Elluminati. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces

typealias Completion = () -> Void

class LocationCenter: NSObject, CLLocationManagerDelegate {
    
    let manager = CLLocationManager()
    let geocoder = CLGeocoder()
    var jobCompletion: Completion?
    
    class var isServicesEnabled: Bool {
        return CLLocationManager.locationServicesEnabled() 
    }
    
    class var authorizationStatus: CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus() 
    }
    
    class var isAlways_OR_WhenInUse: Bool {
        let status = LocationCenter.authorizationStatus
        return (status == CLAuthorizationStatus.authorizedAlways) || 
            (status == CLAuthorizationStatus.authorizedWhenInUse)
    }
    
    class var isDenied: Bool {
        let status = LocationCenter.authorizationStatus
        return status == CLAuthorizationStatus.denied
    }
    
    var lastLocation: CLLocation? { 
        return self.manager.location
    }
    
    static let `default`: LocationCenter = {
        let instance: LocationCenter = LocationCenter()    
        return instance
    }()
    
    // MARK: - 
    
    override init() {
        super.init()
        
        self.manager.delegate = self
        self.manager.activityType = CLActivityType.other
        self.manager.distanceFilter = kCLDistanceFilterNone
        self.manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.manager.pausesLocationUpdatesAutomatically = false
        self.manager.showsBackgroundLocationIndicator = false
    }
    
    // MARK: - 
    class func allowAlert() {
        OperationQueue.main.addOperation { 
            let msg = String(format: "%@", "\nPlease enable location services from the Settings app.\n\n1. Go to Settings > Privacy > Location Services.\n\n2. Make sure that location services is on.")
            let aC = UIAlertController(title: "Allow location", 
                                       message: msg, 
                                       preferredStyle: UIAlertController.Style.alert)
            let act = UIAlertAction(title: "OK", 
                                    style: UIAlertAction.Style.default, 
                                    handler: { (act: UIAlertAction) in
                                        Common.openSettingsApp()
            })
            aC.addAction(act)
            Common.appDelegate.window?.rootViewController?.present(aC, animated: true, completion: {
                print(#function)
            })
        }
    }
    
    func addObservers(_ observer: Any, _ selectors: [Selector]) {
        Common.nCd.removeObserver(observer, 
                                  name: Common.locationUpdateNtfNm, 
                                  object: LocationCenter.default)
        
        Common.nCd.removeObserver(observer, 
                                  name: Common.locationFailNtfNm, 
                                  object: LocationCenter.default)
        
        Common.nCd.addObserver(observer, 
                               selector: selectors[0], 
                               name: Common.locationUpdateNtfNm, 
                               object: LocationCenter.default)
        
        Common.nCd.addObserver(observer, 
                               selector: selectors[1], 
                               name: Common.locationFailNtfNm, 
                               object: LocationCenter.default)
    }
    
    func requestAuthorization() {
        if LocationCenter.isServicesEnabled && (!LocationCenter.isDenied) {
            //location change 2-11
            //self.manager.requestAlwaysAuthorization()
        } else {
            //change2 //userapp //Location change
           // LocationCenter.allowAlert()
        }
    }
    
    func requestLocationOnce() {
        if LocationCenter.isAlways_OR_WhenInUse {
            self.manager.requestLocation()
        } 
        else {
            self.requestAuthorization()
            self.jobCompletion = { [weak self] in
                self?.manager.requestLocation()
            }
        }
    }
    
    func startUpdatingLocation() {
        if LocationCenter.isAlways_OR_WhenInUse {
            self.manager.startUpdatingLocation()
        } 
        else {
            self.requestAuthorization()
            self.jobCompletion = { [weak self] in
                self?.manager.startUpdatingLocation()
            }
        }
    }
    
    func stopUpdatingLocation() {
        self.manager.stopUpdatingLocation()
    }
    
    func reverseGeo(location: CLLocation, _ completion: @escaping Completion) {
//        if self.geocoder.isGeocoding {
//            self.geocoder.cancelGeocode()
//        }
        
        self.geocoder.reverseGeocodeLocation(location) { 
            [weak self] (placemarks: [CLPlacemark]?, error: Error?) in
            guard let self = self else { return }
            
            if let placemark = placemarks?.first {
                print("\(self) \(#function) \(placemark)")
            }
            else {
                print("\(self) \(#function) \(error?.localizedDescription ?? "")")
            }
            
            completion()
        }
    }

    func fetchCityAndCountry(location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
//        if self.geocoder.isGeocoding {
//            self.geocoder.cancelGeocode()
//        }

        self.geocoder.reverseGeocodeLocation(location) {
            [weak self] (placemarks: [CLPlacemark]?, error: Error?) in
            guard let self = self else { return }

            if let placemark = placemarks?.first {
                print("\(self) \(#function) \(placemark)")
                completion(placemark.locality, placemark.country, error)
            } else {
                print("\(self) \(#function) \(error?.localizedDescription ?? "")")
                let gmsGeocoder: GMSGeocoder = GMSGeocoder()
                gmsGeocoder.reverseGeocodeCoordinate(location.coordinate) { (response: GMSReverseGeocodeResponse?, error: Error?) in
                    if error == nil {
                        if let r = response {
                            if let first = r.firstResult() {
                                completion("", first.country ?? "", error)
                            }
                        }
                    }
                    completion("", "", error)
                }
            }
        }

        if #available(iOS 11.0, *) {
            CLGeocoder().reverseGeocodeLocation(location, preferredLocale: Locale.init(identifier: "en_US_POSIX")) { placemarks, error in
                completion(placemarks?.first?.locality, placemarks?.first?.country, error)
            }
        } else {
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                completion(placemarks?.first?.locality, placemarks?.first?.country, error)
            }
        }
    }

    //MARK: - LocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case CLAuthorizationStatus.notDetermined:
            print("\(self) \(#function) notDetermined")
        case CLAuthorizationStatus.restricted:
            print("\(self) \(#function) restricted")
        case CLAuthorizationStatus.denied:
            print("\(self) \(#function) denied")
        case CLAuthorizationStatus.authorizedAlways:
            print("\(self) \(#function) authorizedAlways")
            self.jobCompletion?()
        case CLAuthorizationStatus.authorizedWhenInUse:
            print("\(self) \(#function) authorizedWhenInUse")
            self.jobCompletion?()
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        Common.nCd.post(name: Common.locationUpdateNtfNm, object: LocationCenter.default, userInfo: [Common.locationKey: location])
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Common.nCd.post(name: Common.locationFailNtfNm, object: LocationCenter.default, userInfo: [Common.locationErrorKey: error])
    }

    func locationManager(_ manager: CLLocationManager, 
                         didFinishDeferredUpdatesWithError error: Error?) {
        print("\(self) \(#function)")
    }

    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        print("\(self) \(#function)")
    }

    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        print("\(self) \(#function)")
    }
}
