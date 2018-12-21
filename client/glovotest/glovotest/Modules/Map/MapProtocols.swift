//
//  MapProtocols.swift
//  glovotest
//
//  Created Jesús Solé on 15/12/2018.
//  Copyright © 2018 Jesús Solé. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import Foundation

//MARK: Wireframe -
protocol MapWireframeProtocol: class {

}
//MARK: Presenter -
protocol MapPresenterProtocol: class {
    func drawCitiesPolygons()
    func drawCityPolygons(workingArea: [String])
    func moveCameraToCityCenter() -> CityModel?
    
    func getCityOnPointInfo(point: CGPoint)
    
    func displayCityInfo(city: CityModel)
}

//MARK: Interactor -
protocol MapInteractorProtocol: class {

    var presenter: MapPresenterProtocol?  { get set }
    func drawCitiesPolygons()
    func moveCameraToCityCenter() -> CityModel?
    
    func getCityOnPointInfo(point: CGPoint)
    func getCityInfo(code: String)
}

//MARK: View -
protocol MapViewProtocol: class {

    var presenter: MapPresenterProtocol?  { get set }
    func drawCitiesPolygons()
    func drawCityPolygons(workingArea: [String])
    
    func displayCityInfo(city: CityModel)
}
