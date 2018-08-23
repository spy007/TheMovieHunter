//
//  SearchSettingsProtocols.swift
//  TheMovieHunter
//
//  Created by ws-013-11b on 8/23/18.
//  Copyright © 2018 ws-013-11b. All rights reserved.
//

import Foundation

protocol SearchSettingsViewProtocol {
    
}

protocol SearchSettingsPresenterProtocol {
    var interactor: SearchSettingsInteractorProtocol? { get set }
    
    func getGenresDict() -> [Int:Genre]?
}

protocol SearchSettingsInteractorProtocol {
    
    func getGenresDict() -> [Int:Genre]?
}
