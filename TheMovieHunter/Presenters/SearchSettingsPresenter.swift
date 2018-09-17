//
//  SearchSettingsPresenter.swift
//  TheMovieHunter
//
//  Created by ws-013-11b on 8/23/18.
//  Copyright © 2018 ws-013-11b. All rights reserved.
//

import Foundation

class SearchSettingsPresenter: SearchSettingsPresenterProtocol {
    
    var interactor: SearchSettingsInteractorProtocol?
    
    init() {
        interactor = SearchSettingsInteractor()
    }
    
    func getGenresDict() -> [Int:Genre]? {
        guard let interactor = interactor
            else {
                return nil
        }
        return interactor.getGenresDict()
    }
}
