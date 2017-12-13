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
    
    var beer: Beer?
    var brewery: Brewery?
    private var beerDetailViewController: BeerDetailViewController?

    init(beer : Beer, beerDetailViewController: BeerDetailViewController){
        self.beer = beer
        self.beerDetailViewController = beerDetailViewController
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
    
    func updateUI() {
        guard let viewController = beerDetailViewController else {
            return
        }
        viewController.nameLabel.text = beerName
        viewController.breweryLabel.text = breweryName
        viewController.addressLabel.text = breweryAddress
        if((beer?.rating)! >= 0){
            viewController.ratingLabel.text = beerRating
        }
        viewController.longLabel.text = "\(breweryLong)"
        viewController.latLabel.text = "\(breweryLat)"
    }
    
    func updateMap(){
        guard let viewModel = beerDetailViewController else {
            return
        }
        //Setting up the map and annotations (pins)
        let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: breweryLat, longitude: breweryLong)
        let annotation:MyAnnotation = MyAnnotation(coordinate: coordinate, title: beerName)
        viewModel.map.addAnnotation(annotation)
        viewModel.mapView(viewModel.map)
    }
}
