//
//  HomeViewModelTests.swift
//  BeerAppTests
//
//  Created by Steven Van Durm on 18/12/17.
//  Copyright © 2017 iCapps. All rights reserved.
//

import XCTest
import CoreLocation
@testable import BeerApp

class HomeViewModelTests: XCTestCase {
    
    var locatiemanager = CLLocationManager()
    var currentLocation = CLLocation()
    var smallestDistance: CLLocationDistance?
    var closestBrewery: Brewery?

    var sut: HomeViewModel = HomeViewModel()
    
    override func setUp() {
        super.setUp()
        setupMocks()
    }
    
    func setupMocks() {
        if let mockUrl = URL(string: "https://google.com") {
            let mockBeer = Beer(name: "Beer1", photoURL: mockUrl, breweryId: 1, rating: 1)
            let mockBeer2 = Beer(name: "Beer2", photoURL: mockUrl, breweryId: 2, rating: 1)
            sut.beers = [mockBeer, mockBeer2]
        }

        let mockBrewery = Brewery(name: "Brewery1", address: "BreweryStreet 1", id: 1)
        let mockBrewery2 = Brewery(name: "Brewery2", address: "Linthout 1", id: 2)
        sut.breweries = [mockBrewery, mockBrewery2]
    }
    
    func testSutShouldHave1Beer() {
        XCTAssertEqual(sut.beers?.count, 2)
    }
    
    func testSutShouldHave1Brewery() {
        XCTAssertEqual(sut.breweries?.count, 2)
    }
    
    func testSutShouldHaveMoreOrEqualBeersThenBreweries() {
        if let beers = sut.beers, let breweries = sut.breweries {
            XCTAssertEqual(beers.count >= breweries.count, true)
        }
    }
}
