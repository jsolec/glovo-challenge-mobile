//
//  MapInteractor.swift
//  glovotest
//
//  Created Jesús Solé on 15/12/2018.
//  Copyright © 2018 Jesús Solé. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import ReactiveKit

class MapInteractor: MapInteractorProtocol {

    weak var presenter: MapPresenterProtocol?
    var cities: [CityModel]!
    var citySelected: CityModel?
    var countries: [CountryModel]?
    
    func drawCitiesPolygons() {
        for city in cities {
            if let cityCode = city.code, let workingArea = city.workingArea {
                self.presenter?.drawCityPolygons(cityCode: cityCode, workingArea: workingArea)
            }
        }
    }
    
    func moveCameraToCityCenter() -> CityModel? {
        return self.citySelected
    }
    
    func getCityOnPointInfo(point: CGPoint) {
        for city in self.cities {
            if let workingArea = city.workingArea {
                if MapManager.shared.isPointInsidePaths(point: point, polygonsPaths: workingArea),
                    let cityCode = city.code {
                    self.getCityInfo(code: cityCode)
                    return
                }
            }
        }
    }
    
    func getCityInfo(code: String) {
        let cityObserver = API.manager.getCityInfo(code: code)
        let _ = cityObserver.observeNext { (city) in
            self.presenter?.displayCityInfo(city: city)
        }
    }
    
    func getCitiesInfo() -> [CityModel]? {
        return self.cities
    }
}
