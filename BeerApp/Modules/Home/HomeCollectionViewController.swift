//
//  HomeCollectionViewController.swift
//  BeerApp
//
//  Created by Steven Van Durm on 19/12/17.
//  Copyright © 2017 iCapps. All rights reserved.
//

import UIKit

class HomeCollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var collectionData = ["1 yay", "2 yay", "3 yay", "4 yay", "5 yay", "6 yay"]
    
    public var viewModel: HomeViewModel = HomeViewModel()
    public var service: Service = Service()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let amountOfRows = 2 as CGFloat
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout // swiftlint:disable:this force_cast
        let width = (view.frame.width - (amountOfRows) * layout.minimumInteritemSpacing) / amountOfRows
        layout.itemSize = CGSize(width: width, height: width)
        
        reloadData()
        viewModel.breweriesUpdateHandler = { [unowned self] in
            DispatchQueue.main.async {
                self.reloadUI()
            }
        }
        viewModel.beersUpdateHandler = { [unowned self] in
            DispatchQueue.main.async {
                self.reloadUI()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func reloadUI() {
        self.viewModel.setClosestBrewery()
        //stopt hier vroegtijdig mee
        DispatchQueue.main.async { [unowned self] in
            //self.brewNameLabel.text = self.viewModel.closestBrewName
            //self.brewAddressLabel.text = self.viewModel.closestBrewAddress
            self.collectionView.reloadData()
            
        }
    }
    
    func reloadData() {
        service.getBeers { [unowned self] (error, beers) in
            if let error = error {
                print("error \(error.localizedDescription)")
            }
            
            if let beers = beers {
                DispatchQueue.main.async {
                    self.viewModel.upDateBeerList(beerList: beers, for: 1)
                }
                self.reloadUI()
            }
        }
    }
}

extension HomeCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let beers = viewModel.beers, let breweries = viewModel.breweries else {
            return 0
        }
        return beers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
        guard let beers = viewModel.beers, let breweries = viewModel.breweries else {
            return cell
        }
        let selectedBeer = beers[indexPath.row]
        let selectedBeerPhotoURL = selectedBeer.photoURL
        
        if let image = cell.viewWithTag(100) as? UIImageView {
            func downloadImage(url: URL) {
                image.sd_setImage(with: url, placeholderImage: UIImage(named: "beer.png"))
            }
            downloadImage(url: selectedBeerPhotoURL)
        }
        return cell
    }
    
}
