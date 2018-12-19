//
//  LocationManager.swift
//  glovotest
//
//  Created by Jesús Solé on 12/12/2018.
//  Copyright © 2018 Jesús Solé. All rights reserved.
//

import UIKit
import CoreLocation
import ReactiveKit

public typealias LocationStatusBlock = (Bool) -> Void

class LocationManager: NSObject {
    
    let locationManager = CLLocationManager()
    var statusAuthBlock: LocationStatusBlock?
    
    static let shared: LocationManager = {
        return LocationManager()
    }()

    override init() {
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestLocation()
    }
    
    func askForPermissions(completionBlock: @escaping LocationStatusBlock) {
        self.statusAuthBlock = completionBlock
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        self.locationManager.startUpdatingLocation()
    }
    
    func getLocation() -> CLLocation? {
        return self.locationManager.location
    }
    
    func isLocationPermissionEnabled() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            }
        } else {
            print("Location services are not enabled")
        }
        return false
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if let block = self.statusAuthBlock {
            block(status != .denied)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        //        self.view.didUpdateLocations(locations: locations)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager \(manager) didFailWithError: \(error)")
    }
}
