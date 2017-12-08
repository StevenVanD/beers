//
//  HomeViewModel.swift
//  BeerApp
//
//  Created by Steven Van Durm on 8/12/17.
//  Copyright © 2017 iCapps. All rights reserved.
//

import UIKit

public final class HomeViewModel {

    var beers: [Beer]
    var breweries: [Brewery]
//    public let brewNameText: String
//    public let brewAddressText: String
//    public let segmentState: Bool

    init(beers: [Beer], breweries: [Brewery]){
        self.beers = beers
        self.breweries = breweries
        
    }
}
