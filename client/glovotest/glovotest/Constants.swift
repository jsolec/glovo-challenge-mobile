//
//  Constants.swift
//  glovotest
//
//  Created by Jesús Solé on 12/12/2018.
//  Copyright © 2018 Jesús Solé. All rights reserved.
//

import UIKit

struct Fonts {
    static let homeTitle = UIFont(name: "Helvetica", size: 36)
    static let cityInfo = UIFont(name: "Helvetica", size: 16)
}

struct Network {
    static let baseUrl = "http://192.168.1.134:3000/api/"
    static let countries = "countries/"
    static let cities = "cities/"
}

enum ClientError: Error {
    case error
}

struct CellsIdentifier {
    static let cityCell = "CityCell"
}

struct MapConstants {
    static let cityInfoOffset = 10000
    static let zoomForLogo: Float = 8.0
    static let zoomForCity: Float = 13.0
    static let minCameraDistance: Float = 100000.0 //100Km
}
