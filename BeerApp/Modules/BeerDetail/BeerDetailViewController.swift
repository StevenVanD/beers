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
    var appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate) // swiftlint:disable:this force_cast
    public var viewModel: BeerDetailViewModel!

    @IBOutlet weak var beerImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var breweryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var longLabel: UILabel!
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if viewModel != nil {
        
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
        downloadImage(url: viewModel.beerImage)
    }
    func downloadImage(url: URL) {
        beerImage?.sd_setImage(with: url, placeholderImage: UIImage(named: "beer.png"))
    }
    func updateMap() {
        map.addAnnotation(viewModel.annotation)
        map.setRegion(viewModel.region, animated: true)
    }
    
    @IBAction func changeSlider(_ sender: UISlider) {
        ratingLabel.text = "\(Int(sender.value))"
    }
}
