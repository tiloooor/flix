//
//  NowPlayingViewController.swift
//  flix
//
//  Created by Tyler Holloway on 6/21/17.
//  Copyright © 2017 Tyler Holloway. All rights reserved.
//

import UIKit
import AlamofireImage

class NowPlayingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate
 {

    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    var filteredMovies: [[String: Any]] = []
    var movies: [[String: Any]] = []
    var refreshControl: UIRefreshControl!
    var alertController: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        
        
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
       
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        
        //set up delegates
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        filteredMovies = movies
        
        alertController = UIAlertController(title: "No Wifi", message: "Message", preferredStyle: .alert)
        // create a cancel action
        let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
            self.fetchMovies()
        }
        // add the cancel action to the alertController
        alertController.addAction(cancelAction)

        
        fetchMovies()
    }
    
    
    
    func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        
       fetchMovies()
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)as! MovieCell
        
    
        
        let movie = filteredMovies[indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        let posterPathString = movie["poster_path"] as! String
        let baseURLString = "https://image.tmdb.org/t/p/w500"
        
        
        let posterURL = URL(string: baseURLString + posterPathString)!
        cell.posterImageView.af_setImage(withURL: posterURL)
        
        
        
        return cell
    }
    
    
    // This method updates filteredData based on the text in the Search Box
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        if searchText.isEmpty {
            filteredMovies = movies
        } else {
            filteredMovies = movies.filter {(movie: [String: Any]) -> Bool in
                let title = movie["title"] as! String
                return title.range (of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            }
        }
            
        tableView.reloadData()
    }
    
    
    
    func fetchMovies() {
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=5f89533e24a2ff0828389c5e1cb6f8e8")!
        
        let request = URLRequest(url: url, cachePolicy: . reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            //This will run when the network request returns
            if let error = error  {
                print(error.localizedDescription)
                self.present(self.alertController, animated: true) {
                    // optional code for what happens after the alert controller has finished presenting
                }
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                print(dataDictionary)
                
                let movies = dataDictionary["results"] as! [[String: Any]]
                self.movies = movies
                self.filteredMovies = movies
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                self.activityIndicator.stopAnimating()
            }
        }
        
        task.resume()
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender  as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell) {
            let movie = movies[indexPath.row]
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.movie = movie
        }
    }




    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
