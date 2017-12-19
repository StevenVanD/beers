//
//  BeerTableCell.swift
//  BeerApp
//
//  Created by student on 26/08/2017.
//  Copyright © 2017 iCapps. All rights reserved.
//

import UIKit
import SDWebImage

class BeerTableCell: UITableViewCell {

    @IBOutlet weak var ratingLabel: UILabel!

    func updateCell(for beer: Beer, with brewery: Brewery) {
        textLabel?.text = beer.name
        detailTextLabel?.text = brewery.name
        downloadImage(url: beer.photoURL)
        ratingLabel.text = beer.rating >= 0 ? "\(beer.rating)" : ""
    }
    
    func downloadImage(url: URL) {
        imageView?.sd_setImage(with: url, placeholderImage: UIImage(named: "beer.png"))
    }
}
