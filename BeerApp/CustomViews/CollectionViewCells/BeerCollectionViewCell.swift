//
//  BeerCollectionViewCell.swift
//  BeerApp
//
//  Created by Steven Van Durm on 19/12/17.
//  Copyright © 2017 iCapps. All rights reserved.
//

import UIKit

class BeerCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func updateCell(for beer: Beer) {
        let beerPhotoURL = beer.photoURL
        imageView.sd_setImage(with: beerPhotoURL, placeholderImage: UIImage(named: "beer.png"))
    }
}
