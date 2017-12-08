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

class BeerTableViewController: UITableViewController,CLLocationManagerDelegate {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var brewNameLabel: UILabel!
    @IBOutlet weak var brewAddressLabel: UILabel!
    @IBOutlet weak var segment: UISegmentedControl!
    var beers: [Beer] = []
    var breweries: [Brewery] = []
    var locatiemanager = CLLocationManager()
    var currentLocation = CLLocation()
    var closestLocation: CLLocation?
    var smallestDistance: CLLocationDistance?
    var closestBrewery: Brewery?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locatiemanager.delegate = self
        locatiemanager.requestAlwaysAuthorization()
        locatiemanager.startUpdatingLocation()
        
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

        getData()

    }
    
    //Checks everytime you move for the closest brewery and changes the labels
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        currentLocation = location
        
        for brew in breweries {
            let distance = currentLocation.distance(from: CLLocation(latitude: brew.lat, longitude: brew.lon))
            if smallestDistance == nil || distance < smallestDistance! {
                closestLocation = location
                smallestDistance = distance
                closestBrewery = brew
            }
        }
        brewNameLabel.text = (closestBrewery?.name)!
        brewAddressLabel.text = (closestBrewery?.address)!
    }
    
    //Updates the beer list when entering this viewController (when you return from the detail page)
    override func viewDidAppear(_ animated: Bool) {
        getData()
    }
    
    //Reading all beers and breweries from core data
    func getData() {
        beers = []
        breweries = []
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

         do {
            let loadedBreweries = try context.fetch(Breweries.fetchRequest()) as! [Breweries]
            for brew in loadedBreweries{
                self.breweries += [Brewery(name: brew.name!, address: brew.address!)]
            }
         } catch {
            print("Fetching Failed")
         }
        
         do {
         let loadedBeers = try context.fetch(Beers.fetchRequest()) as! [Beers]
         for b in loadedBeers{
            if(segment.selectedSegmentIndex == 0){
                beers += [Beer(name: b.name!, photo: b.photoLink!, brewery: Int(b.brewery), score: Int(b.score))]
            }else if(b.score >= 0){
                beers += [Beer(name: b.name!, photo: b.photoLink!, brewery: Int(b.brewery), score: Int(b.score))]
            }
         }
         } catch {
            print("Fetching Failed")
         }
        self.tableView.reloadData()
    }
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
 
        beers.removeAll()
        breweries.removeAll()
 
        //Feel free to ad some beers and breweries
 
        //Some breweries
        breweries += [Brewery(name: "Brewery0", address: "Linthout 1 Aalst") ]
        breweries += [Brewery(name: "Brewery1", address: "Nijverheidskaai Brussel") ]
        breweries += [Brewery(name: "Brewery2", address: "Rijnkaai 97/103 2000 Antwerpen") ]
 
        //Enough beers for testing the scroll
        beers += [Beer(name: "Beer0", photo: "beer.png", brewery: 0, score: -1) ]
        beers += [Beer(name: "Beer1", photo: "beer.png", brewery: 2, score: -1) ]
        beers += [Beer(name: "Beer2", photo: "beer.png", brewery: 1, score: -1) ]
        beers += [Beer(name: "Beer3", photo: "beer.png", brewery: 2, score: -1) ]
        beers += [Beer(name: "Beer4", photo: "beer.png", brewery: 0, score: -1) ]
        beers += [Beer(name: "Beer5", photo: "beer.png", brewery: 1, score: -1) ]
        beers += [Beer(name: "Beer6", photo: "beer.png", brewery: 0, score: -1) ]
        beers += [Beer(name: "Beer7", photo: "beer.png", brewery: 2, score: -1) ]
        beers += [Beer(name: "Beer8", photo: "beer.png", brewery: 1, score: -1) ]
        beers += [Beer(name: "Beer9", photo: "beer.png", brewery: 2, score: -1) ]
        beers += [Beer(name: "Beer10", photo: "beer.png", brewery: 0, score: -1) ]
        beers += [Beer(name: "Beer11", photo: "beer.png", brewery: 1, score: -1) ]
        beers += [Beer(name: "Beer12", photo: "beer.png", brewery: 0, score: -1) ]
        beers += [Beer(name: "Beer13", photo: "beer.png", brewery: 2, score: -1) ]
        beers += [Beer(name: "Beer14", photo: "beer.png", brewery: 1, score: -1) ]
        beers += [Beer(name: "Beer15", photo: "beer.png", brewery: 2, score: -1) ]
        beers += [Beer(name: "Beer16", photo: "beer.png", brewery: 0, score: -1) ]
        beers += [Beer(name: "Beer17", photo: "beer.png", brewery: 1, score: -1) ]
        
        for b in breweries{
            let brewery = Breweries(context: context)
            brewery.name = b.name
            brewery.address = b.address
            do{
                try context.save()
                
            }catch{
                fatalError("Failed to save context: \(error)")
            }
        }
        
        for b in beers{
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
        if let nextVC = segue.destination as? ViewController
        {
            let indexPath = self.tableView.indexPathForSelectedRow!
            nextVC.beer = self.beers[indexPath.row]
            nextVC.brewery = self.breweries[self.beers[indexPath.row].brewery]
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
        // #warning Incomplete implementation, return the number of rows
        return beers.count
    }
    
    //Changing the text of the labels in every cell into the info of the beers
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! TableCell
        
        cell.textLabel?.text = self.beers[indexPath.row].name
        cell.detailTextLabel?.text = breweries[self.beers[indexPath.row].brewery].name
        cell.imageView?.image = UIImage(named: self.beers[indexPath.row].photo)!
        
        if(self.beers[indexPath.row].score >= 0){
            
            cell.ratingLabel?.text = "\(self.beers[indexPath.row].score)"
        }else{
            cell.ratingLabel?.text = ""
        }

        // Configure the cell...
        
        return cell
    }
    
    //Reloading the beers if yoou switch between all beers and rated beers
    @IBAction func switchSelection(_ sender: UISegmentedControl) {
        getData()
    }
}
