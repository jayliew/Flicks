//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Jay Liew on 10/12/16.
//  Copyright © 2016 Jay Liew. All rights reserved.
//

import UIKit
import AFNetworking

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    var movies: [Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        callAPI()
        
        let contentWidth = tableView.bounds.width
        let contentHeight = tableView.bounds.height * 3
        tableView.contentSize = CGSize(width: contentWidth, height: contentHeight)
    }

    func callAPI(){
        let api_key = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(api_key)")
        let request = NSURLRequest(url: url! as URL)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest,
                                                        completionHandler: { (dataOrNil, responseOrNil, errorOrNil) in
                                                            if errorOrNil != nil {
                                                                            //errorCallback?(requestError)
                                                            } else {
                                                                if let data = dataOrNil {
                                                                    if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                                                                                    NSLog("response: \(responseDictionary)")
                                                                        
                                                                                    if let movies_array = responseDictionary["results"] as? [Any]{
                                                                                        self.movies = movies_array
                                                                                        self.tableView.reloadData()
                                                                                    }
                                                                                }
                                                                }
                                                            }
        });
        task.resume()
    }
    
    // MARK: UITableView Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let allMovies = self.movies {
            return allMovies.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)
        
        // cell.textLabel!.text = "row \(indexPath.row)"
        
        return cell
    }

    
    
}
