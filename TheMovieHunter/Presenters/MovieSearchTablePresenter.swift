//
//  MovieSearchTablePresenter.swift
//  TheMovieHunter
//
//  Created by ws-016-11b on 17.09.2018.
//  Copyright © 2018 ws-013-11b. All rights reserved.
//

import Foundation

class MovieSearchTablePresenter: MovieSearchTablePresenterProtocol {
    // TODO: figure out how not to initialize view and interactor below like in IOS-Viper-Architecture project
    weak var view: MovieSearchTableViewProtocol?
    var interactor: MovieSearchTableInteractorProtocol?
    
    func viewDidLoad(view: MovieSearchTableViewProtocol?) {
        if self.view == nil {
            self.view = view
        }
        if interactor == nil {
            interactor = MovieSearchTableInteractor(presenter: self)
        }
    }
    
    // MARK: Public methods
    func getGenres(with movie: Movie) -> String {
        var genres = ""
        if let interactor = interactor {
            genres = interactor.getGenres(with: movie)
        }
        return genres
    }
    
    func showError(_ errorMessage: String) {
        
        print(errorMessage)
        if let view = view {
            view.showError(errorMessage: errorMessage)
        }
    }
    
    func showMovies(with movies: [Movie]) {
        if let view = view {
            view.showMovies(with: movies)
            view.hideLoading()
        }
    }
    
    func searchMovies(with searchText: String) {
        if let interactor = interactor {
            interactor.searchMovies(with: searchText)
            view?.showLoading()
        }
    }
}
