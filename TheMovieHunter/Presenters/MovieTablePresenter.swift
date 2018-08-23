//
//  MovieTablePresenter.swift
//  TheMovieHunter
//
//  Created by ws-013-11b on 8/22/18.
//  Copyright © 2018 ws-013-11b. All rights reserved.
//

import Foundation

class MovieTablePresenter: MovieTablePresenterProtocol {
        // TODO: figure out how to not to initialize view and interactor below like in IOS-Viper-Architecture project
    weak var view: MovieTableViewProtocol?
    var interactor: MovieTableInteractorProtocol?
    
    func viewWillAppear(view: MovieTableViewProtocol?) {
        if self.view == nil {
            self.view = view
        }
        if interactor == nil {
            interactor = MovieTableInteractor(presenter: self)
        }
            
        view?.showLoading()
        interactor?.requestMoviesData()
    }
    
    func showError(_ errorMessage: String) {
        print(errorMessage)
        view?.showError(errorMessage: errorMessage)
    }
    
    func showMovies(with movies: [Movie]) {
        view?.showMovies(with: movies)
        view?.hideLoading()
    }
    
    func searchMovies(with searchText: String) {
        interactor?.searchMovies(with: searchText)
    }
    
    func searchActive(searchActive: Bool) {
        interactor?.searchActive(searchActive: searchActive)
    }
}
