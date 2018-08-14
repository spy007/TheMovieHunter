//
//  UserDefaults.swift
//  TheMovieHunter
//
//  Created by ws-013-11b on 8/2/18.
//  Copyright © 2018 ws-013-11b. All rights reserved.
//

import Foundation

class Defaults {
    static private let minMovieYearKey = "minMovieYear"
    static private let maxMovieYearKey = "maxMovieYearKey"
    static let selectedGenresKey = "selectedGenresKey"
    static let guestExpireDateKey = "guestExpireDateKey"
    
    class func setMovieYearsRange(movieYear: (Double, Double)) {
        let defaults = UserDefaults.standard
        defaults.set(movieYear.0, forKey: minMovieYearKey)
        defaults.set(movieYear.1, forKey: maxMovieYearKey)
    }
    
    class func getMovieYearsRange() -> (Double,Double) {
        let defaults = UserDefaults.standard
        
        var movieYear = (0.0, MovieYearUtils.getCurrentYear() - Constants.minMovieYear)
        
        if keyExists(key: minMovieYearKey) {
            movieYear = (defaults.double(forKey: minMovieYearKey), defaults.double(forKey: maxMovieYearKey))
        }
        
        return movieYear
    }
    
    class func setSelectedGenres() {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: selectedGenresKey)
    }
    
    class func keyExists(key: String) -> Bool {
        let defaults = UserDefaults.standard
        let keyExists = defaults.object(forKey: key) != nil
        print("keyExists=\(keyExists)")
        
        return keyExists
    }
    
    class func setGuestExpireDate(guestExpireDate: String) {
        let defaults = UserDefaults.standard
        defaults.set(guestExpireDate, forKey: guestExpireDateKey)
    }
    
    class func getGuestExpireDate() -> String? {
        let defaults = getUserDefaults()
        guard let guestExpireDate = defaults.string(forKey: guestExpireDateKey) else {
            return nil
        }
        
        var date: String? = nil
        date = guestExpireDate
        return date
    }
    
    class func getUserDefaults() -> UserDefaults {
        return UserDefaults.standard
    }
}
