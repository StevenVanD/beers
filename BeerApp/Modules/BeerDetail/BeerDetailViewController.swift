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
class BeerDetailViewController: UIViewController {
    public var viewModel: BeerDetailViewModel!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext // swiftlint:disable:this force_cast
    var appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate) // swiftlint:disable:this force_cast
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var breweryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var longLabel: UILabel!
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if viewModel == nil {
            viewModel = BeerDetailViewModel()
        }
        viewModel.breweryUpdateHandler = { [unowned self] in
            DispatchQueue.main.async {
                self.reloadUI()
            }
        }
        viewModel.beerUpdateHandler = { [unowned self] in
            DispatchQueue.main.async {
                self.reloadUI()
            }
        }
        updateMap()
        reloadUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func reloadUI() {
        nameLabel.text = viewModel.beerName
        breweryLabel.text = viewModel.breweryName
        addressLabel.text = viewModel.breweryAddress
        ratingLabel.text = viewModel.beerRating
        longLabel.text = viewModel.breweryLongString
        latLabel.text = viewModel.breweryLatString
    }
    
    func updateMap() {
        map.addAnnotation(viewModel.annotation)
        map.setRegion(viewModel.region, animated: true)
    }
    
    @IBAction func changeSlider(_ sender: UISlider) {
        ratingLabel.text = "\(Int(sender.value))"
    }
}
