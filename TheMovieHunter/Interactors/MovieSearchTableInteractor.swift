//
//  MovieSearchTableInteractor.swift
//  TheMovieHunter
//
//  Created by ws-016-11b on 17.09.2018.
//  Copyright © 2018 ws-013-11b. All rights reserved.
//

import Foundation

class MovieSearchTableInteractor: MovieSearchTableInteractorProtocol {
    
    // MARK: Properties
    
    private var movies: [Movie] = []
    private var mng: CoreDataManager
    var presenter: MovieSearchTablePresenterProtocol
    
    init(presenter: MovieSearchTablePresenterProtocol) {
        
        self.presenter = presenter
        
        mng = CoreDataManager()
    }
    
    // MARK: Public methods
    
    func searchMovies(with searchText: String) {
        URLSession.shared.dataTask(with: UrlManager.getMoviesBySearch(query: searchText)) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            let moviesJson = try? jsonDecoder.decode(MoviesResponse.self, from: data!)
            
            if let loadedMovies = moviesJson?.results {
                self.movies = self.movieResponsesToMovies(movieResults: loadedMovies)
                self.presenter.showMovies(with: self.movies)
            } else {
                self.presenter.showError(Constants.errorRequestGenres)
            }
        }.resume()
    }
    
    // MARK: Private methods
    private func movieResponsesToMovies(movieResults: [MovieResponse]?) -> [Movie] {
        let localContext = Utils.getContext()
        
        var movies: [Movie] = []
        
        if let movs = movieResults {
            for mov in movs {
                let movie = Movie(context: localContext)
                if let id = movie.id {
                    movie.id = String("\(id)")
                }
                movie.title = mov.title
                movie.backdrop_path = mov.backdrop_path
                movie.overview = mov.overview
                movie.popularity = mov.popularity!
                movie.poster_path = mov.poster_path
                movie.release_date = mov.release_date
                if let vote = mov.vote_count {
                    movie.vote_count = String("\(vote)")
                }
                movie.vote_average = mov.vote_average!
                movies.append(movie)
            }
        }
        return movies
    }
    
    func getGenres(with movie: Movie) -> String {
        return self.mng.getGenreNamesSequence(movie: movie)
    }
}
