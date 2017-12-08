//
//  TableCell.swift
//  BeerApp
//
//  Created by student on 26/08/2017.
//  Copyright © 2017 iCapps. All rights reserved.
//

import UIKit

//Class for adding a label to the cells
class TableCell: UITableViewCell {
    
    @IBOutlet weak var ratingLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
