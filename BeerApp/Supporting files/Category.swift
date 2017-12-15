//
//  Category.swift
//  BeerApp
//
//  Created by Steven Van Durm on 15/12/17.
//  Copyright © 2017 iCapps. All rights reserved.
//

import Foundation

extension Double {
    
    func format(value: String) -> String {
        return String(format: "%\(value)f", self)
    }
}
