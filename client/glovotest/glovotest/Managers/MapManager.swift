//
//  MapManager.swift
//  glovotest
//
//  Created by Jesús Solé on 15/12/2018.
//  Copyright © 2018 Jesús Solé. All rights reserved.
//

import UIKit
import GoogleMaps

protocol MapManagerDelegate {
    func cameraMoved(point: CGPoint)
}

class MapManager: NSObject {
    
    static let shared = MapManager()
    var delegate: MapManagerDelegate?
    
    private var cityOnCamera: CityModel?
    var cities: [CityModel]?
    
    static func configure() {
        GMSServices.provideAPIKey("AIzaSyBfoEovgwAlSkF7UjmL45afhATZtIrhifI")
    }
    
    @objc func loadMap(mapView: GMSMapView) {
        if LocationManager.shared.isLocationPermissionEnabled() {
            LocationManager.shared.startUpdatingLocation()
            
            if let location = LocationManager.shared.getLocation() {
                
                print("Latitude = ", location.coordinate.latitude, " longitude = ", location.coordinate.longitude)
                //Barcelona
                let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                                      longitude: location.coordinate.longitude, zoom: 15)
                mapView.camera = camera
                mapView.isMyLocationEnabled = true
                mapView.settings.myLocationButton = true
                mapView.delegate = self
                
            } else {
                print("Location Manager in MapViewController not loaded")
                perform(#selector(loadMap), with: nil, afterDelay: 0.5)
            }
        }
        else {
            let position = GMSCameraPosition.camera(withLatitude: CLLocationDegrees(41.3947688), longitude: CLLocationDegrees(2.0787279), zoom: 11)
            mapView.animate(to: position)
        }
    }
    
    func moveCameraPosition(mapView: GMSMapView, latitude: Double, longitude: Double) {
        mapView.camera = GMSCameraPosition.camera(withLatitude: latitude,
                                                  longitude: longitude, zoom: 15)
    }
    
    func createMarker(inMap map: GMSMapView, inPosition position: CLLocationCoordinate2D) -> GMSMarker {
        let marker = GMSMarker()
        
        marker.iconView = UIView(frame: CGRect(x: 0, y: 0, width: 42, height: 42))
        marker.groundAnchor = CGPoint.init(x: 0.5, y: 1.0)

        marker.position = position
        marker.map = map
        
        return marker
    }
    
    func createCityPolygons(inMap map: GMSMapView, polygonsPaths: [String]) {

        for polygonPath in polygonsPaths {
            let polygon = GMSPolygon()
            polygon.path = GMSPath(fromEncodedPath: polygonPath)
            polygon.fillColor = UIColor.redZone
            polygon.strokeColor = UIColor.redStroke
            polygon.strokeWidth = 2
            polygon.map = map
        }
    }
    
    func isUserInsidePaths(polygonsPaths: [String]) -> Bool {
        if let coordinate = LocationManager.shared.getLocation()?.coordinate {
            for path in polygonsPaths {
                if let gmsPath = GMSPath(fromEncodedPath: path) {
                    if GMSGeometryContainsLocation(coordinate, gmsPath, true) {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    func isPointInsidePaths(point: CGPoint, polygonsPaths: [String]) -> Bool {
        let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(point.x),
                                                longitude: CLLocationDegrees(point.y))
        for path in polygonsPaths {
            if let gmsPath = GMSPath(fromEncodedPath: path) {
                if GMSGeometryIsLocationOnPathTolerance(coordinate, gmsPath, true, 1000) {
                    return true
                }
            }
        }
        return false
    }
}

extension MapManager: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
        print("Camera position didDrag latitude = ", mapView.camera.target.latitude, " longitude = ", mapView.camera.target.longitude)
    }
    
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        print("Camera position didEndDragging latitude = ", mapView.camera.target.latitude, " longitude = ", mapView.camera.target.longitude)
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        print("Camera position idleAt latitude = ", position.target.latitude, " longitude = ", position.target.longitude)
        if let delegate = self.delegate {
            delegate.cameraMoved(point: CGPoint(x: position.target.latitude, y: position.target.longitude))
        }
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if gesture {
            print("Camera position willMove latitude = ", mapView.camera.target.latitude, " longitude = ", mapView.camera.target.longitude)
        }
    }

    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        print("Camera position didChange latitude = ", mapView.camera.target.latitude, " longitude = ", mapView.camera.target.longitude)
    }
}
