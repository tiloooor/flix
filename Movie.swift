//
//  Movie.swift
//  
//
//  Created by Tyler Holloway on 7/3/17.
//
//

import Foundation

class Movie {
    
    var title: String
    var posterUrl: URL?
    
    init(dictionary: [String: Any]) {
        title = dicitonary["title"] as? String ?? "No title"
    }
    

}
