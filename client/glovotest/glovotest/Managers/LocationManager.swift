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
    }
    
    func askForPermissions(completionBlock: @escaping LocationStatusBlock) {
        self.locationManager.requestWhenInUseAuthorization()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if let block = self.statusAuthBlock {
            block(status != .denied)
        }
    }
}
