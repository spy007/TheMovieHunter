//
//  MovieYearUtils.swift
//  TheMovieHunter
//
//  Created by ws-013-11b on 8/2/18.
//  Copyright © 2018 ws-013-11b. All rights reserved.
//

import Foundation

class MovieYearUtils {
    public class func getMinYearOfMovies(userSelectedMinYearOfMovies: Double) -> String {
        return "\(Int(Constants.minMovieYear + userSelectedMinYearOfMovies))"
    }
    
    public class func getMaxYearOfMovies(userSelectedMaxYearOfMovies: Double) -> String {
        return "\(Int(Constants.minMovieYear + userSelectedMaxYearOfMovies))"
    }
    
    class func getCurrentYear() -> Double {
        return Double(Calendar.current.component(.year, from: Date()))
    }
}
