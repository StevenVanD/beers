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
    
    var beersUpdateHandler:(() -> Void)?
    var breweriesUpdateHandler:(() -> Void)?
    var closestBrewery: Brewery?
    
    private weak var appDelegate = UIApplication.shared.delegate as? AppDelegate // swiftlint:disable:this force_cast
    
    public var locatiemanager = CLLocationManager()
    public var currentLocation = CLLocation()
    public var closestLocation: CLLocation?
    public var smallestDistance: CLLocationDistance?
    private var homeViewController: HomeViewController?
    
    var beers: [Beer]? {
        didSet {
            DispatchQueue.main.async {
                self.beersUpdateHandler?()
            }
        }
    }
    var breweries: [Brewery]? {
        didSet {
            DispatchQueue.main.async {
                self.breweriesUpdateHandler?()
            }
        }
    }
    
    init() {
        locatiemanager.delegate = self as? CLLocationManagerDelegate
        locatiemanager.requestAlwaysAuthorization()
        locatiemanager.startUpdatingLocation()
    }
    
}

// MARK: UI variables

extension HomeViewModel {
    
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        self.currentLocation = location
    }
    
    var closestBrewName: String {
        guard let closestBrewery = closestBrewery else {
            return "No closest brewery available"
        }
        return closestBrewery.name
    }
    
    var closestBrewAddress: String {
        guard let closestBrewery = closestBrewery else {
            return "No closest brewery available"
        }
        return closestBrewery.address
    }
}

// MARK: Functions

extension HomeViewModel {
    
    func setClosestBrewery() {
        guard let breweries = breweries else {
            return
        }
        for brew in breweries {
            let distance = self.currentLocation.distance(from: CLLocation(latitude: brew.lat, longitude: brew.lon))
            guard let afstand = self.smallestDistance else {
                self.closestLocation = self.currentLocation
                self.smallestDistance = distance
                self.closestBrewery = brew
                return
            }
            if  distance < afstand {
                self.closestLocation = self.currentLocation
                self.smallestDistance = distance
                self.closestBrewery = brew
            }
        }

    }
    
    func upDateBeerList(beerList: [Any], for index: Int) {
        beers = []
        breweries = []
        for beer in beerList {
            if let beer = beer as? [String: Any],
                let name = beer["name"] as? String,
                let imageString = beer["image_url"] as? String,
                let brewery = beer["brewery"] as? [String: Any],
                let id = brewery["id"] as? Int,
                let street = brewery["address"],
                let city = brewery["city"],
                let country = brewery["country"],
                let brewName = brewery["name"] {
                
                var breweryExists = false

                guard let imageURL = URL(string: imageString), let breweries = self.breweries else {
                    return
                }
                
                for brewery in breweries where brewery.id == id {
                    breweryExists = true
                }
                if breweryExists == false {
                    self.breweries?.append(Brewery(name: "\(brewName)", address: "\(street) \(city) \(country)", id: id))
                }
                
                if let rating = beer["rating"] as? Int {
                    self.beers?.append(Beer(name: name, photoURL: imageURL, breweryId: id, rating: rating))
                    
                } else {
                    if index == 0 {
                        self.beers?.append(Beer(name: name, photoURL: imageURL, breweryId: id, rating: -1))
                    }
                }

            } else {
                print("Problem parsing trackDictionary\n")
            }
            
        }
        setClosestBrewery()
    }
}
