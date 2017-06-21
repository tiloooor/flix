//
//  NowPlayingViewController.swift
//  flix
//
//  Created by Tyler Holloway on 6/21/17.
//  Copyright © 2017 Tyler Holloway. All rights reserved.
//

import UIKit

class NowPlayingViewController: UIViewController {

    @IBOutlet weak var TableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=5f89533e24a2ff0828389c5e1cb6f8e8")!
        
        let request = URLRequest(url: url, cachePolicy: . reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            //This will run when the network request returns
            if let error = error  {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                print(dataDictionary)
                
                let movies = dataDictionary["results"] as! [[String: Any]]
                //loop through array to get the title out
                for movie in movies {
                    let title = movie["title"] as! String
                    print(title)
                }
            }
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
