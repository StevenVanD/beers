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
    
    @IBOutlet weak var brewNameLabel: UILabel!
    @IBOutlet weak var brewAddressLabel: UILabel!
    @IBOutlet weak var segment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        reloadUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.upDateBeerList(beerList: service.getBeers(), segment: segment)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func reloadUI() {
        brewNameLabel.text = viewModel.closestBrewName
        brewAddressLabel.text = viewModel.closestBrewAddress
        tableView.reloadData()

    }
    
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
        
        if let beerDetailViewController = segue.destination as? BeerDetailViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                
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
                beerDetailViewController.viewModel = beerViewModel
            }
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
    
    @IBAction func updateButton(_ sender: Any) {
        viewModel.upDateBeerList(beerList: service.getBeers(), segment: segment)

    }
    @IBAction func switchSelection(_ sender: UISegmentedControl) {
        viewModel.upDateBeerList(beerList: service.getBeers(), segment: segment)
    }
}