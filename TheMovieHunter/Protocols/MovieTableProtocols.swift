//
//  MovieTableProtocol.swift
//  TheMovieHunter
//
//  Created by ws-013-11b on 8/22/18.
//  Copyright © 2018 ws-013-11b. All rights reserved.
//

import UIKit

protocol MovieTableViewProtocol: class {
    var presenter: MovieTablePresenterProtocol? { get set }
    
    // PRESENTER -> VIEW
    func showLoading()
    
    func hideLoading()
    
    func showError(errorMessage: String)
    
    func showMovies(with movies: [Movie])
}

protocol  MovieTablePresenterProtocol: class {
    var view: MovieTableViewProtocol?  { get set }
    var interactor: MovieTableInteractorProtocol?  { get set }
    
    // VIEW -> PRESENTER
    func viewWillAppear(view: MovieTableViewProtocol?)
    
    func showError(_ errorMessage: String)
    
    func showMovies(with movies: [Movie])
    
    func searchMovies(with searchText: String)
    
    func searchActive(searchActive: Bool)
    
    func getGenres(with movie: Movie) -> String
}

protocol MovieTableInteractorProtocol: class {
    var presenter: MovieTablePresenterProtocol? { get set }
    
    // INTERACTOR -> PRESENTER
    func requestMoviesData()
    
    func searchMovies(with searchText: String)
    
    func searchActive(searchActive: Bool)
    
    func getGenres(with movie: Movie) -> String
}
