//
//  MovieTableInteractorProtocol.swift
//  TheMovieHunter
//
//  Created by ws-013-11b on 8/22/18.
//  Copyright © 2018 ws-013-11b. All rights reserved.
//

import Foundation

class MovieTableInteractor: MovieTableInteractorProtocol {
    
    // MARK: Properties
    
    private var movies: [Movie] = []
    private var mng: CoreDataManager? = nil
    weak var presenter: MovieTablePresenterProtocol?
    private var searchActive : Bool = false
    
    init(presenter: MovieTablePresenterProtocol?) {
        
        self.presenter = presenter
        
        mng = CoreDataManager()
    }
    
    // MARK: Public methods
    
    func requestMoviesData() {
    
        if !Defaults.keyExists(key: Defaults.selectedGenresKey) {
            
            URLSession.shared.dataTask(with: UrlManager.getGenresUrl()) { (data, response, error) in
                
                let jsonDecoder = JSONDecoder()
                let genresJson = try? jsonDecoder.decode(GenresResponse.self, from: data!)
                
                if let genres = genresJson?.genres {
                    self.mng?.save(genresResponse: genres)
                    self.loadMovies()
                } else {
                    self.presenter?.showError(Constants.errorRequestGenres)
                }
                
                }.resume()
        } else {
            loadMovies()
        }
    }
    
    func searchMovies(with searchText: String) {
        
        var filtered: [Movie]? = nil
        
        if searchText.count == 0 {
            searchActive = false;
        } else {
            filtered = movies.filter({ (movie) -> Bool in
                let tmp: NSString = movie.title! as NSString
                let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                return range.location != NSNotFound
            })
            if(filtered?.count == 0){
                searchActive = false;
            } else {
                searchActive = true;
            }
        }
        
        var searchMovies: [Movie]?
        if searchActive {
            searchMovies = filtered
        } else {
            searchMovies = movies
        }
        if let searchMovies = searchMovies {
            presenter?.showMovies(with: searchMovies)
        }
    }
    
    // MARK: Private methods
    
    private func loadMovies() {
        
        self.mng?.deleteAllData(entity: String(describing: Movie.self))
        
        let moviesYearRange = Defaults.getMovieYearsRange()
        let maxYear = Int(moviesYearRange.1)
        let minYear = Int(moviesYearRange.0)
        
        self.movies.removeAll()
        
        for y in minYear...maxYear {
            
            URLSession.shared.dataTask(with: UrlManager.getMoviesUrlByYear(year: Int(Constants.minMovieYear)+y)) { (data, response, error) in
                let jsonDecoder = JSONDecoder()
                
                let responseModel = try? jsonDecoder.decode(MoviesResponse.self, from: data!)
                
                if let movieResults = responseModel!.results {
                    if !Defaults.keyExists(key: Defaults.selectedGenresKey) {
                        // not to make movies list empty if user have not yet selected genres
                        if let genreSelected = self.mng?.getGenresDict()![Constants.actionId] {
                            self.mng?.saveUserSelectedGenre(genreSelected: genreSelected, isSelected: true)
                        }
                    }
                    DispatchQueue.main.sync {
                        if let movs = self.mng?.save(movieResults: movieResults) {
                            if !movs.isEmpty {
                                self.movies += movs
                            }
                        }
                    }
                }
                
                if y == maxYear {
                    if !self.movies.isEmpty {
                        self.presenter?.showMovies(with: self.movies)
                    } else {
                        self.presenter?.showError(Constants.errorRequestMovies)
                    }
                } 
                
                }.resume()
        }
    }
    
    func searchActive(searchActive: Bool) {
        self.searchActive = searchActive
    }
    
    func getGenres(with movie: Movie) -> String {
        var genres = ""
        if let gens = self.mng?.getGenreNamesSequence(movie: movie) {
            genres = gens
        }
        
        return genres
    }
}
