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
        viewController.brewNameLabel.text = self.closestBrewery?.name
        viewController.brewAddressLabel.text = self.closestBrewery?.address
    }

    
    func getBeers() -> Void{
        beers = []
        breweries = []
        guard let url = URL(string: "https://icapps-beers.herokuapp.com/beers") else {
            print ("geen url kunnen aanmaken")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = [
            "accept": "application/json",
            "content-type": "application/json",
            "authorization": "Token token=kVJzYfn9gRaGDFNrtMDuAexP"
        ]
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let _ = session.dataTask(with: urlRequest) {
            (data, response, error) in
            
            guard error == nil else {
                print("error calling GET")
                return
            }
            
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            do {
                guard let greeting = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject] else {
                    print("error trying to convert data to JSON")
                    return
                }
                guard let beerList = greeting["beers"] as? [AnyObject] else {
                    print("fail")
                    return
                }
                
                for beer in beerList{
                    if let beer = beer as? [String: Any],
                        let name = beer["name"],
                        let imageString = beer["image_url"],
                        let brewery = beer["brewery"] as? [String: Any],
                        let id = brewery["id"] as? Int,
                        let street = brewery["address"],
                        let city = brewery["city"],
                        let country = brewery["country"],
                        let brewName = brewery["name"]{
                        
                        var breweryExists = false
                        for brewery in self.breweries{
                            print("\(brewery.name): \(brewery.id)")
                            if brewery.id == id {
                                breweryExists = true
                            }
                        }
                        if breweryExists == false{
                            self.breweries += [Brewery(name: "\(brewName)", address: "\(street) \(city) \(country)", id: id)]
                        }
                        if let rating = beer["rating"] as? Int{
                            self.beers += [Beer(name: "\(name)", photo: imageString as! String, brewery: id, rating: rating) ]
                        }else{
                            self.beers += [Beer(name: "\(name)", photo: imageString as! String, brewery: id, rating: -1) ]
                        }
                    }
                    else{
                        print("Problem parsing trackDictionary\n")
                    }
                }
                
            }catch  {
                print("error trying to convert data to JSON")
                return
            }
        }.resume()
        getData()
    }
    
    func getData() {
        guard let viewController = homeViewController else {
            return
        }
        setClosestBrewery()
        viewController.tableView.reloadData()
    }
}
