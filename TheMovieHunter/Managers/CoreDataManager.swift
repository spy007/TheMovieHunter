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
    
    let managedContext = Utils.getContext()
    
    // MARK: Movies
    
    func save(movieResults: [MovieResponse]?) -> [Movie] {
        
        
        
        var movies: [Movie] = []
        let userIds = getGenreIds()
        
        if let movs = movieResults {
            for mov in movs {
                let ids = Set<Int>(mov.genre_ids!)
                
                if !ids.intersection(userIds).isEmpty {
                    let movie = Movie(context: managedContext)
                    if let id = movie.id {
                        movie.id = String("\(id)")
                    }
                    movie.title = mov.title
                    movie.backdrop_path = mov.backdrop_path
                    movie.overview = mov.overview
                    movie.popularity = mov.popularity!
                    movie.poster_path = mov.poster_path
                    movie.release_date = mov.release_date
                    // set genres
                    for id in ids {
                        let genreId = GenreId(context: managedContext)
                        genreId.id = "\(id)"
                        movie.addToGenreIds(genreId)
                    }
                    if let vote = mov.vote_count {
                        movie.vote_count = String("\(vote)")
                    }
                    movie.vote_average = mov.vote_average!
                    
                    movies.append(movie)
                }
            }
            
            saveContext()
        }
        
        return movies
    }
    
    func getMovies() -> [Movie] {
        var movsDb: [Movie]? = nil
        
        do {
            movsDb = try managedContext.fetch(Movie.fetchRequest())
        } catch {
            print("Failed to fetch movies from Core Data")
        }
        
        return movsDb!
    }
    
    func getGenreIds() -> Set<Int> {
        var ids = Set<Int>()
        if let genres = getGenres() {
            
            for genre in genres {
                if genre.selected {
                    ids.insert(Int(genre.id!)!)
                }
            }
        }
        
        return ids
    }
    
    // MARK: Genres

    func saveUserSelectedGenre(genreSelected: Genre?, isSelected: Bool) {
        
        if let genreSelected = genreSelected {
            
            genreSelected.setValue(isSelected, forKey: Constants.attribute_selected)
            
            saveContext()
            
            Defaults.setSelectedGenres()
        }
    }
    
    func save(genresResponse: [MovieGenreResponse]) {
        var genres = [Genre]()
        
        for gen in genresResponse {
            let genre = Genre(context: managedContext)
            if let id = gen.id {
                genre.id = String("\(id)")
            }
            genre.name = gen.name
            
            genres.append(genre)
        }
    }
    
    func getGenres() -> [Genre]? {
        var genresDb: [Genre]? = nil
        // ordering by name
        let fetchRequest = NSFetchRequest<Genre>(entityName: "Genre")
        let sort = NSSortDescriptor(key: #keyPath(Genre.name), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        do {
            genresDb = try managedContext.fetch(Genre.fetchRequest())
        } catch {
            print("Failed to fetch genres from Core Data")
        }
        
        return genresDb
    }
    
    func getGenresDict() -> [Int:Genre]? {
        let genres = getGenres()
        
        var genresDict = [Int:Genre]()
        
        for genre in genres! {
            let id = Int(genre.id!)
            genresDict[id!] = genre
            
        }
        
        return genresDict
    }

    func deleteAllData(entity: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Delete all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    
    func getGenreNamesSequence(movie: Movie) -> String {
        var genresSeq = ""
        var idx = 0
        var dictGenres = CoreDataManager().getGenresDict()
        if let ids = movie.genreIds {
            for id in ids {
                let genreId = id as! GenreId
                genresSeq += (dictGenres![Int(genreId.id!)!]?.name)!
                if (idx < (movie.genreIds?.count)! - 1) {
                    genresSeq += ", "
                }
                idx += 1
            }
        }
        
        return genresSeq
    }
    
    func getGenresDict(genres: [MovieGenreResponse]?) -> [Int: String] {
        
        var dictGenres = [Int: String]()
        
        for genre in genres! {
            dictGenres.updateValue((genre.name)!, forKey: (genre.id)!)
        }
        
        return dictGenres
    }
    
    func saveContext() {
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
}
