//
//  Movie.swift
//  flix
//
//  Created by Tyler Holloway on 7/3/17.
//  Copyright © 2017 Tyler Holloway. All rights reserved.
//

import Foundation

class Movie {
    var title: String
    var posterUrl: URL?
    
    init(dictionary: [String: Any]) {
        title = dictionary["title"] as? String ?? "No title"
    }
    
    class func movies(dictionaries: [[String: Any]]) -> [Movie] {
        var movies: [Movie] = []
        for dictionary in dictionaries {
            let movie = Movie(dictionary: dictionary)
            movies.append(movie)
        }
        
        return movies
    }
}
