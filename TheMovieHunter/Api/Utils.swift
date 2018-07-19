//
//  Utils.swift
//  TheMovieHunter
//
//  Created by ws-013-11b on 7/18/18.
//  Copyright © 2018 ws-013-11b. All rights reserved.
//

import Foundation

class Utils {
    
    class func getGenresByIds(idsArr: [Int]?, dictGenres: [Int:String]) -> String {
        var genres = ""
        
        if let ids = idsArr {
            var idx = 0
            for id in ids {
                if (idx > 0) {
                    genres += ", "
                }
                genres += dictGenres[id]!
                idx += 1
            }
        }
        
        return genres
    }
    
    class func getGenresDict(genres: [MovieGenre]?) -> [Int: String] {

        var dictGenres = [Int: String]()
        
        for genre in genres! {
            dictGenres.updateValue((genre.name)!, forKey: (genre.id)!)
        }
        
        return dictGenres
    }
}
