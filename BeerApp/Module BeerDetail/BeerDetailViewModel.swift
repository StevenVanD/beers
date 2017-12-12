//
//  BeerDetailViewModel.swift
//  BeerApp
//
//  Created by Steven Van Durm on 8/12/17.
//  Copyright © 2017 iCapps. All rights reserved.
//

import Foundation

public final class BeerDetailViewModel {
    
    var beer: Beer?
    var brewery: Brewery?
    
    init(beer : Beer) {
        self.beer = beer
    }
    
    
    var beerName: String {
        guard let beer = beer else {
            return "No beer name available"
        }
        return beer.name
    }
    var beerRating: String {
        guard let beer = beer else {
            return "No rating available"
        }
        return "\(beer.rating)"
    }
    
    var breweryName: String {
        guard let brewery = brewery else {
            return "No brewery name available"
        }
        return brewery.name
    }
    
    var breweryAddress: String {
        guard let brewery = brewery else {
            return "No address available"
        }
        return brewery.address
    }
    
    var breweryLong: String {
        guard let brewery = brewery else {
            return "No longitude available"
        }
        return "\(brewery.lon)"
    }
    
    var breweryLat: String {
        guard let brewery = brewery else {
            return "No latitude available"
        }
        return "\(brewery.lat)"
    }
    
}
