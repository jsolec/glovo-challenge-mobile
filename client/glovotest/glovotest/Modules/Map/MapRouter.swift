//
//  MapRouter.swift
//  glovotest
//
//  Created Jesús Solé on 15/12/2018.
//  Copyright © 2018 Jesús Solé. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class MapRouter: MapWireframeProtocol {
    
    weak var viewController: UIViewController?
    
    static func createModule(cities: [CityModel], citySelected: CityModel? = nil) -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = MapViewController(nibName: nil, bundle: nil)
        let interactor = MapInteractor()
        let router = MapRouter()
        let presenter = MapPresenter(interface: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        
        interactor.cities = cities
        interactor.citySelected = citySelected
        
        return view
    }
}
