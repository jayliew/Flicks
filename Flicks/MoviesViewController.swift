//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Jay Liew on 10/12/16.
//  Copyright © 2016 Jay Liew. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // MARK: Outlets
    @IBOutlet weak var networkErrorView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var movies: [Any]?
    var endpoint: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        networkErrorView.isHidden = true
        tableView.isHidden = true
        collectionView.isHidden = false
        
        callAPI(endpoint: self.endpoint)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        collectionView.insertSubview(refreshControl, at: 0)

        let contentWidth = tableView.bounds.width
        let contentHeight = tableView.bounds.height * 3
        tableView.contentSize = CGSize(width: contentWidth, height: contentHeight)
    }

    @IBAction func unwindToVC(segue: UIStoryboardSegue) {
        
        //self.performSegue(withIdentifier: "UnwindSegue", sender: self)
        
    }
    
    func hideNetworkError(){
        UIView.animate(withDuration:0.4, animations: {
            self.networkErrorView.alpha = 0
        })
    }

    func showNetworkError(){
        networkErrorView.isHidden = false
        UIView.animate(withDuration:0.4, animations: {
            self.networkErrorView.alpha = 1
        })
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        hideNetworkError()
        callAPI(endpoint: self.endpoint)
        refreshControl.endRefreshing()
    }

    func callAPI(endpoint: String){
        let api_key = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(api_key)")
        let request = NSURLRequest(url: url! as URL)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest,
                                                        completionHandler: { (dataOrNil, responseOrNil, errorOrNil) in
                                                            if errorOrNil != nil {
                                                                // Error handling
                                                                MBProgressHUD.hide(for: self.view, animated: true)
                                                                self.showNetworkError()

                                                            } else {
                                                                if let data = dataOrNil {
                                                                    if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                                                                                    // Success callback
                                                                                    MBProgressHUD.hide(for: self.view, animated: true)
                                                                                    self.hideNetworkError()
                                                                                    if let movies_array = responseDictionary["results"] as? [Any]{
                                                                                        self.movies = movies_array
                                                                                        self.tableView.reloadData()
                                                                                        self.collectionView.reloadData()
                                                                                    }
                                                                                }
                                                                }
                                                            }
        });
        task.resume()
    }
    
    
    // MARK: UICollectionView Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Set the number of items in your collection view.
        if let allMovies = self.movies {
            return allMovies.count
        }else{
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionMovieCell", for: indexPath as IndexPath) as! CollectionMovieCell
        
        let movie = movies![indexPath.row] as! [String: Any]
        
        if let poster = movie["poster_path"] as? String {
            let poster_url = URL(string: "https://image.tmdb.org/t/p/w342" + poster)
            cell.photoView.setImageWith(poster_url!)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let movie = movies![indexPath.row] as! [String: Any]
        
        cell.titleLabel.text = movie["title"] as? String
        cell.overviewLabel.text = movie["overview"] as? String
        
        if let poster = movie["poster_path"] as! String? {
            let poster_url = URL(string: "https://image.tmdb.org/t/p/w342" + poster)
            cell.posterView.setImageWith(poster_url!)
        }
        
        //cell.overviewLabel.sizeToFit()
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if (segue.identifier == "TableViewSegue"){
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let movie = movies![(indexPath?.row)!] as! NSDictionary
            let detailsViewController = segue.destination as! MovieDetailsViewController
            detailsViewController.movie = movie
        }else if(segue.identifier == "CollectionViewSegue"){
            let cell = sender as! CollectionMovieCell
            let indexPath = collectionView.indexPath(for: cell)
            let movie = movies![(indexPath?.row)!] as! NSDictionary
            let detailsViewController = segue.destination as! MovieDetailsViewController
            detailsViewController.movie = movie
        }else if(segue.identifier == "BarButtonSegue"){
    
        }
 

    }
}
