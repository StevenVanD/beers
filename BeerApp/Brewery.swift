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
    
    init(name: String, address: String ){
        self.name = name
        self.address = address
        self.lat = 0
        self.lon = 0
        
        //Using the geoCoder to get the longitude and latitude from the address of the brewery
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(self.address) {
            placemarks, error in
            let placemark = placemarks?.first
            let lat = placemark?.location?.coordinate.latitude
            let lon = placemark?.location?.coordinate.longitude
            self.lat = lat!
            self.lon = lon!
        }
    }
}
