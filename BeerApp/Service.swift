//
//  BeerService.swift
//  BeerApp
//
//  Created by Steven Van Durm on 13/12/17.
//  Copyright © 2017 iCapps. All rights reserved.
//

import Foundation

class Service {
    public var homeViewModel: HomeViewModel?
    init(homeViewModel: HomeViewModel){
        self.homeViewModel = homeViewModel
    }
    func getBeers() -> Void{
        guard let viewModel = homeViewModel else {
            return
        }
        viewModel.beers = []
        viewModel.breweries = []
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
                        for brewery in viewModel.breweries{
                            if brewery.id == id {
                                breweryExists = true
                            }
                        }
                        if breweryExists == false{
                            viewModel.breweries += [Brewery(name: "\(brewName)", address: "\(street) \(city) \(country)", id: id)]
                        }
                        if let rating = beer["rating"] as? Int{
                            viewModel.beers += [Beer(name: name, photoURL: imageURL, breweryId: id, rating: rating) ]
                        }else{
                            viewModel.beers += [Beer(name: name, photoURL: imageURL, breweryId: id, rating: -1) ]
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
        viewModel.getData()
    }
}
