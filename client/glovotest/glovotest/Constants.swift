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
}

struct Network {
    static let baseUrl = "http://localhost:3000/api/"
    static let countries = "countries/"
    static let cities = "cities/"
}

enum ClientError: Error {
    case error
}

struct CellsIdentifier {
    static let cityCell = "CityCell"
}
