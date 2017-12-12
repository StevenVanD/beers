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
        homeViewModel = HomeViewModel()

        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            homeViewModel?.update()
            print("Not first launch.")
        }
        else {
            print("First launch, setting UserDefault.")
            homeViewModel?.update()
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        getData()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let viewModel = homeViewModel else {
            return
        }
        let location = locations[0]
        viewModel.currentLocation = location
        
        for brew in viewModel.breweries {
            let distance = viewModel.currentLocation.distance(from: CLLocation(latitude: brew.lat, longitude: brew.lon))
            if viewModel.smallestDistance == nil || distance < viewModel.smallestDistance! {
                viewModel.closestLocation = location
                viewModel.smallestDistance = distance
                viewModel.closestBrewery = brew
            }
        }
        brewNameLabel.text = viewModel.closestBrewery?.name
        brewAddressLabel.text = viewModel.closestBrewery?.address
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getData()
    }
    
    func getData() {
        guard let viewModel = homeViewModel else {
            return
        }
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        
        viewModel.beers = []
        viewModel.breweries = []
        
        
        do {
            let loadedBreweries = try context.fetch(Breweries.fetchRequest()) as! [Breweries]
            for brew in loadedBreweries{
                viewModel.breweries += [Brewery(name: brew.name!, address: brew.address!, id: Int(brew.id))]
            }
        } catch {
            print("Fetching Failed")
        }
        
        do {
            let loadedBeers = try context.fetch(Beers.fetchRequest()) as! [Beers]
            for b in loadedBeers{
                if(segment.selectedSegmentIndex == 0){
                    viewModel.beers += [Beer(name: b.name!, photo: b.photoLink!, brewery: Int(b.brewery), score: Int(b.score))]
                }else if(b.score >= 0){
                    viewModel.beers += [Beer(name: b.name!, photo: b.photoLink!, brewery: Int(b.brewery), score: Int(b.score))]
                }
            }
        } catch {
            print("Fetching Failed")
        }
        self.tableView.reloadData()
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
        if let nextVC = segue.destination as? BeerDetailViewController
        {    if let indexPath = tableView.indexPathForSelectedRow{
            
            let newViewModel = BeerDetailViewModel(beer: viewModel.beers[indexPath.row])
            nextVC.beerDetailViewModel = newViewModel
            guard let detailViewModel = nextVC.beerDetailViewModel else {
                return
            }
            detailViewModel.brewery = viewModel.breweries[viewModel.beers[indexPath.row].brewery]
            }
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! TableCell
        
        guard let viewModel = homeViewModel else {
            return cell
        }
        
        cell.textLabel?.text = viewModel.beers[indexPath.row].name
        for brewery in viewModel.breweries{
            if brewery.id == viewModel.beers[indexPath.row].brewery{
                cell.detailTextLabel?.text = brewery.name
            }
        }
        cell.imageView?.image = UIImage(named: viewModel.beers[indexPath.row].photo)!
        
        if(viewModel.beers[indexPath.row].score >= 0){
            
            cell.ratingLabel?.text = "\(viewModel.beers[indexPath.row].score)"
        }else{
            cell.ratingLabel?.text = ""
        }
        return cell
    }
    
    @IBAction func updateButton(_ sender: Any) {
        homeViewModel?.update()
    }
    @IBAction func switchSelection(_ sender: UISegmentedControl) {
        getData()
    }
}
