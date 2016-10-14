//
//  MovieCell.swift
//  Flicks
//
//  Created by Jay Liew on 10/13/16.
//  Copyright © 2016 Jay Liew. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    // MARK: Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
