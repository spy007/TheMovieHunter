//
//  MovieTablePresenter.swift
//  TheMovieHunter
//
//  Created by ws-013-11b on 8/22/18.
//  Copyright © 2018 ws-013-11b. All rights reserved.
//

import Foundation

class MovieTablePresenter: MovieTablePresenterProtocol {
        // TODO: figure out how not to initialize view and interactor below like in IOS-Viper-Architecture project
    weak var view: MovieTableViewProtocol?
    var interactor: MovieTableInteractorProtocol?
    
    func viewWillAppear() {
        guard let controller = try! view?.getTabBarController() as? MoviesTabBarController else {
            return
        }
        if(controller.shouldUpdateMovies){
            self.requestMoviesData(userFiredAction: false)
            controller.shouldUpdateMovies = false
        }
    }
    
    func viewDidLoad(view: MovieTableViewProtocol?) {
        if self.view == nil {
            self.view = view
        }
        if interactor == nil {
            interactor = MovieTableInteractor(presenter: self)
        }
        requestMoviesData(userFiredAction: false)
    }
    
    func requestMoviesData(userFiredAction: Bool) {
        if let interactor = interactor {
            interactor.requestMoviesData()
            if !userFiredAction {
                if let view = view {
                    view.showLoading()
                }
            }
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
        }
    }
    
    func searchActive(searchActive: Bool) {
        if let interactor = interactor {
            interactor.searchActive(searchActive: searchActive)
        }
    }
}
