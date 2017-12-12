//
//  Brewery.swift
//  BeerApp
//
//  Created by student on 25/08/2017.
//  Copyright © 2017 iCapps. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

class Brewery{
    var name: String
    var address: String
    var lat: Double
    var lon: Double
    var id: Int
    
    init(name: String, address: String, id: Int){
        self.name = name
        self.address = address
        self.lat = 0
        self.lon = 0
        self.id = id
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(self.address) {
            placemarks, error in
            let placemark = placemarks?.first
            guard let lat = placemark?.location?.coordinate.latitude else{
                return
            }
            guard let lon = placemark?.location?.coordinate.longitude else{
                return
            }
            self.lat = lat
            self.lon = lon
        }
    }
}
