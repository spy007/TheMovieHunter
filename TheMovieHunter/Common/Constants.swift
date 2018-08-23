//
//  Constants.swift
//  TheMovieHunter
//
//  Created by ws-013-11b on 7/13/18.
//  Copyright © 2018 ws-013-11b. All rights reserved.
//

import Foundation
import UIKit

public struct Constants {
    public static let starsCount = 5
    
    // image star
    public static let imageStarEmpty = "emptyStar"
    public static let imageStarFilled = "filledStar"
    public static let imageStarHighlighted = "highlightedStar"
    
    // size
    public static let imageStarSize = 44.0
    
    // Core Data
    // Entity Genre attribute name
    public static let attributeSelected = "selected"
    
    // messages
    public static let messageLoadingMovies = "Loading movies..."
    public static let errorRequestGenres = "Failed to request genres"
    public static let errorRequestMovies = "Failed to request movies"
    
    // labels
    public static let labelGenres = "Genres: "
    
    // other
    public static let actionId = 28
    public static let login = "kirill.ivanou"
    public static let password = "Test1"
    
    public static let minMovieYear = 1902.0
}
