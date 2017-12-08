//
//  MyAnnotation.swift
//  BeerApp
//
//  Created by student on 27/08/2017.
//  Copyright © 2017 iCapps. All rights reserved.
//

import Foundation
import UIKit
import MapKit

//Class for the pins on the map
class MyAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    override init(){
        coordinate = CLLocationCoordinate2D()
        title = ""
    }
    
    init(coordinate:CLLocationCoordinate2D, title:String) {
        self.coordinate = coordinate
        self.title = title
    }
}
