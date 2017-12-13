//
//  ViewController.swift
//  BeerApp
//
//  Created by student on 25/08/2017.
//  Copyright © 2017 iCapps. All rights reserved.
//

import UIKit
import MapKit

//Detail viewController
class BeerDetailViewController: UIViewController{
    public var beerDetailViewModel: BeerDetailViewModel?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var breweryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var longLabel: UILabel!
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
    
    
    override func viewDidAppear(_ animated: Bool) {
        guard let viewModel = beerDetailViewModel else {
            return
        }
        viewModel.updateUI()
        viewModel.updateMap()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Save the rating everytime the slider gets replaced
    @IBAction func changeSlider(_ sender: UISlider) {
        ratingLabel.text = "\(Int(sender.value))"
    }
    
    //Set the region of the map to the place of the beer
    func mapView(_ mapView: MKMapView) {
        guard let viewModel = beerDetailViewModel else {
            return
        }
        let center = CLLocationCoordinate2D(latitude: (viewModel.brewery?.lat)!, longitude: (viewModel.brewery?.lon)!)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
    }
}

