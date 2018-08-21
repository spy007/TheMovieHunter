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
    
    // sized
    public static let imageStarSize = 44.0
    public static let labelGenresWidth: CGFloat = 100
    public static let pickerGenresWidth: CGFloat = 50
    public static let pickerGenresHeight: CGFloat = 50
    public static let searchSettingsHeight: CGFloat = 130
    
    // Core Data
    // Entity GenreSelected attribute names
    public static let attribute_selected = "selected"
    
    // messages
    public static let alertLoadingMovies = "Loading movies ..."
    
    // labels
    public static let labelGenres = "Genres: "
    
    public static let minMovieYear = 1902.0
    
    // other
    public static let actionId = 28
    public static let login = "kirill.ivanou"
    public static let password = "Test1"
}
