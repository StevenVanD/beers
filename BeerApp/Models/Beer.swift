//
//  Beer.swift
//  BeerApp
//
//  Created by student on 22/08/2017.
//  Copyright © 2017 iCapps. All rights reserved.
//

import Foundation

class Beer {
    var name: String
    var photoURL: URL
    var breweryId: Int
    var rating: Int

    init(name: String, photoURL: URL, breweryId: Int, rating: Int) {
        self.name = name
        self.photoURL = photoURL
        self.breweryId = breweryId
        self.rating = rating
    }
}
