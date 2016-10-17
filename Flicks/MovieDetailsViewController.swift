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
        
        if let poster = movie["poster_path"] as? String {
            let imageUrl = URL(string: "https://image.tmdb.org/t/p/w92" + poster)!
            let imageRequest = NSURLRequest(url: imageUrl)
            
            self.posterView.setImageWith(
                imageRequest as URLRequest,
                placeholderImage: nil,
                success: { (imageRequest, imageResponse, image) -> Void in
                    // imageResponse will be nil if the image is cached
                    if imageResponse != nil {
                        self.posterView.alpha = 0.0
                        self.posterView.image = image
                        
                        UIView.animate(withDuration: 0.4,
                                       animations: { () -> Void in self.posterView.alpha = 1.0},
                                       
                                       completion: { (success) -> Void in
                                        
                                        self.loadHigherResolutionImage(poster: poster, image: image)
                                        
                            } // animate completion handler
                        ) // animate
                    } else {
                        self.posterView.image = image
                        self.loadHigherResolutionImage(poster: poster, image: image)
                    } // low res cache hit/miss
                    
                }, // low res success
                failure: { (imageRequest, imageResponse, error) -> Void in // do something for the failure condition
                }
            ) // set low res image
            
        } // unwrap movie["poster_path"]

        if let title = movie["title"] as! String? {
            titleLabel.text = title
            self.navigationItem.title = title
        }
    }

    func loadHigherResolutionImage(poster: String, image: UIImage){
        // The AFNetworking ImageView Category only allows one request to be sent at a time
        // per ImageView. This code must be in the completion block.
        let bigImageUrl = URL(string: "https://image.tmdb.org/t/p/w342" + poster)!
        let bigImageRequest = NSURLRequest(url: bigImageUrl)
        
        self.posterView.setImageWith(
            bigImageRequest as URLRequest,
            placeholderImage: image,
            success: { (bigImageRequest, bigImageResponse, bigImage) -> Void in
                self.posterView.image = bigImage
            }, // success hi res
            failure: { (request, response, error) -> Void in }
            
        ) // setting hi res image
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
