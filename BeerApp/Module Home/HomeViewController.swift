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

class HomeViewController: UITableViewController,CLLocationManagerDelegate {
    public var homeViewModel: HomeViewModel?
    public var service: Service?
    @IBOutlet weak var brewNameLabel: UILabel!
    @IBOutlet weak var brewAddressLabel: UILabel!
    @IBOutlet weak var segment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeViewModel = HomeViewModel(homeViewController: self)
        guard let viewModel = homeViewModel else {
            return
        }
        service = Service(homeViewModel: viewModel)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let service = service else {
            return
        }
        service.getBeers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = homeViewModel else {
            return 0
        }
            return viewModel.beers.count
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let viewModel = homeViewModel else {
            return
        }
        
        if let beerDetailViewController = segue.destination as? BeerDetailViewController{
            if let indexPath = tableView.indexPathForSelectedRow{
                
                let selectedBeer = viewModel.beers[indexPath.row]
                let selectedBeerId = selectedBeer.breweryId
                
                let beerViewModel = BeerDetailViewModel(beer: selectedBeer)
                
                for brewery in viewModel.breweries{
                    let breweryId = selectedBeerId
                    if brewery.id == breweryId{
                        beerViewModel.brewery = brewery
                    }
                }
                beerDetailViewController.beerDetailViewModel = beerViewModel
            }
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! TableCell
        
        guard let viewModel = homeViewModel else {
            return cell
        }
        
        let selectedBeer = viewModel.beers[indexPath.row]
        let selectedBeerName = selectedBeer.name
        let selectedBeerBrewId = selectedBeer.breweryId
        let selectedBeerPhoto = selectedBeer.photoURL
        let selectedBeerRating = selectedBeer.rating

        cell.textLabel?.text = selectedBeerName
        for brewery in viewModel.breweries{
            if brewery.id == selectedBeerBrewId{
                let breweryName = brewery.name
                cell.detailTextLabel?.text = breweryName
            }
        }
        
        let photoUrlString = selectedBeerPhoto
        func downloadImage(url: URL) {
            getDataFromUrl(url: photoUrlString) { data, response, error in
                guard let data = data, error == nil else {
                    return
                }
                DispatchQueue.main.async() {
                    cell.imageView?.image  = UIImage(data: data)
                }
            }
        }
        downloadImage(url: photoUrlString)
        
        
        if(selectedBeerRating >= 0){
            cell.ratingLabel?.text = "\(selectedBeerRating)"
        }else{
            cell.ratingLabel?.text = ""
        }
        return cell
    }
    
    @IBAction func updateButton(_ sender: Any) {
        guard let viewModel = homeViewModel else {
            return
        }
        viewModel.getData()
    }
    @IBAction func switchSelection(_ sender: UISegmentedControl) {
        guard let viewModel = homeViewModel else {
            return
        }
        viewModel.getData()
    }
}
