//
//  BeerService.swift
//  BeerApp
//
//  Created by Steven Van Durm on 13/12/17.
//  Copyright © 2017 iCapps. All rights reserved.
//

import Foundation

class Service {
    
    let beerURL =  URL(string: "https://icapps-beers.herokuapp.com/beers")
    let headers = [ "accept": "application/json",
                    "content-type": "application/json",
                    "authorization": "Token token=kVJzYfn9gRaGDFNrtMDuAexP"
                ]
    
    func getBeers(completion: @escaping (_ error: Error?, _ result: [Any]?) -> Void) {
        
        guard let url = beerURL else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.allHTTPHeaderFields = headers
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        _ = session.dataTask(with: urlRequest) { (data, _, error) in
            
            if let error = error {
                print("error calling GET")
                completion(error, nil)
            }
            
            guard let responseData = data else {
                print("Error: did not receive data")
                // TODO: Make custom error object to return here
                completion(nil, nil)
                return
            }
            
            do {
                guard let greeting = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject] else {
                    print("error trying to convert data to JSON")
                    // TODO: Make custom error object to return here
                    completion(nil, nil)
                    return
                }
                guard let beerList = greeting["beers"] as? [AnyObject] else {
                    print("fail")
                    // TODO: Make custom error object to return here
                    completion(nil, nil)
                    return
                }
                completion(nil, beerList)
            } catch {
                print("error trying to convert data to JSON")
                return
            }
        }.resume()
    }
}
