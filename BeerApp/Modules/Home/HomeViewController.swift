//
//  BeerTableViewController.swift
//  BeerApp
//
//  Created by student on 25/08/2017.
//  Copyright © 2017 iCapps. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class HomeViewController: UITableViewController, CLLocationManagerDelegate {
    public var viewModel: HomeViewModel = HomeViewModel()
    public var service: Service = Service()
    
    public var locationManager: CLLocationManager!

    @IBOutlet weak var brewNameLabel: UILabel!
    @IBOutlet weak var brewAddressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        reloadData()
        viewModel.breweriesUpdateHandler = { [unowned self] in
            DispatchQueue.main.async {
                self.reloadUI()
            }
        }
        viewModel.beersUpdateHandler = { [unowned self] in
            DispatchQueue.main.async {
                self.reloadUI()
            }
        }
        locationManager = CLLocationManager()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadUI()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
     let location = locations[0]
     viewModel.currentLocation = location
        reloadCLosestBrewery()
    }
    func reloadCLosestBrewery() {
        self.viewModel.setClosestBrewery()        
        self.brewNameLabel.text = self.viewModel.closestBrewName
        self.brewAddressLabel.text = self.viewModel.closestBrewAddress
    }
    func reloadUI() {
        DispatchQueue.main.async { [unowned self] in
            self.tableView.reloadData()
            self.reloadCLosestBrewery()
        }
    }
    
    func reloadData() {
        service.getBeers { [unowned self] (error, beers) in
            if let error = error {
                print("error \(error.localizedDescription)")
            }
            
            if let beers = beers {
                DispatchQueue.main.async {
                    self.viewModel.upDateBeerList(beerList: beers, for: 0)
                }
                self.reloadUI()
            }
        }
    }
}

// MARK: TableView Functions

extension HomeViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let beers = viewModel.beers else {
            return 0
        }
        return beers.count
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let beers = viewModel.beers, let breweries = viewModel.breweries else {
            return
        }
        
        if segue.identifier == "showDetail" {
            
            guard let indexPath = tableView.indexPathForSelectedRow else {
                return
            }
            guard let beerDetailViewController = (segue.destination as? UINavigationController)?.topViewController as? BeerDetailViewController else {
                return
            }
            
            let selectedBeer = beers[indexPath.row]
            let selectedBeerId = selectedBeer.breweryId
            let beerViewModel = BeerDetailViewModel()
            beerViewModel.beer = selectedBeer
            
            for brewery in breweries {
                let breweryId = selectedBeerId
                if brewery.id == breweryId {
                    beerViewModel.brewery = brewery
                }
            }
            
            beerDetailViewController.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            beerDetailViewController.navigationItem.leftItemsSupplementBackButton = true
            beerDetailViewController.viewModel = beerViewModel
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! BeerTableCell // swiftlint:disable:this force_cast
        
        guard let beers = viewModel.beers, let breweries = viewModel.breweries else {
            return cell
        }
        
        let selectedBeer = beers[indexPath.row]
        let selectedBeerBrewId = selectedBeer.breweryId
        
        for brewery in breweries where brewery.id == selectedBeerBrewId {
                cell.updateCell(for: selectedBeer, with: brewery)
        }
        
        return cell
    }
}
