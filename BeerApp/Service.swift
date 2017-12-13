//
//  BeerService.swift
//  BeerApp
//
//  Created by Steven Van Durm on 13/12/17.
//  Copyright © 2017 iCapps. All rights reserved.
//

import Foundation

class Service {
    var beerList: [Any] = []

    func getBeers() -> [Any]{

        guard let url = URL(string: "https://icapps-beers.herokuapp.com/beers") else {
            print ("geen url kunnen aanmaken")
            return[]
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
                self.beerList = beerList
                
            }catch  {
                print("error trying to convert data to JSON")
                return
            }
            }.resume()
        return beerList
    }
}
