//
//  Netwerk.swift
//  BeerApp
//
//  Created by Steven Van Durm on 12/12/17.
//  Copyright © 2017 iCapps. All rights reserved.
//

import Foundation

struct Netwerk {
    public var homeViewModel: HomeViewModel?
    init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
    }
    
    func getBeers() {
        guard let homeViewModel = homeViewModel else {
            return
        }
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
        
        loadBeers()
    }
    func loadBeers() {
        _ = session.dataTask(with: urlRequest) { (_, _, error) in
            
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
                
                addBeers()

            } catch {
                print("error trying to convert data to JSON")
                return
            }
            } .resume()
    }
    func addBeers() {
        for beer in beerList {
            print(beer)
            if let beer = beer as? [String: Any],
                let name = beer["name"],
                let imageString = beer["image_url"],
                let brewery = beer["brewery"] as? [String: Any],
                let id = brewery["id"] as? Int,
                let straat = brewery["address"],
                let stad = brewery["city"],
                let land = brewery["country"],
                let brewName = brewery["name"] {
                
                var breweryExists = false
                for brewery in homeViewModel.breweries where brewery.id == id {
                    breweryExists = true
                    
                }
                if breweryExists == false {
                    homeViewModel.breweries += [Brewery(name: "\(brewName)", address: "\(straat) \(stad) \(land)", id: id)]
                }
                if let score = beer["rating"] as? Int {
                    homeViewModel.beers += [Beer(name: "\(name)", photo: imageString as! String, brewery: id, score: score) ] // swiftlint:disable:this force_cast
                } else {
                    homeViewModel.beers += [Beer(name: "\(name)", photo: imageString as! String, brewery: id, score: -1) ] // swiftlint:disable:this force_cast
                }
            } else {
                print("Problem parsing trackDictionary\n")
            }
        }
    }
}
