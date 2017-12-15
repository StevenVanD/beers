//
//  TableCell.swift
//  BeerApp
//
//  Created by student on 26/08/2017.
//  Copyright © 2017 iCapps. All rights reserved.
//

import UIKit

//Class for adding a label to the cells
class BeerTableCell: UITableViewCell {
    
    func updateCell(for beer: Beer, with brewery: Brewery) {
        let beerName = beer.name
        let beerBrewId = beer.breweryId
        let beerPhoto = beer.photoURL
        let beerRating = beer.rating
        
        textLabel?.text = beerName
        
        let breweryName = brewery.name
        detailTextLabel?.text = breweryName
        let photoUrlString = beerPhoto
        func downloadImage(url: URL) {
            getImageFromUrl(url: photoUrlString) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                DispatchQueue.main.async {
                    self.imageView?.image  = UIImage(data: data)
                }
            }
        }
        downloadImage(url: photoUrlString)
        
        if beerRating >= 0 {
            ratingLabel?.text = "\(beerRating)"
        } else {
            ratingLabel?.text = ""
        }
    }
    
    @IBOutlet weak var ratingLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func getImageFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
}
