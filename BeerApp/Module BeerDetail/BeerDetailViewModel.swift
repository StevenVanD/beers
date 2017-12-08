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
    public let nameText: String
    public let breweryText: String
    public let addressText: String
    public let ratingText: String
    public let longText: String
    public let latText: String
    
    init(){
        self.nameText = ""
        self.breweryText = ""
        self.addressText = ""
        self.ratingText = ""
        self.longText = ""
        self.latText = ""
    }
    
}
