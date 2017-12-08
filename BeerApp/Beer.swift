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
    var brewery: Int
    var score: Int

    init(name: String, photo: String, brewery: Int, score: Int){
        self.name = name
        self.photo = photo
        self.brewery = brewery
        self.score = score
        
    }
}
