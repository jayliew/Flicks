//
//  MovieDetailsViewController.swift
//  Flicks
//
//  Created by Jay Liew on 10/14/16.
//  Copyright © 2016 Jay Liew. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var detailsView: UIView!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let poster = movie["poster_path"] as! String? { // DEBUG: This is sometimes null and breaks ... TODO: bugfix!
            let poster_url = URL(string: "https://image.tmdb.org/t/p/w342" + poster)
            posterView.setImageWith(poster_url!)
        }

        if let title = movie["title"] as! String? {
            titleLabel.text = title
            self.navigationItem.title = title
        }
        
        if let overview = movie["overview"] as! String? {
            overviewLabel.text = overview
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
