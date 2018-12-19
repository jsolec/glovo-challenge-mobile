//
//  CountryModel.swift
//  glovotest
//
//  Created by Jesús Solé on 15/12/2018.
//  Copyright © 2018 Jesús Solé. All rights reserved.
//

import UIKit
import ObjectMapper

class CountryModel: Mappable {
    var code: String?
    var name: String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        code <- map["code"]
        name <- map["name"]
    }
}

extension CountryModel: Hashable {
    static func == (lhs: CountryModel, rhs: CountryModel) -> Bool {
        if let lhsCode = lhs.code, let rhsCode = rhs.code {
            return lhsCode == rhsCode
        }
        return false
    }
    
    var hashValue: Int {
        return ObjectIdentifier(self).hashValue
    }
}
