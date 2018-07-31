//
//  CoreDataManager.swift
//  TheMovieHunter
//
//  Created by ws-013-11b on 7/18/18.
//  Copyright © 2018 ws-013-11b. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
    var context: NSManagedObjectContext?
    
    init() {
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    // MARK: Movies
    
    func save(navigationController: UINavigationController?, movieResults: [MovieResults]?, genres: [MovieGenre]?) {
        //        DispatchQueue.global(qos: .userInitiated).async {
        var movies: [Movie] = []
        let dictGenres = Utils.getGenresDict(genres: genres)
        
        if let movs = movieResults {
            for mov in movs {
                let movie = Movie(context: context!)
                if let id = movie.id {
                    movie.id = String("\(id)")
                }
                movie.title = mov.title
                movie.backdrop_path = mov.backdrop_path
                movie.overview = mov.overview
                movie.popularity = mov.popularity!
                movie.poster_path = mov.poster_path
                movie.release_date = mov.release_date
                movie.genres = Utils.getGenresByIds(idsArr: mov.genre_ids, dictGenres: dictGenres)
                if let vote = mov.vote_count {
                    movie.vote_count = String("\(vote)")
                }
                movie.vote_average = mov.vote_average!
                
                movies.append(movie)
            }
            
            if movies.count > 0 {
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                let _ = navigationController?.popViewController(animated: true)
            }
        }
        //        }
    }
    
    func getMovies() -> [Movie] {
        var movsDb: [Movie]? = nil
        
        do {
            movsDb = (try context?.fetch(Movie.fetchRequest()))!
        } catch {
            print("Failed to fetch movies from Core Data")
        }
        
        return movsDb!
    }
    
    // MARK: Genres
    
    func save(navigationController: UINavigationController?, movieGenres: [MovieGenre]?) {
        var genres: [Genre]
        
        if let gens = movieGenres {
            genres = []
            for gen in gens {
                let genre = Genre(context: context!)
                if let id = gen.id {
                    genre.id = String("\(id)")
                }
                genre.name = gen.name
                
                genres.append(genre)
            }
            
            if genres.count > 0 {
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                let _ = navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func getGenres() -> [Genre]? {
        var genresDb: [Genre]? = nil
        
        do {
            genresDb = (try context?.fetch(Genre.fetchRequest()))!
        } catch {
            print("Failed to fetch genres from Core Data")
        }
        
        return genresDb
    }
    
    func deleteAllData(entityName: String)
    {
        // Create Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        // Create Batch Delete Request
        // Batch delete request bypasses the managed object context, it is handed to the managed object context to be executed. This may seem odd, but remember that a managed object context keeps a reference to the persistent store coordinator it is associated with.
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context?.execute(batchDeleteRequest)
        } catch {
            // Error Handling
        }
    }
}
