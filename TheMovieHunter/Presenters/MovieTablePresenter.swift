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
    lazy var interactor: MovieTableInteractorProtocol = MovieTableInteractor(presenter: self)
    
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
        requestMoviesData(userFiredAction: false)
    }
    
    func requestMoviesData(userFiredAction: Bool) {
        interactor.requestMoviesData()
        if !userFiredAction {
            if let view = view {
                view.showLoading()
            }
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
    }
    
    func searchActive(searchActive: Bool) {
        interactor.searchActive(searchActive: searchActive)
    }
}
