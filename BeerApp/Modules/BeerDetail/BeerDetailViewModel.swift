//
//  BeerDetailViewModel.swift
//  BeerApp
//
//  Created by Steven Van Durm on 8/12/17.
//  Copyright © 2017 iCapps. All rights reserved.
//

import Foundation
import MapKit

public final class BeerDetailViewModel {
    
    var beerUpdateHandler:(() -> Void)?
    var breweryUpdateHandler:(() -> Void)?
    
    var beer: Beer? {
        didSet {
            DispatchQueue.main.async {
                self.beerUpdateHandler?()
            }
        }
    }
    
    var brewery: Brewery? {
        didSet {
            DispatchQueue.main.async {
                self.breweryUpdateHandler?()
            }
        }
    }
    
}

// MARK: UI variables

extension BeerDetailViewModel {
    
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
        if beer.rating >= 0 {
            return "\(beer.rating)"
        } else {
            return ""
        }
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
    
    var breweryLong: Double {
        guard let brewery = brewery else {
            return 0
        }
        return brewery.lon
    }
    
    var breweryLat: Double {
        guard let brewery = brewery else {
            return 0
        }
        return brewery.lat
    }
    
    var breweryLongString: String {
        return "\(breweryLong.format(value: ".2"))"
    }
    
    var breweryLatString: String {
        return "\(breweryLat.format(value: ".2"))"
    }
    
    var beerPhotoURL: URL {
        guard let beer = beer else {
            return URL(fileURLWithPath: "https://www.google.be/url?sa=i&rct=j&q=&esrc=s&source=images&cd=&cad=rja&uact=8&ved=0ahUKEwitkdetvZvYAhXNZlAKHTVjAxQQjRwIBw&url=https%3A%2F%2Fwww.istockphoto.com%2Fphotos%2Fbeer-glass&psig=AOvVaw2avQhricobwQdT5AB8ZqYd&ust=1513958580077176")
        }
        return beer.photoURL
    }
}

// MARK: Map & Annotation variables

extension BeerDetailViewModel {
    func downloadImage(url: URL, imageView: UIImageView) {
        imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "beer.png"))
    }
    var region: MKCoordinateRegion {
        let center = CLLocationCoordinate2D(latitude: breweryLat, longitude: breweryLong)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        return region
    }
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: breweryLat, longitude: breweryLong)
    }
    
    var annotation: MyAnnotation {
        return MyAnnotation(coordinate: coordinate, title: beerName)
    }
}
