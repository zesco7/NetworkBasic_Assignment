//
//  BeerListTableViewCell.swift
//  NetworkBasic_Assignment
//
//  Created by Mac Pro 15 on 2022/09/14.
//

import UIKit

class BeerListTableViewCell: UITableViewCell {
    static var identifier = "BeerListTableViewCell"
    
    @IBOutlet weak var beerListImageView: UIImageView!
    @IBOutlet weak var beerListNameLabel: UILabel!
    @IBOutlet weak var beerListIntroLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
