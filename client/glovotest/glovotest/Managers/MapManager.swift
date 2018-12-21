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
    func zoomChanged(zoom: Float)
}

class MapManager: NSObject {
    
    static let shared = MapManager()
    var delegate: MapManagerDelegate?
    var zoom: Float = 0.0
    
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
                                                      longitude: location.coordinate.longitude,
                                                      zoom: MapConstants.zoomForCity)
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
    
    func loadMapWithCityLocation(mapView: GMSMapView, cityLocation: CLLocationCoordinate2D) {
                
        print("Latitude = ", cityLocation.latitude, " longitude = ", cityLocation.longitude)
        //Barcelona
        let camera = GMSCameraPosition.camera(withLatitude: cityLocation.latitude,
                                              longitude: cityLocation.longitude,
                                              zoom: MapConstants.zoomForCity)
        mapView.camera = camera
        mapView.isMyLocationEnabled = false
        mapView.settings.myLocationButton = false
        mapView.delegate = self
        
    }
    
    func createMarker(inMap map: GMSMapView, inPosition position: CLLocationCoordinate2D) -> GMSMarker {
        let marker = GMSMarker()
        
        let frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        marker.iconView = UIView(frame: frame)
        marker.groundAnchor = CGPoint.init(x: 0.5, y: 1.0)
        
        let imageView = UIImageView(frame: frame)
        imageView.image = UIImage(named: "cityLogo")
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.clipsToBounds = true
        marker.iconView?.addSubview(imageView)

        marker.position = position
        marker.map = map
        
        return marker
    }
    
    func createCityPolygons(inMap map: GMSMapView, polygonPath: String) -> GMSPolygon {
        let polygon = GMSPolygon()
        polygon.path = GMSPath(fromEncodedPath: polygonPath)
        polygon.fillColor = UIColor.redZone
        polygon.strokeColor = UIColor.redStroke
        polygon.strokeWidth = 2
        polygon.map = map
        return polygon
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
                if GMSGeometryIsLocationOnPathTolerance(coordinate,
                                                        gmsPath,
                                                        true,
                                                        CLLocationDistance(MapConstants.cityInfoOffset)) {
                    return true
                }
            }
        }
        return false
    }
    
    func getFirstLocationFromWorkingArea(polygonsPaths: [String]) -> CLLocationCoordinate2D? {
        for polygonPath in polygonsPaths {
            let path = GMSPath(fromEncodedPath: polygonPath)
            if let count = path?.count() {
                for index in 0...count {
                    if let coordinate = path?.coordinate(at: index) {
                        return coordinate
                    }
                }
            }
        }
        return nil
    }
}

extension MapManager: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        mapView.animate(toZoom: MapConstants.zoomForCity)
        mapView.animate(toLocation: marker.position)
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
        print("Camera position didDrag latitude = ", mapView.camera.target.latitude, " longitude = ", mapView.camera.target.longitude)
    }
    
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        print("Camera position didEndDragging latitude = ", mapView.camera.target.latitude, " longitude = ", mapView.camera.target.longitude)
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        print("Camera position idleAt latitude = ", position.target.latitude,
              " longitude = ", position.target.longitude,
              " zoom = ", position.zoom)
        if let delegate = self.delegate {
            delegate.cameraMoved(point: CGPoint(x: position.target.latitude, y: position.target.longitude))
            if self.zoom != position.zoom {
                self.zoom = position.zoom
                delegate.zoomChanged(zoom: position.zoom)
            }
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
