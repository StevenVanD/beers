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
        //Updates if it's your first launch
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            print("Not first launch.")
        }
        else {
            print("First launch, setting UserDefault.")
            update()
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
update()
        getData()

    }
    
    //Checks everytime you move for the closest brewery and changes the labels
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
    
    //Updates the beer list when entering this viewController (when you return from the detail page)
    override func viewDidAppear(_ animated: Bool) {
        getData()
    }
    
    //Reading all beers and breweries from core data
    func getData() {
        guard let viewModel = homeViewModel else {
            return
        }
        viewModel.beers = []
        viewModel.breweries = []
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

         do {
            let loadedBreweries = try context.fetch(Breweries.fetchRequest()) as! [Breweries]
            for brew in loadedBreweries{
                viewModel.breweries += [Brewery(name: brew.name!, address: brew.address!)]
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
    
    
    
    

    
    
    
    /*
     // Get beers
     guard let beerUrl = URL(string: "https://icapps-beers.herokuapp.com/beers") else {
     print ("geen url kunnen aanmaken")
     return
     }
     
     var beerUrlRequest = URLRequest(url: beerUrl)
     urlRequest.allHTTPHeaderFields = [
     "accept": "application/json",
     "content-type": "application/json",
     "authorization": "Token token=kVJzYfn9gRaGDFNrtMDuAexP"
     ]
     
     // make the request
     let beerTask = session.dataTask(with: beerUrlRequest) {
     (data, response, error) in
     
     // check for any errors
     guard error == nil else {
     print("error calling GET")
     print(error!)
     return
     }
     
     // make sure we got data
     guard let responseData = data else {
     print("Error: did not receive data")
     return
     }
     
     // parse the result
     do {
     guard let greeting = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject] else {
     print("error trying to convert data to JSON")
     return
     }
     guard let beerse = try greeting["beers"] as? [AnyObject] else {
     print("fail")
     return
     }
     for dictionary in beerse{
     if let dictionary = dictionary as? [String: Any],
     let id = dictionary["id"],
     let brewery = dictionary["brewery"]{
     if let brewery = brewery as? [String: Any],
     let name = brewery["name"]{
     print(name)
     }
     print(id)
     
     //tracks.append(Track(name: name, artist: artist, previewURL:previewURL))
     }else{
     print("Problem parsing trackDictionary\n")
     }
     }
     /*for (key, value) in beerse[0] {
     if key == "brewery" {
     print(value)
     }
     }*/
     print(beerse[0])
     }catch  {
     print("error trying to convert data to JSON")
     return
     }
     }
     beerTask.resume()
     
     */
    
    
    
    
    
    
    
    
    
    
    /*If I found out how to get the info from a heroku-website
    //Online
 let url = URL(string: "https://icapps-beers.herokuapp.com/beers")
 
 let urlRequest = URLRequest(url: url!)
 
 
 // set up the session
 let session = URLSession(configuration: URLSessionConfiguration.default)
 
 // make the request
 let task = session.dataTask(with: urlRequest) {
 (data, response, error) in
 
 // check for any errors
 guard error == nil else {
 print("error calling GET")
 print(error!)
 return
 }
 
 // make sure we got data
 guard let responseData = data else {
 print("Error: did not receive data")
 return
 }
 
 // parse the result
 
 do {
 guard let greeting = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject] else {
 print("error trying to convert data to JSON")
 return
 }
 guard let record = try greeting["records"] as? [AnyObject] else {
 print("fail")
 return
 }

     //Use the data
 
 }
 
 }

 
 for (key, value) in greeting {
 if key == "datasetid" {
 //print(value)
 }
 }
 
 } catch  {
 print("error trying to convert data to JSON")
 return
 }
 }
 
 task.resume()
*/
    //Deleting all existing beers and breweries and adding standard beers and breweries to core data
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
 
        
        
        guard let url = URL(string: "https://icapps-beers.herokuapp.com/breweries") else {
            print ("geen url kunnen aanmaken")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = [
            "accept": "application/json",
            "content-type": "application/json",
            "authorization": "Token token=kVJzYfn9gRaGDFNrtMDuAexP"
        ]
        // set up the session
        let session = URLSession(configuration: URLSessionConfiguration.default)

        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            
            // check for any errors
            guard error == nil else {
                print("error calling GET")
                print(error!)
                return
            }
            
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // parse the result
            do {
                guard let greeting = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject] else {
                    print("error trying to convert data to JSON")
                    return
                }
                guard let breweries = try greeting["breweries"] as? [AnyObject] else {
                    print("fail")
                    return
                }
                for brewery in breweries{
                    if let brewery = brewery as? [String: Any],
                        let straat = brewery["address"],
                        let stad = brewery["city"],
                        let land = brewery["country"],
                        let name = brewery["name"]{
                        viewModel.breweries += [Brewery(name: "\(name)", address: "\(straat) \(stad) \(land)")]
                        
                        //tracks.append(Track(name: name, artist: artist, previewURL:previewURL))
                    }else{
                        print("Problem parsing trackDictionary\n")
                    }
                }
                for b in viewModel.breweries{
                    let brewery = Breweries(context: context)
                    brewery.name = b.name
                    brewery.address = b.address
                    
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
        }
        task.resume()
        
        
        //Feel free to ad some beers and breweries
 
        //Some breweries
        viewModel.breweries += [Brewery(name: "Brewery0", address: "Linthout 1 Aalst") ]
        viewModel.breweries += [Brewery(name: "Brewery1", address: "Nijverheidskaai Brussel") ]
        viewModel.breweries += [Brewery(name: "Brewery2", address: "Rijnkaai 97/103 2000 Antwerpen") ]
 
        //Enough beers for testing the scroll
        viewModel.beers += [Beer(name: "Beer0", photo: "beer.png", brewery: 0, score: -1) ]
        viewModel.beers += [Beer(name: "Beer1", photo: "beer.png", brewery: 2, score: -1) ]
        viewModel.beers += [Beer(name: "Beer2", photo: "beer.png", brewery: 1, score: -1) ]
        viewModel.beers += [Beer(name: "Beer3", photo: "beer.png", brewery: 2, score: -1) ]
        viewModel.beers += [Beer(name: "Beer4", photo: "beer.png", brewery: 0, score: -1) ]
        viewModel.beers += [Beer(name: "Beer5", photo: "beer.png", brewery: 1, score: -1) ]
        viewModel.beers += [Beer(name: "Beer6", photo: "beer.png", brewery: 0, score: -1) ]
        viewModel.beers += [Beer(name: "Beer7", photo: "beer.png", brewery: 2, score: -1) ]
        viewModel.beers += [Beer(name: "Beer8", photo: "beer.png", brewery: 1, score: -1) ]
        viewModel.beers += [Beer(name: "Beer9", photo: "beer.png", brewery: 2, score: -1) ]
        viewModel.beers += [Beer(name: "Beer10", photo: "beer.png", brewery: 0, score: -1) ]
        viewModel.beers += [Beer(name: "Beer11", photo: "beer.png", brewery: 1, score: -1) ]
        viewModel.beers += [Beer(name: "Beer12", photo: "beer.png", brewery: 0, score: -1) ]
        viewModel.beers += [Beer(name: "Beer13", photo: "beer.png", brewery: 2, score: -1) ]
        viewModel.beers += [Beer(name: "Beer14", photo: "beer.png", brewery: 1, score: -1) ]
        viewModel.beers += [Beer(name: "Beer15", photo: "beer.png", brewery: 2, score: -1) ]
        viewModel.beers += [Beer(name: "Beer16", photo: "beer.png", brewery: 0, score: -1) ]
        viewModel.beers += [Beer(name: "Beer17", photo: "beer.png", brewery: 1, score: -1) ]
        
        for b in viewModel.breweries{
            let brewery = Breweries(context: context)
            brewery.name = b.name
            brewery.address = b.address
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
            beer.brewery = Int64(b.brewery)
            beer.score = Int16(b.score)
            do{
                try context.save()
                
            }catch{
                fatalError("Failed to save context: \(error)")
            }
        }
     }
    
    //Sending the selected beer info to the next viewController
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
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = homeViewModel else {
            return 0
        }
        // #warning Incomplete implementation, return the number of rows
        return viewModel.beers.count
    }
    
    //Changing the text of the labels in every cell into the info of the beers
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! TableCell
        
        guard let viewModel = homeViewModel else {
            return cell
        }
        
        cell.textLabel?.text = viewModel.beers[indexPath.row].name
        //print(viewModel.breweries)
        //cell.detailTextLabel?.text = viewModel.breweries[viewModel.beers[indexPath.row].brewery].name
        cell.imageView?.image = UIImage(named: viewModel.beers[indexPath.row].photo)!
        
        if(viewModel.beers[indexPath.row].score >= 0){
            
            cell.ratingLabel?.text = "\(viewModel.beers[indexPath.row].score)"
        }else{
            cell.ratingLabel?.text = ""
        }

        
        return cell
    }
    
    //Reloading the beers if yoou switch between all beers and rated beers
    @IBAction func switchSelection(_ sender: UISegmentedControl) {
        getData()
    }
}
