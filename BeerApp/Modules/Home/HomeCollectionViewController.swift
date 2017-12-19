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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let amountOfRows = 2 as CGFloat
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout // swiftlint:disable:this force_cast
        let width = (view.frame.width - (amountOfRows) * layout.minimumInteritemSpacing) / amountOfRows
        layout.itemSize = CGSize(width: width, height: width)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension HomeCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
        if let label = cell.viewWithTag(100) as? UILabel {
            label.text = collectionData[indexPath.row]
        }
        return cell
    }
    
}
