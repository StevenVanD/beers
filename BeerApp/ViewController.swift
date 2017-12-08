//
//  ViewController.swift
//  BeerApp
//
//  Created by student on 25/08/2017.
//  Copyright © 2017 iCapps. All rights reserved.
//

import UIKit
import CoreData
import MapKit

//Detail viewController
class ViewController: UIViewController{
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var breweryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var longLabel: UILabel!
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var map: MKMapView!

    var beer: Beer?
    var brewery: Brewery?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        //Changing the text in the labels
        nameLabel.text = beer?.name
        breweryLabel.text = brewery?.name
        addressLabel.text = brewery?.address
        if((beer?.score)! >= 0){
            ratingLabel.text = "\((beer?.score)!)"
        }
        longLabel.text = "\((brewery?.lon)!)"
        latLabel.text = "\((brewery?.lat)!)"
        
        //Setting up the map and annotations (pins)
        let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: brewery!.lat, longitude: brewery!.lon)
        let annotation:MyAnnotation = MyAnnotation(coordinate: coordinate, title: (beer?.name)!)
        self.map.addAnnotation(annotation)
        self.mapView(map)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Save the rating everytime the slider gets replaced
    @IBAction func changeSlider(_ sender: UISlider) {
        ratingLabel.text = "\(Int(sender.value))"
        do{
            let results = try context.fetch(NSFetchRequest(entityName: "Beers"))
            for result in results as! [NSManagedObject]
            {
                if  result.value(forKey: "name") as? String == (beer?.name)!
                {
                    result.setValue(Int(sender.value), forKey: "score")
                    do{

                        try context.save()
                    }
                    catch{
                        print("Failed to save")
                    }
                }
            }
        }
        catch{
            print("Failed to fetch")

        }
    }
    
    //Set the region of the map to the place of the beer
    func mapView(_ mapView: MKMapView) {
        let center = CLLocationCoordinate2D(latitude: (brewery?.lat)!, longitude: (brewery?.lon)!)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
    }
}

