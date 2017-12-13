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
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    public var locatiemanager = CLLocationManager()
    public var currentLocation = CLLocation()
    public var closestLocation: CLLocation?
    public var smallestDistance: CLLocationDistance?
    private var homeViewController: HomeViewController?
    
    
    init(homeViewController:HomeViewController){
        locatiemanager.delegate = self as? CLLocationManagerDelegate
        locatiemanager.requestAlwaysAuthorization()
        locatiemanager.startUpdatingLocation()
        self.homeViewController = homeViewController
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
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        self.currentLocation = location
    }
    func setClosestBrewery(){
        guard let viewController = homeViewController else {
            return
        }
        let closestBrewName = self.closestBrewery?.name
        let closestBrewAddress = self.closestBrewery?.address
        for brew in self.breweries {
            let distance = self.currentLocation.distance(from: CLLocation(latitude: brew.lat, longitude: brew.lon))
            guard let afstand = self.smallestDistance else{
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
        viewController.brewNameLabel.text = closestBrewName
        viewController.brewAddressLabel.text = closestBrewAddress
    }
    
    func getData() {
        guard let viewController = homeViewController else {
            return
        }
        guard let tableView = viewController.tableView else {
            return
        }
        setClosestBrewery()
        tableView.reloadData()
    }
    func upDateBeerList(beerList: [Any]){
        guard let viewController = homeViewController else {
            return
        }
        guard let segment = viewController.segment else {
            return
        }
        beers = []
        breweries = []
        for beer in beerList{
            if let beer = beer as? [String: Any],
                let name = beer["name"] as? String,
                let imageString = beer["image_url"] as? String,
                let brewery = beer["brewery"] as? [String: Any],
                let id = brewery["id"] as? Int,
                let street = brewery["address"],
                let city = brewery["city"],
                let country = brewery["country"],
                let brewName = brewery["name"]{
                
                var breweryExists = false
                
                guard let imageURL = URL(string: imageString) else {
                    return
                }
                for brewery in breweries{
                    if brewery.id == id {
                        breweryExists = true
                    }
                }
                if breweryExists == false{
                    breweries += [Brewery(name: "\(brewName)", address: "\(street) \(city) \(country)", id: id)]
                }
                if let rating = beer["rating"] as? Int{
                    beers += [Beer(name: name, photoURL: imageURL, breweryId: id, rating: rating) ]
                }else{
                    if segment.selectedSegmentIndex == 0 {
                        beers += [Beer(name: name, photoURL: imageURL, breweryId: id, rating: -1) ]
                    }
                }
            }
            else{
                print("Problem parsing trackDictionary\n")
            }
        }
        getData()
    }
}
