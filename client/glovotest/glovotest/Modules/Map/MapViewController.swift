//
//  MapViewController.swift
//  glovotest
//
//  Created Jesús Solé on 15/12/2018.
//  Copyright © 2018 Jesús Solé. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import GoogleMaps
import SnapKit

class MapViewController: UIViewController, MapViewProtocol {

	var presenter: MapPresenterProtocol?
    
    var mapView: GMSMapView!
    
    var cityInfoView: UIView!
    var cityNameLabel: UILabel!
    var cityCurrencyLabel: UILabel!
    var cityEnabledLabel: UILabel!
    var cityBusyLabel: UILabel!
    var cityTimeZoneLabel: UILabel!
    
    var cityLogoDictionary: Dictionary<String, GMSMarker>?
    var cityPolygonsDictionary: Dictionary<String, [GMSPolygon]>!

	override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }

    func setup() {
        self.setCityView()
        self.setMapView()
        
        self.cityPolygonsDictionary = Dictionary<String, [GMSPolygon]>()
        
        MapManager.shared.delegate = self
        
        if let city = self.presenter?.moveCameraToCityCenter(),
            let workingArea = city.workingArea,
            let coordinate = MapManager.shared.getFirstLocationFromWorkingArea(polygonsPaths: workingArea) {
            MapManager.shared.loadMapWithCityLocation(mapView: self.mapView, cityLocation: coordinate)
        } else {
            MapManager.shared.loadMap(mapView: self.mapView)
        }
        
        self.drawCitiesPolygons()
    }
    
    func setCityView() {
        self.cityInfoView = UIView()
        self.view.addSubview(self.cityInfoView)
        
        self.cityInfoView.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            if #available(iOS 11.0, *) {
                maker.top.equalTo(self.view.safeAreaLayoutGuide)
            } else {
                maker.top.equalTo(self.view.layoutMarginsGuide)
            }
        }
        self.cityNameLabel = UILabel()
        self.cityNameLabel.font = Fonts.cityInfo
        self.cityInfoView.addSubview(self.cityNameLabel)
        
        self.cityCurrencyLabel = UILabel()
        self.cityCurrencyLabel.font = Fonts.cityInfo
        self.cityInfoView.addSubview(self.cityCurrencyLabel)
        
        self.cityEnabledLabel = UILabel()
        self.cityEnabledLabel.font = Fonts.cityInfo
        self.cityInfoView.addSubview(self.cityEnabledLabel)
        
        self.cityBusyLabel = UILabel()
        self.cityBusyLabel.font = Fonts.cityInfo
        self.cityInfoView.addSubview(self.cityBusyLabel)
        
        self.cityTimeZoneLabel = UILabel()
        self.cityTimeZoneLabel.font = Fonts.cityInfo
        self.cityInfoView.addSubview(self.cityTimeZoneLabel)
        
        self.cityNameLabel.snp.makeConstraints { (maker) in
            maker.top.leading.trailing.equalTo(10)
        }
        
        self.cityCurrencyLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.cityNameLabel.snp_bottomMargin).offset(10)
            maker.leading.equalTo(self.cityNameLabel)
            maker.width.equalTo(self.cityEnabledLabel)
        }

        self.cityEnabledLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.cityCurrencyLabel)
            maker.leading.equalTo(self.cityCurrencyLabel.snp_trailingMargin).offset(10)
            maker.trailing.equalTo(self.cityNameLabel)
            maker.width.equalTo(self.cityCurrencyLabel)
        }

        self.cityBusyLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.cityCurrencyLabel.snp_bottomMargin).offset(10)
            maker.leading.equalTo(self.cityNameLabel)
            maker.width.equalTo(self.cityTimeZoneLabel)
            maker.bottom.equalTo(self.cityInfoView.snp_bottomMargin).offset(-10)
        }

        self.cityTimeZoneLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.cityBusyLabel)
            maker.leading.equalTo(self.cityBusyLabel.snp_trailingMargin).offset(10)
            maker.trailing.equalTo(self.cityNameLabel)
            maker.width.equalTo(self.cityBusyLabel)
        }
    }
    
    func setMapView() {
        self.mapView = GMSMapView()
        self.view.addSubview(self.mapView)
        
        self.mapView.snp.makeConstraints { (maker) in
            maker.width.equalTo(self.view)
            maker.top.equalTo(self.cityInfoView.snp_bottomMargin)
            maker.bottom.equalTo(self.view)
        }
    }
    
    func drawCitiesPolygons() {
        self.presenter?.drawCitiesPolygons()
    }
    
    func drawCityPolygons(cityCode: String, workingArea: [String]) {
        if MapManager.shared.isWorkingAreaVisible(map: self.mapView, polygonsPaths: workingArea),
            !self.cityPolygonsDictionary.keys.contains(cityCode) {
            var polygonsArray = [GMSPolygon]()
            for area in workingArea {
                let polygon = MapManager.shared.createCityPolygons(inMap: self.mapView, polygonPath: area)
                polygonsArray.append(polygon)
            }
            self.cityPolygonsDictionary[cityCode] = polygonsArray
        } else if !MapManager.shared.isWorkingAreaVisible(map: self.mapView, polygonsPaths: workingArea),
            self.cityPolygonsDictionary.keys.contains(cityCode) {
            for polygon in self.cityPolygonsDictionary![cityCode]! {
                polygon.map = nil
            }
            self.cityPolygonsDictionary.removeValue(forKey: cityCode)
        }
    }
    
    func displayCityInfo(city: CityModel) {
        DispatchQueue.main.async {
            self.cityNameLabel.text = "kCityName".localize + (city.name ?? "")
            self.cityCurrencyLabel.text = "kCityCurrency".localize + (city.currency ?? "")
            self.cityEnabledLabel.text = "kCityEnabled".localize + (city.enabled?.description ?? "")
            self.cityBusyLabel.text = "kCityBusy".localize + (city.busy?.description ?? "")
            self.cityTimeZoneLabel.text = "kCityTimeZone".localize + (city.timeZone ?? "")
        }
    }
    
    func drawCityIcons() {
        if let dictionary = self.cityLogoDictionary {
            for key in dictionary.keys {
                let marker = dictionary[key]
                marker?.iconView?.isHidden = false
            }
        } else {
            self.cityLogoDictionary = Dictionary<String, GMSMarker>()
            if let cities = self.presenter?.getCitiesInfo() {
                for city in cities {
                    if let cityCode = city.code,
                        let workingArea = city.workingArea {
                        if let coordinate = MapManager.shared.getFirstLocationFromWorkingArea(polygonsPaths: workingArea) {
                            let marker = MapManager.shared.createMarker(inMap: self.mapView, inPosition: coordinate)
                            self.cityLogoDictionary![cityCode] = marker
                        }
                    }
                }
            }
        }
    }
    
    func deleteAllPolygons() {
        for key in self.cityPolygonsDictionary!.keys {
            for polygon in self.cityPolygonsDictionary![key]! {
                polygon.map = nil
            }
            self.cityPolygonsDictionary!.removeValue(forKey: key)
        }
    }
    
    func deleteAllMarkers() {
        if let dictionary = self.cityLogoDictionary {
            for key in dictionary.keys {
                let marker = dictionary[key]
                marker?.iconView?.isHidden = true
            }
        }
    }
}

extension MapViewController: MapManagerDelegate {
    func cameraMoved(zoom: Float, point: CGPoint) {
        self.presenter?.getCityOnPointInfo(point: point)
        if zoom > MapConstants.zoomForLogo {
            self.drawCitiesPolygons()
        }
    }
    
    func zoomChanged(zoom: Float) {
        if zoom <= MapConstants.zoomForLogo {
            self.drawCityIcons()
            self.deleteAllPolygons()
        } else {
            self.deleteAllMarkers()
        }
    }
}
