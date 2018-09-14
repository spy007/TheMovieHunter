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



//        if interactor == nil {
//            interactor = MovieTableInteractor(presenter: self)
//        }
        
        //view?.showLoading()
        //interactor?.requestMoviesData()
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
        interactor?.requestMoviesData()
        if !userFiredAction {
            view?.showLoading()
        }
    }
    
    // MARK: Public methods
    
    func getGenres(with movie: Movie) -> String {
        var genres = ""
        
        if let gens = interactor?.getGenres(with: movie) {
            genres = gens
        }
        
        return genres
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
