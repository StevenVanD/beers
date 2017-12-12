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
        guard let viewModel = homeViewModel else {
            return
        }
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
        viewModel.getData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let viewModel = homeViewModel else {
            return
        }
        viewModel.getData()
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
        
        cell.textLabel?.text = viewModel.beers[indexPath.row].name
        for brewery in viewModel.breweries{
            if brewery.id == viewModel.beers[indexPath.row].brewery{
                cell.detailTextLabel?.text = brewery.name
            }
        }
        if let url = URL(string: viewModel.beers[indexPath.row].photo) {
            func downloadImage(url: URL) {
                print("Download Started")
                getDataFromUrl(url: url) { data, response, error in
                    guard let data = data, error == nil else {
                        return
                    }
                    print("Download Finished")
                    DispatchQueue.main.async() {
                        cell.imageView?.image  = UIImage(data: data)
                    }
                }
            }
        downloadImage(url: url)

        }
        
        if(viewModel.beers[indexPath.row].score >= 0){
            
            cell.ratingLabel?.text = "\(viewModel.beers[indexPath.row].score)"
        }else{
            cell.ratingLabel?.text = ""
        }
        return cell
    }
    
    @IBAction func updateButton(_ sender: Any) {
        guard let viewModel = homeViewModel else {
            return
        }
        viewModel.update()
    }
    @IBAction func switchSelection(_ sender: UISegmentedControl) {
        guard let viewModel = homeViewModel else {
            return
        }
        viewModel.getData()
    }
}
