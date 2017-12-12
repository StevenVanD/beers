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
            update()
            print("Not first launch.")
        }
        else {
            print("First launch, setting UserDefault.")
            update()
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
    
    func getBeers(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        guard let viewModel = homeViewModel else {
            return
        }
        guard let url = URL(string: "https://icapps-beers.herokuapp.com/beers") else {
            print ("geen url kunnen aanmaken")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = [
            "accept": "application/json",
            "content-type": "application/json",
            "authorization": "Token token=kVJzYfn9gRaGDFNrtMDuAexP"
        ]
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let _ = session.dataTask(with: urlRequest) {
            (data, response, error) in
            
            guard error == nil else {
                print("error calling GET")
                print(error!)
                return
            }
            
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            do {
                guard let greeting = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject] else {
                    print("error trying to convert data to JSON")
                    return
                }
                guard let beers = greeting["beers"] as? [AnyObject] else {
                    print("fail")
                    return
                }
                
                for beer in beers{
                    print(beers.count)
                    if let beer = beer as? [String: Any],
                        let name = beer["name"],
                        let brewery = beer["brewery"] as? [String: Any],
                        let id = brewery["id"] as? Int,
                        let straat = brewery["address"],
                        let stad = brewery["city"],
                        let land = brewery["country"],
                        let brewName = brewery["name"]{
                        
                        var breweryExists = false
                        for brewery in viewModel.breweries{
                            if brewery.id == id {
                                breweryExists = true
                            }
                        }
                        if breweryExists == false{
                            viewModel.breweries += [Brewery(name: "\(brewName)", address: "\(straat) \(stad) \(land)", id: id)]
                        }
                        if let score = beer["rating"] as? Int{
                            viewModel.beers += [Beer(name: "\(name)", photo: "beer.png", brewery: id, score: score) ]
                        }else{
                            viewModel.beers += [Beer(name: "\(name)", photo: "beer.png", brewery: id, score: -1) ]
                        }
                    }
                    else{
                        print("Problem parsing trackDictionary\n")
                    }
                }
                for b in viewModel.breweries{
                    let brewery = Breweries(context: context)
                    brewery.name = b.name
                    brewery.address = b.address
                    brewery.id = Int16(b.id)
                    do{
                        try context.save()
                    }catch{
                        fatalError("Failed to save context: \(error)")
                    }
                }
                for b in viewModel.beers{
                    let beer = Beers(context: context)
                    beer.name = b.name
                    beer.photoLink = b.photo as String
                    beer.brewery = 1
                    beer.score = Int16(b.score)
                    do{
                        try context.save()
                        
                    }catch{
                        fatalError("Failed to save context: \(error)")
                    }
                }
                
            }catch  {
                print("error trying to convert data to JSON")
                return
            }
        }.resume()
    }

    func update() {
        guard let viewModel = homeViewModel else {
            return
        }
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            let loadedBeers = try context.fetch(Beers.fetchRequest()) as! [Beers]
            for b in loadedBeers{
                context.delete(b)
                
            }
        } catch {
            print("Fetching Failed")
        }
        
        do {
            let loadedBreweries = try context.fetch(Breweries.fetchRequest()) as! [Breweries]
            for brew in loadedBreweries{
                context.delete(brew)
            }
        } catch {
            print("Fetching Failed")
        }
        
        do{
            try context.save()
        }
        catch{
        }
        
        viewModel.beers.removeAll()
        viewModel.breweries.removeAll()
        
        getBeers()
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
    
    @IBAction func switchSelection(_ sender: UISegmentedControl) {
        getData()
    }
}
