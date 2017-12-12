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
        
        for brew in self.breweries {
            let distance = self.currentLocation.distance(from: CLLocation(latitude: brew.lat, longitude: brew.lon))
            if self.smallestDistance == nil || distance < self.smallestDistance! {
                self.closestLocation = location
                self.smallestDistance = distance
                self.closestBrewery = brew
            }
        }
        homeViewController?.brewNameLabel.text = self.closestBrewery?.name
        homeViewController?.brewAddressLabel.text = self.closestBrewery?.address
    }
    func update() {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            let loadedBeers = try context.fetch(Beers.fetchRequest()) as! [Beers]
            for b in loadedBeers{
                context.delete(b)
                
            }
        } catch {
            print("Fetching Failed")
        }
        
        do {
            let loadedBreweries = try context.fetch(Breweries.fetchRequest()) as! [Breweries]
            for brew in loadedBreweries{
                context.delete(brew)
            }
        } catch {
            print("Fetching Failed")
        }
        
        do{
            try context.save()
        }
        catch{
        }
        
        beers.removeAll()
        breweries.removeAll()
        
        getBeers()
    }
    
    func getBeers(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
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
                print(error!)
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
                        let brewery = beer["brewery"] as? [String: Any],
                        let id = brewery["id"] as? Int,
                        let straat = brewery["address"],
                        let stad = brewery["city"],
                        let land = brewery["country"],
                        let brewName = brewery["name"]{
                        
                        var breweryExists = false
                        for brewery in self.breweries{
                            if brewery.id == id {
                                breweryExists = true
                            }
                        }
                        if breweryExists == false{
                            self.breweries += [Brewery(name: "\(brewName)", address: "\(straat) \(stad) \(land)", id: id)]
                        }
                        if let score = beer["rating"] as? Int{
                            self.beers += [Beer(name: "\(name)", photo: "beer.png", brewery: id, score: score) ]
                        }else{
                            self.beers += [Beer(name: "\(name)", photo: "beer.png", brewery: id, score: -1) ]
                        }
                    }
                    else{
                        print("Problem parsing trackDictionary\n")
                    }
                }
                for b in self.breweries{
                    let brewery = Breweries(context: context)
                    brewery.name = b.name
                    brewery.address = b.address
                    brewery.id = Int16(b.id)
                    do{
                        try context.save()
                    }catch{
                        fatalError("Failed to save context: \(error)")
                    }
                }
                for b in self.beers{
                    let beer = Beers(context: context)
                    beer.name = b.name
                    beer.photoLink = b.photo as String
                    beer.brewery = Int64(b.brewery)
                    beer.score = Int16(b.score)
                    do{
                        try context.save()
                        
                    }catch{
                        fatalError("Failed to save context: \(error)")
                    }
                }
                
            }catch  {
                print("error trying to convert data to JSON")
                return
            }
            }.resume()
    }
    func getData() {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        
        self.beers = []
        self.breweries = []
        
        
        do {
            let loadedBreweries = try context.fetch(Breweries.fetchRequest()) as! [Breweries]
            for brew in loadedBreweries{
                self.breweries += [Brewery(name: brew.name!, address: brew.address!, id: Int(brew.id))]
            }
        } catch {
            print("Fetching Failed")
        }
        
        do {
            let loadedBeers = try context.fetch(Beers.fetchRequest()) as! [Beers]
            for b in loadedBeers{
                if(homeViewController?.segment.selectedSegmentIndex == 0){
                    self.beers += [Beer(name: b.name!, photo: b.photoLink!, brewery: Int(b.brewery), score: Int(b.score))]
                }else if(b.score >= 0){
                    self.beers += [Beer(name: b.name!, photo: b.photoLink!, brewery: Int(b.brewery), score: Int(b.score))]
                }
            }
        } catch {
            print("Fetching Failed")
        }
        homeViewController?.tableView.reloadData()
    }
    
}
