//
//  MovieSearchTableProtocols.swift
//  TheMovieHunter
//
//  Created by ws-016-11b on 17.09.2018.
//  Copyright © 2018 ws-013-11b. All rights reserved.
//

import UIKit

protocol MovieSearchTableViewProtocol: class {
    var presenter: MovieSearchTablePresenterProtocol? { get set }
    
    // PRESENTER -> VIEW
    func showLoading()
    
    func hideLoading()
    
    func showError(errorMessage: String)
    
    func showMovies(with movies: [Movie])
    
    func getTabBarController() throws -> UITabBarController
}

protocol  MovieSearchTablePresenterProtocol: class {
    var view: MovieSearchTableViewProtocol?  { get set }
    var interactor: MovieSearchTableInteractorProtocol?  { get set }
    
    // VIEW -> PRESENTER
    func viewDidLoad(view: MovieTableViewProtocol?)
    
    func showError(_ errorMessage: String)
    
    func showMovies(with movies: [Movie])
    
    func searchMovies(with searchText: String)
}

protocol MovieSearchTableInteractorProtocol: class {
    var presenter: MovieSearchTablePresenterProtocol? { get set }
    
    // INTERACTOR -> PRESENTER
    func searchMovies(with searchText: String)
}
