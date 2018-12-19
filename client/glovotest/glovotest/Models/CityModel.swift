//
//  CityModel.swift
//  glovotest
//
//  Created by Jesús Solé on 15/12/2018.
//  Copyright © 2018 Jesús Solé. All rights reserved.
//

import UIKit
import ObjectMapper

class CityModel: Mappable {
    var code: String?
    var name: String?
    var countryCode: String?
    var currency: String?
    var enabled: Bool?
    var busy: Bool?
    var timeZone: String?
    var languageCode: String?
    var workingArea: [String]?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        code <- map["code"]
        name <- map["name"]
        countryCode <- map["country_code"]
        currency <- map["currency"]
        enabled <- map["enabled"]
        busy <- map["busy"]
        timeZone <- map["time_zone"]
        languageCode <- map["language_code"]
        workingArea <- map["working_area"]
    }
}
