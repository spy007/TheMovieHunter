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
    static let expireDateKey = "expireDateKey"
    static let requestTokenKey = "requestTokenKey"
    static let usernameKey = "usernameKey"
    static let passwordKey = "passwordKey"
    static let rememberMeKey = "rememberMeKey"
    
    class func setMovieYearsRange(movieYear: (Double, Double)) {
        if let defaults = getUserDefaults() {
            defaults.set(movieYear.0, forKey: minMovieYearKey)
            defaults.set(movieYear.1, forKey: maxMovieYearKey)
        }
    }
    
    class func getMovieYearsRange() -> (Double, Double) {
        
        let max = MovieYearUtils.getCurrentYear() - Constants.minMovieYear
        var movieYear = (max - 1, max)
        
        if let defaults = getUserDefaults(), keyExists(key: minMovieYearKey) {
            movieYear = (defaults.double(forKey: minMovieYearKey), defaults.double(forKey: maxMovieYearKey))
        }
        
        return movieYear
    }
    
    class func set(credentials: (String, String)) {
        if let defaults = getUserDefaults() {
            defaults.set(credentials.0, forKey: usernameKey)
            defaults.set(credentials.1, forKey: passwordKey)
        }
    }
    
    class func getCredentials() -> (String, String) {
        
        var credentials = ("", "")
        
        if let defaults = getUserDefaults(), keyExists(key: usernameKey) {
            if let username = defaults.string(forKey: usernameKey), let password = defaults.string(forKey: passwordKey) {
                credentials = (username, password)
            }
        }
        
        return credentials
    }
    
    class func setSelectedGenres() {
        if let defaults = getUserDefaults() {
            defaults.set(true, forKey: selectedGenresKey)
        }
    }
    
    class func setGuestExpireDate(guestExpireDate: String) {
        if let defaults = getUserDefaults() {
            defaults.set(guestExpireDate, forKey: guestExpireDateKey)
        }
    }
    
    class func getGuestExpireDate() -> String? {
        return getUserDefaultValue(key: guestExpireDateKey)
    }
    
    class func setExpireDate(expireDate: String) {
        if let defaults = getUserDefaults() {
            defaults.set(expireDate, forKey: expireDateKey)
        }
    }
    
    class func getExpireDate() -> String? {
        return getUserDefaultValue(key: expireDateKey)
    }
    
    class func setRequestToken(requestToken: String) {
        if let defaults = getUserDefaults() {
            defaults.set(requestToken, forKey: requestTokenKey)
        }
    }
    
    class func getRequesToken() -> String? {
        return getUserDefaultValue(key: requestTokenKey)
    }
    
    class func setRememberMe(rememberMe: Bool) {
        if let defaults = getUserDefaults() {
            defaults.set(rememberMe, forKey: rememberMeKey)
        }
    }
    
    class func getRememberMe() -> Bool {
        var rememberMe = false
        
        if let defaults = getUserDefaults() {
            rememberMe = defaults.bool(forKey: rememberMeKey)
        }
        
        return rememberMe
    }
    
    class func getUserDefaultValue(key: String) -> String? {
        
        var date: String? = nil
        
        if let defaults = getUserDefaults() {
            guard let expireDate = defaults.string(forKey: key) else {
                return nil
            }
            
            date = expireDate
        }
        
        return date
    }
    
    class func keyExists(key: String) -> Bool {
        var keyExists = false
        
        if let defaults = getUserDefaults() {
            keyExists = defaults.object(forKey: key) != nil
        }
        print("keyExists=\(keyExists)")
        
        return keyExists
    }
    
    class func getUserDefaults() -> UserDefaults? {
        return UserDefaults.standard
    }
}
