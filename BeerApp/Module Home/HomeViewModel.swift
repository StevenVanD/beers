//
//  HomeViewModel.swift
//  BeerApp
//
//  Created by Steven Van Durm on 8/12/17.
//  Copyright © 2017 iCapps. All rights reserved.
//

import UIKit
import CoreLocation

public final class HomeViewModel {

    var beers: [Beer] = []
    var breweries: [Brewery] = []
    var closestBrewery: Brewery?
    
    public let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    public var locatiemanager = CLLocationManager()
    public var currentLocation = CLLocation()
    public var closestLocation: CLLocation?
    public var smallestDistance: CLLocationDistance?
    

    init(){
        locatiemanager.delegate = self as? CLLocationManagerDelegate
        locatiemanager.requestAlwaysAuthorization()
        locatiemanager.startUpdatingLocation()
        
    }
    
    var breweryClosestName: String {
        guard let closestBrewery = closestBrewery else {
            return "No name available"
        }
        
        return closestBrewery.name
    }
    
    var breweryClosestAddress: String {
        guard let closestBrewery = closestBrewery else {
            return "No name available"
        }
        
        return closestBrewery.address
    }
    
}
