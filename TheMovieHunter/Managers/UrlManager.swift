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
    public static let base_url = "https://api.themoviedb.org/3"
    
    public static let base_image_url = "https://image.tmdb.org/t/p/w500/"
    public static let genre_list = "/genre/movie/list"
    public static let guest_session = "/authentication/guest_session/new"
    public static let api_key = "api_key=8a804ccd6e2b680e77ab60f86dc27bb6"
    public static let token = "/authentication/token/new"
    public static let validate_with_login = "/authentication/token/validate_with_login"
    public static let search = "/search/movie"
    
    class func getImageUrl(imgPath: String) -> URL {
        return URL(string: base_image_url + imgPath)!
    }
    
    class func getGenresUrl() -> URL {
        return URL(string: base_url + genre_list + "?" + api_key)!
    }
    
    class func getMoviesUrlByYear(year: Int) -> URL {
        return URL(string: base_url + "/discover/movie?with_genres=12&primary_release_year=\(year)" + "&" + api_key)!
    }
    
    class func getMoviesBySearch(query: String) -> URL {
        return URL(string: base_url + search + "?"+api_key+"&query=\(query)&page=1&include_adult=false")!
    }
    
    class func getGuestSession() -> URL {
        return URL(string: base_url + guest_session + "?" + api_key)!
    }
    
    class func getToken() -> URL {
        return URL(string: base_url + token + "?" + api_key)!
    }
    
    class func getValidateWithLogin() -> String {
        return base_url + validate_with_login + "?" + api_key
    }
}
