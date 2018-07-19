//
//  UrlManager.swift
//  TheMovieHunter
//
//  Created by ws-013-11b on 7/19/18.
//  Copyright © 2018 ws-013-11b. All rights reserved.
//

import Foundation

class UrlManager {
    // urls
    public static let base_image_url = "https://image.tmdb.org/t/p/w500/"
    public static let base_url = "https://api.themoviedb.org/3/discover/movie?with_genres=12&primary_release_year=2018"
    public static let genre_list = "https://api.themoviedb.org/3/genre/movie/list"
    
    public static let api_key = "api_key=8a804ccd6e2b680e77ab60f86dc27bb6"
    
    class func getImageUrl(imgPath: String) -> URL {
        return URL(string: base_image_url + imgPath)!
    }
    
    class func getGenresUrl() -> URL {
        return URL(string: genre_list + "?" + api_key)!
    }
    
    class func getMoviesUrl() -> URL {
        return URL(string: base_url + "&" + api_key)!
    }
}
