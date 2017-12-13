//
//  Beer.swift
//  BeerApp
//
//  Created by student on 22/08/2017.
//  Copyright © 2017 iCapps. All rights reserved.
//

import UIKit
import Foundation

class Beer{
    var name: String
    var photo: String
    var breweryId: Int
    var rating: Int

    init(name: String, photo: String, breweryId: Int, rating: Int){
        self.name = name
        self.photo = photo
        self.breweryId = breweryId
        self.rating = rating
        
    }
}
