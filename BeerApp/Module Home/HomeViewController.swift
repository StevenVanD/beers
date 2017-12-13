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
    @IBOutlet weak var brewNameLabel: UILabel!
    @IBOutlet weak var brewAddressLabel: UILabel!
    @IBOutlet weak var segment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeViewModel = HomeViewModel(homeViewController: self)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let viewModel = homeViewModel else {
            return
        }
        viewModel.getBeers()
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
        if(viewModel.beers.count > 0 && viewModel.breweries.count > 0){
            return viewModel.beers.count
        }
        else{
            return 0
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let viewModel = homeViewModel else {
            return
        }
        
        if let nextVC = segue.destination as? BeerDetailViewController{
            if let indexPath = tableView.indexPathForSelectedRow{
                
                let beerAtIndex = viewModel.beers[indexPath.row]
                let beerAtIndexBrewId = beerAtIndex.breweryId
                
                let newViewModel = BeerDetailViewModel(beer: beerAtIndex)
                nextVC.beerDetailViewModel = newViewModel
                guard let detailViewModel = nextVC.beerDetailViewModel else {
                    return
                }
                
                for brewery in viewModel.breweries{
                    let breweryId = beerAtIndexBrewId
                    if brewery.id == breweryId{
                        detailViewModel.brewery = brewery
                    }
                }
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
        
        let beerAtIndex = viewModel.beers[indexPath.row]
        let beerAtIndexName = beerAtIndex.name
        let beerAtIndexBrewId = beerAtIndex.breweryId
        let beerAtIndexPhoto = beerAtIndex.photo
        let beerAtIndexRating = beerAtIndex.rating

        cell.textLabel?.text = beerAtIndexName
        for brewery in viewModel.breweries{
            if brewery.id == beerAtIndexBrewId{
                let breweryName = brewery.name
                cell.detailTextLabel?.text = breweryName
            }
        }
        
        let photoUrlString = beerAtIndexPhoto
        if let url = URL(string: photoUrlString) {
            func downloadImage(url: URL) {
                getDataFromUrl(url: url) { data, response, error in
                    guard let data = data, error == nil else {
                        return
                    }
                    DispatchQueue.main.async() {
                        cell.imageView?.image  = UIImage(data: data)
                    }
                }
            }
            downloadImage(url: url)
        }
        
        if(beerAtIndexRating >= 0){
            cell.ratingLabel?.text = "\(beerAtIndexRating)"
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
