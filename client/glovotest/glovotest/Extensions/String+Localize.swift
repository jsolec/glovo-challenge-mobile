//
//  String+Localize.swift
//  glovotest
//
//  Created by Jesús Solé on 14/12/2018.
//  Copyright © 2018 Jesús Solé. All rights reserved.
//

import UIKit

extension String {
    var localize: String {
        return NSLocalizedString(self, comment: "")
    }
}
