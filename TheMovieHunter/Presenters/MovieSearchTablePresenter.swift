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
    lazy var interactor: MovieSearchTableInteractorProtocol = MovieSearchTableInteractor(presenter: self)
    
    func viewDidLoad(view: MovieSearchTableViewProtocol?) {
        if self.view == nil {
            self.view = view
        }
    }
    
    // MARK: Public methods
    func getGenres(with movie: Movie) -> String {
        return interactor.getGenres(with: movie)
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
        interactor.searchMovies(with: searchText)
        view?.showLoading()
    }
}
