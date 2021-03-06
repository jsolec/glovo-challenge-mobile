//
//  HomeRouter.swift
//  glovotest
//
//  Created Jesús Solé on 12/12/2018.
//  Copyright © 2018 Jesús Solé. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class HomeRouter: HomeWireframeProtocol {
    
    weak var viewController: UIViewController?
    
    static func createModule() -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = HomeViewController(nibName: nil, bundle: nil)
        let interactor = HomeInteractor()
        let router = HomeRouter()
        let presenter = HomePresenter(interface: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
    
    func presentMapModule(cities: [CityModel]) {
        let mapController = MapRouter.createModule(cities: cities)
        self.viewController?.present(mapController, animated: true, completion: nil)
    }
    
    func presentCityListModule(cities: [CityModel]) {
        let cityListController = CityListRouter.createModule(cities: cities)
        self.viewController?.present(cityListController, animated: true, completion: nil)
    }
}
