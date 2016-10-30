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

extension UIColor {
    // Extend UIColor to allow HTML-style hex values
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Bad red hex value: 0 - 255 only")
        assert(green >= 0 && green <= 255, "Bad green hex value: 0 - 255 only")
        assert(blue >= 0 && blue <= 255, "Bad blue hex value: 0 - 255 only")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
}

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    // MARK: Outlets
    @IBOutlet weak var networkErrorView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movies: [Any]?
    var endpoint: String!
    var filteredData: [Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        
        self.automaticallyAdjustsScrollViewInsets = false // this was creating an unwanted inset in collection view
        
        networkErrorView.isHidden = true
        tableView.isHidden = true
        collectionView.isHidden = true
        
        let defaults = UserDefaults.standard
        if (defaults.integer(forKey: "displayType") == 0) {
            // Table View
            tableView.isHidden = false
        }else{
            // CollectionView
            collectionView.isHidden = false
        }
        
        callAPI(endpoint: self.endpoint)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        collectionView.insertSubview(refreshControl, at: 0)

        let contentWidth = tableView.bounds.width
        let contentHeight = tableView.bounds.height * 3
        tableView.contentSize = CGSize(width: contentWidth, height: contentHeight)
        
        networkErrorView.layer.cornerRadius = 3
        networkErrorView.layer.shadowColor = UIColor.black.cgColor
        networkErrorView.layer.shadowOffset = CGSize(width: 3, height: 3)
        networkErrorView.layer.shadowOpacity = 0.3
        networkErrorView.layer.shadowRadius = 3.0
        
        // Customizing the nav bar
        
        if let navigationBar = navigationController?.navigationBar {
            //navigationBar.setBackgroundImage(UIImage(named: "clouds.png"), for: .default)
            //navigationBar.tintColor = UIColor(red: 1.0, green: 0.25, blue: 0.25, alpha: 0.8)
            
            navigationBar.isTranslucent = true
            self.navigationController!.view.backgroundColor = UIColor.clear

            let shadow = NSShadow()
            shadow.shadowColor = UIColor.gray.withAlphaComponent(0.5)
            shadow.shadowOffset = CGSize(width: 2, height:2);
            shadow.shadowBlurRadius = 4;
            navigationBar.titleTextAttributes = [
                //NSFontAttributeName : UIFont.boldSystemFont(ofSize: 22),
                //NSForegroundColorAttributeName : UIColor(red: 0.5, green: 0.15, blue: 0.15, alpha: 0.8),
                NSShadowAttributeName : shadow
            ]
        }

    }

    @IBAction func unwindToVC(segue: UIStoryboardSegue) {
    }
    
    func hideNetworkError(){
        UIView.animate(withDuration:0.4, animations: {
            self.networkErrorView.alpha = 0
        })
    }

    func showNetworkError(){
        networkErrorView.isHidden = false
        searchBar.isHidden = true
        collectionView.isHidden = true
        tableView.isHidden = true
        
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
                                                                    if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary { self.successCallback(responseDictionary: responseDictionary)}
                                                                }
                                                            }
        });
        task.resume()
    }
    
    func successCallback(responseDictionary: NSDictionary){
        MBProgressHUD.hide(for: self.view, animated: true)
        self.hideNetworkError()
        searchBar.isHidden = false
        
        if let movies_array = responseDictionary["results"] as? [Any]{
            self.movies = movies_array
            self.filteredData = movies_array
            
            self.tableView.reloadData()
            self.collectionView.reloadData()
         
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let defaults = UserDefaults.standard
        if (defaults.integer(forKey: "displayType") == 0) {
            // Table View
            collectionView.isHidden = true
            tableView.isHidden = false
        }else{
            // CollectionView
            tableView.isHidden = true
            collectionView.isHidden = false
        }
    }
    
    // MARK: UISearchBar Delegates
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.isEmpty){
            self.filteredData = self.movies
        }else{
            if let movies = movies as? [[String: Any]]{
                self.filteredData = []
                for movie in movies{
                    if let title = movie["title"] as? String{
                        if(title.range(of: searchText, options: .caseInsensitive) != nil){
                            self.filteredData.append(movie)
                        }
                    }
                }
            }
        }
        tableView.reloadData()
        collectionView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        self.filteredData = self.movies
        tableView.reloadData()
        collectionView.reloadData()
        searchBar.resignFirstResponder()
    }
    
    // MARK: UICollectionView Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if filteredData != nil{
            return filteredData.count
        }else{
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionMovieCell", for: indexPath as IndexPath) as! CollectionMovieCell
        
        let movie = filteredData![indexPath.row] as! [String: Any]
        
        if let poster = movie["poster_path"] as? String {
            let imageUrl = URL(string: "https://image.tmdb.org/t/p/w92" + poster)!
            let imageRequest = NSURLRequest(url: imageUrl)
            
            cell.photoView.setImageWith(
                imageRequest as URLRequest,
                placeholderImage: nil,
                success: { (imageRequest, imageResponse, image) -> Void in
                    
                    // imageResponse will be nil if the image is cached
                    if imageResponse != nil {
                        //print("Image was NOT cached, fade in image")
                        cell.photoView.alpha = 0.0
                        cell.photoView.image = image
                        
                        UIView.animate(withDuration: 0.4,
                                       animations: { () -> Void in cell.photoView.alpha = 1.0},
                                       
                                       completion: { (success) -> Void in
                                        // The AFNetworking ImageView Category only allows one request to be sent at a time
                                        // per ImageView. This code must be in the completion block.
                                        let bigImageUrl = URL(string: "https://image.tmdb.org/t/p/w342" + poster)!
                                        let bigImageRequest = NSURLRequest(url: bigImageUrl)
                                        
                                        cell.photoView.setImageWith(
                                            bigImageRequest as URLRequest,
                                            placeholderImage: image,
                                            success: { (bigImageRequest, bigImageResponse, bigImage) -> Void in
                                                cell.photoView.image = bigImage
                                            }, // success hi res
                                            failure: { (request, response, error) -> Void in }
                                            
                                        ) // setting hi res image
                                        
                            } // animate completion handler
                        ) // animate
                    } else {
                        //print("Image was cached so just update the image")
                        cell.photoView.image = image
                    } // low res cache hit/miss
                    
                }, // low res success
                failure: { (imageRequest, imageResponse, error) -> Void in // do something for the failure condition
                }
            ) // set low res image
            
        } // unwrap movie["poster_path"]

        
        /*
        if let poster = movie["poster_path"] as? String {
            let imageUrl = URL(string: "https://image.tmdb.org/t/p/w92" + poster)!
            let imageRequest = NSURLRequest(url: imageUrl)
            
            cell.photoView.setImageWith(
                imageRequest as URLRequest,
                placeholderImage: nil,
                success: { (imageRequest, imageResponse, image) -> Void in
                    
                    // imageResponse will be nil if the image is cached
                    if imageResponse != nil {
                        cell.photoView.alpha = 0.0
                        cell.photoView.image = image
                        UIView.animate(withDuration: 0.3, animations: { () -> Void in
                            cell.photoView.alpha = 1.0
                        })
                    } else {
                        cell.photoView.image = image
                    }
                },
                failure: { (imageRequest, imageResponse, error) -> Void in
                    // do something for the failure condition
            })
        } */
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
        if filteredData != nil{
            return filteredData.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = filteredData[indexPath.row] as! [String: Any]
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red:0.96, green:0.79, blue:0.78, alpha:1.0) // 0xF6CAC8
        cell.selectedBackgroundView = backgroundView
        
        cell.titleLabel.text = movie["title"] as? String
        cell.overviewLabel.text = movie["overview"] as? String
        
        if let poster = movie["poster_path"] as? String {
            let imageUrl = URL(string: "https://image.tmdb.org/t/p/w92" + poster)!
            let imageRequest = NSURLRequest(url: imageUrl)
            
            cell.posterView.setImageWith(
                imageRequest as URLRequest,
                placeholderImage: nil,
                success: { (imageRequest, imageResponse, image) -> Void in
                    
                    // imageResponse will be nil if the image is cached
                    if imageResponse != nil {
                        //print("Image was NOT cached, fade in image")
                        cell.posterView.alpha = 0.0
                        cell.posterView.image = image
                        
                        UIView.animate(withDuration: 0.4,
                                       animations: { () -> Void in cell.posterView.alpha = 1.0},
                                       
                                       completion: { (success) -> Void in
                                        // The AFNetworking ImageView Category only allows one request to be sent at a time
                                        // per ImageView. This code must be in the completion block.
                                            let bigImageUrl = URL(string: "https://image.tmdb.org/t/p/w342" + poster)!
                                            let bigImageRequest = NSURLRequest(url: bigImageUrl)
                                        
                                            cell.posterView.setImageWith(
                                                bigImageRequest as URLRequest,
                                                placeholderImage: image,
                                                success: { (bigImageRequest, bigImageResponse, bigImage) -> Void in
                                                    cell.posterView.image = bigImage
                                                }, // success hi res
                                                failure: { (request, response, error) -> Void in }
                                            
                                            ) // setting hi res image
                                        
                                        } // animate completion handler
                                       ) // animate
                    } else {
                        //print("Image was cached so just update the image")
                        cell.posterView.image = image
                    } // low res cache hit/miss
                    
                }, // low res success
                failure: { (imageRequest, imageResponse, error) -> Void in // do something for the failure condition 
                }
            ) // set low res image
            
        } // unwrap movie["poster_path"]
        return cell
        
    } // cellForRowAt
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "TableViewSegue"){
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let movie = filteredData![(indexPath?.row)!] as! NSDictionary
            let detailsViewController = segue.destination as! MovieDetailsViewController
            detailsViewController.movie = movie
        }else if(segue.identifier == "CollectionViewSegue"){
            let cell = sender as! CollectionMovieCell
            let indexPath = collectionView.indexPath(for: cell)
            let movie = filteredData![(indexPath?.row)!] as! NSDictionary
            let detailsViewController = segue.destination as! MovieDetailsViewController
            detailsViewController.movie = movie
        }else if(segue.identifier == "BarButtonSegue"){
        }
    }
    
}
